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
        alert("Thành phố khởi hành phải có ít nhất 2 ký tự");
        document.getElementById("departureCity").focus();
        return false;
      }

      if (destinationCity.length < 2) {
        e.preventDefault();
        alert("Thành phố đến phải có ít nhất 2 ký tự");
        document.getElementById("destinationCity").focus();
        return false;
      }

      if (departureCity === destinationCity) {
        e.preventDefault();
        alert("Thành phố khởi hành và đến không được giống nhau");
        document.getElementById("destinationCity").focus();
        return false;
      }

      if (distance < 1 || distance > 5000) {
        e.preventDefault();
        alert("Khoảng cách phải từ 1 đến 5000 km");
        document.getElementById("distance").focus();
        return false;
      }

      if (durationHours < 0.5 || durationHours > 48) {
        e.preventDefault();
        alert("Thời gian di chuyển phải từ 0.5 đến 48 giờ");
        document.getElementById("durationHours").focus();
        return false;
      }

      if (basePrice < 1000 || basePrice > 10000000) {
        e.preventDefault();
        alert("Giá vé phải từ 1,000 đến 10,000,000 VNĐ");
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
