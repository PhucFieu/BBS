<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <jsp:include page="/views/partials/head.jsp">
                    <jsp:param name="title" value="Rating Management - Bus Booking System" />
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

                    .filter-card {
                        background: #f8f9fa;
                        padding: 16px;
                        border-radius: 8px;
                        margin-bottom: 16px;
                    }

                    /* Animated table styles */
                    .table-animated tbody tr {
                        transition: transform .15s ease, background-color .2s ease, box-shadow .2s ease;
                    }

                    .table-animated tbody tr:hover {
                        transform: translateY(-2px);
                        background-color: #f8fafc;
                        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
                    }

                    .fade-in {
                        animation: fadeIn .25s ease-out;
                    }

                    @keyframes fadeIn {
                        from {
                            opacity: 0;
                            transform: translateY(4px);
                        }

                        to {
                            opacity: 1;
                            transform: translateY(0);
                        }
                    }
                </style>
                <script defer src="https://kit.fontawesome.com/a2e0e6ad54.js" crossorigin="anonymous"></script>
                <script>
                    function onFilterTypeChange(sel) {
                        var objGroup = document.getElementById('objectTypeGroup');
                        if (sel.value === 'object') {
                            objGroup.classList.remove('d-none');
                        } else {
                            objGroup.classList.add('d-none');
                        }
                    }
                    document.addEventListener('DOMContentLoaded', function () {
                        var sel = document.getElementById('filterType');
                        onFilterTypeChange(sel);
                    });
                </script>
            </head>

            <body>
                <%@ include file="/views/partials/admin-header.jsp" %>

                    <main class="flex-grow-1">
                        <div class="container mt-4">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <h2><i class="fas fa-star me-2"></i>Rating Management</h2>
                            </div>

                            <div class="filter-card">
                                <form method="get" action="${pageContext.request.contextPath}/admin/ratings/"
                                    class="row g-3">
                                    <div class="col-md-4">
                                        <label class="form-label" for="filterType">Filter by</label>
                                        <select class="form-select" id="filterType" name="filterType"
                                            onchange="onFilterTypeChange(this)">
                                            <option value="role" ${filterType=='role' ? 'selected' : '' }>User Role
                                            </option>
                                            <option value="object" ${filterType=='object' ? 'selected' : '' }>Object
                                            </option>
                                        </select>
                                    </div>
                                    <div class="col-md-4 ${filterType == 'object' ? '' : 'd-none'}"
                                        id="objectTypeGroup">
                                        <label class="form-label" for="objectType">Object</label>
                                        <select class="form-select" id="objectType" name="objectType">
                                            <option value="driver" ${objectType=='driver' ? 'selected' : '' }>Driver
                                            </option>
                                            <option value="route" ${objectType=='route' ? 'selected' : '' }>Route
                                            </option>
                                            <option value="ticket" ${objectType=='ticket' ? 'selected' : '' }>Ticket
                                            </option>
                                        </select>
                                    </div>
                                    <div class="col-md-4 d-flex align-items-end">
                                        <button type="submit" class="btn btn-primary"><i
                                                class="fas fa-filter me-1"></i>Apply</button>
                                    </div>
                                </form>
                            </div>

                            <c:choose>
                                <c:when test="${viewMode == 'ROLE'}">
                                    <div class="table-responsive fade-in">
                                        <table class="table table-hover align-middle table-animated">
                                            <thead class="table-dark">
                                                <tr>
                                                    <th>Role</th>
                                                    <th class="text-end" style="width:180px">Total Ratings</th>
                                                    <th style="width:120px" class="text-center">Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="r" items="${rows}">
                                                    <tr>
                                                        <td>
                                                            <c:out value="${r.role}" />
                                                        </td>
                                                        <td class="text-end">
                                                            <c:out value="${r.total}" />
                                                        </td>
                                                        <td class="text-center">
                                                            <a class="btn btn-sm btn-outline-primary disabled"
                                                                tabindex="-1" aria-disabled="true">
                                                                <i class="fas fa-eye me-1"></i>View
                                                            </a>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="table-responsive fade-in">
                                        <table class="table table-hover align-middle table-animated">
                                            <thead class="table-dark">
                                                <tr>
                                                    <th>ID</th>
                                                    <th>Name</th>
                                                    <th style="width:180px" class="text-center">Average</th>
                                                    <th style="width:180px" class="text-end">Total Ratings</th>
                                                    <th style="width:120px" class="text-center">Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="r" items="${rows}">
                                                    <tr>
                                                        <td>
                                                            <c:out value="${r.id}" />
                                                        </td>
                                                        <td>
                                                            <c:out value="${r.name}" />
                                                        </td>
                                                        <td class="text-center">
                                                            <fmt:formatNumber value="${r.avg}" maxFractionDigits="2"
                                                                minFractionDigits="1" />
                                                        </td>
                                                        <td class="text-end">
                                                            <c:out value="${r.total}" />
                                                        </td>
                                                        <td class="text-center">
                                                            <a class="btn btn-sm btn-outline-primary"
                                                                href="${pageContext.request.contextPath}/admin/ratings/detail?type=${objectType}&id=${r.id}">
                                                                <i class="fas fa-eye me-1"></i>View
                                                            </a>
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