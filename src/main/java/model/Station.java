package model;

import java.time.LocalDateTime;
import java.util.UUID;

public class Station {
    private UUID stationId;
    private String stationName;
    private UUID cityId; // Reference to City by ID
    private String city; // Kept for backward compatibility, deprecated
    private String address;
    private String status;
    private LocalDateTime createdDate;
    private LocalDateTime updatedDate;
    
    // Related City object
    private City cityObj;

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
        this.city = city; // Deprecated, use cityId instead
        this.address = address;
    }
    
    public Station(String stationName, UUID cityId, String address) {
        this();
        this.stationName = stationName;
        this.cityId = cityId;
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

    public UUID getCityId() {
        return cityId;
    }

    public void setCityId(UUID cityId) {
        this.cityId = cityId;
    }

    /**
     * @deprecated Use getCityId() and getCityObj() instead
     */
    @Deprecated
    public String getCity() {
        return city;
    }

    /**
     * @deprecated Use setCityId() instead
     */
    @Deprecated
    public void setCity(String city) {
        this.city = city;
    }
    
    public City getCityObj() {
        return cityObj;
    }

    public void setCityObj(City cityObj) {
        this.cityObj = cityObj;
        if (cityObj != null) {
            this.city = cityObj.getCityName(); // Keep backward compatibility
            this.cityId = cityObj.getCityId();
        }
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
