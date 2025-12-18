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

public class UserDAO {

    public User authenticate(String username, String password) throws SQLException {
        String sql = "SELECT * FROM Users WHERE username = ?";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                User user = mapResultSetToUser(rs);
                // Verify password using MD5 hash
                if (PasswordUtils.verifyPassword(password, user.getPassword())) {
                    if (!"USER".equalsIgnoreCase(user.getRole())
                            && !"ACTIVE".equalsIgnoreCase(user.getStatus())) {
                        return null;
                    }
                    if ("INACTIVE".equalsIgnoreCase(user.getStatus())
                            && "USER".equalsIgnoreCase(user.getRole())) {
                        reactivateUser(user.getUserId());
                        user.setStatus("ACTIVE");
                    }
                    // Update last login
                    updateLastLogin(user.getUserId());
                    return user;
                }
            }
        }
        return null;
    }

    public User getUserById(UUID userId) throws SQLException {
        String sql = "SELECT * FROM Users WHERE user_id = ? AND status = 'ACTIVE'";

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

    public User getUserByUsername(String username) throws SQLException {
        String sql = "SELECT * FROM Users WHERE username = ?";

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

    public List<User> getAllUsers() throws SQLException {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM Users WHERE status = 'ACTIVE' ORDER BY username";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                User user = mapResultSetToUser(rs);
                users.add(user);
            }
        }
        return users;
    }

    public boolean addUser(User user) throws SQLException {
        String sql = "INSERT INTO Users (user_id, username, password, full_name, email, phone_number, role, status, id_card, address, date_of_birth, gender) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            // Log all values before insertion for debugging
            System.out.println("=== DEBUG: Adding User ===");
            System.out.println("User ID: " + user.getUserId());
            System.out.println("Username: '" + user.getUsername() + "'");
            System.out.println(
                    "Email: '" + user.getEmail() + "' (null=" + (user.getEmail() == null) + ")");
            System.out.println("Phone: '" + user.getPhoneNumber() + "' (null="
                    + (user.getPhoneNumber() == null) + ")");
            System.out.println("ID Card: '" + user.getIdCard() + "' (null="
                    + (user.getIdCard() == null) + ")");
            System.out.println("Full Name: '" + user.getFullName() + "'");
            System.out.println("Role: '" + user.getRole() + "'");
            System.out.println("==========================");

            stmt.setObject(1, user.getUserId());
            stmt.setString(2, user.getUsername());
            stmt.setString(3, PasswordUtils.hashPassword(user.getPassword()));
            stmt.setString(4, user.getFullName());

            // Handle email - set to null if empty or null
            if (user.getEmail() != null && !user.getEmail().trim().isEmpty()) {
                stmt.setString(5, user.getEmail().trim());
            } else {
                stmt.setNull(5, Types.VARCHAR);
            }

            // Handle phone_number - set to null if empty or null
            if (user.getPhoneNumber() != null && !user.getPhoneNumber().trim().isEmpty()) {
                stmt.setString(6, user.getPhoneNumber().trim());
            } else {
                stmt.setNull(6, Types.VARCHAR);
            }

            stmt.setString(7, user.getRole());
            stmt.setString(8, user.getStatus());

            // Handle id_card - set to null if empty or null
            if (user.getIdCard() != null && !user.getIdCard().trim().isEmpty()) {
                stmt.setString(9, user.getIdCard());
            } else {
                stmt.setNull(9, Types.VARCHAR);
            }

            // Handle address - set to null if empty or null
            if (user.getAddress() != null && !user.getAddress().trim().isEmpty()) {
                stmt.setString(10, user.getAddress());
            } else {
                stmt.setNull(10, Types.VARCHAR);
            }

            if (user.getDateOfBirth() != null) {
                stmt.setDate(11, Date.valueOf(user.getDateOfBirth()));
            } else {
                stmt.setNull(11, Types.DATE);
            }

            // Handle gender - set to null if empty or null
            if (user.getGender() != null && !user.getGender().trim().isEmpty()) {
                stmt.setString(12, user.getGender());
            } else {
                stmt.setNull(12, Types.VARCHAR);
            }

            try {
                int rowsAffected = stmt.executeUpdate();
                System.out.println(
                        "=== DEBUG: Insert successful, rows affected: " + rowsAffected + " ===");
                return rowsAffected > 0;
            } catch (SQLException e) {
                System.err.println("=== DEBUG: SQLException occurred ===");
                System.err.println("Error Code: " + e.getErrorCode());
                System.err.println("SQL State: " + e.getSQLState());
                System.err.println("Message: " + e.getMessage());
                System.err
                        .println("Constraint Name: "
                                + (e.getMessage().contains("UQ__Users__")
                                        ? e.getMessage().substring(
                                                e.getMessage().indexOf("UQ__Users__"),
                                                Math.min(e.getMessage().indexOf("UQ__Users__") + 30,
                                                        e.getMessage().length()))
                                        : "N/A"));
                System.err.println("===================================");
                throw e;
            }
        }
    }

    public boolean updateUser(User user) throws SQLException {
        String sql = "UPDATE Users SET full_name = ?, email = ?, phone_number = ?, role = ?, status = ?, id_card = ?, address = ?, date_of_birth = ?, gender = ?, updated_date = GETDATE() WHERE user_id = ?";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, user.getFullName());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getPhoneNumber());
            stmt.setString(4, user.getRole());
            stmt.setString(5, user.getStatus());

            // Handle id_card - set to null if empty or null
            if (user.getIdCard() != null && !user.getIdCard().trim().isEmpty()) {
                stmt.setString(6, user.getIdCard());
            } else {
                stmt.setNull(6, Types.VARCHAR);
            }

            // Handle address - set to null if empty or null
            if (user.getAddress() != null && !user.getAddress().trim().isEmpty()) {
                stmt.setString(7, user.getAddress());
            } else {
                stmt.setNull(7, Types.VARCHAR);
            }

            if (user.getDateOfBirth() != null) {
                stmt.setDate(8, Date.valueOf(user.getDateOfBirth()));
            } else {
                stmt.setNull(8, Types.DATE);
            }

            // Handle gender - set to null if empty or null
            if (user.getGender() != null && !user.getGender().trim().isEmpty()) {
                stmt.setString(9, user.getGender());
            } else {
                stmt.setNull(9, Types.VARCHAR);
            }

            stmt.setObject(10, user.getUserId());

            return stmt.executeUpdate() > 0;
        }
    }

    public boolean changePassword(UUID userId, String newPassword) throws SQLException {
        String sql = "UPDATE Users SET password = ?, updated_date = GETDATE() WHERE user_id = ?";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, PasswordUtils.hashPassword(newPassword));
            stmt.setObject(2, userId);

            return stmt.executeUpdate() > 0;
        }
    }

    public boolean deleteUser(UUID userId) throws SQLException {
        String sql = "UPDATE Users SET status = 'INACTIVE', updated_date = GETDATE() WHERE user_id = ?";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, userId);
            return stmt.executeUpdate() > 0;
        }
    }

    private boolean updateLastLogin(UUID userId) throws SQLException {
        String sql = "UPDATE Users SET last_login = GETDATE() WHERE user_id = ?";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, userId);
            return stmt.executeUpdate() > 0;
        }
    }

    public List<User> searchUsers(String searchTerm) throws SQLException {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM Users WHERE (username LIKE ? OR full_name LIKE ? OR email LIKE ? OR phone_number LIKE ?) AND status = 'ACTIVE' ORDER BY username";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            String searchPattern = "%" + searchTerm.trim() + "%";
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);
            stmt.setString(3, searchPattern);
            stmt.setString(4, searchPattern);

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                User user = mapResultSetToUser(rs);
                users.add(user);
            }
        }
        return users;
    }

    public List<User> searchUsers(String searchTerm, String role) throws SQLException {
        List<User> users = new ArrayList<>();
        String sql;

        // If search term is empty, return all users with the specified role
        if (searchTerm == null || searchTerm.trim().isEmpty()) {
            sql = "SELECT * FROM Users WHERE role = ? AND status = 'ACTIVE' ORDER BY full_name";
        } else {
            sql = "SELECT * FROM Users WHERE (username LIKE ? OR full_name LIKE ? OR email LIKE ? OR phone_number LIKE ?) AND role = ? AND status = 'ACTIVE' ORDER BY full_name";
        }

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            if (searchTerm == null || searchTerm.trim().isEmpty()) {
                // No search term - return all users with specified role
                stmt.setString(1, role);
            } else {
                // With search term - search in multiple fields
                String searchPattern = "%" + searchTerm.trim() + "%";
                stmt.setString(1, searchPattern);
                stmt.setString(2, searchPattern);
                stmt.setString(3, searchPattern);
                stmt.setString(4, searchPattern);
                stmt.setString(5, role);
            }

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                User user = mapResultSetToUser(rs);
                users.add(user);
            }
        }
        return users;
    }

    public User getUserByPhone(String phoneNumber) throws SQLException {
        String sql = "SELECT * FROM Users WHERE phone_number = ?";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, phoneNumber);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
        }
        return null;
    }

    public User getUserByEmail(String email) throws SQLException {
        String sql = "SELECT * FROM Users WHERE email = ?";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
        }
        return null;
    }

    public User getUserByIdCard(String idCard) throws SQLException {
        String sql = "SELECT * FROM Users WHERE id_card = ?";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, idCard);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
        }
        return null;
    }

    public List<User> getUsersByRole(String role) throws SQLException {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM Users WHERE role = ? AND status = 'ACTIVE' ORDER BY username";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, role);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                User user = mapResultSetToUser(rs);
                users.add(user);
            }
        }
        return users;
    }

    /**
     * Get distinct passengers (Users with role USER) who have confirmed tickets
     * on schedules assigned to the given driver (identified by driver's user_id).
     * Only includes passengers with tickets that have payment_status = 'PAID'.
     */
    public List<User> getPassengersByDriverUserId(UUID driverUserId) throws SQLException {
        List<User> users = new ArrayList<>();
        String sql = "SELECT DISTINCT u.* " +
                "FROM Tickets t " +
                "JOIN Schedules s ON t.schedule_id = s.schedule_id " +
                "JOIN ScheduleDrivers sd ON s.schedule_id = sd.schedule_id " +
                "JOIN Drivers d ON sd.driver_id = d.driver_id " +
                "JOIN Users du ON d.user_id = du.user_id " +
                "JOIN Users u ON t.user_id = u.user_id " +
                "WHERE du.user_id = ? AND t.status = 'CONFIRMED' AND t.payment_status = 'PAID' AND u.status = 'ACTIVE' AND u.role = 'USER' "
                +
                "ORDER BY u.full_name";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, driverUserId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                User user = mapResultSetToUser(rs);
                users.add(user);
            }
        }
        return users;
    }

    public List<User> getRecentUsers(int limit) throws SQLException {
        List<User> users = new ArrayList<>();
        String sql = "SELECT TOP (?) * FROM Users WHERE status = 'ACTIVE' ORDER BY created_date DESC";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                User user = mapResultSetToUser(rs);
                users.add(user);
            }
        }
        return users;
    }

    public int getTotalUsers() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Users WHERE status = 'ACTIVE'";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

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

    /**
     * Deactivate user account (soft delete)
     */
    public boolean deactivateUser(UUID userId) throws SQLException {
        String sql = "UPDATE Users SET status = 'INACTIVE', updated_date = GETDATE() WHERE user_id = ?";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, userId);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        }
    }

    /**
     * Reactivate a user account.
     */
    public boolean reactivateUser(UUID userId) throws SQLException {
        String sql = "UPDATE Users SET status = 'ACTIVE', updated_date = GETDATE() WHERE user_id = ?";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, userId);
            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Automatically deactivate passenger accounts that have been inactive for the
     * given number of
     * months.
     *
     * @param monthsThreshold number of months without login activity before marking
     *                        inactive
     * @return number of affected rows
     */
    public int deactivateInactivePassengers(int monthsThreshold) throws SQLException {
        String sql = "UPDATE Users SET status = 'INACTIVE', updated_date = GETDATE() "
                + "WHERE role = 'USER' AND status = 'ACTIVE' "
                + "AND ("
                + "    (last_login IS NOT NULL AND last_login < DATEADD(MONTH, ?, GETDATE())) "
                + " OR (last_login IS NULL AND created_date < DATEADD(MONTH, ?, GETDATE()))"
                + ")";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, -Math.abs(monthsThreshold));
            stmt.setInt(2, -Math.abs(monthsThreshold));
            return stmt.executeUpdate();
        }
    }
}
