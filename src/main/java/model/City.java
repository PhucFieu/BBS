package model;

import java.time.LocalDateTime;
import java.util.UUID;

public class City {
    private UUID cityId;
    private String cityName;
    private int cityNumber; // Số thứ tự từ 1 đến n
    private String status;
    private LocalDateTime createdDate;
    private LocalDateTime updatedDate;

    // Constructors
    public City() {
        this.cityId = UUID.randomUUID();
        this.status = "ACTIVE";
        this.createdDate = LocalDateTime.now();
        this.updatedDate = LocalDateTime.now();
    }

    public City(String cityName, int cityNumber) {
        this();
        this.cityName = cityName;
        this.cityNumber = cityNumber;
    }

    // Getters and Setters
    public UUID getCityId() {
        return cityId;
    }

    public void setCityId(UUID cityId) {
        this.cityId = cityId;
    }

    public String getCityName() {
        return cityName;
    }

    public void setCityName(String cityName) {
        this.cityName = cityName;
    }

    public int getCityNumber() {
        return cityNumber;
    }

    public void setCityNumber(int cityNumber) {
        this.cityNumber = cityNumber;
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
        return "City{" +
                "cityId=" + cityId +
                ", cityName='" + cityName + '\'' +
                ", cityNumber=" + cityNumber +
                ", status='" + status + '\'' +
                '}';
    }
}

