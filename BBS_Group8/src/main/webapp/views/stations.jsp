<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <jsp:include page="/views/partials/head.jsp">
                <jsp:param name="title" value="Station Management - BusTicket System" />
            </jsp:include>
            <style>
                .station-card {
                    transition: transform 0.2s ease;
                    border: none;
                    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                }

                .station-card:hover {
                    transform: translateY(-2px);
                    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
                }

                .search-form {
                    background: #f8f9fa;
                    padding: 20px;
                    border-radius: 8px;
                    margin-bottom: 20px;
                }

                .station-icon {
                    width: 60px;
                    height: 60px;
                    border-radius: 50%;
                    background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    color: white;
                    font-size: 1.5rem;
                }
            </style>
        </head>

        <body>
            <%@ include file="/views/partials/admin-header.jsp" %>

                <div class="container mt-4">
                    <!-- Header -->
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h2><i class="fas fa-map-marker-alt me-2"></i>Station Management</h2>
                        <a href="${pageContext.request.contextPath}/stations/add" class="btn btn-primary">
                            <i class="fas fa-plus me-1"></i>Add Station
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
                        <form action="${pageContext.request.contextPath}/stations/search" method="get" class="row g-3">
                            <div class="col-md-4">
                                <label for="keyword" class="form-label">Search</label>
                                <div class="input-group">
                                    <span class="input-group-text">
                                        <i class="fas fa-search"></i>
                                    </span>
                                    <input type="text" class="form-control" id="keyword" name="keyword"
                                        value="${searchKeyword}" placeholder="Station name, city, address...">
                                </div>
                            </div>
                            <div class="col-md-3">
                                <label for="city" class="form-label">City</label>
                                <input type="text" class="form-control" id="city" name="city" value="${param.city}"
                                    placeholder="E.g: Hanoi">
                            </div>
                            <div class="col-md-3">
                                <label for="status" class="form-label">Status</label>
                                <select class="form-select" id="status" name="status">
                                    <option value="">All</option>
                                    <option value="ACTIVE" ${param.status eq 'ACTIVE' ? 'selected' : '' }>Active
                                    </option>
                                    <option value="INACTIVE" ${param.status eq 'INACTIVE' ? 'selected' : '' }>Inactive
                                        động</option>
                                </select>
                            </div>
                            <div class="col-md-2 d-flex align-items-end">
                                <button type="submit" class="btn btn-outline-primary me-2">
                                    <i class="fas fa-search me-1"></i>Tìm kiếm
                                </button>
                                <a href="${pageContext.request.contextPath}/stations" class="btn btn-outline-secondary">
                                    <i class="fas fa-refresh me-1"></i>Làm mới
                                </a>
                            </div>
                        </form>
                    </div>

                    <!-- Stations Display -->
                    <c:choose>
                        <c:when test="${empty stations}">
                            <div class="text-center py-5">
                                <i class="fas fa-map-marker-alt fa-3x text-muted mb-3"></i>
                                <h5 class="text-muted">Không có trạm xe nào</h5>
                                <p class="text-muted">Hãy thêm trạm xe đầu tiên để bắt đầu</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <!-- Grid View -->
                            <div class="row g-4" id="stationsGrid">
                                <c:forEach var="station" items="${stations}">
                                    <div class="col-md-6 col-lg-4">
                                        <div class="card station-card h-100">
                                            <div class="card-body">
                                                <div class="d-flex align-items-center mb-3">
                                                    <div class="station-icon me-3">
                                                        <i class="fas fa-building"></i>
                                                    </div>
                                                    <div>
                                                        <h6 class="mb-1">${station.stationName}</h6>
                                                        <span class="badge bg-secondary">${station.city}</span>
                                                        <c:choose>
                                                            <c:when test="${station.status eq 'ACTIVE'}">
                                                                <span class="badge bg-success ms-1">Hoạt động</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-secondary ms-1">Không hoạt
                                                                    động</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </div>

                                                <div class="mb-2">
                                                    <i class="fas fa-map-marker-alt me-2 text-primary"></i>
                                                    <span>${station.address}</span>
                                                </div>
                                                <div class="mb-2">
                                                    <i class="fas fa-city me-2 text-info"></i>
                                                    <span>${station.city}</span>
                                                </div>
                                            </div>
                                            <div class="card-footer bg-transparent">
                                                <div class="d-flex justify-content-between">
                                                    <a href="${pageContext.request.contextPath}/stations/${station.stationId}"
                                                        class="btn btn-sm btn-info btn-action" title="Xem chi tiết">
                                                        <i class="fas fa-eye"></i>
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/stations/edit?id=${station.stationId}"
                                                        class="btn btn-sm btn-warning btn-action" title="Sửa">
                                                        <i class="fas fa-edit"></i>
                                                    </a>
                                                    <button type="button" class="btn btn-sm btn-danger btn-action"
                                                        onclick="confirmDelete('${station.stationId}', '${station.stationName}')"
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
                            <div class="table-responsive d-none" id="stationsTable">
                                <table class="table table-hover">
                                    <thead class="table-dark">
                                        <tr>
                                            <th>ID</th>
                                            <th>Tên trạm</th>
                                            <th>Thành phố</th>
                                            <th>Địa chỉ</th>
                                            <th>Trạng thái</th>
                                            <th>Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="station" items="${stations}">
                                            <tr>
                                                <td>${station.stationId}</td>
                                                <td><strong>${station.stationName}</strong></td>
                                                <td>${station.city}</td>
                                                <td>${station.address}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${station.status eq 'ACTIVE'}">
                                                            <span class="badge bg-success">Hoạt động</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-secondary">Không hoạt động</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <a href="${pageContext.request.contextPath}/stations/${station.stationId}"
                                                        class="btn btn-sm btn-info btn-action" title="Xem chi tiết">
                                                        <i class="fas fa-eye"></i>
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/stations/edit?id=${station.stationId}"
                                                        class="btn btn-sm btn-warning btn-action" title="Sửa">
                                                        <i class="fas fa-edit"></i>
                                                    </a>
                                                    <button type="button" class="btn btn-sm btn-danger btn-action"
                                                        onclick="confirmDelete('${station.stationId}', '${station.stationName}')"
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
                                <h5 class="modal-title">Xác nhận xóa</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                            </div>
                            <div class="modal-body">
                                <p>Bạn có chắc chắn muốn xóa trạm xe <strong id="stationNameToDelete"></strong>?</p>
                                <p class="text-danger"><small>Hành động này không thể hoàn tác.</small></p>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                                <a href="#" id="confirmDeleteBtn" class="btn btn-danger">Xóa</a>
                            </div>
                        </div>
                    </div>
                </div>

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
                <script>
                    function confirmDelete(stationId, stationName) {
                        document.getElementById('stationNameToDelete').textContent = stationName;
                        document.getElementById('confirmDeleteBtn').href =
                            '${pageContext.request.contextPath}/stations/delete?id=' + stationId;
                        new bootstrap.Modal(document.getElementById('deleteModal')).show();
                    }

                    function switchView(view) {
                        const gridView = document.getElementById('stationsGrid');
                        const tableView = document.getElementById('stationsTable');
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