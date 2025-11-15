package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import model.Rating;
import util.DBConnection;
import util.UUIDUtils;

public class RatingDAO {

    public List<Rating> getAllRatings() throws SQLException {
        List<Rating> ratings = new ArrayList<>();
        String sql = "SELECT r.*, t.ticket_number, u.full_name as user_name, " +
                "dr.full_name as driver_name, rt.route_name " +
                "FROM Ratings r " +
                "JOIN Tickets t ON r.ticket_id = t.ticket_id " +
                "JOIN Users u ON r.user_id = u.user_id " +
                "JOIN Drivers d ON r.driver_id = d.driver_id " +
                "JOIN Users dr ON d.user_id = dr.user_id " +
                "JOIN Schedules s ON t.schedule_id = s.schedule_id " +
                "JOIN Routes rt ON s.route_id = rt.route_id " +
                "ORDER BY r.created_date DESC";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Rating rating = mapResultSetToRating(rs);
                ratings.add(rating);
            }
        }
        return ratings;
    }

    public Rating getRatingById(UUID ratingId) throws SQLException {
        String sql = "SELECT r.*, t.ticket_number, u.full_name as user_name, " +
                "dr.full_name as driver_name, rt.route_name " +
                "FROM Ratings r " +
                "JOIN Tickets t ON r.ticket_id = t.ticket_id " +
                "JOIN Users u ON r.user_id = u.user_id " +
                "JOIN Drivers d ON r.driver_id = d.driver_id " +
                "JOIN Users dr ON d.user_id = dr.user_id " +
                "JOIN Schedules s ON t.schedule_id = s.schedule_id " +
                "JOIN Routes rt ON s.route_id = rt.route_id " +
                "WHERE r.rating_id = ?";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, ratingId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToRating(rs);
            }
        }
        return null;
    }

    public Rating getRatingByTicketId(UUID ticketId) throws SQLException {
        String sql = "SELECT r.*, t.ticket_number, u.full_name as user_name, " +
                "dr.full_name as driver_name, rt.route_name " +
                "FROM Ratings r " +
                "JOIN Tickets t ON r.ticket_id = t.ticket_id " +
                "JOIN Users u ON r.user_id = u.user_id " +
                "JOIN Drivers d ON r.driver_id = d.driver_id " +
                "JOIN Users dr ON d.user_id = dr.user_id " +
                "JOIN Schedules s ON t.schedule_id = s.schedule_id " +
                "JOIN Routes rt ON s.route_id = rt.route_id " +
                "WHERE r.ticket_id = ?";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, ticketId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToRating(rs);
            }
        }
        return null;
    }

    public List<Rating> getRatingsByDriver(UUID driverId) throws SQLException {
        List<Rating> ratings = new ArrayList<>();
        String sql = "SELECT r.*, t.ticket_number, u.full_name as user_name, " +
                "dr.full_name as driver_name, rt.route_name " +
                "FROM Ratings r " +
                "JOIN Tickets t ON r.ticket_id = t.ticket_id " +
                "JOIN Users u ON r.user_id = u.user_id " +
                "JOIN Drivers d ON r.driver_id = d.driver_id " +
                "JOIN Users dr ON d.user_id = dr.user_id " +
                "JOIN Schedules s ON t.schedule_id = s.schedule_id " +
                "JOIN Routes rt ON s.route_id = rt.route_id " +
                "WHERE r.driver_id = ? " +
                "ORDER BY r.created_date DESC";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, driverId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Rating rating = mapResultSetToRating(rs);
                ratings.add(rating);
            }
        }
        return ratings;
    }

    public List<Rating> getRatingsByUser(UUID userId) throws SQLException {
        List<Rating> ratings = new ArrayList<>();
        String sql = "SELECT r.*, t.ticket_number, u.full_name as user_name, " +
                "dr.full_name as driver_name, rt.route_name " +
                "FROM Ratings r " +
                "JOIN Tickets t ON r.ticket_id = t.ticket_id " +
                "JOIN Users u ON r.user_id = u.user_id " +
                "JOIN Drivers d ON r.driver_id = d.driver_id " +
                "JOIN Users dr ON d.user_id = dr.user_id " +
                "JOIN Schedules s ON t.schedule_id = s.schedule_id " +
                "JOIN Routes rt ON s.route_id = rt.route_id " +
                "WHERE r.user_id = ? " +
                "ORDER BY r.created_date DESC";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, userId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Rating rating = mapResultSetToRating(rs);
                ratings.add(rating);
            }
        }
        return ratings;
    }

    public boolean addRating(Rating rating) throws SQLException {
        String sql =
                "INSERT INTO Ratings (rating_id, ticket_id, user_id, driver_id, rating_value, comments, created_date) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, rating.getRatingId());
            stmt.setObject(2, rating.getTicketId());
            stmt.setObject(3, rating.getUserId());
            stmt.setObject(4, rating.getDriverId());
            stmt.setInt(5, rating.getRatingValue());
            stmt.setString(6, rating.getComments());
            stmt.setTimestamp(7, Timestamp.valueOf(rating.getCreatedDate()));

            return stmt.executeUpdate() > 0;
        }
    }

    public boolean updateRating(Rating rating) throws SQLException {
        String sql = "UPDATE Ratings SET rating_value = ?, comments = ? WHERE rating_id = ?";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, rating.getRatingValue());
            stmt.setString(2, rating.getComments());
            stmt.setObject(3, rating.getRatingId());

            return stmt.executeUpdate() > 0;
        }
    }

    public boolean deleteRating(UUID ratingId) throws SQLException {
        String sql = "DELETE FROM Ratings WHERE rating_id = ?";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, ratingId);
            return stmt.executeUpdate() > 0;
        }
    }

    public double getAverageRatingByDriver(UUID driverId) throws SQLException {
        String sql = "SELECT AVG(CAST(rating_value AS FLOAT)) FROM Ratings WHERE driver_id = ?";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, driverId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                double avg = rs.getDouble(1);
                return rs.wasNull() ? 0.0 : avg;
            }
        }
        return 0.0;
    }

    public int getTotalRatingsByDriver(UUID driverId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Ratings WHERE driver_id = ?";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    public boolean hasUserRatedTicket(UUID ticketId, UUID userId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Ratings WHERE ticket_id = ? AND user_id = ?";

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

    public List<Rating> getRatingsByUserId(UUID userId) throws SQLException {
        List<Rating> ratings = new ArrayList<>();
        String sql = "SELECT r.*, t.ticket_number, u.full_name as user_name, " +
                "dr.full_name as driver_name, rt.route_name " +
                "FROM Ratings r " +
                "JOIN Tickets t ON r.ticket_id = t.ticket_id " +
                "JOIN Users u ON r.user_id = u.user_id " +
                "JOIN Drivers d ON r.driver_id = d.driver_id " +
                "JOIN Users dr ON d.user_id = dr.user_id " +
                "JOIN Schedules s ON t.schedule_id = s.schedule_id " +
                "JOIN Routes rt ON s.route_id = rt.route_id " +
                "WHERE r.user_id = ? " +
                "ORDER BY r.created_date DESC";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, userId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Rating rating = mapResultSetToRating(rs);
                ratings.add(rating);
            }
        }
        return ratings;
    }

    private Rating mapResultSetToRating(ResultSet rs) throws SQLException {
        Rating rating = new Rating();

        rating.setRatingId(UUIDUtils.getUUIDFromResultSet(rs, "rating_id"));
        rating.setTicketId(UUIDUtils.getUUIDFromResultSet(rs, "ticket_id"));
        rating.setUserId(UUIDUtils.getUUIDFromResultSet(rs, "user_id"));
        rating.setDriverId(UUIDUtils.getUUIDFromResultSet(rs, "driver_id"));
        rating.setRatingValue(rs.getInt("rating_value"));
        rating.setComments(rs.getString("comments"));

        Timestamp createdDate = rs.getTimestamp("created_date");
        if (createdDate != null) {
            rating.setCreatedDate(createdDate.toLocalDateTime());
        }

        // Display fields from joins
        rating.setTicketNumber(rs.getString("ticket_number"));
        rating.setUserName(rs.getString("user_name"));
        rating.setDriverName(rs.getString("driver_name"));
        rating.setRouteName(rs.getString("route_name"));

        return rating;
    }
}
