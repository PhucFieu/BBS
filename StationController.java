package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.UUID;

import dao.StationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Station;
import util.AuthUtils;

@WebServlet(urlPatterns = { "/stations/*", "/admin/stations/*" })
public class StationController extends HttpServlet {

    private StationDAO stationDAO;

    @Override
    public void init() throws ServletException {
        stationDAO = new StationDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String servletPath = request.getServletPath();
        String pathInfo = request.getPathInfo();
        if (pathInfo == null) pathInfo = "/";

        try {
            if (servletPath.startsWith("/admin")) {
                if (!AuthUtils.canManageStations(request.getSession(false))) {
                    response.sendRedirect(request.getContextPath() + "/auth/login");
                    return;
                }
                if ("/".equals(pathInfo)) {
                    adminListStations(request, response);
                } else if ("/add".equals(pathInfo)) {
                    adminShowAddForm(request, response);
                } else if ("/edit".equals(pathInfo)) {
                    adminShowEditForm(request, response);
                } else if ("/delete".equals(pathInfo)) {
                    adminDeleteStation(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                }
            } else {
                if ("/".equals(pathInfo) || pathInfo.isEmpty()) {
                    listStations(request, response);
                } else if ("/add".equals(pathInfo)) {
                    if (!AuthUtils.canManageStations(request.getSession(false))) {
                        HttpSession session = request.getSession(false);
                        if (session == null || session.getAttribute("user") == null) {
                            response.sendRedirect(request.getContextPath() + "/auth/login");
                        } else {
                            response.sendRedirect(request.getContextPath() + "/admin/stations");
                        }
                        return;
                    }
                    showAddForm(request, response);
                } else if ("/edit".equals(pathInfo)) {
                    if (!AuthUtils.canManageStations(request.getSession(false))) {
                        HttpSession session = request.getSession(false);
                        if (session == null || session.getAttribute("user") == null) {
                            response.sendRedirect(request.getContextPath() + "/auth/login");
                        } else {
                            response.sendRedirect(request.getContextPath() + "/admin/stations");
                        }
                        return;
                    }
                    showEditForm(request, response);
                } else if ("/delete".equals(pathInfo)) {
                    if (!AuthUtils.canManageStations(request.getSession(false))) {
                        HttpSession session = request.getSession(false);
                        if (session == null || session.getAttribute("user") == null) {
                            response.sendRedirect(request.getContextPath() + "/auth/login");
                        } else {
                            response.sendRedirect(request.getContextPath() + "/admin/stations");
                        }
                        return;
                    }
                    deleteStation(request, response);
                } else if ("/search".equals(pathInfo)) {
                    searchStations(request, response);
                } else if ("/cities".equals(pathInfo)) {
                    getAllCities(request, response);
                } else {
                    getStationById(request, response);
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
        if (pathInfo == null) pathInfo = "/";

        try {
            if (servletPath.startsWith("/admin")) {
                if (!AuthUtils.canManageStations(request.getSession(false))) {
                    response.sendRedirect(request.getContextPath() + "/auth/login");
                    return;
                }
                if ("/add".equals(pathInfo)) {
                    adminAddStation(request, response);
                } else if ("/edit".equals(pathInfo)) {
                    adminUpdateStation(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                }
            } else {
                if (!AuthUtils.canManageStations(request.getSession(false))) {
                    HttpSession session = request.getSession(false);
                    if (session == null || session.getAttribute("user") == null) {
                        response.sendRedirect(request.getContextPath() + "/auth/login");
                    } else {
                        response.sendRedirect(request.getContextPath() + "/admin/stations");
                    }
                    return;
                }
                if ("/add".equals(pathInfo)) {
                    addStation(request, response);
                } else if ("/edit".equals(pathInfo)) {
                    updateStation(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                }
            }
        } catch (SQLException e) {
            handleError(request, response, "Database error: " + e.getMessage());
        }
    }

    private void listStations(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        List<Station> stations = stationDAO.getAllStations();
        request.setAttribute("stations", stations);
        request.getRequestDispatcher("/views/stations/stations.jsp").forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/stations/station-form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        UUID stationId = UUID.fromString(request.getParameter("id"));
        Station station = stationDAO.getStationById(stationId);

        if (station != null) {
            request.setAttribute("station", station);
            request.getRequestDispatcher("/views/stations/station-form.jsp").forward(request, response);
        } else {
            handleError(request, response, "Station not found");
        }
    }

    private void addStation(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        // Get parameters from request
        String stationName = request.getParameter("stationName");
        String city = request.getParameter("city");
        String address = request.getParameter("address");

        // Validate input
        if (stationName == null || stationName.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/stations/add?error=Station name is required");
            return;
        }

        // Create new station
        Station station = new Station(stationName, city, address);

        // Save to database
        boolean success = stationDAO.addStation(station);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/stations?message=Station added successfully");
        } else {
            response.sendRedirect(request.getContextPath() + "/stations/add?error=Failed to add station");
        }
    }

    private void updateStation(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        // Get parameters from request
        UUID stationId = UUID.fromString(request.getParameter("stationId"));
        String stationName = request.getParameter("stationName");
        String city = request.getParameter("city");
        String address = request.getParameter("address");

        // Create station object
        Station station = new Station(stationName, city, address);
        station.setStationId(stationId);

        // Update in database
        boolean success = stationDAO.updateStation(station);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/stations?message=Station updated successfully");
        } else {
            response.sendRedirect(
                    request.getContextPath() + "/stations/edit?id=" + stationId + "&error=Failed to update station");
        }
    }

    private void deleteStation(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        UUID stationId = UUID.fromString(request.getParameter("id"));
        boolean success = stationDAO.deleteStation(stationId);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/stations?message=Station deleted successfully");
        } else {
            response.sendRedirect(request.getContextPath() + "/stations?error=Failed to delete station");
        }
    }

    private void searchStations(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        String keyword = request.getParameter("keyword");
        List<Station> stations = stationDAO.searchStations(keyword);
        request.setAttribute("stations", stations);
        request.setAttribute("keyword", keyword);
        request.getRequestDispatcher("/views/stations/stations.jsp").forward(request, response);
    }

    private void getAllCities(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        List<String> cities = stationDAO.getAllCities();
        request.setAttribute("cities", cities);
        request.getRequestDispatcher("/views/cities.jsp").forward(request, response);
    }

    private void getStationById(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        String pathInfo = request.getPathInfo();
        UUID stationId = UUID.fromString(pathInfo.substring(1));

        Station station = stationDAO.getStationById(stationId);

        if (station != null) {
            request.setAttribute("station", station);
            request.getRequestDispatcher("/views/station-detail.jsp").forward(request, response);
        } else {
            handleError(request, response, "Station not found");
        }
    }

    private void handleError(HttpServletRequest request, HttpServletResponse response, String message)
            throws ServletException, IOException {
        request.setAttribute("error", message);
        request.getRequestDispatcher("/views/errors/error.jsp").forward(request, response);
    }

    // Admin-specific helpers
    private void adminListStations(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        List<Station> stations = stationDAO.getAllStations();
        request.setAttribute("stations", stations);
        request.getRequestDispatcher("/views/admin/stations.jsp").forward(request, response);
    }

    private void adminShowAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/admin/station-form.jsp").forward(request, response);
    }

    private void adminShowEditForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        String stationIdStr = request.getParameter("id");
        if (stationIdStr == null || stationIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/stations?error=Station ID is required");
            return;
        }
        try {
            UUID stationId = UUID.fromString(stationIdStr);
            Station station = stationDAO.getStationById(stationId);
            if (station != null) {
                request.setAttribute("station", station);
                request.getRequestDispatcher("/views/admin/station-form.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/stations?error=Station not found");
            }
        } catch (IllegalArgumentException e) {
            response.sendRedirect(request.getContextPath() + "/admin/stations?error=Invalid station ID");
        }
    }

    private void adminAddStation(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String stationName = request.getParameter("stationName");
        String city = request.getParameter("city");
        String address = request.getParameter("address");
        if (stationName == null || stationName.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/stations/add?error=Station name is required");
            return;
        }
        Station station = new Station(stationName, city, address);
        boolean success = stationDAO.addStation(station);
        if (success) {
            response.sendRedirect(request.getContextPath() + "/admin/stations?message=Station added successfully");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/stations/add?error=Failed to add station");
        }
    }

    private void adminUpdateStation(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String stationIdStr = request.getParameter("stationId");
        String stationName = request.getParameter("stationName");
        String city = request.getParameter("city");
        String address = request.getParameter("address");
        if (stationIdStr == null || stationName == null || stationName.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/stations?error=All fields are required");
            return;
        }
        try {
            UUID stationId = UUID.fromString(stationIdStr);
            Station existingStation = stationDAO.getStationById(stationId);
            if (existingStation == null) {
                response.sendRedirect(request.getContextPath() + "/admin/stations?error=Station not found");
                return;
            }
            existingStation.setStationName(stationName);
            existingStation.setCity(city);
            existingStation.setAddress(address);
            boolean success = stationDAO.updateStation(existingStation);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/stations?message=Station updated successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/stations?error=Failed to update station");
            }
        } catch (IllegalArgumentException e) {
            response.sendRedirect(request.getContextPath() + "/admin/stations?error=Invalid station ID");
        }
    }

    private void adminDeleteStation(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String stationIdStr = request.getParameter("id");
        if (stationIdStr == null || stationIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/stations?error=Station ID is required");
            return;
        }
        try {
            UUID stationId = UUID.fromString(stationIdStr);
            boolean success = stationDAO.deleteStation(stationId);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/stations?message=Station deleted successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/stations?error=Failed to delete station");
            }
        } catch (IllegalArgumentException e) {
            response.sendRedirect(request.getContextPath() + "/admin/stations?error=Invalid station ID");
        }
    }
}
