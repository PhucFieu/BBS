package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.regex.Pattern;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

import dao.RouteDAO;
import dao.RouteStationDAO;
import dao.StationDAO;
import dto.RouteStationRequestDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Routes;
import model.Station;
import util.AuthUtils;

@WebServlet(urlPatterns = {"/routes/*", "/admin/routes/*"})
public class RouteController extends HttpServlet {
    private RouteDAO routeDAO;
    private RouteStationDAO routeStationDAO;
    private StationDAO stationDAO;
    private final Gson gson = new Gson();

    // Validation patterns
    // Distance: positive decimal number (e.g., 100.5, 250)
    private static final Pattern DISTANCE_PATTERN = Pattern.compile("^[0-9]+(\\.[0-9]{1,2})?$");
    // Duration: positive decimal number (e.g., 0.5, 1, 2.5, 10) - format validation, value >= 0.5
    // checked separately
    private static final Pattern DURATION_PATTERN =
            Pattern.compile("^([0-9]+(\\.[0-9]{1,2})?|0\\.[0-9]{1,2})$");
    // Base price: positive integer, minimum 1000 (e.g., 1000, 50000, 100000)
    private static final Pattern BASE_PRICE_PATTERN = Pattern.compile("^[1-9][0-9]{3,}$");

    @Override
    public void init() throws ServletException {
        routeDAO = new RouteDAO();
        routeStationDAO = new RouteStationDAO();
        stationDAO = new StationDAO();
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
                // Admin-only routes management UI
                if (!AuthUtils.isAdmin(request.getSession(false))) {
                    request.setAttribute("error", "You do not have permission to access this page");
                    request.getRequestDispatcher("/views/errors/403.jsp").forward(request,
                            response);
                    return;
                }
                if ("/".equals(pathInfo)) {
                    listRoutes(request, response);
                } else if ("/add".equals(pathInfo)) {
                    showAddForm(request, response);
                } else if ("/edit".equals(pathInfo)) {
                    showEditForm(request, response);
                } else if ("/delete".equals(pathInfo)) {
                    deleteRoute(request, response);
                } else if ("/detail".equals(pathInfo)) {
                    getRouteDetails(request, response);
                } else if ("/search".equals(pathInfo)) {
                    searchRoutes(request, response);
                } else {
                    getRouteById(request, response);
                }
            } else {
                // Public/driver access
                if ("/search".equals(pathInfo)) {
                    searchRoutes(request, response);
                    return;
                }
                boolean isAdmin = AuthUtils.isAdmin(request.getSession(false));
                boolean isDriver = AuthUtils.isDriver(request.getSession(false));
                if ("/".equals(pathInfo)) {
                    if (!isAdmin && !isDriver) {
                        request.setAttribute("error",
                                "You do not have permission to access this page");
                        request.getRequestDispatcher("/views/errors/403.jsp").forward(request,
                                response);
                        return;
                    }
                    listRoutes(request, response);
                } else if ("/add".equals(pathInfo)) {
                    if (!isAdmin) {
                        request.setAttribute("error",
                                "You do not have permission to access this page");
                        request.getRequestDispatcher("/views/errors/403.jsp").forward(request,
                                response);
                        return;
                    }
                    showAddForm(request, response);
                } else if ("/edit".equals(pathInfo)) {
                    if (!isAdmin) {
                        request.setAttribute("error",
                                "You do not have permission to access this page");
                        request.getRequestDispatcher("/views/errors/403.jsp").forward(request,
                                response);
                        return;
                    }
                    showEditForm(request, response);
                } else if ("/delete".equals(pathInfo)) {
                    if (!isAdmin) {
                        request.setAttribute("error",
                                "You do not have permission to access this page");
                        request.getRequestDispatcher("/views/errors/403.jsp").forward(request,
                                response);
                        return;
                    }
                    deleteRoute(request, response);
                } else if ("/detail".equals(pathInfo)) {
                    if (!isAdmin && !isDriver) {
                        request.setAttribute("error",
                                "You do not have permission to access this page");
                        request.getRequestDispatcher("/views/errors/403.jsp").forward(request,
                                response);
                        return;
                    }
                    getRouteDetails(request, response);
                } else {
                    if (!isAdmin && !isDriver) {
                        request.setAttribute("error",
                                "You do not have permission to access this page");
                        request.getRequestDispatcher("/views/errors/403.jsp").forward(request,
                                response);
                        return;
                    }
                    getRouteById(request, response);
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
                if (!AuthUtils.isAdmin(request.getSession(false))) {
                    request.setAttribute("error", "You do not have permission to access this page");
                    request.getRequestDispatcher("/views/errors/403.jsp").forward(request,
                            response);
                    return;
                }
                if ("/add".equals(pathInfo)) {
                    addRoute(request, response);
                } else if ("/edit".equals(pathInfo)) {
                    updateRoute(request, response);
                } else if ("/search".equals(pathInfo)) {
                    searchRoutes(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                }
            } else {
                if ("/search".equals(pathInfo)) {
                    searchRoutes(request, response);
                } else if ("/add".equals(pathInfo) || "/edit".equals(pathInfo)) {
                    if (!AuthUtils.isAdmin(request.getSession(false))) {
                        request.setAttribute("error",
                                "You do not have permission to access this page");
                        request.getRequestDispatcher("/views/errors/403.jsp").forward(request,
                                response);
                        return;
                    }
                    if ("/add".equals(pathInfo))
                        addRoute(request, response);
                    else
                        updateRoute(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                }
            }
        } catch (SQLException e) {
            handleError(request, response, "Database error: " + e.getMessage());
        }
    }

    private void listRoutes(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        // Always show only active routes (inactive routes are hidden)
        List<Routes> routes = routeDAO.getAllRoutes();
        request.setAttribute("routes", routes);
        if (AuthUtils.isAdmin(request.getSession(false))) {
            request.getRequestDispatcher("/views/routes/routes.jsp").forward(request, response);
        } else {
            // For DRIVER/USER, show the public/search-oriented page instead of admin UI
            request.getRequestDispatcher("/views/routes/route-search.jsp").forward(request,
                    response);
        }
    }

    private void getRouteDetails(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        JsonObject result = new JsonObject();
        String routeIdStr = request.getParameter("id");

        try (PrintWriter writer = response.getWriter()) {
            if (routeIdStr == null || routeIdStr.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                result.addProperty("success", false);
                result.addProperty("message", "Route ID is required");
                writer.write(gson.toJson(result));
                return;
            }

            try {
                UUID routeId = UUID.fromString(routeIdStr);
                boolean isAdmin = AuthUtils.isAdmin(request.getSession(false));
                Routes route = isAdmin ? routeDAO.getRouteByIdAnyStatus(routeId)
                        : routeDAO.getRouteById(routeId);

                if (route == null) {
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    result.addProperty("success", false);
                    result.addProperty("message", "Route not found");
                    writer.write(gson.toJson(result));
                    return;
                }

                List<Station> stations = routeStationDAO.getStationsByRouteAsStations(routeId);

                JsonObject routeJson = new JsonObject();
                routeJson.addProperty("routeId", route.getRouteId().toString());
                routeJson.addProperty("routeName", route.getRouteName());
                routeJson.addProperty("departureCity", route.getDepartureCity());
                routeJson.addProperty("destinationCity", route.getDestinationCity());
                routeJson.addProperty("distance",
                        route.getDistance() == null ? null : route.getDistance().toPlainString());
                routeJson.addProperty("durationHours", route.getDurationHours());
                routeJson.addProperty("basePrice",
                        route.getBasePrice() == null ? null : route.getBasePrice().toPlainString());
                routeJson.addProperty("status", route.getStatus());

                JsonArray stationsArray = new JsonArray();
                int order = 1;
                for (Station station : stations) {
                    JsonObject stationJson = new JsonObject();
                    stationJson.addProperty("stationId",
                            station.getStationId() == null ? null
                                    : station.getStationId().toString());
                    stationJson.addProperty("stationName", station.getStationName());
                    stationJson.addProperty("city", station.getCity());
                    stationJson.addProperty("address", station.getAddress());
                    stationJson.addProperty("order", order++);
                    stationsArray.add(stationJson);
                }

                result.addProperty("success", true);
                result.add("route", routeJson);
                result.add("stations", stationsArray);
                writer.write(gson.toJson(result));
            } catch (IllegalArgumentException e) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                result.addProperty("success", false);
                result.addProperty("message", "Invalid route ID format");
                writer.write(gson.toJson(result));
            }
        }
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        // Load all active stations for selection
        List<Station> stations = stationDAO.getAllStations();
        request.setAttribute("stations", stations);
        request.getRequestDispatcher("/views/routes/route-form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        String routeIdStr = request.getParameter("id");
        if (routeIdStr == null || routeIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/routes?error="
                    + encodeParam("Missing information: Route ID is required"));
            return;
        }
        try {
            UUID routeId = UUID.fromString(routeIdStr);
            Routes route = routeDAO.getRouteByIdAnyStatus(routeId);

            if (route != null) {
                request.setAttribute("route", route);
                // Load all active stations
                List<Station> allStations = stationDAO.getAllStations();
                request.setAttribute("stations", allStations);
                // Load route stations
                List<Station> routeStations = routeStationDAO.getStationsByRouteAsStations(routeId);
                request.setAttribute("routeStations", routeStations);
                request.getRequestDispatcher("/views/routes/route-form.jsp").forward(request,
                        response);
            } else {
                response.sendRedirect(request.getContextPath() + "/routes?error="
                        + encodeParam("Error: Route not found with the given ID"));
            }
        } catch (IllegalArgumentException e) {
            response.sendRedirect(request.getContextPath() + "/routes?error="
                    + encodeParam("Error: Invalid route ID format. Please check again"));
        }
    }

    private void addRoute(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        // Get parameters from request
        String routeName = request.getParameter("routeName");
        String distanceStr = request.getParameter("distance");
        String durationHoursStr = request.getParameter("durationHours");
        String basePriceStr = request.getParameter("basePrice");
        // Validate input with specific error messages
        if (routeName == null || routeName.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/routes/add?error="
                    + encodeParam("Missing information: Route name is required"));
            return;
        }
        if (distanceStr == null || distanceStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/routes/add?error="
                    + encodeParam("Missing information: Distance is required"));
            return;
        }
        if (durationHoursStr == null || durationHoursStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/routes/add?error="
                    + encodeParam("Missing information: Duration hours is required"));
            return;
        }
        if (basePriceStr == null || basePriceStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/routes/add?error="
                    + encodeParam("Missing information: Base price is required"));
            return;
        }

        // Validate distance format
        if (!DISTANCE_PATTERN.matcher(distanceStr.trim()).matches()) {
            response.sendRedirect(request.getContextPath() + "/routes/add?error="
                    + encodeParam(
                            "Error: Invalid distance format. Distance must be a positive number (e.g., 100.5, 250)"));
            return;
        }

        // Validate duration format
        if (!DURATION_PATTERN.matcher(durationHoursStr.trim()).matches()) {
            response.sendRedirect(request.getContextPath() + "/routes/add?error="
                    + encodeParam(
                            "Error: Invalid duration format. Duration must be a positive number, minimum 0.5 (e.g., 0.5, 1, 2.5)"));
            return;
        }

        // Validate base price format
        if (!BASE_PRICE_PATTERN.matcher(basePriceStr.trim()).matches()) {
            response.sendRedirect(request.getContextPath() + "/routes/add?error="
                    + encodeParam(
                            "Error: Invalid base price format. Base price must be a positive integer, minimum 1000 (e.g., 1000, 50000)"));
            return;
        }

        try {
            RouteStationRequestDTO stationRequest = buildStationRequest(request);
            BigDecimal distance = new BigDecimal(distanceStr.trim());
            double durationHoursDouble = Double.parseDouble(durationHoursStr.trim());

            // Additional validation: distance must be > 0
            if (distance.compareTo(BigDecimal.ZERO) <= 0) {
                response.sendRedirect(request.getContextPath() + "/routes/add?error="
                        + encodeParam("Error: Distance must be greater than 0"));
                return;
            }

            // Additional validation: duration must be >= 0.5
            if (durationHoursDouble < 0.5) {
                response.sendRedirect(request.getContextPath() + "/routes/add?error="
                        + encodeParam("Error: Duration must be at least 0.5 hours"));
                return;
            }

            int durationHours = (int) Math.round(durationHoursDouble);
            if (durationHours < 1) {
                durationHours = 1; // Minimum 1 hour if less than 1
            }

            BigDecimal basePrice = new BigDecimal(basePriceStr.trim());

            // Additional validation: base price must be >= 1000
            if (basePrice.compareTo(new BigDecimal("1000")) < 0) {
                response.sendRedirect(request.getContextPath() + "/routes/add?error="
                        + encodeParam("Error: Base price must be at least 1000"));
                return;
            }

            Station departureStation = stationRequest.getDepartureStation();
            Station destinationStation = stationRequest.getDestinationStation();

            if (departureStation == null || destinationStation == null) {
                throw new IllegalArgumentException(
                        "Unable to resolve terminal stations. Please reselect them.");
            }

            // Create new route
            Routes route = new Routes(routeName.trim(), departureStation.getCity(),
                    destinationStation.getCity(), distance, durationHours, basePrice);

            // Save to database
            boolean success = routeDAO.addRoute(route);

            if (success) {
                // Handle station selection
                routeStationDAO.updateRouteStations(route.getRouteId(),
                        stationRequest.getOrderedStationIds());

                response.sendRedirect(request.getContextPath()
                        + "/routes?message="
                        + encodeParam("Route added successfully! Route " + routeName
                                + " has been added to the system"));
            } else {
                response.sendRedirect(request.getContextPath()
                        + "/routes/add?error="
                        + encodeParam(
                                "Error: Failed to add route. Please try again or contact administrator"));
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath()
                    + "/routes/add?error="
                    + encodeParam(
                            "Error: Invalid number format. Please check distance, duration, and price fields"));
        } catch (IllegalArgumentException e) {
            response.sendRedirect(request.getContextPath() + "/routes/add?error="
                    + encodeParam("Error: " + e.getMessage()));
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/routes/add?error="
                    + encodeParam("Error: An unexpected error occurred. " + e.getMessage()));
        }
    }

    private void updateRoute(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        // Get parameters from request
        String routeIdStr = request.getParameter("routeId");
        String routeName = request.getParameter("routeName");
        String distanceStr = request.getParameter("distance");
        String durationHoursStr = request.getParameter("durationHours");
        String basePriceStr = request.getParameter("basePrice");
        // Validate input with specific error messages
        if (routeIdStr == null || routeIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/routes?error="
                    + encodeParam("Missing information: Route ID is required"));
            return;
        }
        if (routeName == null || routeName.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/routes/edit?id=" + routeIdStr
                    + "&error=" + encodeParam("Missing information: Route name is required"));
            return;
        }
        if (distanceStr == null || distanceStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/routes/edit?id=" + routeIdStr
                    + "&error=" + encodeParam("Missing information: Distance is required"));
            return;
        }
        if (durationHoursStr == null || durationHoursStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/routes/edit?id=" + routeIdStr
                    + "&error="
                    + encodeParam("Missing information: Duration hours is required"));
            return;
        }
        if (basePriceStr == null || basePriceStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/routes/edit?id=" + routeIdStr
                    + "&error="
                    + encodeParam("Missing information: Base price is required"));
            return;
        }

        // Validate distance format
        if (!DISTANCE_PATTERN.matcher(distanceStr.trim()).matches()) {
            response.sendRedirect(request.getContextPath() + "/routes/edit?id=" + routeIdStr
                    + "&error="
                    + encodeParam(
                            "Error: Invalid distance format. Distance must be a positive number (e.g., 100.5, 250)"));
            return;
        }

        // Validate duration format
        if (!DURATION_PATTERN.matcher(durationHoursStr.trim()).matches()) {
            response.sendRedirect(request.getContextPath() + "/routes/edit?id=" + routeIdStr
                    + "&error="
                    + encodeParam(
                            "Error: Invalid duration format. Duration must be a positive number, minimum 0.5 (e.g., 0.5, 1, 2.5)"));
            return;
        }

        // Validate base price format
        if (!BASE_PRICE_PATTERN.matcher(basePriceStr.trim()).matches()) {
            response.sendRedirect(request.getContextPath() + "/routes/edit?id=" + routeIdStr
                    + "&error="
                    + encodeParam(
                            "Error: Invalid base price format. Base price must be a positive integer, minimum 1000 (e.g., 1000, 50000)"));
            return;
        }

        try {
            UUID routeId = UUID.fromString(routeIdStr);
            BigDecimal distance = new BigDecimal(distanceStr.trim());
            double durationHoursDouble = Double.parseDouble(durationHoursStr.trim());

            // Additional validation: distance must be > 0
            if (distance.compareTo(BigDecimal.ZERO) <= 0) {
                response.sendRedirect(
                        request.getContextPath() + "/routes/edit?id=" + routeIdStr + "&error="
                                + encodeParam("Error: Distance must be greater than 0"));
                return;
            }

            // Additional validation: duration must be >= 0.5
            if (durationHoursDouble < 0.5) {
                response.sendRedirect(
                        request.getContextPath() + "/routes/edit?id=" + routeIdStr + "&error="
                                + encodeParam("Error: Duration must be at least 0.5 hours"));
                return;
            }

            int durationHours = (int) Math.round(durationHoursDouble);
            if (durationHours < 1) {
                durationHours = 1; // Minimum 1 hour if less than 1
            }

            BigDecimal basePrice = new BigDecimal(basePriceStr.trim());

            // Additional validation: base price must be >= 1000
            if (basePrice.compareTo(new BigDecimal("1000")) < 0) {
                response.sendRedirect(
                        request.getContextPath() + "/routes/edit?id=" + routeIdStr + "&error="
                                + encodeParam("Error: Base price must be at least 1000"));
                return;
            }

            RouteStationRequestDTO stationRequest = buildStationRequest(request);

            Routes existingRoute = routeDAO.getRouteById(routeId);
            if (existingRoute == null) {
                response.sendRedirect(request.getContextPath() + "/routes?error="
                        + encodeParam("Error: Route not found with the given ID"));
                return;
            }

            Station departureStation = stationRequest.getDepartureStation();
            Station destinationStation = stationRequest.getDestinationStation();
            if (departureStation == null || destinationStation == null) {
                throw new IllegalArgumentException(
                        "Unable to resolve terminal stations. Please reselect them.");
            }

            // Create route object
            Routes route = new Routes(routeName.trim(), departureStation.getCity(),
                    destinationStation.getCity(), distance, durationHours, basePrice);
            route.setRouteId(routeId);

            // Update in database
            boolean success = routeDAO.updateRoute(route);

            if (success) {
                // Handle station selection
                routeStationDAO.updateRouteStations(routeId,
                        stationRequest.getOrderedStationIds());

                response.sendRedirect(request.getContextPath()
                        + "/routes?message="
                        + encodeParam("Route updated successfully! Route " + routeName
                                + " information has been saved"));
            } else {
                response.sendRedirect(
                        request.getContextPath() + "/routes/edit?id=" + routeIdStr
                                + "&error=" + encodeParam(
                                        "Error: Failed to update route. Please try again or contact administrator"));
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/routes/edit?id=" + routeIdStr
                    + "&error=" + encodeParam(
                            "Error: Invalid number format. Please check distance, duration, and price fields"));
        } catch (IllegalArgumentException e) {
            response.sendRedirect(request.getContextPath() + "/routes/edit?id=" + routeIdStr
                    + "&error=" + encodeParam("Error: " + e.getMessage()));
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/routes/edit?id=" + routeIdStr
                    + "&error="
                    + encodeParam("Error: An unexpected error occurred. " + e.getMessage()));
        }
    }

    private RouteStationRequestDTO buildStationRequest(HttpServletRequest request)
            throws SQLException {
        String departureStationIdStr = request.getParameter("departureStationId");
        String destinationStationIdStr = request.getParameter("destinationStationId");
        String[] orderedStationIdsRaw = request.getParameterValues("stationIds");

        List<UUID> orderedStationIds = new ArrayList<>();
        if (orderedStationIdsRaw != null) {
            for (String stationIdStr : orderedStationIdsRaw) {
                if (stationIdStr == null || stationIdStr.trim().isEmpty()) {
                    continue;
                }
                orderedStationIds.add(parseUuidStrict(stationIdStr));
            }
        }

        UUID departureStationId = parseUuidOptional(departureStationIdStr, "departure station");
        UUID destinationStationId =
                parseUuidOptional(destinationStationIdStr, "destination station");

        RouteStationRequestDTO stationRequest =
                new RouteStationRequestDTO(departureStationId, destinationStationId,
                        orderedStationIds);
        stationRequest.validateAndResolve(stationDAO);
        return stationRequest;
    }

    private UUID parseUuidOptional(String rawValue, String fieldName) {
        if (rawValue == null || rawValue.trim().isEmpty()) {
            return null;
        }
        try {
            return UUID.fromString(rawValue.trim());
        } catch (IllegalArgumentException e) {
            throw new IllegalArgumentException("Invalid " + fieldName + " format");
        }
    }

    private UUID parseUuidStrict(String rawValue) {
        if (rawValue == null || rawValue.trim().isEmpty()) {
            throw new IllegalArgumentException("Station sequence contains an empty value");
        }
        try {
            return UUID.fromString(rawValue.trim());
        } catch (IllegalArgumentException e) {
            throw new IllegalArgumentException(
                    "Invalid station identifier in the ordered sequence");
        }
    }

    private void deleteRoute(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String routeIdStr = request.getParameter("id");
        if (routeIdStr == null || routeIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/routes?error="
                    + encodeParam("Missing information: Route ID is required"));
            return;
        }

        try {
            UUID routeId = UUID.fromString(routeIdStr);
            Routes route = routeDAO.getRouteById(routeId);

            if (route == null) {
                response.sendRedirect(request.getContextPath() + "/routes?error="
                        + encodeParam("Error: Route not found with the given ID"));
                return;
            }

            String routeName = route.getRouteName();

            // Check if route is assigned to any schedules
            if (routeDAO.isRouteAssignedToSchedule(routeId)) {
                String errorMsg = URLEncoder.encode(
                        "Cannot delete route! Route \"" + routeName
                                + "\" has been assigned to schedules. Please delete or cancel related schedules before deleting this route.",
                        StandardCharsets.UTF_8);
                response.sendRedirect(request.getContextPath()
                        + "/routes?error=" + errorMsg);
                return;
            }

            boolean success = routeDAO.deleteRoute(routeId);

            if (success) {
                response.sendRedirect(request.getContextPath()
                        + "/routes?message="
                        + encodeParam("Route deleted successfully! Route " + routeName
                                + " has been removed from the system"));
            } else {
                response.sendRedirect(request.getContextPath()
                        + "/routes?error="
                        + encodeParam(
                                "Error: Failed to delete route. The route may be in use or does not exist"));
            }
        } catch (IllegalArgumentException e) {
            response.sendRedirect(request.getContextPath() + "/routes?error="
                    + encodeParam("Error: Invalid route ID format. Please check again"));
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/routes?error=" + encodeParam(
                    "Error: An unexpected error occurred while deleting the route. "
                            + e.getMessage()));
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
        request.getRequestDispatcher("/views/routes/routes.jsp").forward(request, response);
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

    private void handleError(HttpServletRequest request, HttpServletResponse response,
            String message)
            throws ServletException, IOException {
        request.setAttribute("error", message);
        request.getRequestDispatcher("/views/errors/error.jsp").forward(request, response);
    }

    private String encodeParam(String value) {
        return URLEncoder.encode(value == null ? "" : value, StandardCharsets.UTF_8);
    }
}
