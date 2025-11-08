package model;

import java.time.LocalDateTime;
import java.util.UUID;

public class Driver {
    private UUID driverId;
    private UUID userId;
    private String licenseNumber;
    private int experienceYears;
    private String status;
    private LocalDateTime createdDate;
    private LocalDateTime updatedDate;

    // Related object
    private User user;

    // Display fields
    private String username;
    private String fullName;
    private String phoneNumber;
    private String email;

    // Rating fields
    private double averageRating;
    private int totalRatings;

    // Constructors
    public Driver() {
        this.driverId = UUID.randomUUID();
        this.status = "ACTIVE";
        this.experienceYears = 0;
        this.createdDate = LocalDateTime.now();
        this.updatedDate = LocalDateTime.now();
    }

    public Driver(UUID userId, String licenseNumber, int experienceYears) {
        this();
        this.userId = userId;
        this.licenseNumber = licenseNumber;
        this.experienceYears = experienceYears;
    }

    // Getters and Setters
    public UUID getDriverId() {
        return driverId;
    }

    public void setDriverId(UUID driverId) {
        this.driverId = driverId;
    }

    public UUID getUserId() {
        return userId;
    }

    public void setUserId(UUID userId) {
        this.userId = userId;
    }

    public String getLicenseNumber() {
        return licenseNumber;
    }

    public void setLicenseNumber(String licenseNumber) {
        this.licenseNumber = licenseNumber;
    }

    public int getExperienceYears() {
        return experienceYears;
    }

    public void setExperienceYears(int experienceYears) {
        this.experienceYears = experienceYears;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
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

    // Related object
    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    // Display fields
    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    // Rating fields
    public double getAverageRating() {
        return averageRating;
    }

    public void setAverageRating(double averageRating) {
        this.averageRating = averageRating;
    }

    public int getTotalRatings() {
        return totalRatings;
    }

    public void setTotalRatings(int totalRatings) {
        this.totalRatings = totalRatings;
    }

    @Override
    public String toString() {
        return "Driver{" +
                "driverId=" + driverId +
                ", userId=" + userId +
                ", licenseNumber='" + licenseNumber + '\'' +
                ", experienceYears=" + experienceYears +
                ", status='" + status + '\'' +
                ", fullName='" + fullName + '\'' +
                '}';
    }
}
