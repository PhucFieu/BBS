<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Replace Bus - Admin Dashboard</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
            <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
            <style>
                body {
                    font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
                    background-color: #f1f8f4;
                }

                .header-section {
                    background: linear-gradient(135deg, #66bb6a 0%, #81c784 100%);
                    color: white;
                    padding: 2rem;
                    border-radius: 10px;
                    margin-bottom: 2rem;
                }

                .info-card {
                    background: white;
                    border-radius: 10px;
                    padding: 1.5rem;
                    margin-bottom: 1.5rem;
                    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                }

                .bus-card {
                    border: 2px solid #e0e0e0;
                    border-radius: 10px;
                    padding: 1rem;
                    margin-bottom: 0.75rem;
                    transition: all 0.2s;
                    cursor: pointer;
                }

                .bus-card:hover {
                    border-color: #66bb6a;
                    box-shadow: 0 4px 8px rgba(102, 187, 106, 0.2);
                }

                .bus-card.selected {
                    border-color: #66bb6a;
                    background: #f1f8f4;
                }
            </style>
        </head>

        <body>
            <jsp:include page="../partials/admin-header.jsp" />

            <div class="container mt-4 mb-5">
                <div class="header-section">
                    <div class="row align-items-center">
                        <div class="col-md-8">
                            <h3 class="mb-0">
                                <i class="fas fa-exchange-alt me-2"></i>Replace Bus
                            </h3>
                            <p class="mb-0 mt-2 opacity-75">Replace bus when bus has accident or breakdown</p>
                        </div>
                        <div class="col-md-4 text-md-end">
                            <a href="${pageContext.request.contextPath}/admin/schedules" class="btn btn-light">
                                <i class="fas fa-arrow-left me-1"></i>Back to Schedules
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Alert Messages -->
                <c:if test="${not empty param.error}">
                    <div class="alert alert-danger alert-dismissible fade show">
                        <i class="fas fa-exclamation-circle me-2"></i>${param.error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <c:if test="${not empty schedule}">
                    <!-- Schedule Info -->
                    <div class="info-card">
                        <h5 class="mb-3"><i class="fas fa-calendar-alt me-2"></i>Schedule Information</h5>
                        <div class="row">
                            <div class="col-md-6">
                                <p><strong>Route:</strong> ${schedule.routeName}</p>
                                <p><strong>From:</strong> ${schedule.departureCity}</p>
                                <p><strong>To:</strong> ${schedule.destinationCity}</p>
                            </div>
                            <div class="col-md-6">
                                <p><strong>Date:</strong> ${schedule.departureDate}</p>
                                <p><strong>Departure:</strong> ${schedule.departureTime}</p>
                                <p><strong>Arrival:</strong> ${schedule.estimatedArrivalTime}</p>
                            </div>
                        </div>
                    </div>

                    <!-- Current Bus Info -->
                    <c:if test="${not empty currentBus}">
                        <div class="info-card bg-warning bg-opacity-10">
                            <h5 class="mb-3"><i class="fas fa-bus me-2"></i>Current Bus</h5>
                            <div class="row">
                                <div class="col-md-4">
                                    <p><strong>Bus Number:</strong> ${currentBus.busNumber}</p>
                                </div>
                                <div class="col-md-4">
                                    <p><strong>License Plate:</strong> ${currentBus.licensePlate}</p>
                                </div>
                                <div class="col-md-4">
                                    <p><strong>Total Seats:</strong> ${currentBus.totalSeats}</p>
                                </div>
                            </div>
                        </div>
                    </c:if>

                    <!-- Replace Bus Form -->
                    <div class="info-card">
                        <h5 class="mb-3"><i class="fas fa-exchange-alt me-2"></i>Select New Bus</h5>
                        <form method="post" action="${pageContext.request.contextPath}/admin/schedules/replace-bus">
                            <input type="hidden" name="scheduleId" value="${schedule.scheduleId}">

                            <div class="mb-3">
                                <label class="form-label"><strong>Reason for replacement (optional)</strong></label>
                                <textarea class="form-control" name="reason" rows="3"
                                    placeholder="Example: Bus had accident, bus broke down..."></textarea>
                                <small class="text-muted">If reason is accident or breakdown, old bus will be marked as
                                    MAINTENANCE</small>
                            </div>

                            <div class="mb-3">
                                <label class="form-label"><strong>Available Buses</strong></label>
                                <c:choose>
                                    <c:when test="${not empty availableBuses}">
                                        <div class="row">
                                            <c:forEach var="bus" items="${availableBuses}">
                                                <div class="col-md-6 mb-2">
                                                    <div class="bus-card" onclick="selectBus('${bus.busId}', this)">
                                                        <input type="radio" name="newBusId" value="${bus.busId}"
                                                            id="bus-${bus.busId}" style="display: none;" required>
                                                        <div class="d-flex justify-content-between align-items-center">
                                                            <div>
                                                                <strong><i
                                                                        class="fas fa-bus me-2"></i>${bus.busNumber}</strong>
                                                                <div class="small text-muted mt-1">
                                                                    <i
                                                                        class="fas fa-id-card me-1"></i>${bus.licensePlate}
                                                                </div>
                                                                <div class="small text-muted">
                                                                    <i class="fas fa-chair me-1"></i>${bus.totalSeats}
                                                                    seats
                                                                </div>
                                                            </div>
                                                            <div>
                                                                <i class="fas fa-check-circle text-success"
                                                                    style="display: none;"></i>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="alert alert-warning">
                                            <i class="fas fa-exclamation-triangle me-2"></i>
                                            No available buses found. Please add more buses first.
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div class="d-flex justify-content-end gap-2">
                                <a href="${pageContext.request.contextPath}/admin/schedules" class="btn btn-secondary">
                                    <i class="fas fa-times me-1"></i>Cancel
                                </a>
                                <button type="submit" class="btn btn-primary" ${empty availableBuses ? 'disabled' : ''
                                    }>
                                    <i class="fas fa-exchange-alt me-1"></i>Replace Bus
                                </button>
                            </div>
                        </form>
                    </div>
                </c:if>
            </div>

            <jsp:include page="../partials/footer.jsp" />

            <script>
                function selectBus(busId, element) {
                    // Remove selection from all cards
                    document.querySelectorAll('.bus-card').forEach(card => {
                        card.classList.remove('selected');
                        card.querySelector('i.fa-check-circle').style.display = 'none';
                    });

                    // Select this bus
                    element.classList.add('selected');
                    element.querySelector('i.fa-check-circle').style.display = 'inline';
                    document.getElementById('bus-' + busId).checked = true;
                }
            </script>
        </body>

        </html>