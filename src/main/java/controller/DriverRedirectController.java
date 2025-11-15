package controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import util.AuthUtils;

@WebServlet("/drivers")
public class DriverRedirectController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if user is logged in and is a driver
        if (!AuthUtils.isLoggedIn(request.getSession(false))) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        // Check if user has driver role
        if (!AuthUtils.isDriver(request.getSession(false))) {
            request.setAttribute("error", "Access denied: DRIVER role required");
            request.getRequestDispatcher("/views/errors/403.jsp").forward(request, response);
            return;
        }

        // Redirect to the correct driver URL
        response.sendRedirect(request.getContextPath() + "/driver/trips");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
