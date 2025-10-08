package model;

import java.time.LocalDateTime;

public class Bus {
    private int busId;
    private String busNumber;
    private String busType;
    private int totalSeats;
    private int availableSeats;
    private String driverId;
    private String licensePlate;
    private String status;
    private LocalDateTime createdDate;
    private LocalDateTime updatedDate;

    // Constructors
    public Bus() {
    }

    public Bus(String busNumber, String busType, int totalSeats, String driverName, String licensePlate) {
        this.busNumber = busNumber;
        this.busType = busType;
        this.totalSeats = totalSeats;
        this.availableSeats = totalSeats;
        this.driverId = driverName;
        this.licensePlate = licensePlate;
        this.status = "ACTIVE";
    }

    // Getters and Setters
    public int getBusId() {
        return busId;
    }

    public void setBusId(int busId) {
        this.busId = busId;
    }

    public String getBusNumber() {
        return busNumber;
    }

    public void setBusNumber(String busNumber) {
        this.busNumber = busNumber;
    }

    public String getBusType() {
        return busType;
    }

    public void setBusType(String busType) {
        this.busType = busType;
    }

    public int getTotalSeats() {
        return totalSeats;
    }

    public void setTotalSeats(int totalSeats) {
        this.totalSeats = totalSeats;
    }

    public int getAvailableSeats() {
        return availableSeats;
    }

    public void setAvailableSeats(int availableSeats) {
        this.availableSeats = availableSeats;
    }

    public String getDriverId() {
        return driverId;
    }

    public void setDriverId(String driverID) {
        this.driverId = driverId;
    }

    public String getLicensePlate() {
        return licensePlate;
    }

    public void setLicensePlate(String licensePlate) {
        this.licensePlate = licensePlate;
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

    @Override
    public String toString() {
        return "Bus{" +
                "busId=" + busId +
                ", busNumber='" + busNumber + '\'' +
                ", busType='" + busType + '\'' +
                ", totalSeats=" + totalSeats +
                ", availableSeats=" + availableSeats +
                ", driverName='" + driverId + '\'' +
                ", licensePlate='" + licensePlate + '\'' +
                ", status='" + status + '\'' +
                '}';
    }
} 