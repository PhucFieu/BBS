package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.UUID;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;
import util.AuthUtils;

/**
 *
 * @author TàiNH CE190387
 */
@WebServlet("/passengers/*")
public class PassengerController extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user has permission to manage passengers
        if (!AuthUtils.canManagePassengers(request.getSession(false))) {
            request.setAttribute("error", "You do not have permission to access this page");
            request.getRequestDispatcher("/views/403.jsp").forward(request, response);
            return;
        }

        String pathInfo = request.getPathInfo();

        try {
            if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("")) {
                // List all passengers (users with role USER)
                listPassengers(request, response);
            } else if (pathInfo.equals("/add")) {
                // Show add form
                showAddForm(request, response);
            } else if (pathInfo.equals("/edit")) {
                // Show edit form
                showEditForm(request, response);
            } else if (pathInfo.equals("/delete")) {
                // Delete passenger
                deletePassenger(request, response);
            } else if (pathInfo.equals("/search")) {
                // Search passengers
                searchPassengers(request, response);
            } else if (pathInfo.equals("/profile")) {
                // Show passenger profile
                showProfile(request, response);
            } else {
                // Get passenger by ID
                getPassengerById(request, response);
            }
        } catch (SQLException e) {
            handleError(request, response, "Database error: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user has permission to manage passengers
        if (!AuthUtils.canManagePassengers(request.getSession(false))) {
            request.setAttribute("error", "You do not have permission to access this page");
            request.getRequestDispatcher("/views/403.jsp").forward(request, response);
            return;
        }

        String pathInfo = request.getPathInfo();

        try {
            if (pathInfo.equals("/add")) {
                addPassenger(request, response);
            } else if (pathInfo.equals("/edit")) {
                updatePassenger(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            handleError(request, response, "Database error: " + e.getMessage());
        }
    }

    private void listPassengers(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        List<User> passengers = userDAO.getUsersByRole("USER");
        request.setAttribute("passengers", passengers);
        request.getRequestDispatcher("/views/passengers.jsp").forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/passenger-form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        String userIdStr = request.getParameter("id");
        if (userIdStr == null) {
            handleError(request, response, "User ID is required");
            return;
        }

        UUID userId = UUID.fromString(userIdStr);
        User user = userDAO.getUserById(userId);

        if (user != null && "USER".equals(user.getRole())) {
            request.setAttribute("passenger", user);
            request.getRequestDispatcher("/views/passenger-form.jsp").forward(request, response);
        } else {
            handleError(request, response, "Passenger not found");
        }
    }

    private void showProfile(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        String userIdStr = request.getParameter("id");
        if (userIdStr == null) {
            handleError(request, response, "User ID is required");
            return;
        }

        UUID userId = UUID.fromString(userIdStr);
        User user = userDAO.getUserById(userId);

        if (user != null && "USER".equals(user.getRole())) {
            request.setAttribute("passenger", user);
            request.getRequestDispatcher("/views/passenger-profile.jsp").forward(request, response);
        } else {
            handleError(request, response, "Passenger not found");
        }
    }

    private void searchPassengers(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        String keyword = request.getParameter("keyword");

        if (keyword != null && !keyword.trim().isEmpty()) {
            List<User> passengers = userDAO.searchUsers(keyword, "USER");
            request.setAttribute("passengers", passengers);
            request.setAttribute("searchKeyword", keyword);
        } else {
            List<User> passengers = userDAO.getUsersByRole("USER");
            request.setAttribute("passengers", passengers);
        }

        request.getRequestDispatcher("/views/passengers.jsp").forward(request, response);
    }

    private void addPassenger(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        // Get parameters from request
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String fullName = request.getParameter("fullName");
        String phoneNumber = request.getParameter("phoneNumber");
        String email = request.getParameter("email");
        String idCard = request.getParameter("idCard");
        String address = request.getParameter("address");
        String dateOfBirthStr = request.getParameter("dateOfBirth");
        String gender = request.getParameter("gender");

        // Validate required fields
        if (username == null || username.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/passengers/add?error=Username is required");
            return;
        }

        if (password == null || password.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/passengers/add?error=Password is required");
            return;
        }

        if (fullName == null || fullName.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/passengers/add?error=Full name is required");
            return;
        }

        if (phoneNumber == null || phoneNumber.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/passengers/add?error=Phone number is required");
            return;
        }

        // Parse date of birth
        LocalDate dateOfBirth = null;
        if (dateOfBirthStr != null && !dateOfBirthStr.trim().isEmpty()) {
            try {
                dateOfBirth = LocalDate.parse(dateOfBirthStr, DateTimeFormatter.ISO_LOCAL_DATE);
            } catch (Exception e) {
                response.sendRedirect(request.getContextPath() + "/passengers/add?error=Invalid date format");
                return;
            }
        }

        // Check if username already exists
        try {
            User existingUser = userDAO.getUserByUsername(username);
            if (existingUser != null) {
                response.sendRedirect(request.getContextPath() + "/passengers/add?error=Username already exists");
                return;
            }
        } catch (SQLException e) {
            // Continue if check fails
        }

        // Check if phone number already exists
        try {
            User existingUser = userDAO.getUserByPhone(phoneNumber);
            if (existingUser != null) {
                response.sendRedirect(request.getContextPath() + "/passengers/add?error=Phone number already exists");
                return;
            }
        } catch (SQLException e) {
            // Continue if check fails
        }

        // Check if ID card already exists
        if (idCard != null && !idCard.trim().isEmpty()) {
            try {
                User existingUser = userDAO.getUserByIdCard(idCard);
                if (existingUser != null) {
                    response.sendRedirect(request.getContextPath() + "/passengers/add?error=ID card already exists");
                    return;
                }
            } catch (SQLException e) {
                // Continue if check fails
            }
        }

        // Create new user (passenger)
        User user = new User(username, password, fullName, email, phoneNumber, "USER");
        user.setIdCard(idCard);
        user.setAddress(address);
        user.setDateOfBirth(dateOfBirth);
        user.setGender(gender);

        // Save to database
        boolean success = userDAO.addUser(user);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/passengers?message=Passenger added successfully");
        } else {
            response.sendRedirect(request.getContextPath() + "/passengers/add?error=Failed to add passenger");
        }
    }

    private void updatePassenger(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        // Get parameters from request
        String userIdStr = request.getParameter("userId");
        if (userIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/passengers?error=User ID is required");
            return;
        }

        UUID userId = UUID.fromString(userIdStr);
        String fullName = request.getParameter("fullName");
        String phoneNumber = request.getParameter("phoneNumber");
        String email = request.getParameter("email");
        String idCard = request.getParameter("idCard");
        String address = request.getParameter("address");
        String dateOfBirthStr = request.getParameter("dateOfBirth");
        String gender = request.getParameter("gender");

        // Validate required fields
        if (fullName == null || fullName.trim().isEmpty()) {
            response.sendRedirect(
                    request.getContextPath() + "/passengers/edit?id=" + userIdStr + "&error=Full name is required");
            return;
        }

        if (phoneNumber == null || phoneNumber.trim().isEmpty()) {
            response.sendRedirect(
                    request.getContextPath() + "/passengers/edit?id=" + userIdStr + "&error=Phone number is required");
            return;
        }

        // Parse date of birth
        LocalDate dateOfBirth = null;
        if (dateOfBirthStr != null && !dateOfBirthStr.trim().isEmpty()) {
            try {
                dateOfBirth = LocalDate.parse(dateOfBirthStr, DateTimeFormatter.ISO_LOCAL_DATE);
            } catch (Exception e) {
                response.sendRedirect(
                        request.getContextPath() + "/passengers/edit?id=" + userIdStr + "&error=Invalid date format");
                return;
            }
        }

        // Get existing user
        User user = userDAO.getUserById(userId);
        if (user == null || !"USER".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/passengers?error=Passenger not found");
            return;
        }

        // Update user fields
        user.setFullName(fullName);
        user.setPhoneNumber(phoneNumber);
        user.setEmail(email);
        user.setIdCard(idCard);
        user.setAddress(address);
        user.setDateOfBirth(dateOfBirth);
        user.setGender(gender);

        // Update in database
        boolean success = userDAO.updateUser(user);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/passengers?message=Passenger updated successfully");
        } else {
            response.sendRedirect(request.getContextPath() + "/passengers/edit?id=" + userIdStr
                    + "&error=Failed to update passenger");
        }
    }

    private void deletePassenger(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String userIdStr = request.getParameter("id");
        if (userIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/passengers?error=User ID is required");
            return;
        }

        UUID userId = UUID.fromString(userIdStr);
        boolean success = userDAO.deleteUser(userId);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/passengers?message=Passenger deleted successfully");
        } else {
            response.sendRedirect(request.getContextPath() + "/passengers?error=Failed to delete passenger");
        }
    }

    private void getPassengerById(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        String pathInfo = request.getPathInfo();
        String userIdStr = pathInfo.substring(1); // Remove leading slash

        try {
            UUID userId = UUID.fromString(userIdStr);
            User user = userDAO.getUserById(userId);

            if (user != null && "USER".equals(user.getRole())) {
                request.setAttribute("passenger", user);
                request.getRequestDispatcher("/views/passenger-detail.jsp").forward(request, response);
            } else {
                handleError(request, response, "Passenger not found");
            }
        } catch (IllegalArgumentException e) {
            handleError(request, response, "Invalid user ID format");
        }
    }

    private void handleError(HttpServletRequest request, HttpServletResponse response, String message)
            throws ServletException, IOException {
        request.setAttribute("error", message);
        request.getRequestDispatcher("/views/error.jsp").forward(request, response);
    }
}
