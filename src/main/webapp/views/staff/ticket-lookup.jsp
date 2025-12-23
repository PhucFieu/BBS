<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <jsp:include page="/views/partials/head.jsp">
                    <jsp:param name="title" value="Ticket Lookup - Staff Panel" />
                </jsp:include>
                <style>
                    .search-box {
                        background: linear-gradient(135deg, #27ae60 0%, #229954 100%);
                        padding: 1.5rem;
                        border-radius: 10px;
                        color: white;
                        margin-bottom: 20px;
                    }

                    .ticket-row {
                        transition: background 0.2s;
                    }

                    .ticket-row:hover {
                        background: #f8f9fa;
                    }
                </style>
            </head>

            <body>
                <%@ include file="/views/partials/staff-header.jsp" %>

                    <div class="container mt-4">
                        <!-- Search Box -->
                        <div class="search-box">
                            <h4 class="mb-3"><i class="fas fa-search me-2"></i>Ticket Lookup</h4>
                            <form method="get" action="${pageContext.request.contextPath}/staff/tickets"
                                class="row g-3">
                                <div class="col-md-5">
                                    <input type="text" name="search" class="form-control"
                                        placeholder="Search by ticket number, phone, or name" value="${searchTerm}">
                                </div>
                                <div class="col-md-4">
                                    <input type="date" name="date" class="form-control" value="${searchDate}">
                                </div>
                                <div class="col-md-3">
                                    <button type="submit" class="btn btn-light w-100">
                                        <i class="fas fa-search me-2"></i>Search
                                    </button>
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

                        <!-- Page Header -->
                        <div class="row mb-3">
                            <div class="col-12">
                                <h5><i class="fas fa-ticket-alt me-2 text-success"></i>Search Results</h5>
                            </div>
                        </div>

                        <!-- Results -->
                        <c:choose>
                            <c:when test="${empty tickets}">
                                <div class="text-center py-5 text-muted">
                                    <i class="fas fa-ticket-alt fa-3x mb-3 d-block opacity-50"></i>
                                    <p>No tickets found. Enter search criteria above.</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="table-responsive">
                                    <table class="table table-hover">
                                        <thead>
                                            <tr>
                                                <th>Ticket #</th>
                                                <th>Customer</th>
                                                <th>Phone</th>
                                                <th>Route</th>
                                                <th>Date</th>
                                                <th>Seat</th>
                                                <th>Status</th>
                                                <th>Payment</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="ticket" items="${tickets}">
                                                <tr class="ticket-row">
                                                    <td><strong>${ticket.ticketNumber}</strong></td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty ticket.customerName}">
                                                                ${ticket.customerName}</c:when>
                                                            <c:otherwise>${ticket.userName}</c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty ticket.customerPhone}">
                                                                ${ticket.customerPhone}</c:when>
                                                            <c:when test="${not empty ticket.user.phoneNumber}">
                                                                ${ticket.user.phoneNumber}</c:when>
                                                            <c:otherwise>-</c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>${ticket.routeName}</td>
                                                    <td>${ticket.departureDate}</td>
                                                    <td><span class="badge bg-secondary">${ticket.seatNumber}</span>
                                                    </td>
                                                    <td>
                                                        <span class="badge ${not empty ticket.checkedInAt ? 'bg-info' :
                                            ticket.status == 'CONFIRMED' ? 'bg-success' : 
                                            ticket.status == 'CANCELLED' ? 'bg-danger' : 'bg-warning'}">
                                                            <c:choose>
                                                                <c:when test="${not empty ticket.checkedInAt}">Checked
                                                                    In</c:when>
                                                                <c:otherwise>${ticket.status}</c:otherwise>
                                                            </c:choose>
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <span
                                                            class="badge ${ticket.paymentStatus == 'PAID' ? 'bg-success' : 'bg-warning'}">
                                                            ${ticket.paymentStatus}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <a href="${pageContext.request.contextPath}/staff/ticket-detail?id=${ticket.ticketId}"
                                                            class="btn btn-sm btn-outline-primary" title="View Details">
                                                            <i class="fas fa-eye"></i>
                                                        </a>
                                                        <c:if
                                                            test="${ticket.status != 'CANCELLED' && empty ticket.checkedInAt}">
                                                            <a href="${pageContext.request.contextPath}/staff/edit-ticket?id=${ticket.ticketId}"
                                                                class="btn btn-sm btn-outline-warning" title="Edit">
                                                                <i class="fas fa-edit"></i>
                                                            </a>
                                                        </c:if>
                                                        <c:if
                                                            test="${ticket.paymentStatus != 'PAID' && ticket.status != 'CANCELLED'}">
                                                            <form method="post"
                                                                action="${pageContext.request.contextPath}/staff/mark-paid"
                                                                style="display: inline;">
                                                                <input type="hidden" name="ticketId"
                                                                    value="${ticket.ticketId}">
                                                                <input type="hidden" name="redirectTo"
                                                                    value="${pageContext.request.contextPath}/staff/tickets?search=${searchTerm}&date=${searchDate}">
                                                                <button type="submit"
                                                                    class="btn btn-sm btn-outline-success"
                                                                    title="Mark Paid">
                                                                    <i class="fas fa-money-bill"></i>
                                                                </button>
                                                            </form>
                                                        </c:if>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <%@ include file="/views/partials/footer.jsp" %>
            </body>

            </html>