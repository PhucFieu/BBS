package controller;

import dao.BusDAO;
import dao.DriverDAO;
import dao.RouteDAO;
import dao.ScheduleDAO;
import dao.ScheduleStopDAO;
import dao.StationDAO;
import dao.TicketDAO;
import dao.UserDAO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import model.User;

/**
 * Base class for admin controllers with common authentication and DAO initialization
 */
public abstract class AdminBaseController {
    protected UserDAO userDAO;
    protected RouteDAO routeDAO;
    protected BusDAO busDAO;
    protected StationDAO stationDAO;
    protected ScheduleDAO scheduleDAO;
    protected ScheduleStopDAO scheduleStopDAO;
    protected TicketDAO ticketDAO;
    protected DriverDAO driverDAO;

    /**
     * Initialize DAOs - should be called in init() or constructor
     */
    protected void initializeDAOs() {
        userDAO = new UserDAO();
        routeDAO = new RouteDAO();
        busDAO = new BusDAO();
        stationDAO = new StationDAO();
        scheduleDAO = new ScheduleDAO();
        scheduleStopDAO = new ScheduleStopDAO();
        ticketDAO = new TicketDAO();
        driverDAO = new DriverDAO();
    }

    /**
     * Check if the current user is authenticated as admin
     */
    protected boolean isAdminAuthenticated(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            return false;
        }

        User user = (User) session.getAttribute("user");
        return "ADMIN".equals(user.getRole());
    }

    /**
     * Get current user from session
     */
    protected User getCurrentUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }
        return (User) session.getAttribute("user");
    }
}

