<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <title>${user == null ? 'Add Bus' : 'Edit Bus'} - Bus Booking System</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
            <style>
                /* Driver Form Styles */
                .form-card {
                    background: #fff;
                    border-radius: 18px;
                    box-shadow: 0 8px 32px rgba(102, 187, 106, 0.15);
                    padding: 2.5rem 2rem 2rem 2rem;
                    margin-top: 2rem;
                    margin-bottom: 2rem;
                }

                .form-header {
                    background: linear-gradient(135deg, #66bb6a 0%, #81c784 100%);
                    color: #fff;
                    border-radius: 18px 18px 0 0;
                    padding: 1.5rem 2rem;
                    margin: -2.5rem -2rem 2rem -2rem;
                    box-shadow: 0 4px 16px rgba(102, 187, 106, 0.2);
                }

                .section-title {
                    color: #66bb6a;
                    font-weight: 600;
                    margin-bottom: 1rem;
                    padding-bottom: 0.5rem;
                    border-bottom: 2px solid #c8e6c9;
                }

                .form-label {
                    font-weight: 600;
                }

                .form-control:focus {
                    border-color: #66bb6a;
                    box-shadow: 0 0 0 0.2rem rgba(102, 187, 106, 0.25);
                }

                .btn-gradient {
                    background: linear-gradient(135deg, #66bb6a 0%, #81c784 100%);
                    color: #fff;
                    border: none;
                    border-radius: 25px;
                    padding: 0.75rem 2rem;
                    font-weight: 600;
                    transition: all 0.2s;
                }

                .btn-gradient:hover {
                    background: linear-gradient(135deg, #4caf50 0%, #66bb6a 100%);
                    color: #fff;
                    transform: translateY(-1px);
                }

                /* Passenger Form Styles */
                .form-container {
                    max-width: 900px;
                    margin: 0 auto;
                }

                .form-section {
                    background: #e8f5e9;
                    padding: 20px;
                    border-radius: 8px;
                    margin-bottom: 20px;
                }

                .btn-submit {
                    background: linear-gradient(135deg, #66bb6a 0%, #4caf50 100%);
                    border: none;
                    padding: 12px 30px;
                    font-weight: 600;
                }

                .btn-submit:hover {
                    transform: translateY(-1px);
                    box-shadow: 0 4px 8px rgba(102, 187, 106, 0.3);
                }

                .avatar-preview {
                    width: 100px;
                    height: 100px;
                    border-radius: 50%;
                    background: linear-gradient(135deg, #66bb6a 0%, #81c784 100%);
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    color: white;
                    font-size: 2rem;
                    font-weight: bold;
                    margin: 0 auto 20px;
                }

                @media (max-width: 576px) {
                    .form-card,
                    .form-header {
                        padding: 1rem !important;
                    }
                }
            </style>
        </head>

        <body class="bg-light">
            <div class="container">
                <div class="row justify-content-center">
                    <div class="col-lg-7 col-md-9">
                        <div class="form-card">
                            <div class="form-header d-flex align-items-center">
                                <i class="fas fa-user fa-2x me-3"></i>
                                <div>
                                    <h4 class="mb-0">${user == null ? 'Add New Passenger' : 'Edit Passenger'}</h4>
                                    <small>Manage passenger information</small>
                                </div>
                            </div>
                            <!-- Notification Messages -->
                            <c:if test="${not empty param.message}">
                                <div class="alert alert-success alert-dismissible fade show" role="alert">
                                    <i class="fas fa-check-circle me-2"></i>
                                    <strong>Success!</strong> ${param.message}
                                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                </div>
                            </c:if>
                            <c:if test="${not empty param.error}">
                                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                    <i class="fas fa-exclamation-circle me-2"></i>
                                    <strong>Error!</strong> ${param.error}
                                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                </div>
                            </c:if>
                            <c:if test="${not empty param.warning}">
                                <div class="alert alert-warning alert-dismissible fade show" role="alert">
                                    <i class="fas fa-exclamation-triangle me-2"></i>
                                    <strong>Warning!</strong> ${param.warning}
                                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                </div>
                            </c:if>
                            <c:if test="${not empty param.info}">
                                <div class="alert alert-info alert-dismissible fade show" role="alert">
                                    <i class="fas fa-info-circle me-2"></i>
                                    <strong>Info:</strong> ${param.info}
                                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                </div>
                            </c:if>

                            <form action="${pageContext.request.contextPath}/passengers/${user == null ? 'add' : 'edit'}"
                                method="post" id="passengerForm" enctype="multipart/form-data" autocomplete="off">
                                <c:if test="${user != null}">
                                    <input type="hidden" name="userId" value="${user.userId}">
                                </c:if>

                                <!-- Personal Information -->
                                <div class="section-title"><i class="fas fa-id-card me-2"></i>Personal Information
                                </div>
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <label for="username" class="form-label">Username *</label>
                                        <input type="text" class="form-control" id="username" name="username"
                                            value="${user.username}" required maxlength="50" placeholder="Enter username">
                                        <div class="form-text">Username should be unique</div>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="fullName" class="form-label">Full Name *</label>
                                        <input type="text" class="form-control" id="fullName" name="fullName"
                                            value="${user.fullName}" required maxlength="100" placeholder="Enter full name">
                                    </div
                                    >
                                    <div class="col-md-6">
                                        <label for="email" class="form-label">Email *</label>
                                        <input type="email" class="form-control" id="email" name="email"
                                            value="${user.email}" required placeholder="Enter email">
                                    </div>
                                    <div class="col-md-6">
                                        <label for="password" class="form-label">Password <c:if
                                                test="${user == null}">*</c:if></label>
                                        <input type="password" class="form-control" id="password" name="password"
                                            <c:if test="${user == null}">required</c:if> placeholder="${user == null ? 'Enter password' : 'Leave blank to keep current'}">
                                    </div>
                                </div>

                                <!-- Contact Information -->
                                <div class="section-title"><i class="fas fa-phone me-2"></i>Contact Information</div>
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <label for="phone" class="form-label">Phone Number *</label>
                                        <input type="text" class="form-control" id="phone" name="phone" value="${user.phoneNumber}"
                                            required placeholder="Enter phone number">
                                    </div>
                                    <div class="col-md-6">
                                        <label for="idCard" class="form-label">ID Card Number *</label>
                                        <input type="text" class="form-control" id="idCard" name="idCard" value="${user.idCard}"
                                            required placeholder="Enter ID card number">
                                    </div>
                                    <div class="col-md-6">
                                        <label for="dateOfBirth" class="form-label">Date of Birth *</label>
                                        <input type="date" class="form-control" id="dateOfBirth" name="dateOfBirth" value="${user.dateOfBirth}"
                                            required>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">Gender *</label>
                                        <div>
                                            <div class="form-check form-check-inline">
                                                <input class="form-check-input" type="radio" name="gender" id="genderMale"
                                                    value="MALE" <c:if test="${user.gender == 'MALE'}">checked</c:if>>
                                                <label class="form-check-label" for="genderMale">Male</label>
                                            </div>
                                            <div class="form-check form-check-inline">
                                                <input class="form-check-input" type="radio" name="gender" id="genderFemale"
                                                    value="FEMALE" <c:if test="${user.gender == 'FEMALE'}">checked</c:if>>
                                                <label class="form-check-label" for="genderFemale">Female</label>
                                            </div>
                                            <div class="form-check form-check-inline">
                                                <input class="form-check-input" type="radio" name="gender" id="genderOther"
                                                    value="OTHER" <c:if test="${user.gender == 'OTHER'}">checked</c:if>>
                                                <label class="form-check-label" for="genderOther">Other</label>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Address Information -->
                                <div class="section-title"><i class="fas fa-map-marker-alt me-2"></i>Address</div>
                                <div class="row g-3">
                                    <div class="col-12">
                                        <label for="address" class="form-label">Address *</label>
                                        <input type="text" class="form-control" id="address" name="address" value="${user.address}"
                                            required placeholder="Enter address">
                                    </div>
                                </div>

                                <div class="d-flex justify-content-between align-items-center mt-4">
                                    <a href="${pageContext.request.contextPath}/passengers" class="btn btn-outline-secondary">
                                        <i class="fas fa-arrow-left me-2"></i>Back
                                    </a>
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-save me-2"></i>${user == null ? 'Add Passenger' : 'Save Changes'}
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <%@ include file="/views/partials/footer.jsp" %>
            </body>

        </html>

