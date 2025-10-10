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
        String sql = "INSERT INTO Buses (bus_id, bus_number, bus_type, total_seats, license_plate, status) VALUES (?, ?, ?, ?, ?, ?)";
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
        String sql = "UPDATE Buses SET bus_number = ?, bus_type = ?, total_seats = ?, license_plate = ?, status = ?, updated_date = GETDATE() WHERE bus_id = ?";
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
        String sql = "UPDATE Buses SET status = 'INACTIVE', updated_date = GETDATE() WHERE bus_id = ?";
        try (
                Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);) {
            stmt.setObject(1, busId);
            return stmt.executeUpdate() > 0;
        }
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
                + "AND s.departure_time = ? "
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

    private Bus mapResultSetToBus(ResultSet rs) throws SQLException {
        Bus bus = new Bus();

        bus.setBusId((UUID) rs.getObject("bus_id"));
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
