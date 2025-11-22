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

@WebServlet(urlPatterns = {"/users/*", "/admin/users/*", "/admin/user/*"})
public class UserManagementController extends HttpServlet {
    private AdminBaseController baseController;

    @Override
    public void init() throws ServletException {
        baseController = new AdminBaseController() {};
        baseController.initializeDAOs();
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
                if ("/".equals(pathInfo)) {
                    showUsers(request, response);
                } else if ("/edit".equals(pathInfo)) {
                    showEditUserForm(request, response);
                } else if ("/delete".equals(pathInfo)) {
                    deleteUser(request, response);
                } else if ("/search".equals(pathInfo)) {
                    searchPassengers(request, response);
                } else {
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
                if ("/update".equals(pathInfo)) {
                    updateUser(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                }
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            handleError(request, response, "Database error: " + e.getMessage());
        }
    }

    private void showUsers(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        UserDAO userDAO = baseController.userDAO;
        String searchTerm = request.getParameter("search");

        // Always limit to passengers (role USER)
        List<User> users;
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            users = userDAO.searchUsers(searchTerm, "USER");
        } else {
            users = userDAO.getUsersByRole("USER");
        }

        request.setAttribute("users", users);
        request.setAttribute("searchTerm", searchTerm);
        request.setAttribute("roleFilter", "USER");

        request.getRequestDispatcher("/views/admin/users.jsp").forward(request, response);
    }

    private void showEditUserForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        UserDAO userDAO = baseController.userDAO;
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
                // Only allow editing passengers in this section
                if (!"USER".equals(user.getRole())) {
                    response.sendRedirect(request.getContextPath()
                            + "/admin/users?error=Only passengers can be edited here");
                    return;
                }
                request.setAttribute("user", user);
                request.getRequestDispatcher("/views/admin/user-form.jsp").forward(request,
                        response);
            } else {
                response.sendRedirect(
                        request.getContextPath() + "/admin/users?error=User not found");
            }
        } catch (IllegalArgumentException e) {
            response.sendRedirect(request.getContextPath() + "/admin/users?error=Invalid user ID");
        }
    }

    private void updateUser(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        UserDAO userDAO = baseController.userDAO;
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
            // Get existing user
            User existingUser = userDAO.getUserById(userId);
            if (existingUser == null) {
                response.sendRedirect(
                        request.getContextPath() + "/admin/users?error=User not found");
                return;
            }

            // Only allow updating passengers here
            if (!"USER".equals(existingUser.getRole())) {
                response.sendRedirect(request.getContextPath()
                        + "/admin/users?error=Only passengers are managed in this section");
                return;
            }

            // Update user
            existingUser.setUsername(username);
            existingUser.setFullName(fullName);
            existingUser.setEmail(email);
            // Force role to USER to ensure only passengers are managed
            existingUser.setRole("USER");
            existingUser.setStatus(status);

            boolean success = userDAO.updateUser(existingUser);

            if (success) {
                response.sendRedirect(request.getContextPath()
                        + "/admin/users?message=User updated successfully");
            } else {
                response.sendRedirect(
                        request.getContextPath() + "/admin/users?error=Failed to update user");
            }
        } catch (IllegalArgumentException e) {
            response.sendRedirect(request.getContextPath() + "/admin/users?error=Invalid user ID");
        }
    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        UserDAO userDAO = baseController.userDAO;
        String userIdStr = request.getParameter("id");

        if (userIdStr == null || userIdStr.trim().isEmpty()) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/users?error=User ID is required");
            return;
        }

        try {
            UUID userId = UUID.fromString(userIdStr);

            // Check if user exists
            User user = userDAO.getUserById(userId);
            if (user == null) {
                response.sendRedirect(
                        request.getContextPath() + "/admin/users?error=User not found");
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
                        + "/admin/users?message=User deleted successfully");
            } else {
                response.sendRedirect(
                        request.getContextPath() + "/admin/users?error=Failed to delete user");
            }
        } catch (IllegalArgumentException e) {
            response.sendRedirect(request.getContextPath() + "/admin/users?error=Invalid user ID");
        }
    }

    /**
     * Search passengers (users with USER role) - returns JSON
     */
    private void searchPassengers(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        UserDAO userDAO = baseController.userDAO;
        String searchTerm = request.getParameter("search");
        List<User> passengers;

        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            passengers = userDAO.searchUsers(searchTerm, "USER");
        } else {
            passengers = userDAO.getUsersByRole("USER");
        }

        // Set response content type to JSON
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // Create JSON response
        StringBuilder jsonResponse = new StringBuilder();
        jsonResponse.append("[");

        for (int i = 0; i < passengers.size(); i++) {
            User passenger = passengers.get(i);
            jsonResponse.append("{");
            jsonResponse.append("\"userId\":\"").append(passenger.getUserId()).append("\",");
            jsonResponse.append("\"fullName\":\"").append(passenger.getFullName()).append("\",");
            jsonResponse.append("\"email\":\"").append(passenger.getEmail()).append("\",");
            jsonResponse.append("\"phoneNumber\":\"").append(passenger.getPhoneNumber())
                    .append("\",");
            jsonResponse.append("\"username\":\"").append(passenger.getUsername()).append("\"");
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

