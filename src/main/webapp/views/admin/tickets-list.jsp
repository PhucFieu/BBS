<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <jsp:include page="/views/partials/head.jsp">
                    <jsp:param name="title" value="Ticket Management - Admin Panel" />
                </jsp:include>
                <style>
                    :root {
                        --primary: #2563eb;
                        --success: #10b981;
                        --warning: #f59e0b;
                        --danger: #ef4444;
                        --muted: #64748b;
                        --surface: #ffffff;
                        --bg: #f6f8fb;
                        --border: #e5e7eb;
                    }

                    body {
                        background: var(--bg);
                    }

                    .page-header {
                        background: var(--surface);
                        border-bottom: 1px solid var(--border);
                    }

                    .page-title {
                        font-weight: 700;
                    }

                    .kpi-card {
                        background: var(--surface);
                        border: 1px solid var(--border);
                        border-radius: .75rem;
                    }

                    .kpi-icon {
                        width: 40px;
                        height: 40px;
                        border-radius: 50%;
                        display: inline-flex;
                        align-items: center;
                        justify-content: center;
                        color: #fff;
                        font-size: .9rem;
                    }

                    .kpi-total {
                        background: var(--primary);
                    }

                    .kpi-confirmed {
                        background: var(--success);
                    }

                    .kpi-pending {
                        background: var(--warning);
                    }

                    .kpi-cancelled {
                        background: var(--danger);
                    }

                    .filters {
                        background: var(--surface);
                        border: 1px solid var(--border);
                        border-radius: .75rem;
                    }

                    .table-card {
                        background: var(--surface);
                        border: 1px solid var(--border);
                        border-radius: .75rem;
                        overflow: hidden;
                    }

                    .table thead th {
                        background: #f8fafc;
                        color: #111827;
                        font-size: .8rem;
                        text-transform: uppercase;
                        letter-spacing: .04em;
                        border-bottom: 1px solid var(--border);
                        position: sticky;
                        top: 0;
                        z-index: 1;
                    }

                    .table tbody td {
                        vertical-align: middle;
                        border-top-color: var(--border);
                    }

                    .ticket-number {
                        color: var(--primary);
                        font-weight: 600;
                    }

                    .status-badge,
                    .payment-badge {
                        font-weight: 600;
                        font-size: .75rem;
                        border-radius: 20px;
                        padding: .35rem .6rem;
                    }

                    .status-confirmed {
                        background: rgba(16, 185, 129, .12);
                        color: var(--success);
                    }

                    .status-pending {
                        background: rgba(245, 158, 11, .12);
                        color: var(--warning);
                    }

                    .status-cancelled {
                        background: rgba(239, 68, 68, .12);
                        color: var(--danger);
                    }

                    .payment-paid {
                        color: var(--success);
                    }

                    .payment-pending {
                        color: var(--warning);
                    }

                    .payment-cancelled {
                        color: var(--danger);
                    }

                    .actions .btn {
                        padding: .35rem .55rem;
                    }

                    .modal-content {
                        border: none;
                        border-radius: .75rem;
                    }

                    .modal-header {
                        border-bottom: 1px solid var(--border);
                    }

                    .modal-footer {
                        border-top: 1px solid var(--border);
                    }

                    .modal-body .card {
                        border: 1px solid var(--border);
                        border-radius: .5rem;
                    }

                    .modal-body .card.bg-light {
                        background-color: #f8fafc !important;
                    }

                    /* Notification Styles */
                    .alert {
                        border-radius: .75rem;
                        border: none;
                        box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
                        animation: slideDown 0.3s ease-out;
                    }

                    @keyframes slideDown {
                        from {
                            opacity: 0;
                            transform: translateY(-10px);
                        }

                        to {
                            opacity: 1;
                            transform: translateY(0);
                        }
                    }

                    .alert-success {
                        background: linear-gradient(135deg, #10b981 0%, #059669 100%);
                        color: white;
                    }

                    .alert-danger {
                        background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
                        color: white;
                    }

                    .alert-warning {
                        background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
                        color: white;
                    }

                    .alert-info {
                        background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
                        color: white;
                    }

                    .alert .btn-close {
                        filter: brightness(0) invert(1);
                    }

                    .alert strong {
                        font-weight: 600;
                    }
                </style>
            </head>

            <body>
                <jsp:include page="../partials/admin-header.jsp" />
                <div class="container-fluid px-3 px-lg-4 py-3">
                    <div class="page-header rounded-3 px-3 px-lg-4 py-3 mb-3">
                        <div class="d-flex align-items-center justify-content-between flex-wrap gap-2">
                            <div>
                                <h1 class="page-title h3 mb-1">
                                    <i class="fas fa-ticket-alt me-2 text-primary"></i>
                                    Ticket Management
                                </h1>
                                <p class="text-muted mb-0">Quản lý và theo dõi tất cả vé trong hệ thống</p>
                            </div>
                            <div class="d-flex gap-2">
                                <a href="${pageContext.request.contextPath}/admin/tickets/analytics"
                                    class="btn btn-outline-primary">
                                    <i class="fas fa-chart-line me-2"></i>Analytics
                                </a>
                                <a href="${pageContext.request.contextPath}/tickets/add" class="btn btn-primary">
                                    <i class="fas fa-plus me-2"></i>New Ticket
                                </a>
                            </div>
                        </div>
                    </div>

                    <!-- Notification Messages -->
                    <c:if test="${not empty param.message}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="fas fa-check-circle me-2"></i>
                            <strong>Success!</strong> ${param.message}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>
                    <c:if test="${not empty param.error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-circle me-2"></i>
                            <strong>Error!</strong> ${param.error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>
                    <c:if test="${not empty param.warning}">
                        <div class="alert alert-warning alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            <strong>Warning!</strong> ${param.warning}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>
                    <c:if test="${not empty param.info}">
                        <div class="alert alert-info alert-dismissible fade show" role="alert">
                            <i class="fas fa-info-circle me-2"></i>
                            <strong>Info:</strong> ${param.info}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <div class="row g-3 mb-3">
                        <div class="col-6 col-md-3">
                            <div class="kpi-card p-3">
                                <div class="d-flex align-items-center justify-content-between">
                                    <div>
                                        <div class="text-muted small">Total Tickets</div>
                                        <div class="h4 mb-0">${tickets.size()}</div>
                                    </div>
                                    <div class="kpi-icon kpi-total">
                                        <i class="fas fa-ticket-alt"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-6 col-md-3">
                            <div class="kpi-card p-3">
                                <div class="d-flex align-items-center justify-content-between">
                                    <div>
                                        <div class="text-muted small">Confirmed</div>
                                        <div class="h4 mb-0">
                                            <c:set var="confirmedCount" value="0" />
                                            <c:forEach var="t" items="${tickets}">
                                                <c:if test="${t.status == 'CONFIRMED'}">
                                                    <c:set var="confirmedCount" value="${confirmedCount + 1}" />
                                                </c:if>
                                            </c:forEach>
                                            ${confirmedCount}
                                        </div>
                                    </div>
                                    <div class="kpi-icon kpi-confirmed">
                                        <i class="fas fa-check"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-6 col-md-3">
                            <div class="kpi-card p-3">
                                <div class="d-flex align-items-center justify-content-between">
                                    <div>
                                        <div class="text-muted small">Pending</div>
                                        <div class="h4 mb-0">
                                            <c:set var="pendingCount" value="0" />
                                            <c:forEach var="t" items="${tickets}">
                                                <c:if test="${t.status == 'PENDING'}">
                                                    <c:set var="pendingCount" value="${pendingCount + 1}" />
                                                </c:if>
                                            </c:forEach>
                                            ${pendingCount}
                                        </div>
                                    </div>
                                    <div class="kpi-icon kpi-pending">
                                        <i class="fas fa-clock"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-6 col-md-3">
                            <div class="kpi-card p-3">
                                <div class="d-flex align-items-center justify-content-between">
                                    <div>
                                        <div class="text-muted small">Cancelled</div>
                                        <div class="h4 mb-0">
                                            <c:set var="cancelledCount" value="0" />
                                            <c:forEach var="t" items="${tickets}">
                                                <c:if test="${t.status == 'CANCELLED'}">
                                                    <c:set var="cancelledCount" value="${cancelledCount + 1}" />
                                                </c:if>
                                            </c:forEach>
                                            ${cancelledCount}
                                        </div>
                                    </div>
                                    <div class="kpi-icon kpi-cancelled">
                                        <i class="fas fa-times"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="filters p-3 mb-3">
                        <form method="get" action="${pageContext.request.contextPath}/admin/tickets"
                            class="row g-2 align-items-end">
                            <div class="col-12 col-md-5">
                                <label for="searchTerm" class="form-label mb-1">Tìm kiếm</label>
                                <input type="text" class="form-control" id="searchTerm" name="searchTerm"
                                    placeholder="Theo số vé, tên, số điện thoại..."
                                    value="${param.searchTerm != null ? param.searchTerm : ''}">
                            </div>
                            <div class="col-6 col-md-2">
                                <label for="statusFilter" class="form-label mb-1">Trạng thái</label>
                                <select class="form-select" id="statusFilter" name="status">
                                    <option value="">Tất cả</option>
                                    <option value="CONFIRMED" ${param.status=='CONFIRMED' ? 'selected' : '' }>Confirmed
                                    </option>
                                    <option value="PENDING" ${param.status=='PENDING' ? 'selected' : '' }>Pending
                                    </option>
                                    <option value="CANCELLED" ${param.status=='CANCELLED' ? 'selected' : '' }>Cancelled
                                    </option>
                                </select>
                            </div>
                            <div class="col-6 col-md-2">
                                <label for="paymentFilter" class="form-label mb-1">Thanh toán</label>
                                <select class="form-select" id="paymentFilter" name="paymentStatus">
                                    <option value="">Tất cả</option>
                                    <option value="PAID" ${param.paymentStatus=='PAID' ? 'selected' : '' }>Paid</option>
                                    <option value="PENDING" ${param.paymentStatus=='PENDING' ? 'selected' : '' }>Pending
                                        Payment</option>
                                    <option value="CANCELLED" ${param.paymentStatus=='CANCELLED' ? 'selected' : '' }>
                                        Cancelled</option>
                                </select>
                            </div>
                            <div class="col-12 col-md-3 d-flex gap-2">
                                <button type="submit" class="btn btn-primary flex-grow-1">
                                    <i class="fas fa-search me-2"></i>Tìm
                                </button>
                                <a href="${pageContext.request.contextPath}/admin/tickets"
                                    class="btn btn-outline-secondary">
                                    <i class="fas fa-rotate me-1"></i>
                                    Refresh
                                </a>
                            </div>
                        </form>
                    </div>

                    <div class="table-card">
                        <div class="table-responsive">
                            <table class="table align-middle mb-0">
                                <thead>
                                    <tr>
                                        <th style="min-width:120px;">Ticket #</th>
                                        <th style="min-width:180px;">Passenger</th>
                                        <th style="min-width:200px;">Route</th>
                                        <th style="min-width:110px;">Bus</th>
                                        <th style="min-width:140px;">Departure</th>
                                        <th>Seat</th>
                                        <th style="min-width:110px;">Price</th>
                                        <th>Status</th>
                                        <th>Payment</th>
                                        <th style="min-width:140px;">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="ticket" items="${tickets}">
                                        <c:set var="boardingStationName"
                                            value="${not empty ticket.boardingStationName ? ticket.boardingStationName : 'N/A'}" />
                                        <c:set var="boardingStationCity"
                                            value="${not empty ticket.boardingCity ? ticket.boardingCity : 'N/A'}" />
                                        <c:set var="dropoffStationName"
                                            value="${not empty ticket.alightingStationName ? ticket.alightingStationName : 'N/A'}" />
                                        <c:set var="dropoffStationCity"
                                            value="${not empty ticket.alightingCity ? ticket.alightingCity : 'N/A'}" />
                                        <c:set var="formattedDepartureDate" value="" />
                                        <c:set var="formattedDepartureTime" value="" />
                                        <c:set var="formattedPrice" value="0" />
                                        <c:if test="${ticket.departureDateSql != null}">
                                            <fmt:formatDate value="${ticket.departureDateSql}" pattern="dd/MM/yyyy"
                                                var="formattedDepartureDate" />
                                        </c:if>
                                        <c:if test="${ticket.departureTimeSql != null}">
                                            <fmt:formatDate value="${ticket.departureTimeSql}" pattern="HH:mm"
                                                var="formattedDepartureTime" />
                                        </c:if>
                                        <c:if test="${ticket.ticketPrice != null}">
                                            <fmt:formatNumber value="${ticket.ticketPrice}" pattern="#,###"
                                                var="formattedPrice" />
                                        </c:if>
                                        <c:set var="passengerName"
                                            value="${not empty ticket.userName ? ticket.userName : 'N/A'}" />
                                        <c:set var="passengerEmail"
                                            value="${not empty ticket.userEmail ? ticket.userEmail : ''}" />
                                        <c:set var="passengerPhone"
                                            value="${ticket.user != null and not empty ticket.user.phoneNumber ? ticket.user.phoneNumber : ''}" />

                                        <c:set var="safeRouteName"
                                            value="${not empty ticket.routeName ? ticket.routeName : '-'}" />
                                        <c:set var="safeDepartureCity"
                                            value="${not empty ticket.departureCity ? ticket.departureCity : '-'}" />
                                        <c:set var="safeDestinationCity"
                                            value="${not empty ticket.destinationCity ? ticket.destinationCity : '-'}" />
                                        <c:set var="safeRouteDistance"
                                            value="${ticket.route != null and ticket.route.distance != null ? ticket.route.distance : '-'}" />
                                        <c:set var="safeBusNumber"
                                            value="${not empty ticket.busNumber ? ticket.busNumber : '-'}" />
                                        <c:set var="safeBusType"
                                            value="${ticket.bus != null and not empty ticket.bus.busType ? ticket.bus.busType : '-'}" />

                                        <tr>
                                            <td>
                                                <span class="ticket-number">#${ticket.ticketNumber}</span>
                                            </td>
                                            <td>
                                                <div class="fw-semibold">${passengerName}</div>
                                                <small class="text-muted">
                                                    <c:out value="${not empty passengerEmail ? passengerEmail : '-'}" />
                                                </small>
                                            </td>
                                            <td>
                                                <div class="fw-semibold">
                                                    <c:out
                                                        value="${not empty ticket.departureCity ? ticket.departureCity : '-'}" />
                                                    →
                                                    <c:out
                                                        value="${not empty ticket.destinationCity ? ticket.destinationCity : '-'}" />
                                                </div>
                                                <small class="text-muted">
                                                    <c:out
                                                        value="${not empty ticket.routeName ? ticket.routeName : '-'}" />
                                                </small>
                                            </td>
                                            <td>
                                                <div class="fw-semibold">
                                                    <c:out
                                                        value="${not empty ticket.busNumber ? ticket.busNumber : '-'}" />
                                                </div>
                                                <small class="text-muted">
                                                    <c:out
                                                        value="${ticket.bus != null and not empty ticket.bus.busType ? ticket.bus.busType : '-'}" />
                                                </small>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty formattedDepartureDate}">
                                                        <div class="fw-semibold">${formattedDepartureDate}</div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="fw-semibold text-muted">-</div>
                                                    </c:otherwise>
                                                </c:choose>
                                                <c:choose>
                                                    <c:when test="${not empty formattedDepartureTime}">
                                                        <small class="text-muted">${formattedDepartureTime}</small>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <small class="text-muted">-</small>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <span
                                                    class="badge bg-primary-subtle text-primary border border-primary">${ticket.seatNumber}</span>
                                            </td>
                                            <td class="fw-semibold">
                                                <c:choose>
                                                    <c:when test="${not empty formattedPrice}">
                                                        ${formattedPrice} ₫
                                                    </c:when>
                                                    <c:otherwise>
                                                        0 ₫
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <span class="status-badge
                                        ${ticket.status == 'CONFIRMED' ? 'status-confirmed' :
                                          ticket.status == 'PENDING' ? 'status-pending' : 'status-cancelled'}">
                                                    ${ticket.status == 'CONFIRMED' ? 'CONFIRMED' :
                                                    ticket.status == 'PENDING' ? 'PENDING' : 'CANCELLED'}
                                                </span>
                                            </td>
                                            <td>
                                                <span
                                                    class="payment-badge
                                        ${ticket.paymentStatus == 'PAID' ? 'payment-paid' :
                                          ticket.paymentStatus == 'PENDING' ? 'payment-pending' : 'payment-cancelled'}">
                                                    ${ticket.paymentStatus == 'PAID' ? 'PAID' :
                                                    ticket.paymentStatus == 'PENDING' ? 'PENDING' : 'CANCELLED'}
                                                </span>
                                            </td>
                                            <td class="actions">
                                                <div class="d-flex gap-1">
                                                    <button type="button" class="btn btn-sm btn-outline-info"
                                                        data-bs-toggle="modal" data-bs-target="#ticketDetailModal"
                                                        data-ticket-id="${ticket.ticketId}"
                                                        data-ticket-number="${ticket.ticketNumber}"
                                                        data-passenger-name="${passengerName}"
                                                        data-passenger-email="${passengerEmail}"
                                                        data-passenger-phone="${passengerPhone}"
                                                        data-route-name="${safeRouteName}"
                                                        data-departure-city="${safeDepartureCity}"
                                                        data-destination-city="${safeDestinationCity}"
                                                        data-route-distance="${safeRouteDistance}"
                                                        data-boarding-station="${boardingStationName}"
                                                        data-boarding-city="${boardingStationCity}"
                                                        data-dropoff-station="${dropoffStationName}"
                                                        data-dropoff-city="${dropoffStationCity}"
                                                        data-bus-number="${safeBusNumber}"
                                                        data-bus-type="${safeBusType}"
                                                        data-departure-date="${empty formattedDepartureDate ? '-' : formattedDepartureDate}"
                                                        data-departure-time="${empty formattedDepartureTime ? '-' : formattedDepartureTime}"
                                                        data-seat-number="${ticket.seatNumber}"
                                                        data-price="${empty formattedPrice ? '0' : formattedPrice}"
                                                        data-status="${ticket.status}"
                                                        data-payment-status="${ticket.paymentStatus}"
                                                        title="View Details">
                                                        <i class="fas fa-eye"></i>
                                                    </button>
                                                    <a href="${pageContext.request.contextPath}/admin/tickets/edit?id=${ticket.ticketId}"
                                                        class="btn btn-sm btn-outline-primary" title="Edit">
                                                        <i class="fas fa-edit"></i>
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/admin/tickets/delete?id=${ticket.ticketId}"
                                                        class="btn btn-sm btn-outline-danger"
                                                        onclick="return confirm('Are you sure you want to delete this ticket?')"
                                                        title="Delete">
                                                        <i class="fas fa-trash"></i>
                                                    </a>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- Ticket Detail Modal -->
                    <div class="modal fade" id="ticketDetailModal" tabindex="-1"
                        aria-labelledby="ticketDetailModalLabel" aria-hidden="true">
                        <div class="modal-dialog modal-lg modal-dialog-scrollable">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="ticketDetailModalLabel">
                                        <i class="fas fa-ticket-alt me-2"></i>Ticket Details
                                    </h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"
                                        aria-label="Close"></button>
                                </div>
                                <div class="modal-body">
                                    <div class="row g-3">
                                        <!-- Ticket Information -->
                                        <div class="col-12">
                                            <h6 class="text-muted text-uppercase small mb-2">Ticket Information</h6>
                                            <div class="card bg-light">
                                                <div class="card-body">
                                                    <div class="row">
                                                        <div class="col-md-6 mb-2">
                                                            <strong>Ticket Number:</strong>
                                                            <div class="text-primary fw-bold" id="modal-ticket-number">-
                                                            </div>
                                                        </div>
                                                        <div class="col-md-6 mb-2">
                                                            <strong>Status:</strong>
                                                            <div id="modal-status">-</div>
                                                        </div>
                                                        <div class="col-md-6 mb-2">
                                                            <strong>Payment Status:</strong>
                                                            <div id="modal-payment-status">-</div>
                                                        </div>
                                                        <div class="col-md-6 mb-2">
                                                            <strong>Price:</strong>
                                                            <div class="fw-bold" id="modal-price">-</div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Passenger Information -->
                                        <div class="col-12">
                                            <h6 class="text-muted text-uppercase small mb-2">Passenger Information</h6>
                                            <div class="card">
                                                <div class="card-body">
                                                    <div class="row">
                                                        <div class="col-md-6 mb-2">
                                                            <strong>Name:</strong>
                                                            <div id="modal-passenger-name">-</div>
                                                        </div>
                                                        <div class="col-md-6 mb-2">
                                                            <strong>Email:</strong>
                                                            <div id="modal-passenger-email">-</div>
                                                        </div>
                                                        <div class="col-md-6 mb-2">
                                                            <strong>Phone:</strong>
                                                            <div id="modal-passenger-phone">-</div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Route Information -->
                                        <div class="col-12">
                                            <h6 class="text-muted text-uppercase small mb-2">Route Information</h6>
                                            <div class="card">
                                                <div class="card-body">
                                                    <div class="row">
                                                        <div class="col-md-6 mb-2">
                                                            <strong>Route:</strong>
                                                            <div id="modal-route-name">-</div>
                                                        </div>
                                                        <div class="col-md-6 mb-2">
                                                            <strong>Distance:</strong>
                                                            <div id="modal-route-distance">-</div>
                                                        </div>
                                                        <div class="col-12 mb-2">
                                                            <strong>Journey:</strong>
                                                            <div class="fw-semibold" id="modal-journey">-</div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Station Information -->
                                        <div class="col-12">
                                            <h6 class="text-muted text-uppercase small mb-2">Station Information</h6>
                                            <div class="card">
                                                <div class="card-body">
                                                    <div class="row">
                                                        <div class="col-md-6 mb-3">
                                                            <strong class="d-block mb-2">
                                                                <i
                                                                    class="fas fa-map-marker-alt text-success me-1"></i>Boarding
                                                                Station
                                                            </strong>
                                                            <div id="modal-boarding-station" class="fw-semibold">-</div>
                                                            <small class="text-muted" id="modal-boarding-city">-</small>
                                                        </div>
                                                        <div class="col-md-6 mb-3">
                                                            <strong class="d-block mb-2">
                                                                <i
                                                                    class="fas fa-map-marker-alt text-danger me-1"></i>Drop-off
                                                                Station
                                                            </strong>
                                                            <div id="modal-dropoff-station" class="fw-semibold">-</div>
                                                            <small class="text-muted" id="modal-dropoff-city">-</small>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Bus & Schedule Information -->
                                        <div class="col-12">
                                            <h6 class="text-muted text-uppercase small mb-2">Bus & Schedule</h6>
                                            <div class="card">
                                                <div class="card-body">
                                                    <div class="row">
                                                        <div class="col-md-6 mb-2">
                                                            <strong>Bus Number:</strong>
                                                            <div id="modal-bus-number">-</div>
                                                        </div>
                                                        <div class="col-md-6 mb-2">
                                                            <strong>Bus Type:</strong>
                                                            <div id="modal-bus-type">-</div>
                                                        </div>
                                                        <div class="col-md-6 mb-2">
                                                            <strong>Departure Date:</strong>
                                                            <div id="modal-departure-date">-</div>
                                                        </div>
                                                        <div class="col-md-6 mb-2">
                                                            <strong>Departure Time:</strong>
                                                            <div id="modal-departure-time">-</div>
                                                        </div>
                                                        <div class="col-md-6 mb-2">
                                                            <strong>Seat Number:</strong>
                                                            <div>
                                                                <span class="badge bg-primary">Seat <span
                                                                        id="modal-seat-number">-</span></span>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary"
                                        data-bs-dismiss="modal">Close</button>
                                    <a id="modal-edit-link" href="#" class="btn btn-primary">
                                        <i class="fas fa-edit me-1"></i>Edit Ticket
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <jsp:include page="/views/partials/footer.jsp" />
                <script>
                    document.addEventListener('DOMContentLoaded', function () {
                        // Auto-hide alerts after 5 seconds
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

                        const statusFilter = document.getElementById('statusFilter');
                        const paymentFilter = document.getElementById('paymentFilter');
                        if (statusFilter) statusFilter.addEventListener('change', () => statusFilter.form.submit());
                        if (paymentFilter) paymentFilter.addEventListener('change', () => paymentFilter.form.submit());

                        // Handle ticket detail modal
                        const ticketDetailModal = document.getElementById('ticketDetailModal');
                        if (ticketDetailModal) {
                            ticketDetailModal.addEventListener('show.bs.modal', function (event) {
                                const button = event.relatedTarget;
                                const ticketId = button.getAttribute('data-ticket-id');
                                const ticketNumber = button.getAttribute('data-ticket-number');
                                const passengerName = button.getAttribute('data-passenger-name');
                                const passengerEmail = button.getAttribute('data-passenger-email') || '-';
                                const passengerPhone = button.getAttribute('data-passenger-phone') || '-';
                                const routeName = button.getAttribute('data-route-name') || '-';
                                const departureCity = button.getAttribute('data-departure-city');
                                const destinationCity = button.getAttribute('data-destination-city');
                                const routeDistance = button.getAttribute('data-route-distance') || '-';
                                const boardingStation = button.getAttribute('data-boarding-station');
                                const boardingCity = button.getAttribute('data-boarding-city');
                                const dropoffStation = button.getAttribute('data-dropoff-station');
                                const dropoffCity = button.getAttribute('data-dropoff-city');
                                const busNumber = button.getAttribute('data-bus-number');
                                const busType = button.getAttribute('data-bus-type');
                                const departureDate = button.getAttribute('data-departure-date');
                                const departureTime = button.getAttribute('data-departure-time');
                                const seatNumber = button.getAttribute('data-seat-number');
                                const price = button.getAttribute('data-price');
                                const status = button.getAttribute('data-status');
                                const paymentStatus = button.getAttribute('data-payment-status');

                                // Populate modal fields
                                document.getElementById('modal-ticket-number').textContent = '#' + ticketNumber;
                                document.getElementById('modal-passenger-name').textContent = passengerName || '-';
                                document.getElementById('modal-passenger-email').textContent = (passengerEmail && passengerEmail !== 'null' && passengerEmail !== '') ? passengerEmail : '-';
                                document.getElementById('modal-passenger-phone').textContent = (passengerPhone && passengerPhone !== 'null' && passengerPhone !== '') ? passengerPhone : '-';
                                document.getElementById('modal-route-name').textContent = (routeName && routeName !== 'null') ? routeName : '-';
                                document.getElementById('modal-route-distance').textContent = (routeDistance && routeDistance !== '-' && routeDistance !== 'null') ? routeDistance + ' km' : '-';
                                document.getElementById('modal-journey').textContent = (departureCity && destinationCity) ? departureCity + ' → ' + destinationCity : '-';
                                document.getElementById('modal-boarding-station').textContent = (boardingStation && boardingStation !== 'N/A') ? boardingStation : '-';
                                const boardingCityEl = document.getElementById('modal-boarding-city');
                                if (boardingCity && boardingCity !== 'N/A' && boardingCity !== 'null') {
                                    boardingCityEl.textContent = boardingCity;
                                    boardingCityEl.style.display = '';
                                } else {
                                    boardingCityEl.style.display = 'none';
                                }
                                document.getElementById('modal-dropoff-station').textContent = (dropoffStation && dropoffStation !== 'N/A') ? dropoffStation : '-';
                                const dropoffCityEl = document.getElementById('modal-dropoff-city');
                                if (dropoffCity && dropoffCity !== 'N/A' && dropoffCity !== 'null') {
                                    dropoffCityEl.textContent = dropoffCity;
                                    dropoffCityEl.style.display = '';
                                } else {
                                    dropoffCityEl.style.display = 'none';
                                }
                                document.getElementById('modal-bus-number').textContent = busNumber || '-';
                                document.getElementById('modal-bus-type').textContent = busType || '-';
                                document.getElementById('modal-departure-date').textContent = departureDate || '-';
                                document.getElementById('modal-departure-time').textContent = departureTime || '-';
                                document.getElementById('modal-seat-number').textContent = seatNumber || '-';
                                document.getElementById('modal-price').textContent = (price || '0') + ' ₫';

                                // Set status badge
                                const statusBadge = document.getElementById('modal-status');
                                statusBadge.innerHTML = '';
                                const statusClass = status === 'CONFIRMED' ? 'status-confirmed' :
                                    status === 'PENDING' ? 'status-pending' : 'status-cancelled';
                                statusBadge.innerHTML = '<span class="status-badge ' + statusClass + '">' + status + '</span>';

                                // Set payment status badge
                                const paymentBadge = document.getElementById('modal-payment-status');
                                paymentBadge.innerHTML = '';
                                const paymentClass = paymentStatus === 'PAID' ? 'payment-paid' :
                                    paymentStatus === 'PENDING' ? 'payment-pending' : 'payment-cancelled';
                                paymentBadge.innerHTML = '<span class="payment-badge ' + paymentClass + '">' + paymentStatus + '</span>';

                                // Set edit link
                                const editLink = document.getElementById('modal-edit-link');
                                editLink.href = '${pageContext.request.contextPath}/admin/tickets/edit?id=' + ticketId;
                            });
                        }
                    });
                </script>
            </body>

            </html>