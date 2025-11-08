package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.UUID;

import dao.BusDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Bus;
import util.AuthUtils;

@WebServlet(urlPatterns = {"/buses/*", "/admin/buses/*"})
public class BusController extends HttpServlet {

    private BusDAO busDAO;

    @Override
    public void init() throws ServletException {
        busDAO = new BusDAO();
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
                // Admin endpoints
                if (!AuthUtils.canManageBuses(request.getSession(false))) {
                    response.sendRedirect(request.getContextPath() + "/auth/login");
                    return;
                }

                if ("/".equals(pathInfo)) {
                    adminListBuses(request, response);
                } else if ("/delete".equals(pathInfo)) {
                    deleteBus(request, response);
                } else if ("/search".equals(pathInfo)) {
                    adminSearchBuses(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                }
            } else {
                // Public/business endpoints
                if ("/".equals(pathInfo) || pathInfo.isEmpty()) {
                    listBuses(request, response);
                } else if ("/public".equals(pathInfo)) {
                    showPublicBuses(request, response);
                } else if ("/add".equals(pathInfo)) {
                    // Require manage permission for modifications
                    if (!AuthUtils.canManageBuses(request.getSession(false))) {
                        HttpSession session = request.getSession(false);
                        if (session == null || session.getAttribute("user") == null) {
                            response.sendRedirect(request.getContextPath() + "/auth/login");
                        } else {
                            response.sendRedirect(request.getContextPath() + "/admin/buses");
                        }
                        return;
                    }
                    showAddForm(request, response);
                } else if ("/edit".equals(pathInfo)) {
                    if (!AuthUtils.canManageBuses(request.getSession(false))) {
                        HttpSession session = request.getSession(false);
                        if (session == null || session.getAttribute("user") == null) {
                            response.sendRedirect(request.getContextPath() + "/auth/login");
                        } else {
                            response.sendRedirect(request.getContextPath() + "/admin/buses");
                        }
                        return;
                    }
                    showEditForm(request, response);
                } else if ("/delete".equals(pathInfo)) {
                    if (!AuthUtils.canManageBuses(request.getSession(false))) {
                        HttpSession session = request.getSession(false);
                        if (session == null || session.getAttribute("user") == null) {
                            response.sendRedirect(request.getContextPath() + "/auth/login");
                        } else {
                            response.sendRedirect(request.getContextPath() + "/admin/buses");
                        }
                        return;
                    }
                    deleteBus(request, response);
                } else if ("/available".equals(pathInfo)) {
                    showAvailableBuses(request, response);
                } else {
                    getBusById(request, response);
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
                if (!AuthUtils.canManageBuses(request.getSession(false))) {
                    response.sendRedirect(request.getContextPath() + "/auth/login");
                    return;
                }
                if ("/add".equals(pathInfo)) {
                    addBus(request, response);
                } else if ("/edit".equals(pathInfo)) {
                    updateBus(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                }
            } else {
                // Public endpoints do not support POST except for manage actions
                if (!AuthUtils.canManageBuses(request.getSession(false))) {
                    HttpSession session = request.getSession(false);
                    if (session == null || session.getAttribute("user") == null) {
                        response.sendRedirect(request.getContextPath() + "/auth/login");
                    } else {
                        response.sendRedirect(request.getContextPath() + "/admin/buses");
                    }
                    return;
                }
                if ("/add".equals(pathInfo)) {
                    addBus(request, response);
                } else if ("/edit".equals(pathInfo)) {
                    updateBus(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                }
            }
        } catch (SQLException e) {
            handleError(request, response, "Database error: " + e.getMessage());
        }
    }

    private void listBuses(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        List<Bus> buses = busDAO.getAllBuses();
        request.setAttribute("buses", buses);
        request.getRequestDispatcher("/views/buses/buses.jsp").forward(request, response);
    }

    private void showPublicBuses(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        List<Bus> buses = busDAO.getAvailableBuses();
        request.setAttribute("buses", buses);
        request.getRequestDispatcher("/views/buses/bus-listing.jsp").forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/buses/bus-form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        UUID busId = UUID.fromString(request.getParameter("id"));
        Bus bus = busDAO.getBusById(busId);

        if (bus != null) {
            request.setAttribute("bus", bus);
            request.getRequestDispatcher("/views/buses/bus-form.jsp").forward(request, response);
        } else {
            handleError(request, response, "Bus not found");
        }
    }

    private void showAvailableBuses(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        List<Bus> buses = busDAO.getAvailableBuses();
        request.setAttribute("buses", buses);
        request.setAttribute("availableOnly", true);
        request.getRequestDispatcher("/views/buses/buses.jsp").forward(request, response);
    }

    private void addBus(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        // Get parameters from request
        String busNumber = request.getParameter("busNumber");
        String busType = request.getParameter("busType");
        int totalSeats = Integer.parseInt(request.getParameter("totalSeats"));
        String licensePlate = request.getParameter("licensePlate");

        // Validate input
        if (busNumber == null || busNumber.trim().isEmpty()) {
            response.sendRedirect(
                    request.getContextPath() + "/buses/add?error=Bus number is required");
            return;
        }

        // Create new bus
        Bus bus = new Bus(busNumber, busType, totalSeats, licensePlate);

        // Save to database
        boolean success = busDAO.addBus(bus);

        if (success) {
            response.sendRedirect(
                    request.getContextPath() + "/buses?message=Bus added successfully");
        } else {
            response.sendRedirect(request.getContextPath() + "/buses/add?error=Failed to add bus");
        }
    }

    private void updateBus(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        // Get parameters from request
        UUID busId = UUID.fromString(request.getParameter("busId"));
        String busNumber = request.getParameter("busNumber");
        String busType = request.getParameter("busType");
        int totalSeats = Integer.parseInt(request.getParameter("totalSeats"));
        String licensePlate = request.getParameter("licensePlate");

        // Create bus object
        Bus bus = new Bus(busNumber, busType, totalSeats, licensePlate);
        bus.setBusId(busId);

        // Update in database
        boolean success = busDAO.updateBus(bus);

        if (success) {
            response.sendRedirect(
                    request.getContextPath() + "/buses?message=Bus updated successfully");
        } else {
            response.sendRedirect(request.getContextPath() + "/buses/edit?id=" + busId
                    + "&error=Failed to update bus");
        }
    }

    private void deleteBus(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        try {
            UUID busId = UUID.fromString(request.getParameter("id"));

            // Check if bus exists
            Bus bus = busDAO.getBusById(busId);
            if (bus == null) {
                response.sendRedirect(
                        request.getContextPath() + "/admin/buses?error=Bus not found");
                return;
            }

            // Check if bus is currently in use (has active schedules)
            boolean isInUse = busDAO.isBusInUse(busId);
            if (isInUse) {
                response.sendRedirect(request.getContextPath()
                        + "/admin/buses?error=Cannot delete bus. It is currently assigned to active schedules.");
                return;
            }

            // Perform soft delete
            boolean success = busDAO.deleteBus(busId);

            if (success) {
                response.sendRedirect(
                        request.getContextPath() + "/admin/buses?message=Bus " + bus.getBusNumber()
                                + " deleted successfully");
            } else {
                response.sendRedirect(
                        request.getContextPath() + "/admin/buses?error=Failed to delete bus");
            }
        } catch (IllegalArgumentException e) {
            response.sendRedirect(request.getContextPath() + "/admin/buses?error=Invalid bus ID");
        } catch (Exception e) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/admin/buses?error=An error occurred while deleting the bus");
        }
    }

    private void getBusById(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        String pathInfo = request.getPathInfo();
        UUID busId = UUID.fromString(pathInfo.substring(1));

        Bus bus = busDAO.getBusById(busId);

        if (bus != null) {
            request.setAttribute("bus", bus);
            request.getRequestDispatcher("/views/bus-detail.jsp").forward(request, response);
        } else {
            handleError(request, response, "Bus not found");
        }
    }

    private void handleError(HttpServletRequest request, HttpServletResponse response,
            String message)
            throws ServletException, IOException {
        request.setAttribute("error", message);
        request.getRequestDispatcher("/views/errors/error.jsp").forward(request, response);
    }

    // Admin-specific helpers
    private void adminListBuses(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        List<Bus> buses = busDAO.getAllBuses();
        request.setAttribute("buses", buses);
        request.getRequestDispatcher("/views/admin/buses.jsp").forward(request, response);
    }

    private void adminSearchBuses(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String searchTerm = request.getParameter("search");
        List<Bus> buses = (searchTerm != null && !searchTerm.trim().isEmpty())
                ? busDAO.searchBuses(searchTerm)
                : busDAO.getAllBuses();

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        StringBuilder jsonResponse = new StringBuilder();
        jsonResponse.append("[");
        for (int i = 0; i < buses.size(); i++) {
            Bus bus = buses.get(i);
            jsonResponse.append("{");
            jsonResponse.append("\"busId\":\"").append(bus.getBusId()).append("\",");
            jsonResponse.append("\"busNumber\":\"").append(bus.getBusNumber()).append("\",");
            jsonResponse.append("\"busType\":\"").append(bus.getBusType()).append("\",");
            jsonResponse.append("\"licensePlate\":\"").append(bus.getLicensePlate()).append("\",");
            jsonResponse.append("\"totalSeats\":").append(bus.getTotalSeats()).append(",");
            jsonResponse.append("\"status\":\"").append(bus.getStatus()).append("\"");
            jsonResponse.append("}");
            if (i < buses.size() - 1) {
                jsonResponse.append(",");
            }
        }
        jsonResponse.append("]");
        response.getWriter().write(jsonResponse.toString());
    }
}
