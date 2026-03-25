package controller;

import jakarta.ejb.EJB;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.UsersEntity;
import utils.SidebarService;
import java.util.List;
import utils.NavItem;

public class ReceptionistDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/loginjsp.jsp");
            return;
        }

        UsersEntity user = (UsersEntity) session.getAttribute("user");
        String role = user.getRole();

        // Populate menu if not already set
        if (session.getAttribute("menu") == null) {
            List<NavItem> menu = SidebarService.getMenu(role);
            session.setAttribute("menu", menu);
        }

        // Forward to ReceptionistDashboard JSP
        request.getRequestDispatcher("/Dashboard/ReceptionistDashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
