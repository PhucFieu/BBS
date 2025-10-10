package model;

import java.util.UUID;

public class TicketGroup {
    private UUID groupId;
    private UUID ticketId;

    // Related object
    private Tickets ticket;

    // Display fields
    private String ticketNumber;
    private String routeName;
    private String departureCity;
    private String destinationCity;
    private String userName;

    // Constructors
    public TicketGroup() {
        this.groupId = UUID.randomUUID();
    }

    public TicketGroup(UUID ticketId) {
        this();
        this.ticketId = ticketId;
    }

    // Getters and Setters
    public UUID getGroupId() {
        return groupId;
    }

    public void setGroupId(UUID groupId) {
        this.groupId = groupId;
    }

    public UUID getTicketId() {
        return ticketId;
    }

    public void setTicketId(UUID ticketId) {
        this.ticketId = ticketId;
    }

    // Related object
    public Tickets getTicket() {
        return ticket;
    }

    public void setTicket(Tickets ticket) {
        this.ticket = ticket;
    }

    // Display fields
    public String getTicketNumber() {
        return ticketNumber;
    }

    public void setTicketNumber(String ticketNumber) {
        this.ticketNumber = ticketNumber;
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

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    @Override
    public String toString() {
        return "TicketGroup{" +
                "groupId=" + groupId +
                ", ticketId=" + ticketId +
                ", ticketNumber='" + ticketNumber + '\'' +
                '}';
    }
}
