package model;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.UUID;

/**
 *
 * @author TàiNH CE190387
 */
public class User {

    private UUID userId;
    private String username;
    private String password;
    private String fullName;
    private String email;
    private String phoneNumber;
    private String role; // ADMIN, STAFF, CUSTOMER
    private String status; // ACTIVE, INACTIVE
    private String idCard;
    private String address;
    private LocalDate dateOfBirth;
    private String gender;
    private LocalDateTime lastLogin;
    private LocalDateTime createdDate;
    private LocalDateTime updatedDate;

    // Constructors
    public User() {}

    public User(
        String username,
        String password,
        String fullName,
        String email,
        String phoneNumber,
        String role
    ) {
        this.username = username;
        this.password = password;
        this.fullName = fullName;
        this.email = email;
        this.role = role;
        this.phoneNumber = phoneNumber;
        this.createdDate = LocalDateTime.now();
        this.updatedDate = LocalDateTime.now();
        this.status = "ACTIVE";
    }

    public String getCreatedDateStr() {
        if (createdDate == null) return "";
        return createdDate.format(
            DateTimeFormatter.ofPattern("EEEE, MMMM dd, yyyy")
        );
    }

    public String getLastLoginStr() {
        if (lastLogin == null) return "N/A";
        return lastLogin.format(
            DateTimeFormatter.ofPattern("MMM dd, yyyy 'at' HH:mm")
        );
    }

    // Getters and Setters
    public UUID getUserId() {
        return userId;
    }

    public void setUserId(UUID userId) {
        this.userId = userId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public LocalDateTime getLastLogin() {
        return lastLogin;
    }

    public void setLastLogin(LocalDateTime lastLogin) {
        this.lastLogin = lastLogin;
    }

    public LocalDateTime getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(LocalDateTime createdDate) {
        this.createdDate = createdDate;
    }

    public LocalDateTime getUpdatedDate() {
        return updatedDate;
    }

    public void setUpdatedDate(LocalDateTime updatedDate) {
        this.updatedDate = updatedDate;
    }

    @Override
    public String toString() {
        return (
            "User{" +
            "userId=" +
            userId +
            ", username='" +
            username +
            '\'' +
            ", fullName='" +
            fullName +
            '\'' +
            ", email='" +
            email +
            '\'' +
            ", role='" +
            role +
            '\'' +
            ", status='" +
            status +
            '\'' +
            '}'
        );
    }
}
