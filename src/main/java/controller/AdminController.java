package controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import java.util.UUID;

import dao.BusDAO;
import dao.RoutesDAO;
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
import model.Tickets;
import model.User;
/**
 *
 * @author PhúcNH CE190359
 */
@WebServlet("/admin/*")
public class AdminController extends HttpServlet {
    private UserDAO userDAO;
    private RoutesDAO routeDAO;
    private BusDAO busDAO;
    private TicketDAO ticketDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        routeDAO = new RoutesDAO();
        busDAO = new BusDAO();
        ticketDAO = new TicketDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check admin authentication
        if (!isAdminAuthenticated(request)) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        String pathInfo = request.getPathInfo();

        try {
            if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("")) {
                // Admin dashboard
                showDashboard(request, response);
            } else if (pathInfo.equals("/dashboard")) {
                // Admin dashboard
                showDashboard(request, response);
            } else if (pathInfo.equals("/users")) {
                // User management
                showUsers(request, response);
            } else if (pathInfo.equals("/user/edit")) {
                // Edit user form
                showEditUserForm(request, response);
            } else if (pathInfo.equals("/user/delete")) {
                // Delete user
                deleteUser(request, response);
            } else if (pathInfo.equals("/user/add")) {
                // Add user form
                showAddUserForm(request, response);
            } else if (pathInfo.equals("/tickets")) {
                // Ticket management
                showTickets(request, response);
            } else if (pathInfo.equals("/tickets/add")) {
                // Show admin ticket form
                showAdminTicketForm(request, response);
            } else if (pathInfo.equals("/statistics")) {
                // System statistics
                showStatistics(request, response);
            } else if (pathInfo.equals("/reports")) {
                // Reports
                showReports(request, response);
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
        // Check admin authentication
        if (!isAdminAuthenticated(request)) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        String pathInfo = request.getPathInfo();

        try {
            if (pathInfo.equals("/user/update")) {
                // Update user
                updateUser(request, response);
            } else if (pathInfo.equals("/user/add")) {
                // Add new user
                addUser(request, response);
            } else if (pathInfo.equals("/tickets/add")) {
                // Add new ticket via admin
                addAdminTicket(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            handleError(request, response, "Database error: " + e.getMessage());
        }
    }

    private boolean isAdminAuthenticated(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            return false;
        }

        User user = (User) session.getAttribute("user");
        return "ADMIN".equals(user.getRole());
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        // Get dashboard statistics
        int totalUsers = userDAO.getTotalUsers();
        int totalRoutes = routeDAO.getTotalRoutes();
        int totalBuses = busDAO.getTotalBuses();
        int totalTickets = ticketDAO.getTotalTickets();
        int totalPassengers = userDAO.getTotalUsers();

        // Get recent activities
        List<User> recentUsers = userDAO.getRecentUsers(5);
        List<Tickets> recentTickets = ticketDAO.getRecentTickets(5);

        // Set attributes
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("totalRoutes", totalRoutes);
        request.setAttribute("totalBuses", totalBuses);
        request.setAttribute("totalTickets", totalTickets);
        request.setAttribute("totalPassengers", totalPassengers);
        request.setAttribute("recentUsers", recentUsers);
        request.setAttribute("recentTickets", recentTickets);

        request.getRequestDispatcher("/views/admin/dashboard.jsp").forward(request, response);
    }

    private void showUsers(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        String searchTerm = request.getParameter("search");
        String roleFilter = request.getParameter("role");

        List<User> users;
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            users = userDAO.searchUsers(searchTerm);
        } else if (roleFilter != null && !roleFilter.trim().isEmpty()) {
            users = userDAO.getUsersByRole(roleFilter);
        } else {
            users = userDAO.getAllUsers();
        }

        request.setAttribute("users", users);
        request.setAttribute("searchTerm", searchTerm);
        request.setAttribute("roleFilter", roleFilter);

        request.getRequestDispatcher("/views/admin/users.jsp").forward(request, response);
    }

    private void showAddUserForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Forward to the dedicated add user form
        request.getRequestDispatcher("/views/admin/add-user-form.jsp").forward(request, response);
    }

    private void showEditUserForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        String userIdStr = request.getParameter("id");
        if (userIdStr == null || userIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/users?error=User ID is required");
            return;
        }

        try {
            UUID userId = UUID.fromString(userIdStr);
            User user = userDAO.getUserById(userId);

            if (user != null) {
                request.setAttribute("user", user);
                request.getRequestDispatcher("/views/admin/user-form.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/users?error=User not found");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/users?error=Invalid user ID");
        }
    }

    private void updateUser(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String userIdStr = request.getParameter("userId");
        String username = request.getParameter("username");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String role = request.getParameter("role");
        String status = request.getParameter("status");

        // Validate input
        if (userIdStr == null || username == null || fullName == null || email == null || role == null) {
            response.sendRedirect(request.getContextPath() + "/admin/users?error=All fields are required");
            return;
        }

        try {

            UUID userId = UUID.fromString(userIdStr);
            // Get existing user
            User existingUser = userDAO.getUserById(userId);
            if (existingUser == null) {
                response.sendRedirect(request.getContextPath() + "/admin/users?error=User not found");
                return;
            }

            // Update user
            existingUser.setUsername(username);
            existingUser.setFullName(fullName);
            existingUser.setEmail(email);
            existingUser.setRole(role);
            existingUser.setStatus(status);

            boolean success = userDAO.updateUser(existingUser);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/users?message=User updated successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/users?error=Failed to update user");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/users?error=Invalid user ID");
        }
    }

    private void addUser(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phoneNumber = request.getParameter("phoneNumber");
        String role = request.getParameter("role");

        // Validate input
        if (username == null || password == null || fullName == null || email == null || role == null) {
            response.sendRedirect(request.getContextPath() + "/admin/users?error=All fields are required");
            return;
        }

        // Check if username already exists
        User existingUser = userDAO.getUserByUsername(username);
        if (existingUser != null) {
            response.sendRedirect(request.getContextPath() + "/admin/users?error=Username already exists");
            return;
        }

        // Create new user
        User user = new User(username, password, fullName, email, phoneNumber, role);
        String status = request.getParameter("status");
        if (status != null) {
            user.setStatus(status);
        }
        boolean success = userDAO.addUser(user);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/admin/users?message=User added successfully");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/users?error=Failed to add user");
        }
    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String userIdStr = request.getParameter("id");

        if (userIdStr == null || userIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/users?error=User ID is required");
            return;
        }

        try {
            UUID userId = UUID.fromString(userIdStr);

            // Check if user exists
            User user = userDAO.getUserById(userId);
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/admin/users?error=User not found");
                return;
            }

            // Prevent admin from deleting themselves
            HttpSession session = request.getSession(false);
            User currentUser = (User) session.getAttribute("user");
            if (currentUser.getUserId().equals(userId)) {
                response.sendRedirect(request.getContextPath() + "/admin/users?error=Cannot delete your own account");
                return;
            }

            boolean success = userDAO.deleteUser(userId);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/users?message=User deleted successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/users?error=Failed to delete user");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/users?error=Invalid user ID");
        }
    }

    private void showStatistics(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        // Get detailed statistics
        int totalUsers = userDAO.getTotalUsers();
        int totalRoutes = routeDAO.getTotalRoutes();
        int totalBuses = busDAO.getTotalBuses();
        int totalTickets = ticketDAO.getTotalTickets();
        int totalPassengers = userDAO.getTotalUsers();

        // Get user statistics by role
        int adminUsers = userDAO.getUsersByRole("ADMIN").size();
        int driverUsers = userDAO.getUsersByRole("DRIVER").size();
        int regularUsers = userDAO.getUsersByRole("USER").size();

        // Get recent statistics
        List<User> recentUsers = userDAO.getRecentUsers(10);
        List<Tickets> recentTickets = ticketDAO.getRecentTickets(10);

        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("totalRoutes", totalRoutes);
        request.setAttribute("totalBuses", totalBuses);
        request.setAttribute("totalTickets", totalTickets);
        request.setAttribute("totalPassengers", totalPassengers);
        request.setAttribute("adminUsers", adminUsers);
        request.setAttribute("driverUsers", driverUsers);
        request.setAttribute("regularUsers", regularUsers);
        request.setAttribute("recentUsers", recentUsers);
        request.setAttribute("recentTickets", recentTickets);

        request.getRequestDispatcher("/views/admin/statistics.jsp").forward(request, response);
    }

    private void showReports(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        // Get report data
        List<Tickets> monthlyTickets = ticketDAO.getTicketsByMonth();
        List<Routes> popularRoutes = routeDAO.getPopularRoutes();

        request.setAttribute("monthlyTickets", monthlyTickets);
        request.setAttribute("popularRoutes", popularRoutes);

        request.getRequestDispatcher("/views/admin/reports.jsp").forward(request, response);
    }

    private void handleError(HttpServletRequest request, HttpServletResponse response, String message)
            throws ServletException, IOException {
        request.setAttribute("error", message);
        request.getRequestDispatcher("/views/error.jsp").forward(request, response);
    }

    /**
     * Show admin tickets management page
     */
    private void showTickets(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        // For now, just get all tickets - you can add search functionality later
        List<Tickets> tickets = ticketDAO.getAllTickets();

        request.setAttribute("tickets", tickets);

        request.getRequestDispatcher("/views/admin/tickets.jsp").forward(request, response);
    }

    /**
     * Show admin ticket form with all necessary data
     */
    private void showAdminTicketForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        // Get all routes
        List<Routes> routes = routeDAO.getAllRoutes();

        // Get all buses
        List<Bus> buses = busDAO.getAllBuses();

        // Get all passengers (users with PASSENGER role)
        List<User> passengers = userDAO.getUsersByRole("PASSENGER");

        // Set current date for form
        LocalDate currentDate = LocalDate.now();

        // Set attributes
        request.setAttribute("routes", routes);
        request.setAttribute("buses", buses);
        request.setAttribute("passengers", passengers);
        request.setAttribute("currentDate", currentDate.toString());

        request.getRequestDispatcher("/views/admin/admin-ticket-form.jsp").forward(request, response);
    }

    /**
     * Add new ticket via admin form
     */
    private void addAdminTicket(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {

        try {
            // Get form parameters
            String routeIdStr = request.getParameter("routeId");
            String busIdStr = request.getParameter("busId");
            String userIdStr = request.getParameter("userId");
            String departureDateStr = request.getParameter("departureDate");
            String departureTimeStr = request.getParameter("departureTime");
            String seatNumberStr = request.getParameter("seatNumber");
            String ticketPriceStr = request.getParameter("ticketPrice");
            String status = request.getParameter("status");
            String paymentStatus = request.getParameter("paymentStatus");

            // Validate required parameters
            if (routeIdStr == null || busIdStr == null || userIdStr == null ||
                    departureDateStr == null || departureTimeStr == null ||
                    seatNumberStr == null || ticketPriceStr == null) {
                response.sendRedirect(request.getContextPath() +
                        "/admin/tickets/add?error=All fields are required");
                return;
            }

            // Parse parameters
            UUID routeId = UUID.fromString(routeIdStr);
            UUID busId = UUID.fromString(busIdStr);
            UUID userId = UUID.fromString(userIdStr);
            LocalDate departureDate = LocalDate.parse(departureDateStr);
            LocalTime departureTime = LocalTime.parse(departureTimeStr);
            int seatNumber = Integer.parseInt(seatNumberStr);
            double ticketPrice = Double.parseDouble(ticketPriceStr);

            // Create new ticket
            Tickets ticket = new Tickets();
            ticket.setTicketId(UUID.randomUUID());
            ticket.setTicketNumber(generateTicketNumber());
            ticket.setUserId(userId);
            ticket.setSeatNumber(seatNumber);
            ticket.setTicketPrice(BigDecimal.valueOf(ticketPrice));
            ticket.setStatus(status != null ? status : "PENDING");
            ticket.setPaymentStatus(paymentStatus != null ? paymentStatus : "PENDING");

            // For simplicity, set scheduleId to null for now
            // In a full implementation, you would find/create the appropriate schedule
            ticket.setScheduleId(null);

            // Save ticket using the existing DAO method
            boolean success = ticketDAO.addTicket(ticket);

            if (success) {
                response.sendRedirect(request.getContextPath() +
                        "/admin/dashboard?success=Ticket created successfully! Ticket number: "
                        + ticket.getTicketNumber());
            } else {
                response.sendRedirect(request.getContextPath() +
                        "/admin/tickets/add?error=Failed to create ticket");
            }

        } catch (NumberFormatException | java.time.format.DateTimeParseException e) {
            response.sendRedirect(request.getContextPath() +
                    "/admin/tickets/add?error=Invalid input format: " + e.getMessage());
        } catch (SQLException e) {
            System.err.println("Database error creating admin ticket: " + e.getMessage());
            response.sendRedirect(request.getContextPath() +
                    "/admin/tickets/add?error=Database error: " + e.getMessage());
        } catch (Exception e) {
            System.err.println("Unexpected error creating admin ticket: " + e.getMessage());
            response.sendRedirect(request.getContextPath() +
                    "/admin/tickets/add?error=Unexpected error occurred");
        }
    }

    /**
     * Generate a unique ticket number
     */
    private String generateTicketNumber() {
        return "TKT" + System.currentTimeMillis();
    }
}