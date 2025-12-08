<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <jsp:include page="/views/partials/head.jsp">
                    <jsp:param name="title" value="Passenger List - Staff Panel" />
                </jsp:include>
                <style>
                    .trip-header {
                        background: linear-gradient(135deg, #27ae60 0%, #229954 100%);
                        color: white;
                        padding: 1.5rem;
                        border-radius: 10px;
                        margin-bottom: 20px;
                    }

                    .stat-card {
                        text-align: center;
                        padding: 1rem;
                        border-radius: 10px;
                        background: white;
                        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                    }

                    .stat-card.total {
                        border-left: 4px solid #0d6efd;
                    }

                    .stat-card.checked {
                        border-left: 4px solid #27ae60;
                    }

                    .stat-card.pending {
                        border-left: 4px solid #ffc107;
                    }

                    .stat-value {
                        font-size: 2rem;
                        font-weight: 700;
                    }

                    .passenger-row {
                        transition: background 0.2s;
                    }

                    .passenger-row:hover {
                        background: #f8f9fa;
                    }

                    .passenger-row.cancelled {
                        background: #fee2e2;
                        opacity: 0.7;
                    }

                    .passenger-row.cancelled td {
                        text-decoration: line-through;
                        color: #9ca3af;
                    }

                    .passenger-row.cancelled td .badge {
                        text-decoration: none;
                    }
                </style>
            </head>

            <body>
                <%@ include file="/views/partials/staff-header.jsp" %>

                    <div class="container mt-4">
                        <!-- Trip Header -->
                        <div class="trip-header">
                            <div class="row align-items-center">
                                <div class="col-md-8">
                                    <h4 class="mb-2"><i class="fas fa-route me-2"></i>${schedule.routeName}</h4>
                                    <p class="mb-1">
                                        <i class="fas fa-map-marker-alt me-2"></i>${schedule.departureCity} →
                                        ${schedule.destinationCity}
                                    </p>
                                    <p class="mb-0">
                                        <i class="fas fa-calendar me-2"></i>${schedule.departureDate}
                                        <i class="fas fa-clock ms-3 me-2"></i>${schedule.departureTime}
                                        <i class="fas fa-bus ms-3 me-2"></i>${schedule.busNumber}
                                    </p>
                                </div>
                                <div class="col-md-4 text-md-end">
                                    <a href="${pageContext.request.contextPath}/staff/check-in?scheduleId=${schedule.scheduleId}"
                                        class="btn btn-light">
                                        <i class="fas fa-user-check me-2"></i>Go to Check-in
                                    </a>
                                </div>
                            </div>
                        </div>

                        <!-- Statistics -->
                        <div class="row mb-4">
                            <div class="col-md-3">
                                <div class="stat-card total">
                                    <div class="stat-value text-primary">${totalPassengers}</div>
                                    <div class="text-muted">Active Passengers</div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="stat-card checked">
                                    <div class="stat-value text-success">${checkedIn}</div>
                                    <div class="text-muted">Checked In</div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="stat-card pending">
                                    <div class="stat-value text-warning">${notCheckedIn}</div>
                                    <div class="text-muted">Pending Check-in</div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="stat-card" style="border-left: 4px solid #dc3545;">
                                    <div class="stat-value text-danger">${cancelled}</div>
                                    <div class="text-muted">Cancelled</div>
                                </div>
                            </div>
                        </div>

                        <!-- Page Header -->
                        <div class="row mb-3">
                            <div class="col-12">
                                <h5><i class="fas fa-users me-2 text-success"></i>Passenger List</h5>
                            </div>
                        </div>

                        <!-- Passenger List -->
                        <c:choose>
                            <c:when test="${empty tickets}">
                                <div class="text-center py-5 text-muted">
                                    <i class="fas fa-users-slash fa-3x mb-3 d-block opacity-50"></i>
                                    <p>No passengers booked for this trip yet.</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="table-responsive">
                                    <table class="table table-hover">
                                        <thead>
                                            <tr>
                                                <th>Seat</th>
                                                <th>Passenger Name</th>
                                                <th>Phone</th>
                                                <th>Boarding</th>
                                                <th>Alighting</th>
                                                <th>Status</th>
                                                <th>Payment</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="ticket" items="${tickets}">
                                                <tr
                                                    class="passenger-row ${ticket.status == 'CANCELLED' ? 'cancelled' : ''}">
                                                    <td><span class="badge bg-success fs-6">${ticket.seatNumber}</span>
                                                    </td>
                                                    <td>
                                                        <strong>
                                                            <c:choose>
                                                                <c:when test="${not empty ticket.customerName}">
                                                                    ${ticket.customerName}</c:when>
                                                                <c:otherwise>${ticket.userName}</c:otherwise>
                                                            </c:choose>
                                                        </strong>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty ticket.customerPhone}">
                                                                ${ticket.customerPhone}</c:when>
                                                            <c:when test="${not empty ticket.user.phoneNumber}">
                                                                ${ticket.user.phoneNumber}</c:when>
                                                            <c:otherwise>-</c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td><small>${ticket.boardingStationName}</small></td>
                                                    <td><small>${ticket.alightingStationName}</small></td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${ticket.status == 'CHECKED_IN'}">
                                                                <span class="badge bg-success">Checked In</span>
                                                            </c:when>
                                                            <c:when test="${ticket.status == 'CANCELLED'}">
                                                                <span class="badge bg-danger">Cancelled</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-warning">Pending</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <span
                                                            class="badge ${ticket.paymentStatus == 'PAID' ? 'bg-success' : 'bg-danger'}">
                                                            ${ticket.paymentStatus}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <c:if
                                                            test="${ticket.status != 'CHECKED_IN' && ticket.status != 'CANCELLED'}">
                                                            <c:if test="${ticket.paymentStatus != 'PAID'}">
                                                                <form method="post"
                                                                    action="${pageContext.request.contextPath}/staff/mark-paid"
                                                                    style="display: inline;">
                                                                    <input type="hidden" name="ticketId"
                                                                        value="${ticket.ticketId}">
                                                                    <input type="hidden" name="redirectTo"
                                                                        value="${pageContext.request.contextPath}/staff/passenger-list?scheduleId=${schedule.scheduleId}">
                                                                    <button type="submit"
                                                                        class="btn btn-sm btn-outline-success"
                                                                        title="Mark Paid">
                                                                        <i class="fas fa-money-bill"></i>
                                                                    </button>
                                                                </form>
                                                            </c:if>
                                                            <c:if test="${ticket.paymentStatus == 'PAID'}">
                                                                <form method="post"
                                                                    action="${pageContext.request.contextPath}/staff/check-in"
                                                                    style="display: inline;">
                                                                    <input type="hidden" name="ticketId"
                                                                        value="${ticket.ticketId}">
                                                                    <input type="hidden" name="scheduleId"
                                                                        value="${schedule.scheduleId}">
                                                                    <button type="submit" class="btn btn-sm btn-success"
                                                                        title="Check-in">
                                                                        <i class="fas fa-check"></i>
                                                                    </button>
                                                                </form>
                                                            </c:if>
                                                            <a href="${pageContext.request.contextPath}/staff/edit-ticket?id=${ticket.ticketId}"
                                                                class="btn btn-sm btn-outline-warning" title="Edit">
                                                                <i class="fas fa-edit"></i>
                                                            </a>
                                                        </c:if>
                                                        <a href="${pageContext.request.contextPath}/staff/ticket-detail?id=${ticket.ticketId}"
                                                            class="btn btn-sm btn-outline-secondary"
                                                            title="View Details">
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

                        <!-- Back Button -->
                        <div class="mt-3">
                            <a href="${pageContext.request.contextPath}/staff/daily-trips"
                                class="btn btn-outline-secondary">
                                <i class="fas fa-arrow-left me-2"></i>Back to Daily Trips
                            </a>
                        </div>
                    </div>

                    <%@ include file="/views/partials/footer.jsp" %>
            </body>

            </html>