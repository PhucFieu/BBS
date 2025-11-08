<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <jsp:include page="/views/partials/head.jsp">
                <jsp:param name="title" value="Bus Management - Admin Panel" />
            </jsp:include>
            <style>
                .bus-card {
                    transition: transform 0.2s ease;
                    border: none;
                    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                }

                .bus-card:hover {
                    transform: translateY(-2px);
                    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
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
                        <h2><i class="fas fa-bus me-2"></i>Bus Management</h2>
                        <div>
                            <a href="${pageContext.request.contextPath}/buses/add" class="btn btn-primary">
                                <i class="fas fa-plus me-1"></i>Add Bus
                            </a>
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

                    <!-- Filter Section -->
                    <div class="search-form">
                        <div class="row g-3">
                            <div class="col-md-4">
                                <label for="searchTerm" class="form-label">Search Buses</label>
                                <input type="text" class="form-control" id="searchTerm"
                                    placeholder="Search by bus number, type, or license plate...">
                            </div>
                            <div class="col-md-2">
                                <label for="busType" class="form-label">Bus Type</label>
                                <select class="form-select" id="busType">
                                    <option value="">All</option>
                                    <option value="45-seat Bus">45-seat Bus</option>
                                    <option value="35-seat Bus">35-seat Bus</option>
                                    <option value="25-seat Bus">25-seat Bus</option>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <label for="status" class="form-label">Status</label>
                                <select class="form-select" id="status">
                                    <option value="">All</option>
                                    <option value="ACTIVE">Active</option>
                                    <option value="INACTIVE">Inactive</option>
                                </select>
                            </div>
                            <div class="col-md-4 d-flex align-items-end">
                                <button type="button" class="btn btn-outline-primary me-2" onclick="searchBuses()">
                                    <i class="fas fa-search me-1"></i>Search
                                </button>
                                <button type="button" class="btn btn-outline-secondary me-2" onclick="filterBuses()">
                                    <i class="fas fa-filter me-1"></i>Filter
                                </button>
                                <button type="button" class="btn btn-outline-secondary" onclick="resetFilter()">
                                    <i class="fas fa-refresh me-1"></i>Reset
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- Buses Display -->
                    <c:choose>
                        <c:when test="${empty buses}">
                            <div class="text-center py-5">
                                <i class="fas fa-bus fa-3x text-muted mb-3"></i>
                                <h5 class="text-muted">No buses found</h5>
                                <p class="text-muted">Add the first bus to get started</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <!-- Grid View (Hidden by default) -->
                            <div class="row g-4 d-none" id="busesGrid">
                                <c:forEach var="bus" items="${buses}">
                                    <div class="col-md-6 col-lg-4 bus-item" data-type="${bus.busType}"
                                        data-status="${bus.status}">
                                        <div class="card bus-card h-100">
                                            <div class="card-header bg-primary text-white">
                                                <div class="d-flex justify-content-between align-items-center">
                                                    <h6 class="mb-0">
                                                        <i class="fas fa-bus me-2"></i>${bus.busNumber}
                                                    </h6>
                                                    <c:choose>
                                                        <c:when test="${bus.status eq 'ACTIVE'}">
                                                            <span class="badge bg-success status-badge">Active</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span
                                                                class="badge bg-secondary status-badge">Inactive</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                            <div class="card-body">
                                                <div class="mb-3">
                                                    <strong>Type:</strong> ${bus.busType}
                                                </div>
                                                <div class="mb-3">
                                                    <strong>License Plate:</strong> ${bus.licensePlate}
                                                </div>
                                                <div class="mb-3">
                                                    <strong>Total Seats:</strong> ${bus.totalSeats} seats
                                                </div>
                                            </div>
                                            <div class="card-footer bg-transparent">
                                                <div class="d-flex justify-content-between">
                                                    <a href="javascript:void(0);" class="btn btn-sm btn-info btn-action"
                                                        title="View Details" data-bs-toggle="modal"
                                                        data-bs-target="#busDetailModal" data-busid="${bus.busId}"
                                                        data-busnumber="${bus.busNumber}" data-bustype="${bus.busType}"
                                                        data-totalseats="${bus.totalSeats}"
                                                        data-licenseplate="${bus.licensePlate}"
                                                        data-status="${bus.status}">
                                                        <i class="fas fa-eye"></i>
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/buses/edit?id=${bus.busId}"
                                                        class="btn btn-sm btn-warning btn-action" title="Edit">
                                                        <i class="fas fa-edit"></i>
                                                    </a>
                                                    <button type="button" class="btn btn-sm btn-danger btn-action"
                                                        onclick="confirmDelete('${bus.busId}', '${bus.busNumber}')"
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
                            <div class="table-responsive" id="busesTable">
                                <table class="table table-hover">
                                    <thead class="table-dark">
                                        <tr>
                                            <th>ID</th>
                                            <th>Bus Number</th>
                                            <th>Type</th>
                                            <th>License Plate</th>
                                            <th>Total Seats</th>
                                            <th>Status</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="bus" items="${buses}">
                                            <tr>
                                                <td>${bus.busId}</td>
                                                <td><strong>${bus.busNumber}</strong></td>
                                                <td>${bus.busType}</td>
                                                <td>${bus.licensePlate}</td>
                                                <td>
                                                    <span class="text-primary">${bus.totalSeats}</span> seats
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${bus.status eq 'ACTIVE'}">
                                                            <span class="badge bg-success">Active</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-secondary">Inactive</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <a href="javascript:void(0);" class="btn btn-sm btn-info btn-action"
                                                        title="View Details" data-bs-toggle="modal"
                                                        data-bs-target="#busDetailModal" data-busid="${bus.busId}"
                                                        data-busnumber="${bus.busNumber}" data-bustype="${bus.busType}"
                                                        data-licenseplate="${bus.licensePlate}"
                                                        data-status="${bus.status}">
                                                        <i class="fas fa-eye"></i>
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/buses/edit?id=${bus.busId}"
                                                        class="btn btn-sm btn-warning btn-action" title="Edit">
                                                        <i class="fas fa-edit"></i>
                                                    </a>
                                                    <button type="button" class="btn btn-sm btn-danger btn-action"
                                                        onclick="confirmDelete('${bus.busId}', '${bus.busNumber}')"
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
                                    <button type="button" class="btn btn-outline-primary active" onclick="switchView('table')">
                                        <i class="fas fa-table me-1"></i>Table
                                    </button>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
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
                                    <i class="fas fa-bus fa-3x text-danger mb-3"></i>
                                </div>
                                <p class="text-center mb-3">Are you sure you want to delete bus <strong
                                        id="busNumberToDelete" class="text-danger"></strong>?</p>
                                <div class="alert alert-warning" role="alert">
                                    <i class="fas fa-exclamation-triangle me-2"></i>
                                    <strong>Warning:</strong> This action cannot be undone. The bus will be permanently
                                    removed from the system.
                                </div>
                                <div class="alert alert-info" role="alert">
                                    <i class="fas fa-info-circle me-2"></i>
                                    <strong>Note:</strong> If this bus is currently assigned to active schedules, the
                                    deletion will be prevented.
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                                    <i class="fas fa-times me-1"></i>Cancel
                                </button>
                                <button type="button" id="confirmDeleteBtn" class="btn btn-danger">
                                    <i class="fas fa-trash me-1"></i>Delete Bus
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Bus Detail Modal -->
                <div class="modal fade" id="busDetailModal" tabindex="-1" aria-labelledby="busDetailModalLabel"
                    aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header bg-primary text-white">
                                <h5 class="modal-title" id="busDetailModalLabel"><i class="fas fa-bus me-2"></i>Bus
                                    Details</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                            </div>
                            <div class="modal-body">
                                <dl class="row">
                                    <dt class="col-5">Bus ID:</dt>
                                    <dd class="col-7" id="detailBusId"></dd>
                                    <dt class="col-5">Bus Number:</dt>
                                    <dd class="col-7" id="detailBusNumber"></dd>
                                    <dt class="col-5">Type:</dt>
                                    <dd class="col-7" id="detailBusType"></dd>
                                    <dt class="col-5">Total Seats:</dt>
                                    <dd class="col-7" id="detailTotalSeats"></dd>
                                    <dt class="col-5">License Plate:</dt>
                                    <dd class="col-7" id="detailLicensePlate"></dd>
                                    <dt class="col-5">Status:</dt>
                                    <dd class="col-7" id="detailStatus"></dd>
                                </dl>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                            </div>
                        </div>
                    </div>
                </div>

                <script>
                    let currentBusId = null;
                    let currentBusNumber = null;

                    function confirmDelete(busId, busNumber) {
                        console.log('Preparing to delete bus:', busId, busNumber);

                        // Store current bus info
                        currentBusId = busId;
                        currentBusNumber = busNumber;

                        // Set the bus number in the modal
                        const busNumberElement = document.getElementById('busNumberToDelete');
                        if (busNumberElement) {
                            busNumberElement.textContent = busNumber;
                        }

                        // Show the modal
                        const deleteModalElement = document.getElementById('deleteModal');
                        if (deleteModalElement) {
                            const deleteModal = new bootstrap.Modal(deleteModalElement);
                            deleteModal.show();
                        }
                    }

                    function performDelete() {
                        if (!currentBusId) {
                            console.error('No bus ID available for deletion');
                            return;
                        }

                        console.log('Performing delete for bus:', currentBusId);

                        // Show loading state
                        const confirmBtn = document.getElementById('confirmDeleteBtn');
                        const originalText = confirmBtn.innerHTML;
                        confirmBtn.disabled = true;
                        confirmBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Deleting...';

                        // Create form and submit
                        const form = document.createElement('form');
                        form.method = 'GET';
                        form.action = '${pageContext.request.contextPath}/buses/delete';

                        const idInput = document.createElement('input');
                        idInput.type = 'hidden';
                        idInput.name = 'id';
                        idInput.value = currentBusId;

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
                    });

                    function filterBuses() {
                        const busType = document.getElementById('busType').value;
                        const status = document.getElementById('status').value;

                        const busItems = document.querySelectorAll('.bus-item');

                        busItems.forEach(item => {
                            let show = true;

                            if (busType && item.dataset.type !== busType) show = false;
                            if (status && item.dataset.status !== status) show = false;

                            item.style.display = show ? 'block' : 'none';
                        });
                    }

                    function resetFilter() {
                        document.getElementById('searchTerm').value = '';
                        document.getElementById('busType').value = '';
                        document.getElementById('status').value = '';

                        const busItems = document.querySelectorAll('.bus-item');
                        busItems.forEach(item => {
                            item.style.display = 'block';
                        });
                    }

                    function searchBuses() {
                        const searchTerm = document.getElementById('searchTerm').value.trim();

                        if (searchTerm.length < 2) {
                            alert('Please enter at least 2 characters to search.');
                            return;
                        }

                        // Show loading state
                        const searchBtn = event.target;
                        const originalText = searchBtn.innerHTML;
                        searchBtn.disabled = true;
                        searchBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Searching...';

                        // Make AJAX request to search buses
                        fetch('${pageContext.request.contextPath}/admin/buses/search?search=' + encodeURIComponent(searchTerm))
                            .then(response => response.json())
                            .then(data => {
                                displaySearchResults(data);
                            })
                            .catch(error => {
                                console.error('Error searching buses:', error);
                                alert('Error searching buses. Please try again.');
                            })
                            .finally(() => {
                                // Restore button state
                                searchBtn.disabled = false;
                                searchBtn.innerHTML = originalText;
                            });
                    }

                    function displaySearchResults(buses) {
                        const busesGrid = document.getElementById('busesGrid');
                        const busesTable = document.getElementById('busesTable');

                        if (buses.length === 0) {
                            busesGrid.innerHTML = `
                                <div class="col-12">
                                    <div class="text-center py-5">
                                        <i class="fas fa-search fa-3x text-muted mb-3"></i>
                                        <h5 class="text-muted">No buses found</h5>
                                        <p class="text-muted">Try adjusting your search criteria</p>
                                    </div>
                                </div>
                            `;
                            busesTable.querySelector('tbody').innerHTML = `
                                <tr>
                                    <td colspan="7" class="text-center py-5">
                                        <i class="fas fa-search fa-3x text-muted mb-3"></i>
                                        <h5 class="text-muted">No buses found</h5>
                                        <p class="text-muted">Try adjusting your search criteria</p>
                                    </td>
                                </tr>
                            `;
                            return;
                        }

                        // Update grid view
                        busesGrid.innerHTML = buses.map(bus => `
                            <div class="col-md-6 col-lg-4 bus-item" data-type="\${bus.busType}" data-status="\${bus.status}">
                                <div class="card bus-card h-100">
                                    <div class="card-header bg-primary text-white">
                                        <div class="d-flex justify-content-between align-items-center">
                                            <h6 class="mb-0">
                                                <i class="fas fa-bus me-2"></i>\${bus.busNumber}
                                            </h6>
                                            <span class="badge \${bus.status === 'ACTIVE' ? 'bg-success' : 'bg-secondary'} status-badge">
                                                \${bus.status === 'ACTIVE' ? 'Active' : 'Inactive'}
                                            </span>
                                        </div>
                                    </div>
                                    <div class="card-body">
                                        <div class="mb-3">
                                            <strong>Type:</strong> \${bus.busType}
                                        </div>
                                        <div class="mb-3">
                                            <strong>License Plate:</strong> \${bus.licensePlate}
                                        </div>
                                        <div class="mb-3">
                                            <strong>Total Seats:</strong> \${bus.totalSeats} seats
                                        </div>
                                    </div>
                                    <div class="card-footer bg-transparent">
                                        <div class="d-flex justify-content-between">
                                            <a href="javascript:void(0);" class="btn btn-sm btn-info btn-action"
                                                title="View Details" data-bs-toggle="modal"
                                                data-bs-target="#busDetailModal" data-busid="\${bus.busId}"
                                                data-busnumber="\${bus.busNumber}" data-bustype="\${bus.busType}"
                                                data-totalseats="\${bus.totalSeats}"
                                                data-licenseplate="\${bus.licensePlate}"
                                                data-status="\${bus.status}">
                                                <i class="fas fa-eye"></i>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/buses/edit?id=\${bus.busId}"
                                                class="btn btn-sm btn-warning btn-action" title="Edit">
                                                <i class="fas fa-edit"></i>
                                            </a>
                                            <button type="button" class="btn btn-sm btn-danger btn-action"
                                                onclick="confirmDelete('\${bus.busId}', '\${bus.busNumber}')"
                                                title="Delete">
                                                <i class="fas fa-trash"></i>
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        `).join('');

                        // Update table view
                        busesTable.querySelector('tbody').innerHTML = buses.map(bus => `
                            <tr>
                                <td>\${bus.busId}</td>
                                <td><strong>\${bus.busNumber}</strong></td>
                                <td>\${bus.busType}</td>
                                <td>\${bus.licensePlate}</td>
                                <td>
                                    <span class="text-primary">\${bus.totalSeats}</span> seats
                                </td>
                                <td>
                                    <span class="badge \${bus.status === 'ACTIVE' ? 'bg-success' : 'bg-secondary'}">
                                        \${bus.status === 'ACTIVE' ? 'Active' : 'Inactive'}
                                    </span>
                                </td>
                                <td>
                                    <a href="javascript:void(0);" class="btn btn-sm btn-info btn-action"
                                        title="View Details" data-bs-toggle="modal"
                                        data-bs-target="#busDetailModal" data-busid="\${bus.busId}"
                                        data-busnumber="\${bus.busNumber}" data-bustype="\${bus.busType}"
                                        data-licenseplate="\${bus.licensePlate}"
                                        data-status="\${bus.status}">
                                        <i class="fas fa-eye"></i>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/buses/edit?id=\${bus.busId}"
                                        class="btn btn-sm btn-warning btn-action" title="Edit">
                                        <i class="fas fa-edit"></i>
                                    </a>
                                    <button type="button" class="btn btn-sm btn-danger btn-action"
                                        onclick="confirmDelete('\${bus.busId}', '\${bus.busNumber}')"
                                        title="Delete">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                </td>
                            </tr>
                        `).join('');
                    }

                    function switchView(view) {
                        const gridView = document.getElementById('busesGrid');
                        const tableView = document.getElementById('busesTable');
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
                        var busDetailModal = document.getElementById('busDetailModal');
                        busDetailModal.addEventListener('show.bs.modal', function (event) {
                            var button = event.relatedTarget;
                            document.getElementById('detailBusId').textContent = button.getAttribute('data-busid');
                            document.getElementById('detailBusNumber').textContent = button.getAttribute('data-busnumber');
                            document.getElementById('detailBusType').textContent = button.getAttribute('data-bustype');
                            document.getElementById('detailTotalSeats').textContent = button.getAttribute('data-totalseats') + ' seats';
                            document.getElementById('detailLicensePlate').textContent = button.getAttribute('data-licenseplate');
                            var status = button.getAttribute('data-status');
                            document.getElementById('detailStatus').innerHTML =
                                status === 'ACTIVE'
                                    ? '<span class="badge bg-success">Active</span>'
                                    : '<span class="badge bg-secondary">Inactive</span>';
                        });
                    });

                    // Add Enter key support for search
                    document.addEventListener('DOMContentLoaded', function () {
                        const searchInput = document.getElementById('searchTerm');
                        if (searchInput) {
                            searchInput.addEventListener('keypress', function (e) {
                                if (e.key === 'Enter') {
                                    searchBuses();
                                }
                            });
                        }
                    });
                </script>

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
                <script src="${pageContext.request.contextPath}/assets/js/validation.js"></script>
        </body>

        </html>