<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>${user == null ? 'Add User' : 'Edit User'} - Bus Booking System</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
                <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
                <style>
                    .form-container {
                        max-width: 900px;
                        margin: 0 auto;
                    }

                    .form-section {
                        background: #f8f9fa;
                        padding: 20px;
                        border-radius: 8px;
                        margin-bottom: 20px;
                    }

                    .form-control:focus {
                        border-color: #007bff;
                        box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25);
                    }

                    .btn-submit {
                        background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
                        border: none;
                        padding: 12px 30px;
                        font-weight: 600;
                    }

                    .btn-submit:hover {
                        transform: translateY(-1px);
                        box-shadow: 0 4px 8px rgba(0, 123, 255, 0.3);
                    }

                    .avatar-preview {
                        width: 100px;
                        height: 100px;
                        border-radius: 50%;
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        color: white;
                        font-size: 2rem;
                        font-weight: bold;
                        margin: 0 auto 20px;
                    }
                </style>
            </head>

            <body>
                <!-- Include header with session logic -->
                <jsp:include page="/views/partials/user-header.jsp" />

                <div class="container mt-4">
                    <div class="form-container">
                        <!-- Header -->
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h2>
                                <i class="fas fa-user me-2"></i>
                                ${user == null ? 'Thêm Người dùng Mới' : 'Sửa Thông Tin Người dùng'}
                            </h2>
                            <a href="${pageContext.request.contextPath}/passengers" class="btn btn-outline-secondary">
                                <i class="fas fa-arrow-left me-1"></i>Quay lại
                            </a>
                        </div>

                        <!-- Messages -->
                        <c:if test="${not empty param.error}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="fas fa-exclamation-circle me-2"></i>${param.error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <!-- Form -->
                        <form action="${pageContext.request.contextPath}/passengers/${user == null ? 'add' : 'edit'}"
                            method="post" id="userForm">

                            <c:if test="${user != null}">
                                <input type="hidden" name="userId" value="${user.userId}">
                            </c:if>

                            <!-- Avatar Preview -->
                            <div class="text-center">
                                <div class="avatar-preview" id="avatarPreview">
                                    ${user != null ? user.fullName.charAt(0) : '?'}
                                </div>
                            </div>

                            <!-- Personal Information -->
                            <div class="form-section">
                                <h5 class="mb-3">
                                    <i class="fas fa-user me-2"></i>Thông tin cá nhân
                                </h5>
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="fullName" class="form-label">Họ và tên *</label>
                                        <input type="text" class="form-control" id="fullName" name="fullName"
                                            value="${user.fullName}" placeholder="Nhập họ và tên đầy đủ" required>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label for="username" class="form-label">Tên đăng nhập *</label>
                                        <input type="text" class="form-control" id="username" name="username"
                                            value="${user.username}" placeholder="Nhập tên đăng nhập" required>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="password" class="form-label">Mật khẩu ${user == null ? '*' : '(để
                                            trống nếu không thay đổi)'}</label>
                                        <input type="password" class="form-control" id="password" name="password"
                                            placeholder="Nhập mật khẩu" ${user==null ? 'required' : '' }>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label for="gender" class="form-label">Giới tính</label>
                                        <select class="form-select" id="gender" name="gender">
                                            <option value="">Chọn giới tính</option>
                                            <option value="Nam" ${user.gender eq 'Nam' ? 'selected' : '' }>Nam
                                            </option>
                                            <option value="Nữ" ${user.gender eq 'Nữ' ? 'selected' : '' }>Nữ
                                            </option>
                                            <option value="Khác" ${user.gender eq 'Khác' ? 'selected' : '' }>Khác
                                            </option>
                                        </select>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="dateOfBirth" class="form-label">Ngày sinh</label>
                                        <input type="date" class="form-control" id="dateOfBirth" name="dateOfBirth"
                                            value="${user.dateOfBirth}">
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label for="idCard" class="form-label">Số CMND/CCCD</label>
                                        <input type="text" class="form-control" id="idCard" name="idCard"
                                            value="${user.idCard}" placeholder="Nhập số CMND/CCCD">
                                        <div class="form-text">12 số cho CCCD, 9 số cho CMND</div>
                                    </div>
                                </div>
                            </div>

                            <!-- Contact Information -->
                            <div class="form-section">
                                <h5 class="mb-3">
                                    <i class="fas fa-phone me-2"></i>Thông tin liên hệ
                                </h5>
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="phoneNumber" class="form-label">Số điện thoại *</label>
                                        <input type="tel" class="form-control" id="phoneNumber" name="phoneNumber"
                                            value="${user.phoneNumber}" placeholder="VD: 0123456789" required>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label for="email" class="form-label">Email</label>
                                        <input type="email" class="form-control" id="email" name="email"
                                            value="${user.email}" placeholder="VD: example@email.com">
                                    </div>
                                </div>
                                <div class="mb-3">
                                    <label for="address" class="form-label">Địa chỉ</label>
                                    <textarea class="form-control" id="address" name="address" rows="3"
                                        placeholder="Nhập địa chỉ đầy đủ...">${user.address}</textarea>
                                </div>
                            </div>

                            <!-- Role and Status -->
                            <div class="form-section">
                                <h5 class="mb-3">
                                    <i class="fas fa-user-cog me-2"></i>Vai trò và trạng thái
                                </h5>
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="role" class="form-label">Vai trò *</label>
                                        <select class="form-select" id="role" name="role" required>
                                            <option value="">Chọn vai trò</option>
                                            <option value="ADMIN" ${user.role eq 'ADMIN' ? 'selected' : '' }>Quản trị
                                                viên</option>
                                            <option value="STAFF" ${user.role eq 'STAFF' ? 'selected' : '' }>Nhân viên
                                            </option>
                                            <option value="CUSTOMER" ${user.role eq 'CUSTOMER' ? 'selected' : '' }>Khách
                                                hàng</option>
                                            <option value="DRIVER" ${user.role eq 'DRIVER' ? 'selected' : '' }>Tài xế
                                            </option>
                                        </select>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label for="status" class="form-label">Trạng thái</label>
                                        <select class="form-select" id="status" name="status">
                                            <option value="ACTIVE" ${user==null || user.status eq 'ACTIVE' ? 'selected'
                                                : '' }>Hoạt động</option>
                                            <option value="INACTIVE" ${user !=null && user.status eq 'INACTIVE'
                                                ? 'selected' : '' }>Không hoạt động</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="mb-3">
                                    <label for="notes" class="form-label">Ghi chú</label>
                                    <textarea class="form-control" id="notes" name="notes" rows="3"
                                        placeholder="Ghi chú thêm về hành khách...">${passenger.notes}</textarea>
                                </div>
                            </div>

                            <!-- Form Actions -->
                            <div class="d-flex justify-content-between">
                                <a href="${pageContext.request.contextPath}/passengers" class="btn btn-secondary">
                                    <i class="fas fa-times me-1"></i>Hủy
                                </a>
                                <button type="submit" class="btn btn-primary btn-submit">
                                    <i class="fas fa-save me-1"></i>
                                    ${user == null ? 'Thêm Người dùng' : 'Cập nhật'}
                                </button>
                            </div>
                        </form>
                    </div>
                </div>

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
                <script>
                    // Update avatar preview when name changes
                    document.getElementById('fullName').addEventListener('input', function () {
                        const name = this.value.trim();
                        const avatarPreview = document.getElementById('avatarPreview');
                        if (name.length > 0) {
                            avatarPreview.textContent = name.charAt(0).toUpperCase();
                        } else {
                            avatarPreview.textContent = '?';
                        }
                    });

                    // Phone number formatting
                    document.getElementById('phoneNumber').addEventListener('input', function () {
                        let phone = this.value.replace(/\D/g, '');
                        if (phone.length > 11) {
                            phone = phone.substring(0, 11);
                        }
                        this.value = phone;
                    });

                    // ID Card formatting
                    document.getElementById('idCard').addEventListener('input', function () {
                        let idCard = this.value.replace(/\D/g, '');
                        if (idCard.length > 12) {
                            idCard = idCard.substring(0, 12);
                        }
                        this.value = idCard;
                    });

                    // Date of birth validation
                    document.getElementById('dateOfBirth').addEventListener('change', function () {
                        const birthDate = new Date(this.value);
                        const today = new Date();
                        const age = today.getFullYear() - birthDate.getFullYear();

                        if (age < 0 || age > 120) {
                            alert('Ngày sinh không hợp lệ');
                            this.value = '';
                        }
                    });

                    // Form validation
                    document.getElementById('userForm').addEventListener('submit', function (e) {
                        const fullName = document.getElementById('fullName').value.trim();
                        const username = document.getElementById('username').value.trim();
                        const phoneNumber = document.getElementById('phoneNumber').value.trim();
                        const email = document.getElementById('email').value.trim();
                        const idCard = document.getElementById('idCard').value.trim();
                        const role = document.getElementById('role').value;

                        // Full name validation
                        if (fullName.length < 2) {
                            e.preventDefault();
                            alert('Họ và tên phải có ít nhất 2 ký tự');
                            document.getElementById('fullName').focus();
                            return false;
                        }

                        // Username validation
                        if (username.length < 3) {
                            e.preventDefault();
                            alert('Tên đăng nhập phải có ít nhất 3 ký tự');
                            document.getElementById('username').focus();
                            return false;
                        }

                        // Role validation
                        if (!role) {
                            e.preventDefault();
                            alert('Vui lòng chọn vai trò');
                            document.getElementById('role').focus();
                            return false;
                        }

                        // Phone number validation
                        const phoneRegex = /^[0-9]{10,11}$/;
                        if (!phoneRegex.test(phoneNumber)) {
                            e.preventDefault();
                            alert('Số điện thoại phải có 10-11 số');
                            document.getElementById('phoneNumber').focus();
                            return false;
                        }

                        // Email validation (if provided)
                        if (email && !isValidEmail(email)) {
                            e.preventDefault();
                            alert('Email không hợp lệ');
                            document.getElementById('email').focus();
                            return false;
                        }

                        // ID Card validation (if provided)
                        if (idCard) {
                            const idCardRegex = /^[0-9]{9,12}$/;
                            if (!idCardRegex.test(idCard)) {
                                e.preventDefault();
                                alert('Số CMND/CCCD không hợp lệ');
                                document.getElementById('idCard').focus();
                                return false;
                            }
                        }
                    });

                    function isValidEmail(email) {
                        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                        return emailRegex.test(email);
                    }

                    // Auto focus on first field
                    document.addEventListener('DOMContentLoaded', function () {
                        document.getElementById('fullName').focus();
                    });
                </script>
            </body>

            </html>