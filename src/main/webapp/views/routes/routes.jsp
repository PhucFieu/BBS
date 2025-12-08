<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Route Management - Admin Dashboard</title>
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

                    html,
                    body {
                        height: 100%;
                    }

                    body {
                        font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
                        line-height: 1.6;
                        color: var(--gray-800);
                        background-color: #f1f8f4;
                        min-height: 100vh;
                        display: flex;
                        flex-direction: column;
                    }

                    /* ===== NAVBAR STYLES ===== */
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
                        animation: dropdownFadeIn 0.2s ease-in-out;
                    }

                    @keyframes dropdownFadeIn {
                        from {
                            opacity: 0;
                            transform: translateY(-10px);
                        }

                        to {
                            opacity: 1;
                            transform: translateY(0);
                        }
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

                    /* ===== FOOTER STYLES ===== */
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

                    /* ===== SCROLLBAR STYLING ===== */
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

                    /* ===== ANIMATIONS ===== */
                    @keyframes fadeInUp {
                        from {
                            opacity: 0;
                            transform: translateY(30px);
                        }

                        to {
                            opacity: 1;
                            transform: translateY(0);
                        }
                    }

                    .fade-in-up {
                        animation: fadeInUp 0.6s ease-out;
                    }

                    /* ===== RESPONSIVE DESIGN ===== */
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

                    #routesTable {
                        margin-bottom: 0;
                    }

                    #routesTable tbody tr:hover {
                        background-color: #f8f9fa;
                    }

                    #routesTable th {
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
                                            <i class="fas fa-route me-2"></i>Route Management
                                        </h2>
                                        <p class="mb-0 mt-2">Manage bus routes and pricing</p>
                                    </div>
                                    <div class="col-md-6 text-md-end">
                                        <a href="${pageContext.request.contextPath}/routes/add"
                                            class="btn btn-light btn-lg">
                                            <i class="fas fa-plus me-2"></i>Add New Route
                                        </a>
                                    </div>
                                </div>

                                <!-- Search and Filter Section -->
                                <div class="filter-section">
                                    <form action="${pageContext.request.contextPath}/routes/search" method="get">
                                        <div class="row">
                                            <div class="col-md-4">
                                                <div class="input-group">
                                                    <span class="input-group-text bg-white border-0">
                                                        <i class="fas fa-map-marker-alt text-muted"></i>
                                                    </span>
                                                    <input type="text" class="form-control border-0" id="departureCity"
                                                        name="departureCity" value="${departureCity}"
                                                        placeholder="Departure city...">
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <div class="input-group">
                                                    <span class="input-group-text bg-white border-0">
                                                        <i class="fas fa-map-marker-alt text-muted"></i>
                                                    </span>
                                                    <input type="text" class="form-control border-0"
                                                        id="destinationCity" name="destinationCity"
                                                        value="${destinationCity}" placeholder="Destination city...">
                                                </div>
                                            </div>
                                            <div class="col-md-2">
                                                <button type="submit" class="btn btn-outline-light w-100">
                                                    <i class="fas fa-search me-1"></i>Search
                                                </button>
                                            </div>
                                            <div class="col-md-2">
                                                <a href="${pageContext.request.contextPath}/routes"
                                                    class="btn btn-outline-light w-100">
                                                    <i class="fas fa-times me-1"></i>Clear
                                                </a>
                                            </div>
                                        </div>
                                    </form>
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

                            <!-- Routes Table -->
                            <c:choose>
                                <c:when test="${empty routes}">
                                    <div class="text-center py-5">
                                        <i class="fas fa-route fa-3x text-muted mb-3"></i>
                                        <h4 class="text-muted">No routes found</h4>
                                        <p class="text-muted">Click "Add New Route" to create your first route</p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="card shadow-sm">
                                        <div class="card-body">
                                            <div class="table-responsive">
                                                <table class="table table-hover align-middle" id="routesTable">
                                                    <thead class="table-light">
                                                        <tr>
                                                            <th>Route</th>
                                                            <th>From</th>
                                                            <th>To</th>
                                                            <th>Distance</th>
                                                            <th>Duration</th>
                                                            <th>Price</th>
                                                            <th>Status</th>
                                                            <th>Actions</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody id="routesContainer">
                                                        <c:forEach var="route" items="${routes}">
                                                            <tr class="route-item">
                                                                <td>
                                                                    <div class="fw-bold">
                                                                        <i class="fas fa-route me-1 text-primary"></i>
                                                                        ${route.routeName}
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <span class="badge bg-info">
                                                                        <i
                                                                            class="fas fa-map-marker-alt me-1"></i>${route.departureCity}
                                                                    </span>
                                                                </td>
                                                                <td>
                                                                    <span class="badge bg-success">
                                                                        <i
                                                                            class="fas fa-map-marker-alt me-1"></i>${route.destinationCity}
                                                                    </span>
                                                                </td>
                                                                <td>
                                                                    <span class="text-muted">
                                                                        <i
                                                                            class="fas fa-road me-1"></i>${route.distance}
                                                                        km
                                                                    </span>
                                                                </td>
                                                                <td>
                                                                    <span class="text-muted">
                                                                        <i
                                                                            class="fas fa-clock me-1"></i>${route.durationHours}
                                                                        hrs
                                                                    </span>
                                                                </td>
                                                                <td>
                                                                    <span class="text-success fw-bold">
                                                                        <i class="fas fa-money-bill-wave me-1"></i>
                                                                        <fmt:formatNumber value="${route.basePrice}"
                                                                            pattern="#,###" /> ₫
                                                                    </span>
                                                                </td>
                                                                <td>
                                                                    <span
                                                                        class="badge status-badge ${route.status eq 'ACTIVE' ? 'bg-success' : 'bg-secondary'}">
                                                                        ${route.status}
                                                                    </span>
                                                                </td>
                                                                <td>
                                                                    <div class="btn-group" role="group">
                                                                        <button type="button"
                                                                            class="btn btn-outline-info btn-sm"
                                                                            title="View Details" data-bs-toggle="modal"
                                                                            data-bs-target="#routeDetailModal"
                                                                            data-routeid="${route.routeId}"
                                                                            data-routename="${route.routeName}"
                                                                            data-departure="${route.departureCity}"
                                                                            data-destination="${route.destinationCity}"
                                                                            data-distance="${route.distance}"
                                                                            data-duration="${route.durationHours}"
                                                                            data-price="${route.basePrice}"
                                                                            data-status="${route.status}">
                                                                            <i class="fas fa-eye"></i>
                                                                        </button>
                                                                        <a href="${pageContext.request.contextPath}/routes/edit?id=${route.routeId}"
                                                                            class="btn btn-outline-primary btn-sm"
                                                                            title="Edit">
                                                                            <i class="fas fa-edit"></i>
                                                                        </a>
                                                                        <button type="button"
                                                                            class="btn btn-outline-danger btn-sm"
                                                                            data-routename="${route.routeName}"
                                                                            onclick="confirmDelete('${route.routeId}', this)"
                                                                            title="Delete">
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
                                <i class="fas fa-route fa-3x text-muted mb-3"></i>
                                <h4 class="text-muted">No routes found</h4>
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
                                    <i class="fas fa-route fa-3x text-danger mb-3"></i>
                                </div>
                                <p class="text-center mb-3">Are you sure you want to delete route <strong
                                        id="routeNameToDelete" class="text-danger"></strong>?</p>
                                <div class="alert alert-warning" role="alert">
                                    <i class="fas fa-exclamation-triangle me-2"></i>
                                    <strong>Warning:</strong> This action cannot be undone. The route will be
                                    permanently removed from the system.
                                </div>
                                <div class="alert alert-info" role="alert">
                                    <i class="fas fa-info-circle me-2"></i>
                                    <strong>Note:</strong> If this route is currently used in active schedules, the
                                    deletion will be prevented.
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                                    <i class="fas fa-times me-1"></i>Cancel
                                </button>
                                <a href="#" id="confirmDeleteBtn" class="btn btn-danger">
                                    <i class="fas fa-trash me-1"></i>Delete Route
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Route Detail Modal -->
                <div class="modal fade" id="routeDetailModal" tabindex="-1" aria-labelledby="routeDetailModalLabel"
                    aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered modal-lg">
                        <div class="modal-content">
                            <div class="modal-header bg-primary text-white">
                                <h5 class="modal-title" id="routeDetailModalLabel">
                                    <i class="fas fa-route me-2"></i>Route Details
                                </h5>
                                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"
                                    aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <div class="d-flex align-items-center mb-2">
                                            <i class="fas fa-hashtag text-primary me-3" style="width: 20px;"></i>
                                            <div>
                                                <small class="text-muted d-block">Route ID</small>
                                                <strong id="detailRouteId"></strong>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <div class="d-flex align-items-center mb-2">
                                            <i class="fas fa-route text-primary me-3" style="width: 20px;"></i>
                                            <div>
                                                <small class="text-muted d-block">Route Name</small>
                                                <strong id="detailRouteName"></strong>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <div class="d-flex align-items-center mb-2">
                                            <i class="fas fa-map-marker-alt text-info me-3" style="width: 20px;"></i>
                                            <div>
                                                <small class="text-muted d-block">From</small>
                                                <strong id="detailDeparture"></strong>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <div class="d-flex align-items-center mb-2">
                                            <i class="fas fa-map-marker-alt text-success me-3" style="width: 20px;"></i>
                                            <div>
                                                <small class="text-muted d-block">To</small>
                                                <strong id="detailDestination"></strong>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <div class="d-flex align-items-center mb-2">
                                            <i class="fas fa-road text-warning me-3" style="width: 20px;"></i>
                                            <div>
                                                <small class="text-muted d-block">Distance</small>
                                                <strong id="detailDistance"></strong>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <div class="d-flex align-items-center mb-2">
                                            <i class="fas fa-clock text-info me-3" style="width: 20px;"></i>
                                            <div>
                                                <small class="text-muted d-block">Duration</small>
                                                <strong id="detailDuration"></strong>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <div class="d-flex align-items-center mb-2">
                                            <i class="fas fa-money-bill-wave text-success me-3"
                                                style="width: 20px;"></i>
                                            <div>
                                                <small class="text-muted d-block">Base Price</small>
                                                <strong id="detailPrice"></strong>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <div class="d-flex align-items-center mb-2">
                                            <i class="fas fa-check-circle text-success me-3" style="width: 20px;"></i>
                                            <div>
                                                <small class="text-muted d-block">Status</small>
                                                <span id="detailStatus"></span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="mt-3">
                                    <div class="d-flex align-items-center mb-2">
                                        <i class="fas fa-map-signs text-primary me-3" style="width: 20px;"></i>
                                        <div>
                                            <small class="text-muted d-block">Stations</small>
                                            <strong>Route Stations</strong>
                                        </div>
                                    </div>
                                    <div id="detailStationsLoading" class="text-center py-3 d-none">
                                        <div class="spinner-border text-primary" role="status">
                                            <span class="visually-hidden">Loading...</span>
                                        </div>
                                    </div>
                                    <ul class="list-group mb-2" id="detailStationList"></ul>
                                    <div class="text-muted d-none" id="detailStationsEmpty">
                                        No stations configured for this route.
                                    </div>
                                    <div class="text-danger d-none" id="detailStationsError"></div>
                                </div>
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
                        document.addEventListener('DOMContentLoaded', function () {
                            const contextPath = '${pageContext.request.contextPath}';
                            var routeDetailModal = document.getElementById('routeDetailModal');
                            if (routeDetailModal) {
                                routeDetailModal.addEventListener('show.bs.modal', function (event) {
                                    var button = event.relatedTarget;
                                    var routeId = button ? button.getAttribute('data-routeid') : null;
                                    document.getElementById('detailRouteId').textContent = routeId || 'N/A';
                                    document.getElementById('detailRouteName').textContent = button.getAttribute('data-routename');
                                    document.getElementById('detailDeparture').textContent = button.getAttribute('data-departure');
                                    document.getElementById('detailDestination').textContent = button.getAttribute('data-destination');
                                    document.getElementById('detailDistance').textContent = button.getAttribute('data-distance') + ' km';
                                    document.getElementById('detailDuration').textContent = button.getAttribute('data-duration') + ' hours';
                                    var price = Number(button.getAttribute('data-price'));
                                    document.getElementById('detailPrice').textContent = price.toLocaleString('en-US') + ' ₫';
                                    var status = button.getAttribute('data-status');
                                    document.getElementById('detailStatus').innerHTML =
                                        status === 'ACTIVE'
                                            ? '<span class="badge bg-success">Active</span>'
                                            : '<span class="badge bg-secondary">Inactive</span>';
                                    fetchRouteStations(routeId);
                                });
                            }

                            function fetchRouteStations(routeId) {
                                const listEl = document.getElementById('detailStationList');
                                const loadingEl = document.getElementById('detailStationsLoading');
                                const emptyEl = document.getElementById('detailStationsEmpty');
                                const errorEl = document.getElementById('detailStationsError');

                                listEl.innerHTML = '';
                                emptyEl.classList.add('d-none');
                                errorEl.classList.add('d-none');
                                loadingEl.classList.add('d-none');

                                if (!routeId) {
                                    errorEl.textContent = 'Missing route ID. Unable to load stations.';
                                    errorEl.classList.remove('d-none');
                                    return;
                                }

                                loadingEl.classList.remove('d-none');

                                const detailUrl = contextPath + '/routes/detail?id=' + encodeURIComponent(routeId);
                                fetch(detailUrl)
                                    .then(response => {
                                        if (!response.ok) {
                                            throw new Error('Failed to load stations');
                                        }
                                        return response.json();
                                    })
                                    .then(data => {
                                        loadingEl.classList.add('d-none');

                                        if (!data.success) {
                                            errorEl.textContent = data.message || 'Unable to load stations for this route.';
                                            errorEl.classList.remove('d-none');
                                            return;
                                        }

                                        const stations = data.stations || [];
                                        if (stations.length === 0) {
                                            emptyEl.classList.remove('d-none');
                                            return;
                                        }

                                        stations.forEach((station, index) => {
                                            const li = document.createElement('li');
                                            li.className = 'list-group-item';

                                            const title = document.createElement('div');
                                            title.className = 'fw-bold';
                                            const orderText = (station.order || index + 1) + '. ';
                                            title.textContent = orderText + (station.stationName || 'Unnamed station');

                                            const cityRow = document.createElement('div');
                                            cityRow.className = 'small text-muted';
                                            const cityIcon = document.createElement('i');
                                            cityIcon.className = 'fas fa-map-marker-alt me-1';
                                            cityRow.appendChild(cityIcon);
                                            cityRow.appendChild(document.createTextNode(station.city || 'N/A'));

                                            const addressRow = document.createElement('div');
                                            addressRow.className = 'small text-muted';
                                            const addressIcon = document.createElement('i');
                                            addressIcon.className = 'fas fa-location-arrow me-1';
                                            addressRow.appendChild(addressIcon);
                                            addressRow.appendChild(document.createTextNode(station.address || 'No address provided'));

                                            li.appendChild(title);
                                            li.appendChild(cityRow);
                                            li.appendChild(addressRow);
                                            listEl.appendChild(li);
                                        });
                                    })
                                    .catch(error => {
                                        console.error(error);
                                        loadingEl.classList.add('d-none');
                                        errorEl.textContent = 'Unable to load stations for this route right now.';
                                        errorEl.classList.remove('d-none');
                                    });
                            }
                        });
                    </script>
                    <script>
                        function confirmDelete(routeId, el) {
                            let routeName = '';
                            if (el && typeof el.getAttribute === 'function') {
                                routeName = el.getAttribute('data-routename') || '';
                            } else if (typeof el === 'string') {
                                routeName = el;
                            }

                            document.getElementById('routeNameToDelete').textContent = routeName;
                            document.getElementById('confirmDeleteBtn').href =
                                '${pageContext.request.contextPath}/routes/delete?id=' + routeId;
                            new bootstrap.Modal(document.getElementById('deleteModal')).show();
                        }

                    </script>
            </body>

            </html>