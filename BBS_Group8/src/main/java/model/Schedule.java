/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

/**
 *
 * @author PhúcNH CE190359
 */
public class Schedule {
     private int scheduleId;
    private int routeId;
    private int busId;
    private LocalDate departureDate;
    private LocalTime departureTime;
    private LocalTime estimatedArrivalTime;
    private int availableSeats;
    private String status;
    private LocalDateTime createdDate;
    private LocalDateTime updatedDate;


    public Schedule() {}

    public Schedule(int scheduleId, int routeId, int busId, LocalDate departureDate,
                    LocalTime departureTime, LocalTime estimatedArrivalTime,
                    int availableSeats, String status,
                    LocalDateTime createdDate, LocalDateTime updatedDate) {
        this.scheduleId = scheduleId;
        this.routeId = routeId;
        this.busId = busId;
        this.departureDate = departureDate;
        this.departureTime = departureTime;
        this.estimatedArrivalTime = estimatedArrivalTime;
        this.availableSeats = availableSeats;
        this.status = status;
        this.createdDate = createdDate;
        this.updatedDate = updatedDate;
    }

    // ✅ Getter & Setter
    public int getScheduleId() { return scheduleId; }
    public void setScheduleId(int scheduleId) { this.scheduleId = scheduleId; }

    public int getRouteId() { return routeId; }
    public void setRouteId(int routeId) { this.routeId = routeId; }

    public int getBusId() { return busId; }
    public void setBusId(int busId) { this.busId = busId; }

    public LocalDate getDepartureDate() { return departureDate; }
    public void setDepartureDate(LocalDate departureDate) { this.departureDate = departureDate; }

    public LocalTime getDepartureTime() { return departureTime; }
    public void setDepartureTime(LocalTime departureTime) { this.departureTime = departureTime; }

    public LocalTime getEstimatedArrivalTime() { return estimatedArrivalTime; }
    public void setEstimatedArrivalTime(LocalTime estimatedArrivalTime) { this.estimatedArrivalTime = estimatedArrivalTime; }

    public int getAvailableSeats() { return availableSeats; }
    public void setAvailableSeats(int availableSeats) { this.availableSeats = availableSeats; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public LocalDateTime getCreatedDate() { return createdDate; }
    public void setCreatedDate(LocalDateTime createdDate) { this.createdDate = createdDate; }

    public LocalDateTime getUpdatedDate() { return updatedDate; }
    public void setUpdatedDate(LocalDateTime updatedDate) { this.updatedDate = updatedDate; }

    // ✅ Override toString()
    @Override
    public String toString() {
        return "Schedule{" +
                "scheduleId=" + scheduleId +
                ", routeId=" + routeId +
                ", busId=" + busId +
                ", departureDate=" + departureDate +
                ", departureTime=" + departureTime +
                ", estimatedArrivalTime=" + estimatedArrivalTime +
                ", availableSeats=" + availableSeats +
                ", status='" + status + '\'' +
                ", createdDate=" + createdDate +
                ", updatedDate=" + updatedDate +
                '}';
    }
}

