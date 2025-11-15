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
        alert("Station name must be at least 2 characters");
        document.getElementById("stationName").focus();
        return false;
      }

      if (city.length < 2) {
        e.preventDefault();
        alert("City name must be at least 2 characters");
        document.getElementById("city").focus();
        return false;
      }

      if (address.length < 5) {
        e.preventDefault();
        alert("Address must be at least 5 characters");
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
