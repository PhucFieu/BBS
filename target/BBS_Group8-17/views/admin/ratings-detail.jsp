<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <jsp:include page="/views/partials/head.jsp">
        <jsp:param name="title" value="Rating Details - Bus Booking System" />
    </jsp:include>
    <style>
        html, body { height: 100%; }
        body { display: flex; flex-direction: column; min-height: 100vh; }
        main { flex: 1 0 auto; }
        .rating-stars { color: #ffc107; }
        .card-animated { transition: transform .15s ease, box-shadow .2s ease; }
        .card-animated:hover { transform: translateY(-2px); box-shadow: 0 6px 18px rgba(0,0,0,0.08); }
        .fade-in { animation: fadeIn .25s ease-out; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(4px);} to { opacity: 1; transform: translateY(0);} }
    </style>
</head>

<body>
<%@ include file="/views/partials/admin-header.jsp" %>

<main class="flex-grow-1">
<div class="container mt-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2 class="mb-0"><i class="fas fa-star me-2"></i>Ratings Detail
            <small class="text-muted ms-2">(<c:out value="${type}"/>)</small>
        </h2>
        <a href="${pageContext.request.contextPath}/admin/ratings" class="btn btn-outline-secondary">
            <i class="fas fa-arrow-left me-1"></i>Back
        </a>
    </div>

    <c:if test="${not empty objectName}">
        <div class="alert alert-info fade-in" role="alert">
            <i class="fas fa-info-circle me-1"></i>
            Viewing ratings for: <strong><c:out value="${objectName}"/></strong>
        </div>
    </c:if>

    <c:choose>
        <c:when test="${empty rows}">
            <div class="text-center py-5">
                <i class="fas fa-star fa-3x text-muted mb-3"></i>
                <h5 class="text-muted">No ratings found</h5>
            </div>
        </c:when>
        <c:otherwise>
            <div class="table-responsive fade-in">
                <table class="table table-hover align-middle">
                    <thead class="table-dark">
                        <tr>
                            <th style="width:140px">Ticket</th>
                            <th>Route</th>
                            <th>Driver</th>
                            <th>Passenger</th>
                            <th style="width:160px" class="text-center">Rating</th>
                            <th>Comments</th>
                            <th style="width:180px">Created</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="r" items="${rows}">
                            <tr class="fade-in">
                                <td><c:out value="${r.ticketNumber}"/></td>
                                <td><c:out value="${r.routeName}"/></td>
                                <td><c:out value="${r.driverName}"/></td>
                                <td><c:out value="${r.userName}"/></td>
                                <td class="text-center">
                                    <span class="rating-stars">
                                        <c:forEach var="i" begin="1" end="5">
                                            <i class="fa-star ${i <= r.ratingValue ? 'fas' : 'far'}"></i>
                                        </c:forEach>
                                    </span>
                                </td>
                                <td><c:out value="${r.comments}"/></td>
                                <td>
                                    <fmt:formatDate value="${r.createdDate}" pattern="dd/MM/yyyy HH:mm"/>
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
</body>

</html>


