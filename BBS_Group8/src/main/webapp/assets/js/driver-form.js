// Driver Form JavaScript
document.addEventListener("DOMContentLoaded", function () {
  // Form validation
  const driverForm = document.getElementById("driverForm");
  if (driverForm) {
    driverForm.addEventListener("submit", function (e) {
      const userId = document.getElementById("userId").value;
      const licenseNumber = document
        .getElementById("licenseNumber")
        .value.trim();
      const experienceYears = document.getElementById("experienceYears").value;

      if (!userId) {
        e.preventDefault();
        alert("Vui lòng chọn người dùng");
        document.getElementById("userId").focus();
        return false;
      }

      if (licenseNumber.length < 5) {
        e.preventDefault();
        alert("Số bằng lái phải có ít nhất 5 ký tự");
        document.getElementById("licenseNumber").focus();
        return false;
      }

      if (experienceYears < 0 || experienceYears > 50) {
        e.preventDefault();
        alert("Số năm kinh nghiệm phải từ 0 đến 50");
        document.getElementById("experienceYears").focus();
        return false;
      }
    });
  }

  // Auto focus on first field
  const userIdField = document.getElementById("userId");
  if (userIdField) {
    userIdField.focus();
  }
});
