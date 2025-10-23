<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Error - BusTicket System</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
            <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
            <style>
                body {
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    min-height: 100vh;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                }

                .error-container {
                    background: white;
                    border-radius: 15px;
                    box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
                    overflow: hidden;
                    width: 100%;
                    max-width: 500px;
                    text-align: center;
                }

                .error-header {
                    background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
                    color: white;
                    padding: 40px 30px;
                }

                .error-body {
                    padding: 40px;
                }

                .error-icon {
                    font-size: 4rem;
                    margin-bottom: 20px;
                }

                .error-code {
                    font-size: 3rem;
                    font-weight: bold;
                    margin-bottom: 10px;
                }

                .error-message {
                    font-size: 1.2rem;
                    margin-bottom: 30px;
                    color: #6c757d;
                }

                .btn-home {
                    background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
                    border: none;
                    border-radius: 10px;
                    padding: 12px 30px;
                    font-weight: 600;
                    transition: all 0.3s ease;
                }

                .btn-home:hover {
                    transform: translateY(-2px);
                    box-shadow: 0 5px 15px rgba(0, 123, 255, 0.4);
                }

                .error-details {
                    background: #f8f9fa;
                    border-radius: 8px;
                    padding: 20px;
                    margin-top: 20px;
                    text-align: left;
                }

                .error-details pre {
                    margin: 0;
                    font-size: 0.9rem;
                    color: #6c757d;
                }
            </style>
        </head>

        <body>
            <div class="error-container">
                <div class="error-header">
                    <i class="fas fa-exclamation-triangle error-icon"></i>
                    <div class="error-code">Oops!</div>
                    <h3>An error occurred</h3>
                </div>

                <div class="error-body">
                    <div class="error-message">
                        <c:choose>
                            <c:when test="${not empty error}">
                                ${error}
                            </c:when>
                            <c:otherwise>
                                An error occurred while processing your request.
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="d-flex justify-content-center gap-3">
                        <a href="${pageContext.request.contextPath}/" class="btn btn-primary btn-home">
                            <i class="fas fa-home me-2"></i>Go to Home
                        </a>
                        <button type="button" class="btn btn-outline-secondary" onclick="history.back()">
                            <i class="fas fa-arrow-left me-2"></i>Go Back
                        </button>
                    </div>

                    <c:if test="${not empty pageContext.exception}">
                        <div class="error-details">
                            <h6><i class="fas fa-bug me-2"></i>Error Details:</h6>
                            <pre>${pageContext.exception}</pre>
                        </div>
                    </c:if>

                    <div class="mt-4">
                        <p class="text-muted">
                            <i class="fas fa-info-circle me-1"></i>
                            If the error continues to occur, please contact the administrator.
                        </p>
                    </div>
                </div>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>