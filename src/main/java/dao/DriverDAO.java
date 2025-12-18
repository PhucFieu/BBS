package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import model.Driver;
import util.DBConnection;
import util.UUIDUtils;

public class DriverDAO {

    public List<Driver> getAllDrivers() throws SQLException {
        List<Driver> drivers = new ArrayList<>();
        String sql = "SELECT d.*, u.username, u.full_name, u.phone_number, u.email " +
                "FROM Drivers d " +
                "JOIN Users u ON d.user_id = u.user_id " +
                "WHERE d.status = 'ACTIVE' AND u.status = 'ACTIVE' " +
                "ORDER BY u.full_name";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Driver driver = mapResultSetToDriver(rs);
                drivers.add(driver);
            }
        }
        return drivers;
    }

    /**
     * Get admin driver list with optional status filter. Defaults to ACTIVE only.
     */
    public List<Driver> getAllDriversForAdmin(String statusFilter) throws SQLException {
        List<Driver> drivers = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT d.*, u.username, u.full_name, u.phone_number, u.email " +
                        "FROM Drivers d " +
                        "JOIN Users u ON d.user_id = u.user_id " +
                        "WHERE 1=1 ");
        List<Object> parameters = new ArrayList<>();

        String normalizedStatus = normalizeStatusFilter(statusFilter);
        if (!"ALL".equals(normalizedStatus)) {
            sql.append("AND d.status = ? ");
            parameters.add(normalizedStatus);
        }

        sql.append("ORDER BY d.status DESC, u.full_name");

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < parameters.size(); i++) {
                stmt.setObject(i + 1, parameters.get(i));
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Driver driver = mapResultSetToDriver(rs);
                    drivers.add(driver);
                }
            }
        }
        return drivers;
    }

    public Driver getDriverById(UUID driverId) throws SQLException {
        String sql = "SELECT d.*, u.username, u.full_name, u.phone_number, u.email " +
                "FROM Drivers d " +
                "JOIN Users u ON d.user_id = u.user_id " +
                "WHERE d.driver_id = ? AND d.status = 'ACTIVE' AND u.status = 'ACTIVE'";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, driverId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToDriver(rs);
            }
        }
        return null;
    }

    /**
     * Get driver by ID for admin (includes inactive drivers)
     */
    public Driver getDriverByIdForAdmin(UUID driverId) throws SQLException {
        String sql = "SELECT d.*, u.username, u.full_name, u.phone_number, u.email " +
                "FROM Drivers d " +
                "JOIN Users u ON d.user_id = u.user_id " +
                "WHERE d.driver_id = ?";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, driverId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToDriver(rs);
            }
        }
        return null;
    }

    public Driver getDriverByUserId(UUID userId) throws SQLException {
        String sql = "SELECT d.*, u.username, u.full_name, u.phone_number, u.email " +
                "FROM Drivers d " +
                "JOIN Users u ON d.user_id = u.user_id " +
                "WHERE d.user_id = ? AND d.status = 'ACTIVE' AND u.status = 'ACTIVE'";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, userId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToDriver(rs);
            }
        }
        return null;
    }

    public Driver getDriverByLicenseNumber(String licenseNumber) throws SQLException {
        String sql = "SELECT d.*, u.username, u.full_name, u.phone_number, u.email " +
                "FROM Drivers d " +
                "JOIN Users u ON d.user_id = u.user_id " +
                "WHERE d.license_number = ? AND d.status = 'ACTIVE' AND u.status = 'ACTIVE'";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, licenseNumber);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToDriver(rs);
            }
        }
        return null;
    }

    public List<Driver> searchDrivers(String keyword) throws SQLException {
        List<Driver> drivers = new ArrayList<>();
        String sql = "SELECT d.*, u.username, u.full_name, u.phone_number, u.email " +
                "FROM Drivers d " +
                "JOIN Users u ON d.user_id = u.user_id " +
                "WHERE d.status = 'ACTIVE' AND u.status = 'ACTIVE' " +
                "AND (u.full_name LIKE ? OR d.license_number LIKE ? OR u.phone_number LIKE ?) " +
                "ORDER BY u.full_name";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            String searchPattern = "%" + keyword.trim() + "%";
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);
            stmt.setString(3, searchPattern);

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Driver driver = mapResultSetToDriver(rs);
                drivers.add(driver);
            }
        }
        return drivers;
    }

    /**
     * Search drivers for admin with optional status filter.
     */
    public List<Driver> searchDriversForAdmin(String keyword, String statusFilter)
            throws SQLException {
        List<Driver> drivers = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT d.*, u.username, u.full_name, u.phone_number, u.email " +
                        "FROM Drivers d " +
                        "JOIN Users u ON d.user_id = u.user_id " +
                        "WHERE (u.full_name LIKE ? OR d.license_number LIKE ? OR u.phone_number LIKE ?) ");
        List<Object> parameters = new ArrayList<>();

        String searchPattern = "%" + keyword.trim() + "%";
        parameters.add(searchPattern);
        parameters.add(searchPattern);
        parameters.add(searchPattern);

        String normalizedStatus = normalizeStatusFilter(statusFilter);
        if (!"ALL".equals(normalizedStatus)) {
            sql.append("AND d.status = ? ");
            parameters.add(normalizedStatus);
        }

        sql.append("ORDER BY d.status DESC, u.full_name");

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < parameters.size(); i++) {
                stmt.setObject(i + 1, parameters.get(i));
            }

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Driver driver = mapResultSetToDriver(rs);
                drivers.add(driver);
            }
        }
        return drivers;
    }

    private String normalizeStatusFilter(String statusFilter) {
        if (statusFilter == null || statusFilter.trim().isEmpty()) {
            return "ACTIVE";
        }
        String normalized = statusFilter.trim().toUpperCase();
        if ("ACTIVE".equals(normalized) || "INACTIVE".equals(normalized)
                || "ALL".equals(normalized)) {
            return normalized;
        }
        return "ACTIVE";
    }

    public boolean addDriver(Driver driver) throws SQLException {
        String sql = "INSERT INTO Drivers (driver_id, user_id, license_number, experience_years, status) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, driver.getDriverId());
            stmt.setObject(2, driver.getUserId());
            stmt.setString(3, driver.getLicenseNumber());
            stmt.setInt(4, driver.getExperienceYears());
            stmt.setString(5, driver.getStatus());

            return stmt.executeUpdate() > 0;
        }
    }

    public boolean updateDriver(Driver driver) throws SQLException {
        String sql = "UPDATE Drivers SET license_number = ?, experience_years = ?, status = ?, updated_date = GETDATE() WHERE driver_id = ?";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, driver.getLicenseNumber());
            stmt.setInt(2, driver.getExperienceYears());
            stmt.setString(3, driver.getStatus());
            stmt.setObject(4, driver.getDriverId());

            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Delete driver with comprehensive safety checks
     * This method performs a soft delete by setting status to INACTIVE
     */
    public boolean deleteDriver(UUID driverId) throws SQLException {
        // First check if driver exists and is active
        Driver driver = getDriverById(driverId);
        if (driver == null) {
            return false;
        }

        // Perform soft delete (set status to INACTIVE)
        String sql = "UPDATE Drivers SET status = 'INACTIVE', updated_date = GETDATE() WHERE driver_id = ?";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, driverId);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        }
    }

    /**
     * Check if driver has any active schedule assignments
     */
    public boolean hasActiveSchedules(UUID driverId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM ScheduleDrivers sd " +
                "JOIN Schedules s ON sd.schedule_id = s.schedule_id " +
                "WHERE sd.driver_id = ? AND s.status = 'ACTIVE'";

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
     * Check if driver has any pending tickets
     */
    public boolean hasPendingTickets(UUID driverId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Tickets t " +
                "JOIN Schedules s ON t.schedule_id = s.schedule_id " +
                "JOIN ScheduleDrivers sd ON s.schedule_id = sd.schedule_id " +
                "WHERE sd.driver_id = ? AND t.status IN ('PENDING', 'CONFIRMED')";

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

    public int getTotalDrivers() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Drivers WHERE status = 'ACTIVE'";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    public List<Driver> getAvailableDrivers() throws SQLException {
        List<Driver> drivers = new ArrayList<>();
        String sql = "SELECT d.*, u.username, u.full_name, u.phone_number, u.email " +
                "FROM Drivers d " +
                "JOIN Users u ON d.user_id = u.user_id " +
                "WHERE d.status = 'ACTIVE' AND u.status = 'ACTIVE' " +
                "ORDER BY u.full_name";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Driver driver = mapResultSetToDriver(rs);
                drivers.add(driver);
            }
        }
        return drivers;
    }

    public boolean isLicenseNumberExists(String licenseNumber, UUID excludeDriverId)
            throws SQLException {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM Drivers WHERE license_number = ?");

        if (excludeDriverId != null) {
            sql.append(" AND driver_id <> ?");
        }

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            stmt.setString(1, licenseNumber);
            if (excludeDriverId != null) {
                stmt.setObject(2, excludeDriverId);
            }

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    private Driver mapResultSetToDriver(ResultSet rs) throws SQLException {
        Driver driver = new Driver();

        driver.setDriverId(UUIDUtils.getUUIDFromResultSet(rs, "driver_id"));
        driver.setUserId(UUIDUtils.getUUIDFromResultSet(rs, "user_id"));
        driver.setLicenseNumber(rs.getString("license_number"));
        driver.setExperienceYears(rs.getInt("experience_years"));
        driver.setStatus(rs.getString("status"));

        // Display fields from Users table
        driver.setUsername(rs.getString("username"));
        driver.setFullName(rs.getString("full_name"));
        driver.setPhoneNumber(rs.getString("phone_number"));
        driver.setEmail(rs.getString("email"));

        Timestamp createdDate = rs.getTimestamp("created_date");
        if (createdDate != null) {
            driver.setCreatedDate(createdDate.toLocalDateTime());
        }

        Timestamp updatedDate = rs.getTimestamp("updated_date");
        if (updatedDate != null) {
            driver.setUpdatedDate(updatedDate.toLocalDateTime());
        }

        return driver;
    }

    public Driver getDriverByScheduleId(UUID scheduleId) throws SQLException {
        String sql = "SELECT d.*, u.username, u.full_name, u.phone_number, u.email " +
                "FROM Drivers d " +
                "JOIN Users u ON d.user_id = u.user_id " +
                "JOIN ScheduleDrivers sd ON d.driver_id = sd.driver_id " +
                "WHERE sd.schedule_id = ? AND d.status = 'ACTIVE' AND u.status = 'ACTIVE'";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, scheduleId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Driver driver = mapResultSetToDriver(rs);
                // Get rating information
                driver.setAverageRating(getAverageRating(driver.getDriverId()));
                driver.setTotalRatings(getTotalRatings(driver.getDriverId()));
                return driver;
            }
        }
        return null;
    }

    private double getAverageRating(UUID driverId) throws SQLException {
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

    private int getTotalRatings(UUID driverId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Ratings WHERE driver_id = ?";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, driverId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }
}
