<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="/views/partials/head.jsp">
        <jsp:param name="title" value="Checked-in Passengers - Staff Panel" />
    </jsp:include>
    <style>
        .check-in-header {
            background: linear-gradient(135deg, #27ae60 0%, #229954 100%);
            color: white;
            padding: 1.5rem;
            border-radius: 10px;
            margin-bottom: 20px;
        }
        .passenger-card {
            background: white;
            border: 2px solid #27ae60;
            border-radius: 10px;
            padding: 1rem;
            margin-bottom: 0.75rem;
            transition: all 0.2s;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
        .passenger-card:hover {
            box-shadow: 0 4px 12px rgba(39, 174, 96, 0.2);
        }
        .seat-display {
            background: #27ae60;
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
            color: #27ae60;
        }
        .route-badge {
            background: #e8f5e9;
            color: #2e7d32;
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.85rem;
        }
        .time-badge {
            background: #e3f2fd;
            color: #1565c0;
            padding: 0.25rem 0.5rem;
            border-radius: 8px;
            font-size: 0.8rem;
        }
    </style>
</head>
<body>
    <%@ include file="/views/partials/staff-header.jsp" %>
    
    <div class="container mt-4">
        <!-- Header with Date Selector -->
        <div class="check-in-header">
            <div class="row align-items-center">
                <div class="col-md-6">
                    <h4 class="mb-0"><i class="fas fa-user-check me-2"></i>Checked-in Passengers</h4>
                    <p class="mb-0 mt-2 opacity-75">View all passengers who have checked in</p>
                </div>
                <div class="col-md-6">
                    <form method="get" action="${pageContext.request.contextPath}/staff/check-in" class="row g-2 justify-content-end">
                        <div class="col-auto">
                            <input type="date" name="date" class="form-control" value="${selectedDate}">
                        </div>
                        <div class="col-auto">
                            <button type="submit" class="btn btn-light">
                                <i class="fas fa-search me-1"></i>View
                            </button>
                        </div>
                    </form>
                </div>
            </div>
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

        <!-- Statistics -->
        <div class="row mb-4">
            <div class="col-md-4 offset-md-4">
                <div class="stat-card">
                    <div class="stat-value">${totalCheckedIn}</div>
                    <div class="text-muted">Total Checked-in on ${selectedDate}</div>
                </div>
            </div>
        </div>

        <!-- Checked-in Passengers List -->
        <div class="row">
            <div class="col-12">
                <h5 class="mb-3">
                    <i class="fas fa-list me-2 text-success"></i>Checked-in List
                </h5>
            </div>
        </div>

        <c:choose>
            <c:when test="${empty checkedInTickets}">
                <div class="text-center py-5 text-muted">
                    <i class="fas fa-user-check fa-3x mb-3 d-block opacity-50"></i>
                    <p>No passengers checked in on this date.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="row">
                    <c:forEach var="ticket" items="${checkedInTickets}">
                        <div class="col-md-6 col-lg-4">
                            <div class="passenger-card">
                                <div class="d-flex align-items-start gap-3">
                                    <div class="seat-display">${ticket.seatNumber}</div>
                                    <div class="flex-grow-1">
                                        <div class="fw-bold">
                                            <c:choose>
                                                <c:when test="${not empty ticket.customerName}">${ticket.customerName}</c:when>
                                                <c:otherwise>${ticket.userName}</c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="text-muted small mb-2">
                                            <i class="fas fa-phone me-1"></i>
                                            <c:choose>
                                                <c:when test="${not empty ticket.customerPhone}">${ticket.customerPhone}</c:when>
                                                <c:otherwise>-</c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="mb-2">
                                            <span class="route-badge">
                                                <i class="fas fa-route me-1"></i>${ticket.routeName}
                                            </span>
                                        </div>
                                        <div class="d-flex gap-2 flex-wrap">
                                            <span class="time-badge">
                                                <i class="fas fa-clock me-1"></i>${ticket.departureTime}
                                            </span>
                                            <span class="time-badge">
                                                <i class="fas fa-bus me-1"></i>${ticket.busNumber}
                                            </span>
                                        </div>
                                        <c:if test="${not empty ticket.checkedInAt}">
                                            <div class="mt-2 small text-success">
                                                <i class="fas fa-check-circle me-1"></i>
                                                Checked in at: <fmt:formatDate value="${ticket.checkedInAt}" pattern="HH:mm"/>
                                            </div>
                                        </c:if>
                                    </div>
                                    <div>
                                        <a href="${pageContext.request.contextPath}/staff/ticket-detail?id=${ticket.ticketId}" 
                                           class="btn btn-sm btn-outline-secondary" title="View Details">
                                            <i class="fas fa-eye"></i>
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <%@ include file="/views/partials/footer.jsp" %>
</body>
</html>
