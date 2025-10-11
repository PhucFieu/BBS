<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <title>${bus == null ? 'Add Bus' : 'Edit Bus'} - Bus Booking System</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
            <link href="${pageContext.request.contextPath}/assets/css/bus-form.css" rel="stylesheet">
        </head>

        <body class="bg-light">
            <div class="container">
                <div class="row justify-content-center">
                    <div class="col-lg-7 col-md-9">
                        <div class="form-card">
                            <div class="form-header d-flex align-items-center gap-2">
                                <i class="fas fa-bus fa-2x me-2"></i>
                                <div>
                                    <h4 class="mb-0">${bus == null ? 'Add New Bus' : 'Edit Bus Information'}</h4>
                                    <small>Manage bus information</small>
                                </div>
                            </div>
                            <form action="${pageContext.request.contextPath}/buses/${bus == null ? 'add' : 'edit'}"
                                method="post" id="busForm" autocomplete="off">
                                <c:if test="${bus != null}">
                                    <input type="hidden" name="busId" value="${bus.busId}">
                                </c:if>
                                <!-- Basic Information -->
                                <div class="section-title"><i class="fas fa-info-circle me-1"></i>Basic Information
                                </div>
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <label for="busNumber" class="form-label">Bus Number *</label>
                                        <input type="text" class="form-control" id="busNumber" name="busNumber"
                                            value="${bus.busNumber}" placeholder="VD: B001" required>
                                        <div class="form-text">Unique bus identifier</div>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="busType" class="form-label">Bus Type *</label>
                                        <select class="form-select" id="busType" name="busType" required>
                                            <option value="">Select bus type</option>
                                            <option value="Bus 45 seats" ${bus.busType eq 'Bus 45 seats' ? 'selected'
                                                : '' }>
                                                Bus 45 seats
                                            </option>
                                            <option value="Bus 35 seats" ${bus.busType eq 'Bus 35 seats' ? 'selected'
                                                : '' }>
                                                Bus 35 seats
                                            </option>
                                            <option value="Bus 25 seats" ${bus.busType eq 'Bus 25 seats' ? 'selected'
                                                : '' }>
                                                Bus 25 seats
                                            </option>
                                            <option value="Bus 16 seats" ${bus.busType eq 'Bus 16 seats' ? 'selected'
                                                : '' }>
                                                Bus 16 seats
                                            </option>
                                        </select>
                                    </div>
                                </div>
                                <div class="row g-3 mt-2">
                                    <div class="col-md-6">
                                        <label for="totalSeats" class="form-label">Total Seats *</label>
                                        <input type="number" class="form-control" id="totalSeats" name="totalSeats"
                                            value="${bus.totalSeats}" min="1" max="100" required>
                                    </div>
                                </div>
                                <!-- Additional Information -->
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <label for="licensePlate" class="form-label">License Plate *</label>
                                        <input type="text" class="form-control" id="licensePlate" name="licensePlate"
                                            value="${bus.licensePlate}" placeholder="VD: 51A-12345" required>
                                        <div class="form-text">Format: XX-XXXXX or XX-XXXX</div>
                                    </div>
                                </div>
                                <!-- Additional Information -->
                                <div class="section-title"><i class="fas fa-cogs me-1"></i>Additional Information</div>
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <label for="status" class="form-label">Status</label>
                                        <select class="form-select" id="status" name="status">
                                            <option value="ACTIVE" ${bus.status eq 'ACTIVE' ? 'selected' : '' }>Active
                                                động</option>
                                            <option value="INACTIVE" ${bus.status eq 'INACTIVE' ? 'selected' : '' }>
                                                Không hoạt
                                                động
                                            </option>
                                            <option value="MAINTENANCE" ${bus.status eq 'MAINTENANCE' ? 'selected' : ''
                                                }>Bảo trì
                                            </option>
                                        </select>
                                    </div>
                                </div>
                                <!-- Form Actions -->
                                <div class="d-flex justify-content-between align-items-center mt-4">
                                    <a href="${pageContext.request.contextPath}/buses"
                                        class="btn btn-outline-secondary">
                                        <i class="fas fa-arrow-left me-2"></i>Quay lại
                                    </a>
                                    <button type="submit" class="btn btn-gradient">
                                        <i class="fas fa-save me-2"></i>${bus == null ? 'Add Bus' : 'Update'}
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            <script src="${pageContext.request.contextPath}/assets/js/bus-form.js"></script>

            <script src="${pageContext.request.contextPath}/assets/js/validation.js"></script>
        </body>

        </html>
