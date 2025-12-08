package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import model.ScheduleStation;
import model.Station;
import util.DBConnection;
import util.UUIDUtils;

public class ScheduleStationDAO {

    /**
     * Get all stations for a schedule, ordered by sequence number
     */
    public List<ScheduleStation> getStationsBySchedule(UUID scheduleId) throws SQLException {
        List<ScheduleStation> scheduleStations = new ArrayList<>();
        String sql = "SELECT ss.*, s.station_name, s.city_id, s.address, c.city_name " +
                "FROM ScheduleStations ss " +
                "JOIN Stations s ON ss.station_id = s.station_id " +
                "LEFT JOIN Cities c ON s.city_id = c.city_id " +
                "WHERE ss.schedule_id = ? AND s.status = 'ACTIVE' " +
                "ORDER BY ss.sequence_number";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, scheduleId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                ScheduleStation scheduleStation = mapResultSetToScheduleStation(rs);
                scheduleStations.add(scheduleStation);
            }
        }
        return scheduleStations;
    }

    /**
     * Get all stations for a schedule with station details, ordered by sequence number
     */
    public List<Station> getStationsByScheduleAsStations(UUID scheduleId) throws SQLException {
        List<Station> stations = new ArrayList<>();
        String sql = "SELECT s.* " +
                "FROM ScheduleStations ss " +
                "JOIN Stations s ON ss.station_id = s.station_id " +
                "WHERE ss.schedule_id = ? AND s.status = 'ACTIVE' " +
                "ORDER BY ss.sequence_number";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, scheduleId);
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
     * Add a station to a schedule
     */
    public boolean addStationToSchedule(UUID scheduleId, UUID stationId, int sequenceNumber)
            throws SQLException {
        String sql = "INSERT INTO ScheduleStations (schedule_station_id, schedule_id, station_id, sequence_number) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            ScheduleStation scheduleStation = new ScheduleStation(scheduleId, stationId, sequenceNumber);
            stmt.setObject(1, scheduleStation.getScheduleStationId());
            stmt.setObject(2, scheduleId);
            stmt.setObject(3, stationId);
            stmt.setInt(4, sequenceNumber);

            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Remove all stations from a schedule
     */
    public boolean removeAllStationsFromSchedule(UUID scheduleId) throws SQLException {
        String sql = "DELETE FROM ScheduleStations WHERE schedule_id = ?";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, scheduleId);
            return stmt.executeUpdate() >= 0; // >= 0 because it's OK if no rows exist
        }
    }

    /**
     * Remove a specific station from a schedule
     */
    public boolean removeStationFromSchedule(UUID scheduleId, UUID stationId) throws SQLException {
        String sql = "DELETE FROM ScheduleStations WHERE schedule_id = ? AND station_id = ?";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, scheduleId);
            stmt.setObject(2, stationId);
            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Update stations for a schedule
     */
    public boolean updateScheduleStations(UUID scheduleId, List<UUID> stationIds)
            throws SQLException {
        // Remove all existing stations
        removeAllStationsFromSchedule(scheduleId);

        // Add stations with new sequence numbers
        if (stationIds != null && !stationIds.isEmpty()) {
            for (int i = 0; i < stationIds.size(); i++) {
                addStationToSchedule(scheduleId, stationIds.get(i), i + 1);
            }
        }
        return true;
    }

    /**
     * Get the maximum sequence number for a schedule
     */
    public int getMaxSequenceNumber(UUID scheduleId) throws SQLException {
        String sql = "SELECT MAX(sequence_number) as max_seq FROM ScheduleStations WHERE schedule_id = ?";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, scheduleId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                int maxSeq = rs.getInt("max_seq");
                return rs.wasNull() ? 0 : maxSeq;
            }
        }
        return 0;
    }

    /**
     * Check if a station is already in a schedule
     */
    public boolean isStationInSchedule(UUID scheduleId, UUID stationId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM ScheduleStations WHERE schedule_id = ? AND station_id = ?";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, scheduleId);
            stmt.setObject(2, stationId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }

    /**
     * Get stations for a schedule that are also in the route
     * This ensures passengers can only book from valid stations
     */
    public List<Station> getValidStationsForBooking(UUID scheduleId) throws SQLException {
        List<Station> stations = new ArrayList<>();
        String sql = "SELECT DISTINCT s.* " +
                "FROM ScheduleStations ss " +
                "JOIN Stations s ON ss.station_id = s.station_id " +
                "WHERE ss.schedule_id = ? AND s.status = 'ACTIVE' " +
                "ORDER BY ss.sequence_number";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, scheduleId);
            ResultSet rs = stmt.executeQuery();

            StationDAO stationDAO = new StationDAO();
            while (rs.next()) {
                Station station = stationDAO.mapResultSetToStation(rs);
                stations.add(station);
            }
        }
        return stations;
    }

    private ScheduleStation mapResultSetToScheduleStation(ResultSet rs) throws SQLException {
        ScheduleStation scheduleStation = new ScheduleStation();

        scheduleStation.setScheduleStationId(
                UUIDUtils.getUUIDFromResultSet(rs, "schedule_station_id"));
        scheduleStation.setScheduleId(UUIDUtils.getUUIDFromResultSet(rs, "schedule_id"));
        scheduleStation.setStationId(UUIDUtils.getUUIDFromResultSet(rs, "station_id"));
        scheduleStation.setSequenceNumber(rs.getInt("sequence_number"));

        Timestamp createdDate = rs.getTimestamp("created_date");
        if (createdDate != null) {
            scheduleStation.setCreatedDate(createdDate.toLocalDateTime());
        }

        // Map station details if available
        try {
            Station station = new Station();
            station.setStationId(scheduleStation.getStationId());
            station.setStationName(rs.getString("station_name"));
            // Try to get city name from joined Cities table
            try {
                String cityName = rs.getString("city_name");
                station.setCity(cityName);
            } catch (SQLException e) {
                // city_name column not available, ignore
            }
            // Also try to get city_id
            try {
                UUID cityId = UUIDUtils.getUUIDFromResultSet(rs, "city_id");
                if (cityId != null) {
                    station.setCityId(cityId);
                }
            } catch (SQLException e) {
                // city_id column not available, ignore
            }
            station.setAddress(rs.getString("address"));
            scheduleStation.setStation(station);
        } catch (SQLException e) {
            // Station details not available, skip
        }

        return scheduleStation;
    }
}

