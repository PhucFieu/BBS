<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Create New Ticket - Bus Booking System</title>
                <base href="${pageContext.request.contextPath}/">
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
                <style>
                    /* Ticket Form Styles - New Design */
                    :root {
                        --primary-color: #66bb6a;
                        --secondary-color: #81c784;
                        --success-color: #4caf50;
                        --info-color: #66bb6a;
                        --warning-color: #ffc107;
                        --danger-color: #dc3545;
                        --light-color: #e8f5e9;
                        --dark-color: #2e7d32;
                        --border-radius: 0.5rem;
                        --box-shadow: 0 0.125rem 0.25rem rgba(102, 187, 106, 0.15);
                        --box-shadow-lg: 0 1rem 3rem rgba(102, 187, 106, 0.25);
                    }

                    /* Sidebar Styles */
                    .sidebar {
                        position: fixed;
                        top: 0;
                        bottom: 0;
                        left: 0;
                        z-index: 100;
                        padding: 48px 0 0;
                        box-shadow: inset -1px 0 0 rgba(0, 0, 0, 0.1);
                        min-height: 100vh;
                    }

                    .sidebar .nav-link {
                        color: #333;
                        font-weight: 500;
                        padding: 0.75rem 1rem;
                        border-radius: 0.375rem;
                        margin: 0.125rem 0.5rem;
                        transition: all 0.2s ease-in-out;
                    }

                    .sidebar .nav-link:hover {
                        background-color: var(--light-color);
                        color: var(--primary-color);
                    }

                    .sidebar .nav-link.active {
                        background-color: var(--primary-color);
                        color: white;
                    }

                    /* Card Styles */
                    .card {
                        border: none;
                        border-radius: var(--border-radius);
                        box-shadow: var(--box-shadow);
                        transition: all 0.3s ease;
                    }

                    .card:hover {
                        box-shadow: var(--box-shadow-lg);
                    }

                    .card-header {
                        border-bottom: 1px solid rgba(0, 0, 0, 0.125);
                        border-radius: var(--border-radius) var(--border-radius) 0 0 !important;
                        font-weight: 600;
                    }

                    /* Form Styles */
                    .form-label {
                        font-weight: 600;
                        color: var(--dark-color);
                        margin-bottom: 0.5rem;
                    }

                    .form-control:focus,
                    .form-select:focus {
                        border-color: var(--primary-color);
                        box-shadow: 0 0 0 0.2rem rgba(102, 187, 106, 0.25);
                    }

                    .form-control.is-invalid,
                    .form-select.is-invalid {
                        border-color: var(--danger-color);
                    }

                    .form-control.is-valid,
                    .form-select.is-valid {
                        border-color: var(--success-color);
                    }

                    /* Passenger Selection Dropdown */
                    .form-select {
                        background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3e%3cpath fill='none' stroke='%23343a40' stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='m1 6 7 7 7-7'/%3e%3c/svg%3e");
                        background-repeat: no-repeat;
                        background-position: right 0.75rem center;
                        background-size: 16px 12px;
                    }

                    /* Seat Grid */
                    .seat-grid {
                        display: grid;
                        grid-template-columns: repeat(4, 1fr);
                        gap: 10px;
                        align-items: center;
                        margin-top: 1rem;
                    }

                    .seat {
                        width: 48px;
                        height: 48px;
                        border: 2px solid #dee2e6;
                        border-radius: var(--border-radius);
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        cursor: pointer;
                        font-weight: 600;
                        font-size: 0.95rem;
                        transition: all 0.2s ease;
                        user-select: none;
                    }

                    .seat:hover {
                        transform: translateY(-2px);
                        box-shadow: var(--box-shadow);
                    }

                    .seat.available {
                        background-color: #d4edda;
                        border-color: var(--success-color);
                        color: #155724;
                    }

                    .seat.available:hover {
                        background-color: #c3e6cb;
                        border-color: #157347;
                    }

                    .seat.occupied {
                        background-color: #f8d7da;
                        border-color: var(--danger-color);
                        color: #721c24;
                        cursor: not-allowed;
                        opacity: 0.7;
                    }

                    .seat.occupied:hover {
                        transform: none;
                        box-shadow: none;
                    }

                    .seat.selected {
                        background-color: var(--primary-color);
                        border-color: var(--primary-color);
                        color: white;
                        transform: translateY(-2px);
                        box-shadow: 0 0.25rem 0.5rem rgba(102, 187, 106, 0.3);
                    }

                    .seat.selected:hover {
                        background-color: #4caf50;
                        border-color: #4caf50;
                    }

                    /* Seat Legend */
                    .seat-legend {
                        background: var(--light-color);
                        border-radius: var(--border-radius);
                        padding: 1rem;
                        margin-top: 1rem;
                    }

                    .seat-legend-item {
                        width: 20px;
                        height: 20px;
                        border-radius: 50%;
                        border: 2px solid #dee2e6;
                        display: inline-block;
                    }

                    .seat-legend-item.available {
                        background-color: var(--success-color);
                    }

                    .seat-legend-item.occupied {
                        background-color: var(--danger-color);
                    }

                    .seat-legend-item.selected {
                        background-color: var(--primary-color);
                    }

                    /* Price Display */
                    #totalPrice {
                        font-size: 2rem;
                        font-weight: 700;
                        color: var(--primary-color);
                    }

                    /* Button Styles */
                    .btn {
                        border-radius: var(--border-radius);
                        font-weight: 500;
                        transition: all 0.2s ease;
                    }

                    .btn-primary {
                        background: linear-gradient(135deg, var(--primary-color) 0%, #4caf50 100%);
                        border: none;
                    }

                    .btn-primary:hover {
                        background: linear-gradient(135deg, #4caf50 0%, #388e3c 100%);
                        transform: translateY(-1px);
                        box-shadow: 0 0.25rem 0.5rem rgba(102, 187, 106, 0.3);
                    }

                    .btn-outline-primary:hover {
                        transform: translateY(-1px);
                    }

                    .btn-outline-secondary:hover {
                        transform: translateY(-1px);
                    }

                    .btn-outline-danger:hover {
                        transform: translateY(-1px);
                    }

                    /* Validation Styles */
                    .was-validated .form-control:invalid,
                    .was-validated .form-select:invalid {
                        border-color: var(--danger-color);
                    }

                    .was-validated .form-control:valid,
                    .was-validated .form-select:valid {
                        border-color: var(--success-color);
                    }

                    .invalid-feedback {
                        display: none;
                        width: 100%;
                        margin-top: 0.25rem;
                        font-size: 0.875rem;
                        color: var(--danger-color);
                    }

                    .was-validated .form-control:invalid~.invalid-feedback,
                    .was-validated .form-select:invalid~.invalid-feedback {
                        display: block;
                    }

                    /* Loading States */
                    .loading {
                        opacity: 0.6;
                        pointer-events: none;
                    }

                    .spinner-border-sm {
                        width: 1rem;
                        height: 1rem;
                    }

                    /* Responsive Design */
                    @media (max-width: 768px) {
                        .sidebar {
                            position: static;
                            height: auto;
                            padding: 1rem 0;
                        }

                        .seat-grid {
                            grid-template-columns: repeat(4, 1fr);
                        }

                        .seat {
                            width: 42px;
                            height: 42px;
                            font-size: 0.85rem;
                        }
                    }

                    @media (max-width: 576px) {
                        .seat-grid {
                            grid-template-columns: repeat(2, 1fr);
                        }

                        .seat {
                            width: 36px;
                            height: 36px;
                            font-size: 0.8rem;
                        }

                        .card-body {
                            padding: 1rem;
                        }
                    }

                    /* Animation Classes */
                    .fade-in {
                        animation: fadeIn 0.3s ease-in-out;
                    }

                    @keyframes fadeIn {
                        from {
                            opacity: 0;
                            transform: translateY(-10px);
                        }

                        to {
                            opacity: 1;
                            transform: translateY(0);
                        }
                    }

                    .slide-in {
                        animation: slideIn 0.3s ease-in-out;
                    }

                    @keyframes slideIn {
                        from {
                            opacity: 0;
                            transform: translateX(-20px);
                        }

                        to {
                            opacity: 1;
                            transform: translateX(0);
                        }
                    }

                    /* Utility Classes */
                    .text-primary {
                        color: var(--primary-color) !important;
                    }

                    .text-success {
                        color: var(--success-color) !important;
                    }

                    .text-danger {
                        color: var(--danger-color) !important;
                    }

                    .text-muted {
                        color: var(--secondary-color) !important;
                    }

                    .bg-primary {
                        background-color: var(--primary-color) !important;
                    }

                    .bg-success {
                        background-color: var(--success-color) !important;
                    }

                    .bg-info {
                        background-color: var(--info-color) !important;
                    }

                    .bg-warning {
                        background-color: var(--warning-color) !important;
                    }

                    .bg-secondary {
                        background-color: var(--secondary-color) !important;
                    }

                    .bg-light {
                        background-color: var(--light-color) !important;
                    }

                    /* Focus States */
                    .form-control:focus,
                    .form-select:focus,
                    .btn:focus {
                        outline: none;
                        box-shadow: 0 0 0 0.2rem rgba(102, 187, 106, 0.25);
                    }
                </style>
            </head>

            <body class="bg-light">
                <div class="container-fluid">
                    <div class="row">
                        <!-- Sidebar -->
                        <div class="col-md-3 col-lg-2 d-md-block bg-white sidebar">
                            <div class="position-sticky pt-3">
                                <div class="text-center mb-4">
                                    <i class="fas fa-bus fa-3x text-primary"></i>
                                    <h5 class="mt-2">Bus Booking System</h5>
                                </div>
                                <ul class="nav flex-column">
                                    <li class="nav-item">
                                        <a class="nav-link" href="${pageContext.request.contextPath}/admin">
                                            <i class="fas fa-home me-2"></i>Home
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link active"
                                            href="${pageContext.request.contextPath}/admin/tickets">
                                            <i class="fas fa-plus-circle me-2"></i>Create Ticket
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/tickets">
                                            <i class="fas fa-ticket-alt me-2"></i>Manage Tickets
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/passengers">
                                            <i class="fas fa-users me-2"></i>Passengers
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
                                    <i class="fas fa-ticket-alt me-2"></i>Create New Ticket
                                </h1>
                                <div class="btn-toolbar mb-2 mb-md-0">
                                    <a href="${pageContext.request.contextPath}/admin/tickets"
                                        class="btn btn-outline-secondary">
                                        <i class="fas fa-arrow-left me-1"></i>Back
                                    </a>
                                </div>
                            </div>

                            <!-- Notification Messages -->
                            <c:if test="${not empty param.message}">
                                <div class="alert alert-success alert-dismissible fade show" role="alert">
                                    <i class="fas fa-check-circle me-2"></i>
                                    <strong>Success!</strong> ${param.message}
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"
                                        aria-label="Close"></button>
                                </div>
                            </c:if>
                            <c:if test="${not empty param.error}">
                                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                    <i class="fas fa-exclamation-circle me-2"></i>
                                    <strong>Error!</strong> ${param.error}
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"
                                        aria-label="Close"></button>
                                </div>
                            </c:if>
                            <c:if test="${not empty param.warning}">
                                <div class="alert alert-warning alert-dismissible fade show" role="alert">
                                    <i class="fas fa-exclamation-triangle me-2"></i>
                                    <strong>Warning!</strong> ${param.warning}
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"
                                        aria-label="Close"></button>
                                </div>
                            </c:if>
                            <c:if test="${not empty param.info}">
                                <div class="alert alert-info alert-dismissible fade show" role="alert">
                                    <i class="fas fa-info-circle me-2"></i>
                                    <strong>Info:</strong> ${param.info}
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"
                                        aria-label="Close"></button>
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
                                                    <i class="fas fa-route me-2"></i>Route Information
                                                </h5>
                                            </div>
                                            <div class="card-body">
                                                <div class="row g-3">
                                                    <div class="col-md-6">
                                                        <label for="routeId" class="form-label">
                                                            Route <span class="text-danger">*</span>
                                                        </label>
                                                        <select class="form-select" id="routeId" name="routeId"
                                                            required>
                                                            <option value="">Select a route</option>
                                                            <c:forEach var="route" items="${routes}">
                                                                <option value="${route.routeId}"
                                                                    data-price="${route.basePrice}">
                                                                    ${route.departureCity} → ${route.destinationCity}
                                                                </option>
                                                            </c:forEach>
                                                        </select>
                                                        <div class="invalid-feedback">Please select a route</div>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <label for="busId" class="form-label">
                                                            Bus <span class="text-danger">*</span>
                                                        </label>
                                                        <select class="form-select" id="busId" name="busId" required>
                                                            <option value="">Select a bus</option>
                                                            <c:forEach var="bus" items="${buses}">
                                                                <option value="${bus.busId}"
                                                                    data-seats="${bus.totalSeats}">
                                                                    ${bus.busNumber} - ${bus.busType} (${bus.totalSeats}
                                                                    seats)
                                                                </option>
                                                            </c:forEach>
                                                        </select>
                                                        <div class="invalid-feedback">Please select a bus</div>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <label for="boardingStationId" class="form-label">
                                                            Boarding Bus Station <span class="text-danger">*</span>
                                                        </label>
                                                        <select class="form-select" id="boardingStationId"
                                                            name="boardingStationId" required>
                                                            <option value="">Select boarding bus station</option>
                                                            <c:forEach var="station" items="${stations}">
                                                                <option value="${station.stationId}" <c:if
                                                                    test="${ticket != null && ticket.boardingStationId == station.stationId}">
                                                                    selected</c:if>>
                                                                    ${station.stationName} (${station.city})
                                                                </option>
                                                            </c:forEach>
                                                        </select>
                                                        <div class="invalid-feedback">Please select a boarding bus
                                                            station</div>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <label for="alightingStationId" class="form-label">
                                                            Drop-off Bus Station <span class="text-danger">*</span>
                                                        </label>
                                                        <select class="form-select" id="alightingStationId"
                                                            name="alightingStationId" required>
                                                            <option value="">Select drop-off bus station</option>
                                                            <c:forEach var="station" items="${stations}">
                                                                <option value="${station.stationId}" <c:if
                                                                    test="${ticket != null && ticket.alightingStationId == station.stationId}">
                                                                    selected</c:if>>
                                                                    ${station.stationName} (${station.city})
                                                                </option>
                                                            </c:forEach>
                                                        </select>
                                                        <div class="invalid-feedback">Please select a drop-off bus
                                                            station</div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Passenger Information -->
                                        <div class="card mb-4">
                                            <div class="card-header bg-success text-white">
                                                <h5 class="mb-0">
                                                    <i class="fas fa-user me-2"></i>Passenger Information
                                                </h5>
                                            </div>
                                            <div class="card-body">
                                                <div class="mb-3">
                                                    <label for="userId" class="form-label">
                                                        Select Passenger <span class="text-danger">*</span>
                                                    </label>
                                                    <select class="form-select" id="userId" name="userId" required>
                                                        <option value="">-- Select passenger --</option>
                                                        <c:forEach var="user" items="${users}">
                                                            <option value="${user.userId}">
                                                                ${user.fullName} - ${user.phoneNumber}
                                                                <c:if test="${not empty user.email}">
                                                                    (${user.email})
                                                                </c:if>
                                                            </option>
                                                        </c:forEach>
                                                    </select>
                                                    <div class="invalid-feedback">Please select a passenger</div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Schedule Information -->
                                        <div class="card mb-4">
                                            <div class="card-header bg-info text-white">
                                                <h5 class="mb-0">
                                                    <i class="fas fa-calendar me-2"></i>Schedule Information
                                                </h5>
                                            </div>
                                            <div class="card-body">
                                                <div class="row g-3">
                                                    <div class="col-md-6">
                                                        <label for="departureDate" class="form-label">
                                                            Departure Date <span class="text-danger">*</span>
                                                        </label>
                                                        <input type="date" class="form-control" id="departureDate"
                                                            name="departureDate" required>
                                                        <div class="invalid-feedback">Please select a departure date
                                                        </div>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <label for="scheduleId" class="form-label">
                                                            Select Schedule <span class="text-danger">*</span>
                                                        </label>
                                                        <select class="form-select" id="scheduleId" name="scheduleId"
                                                            required>
                                                            <option value="">-- Select schedule --</option>
                                                        </select>
                                                        <div class="invalid-feedback">Please select a schedule</div>
                                                        <small class="form-text text-muted">Selecting a schedule will
                                                            auto-fill the departure time</small>
                                                        <!-- Hidden field to store departureTime for backward compatibility -->
                                                        <input type="hidden" id="departureTime" name="departureTime">
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Seat Selection -->
                                        <div class="card mb-4">
                                            <div class="card-header bg-warning text-dark">
                                                <h5 class="mb-0">
                                                    <i class="fas fa-chair me-2"></i>Select Seat
                                                </h5>
                                            </div>
                                            <div class="card-body">
                                                <div class="row g-3">
                                                    <div class="col-md-6">
                                                        <label for="seatNumber" class="form-label">
                                                            Seat Number <span class="text-danger">*</span>
                                                        </label>
                                                        <input type="number" class="form-control" id="seatNumber"
                                                            name="seatNumber" min="1" max="50"
                                                            placeholder="Enter a seat number between 1 and bus capacity"
                                                            required>
                                                        <div class="invalid-feedback">Please enter a valid seat number
                                                        </div>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <label class="form-label">View available seats</label>
                                                        <div>
                                                            <button type="button" class="btn btn-outline-primary"
                                                                id="viewSeatsBtn" onclick="viewAvailableSeats()">
                                                                <i class="fas fa-eye me-1"></i>View seats
                                                            </button>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Seat Map -->
                                                <div id="seatMap" class="mt-3" style="display: none;">
                                                    <h6>Seat map:</h6>
                                                    <div class="seat-grid" id="seatGrid"></div>
                                                    <div class="seat-legend mt-3">
                                                        <div class="d-flex gap-3">
                                                            <div class="d-flex align-items-center gap-2">
                                                                <div class="seat-legend-item available"></div>
                                                                <span>Available</span>
                                                            </div>
                                                            <div class="d-flex align-items-center gap-2">
                                                                <div class="seat-legend-item occupied"></div>
                                                                <span>Booked</span>
                                                            </div>
                                                            <div class="d-flex align-items-center gap-2">
                                                                <div class="seat-legend-item selected"></div>
                                                                <span>Selected</span>
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
                                                    <i class="fas fa-ticket-alt me-2"></i>Ticket Information
                                                </h5>
                                            </div>
                                            <div class="card-body">
                                                <div class="mb-3">
                                                    <label for="ticketPrice" class="form-label">
                                                        Ticket Price (₫) <span class="text-danger">*</span>
                                                    </label>
                                                    <input type="number" class="form-control" id="ticketPrice"
                                                        name="ticketPrice" min="0" step="1000"
                                                        placeholder="Ticket price will auto-fill when selecting a route"
                                                        required>
                                                    <div class="form-text">Ticket price will be auto-filled after
                                                        selecting a route</div>
                                                    <div class="invalid-feedback">Please enter ticket price</div>
                                                </div>

                                                <div class="mb-3">
                                                    <label for="status" class="form-label">Ticket Status</label>
                                                    <select class="form-select" id="status" name="status">
                                                        <option value="CONFIRMED" selected>Confirmed</option>
                                                        <option value="PENDING">Pending</option>
                                                        <option value="CANCELLED">Cancelled</option>
                                                    </select>
                                                </div>

                                                <div class="mb-3">
                                                    <label for="paymentStatus" class="form-label">Payment Status</label>
                                                    <select class="form-select" id="paymentStatus" name="paymentStatus">
                                                        <option value="PENDING" selected>Pending Payment</option>
                                                        <option value="PAID">Paid</option>
                                                        <option value="CANCELLED">Cancelled</option>
                                                    </select>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Total Price -->
                                        <div class="card mb-4">
                                            <div class="card-body text-center">
                                                <h6 class="text-muted mb-2">Total Price</h6>
                                                <h3 class="text-primary mb-0" id="totalPrice">0 đ</h3>
                                            </div>
                                        </div>

                                        <!-- Action Buttons -->
                                        <div class="d-grid gap-2">
                                            <button type="submit" class="btn btn-primary btn-lg">
                                                <i class="fas fa-save me-2"></i>Create Ticket
                                            </button>
                                            <a href="${pageContext.request.contextPath}/admin/tickets"
                                                class="btn btn-outline-secondary">
                                                <i class="fas fa-times me-2"></i>Cancel
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
                    // Auto-hide alerts after 5 seconds
                    document.addEventListener('DOMContentLoaded', function () {
                        const alerts = document.querySelectorAll('.alert');
                        alerts.forEach(function (alert) {
                            setTimeout(function () {
                                const bsAlert = new bootstrap.Alert(alert);
                                bsAlert.close();
                            }, 5000);
                        });

                        // Scroll to top if there's a message
                        if (alerts.length > 0) {
                            window.scrollTo({ top: 0, behavior: 'smooth' });
                        }
                    });
                </script>
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

                    // Basic validation to ensure stations are not identical
                    function validateTicketStations(changedSelect) {
                        const boardingSelect = document.getElementById('boardingStationId');
                        const alightingSelect = document.getElementById('alightingStationId');
                        if (boardingSelect.value && alightingSelect.value && boardingSelect.value === alightingSelect.value) {
                            alert('Boarding and drop-off stations must be different.');
                            if (changedSelect) {
                                changedSelect.value = '';
                            }
                        }
                    }

                    document.getElementById('boardingStationId').addEventListener('change', function () {
                        validateTicketStations(this);
                    });
                    document.getElementById('alightingStationId').addEventListener('change', function () {
                        validateTicketStations(this);
                    });
                </script>
            </body>

            </html>