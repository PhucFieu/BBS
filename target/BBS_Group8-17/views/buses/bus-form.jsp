<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <title>${bus == null ? 'Add Bus' : 'Edit Bus'} - Bus Booking System</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
            <style>
                /* Bus Form Styles */
                .form-card {
                    background: #fff;
                    border-radius: 18px;
                    box-shadow: 0 8px 32px rgba(102, 187, 106, 0.15);
                    padding: 2.5rem 2rem 2rem 2rem;
                    margin-top: 2rem;
                    margin-bottom: 2rem;
                }

                .form-header {
                    background: linear-gradient(135deg, #66bb6a 0%, #81c784 100%);
                    color: #fff;
                    border-radius: 18px 18px 0 0;
                    padding: 1.5rem 2rem;
                    margin: -2.5rem -2rem 2rem -2rem;
                    box-shadow: 0 4px 16px rgba(102, 187, 106, 0.2);
                }

                .form-label {
                    font-weight: 600;
                }

                .form-control:focus {
                    border-color: #66bb6a;
                    box-shadow: 0 0 0 0.2rem rgba(102, 187, 106, 0.25);
                }

                .btn-gradient {
                    background: linear-gradient(135deg, #66bb6a 0%, #81c784 100%);
                    color: #fff;
                    border: none;
                    border-radius: 25px;
                    padding: 0.75rem 2rem;
                    font-weight: 600;
                    transition: all 0.2s;
                }

                .btn-gradient:hover {
                    background: linear-gradient(135deg, #4caf50 0%, #66bb6a 100%);
                    color: #fff;
                    transform: translateY(-2px);
                    box-shadow: 0 4px 16px rgba(102, 187, 106, 0.25);
                }

                .section-title {
                    font-size: 1.1rem;
                    font-weight: 600;
                    color: #4caf50;
                    margin-bottom: 1rem;
                    margin-top: 1.5rem;
                }

                @media (max-width: 576px) {
                    .form-card,
                    .form-header {
                        padding: 1rem !important;
                    }
                }
            </style>
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
                                            value="${bus.busNumber}" placeholder="e.g., B001" required>
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
                                            value="${bus.licensePlate}" placeholder="e.g., 51A-12345" required>
                                        <div class="form-text">Format: XX-XXXXX or XX-XXXX</div>
                                    </div>
                                </div>
                                <!-- Additional Information -->
                                <div class="section-title"><i class="fas fa-cogs me-1"></i>Additional Information</div>
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <label for="status" class="form-label">Status</label>
                                        <select class="form-select" id="status" name="status">
                                            <option value="ACTIVE" ${bus.status eq 'ACTIVE' ? 'selected' : '' }>Active</option>
                                            <option value="INACTIVE" ${bus.status eq 'INACTIVE' ? 'selected' : '' }>Inactive</option>
                                            <option value="MAINTENANCE" ${bus.status eq 'MAINTENANCE' ? 'selected' : '' }>Maintenance</option>
                                        </select>
                                    </div>
                                </div>
                                <!-- Form Actions -->
                                <div class="d-flex justify-content-between align-items-center mt-4">
                                    <a href="${pageContext.request.contextPath}/buses"
                                        class="btn btn-outline-secondary">
                                        <i class="fas fa-arrow-left me-2"></i>Back
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
            <%@ include file="/views/partials/footer.jsp" %>
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            <script>
                document.addEventListener('DOMContentLoaded', function () {
                    // Auto-hide alerts after 5 seconds
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

