package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import model.Station;
import util.DBConnection;
import util.UUIDUtils;
/**
 *
 * @author PhúcNH CE190359
 */
public class StationDAO {

    public List<Station> getAllStations() throws SQLException {
        List<Station> stations = new ArrayList<>();
        String sql = "SELECT * FROM Stations WHERE status = 'ACTIVE' ORDER BY station_name";

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
        String sql = "SELECT * FROM Stations WHERE station_id = ? AND status = 'ACTIVE'";

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

    public List<Station> getStationsByCity(String city) throws SQLException {
        List<Station> stations = new ArrayList<>();
        String sql = "SELECT * FROM Stations WHERE city = ? AND status = 'ACTIVE' ORDER BY station_name";

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
        String sql = "SELECT * FROM Stations WHERE status = 'ACTIVE' AND (station_name LIKE ? OR city LIKE ? OR address LIKE ?) ORDER BY station_name";

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
        String sql = "INSERT INTO Stations (station_id, station_name, city, address, status) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, station.getStationId());
            stmt.setString(2, station.getStationName());
            stmt.setString(3, station.getCity());
            stmt.setString(4, station.getAddress());
            stmt.setString(5, station.getStatus());

            return stmt.executeUpdate() > 0;
        }
    }

    public boolean updateStation(Station station) throws SQLException {
        String sql = "UPDATE Stations SET station_name = ?, city = ?, address = ?, status = ?, updated_date = GETDATE() WHERE station_id = ?";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, station.getStationName());
            stmt.setString(2, station.getCity());
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

    public List<String> getAllCities() throws SQLException {
        List<String> cities = new ArrayList<>();
        String sql = "SELECT DISTINCT city FROM Stations WHERE status = 'ACTIVE' ORDER BY city";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                cities.add(rs.getString("city"));
            }
        }
        return cities;
    }

    private Station mapResultSetToStation(ResultSet rs) throws SQLException {
        Station station = new Station();

        station.setStationId(UUIDUtils.getUUIDFromResultSet(rs, "station_id"));
        station.setStationName(rs.getString("station_name"));
        station.setCity(rs.getString("city"));
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
