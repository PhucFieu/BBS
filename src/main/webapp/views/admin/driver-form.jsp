<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>${empty driver ? 'Add Driver' : 'Edit Driver'} - Bus Booking System</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
            <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
            <style>
                /* Driver Form Styles */
                .form-card {
                    background: #fff;
                    border-radius: 18px;
                    box-shadow: 0 8px 32px rgba(102, 187, 106, 0.15);
                    padding: 2.5rem 2rem 2rem 2rem;
                    margin-top: 2rem;
                    margin-bottom: 2rem;
                }

                .form-header {
                    background: linear-gradient(135deg, #66bb6a 0%, #81c784 100%);
                    color: #fff;
                    border-radius: 18px 18px 0 0;
                    padding: 1.5rem 2rem;
                    margin: -2.5rem -2rem 2rem -2rem;
                    box-shadow: 0 4px 16px rgba(102, 187, 106, 0.2);
                }

                .section-title {
                    color: #66bb6a;
                    font-weight: 600;
                    margin-bottom: 1rem;
                    padding-bottom: 0.5rem;
                    border-bottom: 2px solid #c8e6c9;
                }

                .form-label {
                    font-weight: 600;
                }

                .form-control:focus {
                    border-color: #66bb6a;
                    box-shadow: 0 0 0 0.2rem rgba(102, 187, 106, 0.25);
                }

                .btn-gradient {
                    background: linear-gradient(135deg, #66bb6a 0%, #81c784 100%);
                    color: #fff;
                    border: none;
                    border-radius: 25px;
                    padding: 0.75rem 2rem;
                    font-weight: 600;
                    transition: all 0.2s;
                }

                .btn-gradient:hover {
                    background: linear-gradient(135deg, #4caf50 0%, #66bb6a 100%);
                    color: #fff;
                    transform: translateY(-1px);
                }
                .form-container {
                    background: linear-gradient(135deg, #66bb6a 0%, #81c784 100%);
                    border-radius: 15px;
                    padding: 2rem;
                    margin-bottom: 2rem;
                    color: white;
                }

                .form-card {
                    background: white;
                    border-radius: 15px;
                    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
                    overflow: hidden;
                }

                .form-header {
                    background: linear-gradient(135deg, #66bb6a 0%, #81c784 100%);
                    color: white;
                    padding: 2rem;
                    text-align: center;
                }

                .form-body {
                    padding: 2rem;
                }

                .form-group {
                    margin-bottom: 1.5rem;
                }

                .form-label {
                    font-weight: 600;
                    color: #333;
                    margin-bottom: 0.5rem;
                }

                .form-control,
                .form-select {
                    border: 2px solid #e9ecef;
                    border-radius: 10px;
                    padding: 0.75rem 1rem;
                    transition: all 0.3s ease;
                }

                .form-control:focus,
                .form-select:focus {
                    border-color: #66bb6a;
                    box-shadow: 0 0 0 0.2rem rgba(102, 187, 106, 0.25);
                }

                .btn-submit {
                    background: linear-gradient(135deg, #66bb6a 0%, #81c784 100%);
                    border: none;
                    border-radius: 10px;
                    padding: 0.75rem 2rem;
                    font-weight: 600;
                    transition: all 0.3s ease;
                }

                .btn-submit:hover {
                    transform: translateY(-2px);
                    box-shadow: 0 5px 15px rgba(102, 187, 106, 0.4);
                }

                .btn-cancel {
                    border: 2px solid #6c757d;
                    border-radius: 10px;
                    padding: 0.75rem 2rem;
                    font-weight: 600;
                    transition: all 0.3s ease;
                }

                .btn-cancel:hover {
                    background-color: #6c757d;
                    color: white;
                }

                .info-card {
                    background: #f8f9fa;
                    border-left: 4px solid #66bb6a;
                    border-radius: 0 10px 10px 0;
                    padding: 1rem;
                    margin-bottom: 1rem;
                }

                .section-title {
                    font-weight: 600;
                    color: #66bb6a;
                    margin-bottom: 1rem;
                    padding-bottom: 0.5rem;
                    border-bottom: 2px solid #e9ecef;
                }
            </style>
        </head>

        <body>
            <jsp:include page="../partials/admin-header.jsp" />

            <div class="container-fluid py-4">
                <div class="row justify-content-center">
                    <div class="col-lg-8">
                        <!-- Header Section -->
                        <div class="form-container">
                            <div class="row align-items-center">
                                <div class="col-md-8">
                                    <h2 class="mb-0">
                                        <i class="fas fa-user-tie me-2"></i>
                                        ${empty driver ? 'Add New Driver' : 'Edit Driver'}
                                    </h2>
                                    <p class="mb-0 mt-2">
                                        ${empty driver ? 'Create a new driver account' : 'Update driver information'}
                                    </p>
                                </div>
                                <div class="col-md-4 text-md-end">
                                    <a href="${pageContext.request.contextPath}/admin/drivers" class="btn btn-light">
                                        <i class="fas fa-arrow-left me-2"></i>Back to Drivers
                                    </a>
                                </div>
                            </div>
                        </div>

                        <!-- Notification Messages -->
                        <c:if test="${not empty param.message}">
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                <i class="fas fa-check-circle me-2"></i>
                                <strong>Success!</strong> ${param.message}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>
                        <c:if test="${not empty param.error}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="fas fa-exclamation-circle me-2"></i>
                                <strong>Error!</strong> ${param.error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>
                        <c:if test="${not empty param.warning}">
                            <div class="alert alert-warning alert-dismissible fade show" role="alert">
                                <i class="fas fa-exclamation-triangle me-2"></i>
                                <strong>Warning!</strong> ${param.warning}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>
                        <c:if test="${not empty param.info}">
                            <div class="alert alert-info alert-dismissible fade show" role="alert">
                                <i class="fas fa-info-circle me-2"></i>
                                <strong>Info:</strong> ${param.info}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>

                        <!-- Form Card -->
                        <div class="form-card">
                            <div class="form-header">
                                <h4 class="mb-0">
                                    <i class="fas fa-${empty driver ? 'plus' : 'edit'} me-2"></i>
                                    Driver Information
                                </h4>
                            </div>
                            <div class="form-body">
                                <form
                                    action="${pageContext.request.contextPath}/admin/drivers/${empty driver ? 'add' : 'edit'}"
                                    method="post" id="driverForm">

                                    <c:if test="${not empty driver}">
                                        <input type="hidden" name="driverId" value="${driver.driverId}">
                                    </c:if>

                                    <!-- Personal Information -->
                                    <div class="section-title">
                                        <i class="fas fa-user me-2"></i>Personal Information
                                    </div>

                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label for="username" class="form-label">
                                                    <i class="fas fa-user me-2"></i>Username *
                                                </label>
                                                <input type="text" class="form-control" id="username" name="username"
                                                    value="${driver.username}" required>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label for="password" class="form-label">
                                                    <i class="fas fa-lock me-2"></i>Password *
                                                </label>
                                                <div class="input-group">
                                                    <input type="password" class="form-control" id="password"
                                                        name="password" ${empty driver ? 'required' : '' }>
                                                    <button class="btn btn-outline-secondary" type="button"
                                                        onclick="togglePasswordVisibility('password')">
                                                        <i class="fas fa-eye" id="passwordToggleIcon"></i>
                                                    </button>
                                                </div>
                                                <c:if test="${not empty driver}">
                                                    <small class="form-text text-muted">Leave blank to keep current
                                                        password</small>
                                                </c:if>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label for="fullName" class="form-label">
                                                    <i class="fas fa-id-card me-2"></i>Full Name *
                                                </label>
                                                <input type="text" class="form-control" id="fullName" name="fullName"
                                                    value="${driver.fullName}" required>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label for="email" class="form-label">
                                                    <i class="fas fa-envelope me-2"></i>Email
                                                </label>
                                                <input type="email" class="form-control" id="email" name="email"
                                                    value="${driver.email}">
                                                <small class="form-text text-muted">Optional</small>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label for="phoneNumber" class="form-label">
                                                    <i class="fas fa-phone me-2"></i>Phone Number *
                                                </label>
                                                <input type="tel" class="form-control" id="phoneNumber"
                                                    name="phoneNumber" value="${driver.phoneNumber}" required>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Driver Specific Information -->
                                    <div class="section-title">
                                        <i class="fas fa-id-card me-2"></i>Driver Information
                                    </div>

                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label for="licenseNumber" class="form-label">
                                                    <i class="fas fa-certificate me-2"></i>License Number *
                                                </label>
                                                <input type="text" class="form-control" id="licenseNumber"
                                                    name="licenseNumber" value="${driver.licenseNumber}" required>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label for="experienceYears" class="form-label">
                                                    <i class="fas fa-calendar-alt me-2"></i>Experience (Years) *
                                                </label>
                                                <input type="number" class="form-control" id="experienceYears"
                                                    name="experienceYears" value="${driver.experienceYears}" min="0"
                                                    max="50" required>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Information Card -->
                                    <div class="info-card">
                                        <h6 class="mb-2">
                                            <i class="fas fa-info-circle me-2"></i>Important Information
                                        </h6>
                                        <ul class="mb-0 small">
                                            <li>Username must be unique and will be used for login</li>
                                            <li>Password must be at least 6 characters long</li>
                                            <li>Phone number should be in Vietnamese format (e.g., 0907450814)</li>
                                            <li>License number must be valid and unique</li>
                                            <li>Experience years should reflect actual driving experience</li>
                                        </ul>
                                    </div>

                                    <!-- Form Actions -->
                                    <div class="d-flex justify-content-between pt-3">
                                        <a href="${pageContext.request.contextPath}/admin/drivers"
                                            class="btn btn-cancel">
                                            <i class="fas fa-times me-2"></i>Cancel
                                        </a>
                                        <button type="submit" class="btn btn-submit text-white">
                                            <i class="fas fa-${empty driver ? 'plus' : 'save'} me-2"></i>
                                            ${empty driver ? 'Add Driver' : 'Update Driver'}
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <%@ include file="/views/partials/footer.jsp" %>
                <script>
                    // Auto-hide alerts after 5 seconds
                    document.addEventListener('DOMContentLoaded', function () {
                        const alerts = document.querySelectorAll('.alert');
                        alerts.forEach(function(alert) {
                            setTimeout(function() {
                                const bsAlert = new bootstrap.Alert(alert);
                                bsAlert.close();
                            }, 5000);
                        });

                        // Scroll to top if there's a message
                        if (alerts.length > 0) {
                            window.scrollTo({ top: 0, behavior: 'smooth' });
                        }
                    });
                </script>
                <script>
                    // Form validation
                    document.getElementById('driverForm').addEventListener('submit', function (e) {
                        const username = document.getElementById('username').value.trim();
                        const fullName = document.getElementById('fullName').value.trim();
                        const email = document.getElementById('email').value.trim();
                        const phoneNumber = document.getElementById('phoneNumber').value.trim();
                        const licenseNumber = document.getElementById('licenseNumber').value.trim();
                        const experienceYears = document.getElementById('experienceYears').value;

                        if (!username || !fullName || !phoneNumber || !licenseNumber || !experienceYears) {
                            e.preventDefault();
                            alert('Please fill in all required fields.');
                            return;
                        }

                        // Email validation (only if provided)
                        if (email && email.length > 0) {
                            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                            if (!emailRegex.test(email)) {
                                e.preventDefault();
                                alert('Please enter a valid email address.');
                                return;
                            }
                        }

                        // Phone number validation for Vietnamese format
                        const phoneRegex = /^(0[3|5|7|8|9])[0-9]{8}$/;
                        if (!phoneRegex.test(phoneNumber.replace(/[\s\-\(\)]/g, ''))) {
                            e.preventDefault();
                            alert('Please enter a valid Vietnamese phone number (e.g., 0907450814).');
                            return;
                        }

                        // Experience years validation
                        const years = parseInt(experienceYears);
                        if (isNaN(years) || years < 0 || years > 50) {
                            e.preventDefault();
                            alert('Please enter a valid experience in years (0-50).');
                            return;
                        }
                    });

                    // Password visibility toggle
                    function togglePasswordVisibility(fieldId) {
                        const passwordField = document.getElementById(fieldId);
                        const toggleIcon = document.getElementById(fieldId + 'ToggleIcon');

                        if (passwordField.type === 'password') {
                            passwordField.type = 'text';
                            toggleIcon.classList.remove('fa-eye');
                            toggleIcon.classList.add('fa-eye-slash');
                        } else {
                            passwordField.type = 'password';
                            toggleIcon.classList.remove('fa-eye-slash');
                            toggleIcon.classList.add('fa-eye');
                        }
                    }
                </script>
        </body>

        </html>