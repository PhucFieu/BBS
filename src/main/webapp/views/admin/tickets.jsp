<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <jsp:include page="/views/partials/head.jsp">
                    <jsp:param name="title" value="Ticket Management - Admin Panel" />
                </jsp:include>
                <link href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css" rel="stylesheet">
                <style>
                    .ticket-card {
                        transition: transform 0.2s;
                        border: none;
                        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.08);
                    }

                    .ticket-card:hover {
                        transform: translateY(-2px);
                        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.13);
                    }

                    .status-badge {
                        font-size: 0.9rem;
                    }

                    .search-form {
                        background: #f8f9fa;
                        padding: 20px;
                        border-radius: 8px;
                        margin-bottom: 20px;
                    }

                    .price-info {
                        font-weight: bold;
                        color: #66bb6a;
                        font-size: 1.1rem;
                    }

                    .seat-info {
                        background-color: #e9ecef;
                        padding: 0.25em 0.5em;
                        border-radius: 4px;
                        font-family: monospace;
                        font-weight: bold;
                    }

                    .ticket-number {
                        font-family: monospace;
                        font-weight: bold;
                        color: #495057;
                    }

                    .stats-card {
                        background: white;
                        border-radius: 10px;
                        padding: 20px;
                        text-align: center;
                        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                        transition: transform 0.2s ease;
                        margin-bottom: 20px;
                    }

                    .stats-card:hover {
                        transform: translateY(-2px);
                        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
                    }

                    .stats-number {
                        font-size: 2.5rem;
                        font-weight: bold;
                        margin-bottom: 10px;
                    }

                    .stats-label {
                        font-size: 1rem;
                        color: #6c757d;
                        margin-bottom: 10px;
                    }

                    .bulk-actions {
                        display: flex;
                        gap: 0.5rem;
                        align-items: center;
                    }

                    /* export buttons removed */

                    .btn-action {
                        margin: 0 2px;
                    }

                    .dataTables_wrapper {
                        padding: 0;
                    }

                    .dataTables_filter input {
                        border: 2px solid #e9ecef;
                        border-radius: 8px;
                        padding: 0.5rem 1rem;
                    }

                    .dataTables_length select {
                        border: 2px solid #e9ecef;
                        border-radius: 8px;
                        padding: 0.5rem;
                    }

                    .dataTables_paginate .paginate_button {
                        border-radius: 8px;
                        margin: 0 2px;
                        padding: 0.5rem 1rem;
                        border: 1px solid #e9ecef;
                        background: white;
                        color: #495057;
                        transition: all 0.3s ease;
                    }

                    .dataTables_paginate .paginate_button:hover {
                        background: #66bb6a;
                        color: white;
                        border-color: #66bb6a;
                    }

                    .dataTables_paginate .paginate_button.current {
                        background: #66bb6a;
                        color: white;
                        border-color: #66bb6a;
                    }
                </style>
            </head>

            <body>
                <%@ include file="/views/partials/admin-header.jsp" %>

                    <div class="container mt-4">
                        <!-- Header -->
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h2><i class="fas fa-ticket-alt me-2"></i>Ticket Management</h2>
                            <a href="${pageContext.request.contextPath}/admin/tickets/add" class="btn btn-primary">
                                <i class="fas fa-plus me-1"></i>Create Ticket
                            </a>
                        </div>

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

                        <!-- Statistics Cards -->
                        <div class="row mb-4">
                            <div class="col-lg-3 col-md-6 mb-3">
                                <div class="stats-card">
                                    <div class="stats-number text-primary">${tickets.size()}</div>
                                    <div class="stats-label">Total Tickets</div>
                                    <div class="mt-2"><i class="fas fa-ticket-alt fa-2x text-primary opacity-50"></i>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-3 col-md-6 mb-3">
                                <div class="stats-card">
                                    <div class="stats-number text-success">
                                        <c:set var="confirmedCount" value="0" />
                                        <c:forEach var="ticket" items="${tickets}">
                                            <c:if test="${ticket.status == 'CONFIRMED'}">
                                                <c:set var="confirmedCount" value="${confirmedCount + 1}" />
                                            </c:if>
                                        </c:forEach>
                                        ${confirmedCount}
                                    </div>
                                    <div class="stats-label">Confirmed</div>
                                    <div class="mt-2"><i class="fas fa-check-circle fa-2x text-success opacity-50"></i>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-3 col-md-6 mb-3">
                                <div class="stats-card">
                                    <div class="stats-number text-warning">
                                        <c:set var="pendingCount" value="0" />
                                        <c:forEach var="ticket" items="${tickets}">
                                            <c:if test="${ticket.status == 'PENDING'}">
                                                <c:set var="pendingCount" value="${pendingCount + 1}" />
                                            </c:if>
                                        </c:forEach>
                                        ${pendingCount}
                                    </div>
                                    <div class="stats-label">Pending</div>
                                    <div class="mt-2"><i class="fas fa-clock fa-2x text-warning opacity-50"></i></div>
                                </div>
                            </div>
                            <div class="col-lg-3 col-md-6 mb-3">
                                <div class="stats-card">
                                    <div class="stats-number text-danger">
                                        <c:set var="cancelledCount" value="0" />
                                        <c:forEach var="ticket" items="${tickets}">
                                            <c:if test="${ticket.status == 'CANCELLED'}">
                                                <c:set var="cancelledCount" value="${cancelledCount + 1}" />
                                            </c:if>
                                        </c:forEach>
                                        ${cancelledCount}
                                    </div>
                                    <div class="stats-label">Cancelled</div>
                                    <div class="mt-2"><i class="fas fa-times-circle fa-2x text-danger opacity-50"></i>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Search Form -->
                        <div class="search-form">
                            <form action="${pageContext.request.contextPath}/admin/tickets" method="get"
                                class="row g-3">
                                <div class="col-md-3">
                                    <label for="searchTerm" class="form-label">Search</label>
                                    <input type="text" class="form-control" id="searchTerm" name="searchTerm"
                                        value="${searchTerm}" placeholder="Ticket number, passenger name, phone...">
                                </div>
                                <div class="col-md-2">
                                    <label for="statusFilter" class="form-label">Status</label>
                                    <select class="form-select" id="statusFilter" name="status">
                                        <option value="">All Status</option>
                                        <option value="CONFIRMED" ${statusFilter=='CONFIRMED' ? 'selected' : '' }>
                                            Confirmed</option>
                                        <option value="PENDING" ${statusFilter=='PENDING' ? 'selected' : '' }>Pending
                                        </option>
                                        <option value="CANCELLED" ${statusFilter=='CANCELLED' ? 'selected' : '' }>
                                            Cancelled</option>
                                    </select>
                                </div>
                                <div class="col-md-2">
                                    <label for="paymentFilter" class="form-label">Payment</label>
                                    <select class="form-select" id="paymentFilter" name="paymentStatus">
                                        <option value="">All</option>
                                        <option value="PAID" ${paymentFilter=='PAID' ? 'selected' : '' }>Paid</option>
                                        <option value="PENDING" ${paymentFilter=='PENDING' ? 'selected' : '' }>Pending
                                        </option>
                                        <option value="CANCELLED" ${paymentFilter=='CANCELLED' ? 'selected' : '' }>
                                            Cancelled</option>
                                    </select>
                                </div>
                                <div class="col-md-2">
                                    <label for="dateFrom" class="form-label">From Date</label>
                                    <input type="date" class="form-control" id="dateFrom" name="dateFrom"
                                        value="${dateFrom}">
                                </div>
                                <div class="col-md-2">
                                    <label for="dateTo" class="form-label">To Date</label>
                                    <input type="date" class="form-control" id="dateTo" name="dateTo" value="${dateTo}">
                                </div>
                                <div class="col-md-1 d-flex align-items-end">
                                    <button type="submit" class="btn btn-outline-primary me-2">
                                        <i class="fas fa-search me-1"></i>Search
                                    </button>
                                </div>
                            </form>
                            <div class="row mt-3">
                                <div class="col-md-6">
                                    <a href="${pageContext.request.contextPath}/admin/tickets"
                                        class="btn btn-outline-secondary me-2">
                                        <i class="fas fa-refresh me-1"></i>Refresh
                                    </a>
                                </div>
                                <div class="col-md-6 text-end"></div>
                            </div>
                        </div>

                        <!-- Tickets Display -->
                        <c:choose>
                            <c:when test="${empty tickets}">
                                <div class="text-center py-5">
                                    <i class="fas fa-ticket-alt fa-3x text-muted mb-3"></i>
                                    <h5 class="text-muted">No tickets found</h5>
                                    <p class="text-muted">Add the first ticket to get started</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <!-- Table View -->
                                <div class="card">
                                    <div class="card-header">
                                        <div class="d-flex justify-content-between align-items-center">
                                            <h5 class="mb-0"><i class="fas fa-list me-2"></i>Ticket List</h5>
                                            <div class="bulk-actions">
                                                <select class="form-select me-2" id="bulkAction" style="width: auto;">
                                                    <option value="">Bulk Actions</option>
                                                    <option value="confirm">Confirm Tickets</option>
                                                    <option value="cancel">Cancel Tickets</option>
                                                    <option value="delete">Delete Tickets</option>
                                                </select>
                                                <button type="button" class="btn btn-primary"
                                                    onclick="executeBulkAction()">
                                                    <i class="fas fa-check me-1"></i>Execute
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="card-body p-0">
                                        <div class="table-responsive">
                                            <table class="table table-hover mb-0" id="ticketsTable">
                                                <thead class="table-dark">
                                                    <tr>
                                                        <th>
                                                            <input type="checkbox" id="selectAll"
                                                                class="form-check-input">
                                                        </th>
                                                        <th>Ticket #</th>
                                                        <th>Passenger</th>
                                                        <th>Route</th>
                                                        <th>Boarding</th>
                                                        <th>Drop-off</th>
                                                        <th>Bus</th>
                                                        <th>Departure</th>
                                                        <th>Seat</th>
                                                        <th>Price</th>
                                                        <th>Status</th>
                                                        <th>Payment</th>
                                                        <th>Actions</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach var="ticket" items="${tickets}">
                                                        <tr>
                                                            <td>
                                                                <input type="checkbox"
                                                                    class="form-check-input ticket-checkbox"
                                                                    value="${ticket.ticketId}">
                                                            </td>
                                                            <td>
                                                                <span
                                                                    class="ticket-number">#${ticket.ticketNumber}</span>
                                                            </td>
                                                            <td>
                                                                <div>
                                                                    <div class="fw-bold">${ticket.userName}</div>
                                                                    <small
                                                                        class="text-muted">${ticket.userEmail}</small>
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <div>
                                                                    <div class="fw-bold">${ticket.departureCity} →
                                                                        ${ticket.destinationCity}</div>
                                                                    <small
                                                                        class="text-muted">${ticket.routeName}</small>
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <div>
                                                                    <div class="fw-bold">${ticket.boardingStationName}</div>
                                                                    <small class="text-muted">${ticket.boardingCity}</small>
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <div>
                                                                    <div class="fw-bold">${ticket.alightingStationName}</div>
                                                                    <small class="text-muted">${ticket.alightingCity}</small>
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <div>
                                                                    <div class="fw-bold">${ticket.busNumber}</div>
                                                                    <small class="text-muted">Seat
                                                                        ${ticket.seatNumber}</small>
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <div>
                                                                    <div class="fw-bold">
                                                                        <c:choose>
                                                                            <c:when
                                                                                test="${ticket.departureDate != null}">
                                                                                ${ticket.departureDate}
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <span class="text-muted">N/A</span>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </div>
                                                                    <small class="text-muted">
                                                                        <c:choose>
                                                                            <c:when
                                                                                test="${ticket.departureTime != null}">
                                                                                ${ticket.departureTime}
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                N/A
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </small>
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <span class="seat-info">${ticket.seatNumber}</span>
                                                            </td>
                                                            <td>
                                                                <span class="price-info">
                                                                    <c:choose>
                                                                        <c:when test="${ticket.ticketPrice != null}">
                                                                            <fmt:formatNumber
                                                                                value="${ticket.ticketPrice}"
                                                                                type="currency" currencySymbol="₫"
                                                                                maxFractionDigits="0" />
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span class="text-muted">N/A</span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </span>
                                                            </td>
                                                            <td>
                                                                <span
                                                                    class="badge ${ticket.status == 'CONFIRMED' ? 'bg-success' : ticket.status == 'PENDING' ? 'bg-warning' : 'bg-danger'} status-badge">
                                                                    ${ticket.status}
                                                                </span>
                                                            </td>
                                                            <td>
                                                                <span
                                                                    class="badge ${ticket.paymentStatus == 'PAID' ? 'bg-success' : ticket.paymentStatus == 'PENDING' ? 'bg-warning' : 'bg-danger'} status-badge">
                                                                    ${ticket.paymentStatus}
                                                                </span>
                                                            </td>
                                                            <td>
                                                                <div class="d-flex gap-1">
                                                                    <a href="${pageContext.request.contextPath}/tickets/${ticket.ticketId}"
                                                                        class="btn btn-sm btn-info btn-action"
                                                                        title="View Detail">
                                                                        <i class="fas fa-eye"></i>
                                                                    </a>
                                                                    <a href="${pageContext.request.contextPath}/admin/tickets/edit?id=${ticket.ticketId}"
                                                                        class="btn btn-sm btn-warning btn-action"
                                                                        title="Edit">
                                                                        <i class="fas fa-edit"></i>
                                                                    </a>

                                                                    <a href="${pageContext.request.contextPath}/admin/tickets/delete?id=${ticket.ticketId}"
                                                                        class="btn btn-sm btn-danger btn-action"
                                                                        title="Delete"
                                                                        onclick="return confirm('Are you sure you want to delete this ticket?')">
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
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <%@ include file="/views/partials/footer.jsp" %>

                        <!-- DataTables scripts (jQuery is already loaded in footer.jsp) -->
                        <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
                        <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
                        <script>
                            $(document).ready(function () {
                                // Initialize DataTable
                                $('#ticketsTable').DataTable({
                                    "pageLength": 25,
                                    "order": [[1, "desc"]],
                                    "columnDefs": [
                                        { "orderable": false, "targets": [0, 12] }
                                    ]
                                });

                                // Select all functionality
                                $('#selectAll').change(function () {
                                    $('.ticket-checkbox').prop('checked', this.checked);
                                });

                                $('.ticket-checkbox').change(function () {
                                    if (!this.checked) {
                                        $('#selectAll').prop('checked', false);
                                    }
                                    if ($('.ticket-checkbox:checked').length === $('.ticket-checkbox').length) {
                                        $('#selectAll').prop('checked', true);
                                    }
                                });

                                // Auto-submit filter form on change
                                $('#statusFilter, #paymentFilter').change(function () {
                                    $('form').submit();
                                });
                            });

                            function executeBulkAction() {
                                const selectedTickets = $('.ticket-checkbox:checked');
                                const action = $('#bulkAction').val();

                                if (selectedTickets.length === 0) {
                                    alert('Please select at least one ticket to perform the action');
                                    return;
                                }

                                if (!action) {
                                    alert('Please select an action to perform');
                                    return;
                                }

                                const ticketIds = Array.from(selectedTickets).map(cb => cb.value);
                                const actionText = {
                                    'confirm': 'confirm',
                                    'cancel': 'cancel',
                                    'delete': 'delete'
                                };

                                if (confirm(`Are you sure you want to ${actionText[action]} ${selectedTickets.length} selected tickets?`)) {
                                    // Create form and submit
                                    const form = document.createElement('form');
                                    form.method = 'POST';
                                    form.action = '${pageContext.request.contextPath}/admin/tickets/bulk-action';

                                    const actionInput = document.createElement('input');
                                    actionInput.type = 'hidden';
                                    actionInput.name = 'action';
                                    actionInput.value = action;
                                    form.appendChild(actionInput);

                                    ticketIds.forEach(id => {
                                        const input = document.createElement('input');
                                        input.type = 'hidden';
                                        input.name = 'ticketIds';
                                        input.value = id;
                                        form.appendChild(input);
                                    });

                                    document.body.appendChild(form);
                                    form.submit();
                                }
                            }

                            // export removed
                        </script>
            </body>

            </html>