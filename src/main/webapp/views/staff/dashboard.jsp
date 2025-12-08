<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <jsp:include page="/views/partials/head.jsp">
                    <jsp:param name="title" value="Staff Dashboard - Bus Booking System" />
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

                    .schedule-item {
                        padding: 12px 0;
                        border-bottom: 1px solid #e9ecef;
                        transition: background 0.2s;
                    }

                    .schedule-item:hover {
                        background: #f8f9fa;
                    }

                    .schedule-item:last-child {
                        border-bottom: none;
                    }

                    .time-badge {
                        background: #e8f5e9;
                        color: #2e7d32;
                        padding: 0.25rem 0.75rem;
                        border-radius: 20px;
                        font-weight: 600;
                        font-size: 0.85rem;
                    }

                    .seat-badge {
                        background: #e3f2fd;
                        color: #1565c0;
                        padding: 0.25rem 0.5rem;
                        border-radius: 8px;
                        font-size: 0.8rem;
                    }

                    .quick-action-btn {
                        padding: 0.75rem 1.25rem;
                        border-radius: 8px;
                        font-weight: 500;
                        transition: all 0.2s;
                    }

                    .quick-action-btn:hover {
                        transform: translateY(-2px);
                        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
                    }
                </style>
            </head>

            <body>
                <%@ include file="/views/partials/staff-header.jsp" %>

                    <div class="container mt-4">
                        <!-- Success/Error Messages -->
                        <c:if test="${not empty param.message}">
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                <i class="fas fa-check-circle me-2"></i>${param.message}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>
                        <c:if test="${not empty param.error}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="fas fa-exclamation-circle me-2"></i>${param.error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <!-- Dashboard Header -->
                        <div class="row mb-4">
                            <div class="col-md-8">
                                <h2><i class="fas fa-headset me-2"></i>Staff Dashboard</h2>
                                <p class="text-muted">
                                    Welcome, ${sessionScope.fullName != null ? sessionScope.fullName :
                                    sessionScope.username}! -
                                    <fmt:formatDate value="<%= new java.util.Date() %>" pattern="EEEE, MMMM dd, yyyy" />
                                </p>
                            </div>
                            <div class="col-md-4 text-md-end">
                                <a href="${pageContext.request.contextPath}/staff/search-schedules"
                                    class="btn btn-success btn-lg">
                                    <i class="fas fa-search me-2"></i>Search & Book
                                </a>
                            </div>
                        </div>

                        <!-- Stats Cards -->
                        <div class="row mb-4">
                            <div class="col-lg-3 col-md-6 mb-3">
                                <div class="stats-card">
                                    <div class="stats-number text-primary">${totalSchedulesToday != null ?
                                        totalSchedulesToday : 0}</div>
                                    <div class="stats-label">Today's Trips</div>
                                    <div class="mt-2"><i class="fas fa-calendar-day fa-2x text-primary opacity-50"></i>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-3 col-md-6 mb-3">
                                <div class="stats-card">
                                    <div class="stats-number text-success">${totalTickets != null ? totalTickets : 0}
                                    </div>
                                    <div class="stats-label">Total Tickets</div>
                                    <div class="mt-2"><i class="fas fa-ticket-alt fa-2x text-success opacity-50"></i>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-3 col-md-6 mb-3">
                                <div class="stats-card">
                                    <div class="stats-number text-warning">
                                        <fmt:formatDate value="<%= new java.util.Date() %>" pattern="HH:mm" />
                                    </div>
                                    <div class="stats-label">Current Time</div>
                                    <div class="mt-2"><i class="fas fa-clock fa-2x text-warning opacity-50"></i></div>
                                </div>
                            </div>
                            <div class="col-lg-3 col-md-6 mb-3">
                                <div class="stats-card">
                                    <div class="stats-number text-info">Ready</div>
                                    <div class="stats-label">System Status</div>
                                    <div class="mt-2"><i class="fas fa-check-circle fa-2x text-info opacity-50"></i>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Quick Actions & Today's Schedules -->
                        <div class="row">
                            <!-- Quick Actions -->
                            <div class="col-md-4">
                                <div class="recent-activity">
                                    <h5><i class="fas fa-bolt me-2 text-warning"></i>Quick Actions</h5>
                                    <div class="d-grid gap-2 mt-3">
                                        <a href="${pageContext.request.contextPath}/staff/search-schedules"
                                            class="btn btn-outline-primary quick-action-btn">
                                            <i class="fas fa-search me-2"></i>Search Schedules
                                        </a>
                                        <a href="${pageContext.request.contextPath}/staff/tickets"
                                            class="btn btn-outline-success quick-action-btn">
                                            <i class="fas fa-ticket-alt me-2"></i>Ticket Lookup
                                        </a>
                                    </div>
                                </div>
                            </div>

                            <!-- Today's Schedules -->
                            <div class="col-md-8">
                                <div class="recent-activity">
                                    <div class="d-flex justify-content-between align-items-center mb-3">
                                        <h5 class="mb-0"><i class="fas fa-calendar-day me-2 text-primary"></i>Today's
                                            Schedules</h5>
                                        <a href="${pageContext.request.contextPath}/staff/search-schedules"
                                            class="btn btn-sm btn-outline-primary">
                                            View All <i class="fas fa-arrow-right ms-1"></i>
                                        </a>
                                    </div>
                                    <c:choose>
                                        <c:when test="${empty todaySchedules}">
                                            <div class="text-center py-4 text-muted">
                                                <i class="fas fa-calendar-times fa-3x mb-3 d-block opacity-50"></i>
                                                No schedules for today
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="schedule" items="${todaySchedules}" varStatus="loop">
                                                <c:if test="${loop.index < 5}">
                                                    <div class="schedule-item">
                                                        <div class="row align-items-center">
                                                            <div class="col-auto">
                                                                <span
                                                                    class="time-badge">${schedule.departureTime}</span>
                                                            </div>
                                                            <div class="col">
                                                                <div class="fw-bold">${schedule.routeName}</div>
                                                                <small class="text-muted">
                                                                    ${schedule.departureCity} →
                                                                    ${schedule.destinationCity}
                                                                </small>
                                                            </div>
                                                            <div class="col-auto">
                                                                <span class="seat-badge">
                                                                    <i
                                                                        class="fas fa-chair me-1"></i>${schedule.availableSeats}
                                                                    seats
                                                                </span>
                                                            </div>
                                                            <div class="col-auto">
                                                                <a href="${pageContext.request.contextPath}/staff/passenger-list?scheduleId=${schedule.scheduleId}"
                                                                    class="btn btn-sm btn-outline-secondary"
                                                                    title="View Passengers">
                                                                    <i class="fas fa-users"></i>
                                                                </a>
                                                                <a href="${pageContext.request.contextPath}/staff/book?scheduleId=${schedule.scheduleId}"
                                                                    class="btn btn-sm btn-success" title="Book Ticket">
                                                                    <i class="fas fa-plus"></i>
                                                                </a>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </c:if>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>

                        <!-- Recent Tickets -->
                        <div class="recent-activity">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <h5 class="mb-0"><i class="fas fa-ticket-alt me-2 text-success"></i>Recent Tickets</h5>
                                <a href="${pageContext.request.contextPath}/staff/tickets"
                                    class="btn btn-sm btn-outline-success">
                                    View All <i class="fas fa-arrow-right ms-1"></i>
                                </a>
                            </div>
                            <c:choose>
                                <c:when test="${empty recentTickets}">
                                    <div class="text-center py-4 text-muted">
                                        <i class="fas fa-ticket-alt fa-3x mb-3 d-block opacity-50"></i>
                                        No recent tickets
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="table-responsive">
                                        <table class="table table-hover">
                                            <thead class="table-light">
                                                <tr>
                                                    <th>Ticket #</th>
                                                    <th>Customer</th>
                                                    <th>Route</th>
                                                    <th>Seat</th>
                                                    <th>Status</th>
                                                    <th>Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="ticket" items="${recentTickets}">
                                                    <tr>
                                                        <td><strong>${ticket.ticketNumber}</strong></td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${not empty ticket.customerName}">
                                                                    ${ticket.customerName}
                                                                </c:when>
                                                                <c:otherwise>
                                                                    ${ticket.userName}
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>${ticket.routeName}</td>
                                                        <td><span class="badge bg-secondary">${ticket.seatNumber}</span>
                                                        </td>
                                                        <td>
                                                            <span class="badge ${ticket.status == 'CONFIRMED' ? 'bg-success' : 
                                                ticket.status == 'CHECKED_IN' ? 'bg-info' : 'bg-warning'}">
                                                                ${ticket.status}
                                                            </span>
                                                        </td>
                                                        <td>
                                                            <a href="${pageContext.request.contextPath}/staff/ticket-detail?id=${ticket.ticketId}"
                                                                class="btn btn-sm btn-outline-primary">
                                                                <i class="fas fa-eye"></i>
                                                            </a>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <%@ include file="/views/partials/footer.jsp" %>
            </body>

            </html>