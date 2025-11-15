<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Print Ticket - Bus Booking System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: #fff;
            -webkit-print-color-adjust: exact;
            print-color-adjust: exact;
        }
        .print-container {
            max-width: 800px;
            margin: 24px auto;
            padding: 24px;
            border: 1px dashed #999;
        }
        .header {
            text-align: center;
            margin-bottom: 16px;
        }
        .ticket-number {
            font-family: 'Courier New', monospace;
            font-size: 20px;
            font-weight: 700;
        }
        .section-title {
            font-weight: 600;
            margin-top: 16px;
            margin-bottom: 8px;
            border-bottom: 1px solid #e9e9e9;
            padding-bottom: 6px;
        }
        .row-item {
            display: flex;
            justify-content: space-between;
            padding: 6px 0;
        }
        .label { color: #666; }
        .value { font-weight: 500; }
        .route {
            text-align: center;
            padding: 12px;
            margin: 8px 0 16px;
            border: 1px solid #e9e9e9;
            border-radius: 8px;
        }
        .controls { margin-bottom: 12px; }
        @media print {
            .no-print { display: none !important; }
            .print-container { border: none; margin: 0; padding: 0; }
        }
    </style>
    <script>
        window.addEventListener('load', function () {
            // Auto open print dialog after load
            window.print();
        });
        function goBackToDetail() {
            window.location.href = '${pageContext.request.contextPath}/tickets/${ticket.ticketId}';
        }
    </script>
</head>

<body>
<div class="container">
    <div class="controls no-print d-flex gap-2 justify-content-end">
        <button class="btn btn-secondary" onclick="goBackToDetail()">Back to details</button>
        <button class="btn btn-primary" onclick="window.print()">Print Ticket</button>
    </div>

    <c:choose>
        <c:when test="${empty ticket}">
            <div class="alert alert-danger">No ticket found to print.</div>
        </c:when>
        <c:otherwise>
            <div class="print-container">
                <div class="header">
                    <h4 class="mb-1">Bus Ticket</h4>
                    <div class="ticket-number">Ticket No.: ${ticket.ticketNumber}</div>
                    <div>
                        <c:choose>
                            <c:when test="${ticket.status eq 'CONFIRMED'}">
                                <span class="badge bg-success">Confirmed</span>
                            </c:when>
                            <c:when test="${ticket.status eq 'PENDING'}">
                                <span class="badge bg-warning text-dark">Pending</span>
                            </c:when>
                            <c:when test="${ticket.status eq 'CANCELLED'}">
                                <span class="badge bg-danger">Cancelled</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-secondary">${ticket.status}</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="route">
                    <div><strong>${ticket.departureCity}</strong> ➜ <strong>${ticket.destinationCity}</strong></div>
                    <small>Route: ${ticket.routeName}</small>
                </div>

                <div class="section">
                    <div class="section-title">Journey Information</div>
                    <div class="row-item">
                        <div class="label">Departure Date</div>
                        <div class="value"><fmt:formatDate value="${ticket.departureDateSql}" pattern="dd/MM/yyyy" /></div>
                    </div>
                    <div class="row-item">
                        <div class="label">Departure Time</div>
                        <div class="value"><fmt:formatDate value="${ticket.departureTimeSql}" pattern="HH:mm" /></div>
                    </div>
                    <div class="row-item">
                        <div class="label">Bus</div>
                        <div class="value">${ticket.busNumber}</div>
                    </div>
                    <div class="row-item">
                        <div class="label">Driver</div>
                        <div class="value">${ticket.driverName}</div>
                    </div>
                </div>

                <div class="section">
                    <div class="section-title">Passenger Information</div>
                    <div class="row-item">
                        <div class="label">Full Name</div>
                        <div class="value">
                            <c:choose>
                                <c:when test="${not empty ticket.userName}">${ticket.userName}</c:when>
                                <c:otherwise>${ticket.passengerName}</c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="row-item">
                        <div class="label">Seat</div>
                        <div class="value">${ticket.seatNumber}</div>
                    </div>
                    <div class="row-item">
                        <div class="label">Ticket Price</div>
                        <div class="value"><fmt:formatNumber value="${ticket.ticketPrice}" type="currency" currencySymbol="₫" maxFractionDigits="0" /></div>
                    </div>
                    <div class="row-item">
                        <div class="label">Payment</div>
                        <div class="value">
                            <c:choose>
                                <c:when test="${ticket.paymentStatus eq 'PAID'}">Paid</c:when>
                                <c:when test="${ticket.paymentStatus eq 'PENDING'}">Pending Payment</c:when>
                                <c:otherwise>${ticket.paymentStatus}</c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <div class="mt-4">
                    <small class="text-muted">Please arrive at the station 30 minutes before departure for check-in.</small>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</div>


</body>
</html>


