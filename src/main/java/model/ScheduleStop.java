package model;

import java.time.LocalTime;
import java.util.UUID;
/**
 *
 * @author PhúcNH CE190359
 */
public class ScheduleStop {
    private UUID scheduleStopId;
    private UUID scheduleId;
    private UUID stationId;
    private int stopOrder;
    private LocalTime arrivalTime;
    private int stopDurationMinutes;

    // Related objects
    private Schedule schedule;
    private Station station;

    // Display fields
    private String stationName;
    private String city;
    private String address;
    private String busNumber;
    private String routeName;

    // Constructors
    public ScheduleStop() {
        this.scheduleStopId = UUID.randomUUID();
        this.stopDurationMinutes = 0;
    }

    public ScheduleStop(UUID scheduleId, UUID stationId, int stopOrder, LocalTime arrivalTime) {
        this();
        this.scheduleId = scheduleId;
        this.stationId = stationId;
        this.stopOrder = stopOrder;
        this.arrivalTime = arrivalTime;
    }

    // Getters and Setters
    public UUID getScheduleStopId() {
        return scheduleStopId;
    }

    public void setScheduleStopId(UUID scheduleStopId) {
        this.scheduleStopId = scheduleStopId;
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

    // Related objects
    public Schedule getSchedule() {
        return schedule;
    }

    public void setSchedule(Schedule schedule) {
        this.schedule = schedule;
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

    public String getBusNumber() {
        return busNumber;
    }

    public void setBusNumber(String busNumber) {
        this.busNumber = busNumber;
    }

    public String getRouteName() {
        return routeName;
    }

    public void setRouteName(String routeName) {
        this.routeName = routeName;
    }

    @Override
    public String toString() {
        return "ScheduleStop{" +
                "scheduleStopId=" + scheduleStopId +
                ", scheduleId=" + scheduleId +
                ", stationId=" + stationId +
                ", stopOrder=" + stopOrder +
                ", arrivalTime=" + arrivalTime +
                ", stopDurationMinutes=" + stopDurationMinutes +
                ", stationName='" + stationName + '\'' +
                '}';
    }
}
