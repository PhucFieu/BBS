package controller;

import java.io.IOException;
import java.net.URLEncoder;
import java.sql.SQLException;
import java.util.List;
import java.util.UUID;

import dao.StaffDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;

/**
 * Controller for managing Staff (STAFF role) accounts.
 * Handles CRUD operations for staff users in the admin panel.
 */
@WebServlet(urlPatterns = { "/admin/staffs/*", "/admin/staff/*" })
public class StaffManagementController extends HttpServlet {
    private AdminBaseController baseController;
    private StaffDAO staffDAO;

    @Override
    public void init() throws ServletException {
        baseController = new AdminBaseController() {
        };
        baseController.initializeDAOs();
        staffDAO = new StaffDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        if (pathInfo == null)
            pathInfo = "/";

        try {
            if (!baseController.isAdminAuthenticated(request)) {
                response.sendRedirect(request.getContextPath() + "/auth/login");
                return;
            }

            switch (pathInfo) {
                case "/":
                    showStaff(request, response);
                    break;
                case "/add":
                    showAddStaffForm(request, response);
                    break;
                case "/edit":
                    showEditStaffForm(request, response);
                    break;
                case "/delete":
                    deleteStaff(request, response);
                    break;
                case "/search":
                    searchStaff(request, response);
                    break;
                default:
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
        if (pathInfo == null)
            pathInfo = "/";

        try {
            if (!baseController.isAdminAuthenticated(request)) {
                response.sendRedirect(request.getContextPath() + "/auth/login");
                return;
            }

            switch (pathInfo) {
                case "/add":
                    addStaff(request, response);
                    break;
                case "/update":
                    updateStaff(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            handleError(request, response, "Database error: " + e.getMessage());
        }
    }

    private void showStaff(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        String searchTerm = request.getParameter("search");
        List<User> staffList;

        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            staffList = staffDAO.searchStaff(searchTerm);
        } else {
            staffList = staffDAO.getAllStaff();
        }

        request.setAttribute("users", staffList);
        request.setAttribute("searchTerm", searchTerm);
        request.setAttribute("roleFilter", "STAFF");
        request.setAttribute("managementPath", "/admin/staffs");
        request.setAttribute("roleDisplayName", "Staff");
        request.setAttribute("totalStaff", staffDAO.getTotalStaff());

        request.getRequestDispatcher("/views/admin/users.jsp").forward(request, response);
    }

    private void showAddStaffForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("roleFilter", "STAFF");
        request.setAttribute("managementPath", "/admin/staffs");
        request.setAttribute("roleDisplayName", "Staff");
        request.setAttribute("isAddMode", true);
        request.getRequestDispatcher("/views/admin/user-form.jsp").forward(request, response);
    }

    private void showEditStaffForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        String userIdStr = request.getParameter("id");
        if (userIdStr == null || userIdStr.trim().isEmpty()) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/staffs?error=Staff ID is required");
            return;
        }

        try {
            UUID userId = UUID.fromString(userIdStr);
            User staff = staffDAO.getStaffById(userId);

            if (staff != null) {
                if (!"STAFF".equals(staff.getRole())) {
                    response.sendRedirect(request.getContextPath() + "/admin/staffs"
                            + "?error=Wrong role for this management area");
                    return;
                }
                request.setAttribute("user", staff);
                request.setAttribute("roleFilter", "STAFF");
                request.setAttribute("managementPath", "/admin/staffs");
                request.setAttribute("roleDisplayName", "Staff");
                request.setAttribute("isAddMode", false);
                request.getRequestDispatcher("/views/admin/user-form.jsp").forward(request,
                        response);
            } else {
                response.sendRedirect(
                        request.getContextPath() + "/admin/staffs?error=Staff not found");
            }
        } catch (IllegalArgumentException e) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/staffs?error=Invalid staff ID");
        }
    }

    private void addStaff(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phoneNumber = request.getParameter("phoneNumber");
        String idCard = request.getParameter("idCard");
        String address = request.getParameter("address");
        String gender = request.getParameter("gender");
        String dateOfBirthStr = request.getParameter("dateOfBirth");

        // Validate input
        if (username == null || password == null || fullName == null) {
            response.sendRedirect(request.getContextPath()
                    + "/admin/staffs/add?error=Required fields are missing");
            return;
        }

        // Check if username already exists
        if (staffDAO.usernameExists(username)) {
            response.sendRedirect(request.getContextPath()
                    + "/admin/staffs/add?error=Username already exists");
            return;
        }

        // Check if email exists
        if (email != null && !email.trim().isEmpty() && staffDAO.emailExists(email, null)) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/staffs/add?error=Email already exists");
            return;
        }

        // Check if phone number exists
        if (phoneNumber != null && !phoneNumber.trim().isEmpty()
                && staffDAO.phoneNumberExists(phoneNumber, null)) {
            response.sendRedirect(request.getContextPath()
                    + "/admin/staffs/add?error=Phone number already exists");
            return;
        }

        try {
            User newStaff = new User();
            newStaff.setUserId(UUID.randomUUID());
            newStaff.setUsername(username);
            newStaff.setPassword(password);
            newStaff.setFullName(fullName);
            newStaff.setEmail(email);
            newStaff.setPhoneNumber(phoneNumber);
            newStaff.setIdCard(idCard);
            newStaff.setAddress(address);
            if (dateOfBirthStr != null && !dateOfBirthStr.trim().isEmpty()) {
                try {
                    java.time.LocalDate dob = java.time.LocalDate.parse(dateOfBirthStr);
                    if (dob.isAfter(java.time.LocalDate.now())) {
                        response.sendRedirect(request.getContextPath()
                                + "/admin/staffs/add?error=Date of birth cannot be in the future");
                        return;
                    }
                    newStaff.setDateOfBirth(dob);
                } catch (Exception ex) {
                    response.sendRedirect(request.getContextPath() + "/admin/staffs/add?error=Invalid date of birth");
                    return;
                }
            }
            newStaff.setGender(gender);
            newStaff.setRole("STAFF");
            newStaff.setStatus("ACTIVE");

            boolean success = staffDAO.addStaff(newStaff);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/staffs"
                        + "?message=Staff added successfully");
            } else {
                response.sendRedirect(
                        request.getContextPath() + "/admin/staffs/add?error=Failed to add staff");
            }
        } catch (java.sql.SQLException e) {
            // Map SQL exceptions (e.g., unique constraint violations) to a user-friendly
            // message
            String friendly;
            String msg = e.getMessage() == null ? "" : e.getMessage().toLowerCase();
            if (msg.contains("duplicate") || msg.contains("unique") || msg.contains("duplicate key")) {
                friendly = "Duplicate data: username/email/phone number/ID card already exists. Please check and try again.";
            } else {
                friendly = "Database error. Please try again or contact the administrator.";
            }

            try {
                response.sendRedirect(request.getContextPath() + "/admin/staffs/add?error="
                        + URLEncoder.encode(friendly, "UTF-8"));
            } catch (Exception ex) {
                response.sendRedirect(request.getContextPath() + "/admin/staffs/add?error=Error");
            }
        } catch (Exception e) {
            try {
                response.sendRedirect(request.getContextPath() + "/admin/staffs/add?error="
                        + URLEncoder.encode("An error occurred. Please try again.", "UTF-8"));
            } catch (Exception ex) {
                response.sendRedirect(request.getContextPath() + "/admin/staffs/add?error=Error");
            }
        }
    }

    private void updateStaff(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String userIdStr = request.getParameter("userId");
        String username = request.getParameter("username");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phoneNumber = request.getParameter("phoneNumber");
        String dateOfBirthStr = request.getParameter("dateOfBirth");
        String gender = request.getParameter("gender");
        String status = request.getParameter("status");

        // Validate input
        if (userIdStr == null || username == null || fullName == null) {
            response.sendRedirect(request.getContextPath()
                    + "/admin/staffs?error=Required fields are missing");
            return;
        }

        try {
            UUID userId = UUID.fromString(userIdStr);
            User existingStaff = staffDAO.getStaffById(userId);

            if (existingStaff == null) {
                response.sendRedirect(
                        request.getContextPath() + "/admin/staffs?error=Staff not found");
                return;
            }

            if (!"STAFF".equals(existingStaff.getRole())) {
                response.sendRedirect(request.getContextPath() + "/admin/staffs"
                        + "?error=Only staff accounts are managed here");
                return;
            }

            // Check email uniqueness (excluding current user)
            if (email != null && !email.trim().isEmpty()
                    && staffDAO.emailExists(email, userId)) {
                response.sendRedirect(request.getContextPath() + "/admin/staffs/edit?id="
                        + userIdStr + "&error=Email already exists");
                return;
            }

            // Check phone number uniqueness (excluding current user)
            if (phoneNumber != null && !phoneNumber.trim().isEmpty()
                    && staffDAO.phoneNumberExists(phoneNumber, userId)) {
                response.sendRedirect(request.getContextPath() + "/admin/staffs/edit?id="
                        + userIdStr + "&error=Phone number already exists");
                return;
            }

            // Update staff
            existingStaff.setUsername(username);
            existingStaff.setFullName(fullName);
            // Validate date of birth if provided
            if (dateOfBirthStr != null && !dateOfBirthStr.trim().isEmpty()) {
                try {
                    java.time.LocalDate dob = java.time.LocalDate.parse(dateOfBirthStr);
                    if (dob.isAfter(java.time.LocalDate.now())) {
                        response.sendRedirect(request.getContextPath() + "/admin/staffs/edit?id="
                                + userIdStr + "&error=Date of birth cannot be in the future");
                        return;
                    }
                    existingStaff.setDateOfBirth(dob);
                } catch (Exception ex) {
                    response.sendRedirect(request.getContextPath() + "/admin/staffs/edit?id=" + userIdStr
                            + "&error=Invalid date of birth");
                    return;
                }
            }

            existingStaff.setGender(gender);
            existingStaff.setEmail(email);
            existingStaff.setPhoneNumber(phoneNumber);
            existingStaff.setStatus(status);

            boolean success = staffDAO.updateStaff(existingStaff);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/staffs"
                        + "?message=Staff updated successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/staffs"
                        + "?error=Failed to update staff");
            }
        } catch (IllegalArgumentException e) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/staffs?error=Invalid staff ID");
        }
    }

    private void deleteStaff(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String userIdStr = request.getParameter("id");

        if (userIdStr == null || userIdStr.trim().isEmpty()) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/staffs?error=Staff ID is required");
            return;
        }

        try {
            UUID userId = UUID.fromString(userIdStr);
            User staff = staffDAO.getStaffById(userId);

            if (staff == null) {
                response.sendRedirect(
                        request.getContextPath() + "/admin/staffs?error=Staff not found");
                return;
            }

            if (!"STAFF".equals(staff.getRole())) {
                response.sendRedirect(request.getContextPath() + "/admin/staffs"
                        + "?error=Wrong role for this management area");
                return;
            }

            // Prevent admin from deleting themselves
            User currentUser = baseController.getCurrentUser(request);
            if (currentUser != null && currentUser.getUserId().equals(userId)) {
                response.sendRedirect(request.getContextPath()
                        + "/admin/staffs?error=Cannot delete your own account");
                return;
            }

            boolean success = staffDAO.deleteStaff(userId);

            if (success) {
                response.sendRedirect(request.getContextPath()
                        + "/admin/staffs?message=Staff deleted successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/staffs"
                        + "?error=Failed to delete staff");
            }
        } catch (IllegalArgumentException e) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/staffs?error=Invalid staff ID");
        }
    }

    private void searchStaff(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        String searchTerm = request.getParameter("search");
        List<User> staffList;

        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            staffList = staffDAO.searchStaff(searchTerm);
        } else {
            staffList = staffDAO.getAllStaff();
        }

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        StringBuilder jsonResponse = new StringBuilder();
        jsonResponse.append("[");

        for (int i = 0; i < staffList.size(); i++) {
            User staff = staffList.get(i);
            jsonResponse.append("{");
            jsonResponse.append("\"userId\":\"").append(staff.getUserId()).append("\",");
            jsonResponse.append("\"fullName\":\"").append(staff.getFullName()).append("\",");
            jsonResponse.append("\"email\":\"").append(staff.getEmail()).append("\",");
            jsonResponse.append("\"phoneNumber\":\"").append(staff.getPhoneNumber()).append("\",");
            jsonResponse.append("\"username\":\"").append(staff.getUsername()).append("\"");
            jsonResponse.append("}");

            if (i < staffList.size() - 1) {
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
