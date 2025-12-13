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
        String sql = "SELECT s.*, r.route_name, "
                + "depc.city_name AS departure_city, destc.city_name AS destination_city, "
                + "b.bus_number, u.full_name as driver_name "
                + "FROM Schedules s "
                + "JOIN Routes r ON s.route_id = r.route_id "
                + "LEFT JOIN Cities depc ON r.departure_city_id = depc.city_id "
                + "LEFT JOIN Cities destc ON r.destination_city_id = destc.city_id "
                + "JOIN Buses b ON s.bus_id = b.bus_id "
                + "LEFT JOIN ScheduleDrivers sd ON s.schedule_id = sd.schedule_id "
                + "LEFT JOIN Drivers d ON sd.driver_id = d.driver_id "
                + "LEFT JOIN Users u ON d.user_id = u.user_id "
                + "WHERE s.status != 'CANCELLED' " // Exclude cancelled schedules
                + "ORDER BY s.departure_date, s.departure_time";

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
        String sql = "SELECT s.*, r.route_name, "
                + "depc.city_name AS departure_city, destc.city_name AS destination_city, "
                + "b.bus_number, u.full_name as driver_name "
                + "FROM Schedules s "
                + "JOIN Routes r ON s.route_id = r.route_id "
                + "LEFT JOIN Cities depc ON r.departure_city_id = depc.city_id "
                + "LEFT JOIN Cities destc ON r.destination_city_id = destc.city_id "
                + "JOIN Buses b ON s.bus_id = b.bus_id "
                + "LEFT JOIN ScheduleDrivers sd ON s.schedule_id = sd.schedule_id "
                + "LEFT JOIN Drivers d ON sd.driver_id = d.driver_id "
                + "LEFT JOIN Users u ON d.user_id = u.user_id "
                + "WHERE s.status != 'CANCELLED' "
                + "ORDER BY s.departure_date, s.departure_time";

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
        String sql = "SELECT s.*, r.route_name, "
                + "depc.city_name AS departure_city, destc.city_name AS destination_city, "
                + "b.bus_number, u.full_name as driver_name "
                + "FROM Schedules s "
                + "JOIN Routes r ON s.route_id = r.route_id "
                + "LEFT JOIN Cities depc ON r.departure_city_id = depc.city_id "
                + "LEFT JOIN Cities destc ON r.destination_city_id = destc.city_id "
                + "JOIN Buses b ON s.bus_id = b.bus_id "
                + "LEFT JOIN ScheduleDrivers sd ON s.schedule_id = sd.schedule_id "
                + "LEFT JOIN Drivers d ON sd.driver_id = d.driver_id "
                + "LEFT JOIN Users u ON d.user_id = u.user_id "
                + "WHERE s.schedule_id = ?";

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
        String sql = "SELECT s.*, r.route_name, "
                + "depc.city_name AS departure_city, destc.city_name AS destination_city, "
                + "b.bus_number, u.full_name as driver_name "
                + "FROM Schedules s "
                + "JOIN Routes r ON s.route_id = r.route_id "
                + "LEFT JOIN Cities depc ON r.departure_city_id = depc.city_id "
                + "LEFT JOIN Cities destc ON r.destination_city_id = destc.city_id "
                + "JOIN Buses b ON s.bus_id = b.bus_id "
                + "LEFT JOIN ScheduleDrivers sd ON s.schedule_id = sd.schedule_id "
                + "LEFT JOIN Drivers d ON sd.driver_id = d.driver_id "
                + "LEFT JOIN Users u ON d.user_id = u.user_id "
                + "WHERE s.route_id = ? AND s.status = 'SCHEDULED' "
                + "ORDER BY s.departure_date, s.departure_time";

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
        String sql = "SELECT s.*, r.route_name, "
                + "depc.city_name AS departure_city, destc.city_name AS destination_city, "
                + "b.bus_number, u.full_name as driver_name "
                + "FROM Schedules s "
                + "JOIN Routes r ON s.route_id = r.route_id "
                + "LEFT JOIN Cities depc ON r.departure_city_id = depc.city_id "
                + "LEFT JOIN Cities destc ON r.destination_city_id = destc.city_id "
                + "JOIN Buses b ON s.bus_id = b.bus_id "
                + "LEFT JOIN ScheduleDrivers sd ON s.schedule_id = sd.schedule_id "
                + "LEFT JOIN Drivers d ON sd.driver_id = d.driver_id "
                + "LEFT JOIN Users u ON d.user_id = u.user_id "
                + "WHERE s.bus_id = ? AND s.status = 'SCHEDULED' "
                + "ORDER BY s.departure_date, s.departure_time";

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
        String sql = "SELECT s.*, r.route_name, "
                + "depc.city_name AS departure_city, destc.city_name AS destination_city, "
                + "b.bus_number, u.full_name as driver_name "
                + "FROM Schedules s "
                + "JOIN Routes r ON s.route_id = r.route_id "
                + "LEFT JOIN Cities depc ON r.departure_city_id = depc.city_id "
                + "LEFT JOIN Cities destc ON r.destination_city_id = destc.city_id "
                + "JOIN Buses b ON s.bus_id = b.bus_id "
                + "LEFT JOIN ScheduleDrivers sd ON s.schedule_id = sd.schedule_id "
                + "LEFT JOIN Drivers d ON sd.driver_id = d.driver_id "
                + "LEFT JOIN Users u ON d.user_id = u.user_id "
                + "WHERE s.departure_date = ? AND s.status = 'SCHEDULED' "
                + "ORDER BY s.departure_time";

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
        String sql = "SELECT s.*, r.route_name, "
                + "depc.city_name AS departure_city, destc.city_name AS destination_city, "
                + "b.bus_number, u.full_name as driver_name "
                + "FROM Schedules s "
                + "JOIN Routes r ON s.route_id = r.route_id "
                + "LEFT JOIN Cities depc ON r.departure_city_id = depc.city_id "
                + "LEFT JOIN Cities destc ON r.destination_city_id = destc.city_id "
                + "JOIN Buses b ON s.bus_id = b.bus_id "
                + "LEFT JOIN ScheduleDrivers sd ON s.schedule_id = sd.schedule_id "
                + "LEFT JOIN Drivers d ON sd.driver_id = d.driver_id "
                + "LEFT JOIN Users u ON d.user_id = u.user_id "
                + "WHERE depc.city_name = ? AND destc.city_name = ? "
                + "AND s.departure_date = ? AND s.status = 'SCHEDULED' "
                + "ORDER BY s.departure_time";

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
        String sql = "SELECT s.*, r.route_name, "
                + "depc.city_name AS departure_city, destc.city_name AS destination_city, "
                + "b.bus_number, u.full_name as driver_name "
                + "FROM Schedules s "
                + "JOIN Routes r ON s.route_id = r.route_id "
                + "LEFT JOIN Cities depc ON r.departure_city_id = depc.city_id "
                + "LEFT JOIN Cities destc ON r.destination_city_id = destc.city_id "
                + "JOIN Buses b ON s.bus_id = b.bus_id "
                + "LEFT JOIN ScheduleDrivers sd ON s.schedule_id = sd.schedule_id "
                + "LEFT JOIN Drivers d ON sd.driver_id = d.driver_id "
                + "LEFT JOIN Users u ON d.user_id = u.user_id "
                + "WHERE s.route_id = ? AND s.departure_date = ? AND s.status = 'SCHEDULED' "
                + "ORDER BY s.departure_time";

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
        String sql = "SELECT s.*, r.route_name, "
                + "depc.city_name AS departure_city, destc.city_name AS destination_city, "
                + "b.bus_number, u.full_name as driver_name "
                + "FROM Schedules s "
                + "JOIN Routes r ON s.route_id = r.route_id "
                + "LEFT JOIN Cities depc ON r.departure_city_id = depc.city_id "
                + "LEFT JOIN Cities destc ON r.destination_city_id = destc.city_id "
                + "JOIN Buses b ON s.bus_id = b.bus_id "
                + "LEFT JOIN ScheduleDrivers sd ON s.schedule_id = sd.schedule_id "
                + "LEFT JOIN Drivers d ON sd.driver_id = d.driver_id "
                + "LEFT JOIN Users u ON d.user_id = u.user_id "
                + "WHERE s.route_id = ? AND s.bus_id = ? AND s.status = 'SCHEDULED' "
                + "ORDER BY s.departure_date, s.departure_time";

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
        String sql = "SELECT s.*, r.route_name, "
                + "depc.city_name AS departure_city, destc.city_name AS destination_city, "
                + "b.bus_number, u.full_name as driver_name "
                + "FROM Schedules s "
                + "JOIN Routes r ON s.route_id = r.route_id "
                + "LEFT JOIN Cities depc ON r.departure_city_id = depc.city_id "
                + "LEFT JOIN Cities destc ON r.destination_city_id = destc.city_id "
                + "JOIN Buses b ON s.bus_id = b.bus_id "
                + "JOIN ScheduleDrivers sd ON s.schedule_id = sd.schedule_id "
                + "JOIN Drivers d ON sd.driver_id = d.driver_id "
                + "JOIN Users u ON d.user_id = u.user_id "
                + "WHERE sd.driver_id = ? AND s.status != 'CANCELLED' " // Exclude cancelled
                                                                        // schedules
                + "ORDER BY s.departure_date, s.departure_time";

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

    /**
     * Check if bus has time conflicts across all routes (not just same route).
     * This checks for overlapping schedules on any route for the given bus.
     */
    public boolean hasBusTimeConflict(UUID busId, LocalDate departureDate,
            LocalTime departureTime, LocalTime estimatedArrivalTime, UUID excludeScheduleId)
            throws SQLException {
        LocalTime effectiveArrival = estimatedArrivalTime != null ? estimatedArrivalTime
                : departureTime;

        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM Schedules WHERE bus_id = ? "
                        + "AND departure_date = ? AND status != 'CANCELLED' "
                        + "AND NOT (CAST(estimated_arrival_time AS TIME) <= CAST(? AS TIME) "
                        + "OR CAST(departure_time AS TIME) >= CAST(? AS TIME))");

        if (excludeScheduleId != null) {
            sql.append(" AND schedule_id <> ?");
        }

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            stmt.setObject(1, busId);
            stmt.setDate(2, Date.valueOf(departureDate));
            stmt.setTime(3, Time.valueOf(departureTime));
            stmt.setTime(4, Time.valueOf(effectiveArrival));

            if (excludeScheduleId != null) {
                stmt.setObject(5, excludeScheduleId);
            }

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }

        return false;
    }

    /**
     * Check if there's a duplicate schedule (same route, same date, same time)
     * This prevents creating duplicate schedules for the same route on the same day and time
     */
    public boolean hasDuplicateSchedule(UUID routeId, LocalDate departureDate,
            LocalTime departureTime, UUID excludeScheduleId) throws SQLException {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM Schedules WHERE route_id = ? "
                        + "AND departure_date = ? AND departure_time = ? AND status != 'CANCELLED'");

        if (excludeScheduleId != null) {
            sql.append(" AND schedule_id <> ?");
        }

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            stmt.setObject(1, routeId);
            stmt.setDate(2, Date.valueOf(departureDate));
            stmt.setTime(3, Time.valueOf(departureTime));

            if (excludeScheduleId != null) {
                stmt.setObject(4, excludeScheduleId);
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
                "SELECT TOP 1 s.*, r.route_name, "
                        + "depc.city_name AS departure_city, destc.city_name AS destination_city, "
                        + "b.bus_number, u.full_name as driver_name "
                        + "FROM ScheduleDrivers sd "
                        + "JOIN Schedules s ON sd.schedule_id = s.schedule_id "
                        + "JOIN Routes r ON s.route_id = r.route_id "
                        + "LEFT JOIN Cities depc ON r.departure_city_id = depc.city_id "
                        + "LEFT JOIN Cities destc ON r.destination_city_id = destc.city_id "
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

    /**
     * Check if driver can be assigned to a new schedule (must wait 8 hours after last assignment)
     * Returns the number of hours remaining before driver can be assigned, or -1 if driver can be
     * assigned now
     * 
     * @deprecated Use checkDriverScheduleTimeGap instead - checks gap based on schedule completion
     *             time, not assignment time
     */
    @Deprecated
    public double getHoursUntilDriverCanBeAssigned(UUID driverId) throws SQLException {
        String sql = "SELECT TOP 1 assigned_date " +
                "FROM ScheduleDrivers " +
                "WHERE driver_id = ? " +
                "ORDER BY assigned_date DESC";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, driverId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Timestamp lastAssignedDate = rs.getTimestamp("assigned_date");
                if (lastAssignedDate != null) {
                    java.time.LocalDateTime lastAssigned = lastAssignedDate.toLocalDateTime();
                    java.time.LocalDateTime now = java.time.LocalDateTime.now();
                    java.time.Duration duration = java.time.Duration.between(lastAssigned, now);
                    long minutesElapsed = duration.toMinutes();

                    // 8 hours = 480 minutes
                    if (minutesElapsed < 480) {
                        // Calculate remaining hours (including minutes as decimal)
                        double remainingMinutes = 480 - minutesElapsed;
                        double remainingHours = remainingMinutes / 60.0;
                        return remainingHours;
                    }
                }
            }
        }
        // Driver can be assigned now (no previous assignment or more than 8 hours have passed)
        return -1;
    }

    /**
     * Check if there's at least 8 hours gap between the end of driver's existing schedules
     * and the start of the new schedule being assigned.
     * Returns the schedule that violates the 8-hour gap rule, or null if no violation.
     * The gap is calculated from when the existing schedule completes (departure_date +
     * estimated_arrival_time)
     * to when the new schedule starts (departure_date + departure_time).
     */
    public Schedule checkDriverScheduleTimeGap(UUID driverId, LocalDate newDepartureDate,
            LocalTime newDepartureTime, UUID excludeScheduleId, double requiredGapHours)
            throws SQLException {

        // Get all schedules assigned to this driver (excluding the one we're assigning if it
        // exists)
        String sql = "SELECT s.*, r.route_name, "
                + "depc.city_name AS departure_city, destc.city_name AS destination_city, "
                + "b.bus_number, u.full_name as driver_name " +
                "FROM ScheduleDrivers sd " +
                "JOIN Schedules s ON sd.schedule_id = s.schedule_id " +
                "JOIN Routes r ON s.route_id = r.route_id " +
                "LEFT JOIN Cities depc ON r.departure_city_id = depc.city_id " +
                "LEFT JOIN Cities destc ON r.destination_city_id = destc.city_id " +
                "JOIN Buses b ON s.bus_id = b.bus_id " +
                "JOIN Drivers d ON sd.driver_id = d.driver_id " +
                "LEFT JOIN Users u ON d.user_id = u.user_id " +
                "WHERE sd.driver_id = ? AND s.status != 'CANCELLED' ";

        if (excludeScheduleId != null) {
            sql += "AND s.schedule_id <> ? ";
        }

        sql += "ORDER BY s.departure_date, s.estimated_arrival_time DESC";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, driverId);
            if (excludeScheduleId != null) {
                stmt.setObject(2, excludeScheduleId);
            }

            try (ResultSet rs = stmt.executeQuery()) {
                // Calculate new schedule start datetime
                java.time.LocalDateTime newScheduleStart = java.time.LocalDateTime.of(
                        newDepartureDate, newDepartureTime);

                while (rs.next()) {
                    Schedule existingSchedule = mapResultSetToSchedule(rs);

                    // Calculate existing schedule end datetime
                    // estimated_arrival_time might be next day, so we need to handle that
                    java.time.LocalDate existingDepartureDate = existingSchedule.getDepartureDate();
                    java.time.LocalTime existingArrivalTime =
                            existingSchedule.getEstimatedArrivalTime();

                    // If arrival time is earlier than departure time, it's next day
                    java.time.LocalTime existingDepartureTime = existingSchedule.getDepartureTime();
                    java.time.LocalDate existingArrivalDate = existingDepartureDate;
                    if (existingArrivalTime.isBefore(existingDepartureTime) ||
                            existingArrivalTime.equals(existingDepartureTime)) {
                        existingArrivalDate = existingArrivalDate.plusDays(1);
                    }

                    java.time.LocalDateTime existingScheduleEnd = java.time.LocalDateTime.of(
                            existingArrivalDate, existingArrivalTime);

                    // Calculate time gap between existing schedule end and new schedule start
                    java.time.Duration gap = java.time.Duration.between(
                            existingScheduleEnd, newScheduleStart);

                    // Check if gap is less than required rest time
                    long gapMinutes = gap.toMinutes();
                    long requiredGapMinutes = (long) Math.ceil(requiredGapHours * 60);
                    if (gapMinutes < requiredGapMinutes) {
                        // Violation: gap shorter than required rest window
                        return existingSchedule;
                    }
                }
            }
        }

        return null; // No violation found
    }

    /**
     * Calculate the minimum gap in hours between the end of driver's last schedule
     * and the start of the new schedule. Returns negative value if gap is less than 8 hours.
     * Returns Double.MAX_VALUE if driver has no existing schedules.
     */
    public double calculateMinGapBeforeNewSchedule(UUID driverId, LocalDate newDepartureDate,
            LocalTime newDepartureTime, UUID excludeScheduleId) throws SQLException {

        // Get the latest schedule assigned to this driver
        String sql = "SELECT TOP 1 s.*, r.route_name, "
                + "depc.city_name AS departure_city, destc.city_name AS destination_city, "
                + "b.bus_number, u.full_name as driver_name " +
                "FROM ScheduleDrivers sd " +
                "JOIN Schedules s ON sd.schedule_id = s.schedule_id " +
                "JOIN Routes r ON s.route_id = r.route_id " +
                "LEFT JOIN Cities depc ON r.departure_city_id = depc.city_id " +
                "LEFT JOIN Cities destc ON r.destination_city_id = destc.city_id " +
                "JOIN Buses b ON s.bus_id = b.bus_id " +
                "JOIN Drivers d ON sd.driver_id = d.driver_id " +
                "LEFT JOIN Users u ON d.user_id = u.user_id " +
                "WHERE sd.driver_id = ? AND s.status != 'CANCELLED' ";

        if (excludeScheduleId != null) {
            sql += "AND s.schedule_id <> ? ";
        }

        sql += "ORDER BY s.departure_date DESC, s.estimated_arrival_time DESC";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, driverId);
            if (excludeScheduleId != null) {
                stmt.setObject(2, excludeScheduleId);
            }

            try (ResultSet rs = stmt.executeQuery()) {
                if (!rs.next()) {
                    // Driver has no existing schedules, can be assigned
                    // Return a large positive value (999 hours) to indicate available
                    return 999.0;
                }

                Schedule lastSchedule = mapResultSetToSchedule(rs);

                // Calculate last schedule end datetime
                java.time.LocalDate lastDepartureDate = lastSchedule.getDepartureDate();
                java.time.LocalTime lastArrivalTime = lastSchedule.getEstimatedArrivalTime();
                java.time.LocalTime lastDepartureTime = lastSchedule.getDepartureTime();

                // If arrival time is earlier than or equal to departure time, it's next day
                java.time.LocalDate lastArrivalDate = lastDepartureDate;
                if (lastArrivalTime.isBefore(lastDepartureTime) ||
                        lastArrivalTime.equals(lastDepartureTime)) {
                    lastArrivalDate = lastArrivalDate.plusDays(1);
                }

                java.time.LocalDateTime lastScheduleEnd = java.time.LocalDateTime.of(
                        lastArrivalDate, lastArrivalTime);

                // Calculate new schedule start datetime
                java.time.LocalDateTime newScheduleStart = java.time.LocalDateTime.of(
                        newDepartureDate, newDepartureTime);

                // Calculate time gap
                java.time.Duration gap = java.time.Duration.between(
                        lastScheduleEnd, newScheduleStart);

                // Return gap in hours (negative if gap is negative, meaning new schedule starts
                // before last ends)
                double gapHours = gap.toHours() + (gap.toMinutes() % 60) / 60.0;
                return gapHours;
            }
        }
    }

    /**
     * Check if there's at least 8 hours gap between the end of bus's existing schedules
     * and the start of the new schedule being assigned.
     * Returns the schedule that violates the 8-hour gap rule, or null if no violation.
     * The gap is calculated from when the existing schedule completes (departure_date +
     * estimated_arrival_time)
     * to when the new schedule starts (departure_date + departure_time).
     */
    public Schedule checkBusScheduleTimeGap(UUID busId, LocalDate newDepartureDate,
            LocalTime newDepartureTime, UUID excludeScheduleId) throws SQLException {

        // Get all schedules assigned to this bus (excluding the one we're assigning if it exists)
        String sql = "SELECT s.*, r.route_name, "
                + "depc.city_name AS departure_city, destc.city_name AS destination_city, "
                + "b.bus_number, u.full_name as driver_name " +
                "FROM Schedules s " +
                "JOIN Routes r ON s.route_id = r.route_id " +
                "LEFT JOIN Cities depc ON r.departure_city_id = depc.city_id " +
                "LEFT JOIN Cities destc ON r.destination_city_id = destc.city_id " +
                "JOIN Buses b ON s.bus_id = b.bus_id " +
                "LEFT JOIN ScheduleDrivers sd ON s.schedule_id = sd.schedule_id " +
                "LEFT JOIN Drivers d ON sd.driver_id = d.driver_id " +
                "LEFT JOIN Users u ON d.user_id = u.user_id " +
                "WHERE s.bus_id = ? AND s.status != 'CANCELLED' ";

        if (excludeScheduleId != null) {
            sql += "AND s.schedule_id <> ? ";
        }

        sql += "ORDER BY s.departure_date, s.estimated_arrival_time DESC";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, busId);
            if (excludeScheduleId != null) {
                stmt.setObject(2, excludeScheduleId);
            }

            try (ResultSet rs = stmt.executeQuery()) {
                // Calculate new schedule start datetime
                java.time.LocalDateTime newScheduleStart = java.time.LocalDateTime.of(
                        newDepartureDate, newDepartureTime);

                while (rs.next()) {
                    Schedule existingSchedule = mapResultSetToSchedule(rs);

                    // Calculate existing schedule end datetime
                    // estimated_arrival_time might be next day, so we need to handle that
                    java.time.LocalDate existingDepartureDate = existingSchedule.getDepartureDate();
                    java.time.LocalTime existingArrivalTime =
                            existingSchedule.getEstimatedArrivalTime();

                    // If arrival time is earlier than departure time, it's next day
                    java.time.LocalTime existingDepartureTime = existingSchedule.getDepartureTime();
                    java.time.LocalDate existingArrivalDate = existingDepartureDate;
                    if (existingArrivalTime.isBefore(existingDepartureTime) ||
                            existingArrivalTime.equals(existingDepartureTime)) {
                        existingArrivalDate = existingArrivalDate.plusDays(1);
                    }

                    java.time.LocalDateTime existingScheduleEnd = java.time.LocalDateTime.of(
                            existingArrivalDate, existingArrivalTime);

                    // Calculate time gap between existing schedule end and new schedule start
                    java.time.Duration gap = java.time.Duration.between(
                            existingScheduleEnd, newScheduleStart);

                    // Check if gap is less than 8 hours (480 minutes)
                    long gapMinutes = gap.toMinutes();
                    if (gapMinutes < 480) {
                        // Violation: less than 8 hours gap
                        return existingSchedule;
                    }
                }
            }
        }

        return null; // No violation found
    }

    /**
     * Calculate the minimum gap in hours between the end of bus's last schedule
     * and the start of the new schedule. Returns negative value if gap is less than 8 hours.
     * Returns 999.0 if bus has no existing schedules.
     */
    public double calculateMinGapBeforeNewScheduleForBus(UUID busId, LocalDate newDepartureDate,
            LocalTime newDepartureTime, UUID excludeScheduleId) throws SQLException {

        // Get the latest schedule assigned to this bus
        String sql = "SELECT TOP 1 s.*, r.route_name, "
                + "depc.city_name AS departure_city, destc.city_name AS destination_city, "
                + "b.bus_number, u.full_name as driver_name " +
                "FROM Schedules s " +
                "JOIN Routes r ON s.route_id = r.route_id " +
                "LEFT JOIN Cities depc ON r.departure_city_id = depc.city_id " +
                "LEFT JOIN Cities destc ON r.destination_city_id = destc.city_id " +
                "JOIN Buses b ON s.bus_id = b.bus_id " +
                "LEFT JOIN ScheduleDrivers sd ON s.schedule_id = sd.schedule_id " +
                "LEFT JOIN Drivers d ON sd.driver_id = d.driver_id " +
                "LEFT JOIN Users u ON d.user_id = u.user_id " +
                "WHERE s.bus_id = ? AND s.status != 'CANCELLED' ";

        if (excludeScheduleId != null) {
            sql += "AND s.schedule_id <> ? ";
        }

        sql += "ORDER BY s.departure_date DESC, s.estimated_arrival_time DESC";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, busId);
            if (excludeScheduleId != null) {
                stmt.setObject(2, excludeScheduleId);
            }

            try (ResultSet rs = stmt.executeQuery()) {
                if (!rs.next()) {
                    // Bus has no existing schedules, can be assigned
                    // Return a large positive value (999 hours) to indicate available
                    return 999.0;
                }

                Schedule lastSchedule = mapResultSetToSchedule(rs);

                // Calculate last schedule end datetime
                java.time.LocalDate lastDepartureDate = lastSchedule.getDepartureDate();
                java.time.LocalTime lastArrivalTime = lastSchedule.getEstimatedArrivalTime();
                java.time.LocalTime lastDepartureTime = lastSchedule.getDepartureTime();

                // If arrival time is earlier than or equal to departure time, it's next day
                java.time.LocalDate lastArrivalDate = lastDepartureDate;
                if (lastArrivalTime.isBefore(lastDepartureTime) ||
                        lastArrivalTime.equals(lastDepartureTime)) {
                    lastArrivalDate = lastArrivalDate.plusDays(1);
                }

                java.time.LocalDateTime lastScheduleEnd = java.time.LocalDateTime.of(
                        lastArrivalDate, lastArrivalTime);

                // Calculate new schedule start datetime
                java.time.LocalDateTime newScheduleStart = java.time.LocalDateTime.of(
                        newDepartureDate, newDepartureTime);

                // Calculate time gap
                java.time.Duration gap = java.time.Duration.between(
                        lastScheduleEnd, newScheduleStart);

                // Return gap in hours (negative if gap is negative, meaning new schedule starts
                // before last ends)
                double gapHours = gap.toHours() + (gap.toMinutes() % 60) / 60.0;
                return gapHours;
            }
        }
    }
}
