package com.mycompany.bbs.model_group8;

import java.time.LocalDate;
import java.time.LocalDateTime;

public class Passenger {
    private int passengerId;
    private String fullName;
    private String phoneNumber;
    private String email;
    private String idCard;
    private String address;
    private LocalDate dateOfBirth;
    private String gender;
    private String status;
    private Integer userId; // Foreign key to Users table
    private LocalDateTime createdDate;
    private LocalDateTime updatedDate;

    // Constructors
    public Passenger() {
    }

    public Passenger(String fullName, String phoneNumber, String email, String idCard,
            String address, LocalDate dateOfBirth, String gender) {
        this.fullName = fullName;
        this.phoneNumber = phoneNumber;
        this.email = email;
        this.idCard = idCard;
        this.address = address;
        this.dateOfBirth = dateOfBirth;
        this.gender = gender;
        this.status = "ACTIVE";
        this.createdDate = LocalDateTime.now();
        this.updatedDate = LocalDateTime.now();
    }

    public java.sql.Date getDateOfBirthSql() {
        return dateOfBirth != null ? java.sql.Date.valueOf(dateOfBirth) : null;
    }

    public void setDateOfBirthSql(java.sql.Date sqlDate) {
        this.dateOfBirth = sqlDate != null ? sqlDate.toLocalDate() : null;
        this.updatedDate = LocalDateTime.now();
    }

    // Getters and Setters
    public int getPassengerId() {
        return passengerId;
    }

    public void setPassengerId(int passengerId) {
        this.passengerId = passengerId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
        this.updatedDate = LocalDateTime.now();
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
        this.updatedDate = LocalDateTime.now();
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
        this.updatedDate = LocalDateTime.now();
    }

    public String getIdCard() {
        return idCard;
    }

    public void setIdCard(String idCard) {
        this.idCard = idCard;
        this.updatedDate = LocalDateTime.now();
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
        this.updatedDate = LocalDateTime.now();
    }

    public LocalDate getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(LocalDate dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
        this.updatedDate = LocalDateTime.now();
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
        this.updatedDate = LocalDateTime.now();
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
        this.updatedDate = LocalDateTime.now();
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
        this.updatedDate = LocalDateTime.now();
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
        return "Passenger{" +
                "passengerId=" + passengerId +
                ", fullName='" + fullName + '\'' +
                ", phoneNumber='" + phoneNumber + '\'' +
                ", email='" + email + '\'' +
                ", idCard='" + idCard + '\'' +
                ", address='" + address + '\'' +
                ", dateOfBirth=" + dateOfBirth +
                ", gender='" + gender + '\'' +
                ", status='" + status + '\'' +
                ", createdDate=" + createdDate +
                ", updatedDate=" + updatedDate +
                '}';
    }
}