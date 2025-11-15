package controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

/**
 * Legacy AdminController - now redirects to specific controllers
 * This controller is kept for backward compatibility but most functionality
 * has been moved to specialized controllers:
 * - DashboardController: /admin/dashboard
 * - UserManagementController: /admin/users/*
 * - TicketManagementController: /admin/tickets/*
 * - BusManagementController: /admin/buses/*
 * - StationManagementController: /admin/stations/*
 * - ScheduleManagementController: /admin/schedules/*
 * - DriverManagementController: /admin/drivers/*
 * - StatisticsController: /admin/statistics, /admin/reports
 */
@WebServlet("/admin")
public class AdminController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check admin authentication
        if (!isAdminAuthenticated(request)) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        // Redirect to dashboard
        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check admin authentication
        if (!isAdminAuthenticated(request)) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        // Redirect to dashboard
        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
    }

    private boolean isAdminAuthenticated(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            return false;
        }

        User user = (User) session.getAttribute("user");
        return "ADMIN".equals(user.getRole());
    }
}
