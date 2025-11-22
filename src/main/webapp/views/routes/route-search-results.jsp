<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <jsp:include page="/views/partials/head.jsp">
                    <jsp:param name="title" value="Search Results - Bus Booking System" />
                </jsp:include>
                <style>
                    :root {
                        --primary-gradient: linear-gradient(135deg, #66bb6a 0%, #81c784 100%);
                        --secondary-gradient: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
                        --success-color: #10b981;
                        --text-dark: #1e293b;
                        --text-light: #64748b;
                        --card-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
                        --card-shadow-hover: 0 20px 40px rgba(0, 0, 0, 0.15);
                    }

                    body {
                        font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
                        background: #f8fafc;
                        min-height: 100vh;
                        display: flex;
                        flex-direction: column;
                    }

                    /* Hero Section */
                    .search-hero {
                        background: var(--primary-gradient);
                        color: white;
                        padding: 60px 0 40px;
                        position: relative;
                        overflow: hidden;
                        margin-bottom: 40px;
                    }

                    .search-hero::before {
                        content: '';
                        position: absolute;
                        top: -50%;
                        right: -10%;
                        width: 500px;
                        height: 500px;
                        background: rgba(255, 255, 255, 0.1);
                        border-radius: 50%;
                        transform: rotate(45deg);
                    }

                    .search-hero::after {
                        content: '';
                        position: absolute;
                        bottom: -30%;
                        left: -5%;
                        width: 400px;
                        height: 400px;
                        background: rgba(255, 255, 255, 0.08);
                        border-radius: 50%;
                    }

                    .search-hero-content {
                        position: relative;
                        z-index: 2;
                    }

                    .search-title {
                        font-size: 2.5rem;
                        font-weight: 700;
                        margin-bottom: 1rem;
                        text-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
                    }

                    .search-subtitle {
                        font-size: 1.25rem;
                        opacity: 0.95;
                        margin-bottom: 1.5rem;
                    }

                    .date-badges {
                        display: flex;
                        gap: 12px;
                        flex-wrap: wrap;
                        justify-content: center;
                        margin-top: 1.5rem;
                    }

                    .date-badge {
                        background: rgba(255, 255, 255, 0.2);
                        backdrop-filter: blur(10px);
                        border: 1px solid rgba(255, 255, 255, 0.3);
                        padding: 10px 20px;
                        border-radius: 25px;
                        font-size: 0.95rem;
                        font-weight: 500;
                        display: inline-flex;
                        align-items: center;
                        gap: 8px;
                    }

                    /* Route Cards */
                    .route-card {
                        background: white;
                        border: none;
                        border-radius: 20px;
                        box-shadow: var(--card-shadow);
                        transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
                        overflow: hidden;
                        height: 100%;
                        display: flex;
                        flex-direction: column;
                        position: relative;
                    }

                    .route-card::before {
                        content: '';
                        position: absolute;
                        top: 0;
                        left: 0;
                        right: 0;
                        height: 5px;
                        background: var(--primary-gradient);
                        transform: scaleX(0);
                        transform-origin: left;
                        transition: transform 0.4s ease;
                    }

                    .route-card:hover {
                        transform: translateY(-10px) scale(1.02);
                        box-shadow: var(--card-shadow-hover);
                    }

                    .route-card:hover::before {
                        transform: scaleX(1);
                    }

                    .route-card-header {
                        padding: 1.75rem 1.75rem 1rem;
                        background: linear-gradient(135deg, #f8fafc 0%, #ffffff 100%);
                        border-bottom: 1px solid #e2e8f0;
                    }

                    .route-name {
                        font-size: 1.35rem;
                        font-weight: 700;
                        color: var(--text-dark);
                        margin-bottom: 0.5rem;
                        display: flex;
                        align-items: center;
                        gap: 10px;
                    }

                    .route-name i {
                        color: #66bb6a;
                        font-size: 1.2rem;
                    }

                    .route-path {
                        display: flex;
                        align-items: center;
                        gap: 12px;
                        margin-top: 1rem;
                        padding: 12px;
                        background: #f1f5f9;
                        border-radius: 12px;
                    }

                    .route-city {
                        display: flex;
                        align-items: center;
                        gap: 8px;
                        font-weight: 600;
                        color: var(--text-dark);
                        font-size: 1rem;
                    }

                    .route-city.departure i {
                        color: #66bb6a;
                        font-size: 1.1rem;
                    }

                    .route-city.destination i {
                        color: #f5576c;
                        font-size: 1.1rem;
                    }

                    .route-arrow {
                        color: var(--text-light);
                        font-size: 1.2rem;
                        flex: 1;
                        text-align: center;
                    }

                    .route-card-body {
                        padding: 1.5rem 1.75rem;
                        flex: 1;
                    }

                    .route-info-grid {
                        display: grid;
                        grid-template-columns: repeat(2, 1fr);
                        gap: 1rem;
                        margin-bottom: 1.5rem;
                    }

                    .route-info-item {
                        text-align: center;
                        padding: 12px;
                        background: #f8fafc;
                        border-radius: 12px;
                        transition: all 0.3s ease;
                    }

                    .route-card:hover .route-info-item {
                        background: #f1f5f9;
                        transform: translateY(-2px);
                    }

                    .route-info-icon {
                        font-size: 1.5rem;
                        margin-bottom: 8px;
                        color: #66bb6a;
                    }

                    .route-info-label {
                        font-size: 0.75rem;
                        color: var(--text-light);
                        text-transform: uppercase;
                        letter-spacing: 0.5px;
                        font-weight: 600;
                        margin-bottom: 4px;
                    }

                    .route-info-value {
                        font-size: 1rem;
                        font-weight: 700;
                        color: var(--text-dark);
                    }

                    .route-price {
                        text-align: center;
                        padding: 1rem;
                        background: linear-gradient(135deg, #10b981 0%, #059669 100%);
                        color: white;
                        border-radius: 12px;
                        margin-bottom: 1.5rem;
                    }

                    .route-price-label {
                        font-size: 0.85rem;
                        opacity: 0.9;
                        margin-bottom: 4px;
                    }

                    .route-price-value {
                        font-size: 1.75rem;
                        font-weight: 700;
                    }

                    .route-card-footer {
                        padding: 0 1.75rem 1.75rem;
                    }

                    .btn-view-schedules {
                        width: 100%;
                        padding: 14px 24px;
                        background: var(--primary-gradient);
                        color: white;
                        border: none;
                        border-radius: 12px;
                        font-weight: 600;
                        font-size: 1rem;
                        transition: all 0.3s ease;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        gap: 8px;
                    }

                    .btn-view-schedules:hover {
                        transform: translateY(-2px);
                        box-shadow: 0 8px 20px rgba(102, 187, 106, 0.4);
                        color: white;
                    }

                    .btn-view-schedules:active {
                        transform: translateY(0);
                    }

                    /* Empty State */
                    .empty-state {
                        text-align: center;
                        padding: 80px 20px;
                        background: white;
                        border-radius: 20px;
                        box-shadow: var(--card-shadow);
                    }

                    .empty-state-icon {
                        font-size: 5rem;
                        color: var(--text-light);
                        margin-bottom: 1.5rem;
                        opacity: 0.5;
                    }

                    .empty-state-title {
                        font-size: 1.5rem;
                        font-weight: 600;
                        color: var(--text-dark);
                        margin-bottom: 0.5rem;
                    }

                    .empty-state-text {
                        color: var(--text-light);
                        font-size: 1rem;
                    }

                    /* Error Alert */
                    .alert-custom {
                        border: none;
                        border-radius: 16px;
                        padding: 1.25rem 1.5rem;
                        box-shadow: 0 4px 12px rgba(239, 68, 68, 0.15);
                        margin-bottom: 2rem;
                    }

                    /* Return Routes Section */
                    .return-routes-section {
                        margin-top: 60px;
                        padding-top: 40px;
                        border-top: 2px solid #e2e8f0;
                    }

                    .section-header {
                        display: flex;
                        align-items: center;
                        gap: 12px;
                        margin-bottom: 2rem;
                    }

                    .section-header-icon {
                        width: 50px;
                        height: 50px;
                        background: var(--secondary-gradient);
                        border-radius: 12px;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        color: white;
                        font-size: 1.5rem;
                    }

                    .section-header-title {
                        font-size: 1.75rem;
                        font-weight: 700;
                        color: var(--text-dark);
                        margin: 0;
                    }

                    /* Responsive */
                    @media (max-width: 768px) {
                        .search-title {
                            font-size: 1.75rem;
                        }

                        .search-subtitle {
                            font-size: 1rem;
                        }

                        .route-info-grid {
                            grid-template-columns: 1fr;
                            gap: 0.75rem;
                        }

                        .route-path {
                            flex-direction: column;
                            gap: 8px;
                        }

                        .route-arrow {
                            transform: rotate(90deg);
                        }
                    }

                    /* Animation */
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

                    .route-card {
                        animation: fadeInUp 0.6s ease forwards;
                    }

                    .route-card:nth-child(1) { animation-delay: 0.1s; }
                    .route-card:nth-child(2) { animation-delay: 0.2s; }
                    .route-card:nth-child(3) { animation-delay: 0.3s; }
                    .route-card:nth-child(4) { animation-delay: 0.4s; }
                    .route-card:nth-child(5) { animation-delay: 0.5s; }
                    .route-card:nth-child(6) { animation-delay: 0.6s; }
                </style>
            </head>

            <body>
                <%@ include file="/views/partials/user-header.jsp" %>
                
                <!-- Hero Section -->
                <section class="search-hero">
                    <div class="container search-hero-content">
                        <div class="text-center">
                            <h1 class="search-title">
                                <i class="fas fa-search me-3"></i>Search Results
                            </h1>
                            <p class="search-subtitle">
                                From <strong>${departureCity}</strong> to <strong>${destinationCity}</strong>
                            </p>
                            <div class="date-badges">
                                <c:if test="${not empty departureDate}">
                                    <span class="date-badge">
                                        <i class="fas fa-calendar-alt"></i>
                                        <span>Depart: ${departureDate}</span>
                                    </span>
                                </c:if>
                                <c:if test="${not empty returnDate}">
                                    <span class="date-badge">
                                        <i class="fas fa-calendar-alt"></i>
                                        <span>Return: ${returnDate}</span>
                                    </span>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- Main Content -->
                <div class="container mb-5" style="flex: 1;">
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-custom alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-circle me-2"></i>${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <c:choose>
                        <c:when test="${empty routes}">
                            <div class="empty-state">
                                <div class="empty-state-icon">
                                    <i class="fas fa-route"></i>
                                </div>
                                <h3 class="empty-state-title">No routes found</h3>
                                <p class="empty-state-text">Sorry, we couldn't find any routes matching your search.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="row g-4">
                                <c:forEach var="route" items="${routes}">
                                    <div class="col-md-6 col-lg-4">
                                        <div class="route-card">
                                            <div class="route-card-header">
                                                <h5 class="route-name">
                                                    <i class="fas fa-route"></i>
                                                    ${route.routeName}
                                                </h5>
                                                <div class="route-path">
                                                    <span class="route-city departure">
                                                        <i class="fas fa-map-marker-alt"></i>
                                                        ${route.departureCity}
                                                    </span>
                                                    <span class="route-arrow">
                                                        <i class="fas fa-arrow-right"></i>
                                                    </span>
                                                    <span class="route-city destination">
                                                        <i class="fas fa-map-marker-alt"></i>
                                                        ${route.destinationCity}
                                                    </span>
                                                </div>
                                            </div>
                                            <div class="route-card-body">
                                                <div class="route-info-grid">
                                                    <div class="route-info-item">
                                                        <div class="route-info-icon">
                                                            <i class="fas fa-road"></i>
                                                        </div>
                                                        <div class="route-info-label">Distance</div>
                                                        <div class="route-info-value">${route.distance} km</div>
                                                    </div>
                                                    <div class="route-info-item">
                                                        <div class="route-info-icon">
                                                            <i class="fas fa-clock"></i>
                                                        </div>
                                                        <div class="route-info-label">Duration</div>
                                                        <div class="route-info-value">${route.durationHours} hours</div>
                                                    </div>
                                                </div>
                                                <div class="route-price">
                                                    <div class="route-price-label">Price from</div>
                                                    <div class="route-price-value">
                                                        <fmt:formatNumber value="${route.basePrice}" pattern="#,###"/> ₫
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="route-card-footer">
                                                <c:choose>
                                                    <c:when test="${not empty departureDate}">
                                                        <a class="btn btn-view-schedules" 
                                                           href="${pageContext.request.contextPath}/search/schedules?routeId=${route.routeId}&departureDate=${departureDate}">
                                                            <i class="fas fa-calendar-alt"></i>
                                                            <span>View schedules</span>
                                                        </a>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <a class="btn btn-view-schedules" 
                                                           href="${pageContext.request.contextPath}/search/schedules?routeId=${route.routeId}">
                                                            <i class="fas fa-calendar-alt"></i>
                                                            <span>View schedules</span>
                                                        </a>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>

                    <!-- Return Routes Section -->
                    <c:if test="${tripType eq 'roundtrip'}">
                        <div class="return-routes-section">
                            <div class="section-header">
                                <div class="section-header-icon">
                                    <i class="fas fa-exchange-alt"></i>
                                </div>
                                <h2 class="section-header-title">Return routes</h2>
                            </div>
                            <c:choose>
                                <c:when test="${empty returnRoutes}">
                                    <div class="alert alert-info alert-custom">
                                        <i class="fas fa-info-circle me-2"></i>No return routes found
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="row g-4">
                                        <c:forEach var="route" items="${returnRoutes}">
                                            <div class="col-md-6 col-lg-4">
                                                <div class="route-card">
                                                    <div class="route-card-header">
                                                        <h5 class="route-name">
                                                            <i class="fas fa-route"></i>
                                                            ${route.routeName}
                                                        </h5>
                                                        <div class="route-path">
                                                            <span class="route-city departure">
                                                                <i class="fas fa-map-marker-alt"></i>
                                                                ${route.departureCity}
                                                            </span>
                                                            <span class="route-arrow">
                                                                <i class="fas fa-arrow-right"></i>
                                                            </span>
                                                            <span class="route-city destination">
                                                                <i class="fas fa-map-marker-alt"></i>
                                                                ${route.destinationCity}
                                                            </span>
                                                        </div>
                                                    </div>
                                                    <div class="route-card-body">
                                                        <div class="route-info-grid">
                                                            <div class="route-info-item">
                                                                <div class="route-info-icon">
                                                                    <i class="fas fa-road"></i>
                                                                </div>
                                                                <div class="route-info-label">Distance</div>
                                                                <div class="route-info-value">${route.distance} km</div>
                                                            </div>
                                                            <div class="route-info-item">
                                                                <div class="route-info-icon">
                                                                    <i class="fas fa-clock"></i>
                                                                </div>
                                                                <div class="route-info-label">Duration</div>
                                                                <div class="route-info-value">${route.durationHours} hours</div>
                                                            </div>
                                                        </div>
                                                        <div class="route-price">
                                                            <div class="route-price-label">Price from</div>
                                                            <div class="route-price-value">
                                                                <fmt:formatNumber value="${route.basePrice}" pattern="#,###"/> ₫
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="route-card-footer">
                                                        <c:choose>
                                                            <c:when test="${not empty returnDate}">
                                                                <a class="btn btn-view-schedules" 
                                                                   href="${pageContext.request.contextPath}/search/schedules?routeId=${route.routeId}&departureDate=${returnDate}">
                                                                    <i class="fas fa-calendar-alt"></i>
                                                                    <span>View schedules</span>
                                                                </a>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <a class="btn btn-view-schedules" 
                                                                   href="${pageContext.request.contextPath}/search/schedules?routeId=${route.routeId}">
                                                                    <i class="fas fa-calendar-alt"></i>
                                                                    <span>View schedules</span>
                                                                </a>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:if>
                </div>

                <%@ include file="/views/partials/footer.jsp" %>
            </body>

            </html>