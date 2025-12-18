<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>${not empty schedule ? 'Edit' : 'Add'} Schedule - Admin Dashboard</title>
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css"
                        rel="stylesheet">
                    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"
                        rel="stylesheet">
                    <style>
                        /* ===== GLOBAL STYLES ===== */
                        :root {
                            --primary-color: #66bb6a;
                            --secondary-color: #81c784;
                            --success-color: #4caf50;
                            --danger-color: #dc3545;
                            --warning-color: #ffc107;
                            --info-color: #66bb6a;
                            --light-color: #e8f5e9;
                            --dark-color: #2e7d32;
                            --white: #ffffff;
                            --gray-100: #e8f5e9;
                            --gray-200: #c8e6c9;
                            --gray-300: #a5d6a7;
                            --gray-400: #81c784;
                            --gray-500: #66bb6a;
                            --gray-600: #4caf50;
                            --gray-700: #388e3c;
                            --gray-800: #2e7d32;
                            --gray-900: #1b5e20;
                            --shadow-sm: 0 0.125rem 0.25rem rgba(102, 187, 106, 0.15);
                            --shadow: 0 0.5rem 1rem rgba(102, 187, 106, 0.2);
                            --shadow-lg: 0 1rem 3rem rgba(102, 187, 106, 0.25);
                            --border-radius: 0.375rem;
                            --border-radius-lg: 0.5rem;
                            --border-radius-xl: 0.75rem;
                            --transition: all 0.3s ease;
                        }

                        body {
                            font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
                            line-height: 1.6;
                            color: var(--gray-800);
                            background-color: #f1f8f4;
                            min-height: 100vh;
                        }

                        .navbar {
                            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%) !important;
                            box-shadow: var(--shadow);
                            padding: 1rem 0;
                        }

                        .navbar-brand {
                            font-weight: 700;
                            font-size: 1.5rem;
                            color: var(--white) !important;
                            text-decoration: none;
                            transition: var(--transition);
                        }

                        .navbar-brand:hover {
                            color: var(--gray-200) !important;
                            transform: translateY(-1px);
                        }

                        .navbar-nav .nav-link {
                            color: var(--white) !important;
                            font-weight: 500;
                            padding: 0.5rem 1rem !important;
                            border-radius: var(--border-radius);
                            transition: var(--transition);
                            margin: 0 0.25rem;
                        }

                        .navbar-nav .nav-link:hover {
                            background-color: rgba(255, 255, 255, 0.1);
                            color: var(--white) !important;
                            transform: translateY(-1px);
                        }

                        .dropdown-menu {
                            border: none;
                            box-shadow: var(--shadow-lg);
                            border-radius: var(--border-radius-lg);
                            padding: 0.5rem 0;
                            background-color: var(--white);
                            margin-top: 0.5rem;
                        }

                        .dropdown-item {
                            padding: 0.75rem 1.5rem;
                            transition: var(--transition);
                            color: var(--gray-700);
                            text-decoration: none;
                            display: block;
                        }

                        .dropdown-item:hover {
                            background-color: var(--gray-100);
                            color: var(--primary-color);
                            text-decoration: none;
                        }

                        footer {
                            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
                            color: var(--white);
                            padding: 2rem 0;
                            margin-top: auto;
                        }

                        footer a {
                            color: var(--gray-300);
                            text-decoration: none;
                            transition: var(--transition);
                        }

                        footer a:hover {
                            color: var(--white);
                        }

                        ::-webkit-scrollbar {
                            width: 8px;
                        }

                        ::-webkit-scrollbar-track {
                            background: var(--gray-200);
                        }

                        ::-webkit-scrollbar-thumb {
                            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
                            border-radius: 4px;
                        }

                        ::-webkit-scrollbar-thumb:hover {
                            background: linear-gradient(135deg, #4caf50 0%, #66bb6a 100%);
                        }

                        @media (max-width: 768px) {
                            .container {
                                padding: 0 1rem;
                            }

                            .card-body {
                                padding: 1rem;
                            }

                            .btn {
                                padding: 0.5rem 1rem;
                                font-size: 0.875rem;
                            }
                        }

                        .form-container {
                            background: linear-gradient(135deg, #66bb6a 0%, #81c784 100%);
                            border-radius: 15px;
                            padding: 2rem;
                            margin-bottom: 2rem;
                            color: white;
                        }

                        .form-card {
                            background: white;
                            border-radius: 15px;
                            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
                            overflow: hidden;
                        }

                        .form-header {
                            background: linear-gradient(135deg, #66bb6a 0%, #81c784 100%);
                            color: white;
                            padding: 2rem;
                            text-align: center;
                        }

                        .form-body {
                            padding: 2rem;
                        }

                        .form-group {
                            margin-bottom: 1.5rem;
                        }

                        .form-label {
                            font-weight: 600;
                            color: #333;
                            margin-bottom: 0.5rem;
                        }

                        .form-control,
                        .form-select {
                            border: 2px solid #e9ecef;
                            border-radius: 10px;
                            padding: 0.75rem 1rem;
                            transition: all 0.3s ease;
                        }

                        .form-control:focus,
                        .form-select:focus {
                            border-color: #66bb6a;
                            box-shadow: 0 0 0 0.2rem rgba(102, 187, 106, 0.25);
                        }

                        .btn-submit {
                            background: linear-gradient(135deg, #66bb6a 0%, #81c784 100%);
                            border: none;
                            border-radius: 10px;
                            padding: 0.75rem 2rem;
                            font-weight: 600;
                            transition: all 0.3s ease;
                        }

                        .btn-submit:hover {
                            transform: translateY(-2px);
                            box-shadow: 0 5px 15px rgba(102, 187, 106, 0.4);
                        }

                        .btn-cancel {
                            border: 2px solid #6c757d;
                            border-radius: 10px;
                            padding: 0.75rem 2rem;
                            font-weight: 600;
                            transition: all 0.3s ease;
                        }

                        .btn-cancel:hover {
                            background-color: #6c757d;
                            color: white;
                        }

                        .info-card {
                            background: #f8f9fa;
                            border-left: 4px solid #66bb6a;
                            border-radius: 0 10px 10px 0;
                            padding: 1rem;
                            margin-bottom: 1rem;
                        }

                        .station-selection-container {
                            max-height: 400px;
                            overflow-y: auto;
                            border: 2px solid #e9ecef;
                            border-radius: 10px;
                            padding: 1rem;
                            background: #f8f9fa;
                        }

                        .station-card {
                            margin-bottom: 0;
                        }

                        .station-card .form-check-input {
                            position: absolute;
                            top: 10px;
                            right: 10px;
                            z-index: 10;
                        }

                        .station-card .form-check-label {
                            cursor: pointer;
                        }

                        .station-card .card {
                            transition: all 0.3s ease;
                            border: 2px solid transparent;
                        }

                        .station-card .form-check-input:checked+.form-check-label .card {
                            border-color: #66bb6a;
                            background: linear-gradient(135deg, rgba(102, 187, 106, 0.1) 0%, rgba(129, 199, 132, 0.1) 100%);
                            transform: translateY(-2px);
                            box-shadow: 0 5px 15px rgba(102, 187, 106, 0.2);
                        }

                        .station-card .form-check-input:checked+.form-check-label .card-title {
                            color: #66bb6a;
                            font-weight: 600;
                        }

                        .station-details-card {
                            background: #f8f9fa;
                            border: 1px solid #dee2e6;
                            border-radius: 8px;
                            padding: 1rem;
                            margin-bottom: 1rem;
                        }

                        .station-details-card h6 {
                            color: #66bb6a;
                            margin-bottom: 1rem;
                        }

                        .form-check-card {
                            position: relative;
                        }

                        .form-check-card input[type="radio"] {
                            position: absolute;
                            top: 10px;
                            right: 10px;
                            z-index: 10;
                        }

                        .form-check-card input[type="radio"]:checked+label .card {
                            border-color: #66bb6a !important;
                            box-shadow: 0 0 0 0.2rem rgba(102, 187, 106, 0.25) !important;
                            background: linear-gradient(135deg, rgba(102, 187, 106, 0.05) 0%, rgba(129, 199, 132, 0.05) 100%);
                        }

                        .form-check-card label {
                            cursor: pointer;
                            margin-bottom: 0;
                        }

                        .form-check-card .card {
                            transition: all 0.3s ease;
                            border: 2px solid #e9ecef;
                        }

                        .form-check-card .card:hover {
                            border-color: #66bb6a;
                            transform: translateY(-2px);
                            box-shadow: 0 4px 8px rgba(102, 187, 106, 0.2);
                        }
                    </style>
                </head>

                <body>
                    <jsp:include page="../partials/admin-header.jsp" />

                    <div class="container-fluid py-4">
                        <div class="row justify-content-center">
                            <div class="col-lg-8">
                                <!-- Header Section -->
                                <div class="form-container">
                                    <div class="row align-items-center">
                                        <div class="col-md-8">
                                            <h2 class="mb-0">
                                                <i class="fas fa-calendar-alt me-2"></i>
                                                ${not empty schedule ? 'Edit Schedule' : 'Add New Schedule'}
                                            </h2>
                                            <p class="mb-0 mt-2">
                                                ${not empty schedule ? 'Update schedule information' : 'Create a new bus
                                                schedule'}
                                            </p>
                                        </div>
                                        <div class="col-md-4 text-md-end">
                                            <a href="${pageContext.request.contextPath}/admin/schedules"
                                                class="btn btn-light">
                                                <i class="fas fa-arrow-left me-2"></i>Back to Schedules
                                            </a>
                                        </div>
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

                                <!-- Form Card -->
                                <div class="form-card">
                                    <div class="form-header">
                                        <h4 class="mb-0">
                                            <i class="fas fa-${not empty schedule ? 'edit' : 'plus'} me-2"></i>
                                            Schedule Information
                                        </h4>
                                    </div>
                                    <div class="form-body">
                                        <div id="formError" class="alert alert-danger d-none" role="alert"
                                            tabindex="-1">
                                        </div>
                                        <form
                                            action="${pageContext.request.contextPath}/admin/schedules/${not empty schedule ? 'edit' : 'add'}"
                                            method="post" id="scheduleForm">

                                            <c:if test="${not empty schedule}">
                                                <input type="hidden" name="scheduleId" value="${schedule.scheduleId}">
                                            </c:if>

                                            <div class="row">
                                                <!-- Route Selection -->
                                                <div class="col-md-6">
                                                    <div class="form-group">
                                                        <label for="routeId"
                                                            class="form-label d-flex align-items-center justify-content-between">
                                                            <span><i class="fas fa-route me-2"></i>Route *</span>
                                                            <span class="badge bg-light text-muted"
                                                                id="routeDurationHelper"
                                                                style="font-weight: 500;"></span>
                                                        </label>
                                                        <select class="form-select" id="routeId" name="routeId"
                                                            required>
                                                            <option value="">Select a route</option>
                                                            <c:forEach var="route" items="${routes}">
                                                                <option value="${route.routeId}"
                                                                    data-duration="${route.durationHours}" ${not empty
                                                                    schedule && schedule.routeId==route.routeId
                                                                    ? 'selected' : '' }>
                                                                    ${route.routeName} (${route.departureCity} →
                                                                    ${route.destinationCity})
                                                                </option>
                                                            </c:forEach>
                                                        </select>
                                                    </div>
                                                </div>

                                                <!-- Bus Selection -->
                                                <div class="col-md-6">
                                                    <div class="form-group">
                                                        <label for="busId" class="form-label">
                                                            <i class="fas fa-bus me-2"></i>Bus *
                                                        </label>
                                                        <select class="form-select" id="busId" name="busId" required>
                                                            <option value="">Select a bus</option>
                                                            <c:forEach var="bus" items="${buses}">
                                                                <option value="${bus.busId}" ${not empty schedule &&
                                                                    schedule.busId==bus.busId ? 'selected' : '' }>
                                                                    ${bus.busNumber} - ${bus.busType} (${bus.totalSeats}
                                                                    seats)
                                                                </option>
                                                            </c:forEach>
                                                        </select>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Date Selection Mode Toggle -->
                                            <div class="row mb-3">
                                                <div class="col-12">
                                                    <div class="card border-2" style="border-color: #e9ecef;">
                                                        <div class="card-body">
                                                            <label class="form-label fw-bold mb-3">
                                                                <i class="fas fa-calendar-check me-2"></i>Date Selection
                                                                Mode *
                                                            </label>
                                                            <div class="row">
                                                                <div class="col-md-6 mb-2">
                                                                    <div class="form-check form-check-card">
                                                                        <input class="form-check-input" type="radio"
                                                                            name="dateMode" id="dateModeSingle"
                                                                            value="single" checked>
                                                                        <label class="form-check-label w-100"
                                                                            for="dateModeSingle">
                                                                            <div class="card border-2"
                                                                                style="border-color: #e9ecef; transition: all 0.3s;">
                                                                                <div class="card-body text-center">
                                                                                    <i
                                                                                        class="fas fa-calendar-day fa-2x mb-2 text-primary"></i>
                                                                                    <h6 class="mb-1">Select One Day</h6>
                                                                                    <small class="text-muted">${not
                                                                                        empty schedule ? 'Update
                                                                                        schedule for one day' : 'Create
                                                                                        schedule for a specific
                                                                                        day'}</small>
                                                                                </div>
                                                                            </div>
                                                                        </label>
                                                                    </div>
                                                                </div>
                                                                <div class="col-md-6 mb-2">
                                                                    <div class="form-check form-check-card">
                                                                        <input class="form-check-input" type="radio"
                                                                            name="dateMode" id="dateModeRange"
                                                                            value="range">
                                                                        <label class="form-check-label w-100"
                                                                            for="dateModeRange">
                                                                            <div class="card border-2"
                                                                                style="border-color: #e9ecef; transition: all 0.3s;">
                                                                                <div class="card-body text-center">
                                                                                    <i
                                                                                        class="fas fa-calendar-week fa-2x mb-2 text-success"></i>
                                                                                    <h6 class="mb-1">Select Time Range
                                                                                    </h6>
                                                                                    <small class="text-muted">${not
                                                                                        empty schedule ? 'Update and
                                                                                        create more schedules for
                                                                                        multiple
                                                                                        days' : 'Create schedules for
                                                                                        multiple
                                                                                        days'}</small>
                                                                                </div>
                                                                            </div>
                                                                        </label>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Single Date Mode -->
                                            <div id="singleDateSection" class="row">
                                                <!-- Departure Date -->
                                                <div class="col-md-6">
                                                    <div class="form-group">
                                                        <label for="departureDate" class="form-label">
                                                            <i class="fas fa-calendar me-2"></i>Departure Date *
                                                        </label>
                                                        <input type="date" class="form-control" id="departureDate"
                                                            name="departureDate"
                                                            value="${not empty schedule ? schedule.departureDate : ''}"
                                                            required>
                                                    </div>
                                                </div>

                                                <!-- Available Seats (visible in single mode) -->
                                                <div class="col-md-6">
                                                    <div class="form-group">
                                                        <label for="availableSeats" class="form-label">
                                                            <i class="fas fa-users me-2"></i>Available Seats *
                                                        </label>
                                                        <input type="number" class="form-control" id="availableSeats"
                                                            name="availableSeats"
                                                            value="${not empty schedule ? schedule.availableSeats : ''}"
                                                            min="1" max="100" required>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Date Range Mode Section (hidden by default) -->
                                            <div id="rangeDateSection" class="d-none">
                                                <div class="info-card mb-3" style="border-left-color: #17a2b8;">
                                                    <h6 class="mb-2">
                                                        <i class="fas fa-info-circle me-2 text-info"></i>Time Range Mode
                                                    </h6>
                                                    <p class="mb-1 small">Select date range and how to create schedules:
                                                    </p>
                                                    <ul class="small mb-0">
                                                        <li><strong>Daily:</strong> create schedules for all days
                                                            in the range from start date to end date.</li>
                                                        <li><strong>Select weekdays:</strong> select days of
                                                            the week to create schedules (e.g., only Thursdays).</li>
                                                    </ul>
                                                </div>

                                                <!-- Pattern Selection -->
                                                <div class="row mb-3">
                                                    <div class="col-md-6 mb-2">
                                                        <div class="form-check form-check-card">
                                                            <input class="form-check-input" type="radio"
                                                                name="bulkPattern" id="patternDaily" value="daily"
                                                                checked>
                                                            <label class="form-check-label w-100" for="patternDaily">
                                                                <div class="card border-2"
                                                                    style="border-color: #e9ecef; transition: all 0.3s;">
                                                                    <div class="card-body text-center">
                                                                        <i
                                                                            class="fas fa-calendar-day fa-2x mb-2 text-primary"></i>
                                                                        <h6 class="mb-1">Daily</h6>
                                                                        <small class="text-muted">Create schedules for
                                                                            all
                                                                            days in range</small>
                                                                    </div>
                                                                </div>
                                                            </label>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-6 mb-2">
                                                        <div class="form-check form-check-card">
                                                            <input class="form-check-input" type="radio"
                                                                name="bulkPattern" id="patternWeekdays"
                                                                value="weekdays">
                                                            <label class="form-check-label w-100" for="patternWeekdays">
                                                                <div class="card border-2"
                                                                    style="border-color: #e9ecef; transition: all 0.3s;">
                                                                    <div class="card-body text-center">
                                                                        <i
                                                                            class="fas fa-check-square fa-2x mb-2 text-success"></i>
                                                                        <h6 class="mb-1">Select Weekdays</h6>
                                                                        <small class="text-muted">Select days to create
                                                                            schedules</small>
                                                                    </div>
                                                                </div>
                                                            </label>
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="row">
                                                    <!-- Date Range From -->
                                                    <div class="col-md-6">
                                                        <div class="form-group">
                                                            <label for="dateFrom" class="form-label">
                                                                <i class="fas fa-calendar-alt me-2"></i>Start Date *
                                                            </label>
                                                            <input type="date" class="form-control" id="dateFrom"
                                                                name="dateFrom">
                                                        </div>
                                                    </div>

                                                    <!-- Date Range To -->
                                                    <div class="col-md-6">
                                                        <div class="form-group">
                                                            <label for="dateTo" class="form-label">
                                                                <i class="fas fa-calendar-alt me-2"></i>End Date *
                                                            </label>
                                                            <input type="date" class="form-control" id="dateTo"
                                                                name="dateTo">
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Available Seats for Range Mode -->
                                                <div class="row">
                                                    <div class="col-md-6">
                                                        <div class="form-group">
                                                            <label for="availableSeatsRange" class="form-label">
                                                                <i class="fas fa-users me-2"></i>Available Seats *
                                                            </label>
                                                            <input type="number" class="form-control"
                                                                id="availableSeatsRange" name="availableSeats" min="1"
                                                                max="100" disabled>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Days of Week Selection (only shown when patternWeekdays is selected) -->
                                                <div id="daysOfWeekSection" class="row d-none">
                                                    <div class="col-12">
                                                        <div class="form-group">
                                                            <label class="form-label">
                                                                <i class="fas fa-calendar-day me-2"></i>Select Weekdays
                                                                *
                                                            </label>
                                                            <div class="d-flex flex-wrap gap-2">
                                                                <div class="form-check form-check-inline">
                                                                    <input class="form-check-input" type="checkbox"
                                                                        name="daysOfWeek" value="1" id="dayMon">
                                                                    <label class="form-check-label"
                                                                        for="dayMon">Monday</label>
                                                                </div>
                                                                <div class="form-check form-check-inline">
                                                                    <input class="form-check-input" type="checkbox"
                                                                        name="daysOfWeek" value="2" id="dayTue">
                                                                    <label class="form-check-label"
                                                                        for="dayTue">Tuesday</label>
                                                                </div>
                                                                <div class="form-check form-check-inline">
                                                                    <input class="form-check-input" type="checkbox"
                                                                        name="daysOfWeek" value="3" id="dayWed">
                                                                    <label class="form-check-label"
                                                                        for="dayWed">Wednesday</label>
                                                                </div>
                                                                <div class="form-check form-check-inline">
                                                                    <input class="form-check-input" type="checkbox"
                                                                        name="daysOfWeek" value="4" id="dayThu">
                                                                    <label class="form-check-label"
                                                                        for="dayThu">Thursday</label>
                                                                </div>
                                                                <div class="form-check form-check-inline">
                                                                    <input class="form-check-input" type="checkbox"
                                                                        name="daysOfWeek" value="5" id="dayFri">
                                                                    <label class="form-check-label"
                                                                        for="dayFri">Friday</label>
                                                                </div>
                                                                <div class="form-check form-check-inline">
                                                                    <input class="form-check-input" type="checkbox"
                                                                        name="daysOfWeek" value="6" id="daySat">
                                                                    <label class="form-check-label"
                                                                        for="daySat">Saturday</label>
                                                                </div>
                                                                <div class="form-check form-check-inline">
                                                                    <input class="form-check-input" type="checkbox"
                                                                        name="daysOfWeek" value="7" id="daySun">
                                                                    <label class="form-check-label"
                                                                        for="daySun">Sunday</label>
                                                                </div>
                                                            </div>
                                                            <div id="schedulesPreview" class="mt-2 text-muted small">
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>

                                            </div>

                                            <div class="row">
                                                <!-- Departure Time -->
                                                <div class="col-md-6">
                                                    <div class="form-group">
                                                        <label for="departureTime" class="form-label">
                                                            <i class="fas fa-clock me-2"></i>Departure Time *
                                                        </label>
                                                        <input type="time" class="form-control" id="departureTime"
                                                            name="departureTime"
                                                            value="${not empty schedule ? schedule.departureTime : ''}"
                                                            required>
                                                    </div>
                                                </div>

                                                <!-- Arrival Time -->
                                                <div class="col-md-6">
                                                    <div class="form-group">
                                                        <label for="arrivalTime" class="form-label">
                                                            <i class="fas fa-clock me-2"></i>Estimated Arrival Time *
                                                        </label>
                                                        <input type="time" class="form-control" id="arrivalTime"
                                                            name="arrivalTime"
                                                            value="${not empty schedule ? schedule.estimatedArrivalTime : ''}"
                                                            required readonly>
                                                        <div class="form-text">
                                                            Arrival time is automatically calculated from the route
                                                            duration.
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Information Card -->
                                            <div class="info-card">
                                                <h6 class="mb-2">
                                                    <i class="fas fa-info-circle me-2"></i>Important Information
                                                </h6>
                                                <ul class="mb-0 small">
                                                    <li>Make sure the departure time is before the arrival time</li>
                                                    <li>Available seats should not exceed the bus capacity</li>
                                                    <li>Select at least 2 bus stations for the schedule</li>
                                                    <li>You can set different arrival times and stop durations for each
                                                        station</li>
                                                    <li>Schedule will be automatically set to "SCHEDULED" status</li>
                                                    <li>You can assign drivers to this schedule after creation</li>
                                                </ul>
                                            </div>

                                            <!-- Form Actions -->
                                            <div class="d-flex justify-content-between pt-3">
                                                <a href="${pageContext.request.contextPath}/admin/schedules"
                                                    class="btn btn-cancel">
                                                    <i class="fas fa-times me-2"></i>Cancel
                                                </a>
                                                <button type="submit" class="btn btn-submit text-white">
                                                    <i class="fas fa-${not empty schedule ? 'save' : 'plus'} me-2"></i>
                                                    ${not empty schedule ? 'Update Schedule' : 'Create Schedule'}
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
                            document.addEventListener('DOMContentLoaded', function () {
                                const form = document.getElementById('scheduleForm');
                                const departureTime = document.getElementById('departureTime');
                                const arrivalTime = document.getElementById('arrivalTime');
                                const departureDate = document.getElementById('departureDate');
                                const availableSeats = document.getElementById('availableSeats');
                                const busSelect = document.getElementById('busId');
                                const routeSelect = document.getElementById('routeId');
                                const formErrorAlert = document.getElementById('formError');
                                const routeDurationHelper = document.getElementById('routeDurationHelper');
                                let lastErrorSource = null;

                                function showFormError(message, source) {
                                    if (!formErrorAlert) {
                                        return;
                                    }
                                    formErrorAlert.textContent = message;
                                    formErrorAlert.classList.remove('d-none');
                                    formErrorAlert.scrollIntoView({ behavior: 'smooth', block: 'center' });
                                    lastErrorSource = source || null;
                                }

                                function hideFormError(source) {
                                    if (!formErrorAlert) {
                                        return;
                                    }
                                    if (!source || lastErrorSource === source) {
                                        formErrorAlert.classList.add('d-none');
                                        formErrorAlert.textContent = '';
                                        lastErrorSource = null;
                                    }
                                }

                                const today = new Date().toISOString().split('T')[0];
                                departureDate.setAttribute('min', today);

                                // Date mode handling (single vs range)
                                const dateModeSingle = document.getElementById('dateModeSingle');
                                const dateModeRange = document.getElementById('dateModeRange');
                                const singleDateSection = document.getElementById('singleDateSection');
                                const rangeDateSection = document.getElementById('rangeDateSection');
                                const patternDaily = document.getElementById('patternDaily');
                                const patternWeekdays = document.getElementById('patternWeekdays');
                                const daysOfWeekSection = document.getElementById('daysOfWeekSection');
                                const dayCheckboxes = Array.from(document.querySelectorAll('input[name="daysOfWeek"]'));
                                const availableSeatsRange = document.getElementById('availableSeatsRange');
                                const dateFromInput = document.getElementById('dateFrom');
                                const dateToInput = document.getElementById('dateTo');
                                const schedulesPreview = document.getElementById('schedulesPreview');

                                // Update card border when radio is selected
                                function updateCardBorders() {
                                    document.querySelectorAll('.form-check-card').forEach(card => {
                                        const radio = card.querySelector('input[type="radio"]');
                                        const cardElement = card.querySelector('.card');
                                        if (radio && cardElement) {
                                            if (radio.checked) {
                                                cardElement.style.borderColor = '#66bb6a';
                                                cardElement.style.boxShadow = '0 0 0 0.2rem rgba(102, 187, 106, 0.25)';
                                            } else {
                                                cardElement.style.borderColor = '#e9ecef';
                                                cardElement.style.boxShadow = 'none';
                                            }
                                        }
                                    });
                                }

                                function toggleDateModeUI() {
                                    const isRangeMode = dateModeRange && dateModeRange.checked;

                                    if (isRangeMode) {
                                        // Range mode: hide single date section, show range section
                                        singleDateSection.classList.add('d-none');
                                        rangeDateSection.classList.remove('d-none');

                                        // Disable single mode fields
                                        departureDate.disabled = true;
                                        departureDate.removeAttribute('required');
                                        departureDate.removeAttribute('name');
                                        availableSeats.disabled = true;
                                        availableSeats.removeAttribute('required');
                                        availableSeats.removeAttribute('name');

                                        // Enable range mode fields
                                        if (dateFromInput) {
                                            dateFromInput.disabled = false;
                                            dateFromInput.name = 'dateFrom'; // ensure name is present when enabling
                                            dateFromInput.setAttribute('required', 'required');
                                            dateFromInput.setAttribute('min', today);
                                        }
                                        if (dateToInput) {
                                            dateToInput.disabled = false;
                                            dateToInput.name = 'dateTo'; // ensure name is present when enabling
                                            dateToInput.setAttribute('required', 'required');
                                            dateToInput.setAttribute('min', today);
                                        }
                                        if (availableSeatsRange) {
                                            availableSeatsRange.disabled = false;
                                            availableSeatsRange.setAttribute('required', 'required');
                                            availableSeatsRange.setAttribute('name', 'availableSeats');
                                            // Sync value from single mode if exists
                                            if (availableSeats.value) {
                                                availableSeatsRange.value = availableSeats.value;
                                            }
                                        }

                                        // Add hidden input for bulkMode
                                        let bulkModeInput = document.getElementById('bulkModeHidden');
                                        if (!bulkModeInput) {
                                            bulkModeInput = document.createElement('input');
                                            bulkModeInput.type = 'hidden';
                                            bulkModeInput.id = 'bulkModeHidden';
                                            bulkModeInput.name = 'bulkMode';
                                            bulkModeInput.value = 'on';
                                            form.appendChild(bulkModeInput);
                                        }

                                        syncPattern();
                                    } else {
                                        // Single mode: show single date section, hide range section
                                        singleDateSection.classList.remove('d-none');
                                        rangeDateSection.classList.add('d-none');

                                        // Enable single mode fields
                                        departureDate.disabled = false;
                                        departureDate.setAttribute('required', 'required');
                                        departureDate.setAttribute('name', 'departureDate');
                                        availableSeats.disabled = false;
                                        availableSeats.setAttribute('required', 'required');
                                        availableSeats.setAttribute('name', 'availableSeats');

                                        // Disable range mode fields
                                        if (dateFromInput) {
                                            dateFromInput.disabled = true;
                                            dateFromInput.removeAttribute('required');
                                            dateFromInput.removeAttribute('name');
                                        }
                                        if (dateToInput) {
                                            dateToInput.disabled = true;
                                            dateToInput.removeAttribute('required');
                                            dateToInput.removeAttribute('name');
                                        }
                                        if (availableSeatsRange) {
                                            availableSeatsRange.disabled = true;
                                            availableSeatsRange.removeAttribute('required');
                                            availableSeatsRange.removeAttribute('name');
                                            // Sync value back to single mode if exists
                                            if (availableSeatsRange.value) {
                                                availableSeats.value = availableSeatsRange.value;
                                            }
                                        }

                                        // Remove bulkMode hidden input
                                        const bulkModeInput = document.getElementById('bulkModeHidden');
                                        if (bulkModeInput) {
                                            bulkModeInput.remove();
                                        }
                                    }
                                    updateCardBorders();
                                }

                                function syncPattern() {
                                    if (!dateModeRange || !dateModeRange.checked) return;

                                    if (patternDaily && patternDaily.checked) {
                                        // Daily pattern: hide days of week selection, check all days
                                        daysOfWeekSection.classList.add('d-none');
                                        dayCheckboxes.forEach(cb => {
                                            cb.checked = true;
                                            cb.disabled = true;
                                            cb.removeAttribute('required');
                                        });
                                    } else if (patternWeekdays && patternWeekdays.checked) {
                                        // Weekly pattern: show days of week selection
                                        daysOfWeekSection.classList.remove('d-none');
                                        dayCheckboxes.forEach(cb => {
                                            cb.disabled = false;
                                            cb.removeAttribute('required'); // custom validation will handle required state
                                        });
                                    }
                                    updateCardBorders();
                                    updateSchedulesPreview();
                                }

                                // Initialize date mode
                                if (dateModeSingle && dateModeRange) {
                                    dateModeSingle.addEventListener('change', toggleDateModeUI);
                                    dateModeRange.addEventListener('change', toggleDateModeUI);
                                    toggleDateModeUI();
                                }

                                if (patternDaily) patternDaily.addEventListener('change', syncPattern);
                                if (patternWeekdays) patternWeekdays.addEventListener('change', syncPattern);

                                // Initialize card borders
                                updateCardBorders();

                                function updateRouteDurationHelper() {
                                    if (!routeDurationHelper) {
                                        return;
                                    }
                                    const option = routeSelect.options[routeSelect.selectedIndex];
                                    const duration = option ? option.getAttribute('data-duration') : null;
                                    routeDurationHelper.textContent = duration ? `Duration: ${duration}h` : '';
                                }

                                function updateArrivalTime() {
                                    const option = routeSelect.options[routeSelect.selectedIndex];
                                    const duration = option ? parseFloat(option.getAttribute('data-duration')) : null;
                                    if (!duration || !departureTime.value) {
                                        arrivalTime.value = '';
                                        return;
                                    }
                                    const [depHour, depMinute] = departureTime.value.split(':').map(Number);
                                    const durationMinutes = Math.round(duration * 60);
                                    const totalMinutes = (depHour * 60 + depMinute + durationMinutes) % (24 * 60);
                                    const arrivalHour = String(Math.floor(totalMinutes / 60)).padStart(2, '0');
                                    const arrivalMin = String(totalMinutes % 60).padStart(2, '0');
                                    arrivalTime.value = `${arrivalHour}:${arrivalMin}`;
                                    hideFormError('time');
                                }

                                function validateTimes() {
                                    if (departureTime.value && arrivalTime.value) {
                                        if (departureTime.value >= arrivalTime.value) {
                                            arrivalTime.setCustomValidity('Arrival time must be after departure time');
                                            showFormError('Arrival time must be later than departure time.', 'time');
                                            return false;
                                        }
                                        arrivalTime.setCustomValidity('');
                                        hideFormError('time');
                                    }
                                    return true;
                                }

                                function validateSeats() {
                                    const selectedBus = busSelect.options[busSelect.selectedIndex];
                                    // Get the active seats field (check if range mode is on)
                                    const isRangeMode = dateModeRange && dateModeRange.checked;
                                    const activeSeatsField = isRangeMode
                                        ? availableSeatsRange
                                        : availableSeats;

                                    if (selectedBus.value && activeSeatsField && activeSeatsField.value) {
                                        const busCapacity = selectedBus.text.match(/\((\d+) seats\)/);
                                        if (busCapacity) {
                                            const capacity = parseInt(busCapacity[1], 10);
                                            if (parseInt(activeSeatsField.value, 10) > capacity) {
                                                activeSeatsField.setCustomValidity(`Available seats cannot exceed bus capacity (${capacity})`);
                                                showFormError(`Available seats cannot exceed bus capacity (${capacity}).`, 'seats');
                                                return false;
                                            }
                                        }
                                    }
                                    // Clear validity on both fields
                                    availableSeats.setCustomValidity('');
                                    if (availableSeatsRange) availableSeatsRange.setCustomValidity('');
                                    hideFormError('seats');
                                    return true;
                                }

                                departureTime.addEventListener('change', function () {
                                    updateArrivalTime();
                                    validateTimes();
                                });
                                availableSeats.addEventListener('input', validateSeats);

                                // Also add validation for range seats field
                                if (availableSeatsRange) {
                                    availableSeatsRange.addEventListener('input', validateSeats);
                                }

                                busSelect.addEventListener('change', function () {
                                    const selectedBus = this.options[this.selectedIndex];
                                    const capacityMatch = selectedBus?.text.match(/\((\d+) seats\)/);
                                    const capacity = capacityMatch ? parseInt(capacityMatch[1], 10) : null;

                                    // Always sync seats with the selected bus capacity so changing buses refreshes the defaults
                                    [availableSeats, availableSeatsRange].forEach(field => {
                                        if (!field) return;
                                        if (capacity) {
                                            field.max = capacity;
                                            field.value = capacity;
                                        } else {
                                            field.removeAttribute('max');
                                        }
                                    });

                                    validateSeats();
                                });
                                routeSelect.addEventListener('change', function () {
                                    updateRouteDurationHelper();
                                    updateArrivalTime();
                                });

                                form.addEventListener('submit', function (e) {
                                    hideFormError();

                                    // Validate based on mode
                                    const isRangeMode = dateModeRange && dateModeRange.checked;

                                    if (isRangeMode) {
                                        // Validate range mode fields
                                        if (!dateFromInput || !dateFromInput.value) {
                                            showFormError('Please select start date', 'dateRange');
                                            e.preventDefault();
                                            return;
                                        }
                                        if (!dateToInput || !dateToInput.value) {
                                            showFormError('Please select end date', 'dateRange');
                                            e.preventDefault();
                                            return;
                                        }
                                        if (new Date(dateFromInput.value) > new Date(dateToInput.value)) {
                                            showFormError('Start date must be before or equal to end date', 'dateRange');
                                            e.preventDefault();
                                            return;
                                        }

                                        const isDailyPattern = patternDaily && patternDaily.checked;
                                        if (!isDailyPattern) {
                                            const selectedDays = Array.from(document.querySelectorAll('input[name="daysOfWeek"]:checked'));
                                            if (selectedDays.length === 0) {
                                                showFormError('Please select at least one day of the week', 'daysOfWeek');
                                                e.preventDefault();
                                                return;
                                            }
                                        }

                                        if (!availableSeatsRange || !availableSeatsRange.value) {
                                            showFormError('Please enter available seats', 'seats');
                                            e.preventDefault();
                                            return;
                                        }
                                    } else {
                                        // Validate single mode fields
                                        if (!departureDate.value) {
                                            showFormError('Please select departure date', 'date');
                                            e.preventDefault();
                                            return;
                                        }
                                        if (!availableSeats.value) {
                                            showFormError('Please enter available seats', 'seats');
                                            e.preventDefault();
                                            return;
                                        }
                                    }

                                    if (!validateTimes() || !validateSeats()) {
                                        e.preventDefault();
                                    }
                                });

                                updateRouteDurationHelper();
                                updateArrivalTime();

                                // Preview scheduled dates
                                function updateSchedulesPreview() {
                                    if (!dateModeRange || !dateModeRange.checked || !schedulesPreview) return;

                                    const dateFrom = dateFromInput?.value;
                                    const dateTo = dateToInput?.value;
                                    const isDailyPattern = patternDaily && patternDaily.checked;
                                    const selectedDays = Array.from(document.querySelectorAll('input[name="daysOfWeek"]:checked'))
                                        .map(cb => parseInt(cb.value));

                                    if (!dateFrom || !dateTo) {
                                        schedulesPreview.textContent = 'Select date range to see preview';
                                        return;
                                    }

                                    const start = new Date(dateFrom);
                                    const end = new Date(dateTo);

                                    if (start > end) {
                                        schedulesPreview.innerHTML = '<span class="text-danger">Start date must be before end date</span>';
                                        return;
                                    }

                                    if (isDailyPattern) {
                                        // Daily pattern: count all days
                                        const diffTime = Math.abs(end - start);
                                        const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24)) + 1;
                                        schedulesPreview.innerHTML = `<span class="text-success fw-bold">${diffDays} schedule(s)</span> will be created for all days from ${dateFrom} to ${dateTo}`;
                                    } else {
                                        // Weekly pattern: count matching days
                                        if (selectedDays.length === 0) {
                                            schedulesPreview.innerHTML = '<span class="text-warning">Please select at least one day of the week</span>';
                                            return;
                                        }

                                        const dayNames = ['', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
                                        let count = 0;
                                        let previewDates = [];
                                        const current = new Date(start);

                                        while (current <= end) {
                                            // JavaScript: Sunday = 0, Monday = 1, ..., Saturday = 6
                                            // Our system: Monday = 1, ..., Sunday = 7
                                            let dayOfWeek = current.getDay();
                                            if (dayOfWeek === 0) dayOfWeek = 7; // Convert Sunday from 0 to 7

                                            if (selectedDays.includes(dayOfWeek)) {
                                                count++;
                                                if (previewDates.length < 5) {
                                                    previewDates.push(current.toLocaleDateString('vi-VN', {
                                                        weekday: 'short', month: 'short', day: 'numeric'
                                                    }));
                                                }
                                            }
                                            current.setDate(current.getDate() + 1);
                                        }

                                        if (count === 0) {
                                            schedulesPreview.innerHTML = '<span class="text-warning">No matching days found</span>';
                                        } else {
                                            const daysText = selectedDays.map(d => dayNames[d]).join(', ');
                                            let preview = `<span class="text-success fw-bold">${count} schedule(s)</span> will be created for ${daysText}`;
                                            if (previewDates.length > 0) {
                                                preview += '<br><small>Ví dụ: ' + previewDates.join(', ');
                                                if (count > 5) preview += `, ... và ${count - 5} ngày khác`;
                                                preview += '</small>';
                                            }
                                            schedulesPreview.innerHTML = preview;
                                        }
                                    }
                                }

                                if (dateFromInput) dateFromInput.addEventListener('change', updateSchedulesPreview);
                                if (dateToInput) dateToInput.addEventListener('change', updateSchedulesPreview);
                                if (patternDaily) patternDaily.addEventListener('change', updateSchedulesPreview);
                                if (patternWeekdays) patternWeekdays.addEventListener('change', updateSchedulesPreview);
                                document.querySelectorAll('input[name="daysOfWeek"]').forEach(cb => {
                                    cb.addEventListener('change', updateSchedulesPreview);
                                });

                                // Sync available seats between modes
                                if (availableSeatsRange) {
                                    availableSeatsRange.addEventListener('input', function () {
                                        availableSeats.value = this.value;
                                    });
                                }
                                availableSeats.addEventListener('input', function () {
                                    if (availableSeatsRange && !availableSeatsRange.disabled) {
                                        availableSeatsRange.value = this.value;
                                    }
                                });
                            });
                        </script>
                </body>

                </html>