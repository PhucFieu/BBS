<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <jsp:include page="/views/partials/head.jsp">
                <jsp:param name="title" value="Admin Dashboard - Bus Booking System" />
            </jsp:include>
        </head>

        <body>
            <%@ include file="/views/partials/admin-header.jsp" %>

                <!-- Dashboard Header and Stats (copy from your dashboard.jsp) -->
                <div class="container mt-4">
                    <div class="row mb-4">
                        <div class="col-lg-3 col-md-6 mb-3">
                            <div class="stats-card users">
                                <div class="stats-number text-primary">${totalUsers}</div>
                                <div class="stats-label">Total Passengers</div>
                                <div class="mt-2"><i class="fas fa-users fa-2x text-primary opacity-50"></i></div>
                            </div>
                        </div>
                        <div class="col-lg-3 col-md-6 mb-3">
                            <div class="stats-card routes">
                                <div class="stats-number text-success">${totalRoutes}</div>
                                <div class="stats-label">Active Routes</div>
                                <div class="mt-2"><i class="fas fa-route fa-2x text-success opacity-50"></i></div>
                            </div>
                        </div>
                        <div class="col-lg-3 col-md-6 mb-3">
                            <div class="stats-card buses">
                                <div class="stats-number text-warning">${totalBuses}</div>
                                <div class="stats-label">Available Buses</div>
                                <div class="mt-2"><i class="fas fa-bus fa-2x text-warning opacity-50"></i></div>
                            </div>
                        </div>
                        <div class="col-lg-3 col-md-6 mb-3">
                            <div class="stats-card tickets">
                                <div class="stats-number text-danger">${totalTickets}</div>
                                <div class="stats-label">Total Tickets</div>
                                <div class="mt-2"><i class="fas fa-ticket-alt fa-2x text-danger opacity-50"></i></div>
                            </div>
                        </div>
                    </div>
                    <!-- Add more admin dashboard content as needed -->
                </div>

                <%@ include file="/views/partials/footer.jsp" %>
        </body>

        </html>