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

public class ReceptionistCustomerProfileServlet extends HttpServlet {

    @EJB
    private UsersEntityFacade userFacade;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !(session.getAttribute("user") instanceof UsersEntity)) {
            response.sendRedirect(request.getContextPath() + "/loginjsp.jsp");
            return;
        }

        UsersEntity currentUser = userFacade.find(((UsersEntity) session.getAttribute("user")).getId());
        if (currentUser == null || !canManageCustomers(currentUser)) {
            response.sendRedirect(request.getContextPath() + "/loginjsp.jsp");
            return;
        }

        Integer customerId = parseInteger(request.getParameter("customerId"));
        UsersEntity customer = customerId == null ? null : userFacade.find(customerId);
        if (customer == null || !"customer".equalsIgnoreCase(trim(customer.getRole()))) {
            response.sendRedirect(request.getContextPath() + "/Pages/Receptionist/ManageCustomers.jsp?error=CustomerNotFound");
            return;
        }

        String email = trim(request.getParameter("email")).toLowerCase();
        UsersEntity existing = userFacade.findByEmail(email);
        if (existing != null && !existing.getId().equals(customer.getId())) {
            response.sendRedirect(request.getContextPath() + "/Pages/Receptionist/EditCustomer.jsp?id=" + customer.getId() + "&error=DuplicateEmail");
            return;
        }

        customer.setName(trim(request.getParameter("name")));
        customer.setEmail(email);
        customer.setPhone_number(trim(request.getParameter("phone")));
        customer.setGender(trim(request.getParameter("gender")));
        customer.setIs_malaysian(parseInteger(request.getParameter("is_malaysian")));
        customer.setOrigin_country(trim(request.getParameter("origin_country")));
        customer.setCountry_code(parseInteger(request.getParameter("country_code")));
        customer.setIC_number_passportnumber(trim(request.getParameter("identity_number")));
        customer.setHome_address(trim(request.getParameter("home_address")));

        String newPassword = trim(request.getParameter("new_password"));
        if (!newPassword.isEmpty()) {
            if (!PasswordValidator.isStrong(newPassword)) {
                response.sendRedirect(request.getContextPath() + "/Pages/Receptionist/EditCustomer.jsp?id=" + customer.getId() + "&error=WeakPassword");
                return;
            }
            customer.setPassword(hashPassword.hashPassword(newPassword));
        }

        userFacade.edit(customer);
        response.sendRedirect(request.getContextPath() + "/Pages/Receptionist/EditCustomer.jsp?id=" + customer.getId() + "&updated=1");
    }

    private boolean canManageCustomers(UsersEntity user) {
        String role = trim(user.getRole()).toLowerCase();
        return "receptionist".equals(role) || "counter_staff".equals(role);
    }

    private Integer parseInteger(String value) {
        try {
            return value == null || value.trim().isEmpty() ? null : Integer.valueOf(value.trim());
        } catch (NumberFormatException ex) {
            return null;
        }
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }
}
