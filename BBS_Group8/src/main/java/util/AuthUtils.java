package util;

import fpt.edu.vn.busticket.model.User;
import jakarta.servlet.http.HttpSession;

public class AuthUtils {
    
    /**
     * Kiểm tra xem user có đăng nhập hay không
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
        return user != null && role.equals(user.getRole());
    }
    
    /**
     * Kiểm tra xem user có phải là ADMIN hay không
     */
    public static boolean isAdmin(HttpSession session) {
        return hasRole(session, "ADMIN");
    }
    
    /**
     * Kiểm tra xem user có phải là STAFF hay không
     */
    public static boolean isStaff(HttpSession session) {
        return hasRole(session, "STAFF");
    }
    
    /**
     * Kiểm tra xem user có phải là CUSTOMER hay không
     */
    public static boolean isCustomer(HttpSession session) {
        return hasRole(session, "CUSTOMER");
    }
    
    /**
     * Kiểm tra xem user có quyền truy cập vào admin area hay không
     */
    public static boolean canAccessAdmin(HttpSession session) {
        return isAdmin(session) || isStaff(session);
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
    public static boolean canEditOwnTicket(HttpSession session, int ticketUserId) {
        User currentUser = getCurrentUser(session);
        if (currentUser == null) return false;
        
        // Admin và Staff có thể chỉnh sửa tất cả tickets
        if (isAdmin(session) || isStaff(session)) return true;
        
        // Customer chỉ có thể chỉnh sửa ticket của chính mình
        return currentUser.getUserId() == ticketUserId;
    }
} 