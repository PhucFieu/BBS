<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
            <!DOCTYPE html>
            <html>

            <head>
                <jsp:include page="/views/partials/head.jsp">
                    <jsp:param name="title" value="Driver Dashboard" />
                </jsp:include>
            </head>

            <body>
                <jsp:include page="/views/partials/driver-header.jsp" />

                <div class="container mt-4">
                    <h1 class="mb-4">Driver Dashboard</h1>

                    <div class="card mb-4 p-3">
                        <h3 class="mb-2">Welcome,
                            <c:out value="${driver.fullName != null ? driver.fullName : driver.username}" />
                        </h3>
                        <p>Status: <strong>
                                <c:out value="${driver.status}" />
                            </strong></p>
                        <p>License: <strong>
                                <c:out value="${driver.licenseNumber}" />
                            </strong></p>
                    </div>

                    <div class="row g-3">
                        <div class="col-md-4">
                            <div class="card h-100 p-3">
                                <h3 class="mb-2">Assigned Trips</h3>
                                <p>Total: <strong>
                                        <c:out value='${fn:length(trips)}' />
                                    </strong></p>
                                <a class="btn btn-primary" href="<c:url value='/driver/trips'/>">View Trips</a>
                            </div>
                        </div>

                        <div class="col-md-4">
                            <div class="card h-100 p-3">
                                <h3 class="mb-2">Update Trip Status</h3>
                                <p>Go to a trip to update its status.</p>
                                <a class="btn btn-outline-secondary" href="<c:url value='/driver/trips'/>">Manage
                                    Status</a>
                            </div>
                        </div>

                        <div class="col-md-4">
                            <div class="card h-100 p-3">
                                <h3 class="mb-2">Passenger Details</h3>
                                <p>Use the View Details button on each trip to see booked passengers and stops.</p>
                                <a class="btn btn-outline-secondary" href="<c:url value='/driver/trips'/>">
                                    Go to Trips
                                </a>
                            </div>
                        </div>
                    </div>

                    <c:if test='${not empty param.message}'>
                        <div class="alert success">${param.message}</div>
                    </c:if>
                    <c:if test='${not empty param.error}'>
                        <div class="alert error">${param.error}</div>
                    </c:if>
                </div>

                <jsp:include page="/views/partials/footer.jsp" />
            </body>

            </html>