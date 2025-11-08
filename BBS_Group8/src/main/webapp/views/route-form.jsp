<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <title>${route == null ? 'Add Route' : 'Edit Route'} - Bus Booking System</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
            <link href="${pageContext.request.contextPath}/assets/css/route-form.css" rel="stylesheet">
        </head>

        <body class="bg-light">
            <div class="container">
                <div class="row justify-content-center">
                    <div class="col-lg-7 col-md-9">
                        <div class="form-card">
                            <div class="form-header d-flex align-items-center gap-2">
                                <i class="fas fa-route fa-2x me-2"></i>
                                <div>
                                    <h4 class="mb-0">${route == null ? 'Add Route' : 'Edit Route'}</h4>
                                    <small>Manage bus route information</small>
                                </div>
                            </div>
                            <form action="${pageContext.request.contextPath}/routes/${route == null ? 'add' : 'edit'}"
                                method="post" autocomplete="off">
                                <c:if test="${route != null}">
                                    <input type="hidden" name="routeId" value="${route.routeId}">
                                </c:if>
                                <div class="section-title"><i class="fas fa-info-circle me-1"></i>Basic Information
                                </div>
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <label for="routeName" class="form-label">Route Name *</nlabel>
                                        <input type="text" class="form-control" id="routeName" name="routeName"
                                            value="${route.routeName}" required maxlength="100"
                                            placeholder="E.g: Hanoi - Hai Phong">
                                    </div>
                                    <div class="col-md-6">
                                        <label for="basePrice" class="form-label">Base Price (VND) *</label>
                                        <input type="number" class="form-control" id="basePrice" name="basePrice"
                                            value="${route.basePrice}" min="0" step="1000" required
                                            placeholder="VD: 150000">
                                    </div>
                                </div>
                                <div class="row g-3 mt-2">
                                    <div class="col-md-6">
                                        <label for="departureCity" class="form-label">Departure City *</label>
                                        <input type="text" class="form-control" id="departureCity" name="departureCity"
                                            value="${route.departureCity}" required maxlength="50"
                                            placeholder="E.g: Hanoi">
                                    </div>
                                    <div class="col-md-6">
                                        <label for="destinationCity" class="form-label">Destination City *</label>
                                        <input type="text" class="form-control" id="destinationCity"
                                            name="destinationCity" value="${route.destinationCity}" required
                                            maxlength="50" placeholder="E.g: Hai Phong">
                                    </div>
                                </div>
                                <div class="row g-3 mt-2">
                                    <div class="col-md-6">
                                        <label for="distance" class="form-label">Distance (km) *</label>
                                        <input type="number" class="form-control" id="distance" name="distance"
                                            value="${route.distance}" step="0.1" min="1" required
                                            placeholder="VD: 105.5">
                                    </div>
                                    <div class="col-md-6">
                                        <label for="durationHours" class="form-label">Duration (hours) *</label>
                                        <input type="number" class="form-control" id="durationHours"
                                            name="durationHours" value="${route.durationHours}" min="1" step="0.5"
                                            required placeholder="VD: 2">
                                    </div>
                                </div>
                                <div class="d-flex justify-content-between align-items-center mt-4">
                                    <a href="${pageContext.request.contextPath}/routes"
                                        class="btn btn-outline-secondary">
                                        <i class="fas fa-arrow-left me-2"></i>Back
                                    </a>
                                    <button type="submit" class="btn btn-gradient">
                                        <i class="fas fa-save me-2"></i>${route == null ? 'Thêm Tuyến xe' : 'Cập nhật'}
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            <script src="${pageContext.request.contextPath}/assets/js/route-form.js"></script>
        </body>

        </html>

