package util;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.UUID;

/**
 * Utility class for handling UUID conversions from database ResultSet
 */
public class UUIDUtils {

    /**
     * Helper method to safely convert database object to UUID
     */
    public static UUID getUUIDFromResultSet(ResultSet rs, String columnName) throws SQLException {
        Object obj = rs.getObject(columnName);
        if (obj instanceof UUID) {
            return (UUID) obj;
        } else if (obj instanceof String) {
            return UUID.fromString((String) obj);
        } else {
            throw new SQLException(
                    "Invalid " + columnName + " type: " + (obj != null ? obj.getClass().getName() : "null"));
        }
    }
}
