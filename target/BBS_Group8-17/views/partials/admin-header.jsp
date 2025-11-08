<%@ taglib prefix="c" uri="jakarta.tags.core" %>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/admin/dashboard">
                <i class="fas fa-cog me-2"></i>Admin Panel
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item"><a class="nav-link"
                            href="${pageContext.request.contextPath}/admin/dashboard"><i
                                class="fas fa-tachometer-alt me-1"></i>Dashboard</a></li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/users"><i
                                class="fas fa-users me-1"></i>Users</a></li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/routes"><i
                                class="fas fa-route me-1"></i>Routes</a></li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/buses"><i
                                class="fas fa-bus me-1"></i>Buses</a></li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/tickets"><i
                                class="fas fa-ticket-alt me-1"></i>Tickets</a></li>
                </ul>
                <ul class="navbar-nav">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button"
                            data-bs-toggle="dropdown">
                            <i class="fas fa-user me-1"></i>${sessionScope.username}
                            <span class="admin-badge ms-1">ADMIN</span>
                        </a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item"
                                    href="${pageContext.request.contextPath}/auth/profile">Profile</a></li>
                            <li><a class="dropdown-item"
                                    href="${pageContext.request.contextPath}/auth/change-password">Change
                                    Password</a></li>
                            <li>
                                <hr class="dropdown-divider">
                            </li>
                            <li><a class="dropdown-item"
                                    href="${pageContext.request.contextPath}/auth/logout">Logout</a></li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
    </nav>