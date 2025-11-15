<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

            <c:if test="${empty sessionScope.user}">
                <script>
                    window.location.href = '${pageContext.request.contextPath}/auth/login?error=You need to login to view your ratings';
                </script>
                <c:remove var="ratings" scope="request" />
            </c:if>

            <!DOCTYPE html>
            <html lang="en">

            <head>
                <jsp:include page="/views/partials/head.jsp">
                    <jsp:param name="title" value="My Ratings - Bus Booking System" />
                </jsp:include>
                <style>
                    html,
                    body {
                        height: 100%;
                    }

                    body {
                        display: flex;
                        flex-direction: column;
                        min-height: 100vh;
                    }

                    main {
                        flex: 1 0 auto;
                    }

                    .rating-card {
                        transition: transform 0.2s;
                        border: none;
                        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.08);
                        margin-bottom: 20px;
                    }

                    .rating-card:hover {
                        transform: translateY(-2px);
                        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.13);
                    }

                    .rating-stars {
                        color: #ffc107;
                    }

                    .title-with-icon {
                        white-space: nowrap;
                    }
                </style>
            </head>

            <body>
                <%@ include file="/views/partials/user-header.jsp" %>

                    <main class="flex-grow-1">
                        <div class="container mt-4">
                            <div class="d-flex justify-content-between align-items-center mb-4">
                                <h2 class="mb-0"><span class="title-with-icon"><i class="fas fa-star me-2"></i>My Ratings</span></h2>
                                <div>
                                    <a href="${pageContext.request.contextPath}/tickets"
                                        class="btn btn-outline-secondary">
                                        <i class="fas fa-ticket-alt me-1"></i>My Tickets
                                    </a>
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

                            <c:choose>
                                <c:when test="${empty ratings}">
                                    <div class="text-center py-5">
                                        <i class="fas fa-star fa-3x text-muted mb-3"></i>
                                        <h5 class="text-muted">You haven't rated any trips yet</h5>
                                        <p class="text-muted">After completing and paying for a trip, you can rate your
                                            driver.</p>
                                        <a href="${pageContext.request.contextPath}/tickets" class="btn btn-primary">
                                            <i class="fas fa-ticket-alt me-1"></i>View My Tickets
                                        </a>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="table-responsive">
                                        <table class="table table-hover align-middle">
                                            <thead class="table-light">
                                                <tr>
                                                    <th style="min-width:140px">Ticket</th>
                                                    <th>Route</th>
                                                    <th>Driver</th>
                                                    <th style="width:120px">Rating</th>
                                                    <th>Comments</th>
                                                    <th style="width:160px">Created</th>
                                                    <th style="width:140px">Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="r" items="${ratings}">
                                                    <tr>
                                                        <td>
                                                            <div class="fw-bold">${r.ticketNumber}</div>
                                                        </td>
                                                        <td>
                                                            <div>${r.routeName}</div>
                                                        </td>
                                                        <td>
                                                            <c:out value="${r.driverName}" />
                                                        </td>
                                                    <td>
                                                        <span class="fw-bold">${r.ratingValue}/5</span>
                                                    </td>
                                                        <td>
                                                            <c:out value="${r.comments}" />
                                                        </td>
                                                        <td>
                                                            <c:out value="${r.formattedCreatedDate}" />
                                                        </td>
                                                        <td>
                                                            <a class="btn btn-sm btn-outline-primary"
                                                                href="${pageContext.request.contextPath}/tickets/rate/edit?ratingId=${r.ratingId}">
                                                                <i class="fas fa-edit"></i>
                                                            </a>
                                                            <form
                                                                action="${pageContext.request.contextPath}/tickets/rate/delete"
                                                                method="post" style="display:inline">
                                                                <input type="hidden" name="ratingId"
                                                                    value="${r.ratingId}" />
                                                                <button type="submit"
                                                                    class="btn btn-sm btn-outline-danger"
                                                                    onclick="return confirm('Delete this rating?')">
                                                                    <i class="fas fa-trash"></i>
                                                                </button>
                                                            </form>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </main>

                    <%@ include file="/views/partials/footer.jsp" %>
                        <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
                        <script>
                            // Auto-hide alerts after 5 seconds
                            document.addEventListener('DOMContentLoaded', function () {
                                const alerts = document.querySelectorAll('.alert');
                                alerts.forEach(function(alert) {
                                    setTimeout(function() {
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