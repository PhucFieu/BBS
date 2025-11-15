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
import model.Routes;
import model.Tickets;
import model.User;

@WebServlet({"/admin/statistics", "/admin/reports"})
public class StatisticsController extends HttpServlet {
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

        String pathInfo = request.getPathInfo();
        try {
            if (pathInfo != null && pathInfo.equals("/reports")) {
                showReports(request, response);
            } else {
                showStatistics(request, response);
            }
        } catch (SQLException e) {
            handleError(request, response, "Database error: " + e.getMessage());
        }
    }

    private void showStatistics(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        UserDAO userDAO = baseController.userDAO;
        RouteDAO routeDAO = baseController.routeDAO;
        BusDAO busDAO = baseController.busDAO;
        TicketDAO ticketDAO = baseController.ticketDAO;

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
        TicketDAO ticketDAO = baseController.ticketDAO;
        RouteDAO routeDAO = baseController.routeDAO;

        // Get report data
        List<Tickets> monthlyTickets = ticketDAO.getTicketsByMonth();
        List<Routes> popularRoutes = routeDAO.getPopularRoutes();

        request.setAttribute("monthlyTickets", monthlyTickets);
        request.setAttribute("popularRoutes", popularRoutes);

        request.getRequestDispatcher("/views/admin/reports.jsp").forward(request, response);
    }

    private void handleError(HttpServletRequest request, HttpServletResponse response,
            String message)
            throws ServletException, IOException {
        request.setAttribute("error", message);
        request.getRequestDispatcher("/views/errors/error.jsp").forward(request, response);
    }
}

