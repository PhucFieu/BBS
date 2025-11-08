// Passenger Form JavaScript
document.addEventListener("DOMContentLoaded", function () {
  // Update avatar preview when name changes
  const fullNameInput = document.getElementById("fullName");
  const avatarPreview = document.getElementById("avatarPreview");

  if (fullNameInput && avatarPreview) {
    fullNameInput.addEventListener("input", function () {
      const name = this.value.trim();
      if (name.length > 0) {
        avatarPreview.textContent = name.charAt(0).toUpperCase();
      } else {
        avatarPreview.textContent = "?";
      }
    });
  }

  // Phone number formatting
  const phoneNumberInput = document.getElementById("phoneNumber");
  if (phoneNumberInput) {
    phoneNumberInput.addEventListener("input", function () {
      let phone = this.value.replace(/\D/g, "");
      if (phone.length > 11) {
        phone = phone.substring(0, 11);
      }
      this.value = phone;
    });
  }

  // ID Card formatting
  const idCardInput = document.getElementById("idCard");
  if (idCardInput) {
    idCardInput.addEventListener("input", function () {
      let idCard = this.value.replace(/\D/g, "");
      if (idCard.length > 12) {
        idCard = idCard.substring(0, 12);
      }
      this.value = idCard;
    });
  }

  // Date of birth validation
  const dateOfBirthInput = document.getElementById("dateOfBirth");
  if (dateOfBirthInput) {
    dateOfBirthInput.addEventListener("change", function () {
      const birthDate = new Date(this.value);
      const today = new Date();
      const age = today.getFullYear() - birthDate.getFullYear();

      if (age < 0 || age > 120) {
        alert("Ngày sinh không hợp lệ");
        this.value = "";
      }
    });
  }

  // Form validation
  const userForm = document.getElementById("userForm");
  if (userForm) {
    userForm.addEventListener("submit", function (e) {
      const fullName = document.getElementById("fullName").value.trim();
      const username = document.getElementById("username").value.trim();
      const phoneNumber = document.getElementById("phoneNumber").value.trim();
      const email = document.getElementById("email").value.trim();
      const idCard = document.getElementById("idCard").value.trim();
      const role = document.getElementById("role").value;

      // Full name validation
      if (fullName.length < 2) {
        e.preventDefault();
        alert("Họ và tên phải có ít nhất 2 ký tự");
        document.getElementById("fullName").focus();
        return false;
      }

      // Username validation
      if (username.length < 3) {
        e.preventDefault();
        alert("Tên đăng nhập phải có ít nhất 3 ký tự");
        document.getElementById("username").focus();
        return false;
      }

      // Role validation
      if (!role) {
        e.preventDefault();
        alert("Vui lòng chọn vai trò");
        document.getElementById("role").focus();
        return false;
      }

      // Phone number validation
      const phoneRegex = /^[0-9]{10,11}$/;
      if (!phoneRegex.test(phoneNumber)) {
        e.preventDefault();
        alert("Số điện thoại phải có 10-11 số");
        document.getElementById("phoneNumber").focus();
        return false;
      }

      // Email validation (if provided)
      if (email && !isValidEmail(email)) {
        e.preventDefault();
        alert("Email không hợp lệ");
        document.getElementById("email").focus();
        return false;
      }

      // ID Card validation (if provided)
      if (idCard) {
        const idCardRegex = /^[0-9]{9,12}$/;
        if (!idCardRegex.test(idCard)) {
          e.preventDefault();
          alert("Số CMND/CCCD không hợp lệ");
          document.getElementById("idCard").focus();
          return false;
        }
      }
    });
  }

  // Auto focus on first field
  if (fullNameInput) {
    fullNameInput.focus();
  }
});

function isValidEmail(email) {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailRegex.test(email);
}
