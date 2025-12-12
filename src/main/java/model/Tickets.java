package model;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.UUID;
import java.util.Date;

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

    // Station information
    private UUID boardingStationId;
    private UUID alightingStationId;
    private String boardingStationName;
    private String alightingStationName;
    private String boardingCity;
    private String alightingCity;
    
    // Walk-in customer information (for tickets created by staff)
    private String customerName;
    private String customerPhone;
    private String customerEmail;
    private String notes;
    private UUID createdByStaffId;
    private LocalDateTime checkedInAt;
    private UUID checkedInByStaffId;

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

    // Station getters and setters
    public UUID getBoardingStationId() {
        return boardingStationId;
    }

    public void setBoardingStationId(UUID boardingStationId) {
        this.boardingStationId = boardingStationId;
    }

    public UUID getAlightingStationId() {
        return alightingStationId;
    }

    public void setAlightingStationId(UUID alightingStationId) {
        this.alightingStationId = alightingStationId;
    }

    public String getBoardingStationName() {
        return boardingStationName;
    }

    public void setBoardingStationName(String boardingStationName) {
        this.boardingStationName = boardingStationName;
    }

    public String getAlightingStationName() {
        return alightingStationName;
    }

    public void setAlightingStationName(String alightingStationName) {
        this.alightingStationName = alightingStationName;
    }

    public String getBoardingCity() {
        return boardingCity;
    }

    public void setBoardingCity(String boardingCity) {
        this.boardingCity = boardingCity;
    }

    public String getAlightingCity() {
        return alightingCity;
    }

    public void setAlightingCity(String alightingCity) {
        this.alightingCity = alightingCity;
    }

    /**
     * Check if this ticket can be rated
     * Can rate if: COMPLETED and PAID
     */
    public boolean getCanRate() {
        return "COMPLETED".equals(status) && "PAID".equals(paymentStatus);
    }

    // Walk-in customer getters and setters
    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getCustomerPhone() {
        return customerPhone;
    }

    public void setCustomerPhone(String customerPhone) {
        this.customerPhone = customerPhone;
    }

    public String getCustomerEmail() {
        return customerEmail;
    }

    public void setCustomerEmail(String customerEmail) {
        this.customerEmail = customerEmail;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public UUID getCreatedByStaffId() {
        return createdByStaffId;
    }

    public void setCreatedByStaffId(UUID createdByStaffId) {
        this.createdByStaffId = createdByStaffId;
    }

    public LocalDateTime getCheckedInAt() {
        return checkedInAt;
    }

    public void setCheckedInAt(LocalDateTime checkedInAt) {
        this.checkedInAt = checkedInAt;
    }

    /**
     * Helper for JSP formatting; converts LocalDateTime to java.util.Date.
     */
    public Date getCheckedInAtDate() {
        return checkedInAt == null
                ? null
                : Date.from(checkedInAt.atZone(ZoneId.systemDefault()).toInstant());
    }

    public UUID getCheckedInByStaffId() {
        return checkedInByStaffId;
    }

    public void setCheckedInByStaffId(UUID checkedInByStaffId) {
        this.checkedInByStaffId = checkedInByStaffId;
    }

    /**
     * Check if this ticket is checked in
     */
    public boolean isCheckedIn() {
        return checkedInAt != null;
    }

    /**
     * Get display name for customer (use customerName if available, otherwise userName)
     */
    public String getDisplayCustomerName() {
        if (customerName != null && !customerName.trim().isEmpty()) {
            return customerName;
        }
        return userName;
    }

    /**
     * Check if this is a walk-in ticket (created by staff for a customer)
     */
    public boolean isWalkInTicket() {
        return createdByStaffId != null;
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
