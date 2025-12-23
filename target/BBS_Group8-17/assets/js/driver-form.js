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
        alert("Please select a user");
        document.getElementById("userId").focus();
        return false;
      }

      // License number validation: must be exactly 12 digits
      const licenseNumberRegex = /^[0-9]{12}$/;
      if (!licenseNumberRegex.test(licenseNumber)) {
        e.preventDefault();
        alert("License number must be exactly 12 digits (numbers only)");
        document.getElementById("licenseNumber").focus();
        return false;
      }

      if (experienceYears < 0 || experienceYears > 50) {
        e.preventDefault();
        alert("Years of experience must be between 0 and 50");
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
