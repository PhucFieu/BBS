<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <jsp:include page="/views/partials/head.jsp">
                <jsp:param name="title" value="Home - Bus Ticket Booking" />
            </jsp:include>
        </head>

        <body>
            <%@ include file="/views/partials/user-header.jsp" %>

                <!-- Popular Routes -->
                <section class="py-5 bg-light">
                    <div class="container">
                        <h3 class="text-center mb-4">Popular Routes</h3>
                        <div class="row">
                            <c:forEach var="route" items="${popularRoutes}">
                                <div class="col-md-4 mb-4">
                                    <div class="card h-100">
                                        <div class="card-body">
                                            <h5 class="card-title">${route.routeName}</h5>
                                            <p class="card-text">
                                                <i class="fas fa-map-marker-alt text-primary"></i>
                                                ${route.departureCity}
                                                <i class="fas fa-arrow-right mx-2"></i>
                                                <i class="fas fa-map-marker-alt text-danger"></i>
                                                ${route.destinationCity}
                                            </p>
                                            <p class="card-text">
                                                <i class="fas fa-road"></i> Distance: ${route.distance} km<br>
                                                <i class="fas fa-clock"></i> Duration: ${route.durationHours} hours<br>
                                                <i class="fas fa-money-bill"></i> Price: ${route.price} VND
                                            </p>
                                            <c:choose>
                                                <c:when test="${empty sessionScope.user}">
                                                    <button class="btn btn-primary w-100" onclick="showLoginPrompt()">
                                                        <i class="fas fa-ticket-alt"></i> Book Now
                                                    </button>
                                                </c:when>
                                                <c:otherwise>
                                                    <a href="${pageContext.request.contextPath}/tickets/book?routeId=${route.routeId}"
                                                        class="btn btn-primary w-100">
                                                        <i class="fas fa-ticket-alt"></i> Book Now
                                                    </a>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </section>

                <!-- Route List -->
                <section class="py-5">
                    <div class="container">
                        <h3 class="text-center mb-4">Route List</h3>
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead class="table-dark">
                                    <tr>
                                        <th>Route ID</th>
                                        <th>From</th>
                                        <th>To</th>
                                        <th>Distance</th>
                                        <th>Duration</th>
                                        <th>Price</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="route" items="${routes}">
                                        <tr>
                                            <td>${route.routeId}</td>
                                            <td>${route.departureCity}</td>
                                            <td>${route.destinationCity}</td>
                                            <td>${route.distance} km</td>
                                            <td>${route.durationHours} hours</td>
                                            <td>
                                                <fmt:formatNumber value="${route.basePrice}" pattern="#,###" />₫
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${empty sessionScope.user}">
                                                        <button class="btn btn-primary w-100"
                                                            onclick="showLoginPrompt()">
                                                            <i class="fas fa-ticket-alt"></i> Book Now
                                                        </button>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <a href="${pageContext.request.contextPath}/tickets/book?routeId=${route.routeId}"
                                                            class="btn btn-primary w-100">
                                                            <i class="fas fa-ticket-alt"></i> Book Now
                                                        </a>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </section>



                <%@ include file="/views/partials/footer.jsp" %>

                    <script>
                        function showLoginPrompt() {
                            if (confirm("You need to login to book tickets. Go to login page?")) {
                                window.location.href = "${pageContext.request.contextPath}/auth/login";
                            }
                        }
                    </script>

        </body>

        </html>