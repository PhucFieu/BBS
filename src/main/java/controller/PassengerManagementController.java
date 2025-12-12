package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.UUID;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;

/**
 * Controller for managing Passenger (USER role) accounts.
 * Handles CRUD operations for passenger users in the admin panel.
 */
@WebServlet(urlPatterns = { "/users/*", "/admin/users/*", "/admin/user/*", "/admin/passengers/*",
        "/admin/passenger/*" })
public class PassengerManagementController extends HttpServlet {
    private AdminBaseController baseController;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        baseController = new AdminBaseController() {
        };
        baseController.initializeDAOs();
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String servletPath = request.getServletPath();
        String pathInfo = request.getPathInfo();
        if (pathInfo == null)
            pathInfo = "/";

        try {
            if (servletPath.startsWith("/admin")) {
                if (!baseController.isAdminAuthenticated(request)) {
                    response.sendRedirect(request.getContextPath() + "/auth/login");
                    return;
                }

                switch (pathInfo) {
                    case "/":
                        showPassengers(request, response);
                        break;
                    case "/edit":
                        showEditPassengerForm(request, response);
                        break;
                    case "/delete":
                        deletePassenger(request, response);
                        break;
                    case "/search":
                        searchPassengers(request, response);
                        break;
                    default:
                        response.sendError(HttpServletResponse.SC_NOT_FOUND);
                }
            } else {
                // Public: expose a limited search of passengers as JSON (read-only)
                if ("/search".equals(pathInfo)) {
                    searchPassengers(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                }
            }
        } catch (SQLException e) {
            handleError(request, response, "Database error: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        if (pathInfo == null)
            pathInfo = "/";

        try {
            if (!baseController.isAdminAuthenticated(request)) {
                response.sendRedirect(request.getContextPath() + "/auth/login");
                return;
            }

            if ("/update".equals(pathInfo)) {
                updatePassenger(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            handleError(request, response, "Database error: " + e.getMessage());
        }
    }

    private void showPassengers(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        String searchTerm = request.getParameter("search");
        List<User> passengers;

        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            passengers = userDAO.searchUsers(searchTerm, "USER");
        } else {
            passengers = userDAO.getUsersByRole("USER");
        }

        request.setAttribute("users", passengers);
        request.setAttribute("searchTerm", searchTerm);
        request.setAttribute("roleFilter", "USER");
        request.setAttribute("managementPath", "/admin/users");
        request.setAttribute("roleDisplayName", "Passenger");

        request.getRequestDispatcher("/views/admin/users.jsp").forward(request, response);
    }

    private void showEditPassengerForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        String userIdStr = request.getParameter("id");
        if (userIdStr == null || userIdStr.trim().isEmpty()) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/users?error=User ID is required");
            return;
        }

        try {
            UUID userId = UUID.fromString(userIdStr);
            User user = userDAO.getUserById(userId);

            if (user != null) {
                if (!"USER".equals(user.getRole())) {
                    response.sendRedirect(request.getContextPath() + "/admin/users"
                            + "?error=Wrong role for this management area");
                    return;
                }
                request.setAttribute("user", user);
                request.setAttribute("roleFilter", "USER");
                request.setAttribute("managementPath", "/admin/users");
                request.setAttribute("roleDisplayName", "Passenger");
                request.setAttribute("isAddMode", false);
                request.getRequestDispatcher("/views/admin/user-form.jsp").forward(request,
                        response);
            } else {
                response.sendRedirect(
                        request.getContextPath() + "/admin/users?error=User not found");
            }
        } catch (IllegalArgumentException e) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/users?error=Invalid user ID");
        }
    }

    private void updatePassenger(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String userIdStr = request.getParameter("userId");
        String username = request.getParameter("username");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String status = request.getParameter("status");

        // Validate input
        if (userIdStr == null || username == null || fullName == null || email == null) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/users?error=All fields are required");
            return;
        }

        try {
            UUID userId = UUID.fromString(userIdStr);
            User existingUser = userDAO.getUserById(userId);

            if (existingUser == null) {
                response.sendRedirect(
                        request.getContextPath() + "/admin/users?error=User not found");
                return;
            }

            if (!"USER".equals(existingUser.getRole())) {
                response.sendRedirect(request.getContextPath() + "/admin/users"
                        + "?error=Only passenger accounts are managed here");
                return;
            }

            // Update user
            existingUser.setUsername(username);
            existingUser.setFullName(fullName);
            existingUser.setEmail(email);
            existingUser.setRole("USER");
            existingUser.setStatus(status);

            boolean success = userDAO.updateUser(existingUser);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/users"
                        + "?message=Passenger updated successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/users"
                        + "?error=Failed to update passenger");
            }
        } catch (IllegalArgumentException e) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/users?error=Invalid user ID");
        }
    }

    private void deletePassenger(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String userIdStr = request.getParameter("id");

        if (userIdStr == null || userIdStr.trim().isEmpty()) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/users?error=User ID is required");
            return;
        }

        try {
            UUID userId = UUID.fromString(userIdStr);
            User user = userDAO.getUserById(userId);

            if (user == null) {
                response.sendRedirect(
                        request.getContextPath() + "/admin/users?error=User not found");
                return;
            }

            if (!"USER".equals(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/admin/users"
                        + "?error=Wrong role for this management area");
                return;
            }

            // Prevent admin from deleting themselves
            User currentUser = baseController.getCurrentUser(request);
            if (currentUser != null && currentUser.getUserId().equals(userId)) {
                response.sendRedirect(request.getContextPath()
                        + "/admin/users?error=Cannot delete your own account");
                return;
            }

            boolean success = userDAO.deleteUser(userId);

            if (success) {
                response.sendRedirect(request.getContextPath()
                        + "/admin/users?message=Passenger deleted successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/users"
                        + "?error=Failed to delete passenger");
            }
        } catch (IllegalArgumentException e) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/users?error=Invalid user ID");
        }
    }

    private void searchPassengers(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        String searchTerm = request.getParameter("search");
        List<User> passengers;

        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            passengers = userDAO.searchUsers(searchTerm, "USER");
        } else {
            passengers = userDAO.getUsersByRole("USER");
        }

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        StringBuilder jsonResponse = new StringBuilder();
        jsonResponse.append("[");

        for (int i = 0; i < passengers.size(); i++) {
            User user = passengers.get(i);
            jsonResponse.append("{");
            jsonResponse.append("\"userId\":\"").append(user.getUserId()).append("\",");
            jsonResponse.append("\"fullName\":\"").append(user.getFullName()).append("\",");
            jsonResponse.append("\"email\":\"").append(user.getEmail()).append("\",");
            jsonResponse.append("\"phoneNumber\":\"").append(user.getPhoneNumber()).append("\",");
            jsonResponse.append("\"username\":\"").append(user.getUsername()).append("\"");
            jsonResponse.append("}");

            if (i < passengers.size() - 1) {
                jsonResponse.append(",");
            }
        }

        jsonResponse.append("]");

        response.getWriter().write(jsonResponse.toString());
    }

    private void handleError(HttpServletRequest request, HttpServletResponse response,
            String message)
            throws ServletException, IOException {
        request.setAttribute("error", message);
        request.getRequestDispatcher("/views/errors/error.jsp").forward(request, response);
    }
}
