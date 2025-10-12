package controller;

import java.io.IOException;

import dao.RoutesDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "HomeController", urlPatterns = { "", "/home" })
public class HomeController extends HttpServlet {

    private RoutesDAO routeDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        routeDAO = new RoutesDAO();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response) throws ServletException, IOException {
        System.out.println("HomeController: Processing GET request");
        try {
            // Forward đến trang index.jsp
            request
                    .getRequestDispatcher("/index.jsp")
                    .forward(request, response);
        } catch (ServletException | IOException e) {
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request
                    .getRequestDispatcher("/views/error.jsp")
                    .forward(request, response);
        }
    }
}
