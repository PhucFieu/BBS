<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Schedule Management - Admin Dashboard</title>
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

                    .status-badge {
                        font-size: 0.85em;
                        padding: 0.4em 0.8em;
                    }

                    .search-container {
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

                    #schedulesTable {
                        margin-bottom: 0;
                    }

                    #schedulesTable tbody tr:hover {
                        background-color: #f8f9fa;
                    }

                    #schedulesTable th {
                        font-weight: 600;
                        text-transform: uppercase;
                        font-size: 0.85em;
                        letter-spacing: 0.5px;
                        border-bottom: 2px solid #dee2e6;
                    }

                    .btn-group .btn {
                        border-radius: 0;
                    }

                    .btn-group .btn:first-child {
                        border-top-left-radius: 0.25rem;
                        border-bottom-left-radius: 0.25rem;
                    }

                    .btn-group .btn:last-child {
                        border-top-right-radius: 0.25rem;
                        border-bottom-right-radius: 0.25rem;
                    }
                </style>
            </head>

            <body>
                <jsp:include page="../partials/admin-header.jsp" />

                <div class="container-fluid py-4">
                    <div class="row">
                        <div class="col-12">
                            <!-- Header Section -->
                            <div class="search-container">
                                <div class="row align-items-center">
                                    <div class="col-md-6">
                                        <h2 class="mb-0">
                                            <i class="fas fa-calendar-alt me-2"></i>Schedule Management
                                        </h2>
                                        <p class="mb-0 mt-2">Manage bus schedules and routes</p>
                                    </div>
                                    <div class="col-md-6 text-md-end">
                                        <a href="${pageContext.request.contextPath}/admin/schedules/add"
                                            class="btn btn-light btn-lg">
                                            <i class="fas fa-plus me-2"></i>Add New Schedule
                                        </a>
                                    </div>
                                </div>

                                <!-- Search and Filter Section -->
                                <div class="filter-section">
                                    <div class="row">
                                        <div class="col-md-4">
                                            <div class="input-group">
                                                <span class="input-group-text bg-white border-0">
                                                    <i class="fas fa-search text-muted"></i>
                                                </span>
                                                <input type="text" class="form-control border-0" id="searchInput"
                                                    placeholder="Search schedules..." onkeyup="filterSchedules()">
                                            </div>
                                        </div>
                                        <div class="col-md-3">
                                            <select class="form-select border-0" id="statusFilter"
                                                onchange="filterSchedules()">
                                                <option value="">All Status</option>
                                                <option value="SCHEDULED">Scheduled</option>
                                                <option value="DEPARTED">Departed</option>
                                                <option value="ARRIVED">Arrived</option>
                                                <option value="CANCELLED">Cancelled</option>
                                            </select>
                                        </div>
                                        <div class="col-md-3">
                                            <input type="date" class="form-control border-0" id="dateFilter"
                                                onchange="filterSchedules()">
                                        </div>
                                        <div class="col-md-2">
                                            <button class="btn btn-outline-light w-100" onclick="clearFilters()">
                                                <i class="fas fa-times me-1"></i>Clear
                                            </button>
                                        </div>
                                    </div>
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

                            <!-- Schedules Table -->
                            <c:choose>
                                <c:when test="${empty schedules}">
                                    <div class="text-center py-5">
                                        <i class="fas fa-calendar-times fa-3x text-muted mb-3"></i>
                                        <h4 class="text-muted">No schedules found</h4>
                                        <p class="text-muted">Click "Add New Schedule" to create your first schedule</p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="card shadow-sm">
                                        <div class="card-body">
                                            <div class="table-responsive">
                                                <table class="table table-hover align-middle" id="schedulesTable">
                                                    <thead class="table-light">
                                                        <tr>
                                                            <th>Route</th>
                                                            <th>Departure</th>
                                                            <th>Arrival</th>
                                                            <th>Bus</th>
                                                            <th>Driver</th>
                                                            <th>Available Seats</th>
                                                            <th>Status</th>
                                                            <th>Actions</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody id="schedulesContainer">
                                                        <c:forEach var="schedule" items="${schedules}">
                                                            <tr class="schedule-item" data-status="${schedule.status}"
                                                                data-date="${schedule.departureDate}"
                                                                data-route="${schedule.routeName}"
                                                                data-bus="${schedule.busNumber}">
                                                                <td>
                                                                    <div class="fw-bold">
                                                                        <i class="fas fa-route me-1 text-primary"></i>
                                                                        ${schedule.routeName}
                                                                    </div>
                                                                    <small class="text-muted">
                                                                        ${schedule.departureCity} →
                                                                        ${schedule.destinationCity}
                                                                    </small>
                                                                </td>
                                                                <td>
                                                                    <div class="fw-bold">${schedule.departureDate}</div>
                                                                    <small class="text-primary">
                                                                        <i
                                                                            class="fas fa-clock me-1"></i>${schedule.departureTime}
                                                                    </small>
                                                                </td>
                                                                <td>
                                                                    <div class="fw-bold text-success">
                                                                        <i
                                                                            class="fas fa-clock me-1"></i>${schedule.estimatedArrivalTime}
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div class="fw-bold">
                                                                        <i
                                                                            class="fas fa-bus me-1"></i>${schedule.busNumber}
                                                                    </div>
                                                                    <small class="text-muted">
                                                                        <i
                                                                            class="fas fa-tag me-1"></i>${schedule.busType}
                                                                    </small>
                                                                    <div class="mt-1">
                                                                        <small class="badge bg-secondary">
                                                                            <i
                                                                                class="fas fa-id-card me-1"></i>${schedule.licensePlate}
                                                                        </small>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <c:choose>
                                                                        <c:when test="${not empty schedule.driverName}">
                                                                            <span class="text-success">
                                                                                <i
                                                                                    class="fas fa-user me-1"></i>${schedule.driverName}
                                                                            </span>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span class="text-muted">
                                                                                <i
                                                                                    class="fas fa-user-slash me-1"></i>Not
                                                                                assigned
                                                                            </span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                                <td>
                                                                    <span class="badge bg-info">
                                                                        <i
                                                                            class="fas fa-chair me-1"></i>${schedule.availableSeats}
                                                                    </span>
                                                                </td>
                                                                <td>
                                                                    <span class="badge status-badge 
                                                                        <c:choose>
                                                                            <c:when test="
                                                                        ${schedule.status=='SCHEDULED' }">bg-success
                                                                        </c:when>
                                                                        <c:when test="${schedule.status == 'DEPARTED'}">
                                                                            bg-warning</c:when>
                                                                        <c:when test="${schedule.status == 'ARRIVED'}">
                                                                            bg-info</c:when>
                                                                        <c:when
                                                                            test="${schedule.status == 'CANCELLED'}">
                                                                            bg-danger</c:when>
                                                                        <c:otherwise>bg-secondary</c:otherwise>
                            </c:choose>">
                            ${schedule.status}
                            </span>
                            </td>
                            <td>
                                <div class="btn-group" role="group">
                                    <a href="${pageContext.request.contextPath}/admin/schedules/edit?id=${schedule.scheduleId}"
                                        class="btn btn-outline-primary btn-sm" title="Edit">
                                        <i class="fas fa-edit"></i>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/admin/schedules/replace-bus?id=${schedule.scheduleId}"
                                        class="btn btn-outline-warning btn-sm" title="Replace Bus">
                                        <i class="fas fa-exchange-alt"></i>
                                    </a>
                                    <c:choose>
                                        <c:when test="${empty schedule.driverName}">
                                            <a href="${pageContext.request.contextPath}/admin/drivers/assign?scheduleId=${schedule.scheduleId}"
                                                class="btn btn-outline-success btn-sm" title="Assign Driver">
                                                <i class="fas fa-user-plus"></i>
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="${pageContext.request.contextPath}/admin/drivers/assign?scheduleId=${schedule.scheduleId}"
                                                class="btn btn-outline-success btn-sm" title="Change Driver">
                                                <i class="fas fa-user-edit"></i>
                                            </a>
                                        </c:otherwise>
                                    </c:choose>
                                    <button type="button" class="btn btn-outline-danger btn-sm"
                                        data-routename="${schedule.routeName}"
                                        onclick="confirmDelete('${schedule.scheduleId}', this)" title="Delete">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                </div>
                            </td>
                            </tr>
                            </c:forEach>
                            </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                </c:otherwise>
                </c:choose>

                <!-- No Results Message -->
                <div id="noResults" class="text-center py-5" style="display: none;">
                    <i class="fas fa-calendar-times fa-3x text-muted mb-3"></i>
                    <h4 class="text-muted">No schedules found</h4>
                    <p class="text-muted">Try adjusting your search criteria</p>
                </div>
                </div>
                </div>
                </div>

                <!-- Delete Confirmation Modal -->
                <div class="modal fade" id="deleteModal" tabindex="-1" aria-labelledby="deleteModalLabel"
                    aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered">
                        <div class="modal-content">
                            <div class="modal-header bg-danger text-white">
                                <h5 class="modal-title" id="deleteModalLabel">
                                    <i class="fas fa-exclamation-triangle me-2"></i>Confirm Delete
                                </h5>
                                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"
                                    aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <div class="text-center mb-3">
                                    <i class="fas fa-calendar-times fa-3x text-danger mb-3"></i>
                                </div>
                                <p class="text-center mb-3">Are you sure you want to delete schedule <strong
                                        id="scheduleNameToDelete" class="text-danger"></strong>?</p>
                                <div class="alert alert-warning" role="alert">
                                    <i class="fas fa-exclamation-triangle me-2"></i>
                                    <strong>Warning:</strong> This action cannot be undone. The schedule will be
                                    permanently removed from the system.
                                </div>
                                <div class="alert alert-info" role="alert">
                                    <i class="fas fa-info-circle me-2"></i>
                                    <strong>Note:</strong> If this schedule has active bookings, the deletion will be
                                    prevented.
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                                    <i class="fas fa-times me-1"></i>Cancel
                                </button>
                                <button type="button" id="confirmDeleteBtn" class="btn btn-danger">
                                    <i class="fas fa-trash me-1"></i>Delete Schedule
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Delete Blocked Modal -->
                <div class="modal fade" id="deleteBlockedModal" tabindex="-1" aria-labelledby="deleteBlockedModalLabel"
                    aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered">
                        <div class="modal-content">
                            <div class="modal-header bg-warning text-white">
                                <h5 class="modal-title" id="deleteBlockedModalLabel">
                                    <i class="fas fa-ban me-2"></i>Cannot Delete Schedule
                                </h5>
                                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"
                                    aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <div class="text-center mb-3">
                                    <i class="fas fa-ticket-alt fa-3x text-warning mb-3"></i>
                                </div>
                                <p class="text-center mb-2 fw-semibold" id="deleteBlockedMessage">
                                    Schedule has booked tickets. Please cancel or refund tickets before deleting.
                                </p>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                                    <i class="fas fa-times me-1"></i>Close
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <%@ include file="/views/partials/footer.jsp" %>
                    <script>
                        // Auto-hide alerts after 5 seconds
                        document.addEventListener('DOMContentLoaded', function () {
                            const alerts = document.querySelectorAll('.alert');
                            alerts.forEach(function (alert) {
                                setTimeout(function () {
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
                        let currentScheduleId = null;
                        let currentScheduleName = null;

                        function confirmDelete(scheduleId, el) {
                            // Support calling with (scheduleId, scheduleName) for backward-compatibility
                            let scheduleName = '';
                            if (el && typeof el.getAttribute === 'function') {
                                scheduleName = el.getAttribute('data-routename') || '';
                            } else if (typeof el === 'string') {
                                scheduleName = el;
                            }

                            console.log('Preparing to delete schedule:', scheduleId, scheduleName);

                            // Store current schedule info
                            currentScheduleId = scheduleId;
                            currentScheduleName = scheduleName;

                            // Set the schedule name in the modal
                            const scheduleNameElement = document.getElementById('scheduleNameToDelete');
                            if (scheduleNameElement) {
                                scheduleNameElement.textContent = scheduleName;
                            }

                            // Show the modal
                            const deleteModalElement = document.getElementById('deleteModal');
                            if (deleteModalElement) {
                                const deleteModal = new bootstrap.Modal(deleteModalElement);
                                deleteModal.show();
                            }
                        }

                        function performDelete() {
                            if (!currentScheduleId) {
                                console.error('No schedule ID available for deletion');
                                return;
                            }

                            console.log('Performing delete for schedule:', currentScheduleId);

                            // Show loading state
                            const confirmBtn = document.getElementById('confirmDeleteBtn');
                            const originalText = confirmBtn.innerHTML;
                            confirmBtn.disabled = true;
                            confirmBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Deleting...';

                            // Create form and submit
                            const form = document.createElement('form');
                            form.method = 'GET';
                            form.action = '${pageContext.request.contextPath}/admin/schedules/delete';

                            const idInput = document.createElement('input');
                            idInput.type = 'hidden';
                            idInput.name = 'id';
                            idInput.value = currentScheduleId;

                            form.appendChild(idInput);
                            document.body.appendChild(form);
                            form.submit();
                        }

                        // Add event listener for confirm delete button
                        document.addEventListener('DOMContentLoaded', function () {
                            const confirmDeleteBtn = document.getElementById('confirmDeleteBtn');
                            if (confirmDeleteBtn) {
                                confirmDeleteBtn.addEventListener('click', function (e) {
                                    e.preventDefault();
                                    performDelete();
                                });
                            }

                            // Show popup when deletion is blocked due to existing tickets
                            const urlParams = new URLSearchParams(window.location.search);
                            const errorParam = urlParams.get('error');
                            if (errorParam && errorParam.toLowerCase().includes('cannot delete schedule')) {
                                const msgEl = document.getElementById('deleteBlockedMessage');
                                if (msgEl) {
                                    msgEl.textContent = errorParam;
                                }
                                const modalEl = document.getElementById('deleteBlockedModal');
                                if (modalEl) {
                                    const blockedModal = new bootstrap.Modal(modalEl);
                                    blockedModal.show();
                                    window.scrollTo({ top: 0, behavior: 'smooth' });
                                }
                            }
                        });

                        function filterSchedules() {
                            const searchTerm = document.getElementById('searchInput').value.trim().toLowerCase();
                            const statusFilter = document.getElementById('statusFilter').value;
                            const dateFilter = document.getElementById('dateFilter').value;

                            const scheduleItems = document.querySelectorAll('.schedule-item');
                            const schedulesTable = document.getElementById('schedulesTable');
                            let visibleCount = 0;

                            scheduleItems.forEach(item => {
                                const route = item.dataset.route.toLowerCase();
                                const bus = item.dataset.bus.toLowerCase();
                                const status = item.dataset.status;
                                const date = item.dataset.date;

                                const matchesSearch = route.includes(searchTerm) || bus.includes(searchTerm);
                                const matchesStatus = !statusFilter || status === statusFilter;
                                const matchesDate = !dateFilter || date === dateFilter;

                                if (matchesSearch && matchesStatus && matchesDate) {
                                    item.style.display = '';
                                    visibleCount++;
                                } else {
                                    item.style.display = 'none';
                                }
                            });

                            // Show/hide no results message and table
                            const noResults = document.getElementById('noResults');
                            if (visibleCount === 0) {
                                if (schedulesTable) {
                                    schedulesTable.closest('.card').style.display = 'none';
                                }
                                noResults.style.display = 'block';
                            } else {
                                if (schedulesTable) {
                                    schedulesTable.closest('.card').style.display = 'block';
                                }
                                noResults.style.display = 'none';
                            }
                        }

                        function clearFilters() {
                            document.getElementById('searchInput').value = '';
                            document.getElementById('statusFilter').value = '';
                            document.getElementById('dateFilter').value = '';
                            filterSchedules();
                        }

                    </script>
            </body>

            </html>

            </html>