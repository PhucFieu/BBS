<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <jsp:include page="/views/partials/head.jsp">
                <jsp:param name="title" value="Available Buses - Bus Booking System" />
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
            <%@ include file="/views/partials/header.jsp" %>

                <div class="container mt-4">
                    <!-- Header -->
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h2><i class="fas fa-bus me-2"></i>Available Buses</h2>
                        <div>
                            <a href="${pageContext.request.contextPath}/" class="btn btn-outline-primary">
                                <i class="fas fa-home me-1"></i>Home
                            </a>
                        </div>
                    </div>

                    <!-- Filter Section -->
                    <div class="search-form">
                        <div class="row g-3">
                            <div class="col-md-3">
                                <label for="busType" class="form-label">Bus Type</label>
                                <select class="form-select" id="busType">
                                    <option value="">All</option>
                                    <option value="45-seat Bus">45-seat Bus</option>
                                    <option value="35-seat Bus">35-seat Bus</option>
                                    <option value="25-seat Bus">25-seat Bus</option>
                                </select>
                            </div>
                            <div class="col-md-6 d-flex align-items-end">
                                <button type="button" class="btn btn-outline-primary me-2" onclick="filterBuses()">
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
                                <h5 class="text-muted">No buses available</h5>
                                <p class="text-muted">Please check back later for available buses</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <!-- Grid View -->
                            <div class="row g-4" id="busesGrid">
                                <c:forEach var="bus" items="${buses}">
                                    <div class="col-md-6 col-lg-4 bus-item" data-type="${bus.busType}">
                                        <div class="card bus-card h-100">
                                            <div class="card-header bg-primary text-white">
                                                <div class="d-flex justify-content-between align-items-center">
                                                    <h6 class="mb-0">
                                                        <i class="fas fa-bus me-2"></i>${bus.busNumber}
                                                    </h6>
                                                    <span class="badge bg-success">Available</span>
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
                                                <div class="d-flex justify-content-center">
                                                    <a href="javascript:void(0);" class="btn btn-sm btn-info btn-action"
                                                        title="View Details" data-bs-toggle="modal"
                                                        data-bs-target="#busDetailModal" data-busid="${bus.busId}"
                                                        data-busnumber="${bus.busNumber}" data-bustype="${bus.busType}"
                                                        data-totalseats="${bus.totalSeats}"
                                                        data-licenseplate="${bus.licensePlate}">
                                                        <i class="fas fa-eye me-1"></i>View Details
                                                    </a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
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
                                    <dt class="col-5">Bus Number:</dt>
                                    <dd class="col-7" id="detailBusNumber"></dd>
                                    <dt class="col-5">Type:</dt>
                                    <dd class="col-7" id="detailBusType"></dd>
                                    <dt class="col-5">Total Seats:</dt>
                                    <dd class="col-7" id="detailTotalSeats"></dd>
                                    <dt class="col-5">License Plate:</dt>
                                    <dd class="col-7" id="detailLicensePlate"></dd>
                                </dl>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                            </div>
                        </div>
                    </div>
                </div>

                <script>
                    function filterBuses() {
                        const busType = document.getElementById('busType').value;
                        const busItems = document.querySelectorAll('.bus-item');

                        busItems.forEach(item => {
                            let show = true;
                            if (busType && item.dataset.type !== busType) show = false;
                            item.style.display = show ? 'block' : 'none';
                        });
                    }

                    function resetFilter() {
                        document.getElementById('busType').value = '';
                        const busItems = document.querySelectorAll('.bus-item');
                        busItems.forEach(item => {
                            item.style.display = 'block';
                        });
                    }

                    document.addEventListener('DOMContentLoaded', function () {
                        var busDetailModal = document.getElementById('busDetailModal');
                        busDetailModal.addEventListener('show.bs.modal', function (event) {
                            var button = event.relatedTarget;
                            document.getElementById('detailBusNumber').textContent = button.getAttribute('data-busnumber');
                            document.getElementById('detailBusType').textContent = button.getAttribute('data-bustype');
                            document.getElementById('detailTotalSeats').textContent = button.getAttribute('data-totalseats') + ' seats';
                            document.getElementById('detailLicensePlate').textContent = button.getAttribute('data-licenseplate');
                        });
                    });
                </script>

                <%@ include file="/views/partials/footer.jsp" %>
        </body>

        </html>

