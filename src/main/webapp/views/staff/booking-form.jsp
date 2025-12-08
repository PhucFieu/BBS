<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="/views/partials/head.jsp">
        <jsp:param name="title" value="Book Ticket - Staff Panel" />
    </jsp:include>
    <style>
        .trip-info {
            background: linear-gradient(135deg, #27ae60 0%, #229954 100%);
            color: white;
            padding: 1.5rem;
            border-radius: 10px;
            margin-bottom: 20px;
        }
        .section-title {
            font-weight: 600;
            color: #27ae60;
            margin-bottom: 1rem;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid #e0e0e0;
        }
        .seat-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 0.5rem;
            max-width: 300px;
            margin: 0 auto;
        }
        .seat {
            width: 50px;
            height: 50px;
            border: 2px solid #dee2e6;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.2s;
            font-weight: 600;
        }
        .seat:hover:not(.booked):not(.selected) {
            border-color: #27ae60;
            background: #e8f5e9;
        }
        .seat.selected {
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
        .seat-legend {
            display: flex;
            gap: 1.5rem;
            justify-content: center;
            margin-top: 1rem;
        }
        .legend-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 0.85rem;
        }
        .legend-box {
            width: 20px;
            height: 20px;
            border-radius: 4px;
            border: 2px solid #dee2e6;
        }
        .legend-box.available { background: white; }
        .legend-box.selected { background: #27ae60; border-color: #229954; }
        .legend-box.booked { background: #f8d7da; border-color: #f5c6cb; }
        .price-display {
            font-size: 1.5rem;
            font-weight: 700;
            color: white;
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
        <!-- Trip Information -->
        <div class="trip-info">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h4 class="mb-2"><i class="fas fa-route me-2"></i>${schedule.routeName}</h4>
                    <p class="mb-1">
                        <i class="fas fa-map-marker-alt me-2"></i>${schedule.departureCity} 
                        <i class="fas fa-arrow-right mx-2"></i>${schedule.destinationCity}
                    </p>
                    <p class="mb-0">
                        <i class="fas fa-calendar me-2"></i>${schedule.departureDate} 
                        <i class="fas fa-clock ms-3 me-2"></i>${schedule.departureTime} - ${schedule.estimatedArrivalTime}
                        <i class="fas fa-bus ms-3 me-2"></i>${schedule.busNumber}
                    </p>
                </div>
                <div class="col-md-4 text-md-end">
                    <div class="price-display">${route.basePrice} VND</div>
                    <small>per seat</small>
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

        <form method="post" action="${pageContext.request.contextPath}/staff/book" id="bookingForm">
            <input type="hidden" name="scheduleId" value="${schedule.scheduleId}">
            <input type="hidden" name="seatNumber" id="seatNumberInput" value="">

            <div class="row">
                <!-- Seat Selection -->
                <div class="col-md-5">
                    <div class="recent-activity">
                        <h5 class="section-title"><i class="fas fa-chair me-2"></i>Select Seat</h5>
                        <div class="seat-grid" id="seatGrid">
                            <c:forEach begin="1" end="${schedule.availableSeats + bookedSeats.size()}" var="seatNum">
                                <c:set var="isBooked" value="false"/>
                                <c:forEach var="booked" items="${bookedSeats}">
                                    <c:if test="${booked == seatNum}">
                                        <c:set var="isBooked" value="true"/>
                                    </c:if>
                                </c:forEach>
                                <div class="seat ${isBooked ? 'booked' : ''}" 
                                     data-seat="${seatNum}"
                                     onclick="${isBooked ? '' : 'selectSeat(this)'}">
                                    ${seatNum}
                                </div>
                            </c:forEach>
                        </div>
                        <div class="seat-legend">
                            <div class="legend-item"><div class="legend-box available"></div> Available</div>
                            <div class="legend-item"><div class="legend-box selected"></div> Selected</div>
                            <div class="legend-item"><div class="legend-box booked"></div> Booked</div>
                        </div>
                    </div>
                </div>

                <!-- Customer Information -->
                <div class="col-md-7">
                    <div class="recent-activity">
                        <h5 class="section-title"><i class="fas fa-user me-2"></i>Customer Information</h5>
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label">Customer Name *</label>
                                <input type="text" name="customerName" class="form-control" required placeholder="Full name">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Phone Number *</label>
                                <input type="tel" name="customerPhone" class="form-control" required placeholder="Phone number">
                            </div>
                            <div class="col-12">
                                <label class="form-label">Email (optional)</label>
                                <input type="email" name="customerEmail" class="form-control" placeholder="email@example.com">
                            </div>
                            <div class="col-12">
                                <label class="form-label">Notes (optional)</label>
                                <textarea name="notes" class="form-control" rows="2" placeholder="Special requests or notes"></textarea>
                            </div>
                        </div>

                        <h5 class="section-title mt-4"><i class="fas fa-map-marker-alt me-2"></i>Station Selection</h5>
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label">Boarding Station</label>
                                <select name="boardingStationId" class="form-select">
                                    <c:forEach var="station" items="${stations}">
                                        <option value="${station.stationId}" 
                                            ${route.departureStationId == station.stationId ? 'selected' : ''}>
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
                                            ${route.destinationStationId == station.stationId ? 'selected' : ''}>
                                            ${station.stationName} (${station.city})
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <h5 class="section-title mt-4"><i class="fas fa-credit-card me-2"></i>Payment Status</h5>
                        <div class="row g-3">
                            <div class="col-12">
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" name="paymentStatus" id="paymentPaid" value="PAID">
                                    <label class="form-check-label" for="paymentPaid">
                                        <i class="fas fa-check-circle text-success me-1"></i>Paid
                                    </label>
                                </div>
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" name="paymentStatus" id="paymentUnpaid" value="UNPAID" checked>
                                    <label class="form-check-label" for="paymentUnpaid">
                                        <i class="fas fa-clock text-warning me-1"></i>Unpaid (Pay later)
                                    </label>
                                </div>
                            </div>
                        </div>

                        <div class="mt-4 d-flex justify-content-between">
                            <a href="${pageContext.request.contextPath}/staff/search-schedules" class="btn btn-outline-secondary">
                                <i class="fas fa-arrow-left me-2"></i>Back
                            </a>
                            <button type="submit" class="btn btn-success btn-lg" id="submitBtn" disabled>
                                <i class="fas fa-ticket-alt me-2"></i>Create Ticket
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
            // Remove selection from other seats
            document.querySelectorAll('.seat.selected').forEach(s => s.classList.remove('selected'));
            // Select this seat
            element.classList.add('selected');
            // Update hidden input
            document.getElementById('seatNumberInput').value = element.dataset.seat;
            // Enable submit button
            document.getElementById('submitBtn').disabled = false;
        }

        // Form validation
        document.getElementById('bookingForm').addEventListener('submit', function(e) {
            const seatNumber = document.getElementById('seatNumberInput').value;
            if (!seatNumber) {
                e.preventDefault();
                alert('Please select a seat');
            }
        });
    </script>
</body>
</html>
