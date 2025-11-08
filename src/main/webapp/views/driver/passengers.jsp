<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Passengers - Driver Dashboard</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
            <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
            <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
            <style>
                .passenger-card {
                    transition: transform 0.2s ease-in-out;
                }

                .passenger-card:hover {
                    transform: translateY(-2px);
                }

                .header-section {
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    border-radius: 15px;
                    padding: 2rem;
                    margin-bottom: 2rem;
                    color: white;
                }

                .trip-info {
                    background: rgba(255, 255, 255, 0.1);
                    border-radius: 10px;
                    padding: 1.5rem;
                    margin-top: 1rem;
                }
            </style>
        </head>

        <body>
            <jsp:include page="../partials/driver-header.jsp" />

            <div class="container-fluid py-4">
                <div class="row">
                    <div class="col-12">
                        <!-- Header Section -->
                        <div class="header-section">
                            <div class="row align-items-center">
                                <div class="col-md-8">
                                    <h2 class="mb-0">
                                        <i class="fas fa-users me-2"></i>Passenger List
                                    </h2>
                                    <p class="mb-0 mt-2">View passenger details for this trip</p>
                                </div>
                                <div class="col-md-4 text-md-end">
                                    <a href="${pageContext.request.contextPath}/driver/trips" class="btn btn-light">
                                        <i class="fas fa-arrow-left me-2"></i>Back to Trips
                                    </a>
                                </div>
                            </div>

                            <!-- Trip Information -->
                            <div class="trip-info">
                                <div class="row">
                                    <div class="col-md-3">
                                        <div class="d-flex justify-content-between">
                                            <span>Route:</span>
                                            <span class="fw-bold">${schedule.routeName}</span>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="d-flex justify-content-between">
                                            <span>Date:</span>
                                            <span class="fw-bold">${schedule.departureDate}</span>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="d-flex justify-content-between">
                                            <span>Time:</span>
                                            <span class="fw-bold">${schedule.departureTime}</span>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="d-flex justify-content-between">
                                            <span>Bus:</span>
                                            <span class="fw-bold">${schedule.busNumber}</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
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

                        <!-- Passengers List -->
                        <div class="row" id="passengersContainer">
                            <c:forEach var="passenger" items="${passengers}">
                                <div class="col-lg-4 col-md-6 mb-4 passenger-item">
                                    <div class="card passenger-card h-100 shadow-sm">
                                        <div class="card-header bg-info text-white">
                                            <div class="d-flex justify-content-between align-items-center">
                                                <h6 class="mb-0">
                                                    <i class="fas fa-user me-2"></i>${passenger.userName}
                                                </h6>
                                                <span class="badge bg-light text-dark">
                                                    Seat ${passenger.seatNumber}
                                                </span>
                                            </div>
                                        </div>
                                        <div class="card-body">
                                            <div class="mb-3">
                                                <div class="d-flex justify-content-between">
                                                    <span class="text-muted">Ticket ID:</span>
                                                    <span class="fw-bold">${passenger.ticketNumber}</span>
                                                </div>
                                                <div class="d-flex justify-content-between">
                                                    <span class="text-muted">Username:</span>
                                                    <span class="fw-bold">${passenger.username}</span>
                                                </div>
                                                <div class="d-flex justify-content-between">
                                                    <span class="text-muted">Email:</span>
                                                    <span class="fw-bold">${passenger.userEmail}</span>
                                                </div>
                                            </div>

                                            <div class="mb-3">
                                                <div class="d-flex justify-content-between">
                                                    <span class="text-muted">Booking Date:</span>
                                                    <span class="fw-bold">${passenger.bookingDateStr}</span>
                                                </div>
                                                <div class="d-flex justify-content-between">
                                                    <span class="text-muted">Payment Status:</span>
                                                    <span class="badge 
                                                <c:choose>
                                                    <c:when test=" ${passenger.paymentStatus=='PAID' }">bg-success
                                                        </c:when>
                                                        <c:when test="${passenger.paymentStatus == 'PENDING'}">
                                                            bg-warning
                                                        </c:when>
                                                        <c:otherwise>bg-danger
                                                        </c:otherwise>
                                                        </c:choose>">
                                                        ${passenger.paymentStatus}
                                                    </span>
                                                </div>
                                            </div>

                                            <div class="mb-3">
                                                <div class="d-flex justify-content-between">
                                                    <span class="text-muted">Ticket Status:</span>
                                                    <span class="badge 
                                                <c:choose>
                                                    <c:when test=" ${passenger.status=='CONFIRMED' }">bg-success
                                                        </c:when>
                                                        <c:when test="${passenger.status == 'CANCELLED'}">
                                                            bg-danger
                                                        </c:when>
                                                        <c:otherwise>bg-secondary
                                                        </c:otherwise>
                                                        </c:choose>">
                                                        ${passenger.status}
                                                    </span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="card-footer bg-light">
                                            <div class="d-flex justify-content-between align-items-center">
                                                <small class="text-muted">
                                                    <i class="fas fa-ticket-alt me-1"></i>
                                                    Ticket #${passenger.ticketNumber}
                                                </small>
                                                <small class="text-muted">
                                                    <i class="fas fa-dollar-sign me-1"></i>
                                                    $${passenger.ticketPrice}
                                                </small>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>

                        <!-- No Results Message -->
                        <div id="noResults" class="text-center py-5" style="display: none;">
                            <i class="fas fa-users fa-3x text-muted mb-3"></i>
                            <h4 class="text-muted">No passengers found</h4>
                            <p class="text-muted">No passengers have booked this trip yet</p>
                        </div>
                    </div>
                </div>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
            <script>
                // Show no results message if no passengers
                document.addEventListener('DOMContentLoaded', function () {
                    const passengerItems = document.querySelectorAll('.passenger-item');
                    const noResults = document.getElementById('noResults');

                    if (passengerItems.length === 0) {
                        noResults.style.display = 'block';
                    }
                });
            </script>
        </body>

        </html>