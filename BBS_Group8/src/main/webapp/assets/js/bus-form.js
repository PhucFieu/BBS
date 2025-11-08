// Bus Form JavaScript
document.addEventListener("DOMContentLoaded", function () {
  // Auto-calculate total seats based on bus type
  const busTypeSelect = document.getElementById("busType");
  if (busTypeSelect) {
    busTypeSelect.addEventListener("change", function () {
      const busType = this.value;
      const totalSeatsInput = document.getElementById("totalSeats");
      if (totalSeatsInput) {
        switch (busType) {
          case "Bus 45 seats":
            totalSeatsInput.value = 45;
            break;
          case "Bus 35 seats":
            totalSeatsInput.value = 35;
            break;
          case "Bus 25 seats":
            totalSeatsInput.value = 25;
            break;
          case "Bus 16 seats":
            totalSeatsInput.value = 16;
            break;
          default:
            totalSeatsInput.value = "";
        }
      }
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
      const totalSeats = document.getElementById("totalSeats").value;
      const licensePlate = document.getElementById("licensePlate").value.trim();

      if (busNumber.length < 2) {
        e.preventDefault();
        alert("Số xe phải có ít nhất 2 ký tự");
        document.getElementById("busNumber").focus();
        return false;
      }

      if (!busType) {
        e.preventDefault();
        alert("Vui lòng chọn loại xe");
        document.getElementById("busType").focus();
        return false;
      }

      if (totalSeats < 1 || totalSeats > 100) {
        e.preventDefault();
        alert("Tổng số ghế phải từ 1 đến 100");
        document.getElementById("totalSeats").focus();
        return false;
      }

      const licensePlateRegex = /^[0-9]{2}[A-Z]-[0-9]{4,5}$/;
      if (!licensePlateRegex.test(licensePlate)) {
        e.preventDefault();
        alert("Biển số xe không hợp lệ. Định dạng: XX-XXXXX hoặc XX-XXXX");
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
