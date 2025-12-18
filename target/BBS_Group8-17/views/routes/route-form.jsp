<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <title>${route == null ? 'Add Route' : 'Edit Route'} - Bus Booking System</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
                <style>
                    /* Route Form Styles */
                    .form-card {
                        background: #fff;
                        border-radius: 18px;
                        box-shadow: 0 8px 32px rgba(102, 187, 106, 0.15);
                        padding: 2.5rem 2rem 2rem 2rem;
                        margin-top: 2rem;
                        margin-bottom: 2rem;
                    }

                    .form-header {
                        background: linear-gradient(135deg, #66bb6a 0%, #81c784 100%);
                        color: #fff;
                        border-radius: 18px 18px 0 0;
                        padding: 1.5rem 2rem;
                        margin: -2.5rem -2rem 2rem -2rem;
                        box-shadow: 0 4px 16px rgba(102, 187, 106, 0.2);
                    }

                    .form-label {
                        font-weight: 600;
                    }

                    .section-title {
                        font-weight: 600;
                        color: #66bb6a;
                        margin-top: 1.5rem;
                        margin-bottom: 1rem;
                        padding-bottom: 0.5rem;
                        border-bottom: 2px solid #e0e0e0;
                    }

                    .form-control:focus,
                    .form-select:focus {
                        border-color: #66bb6a;
                        box-shadow: 0 0 0 0.2rem rgba(102, 187, 106, 0.25);
                    }

                    .btn-gradient {
                        background: linear-gradient(135deg, #66bb6a 0%, #81c784 100%);
                        color: #fff;
                        border: none;
                        border-radius: 25px;
                        padding: 0.75rem 2rem;
                        font-weight: 600;
                        transition: all 0.2s;
                    }

                    .btn-gradient:hover {
                        background: linear-gradient(135deg, #4caf50 0%, #66bb6a 100%);
                        color: #fff;
                        transform: translateY(-2px);
                        box-shadow: 0 4px 16px rgba(102, 187, 106, 0.25);
                    }

                    @media (max-width: 576px) {

                        .form-card,
                        .form-header {
                            padding: 1rem !important;
                        }
                    }

                    /* Station Selection Styles */
                    .station-list {
                        max-height: 400px;
                        overflow-y: auto;
                        border: 1px solid #e0e0e0;
                        border-radius: 12px;
                        padding: 1rem;
                        background: linear-gradient(135deg, #fafafa 0%, #f5f5f5 100%);
                    }

                    .station-list::-webkit-scrollbar {
                        width: 6px;
                    }

                    .station-list::-webkit-scrollbar-track {
                        background: #f1f1f1;
                        border-radius: 3px;
                    }

                    .station-list::-webkit-scrollbar-thumb {
                        background: #66bb6a;
                        border-radius: 3px;
                    }

                    .station-item {
                        display: flex;
                        align-items: center;
                        padding: 0.75rem 1rem;
                        margin-bottom: 0.5rem;
                        border-radius: 10px;
                        transition: all 0.3s ease;
                        border-left: 4px solid transparent;
                        background: white;
                        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.02);
                        cursor: pointer;
                    }

                    .station-item:hover {
                        background-color: #f0f7f0;
                        transform: translateX(4px);
                        box-shadow: 0 4px 12px rgba(102, 187, 106, 0.15);
                    }

                    .station-item.selected {
                        background: linear-gradient(135deg, #e8f5e9 0%, #c8e6c9 100%);
                        border-left-color: #66bb6a;
                        box-shadow: 0 4px 12px rgba(102, 187, 106, 0.2);
                    }

                    .station-item input[type="checkbox"] {
                        width: 18px;
                        height: 18px;
                        margin-right: 1rem;
                        accent-color: #66bb6a;
                        cursor: pointer;
                    }

                    .station-info {
                        flex: 1;
                        display: flex;
                        align-items: center;
                        gap: 0.75rem;
                        cursor: pointer;
                    }

                    .station-name {
                        font-weight: 600;
                        color: #2e7d32;
                        font-size: 0.95rem;
                    }

                    .station-city {
                        font-size: 0.8rem;
                        color: #78909c;
                        background: #eceff1;
                        padding: 0.2rem 0.5rem;
                        border-radius: 4px;
                    }

                    .city-group {
                        margin-bottom: 1.25rem;
                    }

                    .city-group-header {
                        background: linear-gradient(135deg, #e8f5e9 0%, #c8e6c9 100%);
                        padding: 0.75rem 1rem;
                        border-radius: 10px;
                        font-weight: 700;
                        color: #2e7d32;
                        margin-bottom: 0.75rem;
                        display: flex;
                        align-items: center;
                        box-shadow: 0 2px 8px rgba(102, 187, 106, 0.15);
                    }

                    .city-group-header i {
                        margin-right: 0.75rem;
                        color: #43a047;
                        font-size: 1.1rem;
                    }

                    .terminal-badge {
                        background: linear-gradient(135deg, #ff9800 0%, #ffc107 100%);
                        color: white;
                        padding: 0.25rem 0.6rem;
                        border-radius: 20px;
                        font-size: 0.7rem;
                        font-weight: 600;
                        margin-left: auto;
                        text-transform: uppercase;
                        letter-spacing: 0.5px;
                        box-shadow: 0 2px 4px rgba(255, 152, 0, 0.3);
                    }

                    .terminal-badge.departure {
                        background: linear-gradient(135deg, #4caf50 0%, #66bb6a 100%);
                        box-shadow: 0 2px 4px rgba(76, 175, 80, 0.3);
                    }

                    .terminal-badge.destination {
                        background: linear-gradient(135deg, #f44336 0%, #e57373 100%);
                        box-shadow: 0 2px 4px rgba(244, 67, 54, 0.3);
                    }

                    .info-box {
                        background: linear-gradient(135deg, #e3f2fd 0%, #bbdefb 100%);
                        border-left: 4px solid #2196f3;
                        padding: 1rem 1.25rem;
                        border-radius: 0 12px 12px 0;
                        margin-bottom: 1rem;
                        box-shadow: 0 2px 8px rgba(33, 150, 243, 0.1);
                    }

                    .info-box i {
                        color: #1976d2;
                        margin-right: 0.5rem;
                    }

                    .empty-state {
                        text-align: center;
                        padding: 2rem;
                        color: #78909c;
                    }

                    .empty-state i {
                        font-size: 3rem;
                        margin-bottom: 1rem;
                        color: #b0bec5;
                    }

                    .empty-state p {
                        margin: 0;
                        font-size: 0.95rem;
                    }

                    .station-count {
                        font-size: 0.75rem;
                        color: #78909c;
                        background: white;
                        padding: 0.2rem 0.5rem;
                        border-radius: 10px;
                        margin-left: 0.5rem;
                    }

                    /* Searchable Dropdown Styles */
                    .searchable-select-wrapper {
                        position: relative;
                    }

                    .searchable-input {
                        cursor: pointer;
                    }

                    .searchable-dropdown {
                        position: absolute;
                        top: 100%;
                        left: 0;
                        right: 0;
                        max-height: 300px;
                        overflow-y: auto;
                        background: white;
                        border: 1px solid #dee2e6;
                        border-radius: 0.375rem;
                        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
                        z-index: 1000;
                        display: none;
                        margin-top: 0.25rem;
                    }

                    .searchable-dropdown.show {
                        display: block;
                    }

                    .searchable-option {
                        padding: 0.75rem 1rem;
                        cursor: pointer;
                        transition: all 0.2s ease;
                        border-bottom: 1px solid #f0f0f0;
                    }

                    .searchable-option:last-child {
                        border-bottom: none;
                    }

                    .searchable-option:hover {
                        background: linear-gradient(135deg, #e8f5e9 0%, #c8e6c9 100%);
                        color: #2e7d32;
                        font-weight: 500;
                    }

                    .searchable-option.selected {
                        background: linear-gradient(135deg, #66bb6a 0%, #81c784 100%);
                        color: white;
                        font-weight: 600;
                    }

                    .searchable-option.hidden {
                        display: none;
                    }

                    .searchable-dropdown::-webkit-scrollbar {
                        width: 6px;
                    }

                    .searchable-dropdown::-webkit-scrollbar-track {
                        background: #f1f1f1;
                        border-radius: 3px;
                    }

                    .searchable-dropdown::-webkit-scrollbar-thumb {
                        background: #66bb6a;
                        border-radius: 3px;
                    }

                    .searchable-dropdown::-webkit-scrollbar-thumb:hover {
                        background: #4caf50;
                    }
                </style>
            </head>

            <body class="bg-light">
                <div class="container">
                    <div class="row justify-content-center">
                        <div class="col-lg-10 col-md-12">
                            <div class="form-card">
                                <div class="form-header d-flex align-items-center gap-2">
                                    <i class="fas fa-route fa-2x me-2"></i>
                                    <div>
                                        <h4 class="mb-0">${route == null ? 'Add Route' : 'Edit Route'}</h4>
                                        <small>Manage bus route information</small>
                                    </div>
                                </div>
                                <!-- Notification Messages -->
                                <c:if test="${not empty param.message}">
                                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                                        <i class="fas fa-check-circle me-2"></i>
                                        <strong>Success!</strong> ${param.message}
                                        <button type="button" class="btn-close" data-bs-dismiss="alert"
                                            aria-label="Close"></button>
                                    </div>
                                </c:if>
                                <c:if test="${not empty param.error}">
                                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                        <i class="fas fa-exclamation-circle me-2"></i>
                                        <strong>Error!</strong> ${param.error}
                                        <button type="button" class="btn-close" data-bs-dismiss="alert"
                                            aria-label="Close"></button>
                                    </div>
                                </c:if>
                                <c:if test="${not empty param.warning}">
                                    <div class="alert alert-warning alert-dismissible fade show" role="alert">
                                        <i class="fas fa-exclamation-triangle me-2"></i>
                                        <strong>Warning!</strong> ${param.warning}
                                        <button type="button" class="btn-close" data-bs-dismiss="alert"
                                            aria-label="Close"></button>
                                    </div>
                                </c:if>
                                <c:if test="${not empty param.info}">
                                    <div class="alert alert-info alert-dismissible fade show" role="alert">
                                        <i class="fas fa-info-circle me-2"></i>
                                        <strong>Info:</strong> ${param.info}
                                        <button type="button" class="btn-close" data-bs-dismiss="alert"
                                            aria-label="Close"></button>
                                    </div>
                                </c:if>

                                <form id="routeForm"
                                    action="${pageContext.request.contextPath}/routes/${route == null ? 'add' : 'edit'}"
                                    method="post" autocomplete="off">
                                    <c:if test="${route != null}">
                                        <input type="hidden" name="routeId" value="${route.routeId}">
                                    </c:if>
                                    <div class="section-title"><i class="fas fa-info-circle me-1"></i>Basic Information
                                    </div>
                                    <div class="row g-3">
                                        <div class="col-md-6">
                                            <label for="routeName" class="form-label">Route Name *</label>
                                            <input type="text" class="form-control" id="routeName" name="routeName"
                                                value="${route.routeName}" required maxlength="100"
                                                placeholder="E.g: Hanoi - Hai Phong">
                                        </div>
                                        <div class="col-md-6">
                                            <label for="basePrice" class="form-label">Base Price (VND) *</label>
                                            <input type="number" class="form-control" id="basePrice" name="basePrice"
                                                value="${route.basePrice}" min="0" step="1000" required
                                                placeholder="e.g., 150000">
                                        </div>
                                    </div>

                                    <div class="section-title mt-4"><i class="fas fa-chart-line me-1"></i>Route Metrics
                                    </div>
                                    <p class="text-muted small mb-3">
                                        Provide the official route distance and estimated travel duration. These values
                                        will be used across schedules, tickets, and fare calculations.
                                    </p>
                                    <div class="row g-3">
                                        <div class="col-md-6">
                                            <label for="distance" class="form-label">Distance (km) *</label>
                                            <div class="input-group">
                                                <span class="input-group-text bg-light"><i
                                                        class="fas fa-road"></i></span>
                                                <input type="number" class="form-control" id="distance" name="distance"
                                                    value="${route != null && route.distance != null ? route.distance : ''}"
                                                    min="1" max="5000" step="0.1" required placeholder="e.g., 105.5">
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <label for="durationHours" class="form-label">Duration (hours) *</label>
                                            <div class="input-group">
                                                <span class="input-group-text bg-light"><i
                                                        class="fas fa-clock"></i></span>
                                                <input type="number" class="form-control" id="durationHours"
                                                    name="durationHours"
                                                    value="${route != null ? route.durationHours : ''}" min="1" max="72"
                                                    step="1" required placeholder="e.g., 2">
                                            </div>
                                        </div>
                                    </div>

                                    <div class="section-title mt-4"><i class="fas fa-landmark me-1"></i>Route Cities
                                    </div>
                                    <p class="text-muted small mb-3">
                                        Select departure and destination cities. The system will show available stations
                                        for
                                        selection.
                                    </p>
                                    <div class="row g-3">
                                        <div class="col-md-6">
                                            <label for="departureCityId" class="form-label">Departure City *</label>
                                            <div class="searchable-select-wrapper">
                                                <input type="text" class="form-control searchable-input"
                                                    id="departureCitySearch"
                                                    placeholder="Type to search departure city..." autocomplete="off">
                                                <select class="form-select d-none" id="departureCityId"
                                                    name="departureCityId" required>
                                                    <option value="">Select departure city</option>
                                                    <c:forEach var="city" items="${cities}">
                                                        <option value="${city.cityId}"
                                                            data-city-number="${city.cityNumber}" ${route !=null &&
                                                            route.departureCityId==city.cityId ? 'selected' : '' }>
                                                            ${city.cityNumber}. ${city.cityName}
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                                <div class="searchable-dropdown" id="departureCityDropdown">
                                                    <c:forEach var="city" items="${cities}">
                                                        <div class="searchable-option" data-value="${city.cityId}"
                                                            data-number="${city.cityNumber}"
                                                            data-name="${city.cityName}">
                                                            ${city.cityNumber}. ${city.cityName}
                                                        </div>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <label for="destinationCityId" class="form-label">Destination City *</label>
                                            <div class="searchable-select-wrapper">
                                                <input type="text" class="form-control searchable-input"
                                                    id="destinationCitySearch"
                                                    placeholder="Type to search destination city..." autocomplete="off">
                                                <select class="form-select d-none" id="destinationCityId"
                                                    name="destinationCityId" required>
                                                    <option value="">Select destination city</option>
                                                    <c:forEach var="city" items="${cities}">
                                                        <option value="${city.cityId}"
                                                            data-city-number="${city.cityNumber}" ${route !=null &&
                                                            route.destinationCityId==city.cityId ? 'selected' : '' }>
                                                            ${city.cityNumber}. ${city.cityName}
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                                <div class="searchable-dropdown" id="destinationCityDropdown">
                                                    <c:forEach var="city" items="${cities}">
                                                        <div class="searchable-option" data-value="${city.cityId}"
                                                            data-number="${city.cityNumber}"
                                                            data-name="${city.cityName}">
                                                            ${city.cityNumber}. ${city.cityName}
                                                        </div>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="section-title mt-4"><i class="fas fa-map-marker-alt me-1"></i>Terminal
                                        Stations
                                    </div>
                                    <div class="info-box">
                                        <i class="fas fa-info-circle"></i>
                                        <strong>Terminal Stations:</strong> Select the default boarding and alighting
                                        stations for
                                        this route. These will be pre-selected when customers book tickets.
                                    </div>
                                    <div class="row g-3">
                                        <div class="col-md-6">
                                            <label for="departureStationId" class="form-label">Departure Station</label>
                                            <select class="form-select" id="departureStationId"
                                                name="departureStationId">
                                                <option value="">Select departure station</option>
                                                <c:forEach var="station" items="${stations}">
                                                    <option value="${station.stationId}"
                                                        data-city-id="${station.cityId}" ${route !=null &&
                                                        route.departureStationId==station.stationId ? 'selected' : '' }>
                                                        ${station.stationName} (${station.city})
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-md-6">
                                            <label for="destinationStationId" class="form-label">Destination
                                                Station</label>
                                            <select class="form-select" id="destinationStationId"
                                                name="destinationStationId">
                                                <option value="">Select destination station</option>
                                                <c:forEach var="station" items="${stations}">
                                                    <option value="${station.stationId}"
                                                        data-city-id="${station.cityId}" ${route !=null &&
                                                        route.destinationStationId==station.stationId ? 'selected' : ''
                                                        }>
                                                        ${station.stationName} (${station.city})
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>

                                    <div class="section-title mt-4"><i class="fas fa-bus-alt me-1"></i>Intermediate
                                        Stations
                                    </div>
                                    <div class="info-box">
                                        <i class="fas fa-info-circle"></i>
                                        <strong>Intermediate Stations:</strong> Select the stations along this route
                                        where the bus
                                        will stop. The order follows the city sequence from departure to destination.
                                    </div>
                                    <div id="stationSelectionContainer" class="station-list">
                                        <div class="text-center text-muted py-3">
                                            <i class="fas fa-map-signs fa-2x mb-2 d-block"></i>
                                            Please select departure and destination cities first
                                        </div>
                                    </div>

                                    <div class="d-flex justify-content-between align-items-center mt-4">
                                        <a href="${pageContext.request.contextPath}/routes"
                                            class="btn btn-outline-secondary">
                                            <i class="fas fa-arrow-left me-2"></i>Back
                                        </a>
                                        <button type="submit" class="btn btn-gradient">
                                            <i class="fas fa-save me-2"></i>${route == null ? 'Add Route' : 'Update'}
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
                <%@ include file="/views/partials/footer.jsp" %>

                    <!-- Hidden data containers for JavaScript -->
                    <div id="stationsData" style="display:none;">
                        <c:forEach var="station" items="${stations}">
                            <div class="station-data" data-id="${station.stationId}"
                                data-name="${fn:escapeXml(station.stationName)}" data-city-id="${station.cityId}"
                                data-city-name="${fn:escapeXml(station.city)}"></div>
                        </c:forEach>
                    </div>
                    <div id="citiesData" style="display:none;">
                        <c:forEach var="city" items="${cities}">
                            <div class="city-data" data-id="${city.cityId}" data-name="${fn:escapeXml(city.cityName)}"
                                data-number="${city.cityNumber}"></div>
                        </c:forEach>
                    </div>
                    <div id="existingStationsData" style="display:none;">
                        <c:if test="${route != null && routeStations != null}">
                            <c:forEach var="station" items="${routeStations}">
                                <span data-id="${station.stationId}"></span>
                            </c:forEach>
                        </c:if>
                    </div>

                    <script>
                        document.addEventListener('DOMContentLoaded', function () {
                            // Searchable Dropdown Implementation
                            function initSearchableDropdown(searchInputId, selectId, dropdownId) {
                                const searchInput = document.getElementById(searchInputId);
                                const selectElement = document.getElementById(selectId);
                                const dropdown = document.getElementById(dropdownId);
                                const options = dropdown.querySelectorAll('.searchable-option');

                                // Set initial value if option is selected
                                const selectedOption = selectElement.querySelector('option[selected]');
                                if (selectedOption && selectedOption.value) {
                                    const optionText = selectedOption.textContent.trim();
                                    searchInput.value = optionText;
                                    options.forEach(opt => {
                                        if (opt.dataset.value === selectedOption.value) {
                                            opt.classList.add('selected');
                                        }
                                    });
                                }

                                // Show dropdown on input focus
                                searchInput.addEventListener('focus', function () {
                                    dropdown.classList.add('show');
                                    // Show all options when focused
                                    options.forEach(option => option.classList.remove('hidden'));
                                });

                                // Filter options on input
                                searchInput.addEventListener('input', function () {
                                    const searchTerm = this.value.trim().toLowerCase();
                                    let visibleCount = 0;

                                    options.forEach(option => {
                                        const text = option.textContent.trim().toLowerCase();
                                        if (text.includes(searchTerm)) {
                                            option.classList.remove('hidden');
                                            visibleCount++;
                                        } else {
                                            option.classList.add('hidden');
                                        }
                                    });

                                    // Show dropdown if there's text and visible options
                                    if (this.value && visibleCount > 0) {
                                        dropdown.classList.add('show');
                                    }
                                });

                                // Handle option click
                                options.forEach(option => {
                                    option.addEventListener('click', function () {
                                        const value = this.dataset.value;
                                        const text = this.textContent.trim();

                                        // Update hidden select
                                        selectElement.value = value;

                                        // Update search input
                                        searchInput.value = text;

                                        // Update selected class
                                        options.forEach(opt => opt.classList.remove('selected'));
                                        this.classList.add('selected');

                                        // Hide dropdown
                                        dropdown.classList.remove('show');

                                        // Trigger change event on select
                                        selectElement.dispatchEvent(new Event('change'));
                                    });
                                });

                                // Close dropdown when clicking outside
                                document.addEventListener('click', function (e) {
                                    if (!searchInput.contains(e.target) && !dropdown.contains(e.target)) {
                                        dropdown.classList.remove('show');
                                    }
                                });

                                // Prevent form submission on Enter in search input
                                searchInput.addEventListener('keydown', function (e) {
                                    if (e.key === 'Enter') {
                                        e.preventDefault();
                                        // Select first visible option
                                        const firstVisible = Array.from(options).find(opt => !opt.classList.contains('hidden'));
                                        if (firstVisible) {
                                            firstVisible.click();
                                        }
                                    }
                                });
                            }

                            // Initialize both searchable dropdowns
                            initSearchableDropdown('departureCitySearch', 'departureCityId', 'departureCityDropdown');
                            initSearchableDropdown('destinationCitySearch', 'destinationCityId', 'destinationCityDropdown');

                            // Auto-close alerts
                            const alerts = document.querySelectorAll('.alert');
                            alerts.forEach(function (alert) {
                                setTimeout(function () {
                                    const bsAlert = new bootstrap.Alert(alert);
                                    bsAlert.close();
                                }, 5000);
                            });
                            if (alerts.length > 0) {
                                window.scrollTo({ top: 0, behavior: 'smooth' });
                            }

                            // DOM elements
                            const departureCitySelect = document.getElementById('departureCityId');
                            const destinationCitySelect = document.getElementById('destinationCityId');
                            const departureStationSelect = document.getElementById('departureStationId');
                            const destinationStationSelect = document.getElementById('destinationStationId');
                            const stationContainer = document.getElementById('stationSelectionContainer');

                            // Parse stations data from hidden elements
                            const allStations = [];
                            document.querySelectorAll('#stationsData .station-data').forEach(el => {
                                allStations.push({
                                    id: el.dataset.id,
                                    name: el.dataset.name,
                                    cityId: el.dataset.cityId,
                                    cityName: el.dataset.cityName
                                });
                            });

                            // Parse cities data from hidden elements
                            const citiesData = {};
                            document.querySelectorAll('#citiesData .city-data').forEach(el => {
                                citiesData[el.dataset.id] = {
                                    id: el.dataset.id,
                                    name: el.dataset.name,
                                    number: parseInt(el.dataset.number)
                                };
                            });

                            // Parse existing route stations
                            const existingRouteStations = [];
                            document.querySelectorAll('#existingStationsData span').forEach(el => {
                                existingRouteStations.push(el.dataset.id);
                            });

                            // Terminal station IDs
                            let departureTerminalStationId = departureStationSelect.value || '';
                            let destinationTerminalStationId = destinationStationSelect.value || '';

                            function filterStationsByCity(selectElement, cityId) {
                                const options = selectElement.querySelectorAll('option');
                                options.forEach(option => {
                                    if (option.value === '' || option.dataset.cityId === cityId) {
                                        option.style.display = '';
                                    } else {
                                        option.style.display = 'none';
                                    }
                                });
                                if (selectElement.value && selectElement.selectedOptions[0]?.style.display === 'none') {
                                    selectElement.value = '';
                                }
                            }

                            function escapeHtml(text) {
                                const div = document.createElement('div');
                                div.textContent = text;
                                return div.innerHTML;
                            }

                            function updateIntermediateStations() {
                                const depCityId = departureCitySelect.value;
                                const destCityId = destinationCitySelect.value;

                                if (!depCityId || !destCityId) {
                                    stationContainer.innerHTML = '<div class="empty-state">' +
                                        '<i class="fas fa-map-marked-alt"></i>' +
                                        '<p>Please select departure and destination cities</p>' +
                                        '</div>';
                                    return;
                                }

                                const depCity = citiesData[depCityId];
                                const destCity = citiesData[destCityId];
                                if (!depCity || !destCity) return;

                                const minNum = Math.min(depCity.number, destCity.number);
                                const maxNum = Math.max(depCity.number, destCity.number);

                                const citiesInRange = Object.values(citiesData)
                                    .filter(c => c.number >= minNum && c.number <= maxNum)
                                    .sort((a, b) => {
                                        return depCity.number < destCity.number ? a.number - b.number : b.number - a.number;
                                    });

                                let html = '';
                                let totalStations = 0;

                                citiesInRange.forEach(city => {
                                    const cityStations = allStations.filter(s => s.cityId === city.id);
                                    if (cityStations.length === 0) return;

                                    totalStations += cityStations.length;
                                    const isDepCity = city.id === depCityId;
                                    const isDestCity = city.id === destCityId;

                                    let cityBadge = '';
                                    if (isDepCity) {
                                        cityBadge = '<span class="terminal-badge departure"><i class="fas fa-play-circle me-1"></i>Departure Point</span>';
                                    } else if (isDestCity) {
                                        cityBadge = '<span class="terminal-badge destination"><i class="fas fa-flag-checkered me-1"></i>Destination Point</span>';
                                    }

                                    html += '<div class="city-group">' +
                                        '<div class="city-group-header">' +
                                        '<i class="fas fa-building"></i> ' +
                                        escapeHtml(city.name) +
                                        ' <span class="station-count">' + cityStations.length + ' stations</span>' +
                                        cityBadge +
                                        '</div>';

                                    cityStations.forEach(station => {
                                        const isTerminalStation = station.id === departureTerminalStationId || station.id === destinationTerminalStationId;
                                        const isSelected = existingRouteStations.includes(station.id) || isTerminalStation;

                                        let stationBadge = '';
                                        if (station.id === departureTerminalStationId) {
                                            stationBadge = '<span class="terminal-badge departure">Starting Point</span>';
                                        } else if (station.id === destinationTerminalStationId) {
                                            stationBadge = '<span class="terminal-badge destination">End Point</span>';
                                        }

                                        html += '<div class="station-item ' + (isSelected ? 'selected' : '') + '" onclick="this.querySelector(\'input\').click()">' +
                                            '<input type="checkbox" name="selectedStationIds" value="' + station.id + '" ' +
                                            'id="station_' + station.id + '" ' + (isSelected ? 'checked' : '') + ' onclick="event.stopPropagation()">' +
                                            '<label for="station_' + station.id + '" class="station-info" onclick="event.preventDefault()">' +
                                            '<span class="station-name">' + escapeHtml(station.name) + '</span>' +
                                            stationBadge +
                                            '</label>' +
                                            '</div>';
                                    });

                                    html += '</div>';
                                });

                                if (html) {
                                    stationContainer.innerHTML = html;
                                } else {
                                    stationContainer.innerHTML = '<div class="empty-state">' +
                                        '<i class="fas fa-exclamation-circle"></i>' +
                                        '<p>No stations found in selected range</p>' +
                                        '</div>';
                                }

                                // Add checkbox toggle listeners
                                stationContainer.querySelectorAll('.station-item input[type="checkbox"]').forEach(cb => {
                                    cb.addEventListener('change', function (e) {
                                        e.stopPropagation();
                                        this.closest('.station-item').classList.toggle('selected', this.checked);
                                    });
                                });
                            }

                            // City selection change handlers
                            departureCitySelect.addEventListener('change', function () {
                                filterStationsByCity(departureStationSelect, this.value);
                                departureStationSelect.value = '';
                                departureTerminalStationId = '';
                                updateIntermediateStations();
                            });

                            destinationCitySelect.addEventListener('change', function () {
                                filterStationsByCity(destinationStationSelect, this.value);
                                destinationStationSelect.value = '';
                                destinationTerminalStationId = '';
                                updateIntermediateStations();
                            });

                            // Terminal station change handlers
                            departureStationSelect.addEventListener('change', function () {
                                departureTerminalStationId = this.value;
                                updateIntermediateStations();
                            });

                            destinationStationSelect.addEventListener('change', function () {
                                destinationTerminalStationId = this.value;
                                updateIntermediateStations();
                            });

                            // Initial setup
                            if (departureCitySelect.value) {
                                filterStationsByCity(departureStationSelect, departureCitySelect.value);
                            }
                            if (destinationCitySelect.value) {
                                filterStationsByCity(destinationStationSelect, destinationCitySelect.value);
                            }
                            departureTerminalStationId = departureStationSelect.value || '';
                            destinationTerminalStationId = destinationStationSelect.value || '';
                            updateIntermediateStations();

                            // Form validation
                            document.querySelector('form').addEventListener('submit', function (e) {
                                if (!departureCitySelect.value || !destinationCitySelect.value) {
                                    alert('Please select departure and destination cities.');
                                    e.preventDefault();
                                    return false;
                                }
                                if (departureCitySelect.value === destinationCitySelect.value) {
                                    alert('Departure and destination cities must be different.');
                                    e.preventDefault();
                                    return false;
                                }
                                return true;
                            });
                        });
                    </script>
            </body>

            </html>