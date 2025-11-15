<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

            <!DOCTYPE html>
            <html lang="en">

            <head>
                <jsp:include page="/views/partials/head.jsp">
                    <jsp:param name="title" value="Edit Rating - Bus Booking System" />
                </jsp:include>
                <style>
                    .rating-card {
                        background: #fff;
                        border-radius: 10px;
                        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
                    }

                    .star {
                        font-size: 2rem;
                        color: #e9ecef;
                        cursor: pointer;
                        transition: transform 0.15s, color 0.15s;
                    }

                    .star.selected {
                        color: #ffc107;
                        transform: scale(1.06);
                    }

                    .driver-info,
                    .ticket-info {
                        background: #f8f9fa;
                        border-radius: 8px;
                        padding: 16px;
                    }
                </style>
            </head>

            <body>
                <%@ include file="/views/partials/user-header.jsp" %>

                    <div class="container mt-4">
                        <div class="row justify-content-center">
                            <div class="col-lg-8">
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

                                <div class="rating-card p-4">
                                    <h3 class="mb-3"><i class="fas fa-edit me-2"></i>Edit Your Rating</h3>

                                    <c:if test="${empty rating}">
                                        <div class="alert alert-danger">Rating not found.</div>
                                    </c:if>

                                    <c:if test="${not empty rating}">
                                        <div class="row g-3 mb-3">
                                            <div class="col-md-6">
                                                <div class="ticket-info">
                                                    <h6 class="text-primary mb-2"><i
                                                            class="fas fa-ticket-alt me-1"></i>Ticket</h6>
                                                    <div><strong>No:</strong> ${ticket.ticketNumber}</div>
                                                    <div>
                                                        <strong>Route:</strong> ${ticket.routeName}
                                                    </div>
                                                    <div>
                                                        <strong>Departure:</strong>
                                                        <fmt:formatDate value="${ticket.departureDateSql}"
                                                            pattern="dd/MM/yyyy" />
                                                        <small class="ms-1">
                                                            <fmt:formatDate value="${ticket.departureTimeSql}"
                                                                pattern="HH:mm" />
                                                        </small>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="driver-info">
                                                    <h6 class="text-warning mb-2"><i
                                                            class="fas fa-user-tie me-1"></i>Driver</h6>
                                                    <div><strong>${driver.fullName}</strong></div>
                                                    <div class="text-muted">License: ${driver.licenseNumber}</div>
                                                </div>
                                            </div>
                                        </div>

                                        <form action="${pageContext.request.contextPath}/tickets/rate/edit"
                                            method="post" id="editRatingForm">
                                            <input type="hidden" name="ratingId" value="${rating.ratingId}" />
                                            <div class="mb-3">
                                                <label class="form-label"><i class="fas fa-star me-1"></i>Rating</label>
                                                <div id="starRating" class="d-flex gap-2">
                                                    <i class="fas fa-star star" data-rating="1"></i>
                                                    <i class="fas fa-star star" data-rating="2"></i>
                                                    <i class="fas fa-star star" data-rating="3"></i>
                                                    <i class="fas fa-star star" data-rating="4"></i>
                                                    <i class="fas fa-star star" data-rating="5"></i>
                                                </div>
                                                <input type="hidden" id="ratingValue" name="ratingValue"
                                                    value="${rating.ratingValue}" />
                                            </div>

                                            <div class="mb-3">
                                                <label for="comments" class="form-label"><i
                                                        class="fas fa-comment me-1"></i>Comments (optional)</label>
                                                <textarea id="comments" name="comments" rows="4" class="form-control"
                                                    placeholder="Update your feedback...">${rating.comments}</textarea>
                                            </div>

                                            <div class="d-flex justify-content-between">
                                                <a href="${pageContext.request.contextPath}/tickets/rate/list"
                                                    class="btn btn-outline-secondary">
                                                    <i class="fas fa-arrow-left me-1"></i>Back
                                                </a>
                                                <button type="submit" class="btn btn-warning text-dark">
                                                    <i class="fas fa-save me-1"></i>Save Changes
                                                </button>
                                            </div>
                                        </form>
                                    </c:if>
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
                            (function () {
                                const stars = document.querySelectorAll('#starRating .star');
                                const hiddenInput = document.getElementById('ratingValue');
                                let current = parseInt(hiddenInput.value || '5', 10);

                                function refresh() {
                                    stars.forEach((s, idx) => {
                                        if (idx < current) s.classList.add('selected'); else s.classList.remove('selected');
                                    });
                                }

                                stars.forEach(star => {
                                    star.addEventListener('click', function () {
                                        current = parseInt(this.dataset.rating, 10);
                                        hiddenInput.value = current;
                                        refresh();
                                    });
                                    star.addEventListener('mouseover', function () {
                                        const hoverVal = parseInt(this.dataset.rating, 10);
                                        stars.forEach((s, idx) => {
                                            if (idx < hoverVal) s.classList.add('selected'); else s.classList.remove('selected');
                                        });
                                    });
                                });

                                document.getElementById('starRating').addEventListener('mouseleave', refresh);
                                refresh();
                            })();
                        </script>
            </body>

            </html>