<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <jsp:include page="/views/partials/head.jsp">
                <jsp:param name="title" value="Add New User - Admin Panel" />
            </jsp:include>
        </head>

        <body>
            <%@ include file="/views/partials/admin-header.jsp" %>

                <div class="container mt-4">
                    <div class="row justify-content-center">
                        <div class="col-md-8">
                            <div class="card">
                                <div class="card-header bg-success text-white">
                                    <h5 class="mb-0">
                                        <i class="fas fa-user-plus me-2"></i>
                                        Add New Passenger
                                    </h5>
                                </div>
                                <div class="card-body">
                                    <!-- Messages -->
                                    <c:if test="${not empty param.error}">
                                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                            <i class="fas fa-exclamation-circle me-2"></i>${param.error}
                                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                        </div>
                                    </c:if>

                                    <c:if test="${not empty param.message}">
                                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                                            <i class="fas fa-check-circle me-2"></i>${param.message}
                                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                        </div>
                                    </c:if>

                                    <form action="${pageContext.request.contextPath}/admin/users/add" method="post"
                                        id="addUserForm">

                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="mb-3">
                                                    <label for="username" class="form-label">Username *</label>
                                                    <input type="text" class="form-control" id="username"
                                                        name="username" required placeholder="Enter username">
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="mb-3">
                                                    <label for="fullName" class="form-label">Full Name *</label>
                                                    <input type="text" class="form-control" id="fullName"
                                                        name="fullName" required placeholder="Enter full name">
                                                </div>
                                            </div>
                                        </div>

                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="mb-3">
                                                    <label for="email" class="form-label">Email *</label>
                                                    <input type="email" class="form-control" id="email" name="email"
                                                        required placeholder="Enter email">
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="mb-3">
                                                    <label for="phoneNumber" class="form-label">Phone Number *</label>
                                                    <input type="tel" class="form-control" id="phoneNumber"
                                                        name="phoneNumber" required placeholder="Enter phone number">
                                                </div>
                                            </div>
                                        </div>

                                        <div class="mb-3">
                                            <label for="password" class="form-label">Password *</label>
                                            <input type="password" class="form-control" id="password" name="password"
                                                required placeholder="Enter password">
                                            <div class="form-text">Password must be at least 8 characters</div>
                                        </div>

                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="mb-3">
                                                    <label for="status" class="form-label">Status *</label>
                                                    <select class="form-select" id="status" name="status" required>
                                                        <option value="">Select status</option>
                                                        <option value="ACTIVE" selected>Active</option>
                                                        <option value="INACTIVE">Inactive</option>
                                                    </select>
                                                </div>
                                            </div>
                                            <!-- Role is fixed to USER (Passenger) for this form -->
                                            <input type="hidden" name="role" value="USER" />
                                        </div>

                                        <div class="mb-3">
                                            <label for="idCard" class="form-label">ID Card</label>
                                            <input type="text" class="form-control" id="idCard" name="idCard"
                                                placeholder="Enter ID card (optional)">
                                        </div>

                                        <div class="mb-3">
                                            <label for="address" class="form-label">Address</label>
                                            <textarea class="form-control" id="address" name="address" rows="3"
                                                placeholder="Enter address (optional)"></textarea>
                                        </div>

                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="mb-3">
                                                    <label for="dateOfBirth" class="form-label">Date of Birth</label>
                                                    <input type="date" class="form-control" id="dateOfBirth"
                                                        name="dateOfBirth">
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="mb-3">
                                                    <label for="gender" class="form-label">Gender</label>
                                                    <select class="form-select" id="gender" name="gender">
                                                        <option value="">Select gender</option>
                                                        <option value="MALE">Male</option>
                                                        <option value="FEMALE">Female</option>
                                                        <option value="OTHER">Other</option>
                                                    </select>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="d-flex justify-content-between">
                                            <a href="${pageContext.request.contextPath}/admin/users"
                                                class="btn btn-secondary">
                                                <i class="fas fa-arrow-left me-2"></i>Back
                                            </a>
                                            <button type="submit" class="btn btn-success">
                                                <i class="fas fa-plus me-2"></i>Add User
                                            </button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Include footer -->
                <%@ include file="/views/partials/footer.jsp" %>

                    <!-- Form validation script -->
                    <script>
                        document.getElementById('addUserForm').addEventListener('submit', function (e) {
                            const username = document.getElementById('username').value.trim();
                            const fullName = document.getElementById('fullName').value.trim();
                            const email = document.getElementById('email').value.trim();
                            const phoneNumber = document.getElementById('phoneNumber').value.trim();
                            // role fixed as USER
                            const status = document.getElementById('status').value;
                            const password = document.getElementById('password').value;

                            if (!username || !fullName || !email || !phoneNumber || !status || !password) {
                                e.preventDefault();
                                alert('Please fill in all required fields!');
                                return false;
                            }

                            if (password.length < 8) {
                                e.preventDefault();
                                alert('Password must be at least 8 characters!');
                                return false;
                            }

                            // Email validation
                            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                            if (!emailRegex.test(email)) {
                                e.preventDefault();
                                alert('Invalid email!');
                                return false;
                            }

                            // Phone validation
                            const phoneRegex = /^[0-9]{10,11}$/;
                            if (!phoneRegex.test(phoneNumber)) {
                                e.preventDefault();
                                alert('Phone number must be 10-11 digits!');
                                return false;
                            }

                            // Username validation
                            if (username.length < 3) {
                                e.preventDefault();
                                alert('Username must be at least 3 characters!');
                                return false;
                            }
                        });
                    </script>
        </body>

        </html>