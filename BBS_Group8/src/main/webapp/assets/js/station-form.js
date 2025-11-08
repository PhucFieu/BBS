// Station Form JavaScript
document.addEventListener("DOMContentLoaded", function () {
  // Form validation
  const stationForm = document.getElementById("stationForm");
  if (stationForm) {
    stationForm.addEventListener("submit", function (e) {
      const stationName = document.getElementById("stationName").value.trim();
      const city = document.getElementById("city").value.trim();
      const address = document.getElementById("address").value.trim();

      if (stationName.length < 2) {
        e.preventDefault();
        alert("Tên trạm phải có ít nhất 2 ký tự");
        document.getElementById("stationName").focus();
        return false;
      }

      if (city.length < 2) {
        e.preventDefault();
        alert("Tên thành phố phải có ít nhất 2 ký tự");
        document.getElementById("city").focus();
        return false;
      }

      if (address.length < 5) {
        e.preventDefault();
        alert("Địa chỉ phải có ít nhất 5 ký tự");
        document.getElementById("address").focus();
        return false;
      }
    });
  }

  // Auto focus on first field
  const stationNameField = document.getElementById("stationName");
  if (stationNameField) {
    stationNameField.focus();
  }
});
