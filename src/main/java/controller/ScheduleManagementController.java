package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.sql.SQLException;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;
import java.util.UUID;

import dao.BusDAO;
import dao.RouteDAO;
import dao.ScheduleDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Bus;
import model.Routes;
import model.Schedule;

@WebServlet(urlPatterns = {"/schedules/*", "/admin/schedules/*"})
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
        if (pathInfo == null)
            pathInfo = "/";

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
        if (pathInfo == null)
            pathInfo = "/";

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
        List<Schedule> schedules = scheduleDAO.getAllSchedulesAnyStatus();

        request.setAttribute("schedules", schedules);
        request.getRequestDispatcher("/views/admin/schedules.jsp").forward(request, response);
    }

    private void showAddScheduleForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        RouteDAO routeDAO = baseController.routeDAO;
        BusDAO busDAO = baseController.busDAO;
        // Get all routes and buses for the form
        List<Routes> routes = routeDAO.getAllRoutes();
        List<Bus> buses = busDAO.getAllBuses();

        request.setAttribute("routes", routes);
        request.setAttribute("buses", buses);
        request.getRequestDispatcher("/views/admin/schedule-form.jsp").forward(request, response);
    }

    private void showEditScheduleForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        ScheduleDAO scheduleDAO = baseController.scheduleDAO;
        RouteDAO routeDAO = baseController.routeDAO;
        BusDAO busDAO = baseController.busDAO;

        String scheduleIdStr = request.getParameter("id");
        if (scheduleIdStr == null || scheduleIdStr.trim().isEmpty()) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/admin/schedules?error=Missing information: Schedule ID is required");
            return;
        }

        try {
            UUID scheduleId = UUID.fromString(scheduleIdStr);
            Schedule schedule = scheduleDAO.getScheduleById(scheduleId);

            if (schedule != null) {
                // Get all routes, buses, and stations for the form
                List<Routes> routes = routeDAO.getAllRoutes();
                List<Bus> buses = busDAO.getAllBuses();
                request.setAttribute("schedule", schedule);
                request.setAttribute("routes", routes);
                request.setAttribute("buses", buses);
                request.getRequestDispatcher("/views/admin/schedule-form.jsp").forward(request,
                        response);
            } else {
                response.sendRedirect(
                        request.getContextPath()
                                + "/admin/schedules?error=Error: Schedule not found with the given ID");
            }
        } catch (IllegalArgumentException e) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/admin/schedules?error=Error: Invalid schedule ID format. Please check again");
        }
    }

    private void addSchedule(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        ScheduleDAO scheduleDAO = baseController.scheduleDAO;

        String routeIdStr = request.getParameter("routeId");
        String busIdStr = request.getParameter("busId");
        String departureTimeStr = request.getParameter("departureTime");
        String availableSeatsStr = request.getParameter("availableSeats");

        // Check if bulk mode
        String bulkMode = request.getParameter("bulkMode");
        boolean isBulkMode = "on".equals(bulkMode) || "true".equals(bulkMode);

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
        if (departureTimeStr == null || departureTimeStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath()
                    + "/admin/schedules/add?error=Missing information: Please select departure time");
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
            LocalTime departureTime = LocalTime.parse(departureTimeStr);
            int availableSeats = Integer.parseInt(availableSeatsStr);

            // Ensure route exists to derive duration
            Routes selectedRoute = baseController.routeDAO.getRouteById(routeId);
            if (selectedRoute == null) {
                response.sendRedirect(request.getContextPath()
                        + "/admin/schedules/add?error=Error: Route not found with the given ID");
                return;
            }
            LocalTime arrivalTime = departureTime.plusHours(selectedRoute.getDurationHours());

            // Check if bus is under maintenance
            BusDAO busDAO = baseController.busDAO;
            Bus bus = busDAO.getBusByIdForAdmin(busId);
            if (bus == null) {
                response.sendRedirect(request.getContextPath()
                        + "/admin/schedules/add?error=Error: Bus not found with the given ID");
                return;
            }
            if ("MAINTENANCE".equals(bus.getStatus())) {
                response.sendRedirect(request.getContextPath()
                        + "/admin/schedules/add?error=Error: Cannot assign bus that is under maintenance. Please select a different bus.");
                return;
            }

            // Determine dates to create schedules for
            List<LocalDate> datesToSchedule = new ArrayList<>();

            if (isBulkMode) {
                // Bulk mode: get date range and selected days of week
                String dateFromStr = request.getParameter("dateFrom");
                String dateToStr = request.getParameter("dateTo");
                String[] selectedDays = request.getParameterValues("daysOfWeek");

                if (dateFromStr == null || dateFromStr.trim().isEmpty() ||
                        dateToStr == null || dateToStr.trim().isEmpty()) {
                    response.sendRedirect(request.getContextPath()
                            + "/admin/schedules/add?error=Missing information: Please select date range for bulk creation");
                    return;
                }

                if (selectedDays == null || selectedDays.length == 0) {
                    response.sendRedirect(request.getContextPath()
                            + "/admin/schedules/add?error=Missing information: Please select at least one day of week");
                    return;
                }

                LocalDate dateFrom = LocalDate.parse(dateFromStr);
                LocalDate dateTo = LocalDate.parse(dateToStr);

                if (dateFrom.isAfter(dateTo)) {
                    response.sendRedirect(request.getContextPath()
                            + "/admin/schedules/add?error=Error: Start date must be before or equal to end date");
                    return;
                }

                // Convert selected days to DayOfWeek enum values
                List<DayOfWeek> selectedDaysOfWeek = new ArrayList<>();
                for (String day : selectedDays) {
                    selectedDaysOfWeek.add(DayOfWeek.of(Integer.parseInt(day)));
                }

                // Generate all dates in range that match selected days of week
                LocalDate currentDate = dateFrom;
                while (!currentDate.isAfter(dateTo)) {
                    if (selectedDaysOfWeek.contains(currentDate.getDayOfWeek())) {
                        datesToSchedule.add(currentDate);
                    }
                    currentDate = currentDate.plusDays(1);
                }

                if (datesToSchedule.isEmpty()) {
                    response.sendRedirect(request.getContextPath()
                            + "/admin/schedules/add?error=No matching dates found for the selected days of week in the given range");
                    return;
                }
            } else {
                // Single date mode
                String departureDateStr = request.getParameter("departureDate");
                if (departureDateStr == null || departureDateStr.trim().isEmpty()) {
                    response.sendRedirect(request.getContextPath()
                            + "/admin/schedules/add?error=Missing information: Please select departure date");
                    return;
                }
                datesToSchedule.add(LocalDate.parse(departureDateStr));
            }

            // Create schedules for all dates
            int successCount = 0;
            int skipCount = 0;
            List<String> errors = new ArrayList<>();

            for (LocalDate departureDate : datesToSchedule) {
                // Check if bus can be assigned (3-hour rule)
                Schedule violatingSchedule = scheduleDAO.checkBusScheduleTimeGap(
                        busId, departureDate, departureTime, null);
                if (violatingSchedule != null) {
                    skipCount++;
                    errors.add(departureDate + ": Bus conflict with existing schedule");
                    continue;
                }

                // Check for bus time conflicts on the same route
                if (scheduleDAO.hasBusScheduleConflict(routeId, busId, departureDate, departureTime,
                        arrivalTime, null)) {
                    skipCount++;
                    errors.add(departureDate + ": Bus already has schedule for this route");
                    continue;
                }

                // Check for bus time conflicts across all routes
                if (scheduleDAO.hasBusTimeConflict(busId, departureDate, departureTime, arrivalTime,
                        null)) {
                    skipCount++;
                    errors.add(departureDate + ": Bus has conflicting schedule");
                    continue;
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

                if (scheduleDAO.addSchedule(schedule)) {
                    successCount++;
                } else {
                    skipCount++;
                    errors.add(departureDate + ": Failed to add schedule");
                }
            }

            // Build result message
            StringBuilder message = new StringBuilder();
            if (successCount > 0) {
                if (isBulkMode) {
                    message.append("Successfully created ").append(successCount)
                            .append(" schedule(s)!");
                } else {
                    message.append(
                            "Schedule added successfully! The schedule has been created and is ready for use");
                }
            }
            if (skipCount > 0) {
                if (successCount > 0) {
                    message.append(" Skipped ").append(skipCount)
                            .append(" date(s) due to conflicts.");
                } else {
                    response.sendRedirect(request.getContextPath()
                            + "/admin/schedules/add?error=Failed to create any schedules. " +
                            (errors.isEmpty() ? "" : errors.get(0)));
                    return;
                }
            }

            if (successCount > 0) {
                response.sendRedirect(request.getContextPath()
                        + "/admin/schedules?message="
                        + java.net.URLEncoder.encode(message.toString(),
                                java.nio.charset.StandardCharsets.UTF_8));
            } else {
                response.sendRedirect(request.getContextPath()
                        + "/admin/schedules/add?error=Error: Failed to add schedule. Please try again or contact administrator");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/admin/schedules/add?error=Error: Invalid number format. Please check available seats and other numeric fields");
        } catch (java.time.format.DateTimeParseException e) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/admin/schedules/add?error=Error: Invalid date or time format. Please check departure date, departure time, and arrival time");
        } catch (IllegalArgumentException e) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/admin/schedules/add?error=Error: Invalid ID format. Please check route ID and bus ID");
        } catch (Exception e) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/admin/schedules/add?error=Error: An unexpected error occurred. "
                            + e.getMessage());
        }
    }

    private void updateSchedule(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        ScheduleDAO scheduleDAO = baseController.scheduleDAO;

        String scheduleIdStr = request.getParameter("scheduleId");
        String routeIdStr = request.getParameter("routeId");
        String busIdStr = request.getParameter("busId");
        String departureDateStr = request.getParameter("departureDate");
        String departureTimeStr = request.getParameter("departureTime");
        String availableSeatsStr = request.getParameter("availableSeats");

        // Validate input with specific error messages
        if (scheduleIdStr == null || scheduleIdStr.trim().isEmpty()) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/admin/schedules?error=Missing information: Schedule ID is required");
            return;
        }
        if (routeIdStr == null || routeIdStr.trim().isEmpty()) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/schedules/edit?id=" + scheduleIdStr
                            + "&error=Missing information: Please select a route");
            return;
        }
        if (busIdStr == null || busIdStr.trim().isEmpty()) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/schedules/edit?id=" + scheduleIdStr
                            + "&error=Missing information: Please select a bus");
            return;
        }
        if (departureDateStr == null || departureDateStr.trim().isEmpty()) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/schedules/edit?id=" + scheduleIdStr
                            + "&error=Missing information: Please select departure date");
            return;
        }
        if (departureTimeStr == null || departureTimeStr.trim().isEmpty()) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/schedules/edit?id=" + scheduleIdStr
                            + "&error=Missing information: Please select departure time");
            return;
        }
        if (availableSeatsStr == null || availableSeatsStr.trim().isEmpty()) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/schedules/edit?id=" + scheduleIdStr
                            + "&error=Missing information: Please enter available seats");
            return;
        }

        try {
            UUID scheduleId = UUID.fromString(scheduleIdStr);
            UUID routeId = UUID.fromString(routeIdStr);
            UUID busId = UUID.fromString(busIdStr);
            LocalDate departureDate = LocalDate.parse(departureDateStr);
            LocalTime departureTime = LocalTime.parse(departureTimeStr);
            int availableSeats = Integer.parseInt(availableSeatsStr);

            // Ensure route exists to derive duration
            Routes selectedRoute = baseController.routeDAO.getRouteById(routeId);
            if (selectedRoute == null) {
                response.sendRedirect(
                        request.getContextPath() + "/admin/schedules/edit?id=" + scheduleIdStr
                                + "&error=Error: Route not found with the given ID");
                return;
            }
            LocalTime arrivalTime = departureTime.plusHours(selectedRoute.getDurationHours());

            // Check if bus is under maintenance
            BusDAO busDAO = baseController.busDAO;
            Bus bus = busDAO.getBusByIdForAdmin(busId);
            if (bus == null) {
                response.sendRedirect(request.getContextPath()
                        + "/admin/schedules/edit?id=" + scheduleId
                        + "&error=Error: Bus not found with the given ID");
                return;
            }
            if ("MAINTENANCE".equals(bus.getStatus())) {
                response.sendRedirect(request.getContextPath()
                        + "/admin/schedules/edit?id=" + scheduleId
                        + "&error=Error: Cannot assign bus that is under maintenance. Please select a different bus.");
                return;
            }

            // Check if bus can be assigned (3-hour rule: gap between schedule end and new schedule
            // start)
            Schedule violatingSchedule = scheduleDAO.checkBusScheduleTimeGap(
                    busId, departureDate, departureTime, scheduleId);
            if (violatingSchedule != null) {
                String busNumber = bus.getBusNumber() != null ? bus.getBusNumber() : "this bus";

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
                        departureDate, departureTime);
                java.time.Duration gap =
                        java.time.Duration.between(violatingScheduleEnd, newScheduleStart);
                double gapHours = gap.toHours() + (gap.toMinutes() % 60) / 60.0;

                String violatingScheduleDescription = String.format("%s (%s %s - %s)",
                        violatingSchedule.getRouteName() != null
                                ? violatingSchedule.getRouteName()
                                : "another schedule",
                        violatingSchedule.getDepartureDate(),
                        violatingSchedule.getDepartureTime(),
                        violatingSchedule.getEstimatedArrivalTime());

                String errorMessage = String.format(
                        "Cannot assign bus %s to this schedule. There must be at least 3 hours gap between schedules. "
                                + "The bus's previous schedule %s ends at %s, and this schedule starts at %s "
                                + "(gap: %.1f hours). Rule: 3 hours minimum gap between schedule completion and next schedule start.",
                        busNumber, violatingScheduleDescription,
                        violatingScheduleEnd.toString().replace("T", " "),
                        newScheduleStart.toString().replace("T", " "),
                        gapHours);

                response.sendRedirect(request.getContextPath()
                        + "/admin/schedules/edit?id=" + scheduleId
                        + "&error="
                        + java.net.URLEncoder.encode(errorMessage,
                                java.nio.charset.StandardCharsets.UTF_8));
                return;
            }

            // Check for bus time conflicts on the same route
            if (scheduleDAO.hasBusScheduleConflict(routeId, busId, departureDate, departureTime,
                    arrivalTime, scheduleId)) {
                response.sendRedirect(request.getContextPath()
                        + "/admin/schedules/edit?id=" + scheduleId
                        + "&error=Error: Selected bus already has a schedule for this route during the chosen time. Please select a different bus or time.");
                return;
            }

            // Check for bus time conflicts across all routes (overlapping times)
            if (scheduleDAO.hasBusTimeConflict(busId, departureDate, departureTime, arrivalTime,
                    scheduleId)) {
                response.sendRedirect(request.getContextPath()
                        + "/admin/schedules/edit?id=" + scheduleId
                        + "&error=Error: Selected bus already has a conflicting schedule during the chosen time. Please select a different bus or time.");
                return;
            }

            // Get existing schedule
            Schedule existingSchedule = scheduleDAO.getScheduleById(scheduleId);
            if (existingSchedule == null) {
                response.sendRedirect(
                        request.getContextPath()
                                + "/admin/schedules?error=Error: Schedule not found with the given ID");
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
                response.sendRedirect(
                        request.getContextPath()
                                + "/admin/schedules?message=Schedule updated successfully! The schedule information has been saved");
            } else {
                response.sendRedirect(request.getContextPath()
                        + "/admin/schedules/edit?id=" + scheduleIdStr
                        + "&error=Error: Failed to update schedule. Please try again or contact administrator");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/schedules/edit?id=" + scheduleIdStr
                            + "&error=Error: Invalid number format. Please check available seats and other numeric fields");
        } catch (java.time.format.DateTimeParseException e) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/schedules/edit?id=" + scheduleIdStr
                            + "&error=Error: Invalid date or time format. Please check departure date, departure time, and arrival time");
        } catch (IllegalArgumentException e) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/admin/schedules?error=Error: Invalid ID format. Please check schedule ID, route ID, and bus ID");
        } catch (Exception e) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/schedules/edit?id=" + scheduleIdStr
                            + "&error=Error: An unexpected error occurred. " + e.getMessage());
        }
    }

    private void deleteSchedule(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        ScheduleDAO scheduleDAO = baseController.scheduleDAO;
        String scheduleIdStr = request.getParameter("id");

        if (scheduleIdStr == null || scheduleIdStr.trim().isEmpty()) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/admin/schedules?error=Missing information: Schedule ID is required");
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
                    request.getContextPath()
                            + "/admin/schedules?error=Error: Invalid schedule ID format. Please check again");
        } catch (Exception e) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/admin/schedules?error=Error: An unexpected error occurred while deleting the schedule. "
                            + e.getMessage());
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
            request.getRequestDispatcher("/views/schedules/schedule-detail.jsp").forward(request,
                    response);
        } else {
            handleError(request, response, "Schedule not found");
        }
    }
}

