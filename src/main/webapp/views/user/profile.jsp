<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <jsp:include page="/views/partials/head.jsp">
                <jsp:param name="title" value="User Profile - Bus Booking System" />
            </jsp:include>
            <!-- Profile specific CSS -->
            <style>
                /* ===== PROFILE PAGE STYLES ===== */
                :root {
                    --primary-color: #66bb6a;
                    --secondary-color: #81c784;
                    --success-color: #4caf50;
                    --white: #ffffff;
                    --border-radius-xl: 0.75rem;
                    --shadow-sm: 0 0.125rem 0.25rem rgba(102, 187, 106, 0.15);
                    --shadow: 0 0.5rem 1rem rgba(102, 187, 106, 0.2);
                    --shadow-lg: 0 1rem 3rem rgba(102, 187, 106, 0.25);
                    --transition: all 0.3s ease;
                    --gray-100: #e8f5e9;
                    --gray-200: #c8e6c9;
                    --gray-600: #4caf50;
                    --gray-800: #2e7d32;
                }

                /* Profile Header */
                .profile-header {
                    background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
                    color: var(--white);
                    padding: 3rem 0;
                    margin-bottom: 2rem;
                    position: relative;
                    overflow: hidden;
                }

                .profile-header::before {
                    content: '';
                    position: absolute;
                    top: 0;
                    left: 0;
                    right: 0;
                    bottom: 0;
                    background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grain" width="100" height="100" patternUnits="userSpaceOnUse"><circle cx="25" cy="25" r="1" fill="rgba(255,255,255,0.1)"/><circle cx="75" cy="75" r="1" fill="rgba(255,255,255,0.1)"/><circle cx="50" cy="10" r="0.5" fill="rgba(255,255,255,0.1)"/><circle cx="10" cy="60" r="0.5" fill="rgba(255,255,255,0.1)"/><circle cx="90" cy="40" r="0.5" fill="rgba(255,255,255,0.1)"/></pattern></defs><rect width="100" height="100" fill="url(%23grain)"/></svg>');
                    opacity: 0.3;
                }

                .profile-avatar {
                    width: 120px;
                    height: 120px;
                    background: rgba(255, 255, 255, 0.2);
                    border-radius: 50%;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    margin: 0 auto 1rem;
                    border: 4px solid rgba(255, 255, 255, 0.3);
                    backdrop-filter: blur(10px);
                    transition: var(--transition);
                }

                .profile-avatar:hover {
                    transform: scale(1.05);
                    border-color: rgba(255, 255, 255, 0.5);
                }

                .profile-avatar i {
                    font-size: 3rem;
                    color: var(--white);
                }

                /* Profile Card */
                .profile-card {
                    border: none;
                    border-radius: var(--border-radius-xl);
                    box-shadow: var(--shadow-lg);
                    overflow: hidden;
                    transition: var(--transition);
                    background: var(--white);
                }

                .profile-card:hover {
                    transform: translateY(-5px);
                    box-shadow: 0 1.5rem 4rem rgba(0, 0, 0, 0.2);
                }

                .profile-card .card-header {
                    background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
                    color: var(--white);
                    border: none;
                    padding: 1.5rem;
                    position: relative;
                    overflow: hidden;
                }

                .profile-card .card-header::before {
                    content: '';
                    position: absolute;
                    top: -50%;
                    right: -50%;
                    width: 200%;
                    height: 200%;
                    background: radial-gradient(circle, rgba(255, 255, 255, 0.1) 0%, transparent 70%);
                    animation: rotate 20s linear infinite;
                }

                @keyframes rotate {
                    from {
                        transform: rotate(0deg);
                    }

                    to {
                        transform: rotate(360deg);
                    }
                }

                .profile-card .card-header h5 {
                    position: relative;
                    z-index: 1;
                    margin: 0;
                    font-weight: 700;
                    font-size: 1.25rem;
                }

                .profile-card .card-body {
                    padding: 2rem;
                }

                /* Profile Section */
                .profile-section {
                    margin-bottom: 1.5rem;
                    padding: 1rem;
                    background: var(--gray-100);
                    border-radius: var(--border-radius-xl);
                    border-left: 4px solid var(--primary-color);
                    transition: var(--transition);
                }

                .profile-section:hover {
                    background: var(--white);
                    box-shadow: var(--shadow-sm);
                    transform: translateX(5px);
                }

                .profile-section h6 {
                    font-size: 0.875rem;
                    font-weight: 600;
                    margin-bottom: 0.5rem;
                    color: var(--gray-600);
                    text-transform: uppercase;
                    letter-spacing: 0.5px;
                }

                .profile-section p {
                    font-size: 1.1rem;
                    margin: 0;
                    color: var(--gray-800);
                }

                /* Role Badge */
                .role-badge {
                    display: inline-flex;
                    align-items: center;
                    padding: 0.5rem 1rem;
                    border-radius: 2rem;
                    font-weight: 600;
                    font-size: 0.875rem;
                    text-transform: uppercase;
                    letter-spacing: 0.5px;
                    transition: var(--transition);
                }

                .role-admin {
                    background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
                    color: var(--white);
                }

                .role-user {
                    background: linear-gradient(135deg, var(--success-color) 0%, #20c997 100%);
                    color: var(--white);
                }

                .role-badge:hover {
                    transform: scale(1.05);
                    box-shadow: var(--shadow-sm);
                }

                /* Edit Button */
                .btn-edit {
                    background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
                    border: none;
                    padding: 0.875rem 2rem;
                    font-weight: 600;
                    border-radius: 2rem;
                    transition: var(--transition);
                    box-shadow: var(--shadow-sm);
                }

                .btn-edit:hover {
                    transform: translateY(-2px);
                    box-shadow: var(--shadow);
                    background: linear-gradient(135deg, #4caf50 0%, #66bb6a 100%);
                }

                /* Profile Stats */
                .profile-stats {
                    margin-bottom: 2rem;
                }

                .stat-card {
                    background: var(--white);
                    border-radius: var(--border-radius-xl);
                    padding: 1.5rem;
                    text-align: center;
                    box-shadow: var(--shadow-sm);
                    transition: var(--transition);
                    border: 1px solid var(--gray-200);
                }

                .stat-card:hover {
                    transform: translateY(-3px);
                    box-shadow: var(--shadow);
                }

                .stat-number {
                    font-size: 2rem;
                    font-weight: 700;
                    color: var(--primary-color);
                    margin-bottom: 0.5rem;
                }

                .stat-label {
                    color: var(--gray-600);
                    font-weight: 500;
                    text-transform: uppercase;
                    letter-spacing: 0.5px;
                    font-size: 0.875rem;
                }

                /* Profile Actions */
                .profile-actions {
                    background: var(--gray-100);
                    border-radius: var(--border-radius-xl);
                    padding: 1.5rem;
                    margin-top: 2rem;
                }

                .profile-actions .btn {
                    margin: 0.5rem;
                    min-width: 150px;
                }

                /* Activity Items */
                .activity-item {
                    display: flex;
                    align-items: center;
                    padding: 0.75rem 0;
                    border-bottom: 1px solid var(--gray-200);
                    transition: var(--transition);
                }

                .activity-item:last-child {
                    border-bottom: none;
                }

                .activity-item:hover {
                    background: var(--gray-100);
                    border-radius: var(--border-radius-xl);
                    padding-left: 0.5rem;
                    padding-right: 0.5rem;
                }

                .activity-icon {
                    width: 40px;
                    height: 40px;
                    background: var(--gray-100);
                    border-radius: 50%;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    margin-right: 1rem;
                    flex-shrink: 0;
                }

                .activity-content {
                    flex: 1;
                }

                .activity-title {
                    font-weight: 600;
                    color: var(--gray-800);
                    margin-bottom: 0.25rem;
                }

                .activity-time {
                    font-size: 0.875rem;
                    color: var(--gray-600);
                }

                /* Profile Modal */
                #editProfileModal .modal-content {
                    border-radius: var(--border-radius-xl);
                    border: none;
                    box-shadow: var(--shadow-lg);
                }

                #editProfileModal .modal-header {
                    background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
                    color: var(--white);
                    border-radius: var(--border-radius-xl) var(--border-radius-xl) 0 0;
                }

                #editProfileModal .modal-title {
                    font-weight: 700;
                }

                #editProfileModal .form-control {
                    border-radius: var(--border-radius-xl);
                    border: 2px solid var(--gray-200);
                    padding: 0.875rem 1rem;
                    transition: var(--transition);
                }

                #editProfileModal .form-control:focus {
                    border-color: var(--primary-color);
                    box-shadow: 0 0 0 0.2rem rgba(102, 187, 106, 0.25);
                }

                #editProfileModal .btn {
                    border-radius: var(--border-radius-xl);
                    padding: 0.75rem 1.5rem;
                    font-weight: 600;
                }

                /* Responsive Profile */
                @media (max-width: 768px) {
                    .profile-header {
                        padding: 2rem 0;
                    }

                    .profile-avatar {
                        width: 80px;
                        height: 80px;
                    }

                    .profile-avatar i {
                        font-size: 2rem;
                    }

                    .profile-card .card-body {
                        padding: 1.5rem;
                    }

                    .profile-section {
                        margin-bottom: 1rem;
                        padding: 0.75rem;
                    }

                    .stat-card {
                        margin-bottom: 1rem;
                    }

                    .profile-actions .btn {
                        width: 100%;
                        margin: 0.5rem 0;
                    }
                }
            </style>
        </head>

        <body>
            <!-- Header based on role -->
            <c:choose>
                <c:when test="${sessionScope.role == 'ADMIN'}">
                    <%@ include file="/views/partials/admin-header.jsp" %>
                </c:when>
                <c:when test="${sessionScope.role == 'DRIVER' || sessionScope.role == 'DRIVE'}">
                    <%@ include file="/views/partials/driver-header.jsp" %>
                </c:when>
                <c:otherwise>
                    <%@ include file="/views/partials/user-header.jsp" %>
                </c:otherwise>
            </c:choose>

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

            <%@ include file="/views/partials/footer.jsp" %>

                <!-- Profile Page JavaScript -->
                <script src="${pageContext.request.contextPath}/assets/js/profile.js"></script>
        </body>

        </html>