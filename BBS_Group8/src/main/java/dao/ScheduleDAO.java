package dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Time;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import model.Schedule;
import util.DBConnection;
import util.UUIDUtils;
/**
 *
 * @author PhúcNH CE190359
 */
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
                "WHERE s.status = 'SCHEDULED' " +
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
                "WHERE s.schedule_id = ? AND s.status = 'SCHEDULED'";

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

    public List<Schedule> searchSchedules(String departureCity, String destinationCity, LocalDate date)
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

    public boolean addSchedule(Schedule schedule) throws SQLException {
        String sql = "INSERT INTO Schedules (schedule_id, route_id, bus_id, departure_date, departure_time, estimated_arrival_time, available_seats, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

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

    public boolean updateSchedule(Schedule schedule) throws SQLException {
        String sql = "UPDATE Schedules SET route_id = ?, bus_id = ?, departure_date = ?, departure_time = ?, estimated_arrival_time = ?, available_seats = ?, status = ?, updated_date = GETDATE() WHERE schedule_id = ?";

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

        System.out.println("=== DEBUG: getSchedulesByRouteAndBus ===");
        System.out.println("RouteId: " + routeId);
        System.out.println("BusId: " + busId);
        System.out.println("SQL: " + sql);

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, routeId);
            stmt.setObject(2, busId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Schedule schedule = mapResultSetToSchedule(rs);
                schedules.add(schedule);
            }

            System.out.println("Found " + schedules.size() + " schedules for route " + routeId + " and bus " + busId);
        }
        return schedules;
    }

    public boolean deleteSchedule(UUID scheduleId) throws SQLException {
        String sql = "UPDATE Schedules SET status = 'CANCELLED', updated_date = GETDATE() WHERE schedule_id = ?";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, scheduleId);
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean updateAvailableSeats(UUID scheduleId, int seatsToReserve) throws SQLException {
        String sql = "UPDATE Schedules SET available_seats = available_seats - ?, updated_date = GETDATE() WHERE schedule_id = ? AND available_seats >= ?";

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
        String sql = "SELECT s.schedule_id, s.route_id, s.bus_id, r.route_name, b.bus_number, s.departure_date, s.status "
                +
                "FROM Schedules s " +
                "JOIN Routes r ON s.route_id = r.route_id " +
                "JOIN Buses b ON s.bus_id = b.bus_id " +
                "ORDER BY s.departure_date";

        System.out.println("=== DEBUG: All Schedules in Database ===");
        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                System.out.println("ScheduleId: " + rs.getString("schedule_id") +
                        ", RouteId: " + rs.getString("route_id") +
                        ", BusId: " + rs.getString("bus_id") +
                        ", Route: " + rs.getString("route_name") +
                        ", Bus: " + rs.getString("bus_number") +
                        ", Date: " + rs.getDate("departure_date") +
                        ", Status: " + rs.getString("status"));
            }
        }
        System.out.println("=== END DEBUG ===");
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
}
