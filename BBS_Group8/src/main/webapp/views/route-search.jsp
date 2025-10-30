<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

            <!DOCTYPE html>
            <html lang="en">

            <head>
                <jsp:include page="/views/partials/head.jsp">
                    <jsp:param name="title" value="Search Routes - BusTicket System" />
                </jsp:include>
                <style>
                    .search-container {
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
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
                        border-color: #667eea;
                        box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
                    }

                    .btn-search {
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        border: none;
                        padding: 12px 30px;
                        font-weight: 600;
                    }

                    .btn-search:hover {
                        transform: translateY(-2px);
                        box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
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
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        border-color: #667eea;
                    }

                    .feature-icon {
                        font-size: 2rem;
                        color: #667eea;
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
                                            id="searchForm">
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

                                                <!-- Departure Date -->
                                                <div class="col-md-6">
                                                    <label for="departureDate" class="form-label fw-bold">
                                                        <i class="fas fa-calendar text-success me-1"></i>Departure Date
                                                    </label>
                                                    <input type="date" class="form-control form-control-lg"
                                                        id="departureDate" name="departureDate" required>
                                                </div>

                                                <!-- Return Date (hidden by default) -->
                                                <div class="col-md-6" id="returnDateGroup" style="display: none;">
                                                    <label for="returnDate" class="form-label fw-bold">
                                                        <i class="fas fa-calendar text-warning me-1"></i>Return Date
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
                                            document.getElementById('returnDate').required = true;
                                        } else {
                                            returnDateGroup.style.display = 'none';
                                            document.getElementById('returnDate').required = false;
                                        }
                                    });
                                });

                                // City autocomplete
                                setupAutocomplete('departureCity', 'departureSuggestions');
                                setupAutocomplete('destinationCity', 'destinationSuggestions');

                                // Departure date change handler
                                document.getElementById('departureDate').addEventListener('change', function () {
                                    const returnDate = document.getElementById('returnDate');
                                    if (returnDate.value) {
                                        returnDate.min = this.value;
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
                                document.getElementById('searchForm').submit();
                            }
                        </script>
            </body>

            </html>