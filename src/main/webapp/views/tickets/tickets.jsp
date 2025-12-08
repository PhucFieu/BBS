<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
                <c:if test="${empty sessionScope.user}">
                    <script>
                        window.location.href = '${pageContext.request.contextPath}/auth/login?error=You need to login to view your tickets';
                    </script>
                </c:if>
                <c:set var="role" value="${sessionScope.role}" />

                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <jsp:include page="/views/partials/head.jsp">
                        <jsp:param name="title" value="Ticket Management - Bus Booking System" />
                    </jsp:include>
                    <style>
                        .tickets-page {
                            background-color: #f5f7fb;
                            min-height: 100vh;
                        }

                        .tickets-container {
                            max-width: 1280px;
                        }

                        .page-header {
                            background: #ffffff;
                            border-radius: 16px;
                            padding: 28px;
                            box-shadow: 0 14px 45px rgba(15, 23, 42, 0.08);
                            display: flex;
                            flex-wrap: wrap;
                            align-items: center;
                            justify-content: space-between;
                            gap: 1.5rem;
                        }

                        .page-header .left-side {
                            display: flex;
                            flex-direction: column;
                            gap: 0.35rem;
                        }

                        .icon-circle {
                            width: 56px;
                            height: 56px;
                            border-radius: 16px;
                            display: grid;
                            place-items: center;
                            background: linear-gradient(135deg, #66bb6a, #4caf50);
                            color: #ffffff;
                            font-size: 1.55rem;
                            box-shadow: 0 12px 30px rgba(102, 187, 106, 0.25);
                        }

                        .page-title {
                            font-size: 2rem;
                            font-weight: 700;
                            color: #111827;
                            margin-bottom: 0;
                        }

                        .page-subtitle {
                            color: #6b7280;
                            font-size: 0.95rem;
                        }

                        .page-actions .btn {
                            min-width: 160px;
                            box-shadow: 0 10px 30px rgba(102, 187, 106, 0.2);
                            border-radius: 12px;
                        }

                        .filter-card,
                        .table-card {
                            border-radius: 16px;
                            background: #ffffff;
                            box-shadow: 0 14px 45px rgba(15, 23, 42, 0.06);
                            border: none;
                        }

                        .filter-card .card-body {
                            padding: 26px;
                        }

                        .filter-card label {
                            font-weight: 600;
                            color: #374151;
                            font-size: 0.9rem;
                            margin-bottom: 0.35rem;
                        }

                        .input-icon {
                            position: relative;
                        }

                        .input-icon .icon {
                            position: absolute;
                            top: 50%;
                            left: 14px;
                            transform: translateY(-50%);
                            color: #9ca3af;
                            font-size: 0.95rem;
                        }

                        .input-icon .form-control {
                            padding-left: 2.6rem;
                        }

                        .filter-card .form-control,
                        .filter-card .form-select {
                            border-radius: 12px;
                            border: 1px solid #d1d5db;
                            font-size: 0.95rem;
                            padding: 0.6rem 0.75rem;
                            transition: border-color 0.2s ease, box-shadow 0.2s ease;
                        }

                        .filter-card .form-control:focus,
                        .filter-card .form-select:focus {
                            border-color: #66bb6a;
                            box-shadow: 0 0 0 0.15rem rgba(102, 187, 106, 0.18);
                        }

                        .ticket-card {
                            transition: transform 0.2s ease, box-shadow 0.2s ease;
                            border: none;
                            box-shadow: 0 12px 34px rgba(15, 23, 42, 0.08);
                            border-radius: 16px;
                        }

                        .ticket-card:hover {
                            transform: translateY(-4px);
                            box-shadow: 0 16px 42px rgba(15, 23, 42, 0.12);
                        }

                        .ticket-card .card-header {
                            border-top-left-radius: 16px;
                            border-top-right-radius: 16px;
                            background: linear-gradient(135deg, #66bb6a, #4caf50);
                        }

                        .ticket-card .card-body,
                        .ticket-card .card-footer {
                            word-break: break-word;
                            white-space: normal;
                            padding: 1.25rem 1.5rem;
                        }

                        .ticket-number {
                            font-family: 'Fira Code', monospace;
                            font-weight: 600;
                            letter-spacing: 0.02em;
                        }

                        .seat-info {
                            background-color: rgba(79, 70, 229, 0.12);
                            padding: 0.3em 0.65em;
                            border-radius: 8px;
                            font-family: 'Fira Code', monospace;
                            font-weight: 600;
                            color: #4f46e5;
                        }

                        .price-info {
                            font-weight: 700;
                            color: #047857;
                            font-size: 1.15rem;
                        }

                        .status-badge {
                            font-size: 0.9rem;
                            font-weight: 600;
                            padding: 0.35rem 0.8rem;
                            border-radius: 999px;
                        }

                        .status-badge.bg-warning,
                        .status-badge.bg-warning.text-dark {
                            color: #92400e !important;
                            background-color: rgba(251, 191, 36, 0.25) !important;
                        }

                        .table-card .card-header {
                            padding: 24px 28px;
                            border-bottom: 1px solid #edf0f7;
                            background: transparent;
                        }

                        .table-toolbar {
                            padding: 0 28px 22px;
                            display: flex;
                            justify-content: space-between;
                            align-items: center;
                            gap: 1.25rem;
                            flex-wrap: wrap;
                        }

                        .table-toolbar .form-control,
                        .table-toolbar .form-select {
                            border-radius: 12px;
                            border-color: #d1d5db;
                        }

                        .table-toolbar .form-control:focus,
                        .table-toolbar .form-select:focus {
                            border-color: #66bb6a;
                            box-shadow: 0 0 0 0.15rem rgba(102, 187, 106, 0.18);
                        }

                        .table-card .table {
                            margin-bottom: 0;
                            border-color: #f1f3f8;
                        }

                        .table-card .table thead th {
                            text-transform: uppercase;
                            font-size: 0.72rem;
                            letter-spacing: 0.06em;
                            color: #6b7280;
                            background: #f9fafb;
                            border-bottom: none;
                            padding-top: 0.85rem;
                            padding-bottom: 0.85rem;
                        }

                        .table-card .table tbody td {
                            vertical-align: middle;
                            padding: 1rem 0.85rem;
                            color: #1f2937;
                            font-size: 0.95rem;
                        }

                        .table-card .table tbody tr:hover {
                            background: rgba(102, 187, 106, 0.05);
                        }

                        .text-subtle {
                            color: #6b7280 !important;
                            font-size: 0.82rem;
                        }

                        .table-meta {
                            display: block;
                            font-size: 0.78rem;
                            color: #9ca3af;
                        }

                        .status-pill {
                            padding: 0.35rem 0.85rem;
                            border-radius: 999px;
                            font-weight: 600;
                            font-size: 0.82rem;
                            display: inline-flex;
                            align-items: center;
                            gap: 0.35rem;
                        }

                        .status-pill.confirmed {
                            background-color: rgba(16, 185, 129, 0.12);
                            color: #047857;
                        }

                        .status-pill.pending {
                            background-color: rgba(251, 191, 36, 0.2);
                            color: #92400e;
                        }

                        .status-pill.cancelled {
                            background-color: rgba(248, 113, 113, 0.16);
                            color: #b91c1c;
                        }

                        .status-pill.default {
                            background-color: rgba(148, 163, 184, 0.16);
                            color: #475569;
                        }

                        .actions-cell {
                            white-space: nowrap;
                            width: 1%;
                            text-align: right;
                        }

                        .btn-action {
                            margin-right: 0.35rem;
                            border-radius: 10px;
                        }

                        .actions-cell .btn:last-child,
                        .btn-action:last-child {
                            margin-right: 0;
                        }

                        .table-responsive {
                            border-bottom-left-radius: 16px;
                            border-bottom-right-radius: 16px;
                        }

                        .table-responsive::-webkit-scrollbar {
                            height: 8px;
                        }

                        .table-responsive::-webkit-scrollbar-thumb {
                            background: rgba(148, 163, 184, 0.45);
                            border-radius: 999px;
                        }

                        .table-responsive::-webkit-scrollbar-track {
                            background: transparent;
                        }

                        .summary-text {
                            padding: 20px 28px;
                            color: #6b7280;
                            font-size: 0.9rem;
                        }

                        .table-footer-nav {
                            padding: 0 28px 26px;
                            display: flex;
                            justify-content: flex-end;
                        }

                        .table-footer-nav .pagination {
                            margin-bottom: 0;
                        }

                        .modal-body dl {
                            margin-bottom: 0;
                        }

                        .modal-body dt {
                            color: #6c757d;
                            font-weight: 600;
                        }

                        @media (max-width: 1199.98px) {
                            .page-header {
                                padding: 24px;
                            }

                            .page-title {
                                font-size: 1.8rem;
                            }
                        }

                        @media (max-width: 991.98px) {
                            .filter-card .card-body {
                                padding: 22px;
                            }

                            .table-toolbar {
                                flex-direction: column;
                                align-items: stretch;
                            }

                            .actions-cell {
                                text-align: left;
                            }
                        }

                        @media (max-width: 767.98px) {
                            .table-card .table {
                                min-width: 1100px;
                            }

                            .table-footer-nav {
                                justify-content: center;
                            }
                        }
                    </style>
                </head>

                <body class="tickets-page">
                    <c:choose>
                        <c:when test="${role == 'ADMIN'}">
                            <%@ include file="/views/partials/admin-header.jsp" %>
                        </c:when>
                        <c:otherwise>
                            <%@ include file="/views/partials/user-header.jsp" %>
                        </c:otherwise>
                    </c:choose>

                    <div class="container-xxl tickets-container py-4">
                        <div class="page-header mb-4">
                            <div class="d-flex align-items-center gap-3">
                                <div class="icon-circle">
                                    <i class="fas fa-ticket-alt"></i>
                                </div>
                                <div class="left-side">
                                    <h1 class="page-title">
                                        <c:choose>
                                            <c:when test="${role == 'ADMIN' || role == 'DRIVER'}">Ticket Management
                                            </c:when>
                                            <c:otherwise>My Tickets</c:otherwise>
                                        </c:choose>
                                    </h1>
                                    <p class="page-subtitle mb-0">
                                        <c:choose>
                                            <c:when test="${role == 'ADMIN' || role == 'DRIVER'}">Quản lý vé, trạng thái
                                                thanh
                                                toán và hành trình của hành khách một cách trực quan.</c:when>
                                            <c:otherwise>Theo dõi lịch trình và thông tin vé cho mỗi chuyến đi của bạn.
                                            </c:otherwise>
                                        </c:choose>
                                    </p>
                                </div>
                            </div>
                            <div class="page-actions">
                                <c:if test="${role == 'ADMIN' || role == 'DRIVER'}">
                                    <span class="badge bg-secondary rounded-pill">
                                        Vé được tạo tự động khi khách đặt chỗ
                                    </span>
                                </c:if>
                            </div>
                        </div>

                        <!-- Messages -->
                        <c:if test="${not empty param.message}">
                            <div class="alert alert-success shadow-sm border-0 rounded-3 alert-dismissible fade show"
                                role="alert">
                                <i class="fas fa-check-circle me-2"></i>${param.message}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>
                        <c:if test="${not empty param.error}">
                            <div class="alert alert-danger shadow-sm border-0 rounded-3 alert-dismissible fade show"
                                role="alert">
                                <i class="fas fa-exclamation-circle me-2"></i>${param.error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <!-- Search Form (only for admin/driver) -->
                        <c:if test="${role == 'ADMIN' || role == 'DRIVER'}">
                            <div class="card filter-card mb-4">
                                <div class="card-body">
                                    <form id="ticketFilterForm" class="row g-3 align-items-end">
                                        <div class="col-12 col-lg-4">
                                            <label for="filterKeyword" class="form-label">Search</label>
                                            <div class="input-icon">
                                                <span class="icon"><i class="fas fa-search"></i></span>
                                                <input type="text" class="form-control" id="filterKeyword"
                                                    name="keyword"
                                                    placeholder="Ticket number, passenger name, phone...">
                                            </div>
                                        </div>
                                        <div class="col-6 col-md-4 col-lg-2">
                                            <label for="filterStatus" class="form-label">Status</label>
                                            <select class="form-select" id="filterStatus" name="status">
                                                <option value="">All Status</option>
                                                <option value="CONFIRMED">Confirmed</option>
                                                <option value="PENDING">Pending</option>
                                                <option value="CANCELLED">Cancelled</option>
                                            </select>
                                        </div>
                                        <div class="col-6 col-md-4 col-lg-2">
                                            <label for="filterPayment" class="form-label">Payment</label>
                                            <select class="form-select" id="filterPayment" name="paymentStatus">
                                                <option value="">All</option>
                                                <option value="PAID">Paid</option>
                                                <option value="PENDING">Pending</option>
                                                <option value="FAILED">Failed</option>
                                            </select>
                                        </div>
                                        <div class="col-6 col-md-4 col-lg-2">
                                            <label for="filterFromDate" class="form-label">From Date</label>
                                            <input type="date" class="form-control" id="filterFromDate" name="fromDate">
                                        </div>
                                        <div class="col-6 col-md-4 col-lg-2">
                                            <label for="filterToDate" class="form-label">To Date</label>
                                            <input type="date" class="form-control" id="filterToDate" name="toDate">
                                        </div>
                                        <div class="col-12 col-lg-2 d-flex gap-2">
                                            <button type="submit" class="btn btn-primary flex-fill">
                                                <i class="fas fa-filter me-2"></i>Lọc
                                            </button>
                                            <button type="button" class="btn btn-outline-secondary flex-fill"
                                                id="filterResetBtn">
                                                <i class="fas fa-rotate-right me-2"></i>Reset
                                            </button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </c:if>

                        <!-- Tickets Display -->
                        <c:choose>
                            <c:when test="${empty tickets}">
                                <div class="text-center py-5">
                                    <i class="fas fa-ticket-alt fa-3x text-muted mb-3"></i>
                                    <h5 class="text-muted">
                                        <c:choose>
                                            <c:when test="${role == 'ADMIN' || role == 'DRIVER'}">No tickets found
                                            </c:when>
                                            <c:otherwise>You have no tickets yet</c:otherwise>
                                        </c:choose>
                                    </h5>
                                    <p class="text-muted">
                                        <c:choose>
                                            <c:when test="${role == 'ADMIN' || role == 'DRIVER'}">Add the first ticket
                                                to
                                                get
                                                started</c:when>
                                            <c:otherwise>Book a ticket to start your journey!</c:otherwise>
                                        </c:choose>
                                    </p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <!-- Grid View -->
                                <div class="row g-4" id="ticketsGrid">
                                    <c:forEach var="ticket" items="${tickets}">
                                        <div class="col-md-6 col-lg-4">
                                            <div class="card ticket-card h-100">
                                                <div class="card-header text-white"
                                                    style="background: linear-gradient(135deg, #66bb6a, #4caf50);">
                                                    <div class="d-flex justify-content-between align-items-center">
                                                        <h6 class="mb-0">
                                                            <i class="fas fa-ticket-alt me-2"></i>
                                                            <span class="ticket-number">${ticket.ticketNumber}</span>
                                                        </h6>
                                                        <span class="badge status-badge
                                        <c:choose>
                                            <c:when test=" ${ticket.status eq 'CONFIRMED' }">bg-success</c:when>
                                                            <c:when test="${ticket.status eq 'PENDING'}">bg-warning
                                                            </c:when>
                                                            <c:when test="${ticket.status eq 'CANCELLED'}">bg-danger
                                                            </c:when>
                                                            <c:otherwise>bg-secondary</c:otherwise>
                        </c:choose>
                        ">
                        <c:choose>
                            <c:when test="${ticket.status eq 'CONFIRMED'}">Confirmed</c:when>
                            <c:when test="${ticket.status eq 'PENDING'}">Pending</c:when>
                            <c:when test="${ticket.status eq 'CANCELLED'}">Cancelled</c:when>
                            <c:otherwise>${ticket.status}</c:otherwise>
                        </c:choose>
                        </span>
                    </div>
                    </div>
                    <div class="card-body">
                        <div class="mb-3"><strong>User:</strong> ${ticket.userName}</div>
                        <div class="mb-3"><strong>Route:</strong> ${ticket.routeName}</div>
                        <div class="mb-3"><strong>Bus:</strong> ${ticket.busNumber}</div>
                        <div class="mb-3"><strong>Seat:</strong> <span class="seat-info">${ticket.seatNumber}</span>
                        </div>
                        <div class="mb-3"><strong>Departure:</strong><br>
                            <i class="fas fa-calendar me-1"></i>
                            <fmt:formatDate value="${ticket.departureDateSql}" pattern="dd/MM/yyyy" />
                            <i class="fas fa-clock me-1"></i>
                            <fmt:formatDate value="${ticket.departureTimeSql}" pattern="HH:mm" />
                        </div>
                        <div class="mb-3"><strong>Ticket Price:</strong>
                            <div class="price-info">
                                <fmt:formatNumber value="${ticket.ticketPrice}" type="currency" currencySymbol="₫"
                                    maxFractionDigits="0" />
                            </div>
                        </div>
                        <div class="mb-3"><strong>Payment:</strong>
                            <span class="badge
                                        <c:choose>
                                            <c:when test=" ${ticket.paymentStatus eq 'PAID' }">bg-success</c:when>
                                <c:when test="${ticket.paymentStatus eq 'PENDING'}">bg-warning</c:when>
                                <c:otherwise>bg-secondary</c:otherwise>
                                </c:choose>
                                ">
                                <c:choose>
                                    <c:when test="${ticket.paymentStatus eq 'PAID'}">Paid</c:when>
                                    <c:when test="${ticket.paymentStatus eq 'PENDING'}">Pending Payment</c:when>
                                    <c:otherwise>${ticket.paymentStatus}</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                    </div>
                    <div class="card-footer bg-transparent">
                        <div class="d-flex justify-content-between">
                            <!-- Detail Modal Button -->
                            <button type="button" class="btn btn-sm btn-info btn-action" title="View Details"
                                data-bs-toggle="modal" data-bs-target="#ticketDetailModal"
                                data-ticketid="${ticket.ticketId}" data-ticketnumber="${ticket.ticketNumber}"
                                data-username="<c:out value='${ticket.userName}'/>"
                                data-passengername="<c:out value='${ticket.userName}'/>"
                                data-routename="<c:out value='${ticket.routeName}'/>"
                                data-busnumber="<c:out value='${ticket.busNumber}'/>"
                                data-seatnumber="${ticket.seatNumber}"
                                data-departuredate="<fmt:formatDate value='${ticket.departureDateSql}' pattern='dd/MM/yyyy'/>"
                                data-departuretime="<fmt:formatDate value='${ticket.departureTimeSql}' pattern='HH:mm'/>"
                                data-boardingstation="<c:out value='${ticket.boardingStationName}'/>"
                                data-boardingcity="<c:out value='${ticket.boardingCity}'/>"
                                data-dropoffstation="<c:out value='${ticket.alightingStationName}'/>"
                                data-dropoffcity="<c:out value='${ticket.alightingCity}'/>"
                                data-ticketprice="${ticket.ticketPrice}" data-status="${ticket.status}"
                                data-paymentstatus="${ticket.paymentStatus}">
                                <i class="fas fa-eye"></i>
                            </button>
                            <a href="${pageContext.request.contextPath}/tickets/${ticket.ticketId}"
                                class="btn btn-sm btn-secondary btn-action" title="Detail Page">
                                <i class="fas fa-external-link-alt"></i>
                            </a>
                            <c:if test="${role == 'ADMIN' || role == 'DRIVER'}">
                                <a href="${pageContext.request.contextPath}/tickets/edit?id=${ticket.ticketId}"
                                    class="btn btn-sm btn-warning btn-action" title="Edit">
                                    <i class="fas fa-edit"></i>
                                </a>
                                <button type="button" class="btn btn-sm btn-danger btn-action"
                                    data-ticketnumber="${ticket.ticketNumber}"
                                    onclick="confirmDelete('${ticket.ticketId}', this)" title="Cancel Ticket">
                                    <i class="fas fa-times"></i>
                                </button>
                            </c:if>
                        </div>
                    </div>
                    </div>
                    </div>
                    </c:forEach>
                    </div>

                    <!-- Table View (Hidden by default) -->
                    <div class="table-responsive d-none" id="ticketsTable">
                        <table class="table table-hover">
                            <thead class="table-dark">
                                <tr>
                                    <th>Ticket Number</th>
                                    <th>User</th>
                                    <th>Route</th>
                                    <th>Bus</th>
                                    <th>Seat</th>
                                    <th>Departure</th>
                                    <th>Ticket Price</th>
                                    <th>Status</th>
                                    <th>Payment</th>
                                    <th class="actions-cell">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="ticket" items="${tickets}">
                                    <tr>
                                        <td><span class="ticket-number">${ticket.ticketNumber}</span></td>
                                        <td><strong>${ticket.userName}</strong></td>
                                        <td>${ticket.routeName}</td>
                                        <td>${ticket.busNumber}</td>
                                        <td><span class="seat-info">${ticket.seatNumber}</span></td>
                                        <td>
                                            <div>
                                                <fmt:formatDate value="${ticket.departureDateSql}"
                                                    pattern="dd/MM/yyyy" />
                                            </div>
                                            <small>
                                                <fmt:formatDate value="${ticket.departureTimeSql}" pattern="HH:mm" />
                                            </small>
                                        </td>
                                        <td class="price-info">
                                            <fmt:formatNumber value="${ticket.ticketPrice}" type="currency"
                                                currencySymbol="₫" maxFractionDigits="0" />
                                        </td>
                                        <td>
                                            <span class="badge
                                        <c:choose>
                                            <c:when test=" ${ticket.status eq 'CONFIRMED' }">bg-success</c:when>
                                                <c:when test="${ticket.status eq 'PENDING'}">bg-warning</c:when>
                                                <c:when test="${ticket.status eq 'CANCELLED'}">bg-danger</c:when>
                                                <c:otherwise>bg-secondary</c:otherwise>
                                                </c:choose>
                                                ">
                                                <c:choose>
                                                    <c:when test="${ticket.status eq 'CONFIRMED'}">Confirmed</c:when>
                                                    <c:when test="${ticket.status eq 'PENDING'}">Pending</c:when>
                                                    <c:when test="${ticket.status eq 'CANCELLED'}">Cancelled</c:when>
                                                    <c:otherwise>${ticket.status}</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </td>
                                        <td>
                                            <span class="badge
                                        <c:choose>
                                            <c:when test=" ${ticket.paymentStatus eq 'PAID' }">bg-success</c:when>
                                                <c:when test="${ticket.paymentStatus eq 'PENDING'}">bg-warning</c:when>
                                                <c:otherwise>bg-secondary</c:otherwise>
                                                </c:choose>
                                                ">
                                                <c:choose>
                                                    <c:when test="${ticket.paymentStatus eq 'PAID'}">Paid</c:when>
                                                    <c:when test="${ticket.paymentStatus eq 'PENDING'}">Pending Payment
                                                    </c:when>
                                                    <c:otherwise>${ticket.paymentStatus}</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </td>
                                        <td class="actions-cell">
                                            <button type="button" class="btn btn-sm btn-info btn-action"
                                                title="View Details" data-bs-toggle="modal"
                                                data-bs-target="#ticketDetailModal" data-ticketid="${ticket.ticketId}"
                                                data-ticketnumber="${ticket.ticketNumber}"
                                                data-username="<c:out value='${ticket.userName}'/>"
                                                data-passengername="<c:out value='${ticket.userName}'/>"
                                                data-routename="<c:out value='${ticket.routeName}'/>"
                                                data-busnumber="<c:out value='${ticket.busNumber}'/>"
                                                data-seatnumber="${ticket.seatNumber}"
                                                data-departuredate="<fmt:formatDate value='${ticket.departureDateSql}' pattern='dd/MM/yyyy'/>"
                                                data-departuretime="<fmt:formatDate value='${ticket.departureTimeSql}' pattern='HH:mm'/>"
                                                data-boardingstation="<c:out value='${ticket.boardingStationName}'/>"
                                                data-boardingcity="<c:out value='${ticket.boardingCity}'/>"
                                                data-dropoffstation="<c:out value='${ticket.alightingStationName}'/>"
                                                data-dropoffcity="<c:out value='${ticket.alightingCity}'/>"
                                                data-ticketprice="${ticket.ticketPrice}" data-status="${ticket.status}"
                                                data-paymentstatus="${ticket.paymentStatus}">
                                                <i class="fas fa-eye"></i>
                                            </button>
                                            <a href="${pageContext.request.contextPath}/tickets/${ticket.ticketId}"
                                                class="btn btn-sm btn-secondary btn-action" title="Detail Page">
                                                <i class="fas fa-external-link-alt"></i>
                                            </a>
                                            <c:if test="${role == 'ADMIN' || role == 'DRIVER'}">
                                                <a href="${pageContext.request.contextPath}/tickets/edit?id=${ticket.ticketId}"
                                                    class="btn btn-sm btn-warning btn-action" title="Edit">
                                                    <i class="fas fa-edit"></i>
                                                </a>
                                                <button type="button" class="btn btn-sm btn-danger btn-action"
                                                    data-ticketnumber="${ticket.ticketNumber}"
                                                    onclick="confirmDelete('${ticket.ticketId}', this)"
                                                    title="Cancel Ticket">
                                                    <i class="fas fa-times"></i>
                                                </button>
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <!-- View Toggle -->
                    <div class="text-center mt-4">
                        <div class="btn-group" role="group">
                            <button type="button" class="btn btn-outline-primary active" onclick="switchView('grid')">
                                <i class="fas fa-th-large me-1"></i> Grid
                            </button>
                            <button type="button" class="btn btn-outline-primary" onclick="switchView('table')">
                                <i class="fas fa-table me-1"></i> Table
                            </button>
                        </div>
                    </div>
                    </c:otherwise>
                    </c:choose>
                    </div>

                    <!-- Ticket Detail Modal -->
                    <div class="modal fade" id="ticketDetailModal" tabindex="-1"
                        aria-labelledby="ticketDetailModalLabel" aria-hidden="true">
                        <div class="modal-dialog modal-lg">
                            <div class="modal-content">
                                <div class="modal-header text-white"
                                    style="background: linear-gradient(135deg, #66bb6a, #4caf50);">
                                    <h5 class="modal-title" id="ticketDetailModalLabel"><i
                                            class="fas fa-ticket-alt me-2"></i>Ticket Details
                                    </h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                </div>
                                <div class="modal-body">
                                    <dl class="row">
                                        <dt class="col-5">Ticket Number:</dt>
                                        <dd class="col-7" id="detailTicketNumber"></dd>
                                        <dt class="col-5">User:</dt>
                                        <dd class="col-7" id="detailUserName"></dd>
                                        <dt class="col-5">Passenger:</dt>
                                        <dd class="col-7" id="detailPassengerName"></dd>
                                        <dt class="col-5">Route:</dt>
                                        <dd class="col-7" id="detailRouteName"></dd>
                                        <dt class="col-5">Bus:</dt>
                                        <dd class="col-7" id="detailBusNumber"></dd>
                                        <dt class="col-5">Seat:</dt>
                                        <dd class="col-7" id="detailSeatNumber"></dd>
                                        <dt class="col-5">Departure:</dt>
                                        <dd class="col-7">
                                            <span id="detailDepartureDate"></span>
                                            <span id="detailDepartureTime"></span>
                                        </dd>
                                        <dt class="col-5">Boarding:</dt>
                                        <dd class="col-7" id="detailBoarding">
                                            <!-- filled by JS -->
                                        </dd>
                                        <dt class="col-5">Drop-off:</dt>
                                        <dd class="col-7" id="detailDropoff">
                                            <!-- filled by JS -->
                                        </dd>
                                        <dt class="col-5">Ticket Price:</dt>
                                        <dd class="col-7" id="detailTicketPrice"></dd>
                                        <dt class="col-5">Status:</dt>
                                        <dd class="col-7" id="detailStatus"></dd>
                                        <dt class="col-5">Payment:</dt>
                                        <dd class="col-7" id="detailPaymentStatus"></dd>
                                    </dl>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary"
                                        data-bs-dismiss="modal">Close</button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Delete Confirmation Modal -->
                    <div class="modal fade" id="deleteModal" tabindex="-1">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title">Confirm Ticket Cancellation</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                </div>
                                <div class="modal-body">
                                    <p>Are you sure you want to cancel ticket <strong
                                            id="ticketNumberToDelete"></strong>?
                                    </p>
                                    <p class="text-danger"><small>This action cannot be undone.</small></p>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary"
                                        data-bs-dismiss="modal">Cancel</button>
                                    <a href="#" id="confirmDeleteBtn" class="btn btn-danger">Cancel Ticket</a>
                                </div>
                            </div>
                        </div>
                    </div>

                    <%@ include file="/views/partials/footer.jsp" %>
                        <script>
                            function confirmDelete(ticketId, el) {
                                // Support calling with (ticketId, ticketNumber) for backward-compatibility
                                let ticketNumber = '';
                                if (el && typeof el.getAttribute === 'function') {
                                    ticketNumber = el.getAttribute('data-ticketnumber') || '';
                                } else if (typeof el === 'string') {
                                    ticketNumber = el;
                                }

                                document.getElementById('ticketNumberToDelete').textContent = ticketNumber;
                                document.getElementById('confirmDeleteBtn').href =
                                    '${pageContext.request.contextPath}/tickets/delete?id=' + ticketId;
                                new bootstrap.Modal(document.getElementById('deleteModal')).show();
                            }

                            function switchView(view) {
                                const gridView = document.getElementById('ticketsGrid');
                                const tableView = document.getElementById('ticketsTable');
                                const buttons = document.querySelectorAll('.btn-group .btn');
                                buttons.forEach(btn => btn.classList.remove('active'));
                                event.target.classList.add('active');
                                if (view === 'grid') {
                                    gridView.classList.remove('d-none');
                                    tableView.classList.add('d-none');
                                } else {
                                    gridView.classList.add('d-none');
                                    tableView.classList.remove('d-none');
                                }
                            }

                            // Populate ticket detail modal
                            document.addEventListener('DOMContentLoaded', function () {
                                var ticketDetailModal = document.getElementById('ticketDetailModal');
                                ticketDetailModal.addEventListener('show.bs.modal', function (event) {
                                    var button = event.relatedTarget;
                                    document.getElementById('detailTicketNumber').textContent = button.getAttribute('data-ticketnumber');
                                    document.getElementById('detailUserName').textContent = button.getAttribute('data-username') || '-';
                                    document.getElementById('detailPassengerName').textContent = button.getAttribute('data-passengername') || '-';
                                    document.getElementById('detailRouteName').textContent = button.getAttribute('data-routename');
                                    document.getElementById('detailBusNumber').textContent = button.getAttribute('data-busnumber');
                                    document.getElementById('detailSeatNumber').textContent = button.getAttribute('data-seatnumber');
                                    document.getElementById('detailDepartureDate').textContent = button.getAttribute('data-departuredate');
                                    document.getElementById('detailDepartureTime').textContent = ' ' + button.getAttribute('data-departuretime');
                                    document.getElementById('detailTicketPrice').textContent =
                                        Number(button.getAttribute('data-ticketprice')).toLocaleString('vi-VN') + ' ₫';

                                    // Boarding / Drop-off
                                    var bStation = button.getAttribute('data-boardingstation') || '';
                                    var bCity = button.getAttribute('data-boardingcity') || '';
                                    var bTime = '';
                                    var dStation = button.getAttribute('data-dropoffstation') || '';
                                    var dCity = button.getAttribute('data-dropoffcity') || '';
                                    var dTime = '';
                                    var boardingText = (bStation ? bStation : '-') + (bCity ? ' (' + bCity + ')' : '') + (bTime ? ' • ' + bTime : '');
                                    var dropoffText = (dStation ? dStation : '-') + (dCity ? ' (' + dCity + ')' : '') + (dTime ? ' • ' + dTime : '');
                                    document.getElementById('detailBoarding').textContent = boardingText;
                                    document.getElementById('detailDropoff').textContent = dropoffText;

                                    // Status
                                    var status = button.getAttribute('data-status');
                                    document.getElementById('detailStatus').innerHTML =
                                        status === 'CONFIRMED' ? '<span class="badge bg-success">Confirmed</span>' :
                                            status === 'PENDING' ? '<span class="badge bg-warning">Pending</span>' :
                                                status === 'CANCELLED' ? '<span class="badge bg-danger">Cancelled</span>' :
                                                    '<span class="badge bg-secondary">' + status + '</span>';

                                    // Payment status
                                    var paymentStatus = button.getAttribute('data-paymentstatus');
                                    document.getElementById('detailPaymentStatus').innerHTML =
                                        paymentStatus === 'PAID' ? '<span class="badge bg-success">Paid</span>' :
                                            paymentStatus === 'PENDING' ? '<span class="badge bg-warning">Pending Payment</span>' :
                                                '<span class="badge bg-secondary">' + paymentStatus + '</span>';
                                });
                            });
                        </script>

                        <script src="${pageContext.request.contextPath}/assets/js/validation.js"></script>
                </body>

                </html>