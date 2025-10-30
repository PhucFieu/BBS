<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <jsp:include page="/views/partials/head.jsp">
                <jsp:param name="title" value="Form hanh khach - Admin Panel" />
            </jsp:include>
        </head>

        <body>
            <%@ include file="/views/partials/admin-header.jsp" %>

                <div class="container mt-4">
                    <div class="row justify-content-center">
                        <div class="col-md-8">
                            <div class="card">
                                <div class="card-header bg-primary text-white">
                                    <h5 class="mb-0">
                                        <i class="fas fa-user-edit me-2"></i>
                                        <c:choose>
                                            <c:when test="${isAddMode}">Thêm hành khách mới</c:when>
                                            <c:when test="${not empty user}">Chỉnh sửa hành khách</c:when>
                                            <c:otherwise>Thêm hành khách mới</c:otherwise>
                                        </c:choose>
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

                                    <form
                                        action="${pageContext.request.contextPath}/admin/user/${isAddMode ? 'add' : (not empty user ? 'update' : 'add')}"
                                        method="post" id="userForm">

                                        <c:if test="${not empty user}">
                                            <input type="hidden" name="userId" value="${user.userId}">
                                        </c:if>

                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="mb-3">
                                                    <label for="username" class="form-label">Username *</label>
                                                    <input type="text" class="form-control" id="username"
                                                        name="username" value="${user.username}" required>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="mb-3">
                                                    <label for="fullName" class="form-label">Họ và tên *</label>
                                                    <input type="text" class="form-control" id="fullName"
                                                        name="fullName" value="${user.fullName}" required>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="mb-3">
                                                    <label for="email" class="form-label">Email *</label>
                                                    <input type="email" class="form-control" id="email" name="email"
                                                        value="${user.email}" required>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="mb-3">
                                                    <label for="phoneNumber" class="form-label">Số điện thoại *</label>
                                                    <input type="tel" class="form-control" id="phoneNumber"
                                                        name="phoneNumber" value="${user.phoneNumber}" required>
                                                </div>
                                            </div>
                                        </div>

                                        <c:if test="${isAddMode or empty user}">
                                            <div class="mb-3">
                                                <label for="password" class="form-label">Mật khẩu *</label>
                                                <div class="input-group">
                                                    <input type="password" class="form-control" id="password"
                                                        name="password" required>
                                                    <button class="btn btn-outline-secondary" type="button"
                                                        onclick="togglePasswordVisibility('password')">
                                                        <i class="fas fa-eye" id="passwordToggleIcon"></i>
                                                    </button>
                                                </div>
                                                <div class="form-text">Mật khẩu phải có ít nhất 8 ký tự</div>
                                            </div>
                                        </c:if>

                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="mb-3">
                                                    <label for="role" class="form-label">Vai trò *</label>
                                                    <select class="form-select" id="role" name="role" required>
                                                        <option value="">Chọn vai trò</option>
                                                        <option value="ADMIN" ${user.role=='ADMIN' ? 'selected' : '' }>
                                                            Admin</option>
                                                        <option value="USER" ${user.role=='USER' ? 'selected' : '' }>
                                                            Passenger</option>
                                                        <option value="DRIVER" ${user.role=='DRIVER' ? 'selected' : ''
                                                            }>Driver</option>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="mb-3">
                                                    <label for="status" class="form-label">Trạng thái *</label>
                                                    <select class="form-select" id="status" name="status" required>
                                                        <option value="">Chọn trạng thái</option>
                                                        <option value="ACTIVE" ${user.status=='ACTIVE' ? 'selected' : ''
                                                            }>Active</option>
                                                        <option value="INACTIVE" ${user.status=='INACTIVE' ? 'selected'
                                                            : '' }>Inactive</option>
                                                    </select>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="mb-3">
                                            <label for="idCard" class="form-label">CCCD/CMND</label>
                                            <input type="text" class="form-control" id="idCard" name="idCard"
                                                value="${user.idCard}">
                                        </div>

                                        <div class="mb-3">
                                            <label for="address" class="form-label">Địa chỉ</label>
                                            <textarea class="form-control" id="address" name="address"
                                                rows="3">${user.address}</textarea>
                                        </div>

                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="mb-3">
                                                    <label for="dateOfBirth" class="form-label">Ngày sinh</label>
                                                    <input type="date" class="form-control" id="dateOfBirth"
                                                        name="dateOfBirth" value="${user.dateOfBirth}">
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="mb-3">
                                                    <label for="gender" class="form-label">Giới tính</label>
                                                    <select class="form-select" id="gender" name="gender">
                                                        <option value="">Chọn giới tính</option>
                                                        <option value="MALE" ${user.gender=='MALE' ? 'selected' : '' }>
                                                            Nam</option>
                                                        <option value="FEMALE" ${user.gender=='FEMALE' ? 'selected' : ''
                                                            }>Nữ</option>
                                                        <option value="OTHER" ${user.gender=='OTHER' ? 'selected' : ''
                                                            }>Khác</option>
                                                    </select>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="d-flex justify-content-between">
                                            <a href="${pageContext.request.contextPath}/admin/users"
                                                class="btn btn-secondary">
                                                <i class="fas fa-arrow-left me-2"></i>Quay lại
                                            </a>
                                            <button type="submit" class="btn btn-primary">
                                                <i class="fas fa-save me-2"></i>
                                                <c:choose>
                                                    <c:when test="${not empty user}">Cập nhật</c:when>
                                                    <c:otherwise>Thêm mới</c:otherwise>
                                                </c:choose>
                                            </button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <%@ include file="/views/partials/footer.jsp" %>

                    <script>
                        // Form validation
                        document.getElementById('userForm').addEventListener('submit', function (e) {
                            const username = document.getElementById('username').value.trim();
                            const fullName = document.getElementById('fullName').value.trim();
                            const email = document.getElementById('email').value.trim();
                            const phoneNumber = document.getElementById('phoneNumber').value.trim();
                            const role = document.getElementById('role').value;
                            const status = document.getElementById('status').value;
                            const password = document.getElementById('password');

                            if (!username || !fullName || !email || !phoneNumber || !role || !status) {
                                e.preventDefault();
                                alert('Vui lòng điền đầy đủ thông tin bắt buộc!');
                                return false;
                            }

                            if (password && password.value.length < 8) {
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
                        });

                        // Password visibility toggle
                        function togglePasswordVisibility(fieldId) {
                            const passwordField = document.getElementById(fieldId);
                            const toggleIcon = document.getElementById(fieldId + 'ToggleIcon');

                            if (passwordField.type === 'password') {
                                passwordField.type = 'text';
                                toggleIcon.classList.remove('fa-eye');
                                toggleIcon.classList.add('fa-eye-slash');
                            } else {
                                passwordField.type = 'password';
                                toggleIcon.classList.remove('fa-eye-slash');
                                toggleIcon.classList.add('fa-eye');
                            }
                        }
                    </script>
        </body>

        </html>
