$(function () {
  // Helper: show error
  function showError($input, message) {
    $input.addClass("is-invalid");
    if ($input.next(".invalid-feedback").length === 0) {
      $input.after('<div class="invalid-feedback">' + message + "</div>");
    } else {
      $input.next(".invalid-feedback").text(message);
    }
  }

  // Helper: clear error
  function clearError($input) {
    $input.removeClass("is-invalid");
    $input.next(".invalid-feedback").remove();
  }

  // Username/email uniqueness check (AJAX)
  function checkUnique($input, url, paramName) {
    var val = $input.val().trim();
    if (!val) return;
    $.get(url, { [paramName]: val }, function (data) {
      if (data.exists) {
        showError(
          $input,
          paramName.charAt(0).toUpperCase() +
            paramName.slice(1) +
            " already exists"
        );
      } else {
        clearError($input);
      }
    });
  }

  // Register Form
  $("#registerForm").on("submit", function (e) {
    let valid = true;
    let $username = $("#username");
    let $fullName = $("#fullName");
    let $email = $("#email");
    let $password = $("#password");
    let $confirmPassword = $("#confirmPassword");
    let $agreeTerms = $("#agreeTerms");

    // Username
    if ($username.val().trim().length < 3) {
      showError($username, "Username must be at least 3 characters");
      valid = false;
    } else {
      clearError($username);
    }
    // Full name
    if ($fullName.val().trim().length < 2) {
      showError($fullName, "Full name must be at least 2 characters");
      valid = false;
    } else {
      clearError($fullName);
    }
    // Email
    let emailVal = $email.val().trim();
    let emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(emailVal)) {
      showError($email, "Invalid email");
      valid = false;
    } else {
      clearError($email);
    }
    // Password
    if ($password.val().length < 8) {
      showError($password, "Password must be at least 8 characters");
      valid = false;
    } else {
      clearError($password);
    }
    // Confirm password
    if ($password.val() !== $confirmPassword.val()) {
      showError($confirmPassword, "Password confirmation does not match");
      valid = false;
    } else {
      clearError($confirmPassword);
    }
    // Terms
    if (!$agreeTerms.is(":checked")) {
      showError($agreeTerms, "You must agree to the terms of use");
      valid = false;
    } else {
      clearError($agreeTerms);
    }
    if (!valid) e.preventDefault();
  });

  // Login Form
  $("#loginForm").on("submit", function (e) {
    let valid = true;
    let $username = $("#username");
    let $password = $("#password");
    if (!$username.val().trim()) {
      showError($username, "Please enter username");
      valid = false;
    } else {
      clearError($username);
    }
    if (!$password.val().trim()) {
      showError($password, "Please enter password");
      valid = false;
    } else {
      clearError($password);
    }
    if (!valid) e.preventDefault();
  });

  // User Form (Admin)
  $("#userForm").on("submit", function (e) {
    let valid = true;
    let $username = $("#username");
    let $fullName = $("#fullName");
    let $email = $("#email");
    let $role = $("#role");
    if ($username.val().trim().length < 3) {
      showError($username, "Username must be at least 3 characters");
      valid = false;
    } else {
      clearError($username);
    }
    if ($fullName.val().trim().length < 2) {
      showError($fullName, "Full name must be at least 2 characters");
      valid = false;
    } else {
      clearError($fullName);
    }
    let emailVal = $email.val().trim();
    let emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(emailVal)) {
      showError($email, "Invalid email");
      valid = false;
    } else {
      clearError($email);
    }
    if (!$role.val()) {
      showError($role, "Please select role");
      valid = false;
    } else {
      clearError($role);
    }
    if (!valid) e.preventDefault();
  });

  // Passenger Form
  $("#passengerForm").on("submit", function (e) {
    let valid = true;
    let $fullName = $("#fullName");
    let $phoneNumber = $("#phoneNumber");
    let $email = $("#email");
    let $idCard = $("#idCard");
    if ($fullName.val().trim().length < 2) {
      showError($fullName, "Full name must be at least 2 characters");
      valid = false;
    } else {
      clearError($fullName);
    }
    let phoneRegex = /^[0-9]{10,11}$/;
    if (!phoneRegex.test($phoneNumber.val().trim())) {
      showError($phoneNumber, "Phone number must have 10-11 digits");
      valid = false;
    } else {
      clearError($phoneNumber);
    }
    let emailVal = $email.val().trim();
    if (emailVal && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(emailVal)) {
      showError($email, "Invalid email");
      valid = false;
    } else {
      clearError($email);
    }
    let idCardVal = $idCard.val().trim();
    if (idCardVal && !/^[0-9]{9,12}$/.test(idCardVal)) {
      showError($idCard, "Invalid ID card number");
      valid = false;
    } else {
      clearError($idCard);
    }
    if (!valid) e.preventDefault();
  });

  // Bus Form
  $("#busForm").on("submit", function (e) {
    let valid = true;
    let $busNumber = $("#busNumber");
    let $busType = $("#busType");
    let $totalSeats = $("#totalSeats");
    let $driverName = $("#driverName");
    let $licensePlate = $("#licensePlate");
    if ($busNumber.val().trim().length < 2) {
      showError($busNumber, "Bus number must be at least 2 characters");
      valid = false;
    } else {
      clearError($busNumber);
    }
    if (!$busType.val()) {
      showError($busType, "Please select bus type");
      valid = false;
    } else {
      clearError($busType);
    }
    let seats = parseInt($totalSeats.val());
    if (isNaN(seats) || seats < 1 || seats > 100) {
      showError($totalSeats, "Total seats must be from 1 to 100");
      valid = false;
    } else {
      clearError($totalSeats);
    }
    if ($driverName.val().trim().length < 2) {
      showError($driverName, "Driver name must be at least 2 characters");
      valid = false;
    } else {
      clearError($driverName);
    }
    let licensePlateRegex = /^[0-9]{2}[A-Z]-[0-9]{4,5}$/;
    if (!licensePlateRegex.test($licensePlate.val().trim())) {
      showError(
        $licensePlate,
        "Invalid license plate. Format: XX-XXXXX or XX-XXXX"
      );
      valid = false;
    } else {
      clearError($licensePlate);
    }
    if (!valid) e.preventDefault();
  });

  // Route Form
  $("#routeForm").on("submit", function (e) {
    let valid = true;
    let $routeName = $("#routeName");
    let $price = $("#price");
    let $departureCity = $("#departureCity");
    let $destinationCity = $("#destinationCity");
    let $distance = $("#distance");
    let $durationHours = $("#durationHours");
    if ($routeName.val().trim().length < 3) {
      showError($routeName, "Route name must be at least 3 characters");
      valid = false;
    } else {
      clearError($routeName);
    }
    if (parseInt($price.val()) < 1000) {
      showError($price, "Price must be greater than 1000");
      valid = false;
    } else {
      clearError($price);
    }
    if ($departureCity.val().trim().length < 2) {
      showError($departureCity, "Invalid departure city");
      valid = false;
    } else {
      clearError($departureCity);
    }
    if ($destinationCity.val().trim().length < 2) {
      showError($destinationCity, "Invalid destination city");
      valid = false;
    } else {
      clearError($destinationCity);
    }
    if (parseFloat($distance.val()) < 1) {
      showError($distance, "Distance must be greater than 0");
      valid = false;
    } else {
      clearError($distance);
    }
    if (parseFloat($durationHours.val()) < 0.5) {
      showError($durationHours, "Duration must be greater than 0");
      valid = false;
    } else {
      clearError($durationHours);
    }
    if (!valid) e.preventDefault();
  });

  // Ticket Form
  $("#ticketForm").on("submit", function (e) {
    let valid = true;
    let $routeId = $("#routeId");
    let $busId = $("#busId");
    let $userId = $("#userId"); // Fixed: use userId instead of passengerId
    let $departureDate = $("#departureDate");
    let $departureTime = $("#departureTime");
    let $seatNumber = $("#seatNumber");
    let $ticketPrice = $("#ticketPrice");

    if (!$routeId.val()) {
      showError($routeId, "Please select route");
      valid = false;
    } else {
      clearError($routeId);
    }
    if (!$busId.val()) {
      showError($busId, "Please select bus");
      valid = false;
    } else {
      clearError($busId);
    }
    if (!$userId.val()) {
      showError($userId, "Please select passenger");
      valid = false;
    } else {
      clearError($userId);
    }
    if (!$departureDate.val()) {
      showError($departureDate, "Please select departure date");
      valid = false;
    } else {
      clearError($departureDate);
    }
    if (!$departureTime.val()) {
      showError($departureTime, "Please select departure time");
      valid = false;
    } else {
      clearError($departureTime);
    }
    if (!$seatNumber.val() || parseInt($seatNumber.val()) < 1) {
      showError($seatNumber, "Please select valid seat number");
      valid = false;
    } else {
      clearError($seatNumber);
    }
    if (parseInt($ticketPrice.val()) < 1000) {
      showError($ticketPrice, "Ticket price must be greater than 1000");
      valid = false;
    } else {
      clearError($ticketPrice);
    }

    if (!valid) {
      e.preventDefault();
      return false;
    }
  });

  // Change Password Form
  $("#changePasswordForm").on("submit", function (e) {
    let valid = true;
    let $currentPassword = $("#currentPassword");
    let $newPassword = $("#newPassword");
    let $confirmPassword = $("#confirmPassword");
    if ($newPassword.val().length < 8) {
      showError($newPassword, "New password must be at least 8 characters");
      valid = false;
    } else {
      clearError($newPassword);
    }
    if ($newPassword.val() !== $confirmPassword.val()) {
      showError($confirmPassword, "Password confirmation does not match");
      valid = false;
    } else {
      clearError($confirmPassword);
    }
    if (!valid) e.preventDefault();
  });

  // Profile Edit Modal
  $("#editProfileModal form").on("submit", function (e) {
    let valid = true;
    let $fullName = $("#editProfileModal #fullName");
    let $email = $("#editProfileModal #email");
    if ($fullName.val().trim().length < 2) {
      showError($fullName, "Full name must be at least 2 characters");
      valid = false;
    } else {
      clearError($fullName);
    }
    let emailVal = $email.val().trim();
    let emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(emailVal)) {
      showError($email, "Invalid email");
      valid = false;
    } else {
      clearError($email);
    }
    if (!valid) e.preventDefault();
  });

  // Remove error on input
  $("input, select, textarea").on("input change", function () {
    clearError($(this));
  });
});
