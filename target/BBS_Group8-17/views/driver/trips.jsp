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
            <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
            <style>
                .trip-card {
                    transition: transform 0.2s ease-in-out;
                }

                .trip-card:hover {
                    transform: translateY(-2px);
                }

                .status-badge {
                    font-size: 0.8em;
                }

                .header-section {
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
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

                        <!-- Trips Grid -->
                        <div class="row" id="tripsContainer">
                            <c:forEach var="trip" items="${trips}">
                                <div class="col-lg-4 col-md-6 mb-4 trip-item" data-status="${trip.status}"
                                    data-date="${trip.departureDate}" data-route="${trip.routeName}">
                                    <div class="card trip-card h-100 shadow-sm">
                                        <div class="card-header bg-primary text-white">
                                            <div class="d-flex justify-content-between align-items-center">
                                                <h6 class="mb-0">
                                                    <i class="fas fa-route me-2"></i>${trip.routeName}
                                                </h6>
                                                <span class="badge status-badge 
                                            <c:choose>
                                                <c:when test=" ${trip.status=='SCHEDULED' }">bg-success
                                                    </c:when>
                                                    <c:when test="${trip.status == 'DEPARTED'}">bg-warning
                                                    </c:when>
                                                    <c:when test="${trip.status == 'ARRIVED'}">bg-info
                                                    </c:when>
                                                    <c:when test="${trip.status == 'CANCELLED'}">bg-danger
                                                    </c:when>
                                                    <c:otherwise>bg-secondary
                                                    </c:otherwise>
                                                    </c:choose>">
                                                    ${trip.status}
                                                </span>
                                            </div>
                                        </div>
                                        <div class="card-body">
                                            <div class="row mb-3">
                                                <div class="col-6">
                                                    <small class="text-muted">Departure</small>
                                                    <div class="fw-bold">${trip.departureDate}</div>
                                                    <div class="text-primary">
                                                        <i class="fas fa-clock me-1"></i>${trip.departureTime}
                                                    </div>
                                                </div>
                                                <div class="col-6">
                                                    <small class="text-muted">Arrival</small>
                                                    <div class="fw-bold text-success">
                                                        <i class="fas fa-clock me-1"></i>${trip.estimatedArrivalTime}
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="mb-3">
                                                <div class="d-flex justify-content-between">
                                                    <span class="text-muted">Bus:</span>
                                                    <span class="fw-bold">${trip.busNumber}</span>
                                                </div>
                                                <div class="d-flex justify-content-between">
                                                    <span class="text-muted">Available Seats:</span>
                                                    <span class="fw-bold text-info">${trip.availableSeats}</span>
                                                </div>
                                            </div>

                                            <div class="mb-3">
                                                <div class="d-flex justify-content-between">
                                                    <span class="text-muted">Route:</span>
                                                    <span class="fw-bold">${trip.departureCity} →
                                                        ${trip.destinationCity}</span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="card-footer bg-light">
                                            <div class="btn-group w-100" role="group">
                                                <a href="${pageContext.request.contextPath}/driver/passengers?scheduleId=${trip.scheduleId}"
                                                    class="btn btn-outline-info btn-sm">
                                                    <i class="fas fa-users me-1"></i>Passengers
                                                </a>
                                                <a href="${pageContext.request.contextPath}/driver/update-status?scheduleId=${trip.scheduleId}"
                                                    class="btn btn-outline-warning btn-sm">
                                                    <i class="fas fa-edit me-1"></i>Update Status
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>

                        <!-- No Results Message -->
                        <div id="noResults" class="text-center py-5" style="display: none;">
                            <i class="fas fa-route fa-3x text-muted mb-3"></i>
                            <h4 class="text-muted">No trips assigned</h4>
                            <p class="text-muted">You don't have any assigned trips yet</p>
                        </div>
                    </div>
                </div>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
            <script>
                function filterTrips() {
                    const searchTerm = document.getElementById('searchInput').value.toLowerCase();
                    const statusFilter = document.getElementById('statusFilter').value;
                    const dateFilter = document.getElementById('dateFilter').value;

                    const tripItems = document.querySelectorAll('.trip-item');
                    let visibleCount = 0;

                    tripItems.forEach(item => {
                        const route = item.dataset.route.toLowerCase();
                        const status = item.dataset.status;
                        const date = item.dataset.date;

                        const matchesSearch = route.includes(searchTerm);
                        const matchesStatus = !statusFilter || status === statusFilter;
                        const matchesDate = !dateFilter || date === dateFilter;

                        if (matchesSearch && matchesStatus && matchesDate) {
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
                    document.getElementById('searchInput').value = '';
                    document.getElementById('statusFilter').value = '';
                    document.getElementById('dateFilter').value = '';
                    filterTrips();
                }
            </script>
        </body>

        </html>