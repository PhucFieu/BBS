<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <title>${ticket == null ? 'Add Ticket' : 'Edit Ticket'} - BusTicket System</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
                <link href="${pageContext.request.contextPath}/assets/css/ticket-form.css" rel="stylesheet">
            </head>

            <body class="bg-light">
                <div class="container">
                    <div class="row justify-content-center">
                        <div class="col-lg-8 col-md-10">
                            <div class="form-card">
                                <div class="form-header d-flex align-items-center gap-2">
                                    <i class="fas fa-ticket-alt fa-2x me-2"></i>
                                    <div>
                                        <h4 class="mb-0">
                                            <c:choose>
                                                <c:when test="${isBooking}">Book Bus Ticket</c:when>
                                                <c:when test="${ticket == null}">Add New Ticket</c:when>
                                                <c:otherwise>Edit Ticket Information</c:otherwise>
                                            </c:choose>
                                        </h4>
                                        <small>
                                            <c:choose>
                                                <c:when test="${isBooking}">Book bus tickets online</c:when>
                                                <c:otherwise>Manage bus ticket information</c:otherwise>
                                            </c:choose>
                                        </small>
                                    </div>
                                </div>
                                <form
                                    action="${pageContext.request.contextPath}/tickets/${isBooking ? 'book' : (ticket == null ? 'add' : 'edit')}"
                                    method="post" id="ticketForm" autocomplete="off">
                                    <c:if test="${ticket != null}">
                                        <input type="hidden" name="ticketId" value="${ticket.ticketId}">
                                    </c:if>
                                    <!-- Route and Bus Selection -->
                                    <div class="section-title"><i class="fas fa-route me-1"></i>Route Information</div>
                                    <div class="row g-3">
                                        <c:if test="${isBooking}">
                                            <!-- For booking: show selected route info -->
                                            <div class="col-12">
                                                <div class="alert alert-info">
                                                    <h6><i class="fas fa-route me-2"></i>${route.departureCity} →
                                                        ${route.destinationCity}</h6>
                                                    <p class="mb-0">
                                                        <i class="fas fa-road me-1"></i>Distance: ${route.distance}
                                                        km |
                                                        <i class="fas fa-clock me-1"></i>Duration:
                                                        ${route.durationHours} hours |
                                                        <i class="fas fa-money-bill me-1"></i>Ticket Price:
                                                        <fmt:formatNumber value="${route.basePrice}" pattern="#,###" />₫
                                                    </p>
                                                </div>
                                                <input type="hidden" name="routeId" value="${route.routeId}">
                                                <input type="hidden" name="busId" id="busId">
                                            </div>
                                        </c:if>
                                        <c:if test="${!isBooking}">
                                            <!-- For admin: show route and bus selection -->
                                            <div class="col-md-6">
                                                <label for="routeId" class="form-label">Route *</label>
                                                <select class="form-select" id="routeId" name="routeId" required>
                                                    <option value="">Select Route</option>
                                                    <c:forEach var="route" items="${routes}">
                                                        <option value="${route.routeId}" ${ticket.routeId eq
                                                            route.routeId ? 'selected' : '' }
                                                            data-price="${route.basePrice}">
                                                            ${route.departureCity} → ${route.destinationCity} (
                                                            <fmt:formatNumber value="${route.basePrice}"
                                                                pattern="#,###" />
                                                            ₫)
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                            <div class="col-md-6">
                                                <label for="busId" class="form-label">Bus *</label>
                                                <select class="form-select" id="busId" name="busId" required>
                                                    <option value="">Select Bus</option>
                                                    <c:forEach var="bus" items="${buses}">
                                                        <option value="${bus.busId}" ${ticket.busId eq bus.busId
                                                            ? 'selected' : '' } data-seats="${bus.totalSeats}"
                                                            data-available="${bus.totalSeats}">
                                                            ${bus.busNumber} - ${bus.busType}
                                                            (${bus.totalSeats} seats total)
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                        </c:if>
                                    </div>
                                    <!-- Passenger Selection -->
                                    <div class="section-title"><i class="fas fa-user me-1"></i>Passenger Information
                                    </div>
                                    <div class="row g-3">
                                        <c:if test="${isBooking}">
                                            <!-- For booking: show current user info -->
                                            <div class="col-12">
                                                <div class="alert alert-success">
                                                    <h6><i class="fas fa-user me-2"></i>Passenger Information</h6>
                                                    <p class="mb-0">Ticket will be booked for your current account</p>
                                                </div>
                                            </div>
                                        </c:if>
                                        <c:if test="${!isBooking}">
                                            <!-- For admin: show passenger selection -->
                                            <div class="col-md-6">
                                                <label for="userId" class="form-label">Passenger *</label>
                                                <select class="form-select" id="userId" name="userId" required>
                                                    <option value="">Select Passenger</option>
                                                    <c:forEach var="user" items="${users}">
                                                        <option value="${user.userId}" ${ticket.userId eq user.userId
                                                            ? 'selected' : '' }>
                                                            ${user.fullName} - ${user.phoneNumber}
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                            <div class="col-md-6">
                                                <label for="ticketNumber" class="form-label">Ticket Number</label>
                                                <input type="text" class="form-control" id="ticketNumber"
                                                    name="ticketNumber" value="${ticket.ticketNumber}" readonly>
                                                <div class="form-text">Ticket number will be generated automatically
                                                </div>
                                            </div>
                                        </c:if>
                                    </div>
                                    <!-- Departure Information -->
                                    <div class="section-title"><i class="fas fa-calendar me-1"></i>Departure Information
                                    </div>
                                    <div class="row g-3">
                                        <c:if test="${isBooking}">
                                            <!-- For booking: show date/time selection with dynamic loading -->
                                            <div class="col-md-6">
                                                <label for="departureDate" class="form-label">Departure Date *</label>
                                                <select class="form-select" id="departureDate" name="departureDate"
                                                    required>
                                                    <option value="">Select Date</option>
                                                </select>
                                            </div>
                                            <div class="col-md-6">
                                                <label for="departureTime" class="form-label">Departure Time *</label>
                                                <select class="form-select" id="departureTime" name="departureTime"
                                                    required>
                                                    <option value="">Select Time</option>
                                                </select>
                                            </div>
                                        </c:if>
                                        <c:if test="${!isBooking}">
                                            <!-- For admin: show date/time dropdowns with available options -->
                                            <div class="col-md-6">
                                                <label for="departureDate" class="form-label">Departure Date *</label>
                                                <select class="form-select" id="departureDate" name="departureDate"
                                                    required>
                                                    <option value="">Select Date</option>
                                                </select>
                                                <button type="button" class="btn btn-sm btn-outline-info mt-1"
                                                    onclick="loadAvailableSchedules()">
                                                    <i class="fas fa-sync"></i> Refresh Dates
                                                </button>
                                            </div>
                                            <div class="col-md-6">
                                                <label for="departureTime" class="form-label">Departure Time *</label>
                                                <select class="form-select" id="departureTime" name="departureTime"
                                                    required>
                                                    <option value="">Select Time</option>
                                                </select>
                                            </div>
                                        </c:if>
                                    </div>
                                    <!-- Seat Selection -->
                                    <div class="section-title"><i class="fas fa-chair me-1"></i>Seat Selection</div>
                                    <div class="row g-3">
                                        <c:if test="${isBooking}">
                                            <!-- For booking: show seat selection -->
                                            <div class="col-12">
                                                <label class="form-label">Seat Selection *</label>
                                                <div id="seatOptions" class="d-flex flex-wrap gap-2">
                                                    <div class="alert alert-info">
                                                        <i class="fas fa-info-circle"></i> Vui lòng chọn ngày và giờ
                                                        khởi hành trước
                                                    </div>
                                                </div>
                                                <input type="hidden" name="seatNumber" id="seatNumber" required>

                                                <!-- Seat Legend -->
                                                <div class="seat-legend mt-3" id="seatLegend" style="display: none;">
                                                    <h6>Legend:</h6>
                                                    <div class="d-flex gap-3">
                                                        <div class="d-flex align-items-center gap-2">
                                                            <div class="seat-legend-item available"></div>
                                                            <span>Available</span>
                                                        </div>
                                                        <div class="d-flex align-items-center gap-2">
                                                            <div class="seat-legend-item occupied"></div>
                                                            <span>Occupied</span>
                                                        </div>
                                                        <div class="d-flex align-items-center gap-2">
                                                            <div class="seat-legend-item selected"></div>
                                                            <span>Selected</span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <label for="ticketPrice" class="form-label">Ticket Price (₫)</label>
                                                <input type="text" class="form-control" id="ticketPrice"
                                                    name="ticketPrice" value="${route.basePrice}" readonly>
                                                <div class="form-text">Fixed price for this route</div>
                                            </div>
                                        </c:if>
                                        <c:if test="${!isBooking}">
                                            <!-- For admin: show seat input -->
                                            <div class="col-md-6">
                                                <label for="seatNumber" class="form-label">Seat Number *</label>
                                                <input type="number" class="form-control" id="seatNumber"
                                                    name="seatNumber" value="${ticket.seatNumber}" min="1" required>
                                                <div class="form-text">Select seat number from the list below</div>
                                            </div>
                                            <div class="col-md-6">
                                                <label for="ticketPrice" class="form-label">Ticket Price (₫) *</label>
                                                <input type="number" class="form-control" id="ticketPrice"
                                                    name="ticketPrice" value="${ticket.ticketPrice}" min="0" step="1000"
                                                    required>
                                            </div>
                                        </c:if>
                                    </div>
                                    <!-- Seat Map -->
                                    <div id="seatMap" class="mt-3" style="display: none;">
                                        <h6>Bản đồ ghế:</h6>
                                        <div class="seat-selection" id="seatSelection"></div>
                                    </div>
                                    <!-- Price Display -->
                                    <div class="price-display" id="priceDisplay" style="display: none;">
                                        <div>Total: <span id="totalPrice">0</span>₫</div>
                                    </div>
                                    <!-- Status Information -->
                                    <c:if test="${ticket != null}">
                                        <div class="section-title"><i class="fas fa-info-circle me-1"></i>Ticket Status
                                        </div>
                                        <div class="row g-3">
                                            <div class="col-md-6">
                                                <label for="status" class="form-label">Trạng thái</label>
                                                <select class="form-select" id="status" name="status">
                                                    <option value="CONFIRMED" ${ticket.status eq 'CONFIRMED'
                                                        ? 'selected' : '' }>Đã xác
                                                        nhận
                                                    </option>
                                                    <option value="PENDING" ${ticket.status eq 'PENDING' ? 'selected'
                                                        : '' }>Chờ xác
                                                        nhận
                                                    </option>
                                                    <option value="CANCELLED" ${ticket.status eq 'CANCELLED'
                                                        ? 'selected' : '' }>Đã
                                                        hủy
                                                    </option>
                                                </select>
                                            </div>
                                            <div class="col-md-6">
                                                <label for="paymentStatus" class="form-label">Trạng thái thanh
                                                    toán</label>
                                                <select class="form-select" id="paymentStatus" name="paymentStatus">
                                                    <option value="PAID" ${ticket.paymentStatus eq 'PAID' ? 'selected'
                                                        : '' }>Đã thanh
                                                        toán
                                                    </option>
                                                    <option value="PENDING" ${ticket.paymentStatus eq 'PENDING'
                                                        ? 'selected' : '' }>Chờ
                                                        thanh toán
                                                    </option>
                                                    <option value="CANCELLED" ${ticket.paymentStatus eq 'CANCELLED'
                                                        ? 'selected' : '' }>
                                                        Cancelled
                                                    </option>
                                                </select>
                                            </div>
                                        </div>
                                    </c:if>
                                    <!-- Form Actions -->
                                    <div class="d-flex justify-content-between align-items-center mt-4">
                                        <a href="${pageContext.request.contextPath}/tickets"
                                            class="btn btn-outline-secondary">
                                            <i class="fas fa-arrow-left me-2"></i>Back
                                        </a>
                                        <button type="submit" class="btn btn-gradient">
                                            <i class="fas fa-save me-2"></i>
                                            <c:choose>
                                                <c:when test="${isBooking}">Book Ticket</c:when>
                                                <c:when test="${ticket == null}">Add Ticket</c:when>
                                                <c:otherwise>Update</c:otherwise>
                                            </c:choose>
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
                <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                <script>
                    // Set global variables for JSP context
                    window.isBooking = <c:out value="${isBooking != null ? isBooking : false}" />;
                    window.routeId = <c:out value="${route != null ? route.routeId : 'null'}" />;
                    window.contextPath = '${pageContext.request.contextPath}';

                    // Debug logging
                    console.log('Ticket form initialized');
                </script>
                <script src="${pageContext.request.contextPath}/assets/js/ticket-form.js"></script>

                <script src="${pageContext.request.contextPath}/assets/js/validation.js"></script>
            </body>

            </html>