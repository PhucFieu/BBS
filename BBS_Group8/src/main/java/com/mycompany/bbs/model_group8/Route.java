package com.mycompany.bbs.model_group8;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Route {
    public static final String ACTIVE = "ACTIVE";
    public static final String INACTIVE = "INACTIVE";

    private int routeId;
    private String routeName;
    private String departureCity;
    private String destinationCity;
    private BigDecimal distance;
    private int durationHours;
    private BigDecimal price;
    private String status;
    private LocalDateTime createdDate;
    private LocalDateTime updatedDate;

    // Constructors
    public Route() {
    }

    public Route(String routeName, String departureCity, String destinationCity,
            BigDecimal distance, int durationHours, BigDecimal price) {
        this.routeName = routeName;
        this.departureCity = departureCity;
        this.destinationCity = destinationCity;
        this.distance = distance;
        this.durationHours = durationHours;
        this.price = price;
        this.status = ACTIVE;
    }

    // Getters and Setters
    public int getRouteId() {
        return routeId;
    }

    public void setRouteId(int routeId) {
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

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
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
        return "Route{" +
                "routeId=" + routeId +
                ", routeName='" + routeName + '\'' +
                ", departureCity='" + departureCity + '\'' +
                ", destinationCity='" + destinationCity + '\'' +
                ", distance=" + distance +
                ", durationHours=" + durationHours +
                ", price=" + price +
                ", status='" + status + '\'' +
                '}';
    }
}