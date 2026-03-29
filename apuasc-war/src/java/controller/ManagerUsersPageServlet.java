package controller;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import models.UsersEntity;
import models.UsersEntityFacade;

public class ManagerUsersPageServlet extends ManagerBaseServlet {

    @EJB
    private UsersEntityFacade userFacade;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        UsersEntity currentUser = requireManager(request, response);
        if (currentUser == null) {
            return;
        }

        currentUser = userFacade.find(currentUser.getId());
        request.getSession().setAttribute("user", currentUser);
        request.setAttribute("currentUser", currentUser);
        request.setAttribute("staffUsers", userFacade.findStaffUsers());
        request.setAttribute("canToggleManagerAccess",
                currentUser.getHave_Manager_access() != null && currentUser.getHave_Manager_access() == 1);
        request.getRequestDispatcher("/Pages/Manager/ManageUsers.jsp").forward(request, response);
    }
}
