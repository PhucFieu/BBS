package controller;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;
import java.time.Duration;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import com.google.gson.Gson;

import dao.DriverDAO;
import dao.RatingDAO;
import dao.ScheduleDAO;
import dao.StationDAO;
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

@WebServlet(urlPatterns = { "/driver/*", "/admin/drivers/*" })
public class DriverController extends HttpServlet {
    private DriverDAO driverDAO;
    private ScheduleDAO scheduleDAO;
    private TicketDAO ticketDAO;
    private UserDAO userDAO;
    private StationDAO stationDAO;
    private final Gson gson = new Gson();

    @Override
    public void init() throws ServletException {
        driverDAO = new DriverDAO();
        scheduleDAO = new ScheduleDAO();
        ticketDAO = new TicketDAO();
        userDAO = new UserDAO();
        stationDAO = new StationDAO();
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
                } else if (pathInfo.equals("/schedule")) {
                    // Redirect to /trips since Schedule functionality is merged into My Trips
                    response.sendRedirect(request.getContextPath() + "/driver/trips");
                } else if (pathInfo.equals("/trips")) {
                    showAssignedTrips(request, response);
                } else if (pathInfo.equals("/trip-details")) {
                    respondTripDetails(request, response);
                } else if (pathInfo.equals("/check-in")) {
                    showCheckInPassengers(request, response);
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
                } else if (pathInfo.equals("/check-in")) {
                    performCheckIn(request, response);
                } else if (pathInfo.equals("/check-in-ajax")) {
                    performCheckInAjax(request, response);
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

        Driver driver = resolveOrCreateDriverProfile(request, response, userId);
        if (driver == null) {
            return; // resolveOrCreateDriverProfile already handled the response
        }

        // Get assigned schedules for this driver
        List<Schedule> assignedTrips = scheduleDAO.getSchedulesByDriverId(driver.getDriverId());

        request.setAttribute("driver", driver);
        request.setAttribute("trips", assignedTrips);
        request.getRequestDispatcher("/views/driver/trips.jsp").forward(request, response);
    }

    /**
     * Show schedule page for the current driver (calendar/table view)
     */
    private void showSchedule(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        HttpSession session = request.getSession(false);
        UUID userId = (UUID) session.getAttribute("userId");

        Driver driver = resolveOrCreateDriverProfile(request, response, userId);
        if (driver == null) {
            return;
        }

        List<Schedule> assignedTrips = scheduleDAO.getSchedulesByDriverId(driver.getDriverId());

        request.setAttribute("driver", driver);
        request.setAttribute("trips", assignedTrips);
        request.getRequestDispatcher("/views/driver/schedule.jsp").forward(request, response);
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

            // Show all passengers for this trip (including those not yet checked in)
            List<Tickets> passengers = ticketDAO.getTicketsByScheduleId(scheduleId);
            List<Map<String, Object>> passengerData = new ArrayList<>();

            for (Tickets ticket : passengers) {
                Map<String, Object> passengerInfo = new HashMap<>();
                // Use customer name if available (for staff-booked tickets), otherwise use user
                // name
                String displayName = (ticket.getCustomerName() != null
                        && !ticket.getCustomerName().trim().isEmpty())
                                ? ticket.getCustomerName()
                                : ticket.getUserName();
                String displayPhone = (ticket.getCustomerPhone() != null
                        && !ticket.getCustomerPhone().trim().isEmpty())
                                ? ticket.getCustomerPhone()
                                : "";
                boolean isCheckedIn = ticket.getCheckedInAt() != null || "CHECKED_IN".equals(ticket.getStatus());
                boolean canCheckIn = "PAID".equals(ticket.getPaymentStatus()) && !isCheckedIn
                        && !"CANCELLED".equals(ticket.getStatus());

                passengerInfo.put("ticketId",
                        ticket.getTicketId() != null ? ticket.getTicketId().toString() : null);
                passengerInfo.put("fullName", displayName);
                passengerInfo.put("phone", displayPhone);
                passengerInfo.put("username", ticket.getUsername());
                passengerInfo.put("seatNumber", ticket.getSeatNumber());
                passengerInfo.put("ticketNumber", ticket.getTicketNumber());
                passengerInfo.put("boardingStation", ticket.getBoardingStationName());
                passengerInfo.put("boardingCity", ticket.getBoardingCity());
                passengerInfo.put("alightingStation", ticket.getAlightingStationName());
                passengerInfo.put("alightingCity", ticket.getAlightingCity());
                passengerInfo.put("status", ticket.getStatus());
                passengerInfo.put("paymentStatus", ticket.getPaymentStatus());
                passengerInfo.put("checkedIn", isCheckedIn);
                passengerInfo.put("canCheckIn", canCheckIn);
                passengerInfo.put("checkedInAt",
                        ticket.getCheckedInAt() != null ? ticket.getCheckedInAt().toString()
                                : null);
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

    private Driver resolveOrCreateDriverProfile(HttpServletRequest request,
            HttpServletResponse response, UUID userId)
            throws ServletException, IOException {
        Driver driver = null;
        try {
            driver = driverDAO.getDriverByUserId(userId);
            if (driver == null) {
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
                    return null;
                }

                driver = driverDAO.getDriverByUserId(userId);
            }
        } catch (SQLException ex) {
            request.setAttribute("error",
                    "Database error while creating driver profile: " + ex.getMessage());
            request.getRequestDispatcher("/views/errors/403.jsp").forward(request, response);
            return null;
        }
        return driver;
    }

    /**
     * Perform check-in for a passenger via AJAX (driver modal)
     */
    private void performCheckInAjax(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        Map<String, Object> payload = new HashMap<>();
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            payload.put("success", false);
            payload.put("message", "Session expired. Please sign in again.");
            writeJson(response, HttpServletResponse.SC_UNAUTHORIZED, payload);
            return;
        }

        UUID userId = (UUID) session.getAttribute("userId");
        String ticketIdStr = request.getParameter("ticketId");
        String scheduleIdStr = request.getParameter("scheduleId");

        if (ticketIdStr == null || ticketIdStr.trim().isEmpty()) {
            payload.put("success", false);
            payload.put("message", "Ticket ID is required");
            writeJson(response, HttpServletResponse.SC_BAD_REQUEST, payload);
            return;
        }

        try {
            Driver driver = driverDAO.getDriverByUserId(userId);
            if (driver == null) {
                payload.put("success", false);
                payload.put("message", "Driver profile not found");
                writeJson(response, HttpServletResponse.SC_FORBIDDEN, payload);
                return;
            }

            UUID ticketId = UUID.fromString(ticketIdStr);
            Tickets ticket = ticketDAO.getTicketById(ticketId);
            if (ticket == null) {
                payload.put("success", false);
                payload.put("message", "Ticket not found");
                writeJson(response, HttpServletResponse.SC_NOT_FOUND, payload);
                return;
            }

            UUID scheduleId = null;
            if (scheduleIdStr != null && !scheduleIdStr.trim().isEmpty()) {
                scheduleId = UUID.fromString(scheduleIdStr);
            } else if (ticket.getScheduleId() != null) {
                scheduleId = ticket.getScheduleId();
            }

            if (scheduleId != null && !scheduleDAO.isDriverAssignedToSchedule(scheduleId,
                    driver.getDriverId())) {
                payload.put("success", false);
                payload.put("message", "Access denied for this schedule");
                writeJson(response, HttpServletResponse.SC_FORBIDDEN, payload);
                return;
            }

            if (!"PAID".equals(ticket.getPaymentStatus())) {
                payload.put("success", false);
                payload.put("message", "Ticket is not paid. Please collect payment first.");
                writeJson(response, HttpServletResponse.SC_BAD_REQUEST, payload);
                return;
            }

            if ("CANCELLED".equals(ticket.getStatus())) {
                payload.put("success", false);
                payload.put("message", "Cannot check in a cancelled ticket");
                writeJson(response, HttpServletResponse.SC_BAD_REQUEST, payload);
                return;
            }

            if (ticket.getCheckedInAt() != null || "CHECKED_IN".equals(ticket.getStatus())) {
                payload.put("success", true);
                payload.put("message", "Passenger already checked in");
                payload.put("status", ticket.getStatus());
                payload.put("checkedInAt",
                        ticket.getCheckedInAt() != null ? ticket.getCheckedInAt().toString()
                                : null);
                writeJson(response, HttpServletResponse.SC_OK, payload);
                return;
            }

            ticket.setStatus("CHECKED_IN");
            ticket.setCheckedInAt(LocalDateTime.now());
            ticket.setCheckedInByStaffId(userId); // Using driver's user ID for audit

            boolean success = ticketDAO.updateTicket(ticket);
            if (success) {
                payload.put("success", true);
                payload.put("message", "Passenger checked in successfully");
                payload.put("status", ticket.getStatus());
                payload.put("checkedInAt",
                        ticket.getCheckedInAt() != null ? ticket.getCheckedInAt().toString()
                                : null);
                writeJson(response, HttpServletResponse.SC_OK, payload);
            } else {
                payload.put("success", false);
                payload.put("message", "Failed to check in passenger");
                writeJson(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, payload);
            }
        } catch (IllegalArgumentException e) {
            payload.put("success", false);
            payload.put("message", "Invalid identifier format");
            writeJson(response, HttpServletResponse.SC_BAD_REQUEST, payload);
        } catch (SQLException e) {
            payload.put("success", false);
            payload.put("message", "Database error: " + e.getMessage());
            writeJson(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, payload);
        }
    }

    /**
     * Show check-in page for driver to check-in passengers
     */
    private void showCheckInPassengers(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        HttpSession session = request.getSession(false);
        UUID userId = (UUID) session.getAttribute("userId");

        Driver driver = driverDAO.getDriverByUserId(userId);
        if (driver == null) {
            response.sendRedirect(
                    request.getContextPath() + "/driver/trips?error=Driver profile not found");
            return;
        }

        String scheduleIdStr = request.getParameter("scheduleId");
        if (scheduleIdStr == null || scheduleIdStr.trim().isEmpty()) {
            response.sendRedirect(
                    request.getContextPath() + "/driver/trips?error=Schedule ID is required");
            return;
        }

        try {
            UUID scheduleId = UUID.fromString(scheduleIdStr);

            // Verify driver is assigned to this schedule
            boolean isAssigned = scheduleDAO.isDriverAssignedToSchedule(scheduleId, driver.getDriverId());
            if (!isAssigned) {
                response.sendRedirect(request.getContextPath()
                        + "/driver/trips?error=Access denied for this schedule");
                return;
            }

            Schedule schedule = scheduleDAO.getScheduleById(scheduleId);
            if (schedule == null) {
                response.sendRedirect(
                        request.getContextPath() + "/driver/trips?error=Schedule not found");
                return;
            }

            // Get unchecked-in tickets (paid tickets that haven't been checked in)
            List<Tickets> uncheckedInTickets = ticketDAO.getUncheckedInTicketsByScheduleId(scheduleId);
            List<Tickets> checkedInTickets = ticketDAO.getCheckedInTicketsByScheduleId(scheduleId);

            request.setAttribute("schedule", schedule);
            request.setAttribute("uncheckedInTickets", uncheckedInTickets);
            request.setAttribute("checkedInTickets", checkedInTickets);
            request.getRequestDispatcher("/views/driver/check-in.jsp").forward(request, response);

        } catch (IllegalArgumentException e) {
            response.sendRedirect(
                    request.getContextPath() + "/driver/trips?error=Invalid schedule ID format");
        }
    }

    /**
     * Perform check-in for a passenger (driver action)
     */
    private void performCheckIn(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        HttpSession session = request.getSession(false);
        UUID userId = (UUID) session.getAttribute("userId");

        Driver driver = driverDAO.getDriverByUserId(userId);
        if (driver == null) {
            response.sendRedirect(
                    request.getContextPath() + "/driver/trips?error=Driver profile not found");
            return;
        }

        String ticketIdStr = request.getParameter("ticketId");
        String scheduleIdStr = request.getParameter("scheduleId");

        if (ticketIdStr == null || ticketIdStr.trim().isEmpty()) {
            String redirectUrl = request.getContextPath() + "/driver/check-in?scheduleId=" + scheduleIdStr;
            response.sendRedirect(redirectUrl + "&error=Ticket ID is required");
            return;
        }

        try {
            UUID ticketId = UUID.fromString(ticketIdStr);
            Tickets ticket = ticketDAO.getTicketById(ticketId);

            if (ticket == null) {
                String redirectUrl = request.getContextPath() + "/driver/check-in?scheduleId=" + scheduleIdStr;
                response.sendRedirect(redirectUrl + "&error=Ticket not found");
                return;
            }

            // Verify driver is assigned to this schedule
            if (scheduleIdStr != null && !scheduleIdStr.trim().isEmpty()) {
                UUID scheduleId = UUID.fromString(scheduleIdStr);
                boolean isAssigned = scheduleDAO.isDriverAssignedToSchedule(scheduleId, driver.getDriverId());
                if (!isAssigned) {
                    response.sendRedirect(request.getContextPath()
                            + "/driver/trips?error=Access denied for this schedule");
                    return;
                }
            }

            if (ticket.getCheckedInAt() != null) {
                String redirectUrl = request.getContextPath() + "/driver/check-in?scheduleId=" + scheduleIdStr;
                response.sendRedirect(redirectUrl + "&message=Passenger already checked in");
                return;
            }

            // Check payment status
            if (!"PAID".equals(ticket.getPaymentStatus())) {
                String redirectUrl = request.getContextPath() + "/driver/check-in?scheduleId=" + scheduleIdStr;
                response.sendRedirect(
                        redirectUrl + "&error=Ticket is not paid. Please collect payment first.");
                return;
            }

            if ("CANCELLED".equals(ticket.getStatus())) {
                String redirectUrl = request.getContextPath() + "/driver/check-in?scheduleId=" + scheduleIdStr;
                response.sendRedirect(redirectUrl + "&error=Cannot check in a cancelled ticket");
                return;
            }

            // Perform check-in
            ticket.setStatus("CHECKED_IN");
            ticket.setCheckedInAt(java.time.LocalDateTime.now());
            ticket.setCheckedInByStaffId(userId); // Using driver's user ID

            boolean success = ticketDAO.updateTicket(ticket);

            if (success) {
                String redirectUrl = request.getContextPath() + "/driver/check-in?scheduleId=" + scheduleIdStr;
                response.sendRedirect(redirectUrl + "&message=Passenger checked in successfully");
            } else {
                String redirectUrl = request.getContextPath() + "/driver/check-in?scheduleId=" + scheduleIdStr;
                response.sendRedirect(redirectUrl + "&error=Failed to check in passenger");
            }
        } catch (IllegalArgumentException e) {
            String redirectUrl = request.getContextPath() + "/driver/check-in?scheduleId=" + scheduleIdStr;
            response.sendRedirect(redirectUrl + "&error=Invalid ticket ID format");
        } catch (Exception e) {
            String redirectUrl = request.getContextPath() + "/driver/check-in?scheduleId=" + scheduleIdStr;
            response.sendRedirect(redirectUrl + "&error=Error: " + e.getMessage());
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

            request.setAttribute("schedule", schedule);
            request.setAttribute("stations", stationDAO.getAllStations());
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
                    + "/driver/update-status?scheduleId=" + scheduleIdStr
                    + "&error=Missing information: Please select a status");
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
                                + "/driver/trips?message=Trip status updated successfully! The trip status has been changed to "
                                + newStatus);
            } else {
                response.sendRedirect(request.getContextPath()
                        + "/driver/update-status?scheduleId=" + scheduleIdStr
                        + "&error=Error: Failed to update trip status. Please try again or contact administrator");
            }

        } catch (IllegalArgumentException e) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/driver/trips?error=Error: Invalid schedule ID format. Please check again");
        } catch (Exception e) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/driver/trips?error=Error: An unexpected error occurred while updating trip status. "
                            + e.getMessage());
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
        String statusFilter = resolveStatusFilter(request.getParameter("status"));
        List<Driver> drivers = driverDAO.getAllDriversForAdmin(statusFilter);
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
        request.setAttribute("selectedStatus", statusFilter);
        request.setAttribute("searchTerm", null);
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
                    request.getContextPath()
                            + "/admin/drivers?error="
                            + URLEncoder.encode("Missing information: Driver ID is required",
                                    StandardCharsets.UTF_8));
            return;
        }
        try {
            UUID driverId = UUID.fromString(driverIdStr);
            Driver driver = driverDAO.getDriverByIdForAdmin(driverId);
            if (driver != null) {
                request.setAttribute("driver", driver);
                request.getRequestDispatcher("/views/admin/driver-form.jsp").forward(request,
                        response);
            } else {
                response.sendRedirect(
                        request.getContextPath()
                                + "/admin/drivers?error="
                                + URLEncoder.encode("Error: Driver not found with the given ID",
                                        StandardCharsets.UTF_8));
            }
        } catch (IllegalArgumentException e) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/admin/drivers?error="
                            + URLEncoder.encode(
                                    "Error: Invalid driver ID format. Please check again",
                                    StandardCharsets.UTF_8));
        }
    }

    private void adminDeleteDriver(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String driverIdStr = request.getParameter("id");
        if (driverIdStr == null || driverIdStr.trim().isEmpty()) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/admin/drivers?error="
                            + URLEncoder.encode("Missing information: Driver ID is required",
                                    StandardCharsets.UTF_8));
            return;
        }
        try {
            UUID driverId = UUID.fromString(driverIdStr);
            Driver driver = driverDAO.getDriverById(driverId);
            if (driver == null) {
                response.sendRedirect(
                        request.getContextPath()
                                + "/admin/drivers?error="
                                + URLEncoder.encode("Error: Driver not found with the given ID",
                                        StandardCharsets.UTF_8));
                return;
            }
            boolean hasActiveSchedules = scheduleDAO.hasDriverActiveSchedules(driverId);
            if (hasActiveSchedules) {
                response.sendRedirect(request.getContextPath()
                        + "/admin/drivers?error="
                        + URLEncoder.encode(
                                "Error: Cannot delete driver. Driver is currently assigned to active schedules. Please reassign or cancel the schedules first.",
                                StandardCharsets.UTF_8));
                return;
            }
            boolean hasPendingTickets = ticketDAO.hasDriverPendingTickets(driverId);
            if (hasPendingTickets) {
                response.sendRedirect(request.getContextPath()
                        + "/admin/drivers?error="
                        + URLEncoder.encode(
                                "Error: Cannot delete driver. Driver has pending tickets. Please resolve all pending tickets first.",
                                StandardCharsets.UTF_8));
                return;
            }
            boolean driverDeleted = driverDAO.deleteDriver(driverId);
            if (driverDeleted) {
                boolean userDeactivated = userDAO.deactivateUser(driver.getUserId());
                if (userDeactivated) {
                    response.sendRedirect(request.getContextPath()
                            + "/admin/drivers?message="
                            + URLEncoder.encode(
                                    "Driver and account deactivated successfully! Driver has been removed from the system",
                                    StandardCharsets.UTF_8));
                } else {
                    response.sendRedirect(request.getContextPath()
                            + "/admin/drivers?warning="
                            + URLEncoder.encode(
                                    "Driver deactivated successfully, but user account may still be active. Please check the user account status.",
                                    StandardCharsets.UTF_8));
                }
            } else {
                response.sendRedirect(
                        request.getContextPath()
                                + "/admin/drivers?error="
                                + URLEncoder.encode(
                                        "Error: Failed to delete driver. Please try again or contact administrator",
                                        StandardCharsets.UTF_8));
            }
        } catch (IllegalArgumentException e) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/admin/drivers?error="
                            + URLEncoder.encode(
                                    "Error: Invalid driver ID format. Please check again",
                                    StandardCharsets.UTF_8));
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath()
                    + "/admin/drivers?error="
                    + URLEncoder.encode(
                            "Error: An unexpected error occurred while deleting the driver. "
                                    + e.getMessage(),
                            StandardCharsets.UTF_8));
        }
    }

    private void adminSearchDrivers(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        String searchTerm = request.getParameter("search");
        String statusFilter = resolveStatusFilter(request.getParameter("status"));
        List<Driver> drivers = (searchTerm != null && !searchTerm.trim().isEmpty())
                ? driverDAO.searchDriversForAdmin(searchTerm, statusFilter)
                : driverDAO.getAllDriversForAdmin(statusFilter);
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
        request.setAttribute("selectedStatus", statusFilter);
        request.setAttribute("driverAvgMap", driverAvgMap);
        request.setAttribute("driverTotalMap", driverTotalMap);
        request.setAttribute("searchTerm", searchTerm);
        request.getRequestDispatcher("/views/admin/drivers.jsp").forward(request, response);
    }

    private void adminShowAssignDriverForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        String scheduleIdStr = request.getParameter("scheduleId");
        if (scheduleIdStr == null || scheduleIdStr.trim().isEmpty()) {
            String errorMsg = URLEncoder.encode(
                    "Missing information: Please select a schedule from the schedules list to assign a driver",
                    StandardCharsets.UTF_8);
            response.sendRedirect(
                    request.getContextPath() + "/admin/schedules?error=" + errorMsg);
            return;
        }
        try {
            UUID scheduleId = UUID.fromString(scheduleIdStr);
            Schedule schedule = scheduleDAO.getScheduleById(scheduleId);
            if (schedule == null) {
                response.sendRedirect(
                        request.getContextPath()
                                + "/admin/schedules?error=Error: Schedule not found with the given ID");
                return;
            }
            List<Driver> drivers = driverDAO.getAllDrivers();
            double requiredGapHours = calculateRequiredGapHours(schedule);
            double scheduleDurationHours = Math.max(0, requiredGapHours - 8.0);

            // Check minimum gap between each driver's last schedule end and this schedule
            // start
            Map<UUID, Double> driverMinGap = new HashMap<>();
            for (Driver driver : drivers) {
                double minGap = scheduleDAO.calculateMinGapBeforeNewSchedule(
                        driver.getDriverId(),
                        schedule.getDepartureDate(),
                        schedule.getDepartureTime(),
                        scheduleId);
                driverMinGap.put(driver.getDriverId(), minGap);
            }

            request.setAttribute("schedule", schedule);
            request.setAttribute("drivers", drivers);
            request.setAttribute("driverMinGap", driverMinGap);
            request.setAttribute("requiredGapHours", requiredGapHours);
            request.setAttribute("scheduleDurationHours", scheduleDurationHours);
            request.getRequestDispatcher("/views/admin/assign-driver.jsp").forward(request,
                    response);
        } catch (IllegalArgumentException e) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/admin/schedules?error=Error: Invalid schedule ID format. Please check again");
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
                            + "/admin/drivers/add?error="
                            + URLEncoder.encode("Missing information: Username is required",
                                    StandardCharsets.UTF_8));
            return;
        }
        if (password == null || password.trim().isEmpty()) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/admin/drivers/add?error="
                            + URLEncoder.encode("Missing information: Password is required",
                                    StandardCharsets.UTF_8));
            return;
        }
        if (password.length() < 8) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/admin/drivers/add?error="
                            + URLEncoder.encode("Error: Password must be at least 8 characters",
                                    StandardCharsets.UTF_8));
            return;
        }
        if (fullName == null || fullName.trim().isEmpty()) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/admin/drivers/add?error="
                            + URLEncoder.encode("Missing information: Full name is required",
                                    StandardCharsets.UTF_8));
            return;
        }
        if (licenseNumber == null || licenseNumber.trim().isEmpty()) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/admin/drivers/add?error="
                            + URLEncoder.encode("Missing information: License number is required",
                                    StandardCharsets.UTF_8));
            return;
        }
        if (experienceYearsStr == null || experienceYearsStr.trim().isEmpty()) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/admin/drivers/add?error="
                            + URLEncoder.encode("Missing information: Experience years is required",
                                    StandardCharsets.UTF_8));
            return;
        }

        // Trim all input fields
        username = username.trim();
        password = password.trim();
        fullName = fullName.trim();
        licenseNumber = licenseNumber.trim();

        // Validate license number format: 12 digits only
        if (!licenseNumber.matches("^[0-9]{12}$")) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/admin/drivers/add?error="
                            + URLEncoder.encode(
                                    "Error: Invalid license number format. License number must be exactly 12 digits",
                                    StandardCharsets.UTF_8));
            return;
        }

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
                    + "/admin/drivers/add?error="
                    + URLEncoder.encode(
                            "Error: Invalid email format. Please enter a valid email address",
                            StandardCharsets.UTF_8));
            return;
        }

        // Validate phone number format only if provided
        if (phoneNumber != null && !phoneNumber.isEmpty()
                && !phoneNumber.matches("^(0[3|5|7|8|9])[0-9]{8}$")) {
            response.sendRedirect(request.getContextPath()
                    + "/admin/drivers/add?error="
                    + URLEncoder.encode(
                            "Error: Invalid phone number format. Please use Vietnamese format (e.g., 0907450814)",
                            StandardCharsets.UTF_8));
            return;
        }

        try {
            int experienceYears = Integer.parseInt(experienceYearsStr);

            if (experienceYears < 0) {
                response.sendRedirect(request.getContextPath()
                        + "/admin/drivers/add?error="
                        + URLEncoder.encode(
                                "Error: Experience years must be a positive number (0 or greater)",
                                StandardCharsets.UTF_8));
                return;
            }

            // Check username uniqueness
            model.User existingUser = userDAO.getUserByUsername(username);
            if (existingUser != null) {
                response.sendRedirect(request.getContextPath()
                        + "/admin/drivers/add?error="
                        + URLEncoder.encode(
                                "Error: Username already exists. Please choose a different username",
                                StandardCharsets.UTF_8));
                return;
            }

            // Check email uniqueness only if email is provided
            if (email != null && !email.isEmpty()) {
                existingUser = userDAO.getUserByEmail(email);
                if (existingUser != null) {
                    response.sendRedirect(
                            request.getContextPath()
                                    + "/admin/drivers/add?error="
                                    + URLEncoder.encode(
                                            "Error: Email is already in use. Please use a different email",
                                            StandardCharsets.UTF_8));
                    return;
                }
            }

            // Check phone uniqueness only if phone is provided
            if (phoneNumber != null && !phoneNumber.isEmpty()) {
                existingUser = userDAO.getUserByPhone(phoneNumber);
                if (existingUser != null) {
                    response.sendRedirect(request.getContextPath()
                            + "/admin/drivers/add?error="
                            + URLEncoder.encode(
                                    "Error: Phone number is already in use. Please use a different phone number",
                                    StandardCharsets.UTF_8));
                    return;
                }
            }

            // Check license number uniqueness
            if (driverDAO.isLicenseNumberExists(licenseNumber, null)) {
                response.sendRedirect(request.getContextPath()
                        + "/admin/drivers/add?error="
                        + URLEncoder.encode(
                                "Error: License number is already in use. Please use a different license number",
                                StandardCharsets.UTF_8));
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
            String autoIdCard = "AUTO-" + user.getUserId().toString().replace("-", "").substring(0, 12);
            user.setIdCard(autoIdCard);
            user.setAddress(null);
            user.setGender(null);
            user.setDateOfBirth(null);

            try {
                boolean userSuccess = userDAO.addUser(user);
                if (!userSuccess) {
                    response.sendRedirect(request.getContextPath()
                            + "/admin/drivers/add?error="
                            + URLEncoder.encode(
                                    "Error: Failed to create user account. Please try again or contact administrator",
                                    StandardCharsets.UTF_8));
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
                        errorMsg = "Error: Phone number already exists. Please use a different phone number.";
                    } else {
                        errorMsg = "Error: A unique constraint violation occurred. Please check username, email, phone number, or ID card.";
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
                String message = "Driver created successfully! Driver " + fullName
                        + " has been added to the system";
                response.sendRedirect(request.getContextPath()
                        + "/admin/drivers?message="
                        + URLEncoder.encode(message, StandardCharsets.UTF_8));
            } else {
                userDAO.deleteUser(user.getUserId());
                response.sendRedirect(request.getContextPath()
                        + "/admin/drivers/add?error="
                        + URLEncoder.encode(
                                "Error: Failed to create driver profile. Please try again or contact administrator",
                                StandardCharsets.UTF_8));
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/admin/drivers/add?error="
                            + URLEncoder.encode(
                                    "Error: Invalid experience years format. Please enter a valid number",
                                    StandardCharsets.UTF_8));
        } catch (Exception e) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/admin/drivers/add?error="
                            + URLEncoder.encode(
                                    "Error: An unexpected error occurred. " + e.getMessage(),
                                    StandardCharsets.UTF_8));
        }
    }

    private void adminUpdateDriver(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String driverIdStr = request.getParameter("driverId");
        String username = request.getParameter("username");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phoneNumber = request.getParameter("phoneNumber");
        String licenseNumber = request.getParameter("licenseNumber");
        String experienceYearsStr = request.getParameter("experienceYears");
        String status = request.getParameter("status");
        // Validate input with specific error messages
        if (driverIdStr == null || driverIdStr.trim().isEmpty()) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/admin/drivers?error="
                            + URLEncoder.encode("Missing information: Driver ID is required",
                                    StandardCharsets.UTF_8));
            return;
        }
        if (username == null || username.trim().isEmpty()) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/drivers/edit?id=" + driverIdStr
                            + "&error="
                            + URLEncoder.encode("Missing information: Username is required",
                                    StandardCharsets.UTF_8));
            return;
        }
        if (fullName == null || fullName.trim().isEmpty()) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/drivers/edit?id=" + driverIdStr
                            + "&error="
                            + URLEncoder.encode("Missing information: Full name is required",
                                    StandardCharsets.UTF_8));
            return;
        }
        if (email == null || email.trim().isEmpty()) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/drivers/edit?id=" + driverIdStr
                            + "&error="
                            + URLEncoder.encode("Missing information: Email is required",
                                    StandardCharsets.UTF_8));
            return;
        }
        if (phoneNumber == null || phoneNumber.trim().isEmpty()) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/drivers/edit?id=" + driverIdStr
                            + "&error="
                            + URLEncoder.encode("Missing information: Phone number is required",
                                    StandardCharsets.UTF_8));
            return;
        }
        if (licenseNumber == null || licenseNumber.trim().isEmpty()) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/drivers/edit?id=" + driverIdStr
                            + "&error="
                            + URLEncoder.encode("Missing information: License number is required",
                                    StandardCharsets.UTF_8));
            return;
        }
        if (experienceYearsStr == null || experienceYearsStr.trim().isEmpty()) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/drivers/edit?id=" + driverIdStr
                            + "&error="
                            + URLEncoder.encode("Missing information: Experience years is required",
                                    StandardCharsets.UTF_8));
            return;
        }
        if (status == null || status.trim().isEmpty()) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/drivers/edit?id=" + driverIdStr
                            + "&error="
                            + URLEncoder.encode("Missing information: Status is required",
                                    StandardCharsets.UTF_8));
            return;
        }
        if (!status.equals("ACTIVE") && !status.equals("INACTIVE")) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/drivers/edit?id=" + driverIdStr
                            + "&error="
                            + URLEncoder.encode(
                                    "Error: Invalid status. Status must be ACTIVE or INACTIVE",
                                    StandardCharsets.UTF_8));
            return;
        }
        if (!phoneNumber.matches("^(0[3|5|7|8|9])[0-9]{8}$")) {
            response.sendRedirect(request.getContextPath()
                    + "/admin/drivers/edit?id=" + driverIdStr
                    + "&error="
                    + URLEncoder.encode(
                            "Error: Invalid phone number format. Please use Vietnamese format (e.g., 0907450814)",
                            StandardCharsets.UTF_8));
            return;
        }

        // Validate email format
        if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            response.sendRedirect(request.getContextPath()
                    + "/admin/drivers/edit?id=" + driverIdStr
                    + "&error="
                    + URLEncoder.encode(
                            "Error: Invalid email format. Please enter a valid email address",
                            StandardCharsets.UTF_8));
            return;
        }

        // Validate license number format: 12 digits only
        licenseNumber = licenseNumber.trim();
        if (!licenseNumber.matches("^[0-9]{12}$")) {
            response.sendRedirect(request.getContextPath()
                    + "/admin/drivers/edit?id=" + driverIdStr
                    + "&error="
                    + URLEncoder.encode(
                            "Error: Invalid license number format. License number must be exactly 12 digits",
                            StandardCharsets.UTF_8));
            return;
        }

        try {
            UUID driverId = UUID.fromString(driverIdStr);
            int experienceYears = Integer.parseInt(experienceYearsStr);

            Driver existingDriver = driverDAO.getDriverByIdForAdmin(driverId);
            if (existingDriver == null) {
                response.sendRedirect(
                        request.getContextPath()
                                + "/admin/drivers?error="
                                + URLEncoder.encode("Error: Driver not found with the given ID",
                                        StandardCharsets.UTF_8));
                return;
            }

            // Get the current user to check for username uniqueness
            model.User currentUser = userDAO.getUserById(existingDriver.getUserId());
            if (currentUser == null) {
                response.sendRedirect(
                        request.getContextPath()
                                + "/admin/drivers?error="
                                + URLEncoder.encode("Error: User account not found for this driver",
                                        StandardCharsets.UTF_8));
                return;
            }

            // Trim username
            username = username.trim();

            // Check username uniqueness (exclude current user)
            model.User existingUserByUsername = userDAO.getUserByUsername(username);
            if (existingUserByUsername != null
                    && !existingUserByUsername.getUserId().equals(currentUser.getUserId())) {
                response.sendRedirect(request.getContextPath()
                        + "/admin/drivers/edit?id=" + driverIdStr
                        + "&error="
                        + URLEncoder.encode(
                                "Error: Username already exists. Please choose a different username",
                                StandardCharsets.UTF_8));
                return;
            }

            // Check email uniqueness (exclude current user)
            model.User existingUserByEmail = userDAO.getUserByEmail(email);
            if (existingUserByEmail != null
                    && !existingUserByEmail.getUserId().equals(currentUser.getUserId())) {
                response.sendRedirect(
                        request.getContextPath() + "/admin/drivers/edit?id=" + driverIdStr
                                + "&error="
                                + URLEncoder.encode(
                                        "Error: Email is already in use. Please use a different email",
                                        StandardCharsets.UTF_8));
                return;
            }

            // Check phone uniqueness (exclude current user)
            model.User existingUserByPhone = userDAO.getUserByPhone(phoneNumber);
            if (existingUserByPhone != null
                    && !existingUserByPhone.getUserId().equals(currentUser.getUserId())) {
                response.sendRedirect(request.getContextPath()
                        + "/admin/drivers/edit?id=" + driverIdStr
                        + "&error="
                        + URLEncoder.encode(
                                "Error: Phone number is already in use. Please use a different phone number",
                                StandardCharsets.UTF_8));
                return;
            }

            // Check license number uniqueness
            if (driverDAO.isLicenseNumberExists(licenseNumber, driverId)) {
                response.sendRedirect(
                        request.getContextPath() + "/admin/drivers/edit?id=" + driverIdStr
                                + "&error="
                                + URLEncoder.encode(
                                        "Error: License number is already in use. Please use a different license number",
                                        StandardCharsets.UTF_8));
                return;
            }
            existingDriver.setLicenseNumber(licenseNumber);
            existingDriver.setExperienceYears(experienceYears);
            existingDriver.setStatus(status);
            boolean driverSuccess = driverDAO.updateDriver(existingDriver);
            if (driverSuccess) {
                model.User user = userDAO.getUserById(existingDriver.getUserId());
                if (user != null) {
                    user.setUsername(username);
                    user.setFullName(fullName);
                    user.setEmail(email);
                    user.setPhoneNumber(phoneNumber);
                    userDAO.updateUser(user);
                }
                String message = "Driver updated successfully! Driver " + fullName
                        + " information has been saved";
                response.sendRedirect(request.getContextPath()
                        + "/admin/drivers?message="
                        + URLEncoder.encode(message, StandardCharsets.UTF_8));
            } else {
                response.sendRedirect(
                        request.getContextPath() + "/admin/drivers/edit?id=" + driverIdStr
                                + "&error="
                                + URLEncoder.encode(
                                        "Error: Failed to update driver. Please try again or contact administrator",
                                        StandardCharsets.UTF_8));
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/drivers/edit?id=" + driverIdStr
                            + "&error="
                            + URLEncoder.encode(
                                    "Error: Invalid experience years format. Please enter a valid number",
                                    StandardCharsets.UTF_8));
        } catch (IllegalArgumentException e) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/admin/drivers?error=" + URLEncoder.encode(
                                    "Error: Invalid driver ID format", StandardCharsets.UTF_8));
        } catch (Exception e) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/drivers/edit?id=" + driverIdStr
                            + "&error="
                            + URLEncoder.encode(
                                    "Error: An unexpected error occurred. " + e.getMessage(),
                                    StandardCharsets.UTF_8));
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
                    + "/admin/drivers/assign?scheduleId=" + scheduleIdStr
                    + "&error=Missing information: Please select a driver");
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

            // Check if driver can be assigned (8-hour rule: gap between schedule end and
            // new
            // schedule start)
            double requiredGapHours = calculateRequiredGapHours(schedule);
            Schedule violatingSchedule = scheduleDAO.checkDriverScheduleTimeGapWithArrival(
                    driverId, schedule.getDepartureDate(), schedule.getDepartureTime(),
                    schedule.getEstimatedArrivalTime(), scheduleId,
                    requiredGapHours);
            if (violatingSchedule != null) {
                Driver driver = driverDAO.getDriverById(driverId);
                String driverName = driver != null && driver.getFullName() != null
                        ? driver.getFullName()
                        : "this driver";

                // Calculate the gap to show in error message
                java.time.LocalDateTime violatingScheduleEnd = java.time.LocalDateTime.of(
                        violatingSchedule.getDepartureDate(),
                        violatingSchedule.getEstimatedArrivalTime());
                // Handle case where arrival time might be next day
                if (violatingSchedule.getEstimatedArrivalTime()
                        .isBefore(violatingSchedule.getDepartureTime()) ||
                        violatingSchedule.getEstimatedArrivalTime()
                                .equals(violatingSchedule.getDepartureTime())) {
                    violatingScheduleEnd = violatingScheduleEnd.plusDays(1);
                }

                java.time.LocalDateTime newScheduleStart = java.time.LocalDateTime.of(
                        schedule.getDepartureDate(), schedule.getDepartureTime());
                java.time.LocalDateTime newScheduleEnd = java.time.LocalDateTime.of(
                        schedule.getDepartureDate(), schedule.getEstimatedArrivalTime());
                // Handle case where new schedule arrival time might be next day
                if (schedule.getEstimatedArrivalTime().isBefore(schedule.getDepartureTime()) ||
                        schedule.getEstimatedArrivalTime().equals(schedule.getDepartureTime())) {
                    newScheduleEnd = newScheduleEnd.plusDays(1);
                }

                // Determine which gap is the issue (before or after)
                java.time.LocalDateTime violatingScheduleStart = java.time.LocalDateTime.of(
                        violatingSchedule.getDepartureDate(), violatingSchedule.getDepartureTime());

                double gapHours;
                String gapDirection;
                if (violatingScheduleEnd.isBefore(newScheduleStart) || violatingScheduleEnd.equals(newScheduleStart)) {
                    // Existing schedule ends before new schedule starts
                    java.time.Duration gap = java.time.Duration.between(violatingScheduleEnd, newScheduleStart);
                    gapHours = gap.toMinutes() / 60.0;
                    gapDirection = "before";
                } else {
                    // New schedule ends before existing schedule starts
                    java.time.Duration gap = java.time.Duration.between(newScheduleEnd, violatingScheduleStart);
                    gapHours = gap.toMinutes() / 60.0;
                    gapDirection = "after";
                }
                double newTripDurationHours = Math.max(0, requiredGapHours - 8.0);

                String violatingScheduleDescription = String.format("%s (%s %s - %s)",
                        violatingSchedule.getRouteName() != null
                                ? violatingSchedule.getRouteName()
                                : "another schedule",
                        violatingSchedule.getDepartureDate(),
                        violatingSchedule.getDepartureTime(),
                        violatingSchedule.getEstimatedArrivalTime());

                String errorMessage;
                if ("before".equals(gapDirection)) {
                    errorMessage = String.format(
                            "Cannot assign driver %s to this schedule. There must be at least %.1f hours (trip duration %.1f h + 8 h rest) between schedules. "
                                    + "The driver's previous schedule %s ends at %s, and this schedule starts at %s "
                                    + "(gap: %.1f hours).",
                            driverName, requiredGapHours, newTripDurationHours,
                            violatingScheduleDescription,
                            violatingScheduleEnd.toString().replace("T", " "),
                            newScheduleStart.toString().replace("T", " "),
                            gapHours);
                } else {
                    errorMessage = String.format(
                            "Cannot assign driver %s to this schedule. There must be at least %.1f hours (trip duration %.1f h + 8 h rest) between schedules. "
                                    + "This schedule ends at %s, and the driver's next schedule %s starts at %s "
                                    + "(gap: %.1f hours).",
                            driverName, requiredGapHours, newTripDurationHours,
                            newScheduleEnd.toString().replace("T", " "),
                            violatingScheduleDescription,
                            violatingScheduleStart.toString().replace("T", " "),
                            gapHours);
                }

                response.sendRedirect(
                        request.getContextPath() + "/admin/drivers/assign?scheduleId=" + scheduleId
                                + "&error="
                                + URLEncoder.encode(errorMessage, StandardCharsets.UTF_8));
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
                String driverName = driver != null && driver.getFullName() != null ? driver.getFullName()
                        : "Driver";
                String message = "Driver assigned successfully! " + driverName
                        + " has been assigned to this schedule";
                response.sendRedirect(request.getContextPath()
                        + "/admin/schedules?message="
                        + URLEncoder.encode(message, StandardCharsets.UTF_8));
            } else {
                response.sendRedirect(request.getContextPath()
                        + "/admin/drivers/assign?scheduleId=" + scheduleIdStr
                        + "&error=Error: Failed to assign driver. Please try again or contact administrator");
            }
        } catch (IllegalArgumentException e) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/admin/schedules?error=Error: Invalid ID format. Please check schedule ID and driver ID");
        } catch (Exception e) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/admin/schedules?error=Error: An unexpected error occurred while assigning driver. "
                            + e.getMessage());
        }
    }

    private String resolveStatusFilter(String rawStatus) {
        if (rawStatus == null || rawStatus.trim().isEmpty()) {
            return "ACTIVE";
        }
        String normalized = rawStatus.trim().toUpperCase();
        if ("ACTIVE".equals(normalized) || "INACTIVE".equals(normalized)
                || "ALL".equals(normalized)) {
            return normalized;
        }
        return "ACTIVE";
    }

    private double calculateRequiredGapHours(Schedule schedule) {
        return calculateScheduleDurationHours(schedule) + 8.0;
    }

    private double calculateScheduleDurationHours(Schedule schedule) {
        if (schedule == null || schedule.getDepartureDate() == null
                || schedule.getDepartureTime() == null
                || schedule.getEstimatedArrivalTime() == null) {
            return 0.0;
        }
        LocalDateTime departure = LocalDateTime.of(
                schedule.getDepartureDate(), schedule.getDepartureTime());
        LocalDateTime arrival = LocalDateTime.of(
                schedule.getDepartureDate(), schedule.getEstimatedArrivalTime());
        if (!schedule.getEstimatedArrivalTime().isAfter(schedule.getDepartureTime())) {
            arrival = arrival.plusDays(1);
        }
        Duration duration = Duration.between(departure, arrival);
        if (duration.isNegative()) {
            return 0.0;
        }
        return duration.toMinutes() / 60.0;
    }
}
