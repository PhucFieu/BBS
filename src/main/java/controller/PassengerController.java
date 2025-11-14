package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.UUID;

import dao.TicketDAO;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;
import util.AuthUtils;

@WebServlet("/passengers/*")
public class PassengerController extends HttpServlet {
    private UserDAO userDAO;
    private TicketDAO ticketDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        ticketDAO = new TicketDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Permission: ADMIN can access everything. DRIVER can access list/search/view
        // only.
        boolean isAdmin = AuthUtils.isAdmin(request.getSession(false));
        boolean isDriver = AuthUtils.isDriver(request.getSession(false));

        String pathInfo = request.getPathInfo();

        try {
            if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("")) {
                // List passengers
                if (!isAdmin && !isDriver) {
                    request.setAttribute("error", "You do not have permission to access this page");
                    request.getRequestDispatcher("/views/errors/403.jsp").forward(request, response);
                    return;
                }
                listPassengers(request, response);
            } else if (pathInfo.equals("/add")) {
                // Show add form
                if (!isAdmin) {
                    request.setAttribute("error", "You do not have permission to access this page");
                    request.getRequestDispatcher("/views/errors/403.jsp").forward(request, response);
                    return;
                }
                showAddForm(request, response);
            } else if (pathInfo.equals("/edit")) {
                // Show edit form
                if (!isAdmin) {
                    request.setAttribute("error", "You do not have permission to access this page");
                    request.getRequestDispatcher("/views/errors/403.jsp").forward(request, response);
                    return;
                }
                showEditForm(request, response);
            } else if (pathInfo.equals("/delete")) {
                // Delete passenger
                if (!isAdmin) {
                    request.setAttribute("error", "You do not have permission to access this page");
                    request.getRequestDispatcher("/views/errors/403.jsp").forward(request, response);
                    return;
                }
                deletePassenger(request, response);
            } else if (pathInfo.equals("/search")) {
                // Search passengers
                if (!isAdmin && !isDriver) {
                    request.setAttribute("error", "You do not have permission to access this page");
                    request.getRequestDispatcher("/views/errors/403.jsp").forward(request, response);
                    return;
                }
                searchPassengers(request, response);
            } else if (pathInfo.equals("/profile")) {
                // Show passenger profile
                if (!isAdmin && !isDriver) {
                    request.setAttribute("error", "You do not have permission to access this page");
                    request.getRequestDispatcher("/views/errors/403.jsp").forward(request, response);
                    return;
                }
                showProfile(request, response);
            } else {
                // Get passenger by ID
                if (!isAdmin && !isDriver) {
                    request.setAttribute("error", "You do not have permission to access this page");
                    request.getRequestDispatcher("/views/errors/403.jsp").forward(request, response);
                    return;
                }
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
            request.getRequestDispatcher("/views/errors/403.jsp").forward(request, response);
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
        List<User> passengers;
        java.util.Map<UUID, List<model.Tickets>> passengerTickets = new java.util.HashMap<>();
        
        if (AuthUtils.isDriver(request.getSession(false))) {
            // Limit to passengers who have tickets on schedules assigned to this driver
            User current = AuthUtils.getCurrentUser(request.getSession(false));
            passengers = userDAO.getPassengersByDriverUserId(current.getUserId());
            
            // Load tickets with station information for each passenger
            for (User passenger : passengers) {
                try {
                    List<model.Tickets> tickets = ticketDAO.getTicketsByUserId(passenger.getUserId());
                    if (!tickets.isEmpty()) {
                        passengerTickets.put(passenger.getUserId(), tickets);
                    }
                } catch (SQLException e) {
                }
            }
        } else {
            passengers = userDAO.getUsersByRole("USER");
        }
        
        request.setAttribute("passengers", passengers);
        request.setAttribute("passengerTickets", passengerTickets);
        request.getRequestDispatcher("/views/passengers/passengers.jsp").forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/passengers/passenger-form.jsp").forward(request, response);
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
            request.getRequestDispatcher("/views/passengers/passenger-form.jsp").forward(request, response);
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
        List<User> passengers;
        if (AuthUtils.isDriver(request.getSession(false))) {
            // For drivers, ignore global search and keep scope to their passengers;
            // optionally filter in-memory
            User current = AuthUtils.getCurrentUser(request.getSession(false));
            List<User> scoped = userDAO.getPassengersByDriverUserId(current.getUserId());
            if (keyword != null && !keyword.trim().isEmpty()) {
                String lower = keyword.toLowerCase();
                java.util.List<User> filtered = new java.util.ArrayList<>();
                for (User u : scoped) {
                    if ((u.getFullName() != null && u.getFullName().toLowerCase().contains(lower)) ||
                            (u.getUsername() != null && u.getUsername().toLowerCase().contains(lower)) ||
                            (u.getEmail() != null && u.getEmail().toLowerCase().contains(lower)) ||
                            (u.getPhoneNumber() != null && u.getPhoneNumber().toLowerCase().contains(lower))) {
                        filtered.add(u);
                    }
                }
                passengers = filtered;
                request.setAttribute("searchKeyword", keyword);
            } else {
                passengers = scoped;
            }
        } else {
            if (keyword != null && !keyword.trim().isEmpty()) {
                passengers = userDAO.searchUsers(keyword, "USER");
                request.setAttribute("searchKeyword", keyword);
            } else {
                passengers = userDAO.getUsersByRole("USER");
            }
        }

        request.setAttribute("passengers", passengers);

        request.getRequestDispatcher("/views/passengers/passengers.jsp").forward(request, response);
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

        // Validate required fields with specific error messages
        if (username == null || username.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/passengers/add?error=Missing information: Username is required");
            return;
        }

        if (password == null || password.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/passengers/add?error=Missing information: Password is required");
            return;
        }

        if (fullName == null || fullName.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/passengers/add?error=Missing information: Full name is required");
            return;
        }

        if (phoneNumber == null || phoneNumber.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/passengers/add?error=Missing information: Phone number is required");
            return;
        }

        // Parse date of birth
        LocalDate dateOfBirth = null;
        if (dateOfBirthStr != null && !dateOfBirthStr.trim().isEmpty()) {
            try {
                dateOfBirth = LocalDate.parse(dateOfBirthStr, DateTimeFormatter.ISO_LOCAL_DATE);
            } catch (Exception e) {
                response.sendRedirect(request.getContextPath() + "/passengers/add?error=Error: Invalid date format. Please use YYYY-MM-DD format");
                return;
            }
        }

        // Check if username already exists
        try {
            User existingUser = userDAO.getUserByUsername(username);
            if (existingUser != null) {
                response.sendRedirect(request.getContextPath() + "/passengers/add?error=Error: Username already exists. Please choose a different username");
                return;
            }
        } catch (SQLException e) {
            // Continue if check fails
        }

        // Check if phone number already exists
        try {
            User existingUser = userDAO.getUserByPhone(phoneNumber);
            if (existingUser != null) {
                response.sendRedirect(request.getContextPath() + "/passengers/add?error=Error: Phone number already exists. Please use a different phone number");
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
                    response.sendRedirect(request.getContextPath() + "/passengers/add?error=Error: ID card already exists. Please use a different ID card");
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
            response.sendRedirect(request.getContextPath() + "/passengers?message=Passenger added successfully! Passenger " + fullName + " has been added to the system");
        } else {
            response.sendRedirect(request.getContextPath() + "/passengers/add?error=Error: Failed to add passenger. Please try again or contact administrator");
        }
    }

    private void updatePassenger(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        // Get parameters from request
        String userIdStr = request.getParameter("userId");
        if (userIdStr == null || userIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/passengers?error=Missing information: User ID is required");
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

        // Validate required fields with specific error messages
        if (fullName == null || fullName.trim().isEmpty()) {
            response.sendRedirect(
                    request.getContextPath() + "/passengers/edit?id=" + userIdStr + "&error=Missing information: Full name is required");
            return;
        }

        if (phoneNumber == null || phoneNumber.trim().isEmpty()) {
            response.sendRedirect(
                    request.getContextPath() + "/passengers/edit?id=" + userIdStr + "&error=Missing information: Phone number is required");
            return;
        }

        // Parse date of birth
        LocalDate dateOfBirth = null;
        if (dateOfBirthStr != null && !dateOfBirthStr.trim().isEmpty()) {
            try {
                dateOfBirth = LocalDate.parse(dateOfBirthStr, DateTimeFormatter.ISO_LOCAL_DATE);
            } catch (Exception e) {
                response.sendRedirect(
                        request.getContextPath() + "/passengers/edit?id=" + userIdStr + "&error=Error: Invalid date format. Please use YYYY-MM-DD format");
                return;
            }
        }

        // Get existing user
        User user = userDAO.getUserById(userId);
        if (user == null || !"USER".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/passengers?error=Error: Passenger not found with the given ID");
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
            response.sendRedirect(request.getContextPath() + "/passengers?message=Passenger updated successfully! Passenger " + fullName + " information has been saved");
        } else {
            response.sendRedirect(request.getContextPath() + "/passengers/edit?id=" + userIdStr
                    + "&error=Error: Failed to update passenger. Please try again or contact administrator");
        }
    }

    private void deletePassenger(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String userIdStr = request.getParameter("id");
        if (userIdStr == null || userIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/passengers?error=Missing information: User ID is required");
            return;
        }

        try {
            UUID userId = UUID.fromString(userIdStr);
            User user = userDAO.getUserById(userId);
            String fullName = user != null ? user.getFullName() : "Passenger";
            boolean success = userDAO.deleteUser(userId);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/passengers?message=Passenger deleted successfully! Passenger " + fullName + " has been removed from the system");
            } else {
                response.sendRedirect(request.getContextPath() + "/passengers?error=Error: Failed to delete passenger. The passenger may be in use or does not exist");
            }
        } catch (IllegalArgumentException e) {
            response.sendRedirect(request.getContextPath() + "/passengers?error=Error: Invalid user ID format. Please check again");
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/passengers?error=Error: An unexpected error occurred while deleting the passenger. " + e.getMessage());
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
        request.getRequestDispatcher("/views/errors/error.jsp").forward(request, response);
    }
}