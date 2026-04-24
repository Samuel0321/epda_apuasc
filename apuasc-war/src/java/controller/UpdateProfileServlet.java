package controller;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import models.UsersEntity;
import models.UsersEntityFacade;
import utils.PasswordValidator;
import utils.hashPassword;

public class UpdateProfileServlet extends HttpServlet {

    @EJB
    private UsersEntityFacade userFacade;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/loginjsp.jsp");
            return;
        }

        UsersEntity sessionUser = (UsersEntity) session.getAttribute("user");
        UsersEntity user = userFacade.find(sessionUser.getId());
        if (user == null) {
            session.invalidate();
            response.sendRedirect(request.getContextPath() + "/loginjsp.jsp");
            return;
        }

        user.setName(trim(request.getParameter("name")));
        user.setEmail(trim(request.getParameter("email")));
        user.setPhone_number(trim(request.getParameter("phone")));
        user.setGender(trim(request.getParameter("gender")));
        user.setOrigin_country(trim(request.getParameter("origin_country")));
        user.setHome_address(trim(request.getParameter("home_address")));

        String identity = trim(request.getParameter("identity_number"));
        if (!identity.isEmpty()) {
            user.setIC_number_passportnumber(identity);
        }

        String newPassword = trim(request.getParameter("new_password"));
        if (!newPassword.isEmpty()) {
            if (!PasswordValidator.isStrong(newPassword)) {
                response.sendRedirect(request.getContextPath() + "/Pages/Common/Profile.jsp?error=WeakPassword");
                return;
            }
            user.setPassword(hashPassword.hashPassword(newPassword));
        }

        userFacade.edit(user);
        session.setAttribute("user", user);

        response.sendRedirect(request.getContextPath() + "/Pages/Common/Profile.jsp?updated=1");
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }
}
