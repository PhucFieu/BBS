// Booking page JS: route -> schedules -> stations (if available) -> seats -> book
(function () {
  const $ = (sel) => document.querySelector(sel);
  const $$ = (sel) => document.querySelectorAll(sel);
  const contextPath = window.contextPath || "";
  const routeId = $("#routeId")?.value || "";

  const schedulesList = $("#schedulesList");
  const schedulesLoading = $("#schedulesLoading");
  const schedulesEmpty = $("#schedulesEmpty");
  const scheduleIdInput = $("#scheduleId");
  const seatSection = $("#seatSection");
  const seatGrid = $("#seatGrid");
  const seatInfo = $("#seatInfo");
  const seatNumberInput = $("#seatNumber");
  const stationSelectionSection = $("#stationSelectionSection");
  const boardingStationSelect = $("#boardingStation");
  const alightingStationSelect = $("#alightingStation");
  const boardingStationIdInput = $("#boardingStationId");
  const alightingStationIdInput = $("#alightingStationId");
  const submitBtn = $("#submitBtn");

  let selectedScheduleId = null;

  function setDisabled(el, disabled) {
    if (el) el.disabled = !!disabled;
  }

  function clear(element) {
    if (element) element.innerHTML = "";
  }

  function formatVNDate(iso) {
    try {
      const date = new Date(iso + "T00:00:00");
      return date.toLocaleDateString("vi-VN");
    } catch (_) {
      return iso;
    }
  }

  function formatTime(timeStr) {
    try {
      // Handle both "HH:mm" and "HH:mm:ss" formats
      return timeStr.substring(0, 5);
    } catch (_) {
      return timeStr;
    }
  }

  async function fetchJSON(url) {
    const res = await fetch(url, { credentials: "same-origin" });
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    const text = await res.text();
    try {
      return JSON.parse(text);
    } catch {
      return eval(text); // eslint-disable-line no-eval
    }
  }

  async function loadSchedules() {
    if (!routeId) return;

    schedulesLoading.style.display = "block";
    schedulesEmpty.style.display = "none";

    // Hide existing schedules
    $$(".schedule-card").forEach((card) => (card.style.display = "none"));

    try {
      const data = await fetchJSON(
        `${contextPath}/tickets/get-schedules-by-route?routeId=${encodeURIComponent(
          routeId
        )}`
      );

      if (data.error) {
        schedulesEmpty.textContent = data.error;
        schedulesEmpty.style.display = "block";
        return;
      }

      const schedules = data.schedules || [];

      if (schedules.length === 0) {
        schedulesEmpty.style.display = "block";
        return;
      }

      // Clear existing schedules or add new ones
      const existingCards = $$(".schedule-card");
      if (existingCards.length === 0) {
        // Create schedule cards
        schedules.forEach((schedule) => {
          const card = document.createElement("div");
          card.className = "schedule-card";
          card.dataset.scheduleId = schedule.scheduleId;
          card.innerHTML = `
            <div class="row align-items-center">
              <div class="col-md-3">
                <strong>${formatVNDate(schedule.departureDate)}</strong>
                <br>
                <small class="text-muted">Departure date</small>
              </div>
              <div class="col-md-2">
                <strong>${formatTime(schedule.departureTime)}</strong>
                <br>
                <small class="text-muted">Departure time</small>
              </div>
              <div class="col-md-2">
                <strong>${formatTime(schedule.estimatedArrivalTime)}</strong>
                <br>
                <small class="text-muted">Arrival time</small>
              </div>
              <div class="col-md-2">
                <strong>${schedule.availableSeats}</strong>
                <br>
                <small class="text-muted">Seats available</small>
              </div>
              <div class="col-md-2">
                <strong>${schedule.busNumber || "N/A"}</strong>
                <br>
                <small class="text-muted">Bus number</small>
              </div>
              <div class="col-md-1 text-end">
                ${
                  schedule.availableSeats > 0
                    ? '<i class="fas fa-check-circle text-success"></i>'
                    : '<span class="badge bg-danger">Full</span>'
                }
              </div>
            </div>
          `;

          if (schedule.availableSeats > 0) {
            card.addEventListener("click", () => selectSchedule(schedule));
          } else {
            card.style.cursor = "not-allowed";
            card.style.opacity = "0.6";
          }

          schedulesList.appendChild(card);
        });
      } else {
        // Show existing cards
        existingCards.forEach((card) => (card.style.display = "block"));
      }
    } catch (e) {
      console.error("Error loading schedules:", e);
      schedulesEmpty.textContent = "Error loading schedules";
      schedulesEmpty.style.display = "block";
    } finally {
      schedulesLoading.style.display = "none";
    }
  }

  async function selectSchedule(schedule) {
    selectedScheduleId = schedule.scheduleId;
    scheduleIdInput.value = schedule.scheduleId;

    // Update UI: highlight selected schedule
    $$(".schedule-card").forEach((card) => {
      card.classList.remove("selected");
      if (card.dataset.scheduleId === schedule.scheduleId) {
        card.classList.add("selected");
      }
    });

    // Load stations for this schedule
    await loadScheduleStations(schedule.scheduleId);

    // Load seats for this schedule
    await loadSeats(schedule.scheduleId);
  }

  async function loadScheduleStations(scheduleId) {
    try {
      const data = await fetchJSON(
        `${contextPath}/tickets/get-schedule-stations?scheduleId=${encodeURIComponent(
          scheduleId
        )}`
      );

      const stations = data.stations || [];

      if (stations.length === 0) {
        // No stations, hide station selection
        stationSelectionSection.style.display = "none";
        boardingStationIdInput.value = "";
        alightingStationIdInput.value = "";
        return;
      }

      // Show station selection
      stationSelectionSection.style.display = "block";

      // Populate boarding station select
      clear(boardingStationSelect);
      const boardingOption = document.createElement("option");
      boardingOption.value = "";
      boardingOption.textContent = "-- Chọn điểm lên xe (tùy chọn) --";
      boardingStationSelect.appendChild(boardingOption);

      // Populate alighting station select
      clear(alightingStationSelect);
      const alightingOption = document.createElement("option");
      alightingOption.value = "";
      alightingOption.textContent = "-- Chọn điểm xuống xe (tùy chọn) --";
      alightingStationSelect.appendChild(alightingOption);

      stations.forEach((station, index) => {
        const option1 = document.createElement("option");
        option1.value = station.stationId;
        option1.textContent = `${station.stationName} ${
          station.city ? "(" + station.city + ")" : ""
        }`;
        boardingStationSelect.appendChild(option1);

        const option2 = document.createElement("option");
        option2.value = station.stationId;
        option2.textContent = `${station.stationName} ${
          station.city ? "(" + station.city + ")" : ""
        }`;
        alightingStationSelect.appendChild(option2);
      });

      // Update hidden inputs when selects change
      boardingStationSelect.addEventListener("change", (e) => {
        boardingStationIdInput.value = e.target.value;
        updateSubmitButton();
      });

      alightingStationSelect.addEventListener("change", (e) => {
        alightingStationIdInput.value = e.target.value;
        updateSubmitButton();
      });
    } catch (e) {
      console.error("Error loading schedule stations:", e);
      stationSelectionSection.style.display = "none";
    }
  }

  async function loadSeats(scheduleId) {
    seatSection.style.display = "block";
    clear(seatGrid);
    seatInfo.style.display = "none";
    submitBtn.disabled = true;
    seatNumberInput.value = "";

    try {
      const data = await fetchJSON(
        `${contextPath}/tickets/schedule-seats?scheduleId=${encodeURIComponent(
          scheduleId
        )}`
      );

      if (data.error) {
        seatGrid.innerHTML = `<div class="alert alert-warning">${data.error}</div>`;
        return;
      }

      const totalSeats = Number(data.totalSeats) || 0;
      const bookedSeats = new Set(data.bookedSeats || []);
      const availableSeats = new Set(data.availableSeats || []);

      if (totalSeats === 0) {
        seatGrid.innerHTML =
          '<div class="alert alert-warning">No seat information</div>';
        return;
      }

      for (let i = 1; i <= totalSeats; i++) {
        const div = document.createElement("div");
        div.className = "seat";
        div.textContent = String(i);

        if (bookedSeats.has(i)) {
          div.classList.add("occupied");
        } else if (availableSeats.has(i)) {
          div.classList.add("available");
          div.addEventListener("click", function () {
            $$(".seat.selected").forEach((s) => s.classList.remove("selected"));
            this.classList.add("selected");
            seatNumberInput.value = String(i);
            seatInfo.textContent = `Selected seat: ${i}`;
            seatInfo.style.display = "block";
            updateSubmitButton();
          });
        }

        seatGrid.appendChild(div);
      }

      const info = document.createElement("div");
      info.className = "mt-2 text-muted";
      info.textContent = `Total seats: ${totalSeats} | Available: ${availableSeats.size} | Booked: ${bookedSeats.size}`;
      seatGrid.appendChild(info);
    } catch (e) {
      console.error("Error loading seats:", e);
      seatGrid.innerHTML =
        '<div class="alert alert-danger">Error loading seats</div>';
    }
  }

  function updateSubmitButton() {
    const hasSchedule = !!scheduleIdInput.value;
    const hasSeat = !!seatNumberInput.value;
    submitBtn.disabled = !(hasSchedule && hasSeat);
  }

  // Load schedules on page load if routeId exists
  if (routeId) {
    // Check if schedules are already rendered on page
    const existingSchedules = $$(".schedule-card");
    if (existingSchedules.length === 0) {
      loadSchedules();
    } else {
      // Attach click handlers to existing schedules
      existingSchedules.forEach((card) => {
        if (!card.classList.contains("disabled")) {
          const scheduleId = card.dataset.scheduleId;
          card.addEventListener("click", async () => {
            const scheduleData = await fetchJSON(
              `${contextPath}/tickets/get-schedules-by-route?routeId=${encodeURIComponent(
                routeId
              )}`
            );
            const schedules = scheduleData.schedules || [];
            const schedule = schedules.find((s) => s.scheduleId === scheduleId);
            if (schedule && schedule.availableSeats > 0) {
              await selectSchedule(schedule);
            }
          });
        }
      });
    }
  }

  // Prevent submit if missing required fields
  document.getElementById("bookingForm")?.addEventListener("submit", (e) => {
    if (!scheduleIdInput.value || !seatNumberInput.value) {
      e.preventDefault();
      alert("Please select a schedule and a seat");
    }
  });
})();
