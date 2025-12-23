package dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import model.Bus;
import model.Routes;
import model.Tickets;
import model.User;
import util.DBConnection;
import util.UUIDUtils;

public class TicketDAO {

    public List<Tickets> getAllTickets() throws SQLException {
        List<Tickets> tickets = new ArrayList<>();
        String sql = "SELECT t.*, u.user_id, u.full_name as user_name, u.username, u.email as user_email, u.phone_number, "
                + "r.route_id, r.route_name, depc.city_name AS departure_city, destc.city_name AS destination_city, r.distance, "
                + "b.bus_id, b.bus_number, b.bus_type, b.license_plate, "
                + "s.departure_date, s.departure_time, dr.full_name as driver_name, "
                + "bs.station_name as boarding_station_name, bsc.city_name as boarding_city, "
                + "as_st.station_name as alighting_station_name, ascit.city_name as alighting_city "
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
                + "LEFT JOIN Cities depc ON r.departure_city_id = depc.city_id "
                + "LEFT JOIN Cities destc ON r.destination_city_id = destc.city_id "
                + "LEFT JOIN Cities bsc ON bs.city_id = bsc.city_id "
                + "LEFT JOIN Cities ascit ON as_st.city_id = ascit.city_id "
                + "WHERE t.status IN ('CONFIRMED', 'PENDING', 'COMPLETED', 'CANCELLED') "
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
        String sql = "SELECT t.*, u.user_id, u.full_name as user_name, u.username, u.email as user_email, u.phone_number, "
                + "r.route_id, r.route_name, depc.city_name AS departure_city, destc.city_name AS destination_city, r.distance, "
                + "b.bus_id, b.bus_number, b.bus_type, b.license_plate, "
                + "s.departure_date, s.departure_time, dr.full_name as driver_name, "
                + "bs.station_name as boarding_station_name, bsc.city_name as boarding_city, "
                + "as_st.station_name as alighting_station_name, ascit.city_name as alighting_city "
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
                + "LEFT JOIN Cities depc ON r.departure_city_id = depc.city_id "
                + "LEFT JOIN Cities destc ON r.destination_city_id = destc.city_id "
                + "LEFT JOIN Cities bsc ON bs.city_id = bsc.city_id "
                + "LEFT JOIN Cities ascit ON as_st.city_id = ascit.city_id "
                + "WHERE t.ticket_id = ? AND t.status IN ('CONFIRMED','COMPLETED','CHECKED_IN','PENDING','CANCELLED')";

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
        String sql = "SELECT t.*, u.user_id, u.full_name as user_name, u.username, u.email as user_email, u.phone_number, "
                + "r.route_id, r.route_name, depc.city_name AS departure_city, destc.city_name AS destination_city, r.distance, "
                + "b.bus_id, b.bus_number, b.bus_type, b.license_plate, "
                + "s.departure_date, s.departure_time, dr.full_name as driver_name, "
                + "bs.station_name as boarding_station_name, bsc.city_name as boarding_city, "
                + "as_st.station_name as alighting_station_name, ascit.city_name as alighting_city "
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
                + "LEFT JOIN Cities depc ON r.departure_city_id = depc.city_id "
                + "LEFT JOIN Cities destc ON r.destination_city_id = destc.city_id "
                + "LEFT JOIN Cities bsc ON bs.city_id = bsc.city_id "
                + "LEFT JOIN Cities ascit ON as_st.city_id = ascit.city_id "
                + "WHERE t.ticket_number = ? AND t.status IN ('CONFIRMED','COMPLETED','CHECKED_IN','PENDING','CANCELLED')";

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
        String sql = "SELECT t.*, u.user_id, u.full_name as user_name, u.username, u.email as user_email, u.phone_number, "
                + "r.route_id, r.route_name, depc.city_name AS departure_city, destc.city_name AS destination_city, r.distance, "
                + "b.bus_id, b.bus_number, b.bus_type, b.license_plate, "
                + "s.departure_date, s.departure_time, dr.full_name as driver_name, "
                + "bs.station_name as boarding_station_name, bsc.city_name as boarding_city, "
                + "as_st.station_name as alighting_station_name, ascit.city_name as alighting_city "
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
                + "LEFT JOIN Cities depc ON r.departure_city_id = depc.city_id "
                + "LEFT JOIN Cities destc ON r.destination_city_id = destc.city_id "
                + "LEFT JOIN Cities bsc ON bs.city_id = bsc.city_id "
                + "LEFT JOIN Cities ascit ON as_st.city_id = ascit.city_id "
                + "WHERE t.user_id = ? AND t.status IN ('CONFIRMED','COMPLETED','CHECKED_IN','PENDING','CANCELLED') "
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

    /**
     * Get tickets by user ID with optional filters
     */
    public List<Tickets> getTicketsByUserIdWithFilters(UUID userId, String status,
            String paymentStatus,
            java.sql.Date dateFrom) throws SQLException {
        List<Tickets> tickets = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append(
                "SELECT t.*, u.user_id, u.full_name as user_name, u.username, u.email as user_email, u.phone_number, ");
        sql.append(
                "r.route_id, r.route_name, depc.city_name AS departure_city, destc.city_name AS destination_city, r.distance, ");
        sql.append("b.bus_id, b.bus_number, b.bus_type, b.license_plate, ");
        sql.append("s.departure_date, s.departure_time, ");
        sql.append("dr.full_name as driver_name, ");
        sql.append("bs.station_name as boarding_station_name, bsc.city_name as boarding_city, ");
        sql.append(
                "as_st.station_name as alighting_station_name, ascit.city_name as alighting_city ");
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
        sql.append("LEFT JOIN Cities depc ON r.departure_city_id = depc.city_id ");
        sql.append("LEFT JOIN Cities destc ON r.destination_city_id = destc.city_id ");
        sql.append("LEFT JOIN Cities bsc ON bs.city_id = bsc.city_id ");
        sql.append("LEFT JOIN Cities ascit ON as_st.city_id = ascit.city_id ");
        sql.append("WHERE t.user_id = ? ");

        List<Object> parameters = new ArrayList<>();
        parameters.add(userId);

        // Status filter - include all statuses except CANCELLED by default, or filter
        // by specific
        // status
        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND t.status = ? ");
            parameters.add(status);
        } else {
            // Show all tickets including CANCELLED by default (passenger should see
            // cancelled
            // tickets so they can acknowledge/remove them)
            sql.append("AND t.status IN ('CONFIRMED', 'PENDING', 'COMPLETED', 'CHECKED_IN', 'CANCELLED') ");
        }

        // Payment status filter
        if (paymentStatus != null && !paymentStatus.trim().isEmpty()) {
            sql.append("AND t.payment_status = ? ");
            parameters.add(paymentStatus);
        }

        // Date from filter
        if (dateFrom != null) {
            sql.append("AND s.departure_date >= ? ");
            parameters.add(dateFrom);
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

    public boolean addTicket(Tickets ticket) throws SQLException {
        String sql = "INSERT INTO Tickets (ticket_id, ticket_number, schedule_id, user_id, seat_number, ticket_price, booking_date, status, payment_status, boarding_station_id, alighting_station_id, customer_name, customer_phone, customer_email, notes, created_by_staff_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

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
            stmt.setObject(10, ticket.getBoardingStationId());
            stmt.setObject(11, ticket.getAlightingStationId());
            stmt.setString(12, ticket.getCustomerName());
            stmt.setString(13, ticket.getCustomerPhone());
            stmt.setString(14, ticket.getCustomerEmail());
            stmt.setString(15, ticket.getNotes());
            stmt.setObject(16, ticket.getCreatedByStaffId());

            int result = stmt.executeUpdate();
            return result > 0;
        } catch (Exception e) {

            throw e;
        }
    }

    public boolean updateTicket(Tickets ticket) throws SQLException {
        String sql = "UPDATE Tickets SET schedule_id = ?, user_id = ?, seat_number = ?, ticket_price = ?, status = ?, payment_status = ?, boarding_station_id = ?, alighting_station_id = ?, customer_name = ?, customer_phone = ?, customer_email = ?, notes = ?, checked_in_at = ?, checked_in_by_staff_id = ?, updated_date = GETDATE() WHERE ticket_id = ?";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, ticket.getScheduleId());
            stmt.setObject(2, ticket.getUserId());
            stmt.setInt(3, ticket.getSeatNumber());
            stmt.setBigDecimal(4, ticket.getTicketPrice());
            stmt.setString(5, ticket.getStatus());
            stmt.setString(6, ticket.getPaymentStatus());
            stmt.setObject(7, ticket.getBoardingStationId());
            stmt.setObject(8, ticket.getAlightingStationId());
            stmt.setString(9, ticket.getCustomerName());
            stmt.setString(10, ticket.getCustomerPhone());
            stmt.setString(11, ticket.getCustomerEmail());
            stmt.setString(12, ticket.getNotes());
            if (ticket.getCheckedInAt() != null) {
                stmt.setTimestamp(13, java.sql.Timestamp.valueOf(ticket.getCheckedInAt()));
            } else {
                stmt.setObject(13, null);
            }
            stmt.setObject(14, ticket.getCheckedInByStaffId());
            stmt.setObject(15, ticket.getTicketId());

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
        String sql = "SELECT COUNT(*) FROM Tickets WHERE schedule_id = ? AND seat_number = ? "
                + "AND status NOT IN ('CANCELLED')";

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
                + " t.*, u.user_id, u.full_name as user_name, u.username, u.email as user_email, u.phone_number, "
                + "r.route_id, r.route_name, depc.city_name AS departure_city, destc.city_name AS destination_city, r.distance, "
                + "b.bus_id, b.bus_number, b.bus_type, b.license_plate, "
                + "s.departure_date, s.departure_time, " + "dr.full_name as driver_name "
                + "FROM Tickets t "
                + "LEFT JOIN Schedules s ON t.schedule_id = s.schedule_id "
                + "LEFT JOIN Routes r ON s.route_id = r.route_id "
                + "LEFT JOIN Buses b ON s.bus_id = b.bus_id "
                + "LEFT JOIN Users u ON t.user_id = u.user_id "
                + "LEFT JOIN ScheduleDrivers sd ON s.schedule_id = sd.schedule_id "
                + "LEFT JOIN Drivers d ON sd.driver_id = d.driver_id "
                + "LEFT JOIN Users dr ON d.user_id = dr.user_id "
                + "LEFT JOIN Cities depc ON r.departure_city_id = depc.city_id "
                + "LEFT JOIN Cities destc ON r.destination_city_id = destc.city_id "
                + "WHERE t.status = 'CONFIRMED' "
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
        String sql = "SELECT t.*, u.user_id, u.full_name as user_name, u.username, u.email as user_email, u.phone_number, "
                + "r.route_id, r.route_name, depc.city_name AS departure_city, destc.city_name AS destination_city, r.distance, "
                + "b.bus_id, b.bus_number, b.bus_type, b.license_plate, "
                + "s.departure_date, s.departure_time, " + "dr.full_name as driver_name "
                + "FROM Tickets t "
                + "LEFT JOIN Schedules s ON t.schedule_id = s.schedule_id "
                + "LEFT JOIN Routes r ON s.route_id = r.route_id "
                + "LEFT JOIN Buses b ON s.bus_id = b.bus_id "
                + "LEFT JOIN Users u ON t.user_id = u.user_id "
                + "LEFT JOIN ScheduleDrivers sd ON s.schedule_id = sd.schedule_id "
                + "LEFT JOIN Drivers d ON sd.driver_id = d.driver_id "
                + "LEFT JOIN Users dr ON d.user_id = dr.user_id "
                + "LEFT JOIN Cities depc ON r.departure_city_id = depc.city_id "
                + "LEFT JOIN Cities destc ON r.destination_city_id = destc.city_id "
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
                + "WHERE s.bus_id = ? AND s.departure_date = ? AND s.departure_time = CAST(? AS TIME) "
                + "AND t.status NOT IN ('CANCELLED')";

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
        String sql = "SELECT t.*, u.user_id, u.full_name as user_name, u.username, u.email as user_email, u.phone_number, "
                + "r.route_id, r.route_name, depc.city_name AS departure_city, destc.city_name AS destination_city, r.distance, "
                + "b.bus_id, b.bus_number, b.bus_type, b.license_plate, "
                + "s.departure_date, s.departure_time, " + "dr.full_name as driver_name "
                + "FROM Tickets t " + "JOIN Users u ON t.user_id = u.user_id "
                + "JOIN Schedules s ON t.schedule_id = s.schedule_id "
                + "JOIN Routes r ON s.route_id = r.route_id "
                + "JOIN Buses b ON s.bus_id = b.bus_id "
                + "LEFT JOIN Cities depc ON r.departure_city_id = depc.city_id "
                + "LEFT JOIN Cities destc ON r.destination_city_id = destc.city_id "
                + "LEFT JOIN ScheduleDrivers sd ON s.schedule_id = sd.schedule_id "
                + "LEFT JOIN Drivers d ON sd.driver_id = d.driver_id "
                + "LEFT JOIN Users dr ON d.user_id = dr.user_id "
                + "WHERE s.departure_date = ? AND t.status IN ('CONFIRMED','COMPLETED','CHECKED_IN','PENDING') "
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

    /**
     * Get all checked-in tickets by date
     */
    public List<Tickets> getCheckedInTicketsByDate(java.sql.Date date) throws SQLException {
        List<Tickets> tickets = new ArrayList<>();
        String sql = "SELECT t.*, u.user_id, u.full_name as user_name, u.username, u.email as user_email, u.phone_number, "
                + "r.route_id, r.route_name, depc.city_name AS departure_city, destc.city_name AS destination_city, r.distance, "
                + "b.bus_id, b.bus_number, b.bus_type, b.license_plate, "
                + "s.departure_date, s.departure_time, "
                + "dr.full_name as driver_name, "
                + "bs.station_name as boarding_station_name, bsc.city_name as boarding_city, "
                + "as_st.station_name as alighting_station_name, ascit.city_name as alighting_city "
                + "FROM Tickets t "
                + "JOIN Users u ON t.user_id = u.user_id "
                + "JOIN Schedules s ON t.schedule_id = s.schedule_id "
                + "JOIN Routes r ON s.route_id = r.route_id "
                + "JOIN Buses b ON s.bus_id = b.bus_id "
                + "LEFT JOIN Cities depc ON r.departure_city_id = depc.city_id "
                + "LEFT JOIN Cities destc ON r.destination_city_id = destc.city_id "
                + "LEFT JOIN ScheduleDrivers sd ON s.schedule_id = sd.schedule_id "
                + "LEFT JOIN Drivers d ON sd.driver_id = d.driver_id "
                + "LEFT JOIN Users dr ON d.user_id = dr.user_id "
                + "LEFT JOIN Stations bs ON t.boarding_station_id = bs.station_id "
                + "LEFT JOIN Stations as_st ON t.alighting_station_id = as_st.station_id "
                + "LEFT JOIN Cities bsc ON bs.city_id = bsc.city_id "
                + "LEFT JOIN Cities ascit ON as_st.city_id = ascit.city_id "
                + "WHERE s.departure_date = ? AND t.checked_in_at IS NOT NULL AND t.status != 'CANCELLED' "
                + "ORDER BY t.checked_in_at DESC";

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
        // Check ownership regardless of ticket status so that users can manage
        // their tickets (including CANCELLED ones) when appropriate.
        String sql = "SELECT COUNT(*) FROM Tickets WHERE ticket_id = ? AND user_id = ?";

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
                + "WHERE s.bus_id = ? AND t.seat_number = ? AND s.departure_date = ? AND s.departure_time = ? "
                + "AND t.status NOT IN ('CANCELLED')";

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
        } catch (SQLException e) {
            // Columns might not exist in older queries, ignore
        }

        // Customer info fields (for walk-in tickets)
        try {
            ticket.setCustomerName(rs.getString("customer_name"));
            ticket.setCustomerPhone(rs.getString("customer_phone"));
            ticket.setCustomerEmail(rs.getString("customer_email"));
            ticket.setNotes(rs.getString("notes"));

            Object staffId = rs.getObject("created_by_staff_id");
            if (staffId != null) {
                ticket.setCreatedByStaffId(UUID.fromString(staffId.toString()));
            }

            java.sql.Timestamp checkedInAt = rs.getTimestamp("checked_in_at");
            if (checkedInAt != null) {
                ticket.setCheckedInAt(checkedInAt.toLocalDateTime());
            }

            Object checkedInByStaffId = rs.getObject("checked_in_by_staff_id");
            if (checkedInByStaffId != null) {
                ticket.setCheckedInByStaffId(UUID.fromString(checkedInByStaffId.toString()));
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

        // Set route with distance if available
        try {
            java.sql.ResultSetMetaData routeMetaData = rs.getMetaData();
            int routeColumnCount = routeMetaData.getColumnCount();
            boolean hasDistance = false;
            for (int i = 1; i <= routeColumnCount; i++) {
                if ("distance".equalsIgnoreCase(routeMetaData.getColumnName(i))) {
                    hasDistance = true;
                    break;
                }
            }
            if (hasDistance) {
                Object distanceObj = rs.getObject("distance");
                if (distanceObj != null) {
                    Routes route = new Routes();
                    if (rs.getObject("route_id") != null) {
                        route.setRouteId(UUIDUtils.getUUIDFromResultSet(rs, "route_id"));
                    }
                    route.setRouteName(rs.getString("route_name"));
                    route.setDepartureCity(rs.getString("departure_city"));
                    route.setDestinationCity(rs.getString("destination_city"));
                    if (distanceObj instanceof java.math.BigDecimal) {
                        route.setDistance((java.math.BigDecimal) distanceObj);
                    } else if (distanceObj instanceof Number) {
                        route.setDistance(
                                java.math.BigDecimal.valueOf(((Number) distanceObj).doubleValue()));
                    }
                    ticket.setRoute(route);
                }
            }
        } catch (SQLException e) {
            // Distance column might not exist in some queries, ignore
        }

        // Set bus with bus_type if available
        try {
            java.sql.ResultSetMetaData busMetaData = rs.getMetaData();
            int busColumnCount = busMetaData.getColumnCount();
            boolean hasBusType = false;
            for (int i = 1; i <= busColumnCount; i++) {
                if ("bus_type".equalsIgnoreCase(busMetaData.getColumnName(i))) {
                    hasBusType = true;
                    break;
                }
            }
            if (hasBusType) {
                Object busIdObj = rs.getObject("bus_id");
                if (busIdObj != null) {
                    Bus bus = new Bus();
                    bus.setBusId(UUIDUtils.getUUIDFromResultSet(rs, "bus_id"));
                    bus.setBusNumber(rs.getString("bus_number"));
                    String busType = rs.getString("bus_type");
                    if (busType != null) {
                        bus.setBusType(busType);
                    }
                    // Add license plate
                    try {
                        String licensePlate = rs.getString("license_plate");
                        if (licensePlate != null) {
                            bus.setLicensePlate(licensePlate);
                        }
                    } catch (SQLException e) {
                        // license_plate column might not exist, ignore
                    }
                    ticket.setBus(bus);
                }
            }
        } catch (SQLException e) {
            // Bus columns might not exist in some queries, ignore
        }

        // Set user with phone_number if available
        try {
            Object userIdObj = rs.getObject("user_id");
            if (userIdObj != null) {
                User user = new User();
                user.setUserId(UUIDUtils.getUUIDFromResultSet(rs, "user_id"));
                user.setFullName(rs.getString("user_name"));
                user.setUsername(rs.getString("username"));
                user.setEmail(rs.getString("user_email"));
                // Try to get phone_number - it might not exist in all queries
                try {
                    String phoneNumber = rs.getString("phone_number");
                    if (phoneNumber != null && !phoneNumber.trim().isEmpty()) {
                        user.setPhoneNumber(phoneNumber);
                    }
                } catch (SQLException e) {
                    // phone_number column might not exist in some queries, ignore
                }
                ticket.setUser(user);
            }
        } catch (SQLException e) {
            // User columns might not exist in some queries, ignore
        }

        return ticket;
    }

    /**
     * Get tickets by schedule ID (includes all statuses for staff view)
     */
    public List<Tickets> getTicketsByScheduleId(UUID scheduleId) throws SQLException {
        List<Tickets> tickets = new ArrayList<>();
        String sql = "SELECT t.*, "
                + "u.user_id, u.full_name as user_name, u.username, u.email as user_email, u.phone_number, "
                + "s.departure_date, s.departure_time, "
                + "r.route_id, r.route_name, depc.city_name AS departure_city, destc.city_name AS destination_city, r.distance, "
                + "b.bus_id, b.bus_number, b.bus_type, b.license_plate, dr.full_name as driver_name, "
                + "bs.station_name as boarding_station_name, bsc.city_name as boarding_city, "
                + "as_st.station_name as alighting_station_name, ascit.city_name as alighting_city "
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
                + "LEFT JOIN Cities depc ON r.departure_city_id = depc.city_id "
                + "LEFT JOIN Cities destc ON r.destination_city_id = destc.city_id "
                + "LEFT JOIN Cities bsc ON bs.city_id = bsc.city_id "
                + "LEFT JOIN Cities ascit ON as_st.city_id = ascit.city_id "
                + "WHERE t.schedule_id = ? "
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
     * Get only checked-in tickets for a schedule (for driver view)
     */
    public List<Tickets> getCheckedInTicketsByScheduleId(UUID scheduleId) throws SQLException {
        List<Tickets> tickets = new ArrayList<>();
        String sql = "SELECT t.*, "
                + "u.user_id, u.full_name as user_name, u.username, u.email as user_email, u.phone_number, "
                + "s.departure_date, s.departure_time, "
                + "r.route_id, r.route_name, depc.city_name AS departure_city, destc.city_name AS destination_city, r.distance, "
                + "b.bus_id, b.bus_number, b.bus_type, b.license_plate, dr.full_name as driver_name, "
                + "bs.station_name as boarding_station_name, bsc.city_name as boarding_city, "
                + "as_st.station_name as alighting_station_name, ascit.city_name as alighting_city "
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
                + "LEFT JOIN Cities depc ON r.departure_city_id = depc.city_id "
                + "LEFT JOIN Cities destc ON r.destination_city_id = destc.city_id "
                + "LEFT JOIN Cities bsc ON bs.city_id = bsc.city_id "
                + "LEFT JOIN Cities ascit ON as_st.city_id = ascit.city_id "
                + "WHERE t.schedule_id = ? AND t.checked_in_at IS NOT NULL AND t.status != 'CANCELLED' "
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
     * Get unchecked-in tickets for a schedule (for driver check-in)
     */
    public List<Tickets> getUncheckedInTicketsByScheduleId(UUID scheduleId) throws SQLException {
        List<Tickets> tickets = new ArrayList<>();
        String sql = "SELECT t.*, "
                + "u.user_id, u.full_name as user_name, u.username, u.email as user_email, u.phone_number, "
                + "s.departure_date, s.departure_time, "
                + "r.route_id, r.route_name, depc.city_name AS departure_city, destc.city_name AS destination_city, r.distance, "
                + "b.bus_id, b.bus_number, b.bus_type, b.license_plate, dr.full_name as driver_name, "
                + "bs.station_name as boarding_station_name, bsc.city_name as boarding_city, "
                + "as_st.station_name as alighting_station_name, ascit.city_name as alighting_city "
                + "FROM Tickets t "
                + "LEFT JOIN Users u ON t.user_id = u.user_id "
                + "JOIN Schedules s ON t.schedule_id = s.schedule_id "
                + "JOIN Routes r ON s.route_id = r.route_id "
                + "JOIN Buses b ON s.bus_id = b.bus_id "
                + "LEFT JOIN ScheduleDrivers sd ON s.schedule_id = sd.schedule_id "
                + "LEFT JOIN Drivers d ON sd.driver_id = d.driver_id "
                + "LEFT JOIN Users dr ON d.user_id = dr.user_id "
                + "LEFT JOIN Stations bs ON t.boarding_station_id = bs.station_id "
                + "LEFT JOIN Stations as_st ON t.alighting_station_id = as_st.station_id "
                + "LEFT JOIN Cities depc ON r.departure_city_id = depc.city_id "
                + "LEFT JOIN Cities destc ON r.destination_city_id = destc.city_id "
                + "LEFT JOIN Cities bsc ON bs.city_id = bsc.city_id "
                + "LEFT JOIN Cities ascit ON as_st.city_id = ascit.city_id "
                + "WHERE t.schedule_id = ? AND t.checked_in_at IS NULL AND t.status != 'CANCELLED' AND t.payment_status = 'PAID' "
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
     * Check if schedule has any booked tickets (non-cancelled)
     */
    public boolean hasScheduleTickets(UUID scheduleId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Tickets WHERE schedule_id = ? AND status != 'CANCELLED'";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, scheduleId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }

    /**
     * Get count of booked seats for a schedule
     */
    public int getBookedSeatsCount(UUID scheduleId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Tickets WHERE schedule_id = ? AND status != 'CANCELLED'";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, scheduleId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    /**
     * Check if seat is available for update (excluding current ticket)
     */
    public boolean isSeatAvailableForUpdate(UUID scheduleId, int seatNumber, UUID excludeTicketId)
            throws SQLException {
        String sql = "SELECT COUNT(*) FROM Tickets WHERE schedule_id = ? AND seat_number = ? "
                + "AND status NOT IN ('CANCELLED') AND ticket_id != ?";

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
     * Check if a phone or email is already associated with any non-cancelled ticket
     * on the given schedule. This prevents duplicate passenger contacts on the same
     * trip.
     */
    public boolean hasContactConflict(UUID scheduleId, String phone, String email)
            throws SQLException {
        String normalizedPhone = phone != null ? phone.trim() : null;
        String normalizedEmail = email != null ? email.trim().toLowerCase() : null;

        List<String> conditions = new ArrayList<>();
        List<Object> parameters = new ArrayList<>();
        parameters.add(scheduleId);

        if (normalizedPhone != null && !normalizedPhone.isEmpty()) {
            conditions.add("(t.customer_phone = ? OR u.phone_number = ?)");
            parameters.add(normalizedPhone);
            parameters.add(normalizedPhone);
        }
        if (normalizedEmail != null && !normalizedEmail.isEmpty()) {
            conditions.add("(LOWER(t.customer_email) = ? OR LOWER(u.email) = ?)");
            parameters.add(normalizedEmail);
            parameters.add(normalizedEmail);
        }

        if (conditions.isEmpty()) {
            return false; // Nothing to check
        }

        String sql = "SELECT COUNT(*) FROM Tickets t "
                + "LEFT JOIN Users u ON t.user_id = u.user_id "
                + "WHERE t.schedule_id = ? AND t.status NOT IN ('CANCELLED') AND ("
                + String.join(" OR ", conditions) + ")";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            for (int i = 0; i < parameters.size(); i++) {
                stmt.setObject(i + 1, parameters.get(i));
            }

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
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
        sql.append(
                "SELECT t.*, u.user_id, u.full_name as user_name, u.username, u.email as user_email, u.phone_number, ");
        sql.append(
                "r.route_id, r.route_name, depc.city_name AS departure_city, destc.city_name AS destination_city, r.distance, ");
        sql.append("b.bus_id, b.bus_number, b.bus_type, b.license_plate, ");
        sql.append("s.departure_date, s.departure_time, ");
        sql.append("dr.full_name as driver_name, ");
        sql.append("bs.station_name as boarding_station_name, bsc.city_name as boarding_city, ");
        sql.append(
                "as_st.station_name as alighting_station_name, ascit.city_name as alighting_city ");
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
        sql.append("LEFT JOIN Cities depc ON r.departure_city_id = depc.city_id ");
        sql.append("LEFT JOIN Cities destc ON r.destination_city_id = destc.city_id ");
        sql.append("LEFT JOIN Cities bsc ON bs.city_id = bsc.city_id ");
        sql.append("LEFT JOIN Cities ascit ON as_st.city_id = ascit.city_id ");
        sql.append("WHERE 1=1 ");

        List<Object> parameters = new ArrayList<>();

        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            sql.append(
                    "AND (t.ticket_number LIKE ? OR u.full_name LIKE ? OR u.email LIKE ? OR u.phone_number LIKE ? OR t.customer_name LIKE ? OR t.customer_phone LIKE ?) ");
            String searchPattern = "%" + searchTerm.trim() + "%";
            parameters.add(searchPattern);
            parameters.add(searchPattern);
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
     * Search tickets with advanced filters for admin (includes CANCELLED tickets)
     */
    public List<Tickets> searchTicketsForAdmin(String searchTerm, String status,
            String paymentStatus,
            java.sql.Date dateFrom, java.sql.Date dateTo, BigDecimal priceFrom, BigDecimal priceTo)
            throws SQLException {
        List<Tickets> tickets = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append(
                "SELECT t.*, u.user_id, u.full_name as user_name, u.username, u.email as user_email, u.phone_number, ");
        sql.append(
                "r.route_id, r.route_name, depc.city_name AS departure_city, destc.city_name AS destination_city, r.distance, ");
        sql.append("b.bus_id, b.bus_number, b.bus_type, b.license_plate, ");
        sql.append("s.departure_date, s.departure_time, ");
        sql.append("dr.full_name as driver_name, ");
        sql.append("bs.station_name as boarding_station_name, bsc.city_name as boarding_city, ");
        sql.append(
                "as_st.station_name as alighting_station_name, ascit.city_name as alighting_city ");
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
        sql.append("LEFT JOIN Cities depc ON r.departure_city_id = depc.city_id ");
        sql.append("LEFT JOIN Cities destc ON r.destination_city_id = destc.city_id ");
        sql.append("LEFT JOIN Cities bsc ON bs.city_id = bsc.city_id ");
        sql.append("LEFT JOIN Cities ascit ON as_st.city_id = ascit.city_id ");
        sql.append("WHERE 1=1 ");

        List<Object> parameters = new ArrayList<>();

        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            sql.append(
                    "AND (t.ticket_number LIKE ? OR u.full_name LIKE ? OR u.email LIKE ? OR u.phone_number LIKE ? OR t.customer_name LIKE ? OR t.customer_phone LIKE ?) ");
            String searchPattern = "%" + searchTerm.trim() + "%";
            parameters.add(searchPattern);
            parameters.add(searchPattern);
            parameters.add(searchPattern);
            parameters.add(searchPattern);
            parameters.add(searchPattern);
            parameters.add(searchPattern);
        }

        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND t.status = ? ");
            parameters.add(status);
        } else {
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
        String sql = "SELECT t.*, u.user_id, u.full_name as user_name, u.username, u.email as user_email, u.phone_number, "
                + "r.route_id, r.route_name, "
                + "depc.city_name AS departure_city, destc.city_name AS destination_city, r.distance, "
                + "b.bus_id, b.bus_number, b.bus_type, b.license_plate, "
                + "s.departure_date, s.departure_time, " + "dr.full_name as driver_name "
                + "FROM Tickets t " + "JOIN Users u ON t.user_id = u.user_id "
                + "JOIN Schedules s ON t.schedule_id = s.schedule_id "
                + "JOIN Routes r ON s.route_id = r.route_id "
                + "JOIN Buses b ON s.bus_id = b.bus_id "
                + "LEFT JOIN Cities depc ON r.departure_city_id = depc.city_id "
                + "LEFT JOIN Cities destc ON r.destination_city_id = destc.city_id "
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
        String sql = "SELECT t.*, u.user_id, u.full_name as user_name, u.username, u.email as user_email, u.phone_number, "
                + "r.route_id, r.route_name, "
                + "depc.city_name AS departure_city, destc.city_name AS destination_city, r.distance, "
                + "b.bus_id, b.bus_number, b.bus_type, b.license_plate, "
                + "s.departure_date, s.departure_time, " + "dr.full_name as driver_name "
                + "FROM Tickets t " + "JOIN Users u ON t.user_id = u.user_id "
                + "JOIN Schedules s ON t.schedule_id = s.schedule_id "
                + "JOIN Routes r ON s.route_id = r.route_id "
                + "JOIN Buses b ON s.bus_id = b.bus_id "
                + "LEFT JOIN Cities depc ON r.departure_city_id = depc.city_id "
                + "LEFT JOIN Cities destc ON r.destination_city_id = destc.city_id "
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
        String sql = "SELECT t.*, u.user_id, u.full_name as user_name, u.username, u.email as user_email, u.phone_number, "
                + "r.route_id, r.route_name, "
                + "depc.city_name AS departure_city, destc.city_name AS destination_city, r.distance, "
                + "b.bus_id, b.bus_number, b.bus_type, b.license_plate, "
                + "s.departure_date, s.departure_time, " + "dr.full_name as driver_name "
                + "FROM Tickets t " + "JOIN Users u ON t.user_id = u.user_id "
                + "JOIN Schedules s ON t.schedule_id = s.schedule_id "
                + "JOIN Routes r ON s.route_id = r.route_id "
                + "JOIN Buses b ON s.bus_id = b.bus_id "
                + "LEFT JOIN ScheduleDrivers sd ON s.schedule_id = sd.schedule_id "
                + "LEFT JOIN Drivers d ON sd.driver_id = d.driver_id "
                + "LEFT JOIN Users dr ON d.user_id = dr.user_id "
                + "WHERE t.payment_status = ? "
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
        String sql = "SELECT seat_number FROM Tickets WHERE schedule_id = ? "
                + "AND status NOT IN ('CANCELLED')";

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
     * Refund and cancel all tickets for a schedule.
     * Marks ticket status as 'CANCELLED' and payment_status -> 'REFUNDED' when it
     * was 'PAID'.
     * Returns number of tickets updated.
     */
    public int refundTicketsBySchedule(UUID scheduleId, String reason) throws SQLException {
        String sql = "UPDATE Tickets SET status = 'CANCELLED', payment_status = CASE WHEN payment_status = 'PAID' THEN 'REFUNDED' ELSE payment_status END, notes = COALESCE(notes, '') + ?, updated_date = GETDATE() WHERE schedule_id = ? AND status != 'CANCELLED'";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            String noteSuffix = " | Refunded due to schedule cancellation";
            if (reason != null && !reason.trim().isEmpty()) {
                noteSuffix = " | Refunded: " + reason;
            }
            stmt.setString(1, noteSuffix);
            stmt.setObject(2, scheduleId);

            return stmt.executeUpdate();
        }
    }

    /**
     * Get the latest (most recent by departure date/time) ticket of a passenger
     * that belongs to any schedule assigned to the given driver (by driver userId).
     */
    public Tickets getLatestTicketForPassengerByDriver(UUID driverUserId, UUID passengerUserId)
            throws SQLException {
        String sql = "SELECT TOP 1 t.*, u.user_id, u.full_name as user_name, u.username, u.email as user_email, u.phone_number, "
                + "s.departure_date, s.departure_time, "
                + "bs.station_name as boarding_station_name, bsc.city_name as boarding_city, "
                + "as_st.station_name as alighting_station_name, ascit.city_name as alighting_city "
                + "FROM Tickets t "
                + "JOIN Users u ON t.user_id = u.user_id "
                + "JOIN Schedules s ON t.schedule_id = s.schedule_id "
                + "JOIN ScheduleDrivers sd ON s.schedule_id = sd.schedule_id "
                + "JOIN Drivers d ON sd.driver_id = d.driver_id "
                + "JOIN Users du ON d.user_id = du.user_id "
                + "LEFT JOIN Stations bs ON t.boarding_station_id = bs.station_id "
                + "LEFT JOIN Stations as_st ON t.alighting_station_id = as_st.station_id "
                + "LEFT JOIN Cities bsc ON bs.city_id = bsc.city_id "
                + "LEFT JOIN Cities ascit ON as_st.city_id = ascit.city_id "
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
