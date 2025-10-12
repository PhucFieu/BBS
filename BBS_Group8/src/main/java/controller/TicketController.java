package controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.sql.SQLException;
import java.sql.Time;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

import com.google.gson.Gson;

import dao.BusDAO;
import dao.RoutesDAO;
import dao.ScheduleDAO;
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

/**
 *
 * @author LamDNB-CE192005
 */

@WebServlet("/tickets/*")
public class TicketController extends HttpServlet {

    private TicketDAO ticketDAO;
    private RoutesDAO routeDAO;
    private ScheduleDAO scheduleDAO;
    private BusDAO busDAO;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        ticketDAO = new TicketDAO();
        routeDAO = new RoutesDAO();
        scheduleDAO = new ScheduleDAO();
        busDAO = new BusDAO();
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        try {
            if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("")) {
                // List all tickets
                listTickets(request, response);
            } else if (pathInfo.equals("/add")) {
                // Show add form
                showAddForm(request, response);
            } else if (pathInfo.equals("/edit")) {
                // Show edit form
                showEditForm(request, response);
            } else if (pathInfo.equals("/delete")) {
                // Delete ticket
                deleteTicket(request, response);
            } else if (pathInfo.equals("/search")) {
                // Search tickets
                searchTickets(request, response);
            } else if (pathInfo.equals("/print")) {
                // Print ticket
                printTicket(request, response);
            } else if (pathInfo.equals("/check-seat")) {
                // Check seat availability
                checkSeatAvailability(request, response);
            } else if (pathInfo.equals("/available-dates")) {
                getAvailableDates(request, response);
            } else if (pathInfo.equals("/available-times")) {
                getAvailableTimes(request, response);
            } else if (pathInfo.equals("/available-seats")) {
                getAvailableSeats(request, response);
            } else if (pathInfo.equals("/available-schedules")) {
                getAvailableSchedules(request, response);
            } else if (pathInfo.equals("/book")) {
                // Show booking form for customers
                showBookingForm(request, response);
            } else {
                // Get ticket by ID
                getTicketById(request, response);
            }
        } catch (SQLException e) {
            handleError(request, response, "Database error: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        try {
            if (pathInfo.equals("/add")) {
                addTicket(request, response);
            } else if (pathInfo.equals("/edit")) {
                updateTicket(request, response);
            } else if (pathInfo.equals("/book")) {
                // Check authentication
                HttpSession session = request.getSession(false);
                if (session == null || session.getAttribute("user") == null) {
                    // Not logged in, redirect to login page with message
                    response.sendRedirect(
                            request.getContextPath()
                                    + "/auth/login?error=You need to login to book tickets");
                    return;
                }
                // Proceed to book ticket
                bookTicket(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            handleError(request, response, "Database error: " + e.getMessage());
        }
    }

    private void getAvailableDates(
            HttpServletRequest request,
            HttpServletResponse response) throws IOException {
        // Always allow today + next 6 days
        LocalDate today = LocalDate.now();
        List<String> dates = new java.util.ArrayList<>();
        for (int i = 0; i < 7; i++) {
            dates.add(today.plusDays(i).toString());
        }
        response.setContentType("application/json");
        response.getWriter().write(new com.google.gson.Gson().toJson(dates));
    }

    private void getAvailableTimes(
            HttpServletRequest request,
            HttpServletResponse response) throws IOException {
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
        response.setContentType("application/json");
        response.getWriter().write(new com.google.gson.Gson().toJson(times));
    }

    private void getAvailableSchedules(
            HttpServletRequest request,
            HttpServletResponse response) throws SQLException, IOException {
        String routeIdStr = request.getParameter("routeId");
        String busIdStr = request.getParameter("busId");
        String dateStr = request.getParameter("date");

        System.out.println("=== GET AVAILABLE SCHEDULES ===");
        System.out.println("RouteId: " + routeIdStr);
        System.out.println("BusId: " + busIdStr);
        System.out.println("Date: " + dateStr);

        if (routeIdStr == null || busIdStr == null) {
            response.setContentType("application/json");
            response.getWriter().write("{\"error\":\"Route ID and Bus ID are required\"}");
            return;
        }

        try {
            UUID routeId = UUID.fromString(routeIdStr);
            UUID busId = UUID.fromString(busIdStr);

            // Debug: Show all schedules in database
            scheduleDAO.debugAllSchedules();

            // Get schedules from database
            List<Schedule> schedules = scheduleDAO.getSchedulesByRouteAndBus(routeId, busId);

            // Filter by date if provided
            if (dateStr != null && !dateStr.trim().isEmpty()) {
                LocalDate filterDate = LocalDate.parse(dateStr);
                schedules = schedules.stream()
                        .filter(schedule -> schedule.getDepartureDate().equals(filterDate))
                        .collect(Collectors.toList());
            }

            System.out.println("Found " + schedules.size() + " schedules");

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

            response.setContentType("application/json");
            response.getWriter().write(new com.google.gson.Gson().toJson(result));

        } catch (Exception e) {
            System.out.println("ERROR getting schedules: " + e.getMessage());
            e.printStackTrace();
            response.setContentType("application/json");
            response.getWriter().write("{\"error\":\"Error retrieving schedules: " + e.getMessage() + "\"}");
        }
    }

    private void getAvailableSeats(
            HttpServletRequest request,
            HttpServletResponse response) throws SQLException, IOException {
        UUID routeId = UUID.fromString(request.getParameter("routeId"));
        String dateStr = request.getParameter("date");
        String timeStr = request.getParameter("time");
        LocalDate date = LocalDate.parse(dateStr);
        LocalTime time = LocalTime.parse(timeStr);

        System.out.println("Getting available seats for route: " + routeId + ", date: " + date + ", time: " + time);

        // Find a bus for this route
        BusDAO busDAO = new BusDAO();
        List<Bus> buses = busDAO.getAvailableBusesForRoute(routeId, date, time);

        System.out.println("Found " + buses.size() + " available buses");

        if (buses.isEmpty()) {
            response.setContentType("application/json");
            response.getWriter().write("{\"error\":\"Không có xe khả dụng cho tuyến này\"}");
            return;
        }

        // Use the first available bus
        Bus bus = buses.get(0);
        System.out.println("Selected bus: " + bus.getBusNumber() + " with " + bus.getTotalSeats() + " total seats");

        // Get all seats for this bus
        int totalSeats = bus.getTotalSeats();

        // Get booked seats for this trip
        TicketDAO ticketDAO = new TicketDAO();
        List<Integer> bookedSeats = ticketDAO.getBookedSeats(
                bus.getBusId(),
                date,
                time);

        System.out.println("Booked seats: " + bookedSeats);

        // Build available seat list
        List<Integer> availableSeats = new ArrayList<>();
        for (int i = 1; i <= totalSeats; i++) {
            if (!bookedSeats.contains(i)) {
                availableSeats.add(i);
            }
        }

        System.out.println("Available seats: " + availableSeats.size() + " seats");

        // Return busId, availableSeats, bookedSeats, and totalSeats
        response.setContentType("application/json");
        response
                .getWriter()
                .write(
                        "{\"busId\":"
                                + bus.getBusId()
                                + ",\"totalSeats\":"
                                + totalSeats
                                + ",\"availableSeats\":"
                                + new Gson().toJson(availableSeats)
                                + ",\"bookedSeats\":"
                                + new Gson().toJson(bookedSeats)
                                + "}");
    }

    private void listTickets(
            HttpServletRequest request,
            HttpServletResponse response) throws SQLException, ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null)
                ? (User) session.getAttribute("user")
                : null;
        List<Tickets> tickets;

        if (user != null && "USER".equals(user.getRole())) {
            // Only show tickets for this user
            tickets = ticketDAO.getTicketsByUserId(user.getUserId());
        } else {
            // Admin/Driver: show all tickets
            tickets = ticketDAO.getAllTickets();
        }

        request.setAttribute("tickets", tickets);
        request
                .getRequestDispatcher("/views/tickets.jsp")
                .forward(request, response);
    }

    private void showAddForm(
            HttpServletRequest request,
            HttpServletResponse response) throws SQLException, ServletException, IOException {
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
        request
                .getRequestDispatcher("/views/ticket-form.jsp")
                .forward(request, response);
    }

    private void showBookingForm(
            HttpServletRequest request,
            HttpServletResponse response) throws SQLException, ServletException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/auth/login?error=You need to login to book tickets");
            return;
        }

        User user = (User) session.getAttribute("user");

        // Check if user is a regular user
        if (!"USER".equals(user.getRole())) {
            handleError(request, response, "Access denied. Only users can book tickets.");
            return;
        }

        // Get route ID from request parameter
        String routeIdStr = request.getParameter("routeId");
        if (routeIdStr == null || routeIdStr.trim().isEmpty()) {
            handleError(request, response, "Route ID is required for booking.");
            return;
        }

        UUID routeId = UUID.fromString(routeIdStr);
        Routes route = routeDAO.getRouteById(routeId);

        if (route == null) {
            handleError(request, response, "Route not found.");
            return;
        }

        // Load data for the booking form
        List<Routes> routes = routeDAO.getAllRoutes();

        request.setAttribute("route", route);
        request.setAttribute("routes", routes);
        request.setAttribute("isBooking", true); // Flag to indicate this is a booking form
        request
                .getRequestDispatcher("/views/ticket-form.jsp")
                .forward(request, response);
    }

    private void showEditForm(
            HttpServletRequest request,
            HttpServletResponse response) throws SQLException, ServletException, IOException {
        UUID ticketId = UUID.fromString(request.getParameter("id"));
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

            // Load data for dropdowns
            List<Routes> routes = routeDAO.getAllRoutes();
            List<Bus> buses = busDAO.getAllBuses();
            List<User> users = userDAO.getUsersByRole("USER"); // Get users with USER role

            request.setAttribute("ticket", ticket);
            request.setAttribute("routes", routes);
            request.setAttribute("buses", buses);
            request.setAttribute("users", users);
            request
                    .getRequestDispatcher("/views/ticket-form.jsp")
                    .forward(request, response);
        } else {
            handleError(request, response, "Ticket not found");
        }
    }

    private void searchTickets(
            HttpServletRequest request,
            HttpServletResponse response) throws SQLException, ServletException, IOException {
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
                    tickets = ticketDAO.getTicketsByDate(
                            Date.valueOf(departureDate));
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
        request
                .getRequestDispatcher("/views/tickets.jsp")
                .forward(request, response);
    }

    private void printTicket(
            HttpServletRequest request,
            HttpServletResponse response) throws SQLException, ServletException, IOException {
        UUID ticketId = UUID.fromString(request.getParameter("id"));
        Tickets ticket = ticketDAO.getTicketById(ticketId);

        if (ticket != null) {
            // Check if user has permission to print this ticket
            HttpSession session = request.getSession(false);
            User user = (session != null) ? (User) session.getAttribute("user") : null;

            if (user != null && "USER".equals(user.getRole())) {
                // User can only print their own tickets
                if (!ticketDAO.isTicketOwnedByUser(ticketId, user.getUserId())) {
                    handleError(request, response, "Access denied. You can only print your own tickets.");
                    return;
                }
            }

            request.setAttribute("ticket", ticket);
            request
                    .getRequestDispatcher("/views/ticket-print.jsp")
                    .forward(request, response);
        } else {
            handleError(request, response, "Ticket not found");
        }
    }

    private void checkSeatAvailability(
            HttpServletRequest request,
            HttpServletResponse response) throws SQLException, IOException {
        int seatNumber = Integer.parseInt(request.getParameter("seatNumber"));
        UUID busId = UUID.fromString(request.getParameter("busId"));
        String departureDateStr = request.getParameter("departureDate");
        String departureTimeStr = request.getParameter("departureTime");

        try {
            LocalDate departureDate = LocalDate.parse(departureDateStr);
            LocalTime departureTime = LocalTime.parse(departureTimeStr);

            boolean isAvailable = ticketDAO.isSeatAvailable(busId,
                    seatNumber,
                    Date.valueOf(departureDate),
                    Time.valueOf(departureTime));

            response.setContentType("application/json");
            response.getWriter().write("{\"available\": " + isAvailable + "}");
        } catch (Exception e) {
            response.setContentType("application/json");
            response
                    .getWriter()
                    .write("{\"error\": \"Invalid date/time format\"}");
        }
    }

    private void addTicket(
            HttpServletRequest request,
            HttpServletResponse response) throws SQLException, IOException {
        // Check if user has permission to add tickets
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user != null && "USER".equals(user.getRole())) {
            // User cannot add tickets manually
            response.sendRedirect(
                    request.getContextPath()
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
        String ticketPriceStr = request.getParameter("ticketPrice");

        // Log all input parameters
        System.out.println("=== TICKET CREATION DEBUG ===");
        System.out.println("RouteId: " + routeIdStr);
        System.out.println("BusId: " + busIdStr);
        System.out.println("UserId: " + userIdStr);
        System.out.println("SeatNumber: " + seatNumberStr);
        System.out.println("DepartureDate: " + departureDateStr);
        System.out.println("DepartureTime: " + departureTimeStr);
        System.out.println("TicketPrice: " + ticketPriceStr);

        // Validate and parse parameters
        UUID routeId, busId, userId;
        int seatNumber;
        BigDecimal ticketPrice;
        LocalDate departureDate;
        LocalTime departureTime;

        try {
            routeId = UUID.fromString(routeIdStr);
            busId = UUID.fromString(busIdStr);
            userId = UUID.fromString(userIdStr);
            seatNumber = Integer.parseInt(seatNumberStr);
            ticketPrice = new BigDecimal(ticketPriceStr);
            departureDate = LocalDate.parse(departureDateStr);
            departureTime = LocalTime.parse(departureTimeStr);

            System.out.println("Parsed RouteId: " + routeId);
            System.out.println("Parsed BusId: " + busId);
            System.out.println("Parsed UserId: " + userId);
            System.out.println("Parsed SeatNumber: " + seatNumber);
            System.out.println("Parsed DepartureDate: " + departureDate);
            System.out.println("Parsed DepartureTime: " + departureTime);
            System.out.println("Parsed TicketPrice: " + ticketPrice);
        } catch (Exception e) {
            System.out.println("ERROR parsing parameters: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(
                    request.getContextPath()
                            + "/tickets/add?error=Invalid parameter format: " + e.getMessage());
            return;
        }

        // Find schedule ID based on route, bus, and departure date/time
        System.out.println("Looking for schedule with RouteId: " + routeId + ", BusId: " + busId +
                ", Date: " + departureDate + ", Time: " + departureTime);

        UUID scheduleId;
        try {
            scheduleId = routeDAO.findScheduleId(routeId, busId, departureDate, departureTime);
            System.out.println("Found ScheduleId: " + scheduleId);
        } catch (Exception e) {
            System.out.println("ERROR finding schedule: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(
                    request.getContextPath()
                            + "/tickets/add?error=Database error finding schedule: " + e.getMessage());
            return;
        }

        if (scheduleId == null) {
            System.out.println("Schedule not found for the specified parameters");
            response.sendRedirect(
                    request.getContextPath()
                            + "/tickets/add?error=Schedule not found for the specified date and time");
            return;
        }

        // Check seat availability
        System.out.println("Checking seat availability for ScheduleId: " + scheduleId + ", SeatNumber: " + seatNumber);
        boolean isSeatAvailable;
        try {
            isSeatAvailable = ticketDAO.isSeatAvailable(scheduleId, seatNumber);
            System.out.println("Seat available: " + isSeatAvailable);
        } catch (Exception e) {
            System.out.println("ERROR checking seat availability: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(
                    request.getContextPath()
                            + "/tickets/add?error=Database error checking seat availability: " + e.getMessage());
            return;
        }

        if (!isSeatAvailable) {
            System.out.println("Seat " + seatNumber + " is not available");
            response.sendRedirect(
                    request.getContextPath()
                            + "/tickets/add?error=Seat is not available");
            return;
        }

        // Generate ticket number
        String ticketNumber = ticketDAO.generateTicketNumber();
        System.out.println("Generated ticket number: " + ticketNumber);

        // Create new ticket
        Tickets ticket = new Tickets();
        ticket.setTicketNumber(ticketNumber);
        ticket.setScheduleId(scheduleId);
        ticket.setUserId(userId);
        ticket.setSeatNumber(seatNumber);
        ticket.setTicketPrice(ticketPrice);
        ticket.setStatus("CONFIRMED");
        ticket.setPaymentStatus("PENDING");

        System.out.println("Created ticket object:");
        System.out.println("- TicketNumber: " + ticket.getTicketNumber());
        System.out.println("- ScheduleId: " + ticket.getScheduleId());
        System.out.println("- UserId: " + ticket.getUserId());
        System.out.println("- SeatNumber: " + ticket.getSeatNumber());
        System.out.println("- TicketPrice: " + ticket.getTicketPrice());

        // Save to database
        boolean success;
        try {
            success = ticketDAO.addTicket(ticket);
            System.out.println("Ticket save result: " + success);
        } catch (Exception e) {
            System.out.println("ERROR saving ticket: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(
                    request.getContextPath()
                            + "/tickets/add?error=Database error saving ticket: " + e.getMessage());
            return;
        }

        if (success) {
            System.out.println("Ticket added successfully");
            response.sendRedirect(
                    request.getContextPath()
                            + "/tickets?message=Ticket added successfully");
        } else {
            System.out.println("Failed to add ticket");
            response.sendRedirect(
                    request.getContextPath()
                            + "/tickets/add?error=Failed to add ticket");
        }
        System.out.println("=== END TICKET CREATION DEBUG ===");
    }

    private void updateTicket(
            HttpServletRequest request,
            HttpServletResponse response) throws SQLException, IOException {
        // Check if user has permission to update tickets
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user != null && "USER".equals(user.getRole())) {
            // User cannot update tickets
            response.sendRedirect(
                    request.getContextPath()
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
        BigDecimal ticketPrice = new BigDecimal(
                request.getParameter("ticketPrice"));
        String status = request.getParameter("status");
        String paymentStatus = request.getParameter("paymentStatus");

        // Parse date and time
        LocalDate departureDate = LocalDate.parse(departureDateStr);
        LocalTime departureTime = LocalTime.parse(departureTimeStr);

        // Find schedule ID based on route, bus, and departure date/time
        UUID scheduleId = routeDAO.findScheduleId(routeId, busId, departureDate, departureTime);
        if (scheduleId == null) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/tickets/edit?id=" + ticketId
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
            response.sendRedirect(
                    request.getContextPath()
                            + "/tickets?message=Ticket updated successfully");
        } else {
            response.sendRedirect(
                    request.getContextPath()
                            + "/tickets/edit?id="
                            + ticketId
                            + "&error=Failed to update ticket");
        }
    }

    private void bookTicket(
            HttpServletRequest request,
            HttpServletResponse response) throws SQLException, IOException {
        // Check authentication
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(
                    request.getContextPath()
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
            response.sendRedirect(
                    request.getContextPath()
                            + "/tickets/book?error=Route ID is required for booking.");
            return;
        }

        if (busIdStr == null || busIdStr.trim().isEmpty()) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/tickets/book?error=Bus ID is required for booking.");
            return;
        }

        if (seatNumberStr == null || seatNumberStr.trim().isEmpty()) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/tickets/book?error=Seat number is required for booking.");
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
                    request.getContextPath()
                            + "/tickets/book?error=Invalid parameter format.");
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
                    request.getContextPath()
                            + "/tickets/book?error=Departure date is required");
            return;
        }

        if (departureTimeStr == null || departureTimeStr.trim().isEmpty()) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/tickets/book?error=Departure time is required");
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
                    request.getContextPath()
                            + "/tickets/book?error=Invalid date/time format");
            return;
        }

        // Find schedule ID based on route, bus, and departure date/time
        UUID scheduleId = routeDAO.findScheduleId(routeId, busId, departureDate, departureTime);
        if (scheduleId == null) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/tickets/book?error=Schedule not found for the specified date and time");
            return;
        }

        // Check seat availability
        boolean isSeatAvailable = ticketDAO.isSeatAvailable(scheduleId, seatNumber);

        if (!isSeatAvailable) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/tickets/book?error=Seat is not available");
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
                    request.getContextPath()
                            + "/tickets?message=Ticket booked successfully");
        } else {
            response.sendRedirect(
                    request.getContextPath()
                            + "/tickets/book?error=Failed to book ticket");
        }
    }

    private void deleteTicket(
            HttpServletRequest request,
            HttpServletResponse response) throws SQLException, IOException {
        UUID ticketId = UUID.fromString(request.getParameter("id"));

        // Check if user has permission to delete this ticket
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user != null && "USER".equals(user.getRole())) {
            // User can only cancel their own tickets
            if (!ticketDAO.isTicketOwnedByUser(ticketId, user.getUserId())) {
                response.sendRedirect(
                        request.getContextPath()
                                + "/tickets?error=Access denied. You can only cancel your own tickets.");
                return;
            }
        }

        boolean success = ticketDAO.deleteTicket(ticketId);

        if (success) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/tickets?message=Ticket cancelled successfully");
        } else {
            response.sendRedirect(
                    request.getContextPath()
                            + "/tickets?error=Failed to cancel ticket");
        }
    }

    private void getTicketById(
            HttpServletRequest request,
            HttpServletResponse response) throws SQLException, ServletException, IOException {
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
                    handleError(request, response, "Access denied. You can only view your own tickets.");
                    return;
                }
            }

            request.setAttribute("ticket", ticket);
            request
                    .getRequestDispatcher("/views/ticket-detail.jsp")
                    .forward(request, response);
        } else {
            handleError(request, response, "Ticket not found");
        }
    }

    private void handleError(
            HttpServletRequest request,
            HttpServletResponse response,
            String message) throws ServletException, IOException {
        request.setAttribute("error", message);
        request
                .getRequestDispatcher("/views/error.jsp")
                .forward(request, response);
    }
}
