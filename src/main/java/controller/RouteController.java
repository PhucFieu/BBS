package controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;
import java.util.UUID;

import dao.RouteDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Routes;
import util.AuthUtils;

@WebServlet("/routes/*")
public class RouteController extends HttpServlet {
    private RouteDAO routeDAO;

    @Override
    public void init() throws ServletException {
        routeDAO = new RouteDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        // Allow public access to /routes/search for user role
        if ("/search".equals(pathInfo)) {
            try {
                searchRoutes(request, response);
            } catch (SQLException e) {
                handleError(request, response, "Database error: " + e.getMessage());
            }
            return;
        }

        boolean isAdmin = AuthUtils.isAdmin(request.getSession(false));
        boolean isDriver = AuthUtils.isDriver(request.getSession(false));

        try {
            if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("")) {
                // List all routes - allow ADMIN and DRIVER
                if (!isAdmin && !isDriver) {
                    request.setAttribute("error", "You do not have permission to access this page");
                    request.getRequestDispatcher("/views/403.jsp").forward(request, response);
                    return;
                }
                listRoutes(request, response);
            } else if (pathInfo.equals("/add")) {
                // Show add form
                if (!isAdmin) {
                    request.setAttribute("error", "You do not have permission to access this page");
                    request.getRequestDispatcher("/views/403.jsp").forward(request, response);
                    return;
                }
                showAddForm(request, response);
            } else if (pathInfo.equals("/edit")) {
                // Show edit form
                if (!isAdmin) {
                    request.setAttribute("error", "You do not have permission to access this page");
                    request.getRequestDispatcher("/views/403.jsp").forward(request, response);
                    return;
                }
                showEditForm(request, response);
            } else if (pathInfo.equals("/delete")) {
                // Delete route
                if (!isAdmin) {
                    request.setAttribute("error", "You do not have permission to access this page");
                    request.getRequestDispatcher("/views/403.jsp").forward(request, response);
                    return;
                }
                deleteRoute(request, response);
            } else if (pathInfo.equals("/search")) {
                // Search routes
                searchRoutes(request, response);
            } else {
                // Get route by ID
                if (!isAdmin && !isDriver) {
                    request.setAttribute("error", "You do not have permission to access this page");
                    request.getRequestDispatcher("/views/403.jsp").forward(request, response);
                    return;
                }
                getRouteById(request, response);
            }
        } catch (SQLException e) {
            handleError(request, response, "Database error: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        // Allow public access to /routes/search via POST as well
        if ("/search".equals(pathInfo)) {
            try {
                searchRoutes(request, response);
            } catch (SQLException e) {
                handleError(request, response, "Database error: " + e.getMessage());
            }
            return;
        }

        // For other endpoints, enforce admin-only for modifications
        if (!AuthUtils.isAdmin(request.getSession(false))) {
            request.setAttribute("error", "You do not have permission to access this page");
            request.getRequestDispatcher("/views/403.jsp").forward(request, response);
            return;
        }

        try {
            if (pathInfo.equals("/add")) {
                addRoute(request, response);
            } else if (pathInfo.equals("/edit")) {
                updateRoute(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            handleError(request, response, "Database error: " + e.getMessage());
        }
    }

    private void listRoutes(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        List<Routes> routes = routeDAO.getAllRoutes();
        request.setAttribute("routes", routes);
        if (AuthUtils.isAdmin(request.getSession(false))) {
            request.getRequestDispatcher("/views/routes.jsp").forward(request, response);
        } else {
            // For DRIVER/USER, show the public/search-oriented page instead of admin UI
            request.getRequestDispatcher("/views/route-search.jsp").forward(request, response);
        }
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/route-form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        UUID routeId = UUID.fromString(request.getParameter("id"));
        Routes route = routeDAO.getRouteById(routeId);

        if (route != null) {
            request.setAttribute("route", route);
            request.getRequestDispatcher("/views/route-form.jsp").forward(request, response);
        } else {
            handleError(request, response, "Route not found");
        }
    }

    private void addRoute(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        // Get parameters from request
        String routeName = request.getParameter("routeName");
        String departureCity = request.getParameter("departureCity");
        String destinationCity = request.getParameter("destinationCity");
        BigDecimal distance = new BigDecimal(request.getParameter("distance"));
        int durationHours = Integer.parseInt(request.getParameter("durationHours"));
        BigDecimal basePrice = new BigDecimal(request.getParameter("basePrice"));

        // Create new route
        Routes route = new Routes(routeName, departureCity, destinationCity, distance, durationHours, basePrice);

        // Save to database
        boolean success = routeDAO.addRoute(route);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/routes?message=Route added successfully");
        } else {
            response.sendRedirect(request.getContextPath() + "/routes/add?error=Failed to add route");
        }
    }

    private void updateRoute(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        // Get parameters from request
        UUID routeId = UUID.fromString(request.getParameter("routeId"));
        String routeName = request.getParameter("routeName");
        String departureCity = request.getParameter("departureCity");
        String destinationCity = request.getParameter("destinationCity");
        BigDecimal distance = new BigDecimal(request.getParameter("distance"));
        int durationHours = Integer.parseInt(request.getParameter("durationHours"));
        BigDecimal basePrice = new BigDecimal(request.getParameter("basePrice"));

        // Create route object
        Routes route = new Routes(routeName, departureCity, destinationCity, distance, durationHours, basePrice);
        route.setRouteId(routeId);

        // Update in database
        boolean success = routeDAO.updateRoute(route);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/routes?message=Route updated successfully");
        } else {
            response.sendRedirect(
                    request.getContextPath() + "/routes/edit?id=" + routeId + "&error=Failed to update route");
        }
    }

    private void deleteRoute(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        UUID routeId = UUID.fromString(request.getParameter("id"));
        boolean success = routeDAO.deleteRoute(routeId);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/routes?message=Route deleted successfully");
        } else {
            response.sendRedirect(request.getContextPath() + "/routes?error=Failed to delete route");
        }
    }

    private void searchRoutes(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        String departureCity = request.getParameter("departureCity");
        String destinationCity = request.getParameter("destinationCity");

        List<Routes> routes = routeDAO.searchRoutes(departureCity, destinationCity);
        request.setAttribute("routes", routes);
        request.setAttribute("departureCity", departureCity);
        request.setAttribute("destinationCity", destinationCity);
        request.getRequestDispatcher("/views/routes.jsp").forward(request, response);
    }

    private void getRouteById(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        String pathInfo = request.getPathInfo();
        UUID routeId = UUID.fromString(pathInfo.substring(1)); // Remove leading slash

        Routes route = routeDAO.getRouteById(routeId);

        if (route != null) {
            request.setAttribute("route", route);
            request.getRequestDispatcher("/views/route-detail.jsp").forward(request, response);
        } else {
            handleError(request, response, "Route not found");
        }
    }

    private void handleError(HttpServletRequest request, HttpServletResponse response, String message)
            throws ServletException, IOException {
        request.setAttribute("error", message);
        request.getRequestDispatcher("/views/error.jsp").forward(request, response);
    }
}