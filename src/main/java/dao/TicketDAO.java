package dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import model.Tickets;
import util.DBConnection;
import util.UUIDUtils;

/**
 *
 * @author LamDNB-CE192005
 */

public class TicketDAO {

    public List<Tickets> getAllTickets() throws SQLException {
        List<Tickets> tickets = new ArrayList<>();
        String sql = "SELECT t.*, u.full_name as user_name, u.username, u.email as user_email, "
                + "r.route_name, r.departure_city, r.destination_city, " + "b.bus_number, "
                + "s.departure_date, s.departure_time, " + "dr.full_name as driver_name, "
                + "bs.station_name as boarding_station_name, bs.city as boarding_city, "
                + "as_st.station_name as alighting_station_name, as_st.city as alighting_city, "
                + "ss1.arrival_time as boarding_arrival_time, ss2.arrival_time as alighting_arrival_time "
                + "FROM Tickets t " + "JOIN Users u ON t.user_id = u.user_id "
                + "JOIN Schedules s ON t.schedule_id = s.schedule_id "
                + "JOIN Routes r ON s.route_id = r.route_id "
                + "JOIN Buses b ON s.bus_id = b.bus_id "
                + "LEFT JOIN ScheduleDrivers sd ON s.schedule_id = sd.schedule_id "
                + "LEFT JOIN Drivers d ON sd.driver_id = d.driver_id "
                + "LEFT JOIN Users dr ON d.user_id = dr.user_id "
                + "LEFT JOIN Stations bs ON t.boarding_station_id = bs.station_id "
                + "LEFT JOIN Stations as_st ON t.alighting_station_id = as_st.station_id "
                + "LEFT JOIN ScheduleStops ss1 ON ss1.schedule_id = s.schedule_id AND ss1.station_id = t.boarding_station_id "
                + "LEFT JOIN ScheduleStops ss2 ON ss2.schedule_id = s.schedule_id AND ss2.station_id = t.alighting_station_id "
                + "WHERE t.status IN ('CONFIRMED', 'PENDING', 'COMPLETED') " // Exclude CANCELLED tickets
                + "ORDER BY t.booking_date DESC";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Tickets ticket = mapResultSetToTicket(rs);
                tickets.add(ticket);
            }
        }
        return tickets;
    }

    public Tickets getTicketById(UUID ticketId) throws SQLException {
        String sql = "SELECT t.*, u.full_name as user_name, u.username, u.email as user_email, "
                + "r.route_name, r.departure_city, r.destination_city, " + "b.bus_number, "
                + "s.departure_date, s.departure_time, " + "dr.full_name as driver_name, "
                + "bs.station_name as boarding_station_name, bs.city as boarding_city, "
                + "as_st.station_name as alighting_station_name, as_st.city as alighting_city, "
                + "ss1.arrival_time as boarding_arrival_time, ss2.arrival_time as alighting_arrival_time "
                + "FROM Tickets t " + "JOIN Users u ON t.user_id = u.user_id "
                + "JOIN Schedules s ON t.schedule_id = s.schedule_id "
                + "JOIN Routes r ON s.route_id = r.route_id "
                + "JOIN Buses b ON s.bus_id = b.bus_id "
                + "LEFT JOIN ScheduleDrivers sd ON s.schedule_id = sd.schedule_id "
                + "LEFT JOIN Drivers d ON sd.driver_id = d.driver_id "
                + "LEFT JOIN Users dr ON d.user_id = dr.user_id "
                + "LEFT JOIN Stations bs ON t.boarding_station_id = bs.station_id "
                + "LEFT JOIN Stations as_st ON t.alighting_station_id = as_st.station_id "
                + "LEFT JOIN ScheduleStops ss1 ON ss1.schedule_id = s.schedule_id AND ss1.station_id = t.boarding_station_id "
                + "LEFT JOIN ScheduleStops ss2 ON ss2.schedule_id = s.schedule_id AND ss2.station_id = t.alighting_station_id "
                + "WHERE t.ticket_id = ? AND t.status IN ('CONFIRMED','COMPLETED')";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, ticketId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToTicket(rs);
            }
        }
        return null;
    }

    public Tickets getTicketByNumber(String ticketNumber) throws SQLException {
        String sql = "SELECT t.*, u.full_name as user_name, u.username, u.email as user_email, "
                + "r.route_name, r.departure_city, r.destination_city, " + "b.bus_number, "
                + "s.departure_date, s.departure_time, " + "dr.full_name as driver_name, "
                + "bs.station_name as boarding_station_name, bs.city as boarding_city, "
                + "as_st.station_name as alighting_station_name, as_st.city as alighting_city "
                + "FROM Tickets t " + "JOIN Users u ON t.user_id = u.user_id "
                + "JOIN Schedules s ON t.schedule_id = s.schedule_id "
                + "JOIN Routes r ON s.route_id = r.route_id "
                + "JOIN Buses b ON s.bus_id = b.bus_id "
                + "LEFT JOIN ScheduleDrivers sd ON s.schedule_id = sd.schedule_id "
                + "LEFT JOIN Drivers d ON sd.driver_id = d.driver_id "
                + "LEFT JOIN Users dr ON d.user_id = dr.user_id "
                + "LEFT JOIN Stations bs ON t.boarding_station_id = bs.station_id "
                + "LEFT JOIN Stations as_st ON t.alighting_station_id = as_st.station_id "
                + "WHERE t.ticket_number = ? AND t.status IN ('CONFIRMED','COMPLETED')";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, ticketNumber);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToTicket(rs);
            }
        }
        return null;
    }

    public List<Tickets> getTicketsByUserId(UUID userId) throws SQLException {
        List<Tickets> tickets = new ArrayList<>();
        String sql = "SELECT t.*, u.full_name as user_name, u.username, u.email as user_email, "
                + "r.route_name, r.departure_city, r.destination_city, " + "b.bus_number, "
                + "s.departure_date, s.departure_time, " + "dr.full_name as driver_name, "
                + "bs.station_name as boarding_station_name, bs.city as boarding_city, "
                + "as_st.station_name as alighting_station_name, as_st.city as alighting_city "
                + "FROM Tickets t " + "JOIN Users u ON t.user_id = u.user_id "
                + "JOIN Schedules s ON t.schedule_id = s.schedule_id "
                + "JOIN Routes r ON s.route_id = r.route_id "
                + "JOIN Buses b ON s.bus_id = b.bus_id "
                + "LEFT JOIN ScheduleDrivers sd ON s.schedule_id = sd.schedule_id "
                + "LEFT JOIN Drivers d ON sd.driver_id = d.driver_id "
                + "LEFT JOIN Users dr ON d.user_id = dr.user_id "
                + "LEFT JOIN Stations bs ON t.boarding_station_id = bs.station_id "
                + "LEFT JOIN Stations as_st ON t.alighting_station_id = as_st.station_id "
                + "WHERE t.user_id = ? AND t.status IN ('CONFIRMED','COMPLETED') "
                + "ORDER BY t.booking_date DESC";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, userId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Tickets ticket = mapResultSetToTicket(rs);
                tickets.add(ticket);
            }
        }
        return tickets;
    }

    public boolean addTicket(Tickets ticket) throws SQLException {
        String sql = "INSERT INTO Tickets (ticket_id, ticket_number, schedule_id, user_id, seat_number, ticket_price, booking_date, status, payment_status, boarding_station_id, alighting_station_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, ticket.getTicketId());
            stmt.setString(2, ticket.getTicketNumber());
            stmt.setObject(3, ticket.getScheduleId());
            stmt.setObject(4, ticket.getUserId());
            stmt.setInt(5, ticket.getSeatNumber());
            stmt.setBigDecimal(6, ticket.getTicketPrice());
            stmt.setTimestamp(7, java.sql.Timestamp.valueOf(ticket.getBookingDate()));
            stmt.setString(8, ticket.getStatus());
            stmt.setString(9, ticket.getPaymentStatus());
            if (ticket.getBoardingStationId() != null) {
                stmt.setObject(10, ticket.getBoardingStationId());
            } else {
                stmt.setObject(10, null);
            }
            if (ticket.getAlightingStationId() != null) {
                stmt.setObject(11, ticket.getAlightingStationId());
            } else {
                stmt.setObject(11, null);
            }

            int result = stmt.executeUpdate();
            return result > 0;
        } catch (Exception e) {

            throw e;
        }
    }

    public boolean updateTicket(Tickets ticket) throws SQLException {
        String sql = "UPDATE Tickets SET schedule_id = ?, user_id = ?, seat_number = ?, ticket_price = ?, status = ?, payment_status = ?, boarding_station_id = ?, alighting_station_id = ?, updated_date = GETDATE() WHERE ticket_id = ?";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, ticket.getScheduleId());
            stmt.setObject(2, ticket.getUserId());
            stmt.setInt(3, ticket.getSeatNumber());
            stmt.setBigDecimal(4, ticket.getTicketPrice());
            stmt.setString(5, ticket.getStatus());
            stmt.setString(6, ticket.getPaymentStatus());
            if (ticket.getBoardingStationId() != null) {
                stmt.setObject(7, ticket.getBoardingStationId());
            } else {
                stmt.setObject(7, null);
            }
            if (ticket.getAlightingStationId() != null) {
                stmt.setObject(8, ticket.getAlightingStationId());
            } else {
                stmt.setObject(8, null);
            }
            stmt.setObject(9, ticket.getTicketId());

            return stmt.executeUpdate() > 0;
        }
    }

    public boolean deleteTicket(UUID ticketId) throws SQLException {
        // Soft delete: Change status to CANCELLED instead of hard delete
        // This maintains data integrity and preserves audit trail
        String sql = "UPDATE Tickets SET status = 'CANCELLED', updated_date = GETDATE() WHERE ticket_id = ?";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, ticketId);
            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Hard delete ticket - use with caution
     * First removes related TicketGroup records, then deletes the ticket
     */
    public boolean hardDeleteTicket(UUID ticketId) throws SQLException {
        Connection conn = null;
        try {
            conn = DBConnection.getInstance().getConnection();
            conn.setAutoCommit(false); // Start transaction

            // First, delete related TicketGroup records
            String deleteGroupSql = "DELETE FROM TicketGroups WHERE ticket_id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(deleteGroupSql)) {
                stmt.setObject(1, ticketId);
                stmt.executeUpdate();
            }

            // Then delete the ticket
            String deleteTicketSql = "DELETE FROM Tickets WHERE ticket_id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(deleteTicketSql)) {
                stmt.setObject(1, ticketId);
                int rowsAffected = stmt.executeUpdate();

                if (rowsAffected > 0) {
                    conn.commit(); // Commit transaction
                    return true;
                } else {
                    conn.rollback(); // Rollback if ticket not found
                    return false;
                }
            }

        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback(); // Rollback on error
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            throw e;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true); // Restore auto-commit
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    public boolean isSeatAvailable(UUID scheduleId, int seatNumber) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Tickets WHERE schedule_id = ? AND seat_number = ? AND status = 'CONFIRMED'";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, scheduleId);
            stmt.setInt(2, seatNumber);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) == 0;
            }
        }
        return false;
    }

    public int getTotalTickets() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Tickets WHERE status = 'CONFIRMED'";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    public String generateTicketNumber() {
        return "TK" + System.currentTimeMillis();
    }

    /**
     * Mark user's CONFIRMED tickets as COMPLETED if the schedule's arrival time has
     * passed.
     * Returns number of rows updated.
     */
    public int markCompletedTicketsIfArrivedForUser(UUID userId) throws SQLException {
        String sql = "UPDATE t SET t.status = 'COMPLETED', t.updated_date = GETDATE() " +
                "FROM Tickets t " +
                "JOIN Schedules s ON t.schedule_id = s.schedule_id " +
                "WHERE t.user_id = ? AND t.status = 'CONFIRMED' " +
                // Arrival datetime = departure_date + estimated_arrival_time
                "AND (CAST(s.departure_date AS DATETIME) + CAST(s.estimated_arrival_time AS DATETIME)) <= GETDATE()";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setObject(1, userId);
            return stmt.executeUpdate();
        }
    }

    // Additional methods for backward compatibility
    public List<Tickets> getRecentTickets(int limit) throws SQLException {
        List<Tickets> tickets = new ArrayList<>();
        String sql = "SELECT TOP " + limit
                + " t.*, u.full_name as user_name, u.username, u.email as user_email, "
                + "r.route_name, r.departure_city, r.destination_city, " + "b.bus_number, "
                + "s.departure_date, s.departure_time, " + "dr.full_name as driver_name "
                + "FROM Tickets t " + "LEFT JOIN Schedules s ON t.schedule_id = s.schedule_id "
                + "LEFT JOIN Routes r ON s.route_id = r.route_id "
                + "LEFT JOIN Buses b ON s.bus_id = b.bus_id "
                + "LEFT JOIN Users u ON t.user_id = u.user_id "
                + "LEFT JOIN ScheduleDrivers sd ON s.schedule_id = sd.schedule_id "
                + "LEFT JOIN Drivers d ON sd.driver_id = d.driver_id "
                + "LEFT JOIN Users dr ON d.user_id = dr.user_id " + "WHERE t.status = 'CONFIRMED' "
                + "ORDER BY t.booking_date DESC";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Tickets ticket = mapResultSetToTicket(rs);
                tickets.add(ticket);
            }
        }
        return tickets;
    }

    public List<Tickets> getTicketsByMonth() throws SQLException {
        List<Tickets> tickets = new ArrayList<>();
        String sql = "SELECT t.*, u.full_name as user_name, u.username, u.email as user_email, "
                + "r.route_name, r.departure_city, r.destination_city, " + "b.bus_number, "
                + "s.departure_date, s.departure_time, " + "dr.full_name as driver_name "
                + "FROM Tickets t " + "LEFT JOIN Schedules s ON t.schedule_id = s.schedule_id "
                + "LEFT JOIN Routes r ON s.route_id = r.route_id "
                + "LEFT JOIN Buses b ON s.bus_id = b.bus_id "
                + "LEFT JOIN Users u ON t.user_id = u.user_id "
                + "LEFT JOIN ScheduleDrivers sd ON s.schedule_id = sd.schedule_id "
                + "LEFT JOIN Drivers d ON sd.driver_id = d.driver_id "
                + "LEFT JOIN Users dr ON d.user_id = dr.user_id "
                + "WHERE t.status = 'CONFIRMED' AND MONTH(t.booking_date) = MONTH(GETDATE()) AND YEAR(t.booking_date) = YEAR(GETDATE()) "
                + "ORDER BY t.booking_date DESC";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Tickets ticket = mapResultSetToTicket(rs);
                tickets.add(ticket);
            }
        }
        return tickets;
    }

    public List<Integer> getBookedSeats(UUID busId, java.time.LocalDate date,
            java.time.LocalTime time) throws SQLException {
        List<Integer> bookedSeats = new ArrayList<>();
        String sql = "SELECT t.seat_number FROM Tickets t "
                + "JOIN Schedules s ON t.schedule_id = s.schedule_id "
                + "WHERE s.bus_id = ? AND s.departure_date = ? AND s.departure_time = CAST(? AS TIME) AND t.status = 'CONFIRMED'";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, busId);
            stmt.setDate(2, java.sql.Date.valueOf(date));
            stmt.setTime(3, java.sql.Time.valueOf(time));
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                bookedSeats.add(rs.getInt("seat_number"));
            }
        }
        return bookedSeats;
    }

    public List<Tickets> getTicketsByPassenger(int passengerId) throws SQLException {
        // This method is deprecated in new schema, return empty list
        return new ArrayList<>();
    }

    public List<Tickets> getTicketsByDate(java.sql.Date date) throws SQLException {
        List<Tickets> tickets = new ArrayList<>();
        String sql = "SELECT t.*, u.full_name as user_name, u.username, u.email as user_email, "
                + "r.route_name, r.departure_city, r.destination_city, " + "b.bus_number, "
                + "s.departure_date, s.departure_time, " + "dr.full_name as driver_name "
                + "FROM Tickets t " + "JOIN Users u ON t.user_id = u.user_id "
                + "JOIN Schedules s ON t.schedule_id = s.schedule_id "
                + "JOIN Routes r ON s.route_id = r.route_id "
                + "JOIN Buses b ON s.bus_id = b.bus_id "
                + "LEFT JOIN ScheduleDrivers sd ON s.schedule_id = sd.schedule_id "
                + "LEFT JOIN Drivers d ON sd.driver_id = d.driver_id "
                + "LEFT JOIN Users dr ON d.user_id = dr.user_id "
                + "WHERE s.departure_date = ? AND t.status IN ('CONFIRMED','COMPLETED') "
                + "ORDER BY t.booking_date DESC";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setDate(1, date);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Tickets ticket = mapResultSetToTicket(rs);
                tickets.add(ticket);
            }
        }
        return tickets;
    }

    public boolean isTicketOwnedByUser(UUID ticketId, UUID userId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Tickets WHERE ticket_id = ? AND user_id = ? AND status IN ('CONFIRMED','COMPLETED')";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, ticketId);
            stmt.setObject(2, userId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }

    // Overloaded method for backward compatibility
    public boolean isSeatAvailable(UUID busId, int seatNumber, java.sql.Date date,
            java.sql.Time time) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Tickets t "
                + "JOIN Schedules s ON t.schedule_id = s.schedule_id "
                + "WHERE s.bus_id = ? AND t.seat_number = ? AND s.departure_date = ? AND s.departure_time = ? AND t.status = 'CONFIRMED'";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, busId);
            stmt.setInt(2, seatNumber);
            stmt.setDate(3, date);
            stmt.setTime(4, time);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) == 0;
            }
        }
        return false;
    }

    private Tickets mapResultSetToTicket(ResultSet rs) throws SQLException {
        Tickets ticket = new Tickets();
        ticket.setTicketId(UUIDUtils.getUUIDFromResultSet(rs, "ticket_id"));
        ticket.setTicketNumber(rs.getString("ticket_number"));
        ticket.setScheduleId(UUIDUtils.getUUIDFromResultSet(rs, "schedule_id"));
        ticket.setUserId(UUIDUtils.getUUIDFromResultSet(rs, "user_id"));
        ticket.setSeatNumber(rs.getInt("seat_number"));
        ticket.setTicketPrice(rs.getBigDecimal("ticket_price"));
        ticket.setBookingDate(rs.getTimestamp("booking_date").toLocalDateTime());
        ticket.setStatus(rs.getString("status"));
        ticket.setPaymentStatus(rs.getString("payment_status"));
        ticket.setCreatedDate(rs.getTimestamp("created_date").toLocalDateTime());
        ticket.setUpdatedDate(rs.getTimestamp("updated_date").toLocalDateTime());

        // Station IDs
        java.sql.ResultSetMetaData metaData = rs.getMetaData();
        int columnCount = metaData.getColumnCount();
        for (int i = 1; i <= columnCount; i++) {
            String columnName = metaData.getColumnName(i);
            if ("boarding_station_id".equalsIgnoreCase(columnName)) {
                Object boardingId = rs.getObject("boarding_station_id");
                if (boardingId != null) {
                    ticket.setBoardingStationId(UUID.fromString(boardingId.toString()));
                }
            }
            if ("alighting_station_id".equalsIgnoreCase(columnName)) {
                Object alightingId = rs.getObject("alighting_station_id");
                if (alightingId != null) {
                    ticket.setAlightingStationId(UUID.fromString(alightingId.toString()));
                }
            }
        }

        // Display fields from joins
        ticket.setUserName(rs.getString("user_name"));
        ticket.setUsername(rs.getString("username"));
        ticket.setUserEmail(rs.getString("user_email"));
        ticket.setRouteName(rs.getString("route_name"));
        ticket.setDepartureCity(rs.getString("departure_city"));
        ticket.setDestinationCity(rs.getString("destination_city"));
        ticket.setBusNumber(rs.getString("bus_number"));
        ticket.setDriverName(rs.getString("driver_name"));

        // Station names (may be null if not joined)
        try {
            ticket.setBoardingStationName(rs.getString("boarding_station_name"));
            ticket.setBoardingCity(rs.getString("boarding_city"));
            ticket.setAlightingStationName(rs.getString("alighting_station_name"));
            ticket.setAlightingCity(rs.getString("alighting_city"));
            java.sql.Time boardingArrival = null;
            java.sql.Time alightingArrival = null;
            try {
                boardingArrival = rs.getTime("boarding_arrival_time");
            } catch (SQLException ignored) {
            }
            try {
                alightingArrival = rs.getTime("alighting_arrival_time");
            } catch (SQLException ignored) {
            }
            if (boardingArrival != null) {
                ticket.setBoardingArrivalTime(boardingArrival.toLocalTime());
            }
            if (alightingArrival != null) {
                ticket.setAlightingArrivalTime(alightingArrival.toLocalTime());
            }
        } catch (SQLException e) {
            // Columns might not exist in older queries, ignore
        }

        // Handle date and time fields
        java.sql.Date departureDate = rs.getDate("departure_date");
        if (departureDate != null) {
            ticket.setDepartureDate(departureDate.toLocalDate());
        }

        java.sql.Time departureTime = rs.getTime("departure_time");
        if (departureTime != null) {
            ticket.setDepartureTime(departureTime.toLocalTime());
        }

        return ticket;
    }

    /**
     * Get tickets by schedule ID
     */
    public List<Tickets> getTicketsByScheduleId(UUID scheduleId) throws SQLException {
        List<Tickets> tickets = new ArrayList<>();
        String sql = "SELECT t.*, "
                + "u.full_name as user_name, u.username, u.email as user_email, "
                + "s.departure_date, s.departure_time, "
                + "r.route_name, r.departure_city, r.destination_city, "
                + "b.bus_number, dr.full_name as driver_name, "
                + "bs.station_name as boarding_station_name, bs.city as boarding_city, "
                + "as_st.station_name as alighting_station_name, as_st.city as alighting_city "
                + "FROM Tickets t "
                + "JOIN Users u ON t.user_id = u.user_id "
                + "JOIN Schedules s ON t.schedule_id = s.schedule_id "
                + "JOIN Routes r ON s.route_id = r.route_id "
                + "JOIN Buses b ON s.bus_id = b.bus_id "
                + "LEFT JOIN ScheduleDrivers sd ON s.schedule_id = sd.schedule_id "
                + "LEFT JOIN Drivers d ON sd.driver_id = d.driver_id "
                + "LEFT JOIN Users dr ON d.user_id = dr.user_id "
                + "LEFT JOIN Stations bs ON t.boarding_station_id = bs.station_id "
                + "LEFT JOIN Stations as_st ON t.alighting_station_id = as_st.station_id "
                + "WHERE t.schedule_id = ? AND t.status = 'CONFIRMED' "
                + "ORDER BY t.seat_number";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, scheduleId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Tickets ticket = mapResultSetToTicket(rs);
                tickets.add(ticket);
            }
        }
        return tickets;
    }

    /**
     * Check if driver has any pending tickets
     */
    public boolean hasDriverPendingTickets(UUID driverId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Tickets t "
                + "JOIN Schedules s ON t.schedule_id = s.schedule_id "
                + "JOIN ScheduleDrivers sd ON s.schedule_id = sd.schedule_id "
                + "WHERE sd.driver_id = ? AND t.status IN ('PENDING', 'CONFIRMED')";

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
     * Check if seat is available for update (excluding current ticket)
     */
    public boolean isSeatAvailableForUpdate(UUID scheduleId, int seatNumber, UUID excludeTicketId)
            throws SQLException {
        String sql = "SELECT COUNT(*) FROM Tickets WHERE schedule_id = ? AND seat_number = ? AND status = 'CONFIRMED' AND ticket_id != ?";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, scheduleId);
            stmt.setInt(2, seatNumber);
            stmt.setObject(3, excludeTicketId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) == 0;
            }
        }
        return false;
    }

    /**
     * Search tickets with advanced filters
     */
    public List<Tickets> searchTickets(String searchTerm, String status, String paymentStatus,
            java.sql.Date dateFrom, java.sql.Date dateTo, BigDecimal priceFrom, BigDecimal priceTo)
            throws SQLException {
        List<Tickets> tickets = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT t.*, u.full_name as user_name, u.username, u.email as user_email, ");
        sql.append("r.route_name, r.departure_city, r.destination_city, ");
        sql.append("b.bus_number, ");
        sql.append("s.departure_date, s.departure_time, ");
        sql.append("dr.full_name as driver_name, ");
        sql.append("bs.station_name as boarding_station_name, bs.city as boarding_city, ");
        sql.append("as_st.station_name as alighting_station_name, as_st.city as alighting_city, ");
        sql.append("ss1.arrival_time as boarding_arrival_time, ss2.arrival_time as alighting_arrival_time ");
        sql.append("FROM Tickets t ");
        sql.append("JOIN Users u ON t.user_id = u.user_id ");
        sql.append("JOIN Schedules s ON t.schedule_id = s.schedule_id ");
        sql.append("JOIN Routes r ON s.route_id = r.route_id ");
        sql.append("JOIN Buses b ON s.bus_id = b.bus_id ");
        sql.append("LEFT JOIN ScheduleDrivers sd ON s.schedule_id = sd.schedule_id ");
        sql.append("LEFT JOIN Drivers d ON sd.driver_id = d.driver_id ");
        sql.append("LEFT JOIN Users dr ON d.user_id = dr.user_id ");
        sql.append("LEFT JOIN Stations bs ON t.boarding_station_id = bs.station_id ");
        sql.append("LEFT JOIN Stations as_st ON t.alighting_station_id = as_st.station_id ");
        sql.append(
                "LEFT JOIN ScheduleStops ss1 ON ss1.schedule_id = s.schedule_id AND ss1.station_id = t.boarding_station_id ");
        sql.append(
                "LEFT JOIN ScheduleStops ss2 ON ss2.schedule_id = s.schedule_id AND ss2.station_id = t.alighting_station_id ");
        sql.append("WHERE 1=1 ");

        List<Object> parameters = new ArrayList<>();

        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            sql.append(
                    "AND (t.ticket_number LIKE ? OR u.full_name LIKE ? OR u.email LIKE ? OR u.phone_number LIKE ?) ");
            String searchPattern = "%" + searchTerm + "%";
            parameters.add(searchPattern);
            parameters.add(searchPattern);
            parameters.add(searchPattern);
            parameters.add(searchPattern);
        }

        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND t.status = ? ");
            parameters.add(status);
        } else {
            // Exclude CANCELLED tickets when no status filter is specified (hidden when
            // deleted)
            sql.append("AND t.status != 'CANCELLED' ");
        }

        if (paymentStatus != null && !paymentStatus.trim().isEmpty()) {
            sql.append("AND t.payment_status = ? ");
            parameters.add(paymentStatus);
        }

        if (dateFrom != null) {
            sql.append("AND s.departure_date >= ? ");
            parameters.add(dateFrom);
        }

        if (dateTo != null) {
            sql.append("AND s.departure_date <= ? ");
            parameters.add(dateTo);
        }

        if (priceFrom != null) {
            sql.append("AND t.ticket_price >= ? ");
            parameters.add(priceFrom);
        }

        if (priceTo != null) {
            sql.append("AND t.ticket_price <= ? ");
            parameters.add(priceTo);
        }

        sql.append("ORDER BY t.booking_date DESC");

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < parameters.size(); i++) {
                stmt.setObject(i + 1, parameters.get(i));
            }

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Tickets ticket = mapResultSetToTicket(rs);
                tickets.add(ticket);
            }
        }
        return tickets;
    }

    /**
     * Get ticket statistics for admin dashboard
     */
    public java.util.Map<String, Object> getTicketStatistics() throws SQLException {
        java.util.Map<String, Object> stats = new java.util.HashMap<>();

        // Total tickets
        String totalSql = "SELECT COUNT(*) FROM Tickets";
        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(totalSql);
                ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                stats.put("totalTickets", rs.getInt(1));
            }
        }

        // Confirmed tickets
        String confirmedSql = "SELECT COUNT(*) FROM Tickets WHERE status = 'CONFIRMED'";
        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(confirmedSql);
                ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                stats.put("confirmedTickets", rs.getInt(1));
            }
        }

        // Pending tickets
        String pendingSql = "SELECT COUNT(*) FROM Tickets WHERE status = 'PENDING'";
        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(pendingSql);
                ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                stats.put("pendingTickets", rs.getInt(1));
            }
        }

        // Cancelled tickets
        String cancelledSql = "SELECT COUNT(*) FROM Tickets WHERE status = 'CANCELLED'";
        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(cancelledSql);
                ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                stats.put("cancelledTickets", rs.getInt(1));
            }
        }

        // Total revenue
        String revenueSql = "SELECT SUM(ticket_price) FROM Tickets WHERE status = 'CONFIRMED' AND payment_status = 'PAID'";
        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(revenueSql);
                ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                stats.put("totalRevenue", rs.getBigDecimal(1));
            }
        }

        return stats;
    }

    /**
     * Get tickets by date range
     */
    public List<Tickets> getTicketsByDateRange(java.sql.Date startDate, java.sql.Date endDate)
            throws SQLException {
        List<Tickets> tickets = new ArrayList<>();
        String sql = "SELECT t.*, u.full_name as user_name, u.username, u.email as user_email, "
                + "r.route_name, r.departure_city, r.destination_city, " + "b.bus_number, "
                + "s.departure_date, s.departure_time, " + "dr.full_name as driver_name "
                + "FROM Tickets t " + "JOIN Users u ON t.user_id = u.user_id "
                + "JOIN Schedules s ON t.schedule_id = s.schedule_id "
                + "JOIN Routes r ON s.route_id = r.route_id "
                + "JOIN Buses b ON s.bus_id = b.bus_id "
                + "LEFT JOIN ScheduleDrivers sd ON s.schedule_id = sd.schedule_id "
                + "LEFT JOIN Drivers d ON sd.driver_id = d.driver_id "
                + "LEFT JOIN Users dr ON d.user_id = dr.user_id "
                + "WHERE s.departure_date BETWEEN ? AND ? "
                + "ORDER BY s.departure_date DESC, s.departure_time DESC";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setDate(1, startDate);
            stmt.setDate(2, endDate);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Tickets ticket = mapResultSetToTicket(rs);
                tickets.add(ticket);
            }
        }
        return tickets;
    }

    /**
     * Get tickets by status
     */
    public List<Tickets> getTicketsByStatus(String status) throws SQLException {
        List<Tickets> tickets = new ArrayList<>();
        String sql = "SELECT t.*, u.full_name as user_name, u.username, u.email as user_email, "
                + "r.route_name, r.departure_city, r.destination_city, " + "b.bus_number, "
                + "s.departure_date, s.departure_time, " + "dr.full_name as driver_name "
                + "FROM Tickets t " + "JOIN Users u ON t.user_id = u.user_id "
                + "JOIN Schedules s ON t.schedule_id = s.schedule_id "
                + "JOIN Routes r ON s.route_id = r.route_id "
                + "JOIN Buses b ON s.bus_id = b.bus_id "
                + "LEFT JOIN ScheduleDrivers sd ON s.schedule_id = sd.schedule_id "
                + "LEFT JOIN Drivers d ON sd.driver_id = d.driver_id "
                + "LEFT JOIN Users dr ON d.user_id = dr.user_id " + "WHERE t.status = ? "
                + "ORDER BY t.booking_date DESC";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, status);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Tickets ticket = mapResultSetToTicket(rs);
                tickets.add(ticket);
            }
        }
        return tickets;
    }

    /**
     * Get tickets by payment status
     */
    public List<Tickets> getTicketsByPaymentStatus(String paymentStatus) throws SQLException {
        List<Tickets> tickets = new ArrayList<>();
        String sql = "SELECT t.*, u.full_name as user_name, u.username, u.email as user_email, "
                + "r.route_name, r.departure_city, r.destination_city, " + "b.bus_number, "
                + "s.departure_date, s.departure_time, " + "dr.full_name as driver_name "
                + "FROM Tickets t " + "JOIN Users u ON t.user_id = u.user_id "
                + "JOIN Schedules s ON t.schedule_id = s.schedule_id "
                + "JOIN Routes r ON s.route_id = r.route_id "
                + "JOIN Buses b ON s.bus_id = b.bus_id "
                + "LEFT JOIN ScheduleDrivers sd ON s.schedule_id = sd.schedule_id "
                + "LEFT JOIN Drivers d ON sd.driver_id = d.driver_id "
                + "LEFT JOIN Users dr ON d.user_id = dr.user_id " + "WHERE t.payment_status = ? "
                + "ORDER BY t.booking_date DESC";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, paymentStatus);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Tickets ticket = mapResultSetToTicket(rs);
                tickets.add(ticket);
            }
        }
        return tickets;
    }

    public List<Integer> getAvailableSeats(UUID scheduleId) throws SQLException {
        List<Integer> bookedSeats = new ArrayList<>();
        String sql = "SELECT seat_number FROM Tickets WHERE schedule_id = ? AND status = 'CONFIRMED'";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, scheduleId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                bookedSeats.add(rs.getInt("seat_number"));
            }
        }
        return bookedSeats;
    }

    public List<Integer> getBookedSeats(UUID scheduleId) throws SQLException {
        return getAvailableSeats(scheduleId); // Same logic - booked seats are confirmed tickets
    }

    /**
     * Get the latest (most recent by departure date/time) ticket of a passenger
     * that belongs to any schedule assigned to the given driver (by driver userId).
     */
    public Tickets getLatestTicketForPassengerByDriver(UUID driverUserId, UUID passengerUserId)
            throws SQLException {
        String sql = "SELECT TOP 1 t.*, u.full_name as user_name, u.username, u.email as user_email, "
                + "s.departure_date, s.departure_time, "
                + "COALESCE(ssb.arrival_time, first_stop.arrival_time) as boarding_arrival_time, "
                + "COALESCE(ssa.arrival_time, last_stop.arrival_time) as alighting_arrival_time, "
                + "COALESCE(bs.station_name, first_stop.station_name) as boarding_station_name, "
                + "COALESCE(bs.city, first_stop.city) as boarding_city, "
                + "COALESCE(as_st.station_name, last_stop.station_name) as alighting_station_name, "
                + "COALESCE(as_st.city, last_stop.city) as alighting_city "
                + "FROM Tickets t "
                + "JOIN Users u ON t.user_id = u.user_id "
                + "JOIN Schedules s ON t.schedule_id = s.schedule_id "
                + "LEFT JOIN ScheduleStops ssb ON ssb.schedule_id = s.schedule_id AND ssb.station_id = t.boarding_station_id "
                + "LEFT JOIN ScheduleStops ssa ON ssa.schedule_id = s.schedule_id AND ssa.station_id = t.alighting_station_id "
                + "OUTER APPLY (SELECT TOP 1 ss.arrival_time, st.station_name, st.city FROM ScheduleStops ss JOIN Stations st ON ss.station_id = st.station_id WHERE ss.schedule_id = s.schedule_id ORDER BY ss.stop_order ASC) first_stop "
                + "OUTER APPLY (SELECT TOP 1 ss.arrival_time, st.station_name, st.city FROM ScheduleStops ss JOIN Stations st ON ss.station_id = st.station_id WHERE ss.schedule_id = s.schedule_id ORDER BY ss.stop_order DESC) last_stop "
                + "JOIN ScheduleDrivers sd ON s.schedule_id = sd.schedule_id "
                + "JOIN Drivers d ON sd.driver_id = d.driver_id "
                + "JOIN Users du ON d.user_id = du.user_id "
                + "LEFT JOIN Stations bs ON t.boarding_station_id = bs.station_id "
                + "LEFT JOIN Stations as_st ON t.alighting_station_id = as_st.station_id "
                + "WHERE du.user_id = ? AND t.user_id = ? AND t.status IN ('PENDING','CONFIRMED','COMPLETED') "
                + "ORDER BY s.departure_date DESC, s.departure_time DESC";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setObject(1, driverUserId);
            stmt.setObject(2, passengerUserId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToTicket(rs);
            }
        }
        return null;
    }
}
