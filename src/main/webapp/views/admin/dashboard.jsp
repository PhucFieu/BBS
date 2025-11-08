<%-- 
    Document   : dashboard
    Created on : Oct 11, 2025, 12:53:01 PM
    Author     : Phúc
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <jsp:include page="/views/partials/head.jsp">
                <jsp:param name="title" value="Admin Dashboard - BusTicket System" />
            </jsp:include>
            <style>
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

                .recent-activity {
                    background: white;
                    border-radius: 10px;
                    padding: 20px;
                    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                    margin-bottom: 20px;
                }

                .activity-item {
                    display: flex;
                    align-items: center;
                    padding: 10px 0;
                    border-bottom: 1px solid #e9ecef;
                }

                .activity-item:last-child {
                    border-bottom: none;
                }

                .activity-icon {
                    width: 40px;
                    height: 40px;
                    border-radius: 50%;
                    background: #f8f9fa;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    margin-right: 15px;
                    font-size: 1.2rem;
                }
            </style>
        </head>

        <body>
            <%@ include file="/views/partials/admin-header.jsp" %>

                <div class="container mt-4">
                    <!-- Dashboard Header -->
                    <div class="row mb-4">
                        <div class="col-12">
                            <h2><i class="fas fa-tachometer-alt me-2"></i>Admin Dashboard</h2>
                            <p class="text-muted">Tổng quan hệ thống và thống kê</p>
                        </div>
                    </div>

                    <!-- Stats Cards -->
                    <div class="row mb-4">
                        <div class="col-lg-3 col-md-6 mb-3">
                            <div class="stats-card">
                                <div class="stats-number text-primary">${totalUsers}</div>
                                <div class="stats-label">Tổng người dùng</div>
                                <div class="mt-2"><i class="fas fa-users fa-2x text-primary opacity-50"></i></div>
                            </div>
                        </div>
                        <div class="col-lg-3 col-md-6 mb-3">
                            <div class="stats-card">
                                <div class="stats-number text-success">${totalRoutes}</div>
                                <div class="stats-label">Tuyến xe hoạt động</div>
                                <div class="mt-2"><i class="fas fa-route fa-2x text-success opacity-50"></i></div>
                            </div>
                        </div>
                        <div class="col-lg-3 col-md-6 mb-3">
                            <div class="stats-card">
                                <div class="stats-number text-warning">${totalBuses}</div>
                                <div class="stats-label">Xe khả dụng</div>
                                <div class="mt-2"><i class="fas fa-bus fa-2x text-warning opacity-50"></i></div>
                            </div>
                        </div>
                        <div class="col-lg-3 col-md-6 mb-3">
                            <div class="stats-card">
                                <div class="stats-number text-danger">${totalTickets}</div>
                                <div class="stats-label">Tổng vé</div>
                                <div class="mt-2"><i class="fas fa-ticket-alt fa-2x text-danger opacity-50"></i></div>
                            </div>
                        </div>
                    </div>

                    <!-- Quick Actions -->
                    <div class="row mb-4">
                        <div class="col-12">
                            <div class="card">
                                <div class="card-header">
                                    <h5 class="mb-0"><i class="fas fa-bolt me-2"></i>Thao tác nhanh</h5>
                                </div>
                                <div class="card-body">
                                    <div class="row g-3">
                                        <div class="col-md-3">
                                            <a href="${pageContext.request.contextPath}/admin/users"
                                                class="btn btn-outline-primary w-100">
                                                <i class="fas fa-users me-2"></i>Quản lý người dùng
                                            </a>
                                        </div>
                                        <div class="col-md-3">
                                            <a href="${pageContext.request.contextPath}/routes"
                                                class="btn btn-outline-success w-100">
                                                <i class="fas fa-route me-2"></i>Quản lý tuyến xe
                                            </a>
                                        </div>
                                        <div class="col-md-3">
                                            <a href="${pageContext.request.contextPath}/buses"
                                                class="btn btn-outline-warning w-100">
                                                <i class="fas fa-bus me-2"></i>Quản lý xe
                                            </a>
                                        </div>
                                        <div class="col-md-3">
                                            <a href="${pageContext.request.contextPath}/tickets"
                                                class="btn btn-outline-info w-100">
                                                <i class="fas fa-ticket-alt me-2"></i>Quản lý vé
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Recent Activities -->
                    <div class="row">
                        <div class="col-md-6">
                            <div class="recent-activity">
                                <h5><i class="fas fa-user-plus me-2"></i>Người dùng mới</h5>
                                <c:choose>
                                    <c:when test="${not empty recentUsers}">
                                        <c:forEach var="user" items="${recentUsers}">
                                            <div class="activity-item">
                                                <div class="activity-icon">
                                                    <i class="fas fa-user text-primary"></i>
                                                </div>
                                                <div class="flex-grow-1">
                                                    <div class="fw-bold">${user.fullName}</div>
                                                    <small class="text-muted">${user.username} - ${user.role}</small>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <p class="text-muted">Không có người dùng mới</p>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="recent-activity">
                                <h5><i class="fas fa-ticket-alt me-2"></i>Vé mới</h5>
                                <c:choose>
                                    <c:when test="${not empty recentTickets}">
                                        <c:forEach var="ticket" items="${recentTickets}">
                                            <div class="activity-item">
                                                <div class="activity-icon">
                                                    <i class="fas fa-ticket-alt text-success"></i>
                                                </div>
                                                <div class="flex-grow-1">
                                                    <div class="fw-bold">${ticket.ticketNumber}</div>
                                                    <small class="text-muted">${ticket.routeName} -
                                                        ${ticket.status}</small>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <p class="text-muted">Không có vé mới</p>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>

                <%@ include file="/views/partials/footer.jsp" %>
        </body>

        </html>