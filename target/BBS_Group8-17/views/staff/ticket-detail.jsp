<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="/views/partials/head.jsp">
        <jsp:param name="title" value="Ticket Details - Staff Panel" />
    </jsp:include>
    <style>
        .ticket-header {
            background: linear-gradient(135deg, #27ae60 0%, #229954 100%);
            color: white;
            padding: 2rem;
            border-radius: 10px;
            margin-bottom: 20px;
        }
        .ticket-number {
            font-size: 1.5rem;
            font-weight: 700;
            letter-spacing: 2px;
        }
        .recent-activity {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }
        .info-row {
            padding: 0.75rem 0;
            border-bottom: 1px solid #eee;
        }
        .info-row:last-child {
            border-bottom: none;
        }
        .info-label {
            color: #666;
            font-weight: 500;
        }
        .info-value {
            font-weight: 600;
            color: #333;
        }
        .action-btn {
            padding: 0.75rem 1.5rem;
            border-radius: 8px;
            font-weight: 600;
        }
    </style>
</head>
<body>
    <%@ include file="/views/partials/staff-header.jsp" %>
    
    <div class="container mt-4">
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
        <c:if test="${not empty param.warning}">
            <div class="alert alert-warning alert-dismissible fade show">
                <i class="fas fa-exclamation-triangle me-2"></i>${param.warning}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Ticket Header -->
        <div class="ticket-header">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <small>Ticket Number</small>
                    <div class="ticket-number">${ticket.ticketNumber}</div>
                    <div class="mt-2">
                        <span class="badge ${not empty ticket.checkedInAt ? 'bg-light text-info' : 
                            ticket.status == 'CONFIRMED' ? 'bg-light text-success' : 
                            ticket.status == 'CANCELLED' ? 'bg-light text-danger' : 'bg-light text-warning'} me-2">
                            <i class="fas fa-circle me-1"></i>
                            <c:choose>
                                <c:when test="${not empty ticket.checkedInAt}">Checked In</c:when>
                                <c:otherwise>${ticket.status}</c:otherwise>
                            </c:choose>
                        </span>
                        <span class="badge ${ticket.paymentStatus == 'PAID' ? 'bg-light text-success' : 'bg-light text-warning'}">
                            <i class="fas fa-credit-card me-1"></i>${ticket.paymentStatus}
                        </span>
                    </div>
                </div>
                <div class="col-md-4 text-md-end">
                    <div style="font-size: 2rem; font-weight: 700;">
                        <fmt:formatNumber value="${ticket.ticketPrice}" type="currency" currencySymbol="" maxFractionDigits="0"/> VND
                    </div>
                </div>
            </div>
        </div>

        <div class="row">
            <!-- Ticket Information -->
            <div class="col-md-6">
                <div class="recent-activity">
                    <h5 class="mb-4"><i class="fas fa-info-circle me-2 text-success"></i>Trip Information</h5>
                    <div class="info-row">
                        <div class="row">
                            <div class="col-5 info-label">Route</div>
                            <div class="col-7 info-value">${ticket.routeName}</div>
                        </div>
                    </div>
                    <div class="info-row">
                        <div class="row">
                            <div class="col-5 info-label">From - To</div>
                            <div class="col-7 info-value">${ticket.departureCity} → ${ticket.destinationCity}</div>
                        </div>
                    </div>
                    <div class="info-row">
                        <div class="row">
                            <div class="col-5 info-label">Date</div>
                            <div class="col-7 info-value">${ticket.departureDate}</div>
                        </div>
                    </div>
                    <div class="info-row">
                        <div class="row">
                            <div class="col-5 info-label">Time</div>
                            <div class="col-7 info-value">${ticket.departureTime}</div>
                        </div>
                    </div>
                    <div class="info-row">
                        <div class="row">
                            <div class="col-5 info-label">Bus</div>
                            <div class="col-7 info-value">${ticket.busNumber}</div>
                        </div>
                    </div>
                    <div class="info-row">
                        <div class="row">
                            <div class="col-5 info-label">Seat Number</div>
                            <div class="col-7 info-value"><span class="badge bg-success fs-6">${ticket.seatNumber}</span></div>
                        </div>
                    </div>
                    <c:if test="${not empty ticket.boardingStationName}">
                        <div class="info-row">
                            <div class="row">
                                <div class="col-5 info-label">Boarding</div>
                                <div class="col-7 info-value">${ticket.boardingStationName}</div>
                            </div>
                        </div>
                    </c:if>
                    <c:if test="${not empty ticket.alightingStationName}">
                        <div class="info-row">
                            <div class="row">
                                <div class="col-5 info-label">Alighting</div>
                                <div class="col-7 info-value">${ticket.alightingStationName}</div>
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>

            <!-- Customer Information -->
            <div class="col-md-6">
                <div class="recent-activity">
                    <h5 class="mb-4"><i class="fas fa-user me-2 text-primary"></i>Customer Information</h5>
                    <div class="info-row">
                        <div class="row">
                            <div class="col-5 info-label">Name</div>
                            <div class="col-7 info-value">
                                <c:choose>
                                    <c:when test="${not empty ticket.customerName}">${ticket.customerName}</c:when>
                                    <c:otherwise>${ticket.userName}</c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                    <div class="info-row">
                        <div class="row">
                            <div class="col-5 info-label">Phone</div>
                            <div class="col-7 info-value">
                                <c:choose>
                                    <c:when test="${not empty ticket.customerPhone}">${ticket.customerPhone}</c:when>
                                    <c:when test="${not empty ticket.user.phoneNumber}">${ticket.user.phoneNumber}</c:when>
                                    <c:otherwise>-</c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                    <div class="info-row">
                        <div class="row">
                            <div class="col-5 info-label">Email</div>
                            <div class="col-7 info-value">
                                <c:choose>
                                    <c:when test="${not empty ticket.customerEmail}">${ticket.customerEmail}</c:when>
                                    <c:when test="${not empty ticket.userEmail}">${ticket.userEmail}</c:when>
                                    <c:otherwise>-</c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                    <c:if test="${not empty ticket.notes}">
                        <div class="info-row">
                            <div class="row">
                                <div class="col-5 info-label">Notes</div>
                                <div class="col-7 info-value">${ticket.notes}</div>
                            </div>
                        </div>
                    </c:if>
                    <div class="info-row">
                        <div class="row">
                            <div class="col-5 info-label">Booked On</div>
                            <div class="col-7 info-value">${ticket.bookingDateStr}</div>
                        </div>
                    </div>
                </div>

                <!-- Actions -->
                <div class="recent-activity">
                    <h5 class="mb-4"><i class="fas fa-cogs me-2 text-warning"></i>Actions</h5>
                    <div class="d-flex flex-wrap gap-2">
                        <c:if test="${ticket.paymentStatus != 'PAID' && ticket.status != 'CANCELLED'}">
                            <form method="post" action="${pageContext.request.contextPath}/staff/mark-paid" style="display: inline;">
                                <input type="hidden" name="ticketId" value="${ticket.ticketId}">
                                <button type="submit" class="btn btn-success action-btn">
                                    <i class="fas fa-check me-2"></i>Mark as Paid
                                </button>
                            </form>
                        </c:if>
                        
                        <c:if test="${ticket.status != 'CANCELLED' && empty ticket.checkedInAt}">
                            <a href="${pageContext.request.contextPath}/staff/edit-ticket?id=${ticket.ticketId}" 
                               class="btn btn-warning action-btn">
                                <i class="fas fa-edit me-2"></i>Edit Ticket
                            </a>
                            
                            <form method="post" action="${pageContext.request.contextPath}/staff/cancel-ticket" 
                                  style="display: inline;" 
                                  onsubmit="return confirm('Are you sure you want to cancel this ticket?');">
                                <input type="hidden" name="ticketId" value="${ticket.ticketId}">
                                <button type="submit" class="btn btn-danger action-btn">
                                    <i class="fas fa-times me-2"></i>Cancel Ticket
                                </button>
                            </form>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>

        <!-- Back Button -->
        <div class="mt-3">
            <a href="${pageContext.request.contextPath}/staff/tickets" class="btn btn-outline-secondary">
                <i class="fas fa-arrow-left me-2"></i>Back to Ticket Lookup
            </a>
        </div>
    </div>

    <%@ include file="/views/partials/footer.jsp" %>
</body>
</html>
