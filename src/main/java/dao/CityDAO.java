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
import util.DBConnection;
import util.UUIDUtils;

public class CityDAO {

    public List<City> getAllCities() throws SQLException {
        List<City> cities = new ArrayList<>();
        String sql = "SELECT * FROM Cities WHERE status = 'ACTIVE' ORDER BY city_number";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                City city = mapResultSetToCity(rs);
                cities.add(city);
            }
        }
        return cities;
    }

    public City getCityById(UUID cityId) throws SQLException {
        String sql = "SELECT * FROM Cities WHERE city_id = ? AND status = 'ACTIVE'";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, cityId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToCity(rs);
            }
        }
        return null;
    }

    public City getCityByNumber(int cityNumber) throws SQLException {
        String sql = "SELECT * FROM Cities WHERE city_number = ? AND status = 'ACTIVE'";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, cityNumber);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToCity(rs);
            }
        }
        return null;
    }

    /**
     * Tìm kiếm city theo tên (case-insensitive, hỗ trợ tên gọi khác nhau)
     * Ví dụ: "hcm", "ho chi minh", "Hồ Chí Minh" đều tìm được
     */
    public City findCityByName(String cityName) throws SQLException {
        if (cityName == null || cityName.trim().isEmpty()) {
            return null;
        }

        String normalizedName = normalizeCityName(cityName);
        String sql = "SELECT * FROM Cities WHERE status = 'ACTIVE' AND " +
                "(LOWER(REPLACE(REPLACE(REPLACE(city_name, ' ', ''), 'Ồ', 'o'), 'í', 'i')) LIKE ? OR " +
                "LOWER(city_name) LIKE ? OR " +
                "city_name LIKE ?)";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            String searchPattern = "%" + normalizedName.toLowerCase() + "%";
            String originalPattern = "%" + cityName.trim() + "%";

            stmt.setString(1, searchPattern);
            stmt.setString(2, originalPattern.toLowerCase());
            stmt.setString(3, originalPattern);

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToCity(rs);
            }
        }
        return null;
    }

    /**
     * Chuẩn hóa tên thành phố để tìm kiếm (loại bỏ dấu, khoảng trắng, chuyển thành
     * chữ thường)
     */
    private String normalizeCityName(String cityName) {
        if (cityName == null) {
            return "";
        }
        // Loại bỏ khoảng trắng và chuyển thành chữ thường
        // Loại bỏ dấu tiếng Việt cơ bản
        return cityName.trim()
                .replaceAll("\\s+", "")
                .replaceAll("Ồ|Ổ|Ố|Ồ|Ỗ|Ộ", "o")
                .replaceAll("Ồ|Ổ|Ố|Ồ|Ỗ|Ộ", "o")
                .replaceAll("í|ì|ỉ|ĩ|ị", "i")
                .replaceAll("Ế|Ề|Ể|Ễ|Ệ", "e")
                .replaceAll("á|à|ả|ã|ạ", "a")
                .replaceAll("đ", "d")
                .toLowerCase();
    }

    public List<City> searchCities(String keyword) throws SQLException {
        List<City> cities = new ArrayList<>();
        String sql = "SELECT * FROM Cities WHERE status = 'ACTIVE' AND " +
                "(city_name LIKE ? OR CAST(city_number AS NVARCHAR) LIKE ?) " +
                "ORDER BY city_number";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            String searchPattern = "%" + keyword.trim() + "%";
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                City city = mapResultSetToCity(rs);
                cities.add(city);
            }
        }
        return cities;
    }

    public boolean addCity(City city) throws SQLException {
        // Kiểm tra xem city_number đã tồn tại chưa
        if (isCityNumberExists(city.getCityNumber(), null)) {
            throw new SQLException("City number " + city.getCityNumber() + " already exists");
        }

        // Kiểm tra tên city đã tồn tại chưa (case-insensitive)
        if (isCityNameExists(city.getCityName(), null)) {
            throw new SQLException("City name already exists");
        }

        String sql = "INSERT INTO Cities (city_id, city_name, city_number, status) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, city.getCityId());
            stmt.setString(2, city.getCityName());
            stmt.setInt(3, city.getCityNumber());
            stmt.setString(4, city.getStatus());

            return stmt.executeUpdate() > 0;
        }
    }

    public boolean updateCity(City city) throws SQLException {
        // Kiểm tra xem city_number đã tồn tại chưa (trừ city hiện tại)
        if (isCityNumberExists(city.getCityNumber(), city.getCityId())) {
            throw new SQLException("City number " + city.getCityNumber() + " already exists");
        }

        // Kiểm tra tên city đã tồn tại chưa (trừ city hiện tại)
        if (isCityNameExists(city.getCityName(), city.getCityId())) {
            throw new SQLException("City name already exists");
        }

        String sql = "UPDATE Cities SET city_name = ?, city_number = ?, status = ?, updated_date = GETDATE() WHERE city_id = ?";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, city.getCityName());
            stmt.setInt(2, city.getCityNumber());
            stmt.setString(3, city.getStatus());
            stmt.setObject(4, city.getCityId());

            return stmt.executeUpdate() > 0;
        }
    }

    public boolean deleteCity(UUID cityId) throws SQLException {
        String sql = "UPDATE Cities SET status = 'INACTIVE', updated_date = GETDATE() WHERE city_id = ?";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, cityId);
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean isCityNumberExists(int cityNumber, UUID excludeCityId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Cities WHERE city_number = ? AND status = 'ACTIVE'";
        if (excludeCityId != null) {
            sql += " AND city_id != ?";
        }

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, cityNumber);
            if (excludeCityId != null) {
                stmt.setObject(2, excludeCityId);
            }

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }

    public boolean isCityNameExists(String cityName, UUID excludeCityId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Cities WHERE LOWER(TRIM(city_name)) = LOWER(TRIM(?)) AND status = 'ACTIVE'";
        if (excludeCityId != null) {
            sql += " AND city_id != ?";
        }

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, cityName);
            if (excludeCityId != null) {
                stmt.setObject(2, excludeCityId);
            }

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }

    public int getMaxCityNumber() throws SQLException {
        String sql = "SELECT MAX(city_number) as max_num FROM Cities WHERE status = 'ACTIVE'";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                int maxNum = rs.getInt("max_num");
                return rs.wasNull() ? 0 : maxNum;
            }
        }
        return 0;
    }

    /**
     * Lấy các city trong khoảng từ cityNumber x đến cityNumber y
     */
    public List<City> getCitiesInRange(int fromCityNumber, int toCityNumber) throws SQLException {
        List<City> cities = new ArrayList<>();
        int minNum = Math.min(fromCityNumber, toCityNumber);
        int maxNum = Math.max(fromCityNumber, toCityNumber);

        String sql = "SELECT * FROM Cities WHERE status = 'ACTIVE' AND city_number >= ? AND city_number <= ? ORDER BY city_number";

        try (Connection conn = DBConnection.getInstance().getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, minNum);
            stmt.setInt(2, maxNum);

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                City city = mapResultSetToCity(rs);
                cities.add(city);
            }
        }
        return cities;
    }

    private City mapResultSetToCity(ResultSet rs) throws SQLException {
        City city = new City();

        city.setCityId(UUIDUtils.getUUIDFromResultSet(rs, "city_id"));
        city.setCityName(rs.getString("city_name"));
        city.setCityNumber(rs.getInt("city_number"));
        city.setStatus(rs.getString("status"));

        Timestamp createdDate = rs.getTimestamp("created_date");
        if (createdDate != null) {
            city.setCreatedDate(createdDate.toLocalDateTime());
        }

        Timestamp updatedDate = rs.getTimestamp("updated_date");
        if (updatedDate != null) {
            city.setUpdatedDate(updatedDate.toLocalDateTime());
        }

        return city;
    }
}
