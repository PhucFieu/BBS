<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Export Tickets - Ticket Management System</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
                <style>
                    body {
                        font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
                        background: #f8fafc;
                    }

                    .export-header {
                        background: linear-gradient(135deg, #2563eb, #3b82f6);
                        color: white;
                        padding: 2rem;
                        text-align: center;
                        margin-bottom: 2rem;
                    }

                    .export-title {
                        font-size: 2rem;
                        font-weight: 700;
                        margin-bottom: 0.5rem;
                    }

                    .export-subtitle {
                        opacity: 0.9;
                        font-size: 1.1rem;
                    }

                    .export-content {
                        max-width: 1200px;
                        margin: 0 auto;
                        padding: 0 2rem;
                    }

                    .tickets-table {
                        background: white;
                        border-radius: 12px;
                        overflow: hidden;
                        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
                    }

                    .table {
                        margin: 0;
                    }

                    .table th {
                        background: #f8fafc;
                        border: none;
                        padding: 1rem;
                        font-weight: 600;
                        color: #1e293b;
                        font-size: 0.875rem;
                        text-transform: uppercase;
                        letter-spacing: 0.5px;
                    }

                    .table td {
                        padding: 1rem;
                        border: none;
                        border-bottom: 1px solid #e2e8f0;
                        vertical-align: middle;
                    }

                    .ticket-number {
                        font-weight: 600;
                        color: #2563eb;
                    }

                    .status-badge {
                        display: inline-flex;
                        align-items: center;
                        gap: 0.5rem;
                        padding: 0.25rem 0.75rem;
                        border-radius: 20px;
                        font-weight: 500;
                        font-size: 0.875rem;
                    }

                    .status-confirmed {
                        background: rgba(16, 185, 129, 0.1);
                        color: #10b981;
                    }

                    .status-pending {
                        background: rgba(245, 158, 11, 0.1);
                        color: #f59e0b;
                    }

                    .status-cancelled {
                        background: rgba(239, 68, 68, 0.1);
                        color: #ef4444;
                    }

                    .export-footer {
                        text-align: center;
                        padding: 2rem;
                        color: #64748b;
                        font-size: 0.875rem;
                    }

                    @media print {
                        body {
                            background: white;
                        }

                        .export-header {
                            background: #2563eb !important;
                            -webkit-print-color-adjust: exact;
                            color-adjust: exact;
                        }

                        .tickets-table {
                            box-shadow: none;
                            border: 1px solid #e2e8f0;
                        }
                    }
                </style>
            </head>

            <body>
                <div class="export-header">
                    <h1 class="export-title">
                        <i class="fas fa-ticket-alt me-3"></i>
                        Ticket List
                    </h1>
                    <p class="export-subtitle">
                        Exported at:
                        <fmt:formatDate value="<%= new java.util.Date() %>" pattern="dd/MM/yyyy HH:mm" />
                    </p>
                </div>

                <div class="export-content">
                    <div class="tickets-table">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Ticket No.</th>
                                    <th>Passenger</th>
                                    <th>Route</th>
                                    <th>Bus</th>
                                    <th>Departure</th>
                                    <th>Seat</th>
                                    <th>Price</th>
                                    <th>Status</th>
                                    <th>Payment</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="ticket" items="${tickets}">
                                    <tr>
                                        <td>
                                            <span class="ticket-number">#${ticket.ticketNumber}</span>
                                        </td>
                                        <td>
                                            <div>
                                                <div class="fw-bold">${ticket.userName}</div>
                                                <small class="text-muted">${ticket.userEmail}</small>
                                            </div>
                                        </td>
                                        <td>
                                            <div>
                                                <div class="fw-bold">${ticket.departureCity} → ${ticket.destinationCity}
                                                </div>
                                                <small class="text-muted">${ticket.routeName}</small>
                                            </div>
                                        </td>
                                        <td>
                                            <div>
                                                <div class="fw-bold">${ticket.busNumber}</div>
                                                <small class="text-muted">Seat ${ticket.seatNumber}</small>
                                            </div>
                                        </td>
                                        <td>
                                            <div>
                                                <div class="fw-bold">
                                                    <fmt:formatDate value="${ticket.departureDate}"
                                                        pattern="dd/MM/yyyy" />
                                                </div>
                                                <small class="text-muted">
                                                    <fmt:formatDate value="${ticket.departureTime}" pattern="HH:mm" />
                                                </small>
                                            </div>
                                        </td>
                                        <td>
                                            <span class="badge bg-primary">Seat ${ticket.seatNumber}</span>
                                        </td>
                                        <td>
                                            <span class="fw-bold text-success">
                                                <fmt:formatNumber value="${ticket.ticketPrice}" pattern="#,###" />₫
                                            </span>
                                        </td>
                                        <td>
                                            <span
                                                class="status-badge ${ticket.status == 'CONFIRMED' ? 'status-confirmed' : ticket.status == 'PENDING' ? 'status-pending' : 'status-cancelled'}">
                                                <i class="fas fa-circle"></i>
                                                ${ticket.status == 'CONFIRMED' ? 'Confirmed' : ticket.status ==
                                                'PENDING' ? 'Pending' : 'Cancelled'}
                                            </span>
                                        </td>
                                        <td>
                                            <span
                                                class="status-badge ${ticket.paymentStatus == 'PAID' ? 'status-confirmed' : ticket.paymentStatus == 'PENDING' ? 'status-pending' : 'status-cancelled'}">
                                                <i class="fas fa-credit-card"></i>
                                                ${ticket.paymentStatus == 'PAID' ? 'Paid' :
                                                ticket.paymentStatus == 'PENDING' ? 'Pending Payment' : 'Cancelled'}
                                            </span>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="export-footer">
                    <p>Ticket Management System - Export Report</p>
                    <p>Total tickets: ${tickets.size()}</p>
                </div>

                <script>
                    // Auto print when page loads
                    window.onload = function () {
                        window.print();
                    };
                </script>
            </body>

            </html>
