package dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import model.City;
import model.Routes;
import util.DBConnection;
import util.UUIDUtils;

public class RouteDAO {
    public List<Routes> getAllRoutes() throws SQLException {
        List<Routes> routes = new ArrayList<>();
        String sql =
                "SELECT r.*, dc.city_name as departure_city_name, dc.city_number as departure_city_number, "
                        +
                        "destc.city_name as destination_city_name, destc.city_number as destination_city_number, "
                        +
                        "ds.station_name as departure_station_name, dests.station_name as destination_station_name "
                        +
                        "FROM Routes r " +
                        "LEFT JOIN Cities dc ON r.departure_city_id = dc.city_id " +
                        "LEFT JOIN Cities destc ON r.destination_city_id = destc.city_id " +
                        "LEFT JOIN Stations ds ON r.departure_station_id = ds.station_id " +
                        "LEFT JOIN Stations dests ON r.destination_station_id = dests.station_id " +
                        "WHERE r.status = 'ACTIVE' ORDER BY r.route_name";

        try (Connection conn = DBConnection.getInstance().getConnection()) {
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        Routes route = mapResultSetToRoute(rs);
                        routes.add(route);
                    }
                }
            }
        } catch (SQLException e) {
            throw e;
        }
        return routes;
    }

    public List<Routes> getAllRoutesAnyStatus() throws SQLException {
        List<Routes> routes = new ArrayList<>();
        String sql =
                "SELECT r.*, dc.city_name as departure_city_name, dc.city_number as departure_city_number, "
                        +
                        "destc.city_name as destination_city_name, destc.city_number as destination_city_number, "
                        +
                        "ds.station_name as departure_station_name, dests.station_name as destination_station_name "
                        +
                        "FROM Routes r " +
                        "LEFT JOIN Cities dc ON r.departure_city_id = dc.city_id " +
                        "LEFT JOIN Cities destc ON r.destination_city_id = destc.city_id " +
                        "LEFT JOIN Stations ds ON r.departure_station_id = ds.station_id " +
                        "LEFT JOIN Stations dests ON r.destination_station_id = dests.station_id " +
                        "ORDER BY r.status DESC, r.route_name";

        try (Connection conn = DBConnection.getInstance().getConnection()) {
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        Routes route = mapResultSetToRoute(rs);
                        routes.add(route);
                    }
                }
            }
        } catch (SQLException e) {
            throw e;
        }
        return routes;
    }

    public Routes getRouteById(UUID routeId) throws SQLException {
        String sql =
                "SELECT r.*, dc.city_name as departure_city_name, dc.city_number as departure_city_number, "
                        +
                        "destc.city_name as destination_city_name, destc.city_number as destination_city_number, "
                        +
                        "ds.station_name as departure_station_name, dests.station_name as destination_station_name "
                        +
                        "FROM Routes r " +
                        "LEFT JOIN Cities dc ON r.departure_city_id = dc.city_id " +
                        "LEFT JOIN Cities destc ON r.destination_city_id = destc.city_id " +
                        "LEFT JOIN Stations ds ON r.departure_station_id = ds.station_id " +
                        "LEFT JOIN Stations dests ON r.destination_station_id = dests.station_id " +
                        "WHERE r.route_id = ? AND r.status = 'ACTIVE'";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, routeId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToRoute(rs);
            }
        }
        return null;
    }

    public Routes getRouteByIdAnyStatus(UUID routeId) throws SQLException {
        String sql =
                "SELECT r.*, dc.city_name as departure_city_name, dc.city_number as departure_city_number, "
                        +
                        "destc.city_name as destination_city_name, destc.city_number as destination_city_number, "
                        +
                        "ds.station_name as departure_station_name, dests.station_name as destination_station_name "
                        +
                        "FROM Routes r " +
                        "LEFT JOIN Cities dc ON r.departure_city_id = dc.city_id " +
                        "LEFT JOIN Cities destc ON r.destination_city_id = destc.city_id " +
                        "LEFT JOIN Stations ds ON r.departure_station_id = ds.station_id " +
                        "LEFT JOIN Stations dests ON r.destination_station_id = dests.station_id " +
                        "WHERE r.route_id = ?";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, routeId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToRoute(rs);
            }
        }
        return null;
    }

    public List<Routes> searchRoutes(String departureCity, String destinationCity)
            throws SQLException {
        List<Routes> routes = new ArrayList<>();
        String sql =
                "SELECT r.*, dc.city_name as departure_city_name, dc.city_number as departure_city_number, "
                        +
                        "destc.city_name as destination_city_name, destc.city_number as destination_city_number "
                        +
                        "FROM Routes r " +
                        "LEFT JOIN Cities dc ON r.departure_city_id = dc.city_id " +
                        "LEFT JOIN Cities destc ON r.destination_city_id = destc.city_id " +
                        "WHERE r.status = 'ACTIVE'";

        if (departureCity != null && !departureCity.trim().isEmpty()) {
            sql += " AND (dc.city_name LIKE ? OR LOWER(dc.city_name) LIKE ?)";
        }
        if (destinationCity != null && !destinationCity.trim().isEmpty()) {
            sql += " AND (destc.city_name LIKE ? OR LOWER(destc.city_name) LIKE ?)";
        }

        sql += " ORDER BY r.route_name";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            int paramIndex = 1;
            if (departureCity != null && !departureCity.trim().isEmpty()) {
                String searchPattern = "%" + departureCity + "%";
                stmt.setString(paramIndex++, searchPattern);
                stmt.setString(paramIndex++, searchPattern.toLowerCase());
            }
            if (destinationCity != null && !destinationCity.trim().isEmpty()) {
                String searchPattern = "%" + destinationCity + "%";
                stmt.setString(paramIndex++, searchPattern);
                stmt.setString(paramIndex++, searchPattern.toLowerCase());
            }

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Routes route = mapResultSetToRoute(rs);
                routes.add(route);
            }
        }
        return routes;
    }

    /**
     * Search routes by City IDs (case-insensitive city name search)
     */
    public List<Routes> searchRoutesByCityIds(UUID departureCityId, UUID destinationCityId)
            throws SQLException {
        List<Routes> routes = new ArrayList<>();
        String sql =
                "SELECT r.*, dc.city_name as departure_city_name, dc.city_number as departure_city_number, "
                        +
                        "destc.city_name as destination_city_name, destc.city_number as destination_city_number "
                        +
                        "FROM Routes r " +
                        "LEFT JOIN Cities dc ON r.departure_city_id = dc.city_id " +
                        "LEFT JOIN Cities destc ON r.destination_city_id = destc.city_id " +
                        "WHERE r.status = 'ACTIVE'";

        if (departureCityId != null) {
            sql += " AND r.departure_city_id = ?";
        }
        if (destinationCityId != null) {
            sql += " AND r.destination_city_id = ?";
        }

        sql += " ORDER BY r.route_name";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            int paramIndex = 1;
            if (departureCityId != null) {
                stmt.setObject(paramIndex++, departureCityId);
            }
            if (destinationCityId != null) {
                stmt.setObject(paramIndex++, destinationCityId);
            }

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Routes route = mapResultSetToRoute(rs);
                routes.add(route);
            }
        }
        return routes;
    }

    public boolean addRoute(Routes route) throws SQLException {
        if (route.getDepartureCityId() == null || route.getDestinationCityId() == null) {
            throw new SQLException("Departure and destination city IDs are required");
        }

        String sql =
                "INSERT INTO Routes (route_id, route_name, departure_city_id, destination_city_id, departure_station_id, destination_station_id, distance, duration_hours, base_price, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, route.getRouteId());
            stmt.setString(2, route.getRouteName());
            stmt.setObject(3, route.getDepartureCityId());
            stmt.setObject(4, route.getDestinationCityId());
            stmt.setObject(5, route.getDepartureStationId());
            stmt.setObject(6, route.getDestinationStationId());
            stmt.setBigDecimal(7, route.getDistance());
            stmt.setInt(8, route.getDurationHours());
            stmt.setBigDecimal(9, route.getBasePrice());
            stmt.setString(10, route.getStatus());

            return stmt.executeUpdate() > 0;
        }
    }

    public boolean updateRoute(Routes route) throws SQLException {
        if (route.getDepartureCityId() == null || route.getDestinationCityId() == null) {
            throw new SQLException("Departure and destination city IDs are required");
        }

        String sql =
                "UPDATE Routes SET route_name = ?, departure_city_id = ?, destination_city_id = ?, departure_station_id = ?, destination_station_id = ?, distance = ?, duration_hours = ?, base_price = ?, status = ?, updated_date = GETDATE() WHERE route_id = ?";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, route.getRouteName());
            stmt.setObject(2, route.getDepartureCityId());
            stmt.setObject(3, route.getDestinationCityId());
            stmt.setObject(4, route.getDepartureStationId());
            stmt.setObject(5, route.getDestinationStationId());
            stmt.setBigDecimal(6, route.getDistance());
            stmt.setInt(7, route.getDurationHours());
            stmt.setBigDecimal(8, route.getBasePrice());
            stmt.setString(9, route.getStatus());
            stmt.setObject(10, route.getRouteId());

            return stmt.executeUpdate() > 0;
        }
    }

    public boolean deleteRoute(UUID routeId) throws SQLException {
        String sql =
                "UPDATE Routes SET status = 'INACTIVE', updated_date = GETDATE() WHERE route_id = ?";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, routeId);
            return stmt.executeUpdate() > 0;
        }
    }

    public int getTotalRoutes() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Routes WHERE status = 'ACTIVE'";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    public List<Routes> getPopularRoutes() throws SQLException {
        List<Routes> routes = new ArrayList<>();
        String sql =
                "SELECT TOP 5 r.*, dc.city_name as departure_city_name, dc.city_number as departure_city_number, "
                        +
                        "destc.city_name as destination_city_name, destc.city_number as destination_city_number "
                        +
                        "FROM Routes r " +
                        "LEFT JOIN Cities dc ON r.departure_city_id = dc.city_id " +
                        "LEFT JOIN Cities destc ON r.destination_city_id = destc.city_id " +
                        "WHERE r.status = 'ACTIVE' ORDER BY r.route_name";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Routes route = mapResultSetToRoute(rs);
                routes.add(route);
            }
        }
        return routes;
    }

    public BigDecimal getPriceByRouteId(UUID routeId) throws SQLException {
        String sql = "SELECT base_price FROM Routes WHERE route_id = ? AND status = 'ACTIVE'";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, routeId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getBigDecimal("base_price");
            }
        }
        return null;
    }

    /**
     * Check if a route is assigned to any schedules
     * 
     * @param routeId The route ID to check
     * @return true if the route is assigned to at least one schedule, false otherwise
     */
    public boolean isRouteAssignedToSchedule(UUID routeId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Schedules WHERE route_id = ? AND status != 'CANCELLED'";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, routeId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }

    /**
     * Check if a route name already exists (case-insensitive)
     * 
     * @param routeName The route name to check
     * @return true if the route name exists, false otherwise
     */
    public boolean isRouteNameExists(String routeName) throws SQLException {
        // Use LOWER and LTRIM/RTRIM for consistent comparison (SQL Server compatible)
        String sql =
                "SELECT COUNT(*) FROM Routes WHERE LOWER(LTRIM(RTRIM(route_name))) = LOWER(LTRIM(RTRIM(?))) AND status = 'ACTIVE'";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, routeName);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }

    /**
     * Check if a route name already exists excluding a specific route ID (for update)
     * 
     * @param routeName The route name to check
     * @param excludeRouteId The route ID to exclude from the check
     * @return true if the route name exists for another route, false otherwise
     */
    public boolean isRouteNameExistsExcludingId(String routeName, UUID excludeRouteId)
            throws SQLException {
        // Use LOWER and LTRIM/RTRIM for consistent comparison (SQL Server compatible)
        String sql =
                "SELECT COUNT(*) FROM Routes WHERE LOWER(LTRIM(RTRIM(route_name))) = LOWER(LTRIM(RTRIM(?))) AND route_id != ? AND status = 'ACTIVE'";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, routeName);
            stmt.setObject(2, excludeRouteId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }

    private Routes mapResultSetToRoute(ResultSet rs) throws SQLException {
        Routes route = new Routes();
        route.setRouteId(UUIDUtils.getUUIDFromResultSet(rs, "route_id"));
        route.setRouteName(rs.getString("route_name"));

        // Map city IDs
        try {
            UUID departureCityId = UUIDUtils.getUUIDFromResultSet(rs, "departure_city_id");
            if (departureCityId != null) {
                route.setDepartureCityId(departureCityId);
            }
        } catch (SQLException e) {
            // Column might not exist, try old column
        }

        try {
            UUID destinationCityId = UUIDUtils.getUUIDFromResultSet(rs, "destination_city_id");
            if (destinationCityId != null) {
                route.setDestinationCityId(destinationCityId);
            }
        } catch (SQLException e) {
            // Column might not exist, try old column
        }

        // Map city names (for backward compatibility and display)
        try {
            String departureCityName = rs.getString("departure_city_name");
            if (departureCityName != null) {
                route.setDepartureCity(departureCityName); // Deprecated but kept for compatibility

                // Create City object if city ID is available
                if (route.getDepartureCityId() != null) {
                    City depCity = new City();
                    depCity.setCityId(route.getDepartureCityId());
                    depCity.setCityName(departureCityName);
                    try {
                        depCity.setCityNumber(rs.getInt("departure_city_number"));
                    } catch (SQLException e) {
                        // Ignore if column doesn't exist
                    }
                    route.setDepartureCityObj(depCity);
                }
            }
        } catch (SQLException e) {
            // Try old departure_city column
            try {
                String depCity = rs.getString("departure_city");
                if (depCity != null) {
                    route.setDepartureCity(depCity);
                }
            } catch (SQLException e2) {
                // Ignore
            }
        }

        try {
            String destinationCityName = rs.getString("destination_city_name");
            if (destinationCityName != null) {
                route.setDestinationCity(destinationCityName); // Deprecated but kept for
                                                               // compatibility

                // Create City object if city ID is available
                if (route.getDestinationCityId() != null) {
                    City destCity = new City();
                    destCity.setCityId(route.getDestinationCityId());
                    destCity.setCityName(destinationCityName);
                    try {
                        destCity.setCityNumber(rs.getInt("destination_city_number"));
                    } catch (SQLException e) {
                        // Ignore if column doesn't exist
                    }
                    route.setDestinationCityObj(destCity);
                }
            }
        } catch (SQLException e) {
            // Try old destination_city column
            try {
                String destCity = rs.getString("destination_city");
                if (destCity != null) {
                    route.setDestinationCity(destCity);
                }
            } catch (SQLException e2) {
                // Ignore
            }
        }

        route.setDistance(rs.getBigDecimal("distance"));
        route.setDurationHours(rs.getInt("duration_hours"));
        route.setBasePrice(rs.getBigDecimal("base_price"));
        route.setStatus(rs.getString("status"));

        // Map terminal station IDs
        try {
            UUID departureStationId = UUIDUtils.getUUIDFromResultSet(rs, "departure_station_id");
            if (departureStationId != null) {
                route.setDepartureStationId(departureStationId);

                // Create Station object if station name is available
                try {
                    String depStationName = rs.getString("departure_station_name");
                    if (depStationName != null) {
                        model.Station depStation = new model.Station();
                        depStation.setStationId(departureStationId);
                        depStation.setStationName(depStationName);
                        route.setDepartureStationObj(depStation);
                    }
                } catch (SQLException e) {
                    // Ignore if column doesn't exist
                }
            }
        } catch (SQLException e) {
            // Column might not exist
        }

        try {
            UUID destinationStationId =
                    UUIDUtils.getUUIDFromResultSet(rs, "destination_station_id");
            if (destinationStationId != null) {
                route.setDestinationStationId(destinationStationId);

                // Create Station object if station name is available
                try {
                    String destStationName = rs.getString("destination_station_name");
                    if (destStationName != null) {
                        model.Station destStation = new model.Station();
                        destStation.setStationId(destinationStationId);
                        destStation.setStationName(destStationName);
                        route.setDestinationStationObj(destStation);
                    }
                } catch (SQLException e) {
                    // Ignore if column doesn't exist
                }
            }
        } catch (SQLException e) {
            // Column might not exist
        }

        java.sql.Timestamp createdDate = rs.getTimestamp("created_date");
        if (createdDate != null) {
            route.setCreatedDate(createdDate.toLocalDateTime());
        }

        java.sql.Timestamp updatedDate = rs.getTimestamp("updated_date");
        if (updatedDate != null) {
            route.setUpdatedDate(updatedDate.toLocalDateTime());
        }

        return route;
    }

    /**
     * Find schedule ID based on route, bus, and departure date/time
     */
    public UUID findScheduleId(UUID routeId, UUID busId, java.time.LocalDate departureDate,
            java.time.LocalTime departureTime) throws SQLException {
        // Fixed SQL query - use CAST to ensure proper type matching
        String sql =
                "SELECT schedule_id FROM Schedules WHERE route_id = ? AND bus_id = ? AND departure_date = ? AND departure_time = CAST(? AS TIME) AND status = 'SCHEDULED'";



        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, routeId);
            stmt.setObject(2, busId);
            stmt.setDate(3, java.sql.Date.valueOf(departureDate));
            // Use setTime with CAST in SQL to ensure type compatibility
            stmt.setTime(4, java.sql.Time.valueOf(departureTime));

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    UUID result = UUIDUtils.getUUIDFromResultSet(rs, "schedule_id");
                    return result;
                } else {
                }
            }
        } catch (Exception e) {
            throw e;
        }
        return null;
    }
}
