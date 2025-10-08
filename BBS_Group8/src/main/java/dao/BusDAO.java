package dao;

import model.Bus;
import util.DBConnection;
import java.sql.*;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

public class BusDAO {

    public List<Bus> getAllBuses() throws SQLException {
        List<Bus> buses = new ArrayList<>();
        String sql =
            "SELECT * FROM Buses WHERE status = 'ACTIVE' ORDER BY bus_number";

        try (
            Connection conn = DBConnection.getInstance().getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();
        ) {
            while (rs.next()) {
                Bus bus = mapResultSetToBus(rs);
                buses.add(bus);
            }
        }
        return buses;
    }

    public Bus getBusById(int busId) throws SQLException {
        String sql =
            "SELECT * FROM Buses WHERE bus_id = ? AND status = 'ACTIVE'";

        try (
            Connection conn = DBConnection.getInstance().getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
        ) {
            stmt.setInt(1, busId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToBus(rs);
            }
        }
        return null;
    }

    public Bus getBusByNumber(String busNumber) throws SQLException {
        String sql =
            "SELECT * FROM Buses WHERE bus_number = ? AND status = 'ACTIVE'";

        try (
            Connection conn = DBConnection.getInstance().getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
        ) {
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
        String sql =
            "SELECT * FROM Buses WHERE status = 'ACTIVE' AND available_seats > 0 ORDER BY bus_number";

        try (
            Connection conn = DBConnection.getInstance().getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();
        ) {
            while (rs.next()) {
                Bus bus = mapResultSetToBus(rs);
                buses.add(bus);
            }
        }
        return buses;
    }

    public boolean addBus(Bus bus) throws SQLException {
        String sql =
            "INSERT INTO Buses (bus_number, bus_type, total_seats, available_seats, driver_name, license_plate) VALUES (?, ?, ?, ?, ?, ?)";

        try (
            Connection conn = DBConnection.getInstance().getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
        ) {
            stmt.setString(1, bus.getBusNumber());
            stmt.setString(2, bus.getBusType());
            stmt.setInt(3, bus.getTotalSeats());
            stmt.setInt(4, bus.getAvailableSeats());
            stmt.setString(5, bus.getDriverId());
            stmt.setString(6, bus.getLicensePlate());

            return stmt.executeUpdate() > 0;
        }
    }

    public boolean updateBus(Bus bus) throws SQLException {
        String sql =
            "UPDATE Buses SET bus_number = ?, bus_type = ?, total_seats = ?, available_seats = ?, driver_name = ?, license_plate = ?, updated_date = GETDATE() WHERE bus_id = ?";

        try (
            Connection conn = DBConnection.getInstance().getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
        ) {
            stmt.setString(1, bus.getBusNumber());
            stmt.setString(2, bus.getBusType());
            stmt.setInt(3, bus.getTotalSeats());
            stmt.setInt(4, bus.getAvailableSeats());
            stmt.setString(5, bus.getDriverId());
            stmt.setString(6, bus.getLicensePlate());
            stmt.setInt(7, bus.getBusId());

            return stmt.executeUpdate() > 0;
        }
    }

    public boolean deleteBus(int busId) throws SQLException {
        String sql =
            "UPDATE Buses SET status = 'INACTIVE', updated_date = GETDATE() WHERE bus_id = ?";

        try (
            Connection conn = DBConnection.getInstance().getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
        ) {
            stmt.setInt(1, busId);
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean updateAvailableSeats(int busId, int seatsToReserve)
        throws SQLException {
        String sql =
            "UPDATE Buses SET available_seats = available_seats - ?, updated_date = GETDATE() WHERE bus_id = ? AND available_seats >= ?";

        try (
            Connection conn = DBConnection.getInstance().getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
        ) {
            stmt.setInt(1, seatsToReserve);
            stmt.setInt(2, busId);
            stmt.setInt(3, seatsToReserve);

            return stmt.executeUpdate() > 0;
        }
    }

    public int getTotalBuses() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Buses WHERE status = 'ACTIVE'";

        try (
            Connection conn = DBConnection.getInstance().getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();
        ) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    public List<Bus> getAvailableBusesForRoute(
        int routeId,
        LocalDate date,
        LocalTime time
    ) throws SQLException {
        List<Bus> buses = new ArrayList<>();
        
        // First, try to find buses from schedules
        String scheduleSql =
            "SELECT b.* FROM Schedules s " +
            "JOIN Buses b ON s.bus_id = b.bus_id " +
            "WHERE s.route_id = ? " +
            "AND s.departure_date = ? " +
            "AND s.departure_time = ? " +
            "AND b.status = 'ACTIVE' " +
            "AND s.available_seats > 0";
            
        try (
            Connection conn = DBConnection.getInstance().getConnection();
            PreparedStatement stmt = conn.prepareStatement(scheduleSql);
        ) {
            stmt.setInt(1, routeId);
            stmt.setDate(2, java.sql.Date.valueOf(date));
            stmt.setString(3, time.toString() + ":00");

            System.out.println("Checking schedules for route: " + routeId + ", date: " + date + ", time: " + time);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Bus bus = mapResultSetToBus(rs);
                    buses.add(bus);
                }
            }
        }
        
        // If no buses found in schedules, get all available buses
        if (buses.isEmpty()) {
            System.out.println("No scheduled buses found, getting all available buses");
            String fallbackSql = 
                "SELECT * FROM Buses " +
                "WHERE status = 'ACTIVE' AND available_seats > 0 " +
                "ORDER BY bus_number";
                
            try (
                Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(fallbackSql);
                ResultSet rs = stmt.executeQuery();
            ) {
                while (rs.next()) {
                    Bus bus = mapResultSetToBus(rs);
                    buses.add(bus);
                }
            }
        }
        
        return buses;
    }
    
public Bus getBusDetails(int busId) throws SQLException {
    String sql = "SELECT * FROM Buses WHERE bus_id = ?";
    
    try (
        Connection conn = DBConnection.getInstance().getConnection();
        PreparedStatement stmt = conn.prepareStatement(sql);
    ) {
        stmt.setInt(1, busId);
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
        bus.setBusId(rs.getInt("bus_id"));
        bus.setBusNumber(rs.getString("bus_number"));
        bus.setBusType(rs.getString("bus_type"));
        bus.setTotalSeats(rs.getInt("total_seats"));
        bus.setAvailableSeats(rs.getInt("available_seats"));
        bus.setDriverId(rs.getString("driver_name"));
        bus.setLicensePlate(rs.getString("license_plate"));
        bus.setStatus(rs.getString("status"));
        bus.setCreatedDate(rs.getTimestamp("created_date").toLocalDateTime());
        bus.setUpdatedDate(rs.getTimestamp("updated_date").toLocalDateTime());
        return bus;
    }
}
