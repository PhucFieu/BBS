package dto;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.UUID;

import dao.StationDAO;
import model.Station;

/**
 * DTO that encapsulates the ordered station selection coming from the route
 * management forms. It ensures that we always work with validated station IDs
 * instead of arbitrary strings while preserving the requested order (departure,
 * intermediate stops, destination).
 */
public class RouteStationRequestDTO {
    private final UUID departureStationId;
    private final UUID destinationStationId;
    private final List<UUID> orderedStationIds;

    private List<Station> orderedStations;

    public RouteStationRequestDTO(UUID departureStationId, UUID destinationStationId,
            List<UUID> orderedStationIds) {
        this.departureStationId = departureStationId;
        this.destinationStationId = destinationStationId;
        this.orderedStationIds =
                orderedStationIds != null ? new ArrayList<>(orderedStationIds) : new ArrayList<>();
    }

    public UUID getDepartureStationId() {
        return departureStationId;
    }

    public UUID getDestinationStationId() {
        return destinationStationId;
    }

    public List<UUID> getOrderedStationIds() {
        return new ArrayList<>(orderedStationIds);
    }

    /**
     * Validate the submitted station data and resolve the underlying Station
     * entities to avoid repeated DAO lookups elsewhere.
     *
     * @throws IllegalArgumentException when the submitted data is invalid
     * @throws SQLException             when station lookups fail
     */
    public void validateAndResolve(StationDAO stationDAO)
            throws IllegalArgumentException, SQLException {
        if (departureStationId == null) {
            throw new IllegalArgumentException("Departure terminal is required");
        }
        if (destinationStationId == null) {
            throw new IllegalArgumentException("Destination terminal is required");
        }
        if (orderedStationIds.isEmpty()) {
            throw new IllegalArgumentException("At least two ordered stations are required");
        }

        if (!departureStationId.equals(orderedStationIds.get(0))) {
            throw new IllegalArgumentException("First station in the sequence must match departure terminal");
        }
        if (!destinationStationId.equals(orderedStationIds.get(orderedStationIds.size() - 1))) {
            throw new IllegalArgumentException(
                    "Last station in the sequence must match destination terminal");
        }
        if (departureStationId.equals(destinationStationId)) {
            throw new IllegalArgumentException("Departure and destination terminals must differ");
        }

        Set<UUID> uniqueCheck = new HashSet<>();
        orderedStations = new ArrayList<>();

        for (UUID stationId : orderedStationIds) {
            if (stationId == null) {
                throw new IllegalArgumentException("Station ID in the sequence is invalid");
            }
            if (!uniqueCheck.add(stationId)) {
                throw new IllegalArgumentException("Duplicate station detected in the sequence");
            }

            Station station = stationDAO.getStationById(stationId);
            if (station == null || station.getStatus() == null
                    || !"ACTIVE".equalsIgnoreCase(station.getStatus())) {
                throw new IllegalArgumentException("Station " + stationId + " is not active or does not exist");
            }
            orderedStations.add(station);
        }

        if (orderedStations.size() < 2) {
            throw new IllegalArgumentException("Route must include at least two unique stations");
        }
    }

    public List<Station> getOrderedStations() {
        return orderedStations == null ? new ArrayList<>() : new ArrayList<>(orderedStations);
    }

    public Station getDepartureStation() {
        return orderedStations == null || orderedStations.isEmpty() ? null : orderedStations.get(0);
    }

    public Station getDestinationStation() {
        if (orderedStations == null || orderedStations.isEmpty()) {
            return null;
        }
        return orderedStations.get(orderedStations.size() - 1);
    }
}

