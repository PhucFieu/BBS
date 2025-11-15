package model;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.UUID;

public class Rating {
    private UUID ratingId;
    private UUID ticketId;
    private UUID userId;
    private UUID driverId;
    private int ratingValue; // 1-5
    private String comments;
    private LocalDateTime createdDate;

    // Related objects
    private Tickets ticket;
    private User user;
    private Driver driver;

    // Display fields
    private String ticketNumber;
    private String userName;
    private String driverName;
    private String routeName;

    // Constructors
    public Rating() {
        this.ratingId = UUID.randomUUID();
        this.createdDate = LocalDateTime.now();
    }

    public Rating(UUID ticketId, UUID userId, UUID driverId, int ratingValue, String comments) {
        this();
        this.ticketId = ticketId;
        this.userId = userId;
        this.driverId = driverId;
        this.ratingValue = ratingValue;
        this.comments = comments;
    }

    // Getters and Setters
    public UUID getRatingId() {
        return ratingId;
    }

    public void setRatingId(UUID ratingId) {
        this.ratingId = ratingId;
    }

    public UUID getTicketId() {
        return ticketId;
    }

    public void setTicketId(UUID ticketId) {
        this.ticketId = ticketId;
    }

    public UUID getUserId() {
        return userId;
    }

    public void setUserId(UUID userId) {
        this.userId = userId;
    }

    public UUID getDriverId() {
        return driverId;
    }

    public void setDriverId(UUID driverId) {
        this.driverId = driverId;
    }

    public int getRatingValue() {
        return ratingValue;
    }

    public void setRatingValue(int ratingValue) {
        if (ratingValue < 1 || ratingValue > 5) {
            throw new IllegalArgumentException("Rating value must be between 1 and 5");
        }
        this.ratingValue = ratingValue;
    }

    public String getComments() {
        return comments;
    }

    public void setComments(String comments) {
        this.comments = comments;
    }

    public LocalDateTime getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(LocalDateTime createdDate) {
        this.createdDate = createdDate;
    }

    public String getFormattedCreatedDate() {
        if (createdDate == null) {
            return "";
        }
        return createdDate.format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
    }

    // Related objects
    public Tickets getTicket() {
        return ticket;
    }

    public void setTicket(Tickets ticket) {
        this.ticket = ticket;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Driver getDriver() {
        return driver;
    }

    public void setDriver(Driver driver) {
        this.driver = driver;
    }

    // Display fields
    public String getTicketNumber() {
        return ticketNumber;
    }

    public void setTicketNumber(String ticketNumber) {
        this.ticketNumber = ticketNumber;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getDriverName() {
        return driverName;
    }

    public void setDriverName(String driverName) {
        this.driverName = driverName;
    }

    public String getRouteName() {
        return routeName;
    }

    public void setRouteName(String routeName) {
        this.routeName = routeName;
    }

    @Override
    public String toString() {
        return "Rating{" +
                "ratingId=" + ratingId +
                ", ticketId=" + ticketId +
                ", userId=" + userId +
                ", driverId=" + driverId +
                ", ratingValue=" + ratingValue +
                ", comments='" + comments + '\'' +
                ", createdDate=" + createdDate +
                '}';
    }
}
