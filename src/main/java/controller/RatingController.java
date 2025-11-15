package controller;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

import dao.DriverDAO;
import dao.RatingDAO;
import dao.ScheduleDAO;
import dao.TicketDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Driver;
import model.Rating;
import model.Schedule;
import model.Tickets;
import model.User;

@WebServlet(urlPatterns = {"/tickets/rate/*", "/admin/ratings/*"})
public class RatingController extends HttpServlet {

    private RatingDAO ratingDAO;
    private TicketDAO ticketDAO;
    private DriverDAO driverDAO;
    private ScheduleDAO scheduleDAO;

    @Override
    public void init() throws ServletException {
        ratingDAO = new RatingDAO();
        ticketDAO = new TicketDAO();
        driverDAO = new DriverDAO();
        scheduleDAO = new ScheduleDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String servletPath = request.getServletPath();
        String pathInfo = request.getPathInfo();
        if (pathInfo == null)
            pathInfo = "/";

        try {
            if (servletPath.startsWith("/admin")) {
                // Preserve current behavior: admin ratings disabled
                // Require admin auth if needed in future
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            // Public ratings endpoints require auth
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                response.sendRedirect(request.getContextPath()
                        + "/auth/login?error=You need to login to rate drivers");
                return;
            }

            if (pathInfo.equals("/") || pathInfo.isEmpty()) {
                showRatingForm(request, response);
            } else if ("/list".equals(pathInfo)) {
                listUserRatings(request, response);
            } else if ("/edit".equals(pathInfo)) {
                showEditRatingForm(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            handleError(response, "Database error: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String servletPath = request.getServletPath();
        String pathInfo = request.getPathInfo();
        if (pathInfo == null)
            pathInfo = "/";

        try {
            if (servletPath.startsWith("/admin")) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                response.sendRedirect(request.getContextPath()
                        + "/auth/login?error=" + URLEncoder.encode("You need to login to rate drivers", StandardCharsets.UTF_8));
                return;
            }

            if (pathInfo.equals("/") || pathInfo.isEmpty()) {
                submitRating(request, response);
            } else if ("/edit".equals(pathInfo)) {
                updateRating(request, response);
            } else if ("/delete".equals(pathInfo)) {
                deleteRating(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Log the full stack trace
            try {
                response.sendRedirect(request.getContextPath() + 
                        "/tickets?error=" + URLEncoder.encode("Database error: " + e.getMessage(), StandardCharsets.UTF_8));
            } catch (IOException ex) {
                handleError(response, "Database error: " + e.getMessage());
            }
        } catch (Exception e) {
            e.printStackTrace(); // Log any unexpected errors
            try {
                response.sendRedirect(request.getContextPath() + 
                        "/tickets?error=" + URLEncoder.encode("An error occurred: " + e.getMessage(), StandardCharsets.UTF_8));
            } catch (IOException ex) {
                handleError(response, "An error occurred: " + e.getMessage());
            }
        }
    }

    private void showRatingForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        String ticketIdStr = request.getParameter("ticketId");

        if (ticketIdStr == null || ticketIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + 
                    "/tickets?error=" + URLEncoder.encode("Missing information: Ticket ID is required", StandardCharsets.UTF_8));
            return;
        }

        try {
            UUID ticketId = UUID.fromString(ticketIdStr);
            HttpSession session = request.getSession(false);
            User user = (User) session.getAttribute("user");

            // Get ticket details
            Tickets ticket = ticketDAO.getTicketById(ticketId);
            if (ticket == null) {
                response.sendRedirect(request.getContextPath() + 
                        "/tickets?error=" + URLEncoder.encode("Error: Ticket not found with the given ID", StandardCharsets.UTF_8));
                return;
            }

            // Check if user owns this ticket
            if (!ticket.getUserId().equals(user.getUserId())) {
                response.sendRedirect(request.getContextPath() + 
                        "/tickets?error=" + URLEncoder.encode("Error: You can only rate your own tickets", StandardCharsets.UTF_8));
                return;
            }

            // Auto-mark as COMPLETED if arrival time has passed
            try {
                ticketDAO.markCompletedTicketsIfArrivedForUser(user.getUserId());
                ticket = ticketDAO.getTicketById(ticketId); // refresh status
            } catch (SQLException ignored) {
            }

            // Check if ticket is eligible for rating (completed and paid)
            if (!"COMPLETED".equals(ticket.getStatus())
                    || !"PAID".equals(ticket.getPaymentStatus())) {
                response.sendRedirect(request.getContextPath() + 
                        "/tickets?error=" + URLEncoder.encode("Error: Ticket must be completed and paid to rate", StandardCharsets.UTF_8));
                return;
            }

            // Check if user has already rated this ticket
            if (ratingDAO.hasUserRatedTicket(ticketId, user.getUserId())) {
                response.sendRedirect(request.getContextPath() + 
                        "/tickets?error=" + URLEncoder.encode("Error: You have already rated this ticket", StandardCharsets.UTF_8));
                return;
            }

            // Get driver information
            Driver driver = driverDAO.getDriverByScheduleId(ticket.getScheduleId());
            if (driver == null) {
                // Handle case where no driver is assigned to schedule
                String errorMessage =
                        "Error: Driver not found for this trip. Please contact administrator.";
                String encodedMessage = URLEncoder.encode(errorMessage, StandardCharsets.UTF_8);
                response.sendRedirect(request.getContextPath() +
                        "/tickets?error=" + encodedMessage);
                return;
            }

            // Double-check arrival time barrier for safety
            Schedule schedule = scheduleDAO.getScheduleById(ticket.getScheduleId());
            if (schedule == null) {
                response.sendRedirect(request.getContextPath() + 
                        "/tickets?error=" + URLEncoder.encode("Error: Schedule not found for this ticket", StandardCharsets.UTF_8));
                return;
            }
            LocalDateTime arrivalDateTime =
                    schedule.getDepartureDate().atTime(schedule.getEstimatedArrivalTime());
            if (LocalDateTime.now().isBefore(arrivalDateTime)) {
                String errorMessage = "Error: You can only rate after the trip has arrived at the destination.";
                String encodedMessage = URLEncoder.encode(errorMessage, StandardCharsets.UTF_8);
                response.sendRedirect(request.getContextPath() +
                        "/tickets?error=" + encodedMessage);
                return;
            }

            request.setAttribute("ticket", ticket);
            request.setAttribute("driver", driver);
            request.getRequestDispatcher("/views/ratings/rating-form.jsp").forward(request,
                    response);

        } catch (IllegalArgumentException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid ticket ID");
        }
    }

    private void showEditRatingForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        String ratingIdStr = request.getParameter("ratingId");

        if (ratingIdStr == null || ratingIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + 
                    "/tickets/rate/list?error=" + URLEncoder.encode("Missing information: Rating ID is required", StandardCharsets.UTF_8));
            return;
        }

        try {
            UUID ratingId = UUID.fromString(ratingIdStr);
            HttpSession session = request.getSession(false);
            User user = (User) session.getAttribute("user");

            // Get rating details
            Rating rating = ratingDAO.getRatingById(ratingId);
            if (rating == null) {
                response.sendRedirect(request.getContextPath() + 
                        "/tickets/rate/list?error=" + URLEncoder.encode("Error: Rating not found with the given ID", StandardCharsets.UTF_8));
                return;
            }

            // Check if user owns this rating
            if (!rating.getUserId().equals(user.getUserId())) {
                response.sendRedirect(request.getContextPath() + 
                        "/tickets/rate/list?error=" + URLEncoder.encode("Error: You can only edit your own ratings", StandardCharsets.UTF_8));
                return;
            }

            // Get ticket and driver information
            Tickets ticket = ticketDAO.getTicketById(rating.getTicketId());
            Driver driver = driverDAO.getDriverByScheduleId(ticket.getScheduleId());

            request.setAttribute("rating", rating);
            request.setAttribute("ticket", ticket);
            request.setAttribute("driver", driver);
            request.getRequestDispatcher("/views/ratings/rating-edit.jsp").forward(request,
                    response);

        } catch (IllegalArgumentException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid rating ID");
        }
    }

    private void listUserRatings(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        List<Rating> ratings = ratingDAO.getRatingsByUserId(user.getUserId());
        request.setAttribute("ratings", ratings);
        request.getRequestDispatcher("/views/ratings/user-ratings.jsp").forward(request, response);
    }

    private void submitRating(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        String ticketIdStr = request.getParameter("ticketId");
        String ratingValueStr = request.getParameter("ratingValue");
        String comments = request.getParameter("comments");

        // Validate parameters with specific error messages
        if (ticketIdStr == null || ticketIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + 
                    "/tickets?error=" + URLEncoder.encode("Missing information: Ticket ID is required", StandardCharsets.UTF_8));
            return;
        }
        
        if (ratingValueStr == null || ratingValueStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + 
                    "/tickets/rate?ticketId=" + ticketIdStr + 
                    "&error=" + URLEncoder.encode("Missing information: Please select a rating", StandardCharsets.UTF_8));
            return;
        }

        try {
            UUID ticketId = UUID.fromString(ticketIdStr);
            int ratingValue = Integer.parseInt(ratingValueStr);

            // Validate rating value
            if (ratingValue < 1 || ratingValue > 5) {
                response.sendRedirect(request.getContextPath() + 
                        "/tickets/rate?ticketId=" + ticketIdStr + 
                        "&error=" + URLEncoder.encode("Error: Rating must be between 1 and 5", StandardCharsets.UTF_8));
                return;
            }

            // Get ticket details
            Tickets ticket = ticketDAO.getTicketById(ticketId);
            if (ticket == null) {
                response.sendRedirect(request.getContextPath() + 
                        "/tickets?error=" + URLEncoder.encode("Error: Ticket not found with the given ID", StandardCharsets.UTF_8));
                return;
            }

            // Check if user owns this ticket
            if (!ticket.getUserId().equals(user.getUserId())) {
                response.sendRedirect(request.getContextPath() + 
                        "/tickets?error=" + URLEncoder.encode("Error: You can only rate your own tickets", StandardCharsets.UTF_8));
                return;
            }

            // Auto-mark as COMPLETED if arrival time has passed
            try {
                ticketDAO.markCompletedTicketsIfArrivedForUser(user.getUserId());
                ticket = ticketDAO.getTicketById(ticketId); // refresh status
            } catch (SQLException ignored) {
            }

            // Require completed and paid
            if (!"COMPLETED".equals(ticket.getStatus())
                    || !"PAID".equals(ticket.getPaymentStatus())) {
                response.sendRedirect(request.getContextPath() + 
                        "/tickets?error=" + URLEncoder.encode("Error: Ticket must be completed and paid to rate", StandardCharsets.UTF_8));
                return;
            }

            // Get driver information
            Driver driver = driverDAO.getDriverByScheduleId(ticket.getScheduleId());
            if (driver == null) {
                String errorMessage =
                        "Error: Driver not found for this trip. Please contact administrator.";
                String encodedMessage = URLEncoder.encode(errorMessage, StandardCharsets.UTF_8);
                response.sendRedirect(request.getContextPath() +
                        "/tickets?error=" + encodedMessage);
                return;
            }

            // Double-check arrival time barrier for safety
            Schedule schedule = scheduleDAO.getScheduleById(ticket.getScheduleId());
            if (schedule == null) {
                response.sendRedirect(request.getContextPath() + 
                        "/tickets?error=" + URLEncoder.encode("Error: Schedule not found for this ticket", StandardCharsets.UTF_8));
                return;
            }
            
            LocalDateTime arrivalDateTime =
                    schedule.getDepartureDate().atTime(schedule.getEstimatedArrivalTime());
            if (LocalDateTime.now().isBefore(arrivalDateTime)) {
                response.sendRedirect(request.getContextPath() + 
                        "/tickets?error=" + URLEncoder.encode("Error: You can only rate after the trip has arrived at the destination", StandardCharsets.UTF_8));
                return;
            }
            
            // Check if already rated
            if (ratingDAO.hasUserRatedTicket(ticketId, user.getUserId())) {
                response.sendRedirect(request.getContextPath() + 
                        "/tickets?error=" + URLEncoder.encode("Error: You have already rated this ticket", StandardCharsets.UTF_8));
                return;
            }

            // Create rating
            Rating rating = new Rating();
            rating.setTicketId(ticketId);
            rating.setUserId(user.getUserId());
            rating.setDriverId(driver.getDriverId());
            rating.setRatingValue(ratingValue);
            rating.setComments(comments != null && !comments.trim().isEmpty() ? comments.trim() : null);

            // Save rating
            boolean success = ratingDAO.addRating(rating);

            if (success) {
                response.sendRedirect(request.getContextPath() +
                        "/tickets?message=" + URLEncoder.encode("Thank you for your rating! Your feedback helps us improve our service.", StandardCharsets.UTF_8));
            } else {
                response.sendRedirect(request.getContextPath() + 
                        "/tickets/rate?ticketId=" + ticketIdStr + "&error=" + URLEncoder.encode("Error: Failed to save rating. Please try again or contact administrator", StandardCharsets.UTF_8));
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + 
                    "/tickets/rate?ticketId=" + ticketIdStr + "&error=" + URLEncoder.encode("Error: Invalid rating value format. Please enter a number between 1 and 5", StandardCharsets.UTF_8));
        } catch (IllegalArgumentException e) {
            response.sendRedirect(request.getContextPath() + 
                    "/tickets?error=" + URLEncoder.encode("Error: Invalid parameters. " + e.getMessage(), StandardCharsets.UTF_8));
        } catch (SQLException e) {
            e.printStackTrace(); // Log the error
            response.sendRedirect(request.getContextPath() + 
                    "/tickets?error=" + URLEncoder.encode("Error: Database error occurred. " + e.getMessage(), StandardCharsets.UTF_8));
        }
    }

    private void updateRating(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        String ratingIdStr = request.getParameter("ratingId");
        String ratingValueStr = request.getParameter("ratingValue");
        String comments = request.getParameter("comments");

        // Validate parameters with specific error messages
        if (ratingIdStr == null || ratingIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + 
                    "/tickets/rate/list?error=" + URLEncoder.encode("Missing information: Rating ID is required", StandardCharsets.UTF_8));
            return;
        }
        if (ratingValueStr == null || ratingValueStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + 
                    "/tickets/rate/edit?ratingId=" + ratingIdStr + "&error=" + URLEncoder.encode("Missing information: Please select a rating", StandardCharsets.UTF_8));
            return;
        }

        try {
            UUID ratingId = UUID.fromString(ratingIdStr);
            int ratingValue = Integer.parseInt(ratingValueStr);

            // Validate rating value
            if (ratingValue < 1 || ratingValue > 5) {
                response.sendRedirect(request.getContextPath() + 
                        "/tickets/rate/edit?ratingId=" + ratingIdStr + "&error=" + URLEncoder.encode("Error: Rating must be between 1 and 5", StandardCharsets.UTF_8));
                return;
            }

            // Get existing rating
            Rating rating = ratingDAO.getRatingById(ratingId);
            if (rating == null) {
                response.sendRedirect(request.getContextPath() + 
                        "/tickets/rate/list?error=" + URLEncoder.encode("Error: Rating not found with the given ID", StandardCharsets.UTF_8));
                return;
            }

            // Check if user owns this rating
            if (!rating.getUserId().equals(user.getUserId())) {
                response.sendRedirect(request.getContextPath() + 
                        "/tickets/rate/list?error=" + URLEncoder.encode("Error: You can only edit your own ratings", StandardCharsets.UTF_8));
                return;
            }

            // Update rating
            rating.setRatingValue(ratingValue);
            rating.setComments(comments != null ? comments.trim() : null);

            // Save updated rating
            boolean success = ratingDAO.updateRating(rating);

            if (success) {
                response.sendRedirect(request.getContextPath() +
                        "/tickets/rate/list?message=Rating updated successfully! Your rating has been saved");
            } else {
                response.sendRedirect(request.getContextPath() + 
                        "/tickets/rate/edit?ratingId=" + ratingIdStr + "&error=" + URLEncoder.encode("Error: Failed to update rating. Please try again or contact administrator", StandardCharsets.UTF_8));
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + 
                    "/tickets/rate/edit?ratingId=" + ratingIdStr + "&error=" + URLEncoder.encode("Error: Invalid rating value format. Please enter a number between 1 and 5", StandardCharsets.UTF_8));
        } catch (IllegalArgumentException e) {
            response.sendRedirect(request.getContextPath() + 
                    "/tickets/rate/list?error=" + URLEncoder.encode("Error: Invalid rating ID format. Please check again", StandardCharsets.UTF_8));
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + 
                    "/tickets/rate/edit?ratingId=" + ratingIdStr + "&error=" + URLEncoder.encode("Error: An unexpected error occurred. " + e.getMessage(), StandardCharsets.UTF_8));
        }
    }

    private void deleteRating(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        String ratingIdStr = request.getParameter("ratingId");

        if (ratingIdStr == null || ratingIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + 
                    "/tickets/rate/list?error=" + URLEncoder.encode("Missing information: Rating ID is required", StandardCharsets.UTF_8));
            return;
        }

        try {
            UUID ratingId = UUID.fromString(ratingIdStr);

            // Get existing rating
            Rating rating = ratingDAO.getRatingById(ratingId);
            if (rating == null) {
                response.sendRedirect(request.getContextPath() + 
                        "/tickets/rate/list?error=" + URLEncoder.encode("Error: Rating not found with the given ID", StandardCharsets.UTF_8));
                return;
            }

            // Check if user owns this rating
            if (!rating.getUserId().equals(user.getUserId())) {
                response.sendRedirect(request.getContextPath() + 
                        "/tickets/rate/list?error=" + URLEncoder.encode("Error: You can only delete your own ratings", StandardCharsets.UTF_8));
                return;
            }

            // Delete rating
            boolean success = ratingDAO.deleteRating(ratingId);

            if (success) {
                response.sendRedirect(request.getContextPath() +
                        "/tickets/rate/list?message=Rating deleted successfully! Your rating has been removed");
            } else {
                response.sendRedirect(request.getContextPath() + 
                        "/tickets/rate/list?error=" + URLEncoder.encode("Error: Failed to delete rating. Please try again or contact administrator", StandardCharsets.UTF_8));
            }

        } catch (IllegalArgumentException e) {
            response.sendRedirect(request.getContextPath() + 
                    "/tickets/rate/list?error=" + URLEncoder.encode("Error: Invalid rating ID format. Please check again", StandardCharsets.UTF_8));
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + 
                    "/tickets/rate/list?error=" + URLEncoder.encode("Error: An unexpected error occurred while deleting the rating. " + e.getMessage(), StandardCharsets.UTF_8));
        }
    }

    private void handleError(HttpServletResponse response, String message)
            throws ServletException, IOException {
        response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, message);
    }
}
