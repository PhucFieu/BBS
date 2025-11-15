package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import dao.BusDAO;
import dao.RouteDAO;
import dao.TicketDAO;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Tickets;
import model.User;

@WebServlet("/admin/dashboard")
public class DashboardController extends HttpServlet {
    private AdminBaseController baseController;

    @Override
    public void init() throws ServletException {
        baseController = new AdminBaseController() {};
        baseController.initializeDAOs();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!baseController.isAdminAuthenticated(request)) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        try {
            showDashboard(request, response);
        } catch (SQLException e) {
            handleError(request, response, "Database error: " + e.getMessage());
        }
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        UserDAO userDAO = baseController.userDAO;
        RouteDAO routeDAO = baseController.routeDAO;
        BusDAO busDAO = baseController.busDAO;
        TicketDAO ticketDAO = baseController.ticketDAO;

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

    private void handleError(HttpServletRequest request, HttpServletResponse response,
            String message)
            throws ServletException, IOException {
        request.setAttribute("error", message);
        request.getRequestDispatcher("/views/errors/error.jsp").forward(request, response);
    }
}

