<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>My Trips - Driver Dashboard</title>
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

                .header-section {
                    background: linear-gradient(135deg, #66bb6a 0%, #81c784 100%);
                    border-radius: 15px;
                    padding: 2rem;
                    margin-bottom: 2rem;
                    color: white;
                }

                .filter-section {
                    background: rgba(255, 255, 255, 0.1);
                    border-radius: 10px;
                    padding: 1.5rem;
                    margin-top: 1rem;
                }

                .table-container {
                    background: white;
                    border-radius: 10px;
                    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                    overflow: hidden;
                }

                .status-badge {
                    font-size: 0.85em;
                    padding: 0.4em 0.8em;
                }

                .btn-action {
                    margin: 0 2px;
                }

                .table-responsive {
                    border-radius: 10px;
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
                                        <i class="fas fa-route me-2"></i>My Assigned Trips
                                    </h2>
                                    <p class="mb-0 mt-2">View and manage your assigned trips</p>
                                </div>
                                <div class="col-md-4 text-md-end">
                                    <span class="badge bg-light text-dark fs-6">
                                        <i class="fas fa-user me-1"></i>Driver: ${driver.fullName}
                                    </span>
                                </div>
                            </div>

                            <!-- Filter Section -->
                            <div class="filter-section">
                                <div class="row">
                                    <div class="col-md-4">
                                        <div class="input-group">
                                            <span class="input-group-text bg-white border-0">
                                                <i class="fas fa-search text-muted"></i>
                                            </span>
                                            <input type="text" class="form-control border-0" id="searchInput"
                                                placeholder="Search trips..." onkeyup="filterTrips()">
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <select class="form-select border-0" id="statusFilter" onchange="filterTrips()">
                                            <option value="">All Status</option>
                                            <option value="SCHEDULED">Scheduled</option>
                                            <option value="DEPARTED">Departed</option>
                                            <option value="ARRIVED">Arrived</option>
                                            <option value="CANCELLED">Cancelled</option>
                                        </select>
                                    </div>
                                    <div class="col-md-3">
                                        <input type="date" class="form-control border-0" id="dateFilter"
                                            onchange="filterTrips()">
                                    </div>
                                    <div class="col-md-2">
                                        <button class="btn btn-outline-light w-100" onclick="clearFilters()">
                                            <i class="fas fa-times me-1"></i>Clear
                                        </button>
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

                        <!-- Trips Table -->
                        <div class="table-container">
                            <div class="table-responsive">
                                <table class="table table-hover mb-0" id="tripsTable">
                                    <thead class="table-dark">
                                        <tr>
                                            <th><i class="fas fa-route me-1"></i>Route</th>
                                            <th><i class="fas fa-calendar me-1"></i>Departure Date</th>
                                            <th><i class="fas fa-clock me-1"></i>Departure Time</th>
                                            <th><i class="fas fa-clock me-1"></i>Arrival Time</th>
                                            <th><i class="fas fa-bus me-1"></i>Bus Number</th>
                                            <th><i class="fas fa-chair me-1"></i>Available Seats</th>
                                            <th><i class="fas fa-info-circle me-1"></i>Status</th>
                                            <th><i class="fas fa-cog me-1"></i>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${not empty trips}">
                                                <c:forEach var="trip" items="${trips}">
                                                    <tr class="trip-item" data-status="${trip.status}"
                                                        data-date="${trip.departureDate}"
                                                        data-route="${trip.routeName}">
                                                        <td>
                                                            <strong>${trip.routeName}</strong><br>
                                                            <small class="text-muted">
                                                                <i class="fas fa-map-marker-alt me-1"></i>
                                                                ${trip.departureCity} → ${trip.destinationCity}
                                                            </small>
                                                        </td>
                                                        <td>${trip.departureDate}</td>
                                                        <td>
                                                            <i class="fas fa-clock text-primary me-1"></i>
                                                            ${trip.departureTime}
                                                        </td>
                                                        <td>
                                                            <i class="fas fa-clock text-success me-1"></i>
                                                            ${trip.estimatedArrivalTime}
                                                        </td>
                                                        <td>
                                                            <span class="badge bg-secondary">
                                                                <i class="fas fa-bus me-1"></i>${trip.busNumber}
                                                            </span>
                                                        </td>
                                                        <td>
                                                            <span class="badge bg-info">
                                                                <i class="fas fa-chair me-1"></i>${trip.availableSeats}
                                                            </span>
                                                        </td>
                                                        <td>
                                                            <span class="badge status-badge 
                                                                <c:choose>
                                                                    <c:when test=" ${trip.status=='SCHEDULED'
                                                                }">bg-success
                                            </c:when>
                                            <c:when test="${trip.status == 'DEPARTED'}">bg-warning text-dark</c:when>
                                            <c:when test="${trip.status == 'ARRIVED'}">bg-info</c:when>
                                            <c:when test="${trip.status == 'CANCELLED'}">bg-danger</c:when>
                                            <c:otherwise>bg-secondary</c:otherwise>
                                        </c:choose>">
                                        ${trip.status}
                                        </span>
                                        </td>
                                        <td>
                                            <div class="btn-group" role="group">
                                                <a href="${pageContext.request.contextPath}/driver/check-in?scheduleId=${trip.scheduleId}"
                                                    class="btn btn-sm btn-info btn-action" title="View Passengers"
                                                    data-schedule-id="${trip.scheduleId}" data-route="${trip.routeName}"
                                                    data-direction="${trip.departureCity} → ${trip.destinationCity}"
                                                    data-departure="${trip.departureDate}"
                                                    data-departure-time="${trip.departureTime}"
                                                    data-arrival="${trip.estimatedArrivalTime}"
                                                    data-bus="${trip.busNumber}">
                                                    <i class="fas fa-users"></i>
                                                </a>
                                                <!-- New: direct Check-in page link -->
                                                <a href="${pageContext.request.contextPath}/driver/check-in?scheduleId=${trip.scheduleId}"
                                                    class="btn btn-sm btn-success btn-action" title="Go to Check-in">
                                                    <i class="fas fa-user-check"></i>
                                                </a>
                                                <a href="${pageContext.request.contextPath}/driver/update-status?scheduleId=${trip.scheduleId}"
                                                    class="btn btn-sm btn-warning btn-action" title="Update Status">
                                                    <i class="fas fa-edit"></i>
                                                </a>
                                            </div>
                                        </td>
                                        </tr>
                                        </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="8" class="text-center py-5">
                                                    <i class="fas fa-route fa-3x text-muted mb-3"></i>
                                                    <h4 class="text-muted">No trips assigned</h4>
                                                    <p class="text-muted">You don't have any assigned trips yet</p>
                                                </td>
                                            </tr>
                                        </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <!-- No Results Message -->
                        <div id="noResults" class="text-center py-5" style="display: none;">
                            <i class="fas fa-route fa-3x text-muted mb-3"></i>
                            <h4 class="text-muted">No trips found</h4>
                            <p class="text-muted">Try adjusting your filters</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- View Passengers Modal -->
            <div class="modal fade" id="tripDetailsModal" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog modal-lg modal-dialog-scrollable">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="tripDetailsTitle">View Passengers</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <div id="tripDetailsLoading" class="text-center py-4">
                                <div class="spinner-border text-primary" role="status">
                                    <span class="visually-hidden">Loading...</span>
                                </div>
                                <p class="mt-3 mb-0 text-muted">Loading passenger details...</p>
                            </div>

                            <div id="tripDetailsError" class="alert alert-danger d-none" role="alert"></div>

                            <div id="tripDetailsEmpty" class="text-center py-4 d-none">
                                <i class="fas fa-users fa-2x text-muted mb-3"></i>
                                <p class="mb-0 text-muted">No passengers have booked this trip yet.</p>
                            </div>

                            <div id="tripDetailsTable" class="table-responsive d-none">
                                <table class="table table-striped align-middle mb-0">
                                    <thead class="table-light">
                                        <tr>
                                            <th>Check-in</th>
                                            <th>#</th>
                                            <th>Passenger</th>
                                            <th>Seat</th>
                                            <th>Boarding</th>
                                            <th>Drop-off</th>
                                        </tr>
                                    </thead>
                                    <tbody id="tripDetailsBody"></tbody>
                                </table>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        </div>
                    </div>
                </div>
            </div>

            <%@ include file="/views/partials/footer.jsp" %>
                <script>
                    const contextPath = '${pageContext.request.contextPath}';
                    let tripDetailsModal;
                    let currentScheduleId = null;

                    document.addEventListener('DOMContentLoaded', function () {
                        const modalElement = document.getElementById('tripDetailsModal');
                        if (modalElement) {
                            tripDetailsModal = new bootstrap.Modal(modalElement);
                            modalElement.addEventListener('hidden.bs.modal', resetTripDetailsModal);
                        }
                    });

                    function resetTripDetailsModal() {
                        document.getElementById('tripDetailsLoading').classList.remove('d-none');
                        document.getElementById('tripDetailsError').classList.add('d-none');
                        document.getElementById('tripDetailsEmpty').classList.add('d-none');
                        document.getElementById('tripDetailsTable').classList.add('d-none');
                        document.getElementById('tripDetailsBody').innerHTML = '';
                        currentScheduleId = null;
                    }

                    async function showTripDetails(button) {
                        if (!tripDetailsModal) {
                            return;
                        }

                        resetTripDetailsModal();

                        const scheduleId = button.getAttribute('data-schedule-id');
                        const routeName = button.getAttribute('data-route') || '';
                        currentScheduleId = scheduleId;

                        // Set modal title - show route name if available
                        if (routeName) {
                            document.getElementById('tripDetailsTitle').textContent = 'View Passengers - ' + routeName;
                        } else {
                            document.getElementById('tripDetailsTitle').textContent = 'View Passengers';
                        }

                        tripDetailsModal.show();

                        if (!scheduleId) {
                            showTripDetailsError('Missing schedule information.');
                            document.getElementById('tripDetailsLoading').classList.add('d-none');
                            return;
                        }

                        try {
                            const response = await fetch(contextPath + '/driver/trip-details?scheduleId=' + encodeURIComponent(scheduleId), {
                                headers: {
                                    'Accept': 'application/json'
                                }
                            });

                            if (!response.ok) {
                                throw new Error('Failed to load passenger details.');
                            }

                            const data = await response.json();
                            if (data.success && Array.isArray(data.passengers) && data.passengers.length > 0) {
                                populateTripDetailsTable(data.passengers);
                            } else {
                                showTripDetailsEmpty();
                            }
                        } catch (error) {
                            showTripDetailsError(error.message || 'Unable to load passenger details.');
                        } finally {
                            document.getElementById('tripDetailsLoading').classList.add('d-none');
                        }
                    }

                    function buildStatusBadge(passenger) {
                        const badge = document.createElement('span');
                        if (passenger.checkedIn) {
                            badge.className = 'badge bg-success';
                            badge.textContent = 'Checked-in';
                        } else if (passenger.paymentStatus === 'PAID' && passenger.canCheckIn) {
                            // Ticket is paid and ready for check-in
                            badge.className = 'badge bg-info text-white';
                            badge.textContent = 'Paid';
                        } else if (passenger.paymentStatus === 'PENDING') {
                            // Ticket payment is pending - cannot check-in
                            badge.className = 'badge bg-warning text-dark';
                            badge.textContent = 'Pending';
                        } else {
                            badge.className = 'badge bg-secondary';
                            badge.textContent = 'Unavailable';
                        }
                        return badge;
                    }

                    function populateTripDetailsTable(passengers) {
                        const tableContainer = document.getElementById('tripDetailsTable');
                        const tbody = document.getElementById('tripDetailsBody');

                        passengers.forEach((passenger, index) => {
                            const row = document.createElement('tr');
                            if (passenger.checkedIn) {
                                row.classList.add('table-success');
                            }

                            const checkCell = document.createElement('td');
                            const checkWrapper = document.createElement('div');
                            checkWrapper.className = 'form-check';
                            const checkbox = document.createElement('input');
                            checkbox.type = 'checkbox';
                            checkbox.className = 'form-check-input';
                            checkbox.title = 'Tick to check-in';
                            checkbox.dataset.ticketId = passenger.ticketId || '';
                            checkbox.checked = !!passenger.checkedIn;
                            checkbox.disabled = !passenger.canCheckIn || checkbox.checked || !checkbox.dataset.ticketId;
                            const statusBadge = buildStatusBadge(passenger);
                            statusBadge.classList.add('mt-1', 'd-inline-block');
                            checkWrapper.appendChild(checkbox);
                            checkWrapper.appendChild(statusBadge);
                            checkCell.appendChild(checkWrapper);
                            row.appendChild(checkCell);

                            const indexCell = document.createElement('td');
                            indexCell.textContent = index + 1;
                            row.appendChild(indexCell);

                            const passengerCell = document.createElement('td');
                            const nameStrong = document.createElement('strong');
                            nameStrong.textContent = passenger.fullName || 'Unknown passenger';
                            passengerCell.appendChild(nameStrong);

                            if (passenger.phone) {
                                const phoneLine = document.createElement('div');
                                phoneLine.className = 'text-muted small';
                                phoneLine.innerHTML = '<i class="fas fa-phone me-1"></i>' + passenger.phone;
                                passengerCell.appendChild(phoneLine);
                            }

                            if (passenger.ticketNumber) {
                                const ticketLine = document.createElement('div');
                                ticketLine.className = 'text-muted small';
                                ticketLine.textContent = 'Ticket ' + passenger.ticketNumber;
                                passengerCell.appendChild(ticketLine);
                            }

                            row.appendChild(passengerCell);

                            const seatCell = document.createElement('td');
                            const seatBadge = document.createElement('span');
                            seatBadge.className = 'badge bg-primary';
                            seatBadge.textContent = passenger.seatNumber != null ? passenger.seatNumber : 'N/A';
                            seatCell.appendChild(seatBadge);
                            row.appendChild(seatCell);

                            const boardingCell = document.createElement('td');
                            fillStationCell(boardingCell, passenger.boardingStation, passenger.boardingCity);
                            row.appendChild(boardingCell);

                            const alightingCell = document.createElement('td');
                            fillStationCell(alightingCell, passenger.alightingStation, passenger.alightingCity);
                            row.appendChild(alightingCell);

                            if (!checkbox.disabled) {
                                checkbox.addEventListener('change', function () {
                                    handleCheckInToggle(checkbox, statusBadge, row);
                                });
                            }

                            tbody.appendChild(row);
                        });

                        tableContainer.classList.remove('d-none');
                    }

                    function fillStationCell(cell, stationName, city) {
                        cell.innerHTML = '';
                        if (stationName) {
                            const nameEl = document.createElement('strong');
                            nameEl.textContent = stationName;
                            cell.appendChild(nameEl);
                        }
                        if (city) {
                            const cityEl = document.createElement('div');
                            cityEl.className = 'text-muted small';
                            cityEl.textContent = city;
                            cell.appendChild(cityEl);
                        }
                        if (!stationName && !city) {
                            const placeholder = document.createElement('span');
                            placeholder.className = 'text-muted';
                            placeholder.textContent = 'Not set';
                            cell.appendChild(placeholder);
                        }
                    }

                    async function handleCheckInToggle(checkbox, statusBadge, rowElement) {
                        if (!checkbox.dataset.ticketId) {
                            checkbox.checked = false;
                            return;
                        }

                        checkbox.disabled = true;
                        try {
                            const body = new URLSearchParams();
                            body.append('ticketId', checkbox.dataset.ticketId);
                            if (currentScheduleId) {
                                body.append('scheduleId', currentScheduleId);
                            }

                            const response = await fetch(contextPath + '/driver/check-in-ajax', {
                                method: 'POST',
                                headers: {
                                    'Content-Type': 'application/x-www-form-urlencoded',
                                    'Accept': 'application/json'
                                },
                                body: body.toString()
                            });

                            const data = await response.json();
                            if (!response.ok || !data.success) {
                                throw new Error(data.message || 'Failed to check in passenger.');
                            }

                            checkbox.checked = true;
                            const badge = buildStatusBadge({ checkedIn: true });
                            statusBadge.replaceWith(badge);
                            if (rowElement) {
                                rowElement.classList.add('table-success');
                            }
                        } catch (error) {
                            checkbox.checked = false;
                            checkbox.disabled = false;
                            alert(error.message || 'Unable to check in passenger.');
                        }
                    }

                    function showTripDetailsError(message) {
                        const errorAlert = document.getElementById('tripDetailsError');
                        errorAlert.textContent = message;
                        errorAlert.classList.remove('d-none');
                    }

                    function showTripDetailsEmpty() {
                        document.getElementById('tripDetailsEmpty').classList.remove('d-none');
                    }

                    function filterTrips() {
                        const searchTerm = document.getElementById('searchInput').value.trim().toLowerCase();
                        const statusFilter = document.getElementById('statusFilter').value;
                        const dateFilter = document.getElementById('dateFilter').value;

                        const tripItems = document.querySelectorAll('.trip-item');
                        let visibleCount = 0;

                        tripItems.forEach(item => {
                            const route = item.dataset.route ? item.dataset.route.toLowerCase() : '';
                            const status = item.dataset.status;
                            const date = item.dataset.date;

                            const matchesSearch = route.includes(searchTerm);
                            const matchesStatus = !statusFilter || status === statusFilter;
                            const matchesDate = !dateFilter || date === dateFilter;

                            if (matchesSearch && matchesStatus && matchesDate) {
                                item.style.display = '';
                                visibleCount++;
                            } else {
                                item.style.display = 'none';
                            }
                        });

                        const noResults = document.getElementById('noResults');
                        const tableBody = document.querySelector('#tripsTable tbody');
                        if (visibleCount === 0 && tripItems.length > 0) {
                            noResults.style.display = 'block';
                            tableBody.style.display = 'none';
                        } else {
                            noResults.style.display = 'none';
                            tableBody.style.display = '';
                        }
                    }

                    function clearFilters() {
                        document.getElementById('searchInput').value = '';
                        document.getElementById('statusFilter').value = '';
                        document.getElementById('dateFilter').value = '';
                        filterTrips();
                    }
                </script>
        </body>

        </html>