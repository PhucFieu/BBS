<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Assign Driver - Admin Dashboard</title>
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
                    .schedule-info {
                        background: linear-gradient(135deg, #66bb6a 0%, #81c784 100%);
                        border-radius: 15px;
                        padding: 2rem;
                        color: white;
                        margin-bottom: 2rem;
                    }

                    .driver-card {
                        transition: transform 0.2s ease-in-out, box-shadow 0.2s ease-in-out;
                        cursor: pointer;
                        border: 2px solid transparent;
                    }

                    .driver-card:hover {
                        transform: translateY(-5px);
                        box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
                        border-color: #007bff;
                    }

                    .driver-card.selected {
                        border-color: #66bb6a;
                        background-color: #f8fff9;
                    }

                    .driver-card.selected .card-header {
                        background-color: #66bb6a !important;
                    }

                    .experience-badge {
                        font-size: 0.8em;
                    }

                    .search-section {
                        background: #f8f9fa;
                        border-radius: 10px;
                        padding: 1.5rem;
                        margin-bottom: 2rem;
                    }
                </style>
            </head>

            <body>
                <jsp:include page="../partials/admin-header.jsp" />

                <div class="container-fluid py-4">
                    <div class="row">
                        <div class="col-12">
                            <!-- Header -->
                            <div class="d-flex justify-content-between align-items-center mb-4">
                                <h2>
                                    <i class="fas fa-user-plus me-2"></i>Assign Driver to Trip
                                </h2>
                                <a href="${pageContext.request.contextPath}/admin/schedules"
                                    class="btn btn-outline-secondary">
                                    <i class="fas fa-arrow-left me-1"></i>Back to Schedules
                                </a>
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

                            <!-- Schedule Information -->
                            <c:if test="${not empty schedule}">
                                <div class="schedule-info">
                                    <div class="row">
                                        <div class="col-md-8">
                                            <h3 class="mb-3">
                                                <i class="fas fa-route me-2"></i>${schedule.routeName}
                                            </h3>
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <div class="mb-2">
                                                        <i class="fas fa-calendar-alt me-2"></i>
                                                        <strong>Date:</strong> ${schedule.departureDate}
                                                    </div>
                                                    <div class="mb-2">
                                                        <i class="fas fa-clock me-2"></i>
                                                        <strong>Departure:</strong> ${schedule.departureTime}
                                                    </div>
                                                    <div class="mb-2">
                                                        <i class="fas fa-clock me-2"></i>
                                                        <strong>Arrival:</strong> ${schedule.estimatedArrivalTime}
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="mb-2">
                                                        <i class="fas fa-bus me-2"></i>
                                                        <strong>Bus:</strong> ${schedule.busNumber}
                                                    </div>
                                                    <div class="mb-2">
                                                        <i class="fas fa-map-marker-alt me-2"></i>
                                                        <strong>Route:</strong> ${schedule.departureCity} →
                                                        ${schedule.destinationCity}
                                                    </div>
                                                    <div class="mb-2">
                                                        <i class="fas fa-chair me-2"></i>
                                                        <strong>Available Seats:</strong> ${schedule.availableSeats}
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-4 text-md-end">
                                            <div class="mb-3">
                                                <span class="badge bg-light text-dark fs-6 px-3 py-2">
                                                    <i class="fas fa-info-circle me-1"></i>Schedule ID:
                                                    ${schedule.scheduleId}
                                                </span>
                                            </div>
                                            <c:if test="${not empty schedule.driverName}">
                                                <div class="alert alert-warning mb-0">
                                                    <i class="fas fa-user me-2"></i>
                                                    <strong>Current Driver:</strong> ${schedule.driverName}
                                                </div>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </c:if>

                            <!-- Driver Selection Form -->
                            <div class="card">
                                <div class="card-header bg-primary text-white">
                                    <h5 class="mb-0">
                                        <i class="fas fa-users me-2"></i>Select Driver
                                    </h5>
                                </div>
                                <div class="card-body">
                                    <!-- Search Section -->
                                    <div class="search-section">
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="input-group">
                                                    <span class="input-group-text">
                                                        <i class="fas fa-search"></i>
                                                    </span>
                                                    <input type="text" class="form-control" id="driverSearch"
                                                        placeholder="Search drivers by name, license, or phone..."
                                                        onkeyup="filterDrivers()">
                                                </div>
                                            </div>
                                            <div class="col-md-3">
                                                <select class="form-select" id="experienceFilter"
                                                    onchange="filterDrivers()">
                                                    <option value="">All Experience Levels</option>
                                                    <option value="0-2">0-2 years</option>
                                                    <option value="3-5">3-5 years</option>
                                                    <option value="6-10">6-10 years</option>
                                                    <option value="10+">10+ years</option>
                                                </select>
                                            </div>
                                            <div class="col-md-3">
                                                <button type="button" class="btn btn-outline-secondary w-100"
                                                    onclick="clearFilters()">
                                                    <i class="fas fa-times me-1"></i>Clear Filters
                                                </button>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Drivers Grid -->
                                    <form id="assignDriverForm" method="post"
                                        action="${pageContext.request.contextPath}/admin/drivers/assign">
                                        <input type="hidden" name="scheduleId" value="${schedule.scheduleId}">
                                        <input type="hidden" name="driverId" id="selectedDriverId" required>

                                        <div class="row" id="driversContainer">
                                            <c:forEach var="driver" items="${drivers}">
                                                <div class="col-lg-4 col-md-6 mb-3 driver-item"
                                                    data-name="${driver.fullName}"
                                                    data-license="${driver.licenseNumber}"
                                                    data-phone="${driver.phoneNumber}"
                                                    data-experience="${driver.experienceYears}">
                                                    <div class="card driver-card h-100"
                                                        onclick="selectDriver('${driver.driverId}', this)">
                                                        <div class="card-header bg-info text-white">
                                                            <div
                                                                class="d-flex justify-content-between align-items-center">
                                                                <h6 class="mb-0">
                                                                    <i class="fas fa-user me-2"></i>${driver.fullName}
                                                                </h6>
                                                                <span class="badge experience-badge bg-light text-dark">
                                                                    ${driver.experienceYears} years
                                                                </span>
                                                            </div>
                                                        </div>
                                                        <div class="card-body">
                                                            <div class="mb-2">
                                                                <i class="fas fa-id-card me-2 text-muted"></i>
                                                                <strong>License:</strong> ${driver.licenseNumber}
                                                            </div>
                                                            <div class="mb-2">
                                                                <i class="fas fa-phone me-2 text-muted"></i>
                                                                <strong>Phone:</strong> ${driver.phoneNumber}
                                                            </div>
                                                            <div class="mb-2">
                                                                <i class="fas fa-envelope me-2 text-muted"></i>
                                                                <strong>Email:</strong> ${driver.email}
                                                            </div>
                                                            <div class="mb-2">
                                                                <i class="fas fa-user-tag me-2 text-muted"></i>
                                                                <strong>Username:</strong> ${driver.username}
                                                            </div>
                                                        </div>
                                                        <div class="card-footer bg-light text-center">
                                                            <div class="form-check">
                                                                <input class="form-check-input" type="radio"
                                                                    name="driverSelection" value="${driver.driverId}"
                                                                    id="driver_${driver.driverId}">
                                                                <label class="form-check-label"
                                                                    for="driver_${driver.driverId}">
                                                                    Select this driver
                                                                </label>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>

                                        <!-- No Results Message -->
                                        <div id="noResults" class="text-center py-5" style="display: none;">
                                            <i class="fas fa-user-times fa-3x text-muted mb-3"></i>
                                            <h4 class="text-muted">No drivers found</h4>
                                            <p class="text-muted">Try adjusting your search criteria</p>
                                        </div>

                                        <!-- Action Buttons -->
                                        <div class="d-flex justify-content-between mt-4">
                                            <a href="${pageContext.request.contextPath}/admin/schedules"
                                                class="btn btn-secondary">
                                                <i class="fas fa-times me-1"></i>Cancel
                                            </a>
                                            <button type="submit" class="btn btn-success" id="assignBtn" disabled>
                                                <i class="fas fa-user-plus me-1"></i>Assign Driver to Trip
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
                    function selectDriver(driverId, cardElement) {
                        // Remove selection from all cards
                        document.querySelectorAll('.driver-card').forEach(card => {
                            card.classList.remove('selected');
                        });

                        // Add selection to clicked card
                        cardElement.classList.add('selected');

                        // Set the selected driver ID
                        document.getElementById('selectedDriverId').value = driverId;

                        // Check the radio button
                        document.getElementById('driver_' + driverId).checked = true;

                        // Enable the assign button
                        document.getElementById('assignBtn').disabled = false;
                    }

                    function filterDrivers() {
                        const searchTerm = document.getElementById('driverSearch').value.toLowerCase();
                        const experienceFilter = document.getElementById('experienceFilter').value;

                        const driverItems = document.querySelectorAll('.driver-item');
                        let visibleCount = 0;

                        driverItems.forEach(item => {
                            const name = item.dataset.name.toLowerCase();
                            const license = item.dataset.license.toLowerCase();
                            const phone = item.dataset.phone.toLowerCase();
                            const experience = parseInt(item.dataset.experience);

                            const matchesSearch = name.includes(searchTerm) ||
                                license.includes(searchTerm) ||
                                phone.includes(searchTerm);

                            let matchesExperience = true;
                            if (experienceFilter) {
                                switch (experienceFilter) {
                                    case '0-2':
                                        matchesExperience = experience >= 0 && experience <= 2;
                                        break;
                                    case '3-5':
                                        matchesExperience = experience >= 3 && experience <= 5;
                                        break;
                                    case '6-10':
                                        matchesExperience = experience >= 6 && experience <= 10;
                                        break;
                                    case '10+':
                                        matchesExperience = experience > 10;
                                        break;
                                }
                            }

                            if (matchesSearch && matchesExperience) {
                                item.style.display = 'block';
                                visibleCount++;
                            } else {
                                item.style.display = 'none';
                            }
                        });

                        // Show/hide no results message
                        const noResults = document.getElementById('noResults');
                        if (visibleCount === 0) {
                            noResults.style.display = 'block';
                        } else {
                            noResults.style.display = 'none';
                        }
                    }

                    function clearFilters() {
                        document.getElementById('driverSearch').value = '';
                        document.getElementById('experienceFilter').value = '';
                        filterDrivers();
                    }

                    // Form validation
                    document.getElementById('assignDriverForm').addEventListener('submit', function (e) {
                        const selectedDriverId = document.getElementById('selectedDriverId').value;
                        if (!selectedDriverId) {
                            e.preventDefault();
                            alert('Please select a driver before assigning.');
                            return false;
                        }
                    });
                </script>
            </body>

            </html>