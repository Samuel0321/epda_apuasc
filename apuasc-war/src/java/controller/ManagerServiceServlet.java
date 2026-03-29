package controller;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import models.ServiceEntity;
import models.ServiceEntityFacade;
import models.UsersEntity;

public class ManagerServiceServlet extends HttpServlet {

    @EJB
    private ServiceEntityFacade serviceFacade;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !(session.getAttribute("user") instanceof UsersEntity)) {
            response.sendRedirect(request.getContextPath() + "/loginjsp.jsp");
            return;
        }

        UsersEntity currentUser = (UsersEntity) session.getAttribute("user");
        String role = currentUser.getRole() == null ? "" : currentUser.getRole().trim().toLowerCase();
        if (!("manager".equals(role) || "admin".equals(role) || "super_admin".equals(role))) {
            response.sendRedirect(request.getContextPath() + "/loginjsp.jsp");
            return;
        }

        String action = trim(request.getParameter("action"));
        if ("delete".equals(action)) {
            Integer serviceId = parseInteger(request.getParameter("serviceId"));
            ServiceEntity service = serviceId == null ? null : serviceFacade.find(serviceId);
            if (service != null) {
                serviceFacade.remove(service);
            }
            response.sendRedirect(request.getContextPath() + "/Pages/Manager/Services.jsp?deleted=1");
            return;
        }

        if ("create".equals(action) || "update".equals(action)) {
            ServiceEntity service;
            if ("update".equals(action)) {
                Integer serviceId = parseInteger(request.getParameter("serviceId"));
                service = serviceId == null ? null : serviceFacade.find(serviceId);
                if (service == null) {
                    response.sendRedirect(request.getContextPath() + "/Pages/Manager/Services.jsp?error=ServiceNotFound");
                    return;
                }
            } else {
                service = new ServiceEntity();
            }

            service.setService_name(trim(request.getParameter("service_name")));
            service.setDescription(trim(request.getParameter("description")));
            service.setPrice(parseAmount(request.getParameter("price")));
            service.setActive("1".equals(trim(request.getParameter("active"))) ? 1 : 0);

            if ("create".equals(action)) {
                serviceFacade.create(service);
                response.sendRedirect(request.getContextPath() + "/Pages/Manager/Services.jsp?created=1");
            } else {
                serviceFacade.edit(service);
                response.sendRedirect(request.getContextPath() + "/Pages/Manager/Services.jsp?updated=1");
            }
            return;
        }

        response.sendRedirect(request.getContextPath() + "/Pages/Manager/Services.jsp?error=InvalidAction");
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }

    private Integer parseInteger(String value) {
        try {
            return value == null || value.trim().isEmpty() ? null : Integer.valueOf(value.trim());
        } catch (NumberFormatException ex) {
            return null;
        }
    }

    private BigDecimal parseAmount(String value) {
        try {
            return new BigDecimal(trim(value));
        } catch (Exception ex) {
            return BigDecimal.ZERO;
        }
    }
}
