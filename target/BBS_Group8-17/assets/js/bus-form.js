// Bus Form JavaScript
document.addEventListener("DOMContentLoaded", function () {
  const seatMapping = {
    "Bus 45 seats": 45,
    "Bus 35 seats": 35,
    "Bus 25 seats": 25,
    "Bus 16 seats": 16,
  };

  // Auto-display total seats based on bus type
  const busTypeSelect = document.getElementById("busType");
  const totalSeatsDisplay = document.getElementById("totalSeatsDisplay");

  const updateTotalSeatsDisplay = (busType) => {
    if (!totalSeatsDisplay) return;
    totalSeatsDisplay.value = seatMapping[busType] || "";
  };

  if (busTypeSelect) {
    updateTotalSeatsDisplay(busTypeSelect.value);
    busTypeSelect.addEventListener("change", function () {
      updateTotalSeatsDisplay(this.value);
    });
  }

  // License plate validation
  const licensePlateInput = document.getElementById("licensePlate");
  if (licensePlateInput) {
    licensePlateInput.addEventListener("input", function () {
      this.value = this.value.toUpperCase();
    });
  }

  // Form validation
  const busForm = document.getElementById("busForm");
  if (busForm) {
    busForm.addEventListener("submit", function (e) {
      const busNumber = document.getElementById("busNumber").value.trim();
      const busType = document.getElementById("busType").value;
      const licensePlate = document.getElementById("licensePlate").value.trim();

      if (busNumber.length < 2) {
        e.preventDefault();
        alert("Bus number must be at least 2 characters");
        document.getElementById("busNumber").focus();
        return false;
      }

      if (!busType) {
        e.preventDefault();
        alert("Please select a bus type");
        document.getElementById("busType").focus();
        return false;
      }

      const licensePlateRegex = /^[0-9]{2}[A-Z]-[0-9]{4,5}$/;
      if (!licensePlateRegex.test(licensePlate)) {
        e.preventDefault();
        alert("Invalid license plate. Format: XX-XXXXX or XX-XXXX");
        document.getElementById("licensePlate").focus();
        return false;
      }
    });
  }

  // Auto focus on first field
  const busNumberField = document.getElementById("busNumber");
  if (busNumberField) {
    busNumberField.focus();
  }
});
