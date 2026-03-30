package controller;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import models.UsersEntity;
import models.UsersEntityFacade;

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
