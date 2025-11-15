package controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.sql.SQLException;
import java.sql.Time;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

import com.google.gson.Gson;

import dao.BusDAO;
import dao.RouteDAO;
import dao.RouteStopDAO;
import dao.ScheduleDAO;
import dao.ScheduleStopDAO;
import dao.TicketDAO;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Bus;
import model.Routes;
import model.Schedule;
import model.Tickets;
import model.User;
import util.URLUtils;

/**
 *
 * @author LamDNB-CE192005
 */

@WebServlet(urlPatterns = {"/tickets/*", "/admin/tickets/*"})
public class TicketController extends HttpServlet {

    private TicketDAO ticketDAO;
    private RouteDAO routeDAO;
    private RouteStopDAO routeStopDAO;
    private ScheduleDAO scheduleDAO;
    private BusDAO busDAO;
    private UserDAO userDAO;
    private ScheduleStopDAO scheduleStopDAO;

    @Override
    public void init() throws ServletException {
        ticketDAO = new TicketDAO();
        routeDAO = new RouteDAO();
        routeStopDAO = new RouteStopDAO();
        scheduleDAO = new ScheduleDAO();
        busDAO = new BusDAO();
        userDAO = new UserDAO();
        scheduleStopDAO = new ScheduleStopDAO();
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
                // Admin endpoints: require admin role
                HttpSession session = request.getSession(false);
                User sessionUser = (session != null) ? (User) session.getAttribute("user") : null;
                if (sessionUser == null) {
                    response.sendRedirect(request.getContextPath() + "/auth/login");
                    return;
                }
                if (!"ADMIN".equals(sessionUser.getRole())) {
                    request.setAttribute("error", "Access denied: ADMIN required");
                    request.getRequestDispatcher("/views/errors/403.jsp").forward(request,
                            response);
                    return;
                }

                if ("/".equals(pathInfo)) {
                    adminListTickets(request, response);
                } else if ("/add".equals(pathInfo)) {
                    response.sendRedirect(request.getContextPath() + "/tickets/add");
                } else if ("/edit".equals(pathInfo)) {
                    adminShowEditForm(request, response);
                } else if ("/delete".equals(pathInfo)) {
                    adminDeleteTicket(request, response);
                } else if ("/export".equals(pathInfo)) {
                    adminExportTickets(request, response);
                } else if ("/analytics".equals(pathInfo)) {
                    adminShowTicketAnalytics(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                }
            } else {
                if (pathInfo.equals("/") || pathInfo.isEmpty()) {
                    listTickets(request, response);
                } else if (pathInfo.equals("/add")) {
                    showAddForm(request, response);
                } else if (pathInfo.equals("/edit")) {
                    showEditForm(request, response);
                } else if (pathInfo.equals("/delete")) {
                    deleteTicket(request, response);
                } else if (pathInfo.equals("/search")) {
                    searchTickets(request, response);
                } else if (pathInfo.equals("/print")) {
                    printTicket(request, response);
                } else if (pathInfo.equals("/check-seat")) {
                    checkSeatAvailability(request, response);
                } else if (pathInfo.equals("/available-dates")) {
                    getAvailableDates(response);
                } else if (pathInfo.equals("/available-times")) {
                    getAvailableTimes(request, response);
                } else if (pathInfo.equals("/available-seats")) {
                    getAvailableSeats(request, response);
                } else if (pathInfo.equals("/schedule-seats")) {
                    getSeatsBySchedule(request, response);
                } else if (pathInfo.equals("/available-schedules")) {
                    getAvailableSchedules(request, response);
                } else if (pathInfo.equals("/search-passengers")) {
                    searchPassengers(request, response);
                } else if (pathInfo.equals("/route-stations")) {
                    getRouteStations(request, response);
                } else if (pathInfo.equals("/book")) {
                    showBookingForm(request, response);
                } else if (pathInfo.equals("/get-schedules-by-route")) {
                    getSchedulesByRoute(request, response);
                } else if (pathInfo.equals("/get-schedule-stations")) {
                    getScheduleStations(request, response);
                } else {
                    getTicketById(request, response);
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
                User sessionUser = (session != null) ? (User) session.getAttribute("user") : null;
                if (sessionUser == null) {
                    response.sendRedirect(request.getContextPath() + "/auth/login");
                    return;
                }
                if (!"ADMIN".equals(sessionUser.getRole())) {
                    request.setAttribute("error", "Access denied: ADMIN required");
                    request.getRequestDispatcher("/views/errors/403.jsp").forward(request,
                            response);
                    return;
                }

                if ("/add".equals(pathInfo)) {
                    response.sendRedirect(request.getContextPath() + "/tickets/add");
                } else if ("/edit".equals(pathInfo)) {
                    adminUpdateTicket(request, response);
                } else if ("/bulk-action".equals(pathInfo)) {
                    adminHandleBulkTicketAction(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                }
            } else {
                if (pathInfo.equals("/add")) {
                    addTicket(request, response);
                } else if (pathInfo.equals("/edit")) {
                    updateTicket(request, response);
                } else if (pathInfo.equals("/book")) {
                    HttpSession session = request.getSession(false);
                    if (session == null || session.getAttribute("user") == null) {
                        response.sendRedirect(request.getContextPath()
                                + "/auth/login?error=You need to login to book tickets");
                        return;
                    }
                    String action = request.getParameter("action");
                    if ("book".equals(action)) {
                        bookTicketBySchedule(request, response);
                        return;
                    }
                    bookTicket(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                }
            }
        } catch (SQLException e) {
            handleError(request, response, "Database error: " + e.getMessage());
        }
    }

    private void getAvailableDates(HttpServletResponse response) throws IOException {
        // Always allow today + next 6 days
        LocalDate today = LocalDate.now();
        List<String> dates = new java.util.ArrayList<>();
        for (int i = 0; i < 7; i++) {
            dates.add(today.plusDays(i).toString());
        }
        response.setContentType("application/json; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(new com.google.gson.Gson().toJson(dates));
    }

    private void getAvailableTimes(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String dateStr = request.getParameter("date");
        LocalDate date = LocalDate.parse(dateStr);
        LocalTime now = LocalTime.now();
        List<String> times = new java.util.ArrayList<>();
        int startHour = 0;
        if (date.equals(LocalDate.now())) {
            // Add 1 hours buffer
            startHour = now.plusHours(1).getHour();
            // If current time is 23:10, plus 2 hours = 1:10 next day, so startHour = 1, but
            // we want to skip today in that case
            if (startHour >= 24) {
                // No more trips today
                response.setContentType("application/json");
                response.getWriter().write("[]");
                return;
            }
        }
        for (int h = startHour; h < 24; h++) {
            times.add(String.format("%02d:00", h));
        }
        response.setContentType("application/json; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(new com.google.gson.Gson().toJson(times));
    }

    private void searchPassengers(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String keyword = request.getParameter("keyword");

        // If no keyword provided, return all passengers
        if (keyword == null || keyword.trim().isEmpty()) {
            keyword = "";
        }

        try {
            List<User> passengers = userDAO.searchUsers(keyword.trim(), "USER");

            // Convert to JSON format
            List<java.util.Map<String, Object>> passengerData = new ArrayList<>();
            for (User passenger : passengers) {
                java.util.Map<String, Object> passengerMap = new java.util.HashMap<>();
                passengerMap.put("userId", passenger.getUserId().toString());
                passengerMap.put("fullName", passenger.getFullName());
                passengerMap.put("phoneNumber", passenger.getPhoneNumber());
                passengerMap.put("email", passenger.getEmail());
                passengerData.add(passengerMap);
            }

            java.util.Map<String, Object> result = new java.util.HashMap<>();
            result.put("passengers", passengerData);

            response.setContentType("application/json; charset=UTF-8");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(new com.google.gson.Gson().toJson(result));

        } catch (Exception e) {
            response.setContentType("application/json; charset=UTF-8");
            response.setCharacterEncoding("UTF-8");
            response.getWriter()
                    .write("{\"error\":\"Error searching passengers: " + e.getMessage() + "\"}");
        }
    }

    private void getRouteStations(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String routeIdStr = request.getParameter("routeId");

        if (routeIdStr == null || routeIdStr.trim().isEmpty()) {
            response.setContentType("application/json; charset=UTF-8");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"error\":\"Route ID is required\"}");
            return;
        }

        try {
            UUID routeId = UUID.fromString(routeIdStr);
            List<model.RouteStop> routeStops = routeStopDAO.getRouteStopsByRoute(routeId);

            // Convert to JSON format
            List<java.util.Map<String, Object>> stationData = new ArrayList<>();
            for (model.RouteStop routeStop : routeStops) {
                java.util.Map<String, Object> stationMap = new java.util.HashMap<>();
                stationMap.put("stationId", routeStop.getStationId().toString());
                stationMap.put("stationName", routeStop.getStationName());
                stationMap.put("city", routeStop.getCity());
                stationMap.put("stopOrder", routeStop.getStopOrder());
                stationData.add(stationMap);
            }

            java.util.Map<String, Object> result = new java.util.HashMap<>();
            result.put("stations", stationData);

            response.setContentType("application/json; charset=UTF-8");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(new com.google.gson.Gson().toJson(result));

        } catch (Exception e) {
            response.setContentType("application/json; charset=UTF-8");
            response.setCharacterEncoding("UTF-8");
            response.getWriter()
                    .write("{\"error\":\"Error getting route stations: " + e.getMessage() + "\"}");
        }
    }

    private void getSchedulesByRoute(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String routeIdStr = request.getParameter("routeId");

        if (routeIdStr == null || routeIdStr.trim().isEmpty()) {
            response.setContentType("application/json; charset=UTF-8");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"error\":\"Route ID is required\"}");
            return;
        }

        try {
            UUID routeId = UUID.fromString(routeIdStr);
            List<Schedule> schedules = scheduleDAO.getSchedulesByRoute(routeId);

            // Convert to JSON format
            LocalDateTime now = LocalDateTime.now();
            List<java.util.Map<String, Object>> scheduleData = new ArrayList<>();
            for (Schedule schedule : schedules) {
                java.util.Map<String, Object> scheduleMap = new java.util.HashMap<>();
                scheduleMap.put("scheduleId", schedule.getScheduleId().toString());
                scheduleMap.put("departureDate", schedule.getDepartureDate().toString());
                scheduleMap.put("departureTime", schedule.getDepartureTime().toString());
                scheduleMap.put("estimatedArrivalTime",
                        schedule.getEstimatedArrivalTime().toString());
                scheduleMap.put("availableSeats", schedule.getAvailableSeats());
                scheduleMap.put("busNumber", schedule.getBusNumber());

                // Mark if schedule is expired
                if (schedule.getDepartureDate() != null && schedule.getDepartureTime() != null) {
                    LocalDateTime departureDateTime = LocalDateTime.of(
                            schedule.getDepartureDate(),
                            schedule.getDepartureTime());
                    scheduleMap.put("isExpired", departureDateTime.isBefore(now));
                } else {
                    scheduleMap.put("isExpired", true);
                }

                scheduleData.add(scheduleMap);
            }

            java.util.Map<String, Object> result = new java.util.HashMap<>();
            result.put("schedules", scheduleData);

            response.setContentType("application/json; charset=UTF-8");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(new com.google.gson.Gson().toJson(result));

        } catch (Exception e) {
            response.setContentType("application/json; charset=UTF-8");
            response.setCharacterEncoding("UTF-8");
            response.getWriter()
                    .write("{\"error\":\"Error retrieving schedules: " + e.getMessage() + "\"}");
        }
    }

    private void getScheduleStations(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String scheduleIdStr = request.getParameter("scheduleId");

        if (scheduleIdStr == null || scheduleIdStr.trim().isEmpty()) {
            response.setContentType("application/json; charset=UTF-8");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"error\":\"Schedule ID is required\"}");
            return;
        }

        try {
            UUID scheduleId = UUID.fromString(scheduleIdStr);
            List<model.ScheduleStop> scheduleStops =
                    scheduleStopDAO.getScheduleStopsByScheduleId(scheduleId);

            // Convert to JSON format
            List<java.util.Map<String, Object>> stationData = new ArrayList<>();
            for (model.ScheduleStop scheduleStop : scheduleStops) {
                java.util.Map<String, Object> stationMap = new java.util.HashMap<>();
                stationMap.put("stationId", scheduleStop.getStationId().toString());
                stationMap.put("stationName", scheduleStop.getStationName());
                stationMap.put("city", scheduleStop.getCity());
                stationMap.put("stopOrder", scheduleStop.getStopOrder());
                if (scheduleStop.getArrivalTime() != null) {
                    stationMap.put("arrivalTime", scheduleStop.getArrivalTime().toString());
                }
                stationData.add(stationMap);
            }

            java.util.Map<String, Object> result = new java.util.HashMap<>();
            result.put("stations", stationData);

            response.setContentType("application/json; charset=UTF-8");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(new com.google.gson.Gson().toJson(result));

        } catch (Exception e) {
            response.setContentType("application/json; charset=UTF-8");
            response.setCharacterEncoding("UTF-8");
            response.getWriter()
                    .write("{\"error\":\"Error getting schedule stations: " + e.getMessage()
                            + "\"}");
        }
    }

    private void getAvailableSchedules(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String routeIdStr = request.getParameter("routeId");
        String busIdStr = request.getParameter("busId");
        String dateStr = request.getParameter("date");

        if (routeIdStr == null || busIdStr == null) {
            response.setContentType("application/json; charset=UTF-8");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"error\":\"Route ID and Bus ID are required\"}");
            return;
        }

        try {
            UUID routeId = UUID.fromString(routeIdStr);
            UUID busId = UUID.fromString(busIdStr);

            // Get schedules from database
            List<Schedule> schedules = scheduleDAO.getSchedulesByRouteAndBus(routeId, busId);

            // Filter by date if provided
            if (dateStr != null && !dateStr.trim().isEmpty()) {
                LocalDate filterDate = LocalDate.parse(dateStr);
                schedules = schedules.stream()
                        .filter(schedule -> schedule.getDepartureDate().equals(filterDate))
                        .collect(Collectors.toList());
            }

            // Convert to JSON format
            List<java.util.Map<String, Object>> scheduleData = new ArrayList<>();
            for (Schedule schedule : schedules) {
                java.util.Map<String, Object> scheduleMap = new java.util.HashMap<>();
                scheduleMap.put("scheduleId", schedule.getScheduleId());
                scheduleMap.put("departureDate", schedule.getDepartureDate().toString());
                scheduleMap.put("departureTime", schedule.getDepartureTime().toString());
                scheduleMap.put("availableSeats", schedule.getAvailableSeats());
                scheduleData.add(scheduleMap);
            }

            java.util.Map<String, Object> result = new java.util.HashMap<>();
            result.put("schedules", scheduleData);

            response.setContentType("application/json; charset=UTF-8");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(new com.google.gson.Gson().toJson(result));

        } catch (Exception e) {
            response.setContentType("application/json; charset=UTF-8");
            response.setCharacterEncoding("UTF-8");
            response.getWriter()
                    .write("{\"error\":\"Error retrieving schedules: " + e.getMessage() + "\"}");
        }
    }

    private void getAvailableSeats(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        UUID routeId;
        UUID busIdForSchedule = null;
        LocalDate date;
        LocalTime time;
        try {
            String routeIdParam = request.getParameter("routeId");
            String dateStr = request.getParameter("date");
            String timeStr = request.getParameter("time");

            if (routeIdParam == null || dateStr == null || timeStr == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.setContentType("application/json; charset=UTF-8");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"error\":\"Missing routeId, date, or time\"}");
                return;
            }

            routeId = UUID.fromString(routeIdParam);
            date = LocalDate.parse(dateStr);
            time = LocalTime.parse(timeStr);
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.setContentType("application/json; charset=UTF-8");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"error\":\"Invalid routeId/date/time\"}");
            return;
        }

        // Find a bus for this route
        BusDAO busDAO = new BusDAO();
        List<Bus> buses;
        try {
            buses = busDAO.getAvailableBusesForRoute(routeId, date, time);
        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.setContentType("application/json; charset=UTF-8");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"error\":\"Error fetching buses: "
                    + e.getMessage().replace("\"", "'") + "\"}");
            return;
        }

        if (buses.isEmpty()) {
            // Fall back to any available bus; we'll create/ensure schedule below
            try {
                List<Bus> allBuses = busDAO.getAvailableBuses();
                if (!allBuses.isEmpty()) {
                    buses = java.util.List.of(allBuses.get(0));
                } else {
                    response.setStatus(HttpServletResponse.SC_OK);
                    response.setContentType("application/json; charset=UTF-8");
                    response.setCharacterEncoding("UTF-8");
                    response.getWriter()
                            .write("{\"error\":\"No available buses for this route\"}");
                    return;
                }
            } catch (SQLException e) {
                response.setStatus(HttpServletResponse.SC_OK);
                response.setContentType("application/json; charset=UTF-8");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"error\":\"Unable to create schedule for this trip: "
                        + e.getMessage().replace("\"", "'") + "\"}");
                return;
            }
        }

        // Use the first available bus
        Bus bus = buses.get(0);
        if (busIdForSchedule == null) {
            busIdForSchedule = bus.getBusId();
        }

        // Ensure a schedule exists and get its ID
        int durationHours = 1;
        try {
            model.Routes route = routeDAO.getRouteById(routeId);
            if (route != null && route.getDurationHours() > 0) {
                durationHours = route.getDurationHours();
            }
        } catch (SQLException e) {
            // keep default durationHours when route lookup fails

        }
        java.util.UUID scheduleId;
        try {
            scheduleId = scheduleDAO.findOrCreateSchedule(routeId, bus.getBusId(), date, time,
                    durationHours, bus.getTotalSeats());
        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.setContentType("application/json; charset=UTF-8");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"error\":\"Error ensuring schedule: "
                    + e.getMessage().replace("\"", "'") + "\"}");
            return;
        }

        // Get all seats for this bus
        int totalSeats = bus.getTotalSeats();

        // Get booked seats for this trip
        TicketDAO ticketDAO = new TicketDAO();
        List<Integer> bookedSeats;
        try {
            bookedSeats = ticketDAO.getBookedSeats(scheduleId);
        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.setContentType("application/json; charset=UTF-8");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"error\":\"Error fetching booked seats: "
                    + e.getMessage().replace("\"", "'") + "\"}");
            return;
        }

        // Build available seat list
        List<Integer> availableSeats = new ArrayList<>();
        for (int i = 1; i <= totalSeats; i++) {
            if (!bookedSeats.contains(i)) {
                availableSeats.add(i);
            }
        }

        // Return busId, availableSeats, bookedSeats, and totalSeats as valid JSON
        java.util.Map<String, Object> result = new java.util.HashMap<>();
        result.put("busId", bus.getBusId().toString());
        result.put("totalSeats", totalSeats);
        result.put("availableSeats", availableSeats);
        result.put("bookedSeats", bookedSeats);
        result.put("scheduleId", scheduleId.toString());

        response.setContentType("application/json; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(new Gson().toJson(result));
    }

    private void getSeatsBySchedule(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        String scheduleIdStr = request.getParameter("scheduleId");

        if (scheduleIdStr == null || scheduleIdStr.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.setContentType("application/json; charset=UTF-8");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"error\":\"Schedule ID is required\"}");
            return;
        }

        try {
            UUID scheduleId = UUID.fromString(scheduleIdStr);

            // Get schedule details
            Schedule schedule = scheduleDAO.getScheduleById(scheduleId);
            if (schedule == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.setContentType("application/json; charset=UTF-8");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"error\":\"Schedule not found\"}");
                return;
            }

            // Get bus details to know total seats
            Bus bus = busDAO.getBusById(schedule.getBusId());
            if (bus == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.setContentType("application/json; charset=UTF-8");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"error\":\"Bus not found\"}");
                return;
            }

            int totalSeats = bus.getTotalSeats();

            // Get booked seats for this schedule
            List<Integer> bookedSeats;
            try {
                bookedSeats = ticketDAO.getBookedSeats(scheduleId);
            } catch (SQLException e) {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.setContentType("application/json; charset=UTF-8");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"error\":\"Error fetching booked seats: "
                        + e.getMessage().replace("\"", "'") + "\"}");
                return;
            }

            // Build available seat list
            List<Integer> availableSeats = new ArrayList<>();
            for (int i = 1; i <= totalSeats; i++) {
                if (!bookedSeats.contains(i)) {
                    availableSeats.add(i);
                }
            }

            // Return result as JSON
            java.util.Map<String, Object> result = new java.util.HashMap<>();
            result.put("scheduleId", scheduleId.toString());
            result.put("totalSeats", totalSeats);
            result.put("availableSeats", availableSeats);
            result.put("bookedSeats", bookedSeats);

            response.setContentType("application/json; charset=UTF-8");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(new Gson().toJson(result));
        } catch (IllegalArgumentException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.setContentType("application/json; charset=UTF-8");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"error\":\"Invalid schedule ID format\"}");
        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.setContentType("application/json; charset=UTF-8");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"error\":\"Database error: "
                    + e.getMessage().replace("\"", "'") + "\"}");
        }
    }

    private void listTickets(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        List<Tickets> tickets;

        if (user != null && "USER".equals(user.getRole())) {
            // Auto-mark arrived tickets as COMPLETED for this user
            try {
                ticketDAO.markCompletedTicketsIfArrivedForUser(user.getUserId());
            } catch (SQLException e) {
                // Ignore auto-update failure; still show tickets
            }
            // Only show tickets for this user
            tickets = ticketDAO.getTicketsByUserId(user.getUserId());
        } else {
            // Admin/Driver: show all tickets
            tickets = ticketDAO.getAllTickets();
        }

        request.setAttribute("tickets", tickets);

        // Use different views based on user role
        if (user != null && "USER".equals(user.getRole())) {
            request.getRequestDispatcher("/views/passengers/passenger-tickets.jsp").forward(request,
                    response);
        } else {
            request.getRequestDispatcher("/views/tickets/tickets.jsp").forward(request, response);
        }
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        // Check if user has permission to add tickets
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user != null && "USER".equals(user.getRole())) {
            // User cannot add tickets manually
            handleError(request, response, "Access denied. Users cannot add tickets manually.");
            return;
        }

        // Load data for dropdowns
        List<Routes> routes = routeDAO.getAllRoutes();
        List<Bus> buses = busDAO.getAvailableBuses();
        List<User> users = userDAO.getUsersByRole("USER"); // Get users with USER role

        request.setAttribute("routes", routes);
        request.setAttribute("buses", buses);
        request.setAttribute("users", users); // This will be used as passengers in the form
        request.getRequestDispatcher("/views/tickets/ticket-form.jsp").forward(request, response);
    }

    private void showBookingForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath()
                    + "/auth/login?error=You need to login to book tickets");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"USER".equals(user.getRole())) {
            handleError(request, response, "Access denied. Only users can book tickets.");
            return;
        }

        // Read error parameter from URL and set as attribute
        String errorParam = request.getParameter("error");
        if (errorParam != null && !errorParam.trim().isEmpty()) {
            request.setAttribute("error", errorParam);
        }

        String routeIdStr = request.getParameter("routeId");
        String scheduleIdStr = request.getParameter("scheduleId");
        String departureDateStr = request.getParameter("departureDate");

        if (routeIdStr != null && !routeIdStr.trim().isEmpty()) {
            try {
                UUID routeId = UUID.fromString(routeIdStr);
                Routes route = routeDAO.getRouteById(routeId);
                if (route != null) {
                    request.setAttribute("route", route);

                    // Load schedules for this route, filter by date if provided
                    List<Schedule> schedules;
                    if (departureDateStr != null && !departureDateStr.trim().isEmpty()) {
                        try {
                            java.time.LocalDate departureDate =
                                    java.time.LocalDate.parse(departureDateStr);
                            schedules =
                                    scheduleDAO.getSchedulesByRouteAndDate(routeId, departureDate);
                            request.setAttribute("departureDate", departureDateStr);
                        } catch (Exception e) {
                            // If date parsing fails, fall back to all schedules
                            schedules = scheduleDAO.getSchedulesByRoute(routeId);
                        }
                    } else {
                        // Load all schedules if no date specified
                        schedules = scheduleDAO.getSchedulesByRoute(routeId);
                    }
                    // Keep all schedules (including expired) for display with filter option
                    // Mark expired schedules in the request
                    LocalDateTime now = LocalDateTime.now();
                    request.setAttribute("schedules", schedules);
                    request.setAttribute("currentDateTime", now);
                } else {
                    // If errorParam is already set, don't override it
                    if (errorParam == null || errorParam.trim().isEmpty()) {
                        request.setAttribute("error", "Route not found");
                    }
                }
            } catch (Exception e) {
                // If errorParam is already set, don't override it
                if (errorParam == null || errorParam.trim().isEmpty()) {
                    request.setAttribute("error", "Invalid route ID");
                }
            }
        } else {
            // If no routeId provided and no error message, show default message
            if (errorParam == null || errorParam.trim().isEmpty()) {
                request.setAttribute("error",
                        "Route ID is required for booking. Please select a route from the search page.");
            }
        }

        // If scheduleId is provided, load schedule details
        if (scheduleIdStr != null && !scheduleIdStr.trim().isEmpty()) {
            try {
                UUID scheduleId = UUID.fromString(scheduleIdStr);
                Schedule schedule = scheduleDAO.getScheduleById(scheduleId);
                if (schedule != null) {
                    request.setAttribute("selectedSchedule", schedule);
                }
            } catch (Exception e) {
                // Ignore invalid scheduleId
            }
        }

        // Always render the booking page
        request.getRequestDispatcher("/views/tickets/booking-form.jsp").forward(request, response);
    }

    private void bookTicketBySchedule(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        String scheduleIdStr = request.getParameter("scheduleId");
        String seatNumberStr = request.getParameter("seatNumber");
        String routeIdStr = request.getParameter("routeId");
        String tripType = request.getParameter("tripType");
        String returnScheduleIdStr = request.getParameter("returnScheduleId");
        String returnSeatNumberStr = request.getParameter("returnSeatNumber");

        if (scheduleIdStr == null || seatNumberStr == null) {
            String redirectUrl = request.getContextPath() + "/tickets/book?";
            if (routeIdStr != null && !routeIdStr.trim().isEmpty()) {
                redirectUrl += URLUtils.createParameter("routeId", routeIdStr) + "&";
            }
            redirectUrl +=
                    URLUtils.createParameter("error", "Missing required booking information");
            response.sendRedirect(redirectUrl);
            return;
        }

        try {
            UUID scheduleId = UUID.fromString(scheduleIdStr);
            int seatNumber = Integer.parseInt(seatNumberStr);

            // Get schedule first to extract routeId if not provided
            Schedule schedule = scheduleDAO.getScheduleById(scheduleId);
            if (schedule == null) {
                String redirectUrl = request.getContextPath() + "/tickets/book?";
                if (routeIdStr != null && !routeIdStr.trim().isEmpty()) {
                    redirectUrl += URLUtils.createParameter("routeId", routeIdStr) + "&";
                }
                redirectUrl += URLUtils.createParameter("error", "Schedule not found");
                response.sendRedirect(redirectUrl);
                return;
            }

            // Use routeId from schedule if not provided in request (make it final for
            // lambda)
            final String finalRouteIdStr = (routeIdStr != null && !routeIdStr.trim().isEmpty())
                    ? routeIdStr
                    : schedule.getRouteId().toString();

            // Helper method to build redirect URL with routeId preserved
            java.util.function.Function<String, String> buildRedirectUrl = (errorMsg) -> {
                StringBuilder url = new StringBuilder(request.getContextPath() + "/tickets/book?");
                url.append(URLUtils.createParameter("routeId", finalRouteIdStr)).append("&");
                url.append(URLUtils.createParameter("error", errorMsg));
                return url.toString();
            };

            if (!ticketDAO.isSeatAvailable(scheduleId, seatNumber)) {
                response.sendRedirect(buildRedirectUrl.apply("Selected seat is not available"));
                return;
            }

            Routes route = routeDAO.getRouteById(schedule.getRouteId());
            if (route == null) {
                response.sendRedirect(buildRedirectUrl.apply("Route not found"));
                return;
            }

            Tickets ticket = new Tickets();
            ticket.setTicketNumber(ticketDAO.generateTicketNumber());
            ticket.setScheduleId(scheduleId);
            ticket.setUserId(user.getUserId());
            ticket.setSeatNumber(seatNumber);
            ticket.setTicketPrice(route.getBasePrice());
            ticket.setStatus("CONFIRMED");
            ticket.setPaymentStatus("PENDING");

            // Set boarding and alighting stations if provided
            String boardingStationIdStr = request.getParameter("boardingStationId");
            String alightingStationIdStr = request.getParameter("alightingStationId");
            if (boardingStationIdStr != null && !boardingStationIdStr.trim().isEmpty()) {
                try {
                    ticket.setBoardingStationId(UUID.fromString(boardingStationIdStr));
                } catch (Exception e) {

                }
            }
            if (alightingStationIdStr != null && !alightingStationIdStr.trim().isEmpty()) {
                try {
                    ticket.setAlightingStationId(UUID.fromString(alightingStationIdStr));
                } catch (Exception e) {

                }
            }

            boolean success = ticketDAO.addTicket(ticket);
            if (!success) {
                response.sendRedirect(buildRedirectUrl.apply("Failed to book ticket"));
                return;
            }

            if ("roundtrip".equals(tripType) && returnScheduleIdStr != null
                    && returnSeatNumberStr != null) {
                try {
                    UUID returnScheduleId = UUID.fromString(returnScheduleIdStr);
                    int returnSeatNumber = Integer.parseInt(returnSeatNumberStr);

                    if (!ticketDAO.isSeatAvailable(returnScheduleId, returnSeatNumber)) {
                        response.sendRedirect(request.getContextPath()
                                + "/tickets?error=Outbound booked but return seat not available");
                        return;
                    }

                    Schedule returnSchedule = scheduleDAO.getScheduleById(returnScheduleId);
                    Routes returnRoute = routeDAO.getRouteById(returnSchedule.getRouteId());
                    if (returnSchedule == null || returnRoute == null) {
                        String redirectUrl = request.getContextPath() + "/tickets/book?";
                        if (finalRouteIdStr != null && !finalRouteIdStr.trim().isEmpty()) {
                            redirectUrl +=
                                    URLUtils.createParameter("routeId", finalRouteIdStr) + "&";
                        }
                        redirectUrl += URLUtils.createParameter("error",
                                "Return schedule or route not found");
                        response.sendRedirect(redirectUrl);
                        return;
                    }

                    Tickets returnTicket = new Tickets();
                    returnTicket.setTicketNumber(ticketDAO.generateTicketNumber());
                    returnTicket.setScheduleId(returnScheduleId);
                    returnTicket.setUserId(user.getUserId());
                    returnTicket.setSeatNumber(returnSeatNumber);
                    returnTicket.setTicketPrice(returnRoute.getBasePrice());
                    returnTicket.setStatus("CONFIRMED");
                    returnTicket.setPaymentStatus("PENDING");

                    // Set stations for return ticket (reversed)
                    String returnBoardingStationIdStr =
                            request.getParameter("returnBoardingStationId");
                    String returnAlightingStationIdStr =
                            request.getParameter("returnAlightingStationId");
                    if (returnBoardingStationIdStr != null
                            && !returnBoardingStationIdStr.trim().isEmpty()) {
                        try {
                            returnTicket.setBoardingStationId(
                                    UUID.fromString(returnBoardingStationIdStr));
                        } catch (Exception e) {
                        }
                    }
                    if (returnAlightingStationIdStr != null
                            && !returnAlightingStationIdStr.trim().isEmpty()) {
                        try {
                            returnTicket.setAlightingStationId(
                                    UUID.fromString(returnAlightingStationIdStr));
                        } catch (Exception e) {
                        }
                    }

                    boolean returnSuccess = ticketDAO.addTicket(returnTicket);
                    if (!returnSuccess) {
                        response.sendRedirect(request.getContextPath()
                                + "/tickets?error=Outbound booked but failed to book return ticket");
                        return;
                    }

                    response.sendRedirect(request.getContextPath()
                            + "/tickets?message=Round trip booked! Ticket numbers: "
                            + ticket.getTicketNumber() + " and " + returnTicket.getTicketNumber());
                    return;
                } catch (Exception e) {
                    // Use buildRedirectUrl if finalRouteIdStr is in scope, otherwise build manually
                    String redirectUrl = request.getContextPath() + "/tickets/book?";
                    if (finalRouteIdStr != null && !finalRouteIdStr.trim().isEmpty()) {
                        redirectUrl += URLUtils.createParameter("routeId", finalRouteIdStr) + "&";
                    }
                    redirectUrl += URLUtils.createParameter("error",
                            "Error booking return ticket: " + e.getMessage());
                    response.sendRedirect(redirectUrl);
                    return;
                }
            }

            response.sendRedirect(request.getContextPath()
                    + "/tickets?message=Ticket booked successfully! Ticket number: "
                    + ticket.getTicketNumber());
        } catch (NumberFormatException e) {
            // Try to get routeId from schedule if possible
            String errorRouteId = routeIdStr;
            try {
                if (scheduleIdStr != null) {
                    UUID scheduleIdForError = UUID.fromString(scheduleIdStr);
                    Schedule scheduleForError = scheduleDAO.getScheduleById(scheduleIdForError);
                    if (scheduleForError != null) {
                        errorRouteId = scheduleForError.getRouteId().toString();
                    }
                }
            } catch (Exception ex) {
                // Use routeIdStr if schedule lookup fails
            }
            String redirectUrl = request.getContextPath() + "/tickets/book?";
            if (errorRouteId != null && !errorRouteId.trim().isEmpty()) {
                redirectUrl += URLUtils.createParameter("routeId", errorRouteId) + "&";
            }
            redirectUrl += URLUtils.createParameter("error", "Invalid schedule ID or seat number");
            response.sendRedirect(redirectUrl);
        } catch (Exception e) {
            // Try to get routeId from schedule if possible
            String errorRouteId = routeIdStr;
            try {
                if (scheduleIdStr != null) {
                    UUID scheduleIdForError = UUID.fromString(scheduleIdStr);
                    Schedule scheduleForError = scheduleDAO.getScheduleById(scheduleIdForError);
                    if (scheduleForError != null) {
                        errorRouteId = scheduleForError.getRouteId().toString();
                    }
                }
            } catch (Exception ex) {
                // Use routeIdStr if schedule lookup fails
            }
            String redirectUrl = request.getContextPath() + "/tickets/book?";
            if (errorRouteId != null && !errorRouteId.trim().isEmpty()) {
                redirectUrl += URLUtils.createParameter("routeId", errorRouteId) + "&";
            }
            redirectUrl +=
                    URLUtils.createParameter("error", "Error booking ticket: " + e.getMessage());
            response.sendRedirect(redirectUrl);
        }
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        try {
            String ticketIdStr = request.getParameter("id");
            if (ticketIdStr == null || ticketIdStr.trim().isEmpty()) {
                handleError(request, response, "Ticket ID is required");
                return;
            }

            UUID ticketId = UUID.fromString(ticketIdStr);
            Tickets ticket = ticketDAO.getTicketById(ticketId);

            if (ticket != null) {
                // Check if user has permission to edit this ticket
                HttpSession session = request.getSession(false);
                User user = (session != null) ? (User) session.getAttribute("user") : null;

                if (user != null && "USER".equals(user.getRole())) {
                    // User cannot edit tickets
                    handleError(request, response, "Access denied. Users cannot edit tickets.");
                    return;
                }

                // Get schedule to extract routeId and busId for pre-selection
                Schedule schedule = scheduleDAO.getScheduleById(ticket.getScheduleId());
                UUID currentRouteId = null;
                UUID currentBusId = null;
                if (schedule != null) {
                    currentRouteId = schedule.getRouteId();
                    currentBusId = schedule.getBusId();
                }

                // Load data for dropdowns
                List<Routes> routes = routeDAO.getAllRoutes();
                List<Bus> buses = busDAO.getAllBuses();
                List<User> users = userDAO.getUsersByRole("USER"); // Get users with USER role

                request.setAttribute("ticket", ticket);
                request.setAttribute("routes", routes);
                request.setAttribute("buses", buses);
                request.setAttribute("users", users);
                request.setAttribute("currentRouteId", currentRouteId);
                request.setAttribute("currentBusId", currentBusId);
                request.getRequestDispatcher("/views/admin/ticket-edit.jsp").forward(request,
                        response);
            } else {
                handleError(request, response, "Ticket not found");
            }
        } catch (IllegalArgumentException e) {
            handleError(request, response, "Invalid ticket ID format");
        } catch (Exception e) {
            handleError(request, response, "Error loading ticket: " + e.getMessage());
        }
    }

    private void searchTickets(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        // Check user role for search permissions
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        String ticketNumber = request.getParameter("ticketNumber");
        String userIdStr = request.getParameter("userId");
        String departureDateStr = request.getParameter("departureDate");

        List<Tickets> tickets = null;

        if (ticketNumber != null && !ticketNumber.trim().isEmpty()) {
            Tickets ticket = ticketDAO.getTicketByNumber(ticketNumber);
            if (ticket != null) {
                // Check if user can view this ticket
                if (user != null && "USER".equals(user.getRole())) {
                    // Check if this ticket belongs to the user
                    if (!ticket.getUserId().equals(user.getUserId())) {
                        tickets = new ArrayList<>(); // Empty list for user
                    } else {
                        tickets = List.of(ticket);
                    }
                } else {
                    tickets = List.of(ticket);
                }
            }
        } else if (userIdStr != null && !userIdStr.trim().isEmpty()) {
            UUID userId = UUID.fromString(userIdStr);
            // For users, always show their own tickets regardless of userId
            // parameter
            if (user != null && "USER".equals(user.getRole())) {
                tickets = ticketDAO.getTicketsByUserId(user.getUserId());
            } else {
                tickets = ticketDAO.getTicketsByUserId(userId);
            }
        } else if (departureDateStr != null && !departureDateStr.trim().isEmpty()) {
            try {
                LocalDate departureDate = LocalDate.parse(departureDateStr);
                // User can only search their own tickets by date
                if (user != null && "USER".equals(user.getRole())) {
                    tickets = ticketDAO.getTicketsByUserId(user.getUserId());
                    // Filter by date
                    tickets = tickets.stream()
                            .filter(ticket -> ticket.getDepartureDate().equals(departureDate))
                            .collect(Collectors.toList());
                } else {
                    tickets = ticketDAO.getTicketsByDate(Date.valueOf(departureDate));
                }
            } catch (Exception e) {
                // Invalid date format
            }
        }

        if (tickets == null) {
            // Default: show appropriate tickets based on user role
            if (user != null && "USER".equals(user.getRole())) {
                tickets = ticketDAO.getTicketsByUserId(user.getUserId());
            } else {
                tickets = ticketDAO.getAllTickets();
            }
        }

        request.setAttribute("tickets", tickets);
        request.getRequestDispatcher("/views/tickets/tickets.jsp").forward(request, response);
    }

    private void printTicket(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        UUID ticketId = UUID.fromString(request.getParameter("id"));
        Tickets ticket = ticketDAO.getTicketById(ticketId);

        if (ticket != null) {
            // Check if user has permission to print this ticket
            HttpSession session = request.getSession(false);
            User user = (session != null) ? (User) session.getAttribute("user") : null;

            if (user != null && "USER".equals(user.getRole())) {
                // User can only print their own tickets
                if (!ticketDAO.isTicketOwnedByUser(ticketId, user.getUserId())) {
                    handleError(request, response,
                            "Access denied. You can only print your own tickets.");
                    return;
                }
            }

            request.setAttribute("ticket", ticket);
            request.getRequestDispatcher("/views/tickets/ticket-print.jsp").forward(request,
                    response);
        } else {
            handleError(request, response, "Ticket not found");
        }
    }

    private void checkSeatAvailability(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        int seatNumber = Integer.parseInt(request.getParameter("seatNumber"));
        UUID busId = UUID.fromString(request.getParameter("busId"));
        String departureDateStr = request.getParameter("departureDate");
        String departureTimeStr = request.getParameter("departureTime");

        try {
            LocalDate departureDate = LocalDate.parse(departureDateStr);
            LocalTime departureTime = LocalTime.parse(departureTimeStr);

            boolean isAvailable = ticketDAO.isSeatAvailable(busId, seatNumber,
                    Date.valueOf(departureDate), Time.valueOf(departureTime));

            response.setContentType("application/json");
            response.getWriter().write("{\"available\": " + isAvailable + "}");
        } catch (Exception e) {
            response.setContentType("application/json");
            response.getWriter().write("{\"error\": \"Invalid date/time format\"}");
        }
    }

    private void addTicket(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        // Check if user has permission to add tickets
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user != null && "USER".equals(user.getRole())) {
            // User cannot add tickets manually
            response.sendRedirect(request.getContextPath()
                    + "/tickets?error=Access denied. Users cannot add tickets manually.");
            return;
        }

        // Get parameters from request
        String routeIdStr = request.getParameter("routeId");
        String busIdStr = request.getParameter("busId");
        String userIdStr = request.getParameter("userId");
        String seatNumberStr = request.getParameter("seatNumber");
        String departureDateStr = request.getParameter("departureDate");
        String departureTimeStr = request.getParameter("departureTime");
        String scheduleIdStr = request.getParameter("scheduleId");
        String ticketPriceStr = request.getParameter("ticketPrice");
        String boardingStationIdStr = request.getParameter("boardingStationId");
        String alightingStationIdStr = request.getParameter("alightingStationId");

        // Log all input parameters

        // Validate and parse parameters
        UUID routeId, busId, userId;
        int seatNumber;
        BigDecimal ticketPrice;
        UUID scheduleId;
        LocalDate departureDate = null;
        LocalTime departureTime = null;

        try {
            routeId = UUID.fromString(routeIdStr);
            busId = UUID.fromString(busIdStr);
            userId = UUID.fromString(userIdStr);
            seatNumber = Integer.parseInt(seatNumberStr);
            ticketPrice = new BigDecimal(ticketPriceStr);

        } catch (Exception e) {
            response.sendRedirect(request.getContextPath()
                    + "/tickets/add?error=Invalid parameter format: " + e.getMessage());
            return;
        }

        // Try to get scheduleId directly if provided, otherwise find by
        // route/bus/date/time
        try {
            if (scheduleIdStr != null && !scheduleIdStr.trim().isEmpty()) {
                // Use scheduleId directly (preferred method - consistent with route search)
                scheduleId = UUID.fromString(scheduleIdStr);

                // Validate schedule exists and get its details
                Schedule schedule = scheduleDAO.getScheduleById(scheduleId);
                if (schedule == null) {
                    response.sendRedirect(request.getContextPath()
                            + "/tickets/add?error=Schedule not found");
                    return;
                }
                // Use schedule's date/time if needed
                departureDate = schedule.getDepartureDate();
                departureTime = schedule.getDepartureTime();
            } else if (departureDateStr != null && departureTimeStr != null
                    && !departureDateStr.trim().isEmpty() && !departureTimeStr.trim().isEmpty()) {
                // Fallback to finding schedule by route/bus/date/time (backward compatibility)
                departureDate = LocalDate.parse(departureDateStr);
                departureTime = LocalTime.parse(departureTimeStr);

                scheduleId = routeDAO.findScheduleId(routeId, busId, departureDate, departureTime);
            } else {
                response.sendRedirect(request.getContextPath()
                        + "/tickets/add?error=Either scheduleId or departure date/time must be provided");
                return;
            }
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath()
                    + "/tickets/add?error=Database error finding schedule: " + e.getMessage());
            return;
        }

        if (scheduleId == null) {
            response.sendRedirect(request.getContextPath()
                    + "/tickets/add?error=Schedule not found for the specified date and time");
            return;
        }

        // Check seat availability

        boolean isSeatAvailable;
        try {
            isSeatAvailable = ticketDAO.isSeatAvailable(scheduleId, seatNumber);
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath()
                    + "/tickets/add?error=Database error checking seat availability: "
                    + e.getMessage());
            return;
        }

        if (!isSeatAvailable) {
            response.sendRedirect(
                    request.getContextPath() + "/tickets/add?error=Seat is not available");
            return;
        }

        // Generate ticket number
        String ticketNumber = ticketDAO.generateTicketNumber();

        // Create new ticket
        Tickets ticket = new Tickets();
        ticket.setTicketNumber(ticketNumber);
        ticket.setScheduleId(scheduleId);
        ticket.setUserId(userId);
        ticket.setSeatNumber(seatNumber);
        ticket.setTicketPrice(ticketPrice);
        ticket.setStatus("CONFIRMED");
        ticket.setPaymentStatus("PENDING");

        // Set boarding and alighting stations if provided
        if (boardingStationIdStr != null && !boardingStationIdStr.trim().isEmpty()) {
            try {
                ticket.setBoardingStationId(UUID.fromString(boardingStationIdStr));
            } catch (Exception e) {
            }
        }
        if (alightingStationIdStr != null && !alightingStationIdStr.trim().isEmpty()) {
            try {
                ticket.setAlightingStationId(UUID.fromString(alightingStationIdStr));
            } catch (Exception e) {
            }
        }

        // Save to database
        boolean success;
        try {
            success = ticketDAO.addTicket(ticket);
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath()
                    + "/tickets/add?error=Database error saving ticket: " + e.getMessage());
            return;
        }

        if (success) {
            response.sendRedirect(
                    request.getContextPath() + "/tickets?message=Ticket added successfully");
        } else {
            response.sendRedirect(
                    request.getContextPath() + "/tickets/add?error=Failed to add ticket");
        }

    }

    private void updateTicket(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        // Check if user has permission to update tickets
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user != null && "USER".equals(user.getRole())) {
            // User cannot update tickets
            response.sendRedirect(request.getContextPath()
                    + "/tickets?error=Access denied. Users cannot update tickets.");
            return;
        }

        // Get parameters from request
        UUID routeId = UUID.fromString(request.getParameter("routeId"));
        UUID busId = UUID.fromString(request.getParameter("busId"));
        UUID ticketId = UUID.fromString(request.getParameter("ticketId"));
        UUID userId = UUID.fromString(request.getParameter("userId"));
        int seatNumber = Integer.parseInt(request.getParameter("seatNumber"));
        String departureDateStr = request.getParameter("departureDate");
        String departureTimeStr = request.getParameter("departureTime");
        BigDecimal ticketPrice = new BigDecimal(request.getParameter("ticketPrice"));
        String status = request.getParameter("status");
        String paymentStatus = request.getParameter("paymentStatus");

        // Parse date and time
        LocalDate departureDate = LocalDate.parse(departureDateStr);
        LocalTime departureTime = LocalTime.parse(departureTimeStr);

        // Find schedule ID based on route, bus, and departure date/time
        UUID scheduleId = routeDAO.findScheduleId(routeId, busId, departureDate, departureTime);
        if (scheduleId == null) {
            response.sendRedirect(request.getContextPath() + "/tickets/edit?id=" + ticketId
                    + "&error=Schedule not found for the specified date and time");
            return;
        }

        // Create ticket object
        Tickets ticket = new Tickets();
        ticket.setTicketNumber("");
        ticket.setScheduleId(scheduleId);
        ticket.setUserId(userId);
        ticket.setSeatNumber(seatNumber);
        ticket.setDepartureDate(departureDate);
        ticket.setDepartureTime(departureTime);
        ticket.setTicketPrice(ticketPrice);
        ticket.setTicketId(ticketId);
        ticket.setStatus(status);
        ticket.setPaymentStatus(paymentStatus);

        // Update in database
        boolean success = ticketDAO.updateTicket(ticket);

        if (success) {
            response.sendRedirect(request.getContextPath()
                    + "/admin/tickets?message=Ticket updated successfully");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/tickets/edit?id=" + ticketId
                    + "&error=Failed to update ticket");
        }
    }

    private void bookTicket(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        // Check authentication
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath()
                    + "/auth/login?error=You need to login to book tickets");
            return;
        }

        User user = (User) session.getAttribute("user");

        // Get parameters from request
        String routeIdStr = request.getParameter("routeId");
        String busIdStr = request.getParameter("busId");
        String seatNumberStr = request.getParameter("seatNumber");

        // Validate required parameters
        if (routeIdStr == null || routeIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath()
                    + "/tickets/book?"
                    + URLUtils.createParameter("error", "Route ID is required for booking."));
            return;
        }

        if (busIdStr == null || busIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath()
                    + "/tickets/book?"
                    + URLUtils.createParameter("error", "Bus ID is required for booking."));
            return;
        }

        if (seatNumberStr == null || seatNumberStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath()
                    + "/tickets/book?"
                    + URLUtils.createParameter("error", "Seat number is required for booking."));
            return;
        }

        // Parse parameters
        UUID routeId, busId;
        int seatNumber;
        try {
            routeId = UUID.fromString(routeIdStr);
            busId = UUID.fromString(busIdStr);

            seatNumber = Integer.parseInt(seatNumberStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(
                    request.getContextPath() + "/tickets/book?"
                            + URLUtils.createParameter("error", "Invalid parameter format."));
            return;
        }

        // Use user directly since we no longer have separate Passenger table
        UUID userId = user.getUserId();
        String departureDateStr = request.getParameter("departureDate");
        String departureTimeStr = request.getParameter("departureTime");
        BigDecimal ticketPrice = routeDAO.getPriceByRouteId(routeId);

        // Validate input
        if (departureDateStr == null || departureDateStr.trim().isEmpty()) {
            response.sendRedirect(
                    request.getContextPath() + "/tickets/book?"
                            + URLUtils.createParameter("error", "Departure date is required"));
            return;
        }

        if (departureTimeStr == null || departureTimeStr.trim().isEmpty()) {
            response.sendRedirect(
                    request.getContextPath() + "/tickets/book?"
                            + URLUtils.createParameter("error", "Departure time is required"));
            return;
        }

        // Parse date and time
        LocalDate departureDate;
        LocalTime departureTime;
        try {
            departureDate = LocalDate.parse(departureDateStr);
            departureTime = LocalTime.parse(departureTimeStr);
        } catch (Exception e) {
            response.sendRedirect(
                    request.getContextPath() + "/tickets/book?"
                            + URLUtils.createParameter("error", "Invalid date/time format"));
            return;
        }

        // Find schedule ID based on route, bus, and departure date/time (create if
        // missing)
        UUID scheduleId = routeDAO.findScheduleId(routeId, busId, departureDate, departureTime);
        if (scheduleId == null) {
            // Attempt to create a schedule on-the-fly for this bus/route/time
            int durationHours = 1;
            Routes route = routeDAO.getRouteById(routeId);
            if (route != null && route.getDurationHours() > 0) {
                durationHours = route.getDurationHours();
            }
            Bus bus = busDAO.getBusById(busId);
            if (bus == null) {
                response.sendRedirect(
                        request.getContextPath() + "/tickets/book?"
                                + URLUtils.createParameter("error", "Invalid bus selected"));
                return;
            }
            try {
                scheduleId = scheduleDAO.findOrCreateSchedule(routeId, busId, departureDate,
                        departureTime, durationHours, bus.getTotalSeats());
            } catch (SQLException e) {
                response.sendRedirect(request.getContextPath()
                        + "/tickets/book?" + URLUtils.createParameter("error",
                                "Unable to create schedule: " + e.getMessage()));
                return;
            }
        }

        // Check seat availability
        boolean isSeatAvailable = ticketDAO.isSeatAvailable(scheduleId, seatNumber);

        if (!isSeatAvailable) {
            response.sendRedirect(
                    request.getContextPath() + "/tickets/book?"
                            + URLUtils.createParameter("error", "Seat is not available"));
            return;
        }

        // Generate ticket number
        String ticketNumber = ticketDAO.generateTicketNumber();

        // Create new ticket
        Tickets ticket = new Tickets();
        ticket.setTicketNumber(ticketNumber);
        ticket.setScheduleId(scheduleId);
        ticket.setUserId(userId);
        ticket.setSeatNumber(seatNumber);
        ticket.setDepartureDate(departureDate);
        ticket.setDepartureTime(departureTime);
        ticket.setTicketPrice(ticketPrice);
        ticket.setStatus("CONFIRMED");
        ticket.setPaymentStatus("PENDING");

        // Save to database
        boolean success = ticketDAO.addTicket(ticket);

        if (success) {
            // Note: available seats are managed in Schedule table, not Bus table
            response.sendRedirect(
                    request.getContextPath() + "/tickets?message=Ticket booked successfully");
        } else {
            response.sendRedirect(
                    request.getContextPath() + "/tickets/book?"
                            + URLUtils.createParameter("error", "Failed to book ticket"));
        }
    }

    private void deleteTicket(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        UUID ticketId = UUID.fromString(request.getParameter("id"));

        // Check if user has permission to delete this ticket
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user != null && "USER".equals(user.getRole())) {
            // User can only cancel their own tickets
            if (!ticketDAO.isTicketOwnedByUser(ticketId, user.getUserId())) {
                response.sendRedirect(request.getContextPath()
                        + "/tickets?error=Access denied. You can only cancel your own tickets.");
                return;
            }
        }

        boolean success = ticketDAO.deleteTicket(ticketId);

        if (success) {
            response.sendRedirect(
                    request.getContextPath() + "/tickets?message=Ticket cancelled successfully");
        } else {
            response.sendRedirect(
                    request.getContextPath() + "/tickets?error=Failed to cancel ticket");
        }
    }

    private void getTicketById(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        String pathInfo = request.getPathInfo();
        UUID ticketId = UUID.fromString(pathInfo.substring(1));
        Tickets ticket = ticketDAO.getTicketById(ticketId);

        if (ticket != null) {
            // Check if user has permission to view this ticket
            HttpSession session = request.getSession(false);
            User user = (session != null) ? (User) session.getAttribute("user") : null;

            if (user != null && "USER".equals(user.getRole())) {
                // User can only view their own tickets
                if (!ticketDAO.isTicketOwnedByUser(ticketId, user.getUserId())) {
                    handleError(request, response,
                            "Access denied. You can only view your own tickets.");
                    return;
                }
            }

            request.setAttribute("ticket", ticket);
            request.getRequestDispatcher("/views/tickets/ticket-detail.jsp").forward(request,
                    response);
        } else {
            handleError(request, response, "Ticket not found");
        }
    }

    private void handleError(HttpServletRequest request, HttpServletResponse response,
            String message) throws ServletException, IOException {
        request.setAttribute("error", message);
        request.getRequestDispatcher("/views/errors/error.jsp").forward(request, response);
    }

    // Admin-specific handlers
    private void adminListTickets(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        try {
            String searchTerm = request.getParameter("searchTerm");
            String status = request.getParameter("status");
            String paymentStatus = request.getParameter("paymentStatus");

            // Use searchTickets method which supports filtering and returns all tickets
            // when no
            // filters are provided
            // This allows admin to see all tickets (CONFIRMED, PENDING, CANCELLED) when no
            // status
            // filter is set
            List<Tickets> tickets = ticketDAO.searchTickets(
                    (searchTerm != null && !searchTerm.trim().isEmpty()) ? searchTerm : null,
                    (status != null && !status.trim().isEmpty()) ? status : null,
                    (paymentStatus != null && !paymentStatus.trim().isEmpty()) ? paymentStatus
                            : null,
                    null, null, null, null);

            request.setAttribute("tickets", tickets);
            request.getRequestDispatcher("/views/admin/tickets-list.jsp").forward(request,
                    response);
        } catch (Exception e) {
            request.setAttribute("error", "Error loading tickets: " + e.getMessage());
            request.getRequestDispatcher("/views/errors/error.jsp").forward(request, response);
        }
    }

    private void adminShowEditForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        String ticketIdStr = request.getParameter("id");
        if (ticketIdStr == null || ticketIdStr.trim().isEmpty()) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/admin/tickets?error=Missing information: Ticket ID cannot be empty");
            return;
        }
        try {
            UUID ticketId = UUID.fromString(ticketIdStr);
            Tickets ticket = ticketDAO.getTicketById(ticketId);
            if (ticket != null) {
                Schedule schedule = scheduleDAO.getScheduleById(ticket.getScheduleId());
                UUID currentRouteId = null;
                UUID currentBusId = null;
                if (schedule != null) {
                    currentRouteId = schedule.getRouteId();
                    currentBusId = schedule.getBusId();
                }
                List<Routes> routes = routeDAO.getAllRoutes();
                List<Bus> buses = busDAO.getAllBuses();
                List<User> users = userDAO.getUsersByRole("USER");
                request.setAttribute("ticket", ticket);
                request.setAttribute("routes", routes);
                request.setAttribute("buses", buses);
                request.setAttribute("users", users);
                request.setAttribute("currentRouteId", currentRouteId);
                request.setAttribute("currentBusId", currentBusId);
                request.getRequestDispatcher("/views/admin/ticket-edit.jsp").forward(request,
                        response);
            } else {
                response.sendRedirect(
                        request.getContextPath()
                                + "/admin/tickets?error=Error: Ticket not found with the given ID");
            }
        } catch (IllegalArgumentException e) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/admin/tickets?error=Error: Invalid ticket ID. Please check again");
        }
    }

    private void adminUpdateTicket(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        try {
            String ticketIdStr = request.getParameter("ticketId");
            String routeIdStr = request.getParameter("routeId");
            String busIdStr = request.getParameter("busId");
            String userIdStr = request.getParameter("userId");
            String departureDateStr = request.getParameter("departureDate");
            String departureTimeStr = request.getParameter("departureTime");
            String seatNumberStr = request.getParameter("seatNumber");
            String ticketPriceStr = request.getParameter("ticketPrice");
            String status = request.getParameter("status");
            String paymentStatus = request.getParameter("paymentStatus");

            // Validate required fields and provide specific error messages
            if (ticketIdStr == null || ticketIdStr.trim().isEmpty()) {
                response.sendRedirect(
                        request.getContextPath()
                                + "/admin/tickets?error=Missing information: Ticket ID cannot be empty");
                return;
            }
            if (routeIdStr == null || routeIdStr.trim().isEmpty()) {
                response.sendRedirect(
                        request.getContextPath() + "/admin/tickets/edit?id=" + ticketIdStr
                                + "&error=Missing information: Please select a route");
                return;
            }
            if (busIdStr == null || busIdStr.trim().isEmpty()) {
                response.sendRedirect(
                        request.getContextPath() + "/admin/tickets/edit?id=" + ticketIdStr
                                + "&error=Missing information: Please select a bus");
                return;
            }
            if (userIdStr == null || userIdStr.trim().isEmpty()) {
                response.sendRedirect(
                        request.getContextPath() + "/admin/tickets/edit?id=" + ticketIdStr
                                + "&error=Missing information: Please select a passenger");
                return;
            }
            if (departureDateStr == null || departureDateStr.trim().isEmpty()) {
                response.sendRedirect(
                        request.getContextPath() + "/admin/tickets/edit?id=" + ticketIdStr
                                + "&error=Missing information: Please select departure date");
                return;
            }
            if (departureTimeStr == null || departureTimeStr.trim().isEmpty()) {
                response.sendRedirect(
                        request.getContextPath() + "/admin/tickets/edit?id=" + ticketIdStr
                                + "&error=Missing information: Please select departure time");
                return;
            }
            if (seatNumberStr == null || seatNumberStr.trim().isEmpty()) {
                response.sendRedirect(
                        request.getContextPath() + "/admin/tickets/edit?id=" + ticketIdStr
                                + "&error=Missing information: Please select seat number");
                return;
            }
            if (ticketPriceStr == null || ticketPriceStr.trim().isEmpty()) {
                response.sendRedirect(
                        request.getContextPath() + "/admin/tickets/edit?id=" + ticketIdStr
                                + "&error=Missing information: Please enter ticket price");
                return;
            }

            UUID ticketId = UUID.fromString(ticketIdStr);
            UUID routeId = UUID.fromString(routeIdStr);
            UUID busId = UUID.fromString(busIdStr);
            UUID userId = UUID.fromString(userIdStr);
            LocalDate departureDate = LocalDate.parse(departureDateStr);
            LocalTime departureTime = LocalTime.parse(departureTimeStr);
            int seatNumber = Integer.parseInt(seatNumberStr);
            double ticketPrice = Double.parseDouble(ticketPriceStr);

            UUID scheduleId = routeDAO.findScheduleId(routeId, busId, departureDate, departureTime);
            if (scheduleId == null) {
                response.sendRedirect(
                        request.getContextPath() + "/admin/tickets/edit?id=" + ticketId
                                + "&error=Error: Schedule not found for the selected date and time. Please check the route, bus, departure date and time");
                return;
            }

            boolean isSeatAvailable =
                    ticketDAO.isSeatAvailableForUpdate(scheduleId, seatNumber, ticketId);
            if (!isSeatAvailable) {
                response.sendRedirect(
                        request.getContextPath() + "/admin/tickets/edit?id=" + ticketId
                                + "&error=Error: Seat number " + seatNumber
                                + " is already booked. Please select another seat");
                return;
            }

            Tickets existingTicket = ticketDAO.getTicketById(ticketId);
            if (existingTicket == null) {
                response.sendRedirect(
                        request.getContextPath()
                                + "/admin/tickets?error=Error: Ticket not found with the given ID. The ticket may have been deleted");
                return;
            }

            existingTicket.setScheduleId(scheduleId);
            existingTicket.setUserId(userId);
            existingTicket.setSeatNumber(seatNumber);
            existingTicket.setTicketPrice(BigDecimal.valueOf(ticketPrice));
            existingTicket.setStatus(status != null ? status : "CONFIRMED");
            existingTicket.setPaymentStatus(paymentStatus != null ? paymentStatus : "PENDING");

            boolean success = ticketDAO.updateTicket(existingTicket);
            if (success) {
                response.sendRedirect(request.getContextPath()
                        + "/admin/tickets?message=Ticket updated successfully! Ticket information has been saved");
            } else {
                response.sendRedirect(
                        request.getContextPath() + "/admin/tickets/edit?id=" + ticketId
                                + "&error=Error: Failed to update ticket. Please try again or contact administrator");
            }
        } catch (NumberFormatException | java.time.format.DateTimeParseException e) {
            response.sendRedirect(request.getContextPath() + "/admin/tickets/edit?id="
                    + request.getParameter("ticketId")
                    + "&error=Data format error: " + e.getMessage()
                    + ". Please check the entered information");
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/admin/tickets/edit?id="
                    + request.getParameter("ticketId")
                    + "&error=Unexpected error: " + e.getMessage() + ". Please try again");
        }
    }

    private void adminDeleteTicket(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String ticketIdStr = request.getParameter("id");
        if (ticketIdStr == null || ticketIdStr.trim().isEmpty()) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/admin/tickets?error=Missing information: Ticket ID cannot be empty");
            return;
        }
        try {
            UUID ticketId = UUID.fromString(ticketIdStr);
            boolean success = ticketDAO.deleteTicket(ticketId);
            if (success) {
                response.sendRedirect(request.getContextPath()
                        + "/admin/tickets?message=Ticket deleted successfully! Ticket has been removed from the system");
            } else {
                response.sendRedirect(
                        request.getContextPath()
                                + "/admin/tickets?error=Error: Failed to delete ticket. The ticket may be in use or does not exist");
            }
        } catch (IllegalArgumentException e) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/admin/tickets?error=Error: Invalid ticket ID. Please check again");
        }
    }

    private void adminHandleBulkTicketAction(HttpServletRequest request,
            HttpServletResponse response)
            throws SQLException, IOException {
        String action = request.getParameter("action");
        String[] ticketIds = request.getParameterValues("ticketIds");
        if (action == null || ticketIds == null || ticketIds.length == 0) {
            response.sendRedirect(request.getContextPath()
                    + "/admin/tickets?error=No tickets selected or action specified");
            return;
        }
        int successCount = 0;
        int totalCount = ticketIds.length;
        try {
            switch (action) {
                case "confirm":
                    for (String ticketIdStr : ticketIds) {
                        UUID ticketId = UUID.fromString(ticketIdStr);
                        Tickets ticket = ticketDAO.getTicketById(ticketId);
                        if (ticket != null) {
                            ticket.setStatus("CONFIRMED");
                            if (ticketDAO.updateTicket(ticket))
                                successCount++;
                        }
                    }
                    break;
                case "cancel":
                    for (String ticketIdStr : ticketIds) {
                        UUID ticketId = UUID.fromString(ticketIdStr);
                        Tickets ticket = ticketDAO.getTicketById(ticketId);
                        if (ticket != null) {
                            ticket.setStatus("CANCELLED");
                            ticket.setPaymentStatus("CANCELLED");
                            if (ticketDAO.updateTicket(ticket))
                                successCount++;
                        }
                    }
                    break;
                case "delete":
                    for (String ticketIdStr : ticketIds) {
                        UUID ticketId = UUID.fromString(ticketIdStr);
                        if (ticketDAO.deleteTicket(ticketId))
                            successCount++;
                    }
                    break;
                default:
                    response.sendRedirect(request.getContextPath()
                            + "/admin/tickets?error=Error: Invalid action. Please select one of the following actions: confirm, cancel, or delete");
                    return;
            }
            String actionText = action.equals("confirm") ? "have been confirmed"
                    : action.equals("cancel") ? "have been cancelled" : "have been deleted";
            if (successCount == totalCount) {
                response.sendRedirect(
                        request.getContextPath() + "/admin/tickets?message=Success! All "
                                + successCount
                                + " tickets " + actionText);
            } else {
                response.sendRedirect(
                        request.getContextPath() + "/admin/tickets?warning=Partially completed: "
                                + successCount
                                + " out of " + totalCount + " tickets " + actionText
                                + ". Please check the remaining tickets");
            }
        } catch (IllegalArgumentException e) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/admin/tickets?error=Error: Invalid ticket ID format. Please check again");
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath()
                    + "/admin/tickets?error=Error: An error occurred during bulk operation. "
                    + e.getMessage());
        }
    }

    private void adminExportTickets(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String format = request.getParameter("format");
        if (format == null)
            format = "excel";
        try {
            List<Tickets> tickets = ticketDAO.getAllTickets();
            if ("excel".equals(format)) {
                response.setContentType("text/csv");
                response.setHeader("Content-Disposition",
                        "attachment; filename=tickets_" + java.time.LocalDate.now() + ".csv");
                java.io.PrintWriter writer = response.getWriter();
                writer.println(
                        "Ticket Number,Passenger Name,Route,Departure Date,Departure Time,Seat,Price,Status,Payment Status");
                for (Tickets ticket : tickets) {
                    writer.println(String.format("%s,%s,%s to %s,%s,%s,%d,%.0f,%s,%s",
                            ticket.getTicketNumber(),
                            ticket.getUserName(),
                            ticket.getDepartureCity(),
                            ticket.getDestinationCity(),
                            ticket.getDepartureDate(),
                            ticket.getDepartureTime(),
                            ticket.getSeatNumber(),
                            ticket.getTicketPrice().doubleValue(),
                            ticket.getStatus(),
                            ticket.getPaymentStatus()));
                }
            } else if ("pdf".equals(format)) {
                response.sendRedirect(request.getContextPath()
                        + "/admin/tickets?error=PDF export is no longer available");
            }
        } catch (Exception e) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/tickets?error=Failed to export tickets");
        }
    }

    private void adminShowTicketAnalytics(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        try {
            java.util.Map<String, Object> ticketStats = ticketDAO.getTicketStatistics();
            List<Tickets> recentTickets = ticketDAO.getRecentTickets(10);
            request.setAttribute("ticketStats", ticketStats);
            request.setAttribute("recentTickets", recentTickets);
            request.getRequestDispatcher("/views/admin/ticket-analytics.jsp").forward(request,
                    response);
        } catch (Exception e) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/tickets?error=Failed to load analytics");
        }
    }
}
