<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="/views/partials/head.jsp">
        <jsp:param name="title" value="Edit Ticket - Staff Panel" />
    </jsp:include>
    <style>
        .ticket-header {
            background: linear-gradient(135deg, #f39c12 0%, #e67e22 100%);
            color: white;
            padding: 1.5rem;
            border-radius: 10px;
            margin-bottom: 20px;
        }
        .section-title {
            font-weight: 600;
            color: #e67e22;
            margin-bottom: 1rem;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid #e0e0e0;
        }
        .seat {
            width: 45px;
            height: 45px;
            border: 2px solid #dee2e6;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.2s;
            font-weight: 600;
        }
        .seat:hover:not(.booked):not(.current) {
            border-color: #27ae60;
            background: #e8f5e9;
        }
        .seat.current {
            background: linear-gradient(135deg, #27ae60 0%, #229954 100%);
            color: white;
            border-color: #229954;
        }
        .seat.booked {
            background: #f8d7da;
            color: #721c24;
            border-color: #f5c6cb;
            cursor: not-allowed;
        }
        .recent-activity {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <%@ include file="/views/partials/staff-header.jsp" %>
    
    <div class="container mt-4">
        <!-- Ticket Header -->
        <div class="ticket-header">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h4 class="mb-2"><i class="fas fa-edit me-2"></i>Edit Ticket: ${ticket.ticketNumber}</h4>
                    <p class="mb-0">
                        <i class="fas fa-route me-2"></i>${ticket.routeName}
                        <span class="ms-3"><i class="fas fa-calendar me-2"></i>${ticket.departureDate}</span>
                        <span class="ms-3"><i class="fas fa-clock me-2"></i>${ticket.departureTime}</span>
                    </p>
                </div>
                <div class="col-md-4 text-md-end">
                    <span class="badge bg-light text-dark fs-6">Seat #${ticket.seatNumber}</span>
                </div>
            </div>
        </div>

        <!-- Alert Messages -->
        <c:if test="${not empty param.error}">
            <div class="alert alert-danger alert-dismissible fade show">
                <i class="fas fa-exclamation-circle me-2"></i>${param.error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <form method="post" action="${pageContext.request.contextPath}/staff/update-ticket" id="editForm">
            <input type="hidden" name="ticketId" value="${ticket.ticketId}">
            <input type="hidden" name="seatNumber" id="seatNumberInput" value="${ticket.seatNumber}">

            <div class="row">
                <!-- Seat Change -->
                <div class="col-md-5">
                    <div class="recent-activity">
                        <h5 class="section-title"><i class="fas fa-chair me-2"></i>Change Seat (Optional)</h5>
                        <p class="text-muted small">Current seat: <strong>${ticket.seatNumber}</strong>. Click another seat to change.</p>
                        <div class="d-flex flex-wrap gap-2 justify-content-center">
                            <c:forEach begin="1" end="${schedule.availableSeats + bookedSeats.size()}" var="seatNum">
                                <c:set var="isBooked" value="false"/>
                                <c:set var="isCurrent" value="${seatNum == ticket.seatNumber}"/>
                                <c:forEach var="booked" items="${bookedSeats}">
                                    <c:if test="${booked == seatNum && seatNum != ticket.seatNumber}">
                                        <c:set var="isBooked" value="true"/>
                                    </c:if>
                                </c:forEach>
                                <div class="seat ${isCurrent ? 'current' : (isBooked ? 'booked' : '')}" 
                                     data-seat="${seatNum}"
                                     onclick="${isBooked ? '' : 'selectSeat(this)'}">
                                    ${seatNum}
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>

                <!-- Customer & Station Info -->
                <div class="col-md-7">
                    <div class="recent-activity">
                        <h5 class="section-title"><i class="fas fa-user me-2"></i>Customer Information</h5>
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label">Customer Name</label>
                                <input type="text" name="customerName" class="form-control" 
                                       value="${not empty ticket.customerName ? ticket.customerName : ticket.userName}">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Phone Number</label>
                                <input type="tel" name="customerPhone" class="form-control" 
                                       value="${not empty ticket.customerPhone ? ticket.customerPhone : ticket.user.phoneNumber}">
                            </div>
                            <div class="col-12">
                                <label class="form-label">Notes</label>
                                <textarea name="notes" class="form-control" rows="2">${ticket.notes}</textarea>
                            </div>
                        </div>

                        <h5 class="section-title mt-4"><i class="fas fa-map-marker-alt me-2"></i>Station Selection</h5>
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label">Boarding Station</label>
                                <select name="boardingStationId" class="form-select">
                                    <c:forEach var="station" items="${stations}">
                                        <option value="${station.stationId}" 
                                            ${ticket.boardingStationId == station.stationId ? 'selected' : ''}>
                                            ${station.stationName} (${station.city})
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Alighting Station</label>
                                <select name="alightingStationId" class="form-select">
                                    <c:forEach var="station" items="${stations}">
                                        <option value="${station.stationId}" 
                                            ${ticket.alightingStationId == station.stationId ? 'selected' : ''}>
                                            ${station.stationName} (${station.city})
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <div class="mt-4 d-flex justify-content-between">
                            <a href="${pageContext.request.contextPath}/staff/ticket-detail?id=${ticket.ticketId}" 
                               class="btn btn-outline-secondary">
                                <i class="fas fa-times me-2"></i>Cancel
                            </a>
                            <button type="submit" class="btn btn-warning">
                                <i class="fas fa-save me-2"></i>Save Changes
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </form>
    </div>

    <%@ include file="/views/partials/footer.jsp" %>
    
    <script>
        function selectSeat(element) {
            // Remove current class from all seats except the original
            document.querySelectorAll('.seat.current').forEach(s => {
                if (s.dataset.seat != '${ticket.seatNumber}') {
                    s.classList.remove('current');
                }
            });
            // Add current class to selected seat
            element.classList.add('current');
            // Update hidden input
            document.getElementById('seatNumberInput').value = element.dataset.seat;
        }
    </script>
</body>
</html>
