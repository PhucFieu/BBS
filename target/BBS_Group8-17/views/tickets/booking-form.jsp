<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="model.Schedule" %>
        <%@ page import="java.time.LocalDateTime" %>
            <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
                <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
                    <!DOCTYPE html>
                    <html lang="en">

                    <head>
                        <jsp:include page="/views/partials/head.jsp">
                            <jsp:param name="title" value="Book Ticket - Bus Booking System" />
                        </jsp:include>
                        <style>
                            :root {
                                --primary-gradient: linear-gradient(135deg, #66bb6a 0%, #81c784 100%);
                                --success-color: #4caf50;
                                --text-dark: #1e293b;
                                --text-light: #64748b;
                            }

                            body {
                                font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
                                background: #f1f8f4;
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
                                border: 3px solid #66bb6a;
                                box-shadow: 0 8px 20px rgba(102, 187, 106, 0.3);
                            }

                            .schedule-card.expired {
                                opacity: 0.6;
                                background: #f5f5f5;
                                cursor: not-allowed;
                            }

                            .schedule-card.expired:hover {
                                transform: none;
                                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
                            }

                            .expired-badge {
                                background: #dc3545;
                                color: white;
                                padding: 4px 12px;
                                border-radius: 12px;
                                font-size: 0.75rem;
                                font-weight: 600;
                                margin-left: 8px;
                            }

                            .filter-controls {
                                background: white;
                                border-radius: 12px;
                                padding: 20px;
                                margin-bottom: 20px;
                                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                            }

                            .filter-buttons {
                                display: flex;
                                gap: 10px;
                                flex-wrap: wrap;
                            }

                            .filter-btn {
                                padding: 8px 20px;
                                border: 2px solid #e2e8f0;
                                background: white;
                                border-radius: 8px;
                                cursor: pointer;
                                transition: all 0.3s ease;
                                font-weight: 500;
                            }

                            .filter-btn.active {
                                background: var(--primary-gradient);
                                color: white;
                                border-color: #66bb6a;
                            }

                            .filter-btn:hover {
                                border-color: #66bb6a;
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

                            .station-name {
                                font-size: 0.9rem;
                                font-weight: 600;
                                display: flex;
                                align-items: center;
                            }

                            .station-name i {
                                font-size: 0.8rem;
                            }

                            .schedule-info {
                                display: flex;
                                align-items: flex-start;
                                gap: 15px;
                                padding: 20px;
                            }

                            .schedule-card-header {
                                display: flex;
                                justify-content: space-between;
                                align-items: center;
                                gap: 12px;
                                padding: 16px 20px 0;
                            }

                            .schedule-details {
                                flex: 1;
                            }

                            .schedule-time-block {
                                flex: 1;
                            }

                            .time-label {
                                font-size: 0.85rem;
                                color: var(--text-light);
                                text-transform: uppercase;
                                letter-spacing: 0.5px;
                                font-weight: 600;
                            }

                            .schedule-time-divider {
                                color: var(--text-light);
                                padding: 0 12px;
                                font-size: 1.1rem;
                            }

                            .schedule-price {
                                font-size: 1.5rem;
                                font-weight: 700;
                                color: var(--success-color);
                            }

                            .schedule-meta {
                                display: flex;
                                flex-wrap: wrap;
                                gap: 10px;
                                padding: 0 20px 12px;
                                color: var(--text-light);
                                font-size: 0.95rem;
                            }

                            .meta-pill {
                                display: inline-flex;
                                align-items: center;
                                gap: 8px;
                                background: #f8fafc;
                                border: 1px solid #e2e8f0;
                                border-radius: 20px;
                                padding: 6px 12px;
                                font-weight: 600;
                                color: var(--text-dark);
                            }

                            .meta-pill.success {
                                border-color: rgba(102, 187, 106, 0.35);
                                background: rgba(102, 187, 106, 0.08);
                                color: #2e7d32;
                            }

                            .schedule-actions {
                                display: flex;
                                flex-wrap: wrap;
                                gap: 10px;
                                padding: 10px 20px 20px;
                                border-top: 1px dashed #e2e8f0;
                                margin-top: 8px;
                            }

                            .schedule-actions .btn {
                                border-radius: 10px;
                                font-weight: 600;
                            }

                            .seat-chip {
                                display: inline-flex;
                                align-items: center;
                                justify-content: center;
                                padding: 6px 10px;
                                border-radius: 12px;
                                font-weight: 600;
                                margin: 2px;
                                border: 1px solid #e2e8f0;
                            }

                            .seat-chip.available {
                                background: rgba(102, 187, 106, 0.12);
                                color: #2e7d32;
                                border-color: rgba(102, 187, 106, 0.35);
                            }

                            .seat-chip.booked {
                                background: #fff5f5;
                                color: #b91c1c;
                                border-color: #fecdd3;
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

                            .station-selection {
                                background: white;
                                border-radius: 16px;
                                padding: 30px;
                                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
                                margin-top: 30px;
                            }

                            .station-timeline {
                                margin-top: 20px;
                                background: white;
                                border-radius: 16px;
                                padding: 20px;
                                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
                            }

                            .timeline-track {
                                display: flex;
                                align-items: center;
                                gap: 12px;
                                overflow-x: auto;
                                padding: 10px 0;
                            }

                            .timeline-stop {
                                min-width: 140px;
                                padding: 12px;
                                border-radius: 12px;
                                border: 2px solid #e2e8f0;
                                background: #f8fafc;
                                text-align: center;
                                transition: all 0.2s ease;
                            }

                            .timeline-stop.terminal {
                                border-color: #66bb6a;
                                background: #e8f5e9;
                            }

                            .timeline-stop.active {
                                border-color: #4fc3f7;
                                background: #e0f7fa;
                                box-shadow: 0 4px 12px rgba(79, 195, 247, 0.35);
                            }

                            .timeline-connector {
                                flex: 1;
                                height: 4px;
                                border-radius: 4px;
                                background: #e2e8f0;
                            }

                            .timeline-connector.active {
                                background: linear-gradient(90deg, #4fc3f7 0%, #66bb6a 100%);
                            }

                            .stop-sequence {
                                font-size: 0.75rem;
                                font-weight: 700;
                                color: #64748b;
                                text-transform: uppercase;
                                letter-spacing: 0.08em;
                                margin-bottom: 6px;
                            }

                            .stop-name {
                                font-weight: 700;
                                color: #1e293b;
                            }

                            .stop-city {
                                font-size: 0.8rem;
                                color: #64748b;
                            }


                            .form-label {
                                font-weight: 600;
                                color: var(--text-dark);
                                margin-bottom: 8px;
                            }

                            .form-select {
                                border: 2px solid #e2e8f0;
                                border-radius: 8px;
                                padding: 10px 15px;
                                transition: all 0.3s ease;
                            }

                            .form-select:focus {
                                border-color: #66bb6a;
                                box-shadow: 0 0 0 0.2rem rgba(102, 187, 106, 0.25);
                            }

                            /* Bus Seat Layout - Realistic Design */
                            .bus-layout-container {
                                background: #f8f9fa;
                                border-radius: 16px;
                                padding: 30px;
                                margin-top: 20px;
                                position: relative;
                            }

                            .seat-grid {
                                display: flex;
                                flex-direction: column;
                                gap: 12px;
                                max-width: 900px;
                                margin: 0 auto;
                            }

                            .seat-row {
                                display: flex;
                                align-items: center;
                                gap: 8px;
                                justify-content: center;
                                position: relative;
                            }

                            .seat-block {
                                display: flex;
                                gap: 6px;
                                align-items: center;
                            }

                            .aisle {
                                width: 40px;
                                min-width: 40px;
                                height: 60px;
                                display: flex;
                                align-items: center;
                                justify-content: center;
                                color: #94a3b8;
                                font-size: 0.75rem;
                            }

                            .aisle.wide {
                                width: 60px;
                                min-width: 60px;
                            }

                            .driver-seat-row {
                                justify-content: center;
                                gap: 8px;
                            }

                            .seat {
                                width: 55px;
                                height: 55px;
                                border: 2px solid #cbd5e1;
                                border-radius: 8px;
                                display: flex;
                                flex-direction: column;
                                align-items: center;
                                justify-content: center;
                                font-weight: 600;
                                font-size: 0.75rem;
                                cursor: pointer;
                                transition: all 0.2s ease;
                                background: #ffffff;
                                color: #1e293b;
                                position: relative;
                            }

                            .seat:hover:not(.booked):not(.selected) {
                                border-color: #66bb6a;
                                background: #e8f5e9;
                                transform: scale(1.05);
                            }

                            .seat.selected {
                                background: #4fc3f7;
                                color: white;
                                border-color: #29b6f6;
                                box-shadow: 0 4px 12px rgba(79, 195, 247, 0.4);
                            }

                            .seat.booked {
                                background: #e2e8f0;
                                color: #94a3b8;
                                cursor: not-allowed;
                                opacity: 0.6;
                            }

                            .seat.driver-seat {
                                background: #1e293b;
                                color: white;
                                border-color: #0f172a;
                                cursor: default;
                                box-shadow: inset 0 0 8px rgba(15, 23, 42, 0.4);
                            }

                            .seat.driver-seat .seat-label {
                                font-size: 0.75rem;
                                text-transform: uppercase;
                            }

                            .seat.driver-seat .seat-number {
                                font-size: 0.65rem;
                                opacity: 0.85;
                            }

                            .seat.placeholder-seat {
                                visibility: hidden;
                            }

                            .seat-label {
                                font-size: 0.7rem;
                                font-weight: 700;
                                line-height: 1;
                            }

                            .seat-number {
                                font-size: 0.65rem;
                                opacity: 0.8;
                                margin-top: 2px;
                            }

                            .seat-legend {
                                display: flex;
                                justify-content: center;
                                gap: 20px;
                                margin-top: 20px;
                                padding: 15px;
                                background: white;
                                border-radius: 8px;
                                flex-wrap: wrap;
                            }

                            .legend-item {
                                display: flex;
                                align-items: center;
                                gap: 8px;
                                font-size: 0.875rem;
                            }

                            .legend-seat {
                                width: 30px;
                                height: 30px;
                                border-radius: 6px;
                                border: 2px solid #cbd5e1;
                            }

                            .legend-seat.available {
                                background: white;
                            }

                            .legend-seat.selected {
                                background: #4fc3f7;
                                border-color: #29b6f6;
                            }

                            .legend-seat.booked {
                                background: #e2e8f0;
                                opacity: 0.6;
                            }

                            .seat-position-hint {
                                position: absolute;
                                top: -25px;
                                left: 50%;
                                transform: translateX(-50%);
                                font-size: 0.65rem;
                                color: #64748b;
                                white-space: nowrap;
                                display: none;
                            }

                            .seat:hover:not(.booked) .seat-position-hint {
                                display: block;
                            }

                            .window-label,
                            .aisle-label {
                                font-size: 0.7rem;
                                color: #64748b;
                                font-weight: 600;
                                writing-mode: vertical-rl;
                                text-orientation: mixed;
                                padding: 5px;
                            }

                            .window-label {
                                margin-right: 8px;
                            }

                            .aisle-label {
                                margin-left: 8px;
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
                                box-shadow: 0 8px 20px rgba(102, 187, 106, 0.4);
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
                                        <i class="fas fa-ticket-alt me-3"></i>Book Bus Ticket
                                    </h1>
                                    <p class="mb-0 mt-2 opacity-90">Select your schedule and seat</p>
                                </div>
                            </div>

                            <div class="container mb-5">
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
                                <c:if test="${not empty error}">
                                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                        <i class="fas fa-exclamation-circle me-2"></i>
                                        <strong>Error!</strong> ${error}
                                        <button type="button" class="btn-close" data-bs-dismiss="alert"
                                            aria-label="Close"></button>
                                    </div>
                                </c:if>

                                <c:if test="${not empty route}">
                                    <!-- Hidden input to store routeId for JavaScript -->
                                    <input type="hidden" id="routeIdValue" value="${route.routeId}" />
                                    <input type="hidden" id="routeNameValue" value="${route.routeName}" />
                                    <c:if test="${not empty selectedSchedule}">
                                        <input type="hidden" id="preselectedScheduleId"
                                            value="${selectedSchedule.scheduleId}" />
                                    </c:if>

                                    <!-- Route Info -->
                                    <div class="route-info-card">
                                        <h3 class="mb-3">
                                            <i class="fas fa-route text-primary me-2"></i>${route.routeName}
                                        </h3>
                                        <div class="row">
                                            <div class="col-md-6">
                                                <p class="mb-2">
                                                    <i class="fas fa-map-marker-alt text-primary me-2"></i>
                                                    <strong>Departure:</strong> ${route.departureCity}
                                                </p>
                                                <p class="mb-2">
                                                    <i class="fas fa-map-marker-alt text-danger me-2"></i>
                                                    <strong>Destination:</strong> ${route.destinationCity}
                                                </p>
                                            </div>
                                            <div class="col-md-6">
                                                <p class="mb-2">
                                                    <i class="fas fa-road me-2"></i>
                                                    <strong>Distance:</strong> ${route.distance} km
                                                </p>
                                                <p class="mb-2">
                                                    <i class="fas fa-clock me-2"></i>
                                                    <strong>Duration:</strong> ${route.durationHours} hours
                                                </p>
                                                <p class="mb-0">
                                                    <i class="fas fa-money-bill-wave text-success me-2"></i>
                                                    <strong>Price:</strong>
                                                    <span class="text-success fw-bold">
                                                        <fmt:formatNumber value="${route.basePrice}" pattern="#,###" />
                                                        ₫
                                                    </span>
                                                </p>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Schedules List -->
                                    <div class="d-flex justify-content-between align-items-center mb-4">
                                        <h4 class="mb-0">
                                            <i class="fas fa-calendar-alt me-2"></i>Choose a schedule
                                        </h4>
                                    </div>

                                    <!-- Filter Controls -->
                                    <div class="filter-controls">
                                        <label class="form-label mb-2">
                                            <i class="fas fa-filter me-2"></i>Filter schedules:
                                        </label>
                                        <div class="filter-buttons">
                                            <button type="button" class="filter-btn active" data-filter="all">
                                                <i class="fas fa-list me-1"></i>All
                                            </button>
                                            <button type="button" class="filter-btn" data-filter="valid">
                                                <i class="fas fa-check-circle me-1"></i>Available
                                            </button>
                                            <button type="button" class="filter-btn" data-filter="expired">
                                                <i class="fas fa-clock me-1"></i>Expired
                                            </button>
                                        </div>
                                    </div>

                                    <c:choose>
                                        <c:when test="${empty schedules}">
                                            <div class="empty-schedules">
                                                <i class="fas fa-calendar-times fa-3x text-muted mb-3"></i>
                                                <h5 class="text-muted">No schedules available</h5>
                                                <p class="text-muted">Sorry, there are currently no schedules for this
                                                    route.</p>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div id="schedulesList">
                                                <c:forEach var="schedule" items="${schedules}">
                                                    <% // Check if schedule is expired - FIX: Added variable declaration
                                                        model.Schedule sched=(model.Schedule)
                                                        pageContext.getAttribute("schedule"); boolean isExpired=false;
                                                        if (sched !=null && sched.getDepartureDate() !=null &&
                                                        sched.getDepartureTime() !=null) { java.time.LocalDateTime
                                                        currentDateTime=(java.time.LocalDateTime)
                                                        request.getAttribute("currentDateTime"); if (currentDateTime
                                                        !=null) { java.time.LocalDateTime
                                                        departureDateTime=java.time.LocalDateTime.of(
                                                        sched.getDepartureDate(), sched.getDepartureTime() );
                                                        isExpired=departureDateTime.isBefore(currentDateTime); } }
                                                        pageContext.setAttribute("isExpired", isExpired); %>
                                                        <div class="schedule-card ${isExpired ? 'expired' : ''}"
                                                            data-schedule-id="${schedule.scheduleId}"
                                                            data-expired="${isExpired}">
                                                            <div class="schedule-card-header">
                                                                <div class="d-flex flex-wrap align-items-center gap-2">
                                                                    <span class="meta-pill">
                                                                        <i
                                                                            class="fas fa-bus me-1"></i>${schedule.busNumber}
                                                                    </span>
                                                                    <span class="meta-pill success">
                                                                        <i
                                                                            class="fas fa-chair me-1"></i>${schedule.availableSeats}
                                                                        ghế trống
                                                                    </span>
                                                                    <c:if test="${isExpired}">
                                                                        <span class="expired-badge">EXPIRED</span>
                                                                    </c:if>
                                                                </div>
                                                                <div class="text-end">
                                                                    <div class="text-muted small">Price from</div>
                                                                    <div class="schedule-price text-end">
                                                                        <fmt:formatNumber value="${route.basePrice}"
                                                                            pattern="#,###" />
                                                                        ₫
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <div class="schedule-info">
                                                                <div class="schedule-time-block">
                                                                    <div class="time-label">Departure</div>
                                                                    <div class="schedule-time">
                                                                        ${schedule.departureTime}
                                                                    </div>
                                                                    <div class="schedule-date">
                                                                        <i class="fas fa-calendar me-2"></i>
                                                                        ${schedule.departureDate}
                                                                    </div>
                                                                    <div class="station-name text-primary mt-2">
                                                                        <i class="fas fa-map-marker-alt me-1"></i>
                                                                        <c:choose>
                                                                            <c:when
                                                                                test="${not empty route.departureStationObj}">
                                                                                ${route.departureStationObj.stationName}
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                ${route.departureCity}
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </div>
                                                                </div>
                                                                <div class="schedule-time-divider">
                                                                    <i class="fas fa-arrow-right"></i>
                                                                </div>
                                                                <div class="schedule-time-block">
                                                                    <div class="time-label">Arrival (estimated)</div>
                                                                    <div class="schedule-time">
                                                                        <c:choose>
                                                                            <c:when
                                                                                test="${not empty schedule.estimatedArrivalTime}">
                                                                                ${schedule.estimatedArrivalTime}
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                Đang cập nhật
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </div>
                                                                    <div class="schedule-date text-muted">
                                                                        <i class="fas fa-flag-checkered me-2"></i>
                                                                        Thời gian đến dự kiến
                                                                    </div>
                                                                    <div class="station-name text-danger mt-2">
                                                                        <i class="fas fa-map-marker-alt me-1"></i>
                                                                        <c:choose>
                                                                            <c:when
                                                                                test="${not empty route.destinationStationObj}">
                                                                                ${route.destinationStationObj.stationName}
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                ${route.destinationCity}
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <div class="schedule-meta">
                                                                <span class="meta-pill">
                                                                    <i
                                                                        class="fas fa-route me-1"></i>${route.departureCity}
                                                                    → ${route.destinationCity}
                                                                </span>
                                                                <span class="meta-pill">
                                                                    <i class="fas fa-clock me-1"></i>Thời lượng:
                                                                    ${route.durationHours} giờ
                                                                </span>
                                                            </div>
                                                            <div class="schedule-actions">
                                                                <button type="button"
                                                                    class="btn btn-outline-success btn-sm"
                                                                    onclick="showSeatStatus(event, '${schedule.scheduleId}')"
                                                                    ${isExpired ? 'disabled' : '' }>
                                                                    <i class="fas fa-th-list me-1"></i>Ghế đã/đang trống
                                                                </button>
                                                                <button type="button"
                                                                    class="btn btn-outline-secondary btn-sm"
                                                                    onclick="openStationsModal(event)">
                                                                    <i class="fas fa-route me-1"></i>Stations Along
                                                                    Route
                                                                </button>
                                                                <div
                                                                    class="ms-auto text-muted small d-flex align-items-center">
                                                                    <i class="fas fa-hand-pointer me-2"></i>Click card
                                                                    to
                                                                    select schedule
                                                                </div>
                                                            </div>
                                                        </div>
                                                </c:forEach>
                                            </div>

                                            <!-- Seat status modal -->
                                            <div class="modal fade" id="seatStatusModal" tabindex="-1"
                                                aria-hidden="true">
                                                <div
                                                    class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
                                                    <div class="modal-content">
                                                        <div class="modal-header">
                                                            <h5 class="modal-title">
                                                                <i class="fas fa-th-list me-2"></i>Seat Status
                                                            </h5>
                                                            <button type="button" class="btn-close"
                                                                data-bs-dismiss="modal" aria-label="Close"></button>
                                                        </div>
                                                        <div class="modal-body">
                                                            <div id="seatStatusLoading" class="text-center py-4">
                                                                <div class="spinner-border text-success" role="status">
                                                                    <span class="visually-hidden">Loading...</span>
                                                                </div>
                                                                <div class="mt-3">Đang tải thông tin ghế...</div>
                                                            </div>
                                                            <div id="seatStatusError" class="alert alert-danger d-none">
                                                            </div>
                                                            <div id="seatStatusMeta"
                                                                class="d-flex flex-wrap gap-3 mb-3"></div>
                                                            <div class="bus-layout-container">
                                                                <div id="seatStatusGrid" class="seat-grid"></div>
                                                                <div class="seat-legend">
                                                                    <div class="legend-item">
                                                                        <div class="legend-seat available"></div>
                                                                        <span>Ghế trống</span>
                                                                    </div>
                                                                    <div class="legend-item">
                                                                        <div class="legend-seat booked"></div>
                                                                        <span>Ghế đã đặt</span>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Stations modal -->
                                            <div class="modal fade" id="stationsModal" tabindex="-1" aria-hidden="true">
                                                <div
                                                    class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
                                                    <div class="modal-content">
                                                        <div class="modal-header">
                                                            <h5 class="modal-title" id="stationsModalLabel">
                                                                <i class="fas fa-route me-2"></i>Danh sách trạm
                                                            </h5>
                                                            <button type="button" class="btn-close"
                                                                data-bs-dismiss="modal" aria-label="Close"></button>
                                                        </div>
                                                        <div class="modal-body">
                                                            <div id="stationsModalLoading" class="text-center py-4">
                                                                <div class="spinner-border text-success" role="status">
                                                                    <span class="visually-hidden">Loading...</span>
                                                                </div>
                                                                <div class="mt-3">Loading station list...</div>
                                                            </div>
                                                            <div id="stationsModalError"
                                                                class="alert alert-danger d-none"></div>
                                                            <div id="stationsModalList" class="list-group"></div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Bus Station Selection -->
                                            <div id="stationSelection" class="station-selection"
                                                style="${not empty selectedSchedule ? '' : 'display: none;'}">
                                                <h4 class="mb-4">
                                                    <i class="fas fa-map-marker-alt me-2"></i>Select Boarding and
                                                    Drop-off Bus Stations
                                                </h4>

                                                <div class="alert alert-info mb-4">
                                                    <i class="fas fa-info-circle me-2"></i>
                                                    <strong>Note:</strong> Please select a schedule first to load
                                                    available stations.
                                                    The drop-off station must come after the boarding station on the
                                                    route.
                                                </div>

                                                <!-- Loading indicator -->
                                                <div id="stationLoadingIndicator" class="text-center py-3"
                                                    style="display: none;">
                                                    <i class="fas fa-spinner fa-spin me-2"></i>
                                                    <span>Loading stations...</span>
                                                </div>

                                                <!-- Error message -->
                                                <div id="stationError" class="alert alert-danger"
                                                    style="display: none;">
                                                    <i class="fas fa-exclamation-circle me-2"></i>
                                                    <span id="stationErrorMessage"></span>
                                                </div>

                                                <div class="row">
                                                    <div class="col-md-6 mb-3">
                                                        <label for="boardingStationId" class="form-label">
                                                            <i class="fas fa-sign-in-alt me-2"></i>Boarding Bus Station
                                                            <span class="text-danger">*</span>
                                                        </label>
                                                        <select class="form-select" id="boardingStationId"
                                                            name="boardingStationId" required disabled>
                                                            <option value="">-- Select boarding bus station --</option>
                                                        </select>
                                                        <small class="form-text text-muted">
                                                            Choose where you will board the bus
                                                        </small>
                                                    </div>
                                                    <div class="col-md-6 mb-3">
                                                        <label for="alightingStationId" class="form-label">
                                                            <i class="fas fa-sign-out-alt me-2"></i>Drop-off Bus Station
                                                            <span class="text-danger">*</span>
                                                        </label>
                                                        <select class="form-select" id="alightingStationId"
                                                            name="alightingStationId" required disabled>
                                                            <option value="">-- Select drop-off bus station --</option>
                                                        </select>
                                                        <small class="form-text text-muted">
                                                            Choose where you will get off the bus
                                                        </small>
                                                    </div>
                                                </div>
                                                <div id="stationTimeline" class="station-timeline"
                                                    style="display: none;">
                                                    <div class="d-flex align-items-center gap-2 mb-3">
                                                        <i class="fas fa-route text-success fa-lg"></i>
                                                        <div>
                                                            <strong>Route stop overview</strong>
                                                            <div class="text-muted small">Highlighted section represents
                                                                your selected journey</div>
                                                        </div>
                                                    </div>
                                                    <div id="stationTimelineTrack" class="timeline-track"></div>
                                                </div>
                                            </div>

                                            <!-- Seat Selection -->
                                            <div id="seatSelection" class="seat-selection">
                                                <h4 class="mb-4">
                                                    <i class="fas fa-chair me-2"></i>Select Seats
                                                </h4>
                                                <div class="bus-layout-container">
                                                    <div id="seatGrid" class="seat-grid">
                                                        <!-- Seats will be loaded here via AJAX -->
                                                    </div>
                                                    <div class="seat-legend">
                                                        <div class="legend-item">
                                                            <div class="legend-seat available"></div>
                                                            <span>Available seat</span>
                                                        </div>
                                                        <div class="legend-item">
                                                            <div class="legend-seat selected"></div>
                                                            <span>Selected seat</span>
                                                        </div>
                                                        <div class="legend-item">
                                                            <div class="legend-seat booked"></div>
                                                            <span>Booked seat</span>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="text-center mt-4">
                                                    <button type="button" id="btnBook" class="btn btn-book" disabled>
                                                        <i class="fas fa-check me-2"></i>Book now
                                                    </button>
                                                </div>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </c:if>

                                <% String errorMsg=(String) request.getAttribute("error"); if (errorMsg==null ||
                                    errorMsg.trim().isEmpty()) { errorMsg=request.getParameter("error"); } if
                                    ((errorMsg==null || errorMsg.trim().isEmpty()) &&
                                    request.getAttribute("route")==null) { %>
                                    <div class="alert alert-warning">
                                        <i class="fas fa-exclamation-triangle me-2"></i>
                                        Route information not found. Please return to the search page.
                                    </div>
                                    <% } %>
                            </div>

                            <%@ include file="/views/partials/footer.jsp" %>

                                <script>
                                    // Get routeId from hidden input or URL
                                    const routeIdInput = document.getElementById('routeIdValue');
                                    const routeIdFromJSP = routeIdInput ? routeIdInput.value : null;
                                    const routeNameInput = document.getElementById('routeNameValue');
                                    const routeNameFromJSP = routeNameInput ? routeNameInput.value : '';
                                    const contextPath = '${pageContext.request.contextPath}';
                                    const preselectedScheduleInput = document.getElementById('preselectedScheduleId');
                                    const preselectedScheduleId = preselectedScheduleInput ? preselectedScheduleInput.value : null;

                                    let selectedScheduleId = null;
                                    let selectedSeat = null;

                                    // Station selection elements
                                    const boardingSelect = document.getElementById('boardingStationId');
                                    const alightingSelect = document.getElementById('alightingStationId');
                                    const stationLoadingIndicator = document.getElementById('stationLoadingIndicator');
                                    const stationError = document.getElementById('stationError');
                                    const stationErrorMessage = document.getElementById('stationErrorMessage');
                                    const stationTimeline = document.getElementById('stationTimeline');
                                    const stationTimelineTrack = document.getElementById('stationTimelineTrack');

                                    // Popup elements
                                    const seatStatusModalEl = document.getElementById('seatStatusModal');
                                    const seatStatusGrid = document.getElementById('seatStatusGrid');
                                    const seatStatusMeta = document.getElementById('seatStatusMeta');
                                    const seatStatusLoading = document.getElementById('seatStatusLoading');
                                    const seatStatusError = document.getElementById('seatStatusError');

                                    const stationsModalEl = document.getElementById('stationsModal');
                                    const stationsModalList = document.getElementById('stationsModalList');
                                    const stationsModalLoading = document.getElementById('stationsModalLoading');
                                    const stationsModalError = document.getElementById('stationsModalError');
                                    const stationsModalLabel = document.getElementById('stationsModalLabel');

                                    let currentStations = [];

                                    // Create seat layout for modal (read-only, no click events)
                                    function createSeatLayoutForModal(totalSeats, bookedSeats) {
                                        if (!seatStatusGrid) return;
                                        seatStatusGrid.innerHTML = '';

                                        // Render driver seat row at the top (front-left)
                                        function renderDriverSeatRow() {
                                            const driverRow = document.createElement('div');
                                            driverRow.className = 'seat-row driver-seat-row';

                                            const driverSeat = document.createElement('div');
                                            driverSeat.className = 'seat driver-seat';

                                            const driverLabel = document.createElement('div');
                                            driverLabel.className = 'seat-label';
                                            driverLabel.textContent = 'Driver';
                                            driverSeat.appendChild(driverLabel);

                                            const driverNumber = document.createElement('div');
                                            driverNumber.className = 'seat-number';
                                            driverNumber.textContent = 'Front';
                                            driverSeat.appendChild(driverNumber);

                                            driverRow.appendChild(driverSeat);

                                            const frontAisle = document.createElement('div');
                                            frontAisle.className = 'aisle wide';
                                            frontAisle.textContent = '│';
                                            driverRow.appendChild(frontAisle);

                                            const placeholderSeat = document.createElement('div');
                                            placeholderSeat.className = 'seat placeholder-seat';
                                            driverRow.appendChild(placeholderSeat);

                                            const placeholderSeat2 = document.createElement('div');
                                            placeholderSeat2.className = 'seat placeholder-seat';
                                            driverRow.appendChild(placeholderSeat2);

                                            seatStatusGrid.appendChild(driverRow);
                                        }

                                        renderDriverSeatRow();

                                        // Calculate seats per side (A = left, B = right)
                                        const aSeats = Math.ceil(totalSeats / 2);
                                        const bSeats = totalSeats - aSeats;

                                        // Standard bus layout: 2 seats per row on each side (2-2 layout)
                                        const seatsPerRow = 2;
                                        const rows = Math.ceil(Math.max(aSeats, bSeats) / seatsPerRow);

                                        const seatMap = [];
                                        let aSeatNum = 1;
                                        let bSeatNum = 1;

                                        for (let row = 0; row < rows; row++) {
                                            const rowSeats = [];

                                            // Left side: A seats (window + aisle)
                                            if (aSeatNum <= aSeats) {
                                                rowSeats.push(createSeatDataForModal(aSeatNum, 'A', 'window', row));
                                                aSeatNum++;
                                            }

                                            if (aSeatNum <= aSeats) {
                                                rowSeats.push(createSeatDataForModal(aSeatNum, 'A', 'aisle', row));
                                                aSeatNum++;
                                            }

                                            // Aisle separator
                                            rowSeats.push({ type: 'aisle', wide: true });

                                            // Right side: B seats (aisle + window)
                                            if (bSeatNum <= bSeats) {
                                                rowSeats.push(createSeatDataForModal(bSeatNum + aSeats, 'B', 'aisle', row));
                                                bSeatNum++;
                                            }

                                            if (bSeatNum <= bSeats) {
                                                rowSeats.push(createSeatDataForModal(bSeatNum + aSeats, 'B', 'window', row));
                                                bSeatNum++;
                                            }

                                            if (rowSeats.length > 1) {
                                                seatMap.push(rowSeats);
                                            }
                                        }

                                        // Helper function to create seat data
                                        function createSeatDataForModal(number, side, position, rowIndex) {
                                            if (number > totalSeats) return null;

                                            let label;
                                            if (side === 'A') {
                                                label = 'A' + String(number).padStart(2, '0');
                                            } else {
                                                const bNumber = number - aSeats;
                                                label = 'B' + String(bNumber).padStart(2, '0');
                                            }

                                            return {
                                                number: number,
                                                label: label,
                                                side: side,
                                                position: position,
                                                rowIndex: rowIndex
                                            };
                                        }

                                        // Render seats
                                        seatMap.forEach((rowSeats, rowIndex) => {
                                            const seatRow = document.createElement('div');
                                            seatRow.className = 'seat-row';

                                            rowSeats.forEach(item => {
                                                if (!item) return;

                                                if (item.type === 'aisle') {
                                                    const aisle = document.createElement('div');
                                                    aisle.className = 'aisle ' + (item.wide ? 'wide' : '');
                                                    aisle.textContent = '│';
                                                    seatRow.appendChild(aisle);
                                                } else if (item.number && item.number <= totalSeats) {
                                                    const seat = document.createElement('div');
                                                    seat.className = 'seat';
                                                    seat.dataset.seatNumber = item.number;

                                                    const isBooked = bookedSeats.includes(item.number);
                                                    if (isBooked) {
                                                        seat.classList.add('booked');
                                                    } else {
                                                        seat.classList.add('available');
                                                    }

                                                    // Create seat label
                                                    const labelDiv = document.createElement('div');
                                                    labelDiv.className = 'seat-label';
                                                    labelDiv.textContent = item.label;
                                                    seat.appendChild(labelDiv);

                                                    const numberDiv = document.createElement('div');
                                                    numberDiv.className = 'seat-number';
                                                    numberDiv.textContent = '#' + item.number;
                                                    seat.appendChild(numberDiv);

                                                    // Add position hint
                                                    const hint = document.createElement('div');
                                                    hint.className = 'seat-position-hint';
                                                    const positionText = item.position === 'window' ? 'Window' : 'Aisle';
                                                    const sideText = item.side === 'A' ? 'Left' : 'Right';
                                                    const rowText = rowIndex < 3 ? 'Front' : 'Back';
                                                    hint.textContent = positionText + ' - ' + sideText + ' - ' + rowText;
                                                    seat.appendChild(hint);

                                                    seatRow.appendChild(seat);
                                                }
                                            });

                                            if (seatRow.children.length > 0) {
                                                seatStatusGrid.appendChild(seatRow);
                                            }
                                        });
                                    }

                                    function showSeatStatus(event, scheduleId) {
                                        if (event) {
                                            event.stopPropagation();
                                        }
                                        if (!scheduleId || !seatStatusModalEl) {
                                            return;
                                        }

                                        seatStatusError.classList.add('d-none');
                                        seatStatusLoading.classList.remove('d-none');
                                        if (seatStatusGrid) {
                                            seatStatusGrid.innerHTML = '';
                                        }
                                        seatStatusMeta.innerHTML = '';

                                        const seatModal = new bootstrap.Modal(seatStatusModalEl);
                                        seatModal.show();

                                        fetch(contextPath + '/tickets/schedule-seats?scheduleId=' + encodeURIComponent(scheduleId))
                                            .then(response => {
                                                if (!response.ok) {
                                                    throw new Error('HTTP ' + response.status);
                                                }
                                                return response.json();
                                            })
                                            .then(data => {
                                                seatStatusLoading.classList.add('d-none');
                                                if (data.error) {
                                                    seatStatusError.textContent = data.error;
                                                    seatStatusError.classList.remove('d-none');
                                                    return;
                                                }

                                                const booked = data.bookedSeats || [];
                                                const available = data.availableSeats || [];
                                                const totalSeats = data.totalSeats || (booked.length + available.length);

                                                seatStatusMeta.innerHTML =
                                                    '<span class="meta-pill success"><i class="fas fa-chair me-1"></i>' + available.length + ' available seats</span>' +
                                                    '<span class="meta-pill"><i class="fas fa-ban me-1"></i>' + booked.length + ' booked</span>' +
                                                    '<span class="meta-pill"><i class="fas fa-hashtag me-1"></i>' + totalSeats + ' total seats</span>';

                                                createSeatLayoutForModal(totalSeats, booked);
                                            })
                                            .catch(error => {
                                                seatStatusLoading.classList.add('d-none');
                                                seatStatusError.textContent = 'Cannot load seat information: ' + error;
                                                seatStatusError.classList.remove('d-none');
                                            });
                                    }

                                    function openStationsModal(event) {
                                        if (event) {
                                            event.stopPropagation();
                                        }
                                        if (!stationsModalEl) {
                                            return;
                                        }

                                        stationsModalError.classList.add('d-none');
                                        stationsModalLoading.classList.remove('d-none');
                                        stationsModalList.innerHTML = '';

                                        if (stationsModalLabel) {
                                            stationsModalLabel.innerHTML = '<i class="fas fa-route me-2"></i>Danh sách trạm - ' + (routeNameFromJSP || 'Tuyến xe');
                                        }

                                        const stationModal = new bootstrap.Modal(stationsModalEl);
                                        stationModal.show();

                                        if (!routeIdFromJSP) {
                                            stationsModalLoading.classList.add('d-none');
                                            stationsModalError.textContent = 'Route information not found.';
                                            stationsModalError.classList.remove('d-none');
                                            return;
                                        }

                                        fetch(contextPath + '/tickets/get-stations-by-route?routeId=' + encodeURIComponent(routeIdFromJSP))
                                            .then(response => {
                                                if (!response.ok) {
                                                    throw new Error('HTTP ' + response.status);
                                                }
                                                return response.json();
                                            })
                                            .then(data => {
                                                stationsModalLoading.classList.add('d-none');
                                                if (data.error) {
                                                    stationsModalError.textContent = data.error;
                                                    stationsModalError.classList.remove('d-none');
                                                    return;
                                                }

                                                const stations = data.stations || [];
                                                if (stations.length === 0) {
                                                    stationsModalList.innerHTML = '<div class="alert alert-info mb-0">No station information for this route yet.</div>';
                                                    return;
                                                }

                                                stationsModalList.innerHTML = stations.map((st, idx) => {
                                                    const name = st.stationName || 'Trạm';
                                                    const city = st.city || '';
                                                    const address = st.address ? ' - ' + st.address : '';
                                                    const seq = st.sequenceNumber ? st.sequenceNumber : (idx + 1);
                                                    return '<div class="list-group-item d-flex justify-content-between align-items-start">' +
                                                        '<div>' +
                                                        '<div class="fw-semibold">' + name + '</div>' +
                                                        '<div class="small text-muted">' + city + address + '</div>' +
                                                        '</div>' +
                                                        '<span class="badge bg-light text-dark border">#' + seq + '</span>' +
                                                        '</div>';
                                                }).join('');
                                            })
                                            .catch(error => {
                                                stationsModalLoading.classList.add('d-none');
                                                stationsModalError.textContent = 'Cannot load station list: ' + error;
                                                stationsModalError.classList.remove('d-none');
                                            });
                                    }

                                    /**
                                     * Show loading indicator
                                     */
                                    function showStationLoading() {
                                        stationLoadingIndicator.style.display = 'block';
                                        stationError.style.display = 'none';
                                        boardingSelect.disabled = true;
                                        alightingSelect.disabled = true;
                                    }

                                    /**
                                     * Hide loading indicator
                                     */
                                    function hideStationLoading() {
                                        stationLoadingIndicator.style.display = 'none';
                                        boardingSelect.disabled = false;
                                        alightingSelect.disabled = false;
                                    }

                                    /**
                                     * Show error message
                                     */
                                    function showStationError(message) {
                                        stationError.style.display = 'block';
                                        stationErrorMessage.textContent = message;
                                        hideStationLoading();
                                        currentStations = [];
                                        renderStationTimeline();
                                    }

                                    /**
                                     * Hide error message
                                     */
                                    function hideStationError() {
                                        stationError.style.display = 'none';
                                    }

                                    function computeHighlightRange() {
                                        if (!boardingSelect.value || !alightingSelect.value) {
                                            return null;
                                        }
                                        const startIndex = currentStations.findIndex(
                                            station => station.stationId === boardingSelect.value);
                                        const endIndex = currentStations.findIndex(
                                            station => station.stationId === alightingSelect.value);
                                        if (startIndex === -1 || endIndex === -1 || endIndex <= startIndex) {
                                            return null;
                                        }
                                        return { start: startIndex, end: endIndex };
                                    }

                                    function renderStationTimeline() {
                                        if (!stationTimeline || !stationTimelineTrack) {
                                            return;
                                        }
                                        stationTimelineTrack.innerHTML = '';
                                        if (!currentStations || currentStations.length === 0) {
                                            stationTimeline.style.display = 'none';
                                            return;
                                        }
                                        stationTimeline.style.display = 'block';
                                        const highlightRange = computeHighlightRange();
                                        currentStations.forEach((station, index) => {
                                            const stopEl = document.createElement('div');
                                            stopEl.className = 'timeline-stop';
                                            if (index === 0 || index === currentStations.length - 1) {
                                                stopEl.classList.add('terminal');
                                            }
                                            if (highlightRange && index >= highlightRange.start && index <= highlightRange.end) {
                                                stopEl.classList.add('active');
                                            }

                                            const stopSequence = document.createElement('div');
                                            stopSequence.className = 'stop-sequence';
                                            stopSequence.textContent = 'Stop ' + (station.sequenceNumber || (index + 1));

                                            const stopName = document.createElement('div');
                                            stopName.className = 'stop-name';
                                            stopName.textContent = station.stationName || 'Station';

                                            const stopCity = document.createElement('div');
                                            stopCity.className = 'stop-city';
                                            stopCity.textContent = station.city || '';

                                            stopEl.appendChild(stopSequence);
                                            stopEl.appendChild(stopName);
                                            stopEl.appendChild(stopCity);
                                            stationTimelineTrack.appendChild(stopEl);

                                            if (index < currentStations.length - 1) {
                                                const connector = document.createElement('div');
                                                connector.className = 'timeline-connector';
                                                if (highlightRange && index >= highlightRange.start && index < highlightRange.end) {
                                                    connector.classList.add('active');
                                                }
                                                stationTimelineTrack.appendChild(connector);
                                            }
                                        });
                                    }

                                    /**
                                     * Create station option element
                                     */
                                    function createStationOption(station, sequenceNumber) {
                                        const option = document.createElement('option');
                                        option.value = station.stationId;
                                        option.setAttribute('data-order', sequenceNumber || '0');

                                        let label = station.stationName || 'Station';
                                        if (station.city) {
                                            label += ' - ' + station.city;
                                        }
                                        if (station.address) {
                                            label += ' (' + station.address + ')';
                                        }
                                        if (sequenceNumber) {
                                            label += ' [Stop ' + sequenceNumber + ']';
                                        }

                                        option.textContent = label;
                                        return option;
                                    }

                                    /**
                                     * Populate station dropdowns
                                     */
                                    function populateStationDropdowns(stations) {
                                        // Clear existing options
                                        boardingSelect.innerHTML = '<option value="">-- Select boarding bus station --</option>';
                                        alightingSelect.innerHTML = '<option value="">-- Select drop-off bus station --</option>';

                                        if (!stations || stations.length === 0) {
                                            showStationError('No stations available for this schedule.');
                                            return;
                                        }

                                        // Add stations to both dropdowns
                                        stations.forEach(station => {
                                            const sequenceNumber = station.sequenceNumber || 0;
                                            const boardingOption = createStationOption(station, sequenceNumber);
                                            const alightingOption = createStationOption(station, sequenceNumber);

                                            boardingSelect.appendChild(boardingOption);
                                            alightingSelect.appendChild(alightingOption);
                                        });

                                        hideStationLoading();
                                        hideStationError();
                                        currentStations = stations || [];

                                        // Auto-select first station as boarding and last station as drop-off
                                        if (stations.length >= 2) {
                                            const firstStation = stations[0];
                                            const lastStation = stations[stations.length - 1];

                                            // Select first station as boarding
                                            boardingSelect.value = firstStation.stationId;

                                            // Trigger boarding change to filter alighting options
                                            const boardingOrder = parseInt(boardingSelect.selectedOptions[0]?.getAttribute('data-order') || '0');

                                            // Disable alighting options that come before or at boarding station
                                            Array.from(alightingSelect.options).forEach(option => {
                                                if (option.value && option.getAttribute('data-order')) {
                                                    const alightingOrder = parseInt(option.getAttribute('data-order'));
                                                    if (alightingOrder <= boardingOrder) {
                                                        option.disabled = true;
                                                        option.style.display = 'none';
                                                    } else {
                                                        option.disabled = false;
                                                        option.style.display = '';
                                                    }
                                                }
                                            });

                                            // Select last station as drop-off
                                            alightingSelect.value = lastStation.stationId;

                                            // Show seat selection since both stations are selected
                                            validateAndShowSeatSelection();
                                        }

                                        renderStationTimeline();
                                    }

                                    /**
                                     * Load stations for a schedule
                                     */
                                    function loadScheduleStations(scheduleId) {
                                        if (!scheduleId) {
                                            showStationError('Schedule ID is required.');
                                            return;
                                        }

                                        showStationLoading();
                                        hideStationError();

                                        fetch('${pageContext.request.contextPath}/tickets/get-stations-by-schedule?scheduleId=' + encodeURIComponent(scheduleId))
                                            .then(response => {
                                                if (!response.ok) {
                                                    throw new Error('HTTP error! status: ' + response.status);
                                                }
                                                return response.json();
                                            })
                                            .then(data => {
                                                if (data.error) {
                                                    // Try fallback to route stations
                                                    if (routeIdFromJSP) {
                                                        loadRouteStations(routeIdFromJSP);
                                                    } else {
                                                        showStationError('Error loading stations: ' + data.error);
                                                    }
                                                    return;
                                                }

                                                if (data.stations && data.stations.length > 0) {
                                                    populateStationDropdowns(data.stations);
                                                } else {
                                                    // Fallback to route stations
                                                    if (routeIdFromJSP) {
                                                        loadRouteStations(routeIdFromJSP);
                                                    } else {
                                                        showStationError('No stations available for this schedule.');
                                                    }
                                                }
                                            })
                                            .catch(error => {
                                                console.error('Error loading stations:', error);
                                                // Try fallback to route stations
                                                if (routeIdFromJSP) {
                                                    loadRouteStations(routeIdFromJSP);
                                                } else {
                                                    showStationError('Unable to load stations. Please try again.');
                                                }
                                            });
                                    }

                                    /**
                                     * Load stations from route (fallback)
                                     */
                                    function loadRouteStations(routeId) {
                                        if (!routeId) {
                                            showStationError('Route ID is required.');
                                            return;
                                        }

                                        showStationLoading();

                                        fetch('${pageContext.request.contextPath}/tickets/get-stations-by-route?routeId=' + encodeURIComponent(routeId))
                                            .then(response => {
                                                if (!response.ok) {
                                                    throw new Error('HTTP error! status: ' + response.status);
                                                }
                                                return response.json();
                                            })
                                            .then(data => {
                                                if (data.error) {
                                                    showStationError('Error loading stations: ' + data.error);
                                                    return;
                                                }

                                                if (data.stations && data.stations.length > 0) {
                                                    populateStationDropdowns(data.stations);
                                                } else {
                                                    showStationError('No stations available for this route.');
                                                }
                                            })
                                            .catch(error => {
                                                console.error('Error loading route stations:', error);
                                                showStationError('Unable to load stations. Please try again.');
                                            });
                                    }

                                    // Filter functionality
                                    document.querySelectorAll('.filter-btn').forEach(btn => {
                                        btn.addEventListener('click', function () {
                                            // Update active button
                                            document.querySelectorAll('.filter-btn').forEach(b => b.classList.remove('active'));
                                            this.classList.add('active');

                                            const filter = this.dataset.filter;
                                            const scheduleCards = document.querySelectorAll('.schedule-card');

                                            scheduleCards.forEach(card => {
                                                const isExpired = card.dataset.expired === 'true';

                                                if (filter === 'all') {
                                                    card.style.display = '';
                                                } else if (filter === 'valid') {
                                                    card.style.display = isExpired ? 'none' : '';
                                                } else if (filter === 'expired') {
                                                    card.style.display = isExpired ? '' : 'none';
                                                }
                                            });
                                        });
                                    });

                                    // Handle schedule selection
                                    document.querySelectorAll('.schedule-card').forEach(card => {
                                        card.addEventListener('click', function () {
                                            // Check if schedule is expired
                                            const isExpired = this.dataset.expired === 'true';

                                            if (isExpired) {
                                                alert('This schedule has expired and cannot be booked.');
                                                return;
                                            }

                                            // Remove previous selection
                                            document.querySelectorAll('.schedule-card').forEach(c => {
                                                c.classList.remove('selected');
                                            });

                                            // Mark this as selected
                                            this.classList.add('selected');
                                            selectedScheduleId = this.dataset.scheduleId;

                                            // Move station selection to appear right after this schedule card
                                            const stationSelectionEl = document.getElementById('stationSelection');
                                            const seatSelectionEl = document.getElementById('seatSelection');

                                            // Insert station selection right after this card
                                            this.insertAdjacentElement('afterend', stationSelectionEl);

                                            // Insert seat selection right after station selection
                                            stationSelectionEl.insertAdjacentElement('afterend', seatSelectionEl);

                                            // Show station selection
                                            stationSelectionEl.style.display = 'block';

                                            // Reset station selection
                                            resetStationSelection();

                                            // Load stations for this schedule
                                            if (selectedScheduleId) {
                                                loadScheduleStations(selectedScheduleId);
                                            } else if (routeIdFromJSP) {
                                                loadRouteStations(routeIdFromJSP);
                                            }

                                            // Hide seat selection until stations are selected
                                            seatSelectionEl.classList.remove('active');
                                            document.getElementById('btnBook').disabled = true;
                                            selectedSeat = null;

                                            // Scroll to the station selection section
                                            setTimeout(() => {
                                                stationSelectionEl.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
                                            }, 100);
                                        });
                                    });

                                    // Handle preselected schedule
                                    if (preselectedScheduleId) {
                                        const preselectedCard = document.querySelector('.schedule-card[data-schedule-id="' + preselectedScheduleId + '"]');
                                        if (preselectedCard) {
                                            preselectedCard.classList.add('selected');
                                            selectedScheduleId = preselectedScheduleId;

                                            // Move station selection to appear right after this schedule card
                                            const stationSelectionEl = document.getElementById('stationSelection');
                                            const seatSelectionEl = document.getElementById('seatSelection');

                                            // Insert station selection right after this card
                                            preselectedCard.insertAdjacentElement('afterend', stationSelectionEl);

                                            // Insert seat selection right after station selection
                                            stationSelectionEl.insertAdjacentElement('afterend', seatSelectionEl);

                                            stationSelectionEl.style.display = 'block';
                                            resetStationSelection();
                                            loadScheduleStations(preselectedScheduleId);
                                        }
                                    }

                                    /**
                                     * Handle boarding station change
                                     */
                                    boardingSelect.addEventListener('change', function () {
                                        const boardingOrder = this.selectedOptions[0]?.getAttribute('data-order');

                                        if (boardingOrder) {
                                            const boardingOrderInt = parseInt(boardingOrder);

                                            // Enable/disable alighting options based on stop order
                                            Array.from(alightingSelect.options).forEach(option => {
                                                if (option.value && option.getAttribute('data-order')) {
                                                    const alightingOrder = parseInt(option.getAttribute('data-order'));

                                                    if (alightingOrder <= boardingOrderInt) {
                                                        option.disabled = true;
                                                        option.style.display = 'none';
                                                    } else {
                                                        option.disabled = false;
                                                        option.style.display = '';
                                                    }
                                                }
                                            });

                                            // Clear alighting if current selection is invalid
                                            const selectedAlighting = alightingSelect.selectedOptions[0];
                                            if (selectedAlighting && (selectedAlighting.disabled || !selectedAlighting.value)) {
                                                alightingSelect.value = '';
                                            }
                                        }
                                        renderStationTimeline();
                                        // Validate and show seat selection if both stations are selected
                                        if (this.value && alightingSelect.value) {
                                            validateAndShowSeatSelection();
                                        } else {
                                            document.getElementById('seatSelection').classList.remove('active');
                                            document.getElementById('btnBook').disabled = true;
                                        }
                                    });

                                    /**
                                     * Handle alighting station change
                                     */
                                    alightingSelect.addEventListener('change', function () {
                                        renderStationTimeline();
                                        if (boardingSelect.value && this.value) {
                                            validateAndShowSeatSelection();
                                        } else {
                                            document.getElementById('seatSelection').classList.remove('active');
                                            document.getElementById('btnBook').disabled = true;
                                        }
                                    });

                                    /**
                                     * Validate stations and show seat selection
                                     */
                                    function validateAndShowSeatSelection() {
                                        if (!boardingSelect.value || !alightingSelect.value) {
                                            document.getElementById('seatSelection').classList.remove('active');
                                            document.getElementById('btnBook').disabled = true;
                                            renderStationTimeline();
                                            return;
                                        }

                                        // Check if stations are the same
                                        if (boardingSelect.value === alightingSelect.value) {
                                            alert('Boarding and drop-off stations must be different.');
                                            alightingSelect.value = '';
                                            document.getElementById('seatSelection').classList.remove('active');
                                            document.getElementById('btnBook').disabled = true;
                                            renderStationTimeline();
                                            return;
                                        }

                                        // Validate order
                                        const boardingOrder = boardingSelect.selectedOptions[0]?.getAttribute('data-order');
                                        const alightingOrder = alightingSelect.selectedOptions[0]?.getAttribute('data-order');

                                        if (boardingOrder && alightingOrder) {
                                            const boardingOrderInt = parseInt(boardingOrder);
                                            const alightingOrderInt = parseInt(alightingOrder);

                                            if (alightingOrderInt <= boardingOrderInt) {
                                                alert('Drop-off station must come after boarding station on the route.');
                                                alightingSelect.value = '';
                                                document.getElementById('seatSelection').classList.remove('active');
                                                document.getElementById('btnBook').disabled = true;
                                                renderStationTimeline();
                                                return;
                                            }
                                        }

                                        // Valid selection - show seat selection
                                        document.getElementById('seatSelection').classList.add('active');
                                        if (selectedScheduleId) {
                                            loadAvailableSeats(selectedScheduleId);
                                        }
                                        renderStationTimeline();
                                    }

                                    /**
                                     * Reset station selection
                                     */
                                    function resetStationSelection() {
                                        boardingSelect.value = '';
                                        alightingSelect.value = '';
                                        document.getElementById('seatSelection').classList.remove('active');
                                        document.getElementById('btnBook').disabled = true;
                                        selectedSeat = null;

                                        // Reset alighting options - enable all
                                        Array.from(alightingSelect.options).forEach(option => {
                                            if (option.value) {
                                                option.disabled = false;
                                                option.style.display = '';
                                            }
                                        });
                                        renderStationTimeline();
                                    }


                                    // Realistic bus seat layout mapping
                                    // Creates a layout similar to real buses with A seats (left) and B seats (right)
                                    function createSeatLayout(totalSeats, bookedSeats) {
                                        const seatGrid = document.getElementById('seatGrid');
                                        seatGrid.innerHTML = '';

                                        // Render driver seat row at the top (front-left)
                                        function renderDriverSeatRow() {
                                            const driverRow = document.createElement('div');
                                            driverRow.className = 'seat-row driver-seat-row';

                                            const driverSeat = document.createElement('div');
                                            driverSeat.className = 'seat driver-seat';

                                            const driverLabel = document.createElement('div');
                                            driverLabel.className = 'seat-label';
                                            driverLabel.textContent = 'Driver';
                                            driverSeat.appendChild(driverLabel);

                                            const driverNumber = document.createElement('div');
                                            driverNumber.className = 'seat-number';
                                            driverNumber.textContent = 'Front';
                                            driverSeat.appendChild(driverNumber);

                                            driverRow.appendChild(driverSeat);

                                            const frontAisle = document.createElement('div');
                                            frontAisle.className = 'aisle wide';
                                            frontAisle.textContent = '│';
                                            driverRow.appendChild(frontAisle);

                                            const placeholderSeat = document.createElement('div');
                                            placeholderSeat.className = 'seat placeholder-seat';
                                            driverRow.appendChild(placeholderSeat);

                                            const placeholderSeat2 = document.createElement('div');
                                            placeholderSeat2.className = 'seat placeholder-seat';
                                            driverRow.appendChild(placeholderSeat2);

                                            seatGrid.appendChild(driverRow);
                                        }

                                        renderDriverSeatRow();

                                        // Calculate seats per side (A = left, B = right)
                                        const aSeats = Math.ceil(totalSeats / 2);
                                        const bSeats = totalSeats - aSeats;

                                        // Standard bus layout: 2 seats per row on each side (2-2 layout)
                                        // Some rows may have 1 seat on one side
                                        const seatsPerRow = 2;
                                        const rows = Math.ceil(Math.max(aSeats, bSeats) / seatsPerRow);

                                        const seatMap = [];
                                        let aSeatNum = 1;
                                        let bSeatNum = 1;

                                        for (let row = 0; row < rows; row++) {
                                            const rowSeats = [];

                                            // Left side: A seats (window + aisle)
                                            if (aSeatNum <= aSeats) {
                                                rowSeats.push(createSeatData(aSeatNum, 'A', 'window', row));
                                                aSeatNum++;
                                            }

                                            if (aSeatNum <= aSeats) {
                                                rowSeats.push(createSeatData(aSeatNum, 'A', 'aisle', row));
                                                aSeatNum++;
                                            }

                                            // Aisle separator
                                            rowSeats.push({ type: 'aisle', wide: true });

                                            // Right side: B seats (aisle + window)
                                            if (bSeatNum <= bSeats) {
                                                rowSeats.push(createSeatData(bSeatNum + aSeats, 'B', 'aisle', row));
                                                bSeatNum++;
                                            }

                                            if (bSeatNum <= bSeats) {
                                                rowSeats.push(createSeatData(bSeatNum + aSeats, 'B', 'window', row));
                                                bSeatNum++;
                                            }

                                            if (rowSeats.length > 1) {
                                                seatMap.push(rowSeats);
                                            }
                                        }

                                        // Helper function to create seat data
                                        function createSeatData(number, side, position, rowIndex) {
                                            if (number > totalSeats) return null;

                                            let label;
                                            if (side === 'A') {
                                                label = 'A' + String(number).padStart(2, '0');
                                            } else {
                                                // B seats: number is already offset by aSeats
                                                const bNumber = number - aSeats;
                                                label = 'B' + String(bNumber).padStart(2, '0');
                                            }

                                            return {
                                                number: number,
                                                label: label,
                                                side: side,
                                                position: position,
                                                rowIndex: rowIndex
                                            };
                                        }

                                        // Render seats
                                        seatMap.forEach((rowSeats, rowIndex) => {
                                            const seatRow = document.createElement('div');
                                            seatRow.className = 'seat-row';

                                            rowSeats.forEach(item => {
                                                if (!item) return;

                                                if (item.type === 'aisle') {
                                                    const aisle = document.createElement('div');
                                                    aisle.className = 'aisle ' + (item.wide ? 'wide' : '');
                                                    aisle.textContent = '│';
                                                    seatRow.appendChild(aisle);
                                                } else if (item.number && item.number <= totalSeats) {
                                                    const seat = document.createElement('div');
                                                    seat.className = 'seat';
                                                    seat.dataset.seatNumber = item.number;

                                                    const isBooked = bookedSeats.includes(item.number);
                                                    if (isBooked) {
                                                        seat.classList.add('booked');
                                                    }

                                                    // Create seat label
                                                    const labelDiv = document.createElement('div');
                                                    labelDiv.className = 'seat-label';
                                                    labelDiv.textContent = item.label;
                                                    seat.appendChild(labelDiv);

                                                    const numberDiv = document.createElement('div');
                                                    numberDiv.className = 'seat-number';
                                                    numberDiv.textContent = '#' + item.number;
                                                    seat.appendChild(numberDiv);

                                                    // Add position hint
                                                    const hint = document.createElement('div');
                                                    hint.className = 'seat-position-hint';
                                                    const positionText = item.position === 'window' ? 'Window' : 'Aisle';
                                                    const sideText = item.side === 'A' ? 'Left' : 'Right';
                                                    const rowText = rowIndex < 3 ? 'Front' : 'Back';
                                                    hint.textContent = positionText + ' - ' + sideText + ' - ' + rowText;
                                                    seat.appendChild(hint);

                                                    if (!isBooked) {
                                                        seat.addEventListener('click', function () {
                                                            // Remove previous selection
                                                            document.querySelectorAll('.seat').forEach(s => {
                                                                s.classList.remove('selected');
                                                            });

                                                            // Mark this as selected
                                                            this.classList.add('selected');
                                                            selectedSeat = item.number;

                                                            // Validate and enable book button
                                                            if (boardingSelect.value && alightingSelect.value && selectedSeat) {
                                                                document.getElementById('btnBook').disabled = false;
                                                            } else {
                                                                document.getElementById('btnBook').disabled = true;
                                                            }
                                                        });
                                                    }

                                                    seatRow.appendChild(seat);
                                                }
                                            });

                                            if (seatRow.children.length > 0) {
                                                seatGrid.appendChild(seatRow);
                                            }
                                        });
                                    }

                                    function loadAvailableSeats(scheduleId) {
                                        const seatGrid = document.getElementById('seatGrid');
                                        seatGrid.innerHTML = '<div class="col-12 text-center"><i class="fas fa-spinner fa-spin"></i> Loading...</div>';

                                        fetch('${pageContext.request.contextPath}/tickets/schedule-seats?scheduleId=' + encodeURIComponent(scheduleId))
                                            .then(response => {
                                                if (!response.ok) {
                                                    throw new Error('HTTP error! status: ' + response.status);
                                                }
                                                return response.json();
                                            })
                                            .then(data => {
                                                if (data.error) {
                                                    seatGrid.innerHTML = '<div class="col-12 text-center text-danger">' + data.error + '</div>';
                                                    return;
                                                }

                                                const totalSeats = data.totalSeats || 39;
                                                const bookedSeats = data.bookedSeats || [];

                                                createSeatLayout(totalSeats, bookedSeats);
                                            })
                                            .catch(error => {
                                                console.error('Error loading seats:', error);
                                                seatGrid.innerHTML = '<div class="col-12 text-center text-danger">Error while loading seats. Please try again.</div>';
                                            });
                                    }

                                    // Handle booking
                                    document.getElementById('btnBook').addEventListener('click', function () {
                                        if (!selectedScheduleId || !selectedSeat) {
                                            alert('Please select a schedule and a seat');
                                            return;
                                        }

                                        // Validate station choices
                                        const boardingStationId = document.getElementById('boardingStationId').value;
                                        const alightingStationId = document.getElementById('alightingStationId').value;
                                        if (!boardingStationId || !alightingStationId) {
                                            alert('Please select both boarding and drop-off stations');
                                            return;
                                        }
                                        if (boardingStationId === alightingStationId) {
                                            alert('Boarding and drop-off stations must be different.');
                                            return;
                                        }

                                        // Get routeId from URL or route object
                                        const urlParams = new URLSearchParams(window.location.search);
                                        let routeId = urlParams.get('routeId');

                                        // If routeId not in URL, try to get it from the route object (if available)
                                        if (!routeId && routeIdFromJSP) {
                                            routeId = routeIdFromJSP;
                                        }

                                        // Create form and submit
                                        const form = document.createElement('form');
                                        form.method = 'POST';
                                        form.action = '${pageContext.request.contextPath}/tickets/book';

                                        // Add action parameter to use bookTicketBySchedule method
                                        const actionInput = document.createElement('input');
                                        actionInput.type = 'hidden';
                                        actionInput.name = 'action';
                                        actionInput.value = 'book';

                                        const scheduleIdInput = document.createElement('input');
                                        scheduleIdInput.type = 'hidden';
                                        scheduleIdInput.name = 'scheduleId';
                                        scheduleIdInput.value = selectedScheduleId;

                                        const seatNumberInput = document.createElement('input');
                                        seatNumberInput.type = 'hidden';
                                        seatNumberInput.name = 'seatNumber';
                                        seatNumberInput.value = selectedSeat;

                                        // Add routeId to form so it's preserved on error redirect
                                        if (routeId) {
                                            const routeIdInput = document.createElement('input');
                                            routeIdInput.type = 'hidden';
                                            routeIdInput.name = 'routeId';
                                            routeIdInput.value = routeId;
                                            form.appendChild(routeIdInput);
                                        }

                                        // Add station IDs if selected
                                        if (boardingStationId) {
                                            const boardingInput = document.createElement('input');
                                            boardingInput.type = 'hidden';
                                            boardingInput.name = 'boardingStationId';
                                            boardingInput.value = boardingStationId;
                                            form.appendChild(boardingInput);
                                        }

                                        if (alightingStationId) {
                                            const alightingInput = document.createElement('input');
                                            alightingInput.type = 'hidden';
                                            alightingInput.name = 'alightingStationId';
                                            alightingInput.value = alightingStationId;
                                            form.appendChild(alightingInput);
                                        }

                                        form.appendChild(actionInput);
                                        form.appendChild(scheduleIdInput);
                                        form.appendChild(seatNumberInput);
                                        document.body.appendChild(form);
                                        form.submit();
                                    });
                                </script>
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
                    </body>

                    </html>