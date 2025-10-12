<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <title>Admin Dashboard - BusTicket System</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
            <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        </head>

        <body>
            <%@ include file="/views/partials/admin-header.jsp" %>

                <!-- Dashboard Header and Stats (copy from your dashboard.jsp) -->
                <div class="container mt-4">
                    <div class="row mb-4">
                        <div class="col-lg-3 col-md-6 mb-3">
                            <div class="stats-card users">
                                <div class="stats-number text-primary">${totalUsers}</div>
                                <div class="stats-label">Total Users</div>
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