package model;

import java.time.LocalDateTime;
import java.util.UUID;

public class RouteStation {
    private UUID routeStationId;
    private UUID routeId;
    private UUID stationId;
    private int sequenceNumber;
    private LocalDateTime createdDate;
    private LocalDateTime updatedDate;

    // Related objects
    private Station station;
    private Routes route;

    // Constructors
    public RouteStation() {
        this.routeStationId = UUID.randomUUID();
        this.createdDate = LocalDateTime.now();
        this.updatedDate = LocalDateTime.now();
    }

    public RouteStation(UUID routeId, UUID stationId, int sequenceNumber) {
        this();
        this.routeId = routeId;
        this.stationId = stationId;
        this.sequenceNumber = sequenceNumber;
    }

    // Getters and Setters
    public UUID getRouteStationId() {
        return routeStationId;
    }

    public void setRouteStationId(UUID routeStationId) {
        this.routeStationId = routeStationId;
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

    public int getSequenceNumber() {
        return sequenceNumber;
    }

    public void setSequenceNumber(int sequenceNumber) {
        this.sequenceNumber = sequenceNumber;
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

    public Station getStation() {
        return station;
    }

    public void setStation(Station station) {
        this.station = station;
    }

    public Routes getRoute() {
        return route;
    }

    public void setRoute(Routes route) {
        this.route = route;
    }

    @Override
    public String toString() {
        return "RouteStation{" +
                "routeStationId=" + routeStationId +
                ", routeId=" + routeId +
                ", stationId=" + stationId +
                ", sequenceNumber=" + sequenceNumber +
                '}';
    }
}

