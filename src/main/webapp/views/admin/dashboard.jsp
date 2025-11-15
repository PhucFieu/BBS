<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <jsp:include page="/views/partials/head.jsp">
                <jsp:param name="title" value="Admin Dashboard - Bus Booking System" />
            </jsp:include>
            <style>
                .stats-card {
                    background: white;
                    border-radius: 10px;
                    padding: 20px;
                    text-align: center;
                    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                    transition: transform 0.2s ease;
                    margin-bottom: 20px;
                }

                .stats-card:hover {
                    transform: translateY(-2px);
                    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
                }

                .stats-number {
                    font-size: 2.5rem;
                    font-weight: bold;
                    margin-bottom: 10px;
                }

                .stats-label {
                    font-size: 1rem;
                    color: #6c757d;
                    margin-bottom: 10px;
                }

                .recent-activity {
                    background: white;
                    border-radius: 10px;
                    padding: 20px;
                    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                    margin-bottom: 20px;
                }

                .activity-item {
                    display: flex;
                    align-items: center;
                    padding: 10px 0;
                    border-bottom: 1px solid #e9ecef;
                }

                .activity-item:last-child {
                    border-bottom: none;
                }

                .activity-icon {
                    width: 40px;
                    height: 40px;
                    border-radius: 50%;
                    background: #f8f9fa;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    margin-right: 15px;
                    font-size: 1.2rem;
                }
            </style>
        </head>

        <body>
            <%@ include file="/views/partials/admin-header.jsp" %>

                <div class="container mt-4">
                    <!-- Success/Error Messages -->
                    <c:if test="${param.success != null}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="fas fa-check-circle me-2"></i>
                            ${param.success}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <c:if test="${param.error != null}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            ${param.error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <!-- Dashboard Header -->
                    <div class="row mb-4">
                        <div class="col-12">
                            <h2><i class="fas fa-tachometer-alt me-2"></i>Admin Dashboard</h2>
                            <p class="text-muted">System overview and statistics</p>
                        </div>
                    </div>

                    <!-- Stats Cards -->
                    <div class="row mb-4">
                        <div class="col-lg-3 col-md-6 mb-3">
                            <div class="stats-card">
                                <div class="stats-number text-primary">${totalUsers}</div>
                                <div class="stats-label">Total Passengers</div>
                                <div class="mt-2"><i class="fas fa-users fa-2x text-primary opacity-50"></i></div>
                            </div>
                        </div>
                        <div class="col-lg-3 col-md-6 mb-3">
                            <div class="stats-card">
                                <div class="stats-number text-success">${totalRoutes}</div>
                                <div class="stats-label">Active Routes</div>
                                <div class="mt-2"><i class="fas fa-route fa-2x text-success opacity-50"></i></div>
                            </div>
                        </div>
                        <div class="col-lg-3 col-md-6 mb-3">
                            <div class="stats-card">
                                <div class="stats-number text-warning">${totalBuses}</div>
                                <div class="stats-label">Available Buses</div>
                                <div class="mt-2"><i class="fas fa-bus fa-2x text-warning opacity-50"></i></div>
                            </div>
                        </div>
                        <div class="col-lg-3 col-md-6 mb-3">
                            <div class="stats-card">
                                <div class="stats-number text-danger">${totalTickets}</div>
                                <div class="stats-label">Total Tickets</div>
                                <div class="mt-2"><i class="fas fa-ticket-alt fa-2x text-danger opacity-50"></i></div>
                            </div>
                        </div>
                    </div>

                    <!-- Recent Activities -->
                    <div class="row">
                        <div class="col-md-6">
                            <div class="recent-activity">
                                <h5><i class="fas fa-user-plus me-2"></i>New Users</h5>
                                <c:choose>
                                    <c:when test="${not empty recentUsers}">
                                        <c:forEach var="user" items="${recentUsers}">
                                            <div class="activity-item">
                                                <div class="activity-icon">
                                                    <i class="fas fa-user text-primary"></i>
                                                </div>
                                                <div class="flex-grow-1">
                                                    <div class="fw-bold">${user.fullName}</div>
                                                    <small class="text-muted">${user.username} - ${user.role}</small>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <p class="text-muted">No new users</p>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="recent-activity">
                                <h5><i class="fas fa-ticket-alt me-2"></i>New Tickets</h5>
                                <c:choose>
                                    <c:when test="${not empty recentTickets}">
                                        <c:forEach var="ticket" items="${recentTickets}">
                                            <div class="activity-item">
                                                <div class="activity-icon">
                                                    <i class="fas fa-ticket-alt text-success"></i>
                                                </div>
                                                <div class="flex-grow-1">
                                                    <div class="fw-bold">${ticket.ticketNumber}</div>
                                                    <small class="text-muted">${ticket.routeName} -
                                                        ${ticket.status}</small>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <p class="text-muted">No new tickets</p>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>

                <%@ include file="/views/partials/footer.jsp" %>
        </body>

        </html>