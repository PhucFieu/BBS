package com.mycompany.bbs.model_group8;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;

public class Ticket {

    private int ticketId;
    private String ticketNumber;
    private int routeId;
    private String routeName;
    private String departureCity;
    private String destinationCity;
    private int busId;
    private String busNumber;
    private String driverName;
    private int passengerId;
    private String passengerName;
    private int seatNumber;
    private LocalDate departureDate;
    private LocalTime departureTime;
    private BigDecimal ticketPrice;
    private LocalDateTime bookingDate;
    private String status;
    private String paymentStatus;
    private LocalDateTime createdDate;
    private LocalDateTime updatedDate;

    // Additional fields for display purposes
    private Route route;
    private Bus bus;
    private Passenger passenger;

    // User information fields
    private String userName;
    private String username;
    private String userEmail;

    // Constructors
    public Ticket() {}

    public Ticket(
        String ticketNumber,
        int routeId,
        int busId,
        int passengerId,
        int seatNumber,
        LocalDate departureDate,
        LocalTime departureTime,
        BigDecimal ticketPrice
    ) {
        this.ticketNumber = ticketNumber;
        this.routeId = routeId;
        this.busId = busId;
        this.passengerId = passengerId;
        this.seatNumber = seatNumber;
        this.departureDate = departureDate;
        this.departureTime = departureTime;
        this.ticketPrice = ticketPrice;
        this.status = "CONFIRMED";
        this.paymentStatus = "PENDING";
    }

    public Ticket(
        String ticketNumber,
        int routeId,
        String routeName,
        String departureCity,
        String destinationCity,
        int busId,
        String busNumber,
        String driverName,
        int passengerId,
        String passengerName,
        int seatNumber,
        LocalDate departureDate,
        LocalTime departureTime,
        BigDecimal ticketPrice
    ) {
        this.ticketNumber = ticketNumber;
        this.routeId = routeId;
        this.routeName = routeName;
        this.departureCity = departureCity;
        this.destinationCity = destinationCity;
        this.busId = busId;
        this.busNumber = busNumber;
        this.driverName = driverName;
        this.passengerId = passengerId;
        this.passengerName = passengerName;
        this.seatNumber = seatNumber;
        this.departureDate = departureDate;
        this.departureTime = departureTime;
        this.ticketPrice = ticketPrice;
        this.status = "CONFIRMED";
        this.paymentStatus = "PENDING";
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
        if (bookingDate == null) return "";
        return bookingDate.format(DateTimeFormatter.ofPattern("MMM dd, yyyy"));
    }

    // Getters and Setters
    public int getTicketId() {
        return ticketId;
    }

    public void setTicketId(int ticketId) {
        this.ticketId = ticketId;
    }

    public String getTicketNumber() {
        return ticketNumber;
    }

    public void setTicketNumber(String ticketNumber) {
        this.ticketNumber = ticketNumber;
    }

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

    public int getBusId() {
        return busId;
    }

    public void setBusId(int busId) {
        this.busId = busId;
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

    public int getPassengerId() {
        return passengerId;
    }

    public void setPassengerId(int passengerId) {
        this.passengerId = passengerId;
    }

    public String getPassengerName() {
        return passengerName;
    }

    public void setPassengerName(String passengerName) {
        this.passengerName = passengerName;
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
    public Route getRoute() {
        return route;
    }

    public void setRoute(Route route) {
        this.route = route;
    }

    public Bus getBus() {
        return bus;
    }

    public void setBus(Bus bus) {
        this.bus = bus;
    }

    public Passenger getPassenger() {
        return passenger;
    }

    public void setPassenger(Passenger passenger) {
        this.passenger = passenger;
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
        return (
            "Ticket{" +
            "ticketId=" +
            ticketId +
            ", ticketNumber='" +
            ticketNumber +
            '\'' +
            ", routeId=" +
            routeId +
            ", routeName='" +
            routeName +
            '\'' +
            ", departureCity='" +
            departureCity +
            '\'' +
            ", destinationCity='" +
            destinationCity +
            '\'' +
            ", busId=" +
            busId +
            ", busNumber='" +
            busNumber +
            '\'' +
            ", driverName='" +
            driverName +
            '\'' +
            ", passengerId=" +
            passengerId +
            ", passengerName='" +
            passengerName +
            '\'' +
            ", seatNumber=" +
            seatNumber +
            ", departureDate=" +
            departureDate +
            ", departureTime=" +
            departureTime +
            ", ticketPrice=" +
            ticketPrice +
            ", status='" +
            status +
            '\'' +
            ", paymentStatus='" +
            paymentStatus +
            '\'' +
            '}'
        );
    }
}
