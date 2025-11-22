// New Ticket Form JavaScript - Complete Rewrite
document.addEventListener("DOMContentLoaded", function () {
  console.log("Ticket form initialized");

  // Initialize all form functionality
  initializeForm();
  initializeFormValidation();
  initializePriceCalculation();
  initializeSeatSelection();
});

// Get application context path from <base href> or fallback to ''
function getContextPath() {
  const baseTag = document.querySelector("base");
  if (baseTag && baseTag.getAttribute("href")) {
    try {
      const baseUrl = new URL(
        baseTag.getAttribute("href"),
        window.location.href
      );
      return baseUrl.pathname.replace(/\/$/, "");
    } catch (e) {
      // ignore and fallback below
    }
  }
  // Fallback: try to detect context path from location (first path segment)
  const parts = window.location.pathname.split("/").filter(Boolean);
  return parts.length > 0 ? "/" + parts[0] : "";
}

// Main form initialization
function initializeForm() {
  const routeSelect = document.getElementById("routeId");
  const busSelect = document.getElementById("busId");
  const departureDateInput = document.getElementById("departureDate");

  // Set minimum date to today
  if (departureDateInput) {
    const today = new Date().toISOString().split("T")[0];
    departureDateInput.min = today;
  }

  // Route selection handler
  if (routeSelect) {
    routeSelect.addEventListener("change", function () {
      const selectedOption = this.options[this.selectedIndex];
      const price = selectedOption.dataset.price;

      if (price) {
        updateTicketPrice(price);
      }

      // Load available schedules when route and bus are selected
      if (busSelect && busSelect.value) {
        loadAvailableSchedules();
      }
    });
  }

  // Bus selection handler
  if (busSelect) {
    busSelect.addEventListener("change", function () {
      const selectedOption = this.options[this.selectedIndex];
      const totalSeats = selectedOption.dataset.seats;

      if (totalSeats) {
        updateSeatInputMax(totalSeats);
      }

      // Load available schedules when route and bus are selected
      if (routeSelect && routeSelect.value) {
        loadAvailableSchedules();
      }
    });
  }

  // Date selection handler
  if (departureDateInput) {
    departureDateInput.addEventListener("change", function () {
      if (
        this.value &&
        routeSelect &&
        routeSelect.value &&
        busSelect &&
        busSelect.value
      ) {
        loadAvailableSchedules();
      }
    });
  }

  // Schedule selection handler - update hidden departureTime field
  const scheduleSelect = document.getElementById("scheduleId");
  if (scheduleSelect) {
    scheduleSelect.addEventListener("change", function () {
      const selectedOption = this.options[this.selectedIndex];
      const departureTime = selectedOption.dataset.departureTime;
      const departureTimeInput = document.getElementById("departureTime");
      if (departureTimeInput && departureTime) {
        departureTimeInput.value = departureTime;
      }
    });
  }
}

// Passenger selection is now handled by simple dropdown - no complex search needed

// Form validation
function initializeFormValidation() {
  const form = document.getElementById("ticketForm");
  if (!form) return;

  form.addEventListener("submit", function (e) {
    e.preventDefault();

    if (validateForm()) {
      // Show loading state
      const submitBtn = form.querySelector('button[type="submit"]');
      const originalText = submitBtn.innerHTML;
      submitBtn.innerHTML =
        '<i class="fas fa-spinner fa-spin me-2"></i>Creating ticket...';
      submitBtn.disabled = true;

      // Submit form
      setTimeout(() => {
        form.submit();
      }, 500);
    }
  });

  // Real-time validation
  const requiredFields = form.querySelectorAll("[required]");
  requiredFields.forEach((field) => {
    field.addEventListener("blur", function () {
      validateField(this);
    });

    field.addEventListener("input", function () {
      if (this.classList.contains("is-invalid")) {
        validateField(this);
      }
    });
  });
}

function validateForm() {
  const form = document.getElementById("ticketForm");
  const requiredFields = form.querySelectorAll("[required]");
  let isValid = true;

  requiredFields.forEach((field) => {
    if (!validateField(field)) {
      isValid = false;
    }
  });

  // Custom validation for seat number
  const seatNumberInput = document.getElementById("seatNumber");
  const busSelect = document.getElementById("busId");

  if (seatNumberInput && busSelect) {
    const selectedBus = busSelect.options[busSelect.selectedIndex];
    const maxSeats = selectedBus.dataset.seats;

    if (maxSeats && seatNumberInput.value) {
      const seatNumber = parseInt(seatNumberInput.value);
      const maxSeatNumber = parseInt(maxSeats);

      if (seatNumber < 1 || seatNumber > maxSeatNumber) {
        seatNumberInput.classList.add("is-invalid");
        seatNumberInput.classList.remove("is-valid");
        isValid = false;
      }
    }
  }

  return isValid;
}

function validateField(field) {
  const value = field.value.trim();
  const isRequired = field.hasAttribute("required");

  // Clear previous validation classes
  field.classList.remove("is-valid", "is-invalid");

  if (isRequired && !value) {
    field.classList.add("is-invalid");
    return false;
  }

  // Specific validations
  if (field.type === "email" && value) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(value)) {
      field.classList.add("is-invalid");
      return false;
    }
  }

  if (field.type === "number" && value) {
    const num = parseFloat(value);
    if (isNaN(num) || num < 0) {
      field.classList.add("is-invalid");
      return false;
    }
  }

  // For select elements, check if a valid option is selected
  if (field.tagName === "SELECT" && value) {
    const selectedOption = field.options[field.selectedIndex];
    if (selectedOption && selectedOption.value !== "") {
      field.classList.add("is-valid");
      return true;
    }
  }

  if (value) {
    field.classList.add("is-valid");
  }

  return true;
}

// Price calculation
function initializePriceCalculation() {
  const ticketPriceInput = document.getElementById("ticketPrice");
  const totalPriceElement = document.getElementById("totalPrice");

  if (ticketPriceInput && totalPriceElement) {
    ticketPriceInput.addEventListener("input", function () {
      updateTotalPrice();
    });
  }
}

function updateTicketPrice(price) {
  const ticketPriceInput = document.getElementById("ticketPrice");
  if (ticketPriceInput) {
    ticketPriceInput.value = price;
    updateTotalPrice();
  }
}

function updateTotalPrice() {
  const ticketPriceInput = document.getElementById("ticketPrice");
  const totalPriceElement = document.getElementById("totalPrice");

  if (ticketPriceInput && totalPriceElement) {
    const price = parseFloat(ticketPriceInput.value) || 0;
    // Use proper Vietnamese dong symbol (₫) with UTF-8 encoding
    const formattedPrice = new Intl.NumberFormat("vi-VN", {
      style: "currency",
      currency: "VND",
      minimumFractionDigits: 0,
      maximumFractionDigits: 0
    }).format(price);
    totalPriceElement.textContent = formattedPrice;
  }
}

// Seat selection
function initializeSeatSelection() {
  // This will be called when viewing available seats
}

function updateSeatInputMax(maxSeats) {
  const seatNumberInput = document.getElementById("seatNumber");
  if (seatNumberInput) {
    seatNumberInput.max = maxSeats;
    seatNumberInput.placeholder = `Enter a seat number from 1 to ${maxSeats}`;
  }
}

// Load available schedules
function loadAvailableSchedules() {
  const routeSelect = document.getElementById("routeId");
  const busSelect = document.getElementById("busId");
  const departureDateInput = document.getElementById("departureDate");

  if (!routeSelect || !busSelect || !departureDateInput) return;

  const routeId = routeSelect.value;
  const busId = busSelect.value;
  const date = departureDateInput.value;

  if (!routeId || !busId || !date) return;

  const url = `${getContextPath()}/tickets/available-schedules?routeId=${routeId}&busId=${busId}&date=${date}`;

  console.log("Loading available schedules:", url);

  fetch(url)
    .then((response) => {
      if (!response.ok) {
        throw new Error(`HTTP ${response.status}: ${response.statusText}`);
      }
      return response.json();
    })
    .then((data) => {
      populateTimeSelect(data.schedules || []);
    })
    .catch((error) => {
      console.error("Error loading schedules:", error);
      populateTimeSelect([]);
    });
}

function loadAvailableTimes() {
  // Legacy function - redirects to loadAvailableSchedules
  loadAvailableSchedules();
}

function populateTimeSelect(schedules) {
  // Legacy function - now populates schedule select instead
  populateScheduleSelect(schedules);
}

function populateScheduleSelect(schedules) {
  const scheduleSelect = document.getElementById("scheduleId");
  if (!scheduleSelect) return;

  // Clear existing options
  scheduleSelect.innerHTML = '<option value="">-- Select schedule --</option>';

  if (schedules.length === 0) {
    const option = document.createElement("option");
    option.value = "";
    option.textContent = "No available schedules";
    option.disabled = true;
    scheduleSelect.appendChild(option);
    return;
  }

  // Populate with schedules
  schedules.forEach((schedule) => {
    const option = document.createElement("option");
    option.value = schedule.scheduleId;
    option.dataset.departureTime = schedule.departureTime;

    // Format display: "HH:mm - Bus XXX - Seats available: Y"
    let displayText = schedule.departureTime;
    if (schedule.busNumber) {
      displayText += " - Bus: " + schedule.busNumber;
    }
    if (schedule.availableSeats !== undefined) {
      displayText += " - Seats available: " + schedule.availableSeats;
    }

    option.textContent = displayText;
    scheduleSelect.appendChild(option);
  });
}

// View available seats
function viewAvailableSeats() {
  const routeSelect = document.getElementById("routeId");
  const busSelect = document.getElementById("busId");
  const departureDateInput = document.getElementById("departureDate");
  const scheduleSelect = document.getElementById("scheduleId");

  if (!routeSelect || !busSelect || !departureDateInput || !scheduleSelect) {
    alert(
      "Please select route, bus, date, and schedule"
    );
    return;
  }

  const routeId = routeSelect.value;
  const busId = busSelect.value;
  const date = departureDateInput.value;
  const scheduleId = scheduleSelect.value;

  if (!routeId || !busId || !date || !scheduleId) {
    alert(
      "Please select route, bus, date, and schedule"
    );
    return;
  }

  // Use scheduleId if available, otherwise fall back to route/bus/date/time
  let url;
  const selectedOption = scheduleSelect.options[scheduleSelect.selectedIndex];
  const departureTime = selectedOption.dataset.departureTime;

  if (departureTime) {
    // Fallback to time-based endpoint for backward compatibility
    url = `${getContextPath()}/tickets/available-seats?routeId=${routeId}&busId=${busId}&date=${date}&time=${departureTime}`;
  } else {
    // Use schedule-based endpoint if available
    url = `${getContextPath()}/tickets/schedule-seats?scheduleId=${scheduleId}`;
  }

  console.log("Loading available seats:", url);

  // Show loading state
  const viewSeatsBtn = document.getElementById("viewSeatsBtn");
  const originalText = viewSeatsBtn.innerHTML;
  viewSeatsBtn.innerHTML =
    '<i class="fas fa-spinner fa-spin me-1"></i>Loading...';
  viewSeatsBtn.disabled = true;

  fetch(url)
    .then((response) => {
      if (!response.ok) {
        throw new Error(`HTTP ${response.status}: ${response.statusText}`);
      }
      return response.json();
    })
    .then((data) => {
      if (data.error) {
        alert("Error: " + data.error);
        return;
      }

      displaySeatMap(data);
    })
    .catch((error) => {
      console.error("Error loading seats:", error);
      alert("Error loading seat list: " + error.message);
    })
    .finally(() => {
      // Restore button state
      viewSeatsBtn.innerHTML = originalText;
      viewSeatsBtn.disabled = false;
    });
}

function displaySeatMap(data) {
  const seatMap = document.getElementById("seatMap");
  const seatGrid = document.getElementById("seatGrid");

  if (!seatMap || !seatGrid) return;

  seatGrid.innerHTML = "";

  if (!data.totalSeats) {
    seatGrid.innerHTML =
      '<div class="col-12 text-center text-muted">No seat information</div>';
    seatMap.style.display = "block";
    return;
  }

  // Render as bus layout: 4 columns (like actual bus seat arrangement)
  for (let i = 1; i <= data.totalSeats; i++) {
    const seatElement = document.createElement("div");
    seatElement.className = "seat";
    seatElement.textContent = i;
    seatElement.dataset.seatNumber = i;

    if (data.bookedSeats && data.bookedSeats.includes(i)) {
      seatElement.classList.add("occupied");
      seatElement.title = "Seat already booked";
    } else {
      seatElement.classList.add("available");
      seatElement.title = "Available - Click to select";
      seatElement.addEventListener("click", function () {
        selectSeat(this);
      });
    }

    seatGrid.appendChild(seatElement);
  }

  seatMap.style.display = "block";
  seatMap.classList.add("fade-in");
}

function selectSeat(seatElement) {
  // Remove previous selection
  document.querySelectorAll(".seat.selected").forEach((seat) => {
    seat.classList.remove("selected");
  });

  // Select current seat
  seatElement.classList.add("selected");

  // Update seat number input
  const seatNumberInput = document.getElementById("seatNumber");
  if (seatNumberInput) {
    seatNumberInput.value = seatElement.dataset.seatNumber;
    validateField(seatNumberInput);
  }
}

// Utility functions

// Initialize price display on page load
document.addEventListener("DOMContentLoaded", function () {
  updateTotalPrice();
});

// Expose functions used by inline HTML handlers to global scope
if (typeof window !== "undefined") {
  window.viewAvailableSeats = viewAvailableSeats;
}
