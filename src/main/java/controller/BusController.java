package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.UUID;
import java.util.regex.Pattern;

import dao.BusDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Bus;
import util.AuthUtils;
import util.StringUtils;

@WebServlet(urlPatterns = {"/buses/*", "/admin/buses/*"})
public class BusController extends HttpServlet {

    private BusDAO busDAO;
    // License plate format: XX-XXXXX or XX-XXXX (e.g., 30F-256.58, 30F-25658)
    // Pattern: 2-3 alphanumeric characters, hyphen, 4-6 alphanumeric characters (may include dots)
    private static final Pattern LICENSE_PLATE_PATTERN =
            Pattern.compile("^[0-9A-Z]{2,3}-[0-9A-Z.]{4,6}$");

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
        Bus bus = busDAO.getBusByIdForAdmin(busId);

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
        String licensePlate = request.getParameter("licensePlate");

        // Validate input
        if (StringUtils.isBlank(busNumber)) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/buses/add?error=Error: Please enter bus number");
            return;
        }
        if (StringUtils.isBlank(busType)) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/buses/add?error=Error: Please select bus type");
            return;
        }
        if (StringUtils.isBlank(licensePlate)) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/buses/add?error=Error: Please enter license plate");
            return;
        }

        // Normalize bus number - remove extra spaces to prevent duplicates with different spacing
        busNumber = StringUtils.normalizeSpaces(busNumber);
        licensePlate = licensePlate.trim().toUpperCase();

        if (busDAO.isBusNumberExists(busNumber, null)) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/buses/add?error=Error: Bus number \"" + busNumber
                            + "\" already exists. Please use a different bus number");
            return;
        }

        // Validate license plate format
        if (!LICENSE_PLATE_PATTERN.matcher(licensePlate).matches()) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/buses/add?error=Error: Invalid license plate format. Format: XX-XXXXX or XX-XXXX (e.g., 30F-256.58)");
            return;
        }

        try {
            int totalSeats = determineSeatsFromType(busType);
            if (totalSeats == 0) {
                response.sendRedirect(
                        request.getContextPath()
                                + "/buses/add?error=Error: Unsupported bus type. Please choose a valid option");
                return;
            }

            if (busDAO.isLicensePlateExists(licensePlate, null)) {
                response.sendRedirect(
                        request.getContextPath()
                                + "/buses/add?error=Error: License plate \"" + licensePlate
                                + "\" already exists. Please use a different license plate");
                return;
            }

            // Create new bus
            Bus bus = new Bus(busNumber, busType, totalSeats, licensePlate);

            // Save to database
            boolean success = busDAO.addBus(bus);

            if (success) {
                response.sendRedirect(
                        request.getContextPath()
                                + "/admin/buses?message=Bus added successfully! Bus " + busNumber
                                + " has been added to the system");
            } else {
                response.sendRedirect(request.getContextPath()
                        + "/buses/add?error=Error: Failed to add bus. Please try again or contact administrator");
            }
        } catch (SQLException e) {
            // Check for duplicate key violation
            String errorMessage = e.getMessage();
            if (errorMessage != null) {
                String upperMessage = errorMessage.toUpperCase();
                // Check for duplicate key constraint violation
                if (upperMessage.contains("UNIQUE KEY")
                        || upperMessage.contains("UNIQUE CONSTRAINT")
                        || upperMessage.contains("DUPLICATE KEY")) {
                    // Check if it's specifically about bus_number by looking for the bus number in
                    // the error
                    if (errorMessage.contains(busNumber) || upperMessage.contains("BUS_NUMBER")) {
                        response.sendRedirect(request.getContextPath()
                                + "/buses/add?error=Error: Bus number \"" + busNumber
                                + "\" already exists in the system. Please use a different bus number");
                    } else {
                        response.sendRedirect(request.getContextPath()
                                + "/buses/add?error=Error: Information already exists in the system. Please check your input data");
                    }
                    return;
                }
            }
            // Other SQL errors
            response.sendRedirect(request.getContextPath()
                    + "/buses/add?error=Error: An error occurred while adding the bus. Please try again");
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath()
                    + "/buses/add?error=Error: An unexpected error occurred. Please try again");
        }
    }

    private void updateBus(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String busIdStr = request.getParameter("busId");
        String busNumber = request.getParameter("busNumber");
        String busType = request.getParameter("busType");
        String licensePlate = request.getParameter("licensePlate");
        String status = request.getParameter("status");

        // Validate input
        if (StringUtils.isBlank(busIdStr)) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/admin/buses?error=Missing information: Bus ID is required");
            return;
        }
        if (StringUtils.isBlank(busNumber)) {
            response.sendRedirect(
                    request.getContextPath() + "/buses/edit?id=" + busIdStr
                            + "&error=Missing information: Bus number is required");
            return;
        }
        if (StringUtils.isBlank(busType)) {
            response.sendRedirect(
                    request.getContextPath() + "/buses/edit?id=" + busIdStr
                            + "&error=Missing information: Bus type is required");
            return;
        }
        if (StringUtils.isBlank(licensePlate)) {
            response.sendRedirect(
                    request.getContextPath() + "/buses/edit?id=" + busIdStr
                            + "&error=Missing information: License plate is required");
            return;
        }

        try {
            UUID busId = UUID.fromString(busIdStr);
            // Normalize bus number - remove extra spaces to prevent duplicates with different spacing
            busNumber = StringUtils.normalizeSpaces(busNumber);
            licensePlate = licensePlate.trim().toUpperCase();

            // Validate license plate format
            if (!LICENSE_PLATE_PATTERN.matcher(licensePlate).matches()) {
                response.sendRedirect(
                        request.getContextPath() + "/buses/edit?id=" + busIdStr
                                + "&error=Error: Invalid license plate format. Format: XX-XXXXX or XX-XXXX (e.g., 30F-256.58)");
                return;
            }

            int totalSeats = determineSeatsFromType(busType);
            if (totalSeats == 0) {
                response.sendRedirect(
                        request.getContextPath() + "/buses/edit?id=" + busIdStr
                                + "&error=Error: Unsupported bus type. Please choose a valid option");
                return;
            }

            if (busDAO.isBusNumberExists(busNumber, busId)) {
                response.sendRedirect(
                        request.getContextPath() + "/buses/edit?id=" + busIdStr
                                + "&error=Error: Bus number \"" + busNumber
                                + "\" already exists. Please use a different bus number");
                return;
            }

            if (busDAO.isLicensePlateExists(licensePlate, busId)) {
                response.sendRedirect(
                        request.getContextPath() + "/buses/edit?id=" + busIdStr
                                + "&error=Error: License plate \"" + licensePlate
                                + "\" already exists. Please use a different license plate");
                return;
            }

            // Create bus object
            Bus bus = new Bus(busNumber, busType, totalSeats, licensePlate);
            bus.setBusId(busId);
            if (status != null && !status.trim().isEmpty()) {
                bus.setStatus(status);
            }

            // Update in database
            boolean success = busDAO.updateBus(bus);

            if (success) {
                response.sendRedirect(
                        request.getContextPath()
                                + "/admin/buses?message=Bus updated successfully! Bus " + busNumber
                                + " information has been saved");
            } else {
                response.sendRedirect(request.getContextPath() + "/buses/edit?id=" + busId
                        + "&error=Error: Failed to update bus. Please try again or contact administrator");
            }
        } catch (IllegalArgumentException e) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/buses?error=Error: Invalid bus ID format");
        } catch (NullPointerException e) {
            response.sendRedirect(
                    request.getContextPath() + "/buses/edit?id=" + busIdStr
                            + "&error=Error: Missing information. Please fill all required fields");
        } catch (Exception e) {
            response.sendRedirect(
                    request.getContextPath() + "/buses/edit?id=" + busIdStr
                            + "&error=Error: An unexpected error occurred. " + e.getMessage());
        }
    }

    private void deleteBus(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        try {
            UUID busId = UUID.fromString(request.getParameter("id"));

            // Check if bus exists
            Bus bus = busDAO.getBusByIdForAdmin(busId);
            if (bus == null) {
                response.sendRedirect(
                        request.getContextPath()
                                + "/admin/buses?error=Error: Bus not found with the given ID");
                return;
            }

            // Check if bus is currently in use (has active schedules)
            boolean isInUse = busDAO.isBusInUse(busId);
            if (isInUse) {
                response.sendRedirect(request.getContextPath()
                        + "/admin/buses?error=Error: Cannot delete bus. Bus " + bus.getBusNumber()
                        + " is currently assigned to active schedules. Please reassign or cancel the schedules first.");
                return;
            }

            // Perform soft delete
            boolean success = busDAO.deleteBus(busId);

            if (success) {
                response.sendRedirect(
                        request.getContextPath() + "/admin/buses?message=Bus " + bus.getBusNumber()
                                + " deleted successfully! Bus has been removed from the system");
            } else {
                response.sendRedirect(
                        request.getContextPath()
                                + "/admin/buses?error=Error: Failed to delete bus. Please try again or contact administrator");
            }
        } catch (IllegalArgumentException e) {
            response.sendRedirect(request.getContextPath()
                    + "/admin/buses?error=Error: Invalid bus ID format. Please check again");
        } catch (Exception e) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/admin/buses?error=Error: An unexpected error occurred while deleting the bus. "
                            + e.getMessage());
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

    private int determineSeatsFromType(String busType) {
        if (busType == null) {
            return 0;
        }
        switch (busType) {
            case "Bus 45 seats":
                return 45;
            case "Bus 35 seats":
                return 35;
            case "Bus 25 seats":
                return 25;
            case "Bus 16 seats":
                return 16;
            default:
                return 0;
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
        List<Bus> buses = busDAO.getAllBusesForAdmin();
        List<String> busTypes = busDAO.getDistinctBusTypes();
        request.setAttribute("buses", buses);
        request.setAttribute("busTypes", busTypes);
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
