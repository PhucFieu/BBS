<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="/views/partials/head.jsp">
        <jsp:param name="title" value="Daily Trips - Staff Panel" />
    </jsp:include>
    <style>
        .date-selector {
            background: linear-gradient(135deg, #27ae60 0%, #229954 100%);
            padding: 1.5rem;
            border-radius: 10px;
            color: white;
            margin-bottom: 20px;
        }
        .schedule-card {
            background: white;
            border: 1px solid #dee2e6;
            border-radius: 10px;
            padding: 1.25rem;
            margin-bottom: 1rem;
            transition: all 0.2s;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
        .schedule-card:hover {
            border-color: #27ae60;
            box-shadow: 0 4px 12px rgba(39, 174, 96, 0.15);
        }
        .time-display {
            font-size: 1.25rem;
            font-weight: 700;
            color: #27ae60;
        }
    </style>
</head>
<body>
    <%@ include file="/views/partials/staff-header.jsp" %>
    
    <div class="container mt-4">
        <!-- Date Selector -->
        <div class="date-selector">
            <form method="get" action="${pageContext.request.contextPath}/staff/daily-trips" class="row g-3 align-items-end">
                <div class="col-md-6">
                    <h4 class="mb-0"><i class="fas fa-calendar-day me-2"></i>Daily Trips</h4>
                </div>
                <div class="col-md-4">
                    <label class="form-label">Select Date</label>
                    <input type="date" name="date" class="form-control" value="${selectedDate}">
                </div>
                <div class="col-md-2">
                    <button type="submit" class="btn btn-light w-100">
                        <i class="fas fa-search me-2"></i>View
                    </button>
                </div>
            </form>
        </div>

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

        <!-- Page Header -->
        <div class="row mb-3">
            <div class="col-12">
                <h5><i class="fas fa-bus me-2 text-success"></i>Schedules for ${selectedDate}</h5>
            </div>
        </div>

        <!-- Schedules List -->
        <c:choose>
            <c:when test="${empty schedules}">
                <div class="text-center py-5 text-muted">
                    <i class="fas fa-calendar-times fa-3x mb-3 d-block opacity-50"></i>
                    <p>No schedules found for this date.</p>
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach var="schedule" items="${schedules}">
                    <div class="schedule-card">
                        <div class="row align-items-center">
                            <div class="col-md-2 text-center">
                                <div class="time-display">${schedule.departureTime}</div>
                                <small class="text-muted">Departure</small>
                            </div>
                            <div class="col-md-1 text-center">
                                <i class="fas fa-arrow-right text-muted"></i>
                            </div>
                            <div class="col-md-2 text-center">
                                <div class="time-display">${schedule.estimatedArrivalTime}</div>
                                <small class="text-muted">Arrival</small>
                            </div>
                            <div class="col-md-4">
                                <div class="fw-bold">${schedule.routeName}</div>
                                <div class="text-muted">
                                    ${schedule.departureCity} → ${schedule.destinationCity}
                                </div>
                                <div class="mt-1">
                                    <span class="badge bg-secondary me-1"><i class="fas fa-bus me-1"></i>${schedule.busNumber}</span>
                                    <span class="badge bg-info text-white"><i class="fas fa-chair me-1"></i>${schedule.availableSeats} seats</span>
                                </div>
                            </div>
                            <div class="col-md-3 text-end">
                                <a href="${pageContext.request.contextPath}/staff/book?scheduleId=${schedule.scheduleId}" 
                                   class="btn btn-outline-success btn-sm me-1" title="Book Ticket">
                                    <i class="fas fa-ticket-alt me-1"></i>Book
                                </a>
                                <a href="${pageContext.request.contextPath}/staff/passenger-list?scheduleId=${schedule.scheduleId}" 
                                   class="btn btn-outline-primary btn-sm me-1" title="View Passengers">
                                    <i class="fas fa-users me-1"></i>Passengers
                                </a>
                                <a href="${pageContext.request.contextPath}/staff/check-in?scheduleId=${schedule.scheduleId}" 
                                   class="btn btn-success btn-sm" title="Check-in">
                                    <i class="fas fa-user-check me-1"></i>Check-in
                                </a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>

    <%@ include file="/views/partials/footer.jsp" %>
</body>
</html>
