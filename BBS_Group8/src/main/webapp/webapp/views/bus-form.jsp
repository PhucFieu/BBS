<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>${bus == null ? 'Thêm Xe' : 'Sửa Xe'} - BusTicket System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .form-card {
            background: #fff;
            border-radius: 18px;
            box-shadow: 0 8px 32px rgba(102, 126, 234, 0.08);
            padding: 2.5rem 2rem 2rem 2rem;
            margin-top: 2rem;
            margin-bottom: 2rem;
        }

        .form-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: #fff;
            border-radius: 18px 18px 0 0;
            padding: 1.5rem 2rem;
            margin: -2.5rem -2rem 2rem -2rem;
            box-shadow: 0 4px 16px rgba(102, 126, 234, 0.08);
        }

        .form-label {
            font-weight: 600;
        }

        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.15);
        }

        .btn-gradient {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: #fff;
            border: none;
            border-radius: 25px;
            padding: 0.75rem 2rem;
            font-weight: 600;
            transition: all 0.2s;
        }

        .btn-gradient:hover {
            background: linear-gradient(135deg, #5a6fd8 0%, #6a4190 100%);
            color: #fff;
            transform: translateY(-2px);
            box-shadow: 0 4px 16px rgba(102, 126, 234, 0.12);
        }

        .section-title {
            font-size: 1.1rem;
            font-weight: 600;
            color: #764ba2;
            margin-bottom: 1rem;
            margin-top: 1.5rem;
        }

        @media (max-width: 576px) {
            .form-card, .form-header {
                padding: 1rem !important;
            }
        }
    </style>
</head>
<body class="bg-light">
<div class="container">
    <div class="row justify-content-center">
        <div class="col-lg-7 col-md-9">
            <div class="form-card">
                <div class="form-header d-flex align-items-center gap-2">
                    <i class="fas fa-bus fa-2x me-2"></i>
                    <div>
                        <h4 class="mb-0">${bus == null ? 'Thêm Xe Mới' : 'Sửa Thông Tin Xe'}</h4>
                        <small>Quản lý thông tin xe khách</small>
                    </div>
                </div>
                <form action="${pageContext.request.contextPath}/buses/${bus == null ? 'add' : 'edit'}"
                      method="post" id="busForm" autocomplete="off">
                    <c:if test="${bus != null}">
                        <input type="hidden" name="busId" value="${bus.busId}">
                    </c:if>
                    <!-- Basic Information -->
                    <div class="section-title"><i class="fas fa-info-circle me-1"></i>Thông tin cơ bản</div>
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label for="busNumber" class="form-label">Số xe *</label>
                            <input type="text" class="form-control" id="busNumber" name="busNumber"
                                   value="${bus.busNumber}" placeholder="VD: B001" required>
                            <div class="form-text">Số hiệu xe duy nhất</div>
                        </div>
                        <div class="col-md-6">
                            <label for="busType" class="form-label">Loại xe *</label>
                            <select class="form-select" id="busType" name="busType" required>
                                <option value="">Chọn loại xe</option>
                                <option value="Xe khách 45 chỗ" ${bus.busType eq 'Xe khách 45 chỗ' ? 'selected' : '' }>
                                    Xe khách 45 chỗ
                                </option>
                                <option value="Xe khách 35 chỗ" ${bus.busType eq 'Xe khách 35 chỗ' ? 'selected' : '' }>
                                    Xe khách 35 chỗ
                                </option>
                                <option value="Xe khách 25 chỗ" ${bus.busType eq 'Xe khách 25 chỗ' ? 'selected' : '' }>
                                    Xe khách 25 chỗ
                                </option>
                                <option value="Xe khách 16 chỗ" ${bus.busType eq 'Xe khách 16 chỗ' ? 'selected' : '' }>
                                    Xe khách 16 chỗ
                                </option>
                            </select>
                        </div>
                    </div>
                    <div class="row g-3 mt-2">
                        <div class="col-md-6">
                            <label for="totalSeats" class="form-label">Tổng số ghế *</label>
                            <input type="number" class="form-control" id="totalSeats" name="totalSeats"
                                   value="${bus.totalSeats}" min="1" max="100" required>
                        </div>
                        <c:if test="${bus != null}">
                            <div class="col-md-6">
                                <label for="availableSeats" class="form-label">Ghế khả dụng</label>
                                <input type="number" class="form-control" id="availableSeats"
                                       name="availableSeats" value="${bus.availableSeats}" min="0"
                                       max="${bus.totalSeats}">
                            </div>
                        </c:if>
                    </div>
                    <!-- Driver Information -->
                    <div class="section-title"><i class="fas fa-user-tie me-1"></i>Thông tin tài xế</div>
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label for="driverName" class="form-label">Tên tài xế *</label>
                            <input type="text" class="form-control" id="driverName" name="driverName"
                                   value="${bus.driverName}" placeholder="Nhập tên tài xế" required>
                        </div>
                        <div class="col-md-6">
                            <label for="licensePlate" class="form-label">Biển số xe *</label>
                            <input type="text" class="form-control" id="licensePlate" name="licensePlate"
                                   value="${bus.licensePlate}" placeholder="VD: 51A-12345" required>
                            <div class="form-text">Định dạng: XX-XXXXX hoặc XX-XXXX</div>
                        </div>
                    </div>
                    <!-- Additional Information -->
                    <div class="section-title"><i class="fas fa-cogs me-1"></i>Thông tin bổ sung</div>
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label for="status" class="form-label">Trạng thái</label>
                            <select class="form-select" id="status" name="status">
                                <option value="ACTIVE" ${bus.status eq 'ACTIVE' ? 'selected' : '' }>Hoạt động</option>
                                <option value="INACTIVE" ${bus.status eq 'INACTIVE' ? 'selected' : '' }>Không hoạt
                                    động
                                </option>
                                <option value="MAINTENANCE" ${bus.status eq 'MAINTENANCE' ? 'selected' : '' }>Bảo trì
                                </option>
                            </select>
                        </div>
                    </div>
                    <!-- Form Actions -->
                    <div class="d-flex justify-content-between align-items-center mt-4">
                        <a href="${pageContext.request.contextPath}/buses" class="btn btn-outline-secondary">
                            <i class="fas fa-arrow-left me-2"></i>Quay lại
                        </a>
                        <button type="submit" class="btn btn-gradient">
                            <i class="fas fa-save me-2"></i>${bus == null ? 'Thêm Xe' : 'Cập nhật'}
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Auto-calculate total seats based on bus type
    document.getElementById('busType').addEventListener('change', function () {
        const busType = this.value;
        const totalSeatsInput = document.getElementById('totalSeats');
        switch (busType) {
            case 'Xe khách 45 chỗ':
                totalSeatsInput.value = 45;
                break;
            case 'Xe khách 35 chỗ':
                totalSeatsInput.value = 35;
                break;
            case 'Xe khách 25 chỗ':
                totalSeatsInput.value = 25;
                break;
            case 'Xe khách 16 chỗ':
                totalSeatsInput.value = 16;
                break;
            default:
                totalSeatsInput.value = '';
        }
    });
    // License plate validation
    document.getElementById('licensePlate').addEventListener('input', function () {
        this.value = this.value.toUpperCase();
    });
    // Form validation
    document.getElementById('busForm').addEventListener('submit', function (e) {
        const busNumber = document.getElementById('busNumber').value.trim();
        const busType = document.getElementById('busType').value;
        const totalSeats = document.getElementById('totalSeats').value;
        const driverName = document.getElementById('driverName').value.trim();
        const licensePlate = document.getElementById('licensePlate').value.trim();
        if (busNumber.length < 2) {
            e.preventDefault();
            alert('Số xe phải có ít nhất 2 ký tự');
            document.getElementById('busNumber').focus();
            return false;
        }
        if (!busType) {
            e.preventDefault();
            alert('Vui lòng chọn loại xe');
            document.getElementById('busType').focus();
            return false;
        }
        if (totalSeats < 1 || totalSeats > 100) {
            e.preventDefault();
            alert('Tổng số ghế phải từ 1 đến 100');
            document.getElementById('totalSeats').focus();
            return false;
        }
        if (driverName.length < 2) {
            e.preventDefault();
            alert('Tên tài xế phải có ít nhất 2 ký tự');
            document.getElementById('driverName').focus();
            return false;
        }
        const licensePlateRegex = /^[0-9]{2}[A-Z]-[0-9]{4,5}$/;
        if (!licensePlateRegex.test(licensePlate)) {
            e.preventDefault();
            alert('Biển số xe không hợp lệ. Định dạng: XX-XXXXX hoặc XX-XXXX');
            document.getElementById('licensePlate').focus();
            return false;
        }
    });
    // Auto focus on first field
    document.addEventListener('DOMContentLoaded', function () {
        document.getElementById('busNumber').focus();
    });
</script>

<script src="${pageContext.request.contextPath}/assets/js/validation.js"></script>
</body>
</html>
