package model;

import java.time.LocalDateTime;
import java.util.UUID;

public class Bus {
    private UUID busId;
    private String busNumber;
    private String busType;
    private int totalSeats;
    private String licensePlate;
    private String status;
    private LocalDateTime createdDate;
    private LocalDateTime updatedDate;

    // Constructors
    public Bus() {
        this.busId = UUID.randomUUID();
        this.status = "ACTIVE";
        this.createdDate = LocalDateTime.now();
        this.updatedDate = LocalDateTime.now();
    }

    public Bus(String busNumber, String busType, int totalSeats, String licensePlate) {
        this();
        this.busNumber = busNumber;
        this.busType = busType;
        this.totalSeats = totalSeats;
        this.licensePlate = licensePlate;
    }

    // Getters and Setters
    public UUID getBusId() {
        return busId;
    }

    public void setBusId(UUID busId) {
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
                ", licensePlate='" + licensePlate + '\'' +
                ", status='" + status + '\'' +
                '}';
    }
}