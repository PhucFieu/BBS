/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Nguyen Phat Tai
 */
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

public class Routes {

    private UUID routeId; // route_id
    private String routeName; // route_name
    private UUID departureCityId; // departure_city_id - reference to City
    private UUID destinationCityId; // destination_city_id - reference to City
    private String departureCity; // departure_city - deprecated, kept for backward compatibility
    private String destinationCity; // destination_city - deprecated, kept for backward compatibility
    private BigDecimal distance; // distance
    private int durationHours; // duration_hours
    private BigDecimal basePrice; // base_price
    private String status; // status
    private LocalDateTime createdDate;
    private LocalDateTime updatedDate;

    // Related schedules for search results
    private List<Schedule> schedules;

    // Related City objects
    private City departureCityObj;
    private City destinationCityObj;

    // Terminal station IDs (default stations for this route)
    private UUID departureStationId;
    private UUID destinationStationId;

    // Related Station objects
    private Station departureStationObj;
    private Station destinationStationObj;

    // Constructor mặc định
    public Routes() {
        this.routeId = UUID.randomUUID();
        this.status = "ACTIVE";
        this.createdDate = LocalDateTime.now();
        this.updatedDate = LocalDateTime.now();
    }

    // Constructor với 6 tham số (deprecated - use constructor with City IDs)
    public Routes(String routeName, String departureCity, String destinationCity,
            BigDecimal distance, int durationHours, BigDecimal basePrice) {
        this.routeId = UUID.randomUUID();
        this.routeName = routeName;
        this.departureCity = departureCity; // Deprecated
        this.destinationCity = destinationCity; // Deprecated
        this.distance = distance;
        this.durationHours = durationHours;
        this.basePrice = basePrice;
        this.status = "ACTIVE";
        this.createdDate = LocalDateTime.now();
        this.updatedDate = LocalDateTime.now();
    }

    // Constructor với City IDs
    public Routes(String routeName, UUID departureCityId, UUID destinationCityId,
            BigDecimal distance, int durationHours, BigDecimal basePrice) {
        this.routeId = UUID.randomUUID();
        this.routeName = routeName;
        this.departureCityId = departureCityId;
        this.destinationCityId = destinationCityId;
        this.distance = distance;
        this.durationHours = durationHours;
        this.basePrice = basePrice;
        this.status = "ACTIVE";
        this.createdDate = LocalDateTime.now();
        this.updatedDate = LocalDateTime.now();
    }

    // Constructor đầy đủ
    public Routes(String routeName, String departureCity, String destinationCity,
            BigDecimal distance, int durationHours, BigDecimal basePrice,
            String status, LocalDateTime createdDate, LocalDateTime updatedDate) {
        this.routeId = UUID.randomUUID();
        this.routeName = routeName;
        this.departureCity = departureCity;
        this.destinationCity = destinationCity;
        this.distance = distance;
        this.durationHours = durationHours;
        this.basePrice = basePrice;
        this.status = status;
        this.createdDate = createdDate;
        this.updatedDate = updatedDate;
    }

    // Getters và Setters
    public UUID getRouteId() {
        return routeId;
    }

    public void setRouteId(UUID routeId) {
        this.routeId = routeId;
    }

    public String getRouteName() {
        return routeName;
    }

    public void setRouteName(String routeName) {
        this.routeName = routeName;
    }

    public UUID getDepartureCityId() {
        return departureCityId;
    }

    public void setDepartureCityId(UUID departureCityId) {
        this.departureCityId = departureCityId;
    }

    public UUID getDestinationCityId() {
        return destinationCityId;
    }

    public void setDestinationCityId(UUID destinationCityId) {
        this.destinationCityId = destinationCityId;
    }

    /**
     * @deprecated Use getDepartureCityId() and getDepartureCityObj() instead
     */
    @Deprecated
    public String getDepartureCity() {
        return departureCity;
    }

    /**
     * @deprecated Use setDepartureCityId() instead
     */
    @Deprecated
    public void setDepartureCity(String departureCity) {
        this.departureCity = departureCity;
    }

    /**
     * @deprecated Use getDestinationCityId() and getDestinationCityObj()
     * instead
     */
    @Deprecated
    public String getDestinationCity() {
        return destinationCity;
    }

    /**
     * @deprecated Use setDestinationCityId() instead
     */
    @Deprecated
    public void setDestinationCity(String destinationCity) {
        this.destinationCity = destinationCity;
    }

    public City getDepartureCityObj() {
        return departureCityObj;
    }

    public void setDepartureCityObj(City departureCityObj) {
        this.departureCityObj = departureCityObj;
        if (departureCityObj != null) {
            this.departureCityId = departureCityObj.getCityId();
            this.departureCity = departureCityObj.getCityName(); // Keep backward compatibility
        }
    }

    public City getDestinationCityObj() {
        return destinationCityObj;
    }

    public void setDestinationCityObj(City destinationCityObj) {
        this.destinationCityObj = destinationCityObj;
        if (destinationCityObj != null) {
            this.destinationCityId = destinationCityObj.getCityId();
            this.destinationCity = destinationCityObj.getCityName(); // Keep backward compatibility
        }
    }

    public BigDecimal getDistance() {
        return distance;
    }

    public void setDistance(BigDecimal distance) {
        this.distance = distance;
    }

    public int getDurationHours() {
        return durationHours;
    }

    public void setDurationHours(int durationHours) {
        this.durationHours = durationHours;
    }

    public BigDecimal getBasePrice() {
        return basePrice;
    }

    public void setBasePrice(BigDecimal basePrice) {
        this.basePrice = basePrice;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
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

    public List<Schedule> getSchedules() {
        return schedules;
    }

    public void setSchedules(List<Schedule> schedules) {
        this.schedules = schedules;
    }

    // Terminal station getters and setters
    public UUID getDepartureStationId() {
        return departureStationId;
    }

    public void setDepartureStationId(UUID departureStationId) {
        this.departureStationId = departureStationId;
    }

    public UUID getDestinationStationId() {
        return destinationStationId;
    }

    public void setDestinationStationId(UUID destinationStationId) {
        this.destinationStationId = destinationStationId;
    }

    public Station getDepartureStationObj() {
        return departureStationObj;
    }

    public void setDepartureStationObj(Station departureStationObj) {
        this.departureStationObj = departureStationObj;
        if (departureStationObj != null) {
            this.departureStationId = departureStationObj.getStationId();
        }
    }

    public Station getDestinationStationObj() {
        return destinationStationObj;
    }

    public void setDestinationStationObj(Station destinationStationObj) {
        this.destinationStationObj = destinationStationObj;
        if (destinationStationObj != null) {
            this.destinationStationId = destinationStationObj.getStationId();
        }
    }

    // Optional: toString
    @Override
    public String toString() {
        return "Routes{"
                + "routeId=" + routeId
                + ", routeName='" + routeName + '\''
                + ", departureCity='" + departureCity + '\''
                + ", destinationCity='" + destinationCity + '\''
                + ", distance=" + distance
                + ", durationHours=" + durationHours
                + ", basePrice=" + basePrice
                + ", status='" + status + '\''
                + ", createdDate=" + createdDate
                + ", updatedDate=" + updatedDate
                + '}';
    }
}
