package controller;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import models.ServiceEntityFacade;
import models.UsersEntity;

public class ManagerServicesPageServlet extends ManagerBaseServlet {

    @EJB
    private ServiceEntityFacade serviceFacade;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        UsersEntity currentUser = requireManager(request, response);
        if (currentUser == null) {
            return;
        }

        request.setAttribute("services", serviceFacade.findAllOrdered());
        request.getRequestDispatcher("/Pages/Manager/Services.jsp").forward(request, response);
    }
}
