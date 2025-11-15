// ===== GLOBAL VARIABLES =====
let selectedSeats = [];
let currentRouteId = null;

// ===== UTILITY FUNCTIONS =====
function showNotification(message, type = "info") {
  const alertDiv = document.createElement("div");
  alertDiv.className = `alert alert-${type} alert-dismissible fade show position-fixed`;
  alertDiv.style.cssText =
    "top: 20px; right: 20px; z-index: 9999; min-width: 300px;";
  alertDiv.innerHTML = `
        <i class="fas fa-${
          type === "success"
            ? "check-circle"
            : type === "danger"
            ? "exclamation-circle"
            : "info-circle"
        } me-2"></i>
        ${message}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    `;

  document.body.appendChild(alertDiv);

  // Auto remove after 5 seconds
  setTimeout(() => {
    if (alertDiv.parentNode) {
      alertDiv.remove();
    }
  }, 5000);
}

function formatCurrency(amount) {
  return new Intl.NumberFormat("vi-VN", {
    style: "currency",
    currency: "VND",
  }).format(amount);
}

function formatDate(dateString) {
  const date = new Date(dateString);
  return date.toLocaleDateString("vi-VN", {
    year: "numeric",
    month: "long",
    day: "numeric",
  });
}

function formatDateTime(dateString) {
  const date = new Date(dateString);
  return date.toLocaleString("vi-VN", {
    year: "numeric",
    month: "long",
    day: "numeric",
    hour: "2-digit",
    minute: "2-digit",
  });
}

// ===== FORM VALIDATION =====
function validateForm(formId) {
  const form = document.getElementById(formId);
  if (!form) return true;

  const inputs = form.querySelectorAll(
    "input[required], select[required], textarea[required]"
  );
  let isValid = true;

  inputs.forEach((input) => {
    if (!input.value.trim()) {
      input.classList.add("is-invalid");
      isValid = false;
    } else {
      input.classList.remove("is-invalid");
    }
  });

  return isValid;
}

function addFormValidation() {
  const forms = document.querySelectorAll("form");
  forms.forEach((form) => {
    form.addEventListener("submit", function (e) {
      if (!validateForm(this.id)) {
        e.preventDefault();
        showNotification("Please fill in all required information", "danger");
      }
    });
  });
}

// ===== PASSWORD TOGGLE =====
function initPasswordToggle() {
  const toggleButtons = document.querySelectorAll('[id*="togglePassword"]');
  toggleButtons.forEach((button) => {
    button.addEventListener("click", function () {
      const input = this.previousElementSibling;
      const icon = this.querySelector("i");

      if (input.type === "password") {
        input.type = "text";
        icon.classList.remove("fa-eye");
        icon.classList.add("fa-eye-slash");
      } else {
        input.type = "password";
        icon.classList.remove("fa-eye-slash");
        icon.classList.add("fa-eye");
      }
    });
  });
}

// ===== SEAT SELECTION =====
function initSeatSelection() {
  const seatOptions = document.querySelectorAll(".seat-option");
  seatOptions.forEach((seat) => {
    seat.addEventListener("click", function () {
      if (this.classList.contains("booked")) {
        return;
      }

      const seatNumber = this.textContent;
      if (this.classList.contains("selected")) {
        this.classList.remove("selected");
        selectedSeats = selectedSeats.filter((s) => s !== seatNumber);
      } else {
        this.classList.add("selected");
        selectedSeats.push(seatNumber);
      }

      updateSeatSelection();
    });
  });
}

function updateSeatSelection() {
  const seatInput = document.getElementById("selectedSeats");
  if (seatInput) {
    seatInput.value = selectedSeats.join(",");
  }

  const seatDisplay = document.getElementById("seatDisplay");
  if (seatDisplay) {
    seatDisplay.textContent =
      selectedSeats.length > 0 ? selectedSeats.join(", ") : "No seat selected";
  }
}

// ===== MODAL FUNCTIONS =====
function initModals() {
  const modals = document.querySelectorAll(".modal");
  modals.forEach((modal) => {
    modal.addEventListener("show.bs.modal", function () {
      this.classList.add("fade-in-up");
    });

    modal.addEventListener("hidden.bs.modal", function () {
      this.classList.remove("fade-in-up");
    });
  });
}

// ===== TABLE ENHANCEMENTS =====
function initTableEnhancements() {
  const tables = document.querySelectorAll(".table");
  tables.forEach((table) => {
    // Add hover effects
    const rows = table.querySelectorAll("tbody tr");
    rows.forEach((row) => {
      row.addEventListener("mouseenter", function () {
        this.style.transform = "scale(1.01)";
      });

      row.addEventListener("mouseleave", function () {
        this.style.transform = "scale(1)";
      });
    });

    // Add search functionality if search input exists
    const searchInput = table.parentElement.querySelector(".table-search");
    if (searchInput) {
      searchInput.addEventListener("input", function () {
        const searchTerm = this.value.toLowerCase();
        rows.forEach((row) => {
          const text = row.textContent.toLowerCase();
          row.style.display = text.includes(searchTerm) ? "" : "none";
        });
      });
    }
  });
}

// ===== CARD ANIMATIONS =====
function initCardAnimations() {
  const cards = document.querySelectorAll(".card");
  const observer = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          entry.target.classList.add("fade-in-up");
        }
      });
    },
    { threshold: 0.1 }
  );

  cards.forEach((card) => {
    observer.observe(card);
  });
}

// ===== LOADING STATES =====
function showLoading(element) {
  if (element) {
    element.disabled = true;
    const originalText = element.innerHTML;
    element.innerHTML =
      '<span class="spinner-border spinner-border-sm me-2"></span>Processing...';
    element.dataset.originalText = originalText;
  }
}

function hideLoading(element) {
  if (element && element.dataset.originalText) {
    element.disabled = false;
    element.innerHTML = element.dataset.originalText;
    delete element.dataset.originalText;
  }
}

// ===== AJAX HELPERS =====
function makeRequest(url, method = "GET", data = null) {
  const options = {
    method: method,
    headers: {
      "Content-Type": "application/json",
    },
  };

  if (data && method !== "GET") {
    options.body = JSON.stringify(data);
  }

  return fetch(url, options)
    .then((response) => {
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      return response.json();
    })
    .catch((error) => {
      console.error("Request failed:", error);
      showNotification("Error occurred while loading data", "danger");
      throw error;
    });
}

// ===== TICKET BOOKING FUNCTIONS =====
function initTicketBooking() {
  const bookButtons = document.querySelectorAll(
    '[data-bs-target="#bookTicketModal"]'
  );
  bookButtons.forEach((button) => {
    button.addEventListener("click", function () {
      const routeId = this.getAttribute("data-routeid");
      currentRouteId = routeId;
      document.getElementById("modalRouteId").value = routeId;
      loadAvailableDates();
    });
  });
}

function loadAvailableDates() {
  if (!currentRouteId) return;

  showLoading(document.querySelector("#bookTicketModal .btn-primary"));

  makeRequest(
    `${window.location.origin}${window.location.pathname}/tickets/available-dates?routeId=${currentRouteId}`
  )
    .then((dates) => {
      const dateSelect = document.getElementById("modalDate");
      dateSelect.innerHTML = '<option value="">Select date</option>';

      dates.forEach((date) => {
        const option = document.createElement("option");
        option.value = date;
        option.textContent = formatDate(date);
        dateSelect.appendChild(option);
      });

      hideLoading(document.querySelector("#bookTicketModal .btn-primary"));
    })
    .catch(() => {
      hideLoading(document.querySelector("#bookTicketModal .btn-primary"));
    });
}

function loadAvailableTimes() {
  const date = document.getElementById("modalDate").value;
  if (!date || !currentRouteId) return;

  makeRequest(
    `${window.location.origin}${window.location.pathname}/tickets/available-times?routeId=${currentRouteId}&date=${date}`
  ).then((times) => {
    const timeSelect = document.getElementById("modalTime");
    timeSelect.innerHTML = '<option value="">Select time</option>';

    times.forEach((time) => {
      const option = document.createElement("option");
      option.value = time;
      option.textContent = time;
      timeSelect.appendChild(option);
    });
  });
}

function loadAvailableSeats() {
  const date = document.getElementById("modalDate").value;
  const time = document.getElementById("modalTime").value;
  if (!date || !time || !currentRouteId) return;

  makeRequest(
    `${window.location.origin}${window.location.pathname}/tickets/available-seats?routeId=${currentRouteId}&date=${date}&time=${time}`
  ).then((seats) => {
    const seatContainer = document.getElementById("seatOptions");
    seatContainer.innerHTML = "";
    selectedSeats = [];

    seats.forEach((seat) => {
      const seatElement = document.createElement("div");
      seatElement.className = `seat-option ${seat.booked ? "booked" : ""}`;
      seatElement.textContent = seat.seatNumber;
      seatElement.setAttribute("data-seat", seat.seatNumber);

      if (!seat.booked) {
        seatElement.addEventListener("click", function () {
          this.classList.toggle("selected");
          updateSeatSelection();
        });
      }

      seatContainer.appendChild(seatElement);
    });
  });
}

// ===== SEARCH AND FILTER =====
function initSearchAndFilter() {
  const searchInputs = document.querySelectorAll(".search-input");
  searchInputs.forEach((input) => {
    input.addEventListener("input", function () {
      const searchTerm = this.value.toLowerCase();
      const targetTable = this.getAttribute("data-target");
      const table = document.querySelector(targetTable);

      if (table) {
        const rows = table.querySelectorAll("tbody tr");
        rows.forEach((row) => {
          const text = row.textContent.toLowerCase();
          row.style.display = text.includes(searchTerm) ? "" : "none";
        });
      }
    });
  });
}

// ===== SORTING =====
function initTableSorting() {
  const sortableHeaders = document.querySelectorAll(".sortable");
  sortableHeaders.forEach((header) => {
    header.addEventListener("click", function () {
      const table = this.closest("table");
      const tbody = table.querySelector("tbody");
      const rows = Array.from(tbody.querySelectorAll("tr"));
      const columnIndex = Array.from(this.parentElement.children).indexOf(this);
      const isAscending = this.classList.contains("asc");

      // Remove sorting classes from all headers
      sortableHeaders.forEach((h) => h.classList.remove("asc", "desc"));

      // Add sorting class to current header
      this.classList.add(isAscending ? "desc" : "asc");

      // Sort rows
      rows.sort((a, b) => {
        const aValue = a.children[columnIndex].textContent.trim();
        const bValue = b.children[columnIndex].textContent.trim();

        if (isAscending) {
          return bValue.localeCompare(aValue, "vi");
        } else {
          return aValue.localeCompare(bValue, "vi");
        }
      });

      // Reorder rows
      rows.forEach((row) => tbody.appendChild(row));
    });
  });
}

// ===== PAGINATION =====
function initPagination() {
  const paginationLinks = document.querySelectorAll(".pagination .page-link");
  paginationLinks.forEach((link) => {
    link.addEventListener("click", function (e) {
      e.preventDefault();
      const page = this.getAttribute("data-page");
      const currentUrl = new URL(window.location);
      currentUrl.searchParams.set("page", page);
      window.location.href = currentUrl.toString();
    });
  });
}

// ===== CONFIRMATION DIALOGS =====
function confirmAction(message, callback) {
  if (confirm(message)) {
    callback();
  }
}

function initDeleteConfirmations() {
  const deleteButtons = document.querySelectorAll(".btn-delete");
  deleteButtons.forEach((button) => {
    button.addEventListener("click", function (e) {
      e.preventDefault();
      const message =
        this.getAttribute("data-confirm") || "Are you sure you want to delete?";
      confirmAction(message, () => {
        const form = this.closest("form");
        if (form) {
          form.submit();
        } else {
          window.location.href = this.href;
        }
      });
    });
  });
}

// ===== AUTO-COMPLETE =====
function initAutoComplete() {
  const autoCompleteInputs = document.querySelectorAll(".autocomplete");
  autoCompleteInputs.forEach((input) => {
    input.addEventListener("input", function () {
      const searchTerm = this.value.trim();
      if (searchTerm.length < 2) return;

      const dataSource = this.getAttribute("data-source");
      if (!dataSource) return;

      // This would typically make an AJAX call to get suggestions
      // For now, we'll just show a placeholder
      console.log(`Searching for: ${searchTerm} in ${dataSource}`);
    });
  });
}

// ===== INITIALIZATION =====
document.addEventListener("DOMContentLoaded", function () {
  // Initialize all components
  addFormValidation();
  initPasswordToggle();
  initSeatSelection();
  initModals();
  initTableEnhancements();
  initCardAnimations();
  initTicketBooking();
  initSearchAndFilter();
  initTableSorting();
  initPagination();
  initDeleteConfirmations();
  initAutoComplete();

  // Add event listeners for dynamic content
  document.addEventListener("click", function (e) {
    // Handle dynamic button clicks
    if (e.target.matches(".btn-delete")) {
      e.preventDefault();
      const message =
        e.target.getAttribute("data-confirm") ||
        "Are you sure you want to delete?";
      confirmAction(message, () => {
        const form = e.target.closest("form");
        if (form) {
          form.submit();
        } else {
          window.location.href = e.target.href;
        }
      });
    }
  });

  // Enhanced delete functionality for admin buses
  const confirmDeleteBtn = document.getElementById("confirmDeleteBtn");
  if (confirmDeleteBtn) {
    confirmDeleteBtn.addEventListener("click", function (e) {
      e.preventDefault();
      try {
        console.log("[DELETE] Delete button clicked");

        // Check if this is a bus delete action
        if (this.closest("#deleteModal")) {
          console.log("[DELETE] Delete modal detected");
          // If a delete URL is set, navigate to it (works for stations, drivers, buses, etc.)
          if (this.href) {
            console.log("[DELETE] Navigating to:", this.href);
            window.location.href = this.href;
            return;
          }
          // If no href is present, fall through to avoid blocking default behavior
        }

        // For other delete actions, proceed with original logic
        if (this.href) {
          console.log("[DELETE] Navigating to:", this.href);
          window.location.href = this.href;
        }
      } catch (err) {
        console.error("[DELETE] Error during delete action:", err);
        showNotification(
          "An error occurred while processing the delete request",
          "danger"
        );
      }
    });
  }

  // Global error logging to help diagnose issues during delete flows
  window.addEventListener("error", function (event) {
    try {
      console.error(
        "[GLOBAL ERROR]",
        event.message,
        { file: event.filename, line: event.lineno, column: event.colno },
        event.error || null
      );
    } catch (_) {}
  });

  window.addEventListener("unhandledrejection", function (event) {
    try {
      console.error("[UNHANDLED REJECTION]", event.reason);
    } catch (_) {}
  });

  // Smooth scrolling (event delegation so href is checked at click-time)
  document.addEventListener("click", function (e) {
    const link = e.target.closest("a");
    if (!link) return;

    const href = link.getAttribute("href");
    if (!href || !href.startsWith("#")) return;
    if (href === "#") return;

    if (
      link.classList.contains("delete-action") ||
      link.classList.contains("admin-action") ||
      href.includes("/admin/") ||
      href.includes("/delete") ||
      link.closest("#deleteModal")
    )
      return;

    e.preventDefault();
    try {
      const target = document.querySelector(href);
      if (target) {
        target.scrollIntoView({ behavior: "smooth", block: "start" });
      }
    } catch (_) {
      // Ignore invalid selectors
    }
  });

  // Add fade-in animation to page load
  document.body.classList.add("fade-in-up");

  console.log("Bus Booking System JavaScript initialized successfully!");
});

// ===== EXPORT FUNCTIONS FOR GLOBAL USE =====
window.BusBookingSystem = {
  showNotification,
  formatCurrency,
  formatDate,
  formatDateTime,
  validateForm,
  showLoading,
  hideLoading,
  makeRequest,
  confirmAction,
};
