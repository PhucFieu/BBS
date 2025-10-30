<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Tạo vé xe mới - Hệ thống đặt vé xe</title>
                <base href="${pageContext.request.contextPath}/">
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
                <link href="${pageContext.request.contextPath}/assets/css/ticket-form.css" rel="stylesheet">
            </head>

            <body class="bg-light">
                <div class="container-fluid">
                    <div class="row">
                        <!-- Sidebar -->
                        <div class="col-md-3 col-lg-2 d-md-block bg-white sidebar">
                            <div class="position-sticky pt-3">
                                <div class="text-center mb-4">
                                    <i class="fas fa-bus fa-3x text-primary"></i>
                                    <h5 class="mt-2">Hệ thống đặt vé xe</h5>
                                </div>
                                <ul class="nav flex-column">
                                    <li class="nav-item">
                                        <a class="nav-link" href="${pageContext.request.contextPath}/admin">
                                            <i class="fas fa-home me-2"></i>Trang chủ
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link active"
                                            href="${pageContext.request.contextPath}/admin/tickets">
                                            <i class="fas fa-plus-circle me-2"></i>Tạo vé mới
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/tickets">
                                            <i class="fas fa-ticket-alt me-2"></i>Quản lý vé
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/passengers">
                                            <i class="fas fa-users me-2"></i>Hành khách
                                        </a>
                                    </li>
                                </ul>
                            </div>
                        </div>

                        <!-- Main content -->
                        <div class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                            <div
                                class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                                <h1 class="h2">
                                    <i class="fas fa-ticket-alt me-2"></i>Tạo vé xe mới
                                </h1>
                                <div class="btn-toolbar mb-2 mb-md-0">
                                    <a href="${pageContext.request.contextPath}/admin/tickets"
                                        class="btn btn-outline-secondary">
                                        <i class="fas fa-arrow-left me-1"></i>Quay lại
                                    </a>
                                </div>
                            </div>

                            <!-- Alert Messages -->
                            <c:if test="${not empty param.error}">
                                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                    <i class="fas fa-exclamation-triangle me-2"></i>
                                    ${param.error}
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                </div>
                            </c:if>
                            <c:if test="${not empty param.message}">
                                <div class="alert alert-success alert-dismissible fade show" role="alert">
                                    <i class="fas fa-check-circle me-2"></i>
                                    ${param.message}
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                </div>
                            </c:if>

                            <!-- Ticket Form -->
                            <form action="${pageContext.request.contextPath}/tickets/add" method="post" id="ticketForm"
                                class="needs-validation" novalidate>
                                <div class="row">
                                    <!-- Left Column -->
                                    <div class="col-lg-8">
                                        <!-- Route Information -->
                                        <div class="card mb-4">
                                            <div class="card-header bg-primary text-white">
                                                <h5 class="mb-0">
                                                    <i class="fas fa-route me-2"></i>Thông tin tuyến đường
                                                </h5>
                                            </div>
                                            <div class="card-body">
                                                <div class="row g-3">
                                                    <div class="col-md-6">
                                                        <label for="routeId" class="form-label">
                                                            Tuyến đường <span class="text-danger">*</span>
                                                        </label>
                                                        <select class="form-select" id="routeId" name="routeId"
                                                            required>
                                                            <option value="">Chọn tuyến đường</option>
                                                            <c:forEach var="route" items="${routes}">
                                                                <option value="${route.routeId}"
                                                                    data-price="${route.basePrice}">
                                                                    ${route.departureCity} → ${route.destinationCity}
                                                                </option>
                                                            </c:forEach>
                                                        </select>
                                                        <div class="invalid-feedback">Vui lòng chọn tuyến đường</div>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <label for="busId" class="form-label">
                                                            Xe khách <span class="text-danger">*</span>
                                                        </label>
                                                        <select class="form-select" id="busId" name="busId" required>
                                                            <option value="">Chọn xe khách</option>
                                                            <c:forEach var="bus" items="${buses}">
                                                                <option value="${bus.busId}"
                                                                    data-seats="${bus.totalSeats}">
                                                                    ${bus.busNumber} - ${bus.busType} (${bus.totalSeats}
                                                                    ghế)
                                                                </option>
                                                            </c:forEach>
                                                        </select>
                                                        <div class="invalid-feedback">Vui lòng chọn xe khách</div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Passenger Information -->
                                        <div class="card mb-4">
                                            <div class="card-header bg-success text-white">
                                                <h5 class="mb-0">
                                                    <i class="fas fa-user me-2"></i>Thông tin hành khách
                                                </h5>
                                            </div>
                                            <div class="card-body">
                                                <div class="mb-3">
                                                    <label for="userId" class="form-label">
                                                        Chọn hành khách <span class="text-danger">*</span>
                                                    </label>
                                                    <select class="form-select" id="userId" name="userId" required>
                                                        <option value="">-- Chọn hành khách --</option>
                                                        <c:forEach var="user" items="${users}">
                                                            <option value="${user.userId}">
                                                                ${user.fullName} - ${user.phoneNumber}
                                                                <c:if test="${not empty user.email}">
                                                                    (${user.email})
                                                                </c:if>
                                                            </option>
                                                        </c:forEach>
                                                    </select>
                                                    <div class="invalid-feedback">Vui lòng chọn hành khách</div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Schedule Information -->
                                        <div class="card mb-4">
                                            <div class="card-header bg-info text-white">
                                                <h5 class="mb-0">
                                                    <i class="fas fa-calendar me-2"></i>Thông tin lịch trình
                                                </h5>
                                            </div>
                                            <div class="card-body">
                                                <div class="row g-3">
                                                    <div class="col-md-6">
                                                        <label for="departureDate" class="form-label">
                                                            Ngày khởi hành <span class="text-danger">*</span>
                                                        </label>
                                                        <input type="date" class="form-control" id="departureDate"
                                                            name="departureDate" required>
                                                        <div class="invalid-feedback">Vui lòng chọn ngày khởi hành</div>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <label for="departureTime" class="form-label">
                                                            Giờ khởi hành <span class="text-danger">*</span>
                                                        </label>
                                                        <select class="form-select" id="departureTime"
                                                            name="departureTime" required>
                                                            <option value="">--:-- --</option>
                                                        </select>
                                                        <div class="invalid-feedback">Vui lòng chọn giờ khởi hành</div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Seat Selection -->
                                        <div class="card mb-4">
                                            <div class="card-header bg-warning text-dark">
                                                <h5 class="mb-0">
                                                    <i class="fas fa-chair me-2"></i>Chọn ghế ngồi
                                                </h5>
                                            </div>
                                            <div class="card-body">
                                                <div class="row g-3">
                                                    <div class="col-md-6">
                                                        <label for="seatNumber" class="form-label">
                                                            Số ghế <span class="text-danger">*</span>
                                                        </label>
                                                        <input type="number" class="form-control" id="seatNumber"
                                                            name="seatNumber" min="1" max="50"
                                                            placeholder="Nhập số ghế từ 1 đến số ghế tối đa của xe"
                                                            required>
                                                        <div class="invalid-feedback">Vui lòng nhập số ghế hợp lệ</div>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <label class="form-label">Xem ghế trống</label>
                                                        <div>
                                                            <button type="button" class="btn btn-outline-primary"
                                                                id="viewSeatsBtn" onclick="viewAvailableSeats()">
                                                                <i class="fas fa-eye me-1"></i>Xem ghế trống
                                                            </button>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Seat Map -->
                                                <div id="seatMap" class="mt-3" style="display: none;">
                                                    <h6>Bản đồ ghế:</h6>
                                                    <div class="seat-grid" id="seatGrid"></div>
                                                    <div class="seat-legend mt-3">
                                                        <div class="d-flex gap-3">
                                                            <div class="d-flex align-items-center gap-2">
                                                                <div class="seat-legend-item available"></div>
                                                                <span>Trống</span>
                                                            </div>
                                                            <div class="d-flex align-items-center gap-2">
                                                                <div class="seat-legend-item occupied"></div>
                                                                <span>Đã đặt</span>
                                                            </div>
                                                            <div class="d-flex align-items-center gap-2">
                                                                <div class="seat-legend-item selected"></div>
                                                                <span>Đã chọn</span>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Right Column -->
                                    <div class="col-lg-4">
                                        <!-- Ticket Information -->
                                        <div class="card mb-4">
                                            <div class="card-header bg-secondary text-white">
                                                <h5 class="mb-0">
                                                    <i class="fas fa-ticket-alt me-2"></i>Thông tin vé xe
                                                </h5>
                                            </div>
                                            <div class="card-body">
                                                <div class="mb-3">
                                                    <label for="ticketPrice" class="form-label">
                                                        Giá vé (₫) <span class="text-danger">*</span>
                                                    </label>
                                                    <input type="number" class="form-control" id="ticketPrice"
                                                        name="ticketPrice" min="0" step="1000"
                                                        placeholder="Giá vé sẽ được tự động điền khi chọn tuyến đường"
                                                        required>
                                                    <div class="form-text">Giá vé sẽ được tự động điền khi chọn tuyến
                                                        đường</div>
                                                    <div class="invalid-feedback">Vui lòng nhập giá vé</div>
                                                </div>

                                                <div class="mb-3">
                                                    <label for="status" class="form-label">Trạng thái vé</label>
                                                    <select class="form-select" id="status" name="status">
                                                        <option value="CONFIRMED" selected>Đã xác nhận</option>
                                                        <option value="PENDING">Chờ xác nhận</option>
                                                        <option value="CANCELLED">Đã hủy</option>
                                                    </select>
                                                </div>

                                                <div class="mb-3">
                                                    <label for="paymentStatus" class="form-label">Trạng thái thanh
                                                        toán</label>
                                                    <select class="form-select" id="paymentStatus" name="paymentStatus">
                                                        <option value="PENDING" selected>Chờ thanh toán</option>
                                                        <option value="PAID">Đã thanh toán</option>
                                                        <option value="CANCELLED">Đã hủy</option>
                                                    </select>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Total Price -->
                                        <div class="card mb-4">
                                            <div class="card-body text-center">
                                                <h6 class="text-muted mb-2">Tổng giá vé</h6>
                                                <h3 class="text-primary mb-0" id="totalPrice">0₫</h3>
                                            </div>
                                        </div>

                                        <!-- Action Buttons -->
                                        <div class="d-grid gap-2">
                                            <button type="submit" class="btn btn-primary btn-lg">
                                                <i class="fas fa-save me-2"></i>Tạo vé xe
                                            </button>
                                            <a href="${pageContext.request.contextPath}/admin/tickets"
                                                class="btn btn-outline-secondary">
                                                <i class="fas fa-times me-2"></i>Hủy bỏ
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- Scripts -->
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                <script src="${pageContext.request.contextPath}/assets/js/ticket-form.js?v=ticket-add-1"></script>
                <script>
                    // Fallback: ensure global handler is available for inline onclick
                    (function () {
                        try {
                            if (typeof window.viewAvailableSeats !== 'function' && typeof viewAvailableSeats === 'function') {
                                window.viewAvailableSeats = viewAvailableSeats;
                            }
                        } catch (e) {
                            // ignore
                        }
                    })();
                </script>
            </body>

            </html>
