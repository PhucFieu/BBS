<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Update Trip Status - Driver Dashboard</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
            <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
            <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
            <style>
                .form-container {
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    border-radius: 15px;
                    padding: 2rem;
                    margin-bottom: 2rem;
                    color: white;
                }

                .form-card {
                    background: white;
                    border-radius: 15px;
                    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
                    overflow: hidden;
                }

                .form-header {
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    color: white;
                    padding: 2rem;
                    text-align: center;
                }

                .form-body {
                    padding: 2rem;
                }

                .trip-info {
                    background: #f8f9fa;
                    border-left: 4px solid #667eea;
                    border-radius: 0 10px 10px 0;
                    padding: 1rem;
                    margin-bottom: 1.5rem;
                }

                .btn-submit {
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    border: none;
                    border-radius: 10px;
                    padding: 0.75rem 2rem;
                    font-weight: 600;
                    transition: all 0.3s ease;
                }

                .btn-submit:hover {
                    transform: translateY(-2px);
                    box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
                }

                .btn-cancel {
                    border: 2px solid #6c757d;
                    border-radius: 10px;
                    padding: 0.75rem 2rem;
                    font-weight: 600;
                    transition: all 0.3s ease;
                }

                .btn-cancel:hover {
                    background-color: #6c757d;
                    color: white;
                }
            </style>
        </head>

        <body>
            <jsp:include page="../partials/driver-header.jsp" />

            <div class="container-fluid py-4">
                <div class="row justify-content-center">
                    <div class="col-lg-8">
                        <!-- Header Section -->
                        <div class="form-container">
                            <div class="row align-items-center">
                                <div class="col-md-8">
                                    <h2 class="mb-0">
                                        <i class="fas fa-edit me-2"></i>Update Trip Status
                                    </h2>
                                    <p class="mb-0 mt-2">Update the status of your assigned trip</p>
                                </div>
                                <div class="col-md-4 text-md-end">
                                    <a href="${pageContext.request.contextPath}/driver/trips" class="btn btn-light">
                                        <i class="fas fa-arrow-left me-2"></i>Back to Trips
                                    </a>
                                </div>
                            </div>
                        </div>

                        <!-- Messages -->
                        <c:if test="${not empty param.message}">
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                <i class="fas fa-check-circle me-2"></i>${param.message}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>
                        <c:if test="${not empty param.error}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="fas fa-exclamation-circle me-2"></i>${param.error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <!-- Form Card -->
                        <div class="form-card">
                            <div class="form-header">
                                <h4 class="mb-0">
                                    <i class="fas fa-edit me-2"></i>Trip Status Update
                                </h4>
                            </div>
                            <div class="form-body">
                                <!-- Trip Information -->
                                <div class="trip-info">
                                    <h6 class="mb-2">
                                        <i class="fas fa-info-circle me-2"></i>Trip Information
                                    </h6>
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="d-flex justify-content-between">
                                                <span class="text-muted">Route:</span>
                                                <span class="fw-bold">${schedule.routeName}</span>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="d-flex justify-content-between">
                                                <span class="text-muted">Date:</span>
                                                <span class="fw-bold">${schedule.departureDate}</span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row mt-2">
                                        <div class="col-md-6">
                                            <div class="d-flex justify-content-between">
                                                <span class="text-muted">Time:</span>
                                                <span class="fw-bold">${schedule.departureTime}</span>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="d-flex justify-content-between">
                                                <span class="text-muted">Current Status:</span>
                                                <span class="badge bg-primary">${schedule.status}</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <form action="${pageContext.request.contextPath}/driver/update-status" method="post"
                                    id="statusForm">
                                    <input type="hidden" name="scheduleId" value="${schedule.scheduleId}">

                                    <div class="mb-3">
                                        <label for="status" class="form-label">
                                            <i class="fas fa-flag me-2"></i>New Status *
                                        </label>
                                        <select class="form-select" id="status" name="status" required>
                                            <option value="">Select new status</option>
                                            <option value="SCHEDULED" ${schedule.status=='SCHEDULED' ? 'selected' : ''
                                                }>Scheduled</option>
                                            <option value="DEPARTED" ${schedule.status=='DEPARTED' ? 'selected' : '' }>
                                                Departed</option>
                                            <option value="STOP_AT_STATION" ${schedule.status=='STOP_AT_STATION'
                                                ? 'selected' : '' }>
                                                Stop at station</option>
                                            <option value="ARRIVED" ${schedule.status=='ARRIVED' ? 'selected' : '' }>
                                                Arrived</option>
                                            <option value="CANCELLED" ${schedule.status=='CANCELLED' ? 'selected' : ''
                                                }>Cancelled</option>
                                        </select>
                                    </div>

                                    <div class="mb-3" id="stopStationGroup" style="display:none;">
                                        <label for="stopStationId" class="form-label">
                                            <i class="fas fa-bus me-2"></i>Select Station (when stopping)
                                        </label>
                                        <select class="form-select" id="stopStationId" name="stopStationId">
                                            <option value="">Choose station</option>
                                            <c:forEach var="rs" items="${routeStops}">
                                                <option value="${rs.stationId}">
                                                    ${rs.stopOrder}. ${rs.stationName} - ${rs.city}
                                                </option>
                                            </c:forEach>
                                        </select>
                                        <div class="form-text">Required when status is "Stop at station"</div>
                                    </div>

                                    <div class="mb-3">
                                        <label for="notes" class="form-label">
                                            <i class="fas fa-sticky-note me-2"></i>Notes (Optional)
                                        </label>
                                        <textarea class="form-control" id="notes" name="notes" rows="3"
                                            placeholder="Add any additional notes about the trip status..."></textarea>
                                    </div>

                                    <!-- Status Information -->
                                    <div class="alert alert-info" role="alert">
                                        <h6 class="alert-heading">
                                            <i class="fas fa-info-circle me-2"></i>Status Guidelines
                                        </h6>
                                        <ul class="mb-0 small">
                                            <li><strong>Scheduled:</strong> Trip is planned and ready to depart</li>
                                            <li><strong>Departed:</strong> Bus has left the departure station</li>
                                            <li><strong>Stop at station:</strong> Bus is currently stopped at a station
                                                on route</li>
                                            <li><strong>Arrived:</strong> Bus has reached the destination</li>
                                            <li><strong>Cancelled:</strong> Trip has been cancelled due to unforeseen
                                                circumstances</li>
                                        </ul>
                                    </div>

                                    <!-- Form Actions -->
                                    <div class="d-flex justify-content-between pt-3">
                                        <a href="${pageContext.request.contextPath}/driver/trips"
                                            class="btn btn-cancel">
                                            <i class="fas fa-times me-2"></i>Cancel
                                        </a>
                                        <button type="submit" class="btn btn-submit text-white">
                                            <i class="fas fa-save me-2"></i>Update Status
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
            <script>
                document.addEventListener('DOMContentLoaded', function () {
                    const form = document.getElementById('statusForm');
                    const statusSelect = document.getElementById('status');
                    const notesTextarea = document.getElementById('notes');
                    const stopStationGroup = document.getElementById('stopStationGroup');
                    const stopStationSelect = document.getElementById('stopStationId');

                    // Form submission
                    form.addEventListener('submit', function (e) {
                        if (!statusSelect.value) {
                            e.preventDefault();
                            alert('Please select a status');
                            return false;
                        }

                        if (statusSelect.value === 'STOP_AT_STATION' && !stopStationSelect.value) {
                            e.preventDefault();
                            alert('Please choose the station you are stopping at');
                            return false;
                        }
                    });

                    // Auto-fill notes based on status
                    function updateStopStationVisibility() {
                        const status = statusSelect.value;
                        if (status === 'STOP_AT_STATION') {
                            stopStationGroup.style.display = '';
                        } else {
                            stopStationGroup.style.display = 'none';
                            stopStationSelect.value = '';
                        }
                    }

                    statusSelect.addEventListener('change', function () {
                        const status = this.value;
                        let note = '';

                        switch (status) {
                            case 'DEPARTED':
                                note = 'Bus has departed from the station. All passengers are on board.';
                                break;
                            case 'STOP_AT_STATION':
                                note = 'Bus is stopped at a station on the route.';
                                break;
                            case 'ARRIVED':
                                note = 'Bus has arrived at the destination. All passengers have disembarked.';
                                break;
                            case 'CANCELLED':
                                note = 'Trip has been cancelled. Please provide reason for cancellation.';
                                break;
                        }

                        if (note && !notesTextarea.value) {
                            notesTextarea.value = note;
                        }
                        updateStopStationVisibility();
                    });

                    // initialize visibility on load
                    updateStopStationVisibility();
                });
            </script>
        </body>

        </html>