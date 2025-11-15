package dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Time;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import model.Schedule;
import util.DBConnection;
import util.UUIDUtils;

public class ScheduleDAO {

    public List<Schedule> getAllSchedules() throws SQLException {
        List<Schedule> schedules = new ArrayList<>();
        String sql = "SELECT s.*, r.route_name, r.departure_city, r.destination_city, " +
                "b.bus_number, u.full_name as driver_name " +
                "FROM Schedules s " +
                "JOIN Routes r ON s.route_id = r.route_id " +
                "JOIN Buses b ON s.bus_id = b.bus_id " +
                "LEFT JOIN ScheduleDrivers sd ON s.schedule_id = sd.schedule_id " +
                "LEFT JOIN Drivers d ON sd.driver_id = d.driver_id " +
                "LEFT JOIN Users u ON d.user_id = u.user_id " +
                "WHERE s.status != 'CANCELLED' " + // Exclude cancelled schedules
                "ORDER BY s.departure_date, s.departure_time";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Schedule schedule = mapResultSetToSchedule(rs);
                schedules.add(schedule);
            }
        }
        return schedules;
    }

    /**
     * Fetch all schedules regardless of status (for admin views where we need to
     * show real-time status such as DEPARTED/ARRIVED).
     * Excludes CANCELLED schedules (hidden when deleted).
     */
    public List<Schedule> getAllSchedulesAnyStatus() throws SQLException {
        List<Schedule> schedules = new ArrayList<>();
        String sql = "SELECT s.*, r.route_name, r.departure_city, r.destination_city, " +
                "b.bus_number, u.full_name as driver_name " +
                "FROM Schedules s " +
                "JOIN Routes r ON s.route_id = r.route_id " +
                "JOIN Buses b ON s.bus_id = b.bus_id " +
                "LEFT JOIN ScheduleDrivers sd ON s.schedule_id = sd.schedule_id " +
                "LEFT JOIN Drivers d ON sd.driver_id = d.driver_id " +
                "LEFT JOIN Users u ON d.user_id = u.user_id " +
                "WHERE s.status != 'CANCELLED' " +
                "ORDER BY s.departure_date, s.departure_time";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Schedule schedule = mapResultSetToSchedule(rs);
                schedules.add(schedule);
            }
        }
        return schedules;
    }

    public Schedule getScheduleById(UUID scheduleId) throws SQLException {
        String sql = "SELECT s.*, r.route_name, r.departure_city, r.destination_city, " +
                "b.bus_number, u.full_name as driver_name " +
                "FROM Schedules s " +
                "JOIN Routes r ON s.route_id = r.route_id " +
                "JOIN Buses b ON s.bus_id = b.bus_id " +
                "LEFT JOIN ScheduleDrivers sd ON s.schedule_id = sd.schedule_id " +
                "LEFT JOIN Drivers d ON sd.driver_id = d.driver_id " +
                "LEFT JOIN Users u ON d.user_id = u.user_id " +
                "WHERE s.schedule_id = ?";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, scheduleId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToSchedule(rs);
            }
        }
        return null;
    }

    public List<Schedule> getSchedulesByRoute(UUID routeId) throws SQLException {
        List<Schedule> schedules = new ArrayList<>();
        String sql = "SELECT s.*, r.route_name, r.departure_city, r.destination_city, " +
                "b.bus_number, u.full_name as driver_name " +
                "FROM Schedules s " +
                "JOIN Routes r ON s.route_id = r.route_id " +
                "JOIN Buses b ON s.bus_id = b.bus_id " +
                "LEFT JOIN ScheduleDrivers sd ON s.schedule_id = sd.schedule_id " +
                "LEFT JOIN Drivers d ON sd.driver_id = d.driver_id " +
                "LEFT JOIN Users u ON d.user_id = u.user_id " +
                "WHERE s.route_id = ? AND s.status = 'SCHEDULED' " +
                "ORDER BY s.departure_date, s.departure_time";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, routeId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Schedule schedule = mapResultSetToSchedule(rs);
                schedules.add(schedule);
            }
        }
        return schedules;
    }

    public List<Schedule> getSchedulesByBus(UUID busId) throws SQLException {
        List<Schedule> schedules = new ArrayList<>();
        String sql = "SELECT s.*, r.route_name, r.departure_city, r.destination_city, " +
                "b.bus_number, u.full_name as driver_name " +
                "FROM Schedules s " +
                "JOIN Routes r ON s.route_id = r.route_id " +
                "JOIN Buses b ON s.bus_id = b.bus_id " +
                "LEFT JOIN ScheduleDrivers sd ON s.schedule_id = sd.schedule_id " +
                "LEFT JOIN Drivers d ON sd.driver_id = d.driver_id " +
                "LEFT JOIN Users u ON d.user_id = u.user_id " +
                "WHERE s.bus_id = ? AND s.status = 'SCHEDULED' " +
                "ORDER BY s.departure_date, s.departure_time";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, busId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Schedule schedule = mapResultSetToSchedule(rs);
                schedules.add(schedule);
            }
        }
        return schedules;
    }

    public List<Schedule> getSchedulesByDate(LocalDate date) throws SQLException {
        List<Schedule> schedules = new ArrayList<>();
        String sql = "SELECT s.*, r.route_name, r.departure_city, r.destination_city, " +
                "b.bus_number, u.full_name as driver_name " +
                "FROM Schedules s " +
                "JOIN Routes r ON s.route_id = r.route_id " +
                "JOIN Buses b ON s.bus_id = b.bus_id " +
                "LEFT JOIN ScheduleDrivers sd ON s.schedule_id = sd.schedule_id " +
                "LEFT JOIN Drivers d ON sd.driver_id = d.driver_id " +
                "LEFT JOIN Users u ON d.user_id = u.user_id " +
                "WHERE s.departure_date = ? AND s.status = 'SCHEDULED' " +
                "ORDER BY s.departure_time";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setDate(1, Date.valueOf(date));
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Schedule schedule = mapResultSetToSchedule(rs);
                schedules.add(schedule);
            }
        }
        return schedules;
    }

    public List<Schedule> searchSchedules(String departureCity, String destinationCity,
            LocalDate date)
            throws SQLException {
        List<Schedule> schedules = new ArrayList<>();
        String sql = "SELECT s.*, r.route_name, r.departure_city, r.destination_city, " +
                "b.bus_number, u.full_name as driver_name " +
                "FROM Schedules s " +
                "JOIN Routes r ON s.route_id = r.route_id " +
                "JOIN Buses b ON s.bus_id = b.bus_id " +
                "LEFT JOIN ScheduleDrivers sd ON s.schedule_id = sd.schedule_id " +
                "LEFT JOIN Drivers d ON sd.driver_id = d.driver_id " +
                "LEFT JOIN Users u ON d.user_id = u.user_id " +
                "WHERE r.departure_city = ? AND r.destination_city = ? " +
                "AND s.departure_date = ? AND s.status = 'SCHEDULED' " +
                "ORDER BY s.departure_time";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, departureCity);
            stmt.setString(2, destinationCity);
            stmt.setDate(3, Date.valueOf(date));
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Schedule schedule = mapResultSetToSchedule(rs);
                schedules.add(schedule);
            }
        }
        return schedules;
    }

    public List<Schedule> getSchedulesByRouteAndDate(UUID routeId, LocalDate date)
            throws SQLException {
        List<Schedule> schedules = new ArrayList<>();
        String sql = "SELECT s.*, r.route_name, r.departure_city, r.destination_city, " +
                "b.bus_number, u.full_name as driver_name " +
                "FROM Schedules s " +
                "JOIN Routes r ON s.route_id = r.route_id " +
                "JOIN Buses b ON s.bus_id = b.bus_id " +
                "LEFT JOIN ScheduleDrivers sd ON s.schedule_id = sd.schedule_id " +
                "LEFT JOIN Drivers d ON sd.driver_id = d.driver_id " +
                "LEFT JOIN Users u ON d.user_id = u.user_id " +
                "WHERE s.route_id = ? AND s.departure_date = ? AND s.status = 'SCHEDULED' " +
                "ORDER BY s.departure_time";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, routeId);
            stmt.setDate(2, Date.valueOf(date));
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Schedule schedule = mapResultSetToSchedule(rs);
                schedules.add(schedule);
            }
        }
        return schedules;
    }

    public boolean addSchedule(Schedule schedule) throws SQLException {
        String sql =
                "INSERT INTO Schedules (schedule_id, route_id, bus_id, departure_date, departure_time, estimated_arrival_time, available_seats, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, schedule.getScheduleId());
            stmt.setObject(2, schedule.getRouteId());
            stmt.setObject(3, schedule.getBusId());
            stmt.setDate(4, Date.valueOf(schedule.getDepartureDate()));
            stmt.setTime(5, Time.valueOf(schedule.getDepartureTime()));
            stmt.setTime(6, Time.valueOf(schedule.getEstimatedArrivalTime()));
            stmt.setInt(7, schedule.getAvailableSeats());
            stmt.setString(8, schedule.getStatus());

            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Find an existing schedule for route+bus+date+time or create one if missing.
     */
    public java.util.UUID findOrCreateSchedule(java.util.UUID routeId,
            java.util.UUID busId,
            java.time.LocalDate departureDate,
            java.time.LocalTime departureTime,
            int estimatedDurationHours,
            int totalSeats) throws SQLException {
        // Try to find existing schedule first
        String findSql =
                "SELECT schedule_id FROM Schedules WHERE route_id = ? AND bus_id = ? AND departure_date = ? AND departure_time = CAST(? AS TIME) AND status = 'SCHEDULED'";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement findStmt = conn.prepareStatement(findSql)) {

            findStmt.setObject(1, routeId);
            findStmt.setObject(2, busId);
            findStmt.setDate(3, Date.valueOf(departureDate));
            findStmt.setTime(4, Time.valueOf(departureTime));

            try (ResultSet rs = findStmt.executeQuery()) {
                if (rs.next()) {
                    return util.UUIDUtils.getUUIDFromResultSet(rs, "schedule_id");
                }
            }
        }

        // Create a new schedule
        java.time.LocalTime estimatedArrival =
                departureTime.plusHours(Math.max(0, estimatedDurationHours));
        model.Schedule schedule =
                new model.Schedule(routeId, busId, departureDate, departureTime, estimatedArrival,
                        totalSeats);

        boolean inserted = addSchedule(schedule);
        if (!inserted) {
            throw new SQLException(
                    "Failed to create schedule for route " + routeId + ", bus " + busId);
        }
        return schedule.getScheduleId();
    }

    public boolean updateSchedule(Schedule schedule) throws SQLException {
        String sql =
                "UPDATE Schedules SET route_id = ?, bus_id = ?, departure_date = ?, departure_time = ?, estimated_arrival_time = ?, available_seats = ?, status = ?, updated_date = GETDATE() WHERE schedule_id = ?";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, schedule.getRouteId());
            stmt.setObject(2, schedule.getBusId());
            stmt.setDate(3, Date.valueOf(schedule.getDepartureDate()));
            stmt.setTime(4, Time.valueOf(schedule.getDepartureTime()));
            stmt.setTime(5, Time.valueOf(schedule.getEstimatedArrivalTime()));
            stmt.setInt(6, schedule.getAvailableSeats());
            stmt.setString(7, schedule.getStatus());
            stmt.setObject(8, schedule.getScheduleId());

            return stmt.executeUpdate() > 0;
        }
    }

    public List<Schedule> getSchedulesByRouteAndBus(UUID routeId, UUID busId) throws SQLException {
        List<Schedule> schedules = new ArrayList<>();
        String sql = "SELECT s.*, r.route_name, r.departure_city, r.destination_city, " +
                "b.bus_number, u.full_name as driver_name " +
                "FROM Schedules s " +
                "JOIN Routes r ON s.route_id = r.route_id " +
                "JOIN Buses b ON s.bus_id = b.bus_id " +
                "LEFT JOIN ScheduleDrivers sd ON s.schedule_id = sd.schedule_id " +
                "LEFT JOIN Drivers d ON sd.driver_id = d.driver_id " +
                "LEFT JOIN Users u ON d.user_id = u.user_id " +
                "WHERE s.route_id = ? AND s.bus_id = ? AND s.status = 'SCHEDULED' " +
                "ORDER BY s.departure_date, s.departure_time";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, routeId);
            stmt.setObject(2, busId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Schedule schedule = mapResultSetToSchedule(rs);
                schedules.add(schedule);
            }

        }
        return schedules;
    }

    public boolean deleteSchedule(UUID scheduleId) throws SQLException {
        String sql =
                "UPDATE Schedules SET status = 'CANCELLED', updated_date = GETDATE() WHERE schedule_id = ?";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, scheduleId);
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean updateAvailableSeats(UUID scheduleId, int seatsToReserve) throws SQLException {
        String sql =
                "UPDATE Schedules SET available_seats = available_seats - ?, updated_date = GETDATE() WHERE schedule_id = ? AND available_seats >= ?";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, seatsToReserve);
            stmt.setObject(2, scheduleId);
            stmt.setInt(3, seatsToReserve);

            return stmt.executeUpdate() > 0;
        }
    }

    public int getTotalSchedules() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Schedules WHERE status = 'SCHEDULED'";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    public void debugAllSchedules() throws SQLException {
        String sql =
                "SELECT s.schedule_id, s.route_id, s.bus_id, r.route_name, b.bus_number, s.departure_date, s.status "
                        +
                        "FROM Schedules s " +
                        "JOIN Routes r ON s.route_id = r.route_id " +
                        "JOIN Buses b ON s.bus_id = b.bus_id " +
                        "ORDER BY s.departure_date";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
            }
        }

    }

    private Schedule mapResultSetToSchedule(ResultSet rs) throws SQLException {
        Schedule schedule = new Schedule();

        schedule.setScheduleId(UUIDUtils.getUUIDFromResultSet(rs, "schedule_id"));
        schedule.setRouteId(UUIDUtils.getUUIDFromResultSet(rs, "route_id"));
        schedule.setBusId(UUIDUtils.getUUIDFromResultSet(rs, "bus_id"));

        Date departureDate = rs.getDate("departure_date");
        if (departureDate != null) {
            schedule.setDepartureDate(departureDate.toLocalDate());
        }

        Time departureTime = rs.getTime("departure_time");
        if (departureTime != null) {
            schedule.setDepartureTime(departureTime.toLocalTime());
        }

        Time estimatedArrivalTime = rs.getTime("estimated_arrival_time");
        if (estimatedArrivalTime != null) {
            schedule.setEstimatedArrivalTime(estimatedArrivalTime.toLocalTime());
        }

        schedule.setAvailableSeats(rs.getInt("available_seats"));
        schedule.setStatus(rs.getString("status"));

        // Display fields from joins
        schedule.setRouteName(rs.getString("route_name"));
        schedule.setDepartureCity(rs.getString("departure_city"));
        schedule.setDestinationCity(rs.getString("destination_city"));
        schedule.setBusNumber(rs.getString("bus_number"));
        schedule.setDriverName(rs.getString("driver_name"));

        Timestamp createdDate = rs.getTimestamp("created_date");
        if (createdDate != null) {
            schedule.setCreatedDate(createdDate.toLocalDateTime());
        }

        Timestamp updatedDate = rs.getTimestamp("updated_date");
        if (updatedDate != null) {
            schedule.setUpdatedDate(updatedDate.toLocalDateTime());
        }

        return schedule;
    }

    /**
     * Get schedules by driver ID
     */
    public List<Schedule> getSchedulesByDriverId(UUID driverId) throws SQLException {
        List<Schedule> schedules = new ArrayList<>();
        String sql = "SELECT s.*, r.route_name, r.departure_city, r.destination_city, " +
                "b.bus_number, u.full_name as driver_name " +
                "FROM Schedules s " +
                "JOIN Routes r ON s.route_id = r.route_id " +
                "JOIN Buses b ON s.bus_id = b.bus_id " +
                "JOIN ScheduleDrivers sd ON s.schedule_id = sd.schedule_id " +
                "JOIN Drivers d ON sd.driver_id = d.driver_id " +
                "JOIN Users u ON d.user_id = u.user_id " +
                "WHERE sd.driver_id = ? AND s.status != 'CANCELLED' " + // Exclude cancelled
                                                                        // schedules
                "ORDER BY s.departure_date, s.departure_time";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, driverId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Schedule schedule = mapResultSetToSchedule(rs);
                schedules.add(schedule);
            }
        }
        return schedules;
    }

    /**
     * Update schedule status
     */
    public boolean updateScheduleStatus(UUID scheduleId, String status, String notes)
            throws SQLException {
        String sql =
                "UPDATE Schedules SET status = ?, updated_date = GETDATE() WHERE schedule_id = ?";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, status);
            stmt.setObject(2, scheduleId);

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        }
    }

    /**
     * Check if driver has any active schedule assignments
     */
    public boolean hasDriverActiveSchedules(UUID driverId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM ScheduleDrivers sd " +
                "JOIN Schedules s ON sd.schedule_id = s.schedule_id " +
                "WHERE sd.driver_id = ? AND s.status = 'SCHEDULED'";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, driverId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }

    /**
     * Check whether a specific driver is assigned to a schedule
     */
    public boolean isDriverAssignedToSchedule(UUID scheduleId, UUID driverId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM ScheduleDrivers WHERE schedule_id = ? AND driver_id = ?";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, scheduleId);
            stmt.setObject(2, driverId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }

    /**
     * Remove existing driver assignment from schedule
     */
    public boolean removeDriverFromSchedule(UUID scheduleId) throws SQLException {
        String sql = "DELETE FROM ScheduleDrivers WHERE schedule_id = ?";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, scheduleId);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        }
    }

    /**
     * Assign driver to schedule (handles both new assignment and reassignment)
     */
    public boolean assignDriverToSchedule(UUID scheduleId, UUID driverId, boolean allowReassignment)
            throws SQLException {
        Schedule targetSchedule = getScheduleById(scheduleId);
        if (targetSchedule == null) {
            return false;
        }

        Schedule conflictingSchedule =
                findDriverScheduleConflict(driverId, targetSchedule.getRouteId(),
                        targetSchedule.getDepartureDate(), targetSchedule.getDepartureTime(),
                        targetSchedule.getEstimatedArrivalTime(), scheduleId);
        if (conflictingSchedule != null) {
            return false;
        }

        // If not allowing reassignment, check if schedule already has a driver
        if (!allowReassignment) {
            String checkSql = "SELECT COUNT(*) FROM ScheduleDrivers WHERE schedule_id = ?";
            try (Connection conn = DBConnection.getInstance().getConnection();
                    PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
                checkStmt.setObject(1, scheduleId);
                ResultSet rs = checkStmt.executeQuery();
                if (rs.next() && rs.getInt(1) > 0) {
                    return false; // Schedule already has a driver
                }
            }
        }

        // Remove existing assignment if any
        removeDriverFromSchedule(scheduleId);

        // Add new assignment
        String sql =
                "INSERT INTO ScheduleDrivers (schedule_id, driver_id, assigned_date) VALUES (?, ?, GETDATE())";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, scheduleId);
            stmt.setObject(2, driverId);

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        }
    }

    public boolean hasBusScheduleConflict(UUID routeId, UUID busId, LocalDate departureDate,
            LocalTime departureTime, LocalTime estimatedArrivalTime, UUID excludeScheduleId)
            throws SQLException {
        LocalTime effectiveArrival = estimatedArrivalTime != null ? estimatedArrivalTime
                : departureTime;

        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM Schedules WHERE route_id = ? AND bus_id = ? "
                        + "AND departure_date = ? AND status != 'CANCELLED' "
                        + "AND NOT (CAST(estimated_arrival_time AS TIME) <= CAST(? AS TIME) "
                        + "OR CAST(departure_time AS TIME) >= CAST(? AS TIME))");

        if (excludeScheduleId != null) {
            sql.append(" AND schedule_id <> ?");
        }

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            stmt.setObject(1, routeId);
            stmt.setObject(2, busId);
            stmt.setDate(3, Date.valueOf(departureDate));
            stmt.setTime(4, Time.valueOf(departureTime));
            stmt.setTime(5, Time.valueOf(effectiveArrival));

            if (excludeScheduleId != null) {
                stmt.setObject(6, excludeScheduleId);
            }

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }

        return false;
    }

    public boolean hasDriverScheduleConflict(UUID driverId, UUID routeId, LocalDate departureDate,
            LocalTime departureTime, LocalTime estimatedArrivalTime, UUID excludeScheduleId)
            throws SQLException {
        return findDriverScheduleConflict(driverId, routeId, departureDate, departureTime,
                estimatedArrivalTime, excludeScheduleId) != null;
    }

    public Schedule findDriverScheduleConflict(UUID driverId, UUID routeId, LocalDate departureDate,
            LocalTime departureTime, LocalTime estimatedArrivalTime, UUID excludeScheduleId)
            throws SQLException {
        LocalTime effectiveArrival = estimatedArrivalTime != null ? estimatedArrivalTime
                : departureTime;

        StringBuilder sql = new StringBuilder(
                "SELECT TOP 1 s.*, r.route_name, r.departure_city, r.destination_city, "
                        + "b.bus_number, u.full_name as driver_name "
                        + "FROM ScheduleDrivers sd "
                        + "JOIN Schedules s ON sd.schedule_id = s.schedule_id "
                        + "JOIN Routes r ON s.route_id = r.route_id "
                        + "JOIN Buses b ON s.bus_id = b.bus_id "
                        + "JOIN Drivers d ON sd.driver_id = d.driver_id "
                        + "JOIN Users u ON d.user_id = u.user_id "
                        + "WHERE sd.driver_id = ? AND s.route_id = ? "
                        + "AND s.departure_date = ? AND s.status != 'CANCELLED' "
                        + "AND NOT (CAST(s.estimated_arrival_time AS TIME) <= CAST(? AS TIME) "
                        + "OR CAST(s.departure_time AS TIME) >= CAST(? AS TIME))");

        if (excludeScheduleId != null) {
            sql.append(" AND s.schedule_id <> ?");
        }
        sql.append(" ORDER BY s.departure_time ASC");

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            stmt.setObject(1, driverId);
            stmt.setObject(2, routeId);
            stmt.setDate(3, Date.valueOf(departureDate));
            stmt.setTime(4, Time.valueOf(departureTime));
            stmt.setTime(5, Time.valueOf(effectiveArrival));

            if (excludeScheduleId != null) {
                stmt.setObject(6, excludeScheduleId);
            }

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToSchedule(rs);
                }
            }
        }

        return null;
    }
}
