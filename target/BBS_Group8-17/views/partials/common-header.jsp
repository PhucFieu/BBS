<%@ taglib prefix="c" uri="jakarta.tags.core" %>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand" href="/Bus/">
                <i class="fas fa-bus me-2"></i>BusTicket System
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
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
                    </c:if>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/tickets">
                            <i class="fas fa-ticket-alt me-1"></i>Tickets
                        </a>
                    </li>
                </ul>
                <ul class="navbar-nav ms-auto">
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
                                <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button"
                                    data-bs-toggle="dropdown" aria-expanded="false">
                                    <i class="fas fa-user me-1"></i>${sessionScope.fullName}
                                </a>
                                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                                    <li>
                                        <a class="dropdown-item" href="${pageContext.request.contextPath}/auth/profile">
                                            <i class="fas fa-id-card me-2"></i>Profile
                                        </a>
                                    </li>
                                    <li>
                                        <a class="dropdown-item"
                                            href="${pageContext.request.contextPath}/auth/change-password">
                                            <i class="fas fa-key me-2"></i>Change Password
                                        </a>
                                    </li>
                                    <li>
                                        <hr class="dropdown-divider">
                                    </li>
                                    <li>
                                        <a class="dropdown-item" href="${pageContext.request.contextPath}/auth/logout">
                                            <i class="fas fa-sign-out-alt me-2"></i>Logout
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