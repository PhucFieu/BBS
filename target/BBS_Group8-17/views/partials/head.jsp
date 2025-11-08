<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>

        <!-- Meta tags -->
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">

        <!-- Favicon -->
        <link rel="icon" type="image/x-icon"
            href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'><text y='.9em' font-size='90'>🚌</text></svg>">

        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"
            integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">

        <!-- Font Awesome -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

        <!-- Google Fonts -->
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
            rel="stylesheet">

        <!-- Custom CSS -->
        <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/assets/css/components.css" rel="stylesheet">

        <!-- Page specific CSS -->
        <c:if test="${not empty param.css}">
            <link href="${pageContext.request.contextPath}/assets/css/${param.css}" rel="stylesheet">
        </c:if>

        <!-- Bootstrap JS will be loaded at the end of body for better performance -->

        <!-- Custom JS -->
        <script src="${pageContext.request.contextPath}/assets/js/script.js"></script>

        <!-- Bootstrap loading will be handled in footer -->

        <!-- Page specific JS -->
        <c:if test="${not empty param.js}">
            <script src="${pageContext.request.contextPath}/assets/js/${param.js}"></script>
        </c:if>

        <!-- Additional meta tags for SEO -->
        <meta name="description" content="Online bus ticket booking system - BusTicket System">
        <meta name="keywords" content="bus ticket booking, bus, bus ticket, travel">
        <meta name="author" content="BusTicket System">

        <!-- Open Graph tags -->
        <meta property="og:title" content="BusTicket System - Online Bus Ticket Booking">
        <meta property="og:description" content="Safe and convenient online bus ticket booking system">
        <meta property="og:type" content="website">
        <meta property="og:url" content="${pageContext.request.requestURL}">

        <!-- Page title -->
        <title>${param.title != null ? param.title : 'BusTicket System'}</title>