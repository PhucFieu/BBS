<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Ticket Analytics - Bus Management System</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
                <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
                <style>
                    :root {
                        --primary: #2563eb;
                        --success: #10b981;
                        --warning: #f59e0b;
                        --danger: #ef4444;
                        --surface: #ffffff;
                        --bg: #f6f8fb;
                        --border: #e5e7eb;
                        --muted: #64748b;
                    }

                    body {
                        background: var(--bg);
                    }

                    .page-header {
                        background: var(--surface);
                        border-bottom: 1px solid var(--border);
                    }

                    .page-title {
                        font-weight: 700;
                    }

                    .kpi-card {
                        background: var(--surface);
                        border: 1px solid var(--border);
                        border-radius: .75rem;
                    }

                    .kpi-icon {
                        width: 40px;
                        height: 40px;
                        border-radius: 50%;
                        display: inline-flex;
                        align-items: center;
                        justify-content: center;
                        color: #fff;
                        font-size: .9rem;
                    }

                    .kpi-total {
                        background: var(--primary);
                    }

                    .kpi-confirmed {
                        background: var(--success);
                    }

                    .kpi-pending {
                        background: var(--warning);
                    }

                    .kpi-cancelled {
                        background: var(--danger);
                    }

                    .filters {
                        background: var(--surface);
                        border: 1px solid var(--border);
                        border-radius: .75rem;
                    }

                    .chart-card {
                        background: var(--surface);
                        border: 1px solid var(--border);
                        border-radius: .75rem;
                        padding: 1rem;
                    }

                    .chart-title {
                        font-weight: 600;
                    }

                    .chart-container {
                        height: 320px;
                    }

                    .recent-tickets {
                        background: var(--surface);
                        border: 1px solid var(--border);
                        border-radius: .75rem;
                    }

                    .ticket-status {
                        font-size: .8rem;
                        border-radius: 20px;
                        padding: .25rem .55rem;
                    }

                    .status-confirmed {
                        background: rgba(16, 185, 129, .12);
                        color: var(--success);
                    }

                    .status-pending {
                        background: rgba(245, 158, 11, .12);
                        color: var(--warning);
                    }

                    .status-cancelled {
                        background: rgba(239, 68, 68, .12);
                        color: var(--danger);
                    }
                </style>
            </head>

            <body>
                <div class="container-fluid px-3 px-lg-4 py-3">
                    <div
                        class="page-header rounded-3 px-3 px-lg-4 py-3 mb-3 d-flex align-items-center justify-content-between flex-wrap gap-2">
                        <div>
                            <h1 class="page-title h3 mb-1">
                                <i class="fas fa-chart-line me-2 text-primary"></i>Ticket Analytics
                            </h1>
                            <p class="text-muted mb-0">Phân tích và trực quan hóa số liệu vé</p>
                        </div>
                        <div>
                            <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/admin/tickets"><i
                                    class="fas fa-arrow-left me-2"></i>Back to list</a>
                        </div>
                    </div>

                    <div class="filters p-3 mb-3">
                        <form method="get" action="${pageContext.request.contextPath}/admin/tickets/analytics"
                            id="analyticsForm" class="row g-2">
                            <div class="col-6 col-md-3">
                                <label for="dateFrom" class="form-label mb-1">From date</label>
                                <input type="date" class="form-control" id="dateFrom" name="dateFrom"
                                    value="${param.dateFrom}">
                            </div>
                            <div class="col-6 col-md-3">
                                <label for="dateTo" class="form-label mb-1">To date</label>
                                <input type="date" class="form-control" id="dateTo" name="dateTo"
                                    value="${param.dateTo}">
                            </div>
                            <div class="col-6 col-md-3">
                                <label for="statusFilter" class="form-label mb-1">Status</label>
                                <select class="form-select" id="statusFilter" name="status">
                                    <option value="">All</option>
                                    <option value="CONFIRMED" ${param.status=='CONFIRMED' ? 'selected' : '' }>Confirmed
                                    </option>
                                    <option value="PENDING" ${param.status=='PENDING' ? 'selected' : '' }>Pending
                                    </option>
                                    <option value="CANCELLED" ${param.status=='CANCELLED' ? 'selected' : '' }>Cancelled
                                    </option>
                                </select>
                            </div>
                            <div class="col-6 col-md-2">
                                <label for="periodFilter" class="form-label mb-1">Period</label>
                                <select class="form-select" id="periodFilter" name="period">
                                    <option value="7" ${param.period=='7' ? 'selected' : '' }>Last 7 days</option>
                                    <option value="30" ${param.period=='30' ? 'selected' : '' }>Last 30 days</option>
                                    <option value="90" ${param.period=='90' ? 'selected' : '' }>Last 90 days</option>
                                    <option value="365" ${param.period=='365' ? 'selected' : '' }>Last year</option>
                                </select>
                            </div>
                            <div class="col-12 col-md-1 d-flex align-items-end">
                                <button type="submit" class="btn btn-primary w-100">
                                    <i class="fas fa-rotate me-1"></i>Update
                                </button>
                            </div>
                        </form>
                    </div>

                    <div class="row g-3 mb-3">
                        <div class="col-6 col-lg-3">
                            <div class="kpi-card p-3">
                                <div class="d-flex align-items-center justify-content-between">
                                    <div>
                                        <div class="text-muted small">Total Tickets</div>
                                        <div class="h4 mb-0">${ticketStats.totalTickets}</div>
                                    </div>
                                    <div class="kpi-icon kpi-total"><i class="fas fa-ticket-alt"></i></div>
                                </div>
                            </div>
                        </div>
                        <div class="col-6 col-lg-3">
                            <div class="kpi-card p-3">
                                <div class="d-flex align-items-center justify-content-between">
                                    <div>
                                        <div class="text-muted small">Confirmed</div>
                                        <div class="h4 mb-0">${ticketStats.confirmedTickets}</div>
                                    </div>
                                    <div class="kpi-icon kpi-confirmed"><i class="fas fa-check"></i></div>
                                </div>
                            </div>
                        </div>
                        <div class="col-6 col-lg-3">
                            <div class="kpi-card p-3">
                                <div class="d-flex align-items-center justify-content-between">
                                    <div>
                                        <div class="text-muted small">Pending</div>
                                        <div class="h4 mb-0">${ticketStats.pendingTickets}</div>
                                    </div>
                                    <div class="kpi-icon kpi-pending"><i class="fas fa-clock"></i></div>
                                </div>
                            </div>
                        </div>
                        <div class="col-6 col-lg-3">
                            <div class="kpi-card p-3">
                                <div class="d-flex align-items-center justify-content-between">
                                    <div>
                                        <div class="text-muted small">Cancelled</div>
                                        <div class="h4 mb-0">${ticketStats.cancelledTickets}</div>
                                    </div>
                                    <div class="kpi-icon kpi-cancelled"><i class="fas fa-times"></i></div>
                                </div>
                            </div>
                        </div>
                        <div class="col-12">
                            <div class="kpi-card p-3">
                                <div class="d-flex align-items-center justify-content-between">
                                    <div>
                                        <div class="text-muted small">Total Revenue</div>
                                        <div class="h4 mb-0">
                                            <fmt:formatNumber value="${ticketStats.totalRevenue}" pattern="#,###" /> ₫
                                        </div>
                                    </div>
                                    <div class="kpi-icon" style="background:#8b5cf6;"><i class="fas fa-dollar-sign"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="row g-3">
                        <div class="col-12 col-xl-6">
                            <div class="chart-card h-100">
                                <div class="chart-title mb-2"><i class="fas fa-chart-pie me-2"></i>Status Distribution
                                </div>
                                <div class="chart-container"><canvas id="statusChart"></canvas></div>
                            </div>
                        </div>
                        <div class="col-12 col-xl-6">
                            <div class="chart-card h-100">
                                <div class="chart-title mb-2"><i class="fas fa-chart-line me-2"></i>Booking Trend</div>
                                <div class="chart-container"><canvas id="trendChart"></canvas></div>
                            </div>
                        </div>
                        <div class="col-12 col-xl-6">
                            <div class="chart-card h-100">
                                <div class="chart-title mb-2"><i class="fas fa-chart-bar me-2"></i>Revenue by Month
                                </div>
                                <div class="chart-container"><canvas id="revenueChart"></canvas></div>
                            </div>
                        </div>
                        <div class="col-12 col-xl-6">
                            <div class="chart-card h-100">
                                <div class="chart-title mb-2"><i class="fas fa-route me-2"></i>Tickets by Route</div>
                                <div class="chart-container"><canvas id="routeChart"></canvas></div>
                            </div>
                        </div>
                    </div>

                    <div class="recent-tickets p-3 mt-3">
                        <h6 class="mb-3"><i class="fas fa-list me-2"></i>Latest Tickets</h6>
                        <c:forEach var="ticket" items="${recentTickets}" varStatus="status">
                            <c:if test="${status.index < 10}">
                                <div class="d-flex align-items-center py-2 border-top"
                                    style="${status.index == 0 ? 'border-top:0;' : ''}">
                                    <div class="flex-grow-1">
                                        <div class="fw-semibold">#${ticket.ticketNumber}</div>
                                        <small class="text-muted">${ticket.departureCity} →
                                            ${ticket.destinationCity}</small>
                                    </div>
                                    <div
                                        class="ticket-status ${ticket.status == 'CONFIRMED' ? 'status-confirmed' : ticket.status == 'PENDING' ? 'status-pending' : 'status-cancelled'}">
                                        <i class="fas fa-circle me-1"></i>
                                        ${ticket.status == 'CONFIRMED' ? 'Confirmed' : ticket.status == 'PENDING' ?
                                        'Pending' : 'Cancelled'}
                                    </div>
                                </div>
                            </c:if>
                        </c:forEach>
                    </div>
                </div>

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                <script>
                    document.addEventListener('DOMContentLoaded', function () {
                        // Status Chart
                        const statusCtx = document.getElementById('statusChart').getContext('2d');
                        new Chart(statusCtx, {
                            type: 'doughnut',
                            data: {
                                labels: ['Confirmed', 'Pending', 'Cancelled'],
                                datasets: [{
                                    data: [${ ticketStats.confirmedTickets }, ${ ticketStats.pendingTickets }, ${ ticketStats.cancelledTickets }],
                                    backgroundColor: [
                                        '#10b981',
                                        '#f59e0b',
                                        '#ef4444'
                                    ],
                                    borderWidth: 0
                                }]
                            },
                            options: {
                                responsive: true,
                                maintainAspectRatio: false,
                                plugins: {
                                    legend: {
                                        position: 'bottom'
                                    }
                                }
                            }
                        });

                        // Trend Chart
                        const trendCtx = document.getElementById('trendChart').getContext('2d');
                        new Chart(trendCtx, {
                            type: 'line',
                            data: {
                                labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
                                datasets: [{
                                    label: 'Tickets',
                                    data: [12, 19, 3, 5, 2, 3, 8],
                                    borderColor: '#2563eb',
                                    backgroundColor: 'rgba(37, 99, 235, 0.1)',
                                    tension: 0.4,
                                    fill: true
                                }]
                            },
                            options: {
                                responsive: true,
                                maintainAspectRatio: false,
                                scales: {
                                    y: {
                                        beginAtZero: true
                                    }
                                }
                            }
                        });

                        // Revenue Chart
                        const revenueCtx = document.getElementById('revenueChart').getContext('2d');
                        new Chart(revenueCtx, {
                            type: 'bar',
                            data: {
                                labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
                                datasets: [{
                                    label: 'Revenue (₫)',
                                    data: [12000000, 19000000, 3000000, 5000000, 2000000, 3000000],
                                    backgroundColor: '#10b981',
                                    borderColor: '#10b981',
                                    borderWidth: 1
                                }]
                            },
                            options: {
                                responsive: true,
                                maintainAspectRatio: false,
                                scales: {
                                    y: {
                                        beginAtZero: true,
                                        ticks: {
                                            callback: function (value) {
                                                return new Intl.NumberFormat('vi-VN').format(value) + '₫';
                                            }
                                        }
                                    }
                                }
                            }
                        });

                        // Route Chart
                        const routeCtx = document.getElementById('routeChart').getContext('2d');
                        new Chart(routeCtx, {
                            type: 'bar',
                            data: {
                                labels: ['Ha Noi - Ho Chi Minh City', 'Ha Noi - Da Nang', 'Ho Chi Minh City - Da Nang', 'Ha Noi - Hai Phong'],
                                datasets: [{
                                    label: 'Tickets',
                                    data: [45, 32, 28, 15],
                                    backgroundColor: '#8b5cf6',
                                    borderColor: '#8b5cf6',
                                    borderWidth: 1
                                }]
                            },
                            options: {
                                responsive: true,
                                maintainAspectRatio: false,
                                indexAxis: 'y',
                                scales: {
                                    x: {
                                        beginAtZero: true
                                    }
                                }
                            }
                        });

                        // Auto-submit form on filter change
                        document.getElementById('periodFilter').addEventListener('change', function () {
                            const period = this.value;
                            const today = new Date();
                            const fromDate = new Date(today.getTime() - (period * 24 * 60 * 60 * 1000));

                            document.getElementById('dateFrom').value = fromDate.toISOString().split('T')[0];
                            document.getElementById('dateTo').value = today.toISOString().split('T')[0];

                            document.getElementById('analyticsForm').submit();
                        });
                    });
                </script>
            </body>

            </html>