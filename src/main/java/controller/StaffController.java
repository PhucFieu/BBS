package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

import dao.CityDAO;
import dao.RouteDAO;
import dao.RouteStationDAO;
import dao.ScheduleDAO;
import dao.TicketDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.City;
import model.Routes;
import model.Schedule;
import model.Station;
import model.Tickets;
import model.User;
import util.AuthUtils;

@WebServlet(urlPatterns = { "/staff/*" })
public class StaffController extends HttpServlet {
    private ScheduleDAO scheduleDAO;
    private RouteDAO routeDAO;
    private TicketDAO ticketDAO;
    private CityDAO cityDAO;
    private RouteStationDAO routeStationDAO;
    private final Gson gson = new Gson();

    @Override
    public void init() throws ServletException {
        scheduleDAO = new ScheduleDAO();
        routeDAO = new RouteDAO();
        ticketDAO = new TicketDAO();
        cityDAO = new CityDAO();
        routeStationDAO = new RouteStationDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is staff or admin
        if (!AuthUtils.isStaff(request.getSession(false))
                && !AuthUtils.isAdmin(request.getSession(false))) {
            request.setAttribute("error", "You do not have permission to access this page");
            request.getRequestDispatcher("/views/errors/403.jsp").forward(request, response);
            return;
        }

        String pathInfo = request.getPathInfo();
        if (pathInfo == null)
            pathInfo = "/";

        try {
            switch (pathInfo) {
                case "/":
                case "/dashboard":
                    showDashboard(request, response);
                    break;
                case "/search-schedules":
                    showSearchSchedules(request, response);
                    break;
                case "/tickets":
                    showTicketLookup(request, response);
                    break;
                case "/ticket-detail":
                    showTicketDetail(request, response);
                    break;
                case "/book":
                    showBookingForm(request, response);
                    break;
                case "/daily-trips":
                    showDailyTrips(request, response);
                    break;
                case "/passenger-list":
                    showPassengerList(request, response);
                    break;
                case "/check-in":
                    showCheckIn(request, response);
                    break;
                case "/edit-ticket":
                    showEditTicket(request, response);
                    break;
                case "/api/schedules":
                    apiSearchSchedules(request, response);
                    break;
                case "/api/stations":
                    apiGetStations(request, response);
                    break;
                case "/api/passengers":
                    apiGetPassengers(request, response);
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
        // Check if user is staff or admin
        if (!AuthUtils.isStaff(request.getSession(false))
                && !AuthUtils.isAdmin(request.getSession(false))) {
            request.setAttribute("error", "You do not have permission to access this page");
            request.getRequestDispatcher("/views/errors/403.jsp").forward(request, response);
            return;
        }

        String pathInfo = request.getPathInfo();
        if (pathInfo == null)
            pathInfo = "/";

        try {
            switch (pathInfo) {
                case "/search-schedules":
                    searchSchedules(request, response);
                    break;
                case "/book":
                    createTicket(request, response);
                    break;
                case "/cancel-ticket":
                    cancelTicket(request, response);
                    break;
                case "/check-in":
                    performCheckIn(request, response);
                    break;
                case "/update-ticket":
                    updateTicket(request, response);
                    break;
                case "/mark-paid":
                    markTicketPaid(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            handleError(request, response, "Database error: " + e.getMessage());
        }
    }

    // ========== UC-ST1: Dashboard ==========
    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        // Get today's schedules
        List<Schedule> todaySchedules = scheduleDAO.getSchedulesByDate(LocalDate.now());
        request.setAttribute("todaySchedules", todaySchedules);

        // Get recent tickets
        List<Tickets> recentTickets = ticketDAO.getRecentTickets(10);
        request.setAttribute("recentTickets", recentTickets);

        // Get statistics
        request.setAttribute("totalSchedulesToday", todaySchedules.size());
        request.setAttribute("totalTickets", ticketDAO.getTotalTickets());

        request.getRequestDispatcher("/views/staff/dashboard.jsp").forward(request, response);
    }

    // ========== UC-ST1: Search Schedules for Customer ==========
    private void showSearchSchedules(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        // Load cities for dropdown
        request.setAttribute("cities", cityDAO.getAllCities());
        request.setAttribute("routes", routeDAO.getAllRoutes());

        // Default to today's schedules if no search performed
        String dateStr = request.getParameter("departureDate");
        LocalDate date = (dateStr != null && !dateStr.isEmpty()) ? LocalDate.parse(dateStr)
                : LocalDate.now();
        List<Schedule> schedules = scheduleDAO.getSchedulesByDate(date);

        request.setAttribute("schedules", schedules);
        request.setAttribute("departureDate", date.toString());

        request.getRequestDispatcher("/views/staff/search-schedules.jsp").forward(request,
                response);
    }

    private void searchSchedules(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        String departureCityIdStr = request.getParameter("departureCityId");
        String destinationCityIdStr = request.getParameter("destinationCityId");
        String dateStr = request.getParameter("departureDate");

        List<Schedule> schedules = new ArrayList<>();

        if (dateStr != null && !dateStr.trim().isEmpty()) {
            LocalDate date = LocalDate.parse(dateStr);

            if (departureCityIdStr != null && !departureCityIdStr.isEmpty() &&
                    destinationCityIdStr != null && !destinationCityIdStr.isEmpty()) {
                // Get city names for search
                City depCity = cityDAO.getCityById(UUID.fromString(departureCityIdStr));
                City destCity = cityDAO.getCityById(UUID.fromString(destinationCityIdStr));
                if (depCity != null && destCity != null) {
                    schedules = scheduleDAO.searchSchedules(depCity.getCityName(),
                            destCity.getCityName(), date);
                }
            } else {
                schedules = scheduleDAO.getSchedulesByDate(date);
            }
        }

        request.setAttribute("schedules", schedules);
        request.setAttribute("cities", cityDAO.getAllCities());
        request.setAttribute("routes", routeDAO.getAllRoutes());
        request.setAttribute("departureCityId", departureCityIdStr);
        request.setAttribute("destinationCityId", destinationCityIdStr);
        request.setAttribute("departureDate", dateStr);

        request.getRequestDispatcher("/views/staff/search-schedules.jsp").forward(request,
                response);
    }

    private void apiSearchSchedules(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        JsonObject result = new JsonObject();

        String dateStr = request.getParameter("date");
        String routeIdStr = request.getParameter("routeId");

        try (PrintWriter writer = response.getWriter()) {
            if (dateStr == null || dateStr.trim().isEmpty()) {
                result.addProperty("success", false);
                result.addProperty("message", "Date is required");
                writer.write(gson.toJson(result));
                return;
            }

            LocalDate date = LocalDate.parse(dateStr);
            List<Schedule> schedules;

            if (routeIdStr != null && !routeIdStr.isEmpty()) {
                schedules = scheduleDAO.getSchedulesByRouteAndDate(UUID.fromString(routeIdStr), date);
            } else {
                schedules = scheduleDAO.getSchedulesByDate(date);
            }

            JsonArray schedulesArray = new JsonArray();
            for (Schedule s : schedules) {
                JsonObject obj = new JsonObject();
                obj.addProperty("scheduleId", s.getScheduleId().toString());
                obj.addProperty("routeName", s.getRouteName());
                obj.addProperty("departureCity", s.getDepartureCity());
                obj.addProperty("destinationCity", s.getDestinationCity());
                obj.addProperty("busNumber", s.getBusNumber());
                obj.addProperty("departureTime", s.getDepartureTime().toString());
                obj.addProperty("estimatedArrivalTime", s.getEstimatedArrivalTime().toString());
                obj.addProperty("availableSeats", s.getAvailableSeats());
                obj.addProperty("status", s.getStatus());
                schedulesArray.add(obj);
            }

            result.addProperty("success", true);
            result.add("schedules", schedulesArray);
            writer.write(gson.toJson(result));
        }
    }

    // ========== UC-ST2: Create Ticket on Behalf of Customer ==========
    private void showBookingForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        String scheduleIdStr = request.getParameter("scheduleId");

        if (scheduleIdStr == null || scheduleIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/staff/search-schedules?error=" +
                    encodeParam("Please select a schedule first"));
            return;
        }

        UUID scheduleId = UUID.fromString(scheduleIdStr);
        Schedule schedule = scheduleDAO.getScheduleById(scheduleId);

        if (schedule == null) {
            response.sendRedirect(request.getContextPath() + "/staff/search-schedules?error=" +
                    encodeParam("Schedule not found"));
            return;
        }

        // Get route details
        Routes route = routeDAO.getRouteById(schedule.getRouteId());

        // Get booked seats
        List<Integer> bookedSeats = ticketDAO.getBookedSeats(scheduleId);

        // Get stations for this route
        List<Station> stations = routeStationDAO.getStationsByRouteAsStations(schedule.getRouteId());

        request.setAttribute("schedule", schedule);
        request.setAttribute("route", route);
        request.setAttribute("bookedSeats", bookedSeats);
        request.setAttribute("stations", stations);

        request.getRequestDispatcher("/views/staff/booking-form.jsp").forward(request, response);
    }

    private void createTicket(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = AuthUtils.getCurrentUser(session);

        String scheduleIdStr = request.getParameter("scheduleId");
        String seatNumberStr = request.getParameter("seatNumber");
        String customerName = request.getParameter("customerName");
        String customerPhone = request.getParameter("customerPhone");
        String customerEmail = request.getParameter("customerEmail");
        String notes = request.getParameter("notes");
        String boardingStationIdStr = request.getParameter("boardingStationId");
        String alightingStationIdStr = request.getParameter("alightingStationId");
        String paymentStatus = request.getParameter("paymentStatus"); // PAID or UNPAID

        // Validation
        if (scheduleIdStr == null || seatNumberStr == null || customerName == null
                || customerPhone == null) {
            response.sendRedirect(
                    request.getContextPath() + "/staff/book?scheduleId=" + scheduleIdStr +
                            "&error=" + encodeParam("Missing required information"));
            return;
        }

        try {
            UUID scheduleId = UUID.fromString(scheduleIdStr);
            int seatNumber = Integer.parseInt(seatNumberStr);

            // Normalize contact info
            customerPhone = customerPhone != null ? customerPhone.trim() : "";
            customerEmail = customerEmail != null ? customerEmail.trim() : "";

            // Check seat availability
            if (!ticketDAO.isSeatAvailable(scheduleId, seatNumber)) {
                response.sendRedirect(request.getContextPath() + "/staff/book?scheduleId="
                        + scheduleIdStr +
                        "&error=" + encodeParam("Seat " + seatNumber + " is already booked"));
                return;
            }

            // Prevent duplicate passenger contact on the same schedule
            if (ticketDAO.hasContactConflict(scheduleId, customerPhone, customerEmail)) {
                response.sendRedirect(request.getContextPath() + "/staff/book?scheduleId="
                        + scheduleIdStr +
                        "&error=" + encodeParam("Phone or email is already used for this trip"));
                return;
            }

            Schedule schedule = scheduleDAO.getScheduleById(scheduleId);
            Routes route = routeDAO.getRouteById(schedule.getRouteId());

            // Create ticket
            Tickets ticket = new Tickets();
            ticket.setTicketNumber(ticketDAO.generateTicketNumber());
            ticket.setScheduleId(scheduleId);
            ticket.setUserId(currentUser.getUserId()); // Staff creates ticket
            ticket.setSeatNumber(seatNumber);
            ticket.setTicketPrice(route.getBasePrice());
            ticket.setStatus("CONFIRMED");
            ticket.setPaymentStatus(
                    paymentStatus != null && paymentStatus.equals("PAID") ? "PAID" : "PENDING");
            ticket.setCustomerName(customerName);
            ticket.setCustomerPhone(customerPhone);
            ticket.setCustomerEmail(customerEmail);
            ticket.setNotes(notes);
            ticket.setCreatedByStaffId(currentUser.getUserId());

            // Set boarding and alighting stations
            if (boardingStationIdStr != null && !boardingStationIdStr.isEmpty()) {
                ticket.setBoardingStationId(UUID.fromString(boardingStationIdStr));
            } else if (route.getDepartureStationId() != null) {
                ticket.setBoardingStationId(route.getDepartureStationId());
            }
            if (alightingStationIdStr != null && !alightingStationIdStr.isEmpty()) {
                ticket.setAlightingStationId(UUID.fromString(alightingStationIdStr));
            } else if (route.getDestinationStationId() != null) {
                ticket.setAlightingStationId(route.getDestinationStationId());
            }

            boolean success = ticketDAO.addTicket(ticket);

            if (success) {
                // Update available seats
                scheduleDAO.updateAvailableSeats(scheduleId, 1);

                response.sendRedirect(request.getContextPath() + "/staff/ticket-detail?id=" +
                        ticket.getTicketId() + "&message="
                        + encodeParam("Ticket created successfully!"));
            } else {
                response.sendRedirect(
                        request.getContextPath() + "/staff/book?scheduleId=" + scheduleIdStr +
                                "&error=" + encodeParam("Failed to create ticket"));
            }
        } catch (Exception e) {
            response.sendRedirect(
                    request.getContextPath() + "/staff/book?scheduleId=" + scheduleIdStr +
                            "&error=" + encodeParam("Error: " + e.getMessage()));
        }
    }

    // ========== UC-ST3: View & Lookup Ticket ==========
    private void showTicketLookup(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        String searchTerm = request.getParameter("search");
        String dateStr = request.getParameter("date");

        List<Tickets> tickets = new ArrayList<>();

        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            // Search by ticket number, phone, or name
            tickets = ticketDAO.searchTickets(searchTerm, null, null, null, null, null, null);
        } else if (dateStr != null && !dateStr.trim().isEmpty()) {
            java.sql.Date date = java.sql.Date.valueOf(dateStr);
            tickets = ticketDAO.getTicketsByDate(date);
        }

        request.setAttribute("tickets", tickets);
        request.setAttribute("searchTerm", searchTerm);
        request.setAttribute("searchDate", dateStr);

        request.getRequestDispatcher("/views/staff/ticket-lookup.jsp").forward(request, response);
    }

    private void showTicketDetail(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        String ticketIdStr = request.getParameter("id");

        if (ticketIdStr == null || ticketIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/staff/tickets?error=" +
                    encodeParam("Ticket ID is required"));
            return;
        }

        Tickets ticket = ticketDAO.getTicketById(UUID.fromString(ticketIdStr));

        if (ticket == null) {
            response.sendRedirect(request.getContextPath() + "/staff/tickets?error=" +
                    encodeParam("Ticket not found"));
            return;
        }

        request.setAttribute("ticket", ticket);
        request.getRequestDispatcher("/views/staff/ticket-detail.jsp").forward(request, response);
    }

    // ========== UC-ST4: Modify Existing Ticket ==========
    private void showEditTicket(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        String ticketIdStr = request.getParameter("id");

        if (ticketIdStr == null || ticketIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/staff/tickets?error=" +
                    encodeParam("Ticket ID is required"));
            return;
        }

        Tickets ticket = ticketDAO.getTicketById(UUID.fromString(ticketIdStr));

        if (ticket == null) {
            response.sendRedirect(request.getContextPath() + "/staff/tickets?error=" +
                    encodeParam("Ticket not found"));
            return;
        }

        Schedule schedule = scheduleDAO.getScheduleById(ticket.getScheduleId());
        List<Station> stations = routeStationDAO.getStationsByRouteAsStations(schedule.getRouteId());
        List<Integer> bookedSeats = ticketDAO.getBookedSeats(ticket.getScheduleId());

        request.setAttribute("ticket", ticket);
        request.setAttribute("schedule", schedule);
        request.setAttribute("stations", stations);
        request.setAttribute("bookedSeats", bookedSeats);

        request.getRequestDispatcher("/views/staff/ticket-edit.jsp").forward(request, response);
    }

    private void updateTicket(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String ticketIdStr = request.getParameter("ticketId");
        String seatNumberStr = request.getParameter("seatNumber");
        String boardingStationIdStr = request.getParameter("boardingStationId");
        String alightingStationIdStr = request.getParameter("alightingStationId");
        String customerName = request.getParameter("customerName");
        String customerPhone = request.getParameter("customerPhone");
        String notes = request.getParameter("notes");

        if (ticketIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/staff/tickets?error=" +
                    encodeParam("Ticket ID is required"));
            return;
        }

        try {
            UUID ticketId = UUID.fromString(ticketIdStr);
            Tickets ticket = ticketDAO.getTicketById(ticketId);

            if (ticket == null) {
                response.sendRedirect(request.getContextPath() + "/staff/tickets?error=" +
                        encodeParam("Ticket not found"));
                return;
            }

            // Check if can be modified
            if ("CANCELLED".equals(ticket.getStatus()) || ticket.getCheckedInAt() != null) {
                response.sendRedirect(request.getContextPath() + "/staff/ticket-detail?id="
                        + ticketIdStr +
                        "&error="
                        + encodeParam("Cannot modify this ticket - status: " + ticket.getStatus()));
                return;
            }

            // Update seat if changed
            if (seatNumberStr != null && !seatNumberStr.isEmpty()) {
                int newSeatNumber = Integer.parseInt(seatNumberStr);
                if (newSeatNumber != ticket.getSeatNumber()) {
                    // Check if new seat is available
                    if (!ticketDAO.isSeatAvailableForUpdate(ticket.getScheduleId(), newSeatNumber,
                            ticketId)) {
                        response.sendRedirect(request.getContextPath() + "/staff/edit-ticket?id="
                                + ticketIdStr +
                                "&error="
                                + encodeParam("Seat " + newSeatNumber + " is already booked"));
                        return;
                    }
                    ticket.setSeatNumber(newSeatNumber);
                }
            }

            // Update stations
            if (boardingStationIdStr != null && !boardingStationIdStr.isEmpty()) {
                ticket.setBoardingStationId(UUID.fromString(boardingStationIdStr));
            }
            if (alightingStationIdStr != null && !alightingStationIdStr.isEmpty()) {
                ticket.setAlightingStationId(UUID.fromString(alightingStationIdStr));
            }

            // Update customer info
            if (customerName != null)
                ticket.setCustomerName(customerName);
            if (customerPhone != null)
                ticket.setCustomerPhone(customerPhone);
            if (notes != null)
                ticket.setNotes(notes);

            boolean success = ticketDAO.updateTicket(ticket);

            if (success) {
                response.sendRedirect(
                        request.getContextPath() + "/staff/ticket-detail?id=" + ticketIdStr +
                                "&message=" + encodeParam("Ticket updated successfully"));
            } else {
                response.sendRedirect(
                        request.getContextPath() + "/staff/edit-ticket?id=" + ticketIdStr +
                                "&error=" + encodeParam("Failed to update ticket"));
            }
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/staff/tickets?error=" +
                    encodeParam("Error: " + e.getMessage()));
        }
    }

    // ========== UC-ST5: Cancel Ticket ==========
    private void cancelTicket(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String ticketIdStr = request.getParameter("ticketId");

        if (ticketIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/staff/tickets?error=" +
                    encodeParam("Ticket ID is required"));
            return;
        }

        try {
            UUID ticketId = UUID.fromString(ticketIdStr);
            Tickets ticket = ticketDAO.getTicketById(ticketId);

            if (ticket == null) {
                response.sendRedirect(request.getContextPath() + "/staff/tickets?error=" +
                        encodeParam("Ticket not found"));
                return;
            }

            // Check if can be cancelled
            if ("CANCELLED".equals(ticket.getStatus()) || ticket.getCheckedInAt() != null) {
                response.sendRedirect(request.getContextPath() + "/staff/ticket-detail?id="
                        + ticketIdStr +
                        "&error="
                        + encodeParam("Cannot cancel this ticket - status: " + ticket.getStatus()));
                return;
            }

            boolean success = ticketDAO.deleteTicket(ticketId);

            if (success) {
                // Return seat to schedule
                // Note: In real app, we might need to add seats back to available_seats
                response.sendRedirect(request.getContextPath() + "/staff/tickets?message=" +
                        encodeParam("Ticket " + ticket.getTicketNumber() + " has been cancelled"));
            } else {
                response.sendRedirect(
                        request.getContextPath() + "/staff/ticket-detail?id=" + ticketIdStr +
                                "&error=" + encodeParam("Failed to cancel ticket"));
            }
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/staff/tickets?error=" +
                    encodeParam("Error: " + e.getMessage()));
        }
    }

    // ========== UC-ST6: Check-in Passenger ==========
    private void showCheckIn(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        // Get date parameter, default to today
        String dateStr = request.getParameter("date");
        LocalDate date = (dateStr != null && !dateStr.isEmpty()) ? LocalDate.parse(dateStr)
                : LocalDate.now();

        // Get all checked-in tickets for the selected date
        java.sql.Date sqlDate = java.sql.Date.valueOf(date);
        List<Tickets> checkedInTickets = ticketDAO.getCheckedInTicketsByDate(sqlDate);

        request.setAttribute("checkedInTickets", checkedInTickets);
        request.setAttribute("selectedDate", date.toString());
        request.setAttribute("totalCheckedIn", checkedInTickets.size());

        request.getRequestDispatcher("/views/staff/check-in.jsp").forward(request, response);
    }

    private void performCheckIn(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = AuthUtils.getCurrentUser(session);

        String ticketIdStr = request.getParameter("ticketId");
        String scheduleIdStr = request.getParameter("scheduleId");
        String redirectTo = request.getParameter("redirectTo");

        // Default redirect URL
        String defaultRedirect = request.getContextPath() + "/staff/search-schedules";
        if (redirectTo != null && !redirectTo.isEmpty()) {
            defaultRedirect = redirectTo;
        } else if (scheduleIdStr != null) {
            defaultRedirect = request.getContextPath() + "/staff/passenger-list?scheduleId=" + scheduleIdStr;
        }

        if (ticketIdStr == null) {
            response.sendRedirect(defaultRedirect + (defaultRedirect.contains("?") ? "&" : "?") +
                    "error=" + encodeParam("Ticket ID is required"));
            return;
        }

        try {
            UUID ticketId = UUID.fromString(ticketIdStr);
            Tickets ticket = ticketDAO.getTicketById(ticketId);

            if (ticket == null) {
                response.sendRedirect(
                        defaultRedirect + (defaultRedirect.contains("?") ? "&" : "?") +
                                "error=" + encodeParam("Ticket not found"));
                return;
            }

            if (ticket.getCheckedInAt() != null) {
                response.sendRedirect(defaultRedirect + (defaultRedirect.contains("?") ? "&" : "?") +
                        "message=" + encodeParam("Passenger already checked in"));
                return;
            }

            // Check payment status
            if (!"PAID".equals(ticket.getPaymentStatus())) {
                response.sendRedirect(
                        defaultRedirect + (defaultRedirect.contains("?") ? "&" : "?") +
                                "warning="
                                + encodeParam("Ticket is not paid. Please collect payment first."));
                return;
            }

            if ("CANCELLED".equals(ticket.getStatus())) {
                response.sendRedirect(defaultRedirect + (defaultRedirect.contains("?") ? "&" : "?") +
                        "error=" + encodeParam("Cannot check in a cancelled ticket"));
                return;
            }

            // Prevent check-in after the schedule's estimated arrival time
            Schedule schedule = scheduleDAO.getScheduleById(ticket.getScheduleId());
            if (schedule != null && schedule.getDepartureDate() != null
                    && schedule.getEstimatedArrivalTime() != null) {
                LocalDateTime arrivalDateTime = LocalDateTime.of(schedule.getDepartureDate(),
                        schedule.getEstimatedArrivalTime());
                if (LocalDateTime.now().isAfter(arrivalDateTime)) {
                    response.sendRedirect(defaultRedirect + (defaultRedirect.contains("?") ? "&" : "?") +
                            "error=" + encodeParam("Cannot check in after the scheduled arrival time"));
                    return;
                }
            }

            // Keep status confirmed after check-in but record check-in metadata
            ticket.setStatus("CONFIRMED");
            ticket.setCheckedInAt(LocalDateTime.now());
            ticket.setCheckedInByStaffId(currentUser.getUserId());

            boolean success = ticketDAO.updateTicket(ticket);

            if (success) {
                response.sendRedirect(
                        defaultRedirect + (defaultRedirect.contains("?") ? "&" : "?") +
                                "message=" + encodeParam("Passenger checked in successfully"));
            } else {
                response.sendRedirect(
                        defaultRedirect + (defaultRedirect.contains("?") ? "&" : "?") +
                                "error=" + encodeParam("Failed to check in passenger"));
            }
        } catch (Exception e) {
            response.sendRedirect(defaultRedirect + (defaultRedirect.contains("?") ? "&" : "?") +
                    "error=" + encodeParam("Error: " + e.getMessage()));
        }
    }

    // ========== UC-ST7: View Passenger List ==========
    private void showDailyTrips(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        String dateStr = request.getParameter("date");
        LocalDate date = dateStr != null && !dateStr.isEmpty() ? LocalDate.parse(dateStr) : LocalDate.now();

        List<Schedule> schedules = scheduleDAO.getSchedulesByDate(date);

        request.setAttribute("schedules", schedules);
        request.setAttribute("selectedDate", date.toString());

        request.getRequestDispatcher("/views/staff/daily-trips.jsp").forward(request, response);
    }

    private void showPassengerList(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        String scheduleIdStr = request.getParameter("scheduleId");

        if (scheduleIdStr == null || scheduleIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/staff/daily-trips?error=" +
                    encodeParam("Please select a schedule"));
            return;
        }

        UUID scheduleId = UUID.fromString(scheduleIdStr);
        Schedule schedule = scheduleDAO.getScheduleById(scheduleId);
        List<Tickets> tickets = ticketDAO.getTicketsByScheduleId(scheduleId);

        // Count statistics (excluding cancelled tickets from active count)
        int totalPassengers = 0;
        int checkedIn = 0;
        int notCheckedIn = 0;
        int cancelled = 0;

        for (Tickets t : tickets) {
            if ("CANCELLED".equals(t.getStatus())) {
                cancelled++;
            } else {
                totalPassengers++;
                if (t.getCheckedInAt() != null) {
                    checkedIn++;
                } else {
                    notCheckedIn++;
                }
            }
        }

        request.setAttribute("schedule", schedule);
        request.setAttribute("tickets", tickets);
        request.setAttribute("totalPassengers", totalPassengers);
        request.setAttribute("checkedIn", checkedIn);
        request.setAttribute("notCheckedIn", notCheckedIn);
        request.setAttribute("cancelled", cancelled);

        request.getRequestDispatcher("/views/staff/passenger-list.jsp").forward(request, response);
    }

    // ========== UC-ST8: Mark Ticket as Paid ==========
    private void markTicketPaid(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String ticketIdStr = request.getParameter("ticketId");
        String redirectTo = request.getParameter("redirectTo");

        if (ticketIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/staff/tickets?error=" +
                    encodeParam("Ticket ID is required"));
            return;
        }

        try {
            UUID ticketId = UUID.fromString(ticketIdStr);
            Tickets ticket = ticketDAO.getTicketById(ticketId);

            if (ticket == null) {
                response.sendRedirect(request.getContextPath() + "/staff/tickets?error=" +
                        encodeParam("Ticket not found"));
                return;
            }

            ticket.setPaymentStatus("PAID");
            boolean success = ticketDAO.updateTicket(ticket);

            String redirect = redirectTo != null ? redirectTo
                    : request.getContextPath() + "/staff/ticket-detail?id=" + ticketIdStr;

            if (success) {
                response.sendRedirect(redirect + (redirect.contains("?") ? "&" : "?") +
                        "message=" + encodeParam("Payment recorded successfully"));
            } else {
                response.sendRedirect(redirect + (redirect.contains("?") ? "&" : "?") +
                        "error=" + encodeParam("Failed to record payment"));
            }
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/staff/tickets?error=" +
                    encodeParam("Error: " + e.getMessage()));
        }
    }

    // API endpoint to get stations for a route
    private void apiGetStations(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        JsonObject result = new JsonObject();

        String routeIdStr = request.getParameter("routeId");

        try (PrintWriter writer = response.getWriter()) {
            if (routeIdStr == null || routeIdStr.trim().isEmpty()) {
                result.addProperty("success", false);
                result.addProperty("message", "Route ID is required");
                writer.write(gson.toJson(result));
                return;
            }

            UUID routeId = UUID.fromString(routeIdStr);
            List<Station> stations = routeStationDAO.getStationsByRouteAsStations(routeId);
            Routes route = routeDAO.getRouteById(routeId);

            JsonArray stationsArray = new JsonArray();
            for (Station s : stations) {
                JsonObject obj = new JsonObject();
                obj.addProperty("stationId", s.getStationId().toString());
                obj.addProperty("stationName", s.getStationName());
                obj.addProperty("city", s.getCity());
                stationsArray.add(obj);
            }

            result.addProperty("success", true);
            result.add("stations", stationsArray);
            if (route != null) {
                if (route.getDepartureStationId() != null) {
                    result.addProperty("defaultBoardingStationId",
                            route.getDepartureStationId().toString());
                }
                if (route.getDestinationStationId() != null) {
                    result.addProperty("defaultAlightingStationId",
                            route.getDestinationStationId().toString());
                }
            }
            writer.write(gson.toJson(result));
        }
    }

    // API endpoint to get passengers for a schedule
    private void apiGetPassengers(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        JsonObject result = new JsonObject();

        String scheduleIdStr = request.getParameter("scheduleId");

        try (PrintWriter writer = response.getWriter()) {
            if (scheduleIdStr == null || scheduleIdStr.trim().isEmpty()) {
                result.addProperty("success", false);
                result.addProperty("message", "Schedule ID is required");
                writer.write(gson.toJson(result));
                return;
            }

            UUID scheduleId = UUID.fromString(scheduleIdStr);
            List<Tickets> tickets = ticketDAO.getTicketsByScheduleId(scheduleId);

            // Count statistics
            int totalActive = 0;
            int checkedIn = 0;
            int cancelled = 0;

            JsonArray passengersArray = new JsonArray();
            for (Tickets t : tickets) {
                boolean isCheckedIn = t.getCheckedInAt() != null;

                JsonObject obj = new JsonObject();
                obj.addProperty("ticketId", t.getTicketId().toString());
                obj.addProperty("ticketNumber", t.getTicketNumber());
                obj.addProperty("seatNumber", t.getSeatNumber());
                obj.addProperty("customerName",
                        t.getCustomerName() != null ? t.getCustomerName() : t.getUserName());
                obj.addProperty("customerPhone",
                        t.getCustomerPhone() != null ? t.getCustomerPhone() : "");
                obj.addProperty("status", t.getStatus());
                obj.addProperty("paymentStatus", t.getPaymentStatus());
                obj.addProperty("boardingStation",
                        t.getBoardingStationName() != null ? t.getBoardingStationName() : "");
                obj.addProperty("alightingStation",
                        t.getAlightingStationName() != null ? t.getAlightingStationName() : "");
                obj.addProperty("checkedIn", isCheckedIn);
                if (isCheckedIn && t.getCheckedInAt() != null) {
                    obj.addProperty("checkedInAt", t.getCheckedInAt().toString());
                }
                passengersArray.add(obj);

                if ("CANCELLED".equals(t.getStatus())) {
                    cancelled++;
                } else {
                    totalActive++;
                    if (isCheckedIn) {
                        checkedIn++;
                    }
                }
            }

            result.addProperty("success", true);
            result.add("passengers", passengersArray);
            result.addProperty("totalActive", totalActive);
            result.addProperty("checkedIn", checkedIn);
            result.addProperty("pending", totalActive - checkedIn);
            result.addProperty("cancelled", cancelled);
            writer.write(gson.toJson(result));
        } catch (Exception e) {
            try (PrintWriter writer = response.getWriter()) {
                result.addProperty("success", false);
                result.addProperty("message", "Error: " + e.getMessage());
                writer.write(gson.toJson(result));
            }
        }
    }

    private void handleError(HttpServletRequest request, HttpServletResponse response,
            String message)
            throws ServletException, IOException {
        request.setAttribute("error", message);
        request.getRequestDispatcher("/views/errors/error.jsp").forward(request, response);
    }

    private String encodeParam(String value) {
        return URLEncoder.encode(value == null ? "" : value, StandardCharsets.UTF_8);
    }
}
