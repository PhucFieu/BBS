<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Access Denied - BusTicket System</title>
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
                    background: linear-gradient(135deg, #ffc107 0%, #e0a800 100%);
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

                .permission-info {
                    background: #f8f9fa;
                    border-radius: 8px;
                    padding: 20px;
                    margin-top: 20px;
                    text-align: left;
                }

                .permission-info h6 {
                    color: #495057;
                    margin-bottom: 15px;
                }

                .permission-info ul {
                    margin: 0;
                    padding-left: 20px;
                }

                .permission-info li {
                    margin-bottom: 8px;
                    color: #6c757d;
                }
            </style>
        </head>

        <body>
            <div class="error-container">
                <div class="error-header">
                    <i class="fas fa-lock error-icon"></i>
                    <div class="error-code">403</div>
                    <h3>Access Denied</h3>
                </div>

                <div class="error-body">
                    <div class="error-message">
                        <c:choose>
                            <c:when test="${not empty error}">
                                ${error}
                            </c:when>
                            <c:otherwise>
                                You do not have permission to access this page.
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

                    <div class="permission-info">
                        <h6><i class="fas fa-info-circle me-2"></i>Access Permission Information:</h6>
                        <ul>
                            <li><strong>Customer:</strong> Can only access home page, their tickets and personal profile
                            </li>
                            <li><strong>Staff:</strong> Can access management pages and view tickets</li>
                            <li><strong>Admin:</strong> Has access to all pages</li>
                        </ul>
                    </div>

                    <div class="mt-4">
                        <p class="text-muted">
                            <i class="fas fa-question-circle me-1"></i>
                            If you think this is an error, please contact the administrator.
                        </p>
                    </div>
                </div>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>