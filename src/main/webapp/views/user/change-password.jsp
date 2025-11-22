<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Change Password - Bus Booking System</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
            <style>
                body {
                    background: linear-gradient(135deg, #66bb6a 0%, #81c784 100%);
                    min-height: 100vh;
                }

                .password-card {
                    background: white;
                    border-radius: 20px;
                    box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
                    overflow: hidden;
                }

                .password-header {
                    background: linear-gradient(45deg, #66bb6a, #81c784);
                    color: white;
                    padding: 2rem;
                    text-align: center;
                }

                .password-body {
                    padding: 2rem;
                }

                .form-control {
                    border-radius: 10px;
                    border: 2px solid #e9ecef;
                    padding: 0.75rem 1rem;
                    transition: all 0.3s ease;
                }

                .form-control:focus {
                    border-color: #66bb6a;
                    box-shadow: 0 0 0 0.2rem rgba(102, 187, 106, 0.25);
                }

                .btn-change {
                    background: linear-gradient(45deg, #66bb6a, #81c784);
                    border: none;
                    border-radius: 25px;
                    padding: 0.75rem 2rem;
                    font-weight: 600;
                    transition: all 0.3s ease;
                }

                .btn-change:hover {
                    background: linear-gradient(45deg, #4caf50, #66bb6a);
                    transform: translateY(-2px);
                }

                .password-strength {
                    height: 5px;
                    border-radius: 3px;
                    margin-top: 0.5rem;
                    transition: all 0.3s ease;
                }

                .strength-weak {
                    background: #dc3545;
                }

                .strength-medium {
                    background: #ffc107;
                }

                .strength-strong {
                    background: #66bb6a;
                }

                .password-toggle {
                    position: absolute;
                    right: 10px;
                    top: 50%;
                    transform: translateY(-50%);
                    cursor: pointer;
                    color: #6c757d;
                }

                .input-group {
                    position: relative;
                }
            </style>
        </head>

        <body>
            <div class="container">
                <div class="row justify-content-center align-items-center min-vh-100">
                    <div class="col-md-6 col-lg-5">
                        <div class="password-card">
                            <div class="password-header">
                                <i class="fas fa-key fa-3x mb-3"></i>
                                <h3>Change Password</h3>
                                <p class="mb-0">Update your account password</p>
                            </div>

                            <div class="password-body">
                                <!-- Error Messages -->
                                <c:if test="${not empty param.error}">
                                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                        <i class="fas fa-exclamation-circle me-2"></i>${param.error}
                                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                    </div>
                                </c:if>

                                <!-- Success Messages -->
                                <c:if test="${not empty param.message}">
                                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                                        <i class="fas fa-check-circle me-2"></i>${param.message}
                                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                    </div>
                                </c:if>

                                <form action="${pageContext.request.contextPath}/auth/change-password" method="post"
                                    id="changePasswordForm">
                                    <div class="mb-4">
                                        <label for="currentPassword" class="form-label">
                                            <i class="fas fa-lock me-2"></i>Current Password
                                        </label>
                                        <div class="input-group">
                                            <input type="password" class="form-control" id="currentPassword"
                                                name="currentPassword" required>
                                            <i class="fas fa-eye password-toggle"
                                                onclick="togglePassword('currentPassword')"></i>
                                        </div>
                                    </div>

                                    <div class="mb-4">
                                        <label for="newPassword" class="form-label">
                                            <i class="fas fa-key me-2"></i>New Password
                                        </label>
                                        <div class="input-group">
                                            <input type="password" class="form-control" id="newPassword"
                                                name="newPassword" required>
                                            <i class="fas fa-eye password-toggle"
                                                onclick="togglePassword('newPassword')"></i>
                                        </div>
                                        <div class="password-strength" id="passwordStrength"></div>
                                        <small class="text-muted">
                                            Password must be at least 8 characters long and contain uppercase,
                                            lowercase, number, and special character
                                        </small>
                                    </div>

                                    <div class="mb-4">
                                        <label for="confirmPassword" class="form-label">
                                            <i class="fas fa-check-circle me-2"></i>Confirm New Password
                                        </label>
                                        <div class="input-group">
                                            <input type="password" class="form-control" id="confirmPassword"
                                                name="confirmPassword" required>
                                            <i class="fas fa-eye password-toggle"
                                                onclick="togglePassword('confirmPassword')"></i>
                                        </div>
                                        <div id="passwordMatch" class="mt-2"></div>
                                    </div>

                                    <div class="d-grid gap-2">
                                        <button type="submit" class="btn btn-primary btn-change">
                                            <i class="fas fa-save me-2"></i>Change Password
                                        </button>
                                        <a href="${pageContext.request.contextPath}/auth/profile"
                                            class="btn btn-outline-secondary">
                                            <i class="fas fa-arrow-left me-2"></i>Back to Profile
                                        </a>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <%@ include file="/views/partials/footer.jsp" %>
            <script>
                function togglePassword(inputId) {
                    const input = document.getElementById(inputId);
                    const icon = input.nextElementSibling;

                    if (input.type === 'password') {
                        input.type = 'text';
                        icon.classList.remove('fa-eye');
                        icon.classList.add('fa-eye-slash');
                    } else {
                        input.type = 'password';
                        icon.classList.remove('fa-eye-slash');
                        icon.classList.add('fa-eye');
                    }
                }

                function checkPasswordStrength(password) {
                    let strength = 0;
                    const strengthBar = document.getElementById('passwordStrength');

                    if (password.length >= 8) strength++;
                    if (/[a-z]/.test(password)) strength++;
                    if (/[A-Z]/.test(password)) strength++;
                    if (/[0-9]/.test(password)) strength++;
                    if (/[^A-Za-z0-9]/.test(password)) strength++;

                    strengthBar.className = 'password-strength';
                    if (strength <= 2) {
                        strengthBar.classList.add('strength-weak');
                        strengthBar.style.width = '20%';
                    } else if (strength <= 3) {
                        strengthBar.classList.add('strength-medium');
                        strengthBar.style.width = '60%';
                    } else {
                        strengthBar.classList.add('strength-strong');
                        strengthBar.style.width = '100%';
                    }
                }

                function checkPasswordMatch() {
                    const newPassword = document.getElementById('newPassword').value;
                    const confirmPassword = document.getElementById('confirmPassword').value;
                    const matchDiv = document.getElementById('passwordMatch');

                    if (confirmPassword === '') {
                        matchDiv.innerHTML = '';
                        return;
                    }

                    if (newPassword === confirmPassword) {
                        matchDiv.innerHTML = '<i class="fas fa-check-circle text-success me-2"></i>Passwords match';
                    } else {
                        matchDiv.innerHTML = '<i class="fas fa-times-circle text-danger me-2"></i>Passwords do not match';
                    }
                }

                // Event listeners
                document.getElementById('newPassword').addEventListener('input', function () {
                    checkPasswordStrength(this.value);
                    checkPasswordMatch();
                });

                document.getElementById('confirmPassword').addEventListener('input', checkPasswordMatch);

                // Form validation
                document.getElementById('changePasswordForm').addEventListener('submit', function (e) {
                    const newPassword = document.getElementById('newPassword').value;
                    const confirmPassword = document.getElementById('confirmPassword').value;

                    if (newPassword !== confirmPassword) {
                        e.preventDefault();
                        alert('Passwords do not match!');
                        return false;
                    }

                    if (newPassword.length < 8) {
                        e.preventDefault();
                        alert('Password must be at least 8 characters long!');
                        return false;
                    }
                });
            </script>
        </body>

        </html>

