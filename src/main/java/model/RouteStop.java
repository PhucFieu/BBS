package model;

import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.UUID;

public class RouteStop {
    private UUID routeStopId;
    private UUID routeId;
    private UUID stationId;
    private int stopOrder;
    private LocalTime arrivalTime;
    private int stopDurationMinutes;
    private LocalDateTime createdDate;
    private LocalDateTime updatedDate;

    // Related objects
    private Routes route;
    private Station station;

    // Display fields
    private String stationName;
    private String city;
    private String address;

    // Constructors
    public RouteStop() {
        this.routeStopId = UUID.randomUUID();
        this.stopDurationMinutes = 0;
        this.createdDate = LocalDateTime.now();
        this.updatedDate = LocalDateTime.now();
    }

    public RouteStop(UUID routeId, UUID stationId, int stopOrder, LocalTime arrivalTime) {
        this();
        this.routeId = routeId;
        this.stationId = stationId;
        this.stopOrder = stopOrder;
        this.arrivalTime = arrivalTime;
    }

    // Getters and Setters
    public UUID getRouteStopId() {
        return routeStopId;
    }

    public void setRouteStopId(UUID routeStopId) {
        this.routeStopId = routeStopId;
    }

    public UUID getRouteId() {
        return routeId;
    }

    public void setRouteId(UUID routeId) {
        this.routeId = routeId;
    }

    public UUID getStationId() {
        return stationId;
    }

    public void setStationId(UUID stationId) {
        this.stationId = stationId;
    }

    public int getStopOrder() {
        return stopOrder;
    }

    public void setStopOrder(int stopOrder) {
        this.stopOrder = stopOrder;
    }

    public LocalTime getArrivalTime() {
        return arrivalTime;
    }

    public void setArrivalTime(LocalTime arrivalTime) {
        this.arrivalTime = arrivalTime;
    }

    public int getStopDurationMinutes() {
        return stopDurationMinutes;
    }

    public void setStopDurationMinutes(int stopDurationMinutes) {
        this.stopDurationMinutes = stopDurationMinutes;
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

    // Related objects
    public Routes getRoute() {
        return route;
    }

    public void setRoute(Routes route) {
        this.route = route;
    }

    public Station getStation() {
        return station;
    }

    public void setStation(Station station) {
        this.station = station;
    }

    // Display fields
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

    @Override
    public String toString() {
        return "RouteStop{" +
                "routeStopId=" + routeStopId +
                ", routeId=" + routeId +
                ", stationId=" + stationId +
                ", stopOrder=" + stopOrder +
                ", arrivalTime=" + arrivalTime +
                ", stopDurationMinutes=" + stopDurationMinutes +
                ", stationName='" + stationName + '\'' +
                '}';
    }
}
