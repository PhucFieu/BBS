package dao;

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

public class TicketDAO {

    public List<Tickets> getAllTickets() throws SQLException {
        List<Tickets> tickets = new ArrayList<>();
        String sql = "SELECT t.*, u.full_name as user_name, u.username, u.email as user_email, " +
                "r.route_name, r.departure_city, r.destination_city, " +
                "b.bus_number, " +
                "s.departure_date, s.departure_time " +
                "FROM Tickets t " +
                "JOIN Users u ON t.user_id = u.user_id " +
                "JOIN Schedules s ON t.schedule_id = s.schedule_id " +
                "JOIN Routes r ON s.route_id = r.route_id " +
                "JOIN Buses b ON s.bus_id = b.bus_id " +
                "WHERE t.status = 'CONFIRMED' " +
                "ORDER BY t.booking_date DESC";

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
        String sql = "SELECT t.*, u.full_name as user_name, u.username, u.email as user_email, " +
                "r.route_name, r.departure_city, r.destination_city, " +
                "b.bus_number, " +
                "s.departure_date, s.departure_time " +
                "FROM Tickets t " +
                "JOIN Users u ON t.user_id = u.user_id " +
                "JOIN Schedules s ON t.schedule_id = s.schedule_id " +
                "JOIN Routes r ON s.route_id = r.route_id " +
                "JOIN Buses b ON s.bus_id = b.bus_id " +
                "WHERE t.ticket_id = ? AND t.status = 'CONFIRMED'";

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
        String sql = "SELECT t.*, u.full_name as user_name, u.username, u.email as user_email, " +
                "r.route_name, r.departure_city, r.destination_city, " +
                "b.bus_number, " +
                "s.departure_date, s.departure_time " +
                "FROM Tickets t " +
                "JOIN Users u ON t.user_id = u.user_id " +
                "JOIN Schedules s ON t.schedule_id = s.schedule_id " +
                "JOIN Routes r ON s.route_id = r.route_id " +
                "JOIN Buses b ON s.bus_id = b.bus_id " +
                "WHERE t.ticket_number = ? AND t.status = 'CONFIRMED'";

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
        String sql = "SELECT t.*, u.full_name as user_name, u.username, u.email as user_email, " +
                "r.route_name, r.departure_city, r.destination_city, " +
                "b.bus_number, " +
                "s.departure_date, s.departure_time " +
                "FROM Tickets t " +
                "JOIN Users u ON t.user_id = u.user_id " +
                "JOIN Schedules s ON t.schedule_id = s.schedule_id " +
                "JOIN Routes r ON s.route_id = r.route_id " +
                "JOIN Buses b ON s.bus_id = b.bus_id " +
                "WHERE t.user_id = ? AND t.status = 'CONFIRMED' " +
                "ORDER BY t.booking_date DESC";

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
        String sql = "INSERT INTO Tickets (ticket_id, ticket_number, schedule_id, user_id, seat_number, ticket_price, booking_date, status, payment_status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        System.out.println("=== TICKET DAO DEBUG ===");
        System.out.println("SQL: " + sql);
        System.out.println("TicketId: " + ticket.getTicketId());
        System.out.println("TicketNumber: " + ticket.getTicketNumber());
        System.out.println("ScheduleId: " + ticket.getScheduleId());
        System.out.println("UserId: " + ticket.getUserId());
        System.out.println("SeatNumber: " + ticket.getSeatNumber());
        System.out.println("TicketPrice: " + ticket.getTicketPrice());
        System.out.println("BookingDate: " + ticket.getBookingDate());
        System.out.println("Status: " + ticket.getStatus());
        System.out.println("PaymentStatus: " + ticket.getPaymentStatus());

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

            System.out.println("Executing INSERT statement...");
            int result = stmt.executeUpdate();
            System.out.println("Insert result: " + result + " rows affected");
            System.out.println("=== END TICKET DAO DEBUG ===");
            return result > 0;
        } catch (Exception e) {
            System.out.println("ERROR in addTicket: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }

    public boolean updateTicket(Tickets ticket) throws SQLException {
        String sql = "UPDATE Tickets SET schedule_id = ?, user_id = ?, seat_number = ?, ticket_price = ?, status = ?, payment_status = ?, updated_date = GETDATE() WHERE ticket_id = ?";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, ticket.getScheduleId());
            stmt.setObject(2, ticket.getUserId());
            stmt.setInt(3, ticket.getSeatNumber());
            stmt.setBigDecimal(4, ticket.getTicketPrice());
            stmt.setString(5, ticket.getStatus());
            stmt.setString(6, ticket.getPaymentStatus());
            stmt.setObject(7, ticket.getTicketId());

            return stmt.executeUpdate() > 0;
        }
    }

    public boolean deleteTicket(UUID ticketId) throws SQLException {
        String sql = "UPDATE Tickets SET status = 'CANCELLED', updated_date = GETDATE() WHERE ticket_id = ?";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, ticketId);
            return stmt.executeUpdate() > 0;
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

    // Additional methods for backward compatibility
    public List<Tickets> getRecentTickets(int limit) throws SQLException {
        List<Tickets> tickets = new ArrayList<>();
        String sql = "SELECT TOP " + limit + " t.*, u.full_name as user_name, u.username, u.email as user_email, " +
                "r.route_name, r.departure_city, r.destination_city, " +
                "b.bus_number, " +
                "s.departure_date, s.departure_time " +
                "FROM Tickets t " +
                "LEFT JOIN Schedules s ON t.schedule_id = s.schedule_id " +
                "LEFT JOIN Routes r ON s.route_id = r.route_id " +
                "LEFT JOIN Buses b ON s.bus_id = b.bus_id " +
                "LEFT JOIN Users u ON t.user_id = u.user_id " +
                "WHERE t.status = 'CONFIRMED' " +
                "ORDER BY t.booking_date DESC";

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
        String sql = "SELECT t.*, u.full_name as user_name, u.username, u.email as user_email, " +
                "r.route_name, r.departure_city, r.destination_city, " +
                "b.bus_number, " +
                "s.departure_date, s.departure_time " +
                "FROM Tickets t " +
                "LEFT JOIN Schedules s ON t.schedule_id = s.schedule_id " +
                "LEFT JOIN Routes r ON s.route_id = r.route_id " +
                "LEFT JOIN Buses b ON s.bus_id = b.bus_id " +
                "LEFT JOIN Users u ON t.user_id = u.user_id " +
                "WHERE t.status = 'CONFIRMED' AND MONTH(t.booking_date) = MONTH(GETDATE()) AND YEAR(t.booking_date) = YEAR(GETDATE()) "
                +
                "ORDER BY t.booking_date DESC";

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

    public List<Integer> getBookedSeats(UUID busId, java.time.LocalDate date, java.time.LocalTime time)
            throws SQLException {
        List<Integer> bookedSeats = new ArrayList<>();
        String sql = "SELECT t.seat_number FROM Tickets t " +
                "JOIN Schedules s ON t.schedule_id = s.schedule_id " +
                "WHERE s.bus_id = ? AND s.departure_date = ? AND s.departure_time = ? AND t.status = 'CONFIRMED'";

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
        String sql = "SELECT t.*, u.full_name as user_name, u.username, u.email as user_email, " +
                "r.route_name, r.departure_city, r.destination_city, " +
                "b.bus_number, " +
                "s.departure_date, s.departure_time " +
                "FROM Tickets t " +
                "JOIN Users u ON t.user_id = u.user_id " +
                "JOIN Schedules s ON t.schedule_id = s.schedule_id " +
                "JOIN Routes r ON s.route_id = r.route_id " +
                "JOIN Buses b ON s.bus_id = b.bus_id " +
                "WHERE s.departure_date = ? AND t.status = 'CONFIRMED' " +
                "ORDER BY t.booking_date DESC";

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
        String sql = "SELECT COUNT(*) FROM Tickets WHERE ticket_id = ? AND user_id = ? AND status = 'CONFIRMED'";

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
    public boolean isSeatAvailable(UUID busId, int seatNumber, java.sql.Date date, java.sql.Time time)
            throws SQLException {
        String sql = "SELECT COUNT(*) FROM Tickets t " +
                "JOIN Schedules s ON t.schedule_id = s.schedule_id " +
                "WHERE s.bus_id = ? AND t.seat_number = ? AND s.departure_date = ? AND s.departure_time = ? AND t.status = 'CONFIRMED'";

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

        // Display fields from joins
        ticket.setUserName(rs.getString("user_name"));
        ticket.setUsername(rs.getString("username"));
        ticket.setUserEmail(rs.getString("user_email"));
        ticket.setRouteName(rs.getString("route_name"));
        ticket.setDepartureCity(rs.getString("departure_city"));
        ticket.setDestinationCity(rs.getString("destination_city"));
        ticket.setBusNumber(rs.getString("bus_number"));

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
}
