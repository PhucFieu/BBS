<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <jsp:include page="/views/partials/head.jsp">
                <jsp:param name="title" value="Station Form - Admin Panel" />
            </jsp:include>
            <style>
                .form-container {
                    max-width: 600px;
                    margin: 0 auto;
                }

                .form-header {
                    background: linear-gradient(135deg, #66bb6a 0%, #81c784 100%);
                    color: white;
                    padding: 20px;
                    border-radius: 8px 8px 0 0;
                }

                .form-body {
                    background: white;
                    padding: 30px;
                    border-radius: 0 0 8px 8px;
                    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                }
            </style>
        </head>

        <body>
            <%@ include file="/views/partials/admin-header.jsp" %>

                <div class="container mt-4">
                    <div class="form-container">
                        <div class="form-header">
                            <h3 class="mb-0">
                                <i class="fas fa-map-marker-alt me-2"></i>
                                <c:choose>
                                    <c:when test="${not empty station}">
                                        Edit Station
                                    </c:when>
                                    <c:otherwise>
                                        Add New Station
                                    </c:otherwise>
                                </c:choose>
                            </h3>
                        </div>

                        <div class="form-body">
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

                            <!-- Station Form -->
                            <form
                                action="${pageContext.request.contextPath}/admin/stations/${not empty station ? 'edit' : 'add'}"
                                method="post" id="stationForm">

                                <c:if test="${not empty station}">
                                    <input type="hidden" name="stationId" value="${station.stationId}">
                                </c:if>

                                <div class="row">
                                    <div class="col-md-12 mb-3">
                                        <label for="stationName" class="form-label">
                                            <i class="fas fa-building me-1"></i>Station Name <span
                                                class="text-danger">*</span>
                                        </label>
                                        <input type="text" class="form-control" id="stationName" name="stationName"
                                            value="${station.stationName}" required>
                                        <div class="invalid-feedback">
                                            Please provide a valid station name.
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="city" class="form-label">
                                            <i class="fas fa-city me-1"></i>City <span class="text-danger">*</span>
                                        </label>
                                        <input type="text" class="form-control" id="city" name="city"
                                            value="${station.city}" required>
                                        <div class="invalid-feedback">
                                            Please provide a valid city.
                                        </div>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label for="status" class="form-label">
                                            <i class="fas fa-toggle-on me-1"></i>Status
                                        </label>
                                        <select class="form-select" id="status" name="status">
                                            <option value="ACTIVE" ${station.status eq 'ACTIVE' ? 'selected' : '' }>
                                                Active</option>
                                            <option value="INACTIVE" ${station.status eq 'INACTIVE' ? 'selected' : '' }>
                                                Inactive</option>
                                        </select>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-12 mb-4">
                                        <label for="address" class="form-label">
                                            <i class="fas fa-map-marker-alt me-1"></i>Address <span
                                                class="text-danger">*</span>
                                        </label>
                                        <textarea class="form-control" id="address" name="address" rows="3"
                                            required>${station.address}</textarea>
                                        <div class="invalid-feedback">
                                            Please provide a valid address.
                                        </div>
                                    </div>
                                </div>

                                <!-- Form Actions -->
                                <div class="d-flex justify-content-between">
                                    <a href="${pageContext.request.contextPath}/admin/stations"
                                        class="btn btn-secondary">
                                        <i class="fas fa-arrow-left me-1"></i>Back to Stations
                                    </a>
                                    <div>
                                        <button type="button" class="btn btn-outline-secondary me-2"
                                            onclick="resetForm()">
                                            <i class="fas fa-undo me-1"></i>Reset
                                        </button>
                                        <button type="submit" class="btn btn-primary">
                                            <i class="fas fa-save me-1"></i>
                                            <c:choose>
                                                <c:when test="${not empty station}">
                                                    Update Station
                                                </c:when>
                                                <c:otherwise>
                                                    Add Station
                                                </c:otherwise>
                                            </c:choose>
                                        </button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

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
                <script>
                    // Form validation
                    (function () {
                        'use strict';
                        window.addEventListener('load', function () {
                            var forms = document.getElementsByClassName('needs-validation');
                            var validation = Array.prototype.filter.call(forms, function (form) {
                                form.addEventListener('submit', function (event) {
                                    if (form.checkValidity() === false) {
                                        event.preventDefault();
                                        event.stopPropagation();
                                    }
                                    form.classList.add('was-validated');
                                }, false);
                            });
                        }, false);
                    })();

                    // Add validation class to form
                    document.getElementById('stationForm').classList.add('needs-validation');

                    // Reset form function
                    function resetForm() {
                        document.getElementById('stationForm').reset();
                        document.getElementById('stationForm').classList.remove('was-validated');
                    }

                    // Auto-focus on first input
                    document.addEventListener('DOMContentLoaded', function () {
                        document.getElementById('stationName').focus();
                    });
                </script>

                <%@ include file="/views/partials/footer.jsp" %>
        </body>

        </html>