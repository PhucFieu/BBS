/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Nguyen Phat Tai
 */
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

public class Routes {
    private UUID routeId; // route_id
    private String routeName; // route_name
    private String departureCity; // departure_city
    private String destinationCity; // destination_city
    private BigDecimal distance; // distance
    private int durationHours; // duration_hours
    private BigDecimal basePrice; // base_price
    private String status; // status
    private LocalDateTime createdDate;
    private LocalDateTime updatedDate;

    // Related schedules for search results
    private List<Schedule> schedules;

    // Constructor mặc định
    public Routes() {
        this.routeId = UUID.randomUUID();
        this.status = "ACTIVE";
        this.createdDate = LocalDateTime.now();
        this.updatedDate = LocalDateTime.now();
    }

    // Constructor với 6 tham số
    public Routes(String routeName, String departureCity, String destinationCity,
            BigDecimal distance, int durationHours, BigDecimal basePrice) {
        this.routeId = UUID.randomUUID();
        this.routeName = routeName;
        this.departureCity = departureCity;
        this.destinationCity = destinationCity;
        this.distance = distance;
        this.durationHours = durationHours;
        this.basePrice = basePrice;
        this.status = "ACTIVE";
        this.createdDate = LocalDateTime.now();
        this.updatedDate = LocalDateTime.now();
    }

    // Constructor đầy đủ
    public Routes(String routeName, String departureCity, String destinationCity,
            BigDecimal distance, int durationHours, BigDecimal basePrice,
            String status, LocalDateTime createdDate, LocalDateTime updatedDate) {
        this.routeId = UUID.randomUUID();
        this.routeName = routeName;
        this.departureCity = departureCity;
        this.destinationCity = destinationCity;
        this.distance = distance;
        this.durationHours = durationHours;
        this.basePrice = basePrice;
        this.status = status;
        this.createdDate = createdDate;
        this.updatedDate = updatedDate;
    }

    // Getters và Setters
    public UUID getRouteId() {
        return routeId;
    }

    public void setRouteId(UUID routeId) {
        this.routeId = routeId;
    }

    public String getRouteName() {
        return routeName;
    }

    public void setRouteName(String routeName) {
        this.routeName = routeName;
    }

    public String getDepartureCity() {
        return departureCity;
    }

    public void setDepartureCity(String departureCity) {
        this.departureCity = departureCity;
    }

    public String getDestinationCity() {
        return destinationCity;
    }

    public void setDestinationCity(String destinationCity) {
        this.destinationCity = destinationCity;
    }

    public BigDecimal getDistance() {
        return distance;
    }

    public void setDistance(BigDecimal distance) {
        this.distance = distance;
    }

    public int getDurationHours() {
        return durationHours;
    }

    public void setDurationHours(int durationHours) {
        this.durationHours = durationHours;
    }

    public BigDecimal getBasePrice() {
        return basePrice;
    }

    public void setBasePrice(BigDecimal basePrice) {
        this.basePrice = basePrice;
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

    public List<Schedule> getSchedules() {
        return schedules;
    }

    public void setSchedules(List<Schedule> schedules) {
        this.schedules = schedules;
    }

    // Optional: toString
    @Override
    public String toString() {
        return "Routes{" +
                "routeId=" + routeId +
                ", routeName='" + routeName + '\'' +
                ", departureCity='" + departureCity + '\'' +
                ", destinationCity='" + destinationCity + '\'' +
                ", distance=" + distance +
                ", durationHours=" + durationHours +
                ", basePrice=" + basePrice +
                ", status='" + status + '\'' +
                ", createdDate=" + createdDate +
                ", updatedDate=" + updatedDate +
                '}';
    }
}
