<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>BusTicket System - Bus Ticket Booking System</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
            <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
            <style>
                .hero-section {
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    color: white;
                    padding: 100px 0;
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
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    border: none;
                    padding: 12px 30px;
                    border-radius: 25px;
                }

                .btn-primary:hover {
                    background: linear-gradient(135deg, #5a6fd8 0%, #6a4190 100%);
                }
            </style>
        </head>

        <body>
            <!-- Include header with session logic -->
            <jsp:include page="/views/partials/user-header.jsp" />

            <!-- Hero Section -->
            <section class="hero-section">
                <div class="container">
                    <div class="row">
                        <div class="col-lg-8 mx-auto">
                            <h1 class="display-4 fw-bold mb-4">
                                <i class="fas fa-bus me-3"></i>BusTicket System
                            </h1>
                            <c:choose>
                                <c:when test="${empty sessionScope.user}">
                                    <p class="lead mb-5">Modern, convenient and secure bus ticket management and booking
                                        system</p>
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
                                    <p class="lead mb-5">Welcome ${sessionScope.fullName}! Modern, convenient and secure
                                        bus ticket management and booking system</p>
                                    <div class="d-flex justify-content-center gap-3">
                                        <a href="${pageContext.request.contextPath}/routes"
                                            class="btn btn-light btn-lg">
                                            <i class="fas fa-search me-2"></i>Find Routes
                                        </a>
                                        <a href="${pageContext.request.contextPath}/tickets"
                                            class="btn btn-outline-light btn-lg">
                                            <i class="fas fa-ticket-alt me-2"></i>My Tickets
                                        </a>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Features Section -->
            <section class="py-5">
                <div class="container">
                    <div class="row text-center mb-5">
                        <div class="col-lg-8 mx-auto">
                            <h2 class="fw-bold mb-3">Outstanding Features</h2>
                            <p class="text-muted">The system is designed with the most modern features</p>
                        </div>
                    </div>
                    <div class="row g-4">
                        <div class="col-md-4">
                            <div class="card feature-card h-100 text-center p-4">
                                <div class="card-body">
                                    <div class="mb-3">
                                        <i class="fas fa-route fa-3x text-primary"></i>
                                    </div>
                                    <h5 class="card-title">Route Management</h5>
                                    <p class="card-text">Manage all bus routes with detailed information about
                                        departure,
                                        destination, time and ticket prices.</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card feature-card h-100 text-center p-4">
                                <div class="card-body">
                                    <div class="mb-3">
                                        <i class="fas fa-users fa-3x text-success"></i>
                                    </div>
                                    <h5 class="card-title">User Management</h5>
                                    <p class="card-text">User management system with clear role permissions: Admin,
                                        Staff, Customer, Driver.</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card feature-card h-100 text-center p-4">
                                <div class="card-body">
                                    <div class="mb-3">
                                        <i class="fas fa-ticket-alt fa-3x text-warning"></i>
                                    </div>
                                    <h5 class="card-title">Online Booking</h5>
                                    <p class="card-text">Quick and convenient ticket booking with secure and safe
                                        payment system.</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card feature-card h-100 text-center p-4">
                                <div class="card-body">
                                    <div class="mb-3">
                                        <i class="fas fa-user-tie fa-3x text-info"></i>
                                    </div>
                                    <h5 class="card-title">Driver Management</h5>
                                    <p class="card-text">Manage driver information, licenses and driving experience
                                        professionally.</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card feature-card h-100 text-center p-4">
                                <div class="card-body">
                                    <div class="mb-3">
                                        <i class="fas fa-map-marker-alt fa-3x text-danger"></i>
                                    </div>
                                    <h5 class="card-title">Station Management</h5>
                                    <p class="card-text">Manage bus stations with accurate address and location
                                        information.</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card feature-card h-100 text-center p-4">
                                <div class="card-body">
                                    <div class="mb-3">
                                        <i class="fas fa-chart-bar fa-3x text-secondary"></i>
                                    </div>
                                    <h5 class="card-title">Statistical Reports</h5>
                                    <p class="card-text">Detailed reports on revenue, ticket sales and operational
                                        performance.</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Quick Actions -->
            <section class="py-5 bg-light">
                <div class="container">
                    <div class="row text-center mb-5">
                        <div class="col-lg-8 mx-auto">
                            <h2 class="fw-bold mb-3">Quick Access</h2>
                            <p class="text-muted">Main system functions</p>
                        </div>
                    </div>
                    <div class="row g-3">
                        <div class="col-md-3">
                            <a href="${pageContext.request.contextPath}/routes"
                                class="btn btn-outline-primary w-100 py-3">
                                <i class="fas fa-route d-block mb-2 fa-2x"></i>
                                Routes
                            </a>
                        </div>
                        <div class="col-md-3">
                            <a href="${pageContext.request.contextPath}/buses"
                                class="btn btn-outline-success w-100 py-3">
                                <i class="fas fa-bus d-block mb-2 fa-2x"></i>
                                Buses
                            </a>
                        </div>
                        <div class="col-md-3">
                            <a href="${pageContext.request.contextPath}/passengers"
                                class="btn btn-outline-info w-100 py-3">
                                <i class="fas fa-users d-block mb-2 fa-2x"></i>
                                Users
                            </a>
                        </div>
                        <div class="col-md-3">
                            <a href="${pageContext.request.contextPath}/tickets"
                                class="btn btn-outline-warning w-100 py-3">
                                <i class="fas fa-ticket-alt d-block mb-2 fa-2x"></i>
                                Tickets
                            </a>
                        </div>
                        <div class="col-md-3">
                            <a href="${pageContext.request.contextPath}/drivers"
                                class="btn btn-outline-danger w-100 py-3">
                                <i class="fas fa-user-tie d-block mb-2 fa-2x"></i>
                                Drivers
                            </a>
                        </div>
                        <div class="col-md-3">
                            <a href="${pageContext.request.contextPath}/stations"
                                class="btn btn-outline-secondary w-100 py-3">
                                <i class="fas fa-map-marker-alt d-block mb-2 fa-2x"></i>
                                Stations
                            </a>
                        </div>
                        <c:choose>
                            <c:when test="${empty sessionScope.user}">
                                <div class="col-md-3">
                                    <a href="${pageContext.request.contextPath}/auth/login"
                                        class="btn btn-outline-dark w-100 py-3">
                                        <i class="fas fa-sign-in-alt d-block mb-2 fa-2x"></i>
                                        Login
                                    </a>
                                </div>
                                <div class="col-md-3">
                                    <a href="${pageContext.request.contextPath}/auth/register"
                                        class="btn btn-outline-primary w-100 py-3">
                                        <i class="fas fa-user-plus d-block mb-2 fa-2x"></i>
                                        Register
                                    </a>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="col-md-3">
                                    <a href="${pageContext.request.contextPath}/auth/profile"
                                        class="btn btn-outline-dark w-100 py-3">
                                        <i class="fas fa-user d-block mb-2 fa-2x"></i>
                                        Profile
                                    </a>
                                </div>
                                <div class="col-md-3">
                                    <a href="${pageContext.request.contextPath}/tickets"
                                        class="btn btn-outline-primary w-100 py-3">
                                        <i class="fas fa-ticket-alt d-block mb-2 fa-2x"></i>
                                        My Tickets
                                    </a>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </section>

            <!-- Footer -->
            <footer class="bg-dark text-white py-4">
                <div class="container">
                    <div class="row">
                        <div class="col-md-6">
                            <h5><i class="fas fa-bus me-2"></i>BusTicket System</h5>
                            <p class="mb-0">Professional bus ticket management and booking system</p>
                        </div>
                        <div class="col-md-6 text-md-end">
                            <p class="mb-0">&copy; 2024 BusTicket System. All rights reserved.</p>
                        </div>
                    </div>
                </div>
            </footer>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>