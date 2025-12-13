<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Edit Ticket - Bus Management System</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
                <style>
                    :root {
                        --primary-color: #66bb6a;
                        --secondary-color: #64748b;
                        --success-color: #10b981;
                        --warning-color: #f59e0b;
                        --danger-color: #ef4444;
                        --light-bg: #f8fafc;
                        --border-color: #e2e8f0;
                        --text-dark: #1e293b;
                        --text-light: #64748b;
                    }

                    body {
                        background: linear-gradient(135deg, #66bb6a 0%, #81c784 100%);
                        min-height: 100vh;
                        font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
                    }

                    .main-container {
                        background: white;
                        border-radius: 20px;
                        box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
                        overflow: hidden;
                        margin: 2rem auto;
                        max-width: 1200px;
                    }

                    .header-section {
                        background: linear-gradient(135deg, #66bb6a, #4caf50);
                        color: white;
                        padding: 2rem;
                        position: relative;
                        overflow: hidden;
                    }

                    .header-section::before {
                        content: '';
                        position: absolute;
                        top: 0;
                        right: 0;
                        width: 200px;
                        height: 200px;
                        background: rgba(255, 255, 255, 0.1);
                        border-radius: 50%;
                        transform: translate(50%, -50%);
                    }

                    .header-content {
                        position: relative;
                        z-index: 2;
                    }

                    .page-title {
                        font-size: 2rem;
                        font-weight: 700;
                        margin-bottom: 0.5rem;
                    }

                    .page-subtitle {
                        opacity: 0.9;
                        font-size: 1.1rem;
                    }

                    .form-section {
                        padding: 2rem;
                    }

                    .section-card {
                        background: white;
                        border: 1px solid var(--border-color);
                        border-radius: 12px;
                        padding: 1.5rem;
                        margin-bottom: 1.5rem;
                        transition: all 0.3s ease;
                    }

                    .section-card:hover {
                        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
                    }

                    .section-title {
                        display: flex;
                        align-items: center;
                        gap: 0.75rem;
                        font-size: 1.25rem;
                        font-weight: 600;
                        color: var(--text-dark);
                        margin-bottom: 1.5rem;
                        padding-bottom: 0.75rem;
                        border-bottom: 2px solid var(--border-color);
                    }

                    .section-icon {
                        width: 40px;
                        height: 40px;
                        background: linear-gradient(135deg, #66bb6a, #4caf50);
                        border-radius: 10px;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        color: white;
                        font-size: 1.1rem;
                    }

                    .form-label {
                        font-weight: 600;
                        color: var(--text-dark);
                        margin-bottom: 0.5rem;
                        display: flex;
                        align-items: center;
                        gap: 0.5rem;
                    }

                    .form-control,
                    .form-select {
                        border: 2px solid var(--border-color);
                        border-radius: 8px;
                        padding: 0.75rem 1rem;
                        font-size: 1rem;
                        transition: all 0.3s ease;
                    }

                    .form-control:focus,
                    .form-select:focus {
                        border-color: #66bb6a;
                        box-shadow: 0 0 0 3px rgba(102, 187, 106, 0.1);
                    }

                    .form-text {
                        font-size: 0.875rem;
                        color: var(--text-light);
                        margin-top: 0.25rem;
                    }

                    .btn-primary {
                        background: linear-gradient(135deg, #66bb6a, #4caf50);
                        border: none;
                        border-radius: 8px;
                        padding: 0.75rem 2rem;
                        font-weight: 600;
                        transition: all 0.3s ease;
                    }

                    .btn-primary:hover {
                        transform: translateY(-2px);
                        box-shadow: 0 8px 25px rgba(102, 187, 106, 0.3);
                        background: linear-gradient(135deg, #4caf50, #66bb6a);
                    }

                    .btn-secondary {
                        background: var(--secondary-color);
                        border: none;
                        border-radius: 8px;
                        padding: 0.75rem 2rem;
                        font-weight: 600;
                        transition: all 0.3s ease;
                    }

                    .btn-secondary:hover {
                        background: #475569;
                        transform: translateY(-2px);
                    }

                    .status-badge {
                        display: inline-flex;
                        align-items: center;
                        gap: 0.5rem;
                        padding: 0.5rem 1rem;
                        border-radius: 20px;
                        font-weight: 600;
                        font-size: 0.875rem;
                    }

                    .status-confirmed {
                        background: rgba(16, 185, 129, 0.1);
                        color: var(--success-color);
                    }

                    .status-pending {
                        background: rgba(245, 158, 11, 0.1);
                        color: var(--warning-color);
                    }

                    .status-cancelled {
                        background: rgba(239, 68, 68, 0.1);
                        color: var(--danger-color);
                    }

                    .info-card {
                        background: linear-gradient(135deg, #f0f9ff, #e0f2fe);
                        border: 1px solid #bae6fd;
                        border-radius: 12px;
                        padding: 1.5rem;
                        margin-bottom: 1.5rem;
                    }

                    .info-row {
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        padding: 0.75rem 0;
                        border-bottom: 1px solid rgba(59, 130, 246, 0.1);
                    }

                    .info-row:last-child {
                        border-bottom: none;
                    }

                    .info-label {
                        font-weight: 600;
                        color: var(--text-dark);
                    }

                    .info-value {
                        color: var(--text-light);
                    }

                    .price-display {
                        background: linear-gradient(135deg, #fef3c7, #fde68a);
                        border: 1px solid #f59e0b;
                        border-radius: 12px;
                        padding: 1.5rem;
                        text-align: center;
                    }

                    .price-amount {
                        font-size: 2rem;
                        font-weight: 700;
                        color: var(--warning-color);
                    }

                    .alert-custom {
                        border: none;
                        border-radius: 12px;
                        padding: 1rem 1.5rem;
                        margin-bottom: 1.5rem;
                    }

                    .loading-spinner {
                        display: none;
                        text-align: center;
                        padding: 2rem;
                    }

                    .spinner-border {
                        width: 3rem;
                        height: 3rem;
                        border-width: 0.3em;
                    }

                    @media (max-width: 768px) {
                        .main-container {
                            margin: 1rem;
                            border-radius: 16px;
                        }

                        .header-section {
                            padding: 1.5rem;
                        }

                        .form-section {
                            padding: 1.5rem;
                        }

                        .page-title {
                            font-size: 1.5rem;
                        }
                    }
                </style>
            </head>

            <body>
                <div class="container-fluid">
                    <div class="main-container">
                        <!-- Header Section -->
                        <div class="header-section">
                            <div class="header-content">
                                <div class="d-flex align-items-center justify-content-between">
                                    <div>
                                        <h1 class="page-title">
                                            <i class="fas fa-edit me-3"></i>
                                            Edit Ticket
                                        </h1>
                                        <p class="page-subtitle mb-0">
                                            Update ticket information #${ticket.ticketNumber}
                                        </p>
                                    </div>
                                    <div class="text-end">
                                        <div
                                            class="status-badge ${ticket.status == 'CONFIRMED' ? 'status-confirmed' : ticket.status == 'PENDING' ? 'status-pending' : 'status-cancelled'}">
                                            <i class="fas fa-circle"></i>
                                            ${ticket.status == 'CONFIRMED' ? 'Confirmed' : ticket.status == 'PENDING'
                                            ? 'Pending' : 'Cancelled'}
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Form Section -->
                        <div class="form-section">
                            <form action="${pageContext.request.contextPath}/admin/tickets/edit" method="post"
                                id="editTicketForm">
                                <input type="hidden" name="ticketId" value="${ticket.ticketId}">

                                <!-- Ticket Information Card -->
                                <div class="section-card">
                                    <div class="section-title">
                                        <div class="section-icon">
                                            <i class="fas fa-ticket-alt"></i>
                                        </div>
                                        Ticket Information
                                    </div>

                                    <div class="row g-4">
                                        <div class="col-md-6">
                                            <label for="ticketNumber" class="form-label">
                                                <i class="fas fa-hashtag"></i>
                                                Ticket Number
                                            </label>
                                            <input type="text" class="form-control" id="ticketNumber"
                                                name="ticketNumber" value="${ticket.ticketNumber}" readonly>
                                            <div class="form-text">Ticket number is generated automatically</div>
                                        </div>

                                        <div class="col-md-6">
                                            <label for="ticketPrice" class="form-label">
                                                <i class="fas fa-money-bill-wave"></i>
                                                Ticket Price (₫)
                                            </label>
                                            <input type="number" class="form-control" id="ticketPrice"
                                                name="ticketPrice" value="${ticket.ticketPrice}" min="0" step="1000"
                                                required>
                                        </div>
                                    </div>
                                </div>

                                <!-- Route Information Card -->
                                <div class="section-card">
                                    <div class="section-title">
                                        <div class="section-icon">
                                            <i class="fas fa-route"></i>
                                        </div>
                                        Route Information
                                    </div>

                                    <div class="row g-4">
                                        <div class="col-md-6">
                                            <label for="routeId" class="form-label">
                                                <i class="fas fa-map-marked-alt"></i>
                                                Route *
                                            </label>
                                            <select class="form-select" id="routeId" name="routeId" required>
                                                <option value="">Select a route</option>
                                                <c:forEach var="route" items="${routes}">
                                                    <option value="${route.routeId}" data-price="${route.basePrice}"
                                                        ${currentRouteId != null && currentRouteId.equals(route.routeId) ? 'selected' : ''}>
                                                        ${route.departureCity} → ${route.destinationCity} (
                                                        <fmt:formatNumber value="${route.basePrice}" pattern="#,###" />
                                                        ₫)
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>

                                        <div class="col-md-6">
                                            <label for="busId" class="form-label">
                                                <i class="fas fa-bus"></i>
                                                Bus *
                                            </label>
                                            <select class="form-select" id="busId" name="busId" required>
                                                <option value="">Select a bus</option>
                                                <c:forEach var="bus" items="${buses}">
                                                    <option value="${bus.busId}" data-seats="${bus.totalSeats}"
                                                        ${currentBusId != null && currentBusId.equals(bus.busId) ? 'selected' : ''}>
                                                        ${bus.busNumber} - ${bus.busType} (${bus.totalSeats} seats)
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>
                                </div>

                                <!-- Passenger Information Card -->
                                <div class="section-card">
                                    <div class="section-title">
                                        <div class="section-icon">
                                            <i class="fas fa-user"></i>
                                        </div>
                                        Passenger Information
                                    </div>

                                    <div class="row g-4">
                                        <div class="col-md-6">
                                            <label for="userId" class="form-label">
                                                <i class="fas fa-user-circle"></i>
                                                Passenger *
                                            </label>
                                            <select class="form-select" id="userId" name="userId" required>
                                                <option value="">Select a passenger</option>
                                                <c:forEach var="user" items="${users}">
                                                    <option value="${user.userId}"
                                                        ${ticket != null && ticket.userId != null && ticket.userId.equals(user.userId) ? 'selected' : ''}>
                                                        ${user.fullName} - ${user.phoneNumber}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>

                                        <div class="col-md-6">
                                            <label for="seatNumber" class="form-label">
                                                <i class="fas fa-chair"></i>
                                                Seat Number *
                                            </label>
                                            <input type="number" class="form-control" id="seatNumber" name="seatNumber"
                                                value="${ticket.seatNumber}" min="1" required>
                                            <div class="form-text">Enter a seat number between 1 and the bus capacity</div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Departure Information Card -->
                                <div class="section-card">
                                    <div class="section-title">
                                        <div class="section-icon">
                                            <i class="fas fa-calendar-alt"></i>
                                        </div>
                                        Departure Information
                                    </div>

                                    <div class="row g-4">
                                        <div class="col-md-6">
                                            <label for="departureDate" class="form-label">
                                                <i class="fas fa-calendar"></i>
                                                Departure Date *
                                            </label>
                                            <input type="date" class="form-control" id="departureDate"
                                                name="departureDate" value="${ticket.departureDate}" required>
                                        </div>

                                        <div class="col-md-6">
                                            <label for="departureTime" class="form-label">
                                                <i class="fas fa-clock"></i>
                                                Departure Time *
                                            </label>
                                            <input type="time" class="form-control" id="departureTime"
                                                name="departureTime" value="${ticket.departureTime}" required>
                                        </div>
                                    </div>
                                </div>

                                <!-- Status Information Card -->
                                <div class="section-card">
                                    <div class="section-title">
                                        <div class="section-icon">
                                            <i class="fas fa-info-circle"></i>
                                        </div>
                                        Ticket Status
                                    </div>

                                    <div class="row g-4">
                                        <div class="col-md-6">
                                            <label for="status" class="form-label">
                                                <i class="fas fa-flag"></i>
                                                Ticket Status
                                            </label>
                                            <select class="form-select" id="status" name="status">
                                                <option value="CONFIRMED" ${ticket !=null && ticket.status
                                                    eq 'CONFIRMED' ? 'selected' : '' }>Confirmed</option>
                                                <option value="PENDING" ${ticket !=null && ticket.status eq 'PENDING'
                                                    ? 'selected' : '' }>Pending</option>
                                                <option value="CANCELLED" ${ticket !=null && ticket.status
                                                    eq 'CANCELLED' ? 'selected' : '' }>Cancelled</option>
                                            </select>
                                        </div>

                                        <div class="col-md-6">
                                            <label for="paymentStatus" class="form-label">
                                                <i class="fas fa-credit-card"></i>
                                                Payment Status
                                            </label>
                                            <select class="form-select" id="paymentStatus" name="paymentStatus">
                                                <option value="PAID" ${ticket !=null && ticket.paymentStatus eq 'PAID'
                                                    ? 'selected' : '' }>Paid</option>
                                                <option value="PENDING" ${ticket !=null && ticket.paymentStatus
                                                    eq 'PENDING' ? 'selected' : '' }>Pending Payment</option>
                                                <option value="CANCELLED" ${ticket !=null && ticket.paymentStatus
                                                    eq 'CANCELLED' ? 'selected' : '' }>Cancelled</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>

                                <!-- Price Summary Card -->
                                <div class="section-card">
                                    <div class="price-display">
                                        <div class="d-flex align-items-center justify-content-center mb-3">
                                            <i class="fas fa-calculator me-2"
                                                style="font-size: 1.5rem; color: var(--warning-color);"></i>
                                            <h5 class="mb-0">Total Ticket Price</h5>
                                        </div>
                                        <div class="price-amount" id="totalPrice">
                                            <fmt:formatNumber value="${ticket.ticketPrice}" pattern="#,###" />₫
                                        </div>
                                    </div>
                                </div>

                                <!-- Action Buttons -->
                                <div class="d-flex justify-content-between align-items-center mt-4">
                                    <a href="${pageContext.request.contextPath}/admin/tickets"
                                        class="btn btn-secondary">
                                        <i class="fas fa-arrow-left me-2"></i>
                                        Back
                                    </a>

                                    <div class="d-flex gap-3">
                                        <button type="button" class="btn btn-outline-danger" id="cancelTicketBtn">
                                            <i class="fas fa-times me-2"></i>
                                            Cancel Ticket
                                        </button>
                                        <button type="submit" class="btn btn-primary" id="updateTicketBtn">
                                            <i class="fas fa-save me-2"></i>
                                            Update Ticket
                                        </button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- Loading Spinner -->
                <div class="loading-spinner" id="loadingSpinner">
                    <div class="spinner-border text-primary" role="status">
                        <span class="visually-hidden">Loading...</span>
                    </div>
                    <p class="mt-3">Processing request...</p>
                </div>

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                <script>
                    document.addEventListener('DOMContentLoaded', function () {
                        const form = document.getElementById('editTicketForm');
                        const loadingSpinner = document.getElementById('loadingSpinner');
                        const updateBtn = document.getElementById('updateTicketBtn');
                        const cancelBtn = document.getElementById('cancelTicketBtn');
                        const routeSelect = document.getElementById('routeId');
                        const priceInput = document.getElementById('ticketPrice');
                        const totalPriceDisplay = document.getElementById('totalPrice');

                        // Update price when route changes
                        routeSelect.addEventListener('change', function () {
                            const selectedOption = this.options[this.selectedIndex];
                            const price = selectedOption.getAttribute('data-price');
                            if (price) {
                                priceInput.value = price;
                                updateTotalPrice();
                            }
                        });

                        // Update total price display
                        function updateTotalPrice() {
                            const price = priceInput.value;
                            if (price) {
                                totalPriceDisplay.textContent = new Intl.NumberFormat('vi-VN').format(price) + '₫';
                            }
                        }

                        // Update total price when price input changes
                        priceInput.addEventListener('input', updateTotalPrice);

                        // Form submission
                        form.addEventListener('submit', function (e) {
                            e.preventDefault();

                            // Show loading spinner
                            loadingSpinner.style.display = 'block';
                            form.style.display = 'none';

                            // Submit form after a short delay to show loading
                            setTimeout(() => {
                                form.submit();
                            }, 500);
                        });

                        // Cancel ticket functionality
                        cancelBtn.addEventListener('click', function () {
                            if (confirm('Are you sure you want to cancel this ticket?')) {
                                // Set status to cancelled
                                document.getElementById('status').value = 'CANCELLED';
                                document.getElementById('paymentStatus').value = 'CANCELLED';

                                // Submit form
                                form.submit();
                            }
                        });

                        // Initialize total price display
                        updateTotalPrice();
                    });
                </script>
            </body>

            </html>
