package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

import dao.RouteDAO;
import dao.ScheduleDAO;
import dao.StationDAO;
import dao.CityDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Routes;
import model.Schedule;
import model.Station;
import model.City;

@WebServlet("/search/*")
public class RouteSearchController extends HttpServlet {

    private RouteDAO routeDAO;
    private ScheduleDAO scheduleDAO;
    private StationDAO stationDAO;
    private CityDAO cityDAO;

    @Override
    public void init() throws ServletException {
        routeDAO = new RouteDAO();
        scheduleDAO = new ScheduleDAO();
        stationDAO = new StationDAO();
        cityDAO = new CityDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        try {
            if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("")) {
                // Show search form
                showSearchForm(request, response);
            } else if (pathInfo.equals("/search")) {
                // Perform search
                searchRoutes(request, response);
            } else if (pathInfo.equals("/schedules")) {
                // Show schedules for a specific route
                showSchedules(request, response);
            } else if (pathInfo.equals("/stations")) {
                // Get stations for autocomplete
                getStations(request, response);
            } else if (pathInfo.equals("/routes-by-cities")) {
                // Get available routes by cities (AJAX)
                getRoutesByCities(request, response);
            } else if (pathInfo.equals("/cities")) {
                // Get all cities for dropdown (AJAX)
                getAllCities(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            handleError(request, response, "Database error: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        try {
            if (pathInfo.equals("/search")) {
                // Perform search
                searchRoutes(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            handleError(request, response, "Database error: " + e.getMessage());
        }
    }

    private void showSearchForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        // Get all stations for dropdowns
        List<Station> stations = stationDAO.getAllStations();
        request.setAttribute("stations", stations);

        // Get popular routes
        List<Routes> popularRoutes = routeDAO.getPopularRoutes();
        request.setAttribute("popularRoutes", popularRoutes);

        request.getRequestDispatcher("/views/routes/route-search.jsp").forward(request, response);
    }

    private void searchRoutes(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        String departureCity = request.getParameter("departureCity");
        String destinationCity = request.getParameter("destinationCity");
        String departureDateStr = request.getParameter("departureDate");
        String returnDateStr = request.getParameter("returnDate");
        String tripType = request.getParameter("tripType"); // "oneway" or "roundtrip"

        // Validate required parameters - only departureCity and destinationCity are
        // required
        if (departureCity == null || departureCity.trim().isEmpty()
                || destinationCity == null || destinationCity.trim().isEmpty()) {
            request.setAttribute("error", "Please enter both departure and destination cities");
            showSearchForm(request, response);
            return;
        }

        if (departureCity.trim().equalsIgnoreCase(destinationCity.trim())) {
            request.setAttribute("error", "Departure and destination cities cannot be the same");
            showSearchForm(request, response);
            return;
        }

        // Search for routes based only on cities (no date required)
        List<Routes> routes = routeDAO.searchRoutes(departureCity.trim(), destinationCity.trim());

        if (routes.isEmpty()) {
            request.setAttribute("error",
                    "Không tìm thấy tuyến đường từ " + departureCity + " đến " + destinationCity);
            request.setAttribute("showNotFoundPopup", true);
            request.setAttribute("departureCity", departureCity.trim());
            request.setAttribute("destinationCity", destinationCity.trim());
            showSearchForm(request, response);
            return;
        }

        // If departureDate is provided, filter schedules by date
        // Otherwise, show all schedules for each route
        LocalDate departureDate = null;
        if (departureDateStr != null && !departureDateStr.trim().isEmpty()) {
            try {
                departureDate = LocalDate.parse(departureDateStr);
                // Check if departure date is not in the past
                if (departureDate.isBefore(LocalDate.now())) {
                    request.setAttribute("error", "Departure date cannot be in the past");
                    showSearchForm(request, response);
                    return;
                }
            } catch (Exception e) {
                request.setAttribute("error", "Invalid date format");
                showSearchForm(request, response);
                return;
            }
        }

        // Get schedules for each route and filter out expired ones
        LocalDateTime now = LocalDateTime.now();
        dao.TicketDAO ticketDAO = new dao.TicketDAO();
        java.util.Map<UUID, Integer> bookedSeatsMap = new java.util.HashMap<>();

        for (Routes route : routes) {
            // Load station information if station IDs exist but station objects are missing
            if (route.getDepartureStationId() != null && route.getDepartureStationObj() == null) {
                try {
                    Station depStation = stationDAO.getStationById(route.getDepartureStationId());
                    if (depStation != null) {
                        route.setDepartureStationObj(depStation);
                    }
                } catch (SQLException e) {
                    // Ignore if station not found
                }
            }
            if (route.getDestinationStationId() != null && route.getDestinationStationObj() == null) {
                try {
                    Station destStation = stationDAO.getStationById(route.getDestinationStationId());
                    if (destStation != null) {
                        route.setDestinationStationObj(destStation);
                    }
                } catch (SQLException e) {
                    // Ignore if station not found
                }
            }
            List<Schedule> schedules;
            if (departureDate != null) {
                // Filter by date if provided
                schedules = scheduleDAO.getSchedulesByRouteAndDate(route.getRouteId(), departureDate);
            } else {
                // Get all schedules if no date specified
                schedules = scheduleDAO.getSchedulesByRoute(route.getRouteId());
            }
            // Filter out expired schedules (departure date + time is before now)
            schedules = schedules.stream()
                    .filter(schedule -> {
                        if (schedule.getDepartureDate() == null
                                || schedule.getDepartureTime() == null) {
                            return false;
                        }
                        LocalDateTime departureDateTime = LocalDateTime.of(
                                schedule.getDepartureDate(),
                                schedule.getDepartureTime());
                        return departureDateTime.isAfter(now);
                    })
                    .collect(Collectors.toList());

            // Get booked seats count for each schedule
            for (Schedule schedule : schedules) {
                try {
                    int bookedSeats = ticketDAO.getBookedSeatsCount(schedule.getScheduleId());
                    bookedSeatsMap.put(schedule.getScheduleId(), bookedSeats);
                } catch (SQLException e) {
                    bookedSeatsMap.put(schedule.getScheduleId(), 0);
                }
            }

            route.setSchedules(schedules);
        }

        request.setAttribute("bookedSeatsMap", bookedSeatsMap);

        request.setAttribute("routes", routes);
        request.setAttribute("departureCity", departureCity.trim());
        request.setAttribute("destinationCity", destinationCity.trim());
        if (departureDate != null) {
            request.setAttribute("departureDate", departureDateStr);
        }
        request.setAttribute("returnDate", returnDateStr);
        request.setAttribute("tripType", tripType);

        // Handle return trip if round trip
        if ("roundtrip".equals(tripType)) {
            LocalDate returnDate = null;
            if (returnDateStr != null && !returnDateStr.trim().isEmpty()) {
                try {
                    returnDate = LocalDate.parse(returnDateStr);
                    // Check if return date is not in the past
                    if (returnDate.isBefore(LocalDate.now())) {
                        request.setAttribute("error", "Return date cannot be in the past");
                        showSearchForm(request, response);
                        return;
                    }
                    // Check if return date is after departure date (if departure date is provided)
                    if (departureDate != null && returnDate.isBefore(departureDate)) {
                        request.setAttribute("error", "Return date must be after departure date");
                        showSearchForm(request, response);
                        return;
                    }
                } catch (Exception e) {
                    request.setAttribute("error", "Invalid return date format");
                    showSearchForm(request, response);
                    return;
                }
            }

            // Search for return routes (reversed)
            List<Routes> returnRoutes = routeDAO.searchRoutes(destinationCity.trim(), departureCity.trim());

            // Get schedules for return routes and filter out expired ones
            for (Routes route : returnRoutes) {
                List<Schedule> returnSchedules;
                if (returnDate != null) {
                    // Filter by return date if provided
                    returnSchedules = scheduleDAO.getSchedulesByRouteAndDate(route.getRouteId(), returnDate);
                } else {
                    // Get all schedules if no return date specified
                    returnSchedules = scheduleDAO.getSchedulesByRoute(route.getRouteId());
                }
                // Filter out expired schedules (departure date + time is before now)
                returnSchedules = returnSchedules.stream()
                        .filter(schedule -> {
                            if (schedule.getDepartureDate() == null
                                    || schedule.getDepartureTime() == null) {
                                return false;
                            }
                            LocalDateTime departureDateTime = LocalDateTime.of(
                                    schedule.getDepartureDate(),
                                    schedule.getDepartureTime());
                            return departureDateTime.isAfter(now);
                        })
                        .collect(Collectors.toList());

                // Get booked seats count for return schedules
                for (Schedule schedule : returnSchedules) {
                    try {
                        int bookedSeats = ticketDAO.getBookedSeatsCount(schedule.getScheduleId());
                        bookedSeatsMap.put(schedule.getScheduleId(), bookedSeats);
                    } catch (SQLException e) {
                        bookedSeatsMap.put(schedule.getScheduleId(), 0);
                    }
                }

                route.setSchedules(returnSchedules);
            }

            request.setAttribute("returnRoutes", returnRoutes);
        }

        // Get all stations for the search form
        List<Station> stations = stationDAO.getAllStations();
        request.setAttribute("stations", stations);

        request.getRequestDispatcher("/views/routes/route-search-results.jsp").forward(request,
                response);
    }

    private void showSchedules(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        String routeIdStr = request.getParameter("routeId");
        String departureDateStr = request.getParameter("departureDate");

        // Only routeId is required
        if (routeIdStr == null || routeIdStr.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Route ID is required");
            return;
        }

        try {
            java.util.UUID routeId = java.util.UUID.fromString(routeIdStr);

            // Verify route exists
            Routes route = routeDAO.getRouteById(routeId);
            if (route == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Route not found");
                return;
            }

            // Redirect to booking form with routeId and optional departureDate
            String redirectUrl = request.getContextPath() + "/tickets/book?routeId=" + routeIdStr;
            if (departureDateStr != null && !departureDateStr.trim().isEmpty()) {
                redirectUrl += "&departureDate=" + departureDateStr;
            }

            response.sendRedirect(redirectUrl);
        } catch (IllegalArgumentException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid route ID format");
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Error: " + e.getMessage());
        }
    }

    private void getStations(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        String query = request.getParameter("q");

        List<Station> stations;
        if (query != null && !query.trim().isEmpty()) {
            stations = stationDAO.searchStations(query);
        } else {
            stations = stationDAO.getAllStations();
        }

        // Return lightweight payload to avoid Java Time serialization issues
        class CityDTO {
            String city;

            CityDTO(String city) {
                this.city = city;
            }
        }

        java.util.List<CityDTO> result = new java.util.ArrayList<>();
        java.util.Set<String> seen = new java.util.HashSet<>();
        for (Station s : stations) {
            if (s.getCity() != null && seen.add(s.getCity())) {
                result.add(new CityDTO(s.getCity()));
            }
        }

        response.setContentType("application/json");
        response.getWriter().write(new com.google.gson.Gson().toJson(result));
    }

    private void getRoutesByCities(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        String departureCity = request.getParameter("departureCity");
        String destinationCity = request.getParameter("destinationCity");

        response.setContentType("application/json");

        if (departureCity == null || departureCity.trim().isEmpty()
                || destinationCity == null || destinationCity.trim().isEmpty()) {
            response.getWriter().write("{\"error\":\"Departure and destination are required\"}");
            return;
        }

        try {
            // Search for routes
            List<Routes> routes = routeDAO.searchRoutes(departureCity.trim(), destinationCity.trim());

            // For each route, get available dates from schedules
            List<java.util.Map<String, Object>> routesData = new ArrayList<>();
            for (Routes route : routes) {
                List<Schedule> schedules = scheduleDAO.getSchedulesByRoute(route.getRouteId());

                // Get unique dates from schedules (only future dates)
                java.util.Set<String> availableDates = new java.util.TreeSet<>();
                LocalDateTime now = LocalDateTime.now();
                for (Schedule schedule : schedules) {
                    if (schedule.getDepartureDate() != null
                            && schedule.getDepartureTime() != null) {
                        LocalDateTime departureDateTime = LocalDateTime.of(
                                schedule.getDepartureDate(),
                                schedule.getDepartureTime());
                        if (departureDateTime.isAfter(now)) {
                            availableDates.add(schedule.getDepartureDate().toString());
                        }
                    }
                }

                java.util.Map<String, Object> routeData = new java.util.HashMap<>();
                routeData.put("routeId", route.getRouteId().toString());
                routeData.put("routeName", route.getRouteName());
                routeData.put("departureCity", route.getDepartureCity());
                routeData.put("destinationCity", route.getDestinationCity());
                routeData.put("distance", route.getDistance().doubleValue());
                routeData.put("durationHours", route.getDurationHours());
                routeData.put("basePrice", route.getBasePrice().doubleValue());
                routeData.put("availableDates", new ArrayList<String>(availableDates));
                routeData.put("scheduleCount", schedules.size());

                routesData.add(routeData);
            }

            java.util.Map<String, Object> result = new java.util.HashMap<>();
            result.put("routes", routesData);

            response.getWriter().write(new com.google.gson.Gson().toJson(result));
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"" + e.getMessage().replace("\"", "'") + "\"}");
        }
    }

    private void getAllCities(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            List<City> cities = cityDAO.getAllCities();

            // Create simplified city DTOs for JSON response
            List<java.util.Map<String, Object>> citiesData = new ArrayList<>();
            for (City city : cities) {
                java.util.Map<String, Object> cityData = new java.util.HashMap<>();
                cityData.put("cityId", city.getCityId().toString());
                cityData.put("cityName", city.getCityName());
                cityData.put("cityNumber", city.getCityNumber());
                citiesData.add(cityData);
            }

            response.getWriter().write(new com.google.gson.Gson().toJson(citiesData));
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"" + e.getMessage().replace("\"", "'") + "\"}");
        }
    }

    private void handleError(HttpServletRequest request, HttpServletResponse response,
            String message)
            throws ServletException, IOException {
        request.setAttribute("error", message);
        try {
            showSearchForm(request, response);
        } catch (SQLException e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, message);
        }
    }
}
