package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Time;
import java.sql.Timestamp;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import model.RouteStop;
import util.DBConnection;
import util.UUIDUtils;

public class RouteStopDAO {

    public List<RouteStop> getAllRouteStops() throws SQLException {
        List<RouteStop> routeStops = new ArrayList<>();
        String sql = "SELECT rs.*, s.station_name, s.city, s.address " +
                "FROM RouteStops rs " +
                "JOIN Stations s ON rs.station_id = s.station_id " +
                "ORDER BY rs.route_id, rs.stop_order";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                RouteStop routeStop = mapResultSetToRouteStop(rs);
                routeStops.add(routeStop);
            }
        }
        return routeStops;
    }

    public RouteStop getRouteStopById(UUID routeStopId) throws SQLException {
        String sql = "SELECT rs.*, s.station_name, s.city, s.address " +
                "FROM RouteStops rs " +
                "JOIN Stations s ON rs.station_id = s.station_id " +
                "WHERE rs.route_stop_id = ?";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, routeStopId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToRouteStop(rs);
            }
        }
        return null;
    }

    public List<RouteStop> getRouteStopsByRoute(UUID routeId) throws SQLException {
        List<RouteStop> routeStops = new ArrayList<>();
        String sql = "SELECT rs.*, s.station_name, s.city, s.address " +
                "FROM RouteStops rs " +
                "JOIN Stations s ON rs.station_id = s.station_id " +
                "WHERE rs.route_id = ? " +
                "ORDER BY rs.stop_order";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, routeId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                RouteStop routeStop = mapResultSetToRouteStop(rs);
                routeStops.add(routeStop);
            }
        }
        return routeStops;
    }

    public List<RouteStop> getRouteStopsByStation(UUID stationId) throws SQLException {
        List<RouteStop> routeStops = new ArrayList<>();
        String sql = "SELECT rs.*, s.station_name, s.city, s.address " +
                "FROM RouteStops rs " +
                "JOIN Stations s ON rs.station_id = s.station_id " +
                "WHERE rs.station_id = ? " +
                "ORDER BY rs.route_id, rs.stop_order";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, stationId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                RouteStop routeStop = mapResultSetToRouteStop(rs);
                routeStops.add(routeStop);
            }
        }
        return routeStops;
    }

    public RouteStop getRouteStopByRouteAndOrder(UUID routeId, int stopOrder) throws SQLException {
        String sql = "SELECT rs.*, s.station_name, s.city, s.address " +
                "FROM RouteStops rs " +
                "JOIN Stations s ON rs.station_id = s.station_id " +
                "WHERE rs.route_id = ? AND rs.stop_order = ?";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, routeId);
            stmt.setInt(2, stopOrder);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToRouteStop(rs);
            }
        }
        return null;
    }

    public boolean addRouteStop(RouteStop routeStop) throws SQLException {
        String sql = "INSERT INTO RouteStops (route_stop_id, route_id, station_id, stop_order, arrival_time, stop_duration_minutes) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, routeStop.getRouteStopId());
            stmt.setObject(2, routeStop.getRouteId());
            stmt.setObject(3, routeStop.getStationId());
            stmt.setInt(4, routeStop.getStopOrder());

            if (routeStop.getArrivalTime() != null) {
                stmt.setTime(5, Time.valueOf(routeStop.getArrivalTime()));
            } else {
                stmt.setNull(5, Types.TIME);
            }

            stmt.setInt(6, routeStop.getStopDurationMinutes());

            return stmt.executeUpdate() > 0;
        }
    }

    public boolean updateRouteStop(RouteStop routeStop) throws SQLException {
        String sql = "UPDATE RouteStops SET station_id = ?, stop_order = ?, arrival_time = ?, stop_duration_minutes = ?, updated_date = GETDATE() WHERE route_stop_id = ?";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, routeStop.getStationId());
            stmt.setInt(2, routeStop.getStopOrder());

            if (routeStop.getArrivalTime() != null) {
                stmt.setTime(3, Time.valueOf(routeStop.getArrivalTime()));
            } else {
                stmt.setNull(3, Types.TIME);
            }

            stmt.setInt(4, routeStop.getStopDurationMinutes());
            stmt.setObject(5, routeStop.getRouteStopId());

            return stmt.executeUpdate() > 0;
        }
    }

    public boolean deleteRouteStop(UUID routeStopId) throws SQLException {
        String sql = "DELETE FROM RouteStops WHERE route_stop_id = ?";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, routeStopId);
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean deleteRouteStopsByRoute(UUID routeId) throws SQLException {
        String sql = "DELETE FROM RouteStops WHERE route_id = ?";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, routeId);
            return stmt.executeUpdate() > 0;
        }
    }

    public int getTotalRouteStops() throws SQLException {
        String sql = "SELECT COUNT(*) FROM RouteStops";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    public int getNextStopOrder(UUID routeId) throws SQLException {
        String sql = "SELECT MAX(stop_order) FROM RouteStops WHERE route_id = ?";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, routeId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                int maxOrder = rs.getInt(1);
                return rs.wasNull() ? 1 : maxOrder + 1;
            }
        }
        return 1;
    }

    public boolean isStopOrderExists(UUID routeId, int stopOrder) throws SQLException {
        String sql = "SELECT COUNT(*) FROM RouteStops WHERE route_id = ? AND stop_order = ?";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, routeId);
            stmt.setInt(2, stopOrder);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }

    private RouteStop mapResultSetToRouteStop(ResultSet rs) throws SQLException {
        RouteStop routeStop = new RouteStop();

        routeStop.setRouteStopId(UUIDUtils.getUUIDFromResultSet(rs, "route_stop_id"));
        routeStop.setRouteId(UUIDUtils.getUUIDFromResultSet(rs, "route_id"));
        routeStop.setStationId(UUIDUtils.getUUIDFromResultSet(rs, "station_id"));
        routeStop.setStopOrder(rs.getInt("stop_order"));

        Time arrivalTime = rs.getTime("arrival_time");
        if (arrivalTime != null) {
            routeStop.setArrivalTime(arrivalTime.toLocalTime());
        }

        routeStop.setStopDurationMinutes(rs.getInt("stop_duration_minutes"));

        // Display fields from Stations table
        routeStop.setStationName(rs.getString("station_name"));
        routeStop.setCity(rs.getString("city"));
        routeStop.setAddress(rs.getString("address"));

        Timestamp createdDate = rs.getTimestamp("created_date");
        if (createdDate != null) {
            routeStop.setCreatedDate(createdDate.toLocalDateTime());
        }

        Timestamp updatedDate = rs.getTimestamp("updated_date");
        if (updatedDate != null) {
            routeStop.setUpdatedDate(updatedDate.toLocalDateTime());
        }

        return routeStop;
    }
}
