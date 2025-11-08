<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <jsp:include page="/views/partials/head.jsp">
                    <jsp:param name="title" value="Đặt vé - Bus Booking System" />
                </jsp:include>
                <style>
                    :root {
                        --primary-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        --success-color: #10b981;
                        --text-dark: #1e293b;
                        --text-light: #64748b;
                    }

                    body {
                        font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
                        background: #f8fafc;
                    }

                    .booking-hero {
                        background: var(--primary-gradient);
                        color: white;
                        padding: 40px 0;
                        margin-bottom: 30px;
                    }

                    .schedule-card {
                        background: white;
                        border: none;
                        border-radius: 16px;
                        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
                        margin-bottom: 20px;
                        transition: all 0.3s ease;
                        cursor: pointer;
                    }

                    .schedule-card:hover {
                        transform: translateY(-4px);
                        box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
                    }

                    .schedule-card.selected {
                        border: 3px solid #667eea;
                        box-shadow: 0 8px 20px rgba(102, 126, 234, 0.3);
                    }

                    .schedule-time {
                        font-size: 1.5rem;
                        font-weight: 700;
                        color: var(--text-dark);
                    }

                    .schedule-date {
                        color: var(--text-light);
                        font-size: 0.9rem;
                    }

                    .schedule-info {
                        display: flex;
                        align-items: center;
                        gap: 15px;
                        padding: 20px;
                    }

                    .schedule-details {
                        flex: 1;
                    }

                    .schedule-price {
                        font-size: 1.5rem;
                        font-weight: 700;
                        color: var(--success-color);
                    }

                    .seat-selection {
                        background: white;
                        border-radius: 16px;
                        padding: 30px;
                        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
                        margin-top: 30px;
                        display: none;
                    }

                    .seat-selection.active {
                        display: block;
                    }

                    .seat-grid {
                        display: grid;
                        grid-template-columns: repeat(4, 1fr);
                        gap: 10px;
                        margin-top: 20px;
                    }

                    .seat {
                        width: 60px;
                        height: 60px;
                        border: 2px solid #e2e8f0;
                        border-radius: 8px;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        font-weight: 600;
                        cursor: pointer;
                        transition: all 0.2s ease;
                        background: white;
                    }

                    .seat:hover:not(.booked):not(.selected) {
                        border-color: #667eea;
                        background: #f0f4ff;
                    }

                    .seat.selected {
                        background: #667eea;
                        color: white;
                        border-color: #667eea;
                    }

                    .seat.booked {
                        background: #e2e8f0;
                        color: #94a3b8;
                        cursor: not-allowed;
                    }

                    .btn-book {
                        background: var(--primary-gradient);
                        color: white;
                        border: none;
                        padding: 15px 40px;
                        border-radius: 12px;
                        font-weight: 600;
                        font-size: 1.1rem;
                        margin-top: 30px;
                        transition: all 0.3s ease;
                    }

                    .btn-book:hover {
                        transform: translateY(-2px);
                        box-shadow: 0 8px 20px rgba(102, 126, 234, 0.4);
                        color: white;
                    }

                    .empty-schedules {
                        text-align: center;
                        padding: 60px 20px;
                        background: white;
                        border-radius: 16px;
                        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
                    }

                    .route-info-card {
                        background: white;
                        border-radius: 16px;
                        padding: 25px;
                        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
                        margin-bottom: 30px;
                    }
                </style>
            </head>

            <body>
                <%@ include file="/views/partials/user-header.jsp" %>

                    <!-- Hero Section -->
                    <div class="booking-hero">
                        <div class="container">
                            <h1 class="mb-0">
                                <i class="fas fa-ticket-alt me-3"></i>Đặt vé xe
                            </h1>
                            <p class="mb-0 mt-2 opacity-90">Chọn lịch trình và ghế ngồi của bạn</p>
                        </div>
                    </div>

                    <div class="container mb-5">
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="fas fa-exclamation-circle me-2"></i>${error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <c:if test="${not empty route}">
                            <!-- Route Info -->
                            <div class="route-info-card">
                                <h3 class="mb-3">
                                    <i class="fas fa-route text-primary me-2"></i>${route.routeName}
                                </h3>
                                <div class="row">
                                    <div class="col-md-6">
                                        <p class="mb-2">
                                            <i class="fas fa-map-marker-alt text-primary me-2"></i>
                                            <strong>Điểm đi:</strong> ${route.departureCity}
                                        </p>
                                        <p class="mb-2">
                                            <i class="fas fa-map-marker-alt text-danger me-2"></i>
                                            <strong>Điểm đến:</strong> ${route.destinationCity}
                                        </p>
                                    </div>
                                    <div class="col-md-6">
                                        <p class="mb-2">
                                            <i class="fas fa-road me-2"></i>
                                            <strong>Khoảng cách:</strong> ${route.distance} km
                                        </p>
                                        <p class="mb-2">
                                            <i class="fas fa-clock me-2"></i>
                                            <strong>Thời gian:</strong> ${route.durationHours} giờ
                                        </p>
                                        <p class="mb-0">
                                            <i class="fas fa-money-bill-wave text-success me-2"></i>
                                            <strong>Giá vé:</strong>
                                            <span class="text-success fw-bold">
                                                <fmt:formatNumber value="${route.basePrice}" pattern="#,###" /> ₫
                                            </span>
                                        </p>
                                    </div>
                                </div>
                            </div>

                            <!-- Schedules List -->
                            <h4 class="mb-4">
                                <i class="fas fa-calendar-alt me-2"></i>Chọn lịch trình
                            </h4>

                            <c:choose>
                                <c:when test="${empty schedules}">
                                    <div class="empty-schedules">
                                        <i class="fas fa-calendar-times fa-3x text-muted mb-3"></i>
                                        <h5 class="text-muted">Không có lịch trình nào</h5>
                                        <p class="text-muted">Xin lỗi, hiện tại không có lịch trình nào cho tuyến đường
                                            này.</p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div id="schedulesList">
                                        <c:forEach var="schedule" items="${schedules}">
                                            <div class="schedule-card" data-schedule-id="${schedule.scheduleId}">
                                                <div class="schedule-info">
                                                    <div class="schedule-details">
                                                        <div class="schedule-time">
                                                            ${schedule.departureTime}
                                                            <i class="fas fa-arrow-right mx-2 text-muted"></i>
                                                            ${schedule.estimatedArrivalTime}
                                                        </div>
                                                        <div class="schedule-date mt-2">
                                                            <i class="fas fa-calendar me-2"></i>
                                                            ${schedule.departureDate}
                                                        </div>
                                                        <div class="mt-2">
                                                            <span class="badge bg-info me-2">
                                                                <i class="fas fa-bus me-1"></i>${schedule.busNumber}
                                                            </span>
                                                            <span class="badge bg-success">
                                                                <i
                                                                    class="fas fa-chair me-1"></i>${schedule.availableSeats}
                                                                ghế trống
                                                            </span>
                                                        </div>
                                                    </div>
                                                    <div class="schedule-price text-end">
                                                        <fmt:formatNumber value="${route.basePrice}" pattern="#,###" />
                                                        ₫
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>

                                    <!-- Seat Selection -->
                                    <div id="seatSelection" class="seat-selection">
                                        <h4 class="mb-4">
                                            <i class="fas fa-chair me-2"></i>Chọn ghế ngồi
                                        </h4>
                                        <div id="seatGrid" class="seat-grid">
                                            <!-- Seats will be loaded here via AJAX -->
                                        </div>
                                        <div class="text-center">
                                            <button type="button" id="btnBook" class="btn btn-book" disabled>
                                                <i class="fas fa-check me-2"></i>Đặt vé
                                            </button>
                                        </div>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </c:if>

                        <c:if test="${empty route}">
                            <div class="alert alert-warning">
                                <i class="fas fa-exclamation-triangle me-2"></i>
                                Không tìm thấy thông tin tuyến đường. Vui lòng quay lại trang tìm kiếm.
                            </div>
                        </c:if>
                    </div>

                    <%@ include file="/views/partials/footer.jsp" %>

                        <script>
                            let selectedScheduleId = null;
                            let selectedSeat = null;

                            // Handle schedule selection
                            document.querySelectorAll('.schedule-card').forEach(card => {
                                card.addEventListener('click', function () {
                                    // Remove previous selection
                                    document.querySelectorAll('.schedule-card').forEach(c => {
                                        c.classList.remove('selected');
                                    });

                                    // Mark this as selected
                                    this.classList.add('selected');
                                    selectedScheduleId = this.dataset.scheduleId;

                                    // Show seat selection
                                    document.getElementById('seatSelection').classList.add('active');

                                    // Load available seats
                                    loadAvailableSeats(selectedScheduleId);
                                });
                            });

                            function loadAvailableSeats(scheduleId) {
                                const seatGrid = document.getElementById('seatGrid');
                                seatGrid.innerHTML = '<div class="col-12 text-center"><i class="fas fa-spinner fa-spin"></i> Đang tải...</div>';

                                fetch('${pageContext.request.contextPath}/tickets/schedule-seats?scheduleId=' + scheduleId)
                                    .then(response => response.json())
                                    .then(data => {
                                        if (data.error) {
                                            seatGrid.innerHTML = '<div class="col-12 text-center text-danger">' + data.error + '</div>';
                                            return;
                                        }

                                        seatGrid.innerHTML = '';
                                        const totalSeats = data.totalSeats || 40;
                                        const bookedSeats = data.bookedSeats || [];

                                        for (let i = 1; i <= totalSeats; i++) {
                                            const seat = document.createElement('div');
                                            seat.className = 'seat';
                                            seat.textContent = i;
                                            seat.dataset.seatNumber = i;

                                            if (bookedSeats.includes(i)) {
                                                seat.classList.add('booked');
                                            } else {
                                                seat.addEventListener('click', function () {
                                                    // Remove previous selection
                                                    document.querySelectorAll('.seat').forEach(s => {
                                                        s.classList.remove('selected');
                                                    });

                                                    // Mark this as selected
                                                    this.classList.add('selected');
                                                    selectedSeat = i;

                                                    // Enable book button
                                                    document.getElementById('btnBook').disabled = false;
                                                });
                                            }

                                            seatGrid.appendChild(seat);
                                        }
                                    })
                                    .catch(error => {
                                        console.error('Error loading seats:', error);
                                        seatGrid.innerHTML = '<div class="col-12 text-center text-danger">Lỗi khi tải danh sách ghế</div>';
                                    });
                            }

                            // Handle booking
                            document.getElementById('btnBook').addEventListener('click', function () {
                                if (!selectedScheduleId || !selectedSeat) {
                                    alert('Vui lòng chọn lịch trình và ghế ngồi');
                                    return;
                                }

                                // Create form and submit
                                const form = document.createElement('form');
                                form.method = 'POST';
                                form.action = '${pageContext.request.contextPath}/tickets/book';

                                const scheduleIdInput = document.createElement('input');
                                scheduleIdInput.type = 'hidden';
                                scheduleIdInput.name = 'scheduleId';
                                scheduleIdInput.value = selectedScheduleId;

                                const seatNumberInput = document.createElement('input');
                                seatNumberInput.type = 'hidden';
                                seatNumberInput.name = 'seatNumber';
                                seatNumberInput.value = selectedSeat;

                                form.appendChild(scheduleIdInput);
                                form.appendChild(seatNumberInput);
                                document.body.appendChild(form);
                                form.submit();
                            });
                        </script>
            </body>

            </html>