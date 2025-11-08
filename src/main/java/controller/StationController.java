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

@WebServlet("/stations/*")
public class StationController extends HttpServlet {

    private StationDAO stationDAO;

    @Override
    public void init() throws ServletException {
        stationDAO = new StationDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user has permission to manage stations
        if (!AuthUtils.canManageStations(request.getSession(false))) {
            // Redirect to admin login if not logged in, or redirect to admin stations if
            // logged in but not admin
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                response.sendRedirect(request.getContextPath() + "/auth/login");
                return;
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/stations");
                return;
            }
        }

        String pathInfo = request.getPathInfo();

        try {
            if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("")) {
                // List all stations
                listStations(request, response);
            } else if (pathInfo.equals("/add")) {
                // Show add form
                showAddForm(request, response);
            } else if (pathInfo.equals("/edit")) {
                // Show edit form
                showEditForm(request, response);
            } else if (pathInfo.equals("/delete")) {
                // Delete station
                deleteStation(request, response);
            } else if (pathInfo.equals("/search")) {
                // Search stations
                searchStations(request, response);
            } else if (pathInfo.equals("/cities")) {
                // Get all cities
                getAllCities(request, response);
            } else {
                // Get station by ID
                getStationById(request, response);
            }
        } catch (SQLException e) {
            handleError(request, response, "Database error: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user has permission to manage stations
        if (!AuthUtils.canManageStations(request.getSession(false))) {
            // Redirect to admin login if not logged in, or redirect to admin stations if
            // logged in but not admin
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                response.sendRedirect(request.getContextPath() + "/auth/login");
                return;
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/stations");
                return;
            }
        }

        String pathInfo = request.getPathInfo();

        try {
            if (pathInfo.equals("/add")) {
                addStation(request, response);
            } else if (pathInfo.equals("/edit")) {
                updateStation(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            handleError(request, response, "Database error: " + e.getMessage());
        }
    }

    private void listStations(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        List<Station> stations = stationDAO.getAllStations();
        request.setAttribute("stations", stations);
        request.getRequestDispatcher("/views/stations.jsp").forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/station-form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        UUID stationId = UUID.fromString(request.getParameter("id"));
        Station station = stationDAO.getStationById(stationId);

        if (station != null) {
            request.setAttribute("station", station);
            request.getRequestDispatcher("/views/station-form.jsp").forward(request, response);
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
        request.getRequestDispatcher("/views/stations.jsp").forward(request, response);
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
        request.getRequestDispatcher("/views/error.jsp").forward(request, response);
    }
}
