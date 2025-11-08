<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <jsp:include page="/views/partials/head.jsp">
                    <jsp:param name="title" value="Route Management - Bus Booking System" />
                </jsp:include>
                <style>
                    .route-card {
                        transition: transform 0.2s ease;
                        border: none;
                        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                    }

                    .route-card:hover {
                        transform: translateY(-2px);
                        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
                    }

                    .badge-status {
                        font-size: 0.9rem;
                    }

                    .search-form {
                        background: #f8f9fa;
                        padding: 20px;
                        border-radius: 8px;
                        margin-bottom: 20px;
                    }
                </style>
            </head>

            <body>
                <%@ include file="/views/partials/admin-header.jsp" %>
                    <div class="container mt-4">
                        <!-- Header -->
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h2><i class="fas fa-route me-2"></i>Route Management</h2>
                            <a href="${pageContext.request.contextPath}/routes/add" class="btn btn-primary">
                                <i class="fas fa-plus me-1"></i>Add Route
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
                            <form action="${pageContext.request.contextPath}/routes/search" method="get"
                                class="row g-3">
                                <div class="col-md-4">
                                    <label for="departureCity" class="form-label">Departure City</label>
                                    <input type="text" class="form-control" id="departureCity" name="departureCity"
                                        value="${departureCity}" placeholder="Enter departure city">
                                </div>
                                <div class="col-md-4">
                                    <label for="destinationCity" class="form-label">Destination City</label>
                                    <input type="text" class="form-control" id="destinationCity" name="destinationCity"
                                        value="${destinationCity}" placeholder="Enter destination city">
                                </div>
                                <div class="col-md-4 d-flex align-items-end">
                                    <button type="submit" class="btn btn-outline-primary me-2">
                                        <i class="fas fa-search me-1"></i>Search
                                    </button>
                                    <a href="${pageContext.request.contextPath}/routes"
                                        class="btn btn-outline-secondary">
                                        <i class="fas fa-refresh me-1"></i>Refresh
                                    </a>
                                </div>
                            </form>
                        </div>

                        <!-- Routes Display -->
                        <c:choose>
                            <c:when test="${empty routes}">
                                <div class="text-center py-5">
                                    <i class="fas fa-route fa-3x text-muted mb-3"></i>
                                    <h5 class="text-muted">No routes found</h5>
                                    <p class="text-muted">Please add the first route to get started</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <!-- Grid View (Hidden by default) -->
                                <div class="row g-4 d-none" id="routesGrid">
                                    <c:forEach var="route" items="${routes}">
                                        <div class="col-md-6 col-lg-4">
                                            <div class="card route-card h-100">
                                                <div class="card-header bg-primary text-white">
                                                    <div class="d-flex justify-content-between align-items-center">
                                                        <h6 class="mb-0">
                                                            <i class="fas fa-route me-2"></i>${route.routeName}
                                                        </h6>
                                                        <span
                                                            class="badge badge-status ${route.status eq 'ACTIVE' ? 'bg-success' : 'bg-secondary'}">
                                                            ${route.status eq 'ACTIVE' ? 'Active' : 'Inactive'}
                                                        </span>
                                                    </div>
                                                </div>
                                                <div class="card-body">
                                                    <div class="mb-2"><strong>From:</strong> ${route.departureCity}
                                                    </div>
                                                    <div class="mb-2"><strong>To:</strong>
                                                        ${route.destinationCity}</div>
                                                    <div class="mb-2"><strong>Distance:</strong> ${route.distance} km
                                                    </div>
                                                    <div class="mb-2"><strong>Duration:</strong> ${route.durationHours}
                                                        hours</div>
                                                    <div class="mb-2"><strong>Base Price:</strong>
                                                        <span class="text-success fw-bold">
                                                            <fmt:formatNumber value="${route.basePrice}"
                                                                pattern="#,###" /> VND
                                                        </span>
                                                    </div>
                                                </div>
                                                <div class="card-footer bg-transparent">
                                                    <div class="d-flex justify-content-between">
                                                        <button type="button" class="btn btn-sm btn-info btn-action"
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
                                                            class="btn btn-sm btn-warning btn-action" title="Edit">
                                                            <i class="fas fa-edit"></i>
                                                        </a>
                                                        <button type="button" class="btn btn-sm btn-danger btn-action"
                                                            onclick="confirmDelete(${route.routeId}, '${route.routeName}')"
                                                            title="Delete">
                                                            <i class="fas fa-trash"></i>
                                                        </button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>

                                <!-- Table View (Default) -->
                                <div class="table-responsive" id="routesTable">
                                    <table class="table table-hover">
                                        <thead class="table-dark">
                                            <tr>
                                                <th>ID</th>
                                                <th>Route Name</th>
                                                <th>From</th>
                                                <th>To</th>
                                                <th>Distance (km)</th>
                                                <th>Duration (hours)</th>
                                                <th>Price (VND)</th>
                                                <th>Status</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="route" items="${routes}">
                                                <tr>
                                                    <td>${route.routeId}</td>
                                                    <td><strong>${route.routeName}</strong></td>
                                                    <td>${route.departureCity}</td>
                                                    <td>${route.destinationCity}</td>
                                                    <td>${route.distance}</td>
                                                    <td>${route.durationHours}</td>
                                                    <td>
                                                        <span class="text-success fw-bold">
                                                            <fmt:formatNumber value="${route.basePrice}"
                                                                pattern="#,###" />
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <span
                                                            class="badge ${route.status eq 'ACTIVE' ? 'bg-success' : 'bg-secondary'}">
                                                            ${route.status eq 'ACTIVE' ? 'Active' : 'Inactive'}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <button type="button" class="btn btn-sm btn-info btn-action"
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
                                                            class="btn btn-sm btn-warning btn-action" title="Edit">
                                                            <i class="fas fa-edit"></i>
                                                        </a>
                                                        <button type="button" class="btn btn-sm btn-danger btn-action"
                                                            onclick="confirmDelete(${route.routeId}, '${route.routeName}')"
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
                                        <button type="button" class="btn btn-outline-primary"
                                            onclick="switchView('grid')">
                                            <i class="fas fa-th-large me-1"></i>Grid
                                        </button>
                                        <button type="button" class="btn btn-outline-primary active"
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
                                    <p>Are you sure you want to delete route <strong id="routeNameToDelete"></strong>?
                                    </p>
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

                    <div class="modal fade" id="routeDetailModal" tabindex="-1" aria-labelledby="routeDetailModalLabel"
                        aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header bg-primary text-white">
                                    <h5 class="modal-title" id="routeDetailModalLabel"><i
                                            class="fas fa-route me-2"></i>Route Details
                                    </h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                </div>
                                <div class="modal-body">
                                    <dl class="row">
                                        <dt class="col-5">Route ID:</dt>
                                        <dd class="col-7" id="detailRouteId"></dd>
                                        <dt class="col-5">Route Name:</dt>
                                        <dd class="col-7" id="detailRouteName"></dd>
                                        <dt class="col-5">From:</dt>
                                        <dd class="col-7" id="detailDeparture"></dd>
                                        <dt class="col-5">To:</dt>
                                        <dd class="col-7" id="detailDestination"></dd>
                                        <dt class="col-5">Distance:</dt>
                                        <dd class="col-7" id="detailDistance"></dd>
                                        <dt class="col-5">Duration:</dt>
                                        <dd class="col-7" id="detailDuration"></dd>
                                        <dt class="col-5">Base Price:</dt>
                                        <dd class="col-7" id="detailPrice"></dd>
                                        <dt class="col-5">Status:</dt>
                                        <dd class="col-7" id="detailStatus"></dd>
                                    </dl>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary"
                                        data-bs-dismiss="modal">Close</button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <%@ include file="/views/partials/footer.jsp" %>
                    <script>
                        function confirmDelete(routeId, routeName) {
                            document.getElementById('routeNameToDelete').textContent = routeName;
                            document.getElementById('confirmDeleteBtn').href =
                                '${pageContext.request.contextPath}/routes/delete?id=' + routeId;
                            new bootstrap.Modal(document.getElementById('deleteModal')).show();
                        }

                        function switchView(view) {
                            const gridView = document.getElementById('routesGrid');
                            const tableView = document.getElementById('routesTable');
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

                        document.addEventListener('DOMContentLoaded', function () {
                            var routeDetailModal = document.getElementById('routeDetailModal');
                            routeDetailModal.addEventListener('show.bs.modal', function (event) {
                                var button = event.relatedTarget;
                                document.getElementById('detailRouteId').textContent = button.getAttribute('data-routeid');
                                document.getElementById('detailRouteName').textContent = button.getAttribute('data-routename');
                                document.getElementById('detailDeparture').textContent = button.getAttribute('data-departure');
                                document.getElementById('detailDestination').textContent = button.getAttribute('data-destination');
                                document.getElementById('detailDistance').textContent = button.getAttribute('data-distance') + ' km';
                                document.getElementById('detailDuration').textContent = button.getAttribute('data-duration') + ' hours';
                                document.getElementById('detailPrice').textContent = Number(button.getAttribute('data-price')).toLocaleString('en-US') + ' VND';
                                var status = button.getAttribute('data-status');
                                document.getElementById('detailStatus').innerHTML =
                                    status === 'ACTIVE'
                                        ? '<span class="badge bg-success">Active</span>'
                                        : '<span class="badge bg-secondary">Inactive</span>';
                            });
                        });
                    </script>
            </body>

            </html>

