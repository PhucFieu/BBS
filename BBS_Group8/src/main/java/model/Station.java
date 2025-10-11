package model;

import java.time.LocalDateTime;
import java.util.UUID;

public class Station {
    private UUID stationId;
    private String stationName;
    private String city;
    private String address;
    private String status;
    private LocalDateTime createdDate;
    private LocalDateTime updatedDate;

    // Constructors
    public Station() {
        this.stationId = UUID.randomUUID();
        this.status = "ACTIVE";
        this.createdDate = LocalDateTime.now();
        this.updatedDate = LocalDateTime.now();
    }

    public Station(String stationName, String city, String address) {
        this();
        this.stationName = stationName;
        this.city = city;
        this.address = address;
    }

    // Getters and Setters
    public UUID getStationId() {
        return stationId;
    }

    public void setStationId(UUID stationId) {
        this.stationId = stationId;
    }

    public String getStationName() {
        return stationName;
    }

    public void setStationName(String stationName) {
        this.stationName = stationName;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
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
        return "Station{" +
                "stationId=" + stationId +
                ", stationName='" + stationName + '\'' +
                ", city='" + city + '\'' +
                ", address='" + address + '\'' +
                ", status='" + status + '\'' +
                '}';
    }
}
