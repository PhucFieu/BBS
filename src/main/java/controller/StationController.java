package controller;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;
import java.util.List;
import java.util.UUID;

import dao.CityDAO;
import dao.RouteDAO;
import dao.RouteStationDAO;
import dao.StationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.City;
import model.Routes;
import model.Station;
import util.AuthUtils;
import util.StringUtils;

@WebServlet(urlPatterns = {"/stations/*", "/admin/stations/*"})
public class StationController extends HttpServlet {

    private StationDAO stationDAO;
    private CityDAO cityDAO;
    private RouteDAO routeDAO;
    private RouteStationDAO routeStationDAO;

    @Override
    public void init() throws ServletException {
        stationDAO = new StationDAO();
        cityDAO = new CityDAO();
        routeDAO = new RouteDAO();
        routeStationDAO = new RouteStationDAO();
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
        if (pathInfo == null)
            pathInfo = "/";

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
            request.getRequestDispatcher("/views/stations/station-form.jsp").forward(request,
                    response);
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
        if (StringUtils.isBlank(stationName)) {
            response.sendRedirect(
                    request.getContextPath() + "/stations/add?error=Station name is required");
            return;
        }
        // Normalize station name - remove extra spaces to prevent duplicates with different spacing
        stationName = StringUtils.normalizeSpaces(stationName);

        if (stationDAO.isStationNameTaken(stationName)) {
            response.sendRedirect(request.getContextPath()
                    + "/stations/add?error=Error: A station with this name already exists");
            return;
        }

        // Create new station
        Station station = new Station(stationName, city, address);

        // Save to database
        boolean success = stationDAO.addStation(station);

        if (success) {
            response.sendRedirect(
                    request.getContextPath() + "/stations?message=Station added successfully");
        } else {
            response.sendRedirect(
                    request.getContextPath() + "/stations/add?error=Failed to add station");
        }
    }

    private void updateStation(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        // Get parameters from request
        UUID stationId = UUID.fromString(request.getParameter("stationId"));
        String stationName = request.getParameter("stationName");
        String city = request.getParameter("city");
        String address = request.getParameter("address");

        if (StringUtils.isBlank(stationName)) {
            response.sendRedirect(
                    request.getContextPath() + "/stations/edit?id=" + stationId
                            + "&error=Station name is required");
            return;
        }

        // Normalize station name - remove extra spaces to prevent duplicates with different spacing
        stationName = StringUtils.normalizeSpaces(stationName);

        if (stationDAO.isStationNameTaken(stationName, stationId)) {
            response.sendRedirect(request.getContextPath() + "/stations/edit?id=" + stationId
                    + "&error=Error: A station with this name already exists");
            return;
        }

        // Create station object
        Station station = new Station(stationName, city, address);
        station.setStationId(stationId);

        // Update in database
        boolean success = stationDAO.updateStation(station);

        if (success) {
            response.sendRedirect(
                    request.getContextPath() + "/stations?message=Station updated successfully");
        } else {
            response.sendRedirect(
                    request.getContextPath() + "/stations/edit?id=" + stationId
                            + "&error=Failed to update station");
        }
    }

    private void deleteStation(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        UUID stationId = UUID.fromString(request.getParameter("id"));
        boolean success = stationDAO.deleteStation(stationId);

        if (success) {
            response.sendRedirect(
                    request.getContextPath() + "/stations?message=Station deleted successfully");
        } else {
            response.sendRedirect(
                    request.getContextPath() + "/stations?error=Failed to delete station");
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

    private void handleError(HttpServletRequest request, HttpServletResponse response,
            String message)
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
        try {
            request.setAttribute("cities", cityDAO.getAllCities());
        } catch (SQLException e) {
            // If loading cities fails, still show form with an error message
            request.setAttribute("error", "Unable to load cities: " + e.getMessage());
        }
        request.getRequestDispatcher("/views/admin/station-form.jsp").forward(request, response);
    }

    private void adminShowEditForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        String stationIdStr = request.getParameter("id");
        if (stationIdStr == null || stationIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath()
                    + "/admin/stations?error=Missing information: Station ID is required");
            return;
        }
        try {
            UUID stationId = UUID.fromString(stationIdStr);
            Station station = stationDAO.getStationById(stationId);
            if (station != null) {
                request.setAttribute("station", station);
                try {
                    request.setAttribute("cities", cityDAO.getAllCities());
                } catch (SQLException e) {
                    request.setAttribute("error", "Unable to load cities: " + e.getMessage());
                }
                request.getRequestDispatcher("/views/admin/station-form.jsp").forward(request,
                        response);
            } else {
                response.sendRedirect(request.getContextPath()
                        + "/admin/stations?error=Error: Station not found with the given ID");
            }
        } catch (IllegalArgumentException e) {
            response.sendRedirect(request.getContextPath()
                    + "/admin/stations?error=Error: Invalid station ID format. Please check again");
        }
    }

    private void adminAddStation(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String stationName = request.getParameter("stationName");
        String cityIdStr = request.getParameter("cityId");
        String address = request.getParameter("address");
        String status = request.getParameter("status");

        // Validate input with specific error messages
        if (StringUtils.isBlank(stationName)) {
            response.sendRedirect(request.getContextPath()
                    + "/admin/stations/add?error=Missing information: Station name is required");
            return;
        }
        if (StringUtils.isBlank(cityIdStr)) {
            response.sendRedirect(request.getContextPath()
                    + "/admin/stations/add?error=Missing information: City is required");
            return;
        }
        if (StringUtils.isBlank(address)) {
            response.sendRedirect(request.getContextPath()
                    + "/admin/stations/add?error=Missing information: Address is required");
            return;
        }

        try {
            // Normalize station name - remove extra spaces to prevent duplicates with different spacing
            stationName = StringUtils.normalizeSpaces(stationName);
            address = address.trim();
            UUID cityId = UUID.fromString(cityIdStr.trim());

            if (stationDAO.isStationNameTaken(stationName)) {
                response.sendRedirect(request.getContextPath()
                        + "/admin/stations/add?error=Error: Station name already exists. Please choose another name");
                return;
            }

            Station station = new Station(stationName, cityId, address);
            if (status != null && !status.trim().isEmpty()) {
                station.setStatus(status.trim());
            }
            boolean success = stationDAO.addStation(station);
            if (success) {
                // Sync route-stations for all routes that include this city in their range
                try {
                    syncRoutesForCity(cityId);
                } catch (Exception e) {
                    // Do not block adding station if sync fails; just log via redirect message
                }
                String message = "Station added successfully! Station " + stationName
                        + " has been added to the system";
                response.sendRedirect(request.getContextPath() + "/admin/stations?message="
                        + URLEncoder.encode(message, StandardCharsets.UTF_8));
            } else {
                response.sendRedirect(request.getContextPath()
                        + "/admin/stations/add?error=Error: Failed to add station. Please try again or contact administrator");
            }
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath()
                    + "/admin/stations/add?error=Error: An unexpected error occurred. "
                    + e.getMessage());
        }
    }

    private void adminUpdateStation(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String stationIdStr = request.getParameter("stationId");
        String stationName = request.getParameter("stationName");
        String cityIdStr = request.getParameter("cityId");
        String address = request.getParameter("address");
        String status = request.getParameter("status");

        // Validate input with specific error messages
        if (StringUtils.isBlank(stationIdStr)) {
            response.sendRedirect(request.getContextPath()
                    + "/admin/stations?error=Missing information: Station ID is required");
            return;
        }
        if (StringUtils.isBlank(stationName)) {
            response.sendRedirect(request.getContextPath() + "/admin/stations/edit?id="
                    + stationIdStr + "&error=Missing information: Station name is required");
            return;
        }
        if (StringUtils.isBlank(cityIdStr)) {
            response.sendRedirect(request.getContextPath() + "/admin/stations/edit?id="
                    + stationIdStr + "&error=Missing information: City is required");
            return;
        }
        if (StringUtils.isBlank(address)) {
            response.sendRedirect(request.getContextPath() + "/admin/stations/edit?id="
                    + stationIdStr + "&error=Missing information: Address is required");
            return;
        }

        try {
            UUID stationId = UUID.fromString(stationIdStr);
            Station existingStation = stationDAO.getStationById(stationId);
            if (existingStation == null) {
                response.sendRedirect(request.getContextPath()
                        + "/admin/stations?error=Error: Station not found with the given ID");
                return;
            }
            // Normalize station name - remove extra spaces to prevent duplicates with different spacing
            stationName = StringUtils.normalizeSpaces(stationName);
            address = address.trim();
            UUID cityId = UUID.fromString(cityIdStr.trim());

            if (stationDAO.isStationNameTaken(stationName, stationId)) {
                response.sendRedirect(request.getContextPath() + "/admin/stations/edit?id="
                        + stationIdStr
                        + "&error=Error: Station name already exists. Please choose another name");
                return;
            }

            existingStation.setStationName(stationName);
            existingStation.setCityId(cityId);
            existingStation.setAddress(address);
            if (status != null && !status.trim().isEmpty()) {
                existingStation.setStatus(status.trim());
            }
            boolean success = stationDAO.updateStation(existingStation);
            if (success) {
                // If city has changed, sync routes for both old and new city
                try {
                    UUID oldCityId = existingStation.getCityId();
                    if (oldCityId != null && !oldCityId.equals(cityId)) {
                        syncRoutesForCity(oldCityId);
                    }
                    syncRoutesForCity(cityId);
                } catch (Exception e) {
                    // Ignore sync errors here to avoid breaking station update
                }
                String message = "Station updated successfully! Station " + stationName
                        + " information has been saved";
                response.sendRedirect(request.getContextPath() + "/admin/stations?message="
                        + URLEncoder.encode(message, StandardCharsets.UTF_8));
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/stations/edit?id="
                        + stationIdStr
                        + "&error=Error: Failed to update station. Please try again or contact administrator");
            }
        } catch (IllegalArgumentException e) {
            response.sendRedirect(request.getContextPath()
                    + "/admin/stations?error=Error: Invalid station ID format. Please check again");
        } catch (Exception e) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/stations/edit?id=" + stationIdStr
                            + "&error=Error: An unexpected error occurred. " + e.getMessage());
        }
    }

    private void adminDeleteStation(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String stationIdStr = request.getParameter("id");
        if (stationIdStr == null || stationIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath()
                    + "/admin/stations?error=Missing information: Station ID is required");
            return;
        }
        try {
            UUID stationId = UUID.fromString(stationIdStr);
            Station station = stationDAO.getStationById(stationId);
            String stationName = station != null ? station.getStationName() : "Station";
            boolean success = stationDAO.deleteStation(stationId);
            if (success) {
                // When a station is deactivated, sync routes for its city so route-stations drop it
                try {
                    UUID cityId = station != null ? station.getCityId() : null;
                    if (cityId != null) {
                        syncRoutesForCity(cityId);
                    }
                } catch (Exception e) {
                    // Ignore sync errors for delete as well
                }
                String message = "Station deleted successfully! Station " + stationName
                        + " has been removed from the system";
                response.sendRedirect(request.getContextPath() + "/admin/stations?message="
                        + URLEncoder.encode(message, StandardCharsets.UTF_8));
            } else {
                response.sendRedirect(request.getContextPath()
                        + "/admin/stations?error=Error: Failed to delete station. The station may be in use or does not exist");
            }
        } catch (IllegalArgumentException e) {
            response.sendRedirect(request.getContextPath()
                    + "/admin/stations?error=Error: Invalid station ID format. Please check again");
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath()
                    + "/admin/stations?error=Error: An unexpected error occurred while deleting the station. "
                    + e.getMessage());
        }
    }

    /**
     * Sync RouteStations for all routes whose city range includes the given city.
     * This keeps route templates in sync when stations are added/updated/deleted.
     */
    private void syncRoutesForCity(UUID cityId) throws SQLException {
        if (cityId == null) {
            return;
        }

        City city = cityDAO.getCityById(cityId);
        if (city == null) {
            return;
        }
        int targetCityNumber = city.getCityNumber();

        // Load all routes (any status) and find those whose city_number range covers this city
        List<Routes> allRoutes = routeDAO.getAllRoutesAnyStatus();
        if (allRoutes == null || allRoutes.isEmpty()) {
            return;
        }

        for (Routes route : allRoutes) {
            City depCity = route.getDepartureCityObj();
            City destCity = route.getDestinationCityObj();

            if (depCity == null && route.getDepartureCityId() != null) {
                depCity = cityDAO.getCityById(route.getDepartureCityId());
            }
            if (destCity == null && route.getDestinationCityId() != null) {
                destCity = cityDAO.getCityById(route.getDestinationCityId());
            }

            if (depCity == null || destCity == null) {
                continue;
            }

            int fromNum = depCity.getCityNumber();
            int toNum = destCity.getCityNumber();
            int minNum = Math.min(fromNum, toNum);
            int maxNum = Math.max(fromNum, toNum);

            if (targetCityNumber < minNum || targetCityNumber > maxNum) {
                // This route does not logically include the city
                continue;
            }

            // Rebuild route-stations for this route based on current city/station data
            rebuildRouteStationsForRoute(route, depCity, destCity);
        }
    }

    /**
     * Rebuild RouteStations for a single route using the same logic as in RouteController.
     */
    private void rebuildRouteStationsForRoute(Routes route, City departureCity,
            City destinationCity)
            throws SQLException {
        if (route == null || departureCity == null || destinationCity == null) {
            return;
        }

        List<City> citiesInRange =
                cityDAO.getCitiesInRange(departureCity.getCityNumber(),
                        destinationCity.getCityNumber());
        if (citiesInRange == null || citiesInRange.isEmpty()) {
            return;
        }

        List<UUID> cityIds = new java.util.ArrayList<>();
        for (City c : citiesInRange) {
            cityIds.add(c.getCityId());
        }

        List<Station> stationsInRange = stationDAO.getStationsByCityIds(cityIds);
        if (stationsInRange == null || stationsInRange.size() < 2) {
            // Not enough active stations to build a route; skip silently
            return;
        }

        List<UUID> orderedStationIds = new java.util.ArrayList<>();
        for (Station s : stationsInRange) {
            orderedStationIds.add(s.getStationId());
        }

        routeStationDAO.updateRouteStations(route.getRouteId(), orderedStationIds);
    }
}
