package controller;

import java.io.IOException;
import java.sql.SQLException;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import util.URLUtils;

@WebServlet(name = "AuthController", urlPatterns = {"/auth/*"})
public class AuthController extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        try {
            if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("")) {
                // Show login form
                showLoginForm(request, response);
            } else if (pathInfo.equals("/login")) {
                // Show login form
                showLoginForm(request, response);
            } else if (pathInfo.equals("/logout")) {
                // Logout
                logout(request, response);
            } else if (pathInfo.equals("/register")) {
                // Show register form
                showRegisterForm(request, response);
            } else if (pathInfo.equals("/profile")) {
                // Show user profile
                showProfile(request, response);
            } else if (pathInfo.equals("/change-password")) {
                // Show change password form
                showChangePasswordForm(request, response);
            } else if (pathInfo.equals("/update-profile")) {
                // Update user profile
                updateProfile(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            handleError(request, response, "Database error: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        try {
            if (pathInfo.equals("/login")) {
                login(request, response);
            } else if (pathInfo.equals("/register")) {
                register(request, response);
            } else if (pathInfo.equals("/change-password")) {
                changePassword(request, response);
            } else if (pathInfo.equals("/update-profile")) {
                updateProfile(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            handleError(request, response, "Database error: " + e.getMessage());
        }
    }

    private void showLoginForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is already logged in
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
    }

    private void showRegisterForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/auth/register.jsp").forward(request, response);
    }

    private void showProfile(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        User currentUser = (User) session.getAttribute("user");
        User user = userDAO.getUserById(currentUser.getUserId());

        if (user != null) {
            request.setAttribute("user", user);
            request.getRequestDispatcher("/views/user/profile.jsp").forward(request, response);
        } else {
            handleError(request, response, "User not found");
        }
    }

    private void showChangePasswordForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        request.getRequestDispatcher("/views/user/change-password.jsp").forward(request, response);
    }

    private void login(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String rememberMe = request.getParameter("rememberMe");

        // Validate input
        if (username == null || username.trim().isEmpty()) {
            String errorParam = URLUtils.createParameter("error", "Username cannot be empty");
            response.sendRedirect(request.getContextPath() + "/auth/login?" + errorParam);
            return;
        }

        if (password == null || password.trim().isEmpty()) {
            String errorParam = URLUtils.createParameter("error",
                    "Missing information: Password cannot be empty");
            response.sendRedirect(request.getContextPath() + "/auth/login?" + errorParam);
            return;
        }

        // Authenticate user
        User user = userDAO.authenticate(username, password);

        if (user != null) {
            // Create session
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("username", user.getUsername());
            session.setAttribute("role", user.getRole());
            session.setAttribute("fullName", user.getFullName());



            // Set remember-me cookie if requested
            if (rememberMe != null && rememberMe.equals("on")) {
                // Create remember-me cookie valid for 30 days
                jakarta.servlet.http.Cookie userCookie =
                        new jakarta.servlet.http.Cookie("remember-me", username);
                userCookie.setMaxAge(30 * 24 * 60 * 60); // 30 days in seconds
                userCookie.setPath("/");
                response.addCookie(userCookie);
            }

            // Redirect based on role
            String redirectUrl = request.getContextPath() + "/";
            if (user.getRole().equals("ADMIN")) {
                redirectUrl += "admin/dashboard";
            } else if (user.getRole().equals("STAFF")) {
                // STAFF role
                redirectUrl = request.getContextPath() + "/staff/dashboard";
            } else if (util.AuthUtils.isDriver(request.getSession(false))) {
                // DRIVER role
                redirectUrl = request.getContextPath() + "/driver/trips";
            } else {
                // Default for USER or others
                redirectUrl = request.getContextPath() + "/";
            }

            response.sendRedirect(redirectUrl);
        } else {
            String errorParam =
                    URLUtils.createParameter("error", "Username or password is incorrect");
            response.sendRedirect(
                    request.getContextPath() + "/auth/login?" + errorParam);
        }
    }

    private void register(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phoneNumber = request.getParameter("phone"); // Fixed: form uses "phone", not
                                                            // "phonenumber"
        String idCard = request.getParameter("idCard");
        String address = request.getParameter("address");
        String dateOfBirthStr = request.getParameter("dateOfBirth");
        String gender = request.getParameter("gender");

        // Validate input
        if (username == null || username.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/auth/register?"
                    + URLUtils.createParameter("error", "Username cannot be empty"));
            return;
        }

        if (password == null || password.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/auth/register?"
                    + URLUtils.createParameter("error",
                            "Missing information: Password cannot be empty"));
            return;
        }

        if (password.length() < 8) {
            response.sendRedirect(request.getContextPath() + "/auth/register?"
                    + URLUtils.createParameter("error",
                            "Error: Password must be at least 8 characters"));
            return;
        }

        if (!password.equals(confirmPassword)) {
            response.sendRedirect(request.getContextPath() + "/auth/register?"
                    + URLUtils.createParameter("error", "Error: Passwords do not match"));
            return;
        }

        if (fullName == null || fullName.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/auth/register?"
                    + URLUtils.createParameter("error",
                            "Missing information: Full name cannot be empty"));
            return;
        }

        // Validate fullname: only letters and spaces allowed (no numbers)
        // \\p{L} matches any Unicode letter (including Vietnamese characters with diacritics)
        // \\s matches whitespace characters
        fullName = fullName.trim();
        if (!fullName.matches("^[\\p{L}\\s]+$")) {
            response.sendRedirect(request.getContextPath() + "/auth/register?"
                    + URLUtils.createParameter("error",
                            "Error: Full name can only contain letters and spaces. Numbers are not allowed"));
            return;
        }

        if (email == null || email.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/auth/register?"
                    + URLUtils.createParameter("error",
                            "Missing information: Email cannot be empty"));
            return;
        }

        if (phoneNumber == null || phoneNumber.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/auth/register?"
                    + URLUtils.createParameter("error",
                            "Missing information: Phone number cannot be empty"));
            return;
        }

        if (idCard == null || idCard.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/auth/register?"
                    + URLUtils.createParameter("error",
                            "Missing information: ID card cannot be empty"));
            return;
        }

        if (address == null || address.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/auth/register?"
                    + URLUtils.createParameter("error",
                            "Missing information: Address cannot be empty"));
            return;
        }

        if (dateOfBirthStr == null || dateOfBirthStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/auth/register?"
                    + URLUtils.createParameter("error",
                            "Missing information: Date of birth cannot be empty"));
            return;
        }

        if (gender == null || gender.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/auth/register?"
                    + URLUtils.createParameter("error",
                            "Missing information: Gender cannot be empty"));
            return;
        }

        // Check if username already exists
        User existingUser = userDAO.getUserByUsername(username);
        if (existingUser != null) {
            response.sendRedirect(request.getContextPath() + "/auth/register?"
                    + URLUtils.createParameter("error", "Username already exists"));
            return;
        }

        // Check if email already exists
        User existingEmailUser = userDAO.getUserByEmail(email);
        if (existingEmailUser != null) {
            response.sendRedirect(request.getContextPath() + "/auth/register?"
                    + URLUtils.createParameter("error", "Error: Email is already in use"));
            return;
        }

        // Check if phone number already exists
        User existingPhoneUser = userDAO.getUserByPhone(phoneNumber);
        if (existingPhoneUser != null) {
            response.sendRedirect(request.getContextPath() + "/auth/register?"
                    + URLUtils.createParameter("error", "Error: Phone number is already in use"));
            return;
        }

        // Check if ID card already exists
        User existingIdCardUser = userDAO.getUserByIdCard(idCard);
        if (existingIdCardUser != null) {
            response.sendRedirect(request.getContextPath() + "/auth/register?"
                    + URLUtils.createParameter("error", "Error: ID card is already in use"));
            return;
        }

        // Create new user with all fields
        User user = new User(username, password, fullName, email, phoneNumber, "USER");

        // Set additional fields
        user.setIdCard(idCard);
        user.setAddress(address);
        user.setGender(gender);

        // Parse date of birth and validate minimum age (16 years old)
        try {
            java.time.LocalDate dateOfBirth = java.time.LocalDate.parse(dateOfBirthStr);
            java.time.LocalDate today = java.time.LocalDate.now();

            // Calculate age using Period for accurate age calculation
            java.time.Period period = java.time.Period.between(dateOfBirth, today);
            int age = period.getYears();

            // Also check if the date is in the future
            if (dateOfBirth.isAfter(today)) {
                response.sendRedirect(request.getContextPath() + "/auth/register?"
                        + URLUtils.createParameter("error",
                                "Error: Date of birth cannot be in the future"));
                return;
            }

            // Validate minimum age (16 years old)
            if (age < 16) {
                response.sendRedirect(request.getContextPath() + "/auth/register?"
                        + URLUtils.createParameter("error",
                                "Error: You must be at least 16 years old to register. Your age is "
                                        + age + " years."));
                return;
            }

            user.setDateOfBirth(dateOfBirth);
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/auth/register?"
                    + URLUtils.createParameter("error", "Error: Invalid date of birth format"));
            return;
        }

        // Save to database
        boolean success = userDAO.addUser(user);

        if (success) {
            response.sendRedirect(
                    request.getContextPath() + "/auth/login?"
                            + URLUtils.createParameter("message",
                                    "Registration successful! Please login with your credentials."));
        } else {
            response.sendRedirect(request.getContextPath() + "/auth/register?"
                    + URLUtils.createParameter("error",
                            "Error: Failed to create account. Please try again or contact support"));
        }
    }

    private void changePassword(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        User currentUser = (User) session.getAttribute("user");
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // Validate input
        if (currentPassword == null || currentPassword.trim().isEmpty()) {
            response.sendRedirect(
                    request.getContextPath() + "/auth/change-password?"
                            + URLUtils.createParameter("error", "Current password is required"));
            return;
        }

        if (newPassword == null || newPassword.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/auth/change-password?"
                    + URLUtils.createParameter("error", "New password is required"));
            return;
        }

        if (newPassword.length() < 8) {
            response.sendRedirect(request.getContextPath() + "/auth/change-password?"
                    + URLUtils.createParameter("error",
                            "Error: New password must be at least 8 characters"));
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            response.sendRedirect(request.getContextPath() + "/auth/change-password?"
                    + URLUtils.createParameter("error", "New passwords do not match"));
            return;
        }

        // Verify current password
        User user = userDAO.authenticate(currentUser.getUsername(), currentPassword);
        if (user == null) {
            response.sendRedirect(
                    request.getContextPath() + "/auth/change-password?"
                            + URLUtils.createParameter("error", "Current password is incorrect"));
            return;
        }

        // Change password
        boolean success = userDAO.changePassword(currentUser.getUserId(), newPassword);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/auth/profile?"
                    + URLUtils.createParameter("message", "Password changed successfully"));
        } else {
            response.sendRedirect(request.getContextPath() + "/auth/change-password?"
                    + URLUtils.createParameter("error", "Failed to change password"));
        }
    }

    private void updateProfile(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        User currentUser = (User) session.getAttribute("user");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");

        // Validate input
        if (fullName == null || fullName.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/auth/profile?"
                    + URLUtils.createParameter("error", "Full name is required"));
            return;
        }

        // Validate fullname: only letters and spaces allowed (no numbers)
        // \\p{L} matches any Unicode letter (including Vietnamese characters with diacritics)
        // \\s matches whitespace characters
        fullName = fullName.trim();
        if (!fullName.matches("^[\\p{L}\\s]+$")) {
            response.sendRedirect(request.getContextPath() + "/auth/profile?"
                    + URLUtils.createParameter("error",
                            "Error: Full name can only contain letters and spaces. Numbers are not allowed"));
            return;
        }

        if (email == null || email.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/auth/profile?"
                    + URLUtils.createParameter("error", "Email is required"));
            return;
        }

        // Update user
        currentUser.setFullName(fullName);
        currentUser.setEmail(email);

        boolean success = userDAO.updateUser(currentUser);

        if (success) {
            // Update session
            session.setAttribute("user", currentUser);
            response.sendRedirect(request.getContextPath() + "/auth/profile?"
                    + URLUtils.createParameter("message", "Profile updated successfully"));
        } else {
            response.sendRedirect(request.getContextPath() + "/auth/profile?"
                    + URLUtils.createParameter("error", "Failed to update profile"));
        }
    }

    private void logout(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        // Invalidate session
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }

        // Remove remember-me cookie if it exists
        jakarta.servlet.http.Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (jakarta.servlet.http.Cookie cookie : cookies) {
                if (cookie.getName().equals("remember-me")) {
                    cookie.setValue("");
                    cookie.setMaxAge(0);
                    cookie.setPath("/");
                    response.addCookie(cookie);
                    break;
                }
            }
        }

        String messageParam = URLUtils.createParameter("message", "Logout successful");
        response.sendRedirect(request.getContextPath() + "/auth/login?" + messageParam);
    }

    private void handleError(HttpServletRequest request, HttpServletResponse response,
            String message)
            throws ServletException, IOException {
        request.setAttribute("error", message);
        request.getRequestDispatcher("/views/errors/error.jsp").forward(request, response);
    }
}
