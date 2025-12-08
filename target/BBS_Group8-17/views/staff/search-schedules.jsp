<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="/views/partials/head.jsp">
        <jsp:param name="title" value="Search Schedules - Staff Panel" />
    </jsp:include>
    <style>
        .search-form {
            background: linear-gradient(135deg, #27ae60 0%, #229954 100%);
            padding: 1.5rem;
            border-radius: 10px;
            color: white;
            margin-bottom: 20px;
        }
        .schedule-card {
            background: white;
            border: 1px solid #dee2e6;
            border-radius: 10px;
            margin-bottom: 1rem;
            transition: all 0.2s;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }
        .schedule-card:hover {
            border-color: #27ae60;
            box-shadow: 0 4px 12px rgba(39, 174, 96, 0.15);
        }
        .schedule-header {
            padding: 1.25rem;
            cursor: pointer;
        }
        .time-display {
            font-size: 1.25rem;
            font-weight: 700;
            color: #27ae60;
        }
        .route-display {
            font-size: 1.1rem;
            font-weight: 600;
        }
        .info-badge {
            background: #e8f5e9;
            color: #2e7d32;
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.85rem;
        }
        .seat-badge {
            background: #e3f2fd;
            color: #1565c0;
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.85rem;
        }
        .passengers-panel {
            background: #f8f9fa;
            border-top: 1px solid #dee2e6;
            padding: 1rem 1.25rem;
            display: none;
        }
        .passengers-panel.show {
            display: block;
        }
        .passenger-row {
            background: white;
            border: 1px solid #e9ecef;
            border-radius: 8px;
            padding: 0.75rem 1rem;
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            transition: all 0.2s;
        }
        .passenger-row:hover {
            border-color: #27ae60;
        }
        .passenger-row.checked-in {
            background: #e8f5e9;
            border-color: #27ae60;
        }
        .passenger-row.cancelled {
            background: #fee2e2;
            opacity: 0.7;
        }
        .passenger-row.cancelled .passenger-info {
            text-decoration: line-through;
            color: #9ca3af;
        }
        .seat-number {
            background: #27ae60;
            color: white;
            width: 36px;
            height: 36px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 0.9rem;
            margin-right: 1rem;
        }
        .passenger-row.cancelled .seat-number {
            background: #9ca3af;
        }
        .passenger-info {
            flex: 1;
        }
        .stats-mini {
            display: flex;
            gap: 1rem;
            margin-bottom: 1rem;
        }
        .stat-mini {
            background: white;
            padding: 0.5rem 1rem;
            border-radius: 8px;
            border: 1px solid #e9ecef;
        }
        .stat-mini .value {
            font-weight: 700;
            font-size: 1.1rem;
        }
        .loading-spinner {
            text-align: center;
            padding: 2rem;
            color: #6c757d;
        }
        .expand-icon {
            transition: transform 0.2s;
        }
        .schedule-card.expanded .expand-icon {
            transform: rotate(180deg);
        }
    </style>
</head>
<body>
    <%@ include file="/views/partials/staff-header.jsp" %>
    
    <div class="container mt-4">
        <!-- Search Form -->
        <div class="search-form">
            <h4 class="mb-3"><i class="fas fa-search me-2"></i>Search Schedules</h4>
            <form method="post" action="${pageContext.request.contextPath}/staff/search-schedules">
                <div class="row g-3">
                    <div class="col-md-3">
                        <label class="form-label">Departure City</label>
                        <select name="departureCityId" class="form-select">
                            <option value="">All Cities</option>
                            <c:forEach var="city" items="${cities}">
                                <option value="${city.cityId}" ${departureCityId == city.cityId.toString() ? 'selected' : ''}>
                                    ${city.cityName}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Destination City</label>
                        <select name="destinationCityId" class="form-select">
                            <option value="">All Cities</option>
                            <c:forEach var="city" items="${cities}">
                                <option value="${city.cityId}" ${destinationCityId == city.cityId.toString() ? 'selected' : ''}>
                                    ${city.cityName}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Departure Date</label>
                        <input type="date" name="departureDate" class="form-control" 
                               value="${departureDate}">
                    </div>
                    <div class="col-md-3 d-flex align-items-end">
                        <button type="submit" class="btn btn-light w-100">
                            <i class="fas fa-search me-2"></i>Search
                        </button>
                    </div>
                </div>
            </form>
        </div>

        <!-- Alert Messages -->
        <c:if test="${not empty param.message}">
            <div class="alert alert-success alert-dismissible fade show">
                <i class="fas fa-check-circle me-2"></i>${param.message}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${not empty param.error}">
            <div class="alert alert-danger alert-dismissible fade show">
                <i class="fas fa-exclamation-circle me-2"></i>${param.error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${not empty param.warning}">
            <div class="alert alert-warning alert-dismissible fade show">
                <i class="fas fa-exclamation-triangle me-2"></i>${param.warning}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Page Header -->
        <div class="row mb-3">
            <div class="col-12">
                <h5><i class="fas fa-bus me-2 text-success"></i>Schedules for ${departureDate}</h5>
                <small class="text-muted">Click on a schedule to view passengers and perform check-in</small>
            </div>
        </div>

        <!-- Search Results -->
        <c:choose>
            <c:when test="${empty schedules}">
                <div class="text-center py-5 text-muted">
                    <i class="fas fa-search fa-3x mb-3 d-block opacity-50"></i>
                    <p>No schedules found. Please search for available trips.</p>
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach var="schedule" items="${schedules}">
                    <div class="schedule-card" id="schedule-${schedule.scheduleId}">
                        <div class="schedule-header" onclick="togglePassengers('${schedule.scheduleId}')">
                            <div class="row align-items-center">
                                <div class="col-md-2 text-center">
                                    <div class="time-display">${schedule.departureTime}</div>
                                    <small class="text-muted">Departure</small>
                                </div>
                                <div class="col-md-1 text-center">
                                    <i class="fas fa-arrow-right text-muted"></i>
                                </div>
                                <div class="col-md-2 text-center">
                                    <div class="time-display">${schedule.estimatedArrivalTime}</div>
                                    <small class="text-muted">Arrival</small>
                                </div>
                                <div class="col-md-4">
                                    <div class="route-display">${schedule.routeName}</div>
                                    <div class="text-muted">
                                        <i class="fas fa-map-marker-alt me-1"></i>${schedule.departureCity} 
                                        <i class="fas fa-long-arrow-alt-right mx-2"></i>
                                        <i class="fas fa-map-marker me-1"></i>${schedule.destinationCity}
                                    </div>
                                    <div class="mt-2">
                                        <span class="info-badge me-2"><i class="fas fa-bus me-1"></i>${schedule.busNumber}</span>
                                        <span class="seat-badge"><i class="fas fa-chair me-1"></i>${schedule.availableSeats} seats available</span>
                                    </div>
                                </div>
                                <div class="col-md-3 text-end">
                                    <div class="d-flex flex-column gap-2 align-items-end">
                                        <div>
                                            <button type="button" class="btn btn-outline-primary btn-sm" 
                                                    onclick="event.stopPropagation(); togglePassengers('${schedule.scheduleId}')">
                                                <i class="fas fa-users me-1"></i>Passengers
                                                <i class="fas fa-chevron-down expand-icon ms-1"></i>
                                            </button>
                                        </div>
                                        <c:choose>
                                            <c:when test="${schedule.availableSeats > 0}">
                                                <a href="${pageContext.request.contextPath}/staff/book?scheduleId=${schedule.scheduleId}" 
                                                   class="btn btn-success btn-sm" onclick="event.stopPropagation()">
                                                    <i class="fas fa-ticket-alt me-2"></i>Book Ticket
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary">Sold Out</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Passengers Panel (expandable) -->
                        <div class="passengers-panel" id="passengers-${schedule.scheduleId}">
                            <div class="loading-spinner" id="loading-${schedule.scheduleId}">
                                <i class="fas fa-spinner fa-spin fa-2x"></i>
                                <p class="mt-2 mb-0">Loading passengers...</p>
                            </div>
                            <div id="passengers-content-${schedule.scheduleId}" style="display: none;">
                                <!-- Stats -->
                                <div class="stats-mini" id="stats-${schedule.scheduleId}"></div>
                                <!-- Passengers list -->
                                <div id="passengers-list-${schedule.scheduleId}"></div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>

    <%@ include file="/views/partials/footer.jsp" %>
    
    <script>
        const loadedSchedules = {};
        
        function togglePassengers(scheduleId) {
            const card = document.getElementById('schedule-' + scheduleId);
            const panel = document.getElementById('passengers-' + scheduleId);
            
            if (panel.classList.contains('show')) {
                panel.classList.remove('show');
                card.classList.remove('expanded');
            } else {
                panel.classList.add('show');
                card.classList.add('expanded');
                
                // Load passengers if not already loaded
                if (!loadedSchedules[scheduleId]) {
                    loadPassengers(scheduleId);
                }
            }
        }
        
        function loadPassengers(scheduleId) {
            const loading = document.getElementById('loading-' + scheduleId);
            const content = document.getElementById('passengers-content-' + scheduleId);
            const statsCont = document.getElementById('stats-' + scheduleId);
            const listCont = document.getElementById('passengers-list-' + scheduleId);
            
            loading.style.display = 'block';
            content.style.display = 'none';
            
            fetch('${pageContext.request.contextPath}/staff/api/passengers?scheduleId=' + scheduleId)
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        loadedSchedules[scheduleId] = true;
                        
                        // Render stats
                        statsCont.innerHTML = `
                            <div class="stat-mini">
                                <span class="value text-primary">\${data.totalActive}</span>
                                <small class="text-muted ms-1">Active</small>
                            </div>
                            <div class="stat-mini">
                                <span class="value text-success">\${data.checkedIn}</span>
                                <small class="text-muted ms-1">Checked In</small>
                            </div>
                            <div class="stat-mini">
                                <span class="value text-warning">\${data.pending}</span>
                                <small class="text-muted ms-1">Pending</small>
                            </div>
                            <div class="stat-mini">
                                <span class="value text-danger">\${data.cancelled}</span>
                                <small class="text-muted ms-1">Cancelled</small>
                            </div>
                        `;
                        
                        // Render passengers
                        if (data.passengers.length === 0) {
                            listCont.innerHTML = `
                                <div class="text-center py-3 text-muted">
                                    <i class="fas fa-users-slash me-2"></i>No passengers booked yet
                                </div>
                            `;
                        } else {
                            let html = '';
                            data.passengers.forEach(p => {
                                const isCancelled = p.status === 'CANCELLED';
                                const isCheckedIn = p.status === 'CHECKED_IN';
                                const isPaid = p.paymentStatus === 'PAID';
                                
                                html += `
                                    <div class="passenger-row \${isCheckedIn ? 'checked-in' : ''} \${isCancelled ? 'cancelled' : ''}">
                                        <div class="seat-number">\${p.seatNumber}</div>
                                        <div class="passenger-info">
                                            <div class="fw-bold">\${p.customerName}</div>
                                            <small class="text-muted">\${p.customerPhone || '-'}</small>
                                            <div class="mt-1">
                                                <span class="badge \${isCheckedIn ? 'bg-success' : (isCancelled ? 'bg-danger' : 'bg-secondary')} me-1">
                                                    \${isCheckedIn ? 'Checked In' : (isCancelled ? 'Cancelled' : 'Pending')}
                                                </span>
                                                <span class="badge \${isPaid ? 'bg-success' : 'bg-warning'}">
                                                    \${p.paymentStatus}
                                                </span>
                                            </div>
                                        </div>
                                        <div class="d-flex gap-2">
                                `;
                                
                                if (!isCancelled && !isCheckedIn) {
                                    if (!isPaid) {
                                        html += `
                                            <form method="post" action="${pageContext.request.contextPath}/staff/mark-paid" style="display:inline">
                                                <input type="hidden" name="ticketId" value="\${p.ticketId}">
                                                <input type="hidden" name="redirectTo" value="${pageContext.request.contextPath}/staff/search-schedules?departureDate=${departureDate}">
                                                <button type="submit" class="btn btn-warning btn-sm" title="Mark Paid">
                                                    <i class="fas fa-dollar-sign"></i>
                                                </button>
                                            </form>
                                        `;
                                    } else {
                                        html += `
                                            <form method="post" action="${pageContext.request.contextPath}/staff/check-in" style="display:inline">
                                                <input type="hidden" name="ticketId" value="\${p.ticketId}">
                                                <input type="hidden" name="scheduleId" value="\${scheduleId}">
                                                <input type="hidden" name="redirectTo" value="${pageContext.request.contextPath}/staff/search-schedules?departureDate=${departureDate}">
                                                <button type="submit" class="btn btn-success btn-sm" title="Check-in">
                                                    <i class="fas fa-check"></i>
                                                </button>
                                            </form>
                                        `;
                                    }
                                    html += `
                                        <a href="${pageContext.request.contextPath}/staff/edit-ticket?id=\${p.ticketId}" 
                                           class="btn btn-outline-warning btn-sm" title="Edit">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                    `;
                                }
                                
                                html += `
                                            <a href="${pageContext.request.contextPath}/staff/ticket-detail?id=\${p.ticketId}" 
                                               class="btn btn-outline-secondary btn-sm" title="View">
                                                <i class="fas fa-eye"></i>
                                            </a>
                                        </div>
                                    </div>
                                `;
                            });
                            listCont.innerHTML = html;
                        }
                        
                        loading.style.display = 'none';
                        content.style.display = 'block';
                    } else {
                        listCont.innerHTML = `
                            <div class="alert alert-danger">
                                <i class="fas fa-exclamation-circle me-2"></i>\${data.message}
                            </div>
                        `;
                        loading.style.display = 'none';
                        content.style.display = 'block';
                    }
                })
                .catch(error => {
                    listCont.innerHTML = `
                        <div class="alert alert-danger">
                            <i class="fas fa-exclamation-circle me-2"></i>Error loading passengers
                        </div>
                    `;
                    loading.style.display = 'none';
                    content.style.display = 'block';
                });
        }
        
        // Reload passengers after action
        function refreshPassengers(scheduleId) {
            loadedSchedules[scheduleId] = false;
            loadPassengers(scheduleId);
        }
    </script>
</body>
</html>
