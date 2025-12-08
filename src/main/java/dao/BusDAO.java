package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import model.Bus;
import util.DBConnection;
import util.UUIDUtils;

public class BusDAO {

    public List<Bus> getAllBuses() throws SQLException {
        List<Bus> buses = new ArrayList<>();
        String sql = "SELECT * FROM Buses WHERE status = 'ACTIVE' ORDER BY bus_number";
        try (
                Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery();) {
            while (rs.next()) {
                Bus bus = mapResultSetToBus(rs);
                buses.add(bus);
            }
        }
        return buses;
    }

    public List<Bus> getAllBusesForAdmin() throws SQLException {
        List<Bus> buses = new ArrayList<>();
        String sql = "SELECT * FROM Buses WHERE status != 'INACTIVE' ORDER BY bus_number";
        try (
                Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery();) {
            while (rs.next()) {
                Bus bus = mapResultSetToBus(rs);
                buses.add(bus);
            }
        }
        return buses;
    }

    public Bus getBusById(UUID busId) throws SQLException {
        String sql = "SELECT * FROM Buses WHERE bus_id = ? AND status = 'ACTIVE'";
        try (
                Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);) {
            stmt.setObject(1, busId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToBus(rs);
            }
        }
        return null;
    }

    public Bus getBusByIdForAdmin(UUID busId) throws SQLException {
        String sql = "SELECT * FROM Buses WHERE bus_id = ?";
        try (
                Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);) {
            stmt.setObject(1, busId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToBus(rs);
            }
        }
        return null;
    }

    public Bus getBusByNumber(String busNumber) throws SQLException {
        String sql = "SELECT * FROM Buses WHERE bus_number = ? AND status = 'ACTIVE'";
        try (
                Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);) {
            stmt.setString(1, busNumber);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToBus(rs);
            }
        }
        return null;
    }

    public List<Bus> getAvailableBuses() throws SQLException {
        List<Bus> buses = new ArrayList<>();
        String sql = "SELECT * FROM Buses WHERE status = 'ACTIVE' ORDER BY bus_number";
        try (
                Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery();) {
            while (rs.next()) {
                Bus bus = mapResultSetToBus(rs);
                buses.add(bus);
            }
        }
        return buses;
    }

    public boolean addBus(Bus bus) throws SQLException {
        String sql =
                "INSERT INTO Buses (bus_id, bus_number, bus_type, total_seats, license_plate, status) VALUES (?, ?, ?, ?, ?, ?)";
        try (
                Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);) {
            stmt.setObject(1, bus.getBusId());
            stmt.setString(2, bus.getBusNumber());
            stmt.setString(3, bus.getBusType());
            stmt.setInt(4, bus.getTotalSeats());
            stmt.setString(5, bus.getLicensePlate());
            stmt.setString(6, bus.getStatus());
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean updateBus(Bus bus) throws SQLException {
        String sql =
                "UPDATE Buses SET bus_number = ?, bus_type = ?, total_seats = ?, license_plate = ?, status = ?, updated_date = GETDATE() WHERE bus_id = ?";
        try (
                Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);) {
            stmt.setString(1, bus.getBusNumber());
            stmt.setString(2, bus.getBusType());
            stmt.setInt(3, bus.getTotalSeats());
            stmt.setString(4, bus.getLicensePlate());
            stmt.setString(5, bus.getStatus());
            stmt.setObject(6, bus.getBusId());
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean deleteBus(UUID busId) throws SQLException {
        String sql =
                "UPDATE Buses SET status = 'INACTIVE', updated_date = GETDATE() WHERE bus_id = ? AND status = 'ACTIVE'";
        try (
                Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);) {
            stmt.setObject(1, busId);
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean isBusInUse(UUID busId) throws SQLException {
        String sql =
                "SELECT COUNT(*) FROM Schedules WHERE bus_id = ? AND departure_date >= CAST(GETDATE() AS DATE)";
        try (
                Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);) {
            stmt.setObject(1, busId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    // Note: available_seats is now managed in Schedules table, not Buses table
    // This method is kept for backward compatibility but should be updated to work
    // with Schedules
    public boolean updateAvailableSeats(UUID busId, int seatsToReserve)
            throws SQLException {
        // This method should now update available_seats in Schedules table instead
        // For now, we'll just return true as a placeholder
        return true;
    }

    public int getTotalBuses() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Buses WHERE status = 'ACTIVE'";
        try (
                Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery();) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    public List<Bus> getAvailableBusesForRoute(
            UUID routeId,
            LocalDate date,
            LocalTime time) throws SQLException {
        List<Bus> buses = new ArrayList<>();

        String scheduleSql = "SELECT b.* FROM Schedules s "
                + "JOIN Buses b ON s.bus_id = b.bus_id "
                + "WHERE s.route_id = ? "
                + "AND s.departure_date = ? "
                + "AND s.departure_time = CAST(? AS TIME) "
                + "AND b.status = 'ACTIVE' "
                + "AND s.available_seats > 0";

        try (
                Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(scheduleSql);) {
            stmt.setObject(1, routeId);
            stmt.setDate(2, java.sql.Date.valueOf(date));
            stmt.setTime(3, java.sql.Time.valueOf(time));

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    buses.add(mapResultSetToBus(rs));
                }
            }
        }

        if (buses.isEmpty()) {
            String fallbackSql = "SELECT * FROM Buses "
                    + "WHERE status = 'ACTIVE' "
                    + "ORDER BY bus_number";

            try (
                    Connection conn = DBConnection.getInstance().getConnection();
                    PreparedStatement stmt = conn.prepareStatement(fallbackSql);
                    ResultSet rs = stmt.executeQuery();) {
                while (rs.next()) {
                    buses.add(mapResultSetToBus(rs));
                }
            }
        }

        return buses;
    }

    public Bus getBusDetails(UUID busId) throws SQLException {
        String sql = "SELECT * FROM Buses WHERE bus_id = ?";

        try (
                Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);) {
            stmt.setObject(1, busId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToBus(rs);
                }
            }
        }
        return null;
    }

    public List<Bus> searchBuses(String searchTerm) throws SQLException {
        List<Bus> buses = new ArrayList<>();
        String sql =
                "SELECT * FROM Buses WHERE (bus_number LIKE ? OR bus_type LIKE ? OR license_plate LIKE ?) AND status != 'INACTIVE' ORDER BY bus_number";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            String searchPattern = "%" + searchTerm + "%";
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);
            stmt.setString(3, searchPattern);

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Bus bus = mapResultSetToBus(rs);
                buses.add(bus);
            }
        }
        return buses;
    }

    public List<String> getDistinctBusTypes() throws SQLException {
        List<String> busTypes = new ArrayList<>();
        String sql = "SELECT DISTINCT bus_type FROM Buses ORDER BY bus_type";
        try (
                Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery();) {
            while (rs.next()) {
                busTypes.add(rs.getString("bus_type"));
            }
        }
        return busTypes;
    }

    public boolean isBusNumberExists(String busNumber, UUID excludeBusId)
            throws SQLException {
        // Use UPPER and LTRIM/RTRIM (SQL Server doesn't have single TRIM function in all versions)
        // Also collapse multiple spaces by comparing normalized values
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM Buses WHERE UPPER(LTRIM(RTRIM(bus_number))) = UPPER(LTRIM(RTRIM(?)))");

        if (excludeBusId != null) {
            sql.append(" AND bus_id <> ?");
        }

        try (
                Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql.toString());) {
            stmt.setString(1, busNumber);
            if (excludeBusId != null) {
                stmt.setObject(2, excludeBusId);
            }
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    public boolean isLicensePlateExists(String licensePlate, UUID excludeBusId)
            throws SQLException {
        // Use UPPER and LTRIM/RTRIM for consistent comparison
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM Buses WHERE UPPER(LTRIM(RTRIM(license_plate))) = UPPER(LTRIM(RTRIM(?)))");

        if (excludeBusId != null) {
            sql.append(" AND bus_id <> ?");
        }

        try (
                Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql.toString());) {
            stmt.setString(1, licensePlate);
            if (excludeBusId != null) {
                stmt.setObject(2, excludeBusId);
            }
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    private Bus mapResultSetToBus(ResultSet rs) throws SQLException {
        Bus bus = new Bus();

        bus.setBusId(UUIDUtils.getUUIDFromResultSet(rs, "bus_id"));
        bus.setBusNumber(rs.getString("bus_number"));
        bus.setBusType(rs.getString("bus_type"));
        bus.setTotalSeats(rs.getInt("total_seats"));
        bus.setLicensePlate(rs.getString("license_plate"));
        bus.setStatus(rs.getString("status"));

        Timestamp createdDate = rs.getTimestamp("created_date");
        if (createdDate != null) {
            bus.setCreatedDate(createdDate.toLocalDateTime());
        }

        Timestamp updatedDate = rs.getTimestamp("updated_date");
        if (updatedDate != null) {
            bus.setUpdatedDate(updatedDate.toLocalDateTime());
        }

        return bus;
    }
}
