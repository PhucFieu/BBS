package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import dao.RouteDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Routes;
import model.User;

@WebServlet(name = "HomeController", urlPatterns = { "", "/home" })
public class HomeController extends HttpServlet {

    private RouteDAO routeDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        routeDAO = new RouteDAO();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response) throws ServletException, IOException {
        
        try {
            HttpSession session = request.getSession(false);
            User user = (session != null) ? (User) session.getAttribute("user") : null;
            List<Routes> routes = routeDAO.getAllRoutes();
            List<Routes> popularRoutes = routeDAO.getPopularRoutes();
            request.setAttribute("routes", routes);
            request.setAttribute("popularRoutes", popularRoutes);
            if (user != null && "USER".equals(user.getRole())) {
                request.getRequestDispatcher("/views/user/user-homepage.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("/index.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/views/errors/error.jsp").forward(request, response);
        } catch (ServletException | IOException e) {
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/views/errors/error.jsp").forward(request, response);
        }
    }
}
