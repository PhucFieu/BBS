<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%-- Redirect guest users to login page --%>
                <c:if test="${empty sessionScope.user}">
                    <script>
                        window.location.href = '${pageContext.request.contextPath}/auth/login?error=You need to login to view ticket details';
                    </script>
                </c:if>
                <%-- Set role variable for convenience --%>
                    <c:set var="role" value="${sessionScope.role}" />

                    <!DOCTYPE html>
                    <html lang="vi">

                    <head>
                        <meta charset="UTF-8">
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <title>Ticket Details - Bus Booking System</title>
                        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css"
                            rel="stylesheet">
                        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"
                            rel="stylesheet">
                        <style>
                            body {
                                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                                min-height: 100vh;
                            }

                            .ticket-container {
                                max-width: 800px;
                                margin: 0 auto;
                            }

                            .ticket-card {
                                background: white;
                                border-radius: 20px;
                                box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
                                overflow: hidden;
                                margin-top: 2rem;
                            }

                            .ticket-header {
                                background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
                                color: white;
                                padding: 2rem;
                                text-align: center;
                                position: relative;
                            }

                            .ticket-header::before {
                                content: '';
                                position: absolute;
                                top: 0;
                                left: 0;
                                right: 0;
                                bottom: 0;
                                background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grain" width="100" height="100" patternUnits="userSpaceOnUse"><circle cx="25" cy="25" r="1" fill="white" opacity="0.1"/><circle cx="75" cy="75" r="1" fill="white" opacity="0.1"/><circle cx="50" cy="10" r="0.5" fill="white" opacity="0.1"/><circle cx="10" cy="60" r="0.5" fill="white" opacity="0.1"/><circle cx="90" cy="40" r="0.5" fill="white" opacity="0.1"/></pattern></defs><rect width="100" height="100" fill="url(%23grain)"/></svg>');
                                opacity: 0.3;
                            }

                            .ticket-number {
                                font-family: 'Courier New', monospace;
                                font-size: 2rem;
                                font-weight: bold;
                                margin-bottom: 0.5rem;
                                position: relative;
                                z-index: 1;
                            }

                            .ticket-status {
                                position: relative;
                                z-index: 1;
                            }

                            .ticket-body {
                                padding: 2rem;
                            }

                            .info-section {
                                margin-bottom: 2rem;
                            }

                            .info-section h5 {
                                color: #007bff;
                                border-bottom: 2px solid #e9ecef;
                                padding-bottom: 0.5rem;
                                margin-bottom: 1rem;
                            }

                            .info-row {
                                display: flex;
                                justify-content: space-between;
                                align-items: center;
                                padding: 0.75rem 0;
                                border-bottom: 1px solid #f8f9fa;
                            }

                            .info-row:last-child {
                                border-bottom: none;
                            }

                            .info-label {
                                font-weight: 600;
                                color: #6c757d;
                            }

                            .info-value {
                                font-weight: 500;
                                color: #212529;
                            }

                            .route-info {
                                background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
                                color: white;
                                padding: 1.5rem;
                                border-radius: 15px;
                                margin-bottom: 2rem;
                                text-align: center;
                            }

                            .route-arrow {
                                font-size: 2rem;
                                margin: 0 1rem;
                            }

                            .price-display {
                                background: linear-gradient(135deg, #ffc107 0%, #fd7e14 100%);
                                color: white;
                                padding: 1.5rem;
                                border-radius: 15px;
                                text-align: center;
                                margin-bottom: 2rem;
                            }

                            .price-amount {
                                font-size: 2.5rem;
                                font-weight: bold;
                            }

                            .seat-display {
                                background: #e9ecef;
                                padding: 1rem;
                                border-radius: 10px;
                                text-align: center;
                                font-size: 1.2rem;
                                font-weight: bold;
                                color: #495057;
                            }

                            .action-buttons {
                                display: flex;
                                gap: 1rem;
                                justify-content: center;
                                flex-wrap: wrap;
                            }

                            .btn-action {
                                padding: 0.75rem 1.5rem;
                                border-radius: 25px;
                                font-weight: 600;
                                text-decoration: none;
                                transition: all 0.3s ease;
                            }

                            .btn-action:hover {
                                transform: translateY(-2px);
                                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
                            }

                            .qr-code {
                                background: #f8f9fa;
                                padding: 1rem;
                                border-radius: 10px;
                                text-align: center;
                                margin-top: 1rem;
                            }

                            .qr-code i {
                                font-size: 4rem;
                                color: #007bff;
                            }

                            .ticket-footer {
                                background: #f8f9fa;
                                padding: 1rem;
                                text-align: center;
                                color: #6c757d;
                                font-size: 0.9rem;
                            }

                            @media (max-width: 768px) {
                                .ticket-container {
                                    margin: 1rem;
                                }

                                .ticket-header {
                                    padding: 1.5rem;
                                }

                                .ticket-number {
                                    font-size: 1.5rem;
                                }

                                .ticket-body {
                                    padding: 1.5rem;
                                }

                                .action-buttons {
                                    flex-direction: column;
                                }

                                .btn-action {
                                    width: 100%;
                                }
                            }
                        </style>
                    </head>

                    <body>
                        <%-- Include the correct header --%>
                            <c:choose>
                                <c:when test="${role == 'ADMIN'}">
                                    <%@ include file="/views/partials/admin-header.jsp" %>
                                </c:when>
                                <c:otherwise>
                                    <%@ include file="/views/partials/user-header.jsp" %>
                                </c:otherwise>
                            </c:choose>

                            <div class="container ticket-container">
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

                                <c:choose>
                                    <c:when test="${empty ticket}">
                                        <div class="text-center py-5">
                                            <i class="fas fa-ticket-alt fa-4x text-white mb-3"></i>
                                            <h3 class="text-white">Ticket Not Found</h3>
                                            <p class="text-white-50">The ticket you are looking for does not exist or
                                                has been deleted.
                                            </p>
                                            <a href="${pageContext.request.contextPath}/tickets" class="btn btn-light">
                                                <i class="fas fa-arrow-left me-1"></i>Back to Ticket List
                                            </a>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="ticket-card">
                                            <!-- Ticket Header -->
                                            <div class="ticket-header">
                                                <div class="ticket-number">${ticket.ticketNumber}</div>
                                                <div class="ticket-status">
                                                    <c:choose>
                                                        <c:when test="${ticket.status eq 'CONFIRMED'}">
                                                            <span class="badge bg-success fs-6">Confirmed</span>
                                                        </c:when>
                                                        <c:when test="${ticket.status eq 'PENDING'}">
                                                            <span class="badge bg-warning fs-6">Pending</span>
                                                        </c:when>
                                                        <c:when test="${ticket.status eq 'CANCELLED'}">
                                                            <span class="badge bg-danger fs-6">Cancelled</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span
                                                                class="badge bg-secondary fs-6">${ticket.status}</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>

                                            <!-- Ticket Body -->
                                            <div class="ticket-body">
                                                <!-- Route Information -->
                                                <div class="route-info">
                                                    <div class="row align-items-center">
                                                        <div class="col-md-5">
                                                            <h4><i
                                                                    class="fas fa-map-marker-alt me-2"></i>${ticket.departureCity}
                                                            </h4>
                                                        </div>
                                                        <div class="col-md-2">
                                                            <i class="fas fa-arrow-right route-arrow"></i>
                                                        </div>
                                                        <div class="col-md-5">
                                                            <h4><i
                                                                    class="fas fa-map-marker-alt me-2"></i>${ticket.destinationCity}
                                                            </h4>
                                                        </div>
                                                    </div>
                                                    <div class="mt-2">
                                                        <small>Route: ${ticket.routeName}</small>
                                                    </div>
                                                </div>

                                                <!-- Price Display -->
                                                <div class="price-display">
                                                    <div class="price-amount">
                                                        <fmt:formatNumber value="${ticket.ticketPrice}" type="currency"
                                                            currencySymbol="₫" maxFractionDigits="0" />
                                                    </div>
                                                    <div class="mt-2">
                                                        <c:choose>
                                                            <c:when test="${ticket.paymentStatus eq 'PAID'}">
                                                                <span class="badge bg-success fs-6">Đã thanh toán</span>
                                                            </c:when>
                                                            <c:when test="${ticket.paymentStatus eq 'PENDING'}">
                                                                <span class="badge bg-warning fs-6">Chờ thanh
                                                                    toán</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span
                                                                    class="badge bg-secondary fs-6">${ticket.paymentStatus}</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </div>

                                                <!-- Journey Information -->
                                                <div class="info-section">
                                                    <h5><i class="fas fa-route me-2"></i>Thông tin chuyến đi</h5>
                                                    <div class="info-row">
                                                        <span class="info-label">Ngày khởi hành:</span>
                                                        <span class="info-value">
                                                            <i class="fas fa-calendar me-1"></i>
                                                            <fmt:formatDate value="${ticket.departureDateSql}"
                                                                pattern="EEEE, dd/MM/yyyy" />
                                                        </span>
                                                    </div>
                                                    <div class="info-row">
                                                        <span class="info-label">Giờ khởi hành:</span>
                                                        <span class="info-value">
                                                            <i class="fas fa-clock me-1"></i>
                                                            <fmt:formatDate value="${ticket.departureTimeSql}"
                                                                pattern="HH:mm" />
                                                        </span>
                                                    </div>
                                                    <div class="info-row">
                                                        <span class="info-label">Xe:</span>
                                                        <span class="info-value">
                                                            <i class="fas fa-bus me-1"></i>${ticket.busNumber}
                                                        </span>
                                                    </div>
                                                    <div class="info-row">
                                                        <span class="info-label">Tài xế:</span>
                                                        <span class="info-value">
                                                            <i class="fas fa-user me-1"></i>${ticket.driverName}
                                                        </span>
                                                    </div>
                                                </div>

                                                <!-- Passenger Information -->
                                                <div class="info-section">
                                                    <h5><i class="fas fa-user me-2"></i>Thông tin hành khách</h5>
                                                    <div class="info-row">
                                                        <span class="info-label">Họ tên:</span>
                                                        <span class="info-value">
                                                            <c:choose>
                                                                <c:when test="${not empty ticket.userName}">
                                                                    ${ticket.userName}</c:when>
                                                                <c:otherwise>${ticket.passengerName}</c:otherwise>
                                                            </c:choose>
                                                        </span>
                                                    </div>
                                                    <div class="info-row">
                                                        <span class="info-label">Số ghế:</span>
                                                        <span class="info-value">
                                                            <div class="seat-display">${ticket.seatNumber}</div>
                                                        </span>
                                                    </div>
                                                </div>

                                                <!-- Action Buttons -->
                                                <div class="action-buttons">
                                                    <a href="${pageContext.request.contextPath}/tickets"
                                                        class="btn btn-outline-secondary btn-action">
                                                        <i class="fas fa-list me-1"></i>Danh sách vé
                                                    </a>
                                                    <c:if test="${role == 'ADMIN' || role == 'DRIVER'}">
                                                        <a href="${pageContext.request.contextPath}/tickets/edit?id=${ticket.ticketId}"
                                                            class="btn btn-warning btn-action">
                                                            <i class="fas fa-edit me-1"></i>Sửa vé
                                                        </a>
                                                        <button type="button" class="btn btn-danger btn-action"
                                                            onclick="confirmDelete(${ticket.ticketId}, '${ticket.ticketNumber}')">
                                                            <i class="fas fa-times me-1"></i>Hủy vé
                                                        </button>
                                                    </c:if>
                                                </div>
                                            </div>

                                            <!-- Ticket Footer -->
                                            <div class="ticket-footer">
                                                <p class="mb-0">
                                                    <i class="fas fa-info-circle me-1"></i>
                                                    Vui lòng đến bến xe trước giờ khởi hành 30 phút để làm thủ tục lên
                                                    xe.
                                                </p>
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
                                            <h5 class="modal-title">Xác nhận hủy vé</h5>
                                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                        </div>
                                        <div class="modal-body">
                                            <p>Bạn có chắc chắn muốn hủy vé <strong id="ticketNumberToDelete"></strong>?
                                            </p>
                                            <p class="text-danger"><small>Hành động này không thể hoàn tác.</small></p>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy
                                            </button>
                                            <a href="#" id="confirmDeleteBtn" class="btn btn-danger">Hủy vé</a>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <%@ include file="/views/partials/footer.jsp" %>
                                <script
                                src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
                                <script>
                                    function confirmDelete(ticketId, ticketNumber) {
                                        document.getElementById('ticketNumberToDelete').textContent = ticketNumber;
                                        document.getElementById('confirmDeleteBtn').href =
                                            '${pageContext.request.contextPath}/tickets/delete?id=' + ticketId;
                                        new bootstrap.Modal(document.getElementById('deleteModal')).show();
                                    }

                                    // Auto-hide alerts after 5 seconds
                                    setTimeout(function () {
                                        const alerts = document.querySelectorAll('.alert');
                                        alerts.forEach(function (alert) {
                                            const bsAlert = new bootstrap.Alert(alert);
                                            bsAlert.close();
                                        });
                                    }, 5000);
                                </script>
                    </body>

                    </html>
