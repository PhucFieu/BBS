<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <style>
        /* Staff Header Styles */
        .staff-navbar {
            background: linear-gradient(135deg, #27ae60 0%, #229954 100%) !important;
            box-shadow: 0 2px 10px rgba(39, 174, 96, 0.3);
            padding: 0.75rem 0;
        }

        .staff-navbar .navbar-brand {
            color: white !important;
            font-weight: 700;
            font-size: 1.25rem;
            text-decoration: none;
        }

        .staff-navbar .navbar-brand:hover {
            color: rgba(255, 255, 255, 0.9) !important;
        }

        .staff-navbar .nav-link {
            color: rgba(255, 255, 255, 0.9) !important;
            font-weight: 500;
            padding: 0.5rem 1rem !important;
            border-radius: 6px;
            transition: all 0.2s ease;
            margin: 0 2px;
        }

        .staff-navbar .nav-link:hover {
            color: white !important;
            background: rgba(255, 255, 255, 0.15);
            transform: translateY(-1px);
        }

        .staff-navbar .nav-link.active {
            color: white !important;
            background: rgba(255, 255, 255, 0.2);
            font-weight: 600;
        }

        .staff-badge {
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

        .staff-navbar .dropdown-menu {
            border: none;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
            border-radius: 8px;
            padding: 0.5rem 0;
            margin-top: 0.5rem;
        }

        .staff-navbar .dropdown-item {
            padding: 0.6rem 1.25rem;
            color: #333;
            transition: all 0.2s ease;
        }

        .staff-navbar .dropdown-item:hover {
            background: linear-gradient(135deg, #e8f8f0 0%, #f5f5f5 100%);
            color: #27ae60;
        }

        .staff-navbar .dropdown-item i {
            width: 20px;
        }

        .staff-navbar .dropdown-divider {
            margin: 0.25rem 0;
        }

        .staff-navbar .navbar-toggler {
            border-color: rgba(255, 255, 255, 0.5);
        }

        .staff-navbar .navbar-toggler-icon {
            background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 30 30'%3e%3cpath stroke='rgba%28255, 255, 255, 0.9%29' stroke-linecap='round' stroke-miterlimit='10' stroke-width='2' d='M4 7h22M4 15h22M4 23h22'/%3e%3c/svg%3e");
        }

        @media (max-width: 991.98px) {
            .staff-navbar .navbar-nav {
                padding-top: 0.5rem;
            }

            .staff-navbar .nav-link {
                padding: 0.75rem 1rem !important;
            }

            .staff-navbar .dropdown-menu {
                background: rgba(255, 255, 255, 0.1);
                box-shadow: none;
            }

            .staff-navbar .dropdown-item {
                color: white;
            }

            .staff-navbar .dropdown-item:hover {
                background: rgba(255, 255, 255, 0.15);
                color: white;
            }
        }
    </style>

    <nav class="navbar navbar-expand-lg staff-navbar">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/staff/dashboard">
                <i class="fas fa-headset me-2"></i>Staff Panel
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#staffNavbar"
                aria-controls="staffNavbar" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="staffNavbar">
                <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                    <li class="nav-item">
                        <a class="nav-link ${requestScope['javax.servlet.forward.servlet_path'] == '/staff/dashboard' ? 'active' : ''}"
                            href="${pageContext.request.contextPath}/staff/dashboard">
                            <i class="fas fa-tachometer-alt me-1"></i>Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${requestScope['javax.servlet.forward.servlet_path'] == '/staff/search-schedules' ? 'active' : ''}"
                            href="${pageContext.request.contextPath}/staff/search-schedules">
                            <i class="fas fa-search me-1"></i>Search Schedules
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${requestScope['javax.servlet.forward.servlet_path'] == '/staff/tickets' ? 'active' : ''}"
                            href="${pageContext.request.contextPath}/staff/tickets">
                            <i class="fas fa-ticket-alt me-1"></i>Ticket Lookup
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${requestScope['javax.servlet.forward.servlet_path'] == '/staff/check-in' ? 'active' : ''}"
                            href="${pageContext.request.contextPath}/staff/check-in">
                            <i class="fas fa-user-check me-1"></i>Checked-in
                        </a>
                    </li>
                </ul>
                <ul class="navbar-nav">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="staffDropdown" role="button"
                            data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="fas fa-user-circle me-1"></i>
                            <span class="d-none d-md-inline">
                                ${sessionScope.fullName != null ? sessionScope.fullName : sessionScope.username}
                            </span>
                            <span class="staff-badge ms-2">STAFF</span>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="staffDropdown">
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
                            <li>
                                <hr class="dropdown-divider">
                            </li>
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