// Route Form JavaScript
document.addEventListener("DOMContentLoaded", function () {
  // Form validation
  const routeForm = document.getElementById("routeForm");
  if (routeForm) {
    routeForm.addEventListener("submit", function (e) {
      const departureCity = document
        .getElementById("departureCity")
        .value.trim();
      const destinationCity = document
        .getElementById("destinationCity")
        .value.trim();
      const distance = document.getElementById("distance").value;
      const durationHours = document.getElementById("durationHours").value;
      const basePrice = document.getElementById("basePrice").value;

      if (departureCity.length < 2) {
        e.preventDefault();
        alert("Departure city must be at least 2 characters");
        document.getElementById("departureCity").focus();
        return false;
      }

      if (destinationCity.length < 2) {
        e.preventDefault();
        alert("Destination city must be at least 2 characters");
        document.getElementById("destinationCity").focus();
        return false;
      }

      if (departureCity === destinationCity) {
        e.preventDefault();
        alert("Departure and destination cities cannot be the same");
        document.getElementById("destinationCity").focus();
        return false;
      }

      if (distance < 1 || distance > 5000) {
        e.preventDefault();
        alert("Distance must be between 1 and 5000 km");
        document.getElementById("distance").focus();
        return false;
      }

      if (durationHours < 0.5 || durationHours > 48) {
        e.preventDefault();
        alert("Travel time must be between 0.5 and 48 hours");
        document.getElementById("durationHours").focus();
        return false;
      }

      if (basePrice < 1000 || basePrice > 10000000) {
        e.preventDefault();
        alert("Ticket price must be from 1,000 to 10,000,000 VND");
        document.getElementById("basePrice").focus();
        return false;
      }
    });
  }

  // Auto focus on first field
  const departureCityField = document.getElementById("departureCity");
  if (departureCityField) {
    departureCityField.focus();
  }
});
