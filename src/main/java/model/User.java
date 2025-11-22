package model;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.UUID;

public class User {

    private UUID userId;
    private String username;
    private String password;
    private String fullName;
    private String email;
    private String phoneNumber;
    private String role; // ADMIN, USER (Passenger), DRIVER
    private String status; // ACTIVE, INACTIVE
    private String idCard;
    private String address;
    private LocalDate dateOfBirth;
    private String gender;
    private LocalDateTime lastLogin;
    private LocalDateTime createdDate;
    private LocalDateTime updatedDate;

    // Constructors
    public User() {
    }

    public User(
            String username,
            String password,
            String fullName,
            String email,
            String phoneNumber,
            String role) {
        this.userId = UUID.randomUUID();
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
        if (createdDate == null)
            return "";
        return createdDate.format(
                DateTimeFormatter.ofPattern("EEEE, MMMM dd, yyyy"));
    }

    public String getLastLoginStr() {
        if (lastLogin == null)
            return "N/A";
        return lastLogin.format(
                DateTimeFormatter.ofPattern("MMM dd, yyyy 'at' HH:mm"));
    }

    /**
     * Format created date for display in JSP
     * 
     * @return formatted date string or "N/A" if null
     */
    public String getFormattedCreatedDate() {
        if (createdDate == null)
            return "N/A";
        return createdDate.format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
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

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getIdCard() {
        return idCard;
    }

    public void setIdCard(String idCard) {
        this.idCard = idCard;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public LocalDate getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(LocalDate dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
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
        return ("User{" +
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
                '}');
    }
}
