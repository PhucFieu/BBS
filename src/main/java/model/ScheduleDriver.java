package model;

import java.time.LocalDateTime;
import java.util.UUID;

public class ScheduleDriver {
    private UUID scheduleDriverId;
    private UUID scheduleId;
    private UUID driverId;
    private LocalDateTime assignedDate;

    // Related objects
    private Schedule schedule;
    private Driver driver;

    // Display fields
    private String driverName;
    private String licenseNumber;
    private String busNumber;
    private String routeName;

    // Constructors
    public ScheduleDriver() {
        this.scheduleDriverId = UUID.randomUUID();
        this.assignedDate = LocalDateTime.now();
    }

    public ScheduleDriver(UUID scheduleId, UUID driverId) {
        this();
        this.scheduleId = scheduleId;
        this.driverId = driverId;
    }

    // Getters and Setters
    public UUID getScheduleDriverId() {
        return scheduleDriverId;
    }

    public void setScheduleDriverId(UUID scheduleDriverId) {
        this.scheduleDriverId = scheduleDriverId;
    }

    public UUID getScheduleId() {
        return scheduleId;
    }

    public void setScheduleId(UUID scheduleId) {
        this.scheduleId = scheduleId;
    }

    public UUID getDriverId() {
        return driverId;
    }

    public void setDriverId(UUID driverId) {
        this.driverId = driverId;
    }

    public LocalDateTime getAssignedDate() {
        return assignedDate;
    }

    public void setAssignedDate(LocalDateTime assignedDate) {
        this.assignedDate = assignedDate;
    }

    // Related objects
    public Schedule getSchedule() {
        return schedule;
    }

    public void setSchedule(Schedule schedule) {
        this.schedule = schedule;
    }

    public Driver getDriver() {
        return driver;
    }

    public void setDriver(Driver driver) {
        this.driver = driver;
    }

    // Display fields
    public String getDriverName() {
        return driverName;
    }

    public void setDriverName(String driverName) {
        this.driverName = driverName;
    }

    public String getLicenseNumber() {
        return licenseNumber;
    }

    public void setLicenseNumber(String licenseNumber) {
        this.licenseNumber = licenseNumber;
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
        return "ScheduleDriver{" +
                "scheduleDriverId=" + scheduleDriverId +
                ", scheduleId=" + scheduleId +
                ", driverId=" + driverId +
                ", assignedDate=" + assignedDate +
                ", driverName='" + driverName + '\'' +
                '}';
    }
}
