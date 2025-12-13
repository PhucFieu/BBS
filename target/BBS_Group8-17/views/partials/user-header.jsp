<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style>
    /* User Header Styles */
    .user-navbar {
        background: linear-gradient(135deg, #27ae60 0%, #229954 100%) !important;
        box-shadow: 0 2px 10px rgba(39, 174, 96, 0.3);
        padding: 0.75rem 0;
    }

    .user-navbar .navbar-brand {
        color: white !important;
        font-weight: 700;
        font-size: 1.25rem;
        text-decoration: none;
    }

    .user-navbar .navbar-brand:hover {
        color: rgba(255, 255, 255, 0.9) !important;
    }

    .user-navbar .nav-link {
        color: rgba(255, 255, 255, 0.9) !important;
        font-weight: 500;
        padding: 0.5rem 1rem !important;
        border-radius: 6px;
        transition: all 0.2s ease;
        margin: 0 2px;
    }

    .user-navbar .nav-link:hover {
        color: white !important;
        background: rgba(255, 255, 255, 0.15);
        transform: translateY(-1px);
    }

    .user-navbar .nav-link.active {
        color: white !important;
        background: rgba(255, 255, 255, 0.2);
        font-weight: 600;
    }

    .user-navbar .dropdown-menu {
        border: none;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
        border-radius: 8px;
        padding: 0.5rem 0;
        margin-top: 0.5rem;
    }

    .user-navbar .dropdown-item {
        padding: 0.6rem 1.25rem;
        color: #333;
        transition: all 0.2s ease;
    }

    .user-navbar .dropdown-item:hover {
        background: linear-gradient(135deg, #e8f8f0 0%, #f5f5f5 100%);
        color: #27ae60;
    }

    .user-navbar .dropdown-item i {
        width: 20px;
    }

    .user-navbar .navbar-toggler {
        border-color: rgba(255, 255, 255, 0.5);
    }

    .user-navbar .navbar-toggler-icon {
        background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 30 30'%3e%3cpath stroke='rgba%28255, 255, 255, 0.9%29' stroke-linecap='round' stroke-miterlimit='10' stroke-width='2' d='M4 7h22M4 15h22M4 23h22'/%3e%3c/svg%3e");
    }

    .user-navbar .btn-outline-light:hover {
        background: rgba(255, 255, 255, 0.2);
    }

    @media (max-width: 991.98px) {
        .user-navbar .navbar-nav {
            padding-top: 0.5rem;
        }
        
        .user-navbar .nav-link {
            padding: 0.75rem 1rem !important;
        }

        .user-navbar .dropdown-menu {
            background: rgba(255, 255, 255, 0.1);
            box-shadow: none;
        }

        .user-navbar .dropdown-item {
            color: white;
        }

        .user-navbar .dropdown-item:hover {
            background: rgba(255, 255, 255, 0.15);
            color: white;
        }
    }
</style>

<nav class="navbar navbar-expand-lg user-navbar">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/">
            <i class="fas fa-bus me-2"></i>Bus Booking System
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#userNavbar"
            aria-controls="userNavbar" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="userNavbar">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <!-- Only show these links for ADMIN or DRIVER -->
                <c:if test="${sessionScope.role == 'ADMIN' || sessionScope.role == 'DRIVER'}">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/routes">
                            <i class="fas fa-route me-1"></i>Routes
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/buses">
                            <i class="fas fa-bus me-1"></i>Buses
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/passengers">
                            <i class="fas fa-users me-1"></i>Passengers
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/tickets">
                            <i class="fas fa-ticket-alt me-1"></i>Tickets
                        </a>
                    </li>
                </c:if>
                <!-- For USER, show home, search, tickets, and ratings -->
                <c:if test="${sessionScope.role == 'USER' || empty sessionScope.role}">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/">
                            <i class="fas fa-home me-1"></i>Home
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/search">
                            <i class="fas fa-search me-1"></i>Search Routes
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/tickets">
                            <i class="fas fa-ticket-alt me-1"></i>My Tickets
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/tickets/rate/list">
                            <i class="fas fa-star me-1"></i>My Ratings
                        </a>
                    </li>
                </c:if>
                <!-- Staff Panel link for STAFF users -->
                <c:if test="${sessionScope.role == 'STAFF'}">
                    <li class="nav-item">
                        <a class="nav-link btn btn-outline-light btn-sm ms-2" href="${pageContext.request.contextPath}/staff/dashboard">
                            <i class="fas fa-headset me-1"></i>Staff Panel
                        </a>
                    </li>
                </c:if>
            </ul>
            <ul class="navbar-nav">
                <c:choose>
                    <c:when test="${empty sessionScope.user}">
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/auth/login">
                                <i class="fas fa-sign-in-alt me-1"></i>Login
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/auth/register">
                                <i class="fas fa-user-plus me-1"></i>Register
                            </a>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" id="userDropdownMenu" role="button" 
                               data-bs-toggle="dropdown" aria-expanded="false">
                                <i class="fas fa-user me-1"></i>${sessionScope.fullName}
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdownMenu">
                                <li>
                                    <a class="dropdown-item" href="${pageContext.request.contextPath}/auth/profile">
                                        <i class="fas fa-id-card me-2 text-primary"></i>Profile
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
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </div>
</nav>
