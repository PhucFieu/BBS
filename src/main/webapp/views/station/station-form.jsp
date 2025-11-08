<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <title>${station == null ? 'Thêm Trạm xe' : 'Sửa Trạm xe'} - BusTicket System</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
            <link href="${pageContext.request.contextPath}/assets/css/station-form.css" rel="stylesheet">
        </head>

        <body>
            <%@ include file="/views/partials/admin-header.jsp" %>

                <div class="container">
                    <div class="row justify-content-center">
                        <div class="col-lg-8">
                            <div class="form-card">
                                <div class="form-header text-center">
                                    <h3 class="mb-0">
                                        <i class="fas fa-map-marker-alt me-2"></i>
                                        ${station == null ? 'Thêm Trạm xe Mới' : 'Cập nhật Thông tin Trạm xe'}
                                    </h3>
                                    <p class="mb-0 opacity-75">Quản lý thông tin trạm xe</p>
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

                                <form
                                    action="${pageContext.request.contextPath}/stations/${station == null ? 'add' : 'edit'}"
                                    method="post" id="stationForm">
                                    <c:if test="${station != null}">
                                        <input type="hidden" name="stationId" value="${station.stationId}">
                                    </c:if>

                                    <!-- Station Information -->
                                    <div class="section-title"><i class="fas fa-info-circle me-1"></i>Thông tin cơ bản
                                    </div>
                                    <div class="row g-3">
                                        <div class="col-md-6">
                                            <label for="stationName" class="form-label">Tên trạm *</label>
                                            <input type="text" class="form-control" id="stationName" name="stationName"
                                                value="${station.stationName}" required maxlength="100"
                                                placeholder="VD: Bến xe Mỹ Đình">
                                        </div>
                                        <div class="col-md-6">
                                            <label for="city" class="form-label">Thành phố *</label>
                                            <input type="text" class="form-control" id="city" name="city"
                                                value="${station.city}" required maxlength="50"
                                                placeholder="VD: Hà Nội">
                                        </div>
                                    </div>
                                    <div class="row g-3 mt-2">
                                        <div class="col-12">
                                            <label for="address" class="form-label">Địa chỉ *</label>
                                            <textarea class="form-control" id="address" name="address" rows="3" required
                                                maxlength="200"
                                                placeholder="VD: 20 Phạm Hùng, Nam Từ Liêm, Hà Nội">${station.address}</textarea>
                                        </div>
                                    </div>

                                    <!-- Status -->
                                    <div class="section-title"><i class="fas fa-cogs me-1"></i>Trạng thái</div>
                                    <div class="row g-3">
                                        <div class="col-md-6">
                                            <label for="status" class="form-label">Trạng thái</label>
                                            <select class="form-select" id="status" name="status">
                                                <option value="ACTIVE" ${station==null || station.status eq 'ACTIVE'
                                                    ? 'selected' : '' }>Hoạt động</option>
                                                <option value="INACTIVE" ${station !=null && station.status
                                                    eq 'INACTIVE' ? 'selected' : '' }>Không hoạt động</option>
                                            </select>
                                        </div>
                                    </div>

                                    <div class="d-flex justify-content-between align-items-center mt-4">
                                        <a href="${pageContext.request.contextPath}/stations"
                                            class="btn btn-outline-secondary">
                                            <i class="fas fa-arrow-left me-2"></i>Quay lại
                                        </a>
                                        <button type="submit" class="btn btn-gradient">
                                            <i class="fas fa-save me-2"></i>
                                            ${station == null ? 'Thêm Trạm xe' : 'Cập nhật'}
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                <script src="${pageContext.request.contextPath}/assets/js/station-form.js"></script>
        </body>

        </html>