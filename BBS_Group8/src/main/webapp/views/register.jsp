<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Register - BusTicket System</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    </head>

    <body>
        <div class="container mt-5">
            <div class="row justify-content-center">
                <div class="col-md-6">
                    <div class="card">
                        <div class="card-header bg-primary text-white text-center position-relative">
                            <a href="${pageContext.request.contextPath}/"
                                class="btn btn-outline-light btn-sm position-absolute top-0 start-0 m-2">
                                <i class="fas fa-home me-1"></i>Home
                            </a>
                            <h3><i class="fas fa-user-plus me-2"></i>Register Account</h3>
                        </div>
                        <div class="card-body">
                            <% String error=request.getParameter("error"); %>
                                <% String message=request.getParameter("message"); %>

                                    <% if (error !=null) { %>
                                        <div class="alert alert-danger" role="alert">
                                            <i class="fas fa-exclamation-triangle me-2"></i>
                                            <%= error %>
                                        </div>
                                        <% } %>

                                            <% if (message !=null) { %>
                                                <div class="alert alert-success" role="alert">
                                                    <i class="fas fa-check-circle me-2"></i>
                                                    <%= message %>
                                                </div>
                                                <% } %>

                                                    <form action="${pageContext.request.contextPath}/auth/register"
                                                        method="POST">
                                                        <div class="mb-3">
                                                            <label for="username" class="form-label">Username *</label>
                                                            <input type="text" class="form-control" id="username"
                                                                name="username" required>
                                                        </div>

                                                        <div class="mb-3">
                                                            <label for="email" class="form-label">Email *</label>
                                                            <input type="email" class="form-control" id="email"
                                                                name="email" required>
                                                        </div>

                                                        <div class="mb-3">
                                                            <label for="password" class="form-label">Password *</label>
                                                            <input type="password" class="form-control" id="password"
                                                                name="password" required>
                                                        </div>

                                                        <div class="mb-3">
                                                            <label for="confirmPassword" class="form-label">Confirm
                                                                Password *</label>
                                                            <input type="password" class="form-control"
                                                                id="confirmPassword" name="confirmPassword" required>
                                                        </div>

                                                        <div class="mb-3">
                                                            <label for="fullName" class="form-label">Full Name *</label>
                                                            <input type="text" class="form-control" id="fullName"
                                                                name="fullName" required>
                                                        </div>

                                                        <div class="mb-3">
                                                            <label for="phone" class="form-label">Phone Number *</label>
                                                            <input type="tel" class="form-control" id="phone"
                                                                name="phone" required>
                                                        </div>

                                                        <div class="mb-3">
                                                            <label for="idCard" class="form-label">ID Card *</label>
                                                            <input type="text" class="form-control" id="idCard"
                                                                name="idCard" required>
                                                        </div>

                                                        <div class="mb-3">
                                                            <label for="address" class="form-label">Address *</label>
                                                            <textarea class="form-control" id="address" name="address"
                                                                rows="3" required></textarea>
                                                        </div>

                                                        <div class="mb-3">
                                                            <label for="dateOfBirth" class="form-label">Date of Birth
                                                                *</label>
                                                            <input type="date" class="form-control" id="dateOfBirth"
                                                                name="dateOfBirth" required>
                                                        </div>

                                                        <div class="mb-3">
                                                            <label for="gender" class="form-label">Gender *</label>
                                                            <select class="form-control" id="gender" name="gender"
                                                                required>
                                                                <option value="">Select gender</option>
                                                                <option value="MALE">Male</option>
                                                                <option value="FEMALE">Female</option>
                                                                <option value="OTHER">Other</option>
                                                            </select>
                                                        </div>

                                                        <button type="submit" class="btn btn-primary w-100">
                                                            <i class="fas fa-user-plus me-2"></i>Register
                                                        </button>
                                                    </form>

                                                    <div class="text-center mt-3">
                                                        <p>Already have an account? <a
                                                                href="${pageContext.request.contextPath}/auth/login">Login
                                                                now</a></p>
                                                    </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>

    </html>