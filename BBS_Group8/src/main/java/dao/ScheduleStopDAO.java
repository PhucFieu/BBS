package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Time;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import model.ScheduleStop;
import util.DBConnection;
import util.UUIDUtils;

public class ScheduleStopDAO {

    /**
     * Get all schedule stops for a specific schedule
     */
    public List<ScheduleStop> getScheduleStopsByScheduleId(UUID scheduleId) throws SQLException {
        List<ScheduleStop> scheduleStops = new ArrayList<>();
        String sql = "SELECT ss.*, s.station_name, s.city, s.address " +
                "FROM ScheduleStops ss " +
                "JOIN Stations s ON ss.station_id = s.station_id " +
                "WHERE ss.schedule_id = ? " +
                "ORDER BY ss.stop_order";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, scheduleId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                ScheduleStop scheduleStop = mapResultSetToScheduleStop(rs);
                scheduleStops.add(scheduleStop);
            }
        }
        return scheduleStops;
    }

    /**
     * Get schedule stop by ID
     */
    public ScheduleStop getScheduleStopById(UUID scheduleStopId) throws SQLException {
        String sql = "SELECT ss.*, s.station_name, s.city, s.address " +
                "FROM ScheduleStops ss " +
                "JOIN Stations s ON ss.station_id = s.station_id " +
                "WHERE ss.schedule_stop_id = ?";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, scheduleStopId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToScheduleStop(rs);
            }
        }
        return null;
    }

    /**
     * Add a new schedule stop
     */
    public boolean addScheduleStop(ScheduleStop scheduleStop) throws SQLException {
        String sql = "INSERT INTO ScheduleStops (schedule_stop_id, schedule_id, station_id, stop_order, arrival_time, stop_duration_minutes) "
                +
                "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, scheduleStop.getScheduleStopId());
            stmt.setObject(2, scheduleStop.getScheduleId());
            stmt.setObject(3, scheduleStop.getStationId());
            stmt.setInt(4, scheduleStop.getStopOrder());
            stmt.setTime(5, Time.valueOf(scheduleStop.getArrivalTime()));
            stmt.setInt(6, scheduleStop.getStopDurationMinutes());

            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Add multiple schedule stops for a schedule
     */
    public boolean addScheduleStops(List<ScheduleStop> scheduleStops) throws SQLException {
        if (scheduleStops == null || scheduleStops.isEmpty()) {
            return true;
        }

        String sql = "INSERT INTO ScheduleStops (schedule_stop_id, schedule_id, station_id, stop_order, arrival_time, stop_duration_minutes) "
                +
                "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            for (ScheduleStop scheduleStop : scheduleStops) {
                stmt.setObject(1, scheduleStop.getScheduleStopId());
                stmt.setObject(2, scheduleStop.getScheduleId());
                stmt.setObject(3, scheduleStop.getStationId());
                stmt.setInt(4, scheduleStop.getStopOrder());
                stmt.setTime(5, Time.valueOf(scheduleStop.getArrivalTime()));
                stmt.setInt(6, scheduleStop.getStopDurationMinutes());
                stmt.addBatch();
            }

            int[] results = stmt.executeBatch();
            return results.length > 0;
        }
    }

    /**
     * Update a schedule stop
     */
    public boolean updateScheduleStop(ScheduleStop scheduleStop) throws SQLException {
        String sql = "UPDATE ScheduleStops SET station_id = ?, stop_order = ?, arrival_time = ?, stop_duration_minutes = ? "
                +
                "WHERE schedule_stop_id = ?";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, scheduleStop.getStationId());
            stmt.setInt(2, scheduleStop.getStopOrder());
            stmt.setTime(3, Time.valueOf(scheduleStop.getArrivalTime()));
            stmt.setInt(4, scheduleStop.getStopDurationMinutes());
            stmt.setObject(5, scheduleStop.getScheduleStopId());

            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Delete a schedule stop
     */
    public boolean deleteScheduleStop(UUID scheduleStopId) throws SQLException {
        String sql = "DELETE FROM ScheduleStops WHERE schedule_stop_id = ?";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, scheduleStopId);
            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Delete all schedule stops for a schedule
     */
    public boolean deleteScheduleStopsByScheduleId(UUID scheduleId) throws SQLException {
        String sql = "DELETE FROM ScheduleStops WHERE schedule_id = ?";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, scheduleId);
            return stmt.executeUpdate() >= 0; // Return true even if no rows affected
        }
    }

    /**
     * Check if a station is already assigned to a schedule
     */
    public boolean isStationAssignedToSchedule(UUID scheduleId, UUID stationId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM ScheduleStops WHERE schedule_id = ? AND station_id = ?";

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
     * Get the next stop order for a schedule
     */
    public int getNextStopOrder(UUID scheduleId) throws SQLException {
        String sql = "SELECT COALESCE(MAX(stop_order), 0) + 1 FROM ScheduleStops WHERE schedule_id = ?";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, scheduleId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 1;
    }

    /**
     * Get schedule stops with station details for display
     */
    public List<ScheduleStop> getScheduleStopsWithDetails(UUID scheduleId) throws SQLException {
        List<ScheduleStop> scheduleStops = new ArrayList<>();
        String sql = "SELECT ss.*, s.station_name, s.city, s.address, " +
                "sch.departure_date, sch.departure_time, " +
                "r.route_name, b.bus_number " +
                "FROM ScheduleStops ss " +
                "JOIN Stations s ON ss.station_id = s.station_id " +
                "JOIN Schedules sch ON ss.schedule_id = sch.schedule_id " +
                "JOIN Routes r ON sch.route_id = r.route_id " +
                "JOIN Buses b ON sch.bus_id = b.bus_id " +
                "WHERE ss.schedule_id = ? " +
                "ORDER BY ss.stop_order";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, scheduleId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                ScheduleStop scheduleStop = mapResultSetToScheduleStop(rs);
                scheduleStop.setStationName(rs.getString("station_name"));
                scheduleStop.setCity(rs.getString("city"));
                scheduleStop.setAddress(rs.getString("address"));
                scheduleStop.setRouteName(rs.getString("route_name"));
                scheduleStop.setBusNumber(rs.getString("bus_number"));
                scheduleStops.add(scheduleStop);
            }
        }
        return scheduleStops;
    }

    private ScheduleStop mapResultSetToScheduleStop(ResultSet rs) throws SQLException {
        ScheduleStop scheduleStop = new ScheduleStop();

        scheduleStop.setScheduleStopId(UUIDUtils.getUUIDFromResultSet(rs, "schedule_stop_id"));
        scheduleStop.setScheduleId(UUIDUtils.getUUIDFromResultSet(rs, "schedule_id"));
        scheduleStop.setStationId(UUIDUtils.getUUIDFromResultSet(rs, "station_id"));
        scheduleStop.setStopOrder(rs.getInt("stop_order"));

        Time arrivalTime = rs.getTime("arrival_time");
        if (arrivalTime != null) {
            scheduleStop.setArrivalTime(arrivalTime.toLocalTime());
        }

        scheduleStop.setStopDurationMinutes(rs.getInt("stop_duration_minutes"));

        // Set display fields if available
        if (rs.getString("station_name") != null) {
            scheduleStop.setStationName(rs.getString("station_name"));
        }
        if (rs.getString("city") != null) {
            scheduleStop.setCity(rs.getString("city"));
        }
        if (rs.getString("address") != null) {
            scheduleStop.setAddress(rs.getString("address"));
        }

        return scheduleStop;
    }
}
