/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import java.math.BigDecimal;
import java.sql.*;
import java.util.*;
import model.Routes;
import utils.DBConnection;

public class RoutesDAO {

    // ✅ Thêm mới tuyến đường
    public boolean insertRoute(Routes route) {
        String sql = "INSERT INTO Routes (route_id, route_name, departure_city, destination_city, "
                + "distance, duration_hours, base_price, status, created_date, updated_date) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setObject(1, route.getRouteId());
            ps.setString(2, route.getRouteName());
            ps.setString(3, route.getDepartureCity());
            ps.setString(4, route.getDestinationCity());
            ps.setBigDecimal(5, route.getDistance());
            ps.setInt(6, route.getDurationHours());
            ps.setBigDecimal(7, route.getBasePrice());
            ps.setString(8, route.getStatus());
            ps.setTimestamp(9, new Timestamp(route.getCreatedDate().getTime()));
            ps.setTimestamp(10, new Timestamp(route.getUpdatedDate().getTime()));

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("❌ insertRoute() error: " + e.getMessage());
        }
        return false;
    }

    // ✅ Cập nhật tuyến đường
    public boolean updateRoute(Routes route) {
        String sql = "UPDATE Routes SET route_name=?, departure_city=?, destination_city=?, "
                + "distance=?, duration_hours=?, base_price=?, status=?, updated_date=? "
                + "WHERE route_id=?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, route.getRouteName());
            ps.setString(2, route.getDepartureCity());
            ps.setString(3, route.getDestinationCity());
            ps.setBigDecimal(4, route.getDistance());
            ps.setInt(5, route.getDurationHours());
            ps.setBigDecimal(6, route.getBasePrice());
            ps.setString(7, route.getStatus());
            ps.setTimestamp(8, new Timestamp(System.currentTimeMillis()));
            ps.setObject(9, route.getRouteId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("❌ updateRoute() error: " + e.getMessage());
        }
        return false;
    }

    // ✅ Xóa tuyến đường
    public boolean deleteRoute(UUID routeId) {
        String sql = "DELETE FROM Routes WHERE route_id=?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setObject(1, routeId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("❌ deleteRoute() error: " + e.getMessage());
        }
        return false;
    }

    // ✅ Lấy danh sách tất cả tuyến đường
    public List<Routes> getAllRoutes() {
        List<Routes> list = new ArrayList<>();
        String sql = "SELECT * FROM Routes ORDER BY created_date DESC";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Routes r = mapResultSetToRoute(rs);
                list.add(r);
            }
        } catch (SQLException e) {
            System.err.println("❌ getAllRoutes() error: " + e.getMessage());
        }
        return list;
    }

    // ✅ Tìm tuyến đường theo ID
    public Routes getRouteById(UUID routeId) {
        String sql = "SELECT * FROM Routes WHERE route_id=?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setObject(1, routeId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToRoute(rs);
            }
        } catch (SQLException e) {
            System.err.println("❌ getRouteById() error: " + e.getMessage());
        }
        return null;
    }

    // ✅ Tìm tuyến theo thành phố đi & đến
    public List<Routes> searchRoutesByCities(String departure, String destination) {
        List<Routes> list = new ArrayList<>();
        String sql = "SELECT * FROM Routes WHERE departure_city LIKE ? AND destination_city LIKE ?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, "%" + departure + "%");
            ps.setString(2, "%" + destination + "%");
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapResultSetToRoute(rs));
            }
        } catch (SQLException e) {
            System.err.println("❌ searchRoutesByCities() error: " + e.getMessage());
        }
        return list;
    }

    // ✅ Đếm tổng số tuyến (phục vụ phân trang)
    public int countRoutes() {
        String sql = "SELECT COUNT(*) FROM Routes";
        try (Connection conn = DBConnection.getConnection(); Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("❌ countRoutes() error: " + e.getMessage());
        }
        return 0;
    }

    // ✅ Helper: Chuyển ResultSet -> Routes object
    private Routes mapResultSetToRoute(ResultSet rs) throws SQLException {
        Routes r = new Routes();

        String routeIdStr = rs.getString("route_id");
        if (routeIdStr != null && !routeIdStr.isEmpty()) {
            try {
                r.setRouteId(UUID.fromString(routeIdStr));
            } catch (IllegalArgumentException e) {
                System.err.println("⚠️ route_id không đúng định dạng UUID: " + routeIdStr);
                r.setRouteId(null);
            }
        } else {
            r.setRouteId(null);
        }

        r.setRouteName(rs.getString("route_name"));
        r.setDepartureCity(rs.getString("departure_city"));
        r.setDestinationCity(rs.getString("destination_city"));
        r.setDistance(rs.getBigDecimal("distance"));
        r.setDurationHours(rs.getInt("duration_hours"));
        r.setBasePrice(rs.getBigDecimal("base_price"));
        r.setStatus(rs.getString("status"));
        r.setCreatedDate(rs.getTimestamp("created_date"));
        r.setUpdatedDate(rs.getTimestamp("updated_date"));
        return r;
    }

    
//    //chạy thử
//    public static void main(String[] args) {
//        RoutesDAO dao = new RoutesDAO();
//
//        System.out.println("=== TEST ROUTES DAO ===");
//
//        // ✅ 1. Them moi tuyen duong
//        Routes newRoute = new Routes();
//        newRoute.setRouteName("TP.HCM - Da Lat");
//        newRoute.setDepartureCity("TP.HCM");
//        newRoute.setDestinationCity("Da Lat");
//        newRoute.setDistance(new BigDecimal("300.5"));
//        newRoute.setDurationHours(6);
//        newRoute.setBasePrice(new BigDecimal("250000"));
//        newRoute.setStatus("ACTIVE");
//
//        boolean inserted = dao.insertRoute(newRoute);
//        System.out.println("Them moi tuyen: " + (inserted ? "Thanh cong" : "That bai"));
//
//        // ✅ 2. Lay tat ca tuyen
//        System.out.println("\n--- Danh sach tat ca tuyen ---");
//        List<Routes> routesList = dao.getAllRoutes();
//        for (Routes r : routesList) {
//            System.out.println(r);
//        }
//
//        // ✅ 3. Tim tuyen theo ID (lay ID cua tuyen vua chen)
//        if (!routesList.isEmpty()) {
//            UUID id = routesList.get(0).getRouteId();
//            Routes route = dao.getRouteById(id);
//            System.out.println("\n--- Tim theo ID ---");
//            System.out.println(route);
//        }
//
//        // ✅ 4. Cap nhat tuyen (vi du chinh gia & thoi gian)
//        if (!routesList.isEmpty()) {
//            Routes route = routesList.get(0);
//            route.setBasePrice(new BigDecimal("300000"));
//            route.setDurationHours(7);
//            boolean updated = dao.updateRoute(route);
//            System.out.println("\nCap nhat tuyen: " + (updated ? "Thanh cong" : "That bai"));
//        }
//
//        // ✅ 5. Tim tuyen theo thanh pho
//        System.out.println("\n--- Tim tuyen co diem di 'TP.HCM' ---");
//        List<Routes> search = dao.searchRoutesByCities("TP.HCM", "");
//        for (Routes r : search) {
//            System.out.println(r);
//        }
//
//        // ✅ 6. Dem tong so tuyen
//        int count = dao.countRoutes();
//        System.out.println("\nTong so tuyen hien co: " + count);
//
//        // ✅ 7. Xoa tuyen cuoi cung (neu muon test xoa)
//        if (!routesList.isEmpty()) {
//            UUID idToDelete = routesList.get(routesList.size() - 1).getRouteId();
//            boolean deleted = dao.deleteRoute(idToDelete);
//            System.out.println("\nXoa tuyen: " + (deleted ? "Thanh cong" : "That bai"));
//        }
//
//        System.out.println("\n=== KET THUC TEST ===");
//    }
}
