<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Schedule - Driver</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
            <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
            <style>
                :root {
                    --primary: #27ae60;
                    --primary-2: #229954;
                    --muted: #6c757d;
                }

                body {
                    background: #f5f7fb;
                }

                .page-header {
                    background: linear-gradient(135deg, var(--primary) 0%, var(--primary-2) 100%);
                    border-radius: 16px;
                    padding: 24px;
                    color: #fff;
                    box-shadow: 0 10px 30px rgba(34, 153, 84, 0.18);
                }

                .filter-card {
                    background: #fff;
                    border-radius: 12px;
                    box-shadow: 0 6px 20px rgba(0, 0, 0, 0.05);
                    margin-top: -36px;
                    position: relative;
                }

                .schedule-table {
                    background: #fff;
                    border-radius: 12px;
                    box-shadow: 0 6px 20px rgba(0, 0, 0, 0.05);
                }

                .badge-status {
                    font-size: 0.85rem;
                }

                .action-btns .btn {
                    margin-right: 6px;
                }

                .pill {
                    background: rgba(39, 174, 96, 0.12);
                    color: var(--primary);
                    border-radius: 999px;
                    padding: 8px 14px;
                    font-weight: 600;
                }
            </style>
        </head>

        <body>
            <jsp:include page="../partials/driver-header.jsp" />

            <div class="container py-4">
                <div class="page-header mb-4">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h3 class="mb-1"><i class="fas fa-calendar-alt me-2"></i>Your Schedule</h3>
                            <p class="mb-0 text-white-50">All trips assigned to you</p>
                        </div>
                        <div class="pill">
                            <i class="fas fa-id-badge me-2"></i>${driver.fullName}
                        </div>
                    </div>
                </div>

                <div class="filter-card p-3 mb-3">
                    <div class="row g-2">
                        <div class="col-md-4">
                            <div class="input-group">
                                <span class="input-group-text bg-white border-0"><i
                                        class="fas fa-search text-muted"></i></span>
                                <input type="text" id="searchInput" class="form-control border-0"
                                    placeholder="Search route..." onkeyup="filterSchedules()">
                            </div>
                        </div>
                        <div class="col-md-3">
                            <select class="form-select border-0" id="statusFilter" onchange="filterSchedules()">
                                <option value="">All Status</option>
                                <option value="SCHEDULED">Scheduled</option>
                                <option value="DEPARTED">Departed</option>
                                <option value="ARRIVED">Arrived</option>
                                <option value="CANCELLED">Cancelled</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <input type="date" id="dateFilter" class="form-control border-0"
                                onchange="filterSchedules()">
                        </div>
                        <div class="col-md-2 text-md-end">
                            <button class="btn btn-outline-secondary w-100" onclick="clearFilters()">
                                <i class="fas fa-times me-1"></i>Clear
                            </button>
                        </div>
                    </div>
                </div>

                <div class="schedule-table table-responsive">
                    <table class="table table-hover mb-0" id="scheduleTable">
                        <thead class="table-light">
                            <tr>
                                <th>Route</th>
                                <th>Date</th>
                                <th>Depart</th>
                                <th>Arrive</th>
                                <th>Bus</th>
                                <th>Status</th>
                                <th class="text-end">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty trips}">
                                    <c:forEach var="trip" items="${trips}">
                                        <tr class="schedule-row" data-status="${trip.status}"
                                            data-date="${trip.departureDate}" data-route="${trip.routeName}">
                                            <td>
                                                <strong>${trip.routeName}</strong><br>
                                                <small class="text-muted"><i
                                                        class="fas fa-map-marker-alt me-1"></i>${trip.departureCity} →
                                                    ${trip.destinationCity}</small>
                                            </td>
                                            <td>${trip.departureDate}</td>
                                            <td><i class="fas fa-clock text-primary me-1"></i>${trip.departureTime}</td>
                                            <td><i
                                                    class="fas fa-clock text-success me-1"></i>${trip.estimatedArrivalTime}
                                            </td>
                                            <td><span class="badge bg-secondary"><i
                                                        class="fas fa-bus me-1"></i>${trip.busNumber}</span></td>
                                            <td>
                                                <span class="badge badge-status
                                            <c:choose>
                                                <c:when test=" ${trip.status=='SCHEDULED' }"> bg-success
                                </c:when>
                                <c:when test="${trip.status == 'DEPARTED'}"> bg-warning text-dark</c:when>
                                <c:when test="${trip.status == 'ARRIVED'}"> bg-info</c:when>
                                <c:when test="${trip.status == 'CANCELLED'}"> bg-danger</c:when>
                                <c:otherwise> bg-secondary</c:otherwise>
                            </c:choose>">
                            ${trip.status}
                            </span>
                            </td>
                            <td class="text-end action-btns">
                                <button class="btn btn-sm btn-outline-primary" data-schedule-id="${trip.scheduleId}"
                                    data-route="${trip.routeName}" onclick="showPassengers(this)">
                                    <i class="fas fa-users"></i>
                                </button>
                                <a class="btn btn-sm btn-outline-success"
                                    href="${pageContext.request.contextPath}/driver/check-in?scheduleId=${trip.scheduleId}">
                                    <i class="fas fa-clipboard-check"></i>
                                </a>
                                <a class="btn btn-sm btn-outline-warning"
                                    href="${pageContext.request.contextPath}/driver/update-status?scheduleId=${trip.scheduleId}">
                                    <i class="fas fa-pen"></i>
                                </a>
                            </td>
                            </tr>
                            </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="7" class="text-center py-5">
                                        <i class="fas fa-calendar-times fa-2x text-muted mb-2"></i>
                                        <div class="text-muted">No schedules assigned</div>
                                    </td>
                                </tr>
                            </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>

                <div id="noResults" class="text-center py-5" style="display:none;">
                    <i class="fas fa-search fa-2x text-muted mb-2"></i>
                    <div class="text-muted">No schedules match your filters</div>
                </div>
            </div>

            <!-- Passengers Modal -->
            <div class="modal fade" id="passengerModal" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog modal-lg modal-dialog-scrollable">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="passengerModalLabel">Passengers</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <div id="passengerLoading" class="text-center py-4">
                                <div class="spinner-border text-success" role="status">
                                    <span class="visually-hidden">Loading...</span>
                                </div>
                            </div>
                            <div id="passengerError" class="alert alert-danger d-none"></div>
                            <div id="passengerEmpty" class="text-center text-muted d-none">No passengers yet.</div>
                            <div id="passengerTable" class="table-responsive d-none">
                                <table class="table table-striped align-middle mb-0">
                                    <thead class="table-light">
                                        <tr>
                                            <th>#</th>
                                            <th>Name</th>
                                            <th>Seat</th>
                                            <th>Boarding</th>
                                            <th>Drop-off</th>
                                            <th>Status</th>
                                        </tr>
                                    </thead>
                                    <tbody id="passengerBody"></tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <%@ include file="/views/partials/footer.jsp" %>
                <script>
                    const ctx = '${pageContext.request.contextPath}';
                    let passengerModal;

                    document.addEventListener('DOMContentLoaded', () => {
                        const modalEl = document.getElementById('passengerModal');
                        if (modalEl) passengerModal = new bootstrap.Modal(modalEl);
                    });

                    function filterSchedules() {
                        const q = document.getElementById('searchInput').value.toLowerCase();
                        const status = document.getElementById('statusFilter').value;
                        const date = document.getElementById('dateFilter').value;
                        const rows = document.querySelectorAll('.schedule-row');
                        let visible = 0;

                        rows.forEach(row => {
                            const route = (row.dataset.route || '').toLowerCase();
                            const st = row.dataset.status;
                            const dt = row.dataset.date;
                            const match = route.includes(q) &&
                                (!status || st === status) &&
                                (!date || dt === date);
                            row.style.display = match ? '' : 'none';
                            if (match) visible++;
                        });

                        document.getElementById('noResults').style.display = visible === 0 ? 'block' : 'none';
                    }

                    function clearFilters() {
                        document.getElementById('searchInput').value = '';
                        document.getElementById('statusFilter').value = '';
                        document.getElementById('dateFilter').value = '';
                        filterSchedules();
                    }

                    async function showPassengers(btn) {
                        if (!passengerModal) return;
                        resetPassengerModal();
                        passengerModal.show();

                        const scheduleId = btn.getAttribute('data-schedule-id');
                        const route = btn.getAttribute('data-route') || '';
                        document.getElementById('passengerModalLabel').textContent = route ? 'Passengers - ' + route : 'Passengers';

                        if (!scheduleId) {
                            showPassengerError('Missing schedule information.');
                            return;
                        }

                        try {
                            const res = await fetch(ctx + '/driver/trip-details?scheduleId=' + encodeURIComponent(scheduleId), {
                                headers: { 'Accept': 'application/json' }
                            });
                            const data = await res.json();
                            if (!res.ok || !data.success) {
                                throw new Error(data.message || 'Failed to load passengers');
                            }
                            if (!Array.isArray(data.passengers) || data.passengers.length === 0) {
                                document.getElementById('passengerEmpty').classList.remove('d-none');
                                return;
                            }
                            renderPassengers(data.passengers);
                        } catch (err) {
                            showPassengerError(err.message);
                        } finally {
                            document.getElementById('passengerLoading').classList.add('d-none');
                        }
                    }

                    function renderPassengers(list) {
                        const tbody = document.getElementById('passengerBody');
                        const table = document.getElementById('passengerTable');
                        const safe = (v, fallback = '') => {
                            if (v === null || v === undefined) return fallback;
                            if (v === false || v === 'false') return fallback;
                            if (typeof v === 'string' && v.trim() === '') return fallback;
                            return v;
                        };
                        list.forEach((p, idx) => {
                            const boardingCity = safe(p.boardingCity, '');
                            const alightingCity = safe(p.alightingCity, '');
                            const name = safe(p.fullName, 'Unknown');
                            const phone = safe(p.phone, '');
                            const seat = p.seatNumber != null ? p.seatNumber : 'N/A';
                            const boarding = safe(p.boardingStation, '');
                            const drop = safe(p.alightingStation, '');
                            const statusClass = p.checkedIn ? 'bg-success'
                                : p.canCheckIn ? 'bg-warning text-dark'
                                    : 'bg-secondary';
                            const statusText = p.checkedIn ? 'Checked-in'
                                : p.canCheckIn ? 'Pending'
                                    : 'Unavailable';

                            const row = document.createElement('tr');
                            row.innerHTML =
                                '<td>' + (idx + 1) + '</td>' +
                                '<td><strong>' + name + '</strong><div class="text-muted small">' + phone + '</div></td>' +
                                '<td><span class="badge bg-primary">' + seat + '</span></td>' +
                                '<td>' + boarding + (boardingCity ? ' (' + boardingCity + ')' : '') + '</td>' +
                                '<td>' + drop + (alightingCity ? ' (' + alightingCity + ')' : '') + '</td>' +
                                '<td><span class="badge ' + statusClass + '">' + statusText + '</span></td>';
                            tbody.appendChild(row);
                        });
                        table.classList.remove('d-none');
                    }

                    function resetPassengerModal() {
                        document.getElementById('passengerLoading').classList.remove('d-none');
                        document.getElementById('passengerError').classList.add('d-none');
                        document.getElementById('passengerEmpty').classList.add('d-none');
                        document.getElementById('passengerTable').classList.add('d-none');
                        document.getElementById('passengerBody').innerHTML = '';
                    }

                    function showPassengerError(msg) {
                        const err = document.getElementById('passengerError');
                        err.textContent = msg;
                        err.classList.remove('d-none');
                    }
                </script>
        </body>

        </html>