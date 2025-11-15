// ===== PROFILE PAGE JAVASCRIPT =====

// Function to open edit profile modal
function editProfile() {
  new bootstrap.Modal(document.getElementById("editProfileModal")).show();
}

// Profile page animations and interactions
document.addEventListener("DOMContentLoaded", function () {
  initializeProfileAnimations();
  initializeProfileInteractions();
  loadProfileStats();
});

// Initialize profile animations
function initializeProfileAnimations() {
  // Animate profile sections on hover
  const profileSections = document.querySelectorAll(".profile-section");
  profileSections.forEach((section) => {
    section.addEventListener("mouseenter", function () {
      this.style.transform = "translateX(5px)";
    });
    section.addEventListener("mouseleave", function () {
      this.style.transform = "translateX(0)";
    });
  });

  // Animate stat cards with staggered delay
  const statCards = document.querySelectorAll(".stat-card");
  statCards.forEach((card, index) => {
    setTimeout(() => {
      card.style.opacity = "0";
      card.style.transform = "translateY(20px)";
      card.style.transition = "all 0.6s ease";

      setTimeout(() => {
        card.style.opacity = "1";
        card.style.transform = "translateY(0)";
      }, 100);
    }, index * 100);
  });

  // Animate profile avatar on load
  const profileAvatar = document.querySelector(".profile-avatar");
  if (profileAvatar) {
    profileAvatar.style.opacity = "0";
    profileAvatar.style.transform = "scale(0.8)";

    setTimeout(() => {
      profileAvatar.style.transition = "all 0.8s ease";
      profileAvatar.style.opacity = "1";
      profileAvatar.style.transform = "scale(1)";
    }, 300);
  }
}

// Initialize profile interactions
function initializeProfileInteractions() {
  // Add click handlers for activity items
  const activityItems = document.querySelectorAll(".activity-item");
  activityItems.forEach((item) => {
    item.addEventListener("click", function () {
      // Add ripple effect
      const ripple = document.createElement("div");
      ripple.style.position = "absolute";
      ripple.style.borderRadius = "50%";
      ripple.style.background = "rgba(255, 255, 255, 0.6)";
      ripple.style.transform = "scale(0)";
      ripple.style.animation = "ripple 0.6s linear";
      ripple.style.left = "50%";
      ripple.style.top = "50%";
      ripple.style.width = "20px";
      ripple.style.height = "20px";
      ripple.style.marginLeft = "-10px";
      ripple.style.marginTop = "-10px";

      this.style.position = "relative";
      this.appendChild(ripple);

      setTimeout(() => {
        ripple.remove();
      }, 600);
    });
  });

  // Add hover effects for stat cards
  const statCards = document.querySelectorAll(".stat-card");
  statCards.forEach((card) => {
    card.addEventListener("mouseenter", function () {
      this.style.transform = "translateY(-3px) scale(1.02)";
    });
    card.addEventListener("mouseleave", function () {
      this.style.transform = "translateY(0) scale(1)";
    });
  });
}

// Load profile statistics (placeholder for future API integration)
function loadProfileStats() {
  // This function can be used to load real statistics from the server
  // For now, we'll just add some sample data
  const statNumbers = document.querySelectorAll(".stat-number");

  // Simulate loading data
  statNumbers.forEach((stat, index) => {
    const finalValue = getRandomStatValue(index);
    animateNumber(stat, 0, finalValue, 1000);
  });
}

// Get random stat value based on index
function getRandomStatValue(index) {
  const values = [12, 8, 5, 24]; // Sample values for tickets, routes, ratings, hours
  return values[index] || Math.floor(Math.random() * 20) + 1;
}

// Animate number counting
function animateNumber(element, start, end, duration) {
  const startTime = performance.now();
  const startValue = start;
  const endValue = end;

  function updateNumber(currentTime) {
    const elapsed = currentTime - startTime;
    const progress = Math.min(elapsed / duration, 1);

    const currentValue = Math.floor(
      startValue + (endValue - startValue) * progress
    );

    // Update the text content, preserving the icon
    const icon = element.querySelector("i");
    if (icon) {
      element.innerHTML = icon.outerHTML + currentValue;
    } else {
      element.textContent = currentValue;
    }

    if (progress < 1) {
      requestAnimationFrame(updateNumber);
    }
  }

  requestAnimationFrame(updateNumber);
}

// Profile form validation
function validateProfileForm() {
  const fullName = document.getElementById("fullName");
  const email = document.getElementById("email");

  let isValid = true;

  // Validate full name
  if (!fullName.value.trim()) {
    showFieldError(fullName, "Full name cannot be empty");
    isValid = false;
  } else if (fullName.value.trim().length < 2) {
    showFieldError(fullName, "Full name must be at least 2 characters");
    isValid = false;
  } else {
    clearFieldError(fullName);
  }

  // Validate email
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  if (!email.value.trim()) {
    showFieldError(email, "Email cannot be empty");
    isValid = false;
  } else if (!emailRegex.test(email.value)) {
    showFieldError(email, "Invalid email");
    isValid = false;
  } else {
    clearFieldError(email);
  }

  return isValid;
}

// Show field error
function showFieldError(field, message) {
  const errorDiv =
    field.parentNode.querySelector(".field-error") ||
    document.createElement("div");
  errorDiv.className = "field-error text-danger mt-1";
  errorDiv.textContent = message;

  if (!field.parentNode.querySelector(".field-error")) {
    field.parentNode.appendChild(errorDiv);
  }

  field.classList.add("is-invalid");
}

// Clear field error
function clearFieldError(field) {
  const errorDiv = field.parentNode.querySelector(".field-error");
  if (errorDiv) {
    errorDiv.remove();
  }
  field.classList.remove("is-invalid");
}

// Add CSS for ripple effect
const style = document.createElement("style");
style.textContent = `
    @keyframes ripple {
        to {
            transform: scale(4);
            opacity: 0;
        }
    }
    
    .field-error {
        font-size: 0.875rem;
        margin-top: 0.25rem;
    }
    
    .is-invalid {
        border-color: #dc3545 !important;
        box-shadow: 0 0 0 0.2rem rgba(220, 53, 69, 0.25) !important;
    }
`;
document.head.appendChild(style);

// Export functions for global access
window.editProfile = editProfile;
window.validateProfileForm = validateProfileForm;
