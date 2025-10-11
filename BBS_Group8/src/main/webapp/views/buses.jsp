<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <jsp:include page="/views/partials/head.jsp">
                    <jsp:param name="title" value="Bus Management - Bus Booking System" />
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
                <!-- Navigation -->
                <%@ include file="/views/partials/admin-header.jsp" %>

                    <div class="container mt-4">
                        <!-- Header -->
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h2><i class="fas fa-bus me-2"></i>Bus Management</h2>
                            <div>
                                <a href="${pageContext.request.contextPath}/buses/available"
                                    class="btn btn-outline-success me-2">
                                    <i class="fas fa-check-circle me-1"></i>Available Buses
                                </a>
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
                                <div class="col-md-3">
                                    <label for="busType" class="form-label">Loại xe</label>
                                    <select class="form-select" id="busType">
                                        <option value="">Tất cả</option>
                                        <option value="Xe khách 45 chỗ">Xe khách 45 chỗ</option>
                                        <option value="Xe khách 35 chỗ">Xe khách 35 chỗ</option>
                                        <option value="Xe khách 25 chỗ">Xe khách 25 chỗ</option>
                                    </select>
                                </div>
                                <div class="col-md-3">
                                    <label for="status" class="form-label">Trạng thái</label>
                                    <select class="form-select" id="status">
                                        <option value="">Tất cả</option>
                                        <option value="ACTIVE">Hoạt động</option>
                                        <option value="INACTIVE">Không hoạt động</option>
                                    </select>
                                </div>
                                <div class="col-md-6 d-flex align-items-end">
                                    <button type="button" class="btn btn-outline-primary me-2" onclick="filterBuses()">
                                        <i class="fas fa-filter me-1"></i>Lọc
                                    </button>
                                    <button type="button" class="btn btn-outline-secondary" onclick="resetFilter()">
                                        <i class="fas fa-refresh me-1"></i>Làm mới
                                    </button>
                                </div>
                            </div>
                        </div>

                        <!-- Buses Display -->
                        <c:choose>
                            <c:when test="${empty buses}">
                                <div class="text-center py-5">
                                    <i class="fas fa-bus fa-3x text-muted mb-3"></i>
                                    <h5 class="text-muted">Không có xe nào</h5>
                                    <p class="text-muted">Hãy thêm xe đầu tiên để bắt đầu</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <!-- Grid View -->
                                <div class="row g-4" id="busesGrid">
                                    <c:forEach var="bus" items="${buses}">
                                        <div class="col-md-6 col-lg-4 bus-item" data-type="${bus.busType}"
                                            data-status="${bus.status}"
                                            data-available="${bus.status eq 'ACTIVE' ? 'available' : 'inactive'}">
                                            <div class="card bus-card h-100">
                                                <div class="card-header bg-primary text-white">
                                                    <div class="d-flex justify-content-between align-items-center">
                                                        <h6 class="mb-0">
                                                            <i class="fas fa-bus me-2"></i>${bus.busNumber}
                                                        </h6>
                                                        <c:choose>
                                                            <c:when test="${bus.status eq 'ACTIVE'}">
                                                                <span class="badge bg-success status-badge">Hoạt
                                                                    động</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-secondary status-badge">Không hoạt
                                                                    động</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </div>
                                                <div class="card-body">
                                                    <div class="mb-3">
                                                        <strong>Loại xe:</strong> ${bus.busType}
                                                    </div>
                                                    <div class="mb-3">
                                                        <strong>Biển số:</strong> ${bus.licensePlate}
                                                    </div>
                                                    <div class="mb-3">
                                                        <strong>Tổng ghế:</strong> ${bus.totalSeats} ghế
                                                    </div>
                                                </div>
                                                <div class="card-footer bg-transparent">
                                                    <div class="d-flex justify-content-between">
                                                        <a href="javascript:void(0);"
                                                            class="btn btn-sm btn-info btn-action" title="Xem chi tiết"
                                                            data-bs-toggle="modal" data-bs-target="#busDetailModal"
                                                            data-busid="${bus.busId}" data-busnumber="${bus.busNumber}"
                                                            data-bustype="${bus.busType}"
                                                            data-totalseats="${bus.totalSeats}"
                                                            data-availableseats="${bus.availableSeats}"
                                                            data-drivername="${bus.driverName}"
                                                            data-licenseplate="${bus.licensePlate}"
                                                            data-status="${bus.status}">
                                                            <i class="fas fa-eye"></i>
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/buses/edit?id=${bus.busId}"
                                                            class="btn btn-sm btn-warning btn-action" title="Sửa">
                                                            <i class="fas fa-edit"></i>
                                                        </a>
                                                        <button type="button" class="btn btn-sm btn-danger btn-action"
                                                            onclick="confirmDelete(${bus.busId}, '${bus.busNumber}')"
                                                            title="Xóa">
                                                            <i class="fas fa-trash"></i>
                                                        </button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>

                                <!-- Table View (Hidden by default) -->
                                <div class="table-responsive d-none" id="busesTable">
                                    <table class="table table-hover">
                                        <thead class="table-dark">
                                            <tr>
                                                <th>ID</th>
                                                <th>Số xe</th>
                                                <th>Loại xe</th>
                                                <th>Biển số</th>
                                                <th>Tổng ghế</th>
                                                <th>Trạng thái</th>
                                                <th>Thao tác</th>
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
                                                        <span class="text-primary">${bus.totalSeats}</span> ghế
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${bus.status eq 'ACTIVE'}">
                                                                <span class="badge bg-success">Hoạt động</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-secondary">Không hoạt động</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <a href="javascript:void(0);"
                                                            class="btn btn-sm btn-info btn-action" title="Xem chi tiết"
                                                            data-bs-toggle="modal" data-bs-target="#busDetailModal"
                                                            data-busid="${bus.busId}" data-busnumber="${bus.busNumber}"
                                                            data-bustype="${bus.busType}"
                                                            data-totalseats="${bus.totalSeats}"
                                                            data-licenseplate="${bus.licensePlate}"
                                                            data-status="${bus.status}">
                                                            <i class="fas fa-eye"></i>
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/buses/edit?id=${bus.busId}"
                                                            class="btn btn-sm btn-warning btn-action" title="Sửa">
                                                            <i class="fas fa-edit"></i>
                                                        </a>
                                                        <button type="button" class="btn btn-sm btn-danger btn-action"
                                                            onclick="confirmDelete(${bus.busId}, '${bus.busNumber}')"
                                                            title="Xóa">
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
                                    <h5 class="modal-title">Xác nhận xóa</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                </div>
                                <div class="modal-body">
                                    <p>Bạn có chắc chắn muốn xóa xe <strong id="busNumberToDelete"></strong>?</p>
                                    <p class="text-danger"><small>Hành động này không thể hoàn tác.</small></p>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                                    <a href="#" id="confirmDeleteBtn" class="btn btn-danger">Xóa</a>
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
                                    <h5 class="modal-title" id="busDetailModalLabel"><i class="fas fa-bus me-2"></i>Chi
                                        tiết Xe</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                </div>
                                <div class="modal-body">
                                    <dl class="row">
                                        <dt class="col-5">Mã xe:</dt>
                                        <dd class="col-7" id="detailBusId"></dd>
                                        <dt class="col-5">Số xe:</dt>
                                        <dd class="col-7" id="detailBusNumber"></dd>
                                        <dt class="col-5">Loại xe:</dt>
                                        <dd class="col-7" id="detailBusType"></dd>
                                        <dt class="col-5">Tổng số ghế:</dt>
                                        <dd class="col-7" id="detailTotalSeats"></dd>
                                        <dt class="col-5">Biển số:</dt>
                                        <dd class="col-7" id="detailLicensePlate"></dd>
                                        <dt class="col-5">Trạng thái:</dt>
                                        <dd class="col-7" id="detailStatus"></dd>
                                    </dl>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary"
                                        data-bs-dismiss="modal">Đóng</button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <script>
                        function confirmDelete(busId, busNumber) {
                            document.getElementById('busNumberToDelete').textContent = busNumber;
                            document.getElementById('confirmDeleteBtn').href =
                                '${pageContext.request.contextPath}/buses/delete?id=' + busId;
                            new bootstrap.Modal(document.getElementById('deleteModal')).show();
                        }

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
                            document.getElementById('busType').value = '';
                            document.getElementById('status').value = '';

                            const busItems = document.querySelectorAll('.bus-item');
                            busItems.forEach(item => {
                                item.style.display = 'block';
                            });
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
                                document.getElementById('detailTotalSeats').textContent = button.getAttribute('data-totalseats') + ' ghế';
                                document.getElementById('detailLicensePlate').textContent = button.getAttribute('data-licenseplate');
                                var status = button.getAttribute('data-status');
                                document.getElementById('detailStatus').innerHTML =
                                    status === 'ACTIVE'
                                        ? '<span class="badge bg-success">Hoạt động</span>'
                                        : status === 'INACTIVE'
                                            ? '<span class="badge bg-secondary">Không hoạt động</span>'
                                            : '<span class="badge bg-warning">Bảo trì</span>';
                            });
                        });
                    </script>

                    <script src="${pageContext.request.contextPath}/assets/js/validation.js"></script>
            </body>

            </html>