package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;
import java.util.UUID;

import dao.BusDAO;
import dao.RouteDAO;
import dao.ScheduleDAO;
import dao.ScheduleStopDAO;
import dao.StationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Bus;
import model.Routes;
import model.Schedule;
import model.ScheduleStop;
import model.Station;

@WebServlet(urlPatterns = { "/schedules/*", "/admin/schedules/*" })
public class ScheduleManagementController extends HttpServlet {
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
        if (pathInfo == null) pathInfo = "/";

        try {
            if (servletPath.startsWith("/admin")) {
                if (!baseController.isAdminAuthenticated(request)) {
                    response.sendRedirect(request.getContextPath() + "/auth/login");
                    return;
                }
                if ("/".equals(pathInfo)) {
                    showSchedules(request, response);
                } else if ("/add".equals(pathInfo)) {
                    showAddScheduleForm(request, response);
                } else if ("/edit".equals(pathInfo)) {
                    showEditScheduleForm(request, response);
                } else if ("/delete".equals(pathInfo)) {
                    deleteSchedule(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                }
            } else {
                // Public schedules (read-only) - list and details
                if ("/".equals(pathInfo)) {
                    showPublicSchedules(request, response);
                } else {
                    showPublicScheduleDetail(request, response);
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
        if (pathInfo == null) pathInfo = "/";

        try {
            if (servletPath.startsWith("/admin")) {
                if (!baseController.isAdminAuthenticated(request)) {
                    response.sendRedirect(request.getContextPath() + "/auth/login");
                    return;
                }
                if ("/add".equals(pathInfo)) {
                    addSchedule(request, response);
                } else if ("/edit".equals(pathInfo)) {
                    updateSchedule(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                }
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            logDatabaseError("GET " + servletPath + pathInfo, request, e);
            handleError(request, response, "Database error: " + e.getMessage(), e);
            logDatabaseError("POST " + servletPath + pathInfo, request, e);
            handleError(request, response, "Database error: " + e.getMessage(), e);
        }
    }

    private void showSchedules(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        ScheduleDAO scheduleDAO = baseController.scheduleDAO;
        ScheduleStopDAO scheduleStopDAO = baseController.scheduleStopDAO;
        // For admin view, show all schedules with their actual status
        List<Schedule> schedules = scheduleDAO.getAllSchedulesAnyStatus();

        // Load station information for each schedule
        for (Schedule schedule : schedules) {
            List<ScheduleStop> scheduleStops =
                    scheduleStopDAO.getScheduleStopsByScheduleId(schedule.getScheduleId());
            // Store station count in request for display
            request.setAttribute("stationCount_" + schedule.getScheduleId(), scheduleStops.size());
        }

        request.setAttribute("schedules", schedules);
        request.getRequestDispatcher("/views/admin/schedules.jsp").forward(request, response);
    }

    private void showAddScheduleForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        RouteDAO routeDAO = baseController.routeDAO;
        BusDAO busDAO = baseController.busDAO;
        StationDAO stationDAO = baseController.stationDAO;

        // Get all routes, buses, and stations for the form
        List<Routes> routes = routeDAO.getAllRoutes();
        List<Bus> buses = busDAO.getAllBuses();
        List<Station> stations = stationDAO.getAllStations();

        request.setAttribute("routes", routes);
        request.setAttribute("buses", buses);
        request.setAttribute("stations", stations);
        request.getRequestDispatcher("/views/admin/schedule-form.jsp").forward(request, response);
    }

    private void showEditScheduleForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        ScheduleDAO scheduleDAO = baseController.scheduleDAO;
        ScheduleStopDAO scheduleStopDAO = baseController.scheduleStopDAO;
        RouteDAO routeDAO = baseController.routeDAO;
        BusDAO busDAO = baseController.busDAO;
        StationDAO stationDAO = baseController.stationDAO;

        String scheduleIdStr = request.getParameter("id");
        if (scheduleIdStr == null || scheduleIdStr.trim().isEmpty()) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/schedules?error=Missing information: Schedule ID is required");
            return;
        }

        try {
            UUID scheduleId = UUID.fromString(scheduleIdStr);
            Schedule schedule = scheduleDAO.getScheduleById(scheduleId);

            if (schedule != null) {
                // Get all routes, buses, and stations for the form
                List<Routes> routes = routeDAO.getAllRoutes();
                List<Bus> buses = busDAO.getAllBuses();
                List<Station> stations = stationDAO.getAllStations();

                // Get existing schedule stops
                List<ScheduleStop> scheduleStops =
                        scheduleStopDAO.getScheduleStopsByScheduleId(scheduleId);

                request.setAttribute("schedule", schedule);
                request.setAttribute("routes", routes);
                request.setAttribute("buses", buses);
                request.setAttribute("stations", stations);
                request.setAttribute("scheduleStops", scheduleStops);
                request.getRequestDispatcher("/views/admin/schedule-form.jsp").forward(request,
                        response);
            } else {
                response.sendRedirect(
                        request.getContextPath() + "/admin/schedules?error=Error: Schedule not found with the given ID");
            }
        } catch (IllegalArgumentException e) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/schedules?error=Error: Invalid schedule ID format. Please check again");
        }
    }

    private void addSchedule(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        ScheduleDAO scheduleDAO = baseController.scheduleDAO;
        ScheduleStopDAO scheduleStopDAO = baseController.scheduleStopDAO;

        String routeIdStr = request.getParameter("routeId");
        String busIdStr = request.getParameter("busId");
        String departureDateStr = request.getParameter("departureDate");
        String departureTimeStr = request.getParameter("departureTime");
        String arrivalTimeStr = request.getParameter("arrivalTime");
        String availableSeatsStr = request.getParameter("availableSeats");

        // Validate input with specific error messages
        if (routeIdStr == null || routeIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath()
                    + "/admin/schedules/add?error=Missing information: Please select a route");
            return;
        }
        if (busIdStr == null || busIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath()
                    + "/admin/schedules/add?error=Missing information: Please select a bus");
            return;
        }
        if (departureDateStr == null || departureDateStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath()
                    + "/admin/schedules/add?error=Missing information: Please select departure date");
            return;
        }
        if (departureTimeStr == null || departureTimeStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath()
                    + "/admin/schedules/add?error=Missing information: Please select departure time");
            return;
        }
        if (arrivalTimeStr == null || arrivalTimeStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath()
                    + "/admin/schedules/add?error=Missing information: Please select arrival time");
            return;
        }
        if (availableSeatsStr == null || availableSeatsStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath()
                    + "/admin/schedules/add?error=Missing information: Please enter available seats");
            return;
        }

        try {
            UUID routeId = UUID.fromString(routeIdStr);
            UUID busId = UUID.fromString(busIdStr);
            LocalDate departureDate = LocalDate.parse(departureDateStr);
            LocalTime departureTime = LocalTime.parse(departureTimeStr);
            LocalTime arrivalTime = LocalTime.parse(arrivalTimeStr);
            int availableSeats = Integer.parseInt(availableSeatsStr);

            if (scheduleDAO.hasBusScheduleConflict(routeId, busId, departureDate, departureTime,
                    arrivalTime, null)) {
                response.sendRedirect(request.getContextPath()
                        + "/admin/schedules/add?error=Error: Selected bus already has a schedule for this route during the chosen time. Please select a different bus or time.");
                return;
            }

            // Create new schedule
            Schedule schedule = new Schedule();
            schedule.setScheduleId(UUID.randomUUID());
            schedule.setRouteId(routeId);
            schedule.setBusId(busId);
            schedule.setDepartureDate(departureDate);
            schedule.setDepartureTime(departureTime);
            schedule.setEstimatedArrivalTime(arrivalTime);
            schedule.setAvailableSeats(availableSeats);
            schedule.setStatus("SCHEDULED");

            boolean success = scheduleDAO.addSchedule(schedule);

            if (success) {
                // Handle station selections
                String[] selectedStations = request.getParameterValues("selectedStations");
                if (selectedStations != null && selectedStations.length > 0) {
                    List<ScheduleStop> scheduleStops = new ArrayList<>();
                    int stopOrder = 1;

                    for (String stationIdStr : selectedStations) {
                        try {
                            UUID stationId = UUID.fromString(stationIdStr);

                            // Get arrival time for this station
                            String arrivalTimeParam =
                                    request.getParameter("arrivalTime_" + stationIdStr);
                            LocalTime stationArrivalTime = arrivalTime;
                            if (arrivalTimeParam != null && !arrivalTimeParam.trim().isEmpty()) {
                                stationArrivalTime = LocalTime.parse(arrivalTimeParam);
                            }

                            // Get stop duration
                            String durationParam =
                                    request.getParameter("stopDuration_" + stationIdStr);
                            int stopDuration = 0;
                            if (durationParam != null && !durationParam.trim().isEmpty()) {
                                stopDuration = Integer.parseInt(durationParam);
                            }

                            ScheduleStop scheduleStop = new ScheduleStop();
                            scheduleStop.setScheduleId(schedule.getScheduleId());
                            scheduleStop.setStationId(stationId);
                            scheduleStop.setStopOrder(stopOrder++);
                            scheduleStop.setArrivalTime(stationArrivalTime);
                            scheduleStop.setStopDurationMinutes(stopDuration);

                            scheduleStops.add(scheduleStop);
                        } catch (Exception e) {
                            // Log error but continue with other stations
                            System.err.println("Error processing station: " + stationIdStr + " - "
                                    + e.getMessage());
                        }
                    }

                    // Add all schedule stops
                    if (!scheduleStops.isEmpty()) {
                        scheduleStopDAO.addScheduleStops(scheduleStops);
                    }
                }

                response.sendRedirect(
                        request.getContextPath()
                                + "/admin/schedules?message=Schedule added successfully! The schedule has been created and is ready for use");
            } else {
                response.sendRedirect(request.getContextPath()
                        + "/admin/schedules/add?error=Error: Failed to add schedule. Please try again or contact administrator");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/schedules/add?error=Error: Invalid number format. Please check available seats and other numeric fields");
        } catch (java.time.format.DateTimeParseException e) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/schedules/add?error=Error: Invalid date or time format. Please check departure date, departure time, and arrival time");
        } catch (IllegalArgumentException e) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/schedules/add?error=Error: Invalid ID format. Please check route ID and bus ID");
        } catch (Exception e) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/schedules/add?error=Error: An unexpected error occurred. " + e.getMessage());
        }
    }

    private void updateSchedule(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        ScheduleDAO scheduleDAO = baseController.scheduleDAO;
        ScheduleStopDAO scheduleStopDAO = baseController.scheduleStopDAO;

        String scheduleIdStr = request.getParameter("scheduleId");
        String routeIdStr = request.getParameter("routeId");
        String busIdStr = request.getParameter("busId");
        String departureDateStr = request.getParameter("departureDate");
        String departureTimeStr = request.getParameter("departureTime");
        String arrivalTimeStr = request.getParameter("arrivalTime");
        String availableSeatsStr = request.getParameter("availableSeats");

        // Validate input with specific error messages
        if (scheduleIdStr == null || scheduleIdStr.trim().isEmpty()) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/schedules?error=Missing information: Schedule ID is required");
            return;
        }
        if (routeIdStr == null || routeIdStr.trim().isEmpty()) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/schedules/edit?id=" + scheduleIdStr + "&error=Missing information: Please select a route");
            return;
        }
        if (busIdStr == null || busIdStr.trim().isEmpty()) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/schedules/edit?id=" + scheduleIdStr + "&error=Missing information: Please select a bus");
            return;
        }
        if (departureDateStr == null || departureDateStr.trim().isEmpty()) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/schedules/edit?id=" + scheduleIdStr + "&error=Missing information: Please select departure date");
            return;
        }
        if (departureTimeStr == null || departureTimeStr.trim().isEmpty()) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/schedules/edit?id=" + scheduleIdStr + "&error=Missing information: Please select departure time");
            return;
        }
        if (arrivalTimeStr == null || arrivalTimeStr.trim().isEmpty()) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/schedules/edit?id=" + scheduleIdStr + "&error=Missing information: Please select arrival time");
            return;
        }
        if (availableSeatsStr == null || availableSeatsStr.trim().isEmpty()) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/schedules/edit?id=" + scheduleIdStr + "&error=Missing information: Please enter available seats");
            return;
        }

        try {
            UUID scheduleId = UUID.fromString(scheduleIdStr);
            UUID routeId = UUID.fromString(routeIdStr);
            UUID busId = UUID.fromString(busIdStr);
            LocalDate departureDate = LocalDate.parse(departureDateStr);
            LocalTime departureTime = LocalTime.parse(departureTimeStr);
            LocalTime arrivalTime = LocalTime.parse(arrivalTimeStr);
            int availableSeats = Integer.parseInt(availableSeatsStr);

            if (scheduleDAO.hasBusScheduleConflict(routeId, busId, departureDate, departureTime,
                    arrivalTime, scheduleId)) {
                response.sendRedirect(request.getContextPath()
                        + "/admin/schedules/edit?id=" + scheduleId
                        + "&error=Error: Selected bus already has a schedule for this route during the chosen time. Please select a different bus or time.");
                return;
            }

            // Get existing schedule
            Schedule existingSchedule = scheduleDAO.getScheduleById(scheduleId);
            if (existingSchedule == null) {
                response.sendRedirect(
                        request.getContextPath() + "/admin/schedules?error=Error: Schedule not found with the given ID");
                return;
            }

            // Update schedule
            existingSchedule.setRouteId(routeId);
            existingSchedule.setBusId(busId);
            existingSchedule.setDepartureDate(departureDate);
            existingSchedule.setDepartureTime(departureTime);
            existingSchedule.setEstimatedArrivalTime(arrivalTime);
            existingSchedule.setAvailableSeats(availableSeats);

            boolean success = scheduleDAO.updateSchedule(existingSchedule);

            if (success) {
                // Handle station updates
                String[] selectedStations = request.getParameterValues("selectedStations");

                // Remove existing schedule stops
                scheduleStopDAO.deleteScheduleStopsByScheduleId(scheduleId);

                // Add new schedule stops if stations are selected
                if (selectedStations != null && selectedStations.length > 0) {
                    List<ScheduleStop> scheduleStops = new ArrayList<>();
                    int stopOrder = 1;

                    for (String stationIdStr : selectedStations) {
                        try {
                            UUID stationId = UUID.fromString(stationIdStr);

                            // Get arrival time for this station
                            String arrivalTimeParam =
                                    request.getParameter("arrivalTime_" + stationIdStr);
                            LocalTime stationArrivalTime = arrivalTime;
                            if (arrivalTimeParam != null && !arrivalTimeParam.trim().isEmpty()) {
                                stationArrivalTime = LocalTime.parse(arrivalTimeParam);
                            }

                            // Get stop duration
                            String durationParam =
                                    request.getParameter("stopDuration_" + stationIdStr);
                            int stopDuration = 0;
                            if (durationParam != null && !durationParam.trim().isEmpty()) {
                                stopDuration = Integer.parseInt(durationParam);
                            }

                            ScheduleStop scheduleStop = new ScheduleStop();
                            scheduleStop.setScheduleId(scheduleId);
                            scheduleStop.setStationId(stationId);
                            scheduleStop.setStopOrder(stopOrder++);
                            scheduleStop.setArrivalTime(stationArrivalTime);
                            scheduleStop.setStopDurationMinutes(stopDuration);

                            scheduleStops.add(scheduleStop);
                        } catch (Exception e) {
                            // Log error but continue with other stations
                            System.err.println("Error processing station: " + stationIdStr + " - "
                                    + e.getMessage());
                        }
                    }

                    // Add all schedule stops
                    if (!scheduleStops.isEmpty()) {
                        scheduleStopDAO.addScheduleStops(scheduleStops);
                    }
                }

                response.sendRedirect(
                        request.getContextPath()
                                + "/admin/schedules?message=Schedule updated successfully! The schedule information has been saved");
            } else {
                response.sendRedirect(request.getContextPath()
                        + "/admin/schedules/edit?id=" + scheduleIdStr + "&error=Error: Failed to update schedule. Please try again or contact administrator");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/schedules/edit?id=" + scheduleIdStr + "&error=Error: Invalid number format. Please check available seats and other numeric fields");
        } catch (java.time.format.DateTimeParseException e) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/schedules/edit?id=" + scheduleIdStr + "&error=Error: Invalid date or time format. Please check departure date, departure time, and arrival time");
        } catch (IllegalArgumentException e) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/schedules?error=Error: Invalid ID format. Please check schedule ID, route ID, and bus ID");
        } catch (Exception e) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/schedules/edit?id=" + scheduleIdStr + "&error=Error: An unexpected error occurred. " + e.getMessage());
        }
    }

    private void deleteSchedule(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        ScheduleDAO scheduleDAO = baseController.scheduleDAO;
        String scheduleIdStr = request.getParameter("id");

        if (scheduleIdStr == null || scheduleIdStr.trim().isEmpty()) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/schedules?error=Missing information: Schedule ID is required");
            return;
        }

        try {
            UUID scheduleId = UUID.fromString(scheduleIdStr);
            boolean success = scheduleDAO.deleteSchedule(scheduleId);

            if (success) {
                response.sendRedirect(
                        request.getContextPath()
                                + "/admin/schedules?message=Schedule deleted successfully! The schedule has been removed from the system");
            } else {
                response.sendRedirect(request.getContextPath()
                        + "/admin/schedules?error=Error: Failed to delete schedule. The schedule may be in use or does not exist");
            }
        } catch (IllegalArgumentException e) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/schedules?error=Error: Invalid schedule ID format. Please check again");
        } catch (Exception e) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/schedules?error=Error: An unexpected error occurred while deleting the schedule. " + e.getMessage());
        }
    }

    private void handleError(HttpServletRequest request, HttpServletResponse response,
            String message)
            throws ServletException, IOException {
        request.setAttribute("error", message);
        request.getRequestDispatcher("/views/errors/error.jsp").forward(request, response);
    }

    private void handleError(HttpServletRequest request, HttpServletResponse response,
            String message, Throwable throwable)
            throws ServletException, IOException {
        if (throwable != null) {
            request.setAttribute("errorDetails", getStackTrace(throwable));
        }
        handleError(request, response, message);
    }

    private void logDatabaseError(String context, HttpServletRequest request, SQLException e) {
        System.err.println("[ScheduleManagementController] Database error during " + context);
        System.err.println("Message: " + e.getMessage());
        System.err.println("SQLState: " + e.getSQLState());
        System.err.println("ErrorCode: " + e.getErrorCode());
        System.err.println("Request parameters: " + buildRequestParameterLog(request));
        e.printStackTrace();
    }

    private String buildRequestParameterLog(HttpServletRequest request) {
        StringBuilder sb = new StringBuilder("{");
        Enumeration<String> parameterNames = request.getParameterNames();
        boolean first = true;
        while (parameterNames.hasMoreElements()) {
            String name = parameterNames.nextElement();
            String[] values = request.getParameterValues(name);
            if (!first) {
                sb.append(", ");
            }
            sb.append(name).append("=");
            if (values == null) {
                sb.append("null");
            } else if (values.length == 1) {
                sb.append(values[0]);
            } else {
                sb.append("[");
                for (int i = 0; i < values.length; i++) {
                    sb.append(values[i]);
                    if (i < values.length - 1) {
                        sb.append(", ");
                    }
                }
                sb.append("]");
            }
            first = false;
        }
        sb.append("}");
        return sb.toString();
    }

    private String getStackTrace(Throwable throwable) {
        StringWriter sw = new StringWriter();
        PrintWriter pw = new PrintWriter(sw);
        throwable.printStackTrace(pw);
        return sw.toString();
    }

    // Public read-only views
    private void showPublicSchedules(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        ScheduleDAO scheduleDAO = baseController.scheduleDAO;
        List<Schedule> schedules = scheduleDAO.getAllSchedules();
        request.setAttribute("schedules", schedules);
        request.getRequestDispatcher("/views/schedules/schedules.jsp").forward(request, response);
    }

    private void showPublicScheduleDetail(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        String pathInfo = request.getPathInfo();
        UUID scheduleId = UUID.fromString(pathInfo.substring(1));
        ScheduleDAO scheduleDAO = baseController.scheduleDAO;
        Schedule schedule = scheduleDAO.getScheduleById(scheduleId);
        if (schedule != null) {
            request.setAttribute("schedule", schedule);
            request.getRequestDispatcher("/views/schedules/schedule-detail.jsp").forward(request, response);
        } else {
            handleError(request, response, "Schedule not found");
        }
    }
}

