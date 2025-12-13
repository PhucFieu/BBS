<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style>
    /* Admin Header Styles */
    .admin-navbar {
        background: linear-gradient(135deg, #27ae60 0%, #229954 100%) !important;
        box-shadow: 0 2px 10px rgba(39, 174, 96, 0.3);
        padding: 0.75rem 0;
    }

    .admin-navbar .navbar-brand {
        color: white !important;
        font-weight: 700;
        font-size: 1.25rem;
        text-decoration: none;
    }

    .admin-navbar .navbar-brand:hover {
        color: rgba(255, 255, 255, 0.9) !important;
    }

    .admin-navbar .nav-link {
        color: rgba(255, 255, 255, 0.9) !important;
        font-weight: 500;
        padding: 0.5rem 0.75rem !important;
        border-radius: 6px;
        transition: all 0.2s ease;
        margin: 0 2px;
        font-size: 0.9rem;
    }

    .admin-navbar .nav-link:hover {
        color: white !important;
        background: rgba(255, 255, 255, 0.15);
        transform: translateY(-1px);
    }

    .admin-navbar .nav-link.active {
        color: white !important;
        background: rgba(255, 255, 255, 0.2);
        font-weight: 600;
    }

    .admin-badge {
        background: rgba(255, 255, 255, 0.25);
        color: white;
        padding: 3px 10px;
        border-radius: 12px;
        font-size: 0.7rem;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        border: 1px solid rgba(255, 255, 255, 0.3);
    }

    .admin-navbar .dropdown-menu {
        border: none;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
        border-radius: 8px;
        padding: 0.5rem 0;
        margin-top: 0.5rem;
    }

    .admin-navbar .dropdown-item {
        padding: 0.6rem 1.25rem;
        color: #333;
        transition: all 0.2s ease;
    }

    .admin-navbar .dropdown-item:hover {
        background: linear-gradient(135deg, #e8f8f0 0%, #f5f5f5 100%);
        color: #27ae60;
    }

    .admin-navbar .dropdown-item i {
        width: 20px;
    }

    .admin-navbar .navbar-toggler {
        border-color: rgba(255, 255, 255, 0.5);
    }

    .admin-navbar .navbar-toggler-icon {
        background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 30 30'%3e%3cpath stroke='rgba%28255, 255, 255, 0.9%29' stroke-linecap='round' stroke-miterlimit='10' stroke-width='2' d='M4 7h22M4 15h22M4 23h22'/%3e%3c/svg%3e");
    }

    @media (max-width: 991.98px) {
        .admin-navbar .navbar-nav {
            padding-top: 0.5rem;
        }
        
        .admin-navbar .nav-link {
            padding: 0.75rem 1rem !important;
        }

        .admin-navbar .dropdown-menu {
            background: rgba(255, 255, 255, 0.1);
            box-shadow: none;
        }

        .admin-navbar .dropdown-item {
            color: white;
        }

        .admin-navbar .dropdown-item:hover {
            background: rgba(255, 255, 255, 0.15);
            color: white;
        }
    }
</style>

<nav class="navbar navbar-expand-lg admin-navbar">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/admin/dashboard">
            <i class="fas fa-cog me-2"></i>Admin Panel
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#adminNavbar"
            aria-controls="adminNavbar" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="adminNavbar">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">
                        <i class="fas fa-tachometer-alt me-1"></i>Dashboard
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/admin/users">
                        <i class="fas fa-users me-1"></i>Passengers
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/routes">
                        <i class="fas fa-route me-1"></i>Routes
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/admin/buses">
                        <i class="fas fa-bus me-1"></i>Buses
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/admin/stations">
                        <i class="fas fa-map-marker-alt me-1"></i>Stations
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/admin/drivers">
                        <i class="fas fa-user-tie me-1"></i>Drivers
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/admin/tickets">
                        <i class="fas fa-ticket-alt me-1"></i>Tickets
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/admin/schedules">
                        <i class="fas fa-calendar-alt me-1"></i>Schedules
                    </a>
                </li>
            </ul>
            <ul class="navbar-nav">
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="adminDropdown" role="button"
                        data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="fas fa-user-shield me-1"></i>
                        <span class="d-none d-md-inline">
                            ${sessionScope.fullName != null ? sessionScope.fullName : sessionScope.username}
                        </span>
                        <span class="admin-badge ms-2">ADMIN</span>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="adminDropdown">
                        <li>
                            <a class="dropdown-item" href="${pageContext.request.contextPath}/auth/profile">
                                <i class="fas fa-user-circle me-2 text-primary"></i>Profile
                            </a>
                        </li>
                        <li>
                            <a class="dropdown-item" href="${pageContext.request.contextPath}/auth/change-password">
                                <i class="fas fa-key me-2 text-warning"></i>Change Password
                            </a>
                        </li>
                        <li><hr class="dropdown-divider"></li>
                        <li>
                            <a class="dropdown-item" href="${pageContext.request.contextPath}/auth/logout">
                                <i class="fas fa-sign-out-alt me-2 text-danger"></i>Logout
                            </a>
                        </li>
                    </ul>
                </li>
            </ul>
        </div>
    </div>
</nav>
