package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import model.City;
import model.Station;
import util.DBConnection;
import util.UUIDUtils;

public class StationDAO {

    public List<Station> getAllStations() throws SQLException {
        List<Station> stations = new ArrayList<>();
        String sql = "SELECT s.*, c.city_name FROM Stations s " +
                     "LEFT JOIN Cities c ON s.city_id = c.city_id " +
                     "WHERE s.status = 'ACTIVE' ORDER BY s.station_name";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Station station = mapResultSetToStation(rs);
                stations.add(station);
            }
        }
        return stations;
    }

    public Station getStationById(UUID stationId) throws SQLException {
        String sql = "SELECT s.*, c.city_name FROM Stations s " +
                     "LEFT JOIN Cities c ON s.city_id = c.city_id " +
                     "WHERE s.station_id = ? AND s.status = 'ACTIVE'";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, stationId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToStation(rs);
            }
        }
        return null;
    }
    
    /**
     * Get stations by city ID
     */
    public List<Station> getStationsByCityId(UUID cityId) throws SQLException {
        List<Station> stations = new ArrayList<>();
        String sql = "SELECT s.*, c.city_name FROM Stations s " +
                     "LEFT JOIN Cities c ON s.city_id = c.city_id " +
                     "WHERE s.city_id = ? AND s.status = 'ACTIVE' ORDER BY s.station_name";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, cityId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Station station = mapResultSetToStation(rs);
                stations.add(station);
            }
        }
        return stations;
    }
    
    /**
     * Get stations by multiple city IDs (for route with multiple cities)
     */
    public List<Station> getStationsByCityIds(List<UUID> cityIds) throws SQLException {
        if (cityIds == null || cityIds.isEmpty()) {
            return new ArrayList<>();
        }
        
        List<Station> stations = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT s.*, c.city_name FROM Stations s " +
                     "LEFT JOIN Cities c ON s.city_id = c.city_id " +
                     "WHERE s.city_id IN (");
        
        for (int i = 0; i < cityIds.size(); i++) {
            if (i > 0) sql.append(",");
            sql.append("?");
        }
        sql.append(") AND s.status = 'ACTIVE' ORDER BY c.city_number, s.station_name");

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < cityIds.size(); i++) {
                stmt.setObject(i + 1, cityIds.get(i));
            }
            
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Station station = mapResultSetToStation(rs);
                stations.add(station);
            }
        }
        return stations;
    }

    /**
     * @deprecated Use getStationsByCityId() instead
     */
    @Deprecated
    public List<Station> getStationsByCity(String city) throws SQLException {
        List<Station> stations = new ArrayList<>();
        String sql = "SELECT s.*, c.city_name FROM Stations s " +
                     "LEFT JOIN Cities c ON s.city_id = c.city_id " +
                     "WHERE c.city_name = ? AND s.status = 'ACTIVE' ORDER BY s.station_name";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, city);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Station station = mapResultSetToStation(rs);
                stations.add(station);
            }
        }
        return stations;
    }

    public List<Station> searchStations(String keyword) throws SQLException {
        List<Station> stations = new ArrayList<>();
        String sql = "SELECT s.*, c.city_name FROM Stations s " +
                "LEFT JOIN Cities c ON s.city_id = c.city_id " +
                "WHERE s.status = 'ACTIVE' AND (s.station_name LIKE ? OR c.city_name LIKE ? OR s.address LIKE ?) " +
                "ORDER BY s.station_name";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            String searchPattern = "%" + keyword + "%";
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);
            stmt.setString(3, searchPattern);

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Station station = mapResultSetToStation(rs);
                stations.add(station);
            }
        }
        return stations;
    }

    public boolean addStation(Station station) throws SQLException {
        if (station.getCityId() == null) {
            throw new SQLException("City ID is required for station");
        }
        
        String sql = "INSERT INTO Stations (station_id, station_name, city_id, address, status) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, station.getStationId());
            stmt.setString(2, station.getStationName());
            stmt.setObject(3, station.getCityId());
            stmt.setString(4, station.getAddress());
            stmt.setString(5, station.getStatus());

            return stmt.executeUpdate() > 0;
        }
    }

    public boolean isStationNameTaken(String stationName) throws SQLException {
        return isStationNameTaken(stationName, null);
    }

    public boolean isStationNameTaken(String stationName, UUID excludeStationId) throws SQLException {
        // Use LOWER and LTRIM/RTRIM for consistent comparison (case-insensitive, trimmed)
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(1) FROM Stations WHERE LOWER(LTRIM(RTRIM(station_name))) = LOWER(LTRIM(RTRIM(?)))");
        if (excludeStationId != null) {
            sql.append(" AND station_id <> ?");
        }

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            stmt.setString(1, stationName);
            if (excludeStationId != null) {
                stmt.setObject(2, excludeStationId);
            }

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    public boolean updateStation(Station station) throws SQLException {
        if (station.getCityId() == null) {
            throw new SQLException("City ID is required for station");
        }
        
        String sql = "UPDATE Stations SET station_name = ?, city_id = ?, address = ?, status = ?, updated_date = GETDATE() WHERE station_id = ?";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, station.getStationName());
            stmt.setObject(2, station.getCityId());
            stmt.setString(3, station.getAddress());
            stmt.setString(4, station.getStatus());
            stmt.setObject(5, station.getStationId());

            return stmt.executeUpdate() > 0;
        }
    }

    public boolean deleteStation(UUID stationId) throws SQLException {
        String sql = "UPDATE Stations SET status = 'INACTIVE', updated_date = GETDATE() WHERE station_id = ?";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, stationId);
            return stmt.executeUpdate() > 0;
        }
    }

    public int getTotalStations() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Stations WHERE status = 'ACTIVE'";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    /**
     * @deprecated Use CityDAO.getAllCities() instead
     */
    @Deprecated
    public List<String> getAllCities() throws SQLException {
        List<String> cities = new ArrayList<>();
        String sql = "SELECT DISTINCT c.city_name FROM Stations s " +
                     "JOIN Cities c ON s.city_id = c.city_id " +
                     "WHERE s.status = 'ACTIVE' ORDER BY c.city_name";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                cities.add(rs.getString("city_name"));
            }
        }
        return cities;
    }

    public Station mapResultSetToStation(ResultSet rs) throws SQLException {
        Station station = new Station();

        station.setStationId(UUIDUtils.getUUIDFromResultSet(rs, "station_id"));
        station.setStationName(rs.getString("station_name"));
        
        // Try to get city_id first, fallback to city string if not available
        try {
            UUID cityId = UUIDUtils.getUUIDFromResultSet(rs, "city_id");
            if (cityId != null) {
                station.setCityId(cityId);
            }
        } catch (SQLException e) {
            // city_id column might not exist in older queries
        }
        
        // Get city name for backward compatibility
        try {
            String cityName = rs.getString("city_name");
            if (cityName != null) {
                station.setCity(cityName); // Deprecated but kept for compatibility
            }
        } catch (SQLException e) {
            // Try old city column
            try {
                String city = rs.getString("city");
                if (city != null) {
                    station.setCity(city);
                }
            } catch (SQLException e2) {
                // Ignore
            }
        }
        
        station.setAddress(rs.getString("address"));
        station.setStatus(rs.getString("status"));

        Timestamp createdDate = rs.getTimestamp("created_date");
        if (createdDate != null) {
            station.setCreatedDate(createdDate.toLocalDateTime());
        }

        Timestamp updatedDate = rs.getTimestamp("updated_date");
        if (updatedDate != null) {
            station.setUpdatedDate(updatedDate.toLocalDateTime());
        }

        return station;
    }
}
