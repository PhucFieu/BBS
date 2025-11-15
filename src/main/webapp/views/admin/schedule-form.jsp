<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>${not empty schedule ? 'Edit' : 'Add'} Schedule - Admin Dashboard</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
                <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
                <style>
                    /* ===== GLOBAL STYLES ===== */
                    :root {
                        --primary-color: #66bb6a;
                        --secondary-color: #81c784;
                        --success-color: #4caf50;
                        --danger-color: #dc3545;
                        --warning-color: #ffc107;
                        --info-color: #66bb6a;
                        --light-color: #e8f5e9;
                        --dark-color: #2e7d32;
                        --white: #ffffff;
                        --gray-100: #e8f5e9;
                        --gray-200: #c8e6c9;
                        --gray-300: #a5d6a7;
                        --gray-400: #81c784;
                        --gray-500: #66bb6a;
                        --gray-600: #4caf50;
                        --gray-700: #388e3c;
                        --gray-800: #2e7d32;
                        --gray-900: #1b5e20;
                        --shadow-sm: 0 0.125rem 0.25rem rgba(102, 187, 106, 0.15);
                        --shadow: 0 0.5rem 1rem rgba(102, 187, 106, 0.2);
                        --shadow-lg: 0 1rem 3rem rgba(102, 187, 106, 0.25);
                        --border-radius: 0.375rem;
                        --border-radius-lg: 0.5rem;
                        --border-radius-xl: 0.75rem;
                        --transition: all 0.3s ease;
                    }

                    body {
                        font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
                        line-height: 1.6;
                        color: var(--gray-800);
                        background-color: #f1f8f4;
                        min-height: 100vh;
                    }

                    .navbar {
                        background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%) !important;
                        box-shadow: var(--shadow);
                        padding: 1rem 0;
                    }

                    .navbar-brand {
                        font-weight: 700;
                        font-size: 1.5rem;
                        color: var(--white) !important;
                        text-decoration: none;
                        transition: var(--transition);
                    }

                    .navbar-brand:hover {
                        color: var(--gray-200) !important;
                        transform: translateY(-1px);
                    }

                    .navbar-nav .nav-link {
                        color: var(--white) !important;
                        font-weight: 500;
                        padding: 0.5rem 1rem !important;
                        border-radius: var(--border-radius);
                        transition: var(--transition);
                        margin: 0 0.25rem;
                    }

                    .navbar-nav .nav-link:hover {
                        background-color: rgba(255, 255, 255, 0.1);
                        color: var(--white) !important;
                        transform: translateY(-1px);
                    }

                    .dropdown-menu {
                        border: none;
                        box-shadow: var(--shadow-lg);
                        border-radius: var(--border-radius-lg);
                        padding: 0.5rem 0;
                        background-color: var(--white);
                        margin-top: 0.5rem;
                    }

                    .dropdown-item {
                        padding: 0.75rem 1.5rem;
                        transition: var(--transition);
                        color: var(--gray-700);
                        text-decoration: none;
                        display: block;
                    }

                    .dropdown-item:hover {
                        background-color: var(--gray-100);
                        color: var(--primary-color);
                        text-decoration: none;
                    }

                    footer {
                        background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
                        color: var(--white);
                        padding: 2rem 0;
                        margin-top: auto;
                    }

                    footer a {
                        color: var(--gray-300);
                        text-decoration: none;
                        transition: var(--transition);
                    }

                    footer a:hover {
                        color: var(--white);
                    }

                    ::-webkit-scrollbar {
                        width: 8px;
                    }

                    ::-webkit-scrollbar-track {
                        background: var(--gray-200);
                    }

                    ::-webkit-scrollbar-thumb {
                        background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
                        border-radius: 4px;
                    }

                    ::-webkit-scrollbar-thumb:hover {
                        background: linear-gradient(135deg, #4caf50 0%, #66bb6a 100%);
                    }

                    @media (max-width: 768px) {
                        .container {
                            padding: 0 1rem;
                        }
                        .card-body {
                            padding: 1rem;
                        }
                        .btn {
                            padding: 0.5rem 1rem;
                            font-size: 0.875rem;
                        }
                    }
                    .form-container {
                        background: linear-gradient(135deg, #66bb6a 0%, #81c784 100%);
                        border-radius: 15px;
                        padding: 2rem;
                        margin-bottom: 2rem;
                        color: white;
                    }

                    .form-card {
                        background: white;
                        border-radius: 15px;
                        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
                        overflow: hidden;
                    }

                    .form-header {
                        background: linear-gradient(135deg, #66bb6a 0%, #81c784 100%);
                        color: white;
                        padding: 2rem;
                        text-align: center;
                    }

                    .form-body {
                        padding: 2rem;
                    }

                    .form-group {
                        margin-bottom: 1.5rem;
                    }

                    .form-label {
                        font-weight: 600;
                        color: #333;
                        margin-bottom: 0.5rem;
                    }

                    .form-control,
                    .form-select {
                        border: 2px solid #e9ecef;
                        border-radius: 10px;
                        padding: 0.75rem 1rem;
                        transition: all 0.3s ease;
                    }

                    .form-control:focus,
                    .form-select:focus {
                        border-color: #66bb6a;
                        box-shadow: 0 0 0 0.2rem rgba(102, 187, 106, 0.25);
                    }

                    .btn-submit {
                        background: linear-gradient(135deg, #66bb6a 0%, #81c784 100%);
                        border: none;
                        border-radius: 10px;
                        padding: 0.75rem 2rem;
                        font-weight: 600;
                        transition: all 0.3s ease;
                    }

                    .btn-submit:hover {
                        transform: translateY(-2px);
                        box-shadow: 0 5px 15px rgba(102, 187, 106, 0.4);
                    }

                    .btn-cancel {
                        border: 2px solid #6c757d;
                        border-radius: 10px;
                        padding: 0.75rem 2rem;
                        font-weight: 600;
                        transition: all 0.3s ease;
                    }

                    .btn-cancel:hover {
                        background-color: #6c757d;
                        color: white;
                    }

                    .info-card {
                        background: #f8f9fa;
                        border-left: 4px solid #66bb6a;
                        border-radius: 0 10px 10px 0;
                        padding: 1rem;
                        margin-bottom: 1rem;
                    }

                    .station-selection-container {
                        max-height: 400px;
                        overflow-y: auto;
                        border: 2px solid #e9ecef;
                        border-radius: 10px;
                        padding: 1rem;
                        background: #f8f9fa;
                    }

                    .station-card {
                        margin-bottom: 0;
                    }

                    .station-card .form-check-input {
                        position: absolute;
                        top: 10px;
                        right: 10px;
                        z-index: 10;
                    }

                    .station-card .form-check-label {
                        cursor: pointer;
                    }

                    .station-card .card {
                        transition: all 0.3s ease;
                        border: 2px solid transparent;
                    }

                    .station-card .form-check-input:checked+.form-check-label .card {
                        border-color: #66bb6a;
                        background: linear-gradient(135deg, rgba(102, 187, 106, 0.1) 0%, rgba(129, 199, 132, 0.1) 100%);
                        transform: translateY(-2px);
                        box-shadow: 0 5px 15px rgba(102, 187, 106, 0.2);
                    }

                    .station-card .form-check-input:checked+.form-check-label .card-title {
                        color: #66bb6a;
                        font-weight: 600;
                    }

                    .station-details-card {
                        background: #f8f9fa;
                        border: 1px solid #dee2e6;
                        border-radius: 8px;
                        padding: 1rem;
                        margin-bottom: 1rem;
                    }

                    .station-details-card h6 {
                        color: #66bb6a;
                        margin-bottom: 1rem;
                    }
                </style>
            </head>

            <body>
                <jsp:include page="../partials/admin-header.jsp" />

                <div class="container-fluid py-4">
                    <div class="row justify-content-center">
                        <div class="col-lg-8">
                            <!-- Header Section -->
                            <div class="form-container">
                                <div class="row align-items-center">
                                    <div class="col-md-8">
                                        <h2 class="mb-0">
                                            <i class="fas fa-calendar-alt me-2"></i>
                                            ${not empty schedule ? 'Edit Schedule' : 'Add New Schedule'}
                                        </h2>
                                        <p class="mb-0 mt-2">
                                            ${not empty schedule ? 'Update schedule information' : 'Create a new bus
                                            schedule'}
                                        </p>
                                    </div>
                                    <div class="col-md-4 text-md-end">
                                        <a href="${pageContext.request.contextPath}/admin/schedules"
                                            class="btn btn-light">
                                            <i class="fas fa-arrow-left me-2"></i>Back to Schedules
                                        </a>
                                    </div>
                                </div>
                            </div>

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

                            <!-- Form Card -->
                            <div class="form-card">
                                <div class="form-header">
                                    <h4 class="mb-0">
                                        <i class="fas fa-${not empty schedule ? 'edit' : 'plus'} me-2"></i>
                                        Schedule Information
                                    </h4>
                                </div>
                                <div class="form-body">
                                    <div id="formError" class="alert alert-danger d-none" role="alert" tabindex="-1">
                                    </div>
                                    <form
                                        action="${pageContext.request.contextPath}/admin/schedules/${not empty schedule ? 'edit' : 'add'}"
                                        method="post" id="scheduleForm">

                                        <c:if test="${not empty schedule}">
                                            <input type="hidden" name="scheduleId" value="${schedule.scheduleId}">
                                        </c:if>

                                        <div class="row">
                                            <!-- Route Selection -->
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label for="routeId" class="form-label">
                                                        <i class="fas fa-route me-2"></i>Route *
                                                    </label>
                                                    <select class="form-select" id="routeId" name="routeId" required>
                                                        <option value="">Select a route</option>
                                                        <c:forEach var="route" items="${routes}">
                                                            <option value="${route.routeId}" ${not empty schedule &&
                                                                schedule.routeId==route.routeId ? 'selected' : '' }>
                                                                ${route.routeName} (${route.departureCity} →
                                                                ${route.destinationCity})
                                                            </option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                            </div>

                                            <!-- Bus Selection -->
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label for="busId" class="form-label">
                                                        <i class="fas fa-bus me-2"></i>Bus *
                                                    </label>
                                                    <select class="form-select" id="busId" name="busId" required>
                                                        <option value="">Select a bus</option>
                                                        <c:forEach var="bus" items="${buses}">
                                                            <option value="${bus.busId}" ${not empty schedule &&
                                                                schedule.busId==bus.busId ? 'selected' : '' }>
                                                                ${bus.busNumber} - ${bus.busType} (${bus.totalSeats}
                                                                seats)
                                                            </option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="row">
                                            <!-- Departure Date -->
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label for="departureDate" class="form-label">
                                                        <i class="fas fa-calendar me-2"></i>Departure Date *
                                                    </label>
                                                    <input type="date" class="form-control" id="departureDate"
                                                        name="departureDate"
                                                        value="${not empty schedule ? schedule.departureDate : ''}"
                                                        required>
                                                </div>
                                            </div>

                                            <!-- Available Seats -->
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label for="availableSeats" class="form-label">
                                                        <i class="fas fa-users me-2"></i>Available Seats *
                                                    </label>
                                                    <input type="number" class="form-control" id="availableSeats"
                                                        name="availableSeats"
                                                        value="${not empty schedule ? schedule.availableSeats : ''}"
                                                        min="1" max="100" required>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="row">
                                            <!-- Departure Time -->
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label for="departureTime" class="form-label">
                                                        <i class="fas fa-clock me-2"></i>Departure Time *
                                                    </label>
                                                    <input type="time" class="form-control" id="departureTime"
                                                        name="departureTime"
                                                        value="${not empty schedule ? schedule.departureTime : ''}"
                                                        required>
                                                </div>
                                            </div>

                                            <!-- Arrival Time -->
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label for="arrivalTime" class="form-label">
                                                        <i class="fas fa-clock me-2"></i>Estimated Arrival Time *
                                                    </label>
                                                    <input type="time" class="form-control" id="arrivalTime"
                                                        name="arrivalTime"
                                                        value="${not empty schedule ? schedule.estimatedArrivalTime : ''}"
                                                        required>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Station Selection Section -->
                                        <div class="row">
                                            <div class="col-12">
                                                <div class="form-group">
                                                    <label class="form-label">
                                                        <i class="fas fa-map-marker-alt me-2"></i>Select Stations *
                                                    </label>
                                                    <div class="station-selection-container">
                                                        <div class="row">
                                                            <c:forEach var="station" items="${stations}">
                                                                <div class="col-md-6 col-lg-4 mb-3">
                                                                    <div class="form-check station-card">
                                                                        <input class="form-check-input station-checkbox"
                                                                            type="checkbox" value="${station.stationId}"
                                                                            id="station_${station.stationId}"
                                                                            name="selectedStations" <c:if
                                                                            test="${not empty scheduleStops}">
                                                                        <c:forEach var="stop" items="${scheduleStops}">
                                                                            <c:if
                                                                                test="${stop.stationId == station.stationId}">
                                                                                checked</c:if>
                                                                        </c:forEach>
                                                                        </c:if>>
                                                                        <label class="form-check-label w-100"
                                                                            for="station_${station.stationId}">
                                                                            <div class="card h-100">
                                                                                <div class="card-body p-3">
                                                                                    <h6 class="card-title mb-2">
                                                                                        <i
                                                                                            class="fas fa-building me-2"></i>${station.stationName}
                                                                                    </h6>
                                                                                    <p class="card-text mb-1">
                                                                                        <i
                                                                                            class="fas fa-map-marker-alt me-1"></i>${station.city}
                                                                                    </p>
                                                                                    <small
                                                                                        class="text-muted">${station.address}</small>
                                                                                </div>
                                                                            </div>
                                                                        </label>
                                                                    </div>
                                                                </div>
                                                            </c:forEach>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Station Details Section (Hidden by default) -->
                                        <div id="stationDetailsSection" class="row" style="display: none;">
                                            <div class="col-12">
                                                <div class="form-group">
                                                    <label class="form-label">
                                                        <i class="fas fa-clock me-2"></i>Station Arrival Times &
                                                        Durations
                                                    </label>
                                                    <div id="selectedStationsDetails">
                                                        <!-- Dynamic content will be added here -->
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Information Card -->
                                        <div class="info-card">
                                            <h6 class="mb-2">
                                                <i class="fas fa-info-circle me-2"></i>Important Information
                                            </h6>
                                            <ul class="mb-0 small">
                                                <li>Make sure the departure time is before the arrival time</li>
                                                <li>Available seats should not exceed the bus capacity</li>
                                                <li>Select at least one station for the schedule</li>
                                                <li>You can set different arrival times and stop durations for each
                                                    station</li>
                                                <li>Schedule will be automatically set to "SCHEDULED" status</li>
                                                <li>You can assign drivers to this schedule after creation</li>
                                            </ul>
                                        </div>

                                        <!-- Form Actions -->
                                        <div class="d-flex justify-content-between pt-3">
                                            <a href="${pageContext.request.contextPath}/admin/schedules"
                                                class="btn btn-cancel">
                                                <i class="fas fa-times me-2"></i>Cancel
                                            </a>
                                            <button type="submit" class="btn btn-submit text-white">
                                                <i class="fas fa-${not empty schedule ? 'save' : 'plus'} me-2"></i>
                                                ${not empty schedule ? 'Update Schedule' : 'Create Schedule'}
                                            </button>
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
                        document.addEventListener('DOMContentLoaded', function () {
                            const form = document.getElementById('scheduleForm');
                            const departureTime = document.getElementById('departureTime');
                            const arrivalTime = document.getElementById('arrivalTime');
                            const departureDate = document.getElementById('departureDate');
                            const availableSeats = document.getElementById('availableSeats');
                            const busSelect = document.getElementById('busId');
                            const stationCheckboxes = document.querySelectorAll('.station-checkbox');
                            const stationDetailsSection = document.getElementById('stationDetailsSection');
                            const selectedStationsDetails = document.getElementById('selectedStationsDetails');
                            const formErrorAlert = document.getElementById('formError');
                            let lastErrorSource = null;

                            function showFormError(message, source) {
                                if (!formErrorAlert) return;
                                formErrorAlert.textContent = message;
                                formErrorAlert.classList.remove('d-none');
                                if (typeof formErrorAlert.focus === 'function') {
                                    try {
                                        formErrorAlert.focus();
                                    } catch (error) {
                                        // Ignore focus errors
                                    }
                                }
                                formErrorAlert.scrollIntoView({ behavior: 'smooth', block: 'center' });
                                lastErrorSource = source || null;
                            }

                            function hideFormError(source) {
                                if (!formErrorAlert) return;
                                if (!source || lastErrorSource === source) {
                                    formErrorAlert.classList.add('d-none');
                                    formErrorAlert.textContent = '';
                                    lastErrorSource = null;
                                }
                            }

                            // Set minimum date to today
                            const today = new Date().toISOString().split('T')[0];
                            departureDate.setAttribute('min', today);

                            // Validate time inputs
                            function validateTimes() {
                                if (departureTime.value && arrivalTime.value) {
                                    if (departureTime.value >= arrivalTime.value) {
                                        arrivalTime.setCustomValidity('Arrival time must be after departure time');
                                        showFormError('Giờ đến dự kiến phải muộn hơn giờ khởi hành.', 'time');
                                        return false;
                                    } else {
                                        arrivalTime.setCustomValidity('');
                                        hideFormError('time');
                                        return true;
                                    }
                                }
                                return true;
                            }

                            // Validate available seats against bus capacity
                            function validateSeats() {
                                const selectedBus = busSelect.options[busSelect.selectedIndex];
                                if (selectedBus.value && availableSeats.value) {
                                    const busCapacity = selectedBus.text.match(/\((\d+) seats\)/);
                                    if (busCapacity) {
                                        const capacity = parseInt(busCapacity[1]);
                                        if (parseInt(availableSeats.value) > capacity) {
                                            availableSeats.setCustomValidity(`Available seats cannot exceed bus capacity (${capacity})`);
                                            showFormError(`Số ghế trống không được vượt quá sức chứa của xe (${capacity}).`, 'seats');
                                            return false;
                                        } else {
                                            availableSeats.setCustomValidity('');
                                            hideFormError('seats');
                                            return true;
                                        }
                                    }
                                }
                                availableSeats.setCustomValidity('');
                                hideFormError('seats');
                                return true;
                            }

                            // Validate station selection
                            function validateStations() {
                                const checkedStations = document.querySelectorAll('.station-checkbox:checked');
                                if (checkedStations.length === 0) {
                                    showFormError('Vui lòng chọn ít nhất một trạm dừng cho lịch trình.', 'stations');
                                    return false;
                                }
                                hideFormError('stations');
                                return true;
                            }

                            // Handle station selection changes
                            function handleStationSelection() {
                                const checkedStations = document.querySelectorAll('.station-checkbox:checked');

                                if (checkedStations.length > 0) {
                                    stationDetailsSection.style.display = 'block';
                                    updateStationDetails();
                                } else {
                                    stationDetailsSection.style.display = 'none';
                                }
                            }

                            // Update station details section
                            function updateStationDetails() {
                                const checkedStations = document.querySelectorAll('.station-checkbox:checked');
                                let html = '';

                                checkedStations.forEach((checkbox, index) => {
                                    const stationId = checkbox.value;
                                    const stationName = checkbox.closest('.station-card').querySelector('.card-title').textContent.trim();

                                    html += `
                                    <div class="station-details-card">
                                        <h6><i class="fas fa-building me-2"></i>${stationName}</h6>
                                        <div class="row">
                                            <div class="col-md-6">
                                                <label for="arrivalTime_${stationId}" class="form-label">Arrival Time</label>
                                                <input type="time" class="form-control" id="arrivalTime_${stationId}" 
                                                       name="arrivalTime_${stationId}" 
                                                       value="${arrivalTime.value}">
                                            </div>
                                            <div class="col-md-6">
                                                <label for="stopDuration_${stationId}" class="form-label">Stop Duration (minutes)</label>
                                                <input type="number" class="form-control" id="stopDuration_${stationId}" 
                                                       name="stopDuration_${stationId}" 
                                                       value="0" min="0" max="120">
                                            </div>
                                        </div>
                                    </div>
                                `;
                                });

                                selectedStationsDetails.innerHTML = html;
                            }

                            // Event listeners
                            departureTime.addEventListener('change', validateTimes);
                            arrivalTime.addEventListener('change', validateTimes);
                            availableSeats.addEventListener('input', validateSeats);
                            busSelect.addEventListener('change', validateSeats);

                            // Station selection event listeners
                            stationCheckboxes.forEach(checkbox => {
                                checkbox.addEventListener('change', handleStationSelection);
                                checkbox.addEventListener('change', function () {
                                    if (document.querySelectorAll('.station-checkbox:checked').length > 0) {
                                        hideFormError('stations');
                                    }
                                });
                            });

                            // Form submission
                            form.addEventListener('submit', function (e) {
                                hideFormError();
                                if (!validateTimes() || !validateSeats() || !validateStations()) {
                                    e.preventDefault();
                                    return false;
                                }
                            });

                            // Auto-fill available seats based on bus capacity
                            busSelect.addEventListener('change', function () {
                                const selectedBus = this.options[this.selectedIndex];
                                if (selectedBus.value) {
                                    const busCapacity = selectedBus.text.match(/\((\d+) seats\)/);
                                    if (busCapacity && !availableSeats.value) {
                                        availableSeats.value = busCapacity[1];
                                    }
                                }
                            });

                            // Initialize station details if editing existing schedule
                            if (document.querySelectorAll('.station-checkbox:checked').length > 0) {
                                handleStationSelection();
                            }
                        });
                    </script>
            </body>

            </html>