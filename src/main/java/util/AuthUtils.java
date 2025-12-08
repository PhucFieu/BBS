package util;

import java.util.UUID;

import jakarta.servlet.http.HttpSession;
import model.User;

public class AuthUtils {

    /**
     * Check if user is logged in
     */
    public static boolean isLoggedIn(HttpSession session) {
        return session != null && session.getAttribute("user") != null;
    }

    /**
     * Lấy user hiện tại từ session
     */
    public static User getCurrentUser(HttpSession session) {
        if (session != null) {
            return (User) session.getAttribute("user");
        }
        return null;
    }

    /**
     * Kiểm tra xem user có role cụ thể hay không
     */
    public static boolean hasRole(HttpSession session, String role) {
        User user = getCurrentUser(session);
        return user != null && user.getRole() != null && role != null && role.equalsIgnoreCase(user.getRole());
    }

    /**
     * Kiểm tra xem user có phải là ADMIN hay không
     */
    public static boolean isAdmin(HttpSession session) {
        return hasRole(session, "ADMIN");
    }

    /**
     * Kiểm tra xem user có phải là DRIVER hay không
     */
    public static boolean isDriver(HttpSession session) {
        // Chấp nhận cả các biến thể role khác nhau như "Drive"
        return hasRole(session, "DRIVER") || hasRole(session, "DRIVE") || hasRole(session, "Drive");
    }

    /**
     * Kiểm tra xem user có phải là USER hay không
     */
    public static boolean isUser(HttpSession session) {
        return hasRole(session, "USER");
    }

    /**
     * Kiểm tra xem user có phải là STAFF hay không
     */
    public static boolean isStaff(HttpSession session) {
        return hasRole(session, "STAFF");
    }

    /**
     * Kiểm tra xem user có quyền truy cập vào admin area hay không
     */
    public static boolean canAccessAdmin(HttpSession session) {
        return isAdmin(session) || isDriver(session) || isStaff(session);
    }

    /**
     * Kiểm tra xem user có quyền quản lý user khác hay không
     */
    public static boolean canManageUsers(HttpSession session) {
        return isAdmin(session);
    }

    /**
     * Kiểm tra xem user có quyền quản lý bus hay không
     */
    public static boolean canManageBuses(HttpSession session) {
        return isAdmin(session);
    }

    /**
     * Kiểm tra xem user có quyền quản lý routes hay không
     */
    public static boolean canManageRoutes(HttpSession session) {
        return isAdmin(session);
    }

    /**
     * Kiểm tra xem user có quyền quản lý passengers hay không
     */
    public static boolean canManagePassengers(HttpSession session) {
        return isAdmin(session);
    }

    /**
     * Kiểm tra xem user có quyền xem tickets hay không
     */
    public static boolean canViewTickets(HttpSession session) {
        return isLoggedIn(session);
    }

    /**
     * Kiểm tra xem user có quyền tạo ticket hay không
     */
    public static boolean canCreateTicket(HttpSession session) {
        return isLoggedIn(session);
    }

    /**
     * Kiểm tra xem user có quyền chỉnh sửa ticket của chính mình hay không
     */
    public static boolean canEditOwnTicket(HttpSession session, UUID ticketUserId) {
        User currentUser = getCurrentUser(session);
        if (currentUser == null)
            return false;

        // Admin và Driver có thể chỉnh sửa tất cả tickets
        if (isAdmin(session) || isDriver(session))
            return true;

        // User chỉ có thể chỉnh sửa ticket của chính mình
        return currentUser.getUserId().equals(ticketUserId);
    }

    /**
     * Kiểm tra xem user có quyền quản lý drivers hay không
     */
    public static boolean canManageDrivers(HttpSession session) {
        return isAdmin(session);
    }

    /**
     * Kiểm tra xem user có quyền quản lý stations hay không
     */
    public static boolean canManageStations(HttpSession session) {
        return isAdmin(session);
    }

    /**
     * Kiểm tra xem user có quyền quản lý schedules hay không
     */
    public static boolean canManageSchedules(HttpSession session) {
        return isAdmin(session);
    }

    /**
     * Kiểm tra xem user có quyền quản lý ratings hay không
     */
    public static boolean canManageRatings(HttpSession session) {
        return isAdmin(session);
    }

    /**
     * Kiểm tra xem user có quyền quản lý tickets cho khách hay không (Staff)
     */
    public static boolean canManageTicketsForCustomers(HttpSession session) {
        return isAdmin(session) || isStaff(session);
    }

    /**
     * Kiểm tra xem user có quyền check-in khách hay không
     */
    public static boolean canCheckInPassengers(HttpSession session) {
        return isAdmin(session) || isStaff(session);
    }

    /**
     * Kiểm tra xem user có quyền xem danh sách khách hay không
     */
    public static boolean canViewPassengerList(HttpSession session) {
        return isAdmin(session) || isStaff(session) || isDriver(session);
    }

    /**
     * Kiểm tra xem user có quyền hủy vé hay không
     */
    public static boolean canCancelTickets(HttpSession session) {
        return isAdmin(session) || isStaff(session);
    }

    /**
     * Kiểm tra xem user có quyền sửa vé hay không
     */
    public static boolean canModifyTickets(HttpSession session) {
        return isAdmin(session) || isStaff(session);
    }
}