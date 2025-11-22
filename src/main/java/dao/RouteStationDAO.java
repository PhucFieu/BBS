package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import model.RouteStation;
import model.Station;
import util.DBConnection;
import util.UUIDUtils;

public class RouteStationDAO {

    /**
     * Get all stations for a route, ordered by sequence number
     */
    public List<RouteStation> getStationsByRoute(UUID routeId) throws SQLException {
        List<RouteStation> routeStations = new ArrayList<>();
        String sql = "SELECT rs.*, s.station_name, s.city, s.address " +
                "FROM RouteStations rs " +
                "JOIN Stations s ON rs.station_id = s.station_id " +
                "WHERE rs.route_id = ? AND s.status = 'ACTIVE' " +
                "ORDER BY rs.sequence_number";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, routeId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                RouteStation routeStation = mapResultSetToRouteStation(rs);
                routeStations.add(routeStation);
            }
        }
        return routeStations;
    }

    /**
     * Get all stations for a route with station details, ordered by sequence number
     */
    public List<Station> getStationsByRouteAsStations(UUID routeId) throws SQLException {
        List<Station> stations = new ArrayList<>();
        String sql = "SELECT s.* " +
                "FROM RouteStations rs " +
                "JOIN Stations s ON rs.station_id = s.station_id " +
                "WHERE rs.route_id = ? AND s.status = 'ACTIVE' " +
                "ORDER BY rs.sequence_number";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, routeId);
            ResultSet rs = stmt.executeQuery();

            StationDAO stationDAO = new StationDAO();
            while (rs.next()) {
                Station station = stationDAO.mapResultSetToStation(rs);
                stations.add(station);
            }
        }
        return stations;
    }

    /**
     * Add a station to a route
     */
    public boolean addStationToRoute(UUID routeId, UUID stationId, int sequenceNumber)
            throws SQLException {
        String sql = "INSERT INTO RouteStations (route_station_id, route_id, station_id, sequence_number) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            RouteStation routeStation = new RouteStation(routeId, stationId, sequenceNumber);
            stmt.setObject(1, routeStation.getRouteStationId());
            stmt.setObject(2, routeId);
            stmt.setObject(3, stationId);
            stmt.setInt(4, sequenceNumber);

            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Remove all stations from a route
     */
    public boolean removeAllStationsFromRoute(UUID routeId) throws SQLException {
        String sql = "DELETE FROM RouteStations WHERE route_id = ?";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, routeId);
            return stmt.executeUpdate() >= 0; // >= 0 because it's OK if no rows exist
        }
    }

    /**
     * Remove a specific station from a route
     */
    public boolean removeStationFromRoute(UUID routeId, UUID stationId) throws SQLException {
        String sql = "DELETE FROM RouteStations WHERE route_id = ? AND station_id = ?";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, routeId);
            stmt.setObject(2, stationId);
            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Update sequence numbers for all stations in a route
     */
    public boolean updateRouteStations(UUID routeId, List<UUID> stationIds) throws SQLException {
        // Remove all existing stations
        removeAllStationsFromRoute(routeId);

        // Add stations with new sequence numbers
        if (stationIds != null && !stationIds.isEmpty()) {
            for (int i = 0; i < stationIds.size(); i++) {
                addStationToRoute(routeId, stationIds.get(i), i + 1);
            }
        }
        return true;
    }

    /**
     * Get the maximum sequence number for a route
     */
    public int getMaxSequenceNumber(UUID routeId) throws SQLException {
        String sql = "SELECT MAX(sequence_number) as max_seq FROM RouteStations WHERE route_id = ?";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, routeId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                int maxSeq = rs.getInt("max_seq");
                return rs.wasNull() ? 0 : maxSeq;
            }
        }
        return 0;
    }

    /**
     * Check if a station is already in a route
     */
    public boolean isStationInRoute(UUID routeId, UUID stationId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM RouteStations WHERE route_id = ? AND station_id = ?";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, routeId);
            stmt.setObject(2, stationId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }

    /**
     * Get route station by route and station IDs
     */
    public RouteStation getRouteStation(UUID routeId, UUID stationId) throws SQLException {
        String sql = "SELECT rs.*, s.station_name, s.city, s.address " +
                "FROM RouteStations rs " +
                "JOIN Stations s ON rs.station_id = s.station_id " +
                "WHERE rs.route_id = ? AND rs.station_id = ?";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, routeId);
            stmt.setObject(2, stationId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToRouteStation(rs);
            }
        }
        return null;
    }

    private RouteStation mapResultSetToRouteStation(ResultSet rs) throws SQLException {
        RouteStation routeStation = new RouteStation();

        routeStation.setRouteStationId(UUIDUtils.getUUIDFromResultSet(rs, "route_station_id"));
        routeStation.setRouteId(UUIDUtils.getUUIDFromResultSet(rs, "route_id"));
        routeStation.setStationId(UUIDUtils.getUUIDFromResultSet(rs, "station_id"));
        routeStation.setSequenceNumber(rs.getInt("sequence_number"));

        Timestamp createdDate = rs.getTimestamp("created_date");
        if (createdDate != null) {
            routeStation.setCreatedDate(createdDate.toLocalDateTime());
        }

        Timestamp updatedDate = rs.getTimestamp("updated_date");
        if (updatedDate != null) {
            routeStation.setUpdatedDate(updatedDate.toLocalDateTime());
        }

        // Map station details if available
        try {
            Station station = new Station();
            station.setStationId(routeStation.getStationId());
            station.setStationName(rs.getString("station_name"));
            station.setCity(rs.getString("city"));
            station.setAddress(rs.getString("address"));
            routeStation.setStation(station);
        } catch (SQLException e) {
            // Station details not available, skip
        }

        return routeStation;
    }
}

