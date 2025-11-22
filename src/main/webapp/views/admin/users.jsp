<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Passenger Management - Admin Dashboard</title>
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

                    #usersTable {
                        margin-bottom: 0;
                    }

                    #usersTable tbody tr:hover {
                        background-color: #f8f9fa;
                    }

                    #usersTable th {
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

                    .role-badge {
                        padding: 0.4em 0.8em;
                        border-radius: 20px;
                        font-size: 0.85em;
                        font-weight: 500;
                    }

                    .role-admin {
                        background-color: #dc3545;
                        color: white;
                    }

                    .role-driver {
                        background-color: #fd7e14;
                        color: white;
                    }

                    .role-user {
                        background-color: #66bb6a;
                        color: white;
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
                                    <div class="col-12">
                                        <h2 class="mb-0">
                                            <i class="fas fa-users me-2"></i>Passenger Management
                                        </h2>
                                        <p class="mb-0 mt-2">Manage passenger accounts and information</p>
                                    </div>
                                </div>

                                <!-- Search and Filter Section -->
                                <div class="filter-section">
                                    <form action="${pageContext.request.contextPath}/admin/users" method="get">
                                        <div class="row">
                                            <div class="col-md-4">
                                                <div class="input-group">
                                                    <span class="input-group-text bg-white border-0">
                                                        <i class="fas fa-search text-muted"></i>
                                                    </span>
                                                    <input type="text" class="form-control border-0" id="search"
                                                        name="search" value="${searchTerm}"
                                                        placeholder="Search passengers...">
                                                </div>
                                            </div>
                                            <div class="col-md-3">
                                                <select class="form-select border-0" id="statusFilter" name="status">
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
                                                <a href="${pageContext.request.contextPath}/admin/users"
                                                    class="btn btn-outline-light w-100">
                                                    <i class="fas fa-times me-1"></i>Clear
                                                </a>
                                            </div>
                                        </div>
                                    </form>
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

                            <!-- Users Table -->
                            <c:choose>
                                <c:when test="${empty users}">
                                    <div class="text-center py-5">
                                        <i class="fas fa-users fa-3x text-muted mb-3"></i>
                                        <h4 class="text-muted">No passengers found</h4>
                                        <p class="text-muted">Try adjusting your filters or search criteria.</p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="card shadow-sm">
                                        <div class="card-body">
                                            <div class="table-responsive">
                                                <table class="table table-hover align-middle" id="usersTable">
                                                    <thead class="table-light">
                                                        <tr>
                                                            <th>Name</th>
                                                            <th>Username</th>
                                                            <th>Email</th>
                                                            <th>Phone</th>
                                                            <th>Role</th>
                                                            <th>Status</th>
                                                            <th>Creation Date</th>
                                                            <th>Actions</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody id="usersContainer">
                                                        <c:forEach var="user" items="${users}">
                                                            <tr class="user-item" data-status="${user.status}">
                                                                <td>
                                                                    <div class="fw-bold">
                                                                        <i class="fas fa-user me-1 text-primary"></i>
                                                                        ${user.fullName}
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <span class="text-muted">${user.username}</span>
                                                                </td>
                                                                <td>
                                                                    <div class="fw-bold">${user.email}</div>
                                                                </td>
                                                                <td>
                                                                    <span class="text-muted">
                                                                        <i
                                                                            class="fas fa-phone me-1"></i>${user.phoneNumber}
                                                                    </span>
                                                                </td>
                                                                <td>
                                                                    <span
                                                                        class="role-badge role-${user.role.toLowerCase()}">
                                                                        <c:choose>
                                                                            <c:when test="${user.role eq 'USER'}">
                                                                                PASSENGER</c:when>
                                                                            <c:otherwise>${user.role}</c:otherwise>
                                                                        </c:choose>
                                                                    </span>
                                                                </td>
                                                                <td>
                                                                    <span
                                                                        class="badge status-badge ${user.status == 'ACTIVE' ? 'bg-success' : 'bg-danger'}">
                                                                        ${user.status}
                                                                    </span>
                                                                </td>
                                                                <td>
                                                                    <small
                                                                        class="text-muted">${user.formattedCreatedDate}</small>
                                                                </td>
                                                                <td>
                                                                    <div class="btn-group" role="group">
                                                                        <button type="button"
                                                                            class="btn btn-outline-info btn-sm"
                                                                            title="View Details" data-bs-toggle="modal"
                                                                            data-bs-target="#userDetailModal"
                                                                            data-userid="${user.userId}"
                                                                            data-username="${user.username}"
                                                                            data-fullname="${user.fullName}"
                                                                            data-email="${user.email}"
                                                                            data-phone="${user.phoneNumber}"
                                                                            data-role="${user.role}"
                                                                            data-status="${user.status}"
                                                                            data-createddate="${user.formattedCreatedDate}">
                                                                            <i class="fas fa-eye"></i>
                                                                        </button>
                                                                        <a href="${pageContext.request.contextPath}/admin/users/edit?id=${user.userId}"
                                                                            class="btn btn-outline-primary btn-sm"
                                                                            title="Edit">
                                                                            <i class="fas fa-edit"></i>
                                                                        </a>
                                                                        <button type="button"
                                                                            class="btn btn-outline-danger btn-sm"
                                                                            data-username="${user.fullName}"
                                                                            onclick="confirmDelete('${user.userId}', this)"
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
                                <i class="fas fa-users fa-3x text-muted mb-3"></i>
                                <h4 class="text-muted">No passengers found</h4>
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
                                    <i class="fas fa-user-times fa-3x text-danger mb-3"></i>
                                </div>
                                <p class="text-center mb-3">Are you sure you want to delete passenger <strong
                                        id="userNameToDelete" class="text-danger"></strong>?</p>
                                <div class="alert alert-warning" role="alert">
                                    <i class="fas fa-exclamation-triangle me-2"></i>
                                    <strong>Warning:</strong> This action cannot be undone. The passenger account will
                                    be
                                    permanently removed from the system.
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                                    <i class="fas fa-times me-1"></i>Cancel
                                </button>
                                <a href="#" id="confirmDeleteBtn" class="btn btn-danger">
                                    <i class="fas fa-trash me-1"></i>Delete Passenger
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- User Detail Modal -->
                <div class="modal fade" id="userDetailModal" tabindex="-1" aria-labelledby="userDetailModalLabel"
                    aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered modal-lg">
                        <div class="modal-content">
                            <div class="modal-header bg-primary text-white">
                                <h5 class="modal-title" id="userDetailModalLabel">
                                    <i class="fas fa-user me-2"></i>Passenger Details
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
                                                <small class="text-muted d-block">User ID</small>
                                                <strong id="detailUserId"></strong>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <div class="d-flex align-items-center mb-2">
                                            <i class="fas fa-user text-primary me-3" style="width: 20px;"></i>
                                            <div>
                                                <small class="text-muted d-block">Full Name</small>
                                                <strong id="detailFullName"></strong>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <div class="d-flex align-items-center mb-2">
                                            <i class="fas fa-user-circle text-info me-3" style="width: 20px;"></i>
                                            <div>
                                                <small class="text-muted d-block">Username</small>
                                                <strong id="detailUsername"></strong>
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
                                            <i class="fas fa-phone text-warning me-3" style="width: 20px;"></i>
                                            <div>
                                                <small class="text-muted d-block">Phone</small>
                                                <strong id="detailPhone"></strong>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <div class="d-flex align-items-center mb-2">
                                            <i class="fas fa-user-tag text-success me-3" style="width: 20px;"></i>
                                            <div>
                                                <small class="text-muted d-block">Role</small>
                                                <span id="detailRole"></span>
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
                                    <div class="col-md-6 mb-3">
                                        <div class="d-flex align-items-center mb-2">
                                            <i class="fas fa-calendar text-info me-3" style="width: 20px;"></i>
                                            <div>
                                                <small class="text-muted d-block">Created Date</small>
                                                <strong id="detailCreatedDate"></strong>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- Tickets Section -->
                                <hr class="my-4">
                                <div class="mb-3">
                                    <h6 class="mb-3">
                                        <i class="fas fa-ticket-alt me-2 text-success"></i>Booked Tickets
                                        <span class="badge bg-success ms-2" id="ticketCount">0</span>
                                    </h6>
                                    <div id="ticketsContainer">
                                        <div class="text-center py-3">
                                            <div class="spinner-border spinner-border-sm text-primary" role="status">
                                                <span class="visually-hidden">Loading...</span>
                                            </div>
                                            <small class="text-muted d-block mt-2">Loading tickets...</small>
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
                        document.addEventListener('DOMContentLoaded', function () {
                            var userDetailModal = document.getElementById('userDetailModal');
                            if (userDetailModal) {
                                userDetailModal.addEventListener('show.bs.modal', function (event) {
                                    var button = event.relatedTarget;
                                    var userId = button.getAttribute('data-userid');
                                    var role = button.getAttribute('data-role');
                                    
                                    // Set user details
                                    document.getElementById('detailUserId').textContent = userId;
                                    document.getElementById('detailFullName').textContent = button.getAttribute('data-fullname');
                                    document.getElementById('detailUsername').textContent = button.getAttribute('data-username');
                                    document.getElementById('detailEmail').textContent = button.getAttribute('data-email');
                                    document.getElementById('detailPhone').textContent = button.getAttribute('data-phone');
                                    var roleText = role === 'USER' ? 'PASSENGER' : role;
                                    var roleClass = role === 'ADMIN' ? 'role-admin' : role === 'DRIVER' ? 'role-driver' : 'role-user';
                                    document.getElementById('detailRole').innerHTML = '<span class="role-badge ' + roleClass + '">' + roleText + '</span>';
                                    var status = button.getAttribute('data-status');
                                    document.getElementById('detailStatus').innerHTML =
                                        status === 'ACTIVE'
                                            ? '<span class="badge bg-success">Active</span>'
                                            : '<span class="badge bg-danger">Inactive</span>';
                                    document.getElementById('detailCreatedDate').textContent = button.getAttribute('data-createddate');
                                    
                                    // Load tickets if user is a passenger
                                    if (role === 'USER') {
                                        loadUserTickets(userId);
                                    } else {
                                        document.getElementById('ticketsContainer').innerHTML = '<div class="text-center py-3"><small class="text-muted">No tickets available for this user type.</small></div>';
                                        document.getElementById('ticketCount').textContent = '0';
                                    }
                                });
                            }
                        });
                        
                        function loadUserTickets(userId) {
                            var ticketsContainer = document.getElementById('ticketsContainer');
                            ticketsContainer.innerHTML = '<div class="text-center py-3"><div class="spinner-border spinner-border-sm text-primary" role="status"><span class="visually-hidden">Loading...</span></div><small class="text-muted d-block mt-2">Loading tickets...</small></div>';
                            
                            fetch('${pageContext.request.contextPath}/passengers/tickets?userId=' + userId)
                                .then(response => response.json())
                                .then(data => {
                                    if (data.success && data.tickets) {
                                        document.getElementById('ticketCount').textContent = data.count || 0;
                                        
                                        if (data.tickets.length === 0) {
                                            ticketsContainer.innerHTML = '<div class="text-center py-3"><i class="fas fa-ticket-alt fa-2x text-muted mb-2"></i><p class="text-muted mb-0">No tickets found for this passenger.</p></div>';
                                        } else {
                                            var ticketsHtml = '<div class="list-group">';
                                            data.tickets.forEach(function(ticket) {
                                                var statusClass = ticket.status === 'CONFIRMED' ? 'bg-success' : 
                                                                 ticket.status === 'COMPLETED' ? 'bg-primary' : 
                                                                 ticket.status === 'PENDING' ? 'bg-warning' : 'bg-secondary';
                                                var paymentClass = ticket.paymentStatus === 'PAID' ? 'bg-success' : 'bg-warning';
                                                
                                                var departureDate = ticket.departureDate ? new Date(ticket.departureDate).toLocaleDateString('en-GB') : '-';
                                                var departureTime = ticket.departureTime ? ticket.departureTime.substring(0, 5) : '-';
                                                
                                                ticketsHtml += '<div class="list-group-item">';
                                                ticketsHtml += '<div class="d-flex justify-content-between align-items-start mb-2">';
                                                ticketsHtml += '<div><strong>' + ticket.ticketNumber + '</strong></div>';
                                                ticketsHtml += '<div><span class="badge ' + statusClass + ' me-1">' + ticket.status + '</span>';
                                                ticketsHtml += '<span class="badge ' + paymentClass + '">' + ticket.paymentStatus + '</span></div>';
                                                ticketsHtml += '</div>';
                                                ticketsHtml += '<div class="row g-2 small">';
                                                ticketsHtml += '<div class="col-12"><strong>Route:</strong> ' + (ticket.routeName || '-') + ' (' + (ticket.departureCity || '') + ' → ' + (ticket.destinationCity || '') + ')</div>';
                                                ticketsHtml += '<div class="col-6"><strong>Departure:</strong> ' + departureDate + ' ' + departureTime + '</div>';
                                                ticketsHtml += '<div class="col-6"><strong>Seat:</strong> ' + (ticket.seatNumber || '-') + ' | <strong>Bus:</strong> ' + (ticket.busNumber || '-') + '</div>';
                                                if (ticket.boardingStationName || ticket.alightingStationName) {
                                                    ticketsHtml += '<div class="col-12"><strong>Stations:</strong> ';
                                                    if (ticket.boardingStationName) {
                                                        ticketsHtml += 'Boarding: ' + ticket.boardingStationName;
                                                        if (ticket.boardingCity) ticketsHtml += ' (' + ticket.boardingCity + ')';
                                                    }
                                                    if (ticket.boardingStationName && ticket.alightingStationName) ticketsHtml += ' | ';
                                                    if (ticket.alightingStationName) {
                                                        ticketsHtml += 'Alighting: ' + ticket.alightingStationName;
                                                        if (ticket.alightingCity) ticketsHtml += ' (' + ticket.alightingCity + ')';
                                                    }
                                                    ticketsHtml += '</div>';
                                                }
                                                if (ticket.ticketPrice) {
                                                    ticketsHtml += '<div class="col-12"><strong>Price:</strong> <span class="text-success">' + new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(ticket.ticketPrice) + '</span></div>';
                                                }
                                                ticketsHtml += '</div></div>';
                                            });
                                            ticketsHtml += '</div>';
                                            ticketsContainer.innerHTML = ticketsHtml;
                                        }
                                    } else {
                                        ticketsContainer.innerHTML = '<div class="alert alert-warning"><small>Error loading tickets: ' + (data.error || 'Unknown error') + '</small></div>';
                                        document.getElementById('ticketCount').textContent = '0';
                                    }
                                })
                                .catch(error => {
                                    console.error('Error loading tickets:', error);
                                    ticketsContainer.innerHTML = '<div class="alert alert-danger"><small>Error loading tickets. Please try again.</small></div>';
                                    document.getElementById('ticketCount').textContent = '0';
                                });
                        }
                    </script>
                    <script>
                        function confirmDelete(userId, el) {
                            let userName = '';
                            if (el && typeof el.getAttribute === 'function') {
                                userName = el.getAttribute('data-username') || '';
                            } else if (typeof el === 'string') {
                                userName = el;
                            }

                            document.getElementById('userNameToDelete').textContent = userName;
                            document.getElementById('confirmDeleteBtn').href =
                                '${pageContext.request.contextPath}/admin/users/delete?id=' + userId;
                            new bootstrap.Modal(document.getElementById('deleteModal')).show();
                        }
                    </script>
            </body>

            </html>