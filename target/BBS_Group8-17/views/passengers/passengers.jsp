<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>User Management - Bus Booking System</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
                <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
                <style>
                    .table-hover tbody tr:hover {
                        background-color: rgba(0, 0, .075);
                    }

                    .btn-action {
                        margin: 0 2px;
                    }

                    .search-form {
                        background: #f8f9fa;
                        padding: 20px;
                        border-radius: 8px;
                        margin-bottom: 20px;
                    }

                    .passenger-card {
                        transition: transform 0.2s ease;
                        border: none;
                        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                    }

                    .passenger-card:hover {
                        transform: translateY(-2px);
                        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
                    }

                    .avatar {
                        width: 60px;
                        height: 60px;
                        border-radius: 50%;
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        color: white;
                        font-size: 1.5rem;
                        font-weight: bold;
                    }

                    .gender-badge {
                        font-size: 0.75rem;
                    }

                    .contact-info {
                        font-size: 0.9rem;
                    }
                </style>
            </head>

            <body>
                <!-- Include header with session logic -->
                <jsp:include page="/views/partials/user-header.jsp" />

                <div class="container mt-4">
                    <!-- Header -->
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h2><i class="fas fa-users me-2"></i>User Management</h2>
                        <a href="${pageContext.request.contextPath}/passengers/add" class="btn btn-primary">
                            <i class="fas fa-plus me-1"></i>Add User
                        </a>
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

                    <!-- Search Form -->
                    <div class="search-form">
                        <form action="${pageContext.request.contextPath}/passengers/search" method="get"
                            class="row g-3">
                            <div class="col-md-4">
                                <label for="keyword" class="form-label">Search</label>
                                <div class="input-group">
                                    <span class="input-group-text">
                                        <i class="fas fa-search"></i>
                                    </span>
                                    <input type="text" class="form-control" id="keyword" name="keyword"
                                        value="${searchKeyword}" placeholder="Name, phone number, email...">
                                </div>
                            </div>
                            <div class="col-md-3">
                                <label for="gender" class="form-label">Gender</label>
                                <select class="form-select" id="gender" name="gender">
                                    <option value="">All</option>
                                    <option value="Nam" ${param.gender eq 'Nam' ? 'selected' : '' }>Male</option>
                                    <option value="Nữ" ${param.gender eq 'Nữ' ? 'selected' : '' }>Female</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label for="status" class="form-label">Status</label>
                                <select class="form-select" id="status" name="status">
                                    <option value="">All</option>
                                    <option value="ACTIVE" ${param.status eq 'ACTIVE' ? 'selected' : '' }>Active
                                    </option>
                                    <option value="INACTIVE" ${param.status eq 'INACTIVE' ? 'selected' : '' }>Inactive
                                    </option>
                                </select>
                            </div>
                            <div class="col-md-2 d-flex align-items-end">
                                <button type="submit" class="btn btn-outline-primary me-2">
                                    <i class="fas fa-search me-1"></i>Search
                                </button>
                                <a href="${pageContext.request.contextPath}/passengers"
                                    class="btn btn-outline-secondary">
                                    <i class="fas fa-refresh me-1"></i>Refresh
                                </a>
                            </div>
                        </form>
                    </div>

                    <!-- Passengers Display -->
                    <c:choose>
                        <c:when test="${empty users}">
                            <div class="text-center py-5">
                                <i class="fas fa-users fa-3x text-muted mb-3"></i>
                                <h5 class="text-muted">No users found</h5>
                                <p class="text-muted">Please add the first user to get started</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <!-- Grid View -->
                            <div class="row g-4" id="usersGrid">
                                <c:forEach var="user" items="${users}">
                                    <div class="col-md-6 col-lg-4">
                                        <div class="card passenger-card h-100">
                                            <div class="card-body">
                                                <div class="d-flex align-items-center mb-3">
                                                    <div class="avatar me-3">
                                                        ${user.fullName.charAt(0)}
                                                    </div>
                                                    <div>
                                                        <h6 class="mb-1">${user.fullName}</h6>
                                                        <span class="badge bg-info">${user.role}</span>
                                                        <c:choose>
                                                            <c:when test="${user.gender eq 'Nam'}">
                                                                <span class="badge bg-primary gender-badge">
                                                                    <i class="fas fa-mars me-1"></i>Male
                                                                </span>
                                                            </c:when>
                                                            <c:when test="${user.gender eq 'Nữ'}">
                                                                <span class="badge bg-danger gender-badge">
                                                                    <i class="fas fa-venus me-1"></i>Female
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span
                                                                    class="badge bg-secondary gender-badge">Other</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </div>

                                                <div class="contact-info">
                                                    <div class="mb-2">
                                                        <i class="fas fa-phone me-2 text-primary"></i>
                                                        <span>${user.phoneNumber}</span>
                                                    </div>
                                                    <c:if test="${not empty user.email}">
                                                        <div class="mb-2">
                                                            <i class="fas fa-envelope me-2 text-info"></i>
                                                            <span>${user.email}</span>
                                                        </div>
                                                    </c:if>
                                                    <c:if test="${not empty user.idCard}">
                                                        <div class="mb-2">
                                                            <i class="fas fa-id-card me-2 text-warning"></i>
                                                            <span>${user.idCard}</span>
                                                        </div>
                                                    </c:if>
                                                    <c:if test="${not empty user.address}">
                                                        <div class="mb-2">
                                                            <i class="fas fa-map-marker-alt me-2 text-success"></i>
                                                            <span>${user.address}</span>
                                                        </div>
                                                    </c:if>
                                                    <c:if test="${not empty user.dateOfBirth}">
                                                        <div class="mb-2">
                                                            <i class="fas fa-birthday-cake me-2 text-danger"></i>
                                                            <span>
                                                                <fmt:formatDate value="${user.dateOfBirth}"
                                                                    pattern="dd/MM/yyyy" />
                                                            </span>
                                                        </div>
                                                    </c:if>
                                                </div>
                                            </div>
                                            <div class="card-footer bg-transparent">
                                                <div class="d-flex justify-content-between">
                                                    <a href="${pageContext.request.contextPath}/passengers/${user.userId}"
                                                        class="btn btn-sm btn-info btn-action" title="View Details">
                                                        <i class="fas fa-eye"></i>
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/passengers/profile?id=${user.userId}"
                                                        class="btn btn-sm btn-success btn-action" title="Profile">
                                                        <i class="fas fa-user"></i>
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/passengers/edit?id=${user.userId}"
                                                        class="btn btn-sm btn-warning btn-action" title="Edit">
                                                        <i class="fas fa-edit"></i>
                                                    </a>
                                                    <button type="button" class="btn btn-sm btn-danger btn-action"
                                                        onclick="confirmDelete('${user.userId}', '${user.fullName}')"
                                                        title="Delete">
                                                        <i class="fas fa-trash"></i>
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>

                            <!-- Table View (Hidden by default) -->
                            <div class="table-responsive d-none" id="usersTable">
                                <table class="table table-hover">
                                    <thead class="table-dark">
                                        <tr>
                                            <th>ID</th>
                                            <th>Full Name</th>
                                            <th>Username</th>
                                            <th>Phone Number</th>
                                            <th>Email</th>
                                            <th>Role</th>
                                            <th>Gender</th>
                                            <th>Date of Birth</th>
                                            <th>Status</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="user" items="${users}">
                                            <tr>
                                                <td>${user.userId}</td>
                                                <td><strong>${user.fullName}</strong></td>
                                                <td>${user.username}</td>
                                                <td>${user.phoneNumber}</td>
                                                <td>${user.email}</td>
                                                <td>
                                                    <span class="badge bg-info">${user.role}</span>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${user.gender eq 'Nam'}">
                                                            <span class="badge bg-primary">
                                                                <i class="fas fa-mars me-1"></i>Male
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${user.gender eq 'Nữ'}">
                                                            <span class="badge bg-danger">
                                                                <i class="fas fa-venus me-1"></i>Female
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-secondary">Other</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:if test="${not empty user.dateOfBirth}">
                                                        <fmt:formatDate value="${user.dateOfBirth}"
                                                            pattern="dd/MM/yyyy" />
                                                    </c:if>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${user.status eq 'ACTIVE'}">
                                                            <span class="badge bg-success">Active</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-secondary">Inactive</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <a href="${pageContext.request.contextPath}/passengers/${user.userId}"
                                                        class="btn btn-sm btn-info btn-action" title="View Details">
                                                        <i class="fas fa-eye"></i>
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/passengers/profile?id=${user.userId}"
                                                        class="btn btn-sm btn-success btn-action" title="Profile">
                                                        <i class="fas fa-user"></i>
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/passengers/edit?id=${user.userId}"
                                                        class="btn btn-sm btn-warning btn-action" title="Edit">
                                                        <i class="fas fa-edit"></i>
                                                    </a>
                                                    <button type="button" class="btn btn-sm btn-danger btn-action"
                                                        onclick="confirmDelete('${user.userId}', '${user.fullName}')"
                                                        title="Delete">
                                                        <i class="fas fa-trash"></i>
                                                    </button>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>

                            <!-- View Toggle -->
                            <div class="text-center mt-4">
                                <div class="btn-group" role="group">
                                    <button type="button" class="btn btn-outline-primary active"
                                        onclick="switchView('grid')">
                                        <i class="fas fa-th-large me-1"></i>Grid
                                    </button>
                                    <button type="button" class="btn btn-outline-primary" onclick="switchView('table')">
                                        <i class="fas fa-table me-1"></i>Table
                                    </button>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Delete Confirmation Modal -->
                <div class="modal fade" id="deleteModal" tabindex="-1">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title">Confirm Delete</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                            </div>
                            <div class="modal-body">
                                <p>Are you sure you want to delete user <strong id="passengerNameToDelete"></strong>?
                                </p>
                                <p class="text-danger"><small>This action cannot be undone.</small></p>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                <a href="#" id="confirmDeleteBtn" class="btn btn-danger">Delete</a>
                            </div>
                        </div>
                    </div>
                </div>

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
                <script>
                    function confirmDelete(userId, userName) {
                        document.getElementById('passengerNameToDelete').textContent = userName;
                        document.getElementById('confirmDeleteBtn').href =
                            '${pageContext.request.contextPath}/passengers/delete?id=' + userId;
                        new bootstrap.Modal(document.getElementById('deleteModal')).show();
                    }

                    function switchView(view) {
                        const gridView = document.getElementById('usersGrid');
                        const tableView = document.getElementById('usersTable');
                        const buttons = document.querySelectorAll('.btn-group .btn');

                        buttons.forEach(btn => btn.classList.remove('active'));
                        event.target.classList.add('active');

                        if (view === 'grid') {
                            gridView.classList.remove('d-none');
                            tableView.classList.add('d-none');
                        } else {
                            gridView.classList.add('d-none');
                            tableView.classList.remove('d-none');
                        }
                    }
                </script>
            </body>

            </html>