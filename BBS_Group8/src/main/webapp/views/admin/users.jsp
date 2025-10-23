<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <jsp:include page="/views/partials/head.jsp">
                    <jsp:param name="title" value="User Management - Admin Panel" />
                </jsp:include>
                <style>
                    .user-card {
                        transition: transform 0.2s ease;
                        border: none;
                        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                    }

                    .user-card:hover {
                        transform: translateY(-2px);
                        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
                    }

                    .search-form {
                        background: #f8f9fa;
                        padding: 20px;
                        border-radius: 8px;
                        margin-bottom: 20px;
                    }

                    .role-badge {
                        padding: 0.5em 1em;
                        border-radius: 20px;
                        font-size: 0.9rem;
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
                        background-color: #28a745;
                        color: white;
                    }

                    .status-badge {
                        font-size: 0.9rem;
                    }
                </style>
            </head>

            <body>
                <%@ include file="/views/partials/admin-header.jsp" %>

                    <div class="container mt-4">
                        <!-- Header -->
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h2><i class="fas fa-users me-2"></i>User Management</h2>
                            <a href="${pageContext.request.contextPath}/admin/user/add" class="btn btn-primary">
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
                            <form action="${pageContext.request.contextPath}/admin/users" method="get" class="row g-3">
                                <div class="col-md-4">
                                    <label for="search" class="form-label">Search</label>
                                    <input type="text" class="form-control" id="search" name="search"
                                        value="${searchTerm}" placeholder="Name, email, username...">
                                </div>
                                <div class="col-md-3">
                                    <label for="role" class="form-label">Role</label>
                                    <select class="form-select" id="role" name="role">
                                        <option value="">All</option>
                                        <option value="ADMIN" ${roleFilter=='ADMIN' ? 'selected' : '' }>Admin</option>
                                        <option value="USER" ${roleFilter=='USER' ? 'selected' : '' }>User</option>
                                        <option value="DRIVER" ${roleFilter=='DRIVER' ? 'selected' : '' }>Driver
                                        </option>
                                    </select>
                                </div>
                                <div class="col-md-5 d-flex align-items-end">
                                    <button type="submit" class="btn btn-outline-primary me-2">
                                        <i class="fas fa-search me-1"></i>Search
                                    </button>
                                    <a href="${pageContext.request.contextPath}/admin/users"
                                        class="btn btn-outline-secondary">
                                        <i class="fas fa-refresh me-1"></i>Refresh
                                    </a>
                                </div>
                            </form>
                        </div>

                        <!-- Users Display -->
                        <c:choose>
                            <c:when test="${empty users}">
                                <div class="text-center py-5">
                                    <i class="fas fa-users fa-3x text-muted mb-3"></i>
                                    <h5 class="text-muted">No users found</h5>
                                    <p class="text-muted">Add the first user to get started</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <!-- Grid View -->
                                <div class="row g-4" id="usersGrid">
                                    <c:forEach var="user" items="${users}">
                                        <div class="col-md-6 col-lg-4">
                                            <div class="card user-card h-100">
                                                <div class="card-header bg-primary text-white">
                                                    <div class="d-flex justify-content-between align-items-center">
                                                        <h6 class="mb-0">
                                                            <i class="fas fa-user me-2"></i>${user.fullName}
                                                        </h6>
                                                        <span
                                                            class="role-badge role-${user.role.toLowerCase()}">${user.role}</span>
                                                    </div>
                                                </div>
                                                <div class="card-body">
                                                    <div class="mb-2"><strong>Username:</strong> ${user.username}</div>
                                                    <div class="mb-2"><strong>Email:</strong> ${user.email}</div>
                                                    <div class="mb-2"><strong>Phone:</strong> ${user.phoneNumber}</div>
                                                    <div class="mb-2"><strong>Status:</strong>
                                                        <span
                                                            class="badge ${user.status == 'ACTIVE' ? 'bg-success' : 'bg-danger'} status-badge">
                                                            ${user.status}
                                                        </span>
                                                    </div>
                                                    <div class="mb-2"><strong>Creation Date:</strong>
                                                        ${user.formattedCreatedDate}
                                                    </div>
                                                </div>
                                                <div class="card-footer bg-transparent">
                                                    <div class="d-flex justify-content-between">
                                                        <a href="${pageContext.request.contextPath}/admin/user/edit?id=${user.userId}"
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
                                        <tbody>
                                            <c:forEach var="user" items="${users}">
                                                <tr>
                                                    <td>${user.userId}</td>
                                                    <td><strong>${user.fullName}</strong></td>
                                                    <td>${user.username}</td>
                                                    <td>${user.email}</td>
                                                    <td>${user.phoneNumber}</td>
                                                    <td>
                                                        <span
                                                            class="role-badge role-${user.role.toLowerCase()}">${user.role}</span>
                                                    </td>
                                                    <td>
                                                        <span
                                                            class="badge ${user.status == 'ACTIVE' ? 'bg-success' : 'bg-danger'} status-badge">
                                                            ${user.status}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        ${user.formattedCreatedDate}
                                                    </td>
                                                    <td>
                                                        <a href="${pageContext.request.contextPath}/admin/user/edit?id=${user.userId}"
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
                                        <button type="button" class="btn btn-outline-primary"
                                            onclick="switchView('table')">
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
                                    <p>Are you sure you want to delete user <strong id="userNameToDelete"></strong>?</p>
                                    <p class="text-danger"><small>This action cannot be undone.</small></p>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary"
                                        data-bs-dismiss="modal">Cancel</button>
                                    <a href="#" id="confirmDeleteBtn" class="btn btn-danger">Delete</a>
                                </div>
                            </div>
                        </div>
                    </div>

                    <%@ include file="/views/partials/footer.jsp" %>

                        <script>
                            function confirmDelete(userId, userName) {
                                document.getElementById('userNameToDelete').textContent = userName;
                                document.getElementById('confirmDeleteBtn').href =
                                    '${pageContext.request.contextPath}/admin/user/delete?id=' + userId;
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