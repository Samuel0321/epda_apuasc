package controller;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import models.UsersEntity;

public abstract class ManagerBaseServlet extends HttpServlet {

    protected UsersEntity requireManager(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !(session.getAttribute("user") instanceof UsersEntity)) {
            response.sendRedirect(request.getContextPath() + "/loginjsp.jsp");
            return null;
        }

        UsersEntity user = (UsersEntity) session.getAttribute("user");
        String role = user.getRole() == null ? "" : user.getRole().trim().toLowerCase();
        if (!"manager".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/loginjsp.jsp");
            return null;
        }
        return user;
    }
}
