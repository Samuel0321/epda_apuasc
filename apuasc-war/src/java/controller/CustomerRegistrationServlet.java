package controller;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import models.UsersEntity;
import models.UsersEntityFacade;
import utils.CountryLoader;
import utils.hashPassword;

public class CustomerRegistrationServlet extends HttpServlet {

    @EJB
    private UsersEntityFacade userFacade;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        loadCountries(request);
        request.getRequestDispatcher("/Pages/Receptionist/RegisterCustomer.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        loadCountries(request);

        String email = trim(request.getParameter("email")).toLowerCase();
        String password = trim(request.getParameter("password"));
        String name = trim(request.getParameter("name"));

        if (name.isEmpty() || email.isEmpty() || password.isEmpty()) {
            request.setAttribute("errorMessage", "Name, email, and password are required.");
            request.getRequestDispatcher("/Pages/Receptionist/RegisterCustomer.jsp").forward(request, response);
            return;
        }

        if (userFacade.emailExists(email)) {
            request.setAttribute("errorMessage", "A customer with that email already exists.");
            request.getRequestDispatcher("/Pages/Receptionist/RegisterCustomer.jsp").forward(request, response);
            return;
        }

        UsersEntity user = new UsersEntity();
        user.setName(name);
        user.setEmail(email);
        user.setPassword(hashPassword.hashPassword(password));
        user.setGender(trim(request.getParameter("gender")));
        user.setIs_malaysian(parseInteger(request.getParameter("is_malaysian"), 1));
        user.setOrigin_country(trim(request.getParameter("origin_country")));
        user.setCountry_code(parseNullableInteger(request.getParameter("country_code")));
        user.setPhone_number(trim(request.getParameter("phone")));
        user.setIC_number_passportnumber(resolveIdentity(request));
        user.setHome_address(trim(request.getParameter("user_address")));
        user.setRole("customer");
        user.setHave_Manager_access(0);
        user.setIs_Super_Admin(0);

        try {
            userFacade.create(user);
            response.sendRedirect(request.getContextPath() + "/Pages/Receptionist/RegisterCustomer.jsp?success=1");
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Customer registration failed.");
            request.getRequestDispatcher("/Pages/Receptionist/RegisterCustomer.jsp").forward(request, response);
        }
    }

    private void loadCountries(HttpServletRequest request) {
        List<CountryLoader.Country> countries = CountryLoader.loadCountries();
        request.setAttribute("countries", countries);
    }

    private String resolveIdentity(HttpServletRequest request) {
        String ic = trim(request.getParameter("ic_passport"));
        if (!ic.isEmpty()) {
            return ic;
        }
        return trim(request.getParameter("passport_number"));
    }

    private Integer parseNullableInteger(String value) {
        try {
            if (value == null || value.trim().isEmpty()) {
                return null;
            }
            return Integer.valueOf(value.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private Integer parseInteger(String value, Integer defaultValue) {
        Integer parsed = parseNullableInteger(value);
        return parsed == null ? defaultValue : parsed;
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }
}
