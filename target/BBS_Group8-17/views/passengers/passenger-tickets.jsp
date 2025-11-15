<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <c:if test="${empty sessionScope.user}">
                <script>
                    window.location.href = '${pageContext.request.contextPath}/auth/login?error=You need to login to view your tickets';
                </script>
            </c:if>

            <!DOCTYPE html>
            <html lang="en">

            <head>
                <jsp:include page="/views/partials/head.jsp">
                    <jsp:param name="title" value="My Tickets - Bus Booking System" />
                </jsp:include>
                <style>
                    .ticket-card {
                        transition: transform 0.2s;
                        border: none;
                        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.08);
                        margin-bottom: 20px;
                    }

                    .ticket-card:hover {
                        transform: translateY(-2px);
                        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.13);
                    }

                    .status-badge {
                        font-size: 0.9rem;
                    }

                    .price-info {
                        font-weight: bold;
                        color: #66bb6a;
                        font-size: 1.1rem;
                    }

                    .seat-info {
                        background-color: #e9ecef;
                        padding: 0.25em 0.5em;
                        border-radius: 4px;
                        font-family: monospace;
                        font-weight: bold;
                    }

                    .ticket-number {
                        font-family: monospace;
                        font-weight: bold;
                        color: #495057;
                    }

                    .action-buttons {
                        display: flex;
                        gap: 5px;
                        flex-wrap: wrap;
                    }

                    .rating-stars {
                        color: #ffc107;
                        font-size: 1.2rem;
                    }

                    .search-filters {
                        background: #f8f9fa;
                        padding: 20px;
                        border-radius: 8px;
                        margin-bottom: 20px;
                    }

                    .quick-actions {
                        background: linear-gradient(135deg, #66bb6a 0%, #81c784 100%);
                        color: white;
                        padding: 20px;
                        border-radius: 8px;
                        margin-bottom: 20px;
                    }

                    .quick-actions .btn {
                        margin: 5px;
                    }
                </style>
            </head>

            <body>
                <%@ include file="/views/partials/user-header.jsp" %>

                    <div class="container mt-4">
                        <!-- Header -->
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h2><i class="fas fa-ticket-alt me-2"></i>My Tickets</h2>
                            <div class="action-buttons">
                                <a href="${pageContext.request.contextPath}/search" class="btn btn-primary">
                                    <i class="fas fa-search me-1"></i>Search Routes
                                </a>
                                <a href="${pageContext.request.contextPath}/search" class="btn btn-success">
                                    <i class="fas fa-plus me-1"></i>Book New Ticket
                                </a>
                            </div>
                        </div>

                        <!-- Quick Actions -->
                        <div class="quick-actions">
                            <h5><i class="fas fa-bolt me-2"></i>Quick Actions</h5>
                            <p class="mb-3">Manage your travel bookings and rate your experiences</p>
                            <a href="${pageContext.request.contextPath}/search" class="btn btn-light">
                                <i class="fas fa-search me-1"></i>Find Routes
                            </a>
                            <a href="${pageContext.request.contextPath}/search" class="btn btn-light">
                                <i class="fas fa-ticket-alt me-1"></i>Book Ticket
                            </a>
                            <a href="${pageContext.request.contextPath}/tickets?filter=upcoming" class="btn btn-light">
                                <i class="fas fa-calendar me-1"></i>Upcoming Trips
                            </a>
                            <a href="${pageContext.request.contextPath}/tickets?filter=completed" class="btn btn-light">
                                <i class="fas fa-check-circle me-1"></i>Completed Trips
                            </a>
                        </div>

                        <!-- Messages -->
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

                        <!-- Search and Filter -->
                        <div class="search-filters">
                            <form action="${pageContext.request.contextPath}/tickets" method="get" class="row g-3">
                                <div class="col-md-3">
                                    <label for="status" class="form-label">Status</label>
                                    <select class="form-select" id="status" name="status">
                                        <option value="">All Tickets</option>
                                        <option value="CONFIRMED" ${param.status eq 'CONFIRMED' ? 'selected' : '' }>
                                            Confirmed</option>
                                        <option value="PENDING" ${param.status eq 'PENDING' ? 'selected' : '' }>Pending
                                        </option>
                                        <option value="CANCELLED" ${param.status eq 'CANCELLED' ? 'selected' : '' }>
                                            Cancelled</option>
                                    </select>
                                </div>
                                <div class="col-md-3">
                                    <label for="paymentStatus" class="form-label">Payment</label>
                                    <select class="form-select" id="paymentStatus" name="paymentStatus">
                                        <option value="">All Payments</option>
                                        <option value="PAID" ${param.paymentStatus eq 'PAID' ? 'selected' : '' }>Paid
                                        </option>
                                        <option value="PENDING" ${param.paymentStatus eq 'PENDING' ? 'selected' : '' }>
                                            Pending</option>
                                    </select>
                                </div>
                                <div class="col-md-3">
                                    <label for="dateFrom" class="form-label">From Date</label>
                                    <input type="date" class="form-control" id="dateFrom" name="dateFrom"
                                        value="${param.dateFrom}">
                                </div>
                                <div class="col-md-3 d-flex align-items-end">
                                    <button type="submit" class="btn btn-outline-primary me-2">
                                        <i class="fas fa-search me-1"></i>Filter
                                    </button>
                                    <a href="${pageContext.request.contextPath}/tickets"
                                        class="btn btn-outline-secondary">
                                        <i class="fas fa-refresh me-1"></i>Clear
                                    </a>
                                </div>
                            </form>
                        </div>

                        <!-- Tickets Display -->
                        <c:choose>
                            <c:when test="${empty tickets}">
                                <div class="text-center py-5">
                                    <i class="fas fa-ticket-alt fa-3x text-muted mb-3"></i>
                                    <h5 class="text-muted">You have no tickets yet</h5>
                                    <p class="text-muted">Book your first ticket to start your journey!</p>
                                    <a href="${pageContext.request.contextPath}/search" class="btn btn-primary">
                                        <i class="fas fa-search me-1"></i>Find Routes
                                    </a>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <!-- Grid View -->
                                <div class="row g-4" id="ticketsGrid">
                                    <c:forEach var="ticket" items="${tickets}">
                                        <div class="col-md-6 col-lg-4">
                                            <div class="card ticket-card h-100">
                                                <div class="card-header text-white" style="background: linear-gradient(135deg, #66bb6a, #4caf50);">
                                                    <div class="d-flex justify-content-between align-items-center">
                                                        <h6 class="mb-0">
                                                            <i class="fas fa-ticket-alt me-2"></i>
                                                            <span class="ticket-number">${ticket.ticketNumber}</span>
                                                        </h6>
                                                        <span class="badge status-badge
                                            <c:choose>
                                                <c:when test=" ${ticket.status eq 'CONFIRMED' }">bg-success</c:when>
                                                            <c:when test=" ${ticket.status eq 'COMPLETED' }">bg-success
                                                            </c:when>
                                                            <c:when test="${ticket.status eq 'PENDING'}">bg-warning
                                                            </c:when>
                                                            <c:when test="${ticket.status eq 'CANCELLED'}">bg-danger
                                                            </c:when>
                                                            <c:otherwise>bg-secondary</c:otherwise>
                        </c:choose>
                        ">
                        <c:choose>
                            <c:when test="${ticket.status eq 'CONFIRMED'}">Confirmed</c:when>
                            <c:when test="${ticket.status eq 'COMPLETED'}">Completed</c:when>
                            <c:when test="${ticket.status eq 'PENDING'}">Pending</c:when>
                            <c:when test="${ticket.status eq 'CANCELLED'}">Cancelled</c:when>
                            <c:otherwise>${ticket.status}</c:otherwise>
                        </c:choose>
                        </span>
                    </div>
                    </div>
                    <div class="card-body">
                        <div class="mb-3">
                            <strong>Route:</strong> ${ticket.routeName}<br>
                            <small class="text-muted">${ticket.departureCity} → ${ticket.destinationCity}</small>
                        </div>
                        <div class="mb-3">
                            <strong>Bus:</strong> ${ticket.busNumber}<br>
                            <strong>Seat:</strong> <span class="seat-info">${ticket.seatNumber}</span>
                        </div>
                        <div class="mb-3">
                            <strong>Departure:</strong><br>
                            <i class="fas fa-calendar me-1"></i>
                            <fmt:formatDate value="${ticket.departureDateSql}" pattern="dd/MM/yyyy" />
                            <i class="fas fa-clock me-1"></i>
                            <fmt:formatDate value="${ticket.departureTimeSql}" pattern="HH:mm" />
                        </div>
                        <div class="mb-3">
                            <strong>Price:</strong>
                            <div class="price-info">
                                <fmt:formatNumber value="${ticket.ticketPrice}" type="currency" currencySymbol="₫"
                                    maxFractionDigits="0" />
                            </div>
                        </div>
                        <div class="mb-3">
                            <strong>Payment:</strong>
                            <span class="badge
                                            <c:choose>
                                                <c:when test=" ${ticket.paymentStatus eq 'PAID' }">bg-success</c:when>
                                <c:when test="${ticket.paymentStatus eq 'PENDING'}">bg-warning</c:when>
                                <c:otherwise>bg-secondary</c:otherwise>
                                </c:choose>
                                ">
                                <c:choose>
                                    <c:when test="${ticket.paymentStatus eq 'PAID'}">Paid</c:when>
                                    <c:when test="${ticket.paymentStatus eq 'PENDING'}">Pending Payment</c:when>
                                    <c:otherwise>${ticket.paymentStatus}</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                    </div>
                    <div class="card-footer bg-transparent">
                        <div class="action-buttons">
                            <!-- View Details -->
                            <button type="button" class="btn btn-sm btn-info" title="View Details"
                                data-bs-toggle="modal" data-bs-target="#ticketDetailModal"
                                data-ticketid="${ticket.ticketId}" data-ticketnumber="${ticket.ticketNumber}"
                                data-username="<c:out value='${ticket.userName}'/>"
                                data-routename="<c:out value='${ticket.routeName}'/>"
                                data-busnumber="<c:out value='${ticket.busNumber}'/>"
                                data-seatnumber="${ticket.seatNumber}"
                                data-departuredate="<fmt:formatDate value='${ticket.departureDateSql}' pattern='dd/MM/yyyy'/>"
                                data-departuretime="<fmt:formatDate value='${ticket.departureTimeSql}' pattern='HH:mm'/>"
                                data-ticketprice="${ticket.ticketPrice}" data-status="${ticket.status}"
                                data-paymentstatus="${ticket.paymentStatus}">
                                <i class="fas fa-eye"></i>
                            </button>



                            <!-- Rate Driver button khi vé COMPLETED và đã thanh toán -->
                            <c:if test="${ticket.status eq 'COMPLETED' and ticket.paymentStatus eq 'PAID'}">
                                <button type="button" class="btn btn-sm btn-warning" title="Rate Driver"
                                    data-bs-toggle="modal" data-bs-target="#ratingModal"
                                    data-ticketid="${ticket.ticketId}" data-ticketnumber="${ticket.ticketNumber}"
                                    data-drivername="<c:out value='${ticket.driverName}'/>">
                                    <i class="fas fa-star"></i>
                                </button>
                            </c:if>

                            <!-- Cancel Ticket (only for pending/confirmed) -->
                            <c:if test="${ticket.status eq 'PENDING' or ticket.status eq 'CONFIRMED'}">
                                <button type="button" class="btn btn-sm btn-danger" title="Cancel Ticket"
                                    onclick="confirmCancel('${ticket.ticketId}', '${ticket.ticketNumber}')">
                                    <i class="fas fa-times"></i>
                                </button>
                            </c:if>
                        </div>
                    </div>
                    </div>
                    </div>
                    </c:forEach>
                    </div>
                    </c:otherwise>
                    </c:choose>
                    </div>

                    <!-- Ticket Detail Modal -->
                    <div class="modal fade" id="ticketDetailModal" tabindex="-1"
                        aria-labelledby="ticketDetailModalLabel" aria-hidden="true">
                        <div class="modal-dialog modal-lg">
                            <div class="modal-content">
                                <div class="modal-header text-white" style="background: linear-gradient(135deg, #66bb6a, #4caf50);">
                                    <h5 class="modal-title" id="ticketDetailModalLabel">
                                        <i class="fas fa-ticket-alt me-2"></i>Ticket Details
                                    </h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                </div>
                                <div class="modal-body">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <h6 class="text-primary">Ticket Information</h6>
                                            <dl class="row">
                                                <dt class="col-5">Ticket Number:</dt>
                                                <dd class="col-7" id="detailTicketNumber"></dd>
                                                <dt class="col-5">Status:</dt>
                                                <dd class="col-7" id="detailStatus"></dd>
                                                <dt class="col-5">Payment:</dt>
                                                <dd class="col-7" id="detailPaymentStatus"></dd>
                                                <dt class="col-5">Price:</dt>
                                                <dd class="col-7" id="detailTicketPrice"></dd>
                                            </dl>
                                        </div>
                                        <div class="col-md-6">
                                            <h6 class="text-primary">Journey Details</h6>
                                            <dl class="row">
                                                <dt class="col-5">Route:</dt>
                                                <dd class="col-7" id="detailRouteName"></dd>
                                                <dt class="col-5">Bus:</dt>
                                                <dd class="col-7" id="detailBusNumber"></dd>
                                                <dt class="col-5">Seat:</dt>
                                                <dd class="col-7" id="detailSeatNumber"></dd>
                                                <dt class="col-5">Departure:</dt>
                                                <dd class="col-7">
                                                    <span id="detailDepartureDate"></span><br>
                                                    <small id="detailDepartureTime"></small>
                                                </dd>
                                            </dl>
                                        </div>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary"
                                        data-bs-dismiss="modal">Close</button>

                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Rating Modal -->
                    <div class="modal fade" id="ratingModal" tabindex="-1" aria-labelledby="ratingModalLabel"
                        aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header bg-warning text-dark">
                                    <h5 class="modal-title" id="ratingModalLabel">
                                        <i class="fas fa-star me-2"></i>Rate Your Driver
                                    </h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                </div>
                                <form action="${pageContext.request.contextPath}/tickets/rate" method="post">
                                    <div class="modal-body">
                                        <input type="hidden" id="ratingTicketId" name="ticketId">
                                        <div class="mb-3">
                                            <label class="form-label">Ticket: <span
                                                    id="ratingTicketNumber"></span></label>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">Driver: <span
                                                    id="ratingDriverName"></span></label>
                                        </div>
                                        <div class="mb-3">
                                            <label for="ratingValue" class="form-label">Rating</label>
                                            <div class="rating-stars" id="starRating">
                                                <i class="fas fa-star" data-rating="1"></i>
                                                <i class="fas fa-star" data-rating="2"></i>
                                                <i class="fas fa-star" data-rating="3"></i>
                                                <i class="fas fa-star" data-rating="4"></i>
                                                <i class="fas fa-star" data-rating="5"></i>
                                            </div>
                                            <input type="hidden" id="ratingValue" name="ratingValue" value="5">
                                        </div>
                                        <div class="mb-3">
                                            <label for="comments" class="form-label">Comments (Optional)</label>
                                            <textarea class="form-control" id="comments" name="comments" rows="3"
                                                placeholder="Share your experience with this driver..."></textarea>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary"
                                            data-bs-dismiss="modal">Cancel</button>
                                        <button type="submit" class="btn btn-warning">
                                            <i class="fas fa-star me-1"></i>Submit Rating
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>

                    <!-- Cancel Confirmation Modal -->
                    <div class="modal fade" id="cancelModal" tabindex="-1">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title">Confirm Ticket Cancellation</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                </div>
                                <div class="modal-body">
                                    <p>Are you sure you want to cancel ticket <strong id="cancelTicketNumber"></strong>?
                                    </p>
                                    <p class="text-danger"><small>This action cannot be undone. Refund policy
                                            applies.</small></p>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Keep
                                        Ticket</button>
                                    <a href="#" id="confirmCancelBtn" class="btn btn-danger">
                                        <i class="fas fa-times me-1"></i>Cancel Ticket
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>

                    <%@ include file="/views/partials/footer.jsp" %>

                        <script>
                            // Populate ticket detail modal
                            document.addEventListener('DOMContentLoaded', function () {
                                var ticketDetailModal = document.getElementById('ticketDetailModal');
                                ticketDetailModal.addEventListener('show.bs.modal', function (event) {
                                    var button = event.relatedTarget;
                                    document.getElementById('detailTicketNumber').textContent = button.getAttribute('data-ticketnumber');
                                    document.getElementById('detailRouteName').textContent = button.getAttribute('data-routename');
                                    document.getElementById('detailBusNumber').textContent = button.getAttribute('data-busnumber');
                                    document.getElementById('detailSeatNumber').textContent = button.getAttribute('data-seatnumber');
                                    document.getElementById('detailDepartureDate').textContent = button.getAttribute('data-departuredate');
                                    document.getElementById('detailDepartureTime').textContent = button.getAttribute('data-departuretime');
                                    document.getElementById('detailTicketPrice').textContent =
                                        Number(button.getAttribute('data-ticketprice')).toLocaleString('vi-VN') + ' ₫';

                                    // Status
                                    var status = button.getAttribute('data-status');
                                    document.getElementById('detailStatus').innerHTML =
                                        status === 'CONFIRMED' ? '<span class="badge bg-success">Confirmed</span>' :
                                            status === 'COMPLETED' ? '<span class="badge bg-success">Completed</span>' :
                                                status === 'PENDING' ? '<span class="badge bg-warning">Pending</span>' :
                                                    status === 'CANCELLED' ? '<span class="badge bg-danger">Cancelled</span>' :
                                                        '<span class="badge bg-secondary">' + status + '</span>';

                                    // Payment status
                                    var paymentStatus = button.getAttribute('data-paymentstatus');
                                    document.getElementById('detailPaymentStatus').innerHTML =
                                        paymentStatus === 'PAID' ? '<span class="badge bg-success">Paid</span>' :
                                            paymentStatus === 'PENDING' ? '<span class="badge bg-warning">Pending Payment</span>' :
                                                '<span class="badge bg-secondary">' + paymentStatus + '</span>';


                                });

                                // Rating modal
                                var ratingModal = document.getElementById('ratingModal');
                                ratingModal.addEventListener('show.bs.modal', function (event) {
                                    var button = event.relatedTarget;
                                    document.getElementById('ratingTicketId').value = button.getAttribute('data-ticketid');
                                    document.getElementById('ratingTicketNumber').textContent = button.getAttribute('data-ticketnumber');
                                    document.getElementById('ratingDriverName').textContent = button.getAttribute('data-drivername');
                                });

                                // Star rating functionality
                                const stars = document.querySelectorAll('#starRating i');
                                stars.forEach((star, index) => {
                                    star.addEventListener('click', function () {
                                        const rating = this.getAttribute('data-rating');
                                        document.getElementById('ratingValue').value = rating;

                                        // Update star display
                                        stars.forEach((s, i) => {
                                            if (i < rating) {
                                                s.classList.add('fas');
                                                s.classList.remove('far');
                                            } else {
                                                s.classList.add('far');
                                                s.classList.remove('fas');
                                            }
                                        });
                                    });

                                    star.addEventListener('mouseover', function () {
                                        const rating = this.getAttribute('data-rating');
                                        stars.forEach((s, i) => {
                                            if (i < rating) {
                                                s.classList.add('fas');
                                                s.classList.remove('far');
                                            } else {
                                                s.classList.add('far');
                                                s.classList.remove('fas');
                                            }
                                        });
                                    });
                                });

                                // Reset stars on mouse leave
                                document.getElementById('starRating').addEventListener('mouseleave', function () {
                                    const currentRating = document.getElementById('ratingValue').value;
                                    stars.forEach((s, i) => {
                                        if (i < currentRating) {
                                            s.classList.add('fas');
                                            s.classList.remove('far');
                                        } else {
                                            s.classList.add('far');
                                            s.classList.remove('fas');
                                        }
                                    });
                                });
                            });

                            function confirmCancel(ticketId, ticketNumber) {
                                document.getElementById('cancelTicketNumber').textContent = ticketNumber;
                                document.getElementById('confirmCancelBtn').href =
                                    '${pageContext.request.contextPath}/tickets/cancel?id=' + ticketId;
                                new bootstrap.Modal(document.getElementById('cancelModal')).show();
                            }
                        </script>
            </body>

            </html>