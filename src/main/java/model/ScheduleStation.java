package model;

import java.time.LocalDateTime;
import java.util.UUID;

public class ScheduleStation {
    private UUID scheduleStationId;
    private UUID scheduleId;
    private UUID stationId;
    private int sequenceNumber;
    private LocalDateTime createdDate;

    // Related objects
    private Station station;
    private Schedule schedule;

    // Constructors
    public ScheduleStation() {
        this.scheduleStationId = UUID.randomUUID();
        this.createdDate = LocalDateTime.now();
    }

    public ScheduleStation(UUID scheduleId, UUID stationId, int sequenceNumber) {
        this();
        this.scheduleId = scheduleId;
        this.stationId = stationId;
        this.sequenceNumber = sequenceNumber;
    }

    // Getters and Setters
    public UUID getScheduleStationId() {
        return scheduleStationId;
    }

    public void setScheduleStationId(UUID scheduleStationId) {
        this.scheduleStationId = scheduleStationId;
    }

    public UUID getScheduleId() {
        return scheduleId;
    }

    public void setScheduleId(UUID scheduleId) {
        this.scheduleId = scheduleId;
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

    public Station getStation() {
        return station;
    }

    public void setStation(Station station) {
        this.station = station;
    }

    public Schedule getSchedule() {
        return schedule;
    }

    public void setSchedule(Schedule schedule) {
        this.schedule = schedule;
    }

    @Override
    public String toString() {
        return "ScheduleStation{" +
                "scheduleStationId=" + scheduleStationId +
                ", scheduleId=" + scheduleId +
                ", stationId=" + stationId +
                ", sequenceNumber=" + sequenceNumber +
                '}';
    }
}

