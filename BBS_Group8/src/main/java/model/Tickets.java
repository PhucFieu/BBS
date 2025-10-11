package model;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.UUID;

public class Tickets {

    private UUID ticketId;
    private String ticketNumber;
    private UUID scheduleId;
    private UUID userId;
    private int seatNumber;
    private BigDecimal ticketPrice;
    private LocalDateTime bookingDate;
    private String status;
    private String paymentStatus;
    private LocalDateTime createdDate;
    private LocalDateTime updatedDate;

    // Additional fields for display purposes (for backward compatibility)
    private Routes route;
    private Bus bus;
    private User user;

    // Display fields (populated from joins)
    private String routeName;
    private String departureCity;
    private String destinationCity;
    private String busNumber;
    private String driverName;
    private String userName;
    private String username;
    private String userEmail;
    private LocalDate departureDate;
    private LocalTime departureTime;

    // Constructors
    public Tickets() {
        this.ticketId = UUID.randomUUID();
        this.status = "CONFIRMED";
        this.paymentStatus = "PENDING";
        this.bookingDate = LocalDateTime.now();
        this.createdDate = LocalDateTime.now();
        this.updatedDate = LocalDateTime.now();
    }

    public Tickets(
            String ticketNumber,
            UUID scheduleId,
            UUID userId,
            int seatNumber,
            BigDecimal ticketPrice) {
        this();
        this.ticketNumber = ticketNumber;
        this.scheduleId = scheduleId;
        this.userId = userId;
        this.seatNumber = seatNumber;
        this.ticketPrice = ticketPrice;
    }

    public java.sql.Date getDepartureDateSql() {
        return departureDate != null
                ? java.sql.Date.valueOf(departureDate)
                : null;
    }

    public java.sql.Time getDepartureTimeSql() {
        return departureTime != null
                ? java.sql.Time.valueOf(departureTime)
                : null;
    }

    public String getBookingDateStr() {
        if (bookingDate == null)
            return "";
        return bookingDate.format(DateTimeFormatter.ofPattern("MMM dd, yyyy"));
    }

    // Getters and Setters
    public UUID getTicketId() {
        return ticketId;
    }

    public void setTicketId(UUID ticketId) {
        this.ticketId = ticketId;
    }

    public String getTicketNumber() {
        return ticketNumber;
    }

    public void setTicketNumber(String ticketNumber) {
        this.ticketNumber = ticketNumber;
    }

    public UUID getScheduleId() {
        return scheduleId;
    }

    public void setScheduleId(UUID scheduleId) {
        this.scheduleId = scheduleId;
    }

    public UUID getUserId() {
        return userId;
    }

    public void setUserId(UUID userId) {
        this.userId = userId;
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

    public String getBusNumber() {
        return busNumber;
    }

    public void setBusNumber(String busNumber) {
        this.busNumber = busNumber;
    }

    public String getDriverName() {
        return driverName;
    }

    public void setDriverName(String driverName) {
        this.driverName = driverName;
    }

    public int getSeatNumber() {
        return seatNumber;
    }

    public void setSeatNumber(int seatNumber) {
        this.seatNumber = seatNumber;
    }

    public LocalDate getDepartureDate() {
        return departureDate;
    }

    public void setDepartureDate(LocalDate departureDate) {
        this.departureDate = departureDate;
    }

    public LocalTime getDepartureTime() {
        return departureTime;
    }

    public void setDepartureTime(LocalTime departureTime) {
        this.departureTime = departureTime;
    }

    public BigDecimal getTicketPrice() {
        return ticketPrice;
    }

    public void setTicketPrice(BigDecimal ticketPrice) {
        this.ticketPrice = ticketPrice;
    }

    public LocalDateTime getBookingDate() {
        return bookingDate;
    }

    public void setBookingDate(LocalDateTime bookingDate) {
        this.bookingDate = bookingDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
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

    // Additional getters and setters for related objects
    public Routes getRoute() {
        return route;
    }

    public void setRoute(Routes route) {
        this.route = route;
    }

    public Bus getBus() {
        return bus;
    }

    public void setBus(Bus bus) {
        this.bus = bus;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    // User information getters and setters
    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getUserEmail() {
        return userEmail;
    }

    public void setUserEmail(String userEmail) {
        this.userEmail = userEmail;
    }

    @Override
    public String toString() {
        return ("Ticket{" +
                "ticketId=" +
                ticketId +
                ", ticketNumber='" +
                ticketNumber +
                '\'' +
                ", scheduleId=" +
                scheduleId +
                ", userId=" +
                userId +
                ", seatNumber=" +
                seatNumber +
                ", ticketPrice=" +
                ticketPrice +
                ", status='" +
                status +
                '\'' +
                ", paymentStatus='" +
                paymentStatus +
                '\'' +
                '}');
    }
}
