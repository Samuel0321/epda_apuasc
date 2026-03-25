package controller;

import jakarta.ejb.EJB;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.UsersEntity;
import models.UsersEntityFacade;
import utils.SidebarService;
import java.util.List;
import utils.NavItem;

public class ManagerDashboardServlet extends HttpServlet {

    @EJB
    private UsersEntityFacade userFacade;

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

        // Get user list for manager dashboard
        if (userFacade != null) {
            List<UsersEntity> userList = userFacade.findAll();
            request.setAttribute("userList", userList);
        }

        // Forward to ManagerDashboard JSP
        request.getRequestDispatcher("/Dashboard/ManagerDashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
