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
import utils.NavItem;
import utils.SidebarService;
import utils.hashPassword;

public class LoginServlet extends HttpServlet {

    @EJB
    private UsersEntityFacade userFacade;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/loginjsp.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = trim(request.getParameter("email")).toLowerCase();
        String password = trim(request.getParameter("password"));

        if (email.isEmpty() || password.isEmpty()) {
            request.setAttribute("errorMessage", "Email and password are required.");
            request.getRequestDispatcher("/loginjsp.jsp").forward(request, response);
            return;
        }

        UsersEntity user = userFacade.findByEmail(email);
        String hashedPassword = hashPassword.hashPassword(password);

        if (user == null || user.getPassword() == null || !user.getPassword().equals(hashedPassword)) {
            request.setAttribute("errorMessage", "Invalid email or password.");
            request.getRequestDispatcher("/loginjsp.jsp").forward(request, response);
            return;
        }

        HttpSession session = request.getSession(true);
        session.setAttribute("user", user);

        List<NavItem> menu = SidebarService.getMenu(user.getRole());
        session.setAttribute("menu", menu);

        response.sendRedirect(request.getContextPath() + getDashboardPath(user.getRole()));
    }

    private String getDashboardPath(String role) {
        if (role == null) {
            return "/loginjsp.jsp";
        }

        String normalizedRole = role.trim().toLowerCase();
        switch (normalizedRole) {
            case "receptionist":
            case "counter_staff":
                return "/Dashboard/ReceptionistDashboard.jsp";
            case "technician":
                return "/Dashboard/TechnicianDashboard.jsp";
            case "manager":
            case "super_admin":
                return "/Dashboard/ManagerDashboard.jsp";
            case "admin":
                return "/Dashboard/ManagerDashboard.jsp";
            case "customer":
                return "/Dashboard/CustomerDashboard.jsp";
            default:
                return "/loginjsp.jsp";
        }
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }
}
