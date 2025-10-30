<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

            <!DOCTYPE html>
            <html lang="en">

            <head>
                <jsp:include page="/views/partials/head.jsp">
                    <jsp:param name="title" value="Search Results - BusTicket System" />
                </jsp:include>
                <style>
                    .search-summary {
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        color: white;
                        padding: 20px;
                        border-radius: 10px;
                        margin-bottom: 30px;
                    }

                    .route-card {
                        border: 1px solid #e9ecef;
                        border-radius: 10px;
                        margin-bottom: 20px;
                        transition: transform 0.2s, box-shadow 0.2s;
                    }

                    .route-card:hover {
                        transform: translateY(-2px);
                        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
                    }

                    .schedule-item {
                        border: 1px solid #e9ecef;
                        border-radius: 8px;
                        padding: 15px;
                        margin-bottom: 10px;
                        background: #f8f9fa;
                    }

                    .schedule-item:hover {
                        background: #e9ecef;
                    }

                    .price-highlight {
                        font-size: 1.2rem;
                        font-weight: bold;
                        color: #28a745;
                    }

                    .seat-availability {
                        font-size: 0.9rem;
                        color: #6c757d;
                    }

                    .btn-book {
                        background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
                        border: none;
                        color: white;
                        font-weight: 600;
                    }

                    .btn-book:hover {
                        transform: translateY(-1px);
                        box-shadow: 0 4px 8px rgba(40, 167, 69, 0.3);
                    }

                    .trip-section {
                        margin-bottom: 40px;
                    }

                    .trip-header {
                        background: #f8f9fa;
                        padding: 15px;
                        border-radius: 8px;
                        margin-bottom: 20px;
                    }

                    .no-results {
                        text-align: center;
                        padding: 60px 20px;
                    }

                    .no-results i {
                        font-size: 4rem;
                        color: #6c757d;
                        margin-bottom: 20px;
                    }

                    .filter-section {
                        background: #f8f9fa;
                        padding: 20px;
                        border-radius: 8px;
                        margin-bottom: 20px;
                    }

                    .sort-options {
                        display: flex;
                        gap: 10px;
                        align-items: center;
                    }

                    .sort-options select {
                        min-width: 150px;
                    }
                </style>
            </head>

            <body>
                <%@ include file="/views/partials/user-header.jsp" %>

                    <div class="container mt-4">
                        <!-- Search Summary -->
                        <div class="search-summary">
                            <div class="row align-items-center">
                                <div class="col-md-8">
                                    <h4 class="mb-2">
                                        <i class="fas fa-search me-2"></i>Search Results
                                    </h4>
                                    <p class="mb-0">
                                        <i class="fas fa-map-marker-alt me-1"></i>${departureCity}
                                        <i class="fas fa-arrow-right mx-2"></i>
                                        <i class="fas fa-map-marker-alt me-1"></i>${destinationCity}
                                        <span class="ms-3">
                                            <i class="fas fa-calendar me-1"></i>
                                            <fmt:formatDate value="${departureDate}" pattern="EEEE, MMMM dd, yyyy" />
                                        </span>
                                        <c:if test="${tripType eq 'roundtrip' and not empty returnDate}">
                                            <span class="ms-3">
                                                <i class="fas fa-calendar me-1"></i>
                                                <fmt:formatDate value="${returnDate}" pattern="EEEE, MMMM dd, yyyy" />
                                            </span>
                                        </c:if>
                                    </p>
                                </div>
                                <div class="col-md-4 text-end">
                                    <a href="${pageContext.request.contextPath}/routes" class="btn btn-light">
                                        <i class="fas fa-search me-1"></i>New Search
                                    </a>
                                </div>
                            </div>
                        </div>

                        <!-- Outbound Trip -->
                        <div class="trip-section">
                            <div class="trip-header">
                                <h5 class="mb-0">
                                    <i class="fas fa-arrow-right text-primary me-2"></i>
                                    Outbound Trip: ${departureCity} → ${destinationCity}
                                </h5>
                            </div>

                            <c:choose>
                                <c:when test="${empty routes}">
                                    <div class="no-results">
                                        <i class="fas fa-route"></i>
                                        <h5>No routes found</h5>
                                        <p class="text-muted">We couldn't find any routes between ${departureCity} and
                                            ${destinationCity} for the selected date.</p>
                                        <a href="${pageContext.request.contextPath}/routes" class="btn btn-primary">
                                            <i class="fas fa-search me-1"></i>Try Different Search
                                        </a>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <!-- Filter and Sort -->
                                    <div class="filter-section">
                                        <div class="row align-items-center">
                                            <div class="col-md-6">
                                                <strong>Found ${routes.size()} route(s)</strong>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="sort-options justify-content-end">
                                                    <label for="sortBy" class="form-label mb-0 me-2">Sort by:</label>
                                                    <select class="form-select" id="sortBy" onchange="sortRoutes()">
                                                        <option value="price">Price (Low to High)</option>
                                                        <option value="duration">Duration (Short to Long)</option>
                                                        <option value="departure">Departure Time</option>
                                                    </select>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Routes List -->
                                    <div id="routesList">
                                        <c:forEach var="route" items="${routes}">
                                            <div class="route-card" data-price="${route.basePrice}"
                                                data-duration="${route.durationHours}">
                                                <div class="card-body">
                                                    <div class="row">
                                                        <div class="col-md-8">
                                                            <h5 class="card-title">
                                                                <i
                                                                    class="fas fa-route text-primary me-2"></i>${route.routeName}
                                                            </h5>
                                                            <p class="card-text mb-3">
                                                                <i class="fas fa-map-marker-alt text-primary"></i>
                                                                ${route.departureCity}
                                                                <i class="fas fa-arrow-right mx-2 text-muted"></i>
                                                                <i class="fas fa-map-marker-alt text-danger"></i>
                                                                ${route.destinationCity}
                                                            </p>
                                                            <div class="row">
                                                                <div class="col-sm-4">
                                                                    <small class="text-muted">Distance</small><br>
                                                                    <strong>${route.distance} km</strong>
                                                                </div>
                                                                <div class="col-sm-4">
                                                                    <small class="text-muted">Duration</small><br>
                                                                    <strong>${route.durationHours} hours</strong>
                                                                </div>
                                                                <div class="col-sm-4">
                                                                    <small class="text-muted">Base Price</small><br>
                                                                    <strong class="text-success">
                                                                        <fmt:formatNumber value="${route.basePrice}"
                                                                            type="currency" currencySymbol="₫"
                                                                            maxFractionDigits="0" />
                                                                    </strong>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-4 text-end">
                                                            <div class="price-highlight mb-2">
                                                                From
                                                                <fmt:formatNumber value="${route.basePrice}"
                                                                    type="currency" currencySymbol="₫"
                                                                    maxFractionDigits="0" />
                                                            </div>
                                                            <c:choose>
                                                                <c:when test="${empty route.schedules}">
                                                                    <p class="text-muted mb-2">No schedules available
                                                                    </p>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <p class="seat-availability mb-2">
                                                                        ${route.schedules.size()} schedule(s) available
                                                                    </p>
                                                                </c:otherwise>
                                                            </c:choose>
                                                            <button class="btn btn-outline-primary"
                                                                onclick="toggleSchedules('route${route.routeId}')">
                                                                <i class="fas fa-clock me-1"></i>View Schedules
                                                            </button>
                                                        </div>
                                                    </div>

                                                    <!-- Schedules (Hidden by default) -->
                                                    <div id="route${route.routeId}" class="mt-3" style="display: none;">
                                                        <hr>
                                                        <h6 class="text-primary mb-3">
                                                            <i class="fas fa-clock me-2"></i>Available Schedules
                                                        </h6>
                                                        <c:choose>
                                                            <c:when test="${empty route.schedules}">
                                                                <div class="alert alert-warning">
                                                                    <i class="fas fa-exclamation-triangle me-2"></i>
                                                                    No schedules available for this route on the
                                                                    selected date.
                                                                </div>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <c:forEach var="schedule" items="${route.schedules}">
                                                                    <div class="schedule-item">
                                                                        <div class="row align-items-center">
                                                                            <div class="col-md-3">
                                                                                <strong>
                                                                                    <fmt:formatDate
                                                                                        value="${schedule.departureTime}"
                                                                                        pattern="HH:mm" />
                                                                                </strong>
                                                                                <br>
                                                                                <small
                                                                                    class="text-muted">Departure</small>
                                                                            </div>
                                                                            <div class="col-md-3">
                                                                                <strong>
                                                                                    <fmt:formatDate
                                                                                        value="${schedule.estimatedArrivalTime}"
                                                                                        pattern="HH:mm" />
                                                                                </strong>
                                                                                <br>
                                                                                <small
                                                                                    class="text-muted">Arrival</small>
                                                                            </div>
                                                                            <div class="col-md-2">
                                                                                <strong>${schedule.availableSeats}</strong>
                                                                                <br>
                                                                                <small class="text-muted">Available
                                                                                    Seats</small>
                                                                            </div>
                                                                            <div class="col-md-2">
                                                                                <strong class="text-success">
                                                                                    <fmt:formatNumber
                                                                                        value="${route.basePrice}"
                                                                                        type="currency"
                                                                                        currencySymbol="₫"
                                                                                        maxFractionDigits="0" />
                                                                                </strong>
                                                                                <br>
                                                                                <small class="text-muted">Price</small>
                                                                            </div>
                                                                            <div class="col-md-2 text-end">
                                                                                <c:choose>
                                                                                    <c:when
                                                                                        test="${schedule.availableSeats > 0}">
                                                                                        <a href="${pageContext.request.contextPath}/tickets/book?routeId=${route.routeId}&scheduleId=${schedule.scheduleId}&departureDate=${departureDate}&tripType=${tripType}&returnDate=${returnDate}"
                                                                                            class="btn btn-book">
                                                                                            <i
                                                                                                class="fas fa-ticket-alt me-1"></i>Book
                                                                                            Now
                                                                                        </a>
                                                                                    </c:when>
                                                                                    <c:otherwise>
                                                                                        <button
                                                                                            class="btn btn-secondary"
                                                                                            disabled>
                                                                                            <i
                                                                                                class="fas fa-times me-1"></i>Sold
                                                                                            Out
                                                                                        </button>
                                                                                    </c:otherwise>
                                                                                </c:choose>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </c:forEach>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- Return Trip (if round trip) -->
                        <c:if test="${tripType eq 'roundtrip' and not empty returnRoutes}">
                            <div class="trip-section">
                                <div class="trip-header">
                                    <h5 class="mb-0">
                                        <i class="fas fa-arrow-left text-warning me-2"></i>
                                        Return Trip: ${destinationCity} → ${departureCity}
                                    </h5>
                                </div>

                                <c:choose>
                                    <c:when test="${empty returnRoutes}">
                                        <div class="no-results">
                                            <i class="fas fa-route"></i>
                                            <h5>No return routes found</h5>
                                            <p class="text-muted">We couldn't find any return routes for the selected
                                                date.</p>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="route" items="${returnRoutes}">
                                            <div class="route-card">
                                                <div class="card-body">
                                                    <div class="row">
                                                        <div class="col-md-8">
                                                            <h5 class="card-title">
                                                                <i
                                                                    class="fas fa-route text-warning me-2"></i>${route.routeName}
                                                            </h5>
                                                            <p class="card-text mb-3">
                                                                <i class="fas fa-map-marker-alt text-danger"></i>
                                                                ${route.destinationCity}
                                                                <i class="fas fa-arrow-left mx-2 text-muted"></i>
                                                                <i class="fas fa-map-marker-alt text-primary"></i>
                                                                ${route.departureCity}
                                                            </p>
                                                            <div class="row">
                                                                <div class="col-sm-4">
                                                                    <small class="text-muted">Distance</small><br>
                                                                    <strong>${route.distance} km</strong>
                                                                </div>
                                                                <div class="col-sm-4">
                                                                    <small class="text-muted">Duration</small><br>
                                                                    <strong>${route.durationHours} hours</strong>
                                                                </div>
                                                                <div class="col-sm-4">
                                                                    <small class="text-muted">Base Price</small><br>
                                                                    <strong class="text-success">
                                                                        <fmt:formatNumber value="${route.basePrice}"
                                                                            type="currency" currencySymbol="₫"
                                                                            maxFractionDigits="0" />
                                                                    </strong>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-4 text-end">
                                                            <div class="price-highlight mb-2">
                                                                From
                                                                <fmt:formatNumber value="${route.basePrice}"
                                                                    type="currency" currencySymbol="₫"
                                                                    maxFractionDigits="0" />
                                                            </div>
                                                            <c:choose>
                                                                <c:when test="${empty route.schedules}">
                                                                    <p class="text-muted mb-2">No schedules available
                                                                    </p>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <p class="seat-availability mb-2">
                                                                        ${route.schedules.size()} schedule(s) available
                                                                    </p>
                                                                </c:otherwise>
                                                            </c:choose>
                                                            <button class="btn btn-outline-warning"
                                                                onclick="toggleSchedules('returnRoute${route.routeId}')">
                                                                <i class="fas fa-clock me-1"></i>View Schedules
                                                            </button>
                                                        </div>
                                                    </div>

                                                    <!-- Return Schedules -->
                                                    <div id="returnRoute${route.routeId}" class="mt-3"
                                                        style="display: none;">
                                                        <hr>
                                                        <h6 class="text-warning mb-3">
                                                            <i class="fas fa-clock me-2"></i>Available Return Schedules
                                                        </h6>
                                                        <c:choose>
                                                            <c:when test="${empty route.schedules}">
                                                                <div class="alert alert-warning">
                                                                    <i class="fas fa-exclamation-triangle me-2"></i>
                                                                    No return schedules available for this route on the
                                                                    selected date.
                                                                </div>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <c:forEach var="schedule" items="${route.schedules}">
                                                                    <div class="schedule-item">
                                                                        <div class="row align-items-center">
                                                                            <div class="col-md-3">
                                                                                <strong>
                                                                                    <fmt:formatDate
                                                                                        value="${schedule.departureTime}"
                                                                                        pattern="HH:mm" />
                                                                                </strong>
                                                                                <br>
                                                                                <small
                                                                                    class="text-muted">Departure</small>
                                                                            </div>
                                                                            <div class="col-md-3">
                                                                                <strong>
                                                                                    <fmt:formatDate
                                                                                        value="${schedule.estimatedArrivalTime}"
                                                                                        pattern="HH:mm" />
                                                                                </strong>
                                                                                <br>
                                                                                <small
                                                                                    class="text-muted">Arrival</small>
                                                                            </div>
                                                                            <div class="col-md-2">
                                                                                <strong>${schedule.availableSeats}</strong>
                                                                                <br>
                                                                                <small class="text-muted">Available
                                                                                    Seats</small>
                                                                            </div>
                                                                            <div class="col-md-2">
                                                                                <strong class="text-success">
                                                                                    <fmt:formatNumber
                                                                                        value="${route.basePrice}"
                                                                                        type="currency"
                                                                                        currencySymbol="₫"
                                                                                        maxFractionDigits="0" />
                                                                                </strong>
                                                                                <br>
                                                                                <small class="text-muted">Price</small>
                                                                            </div>
                                                                            <div class="col-md-2 text-end">
                                                                                <c:choose>
                                                                                    <c:when
                                                                                        test="${schedule.availableSeats > 0}">
                                                                                        <a href="${pageContext.request.contextPath}/tickets/book?routeId=${route.routeId}&scheduleId=${schedule.scheduleId}&departureDate=${returnDate}&tripType=${tripType}&returnDate=${departureDate}"
                                                                                            class="btn btn-warning">
                                                                                            <i
                                                                                                class="fas fa-ticket-alt me-1"></i>Book
                                                                                            Return
                                                                                        </a>
                                                                                    </c:when>
                                                                                    <c:otherwise>
                                                                                        <button
                                                                                            class="btn btn-secondary"
                                                                                            disabled>
                                                                                            <i
                                                                                                class="fas fa-times me-1"></i>Sold
                                                                                            Out
                                                                                        </button>
                                                                                    </c:otherwise>
                                                                                </c:choose>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </c:forEach>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </c:if>
                    </div>

                    <%@ include file="/views/partials/footer.jsp" %>

                        <script>
                            function toggleSchedules(routeId) {
                                const element = document.getElementById(routeId);
                                if (element.style.display === 'none') {
                                    element.style.display = 'block';
                                } else {
                                    element.style.display = 'none';
                                }
                            }

                            function sortRoutes() {
                                const sortBy = document.getElementById('sortBy').value;
                                const routesList = document.getElementById('routesList');
                                const routes = Array.from(routesList.children);

                                routes.sort((a, b) => {
                                    switch (sortBy) {
                                        case 'price':
                                            return parseFloat(a.dataset.price) - parseFloat(b.dataset.price);
                                        case 'duration':
                                            return parseInt(a.dataset.duration) - parseInt(b.dataset.duration);
                                        case 'departure':
                                            // This would need departure time data, for now just return 0
                                            return 0;
                                        default:
                                            return 0;
                                    }
                                });

                                // Clear and re-append sorted routes
                                routesList.innerHTML = '';
                                routes.forEach(route => routesList.appendChild(route));
                            }
                        </script>
            </body>

            </html>