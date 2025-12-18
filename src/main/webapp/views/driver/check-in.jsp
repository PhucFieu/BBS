<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="/views/partials/head.jsp">
        <jsp:param name="title" value="Check-in Passengers - Driver" />
    </jsp:include>
    <style>
        .check-in-header {
            background: linear-gradient(135deg, #66bb6a 0%, #81c784 100%);
            color: white;
            padding: 1.5rem;
            border-radius: 10px;
            margin-bottom: 20px;
        }
        .schedule-info {
            background: white;
            border-radius: 10px;
            padding: 1.5rem;
            margin-bottom: 20px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
        .passenger-card {
            background: white;
            border: 2px solid #e0e0e0;
            border-radius: 10px;
            padding: 1rem;
            margin-bottom: 0.75rem;
            transition: all 0.2s;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
        .passenger-card:hover {
            box-shadow: 0 4px 12px rgba(102, 187, 106, 0.2);
        }
        .passenger-card.checked-in {
            border-color: #66bb6a;
            background: #f1f8f4;
        }
        .check-in-checkbox {
            width: 24px;
            height: 24px;
            cursor: pointer;
        }
        .seat-display {
            background: #66bb6a;
            color: white;
            width: 45px;
            height: 45px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 1rem;
        }
        .stat-card {
            background: white;
            border-radius: 10px;
            padding: 1.5rem;
            text-align: center;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
        .stat-value {
            font-size: 2.5rem;
            font-weight: 700;
            color: #66bb6a;
        }
    </style>
</head>
<body>
    <jsp:include page="/views/partials/driver-header.jsp" />
    
    <div class="container mt-4">
        <!-- Header -->
        <div class="check-in-header">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h4 class="mb-0"><i class="fas fa-user-check me-2"></i>Check-in Passengers</h4>
                    <p class="mb-0 mt-2 opacity-75">Tick to check-in passengers for this trip</p>
                </div>
                <div class="col-md-4 text-md-end">
                    <a href="${pageContext.request.contextPath}/driver/trips" class="btn btn-light">
                        <i class="fas fa-arrow-left me-1"></i>Back to Trips
                    </a>
                </div>
            </div>
        </div>

        <!-- Schedule Info -->
        <c:if test="${not empty schedule}">
            <div class="schedule-info">
                <div class="row">
                    <div class="col-md-6">
                        <h5><i class="fas fa-route me-2"></i>${schedule.routeName}</h5>
                        <p class="mb-1"><strong>From:</strong> ${schedule.departureCity}</p>
                        <p class="mb-1"><strong>To:</strong> ${schedule.destinationCity}</p>
                    </div>
                    <div class="col-md-6">
                        <p class="mb-1"><strong>Date:</strong> ${schedule.departureDate}</p>
                        <p class="mb-1"><strong>Departure:</strong> ${schedule.departureTime}</p>
                        <p class="mb-1"><strong>Arrival:</strong> ${schedule.estimatedArrivalTime}</p>
                        <p class="mb-0"><strong>Bus:</strong> ${schedule.busNumber}</p>
                    </div>
                </div>
            </div>
        </c:if>

        <!-- Alert Messages -->
        <c:if test="${not empty param.message}">
            <div class="alert alert-success alert-dismissible fade show">
                <i class="fas fa-check-circle me-2"></i>${param.message}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${not empty param.error}">
            <div class="alert alert-danger alert-dismissible fade show">
                <i class="fas fa-exclamation-circle me-2"></i>${param.error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Statistics -->
        <div class="row mb-4">
            <div class="col-md-4">
                <div class="stat-card">
                    <div class="stat-value">${not empty uncheckedInTickets ? uncheckedInTickets.size() : 0}</div>
                    <div class="text-muted">Pending Check-in</div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stat-card">
                    <div class="stat-value">${not empty checkedInTickets ? checkedInTickets.size() : 0}</div>
                    <div class="text-muted">Checked-in</div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stat-card">
                    <div class="stat-value">${(not empty uncheckedInTickets ? uncheckedInTickets.size() : 0) + (not empty checkedInTickets ? checkedInTickets.size() : 0)}</div>
                    <div class="text-muted">Total Passengers</div>
                </div>
            </div>
        </div>

        <!-- Pending Check-in Section -->
        <div class="card mb-4">
            <div class="card-header bg-warning text-dark">
                <h5 class="mb-0"><i class="fas fa-clock me-2"></i>Pending Check-in</h5>
            </div>
            <div class="card-body">
                <c:choose>
                    <c:when test="${not empty uncheckedInTickets}">
                        <c:forEach var="ticket" items="${uncheckedInTickets}">
                            <div class="passenger-card">
                                <div class="row align-items-center">
                                    <div class="col-auto">
                                        <form method="post" action="${pageContext.request.contextPath}/driver/check-in" style="display: inline;">
                                            <input type="hidden" name="ticketId" value="${ticket.ticketId}">
                                            <input type="hidden" name="scheduleId" value="${schedule.scheduleId}">
                                            <input type="checkbox" class="check-in-checkbox" 
                                                   onchange="this.form.submit()" 
                                                   title="Tick to check-in">
                                        </form>
                                    </div>
                                    <div class="col-auto">
                                        <div class="seat-display">${ticket.seatNumber}</div>
                                    </div>
                                    <div class="col">
                                        <strong>${ticket.customerName != null && !ticket.customerName.isEmpty() ? ticket.customerName : ticket.userName}</strong>
                                        <c:if test="${ticket.customerPhone != null && !ticket.customerPhone.isEmpty()}">
                                            <div class="text-muted small">
                                                <i class="fas fa-phone me-1"></i>${ticket.customerPhone}
                                            </div>
                                        </c:if>
                                        <c:if test="${ticket.ticketNumber != null}">
                                            <div class="text-muted small">
                                                <i class="fas fa-ticket-alt me-1"></i>${ticket.ticketNumber}
                                            </div>
                                        </c:if>
                                    </div>
                                    <div class="col-md-3">
                                        <c:if test="${ticket.boardingStationName != null}">
                                            <div class="small">
                                                <strong>Boarding:</strong> ${ticket.boardingStationName}
                                            </div>
                                        </c:if>
                                        <c:if test="${ticket.alightingStationName != null}">
                                            <div class="small">
                                                <strong>Alighting:</strong> ${ticket.alightingStationName}
                                            </div>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-4 text-muted">
                            <i class="fas fa-check-circle fa-3x mb-3"></i>
                            <p>All passengers have been checked in!</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Already Checked-in Section -->
        <c:if test="${not empty checkedInTickets}">
            <div class="card">
                <div class="card-header bg-success text-white">
                    <h5 class="mb-0"><i class="fas fa-check-circle me-2"></i>Already Checked-in</h5>
                </div>
                <div class="card-body">
                    <c:forEach var="ticket" items="${checkedInTickets}">
                        <div class="passenger-card checked-in">
                            <div class="row align-items-center">
                                <div class="col-auto">
                                    <div class="seat-display">${ticket.seatNumber}</div>
                                </div>
                                <div class="col">
                                    <strong>${ticket.customerName != null && !ticket.customerName.isEmpty() ? ticket.customerName : ticket.userName}</strong>
                                    <c:if test="${ticket.customerPhone != null && !ticket.customerPhone.isEmpty()}">
                                        <div class="text-muted small">
                                            <i class="fas fa-phone me-1"></i>${ticket.customerPhone}
                                        </div>
                                    </c:if>
                                    <c:if test="${ticket.checkedInAt != null}">
                                        <div class="text-muted small">
                                            <i class="fas fa-clock me-1"></i>Checked in: 
                                            <fmt:formatDate value="${ticket.checkedInAtDate}" pattern="HH:mm" />
                                        </div>
                                    </c:if>
                                </div>
                                <div class="col-md-3">
                                    <span class="badge bg-success">
                                        <i class="fas fa-check me-1"></i>Checked In
                                    </span>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </c:if>
    </div>

    <jsp:include page="/views/partials/footer.jsp" />
</body>
</html>

