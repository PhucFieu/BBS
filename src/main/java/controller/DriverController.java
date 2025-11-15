package controller;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import com.google.gson.Gson;

import dao.DriverDAO;
import dao.RatingDAO;
import dao.ScheduleDAO;
import dao.TicketDAO;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Driver;
import model.Schedule;
import model.Tickets;
import util.AuthUtils;

@WebServlet(urlPatterns = {"/driver/*", "/admin/drivers/*"})
public class DriverController extends HttpServlet {
    private DriverDAO driverDAO;
    private ScheduleDAO scheduleDAO;
    private TicketDAO ticketDAO;
    private UserDAO userDAO;
    private final Gson gson = new Gson();

    @Override
    public void init() throws ServletException {
        driverDAO = new DriverDAO();
        scheduleDAO = new ScheduleDAO();
        ticketDAO = new TicketDAO();
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
                // Admin endpoints
                HttpSession session = request.getSession(false);
                if (session == null || session.getAttribute("user") == null) {
                    response.sendRedirect(request.getContextPath() + "/auth/login");
                    return;
                }
                if (!AuthUtils.canManageDrivers(session)) {
                    request.setAttribute("error", "Access denied: ADMIN required");
                    request.getRequestDispatcher("/views/errors/403.jsp").forward(request,
                            response);
                    return;
                }

                if ("/".equals(pathInfo)) {
                    adminShowDrivers(request, response);
                } else if ("/add".equals(pathInfo)) {
                    adminShowAddDriverForm(request, response);
                } else if ("/edit".equals(pathInfo)) {
                    adminShowEditDriverForm(request, response);
                } else if ("/delete".equals(pathInfo)) {
                    adminDeleteDriver(request, response);
                } else if ("/search".equals(pathInfo)) {
                    adminSearchDrivers(request, response);
                } else if ("/assign".equals(pathInfo)) {
                    adminShowAssignDriverForm(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                }
            } else {
                // Driver endpoints
                HttpSession session = request.getSession(false);
                if (session == null || session.getAttribute("user") == null) {
                    response.sendRedirect(request.getContextPath() + "/auth/login");
                    return;
                }
                if (!AuthUtils.isDriver(session)) {
                    request.setAttribute("error", "Access denied: DRIVER role required");
                    request.getRequestDispatcher("/views/errors/403.jsp").forward(request,
                            response);
                    return;
                }

                if (pathInfo.equals("/") || pathInfo.equals("/dashboard")) {
                    showDashboard(request, response);
                } else if (pathInfo.equals("/trips")) {
                    showAssignedTrips(request, response);
                } else if (pathInfo.equals("/trip-details")) {
                    respondTripDetails(request, response);
                } else if (pathInfo.equals("/update-status")) {
                    showUpdateStatusForm(request, response);
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
                HttpSession session = request.getSession(false);
                if (session == null || session.getAttribute("user") == null) {
                    response.sendRedirect(request.getContextPath() + "/auth/login");
                    return;
                }
                if (!AuthUtils.canManageDrivers(session)) {
                    request.setAttribute("error", "Access denied: ADMIN required");
                    request.getRequestDispatcher("/views/errors/403.jsp").forward(request,
                            response);
                    return;
                }

                if ("/add".equals(pathInfo)) {
                    adminAddDriver(request, response);
                } else if ("/edit".equals(pathInfo)) {
                    adminUpdateDriver(request, response);
                } else if ("/assign".equals(pathInfo)) {
                    adminAssignDriverToTrip(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                }
            } else {
                // Driver endpoints
                HttpSession session = request.getSession(false);
                if (session == null || session.getAttribute("user") == null) {
                    response.sendRedirect(request.getContextPath() + "/auth/login");
                    return;
                }
                if (!AuthUtils.isDriver(session)) {
                    request.setAttribute("error", "Access denied: DRIVER role required");
                    request.getRequestDispatcher("/views/errors/403.jsp").forward(request,
                            response);
                    return;
                }

                if (pathInfo.equals("/update-status")) {
                    updateTripStatus(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                }
            }
        } catch (SQLException e) {
            handleError(request, response, "Database error: " + e.getMessage());
        }
    }

    /**
     * Show driver dashboard
     */
    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        HttpSession session = request.getSession(false);
        UUID userId = (UUID) session.getAttribute("userId");

        // Ensure driver profile exists (auto-create if missing)
        Driver driver = driverDAO.getDriverByUserId(userId);
        if (driver == null) {
            try {
                model.Driver newDriver = new model.Driver();
                newDriver.setUserId(userId);
                String placeholder = "TEMP-" + userId.toString().replace("-", "");
                placeholder = placeholder.substring(Math.max(0, placeholder.length() - 10));
                newDriver.setLicenseNumber(placeholder);
                newDriver.setExperienceYears(0);
                newDriver.setStatus("ACTIVE");

                boolean created = driverDAO.addDriver(newDriver);
                if (!created) {
                    request.setAttribute("error",
                            "Unable to auto-create driver profile for current user");
                    request.getRequestDispatcher("/views/errors/403.jsp").forward(request,
                            response);
                    return;
                }

                driver = driverDAO.getDriverByUserId(userId);
            } catch (SQLException ex) {
                request.setAttribute("error",
                        "Database error while creating driver profile: " + ex.getMessage());
                request.getRequestDispatcher("/views/errors/403.jsp").forward(request, response);
                return;
            }
        }

        // Optionally show a quick summary of assigned trips
        List<Schedule> assignedTrips = scheduleDAO.getSchedulesByDriverId(driver.getDriverId());

        request.setAttribute("driver", driver);
        request.setAttribute("trips", assignedTrips);
        request.getRequestDispatcher("/views/driver/dashboard.jsp").forward(request, response);
    }

    /**
     * Show assigned trips for the current driver
     */
    private void showAssignedTrips(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        HttpSession session = request.getSession(false);
        UUID userId = (UUID) session.getAttribute("userId");

        // Get driver info
        Driver driver = driverDAO.getDriverByUserId(userId);
        if (driver == null) {
            // Auto-create a minimal driver profile for this user and continue to dashboard
            try {
                model.Driver newDriver = new model.Driver();
                newDriver.setUserId(userId);
                // Create a placeholder license number; can be updated later by admin
                String placeholder = "TEMP-" + userId.toString().replace("-", "");
                placeholder = placeholder.substring(Math.max(0, placeholder.length() - 10));
                newDriver.setLicenseNumber(placeholder);
                newDriver.setExperienceYears(0);
                newDriver.setStatus("ACTIVE");

                boolean created = driverDAO.addDriver(newDriver);
                if (!created) {
                    request.setAttribute("error",
                            "Unable to auto-create driver profile for current user");
                    request.getRequestDispatcher("/views/errors/403.jsp").forward(request,
                            response);
                    return;
                }

                // Reload the driver profile
                driver = driverDAO.getDriverByUserId(userId);
            } catch (SQLException ex) {
                request.setAttribute("error",
                        "Database error while creating driver profile: " + ex.getMessage());
                request.getRequestDispatcher("/views/errors/403.jsp").forward(request, response);
                return;
            }
        }

        // Get assigned schedules for this driver
        List<Schedule> assignedTrips = scheduleDAO.getSchedulesByDriverId(driver.getDriverId());

        request.setAttribute("driver", driver);
        request.setAttribute("trips", assignedTrips);
        request.getRequestDispatcher("/views/driver/trips.jsp").forward(request, response);
    }

    /**
     * Respond with trip passenger details in JSON for modal display
     */
    private void respondTripDetails(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        Map<String, Object> payload = new HashMap<>();
        String scheduleIdStr = request.getParameter("scheduleId");

        if (scheduleIdStr == null || scheduleIdStr.trim().isEmpty()) {
            payload.put("success", false);
            payload.put("message", "Schedule ID is required");
            writeJson(response, HttpServletResponse.SC_BAD_REQUEST, payload);
            return;
        }

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            payload.put("success", false);
            payload.put("message", "Session has expired. Please sign in again.");
            writeJson(response, HttpServletResponse.SC_UNAUTHORIZED, payload);
            return;
        }

        UUID scheduleId;
        try {
            scheduleId = UUID.fromString(scheduleIdStr);
        } catch (IllegalArgumentException e) {
            payload.put("success", false);
            payload.put("message", "Invalid schedule ID format");
            writeJson(response, HttpServletResponse.SC_BAD_REQUEST, payload);
            return;
        }

        UUID userId = (UUID) session.getAttribute("userId");

        try {
            Driver driver = driverDAO.getDriverByUserId(userId);
            if (driver == null) {
                payload.put("success", false);
                payload.put("message", "Driver profile not found");
                writeJson(response, HttpServletResponse.SC_FORBIDDEN, payload);
                return;
            }

            boolean isAssigned = scheduleDAO.isDriverAssignedToSchedule(scheduleId,
                    driver.getDriverId());
            if (!isAssigned) {
                payload.put("success", false);
                payload.put("message", "Access denied for this schedule");
                writeJson(response, HttpServletResponse.SC_FORBIDDEN, payload);
                return;
            }

            List<Tickets> passengers = ticketDAO.getTicketsByScheduleId(scheduleId);
            List<Map<String, Object>> passengerData = new ArrayList<>();

            for (Tickets ticket : passengers) {
                Map<String, Object> passengerInfo = new HashMap<>();
                passengerInfo.put("fullName", ticket.getUserName());
                passengerInfo.put("username", ticket.getUsername());
                passengerInfo.put("seatNumber", ticket.getSeatNumber());
                passengerInfo.put("ticketNumber", ticket.getTicketNumber());
                passengerInfo.put("boardingStation", ticket.getBoardingStationName());
                passengerInfo.put("boardingCity", ticket.getBoardingCity());
                passengerInfo.put("alightingStation", ticket.getAlightingStationName());
                passengerInfo.put("alightingCity", ticket.getAlightingCity());
                passengerData.add(passengerInfo);
            }

            payload.put("success", true);
            payload.put("count", passengerData.size());
            payload.put("passengers", passengerData);
            writeJson(response, HttpServletResponse.SC_OK, payload);

        } catch (SQLException ex) {
            getServletContext().log("Failed to load trip details", ex);
            payload.put("success", false);
            payload.put("message", "Failed to load trip details. Please try again later.");
            writeJson(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, payload);
        }
    }

    private void writeJson(HttpServletResponse response, int status, Map<String, Object> payload)
            throws IOException {
        response.setStatus(status);
        response.getWriter().write(gson.toJson(payload));
    }

    /**
     * Show update status form
     */
    private void showUpdateStatusForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        String scheduleIdStr = request.getParameter("scheduleId");
        if (scheduleIdStr == null || scheduleIdStr.trim().isEmpty()) {
            response.sendRedirect(
                    request.getContextPath() + "/driver/trips?error=Schedule ID is required");
            return;
        }

        try {
            UUID scheduleId = UUID.fromString(scheduleIdStr);

            // Get schedule details
            Schedule schedule = scheduleDAO.getScheduleById(scheduleId);
            if (schedule == null) {
                response.sendRedirect(
                        request.getContextPath() + "/driver/trips?error=Schedule not found");
                return;
            }

            // Load route stops for station selection when stopping
            dao.RouteStopDAO routeStopDAO = new dao.RouteStopDAO();
            java.util.List<model.RouteStop> routeStops =
                    routeStopDAO.getRouteStopsByRoute(schedule.getRouteId());

            request.setAttribute("schedule", schedule);
            request.setAttribute("routeStops", routeStops);
            request.getRequestDispatcher("/views/driver/update-status.jsp").forward(request,
                    response);

        } catch (NumberFormatException e) {
            response.sendRedirect(
                    request.getContextPath() + "/driver/trips?error=Invalid schedule ID");
        }
    }

    /**
     * Update trip status
     */
    private void updateTripStatus(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {

        String scheduleIdStr = request.getParameter("scheduleId");
        String newStatus = request.getParameter("status");
        String notes = request.getParameter("notes");
        String stopStationIdStr = request.getParameter("stopStationId");

        if (scheduleIdStr == null || scheduleIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath()
                    + "/driver/trips?error=Missing information: Schedule ID is required");
            return;
        }
        if (newStatus == null || newStatus.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath()
                    + "/driver/update-status?scheduleId=" + scheduleIdStr + "&error=Missing information: Please select a status");
            return;
        }

        try {
            UUID scheduleId = UUID.fromString(scheduleIdStr);

            // If stopping at station, ensure station chosen and append to notes for audit
            if ("STOP_AT_STATION".equals(newStatus)) {
                if (stopStationIdStr == null || stopStationIdStr.trim().isEmpty()) {
                    response.sendRedirect(request.getContextPath()
                            + "/driver/update-status?scheduleId=" + scheduleId
                            + "&error=Missing information: Please choose a station when selecting Stop at station");
                    return;
                }
                try {
                    java.util.UUID stationId = java.util.UUID.fromString(stopStationIdStr);
                    // Fetch station name for notes
                    dao.StationDAO stationDAO = new dao.StationDAO();
                    model.Station station = stationDAO.getStationById(stationId);
                    if (station != null) {
                        String suffix = " [Stop at: " + station.getStationName() + ", "
                                + station.getCity() + "]";
                        notes = (notes == null || notes.isBlank()) ? suffix : (notes + suffix);
                    }
                } catch (IllegalArgumentException ex) {
                    response.sendRedirect(request.getContextPath()
                            + "/driver/update-status?scheduleId=" + scheduleId
                            + "&error=Error: Invalid station selected. Please choose a valid station");
                    return;
                }
            }

            // Update schedule status
            boolean success = scheduleDAO.updateScheduleStatus(scheduleId, newStatus, notes);

            if (success) {
                response.sendRedirect(
                        request.getContextPath()
                                + "/driver/trips?message=Trip status updated successfully! The trip status has been changed to " + newStatus);
            } else {
                response.sendRedirect(request.getContextPath()
                        + "/driver/update-status?scheduleId=" + scheduleIdStr + "&error=Error: Failed to update trip status. Please try again or contact administrator");
            }

        } catch (IllegalArgumentException e) {
            response.sendRedirect(
                    request.getContextPath() + "/driver/trips?error=Error: Invalid schedule ID format. Please check again");
        } catch (Exception e) {
            response.sendRedirect(
                    request.getContextPath() + "/driver/trips?error=Error: An unexpected error occurred while updating trip status. " + e.getMessage());
        }
    }

    /**
     * Handle errors
     */
    private void handleError(HttpServletRequest request, HttpServletResponse response,
            String message)
            throws ServletException, IOException {
        request.setAttribute("error", message);
        request.getRequestDispatcher("/views/errors/error.jsp").forward(request, response);
    }

    // Admin-specific handlers
    private void adminShowDrivers(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        List<Driver> drivers = driverDAO.getAllDrivers();
        RatingDAO ratingDAO = new RatingDAO();
        java.util.Map<java.util.UUID, java.lang.Double> driverAvgMap = new java.util.HashMap<>();
        java.util.Map<java.util.UUID, java.lang.Integer> driverTotalMap = new java.util.HashMap<>();
        for (Driver d : drivers) {
            double avg = 0.0;
            int total = 0;
            try {
                avg = ratingDAO.getAverageRatingByDriver(d.getDriverId());
            } catch (SQLException ignored) {
            }
            try {
                total = ratingDAO.getTotalRatingsByDriver(d.getDriverId());
            } catch (SQLException ignored) {
            }
            driverAvgMap.put(d.getDriverId(), avg);
            driverTotalMap.put(d.getDriverId(), total);
        }
        request.setAttribute("drivers", drivers);
        request.setAttribute("driverAvgMap", driverAvgMap);
        request.setAttribute("driverTotalMap", driverTotalMap);
        request.getRequestDispatcher("/views/admin/drivers.jsp").forward(request, response);
    }

    private void adminShowAddDriverForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/admin/driver-form.jsp").forward(request, response);
    }

    private void adminShowEditDriverForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        String driverIdStr = request.getParameter("id");
        if (driverIdStr == null || driverIdStr.trim().isEmpty()) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/drivers?error=Missing information: Driver ID is required");
            return;
        }
        try {
            UUID driverId = UUID.fromString(driverIdStr);
            Driver driver = driverDAO.getDriverById(driverId);
            if (driver != null) {
                request.setAttribute("driver", driver);
                request.getRequestDispatcher("/views/admin/driver-form.jsp").forward(request,
                        response);
            } else {
                response.sendRedirect(
                        request.getContextPath() + "/admin/drivers?error=Error: Driver not found with the given ID");
            }
        } catch (IllegalArgumentException e) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/drivers?error=Error: Invalid driver ID format. Please check again");
        }
    }

    private void adminDeleteDriver(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String driverIdStr = request.getParameter("id");
        if (driverIdStr == null || driverIdStr.trim().isEmpty()) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/drivers?error=Missing information: Driver ID is required");
            return;
        }
        try {
            UUID driverId = UUID.fromString(driverIdStr);
            Driver driver = driverDAO.getDriverById(driverId);
            if (driver == null) {
                response.sendRedirect(
                        request.getContextPath() + "/admin/drivers?error=Error: Driver not found with the given ID");
                return;
            }
            boolean hasActiveSchedules = scheduleDAO.hasDriverActiveSchedules(driverId);
            if (hasActiveSchedules) {
                response.sendRedirect(request.getContextPath()
                        + "/admin/drivers?error=Error: Cannot delete driver. Driver is currently assigned to active schedules. Please reassign or cancel the schedules first.");
                return;
            }
            boolean hasPendingTickets = ticketDAO.hasDriverPendingTickets(driverId);
            if (hasPendingTickets) {
                response.sendRedirect(request.getContextPath()
                        + "/admin/drivers?error=Error: Cannot delete driver. Driver has pending tickets. Please resolve all pending tickets first.");
                return;
            }
            boolean driverDeleted = driverDAO.deleteDriver(driverId);
            if (driverDeleted) {
                boolean userDeactivated = userDAO.deactivateUser(driver.getUserId());
                if (userDeactivated) {
                    response.sendRedirect(request.getContextPath()
                            + "/admin/drivers?message=Driver and account deactivated successfully! Driver has been removed from the system");
                } else {
                    response.sendRedirect(request.getContextPath()
                            + "/admin/drivers?warning=Driver deactivated successfully, but user account may still be active. Please check the user account status.");
                }
            } else {
                response.sendRedirect(
                        request.getContextPath() + "/admin/drivers?error=Error: Failed to delete driver. Please try again or contact administrator");
            }
        } catch (IllegalArgumentException e) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/drivers?error=Error: Invalid driver ID format. Please check again");
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath()
                    + "/admin/drivers?error=Error: An unexpected error occurred while deleting the driver. " + e.getMessage());
        }
    }

    private void adminSearchDrivers(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        String searchTerm = request.getParameter("search");
        List<Driver> drivers = (searchTerm != null && !searchTerm.trim().isEmpty())
                ? driverDAO.searchDrivers(searchTerm)
                : driverDAO.getAllDrivers();
        request.setAttribute("drivers", drivers);
        request.setAttribute("searchTerm", searchTerm);
        request.getRequestDispatcher("/views/admin/drivers.jsp").forward(request, response);
    }

    private void adminShowAssignDriverForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        String scheduleIdStr = request.getParameter("scheduleId");
        if (scheduleIdStr == null || scheduleIdStr.trim().isEmpty()) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/schedules?error=Missing information: Schedule ID is required");
            return;
        }
        try {
            UUID scheduleId = UUID.fromString(scheduleIdStr);
            Schedule schedule = scheduleDAO.getScheduleById(scheduleId);
            if (schedule == null) {
                response.sendRedirect(
                        request.getContextPath() + "/admin/schedules?error=Error: Schedule not found with the given ID");
                return;
            }
            List<Driver> drivers = driverDAO.getAllDrivers();
            request.setAttribute("schedule", schedule);
            request.setAttribute("drivers", drivers);
            request.getRequestDispatcher("/views/admin/assign-driver.jsp").forward(request,
                    response);
        } catch (IllegalArgumentException e) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/schedules?error=Error: Invalid schedule ID format. Please check again");
        }
    }

    private void adminAddDriver(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phoneNumber = request.getParameter("phoneNumber");
        String licenseNumber = request.getParameter("licenseNumber");
        String experienceYearsStr = request.getParameter("experienceYears");

        // Trim and validate required fields with specific error messages
        if (username == null || username.trim().isEmpty()) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/admin/drivers/add?error=Missing information: Username is required");
            return;
        }
        if (password == null || password.trim().isEmpty()) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/admin/drivers/add?error=Missing information: Password is required");
            return;
        }
        if (fullName == null || fullName.trim().isEmpty()) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/admin/drivers/add?error=Missing information: Full name is required");
            return;
        }
        if (licenseNumber == null || licenseNumber.trim().isEmpty()) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/admin/drivers/add?error=Missing information: License number is required");
            return;
        }
        if (experienceYearsStr == null || experienceYearsStr.trim().isEmpty()) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/admin/drivers/add?error=Missing information: Experience years is required");
            return;
        }

        // Trim all input fields
        username = username.trim();
        password = password.trim();
        fullName = fullName.trim();
        licenseNumber = licenseNumber.trim();

        // Normalize email and phone (can be empty, but not just whitespace)
        if (email != null) {
            email = email.trim();
            if (email.isEmpty()) {
                email = null; // Convert empty string to null
            }
        }

        if (phoneNumber != null) {
            phoneNumber = phoneNumber.trim();
            if (phoneNumber.isEmpty()) {
                phoneNumber = null; // Convert empty string to null
            }
        }

        // Validate email format only if provided
        if (email != null && !email.isEmpty() && !email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            response.sendRedirect(request.getContextPath()
                    + "/admin/drivers/add?error=Error: Invalid email format. Please enter a valid email address");
            return;
        }

        // Validate phone number format only if provided
        if (phoneNumber != null && !phoneNumber.isEmpty() && !phoneNumber.matches("^(0[3|5|7|8|9])[0-9]{8}$")) {
            response.sendRedirect(request.getContextPath()
                    + "/admin/drivers/add?error=Error: Invalid phone number format. Please use Vietnamese format (e.g., 0907450814)");
            return;
        }

        try {
            int experienceYears = Integer.parseInt(experienceYearsStr);

            if (experienceYears < 0) {
                response.sendRedirect(request.getContextPath()
                        + "/admin/drivers/add?error=Error: Experience years must be a positive number (0 or greater)");
                return;
            }

            // Check username uniqueness
            model.User existingUser = userDAO.getUserByUsername(username);
            if (existingUser != null) {
                response.sendRedirect(request.getContextPath()
                        + "/admin/drivers/add?error=Error: Username already exists. Please choose a different username");
                return;
            }

            // Check email uniqueness only if email is provided
            if (email != null && !email.isEmpty()) {
                existingUser = userDAO.getUserByEmail(email);
                if (existingUser != null) {
                    response.sendRedirect(
                            request.getContextPath()
                                    + "/admin/drivers/add?error=Error: Email is already in use. Please use a different email");
                    return;
                }
            }

            // Check phone uniqueness only if phone is provided
            if (phoneNumber != null && !phoneNumber.isEmpty()) {
                existingUser = userDAO.getUserByPhone(phoneNumber);
                if (existingUser != null) {
                    response.sendRedirect(request.getContextPath()
                            + "/admin/drivers/add?error=Error: Phone number is already in use. Please use a different phone number");
                    return;
                }
            }

            // Check license number uniqueness
            Driver existingDriver = driverDAO.getDriverByLicenseNumber(licenseNumber);
            if (existingDriver != null) {
                response.sendRedirect(request.getContextPath()
                        + "/admin/drivers/add?error=Error: License number is already in use. Please use a different license number");
                return;
            }

            model.User user = new model.User();
            user.setUserId(UUID.randomUUID());
            user.setUsername(username);
            user.setPassword(password);
            user.setFullName(fullName);
            // Ensure email and phone are null if empty (already normalized above)
            user.setEmail(email);
            user.setPhoneNumber(phoneNumber);
            user.setRole("DRIVER");
            user.setStatus("ACTIVE");
            // Ensure id_card is unique to satisfy DB unique constraint without DB changes
            String autoIdCard =
                    "AUTO-" + user.getUserId().toString().replace("-", "").substring(0, 12);
            user.setIdCard(autoIdCard);
            user.setAddress(null);
            user.setGender(null);
            user.setDateOfBirth(null);

            try {
                boolean userSuccess = userDAO.addUser(user);
                if (!userSuccess) {
                    response.sendRedirect(request.getContextPath()
                            + "/admin/drivers/add?error=Error: Failed to create user account. Please try again or contact administrator");
                    return;
                }
            } catch (SQLException e) {
                // Log detailed error information
                System.err.println("=== ERROR: Failed to add driver user ===");
                System.err.println("Username: " + username);
                System.err.println("Email: " + email);
                System.err.println("Phone: " + phoneNumber);
                System.err.println("SQL Error: " + e.getMessage());
                System.err.println("Error Code: " + e.getErrorCode());
                System.err.println("SQL State: " + e.getSQLState());
                System.err.println("========================================");

                // Provide user-friendly error message
                String errorMsg = "Error: Database error occurred. " + e.getMessage();
                if (e.getMessage().contains("UNIQUE KEY constraint")) {
                    if (e.getMessage().contains("username")
                            || e.getMessage().contains("UQ__Users__")) {
                        errorMsg = "Error: Username already exists. Please choose a different username.";
                    } else if (e.getMessage().contains("email")) {
                        errorMsg = "Error: Email already exists. Please use a different email.";
                    } else if (e.getMessage().contains("phone")) {
                        errorMsg =
                                "Error: Phone number already exists. Please use a different phone number.";
                    } else {
                        errorMsg =
                                "Error: A unique constraint violation occurred. Please check username, email, phone number, or ID card.";
                    }
                }
                response.sendRedirect(request.getContextPath()
                        + "/admin/drivers/add?error="
                        + URLEncoder.encode(errorMsg, StandardCharsets.UTF_8));
                return;
            }
            Driver driver = new Driver();
            driver.setDriverId(UUID.randomUUID());
            driver.setUserId(user.getUserId());
            driver.setLicenseNumber(licenseNumber);
            driver.setExperienceYears(experienceYears);
            driver.setStatus("ACTIVE");
            boolean driverSuccess = driverDAO.addDriver(driver);
            if (driverSuccess) {
                response.sendRedirect(request.getContextPath()
                        + "/admin/drivers?message=Driver created successfully! Driver " + fullName + " has been added to the system");
            } else {
                userDAO.deleteUser(user.getUserId());
                response.sendRedirect(request.getContextPath()
                        + "/admin/drivers/add?error=Error: Failed to create driver profile. Please try again or contact administrator");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/drivers/add?error=Error: Invalid experience years format. Please enter a valid number");
        } catch (Exception e) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/drivers/add?error=Error: An unexpected error occurred. " + e.getMessage());
        }
    }

    private void adminUpdateDriver(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String driverIdStr = request.getParameter("driverId");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phoneNumber = request.getParameter("phoneNumber");
        String licenseNumber = request.getParameter("licenseNumber");
        String experienceYearsStr = request.getParameter("experienceYears");
        // Validate input with specific error messages
        if (driverIdStr == null || driverIdStr.trim().isEmpty()) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/drivers?error=Missing information: Driver ID is required");
            return;
        }
        if (fullName == null || fullName.trim().isEmpty()) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/drivers/edit?id=" + driverIdStr + "&error=Missing information: Full name is required");
            return;
        }
        if (email == null || email.trim().isEmpty()) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/drivers/edit?id=" + driverIdStr + "&error=Missing information: Email is required");
            return;
        }
        if (phoneNumber == null || phoneNumber.trim().isEmpty()) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/drivers/edit?id=" + driverIdStr + "&error=Missing information: Phone number is required");
            return;
        }
        if (licenseNumber == null || licenseNumber.trim().isEmpty()) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/drivers/edit?id=" + driverIdStr + "&error=Missing information: License number is required");
            return;
        }
        if (experienceYearsStr == null || experienceYearsStr.trim().isEmpty()) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/drivers/edit?id=" + driverIdStr + "&error=Missing information: Experience years is required");
            return;
        }
        if (!phoneNumber.matches("^(0[3|5|7|8|9])[0-9]{8}$")) {
            response.sendRedirect(request.getContextPath()
                    + "/admin/drivers/edit?id=" + driverIdStr + "&error=Error: Invalid phone number format. Please use Vietnamese format (e.g., 0907450814)");
            return;
        }
        try {
            UUID driverId = UUID.fromString(driverIdStr);
            int experienceYears = Integer.parseInt(experienceYearsStr);
            Driver existingDriver = driverDAO.getDriverById(driverId);
            if (existingDriver == null) {
                response.sendRedirect(
                        request.getContextPath() + "/admin/drivers?error=Error: Driver not found with the given ID");
                return;
            }
            existingDriver.setLicenseNumber(licenseNumber);
            existingDriver.setExperienceYears(experienceYears);
            boolean driverSuccess = driverDAO.updateDriver(existingDriver);
            if (driverSuccess) {
                model.User user = userDAO.getUserById(existingDriver.getUserId());
                if (user != null) {
                    user.setFullName(fullName);
                    user.setEmail(email);
                    user.setPhoneNumber(phoneNumber);
                    userDAO.updateUser(user);
                }
                response.sendRedirect(request.getContextPath()
                        + "/admin/drivers?message=Driver updated successfully! Driver " + fullName + " information has been saved");
            } else {
                response.sendRedirect(
                        request.getContextPath() + "/admin/drivers/edit?id=" + driverIdStr + "&error=Error: Failed to update driver. Please try again or contact administrator");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/drivers/edit?id=" + driverIdStr + "&error=Error: Invalid experience years format. Please enter a valid number");
        } catch (IllegalArgumentException e) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/drivers?error=Error: Invalid driver ID format");
        } catch (Exception e) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/drivers/edit?id=" + driverIdStr + "&error=Error: An unexpected error occurred. " + e.getMessage());
        }
    }

    private void adminAssignDriverToTrip(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String scheduleIdStr = request.getParameter("scheduleId");
        String driverIdStr = request.getParameter("driverId");
        if (scheduleIdStr == null || scheduleIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath()
                    + "/admin/schedules?error=Missing information: Schedule ID is required");
            return;
        }
        if (driverIdStr == null || driverIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath()
                    + "/admin/drivers/assign?scheduleId=" + scheduleIdStr + "&error=Missing information: Please select a driver");
            return;
        }
        try {
            UUID scheduleId = UUID.fromString(scheduleIdStr);
            UUID driverId = UUID.fromString(driverIdStr);

            Schedule schedule = scheduleDAO.getScheduleById(scheduleId);
            if (schedule == null) {
                response.sendRedirect(
                        request.getContextPath() + "/admin/schedules?error=Schedule not found");
                return;
            }

            Schedule conflictingSchedule = scheduleDAO.findDriverScheduleConflict(driverId,
                    schedule.getRouteId(), schedule.getDepartureDate(),
                    schedule.getDepartureTime(), schedule.getEstimatedArrivalTime(), scheduleId);
            if (conflictingSchedule != null) {
                Driver driver = driverDAO.getDriverById(driverId);
                String driverName = driver != null && driver.getFullName() != null
                        ? driver.getFullName()
                        : "this driver";

                String conflictDescription = String.format("%s (%s %s - %s)",
                        conflictingSchedule.getRouteName() != null
                                ? conflictingSchedule.getRouteName()
                                : "another schedule",
                        conflictingSchedule.getDepartureDate(),
                        conflictingSchedule.getDepartureTime(),
                        conflictingSchedule.getEstimatedArrivalTime());

                String errorMessage = String.format(
                        "Driver %s is already assigned to %s during this timeframe. Please select a different driver.",
                        driverName, conflictDescription);

                response.sendRedirect(
                        request.getContextPath() + "/admin/drivers/assign?scheduleId=" + scheduleId
                                + "&error="
                                + URLEncoder.encode(errorMessage, StandardCharsets.UTF_8));
                return;
            }

            boolean success = scheduleDAO.assignDriverToSchedule(scheduleId, driverId, true);
            if (success) {
                Driver driver = driverDAO.getDriverById(driverId);
                String driverName = driver != null && driver.getFullName() != null ? driver.getFullName() : "Driver";
                response.sendRedirect(request.getContextPath()
                        + "/admin/schedules?message=Driver assigned successfully! " + driverName + " has been assigned to this schedule");
            } else {
                response.sendRedirect(request.getContextPath()
                        + "/admin/drivers/assign?scheduleId=" + scheduleIdStr + "&error=Error: Failed to assign driver. Please try again or contact administrator");
            }
        } catch (IllegalArgumentException e) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/schedules?error=Error: Invalid ID format. Please check schedule ID and driver ID");
        } catch (Exception e) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/schedules?error=Error: An unexpected error occurred while assigning driver. " + e.getMessage());
        }
    }
}
