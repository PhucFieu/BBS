<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <jsp:include page="/views/partials/head.jsp">
                    <jsp:param name="title" value="Home - Bus Ticket Booking" />
                </jsp:include>
                <style>
                    .hero-section {
                        background: linear-gradient(135deg, #66bb6a 0%, #81c784 100%);
                        color: white;
                        padding: 80px 0;
                        text-align: center;
                    }

                    .feature-card {
                        transition: transform 0.3s ease;
                        border: none;
                        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                    }

                    .feature-card:hover {
                        transform: translateY(-5px);
                    }

                    .btn-primary {
                        background: linear-gradient(135deg, #66bb6a 0%, #81c784 100%);
                        border: none;
                        padding: 12px 30px;
                        border-radius: 25px;
                    }

                    .btn-primary:hover {
                        background: linear-gradient(135deg, #4caf50 0%, #66bb6a 100%);
                    }
                </style>
            </head>

            <body>
                <%@ include file="/views/partials/user-header.jsp" %>

                    <!-- Hero Section -->
                    <section class="hero-section">
                        <div class="container">
                            <div class="row">
                                <div class="col-lg-8 mx-auto">
                                    <h1 class="display-5 fw-bold mb-3">
                                        <i class="fas fa-bus me-3"></i>Bus Booking System
                                    </h1>
                                    <c:choose>
                                        <c:when test="${empty sessionScope.user}">
                                            <p class="lead mb-4">Modern, convenient and secure bus ticket booking</p>
                                            <div class="d-flex justify-content-center gap-3">
                                                <a href="${pageContext.request.contextPath}/routes"
                                                    class="btn btn-light btn-lg">
                                                    <i class="fas fa-search me-2"></i>Find Routes
                                                </a>
                                                <a href="${pageContext.request.contextPath}/auth/register"
                                                    class="btn btn-outline-light btn-lg">
                                                    <i class="fas fa-user-plus me-2"></i>Register Now
                                                </a>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <p class="lead mb-4">Welcome ${sessionScope.fullName}! Plan your next trip
                                                easily</p>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </section>

                    <!-- Popular Routes -->
                    <section class="py-5 bg-light">
                        <div class="container">
                            <h3 class="text-center mb-4">Popular Routes</h3>
                            <div class="row">
                                <c:forEach var="route" items="${popularRoutes}">
                                    <div class="col-md-4 mb-4">
                                        <div class="card h-100">
                                            <div class="card-body">
                                                <h5 class="card-title">${route.routeName}</h5>
                                                <p class="text-muted small">ID: ${route.routeId}</p>
                                                <p class="card-text">
                                                    <i class="fas fa-map-marker-alt text-primary"></i>
                                                    ${route.departureCity}
                                                    <i class="fas fa-arrow-right mx-2"></i>
                                                    <i class="fas fa-map-marker-alt text-danger"></i>
                                                    ${route.destinationCity}
                                                </p>
                                                <p class="card-text">
                                                    <i class="fas fa-road"></i> Distance: ${route.distance} km<br>
                                                    <i class="fas fa-clock"></i> Duration: ${route.durationHours}
                                                    hours<br>
                                                    <i class="fas fa-money-bill"></i> Price:
                                                    <fmt:formatNumber value="${route.basePrice}" pattern="#,#00" />₫
                                                </p>
                                                <c:choose>
                                                    <c:when test="${empty sessionScope.user}">
                                                        <button class="btn btn-primary w-100"
                                                            onclick="showLoginPrompt()">
                                                            <i class="fas fa-ticket-alt"></i> Book Now
                                                        </button>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <a href="${pageContext.request.contextPath}/tickets/book?routeId=${route.routeId}"
                                                            class="btn btn-primary w-100">
                                                            <i class="fas fa-ticket-alt"></i> Book Now
                                                        </a>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </section>

                    <!-- Route List -->
                    <section class="py-5">
                        <div class="container">
                            <h3 class="text-center mb-4">Route List</h3>
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead class="table-dark">
                                        <tr>
                                            <th>Route ID</th>
                                            <th>From</th>
                                            <th>To</th>
                                            <th>Distance</th>
                                            <th>Duration</th>
                                            <th>Price</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="route" items="${routes}">
                                            <tr>
                                                <td>${route.routeId}</td>
                                                <td>${route.departureCity}</td>
                                                <td>${route.destinationCity}</td>
                                                <td>${route.distance} km</td>
                                                <td>${route.durationHours} hours</td>
                                                <td>
                                                    <fmt:formatNumber value="${route.basePrice}" pattern="#,###" />₫
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${empty sessionScope.user}">
                                                            <button class="btn btn-primary w-100"
                                                                onclick="showLoginPrompt()">
                                                                <i class="fas fa-ticket-alt"></i> Book Now
                                                            </button>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <a href="${pageContext.request.contextPath}/tickets/book?routeId=${route.routeId}"
                                                                class="btn btn-primary w-100">
                                                                <i class="fas fa-ticket-alt"></i> Book Now
                                                            </a>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </section>



                    <%@ include file="/views/partials/footer.jsp" %>

                        <script>
                            function showLoginPrompt() {
                                if (confirm("You need to login to book tickets. Go to login page?")) {
                                    window.location.href = "${pageContext.request.contextPath}/auth/login";
                                }
                            }
                        </script>

            </body>

            </html>