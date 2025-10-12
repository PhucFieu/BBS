<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <jsp:include page="/views/partials/head.jsp">
                <jsp:param name="title" value="User Profile - BusTicket System" />
            </jsp:include>
            <!-- Profile specific CSS -->
            <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/profile.css">
        </head>

        <body>
            <!-- Home Button -->
            <div class="container mt-3">
                <a href="${pageContext.request.contextPath}/" class="btn btn-primary">
                    <i class="fas fa-home me-2"></i>Home
                </a>
            </div>

            <!-- Profile Header -->
            <div class="profile-header">
                <div class="container">
                    <div class="row align-items-center">
                        <div class="col-md-3 text-center">
                            <div class="profile-avatar">
                                <i class="fas fa-user"></i>
                            </div>
                        </div>
                        <div class="col-md-9">
                            <h1 class="mb-2">${user.fullName}</h1>
                            <p class="mb-2"><i class="fas fa-at me-2"></i>${user.username}</p>
                            <p class="mb-3"><i class="fas fa-envelope me-2"></i>${user.email}</p>
                            <span class="role-badge role-${user.role.toLowerCase()}">
                                <i class="fas fa-user-tag me-1"></i>${user.role}
                            </span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Main Content -->
            <div class="container">
                <!-- Success/Error Messages -->
                <c:if test="${not empty param.message}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle me-2"></i>${param.message}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <c:if test="${not empty param.error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-circle me-2"></i>${param.error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
                <div class="row">
                    <!-- Profile Information -->
                    <div class="col-lg-8">
                        <div class="card profile-card">
                            <div class="card-header bg-primary text-white">
                                <h5 class="mb-0"><i class="fas fa-user-edit me-2"></i>Profile Information</h5>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="profile-section">
                                            <h6 class="text-muted mb-2">Username</h6>
                                            <p class="mb-0 fw-bold">${user.username}</p>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="profile-section">
                                            <h6 class="text-muted mb-2">Full Name</h6>
                                            <p class="mb-0 fw-bold">${user.fullName}</p>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="profile-section">
                                            <h6 class="text-muted mb-2">Email</h6>
                                            <p class="mb-0 fw-bold">${user.email}</p>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="profile-section">
                                            <h6 class="text-muted mb-2">Role</h6>
                                            <span class="role-badge role-${user.role.toLowerCase()}">${user.role}</span>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="profile-section">
                                            <h6 class="text-muted mb-2">Status</h6>
                                            <span
                                                class="badge ${user.status == 'ACTIVE' ? 'bg-success' : 'bg-danger'}">${user.status}</span>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="profile-section">
                                            <h6 class="text-muted mb-2">Member Since</h6>
                                            <p class="mb-0 fw-bold">
                                                ${user.createdDateStr}
                                            </p>
                                        </div>
                                    </div>
                                </div>
                                <c:if test="${not empty user.lastLogin}">
                                    <div class="row">
                                        <div class="col-12">
                                            <div class="profile-section">
                                                <h6 class="text-muted mb-2">Last Login</h6>
                                                <p class="mb-0 fw-bold">
                                                    ${user.lastLoginStr}
                                                </p>
                                            </div>
                                        </div>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>

                    <!-- Quick Actions Sidebar -->
                    <div class="col-lg-4">
                        <div class="card profile-card">
                            <div class="card-header bg-success text-white">
                                <h5 class="mb-0"><i class="fas fa-cogs me-2"></i>Quick Actions</h5>
                            </div>
                            <div class="card-body">
                                <div class="d-grid gap-2">
                                    <button class="btn btn-primary btn-edit" onclick="editProfile()">
                                        <i class="fas fa-edit me-2"></i>Edit Profile
                                    </button>
                                    <a href="${pageContext.request.contextPath}/auth/change-password"
                                        class="btn btn-outline-secondary">
                                        <i class="fas fa-key me-2"></i>Change Password
                                    </a>
                                    <a href="${pageContext.request.contextPath}/tickets" class="btn btn-outline-info">
                                        <i class="fas fa-ticket-alt me-2"></i>My Tickets
                                    </a>
                                </div>
                            </div>
                        </div>

                        <!-- Recent Activity -->
                        <div class="card profile-card mt-3">
                            <div class="card-header bg-info text-white">
                                <h5 class="mb-0"><i class="fas fa-history me-2"></i>Recent Activity</h5>
                            </div>
                            <div class="card-body">
                                <div class="activity-item">
                                    <div class="activity-icon">
                                        <i class="fas fa-sign-in-alt text-primary"></i>
                                    </div>
                                    <div class="activity-content">
                                        <div class="activity-title">Login Successful</div>
                                        <div class="activity-time">Just now</div>
                                    </div>
                                </div>
                                <div class="activity-item">
                                    <div class="activity-icon">
                                        <i class="fas fa-user-edit text-success"></i>
                                    </div>
                                    <div class="activity-content">
                                        <div class="activity-title">Updated Information</div>
                                        <div class="activity-time">2 hours ago</div>
                                    </div>
                                </div>
                                <div class="activity-item">
                                    <div class="activity-icon">
                                        <i class="fas fa-ticket-alt text-warning"></i>
                                    </div>
                                    <div class="activity-content">
                                        <div class="activity-title">New Ticket Booking</div>
                                        <div class="activity-time">1 day ago</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Edit Profile Modal -->
            <div class="modal fade" id="editProfileModal" tabindex="-1">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">Edit Profile</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <form action="${pageContext.request.contextPath}/auth/update-profile" method="post">
                            <div class="modal-body">
                                <div class="mb-3">
                                    <label for="fullName" class="form-label">Full Name</label>
                                    <input type="text" class="form-control" id="fullName" name="fullName"
                                        value="${user.fullName}" required>
                                </div>
                                <div class="mb-3">
                                    <label for="email" class="form-label">Email</label>
                                    <input type="email" class="form-control" id="email" name="email"
                                        value="${user.email}" required>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                <button type="submit" class="btn btn-primary">Save Changes</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Bootstrap JS -->
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"
                integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL"
                crossorigin="anonymous"></script>

            <!-- Profile specific JavaScript -->
            <script src="${pageContext.request.contextPath}/assets/js/profile.js"></script>
        </body>

        </html>