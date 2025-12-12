<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">

    <head>
        <jsp:include page="/views/partials/head.jsp">
            <jsp:param name="title" value="Search Routes - Bus Booking System" />
        </jsp:include>
        <style>
            .search-container {
                background: linear-gradient(135deg, #66bb6a 0%, #81c784 100%);
                color: white;
                padding: 40px 0;
                margin-bottom: 30px;
            }

            .search-form {
                background: white;
                color: #333;
                padding: 30px;
                border-radius: 10px;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            }

            .form-control:focus {
                border-color: #66bb6a;
                box-shadow: 0 0 0 0.2rem rgba(102, 187, 106, 0.25);
            }

            .btn-search {
                background: linear-gradient(135deg, #66bb6a 0%, #81c784 100%);
                border: none;
                padding: 12px 30px;
                font-weight: 600;
            }

            .btn-search:hover {
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(102, 187, 106, 0.4);
            }

            .popular-route-card {
                transition: transform 0.2s;
                border: none;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.08);
            }

            .popular-route-card:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.13);
            }

            .trip-type-buttons .btn {
                margin: 5px;
            }

            .trip-type-buttons .btn.active {
                background: linear-gradient(135deg, #66bb6a 0%, #81c784 100%);
                border-color: #66bb6a;
            }

            .feature-icon {
                font-size: 2rem;
                color: #66bb6a;
                margin-bottom: 15px;
            }

            .search-suggestions {
                position: absolute;
                top: 100%;
                left: 0;
                right: 0;
                background: white;
                border: 1px solid #ddd;
                border-top: none;
                border-radius: 0 0 5px 5px;
                max-height: 200px;
                overflow-y: auto;
                z-index: 1000;
                display: none;
            }

            .search-suggestions .suggestion-item {
                padding: 10px 15px;
                cursor: pointer;
                border-bottom: 1px solid #eee;
            }

            .search-suggestions .suggestion-item:hover {
                background-color: #f8f9fa;
            }

            .search-suggestions .suggestion-item:last-child {
                border-bottom: none;
            }

            .route-selection-card {
                border: 1px solid #dee2e6;
                transition: all 0.2s;
            }

            .route-selection-card:hover {
                border-color: #66bb6a;
                box-shadow: 0 4px 8px rgba(102, 187, 106, 0.15);
            }

            .route-selection-card.border-primary {
                border-color: #66bb6a !important;
                border-width: 2px;
            }
        </style>
    </head>

    <body>
        <%@ include file="/views/partials/user-header.jsp" %>

        <!-- Search Container -->
        <div class="search-container">
            <div class="container">
                <div class="row justify-content-center">
                    <div class="col-lg-10">
                        <div class="text-center mb-4">
                            <h1 class="display-4 mb-3">
                                <i class="fas fa-search me-3"></i>Find Your Perfect Route
                            </h1>
                            <p class="lead">Search and book bus tickets to your destination</p>
                        </div>

                        <!-- Search Form -->
                        <div class="search-form">
                            <form action="${pageContext.request.contextPath}/search/search" method="post"
                                  id="searchForm" onsubmit="return validateRouteSelection()">
                                <!-- Trip Type Selection -->
                                <div class="row mb-4">
                                    <div class="col-12">
                                        <label class="form-label fw-bold">Trip Type</label>
                                        <div class="trip-type-buttons text-center">
                                            <button type="button" class="btn btn-outline-primary active"
                                                    data-trip-type="oneway">
                                                <i class="fas fa-arrow-right me-2"></i>One Way
                                            </button>
                                            <button type="button" class="btn btn-outline-primary"
                                                    data-trip-type="roundtrip">
                                                <i class="fas fa-exchange-alt me-2"></i>Round Trip
                                            </button>
                                        </div>
                                        <input type="hidden" id="tripType" name="tripType" value="oneway">
                                    </div>
                                </div>

                                <div class="row g-3">
                                    <!-- Departure City -->
                                    <div class="col-md-6">
                                        <label for="departureCity" class="form-label fw-bold">
                                            <i class="fas fa-map-marker-alt text-primary me-1"></i>From
                                        </label>
                                        <div class="position-relative">
                                            <input type="text" class="form-control form-control-lg"
                                                   id="departureCity" name="departureCity"
                                                   placeholder="Enter departure city" required
                                                   autocomplete="off">
                                            <div class="search-suggestions" id="departureSuggestions"></div>
                                        </div>
                                    </div>

                                    <!-- Destination City -->
                                    <div class="col-md-6">
                                        <label for="destinationCity" class="form-label fw-bold">
                                            <i class="fas fa-map-marker-alt text-danger me-1"></i>To
                                        </label>
                                        <div class="position-relative">
                                            <input type="text" class="form-control form-control-lg"
                                                   id="destinationCity" name="destinationCity"
                                                   placeholder="Enter destination city" required
                                                   autocomplete="off">
                                            <div class="search-suggestions" id="destinationSuggestions">
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Available Routes List -->
                                    <div class="col-12" id="routesListContainer" style="display: none;">
                                        <label class="form-label fw-bold">
                                            <i class="fas fa-route text-primary me-1"></i>Available routes
                                        </label>
                                        <div id="routesList" class="mt-2"></div>
                                    </div>

                                    <!-- Selected Route Info (hidden, for form submission) -->
                                    <input type="hidden" id="selectedDepartureDate" name="departureDate">

                                    <!-- Return Date (hidden by default) -->
                                    <div class="col-md-6" id="returnDateGroup" style="display: none;">
                                        <label for="returnDate" class="form-label fw-bold">
                                            <i class="fas fa-calendar text-warning me-1"></i>Ngày về <small
                                                class="text-muted">(tùy chọn)</small>
                                        </label>
                                        <input type="date" class="form-control form-control-lg"
                                               id="returnDate" name="returnDate">
                                    </div>

                                    <!-- Search Button -->
                                    <div class="col-12 text-center">
                                        <button type="submit" class="btn btn-search btn-lg px-5">
                                            <i class="fas fa-search me-2"></i>Search Routes
                                        </button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Popular Routes Section -->
        <div class="container">
            <div class="row">
                <div class="col-12">
                    <h3 class="text-center mb-4">
                        <i class="fas fa-fire text-danger me-2"></i>Popular Routes
                    </h3>
                </div>
            </div>

            <c:choose>
                <c:when test="${empty popularRoutes}">
                    <div class="text-center py-5">
                        <i class="fas fa-route fa-3x text-muted mb-3"></i>
                        <h5 class="text-muted">No popular routes available</h5>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="row g-4">
                        <c:forEach var="route" items="${popularRoutes}">
                            <div class="col-md-6 col-lg-4">
                                <div class="card popular-route-card h-100">
                                    <div class="card-body">
                                        <h5 class="card-title">
                                            <i class="fas fa-route text-primary me-2"></i>${route.routeName}
                                        </h5>
                                        <p class="card-text">
                                            <i class="fas fa-map-marker-alt text-primary"></i>
                                            ${route.departureCity}
                                            <i class="fas fa-arrow-right mx-2 text-muted"></i>
                                            <i class="fas fa-map-marker-alt text-danger"></i>
                                            ${route.destinationCity}
                                        </p>
                                        <div class="row text-center">
                                            <div class="col-4">
                                                <small class="text-muted">Distance</small><br>
                                                <strong>${route.distance} km</strong>
                                            </div>
                                            <div class="col-4">
                                                <small class="text-muted">Duration</small><br>
                                                <strong>${route.durationHours}h</strong>
                                            </div>
                                            <div class="col-4">
                                                <small class="text-muted">From</small><br>
                                                <strong class="text-success">
                                                    <fmt:formatNumber value="${route.basePrice}"
                                                                      type="currency" currencySymbol="₫"
                                                                      maxFractionDigits="0" />
                                                </strong>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="card-footer bg-transparent">
                                        <button class="btn btn-outline-primary w-100"
                                                onclick="quickSearch('${route.departureCity}', '${route.destinationCity}')">
                                            <i class="fas fa-search me-1"></i>Search This Route
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Features Section -->
        <div class="container my-5">
            <div class="row">
                <div class="col-12">
                    <h3 class="text-center mb-5">Why Choose Our Bus Service?</h3>
                </div>
            </div>
            <div class="row g-4">
                <div class="col-md-4 text-center">
                    <div class="feature-icon">
                        <i class="fas fa-shield-alt"></i>
                    </div>
                    <h5>Safe & Secure</h5>
                    <p class="text-muted">Your safety is our top priority with well-maintained buses and
                        experienced drivers.</p>
                </div>
                <div class="col-md-4 text-center">
                    <div class="feature-icon">
                        <i class="fas fa-clock"></i>
                    </div>
                    <h5>On-Time Service</h5>
                    <p class="text-muted">We pride ourselves on punctuality and reliable departure times.
                    </p>
                </div>
                <div class="col-md-4 text-center">
                    <div class="feature-icon">
                        <i class="fas fa-dollar-sign"></i>
                    </div>
                    <h5>Best Prices</h5>
                    <p class="text-muted">Competitive pricing with no hidden fees. Book with confidence.</p>
                </div>
            </div>
        </div>

        <!-- Messages -->
        <c:if test="${not empty error}">
            <div class="container">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-circle me-2"></i>${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </div>
        </c:if>

        <!-- Route Not Found Modal (used by server or client-side when empty result) -->
        <div class="modal fade" id="routeNotFoundModal" tabindex="-1" data-bs-backdrop="static">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header bg-danger text-white">
                        <h5 class="modal-title">
                            <i class="fas fa-exclamation-triangle me-2"></i>Route Not Found
                        </h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"
                                aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <p class="mb-3" id="routeNotFoundMessage">
                            <strong>We're sorry!</strong> We couldn't find a route from
                            <strong>${departureCity != null ? departureCity : ''}</strong> to
                            <strong>${destinationCity != null ? destinationCity : ''}</strong>.
                        </p>
                        <p class="text-muted mb-0">
                            Please try again with other cities or contact us for support.
                        </p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary"
                                data-bs-dismiss="modal">Close</button>
                        <a href="${pageContext.request.contextPath}/search" class="btn btn-primary">
                            <i class="fas fa-search me-2"></i>Search Again
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <c:if test="${not empty showNotFoundPopup}">
            <script>
                document.addEventListener('DOMContentLoaded', function () {
                    const modal = new bootstrap.Modal(document.getElementById('routeNotFoundModal'));
                    modal.show();
                });
            </script>
        </c:if>

        <%@ include file="/views/partials/footer.jsp" %>

        <script>
            document.addEventListener('DOMContentLoaded', function () {
                // Set minimum date to today
                const today = new Date().toISOString().split('T')[0];
                document.getElementById('departureDate').min = today;
                document.getElementById('returnDate').min = today;

                // Trip type buttons
                const tripTypeButtons = document.querySelectorAll('[data-trip-type]');
                const returnDateGroup = document.getElementById('returnDateGroup');
                const tripTypeInput = document.getElementById('tripType');

                tripTypeButtons.forEach(button => {
                    button.addEventListener('click', function () {
                        // Remove active class from all buttons
                        tripTypeButtons.forEach(btn => btn.classList.remove('active'));
                        // Add active class to clicked button
                        this.classList.add('active');

                        const tripType = this.getAttribute('data-trip-type');
                        tripTypeInput.value = tripType;

                        if (tripType === 'roundtrip') {
                            returnDateGroup.style.display = 'block';
                            // Return date is optional
                            document.getElementById('returnDate').required = false;
                        } else {
                            returnDateGroup.style.display = 'none';
                            document.getElementById('returnDate').required = false;
                        }
                    });
                });

                // City autocomplete
                setupAutocomplete('departureCity', 'departureSuggestions');
                setupAutocomplete('destinationCity', 'destinationSuggestions');

                // Load routes when both cities are filled
                const departureCityInput = document.getElementById('departureCity');
                const destinationCityInput = document.getElementById('destinationCity');

                function loadRoutes() {
                    const departureCity = departureCityInput.value.trim();
                    const destinationCity = destinationCityInput.value.trim();

                    if (departureCity.length >= 2 && destinationCity.length >= 2
                            && departureCity !== destinationCity) {
                        fetchRoutes(departureCity, destinationCity);
                    } else {
                        document.getElementById('routesListContainer').style.display = 'none';
                    }
                }

                departureCityInput.addEventListener('blur', loadRoutes);
                destinationCityInput.addEventListener('blur', loadRoutes);

                // Also trigger on Enter key
                departureCityInput.addEventListener('keypress', function (e) {
                    if (e.key === 'Enter') {
                        e.preventDefault();
                        loadRoutes();
                    }
                });
                destinationCityInput.addEventListener('keypress', function (e) {
                    if (e.key === 'Enter') {
                        e.preventDefault();
                        loadRoutes();
                    }
                });
            });

            function setupAutocomplete(inputId, suggestionsId) {
                const input = document.getElementById(inputId);
                const suggestions = document.getElementById(suggestionsId);
                let timeout;

                input.addEventListener('input', function () {
                    clearTimeout(timeout);
                    const query = this.value.trim();

                    if (query.length < 2) {
                        suggestions.style.display = 'none';
                        return;
                    }

                    timeout = setTimeout(() => {
                        fetchStations(query, suggestions, input);
                    }, 300);
                });

                input.addEventListener('blur', function () {
                    setTimeout(() => {
                        suggestions.style.display = 'none';
                    }, 200);
                });

                input.addEventListener('focus', function () {
                    if (this.value.trim().length >= 2) {
                        suggestions.style.display = 'block';
                    }
                });
            }

            function fetchStations(query, suggestions, input) {
                const ctx = '${pageContext.request.contextPath}';
                const url = ctx + '/search/stations?q=' + encodeURIComponent(query);
                fetch(url)
                        .then(response => response.json())
                        .then(stations => {
                            suggestions.innerHTML = '';
                            if (stations.length === 0) {
                                suggestions.innerHTML = '<div class="suggestion-item text-muted">No stations found</div>';
                            } else {
                                stations.forEach(station => {
                                    const item = document.createElement('div');
                                    item.className = 'suggestion-item';
                                    item.textContent = station.city;
                                    item.addEventListener('click', function () {
                                        input.value = station.city;
                                        suggestions.style.display = 'none';
                                    });
                                    suggestions.appendChild(item);
                                });
                            }
                            suggestions.style.display = 'block';
                        })
                        .catch(error => {
                            console.error('Error fetching stations:', error);
                            suggestions.style.display = 'none';
                        });
            }

            function quickSearch(departure, destination) {
                document.getElementById('departureCity').value = departure;
                document.getElementById('destinationCity').value = destination;
                fetchRoutes(departure, destination);
            }

            function fetchRoutes(departureCity, destinationCity) {
                const routesListContainer = document.getElementById('routesListContainer');
                const routesList = document.getElementById('routesList');

                routesList.innerHTML = '<div class="text-center py-3"><div class="spinner-border text-primary" role="status"><span class="visually-hidden">Loading...</span></div></div>';
                routesListContainer.style.display = 'block';

                const ctx = '${pageContext.request.contextPath}';
                const url = ctx + '/search/routes-by-cities?departureCity=' +
                        encodeURIComponent(departureCity) +
                        '&destinationCity=' + encodeURIComponent(destinationCity);

                fetch(url)
                        .then(response => response.json())
                        .then(data => {
                            if (data.error) {
                                routesList.innerHTML = '<div class="alert alert-warning">' + data.error + '</div>';
                                return;
                            }

                            if (!data.routes || data.routes.length === 0) {
                                // Show popup modal when no routes are found
                                const nfModal = document.getElementById('routeNotFoundModal');
                                if (nfModal) {
                                    const modal = new bootstrap.Modal(nfModal);
                                    const msg = document.getElementById('routeNotFoundMessage');
                                    if (msg) {
                                        msg.innerHTML = '<strong>We\'re sorry!</strong> No matching routes found. Please try again.';
                                    }
                                    modal.show();
                                }
                                routesList.innerHTML = '';
                                routesListContainer.style.display = 'none';
                                return;
                            }

                            displayRoutes(data.routes);
                        })
                        .catch(error => {
                            console.error('Error fetching routes:', error);
                            routesList.innerHTML = '<div class="alert alert-danger">Error loading routes list</div>';
                        });
            }

            function displayRoutes(routes) {
                const routesList = document.getElementById('routesList');
                routesList.innerHTML = '';

                routes.forEach(route => {
                    const routeCard = document.createElement('div');
                    routeCard.className = 'card mb-3 route-selection-card';
                    routeCard.style.cursor = 'pointer';
                    routeCard.style.transition = 'all 0.2s';

                    const cardBody = document.createElement('div');
                    cardBody.className = 'card-body';

                    const mainRow = document.createElement('div');
                    mainRow.className = 'd-flex justify-content-between align-items-start';

                    const contentDiv = document.createElement('div');
                    contentDiv.className = 'flex-grow-1';

                    // Route name
                    const title = document.createElement('h6');
                    title.className = 'mb-2';
                    title.innerHTML = '<i class="fas fa-route text-primary me-2"></i>' + escapeHtml(route.routeName);

                    // Route cities
                    const cities = document.createElement('p');
                    cities.className = 'mb-1 text-muted small';
                    cities.innerHTML = '<i class="fas fa-map-marker-alt text-primary"></i> ' +
                            escapeHtml(route.departureCity) +
                            ' <i class="fas fa-arrow-right mx-2"></i> ' +
                            '<i class="fas fa-map-marker-alt text-danger"></i> ' +
                            escapeHtml(route.destinationCity);

                    // Route info (distance, duration, price, schedules)
                    const infoDiv = document.createElement('div');
                    infoDiv.className = 'd-flex flex-wrap gap-3 mt-2';
                    const price = new Intl.NumberFormat('vi-VN').format(route.basePrice);
                    const distanceKm = route.distance ? new Intl.NumberFormat('vi-VN').format(route.distance) : 'N/A';
                    infoDiv.innerHTML =
                            '<small class="fw-semibold"><i class="fas fa-road text-primary"></i> ' + distanceKm + ' km</small>' +
                            '<small class="fw-semibold"><i class="fas fa-clock text-primary"></i> ' + route.durationHours + ' giờ</small>' +
                            '<small><i class="fas fa-money-bill text-success"></i> ' + price + '₫</small>' +
                            '<small><i class="fas fa-calendar text-secondary"></i> ' + route.scheduleCount + ' lịch</small>';

                    // Terminal stations
                    const depStationName = (route.departureStationObj && route.departureStationObj.stationName)
                            ? route.departureStationObj.stationName
                            : (route.departureCity || 'N/A');
                    const destStationName = (route.destinationStationObj && route.destinationStationObj.stationName)
                            ? route.destinationStationObj.stationName
                            : (route.destinationCity || 'N/A');

                    const terminalsDiv = document.createElement('div');
                    terminalsDiv.className = 'd-flex flex-wrap gap-2 align-items-center mt-2';
                    terminalsDiv.innerHTML =
                            '<span class="badge bg-light text-dark border"><i class="fas fa-flag-checkered text-primary me-1"></i>Departure station: '
                            + escapeHtml(depStationName) + '</span>' +
                            '<span class="badge bg-light text-dark border"><i class="fas fa-map-pin text-danger me-1"></i>Arrival station: '
                            + escapeHtml(destStationName) + '</span>';

                    contentDiv.appendChild(title);
                    contentDiv.appendChild(cities);
                    contentDiv.appendChild(infoDiv);
                    contentDiv.appendChild(terminalsDiv);
                    mainRow.appendChild(contentDiv);
                    cardBody.appendChild(mainRow);

                    // Dates section
                    const datesDiv = document.createElement('div');
                    datesDiv.className = 'mt-3';
                    datesDiv.id = 'dates-' + route.routeId;
                    datesDiv.style.display = 'none';

                    const datesLabel = document.createElement('label');
                    datesLabel.className = 'form-label fw-bold small';
                    datesLabel.textContent = 'Select departure date:';
                    datesDiv.appendChild(datesLabel);

                    if (route.availableDates && route.availableDates.length > 0) {
                        const datesContainer = document.createElement('div');
                        datesContainer.className = 'd-flex flex-wrap gap-2';

                        route.availableDates.forEach(date => {
                            const dateBtn = document.createElement('button');
                            dateBtn.type = 'button';
                            dateBtn.className = 'btn btn-sm btn-outline-primary date-btn';
                            dateBtn.setAttribute('data-route-id', route.routeId);
                            dateBtn.setAttribute('data-date', date);
                            dateBtn.textContent = formatDate(date);
                            dateBtn.onclick = function (e) {
                                selectDate(route.routeId, date, e);
                            };
                            datesContainer.appendChild(dateBtn);
                        });

                        datesDiv.appendChild(datesContainer);
                    } else {
                        const noDatesAlert = document.createElement('div');
                        noDatesAlert.className = 'alert alert-warning small mb-0';
                        noDatesAlert.innerHTML = '<i class="fas fa-exclamation-triangle me-2"></i>No available schedules for this route yet';
                        datesDiv.appendChild(noDatesAlert);
                    }

                    cardBody.appendChild(datesDiv);
                    routeCard.appendChild(cardBody);

                    routeCard.addEventListener('click', function (e) {
                        if (!e.target.classList.contains('date-btn')) {
                            datesDiv.style.display = datesDiv.style.display === 'none' ? 'block' : 'none';

                            // Close other route dates
                            document.querySelectorAll('[id^="dates-"]').forEach(div => {
                                if (div.id !== 'dates-' + route.routeId) {
                                    div.style.display = 'none';
                                }
                            });
                        }
                    });

                    routesList.appendChild(routeCard);
                });
            }

            function escapeHtml(text) {
                const div = document.createElement('div');
                div.textContent = text;
                return div.innerHTML;
            }

            function selectDate(routeId, date, event) {
                if (event) {
                    event.stopPropagation();
                }

                // Store selected date
                document.getElementById('selectedDepartureDate').value = date;

                // Update UI - remove primary from all date buttons
                document.querySelectorAll('.date-btn').forEach(btn => {
                    btn.classList.remove('btn-primary');
                    btn.classList.add('btn-outline-primary');
                });

                // Add primary to clicked button
                if (event && event.target) {
                    event.target.classList.remove('btn-outline-primary');
                    event.target.classList.add('btn-primary');
                }

                // Show selected info
                let selectedInfo = document.getElementById('selectedRouteInfo');
                if (!selectedInfo) {
                    selectedInfo = document.createElement('div');
                    selectedInfo.id = 'selectedRouteInfo';
                    document.getElementById('routesListContainer').appendChild(selectedInfo);
                }
                selectedInfo.className = 'alert alert-success mt-2';
                selectedInfo.innerHTML =
                        '<i class="fas fa-check-circle me-2"></i>' +
                        'Selected departure date: <strong>' + formatDate(date) + '</strong>';
            }

            function formatDate(dateString) {
                const date = new Date(dateString + 'T00:00:00');
                const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
                const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                return days[date.getDay()] + ', ' + date.getDate() + '/' + months[date.getMonth()] + '/' + date.getFullYear();
            }

            function validateRouteSelection() {
                const selectedDate = document.getElementById('selectedDepartureDate').value;
                const departureCity = document.getElementById('departureCity').value.trim();
                const destinationCity = document.getElementById('destinationCity').value.trim();

                if (!departureCity || !destinationCity) {
                    alert('Please select departure and destination cities');
                    return false;
                }

                // Date is optional - form can submit without date
                return true;
            }
        </script>
    </body>

</html>