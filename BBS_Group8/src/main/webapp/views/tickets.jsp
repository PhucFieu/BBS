<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
                    <jsp:param name="title" value="Ticket Management - BusTicket System" />
                </jsp:include>
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
                        color: #28a745;
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
                </style>
            </head>

            <body>
                <c:choose>
                    <c:when test="${role == 'ADMIN'}">
                        <%@ include file="/views/partials/admin-header.jsp" %>
                    </c:when>
                    <c:otherwise>
                        <%@ include file="/views/partials/user-header.jsp" %>
                    </c:otherwise>
                </c:choose>

                <div class="container mt-4">
                    <!-- Header -->
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h2><i class="fas fa-ticket-alt me-2"></i>
                            <c:choose>
                                <c:when test="${role == 'ADMIN' || role == 'DRIVER'}">Ticket Management</c:when>
                                <c:otherwise>My Tickets</c:otherwise>
                            </c:choose>
                        </h2>
                        <c:if test="${role == 'ADMIN' || role == 'DRIVER'}">
                            <a href="${pageContext.request.contextPath}/tickets/add" class="btn btn-primary">
                                <i class="fas fa-plus me-1"></i>Add Ticket
                            </a>
                        </c:if>
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

                    <!-- Search Form (only for admin/driver) -->
                    <c:if test="${role == 'ADMIN' || role == 'DRIVER'}">
                        <div class="search-form">
                            <form action="${pageContext.request.contextPath}/tickets/search" method="get"
                                class="row g-3">
                                <div class="col-md-3">
                                    <label for="ticketNumber" class="form-label">Ticket Number</label>
                                    <input type="text" class="form-control" id="ticketNumber" name="ticketNumber"
                                        placeholder="Enter ticket number">
                                </div>
                                <div class="col-md-3">
                                    <label for="userName" class="form-label">User Name</label>
                                    <input type="text" class="form-control" id="userName" name="userName"
                                        placeholder="Enter user name">
                                </div>
                                <div class="col-md-3">
                                    <label for="status" class="form-label">Status</label>
                                    <select class="form-select" id="status" name="status">
                                        <option value="">All</option>
                                        <option value="CONFIRMED">Confirmed</option>
                                        <option value="PENDING">Pending</option>
                                        <option value="CANCELLED">Cancelled</option>
                                    </select>
                                </div>
                                <div class="col-md-3 d-flex align-items-end">
                                    <button type="submit" class="btn btn-outline-primary me-2">
                                        <i class="fas fa-search me-1"></i>Search
                                    </button>
                                    <a href="${pageContext.request.contextPath}/tickets"
                                        class="btn btn-outline-secondary">
                                        <i class="fas fa-refresh me-1"></i>Refresh
                                    </a>
                                </div>
                            </form>
                        </div>
                    </c:if>

                    <!-- Tickets Display -->
                    <c:choose>
                        <c:when test="${empty tickets}">
                            <div class="text-center py-5">
                                <i class="fas fa-ticket-alt fa-3x text-muted mb-3"></i>
                                <h5 class="text-muted">
                                    <c:choose>
                                        <c:when test="${role == 'ADMIN' || role == 'DRIVER'}">No tickets found</c:when>
                                        <c:otherwise>You have no tickets yet</c:otherwise>
                                    </c:choose>
                                </h5>
                                <p class="text-muted">
                                    <c:choose>
                                        <c:when test="${role == 'ADMIN' || role == 'DRIVER'}">Add the first ticket to
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
                                            <div class="card-header bg-primary text-white">
                                                <div class="d-flex justify-content-between align-items-center">
                                                    <h6 class="mb-0">
                                                        <i class="fas fa-ticket-alt me-2"></i>
                                                        <span class="ticket-number">${ticket.ticketNumber}</span>
                                                    </h6>
                                                    <span class="badge status-badge
                                        <c:choose>
                                            <c:when test=" ${ticket.status eq 'CONFIRMED' }">bg-success</c:when>
                                                        <c:when test="${ticket.status eq 'PENDING'}">bg-warning</c:when>
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
                    <div class="mb-3"><strong>Xe:</strong> ${ticket.busNumber}</div>
                    <div class="mb-3"><strong>Seat:</strong> <span class="seat-info">${ticket.seatNumber}</span></div>
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
                            data-busnumber="<c:out value='${ticket.busNumber}'/>" data-seatnumber="${ticket.seatNumber}"
                            data-departuredate="<fmt:formatDate value='${ticket.departureDateSql}' pattern='dd/MM/yyyy'/>"
                            data-departuretime="<fmt:formatDate value='${ticket.departureTimeSql}' pattern='HH:mm'/>"
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
                                onclick="confirmDelete(${ticket.ticketId}, '${ticket.ticketNumber}')"
                                title="Cancel Ticket">
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
                                <th>Người dùng</th>
                                <th>Tuyến xe</th>
                                <th>Xe</th>
                                <th>Ghế</th>
                                <th>Khởi hành</th>
                                <th>Giá vé</th>
                                <th>Status</th>
                                <th>Thanh toán</th>
                                <th>Actions</th>
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
                                            <fmt:formatDate value="${ticket.departureDateSql}" pattern="dd/MM/yyyy" />
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
                                    <td>
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
                                                onclick="confirmDelete(${ticket.ticketId}, '${ticket.ticketNumber}')"
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
                            <i class="fas fa-th-large me-1"></i> Ô
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
                <div class="modal fade" id="ticketDetailModal" tabindex="-1" aria-labelledby="ticketDetailModalLabel"
                    aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header bg-primary text-white">
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
                                    <dt class="col-5">Xe:</dt>
                                    <dd class="col-7" id="detailBusNumber"></dd>
                                    <dt class="col-5">Seat:</dt>
                                    <dd class="col-7" id="detailSeatNumber"></dd>
                                    <dt class="col-5">Departure:</dt>
                                    <dd class="col-7">
                                        <span id="detailDepartureDate"></span>
                                        <span id="detailDepartureTime"></span>
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
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
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
                                <p>Are you sure you want to cancel ticket <strong id="ticketNumberToDelete"></strong>?
                                </p>
                                <p class="text-danger"><small>This action cannot be undone.</small></p>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel
                                </button>
                                <a href="#" id="confirmDeleteBtn" class="btn btn-danger">Cancel Ticket</a>
                            </div>
                        </div>
                    </div>
                </div>

                <%@ include file="/views/partials/footer.jsp" %>
                    <script>
                        function confirmDelete(ticketId, ticketNumber) {
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

                                // Status
                                var status = button.getAttribute('data-status');
                                document.getElementById('detailStatus').innerHTML =
                                    status === 'CONFIRMED'
                                        ? '<span class="badge bg-success">Confirmed</span>'
                                        : status === 'PENDING'
                                            ? '<span class="badge bg-warning">Pending</span>'
                                            : status === 'CANCELLED'
                                                ? '<span class="badge bg-danger">Cancelled</span>'
                                                : '<span class="badge bg-secondary">' + status + '</span>';

                                // Payment status
                                var paymentStatus = button.getAttribute('data-paymentstatus');
                                document.getElementById('detailPaymentStatus').innerHTML =
                                    paymentStatus === 'PAID'
                                        ? '<span class="badge bg-success">Paid</span>'
                                        : paymentStatus === 'PENDING'
                                            ? '<span class="badge bg-warning">Pending Payment</span>'
                                            : '<span class="badge bg-secondary">' + paymentStatus + '</span>';
                            });
                        });
                    </script>

                    <script src="${pageContext.request.contextPath}/assets/js/validation.js"></script>
            </body>

            </html>