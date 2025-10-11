package dao;

import java.sql.*;
import java.time.LocalDate;
import java.util.*;
import java.math.BigDecimal;
import model.Ticket;
import util.DBConnection;

public class TicketDAO {

    public List<Ticket> getAllTickets() throws SQLException {
        List<Ticket> list = new ArrayList<>();
        String sql = "SELECT t.*, s.departure_date, s.departure_time, r.route_name, r.departure_city, r.destination_city, b.bus_number, b.driver_name " +
                     "FROM Tickets t " +
                     "JOIN Schedule s ON t.schedule_id = s.schedule_id " +
                     "JOIN Routes r ON s.route_id = r.route_id " +
                     "JOIN Buses b ON s.bus_id = b.bus_id " +
                     "ORDER BY t.booking_date DESC";
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) list.add(mapResultSetToTicket(rs));
        }
        return list;
    }

    public Ticket getTicketById(UUID ticketId) throws SQLException {
        String sql = "SELECT t.*, s.departure_date, s.departure_time, r.route_name, r.departure_city, r.destination_city, b.bus_number, b.driver_name " +
                     "FROM Tickets t " +
                     "JOIN Schedule s ON t.schedule_id = s.schedule_id " +
                     "JOIN Routes r ON s.route_id = r.route_id " +
                     "JOIN Buses b ON s.bus_id = b.bus_id " +
                     "WHERE t.ticket_id = ?";
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, ticketId.toString());
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) return mapResultSetToTicket(rs);
        }
        return null;
    }

    public Ticket getTicketByNumber(String ticketNumber) throws SQLException {
        String sql = "SELECT t.*, s.departure_date, s.departure_time, r.route_name, r.departure_city, r.destination_city, b.bus_number, b.driver_name " +
                     "FROM Tickets t " +
                     "JOIN Schedule s ON t.schedule_id = s.schedule_id " +
                     "JOIN Routes r ON s.route_id = r.route_id " +
                     "JOIN Buses b ON s.bus_id = b.bus_id " +
                     "WHERE t.ticket_number = ?";
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, ticketNumber);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) return mapResultSetToTicket(rs);
        }
        return null;
    }

    public List<Ticket> getTicketsByUserId(UUID userId) throws SQLException {
        List<Ticket> list = new ArrayList<>();
        String sql = "SELECT t.*, s.departure_date, s.departure_time, r.route_name, r.departure_city, r.destination_city, b.bus_number, b.driver_name " +
                     "FROM Tickets t " +
                     "JOIN Schedule s ON t.schedule_id = s.schedule_id " +
                     "JOIN Routes r ON s.route_id = r.route_id " +
                     "JOIN Buses b ON s.bus_id = b.bus_id " +
                     "WHERE t.user_id = ? ORDER BY t.booking_date DESC";
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, userId.toString());
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) list.add(mapResultSetToTicket(rs));
        }
        return list;
    }

    public boolean addTicket(Ticket t) throws SQLException {
        String sql = "INSERT INTO Tickets (ticket_id, ticket_number, schedule_id, user_id, passenger_name, seat_number, ticket_price, status, payment_status, booking_date, created_date) " +
                     "VALUES (NEWID(), ?, ?, ?, ?, ?, ?, ?, ?, GETDATE(), GETDATE())";
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, t.getTicketNumber());
            stmt.setString(2, t.getScheduleId().toString());
            stmt.setString(3, t.getUserId().toString());
            stmt.setString(4, t.getPassengerName());
            stmt.setInt(5, t.getSeatNumber());
            stmt.setBigDecimal(6, t.getTicketPrice() != null ? t.getTicketPrice() : BigDecimal.ZERO);
            stmt.setString(7, t.getStatus());
            stmt.setString(8, t.getPaymentStatus());
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean updateTicket(Ticket t) throws SQLException {
        String sql = "UPDATE Tickets SET schedule_id=?, passenger_name=?, seat_number=?, ticket_price=?, status=?, payment_status=?, updated_date=GETDATE() WHERE ticket_id=?";
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, t.getScheduleId().toString());
            stmt.setString(2, t.getPassengerName());
            stmt.setInt(3, t.getSeatNumber());
            stmt.setBigDecimal(4, t.getTicketPrice());
            stmt.setString(5, t.getStatus());
            stmt.setString(6, t.getPaymentStatus());
            stmt.setString(7, t.getTicketId().toString());
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean deleteTicket(UUID ticketId) throws SQLException {
        String sql = "UPDATE Tickets SET status='CANCELLED', updated_date=GETDATE() WHERE ticket_id=?";
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, ticketId.toString());
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean isSeatAvailable(UUID scheduleId, int seatNumber) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Tickets WHERE schedule_id=? AND seat_number=? AND status!='CANCELLED'";
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, scheduleId.toString());
            stmt.setInt(2, seatNumber);
            ResultSet rs = stmt.executeQuery();
            return rs.next() && rs.getInt(1) == 0;
        }
    }

    public boolean isTicketOwnedByUser(UUID ticketId, UUID userId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Tickets WHERE ticket_id=? AND user_id=?";
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, ticketId.toString());
            stmt.setString(2, userId.toString());
            ResultSet rs = stmt.executeQuery();
            return rs.next() && rs.getInt(1) > 0;
        }
    }

    public String generateTicketNumber() throws SQLException {
        String sql = "SELECT COUNT(*) + 1 FROM Tickets";
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                int count = rs.getInt(1);
                return String.format("TKT%06d", count);
            }
        }
        return "TKT000001";
    }

    public int getTotalTickets() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Tickets";
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    public List<Ticket> getRecentTickets(int limit) throws SQLException {
        List<Ticket> list = new ArrayList<>();
        String sql = "SELECT TOP (?) t.*, s.departure_date, s.departure_time, r.route_name FROM Tickets t " +
                     "JOIN Schedule s ON t.schedule_id = s.schedule_id " +
                     "JOIN Routes r ON s.route_id = r.route_id ORDER BY t.created_date DESC";
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) list.add(mapResultSetToTicket(rs));
        }
        return list;
    }

    public List<Ticket> getTicketsByDate(LocalDate date) throws SQLException {
        List<Ticket> list = new ArrayList<>();
        String sql = "SELECT t.*, s.departure_date, s.departure_time, r.route_name FROM Tickets t " +
                     "JOIN Schedule s ON t.schedule_id = s.schedule_id " +
                     "JOIN Routes r ON s.route_id = r.route_id WHERE s.departure_date = ?";
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setDate(1, java.sql.Date.valueOf(date));
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) list.add(mapResultSetToTicket(rs));
        }
        return list;
    }

    public List<Ticket> getTicketsByMonth(int month, int year) throws SQLException {
        List<Ticket> list = new ArrayList<>();
        String sql = "SELECT t.*, s.departure_date, s.departure_time, r.route_name FROM Tickets t " +
                     "JOIN Schedule s ON t.schedule_id = s.schedule_id " +
                     "JOIN Routes r ON s.route_id = r.route_id WHERE MONTH(s.departure_date)=? AND YEAR(s.departure_date)=?";
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, month);
            stmt.setInt(2, year);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) list.add(mapResultSetToTicket(rs));
        }
        return list;
    }

    public List<Integer> getBookedSeats(UUID scheduleId) throws SQLException {
        List<Integer> list = new ArrayList<>();
        String sql = "SELECT seat_number FROM Tickets WHERE schedule_id=? AND status!='CANCELLED'";
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, scheduleId.toString());
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) list.add(rs.getInt("seat_number"));
        }
        return list;
    }

    private Ticket mapResultSetToTicket(ResultSet rs) throws SQLException {
        Ticket t = new Ticket();
        t.setTicketId(UUID.fromString(rs.getString("ticket_id")));
        t.setTicketNumber(rs.getString("ticket_number"));
        t.setScheduleId(UUID.fromString(rs.getString("schedule_id")));
        t.setUserId(UUID.fromString(rs.getString("user_id")));
        t.setPassengerName(rs.getString("passenger_name"));
        t.setSeatNumber(rs.getInt("seat_number"));
        t.setTicketPrice(rs.getBigDecimal("ticket_price"));
        t.setStatus(rs.getString("status"));
        t.setPaymentStatus(rs.getString("payment_status"));
        Timestamp b = rs.getTimestamp("booking_date");
        if (b != null) t.setBookingDate(b.toLocalDateTime());
        Timestamp c = rs.getTimestamp("created_date");
        if (c != null) t.setCreatedDate(c.toLocalDateTime());
        Timestamp u = rs.getTimestamp("updated_date");
        if (u != null) t.setUpdatedDate(u.toLocalDateTime());
        Date depDate = rs.getDate("departure_date");
        if (depDate != null) t.setDepartureDateStr(depDate.toString());
        Time depTime = rs.getTime("departure_time");
        if (depTime != null) t.setDepartureTimeStr(depTime.toString());
        t.setRouteName(rs.getString("route_name"));
        t.setDepartureCity(rs.getString("departure_city"));
        t.setDestinationCity(rs.getString("destination_city"));
        t.setBusNumber(rs.getString("bus_number"));
        t.setDriverName(rs.getString("driver_name"));
        return t;
    }
}
