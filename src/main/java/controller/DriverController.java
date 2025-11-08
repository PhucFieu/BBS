package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.UUID;

import dao.DriverDAO;
import dao.ScheduleDAO;
import dao.TicketDAO;
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

@WebServlet("/driver/*")
public class DriverController extends HttpServlet {
    private DriverDAO driverDAO;
    private ScheduleDAO scheduleDAO;
    private TicketDAO ticketDAO;

    @Override
    public void init() throws ServletException {
        driverDAO = new DriverDAO();
        scheduleDAO = new ScheduleDAO();
        ticketDAO = new TicketDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if user is logged in and is a driver
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        // Check if user has driver role
        if (!AuthUtils.isDriver(session)) {
            request.setAttribute("error", "Access denied: DRIVER role required");
            request.getRequestDispatcher("/views/403.jsp").forward(request, response);
            return;
        }

        String pathInfo = request.getPathInfo();
        if (pathInfo == null) {
            pathInfo = "/";
        }

        try {
            if (pathInfo.equals("/") || pathInfo.equals("/dashboard") || pathInfo.equals("/trips")) {
                // Show assigned trips (dashboard)
                showAssignedTrips(request, response);
            } else if (pathInfo.equals("/passengers")) {
                // Show passengers for specific trip
                showTripPassengers(request, response);
            } else if (pathInfo.equals("/update-status")) {
                // Show update status form
                showUpdateStatusForm(request, response);
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

        // Check if user is logged in and is a driver
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        // Check if user has driver role
        if (!AuthUtils.isDriver(session)) {
            request.setAttribute("error", "Access denied: DRIVER role required");
            request.getRequestDispatcher("/views/403.jsp").forward(request, response);
            return;
        }

        String pathInfo = request.getPathInfo();
        if (pathInfo == null) {
            pathInfo = "/";
        }

        try {
            if (pathInfo.equals("/update-status")) {
                // Update trip status
                updateTripStatus(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            handleError(request, response, "Database error: " + e.getMessage());
        }
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
            request.setAttribute("error", "No driver profile associated with current user");
            request.getRequestDispatcher("/views/403.jsp").forward(request, response);
            return;
        }

        // Get assigned schedules for this driver
        List<Schedule> assignedTrips = scheduleDAO.getSchedulesByDriverId(driver.getDriverId());

        request.setAttribute("driver", driver);
        request.setAttribute("trips", assignedTrips);
        request.getRequestDispatcher("/views/driver/trips.jsp").forward(request, response);
    }

    /**
     * Show passengers for a specific trip
     */
    private void showTripPassengers(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        String scheduleIdStr = request.getParameter("scheduleId");
        if (scheduleIdStr == null || scheduleIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/driver/trips?error=Schedule ID is required");
            return;
        }

        try {
            UUID scheduleId = UUID.fromString(scheduleIdStr);

            // Get schedule details
            Schedule schedule = scheduleDAO.getScheduleById(scheduleId);
            if (schedule == null) {
                response.sendRedirect(request.getContextPath() + "/driver/trips?error=Schedule not found");
                return;
            }

            // Get passengers for this schedule
            List<Tickets> passengers = ticketDAO.getTicketsByScheduleId(scheduleId);

            request.setAttribute("schedule", schedule);
            request.setAttribute("passengers", passengers);
            request.getRequestDispatcher("/views/driver/passengers.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/driver/trips?error=Invalid schedule ID");
        }
    }

    /**
     * Show update status form
     */
    private void showUpdateStatusForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        String scheduleIdStr = request.getParameter("scheduleId");
        if (scheduleIdStr == null || scheduleIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/driver/trips?error=Schedule ID is required");
            return;
        }

        try {
            UUID scheduleId = UUID.fromString(scheduleIdStr);

            // Get schedule details
            Schedule schedule = scheduleDAO.getScheduleById(scheduleId);
            if (schedule == null) {
                response.sendRedirect(request.getContextPath() + "/driver/trips?error=Schedule not found");
                return;
            }

            // Load route stops for station selection when stopping
            dao.RouteStopDAO routeStopDAO = new dao.RouteStopDAO();
            java.util.List<model.RouteStop> routeStops = routeStopDAO.getRouteStopsByRoute(schedule.getRouteId());

            request.setAttribute("schedule", schedule);
            request.setAttribute("routeStops", routeStops);
            request.getRequestDispatcher("/views/driver/update-status.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/driver/trips?error=Invalid schedule ID");
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

        if (scheduleIdStr == null || scheduleIdStr.trim().isEmpty() ||
                newStatus == null || newStatus.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/driver/trips?error=All required fields must be filled");
            return;
        }

        try {
            UUID scheduleId = UUID.fromString(scheduleIdStr);

            // If stopping at station, ensure station chosen and append to notes for audit
            if ("STOP_AT_STATION".equals(newStatus)) {
                if (stopStationIdStr == null || stopStationIdStr.trim().isEmpty()) {
                    response.sendRedirect(request.getContextPath()
                            + "/driver/update-status?scheduleId=" + scheduleId
                            + "&error=Please choose station when selecting Stop at station");
                    return;
                }
                try {
                    java.util.UUID stationId = java.util.UUID.fromString(stopStationIdStr);
                    // Fetch station name for notes
                    dao.StationDAO stationDAO = new dao.StationDAO();
                    model.Station station = stationDAO.getStationById(stationId);
                    if (station != null) {
                        String suffix = " [Stop at: " + station.getStationName() + ", " + station.getCity() + "]";
                        notes = (notes == null || notes.isBlank()) ? suffix : (notes + suffix);
                    }
                } catch (IllegalArgumentException ex) {
                    response.sendRedirect(request.getContextPath()
                            + "/driver/update-status?scheduleId=" + scheduleId
                            + "&error=Invalid station selected");
                    return;
                }
            }

            // Update schedule status
            boolean success = scheduleDAO.updateScheduleStatus(scheduleId, newStatus, notes);

            if (success) {
                response.sendRedirect(
                        request.getContextPath() + "/driver/trips?message=Trip status updated successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/driver/trips?error=Failed to update trip status");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/driver/trips?error=Invalid schedule ID");
        }
    }

    /**
     * Handle errors
     */
    private void handleError(HttpServletRequest request, HttpServletResponse response, String message)
            throws ServletException, IOException {
        request.setAttribute("error", message);
        request.getRequestDispatcher("/views/error.jsp").forward(request, response);
    }
}