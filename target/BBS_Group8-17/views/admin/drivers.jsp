X<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Driver Management - Admin Dashboard</title>
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

                    #driversTable {
                        margin-bottom: 0;
                    }

                    #driversTable tbody tr:hover {
                        background-color: #f8f9fa;
                    }

                    #driversTable th {
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
                                            <i class="fas fa-user-tie me-2"></i>Driver Management
                                        </h2>
                                        <p class="mb-0 mt-2">Manage driver accounts and information</p>
                                    </div>
                                    <div class="col-md-6 text-md-end">
                                        <a href="${pageContext.request.contextPath}/admin/drivers/add"
                                            class="btn btn-light btn-lg">
                                            <i class="fas fa-plus me-2"></i>Add New Driver
                                        </a>
                                    </div>
                                </div>

                                <!-- Search and Filter Section -->
                                <div class="filter-section">
                                    <form action="${pageContext.request.contextPath}/admin/drivers/search" method="get">
                                        <div class="row">
                                            <div class="col-md-4">
                                                <div class="input-group">
                                                    <span class="input-group-text bg-white border-0">
                                                        <i class="fas fa-search text-muted"></i>
                                                    </span>
                                                    <input type="text" class="form-control border-0" id="keyword"
                                                        name="search" value="${searchTerm}"
                                                        placeholder="Search drivers...">
                                                </div>
                                            </div>
                                            <div class="col-md-3">
                                                <select class="form-select border-0" id="status" name="status">
                                                    <option value="">All Status</option>
                                                    <option value="ACTIVE" ${param.status eq 'ACTIVE' ? 'selected' : ''
                                                        }>Active</option>
                                                    <option value="INACTIVE" ${param.status eq 'INACTIVE' ? 'selected'
                                                        : '' }>Inactive</option>
                                                </select>
                                            </div>
                                            <div class="col-md-3">
                                                <button type="submit" class="btn btn-outline-light w-100">
                                                    <i class="fas fa-search me-1"></i>Search
                                                </button>
                                            </div>
                                            <div class="col-md-2">
                                                <a href="${pageContext.request.contextPath}/admin/drivers"
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

                            <!-- Drivers Table -->
                            <c:choose>
                                <c:when test="${empty drivers}">
                                    <div class="text-center py-5">
                                        <i class="fas fa-user-tie fa-3x text-muted mb-3"></i>
                                        <h4 class="text-muted">No drivers found</h4>
                                        <p class="text-muted">Click "Add New Driver" to create your first driver</p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="card shadow-sm">
                                        <div class="card-body">
                                            <div class="table-responsive">
                                                <table class="table table-hover align-middle" id="driversTable">
                                                    <thead class="table-light">
                                                        <tr>
                                                            <th>Driver</th>
                                                            <th>Contact</th>
                                                            <th>License</th>
                                                            <th>Experience</th>
                                                            <th>Rating</th>
                                                            <th>Total Ratings</th>
                                                            <th>Status</th>
                                                            <th>Actions</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody id="driversContainer">
                                                        <c:forEach var="driver" items="${drivers}">
                                                            <tr class="driver-item" data-status="${driver.status}">
                                                                <td>
                                                                    <div class="fw-bold">
                                                                        <i
                                                                            class="fas fa-user-tie me-1 text-primary"></i>
                                                                        ${driver.fullName}
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div class="fw-bold">
                                                                        <i
                                                                            class="fas fa-phone me-1 text-muted"></i>${driver.phoneNumber}
                                                                    </div>
                                                                    <c:if test="${not empty driver.email}">
                                                                        <small class="text-muted">
                                                                            <i
                                                                                class="fas fa-envelope me-1"></i>${driver.email}
                                                                        </small>
                                                                    </c:if>
                                                                </td>
                                                                <td>
                                                                    <span class="badge bg-secondary">
                                                                        <i
                                                                            class="fas fa-id-card me-1"></i>${driver.licenseNumber}
                                                                    </span>
                                                                </td>
                                                                <td>
                                                                    <span class="text-info">
                                                                        <i
                                                                            class="fas fa-clock me-1"></i>${driver.experienceYears}
                                                                        years
                                                                    </span>
                                                                </td>
                                                                <td>
                                                                    <span class="badge bg-warning text-dark">
                                                                        <i class="fas fa-star me-1"></i>
                                                                        <fmt:formatNumber
                                                                            value="${driverAvgMap[driver.driverId]}"
                                                                            maxFractionDigits="2"
                                                                            minFractionDigits="1" />
                                                                    </span>
                                                                </td>
                                                                <td>
                                                                    <span
                                                                        class="text-muted">${driverTotalMap[driver.driverId]}</span>
                                                                </td>
                                                                <td>
                                                                    <span
                                                                        class="badge status-badge ${driver.status eq 'ACTIVE' ? 'bg-success' : 'bg-secondary'}">
                                                                        ${driver.status}
                                                                    </span>
                                                                </td>
                                                                <td>
                                                                    <div class="btn-group" role="group">
                                                                        <button type="button"
                                                                            class="btn btn-outline-info btn-sm"
                                                                            title="View Details" data-bs-toggle="modal"
                                                                            data-bs-target="#driverDetailModal"
                                                                            data-driverid="${driver.driverId}"
                                                                            data-drivername="${driver.fullName}"
                                                                            data-phone="${driver.phoneNumber}"
                                                                            data-email="${driver.email}"
                                                                            data-license="${driver.licenseNumber}"
                                                                            data-experience="${driver.experienceYears}"
                                                                            data-rating="${driverAvgMap[driver.driverId]}"
                                                                            data-totalratings="${driverTotalMap[driver.driverId]}"
                                                                            data-status="${driver.status}">
                                                                            <i class="fas fa-eye"></i>
                                                                        </button>
                                                                        <a href="${pageContext.request.contextPath}/admin/drivers/edit?id=${driver.driverId}"
                                                                            class="btn btn-outline-primary btn-sm"
                                                                            title="Edit">
                                                                            <i class="fas fa-edit"></i>
                                                                        </a>
                                                                        <button type="button"
                                                                            class="btn btn-outline-danger btn-sm"
                                                                            onclick="showDeleteModal('${driver.driverId}', '${driver.fullName}')"
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
                                <i class="fas fa-user-tie fa-3x text-muted mb-3"></i>
                                <h4 class="text-muted">No drivers found</h4>
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
                                    <i class="fas fa-user-tie fa-3x text-danger mb-3"></i>
                                </div>
                                <p class="text-center mb-3">Are you sure you want to delete driver <strong
                                        id="driverNameToDelete" class="text-danger"></strong>?</p>
                                <div class="alert alert-warning" role="alert">
                                    <i class="fas fa-exclamation-triangle me-2"></i>
                                    <strong>Warning:</strong> This action cannot be undone. The driver will be
                                    permanently removed from the system.
                                </div>
                                <div class="alert alert-info" role="alert">
                                    <i class="fas fa-info-circle me-2"></i>
                                    <strong>Note:</strong> If this driver is currently assigned to active schedules, the
                                    deletion will be prevented.
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                                    <i class="fas fa-times me-1"></i>Cancel
                                </button>
                                <a href="#" id="confirmDeleteBtn" class="btn btn-danger">
                                    <i class="fas fa-trash me-1"></i>Delete Driver
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Driver Detail Modal -->
                <div class="modal fade" id="driverDetailModal" tabindex="-1" aria-labelledby="driverDetailModalLabel"
                    aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered modal-lg">
                        <div class="modal-content">
                            <div class="modal-header bg-primary text-white">
                                <h5 class="modal-title" id="driverDetailModalLabel">
                                    <i class="fas fa-user-tie me-2"></i>Driver Details
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
                                                <small class="text-muted d-block">Driver ID</small>
                                                <strong id="detailDriverId"></strong>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <div class="d-flex align-items-center mb-2">
                                            <i class="fas fa-user-tie text-primary me-3" style="width: 20px;"></i>
                                            <div>
                                                <small class="text-muted d-block">Full Name</small>
                                                <strong id="detailDriverName"></strong>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <div class="d-flex align-items-center mb-2">
                                            <i class="fas fa-phone text-info me-3" style="width: 20px;"></i>
                                            <div>
                                                <small class="text-muted d-block">Phone</small>
                                                <strong id="detailPhone"></strong>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <div class="d-flex align-items-center mb-2">
                                            <i class="fas fa-envelope text-info me-3" style="width: 20px;"></i>
                                            <div>
                                                <small class="text-muted d-block">Email</small>
                                                <strong id="detailEmail"></strong>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <div class="d-flex align-items-center mb-2">
                                            <i class="fas fa-id-card text-warning me-3" style="width: 20px;"></i>
                                            <div>
                                                <small class="text-muted d-block">License Number</small>
                                                <strong id="detailLicense"></strong>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <div class="d-flex align-items-center mb-2">
                                            <i class="fas fa-clock text-success me-3" style="width: 20px;"></i>
                                            <div>
                                                <small class="text-muted d-block">Experience</small>
                                                <strong id="detailExperience"></strong>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <div class="d-flex align-items-center mb-2">
                                            <i class="fas fa-star text-warning me-3" style="width: 20px;"></i>
                                            <div>
                                                <small class="text-muted d-block">Average Rating</small>
                                                <strong id="detailRating"></strong>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <div class="d-flex align-items-center mb-2">
                                            <i class="fas fa-comments text-info me-3" style="width: 20px;"></i>
                                            <div>
                                                <small class="text-muted d-block">Total Ratings</small>
                                                <strong id="detailTotalRatings"></strong>
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
                            var driverDetailModal = document.getElementById('driverDetailModal');
                            if (driverDetailModal) {
                                driverDetailModal.addEventListener('show.bs.modal', function (event) {
                                    var button = event.relatedTarget;
                                    document.getElementById('detailDriverId').textContent = button.getAttribute('data-driverid');
                                    document.getElementById('detailDriverName').textContent = button.getAttribute('data-drivername');
                                    document.getElementById('detailPhone').textContent = button.getAttribute('data-phone') || 'N/A';
                                    document.getElementById('detailEmail').textContent = button.getAttribute('data-email') || 'N/A';
                                    document.getElementById('detailLicense').textContent = button.getAttribute('data-license');
                                    document.getElementById('detailExperience').textContent = button.getAttribute('data-experience') + ' years';
                                    var rating = parseFloat(button.getAttribute('data-rating')) || 0;
                                    document.getElementById('detailRating').textContent = rating.toFixed(1);
                                    document.getElementById('detailTotalRatings').textContent = button.getAttribute('data-totalratings') || '0';
                                    var status = button.getAttribute('data-status');
                                    document.getElementById('detailStatus').innerHTML =
                                        status === 'ACTIVE'
                                            ? '<span class="badge bg-success">Active</span>'
                                            : '<span class="badge bg-secondary">Inactive</span>';
                                });
                            }
                        });
                    </script>
                    <script>
                        function showDeleteModal(driverId, driverName) {
                            document.getElementById('driverNameToDelete').textContent = driverName;
                            document.getElementById('confirmDeleteBtn').href =
                                '${pageContext.request.contextPath}/admin/drivers/delete?id=' + driverId;
                            new bootstrap.Modal(document.getElementById('deleteModal')).show();
                        }
                    </script>
            </body>

            </html>