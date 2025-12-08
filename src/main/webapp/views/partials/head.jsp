<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

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
        <style>
            /* ===== GLOBAL STYLES ===== */
            :root {
                --primary-color: #66bb6a;
                --secondary-color: #81c784;
                --success-color: #4caf50;
                --danger-color: #dc3545;
                --warning-color: #ffc107;
                --info-color: #66bb6a;
                --light-color: #e8f5e9;
                --dark-color: #2e7d32;
                --white: #ffffff;
                --gray-100: #e8f5e9;
                --gray-200: #c8e6c9;
                --gray-300: #a5d6a7;
                --gray-400: #81c784;
                --gray-500: #66bb6a;
                --gray-600: #4caf50;
                --gray-700: #388e3c;
                --gray-800: #2e7d32;
                --gray-900: #1b5e20;
                --shadow-sm: 0 0.125rem 0.25rem rgba(102, 187, 106, 0.15);
                --shadow: 0 0.5rem 1rem rgba(102, 187, 106, 0.2);
                --shadow-lg: 0 1rem 3rem rgba(102, 187, 106, 0.25);
                --border-radius: 0.375rem;
                --border-radius-lg: 0.5rem;
                --border-radius-xl: 0.75rem;
                --transition: all 0.3s ease;
            }

            html,
            body {
                height: 100%;
            }

            body {
                font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
                line-height: 1.6;
                color: var(--gray-800);
                background-color: #f1f8f4;
                min-height: 100vh;
                display: flex;
                flex-direction: column;
            }

            /* ===== NAVBAR STYLES ===== */
            .navbar {
                background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%) !important;
                box-shadow: var(--shadow);
                padding: 1rem 0;
            }

            .navbar-brand {
                font-weight: 700;
                font-size: 1.5rem;
                color: var(--white) !important;
                text-decoration: none;
                transition: var(--transition);
            }

            .navbar-brand:hover {
                color: var(--gray-200) !important;
                transform: translateY(-1px);
            }

            .navbar-nav .nav-link {
                color: var(--white) !important;
                font-weight: 500;
                padding: 0.5rem 1rem !important;
                border-radius: var(--border-radius);
                transition: var(--transition);
                margin: 0 0.25rem;
            }

            .navbar-nav .nav-link:hover {
                background-color: rgba(255, 255, 255, 0.1);
                color: var(--white) !important;
                transform: translateY(-1px);
            }

            .dropdown-menu {
                border: none;
                box-shadow: var(--shadow-lg);
                border-radius: var(--border-radius-lg);
                padding: 0.5rem 0;
                display: none;
                position: absolute;
                z-index: 1000;
                min-width: 10rem;
                background-color: var(--white);
                margin-top: 0.5rem;
                animation: dropdownFadeIn 0.2s ease-in-out;
            }

            .dropdown-menu.show {
                display: block;
            }

            @keyframes dropdownFadeIn {
                from {
                    opacity: 0;
                    transform: translateY(-10px);
                }

                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .dropdown-item {
                padding: 0.75rem 1.5rem;
                transition: var(--transition);
                color: var(--gray-700);
                text-decoration: none;
                display: block;
            }

            .dropdown-item:hover {
                background-color: var(--gray-100);
                color: var(--primary-color);
                text-decoration: none;
            }

            .dropdown-toggle::after {
                display: inline-block;
                margin-left: 0.255em;
                vertical-align: 0.255em;
                content: "";
                border-top: 0.3em solid;
                border-right: 0.3em solid transparent;
                border-bottom: 0;
                border-left: 0.3em solid transparent;
                transition: var(--transition);
            }

            .dropdown-toggle[aria-expanded="true"]::after {
                transform: rotate(180deg);
            }

            .navbar-nav .dropdown-menu {
                position: absolute;
                right: 0;
                left: auto;
            }

            /* ===== COMPONENTS CSS ===== */
            /* Search Form Styles */
            .search-form {
                background: #e8f5e9;
                padding: 20px;
                border-radius: 8px;
                margin-bottom: 20px;
                border: 1px solid #c8e6c9;
            }

            /* Card Styles */
            .route-card,
            .bus-card,
            .ticket-card {
                border: none;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                margin-bottom: 20px;
            }

            .route-card:hover,
            .bus-card:hover,
            .ticket-card:hover {
                box-shadow: 0 6px 14px rgba(0, 0, 0, 0.18);
            }

            /* Status Badge Styles */
            .status-badge {
                font-size: 0.9rem;
                padding: 0.5em 0.75em;
            }

            /* Button Styles */
            .btn-action {
                margin: 0 2px;
            }

            /* Stats Card Styles */
            .stats-card {
                background: white;
                border-radius: 10px;
                padding: 20px;
                text-align: center;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            }

            .stats-card:hover {
                box-shadow: 0 6px 14px rgba(0, 0, 0, 0.18);
            }

            .stats-number {
                font-size: 2.5rem;
                font-weight: bold;
                margin-bottom: 10px;
            }

            .stats-label {
                font-size: 1rem;
                color: #6c757d;
                margin-bottom: 10px;
            }

            /* Profile Styles */
            .profile-header {
                background: linear-gradient(135deg, #66bb6a 0%, #81c784 100%);
                color: white;
                padding: 40px 0;
                margin-bottom: 30px;
            }

            .profile-avatar {
                width: 120px;
                height: 120px;
                border-radius: 50%;
                background: rgba(255, 255, 255, 0.2);
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 3rem;
                margin: 0 auto;
            }

            .role-badge {
                padding: 0.5em 1em;
                border-radius: 20px;
                font-size: 0.9rem;
                font-weight: 500;
            }

            .role-admin {
                background-color: #dc3545;
                color: white;
            }

            .role-staff {
                background-color: #fd7e14;
                color: white;
            }

            .role-customer {
                background-color: #66bb6a;
                color: white;
            }

            .profile-card {
                border: none;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                border-radius: 10px;
                margin-bottom: 20px;
            }

            .profile-section {
                margin-bottom: 20px;
            }

            .activity-item {
                display: flex;
                align-items: center;
                padding: 10px 0;
                border-bottom: 1px solid #e9ecef;
            }

            .activity-item:last-child {
                border-bottom: none;
            }

            .activity-icon {
                width: 40px;
                height: 40px;
                border-radius: 50%;
                background: #f8f9fa;
                display: flex;
                align-items: center;
                justify-content: center;
                margin-right: 15px;
                font-size: 1.2rem;
            }

            .activity-content {
                flex: 1;
            }

            .activity-title {
                font-weight: 500;
                margin-bottom: 5px;
            }

            .activity-time {
                font-size: 0.9rem;
                color: #6c757d;
            }

            /* Admin Badge */
            .admin-badge {
                background: linear-gradient(135deg, #2e7d32 0%, #388e3c 100%);
                color: white;
                padding: 0.25em 0.5em;
                border-radius: 4px;
                font-size: 0.75rem;
                font-weight: 500;
            }

            /* Table Styles */
            .table {
                background-color: #ffffff;
                border-collapse: separate;
                border-spacing: 0;
                border-radius: 10px;
                overflow: hidden;
                box-shadow: 0 1px 2px rgba(0, 0, 0, 0.06);
            }

            .table thead tr {
                background: linear-gradient(135deg, #2e7d32 0%, #388e3c 100%);
                color: #fff;
            }

            .table tbody tr {
                background-color: #ffffff;
                transition: none !important;
            }

            .table td,
            .table th {
                transition: none !important;
            }

            .table tbody tr+tr td {
                border-top: 1px solid #f1f3f5;
            }

            .table-hover tbody tr:hover {
                background-color: #ffffff !important;
                filter: drop-shadow(0 3px 10px rgba(0, 0, 0, 0.12));
            }

            /* Modal Styles */
            .modal-content {
                border-radius: 10px;
                border: none;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
            }

            .modal-header {
                border-bottom: 1px solid #e9ecef;
                border-radius: 10px 10px 0 0;
            }

            .modal-footer {
                border-top: 1px solid #e9ecef;
                border-radius: 0 0 10px 10px;
            }

            /* Form Styles */
            .form-control:focus {
                border-color: #66bb6a;
                box-shadow: 0 0 0 0.2rem rgba(102, 187, 106, 0.25);
            }

            .form-select:focus {
                border-color: #66bb6a;
                box-shadow: 0 0 0 0.2rem rgba(102, 187, 106, 0.25);
            }

            /* Price Display */
            .price-info {
                font-weight: bold;
                color: #66bb6a;
                font-size: 1.1rem;
            }

            /* Seat Info */
            .seat-info {
                background-color: #e9ecef;
                padding: 0.25em 0.5em;
                border-radius: 4px;
                font-family: monospace;
                font-weight: bold;
            }

            /* Ticket Number */
            .ticket-number {
                font-family: monospace;
                font-weight: bold;
                color: #495057;
            }

            /* Error and Success Messages */
            .alert {
                border-radius: 8px;
                border: none;
            }

            .alert-success {
                background-color: #d4edda;
                color: #155724;
                border-left: 4px solid #66bb6a;
            }

            .alert-danger {
                background-color: #f8d7da;
                color: #721c24;
                border-left: 4px solid #dc3545;
            }

            .alert-warning {
                background-color: #fff3cd;
                color: #856404;
                border-left: 4px solid #ffc107;
            }

            .alert-info {
                background-color: #d1ecf1;
                color: #0c5460;
                border-left: 4px solid #17a2b8;
            }

            /* ===== FOOTER STYLES ===== */
            footer {
                background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
                color: var(--white);
                padding: 2rem 0;
                margin-top: auto;
            }

            footer a {
                color: var(--gray-300);
                text-decoration: none;
                transition: var(--transition);
            }

            footer a:hover {
                color: var(--white);
            }

            /* ===== SCROLLBAR STYLING ===== */
            ::-webkit-scrollbar {
                width: 8px;
            }

            ::-webkit-scrollbar-track {
                background: var(--gray-200);
            }

            ::-webkit-scrollbar-thumb {
                background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
                border-radius: 4px;
            }

            ::-webkit-scrollbar-thumb:hover {
                background: linear-gradient(135deg, #4caf50 0%, #66bb6a 100%);
            }

            /* ===== ANIMATIONS ===== */
            @keyframes fadeInUp {
                from {
                    opacity: 0;
                    transform: translateY(30px);
                }

                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .fade-in-up {
                animation: fadeInUp 0.6s ease-out;
            }

            .fade-in {
                animation: fadeIn 0.5s ease-in;
            }

            @keyframes fadeIn {
                from {
                    opacity: 0;
                    transform: translateY(20px);
                }

                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            /* Loading Spinner */
            .loading-spinner {
                display: inline-block;
                width: 20px;
                height: 20px;
                border: 3px solid #f3f3f3;
                border-top: 3px solid #66bb6a;
                border-radius: 50%;
                animation: spin 1s linear infinite;
            }

            @keyframes spin {
                0% {
                    transform: rotate(0deg);
                }

                100% {
                    transform: rotate(360deg);
                }
            }

            /* ===== RESPONSIVE DESIGN ===== */
            @media (max-width: 768px) {
                .container {
                    padding: 0 1rem;
                }

                .card-body {
                    padding: 1rem;
                }

                .modal-body {
                    padding: 1rem;
                }

                .btn {
                    padding: 0.5rem 1rem;
                    font-size: 0.875rem;
                }

                .navbar-nav .dropdown-menu {
                    position: static;
                    float: none;
                    width: auto;
                    margin-top: 0;
                    background-color: transparent;
                    border: 0;
                    box-shadow: none;
                }

                .dropdown-menu.show {
                    display: block;
                }

                .stats-number {
                    font-size: 2rem;
                }

                .profile-avatar {
                    width: 80px;
                    height: 80px;
                    font-size: 2rem;
                }

                .search-form {
                    padding: 15px;
                }
            }
        </style>

        <!-- Page specific CSS - Removed: All CSS is now inline in JSP files -->

        <!-- Bootstrap JS will be loaded at the end of body for better performance -->

        <!-- Custom JS -->
        <script src="${pageContext.request.contextPath}/assets/js/script.js"></script>

        <!-- Bootstrap loading will be handled in footer -->

        <!-- Page specific JS -->
        <c:if test="${not empty param.js}">
            <script src="${pageContext.request.contextPath}/assets/js/${param.js}"></script>
        </c:if>

        <!-- Additional meta tags for SEO -->
        <meta name="description" content="Online bus ticket booking system - Bus Booking System">
        <meta name="keywords" content="bus ticket booking, bus, bus ticket, travel">
        <meta name="author" content="Bus Booking System">

        <!-- Open Graph tags -->
        <meta property="og:title" content="Bus Booking System - Online Bus Ticket Booking">
        <meta property="og:description" content="Safe and convenient online bus ticket booking system">
        <meta property="og:type" content="website">
        <meta property="og:url" content="${pageContext.request.requestURL}">

        <!-- Page title -->
        <title>${param.title != null ? param.title : 'Bus Booking System'}</title>