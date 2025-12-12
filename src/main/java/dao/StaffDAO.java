package dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import model.User;
import util.DBConnection;
import util.PasswordUtils;
import util.UUIDUtils;

/**
 * Data Access Object for Staff management operations.
 * Handles CRUD operations specifically for users with STAFF role.
 */
public class StaffDAO {

    /**
     * Get all active staff members
     * 
     * @return List of staff users
     * @throws SQLException if database error occurs
     */
    public List<User> getAllStaff() throws SQLException {
        List<User> staffList = new ArrayList<>();
        String sql = "SELECT * FROM Users WHERE role = 'STAFF' AND status = 'ACTIVE' ORDER BY full_name";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                User staff = mapResultSetToUser(rs);
                staffList.add(staff);
            }
        }
        return staffList;
    }

    /**
     * Get staff by ID
     * 
     * @param userId the staff user ID
     * @return Staff user object or null if not found
     * @throws SQLException if database error occurs
     */
    public User getStaffById(UUID userId) throws SQLException {
        String sql = "SELECT * FROM Users WHERE user_id = ? AND role = 'STAFF'";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, userId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
        }
        return null;
    }

    /**
     * Get staff by username
     * 
     * @param username the staff username
     * @return Staff user object or null if not found
     * @throws SQLException if database error occurs
     */
    public User getStaffByUsername(String username) throws SQLException {
        String sql = "SELECT * FROM Users WHERE username = ? AND role = 'STAFF'";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
        }
        return null;
    }

    /**
     * Add a new staff member
     * 
     * @param staff the staff user object to add
     * @return true if successful, false otherwise
     * @throws SQLException if database error occurs
     */
    public boolean addStaff(User staff) throws SQLException {
        String sql = "INSERT INTO Users (user_id, username, password, full_name, email, phone_number, role, status, id_card, address, date_of_birth, gender) "
                + "VALUES (?, ?, ?, ?, ?, ?, 'STAFF', 'ACTIVE', ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, staff.getUserId());
            stmt.setString(2, staff.getUsername());
            stmt.setString(3, PasswordUtils.hashPassword(staff.getPassword()));
            stmt.setString(4, staff.getFullName());

            // Handle email
            if (staff.getEmail() != null && !staff.getEmail().trim().isEmpty()) {
                stmt.setString(5, staff.getEmail().trim());
            } else {
                stmt.setNull(5, Types.VARCHAR);
            }

            // Handle phone number
            if (staff.getPhoneNumber() != null && !staff.getPhoneNumber().trim().isEmpty()) {
                stmt.setString(6, staff.getPhoneNumber().trim());
            } else {
                stmt.setNull(6, Types.VARCHAR);
            }

            // Handle ID card
            if (staff.getIdCard() != null && !staff.getIdCard().trim().isEmpty()) {
                stmt.setString(7, staff.getIdCard());
            } else {
                stmt.setNull(7, Types.VARCHAR);
            }

            // Handle address
            if (staff.getAddress() != null && !staff.getAddress().trim().isEmpty()) {
                stmt.setString(8, staff.getAddress());
            } else {
                stmt.setNull(8, Types.VARCHAR);
            }

            // Handle date of birth
            if (staff.getDateOfBirth() != null) {
                stmt.setDate(9, Date.valueOf(staff.getDateOfBirth()));
            } else {
                stmt.setNull(9, Types.DATE);
            }

            // Handle gender
            if (staff.getGender() != null && !staff.getGender().trim().isEmpty()) {
                stmt.setString(10, staff.getGender());
            } else {
                stmt.setNull(10, Types.VARCHAR);
            }

            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Update staff information
     * 
     * @param staff the staff user object with updated information
     * @return true if successful, false otherwise
     * @throws SQLException if database error occurs
     */
    public boolean updateStaff(User staff) throws SQLException {
        String sql = "UPDATE Users SET full_name = ?, email = ?, phone_number = ?, id_card = ?, "
                + "address = ?, date_of_birth = ?, gender = ?, updated_date = GETDATE() "
                + "WHERE user_id = ? AND role = 'STAFF'";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, staff.getFullName());

            // Handle email
            if (staff.getEmail() != null && !staff.getEmail().trim().isEmpty()) {
                stmt.setString(2, staff.getEmail().trim());
            } else {
                stmt.setNull(2, Types.VARCHAR);
            }

            // Handle phone number
            if (staff.getPhoneNumber() != null && !staff.getPhoneNumber().trim().isEmpty()) {
                stmt.setString(3, staff.getPhoneNumber().trim());
            } else {
                stmt.setNull(3, Types.VARCHAR);
            }

            // Handle ID card
            if (staff.getIdCard() != null && !staff.getIdCard().trim().isEmpty()) {
                stmt.setString(4, staff.getIdCard());
            } else {
                stmt.setNull(4, Types.VARCHAR);
            }

            // Handle address
            if (staff.getAddress() != null && !staff.getAddress().trim().isEmpty()) {
                stmt.setString(5, staff.getAddress());
            } else {
                stmt.setNull(5, Types.VARCHAR);
            }

            // Handle date of birth
            if (staff.getDateOfBirth() != null) {
                stmt.setDate(6, Date.valueOf(staff.getDateOfBirth()));
            } else {
                stmt.setNull(6, Types.DATE);
            }

            // Handle gender
            if (staff.getGender() != null && !staff.getGender().trim().isEmpty()) {
                stmt.setString(7, staff.getGender());
            } else {
                stmt.setNull(7, Types.VARCHAR);
            }

            stmt.setObject(8, staff.getUserId());

            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Delete staff member (soft delete - set status to INACTIVE)
     * 
     * @param userId the staff user ID to delete
     * @return true if successful, false otherwise
     * @throws SQLException if database error occurs
     */
    public boolean deleteStaff(UUID userId) throws SQLException {
        String sql = "UPDATE Users SET status = 'INACTIVE', updated_date = GETDATE() "
                + "WHERE user_id = ? AND role = 'STAFF'";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, userId);
            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Reactivate a staff member
     * 
     * @param userId the staff user ID to reactivate
     * @return true if successful, false otherwise
     * @throws SQLException if database error occurs
     */
    public boolean reactivateStaff(UUID userId) throws SQLException {
        String sql = "UPDATE Users SET status = 'ACTIVE', updated_date = GETDATE() "
                + "WHERE user_id = ? AND role = 'STAFF'";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, userId);
            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Search staff by name, username, email or phone
     * 
     * @param searchTerm the search term
     * @return List of matching staff users
     * @throws SQLException if database error occurs
     */
    public List<User> searchStaff(String searchTerm) throws SQLException {
        List<User> staffList = new ArrayList<>();

        // If search term is empty, return all staff
        if (searchTerm == null || searchTerm.trim().isEmpty()) {
            return getAllStaff();
        }

        String sql = "SELECT * FROM Users WHERE role = 'STAFF' AND status = 'ACTIVE' "
                + "AND (username LIKE ? OR full_name LIKE ? OR email LIKE ? OR phone_number LIKE ?) "
                + "ORDER BY full_name";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            String searchPattern = "%" + searchTerm + "%";
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);
            stmt.setString(3, searchPattern);
            stmt.setString(4, searchPattern);

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                User staff = mapResultSetToUser(rs);
                staffList.add(staff);
            }
        }
        return staffList;
    }

    /**
     * Get total count of active staff members
     * 
     * @return count of staff
     * @throws SQLException if database error occurs
     */
    public int getTotalStaff() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Users WHERE role = 'STAFF' AND status = 'ACTIVE'";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    /**
     * Get recent staff members
     * 
     * @param limit maximum number of records to return
     * @return List of recent staff users
     * @throws SQLException if database error occurs
     */
    public List<User> getRecentStaff(int limit) throws SQLException {
        List<User> staffList = new ArrayList<>();
        String sql = "SELECT TOP (?) * FROM Users WHERE role = 'STAFF' AND status = 'ACTIVE' "
                + "ORDER BY created_date DESC";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                User staff = mapResultSetToUser(rs);
                staffList.add(staff);
            }
        }
        return staffList;
    }

    /**
     * Change staff password
     * 
     * @param userId      the staff user ID
     * @param newPassword the new password (will be hashed)
     * @return true if successful, false otherwise
     * @throws SQLException if database error occurs
     */
    public boolean changeStaffPassword(UUID userId, String newPassword) throws SQLException {
        String sql = "UPDATE Users SET password = ?, updated_date = GETDATE() "
                + "WHERE user_id = ? AND role = 'STAFF'";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, PasswordUtils.hashPassword(newPassword));
            stmt.setObject(2, userId);

            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Check if username exists in Users table (all roles)
     * 
     * @param username the username to check
     * @return true if exists, false otherwise
     * @throws SQLException if database error occurs
     */
    public boolean usernameExists(String username) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Users WHERE username = ?";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }

    /**
     * Check if email exists in Users table (all roles)
     * 
     * @param email         the email to check
     * @param excludeUserId user ID to exclude from check (for updates)
     * @return true if exists, false otherwise
     * @throws SQLException if database error occurs
     */
    public boolean emailExists(String email, UUID excludeUserId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Users WHERE email = ?";

        if (excludeUserId != null) {
            sql += " AND user_id != ?";
        }

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);
            if (excludeUserId != null) {
                stmt.setObject(2, excludeUserId);
            }

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }

    /**
     * Check if phone number exists in Users table (all roles)
     * 
     * @param phoneNumber   the phone number to check
     * @param excludeUserId user ID to exclude from check (for updates)
     * @return true if exists, false otherwise
     * @throws SQLException if database error occurs
     */
    public boolean phoneNumberExists(String phoneNumber, UUID excludeUserId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Users WHERE phone_number = ?";

        if (excludeUserId != null) {
            sql += " AND user_id != ?";
        }

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, phoneNumber);
            if (excludeUserId != null) {
                stmt.setObject(2, excludeUserId);
            }

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }

    /**
     * Map ResultSet to User object
     * 
     * @param rs the ResultSet from database query
     * @return User object
     * @throws SQLException if database error occurs
     */
    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(UUIDUtils.getUUIDFromResultSet(rs, "user_id"));
        user.setUsername(rs.getString("username"));
        user.setPassword(rs.getString("password"));
        user.setFullName(rs.getString("full_name"));
        user.setEmail(rs.getString("email"));
        user.setPhoneNumber(rs.getString("phone_number"));
        user.setRole(rs.getString("role"));
        user.setStatus(rs.getString("status"));
        user.setIdCard(rs.getString("id_card"));
        user.setAddress(rs.getString("address"));

        Date dateOfBirth = rs.getDate("date_of_birth");
        if (dateOfBirth != null) {
            user.setDateOfBirth(dateOfBirth.toLocalDate());
        }

        user.setGender(rs.getString("gender"));

        Timestamp lastLogin = rs.getTimestamp("last_login");
        if (lastLogin != null) {
            user.setLastLogin(lastLogin.toLocalDateTime());
        }

        Timestamp createdDate = rs.getTimestamp("created_date");
        if (createdDate != null) {
            user.setCreatedDate(createdDate.toLocalDateTime());
        }

        Timestamp updatedDate = rs.getTimestamp("updated_date");
        if (updatedDate != null) {
            user.setUpdatedDate(updatedDate.toLocalDateTime());
        }

        return user;
    }
}
