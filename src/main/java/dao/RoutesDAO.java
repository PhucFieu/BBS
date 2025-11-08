package dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import model.Routes;
import util.DBConnection;
import util.UUIDUtils;


/**
 *
 * @author Nguyen Phat Tai
 */
public class RoutesDAO {
    public List<Routes> getAllRoutes() throws SQLException {
        List<Routes> routes = new ArrayList<>();
        String sql = "SELECT * FROM Routes WHERE status = 'ACTIVE' ORDER BY route_name";

        System.out.println("RouteDAO: Executing query: " + sql);
        try (Connection conn = DBConnection.getInstance().getConnection()) {
            System.out.println("RouteDAO: Database connection established");
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                System.out.println("RouteDAO: Statement prepared");
                try (ResultSet rs = stmt.executeQuery()) {
                    System.out.println("RouteDAO: Query executed");
                    while (rs.next()) {
                        Routes route = mapResultSetToRoute(rs);
                        routes.add(route);
                        System.out.println("RouteDAO: Added route: " + route.getRouteName());
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("RouteDAO Error: " + e.getMessage());
            System.err.println("SQL State: " + e.getSQLState());
            System.err.println("Error Code: " + e.getErrorCode());
            throw e;
        }
        System.out.println("RouteDAO: Returning " + routes.size() + " routes");
        return routes;
    }

    public Routes getRouteById(UUID routeId) throws SQLException {
        String sql = "SELECT * FROM Routes WHERE route_id = ? AND status = 'ACTIVE'";

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

    public List<Routes> searchRoutes(String departureCity, String destinationCity) throws SQLException {
        List<Routes> routes = new ArrayList<>();
        String sql = "SELECT * FROM Routes WHERE status = 'ACTIVE'";

        if (departureCity != null && !departureCity.trim().isEmpty()) {
            sql += " AND departure_city LIKE ?";
        }
        if (destinationCity != null && !destinationCity.trim().isEmpty()) {
            sql += " AND destination_city LIKE ?";
        }

        sql += " ORDER BY route_name";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            int paramIndex = 1;
            if (departureCity != null && !departureCity.trim().isEmpty()) {
                stmt.setString(paramIndex++, "%" + departureCity + "%");
            }
            if (destinationCity != null && !destinationCity.trim().isEmpty()) {
                stmt.setString(paramIndex++, "%" + destinationCity + "%");
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
        String sql = "INSERT INTO Routes (route_id, route_name, departure_city, destination_city, distance, duration_hours, base_price, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, route.getRouteId());
            stmt.setString(2, route.getRouteName());
            stmt.setString(3, route.getDepartureCity());
            stmt.setString(4, route.getDestinationCity());
            stmt.setBigDecimal(5, route.getDistance());
            stmt.setInt(6, route.getDurationHours());
            stmt.setBigDecimal(7, route.getBasePrice());
            stmt.setString(8, route.getStatus());

            return stmt.executeUpdate() > 0;
        }
    }

    public boolean updateRoute(Routes route) throws SQLException {
        String sql = "UPDATE Routes SET route_name = ?, departure_city = ?, destination_city = ?, distance = ?, duration_hours = ?, base_price = ?, status = ?, updated_date = GETDATE() WHERE route_id = ?";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, route.getRouteName());
            stmt.setString(2, route.getDepartureCity());
            stmt.setString(3, route.getDestinationCity());
            stmt.setBigDecimal(4, route.getDistance());
            stmt.setInt(5, route.getDurationHours());
            stmt.setBigDecimal(6, route.getBasePrice());
            stmt.setString(7, route.getStatus());
            stmt.setObject(8, route.getRouteId());

            return stmt.executeUpdate() > 0;
        }
    }

    public boolean deleteRoute(UUID routeId) throws SQLException {
        String sql = "UPDATE Routes SET status = 'INACTIVE', updated_date = GETDATE() WHERE route_id = ?";

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
        String sql = "SELECT TOP 5 * FROM Routes WHERE status = 'ACTIVE' ORDER BY route_name";

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

    private Routes mapResultSetToRoute(ResultSet rs) throws SQLException {
        Routes route = new Routes();
        route.setRouteId(UUIDUtils.getUUIDFromResultSet(rs, "route_id"));
        route.setRouteName(rs.getString("route_name"));
        route.setDepartureCity(rs.getString("departure_city"));
        route.setDestinationCity(rs.getString("destination_city"));
        route.setDistance(rs.getBigDecimal("distance"));
        route.setDurationHours(rs.getInt("duration_hours"));
        route.setBasePrice(rs.getBigDecimal("base_price"));
        route.setStatus(rs.getString("status"));

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
        String sql = "SELECT schedule_id FROM Schedules WHERE route_id = ? AND bus_id = ? AND departure_date = ? AND departure_time = CAST(? AS TIME) AND status = 'SCHEDULED'";

        System.out.println("=== ROUTE DAO DEBUG ===");
        System.out.println("SQL: " + sql);
        System.out.println("RouteId: " + routeId);
        System.out.println("BusId: " + busId);
        System.out.println(
                "DepartureDate: " + departureDate + " (SQL Date: " + java.sql.Date.valueOf(departureDate) + ")");
        System.out.println(
                "DepartureTime: " + departureTime + " (SQL Time: " + java.sql.Time.valueOf(departureTime) + ")");

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, routeId);
            stmt.setObject(2, busId);
            stmt.setDate(3, java.sql.Date.valueOf(departureDate));
            // Use setTime with CAST in SQL to ensure type compatibility
            stmt.setTime(4, java.sql.Time.valueOf(departureTime));

            System.out.println("Executing query...");
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    UUID result = UUIDUtils.getUUIDFromResultSet(rs, "schedule_id");
                    System.out.println("Found ScheduleId: " + result);
                    return result;
                } else {
                    System.out.println("No schedule found matching criteria");
                }
            }
        } catch (Exception e) {
            System.out.println("ERROR in findScheduleId: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
        System.out.println("=== END ROUTE DAO DEBUG ===");
        return null;
    }
}
