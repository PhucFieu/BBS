<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <jsp:include page="/views/partials/head.jsp">
                <jsp:param name="title" value="Thêm người dùng mới - Admin Panel" />
            </jsp:include>
        </head>

        <body>
            <%@ include file="/views/partials/admin-header.jsp" %>

                <div class="container mt-4">
                    <div class="row justify-content-center">
                        <div class="col-md-8">
                            <div class="card">
                                <div class="card-header bg-success text-white">
                                    <h5 class="mb-0">
                                        <i class="fas fa-user-plus me-2"></i>
                                        Thêm người dùng mới
                                    </h5>
                                </div>
                                <div class="card-body">
                                    <!-- Messages -->
                                    <c:if test="${not empty param.error}">
                                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                            <i class="fas fa-exclamation-circle me-2"></i>${param.error}
                                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                        </div>
                                    </c:if>

                                    <c:if test="${not empty param.message}">
                                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                                            <i class="fas fa-check-circle me-2"></i>${param.message}
                                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                        </div>
                                    </c:if>

                                    <form action="${pageContext.request.contextPath}/admin/user/add" method="post"
                                        id="addUserForm">

                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="mb-3">
                                                    <label for="username" class="form-label">Username *</label>
                                                    <input type="text" class="form-control" id="username"
                                                        name="username" required placeholder="Nhập username">
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="mb-3">
                                                    <label for="fullName" class="form-label">Họ và tên *</label>
                                                    <input type="text" class="form-control" id="fullName"
                                                        name="fullName" required placeholder="Nhập họ và tên">
                                                </div>
                                            </div>
                                        </div>

                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="mb-3">
                                                    <label for="email" class="form-label">Email *</label>
                                                    <input type="email" class="form-control" id="email" name="email"
                                                        required placeholder="Nhập email">
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="mb-3">
                                                    <label for="phoneNumber" class="form-label">Số điện thoại *</label>
                                                    <input type="tel" class="form-control" id="phoneNumber"
                                                        name="phoneNumber" required placeholder="Nhập số điện thoại">
                                                </div>
                                            </div>
                                        </div>

                                        <div class="mb-3">
                                            <label for="password" class="form-label">Mật khẩu *</label>
                                            <input type="password" class="form-control" id="password" name="password"
                                                required placeholder="Nhập mật khẩu">
                                            <div class="form-text">Mật khẩu phải có ít nhất 8 ký tự</div>
                                        </div>

                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="mb-3">
                                                    <label for="role" class="form-label">Vai trò *</label>
                                                    <select class="form-select" id="role" name="role" required>
                                                        <option value="">Chọn vai trò</option>
                                                        <option value="ADMIN">Admin</option>
                                                        <option value="USER">User</option>
                                                        <option value="DRIVER">Driver</option>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="mb-3">
                                                    <label for="status" class="form-label">Trạng thái *</label>
                                                    <select class="form-select" id="status" name="status" required>
                                                        <option value="">Chọn trạng thái</option>
                                                        <option value="ACTIVE" selected>Active</option>
                                                        <option value="INACTIVE">Inactive</option>
                                                    </select>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="mb-3">
                                            <label for="idCard" class="form-label">CCCD/CMND</label>
                                            <input type="text" class="form-control" id="idCard" name="idCard"
                                                placeholder="Nhập CCCD/CMND (tùy chọn)">
                                        </div>

                                        <div class="mb-3">
                                            <label for="address" class="form-label">Địa chỉ</label>
                                            <textarea class="form-control" id="address" name="address" rows="3"
                                                placeholder="Nhập địa chỉ (tùy chọn)"></textarea>
                                        </div>

                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="mb-3">
                                                    <label for="dateOfBirth" class="form-label">Ngày sinh</label>
                                                    <input type="date" class="form-control" id="dateOfBirth"
                                                        name="dateOfBirth">
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="mb-3">
                                                    <label for="gender" class="form-label">Giới tính</label>
                                                    <select class="form-select" id="gender" name="gender">
                                                        <option value="">Chọn giới tính</option>
                                                        <option value="MALE">Nam</option>
                                                        <option value="FEMALE">Nữ</option>
                                                        <option value="OTHER">Khác</option>
                                                    </select>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="d-flex justify-content-between">
                                            <a href="${pageContext.request.contextPath}/admin/users"
                                                class="btn btn-secondary">
                                                <i class="fas fa-arrow-left me-2"></i>Quay lại
                                            </a>
                                            <button type="submit" class="btn btn-success">
                                                <i class="fas fa-plus me-2"></i>Thêm người dùng
                                            </button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Include footer -->
                <%@ include file="/views/partials/footer.jsp" %>

                    <!-- Form validation script -->
                    <script>
                        document.getElementById('addUserForm').addEventListener('submit', function (e) {
                            const username = document.getElementById('username').value.trim();
                            const fullName = document.getElementById('fullName').value.trim();
                            const email = document.getElementById('email').value.trim();
                            const phoneNumber = document.getElementById('phoneNumber').value.trim();
                            const role = document.getElementById('role').value;
                            const status = document.getElementById('status').value;
                            const password = document.getElementById('password').value;

                            if (!username || !fullName || !email || !phoneNumber || !role || !status || !password) {
                                e.preventDefault();
                                alert('Vui lòng điền đầy đủ thông tin bắt buộc!');
                                return false;
                            }

                            if (password.length < 8) {
                                e.preventDefault();
                                alert('Mật khẩu phải có ít nhất 8 ký tự!');
                                return false;
                            }

                            // Email validation
                            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                            if (!emailRegex.test(email)) {
                                e.preventDefault();
                                alert('Email không hợp lệ!');
                                return false;
                            }

                            // Phone validation
                            const phoneRegex = /^[0-9]{10,11}$/;
                            if (!phoneRegex.test(phoneNumber)) {
                                e.preventDefault();
                                alert('Số điện thoại phải có 10-11 chữ số!');
                                return false;
                            }

                            // Username validation
                            if (username.length < 3) {
                                e.preventDefault();
                                alert('Username phải có ít nhất 3 ký tự!');
                                return false;
                            }
                        });
                    </script>
        </body>

        </html>