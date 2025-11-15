<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

            <!DOCTYPE html>
            <html lang="en">

            <head>
                <jsp:include page="/views/partials/head.jsp">
                    <jsp:param name="title" value="Rate Driver - Bus Booking System" />
                </jsp:include>
                <style>
                    .rating-container {
                        background: linear-gradient(135deg, #ffc107 0%, #ff8c00 100%);
                        color: white;
                        padding: 30px 0;
                        margin-bottom: 30px;
                    }

                    .rating-card {
                        background: white;
                        color: #333;
                        border-radius: 10px;
                        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
                        margin-bottom: 20px;
                    }

                    .star-rating {
                        font-size: 2rem;
                        color: #ffc107;
                        cursor: pointer;
                        transition: color 0.2s;
                    }

                    .star-rating:hover {
                        color: #ff8c00;
                    }

                    .star-rating.selected {
                        color: #ff8c00;
                    }

                    .trip-summary {
                        background: #f8f9fa;
                        border-radius: 8px;
                        padding: 20px;
                        margin-bottom: 20px;
                    }

                    .rating-form {
                        background: #fff;
                        border-radius: 10px;
                        padding: 30px;
                        box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
                    }

                    .rating-scale {
                        display: flex;
                        justify-content: center;
                        gap: 10px;
                        margin: 20px 0;
                    }

                    .rating-scale .star {
                        font-size: 3rem;
                        color: #e9ecef;
                        cursor: pointer;
                        transition: all 0.2s;
                    }

                    .rating-scale .star:hover,
                    .rating-scale .star.selected {
                        color: #ffc107;
                        transform: scale(1.1);
                    }

                    .rating-labels {
                        display: flex;
                        justify-content: space-between;
                        margin-top: 10px;
                        font-size: 0.9rem;
                        color: #6c757d;
                    }

                    .comments-section {
                        margin-top: 30px;
                    }

                    .btn-submit {
                        background: linear-gradient(135deg, #ffc107 0%, #ff8c00 100%);
                        border: none;
                        color: white;
                        font-weight: 600;
                        padding: 12px 30px;
                    }

                    .btn-submit:hover {
                        transform: translateY(-2px);
                        box-shadow: 0 5px 15px rgba(255, 193, 7, 0.4);
                    }

                    .rating-preview {
                        background: #e3f2fd;
                        border-radius: 8px;
                        padding: 15px;
                        margin-top: 20px;
                        display: none;
                    }

                    .driver-info {
                        background: #f8f9fa;
                        border-radius: 8px;
                        padding: 20px;
                        margin-bottom: 20px;
                    }

                    .ticket-info {
                        background: #e8f5e8;
                        border-radius: 8px;
                        padding: 20px;
                        margin-bottom: 20px;
                    }
                </style>
            </head>

            <body>
                <%@ include file="/views/partials/user-header.jsp" %>

                    <div class="container mt-4">
                        <!-- Notification Messages -->
                        <c:if test="${not empty param.message}">
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                <i class="fas fa-check-circle me-2"></i>
                                <strong>Success!</strong> ${param.message}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>
                        <c:if test="${not empty param.error}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="fas fa-exclamation-circle me-2"></i>
                                <strong>Error!</strong> ${param.error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>
                        <c:if test="${not empty param.warning}">
                            <div class="alert alert-warning alert-dismissible fade show" role="alert">
                                <i class="fas fa-exclamation-triangle me-2"></i>
                                <strong>Warning!</strong> ${param.warning}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>
                        <c:if test="${not empty param.info}">
                            <div class="alert alert-info alert-dismissible fade show" role="alert">
                                <i class="fas fa-info-circle me-2"></i>
                                <strong>Info:</strong> ${param.info}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>

                        <!-- Header -->
                        <div class="rating-container">
                            <div class="container">
                                <div class="text-center">
                                    <h1 class="display-4 mb-3">
                                        <i class="fas fa-star me-3"></i>Rate Your Driver
                                    </h1>
                                    <p class="lead">Help us improve our service by sharing your experience</p>
                                </div>
                            </div>
                        </div>

                        <!-- Rating Form -->
                        <div class="row justify-content-center">
                            <div class="col-lg-8">
                                <div class="rating-card">
                                    <div class="card-body">
                                        <!-- Trip Summary -->
                                        <div class="trip-summary">
                                            <h5 class="text-primary mb-3">
                                                <i class="fas fa-route me-2"></i>Trip Details
                                            </h5>
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <p class="mb-1">
                                                        <strong>Route:</strong> ${ticket.routeName}
                                                    </p>
                                                    <p class="mb-1">
                                                        <strong>From:</strong> ${ticket.departureCity}
                                                    </p>
                                                    <p class="mb-1">
                                                        <strong>To:</strong> ${ticket.destinationCity}
                                                    </p>
                                                    <p class="mb-1">
                                                        <strong>Date:</strong>
                                                        <fmt:formatDate value="${ticket.departureDateSql}"
                                                            pattern="EEEE, MMMM dd, yyyy" />
                                                    </p>
                                                </div>
                                                <div class="col-md-6">
                                                    <p class="mb-1">
                                                        <strong>Bus:</strong> ${ticket.busNumber}
                                                    </p>
                                                    <p class="mb-1">
                                                        <strong>Seat:</strong> ${ticket.seatNumber}
                                                    </p>
                                                    <p class="mb-1">
                                                        <strong>Departure:</strong>
                                                        <fmt:formatDate value="${ticket.departureTimeSql}"
                                                            pattern="HH:mm" />
                                                    </p>
                                                    <p class="mb-1">
                                                        <strong>Ticket:</strong> ${ticket.ticketNumber}
                                                    </p>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Driver Information -->
                                        <div class="driver-info">
                                            <h5 class="text-warning mb-3">
                                                <i class="fas fa-user-tie me-2"></i>Driver Information
                                            </h5>
                                            <div class="row">
                                                <div class="col-md-8">
                                                    <h6>${driver.fullName}</h6>
                                                    <p class="text-muted mb-1">
                                                        <i class="fas fa-id-card me-1"></i>License:
                                                        ${driver.licenseNumber}
                                                    </p>
                                                    <p class="text-muted mb-1">
                                                        <i class="fas fa-calendar me-1"></i>Experience:
                                                        ${driver.experienceYears} years
                                                    </p>
                                                </div>
                                                <div class="col-md-4 text-end">
                                                    <div class="rating-stats">
                                                        <c:set var="avgRating" value="${driver.averageRating}" />
                                                        <c:choose>
                                                            <c:when test="${avgRating > 0}">
                                                                <div class="star-rating">
                                                                    <c:forEach begin="1" end="5" var="i">
                                                                        <i
                                                                            class="fas fa-star ${i <= avgRating ? 'selected' : ''}"></i>
                                                                    </c:forEach>
                                                                </div>
                                                                <small class="text-muted">${driver.totalRatings}
                                                                    ratings</small>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <small class="text-muted">No ratings yet</small>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Rating Form -->
                                        <form action="${pageContext.request.contextPath}/tickets/rate" method="post"
                                            id="ratingForm">
                                            <input type="hidden" name="ticketId" value="${ticket.ticketId}">

                                            <div class="rating-form">
                                                <h5 class="mb-4">
                                                    <i class="fas fa-star me-2"></i>How was your experience?
                                                </h5>

                                                <!-- Star Rating -->
                                                <div class="text-center">
                                                    <div class="rating-scale" id="starRating">
                                                        <i class="fas fa-star star" data-rating="1"></i>
                                                        <i class="fas fa-star star" data-rating="2"></i>
                                                        <i class="fas fa-star star" data-rating="3"></i>
                                                        <i class="fas fa-star star" data-rating="4"></i>
                                                        <i class="fas fa-star star" data-rating="5"></i>
                                                    </div>
                                                    <div class="rating-labels">
                                                        <span>Poor</span>
                                                        <span>Fair</span>
                                                        <span>Good</span>
                                                        <span>Very Good</span>
                                                        <span>Excellent</span>
                                                    </div>
                                                    <input type="hidden" id="ratingValue" name="ratingValue" value="5">
                                                </div>

                                                <!-- Rating Preview -->
                                                <div class="rating-preview" id="ratingPreview">
                                                    <h6>Your Rating: <span id="previewRating"></span></h6>
                                                    <p id="previewDescription"></p>
                                                </div>

                                                <!-- Comments Section -->
                                                <div class="comments-section">
                                                    <label for="comments" class="form-label">
                                                        <i class="fas fa-comment me-2"></i>Additional Comments
                                                        (Optional)
                                                    </label>
                                                    <textarea class="form-control" id="comments" name="comments"
                                                        rows="4"
                                                        placeholder="Tell us more about your experience with this driver..."></textarea>
                                                    <div class="form-text">
                                                        Your feedback helps us improve our service and helps other
                                                        passengers make informed decisions.
                                                    </div>
                                                </div>

                                                <!-- Submit Button -->
                                                <div class="text-center mt-4">
                                                    <button type="button" class="btn btn-secondary me-3"
                                                        onclick="history.back()">
                                                        <i class="fas fa-arrow-left me-1"></i>Cancel
                                                    </button>
                                                    <button type="submit" class="btn btn-submit">
                                                        <i class="fas fa-star me-2"></i>Submit Rating
                                                    </button>
                                                </div>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <%@ include file="/views/partials/footer.jsp" %>

                        <script>
                            // Auto-hide alerts after 5 seconds
                            document.addEventListener('DOMContentLoaded', function () {
                                const alerts = document.querySelectorAll('.alert');
                                alerts.forEach(function(alert) {
                                    setTimeout(function() {
                                        const bsAlert = new bootstrap.Alert(alert);
                                        bsAlert.close();
                                    }, 5000);
                                });

                                // Scroll to top if there's a message
                                if (alerts.length > 0) {
                                    window.scrollTo({ top: 0, behavior: 'smooth' });
                                }
                            });
                        </script>
                        <script>
                            let selectedRating = 5;
                            const ratingDescriptions = {
                                1: "Poor - Very dissatisfied with the service",
                                2: "Fair - Below expectations",
                                3: "Good - Met basic expectations",
                                4: "Very Good - Exceeded expectations",
                                5: "Excellent - Outstanding service"
                            };

                            document.addEventListener('DOMContentLoaded', function () {
                                const stars = document.querySelectorAll('.star');
                                const ratingValueInput = document.getElementById('ratingValue');
                                const ratingPreview = document.getElementById('ratingPreview');
                                const previewRating = document.getElementById('previewRating');
                                const previewDescription = document.getElementById('previewDescription');

                                // Initialize with 5 stars selected
                                updateStarDisplay(5);
                                updatePreview(5);

                                stars.forEach(star => {
                                    star.addEventListener('click', function () {
                                        const rating = parseInt(this.dataset.rating);
                                        selectedRating = rating;
                                        ratingValueInput.value = rating;
                                        updateStarDisplay(rating);
                                        updatePreview(rating);
                                    });

                                    star.addEventListener('mouseover', function () {
                                        const rating = parseInt(this.dataset.rating);
                                        updateStarDisplay(rating);
                                    });
                                });

                                // Reset to selected rating on mouse leave
                                document.getElementById('starRating').addEventListener('mouseleave', function () {
                                    updateStarDisplay(selectedRating);
                                });

                                function updateStarDisplay(rating) {
                                    stars.forEach((star, index) => {
                                        if (index < rating) {
                                            star.classList.add('selected');
                                        } else {
                                            star.classList.remove('selected');
                                        }
                                    });
                                }

                                function updatePreview(rating) {
                                    previewRating.textContent = rating + ' star' + (rating > 1 ? 's' : '');
                                    previewDescription.textContent = ratingDescriptions[rating];
                                    ratingPreview.style.display = 'block';
                                }
                            });
                        </script>
            </body>

            </html>

