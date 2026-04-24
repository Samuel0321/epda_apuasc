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
import utils.CountryLoader;
import utils.PasswordValidator;
import utils.hashPassword;
import utils.NotificationService;

public class RegisterServlet extends HttpServlet {

    @EJB
    private UsersEntityFacade userFacade;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        loadCountries(request);
        applyRolePermissions(request);
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        loadCountries(request);

        String name = trim(request.getParameter("name"));
        String email = trim(request.getParameter("email")).toLowerCase();
        String password = trim(request.getParameter("password"));
        String role = normalizeRole(request.getParameter("role"));
        UsersEntity currentUser = getCurrentUser(request);

        if (name.isEmpty() || email.isEmpty() || password.isEmpty() || role.isEmpty()) {
            request.setAttribute("errorMessage", "Name, email, password, and role are required.");
            applyRolePermissions(request);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (!PasswordValidator.isStrong(password)) {
            request.setAttribute("errorMessage", PasswordValidator.REQUIREMENTS_MESSAGE);
            applyRolePermissions(request);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (!isAllowedRegistrationRole(currentUser, role)) {
            request.setAttribute("errorMessage", "You are not allowed to create that account type.");
            applyRolePermissions(request);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (userFacade.emailExists(email)) {
            request.setAttribute("errorMessage", "Email already exists.");
            applyRolePermissions(request);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
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
        user.setRole(role);
        user.setHave_Manager_access(resolveManagerAccess(role, currentUser));

        try {
            userFacade.create(user);
            if (currentUser != null && isManager(currentUser.getRole()) && !"customer".equals(role)) {
                NotificationService.notifyUsers(getServletContext(), extractUserIds(userFacade.findByRoles(java.util.Arrays.asList("manager"))), "staff",
                        "New staff registered",
                        currentUser.getName() + " registered a new " + role + " account for " + user.getName() + ".",
                        request.getContextPath() + "/Pages/Manager/ManageUsers.jsp");
            }
            if (currentUser != null && isManager(currentUser.getRole())) {
                response.sendRedirect(request.getContextPath() + "/Pages/Manager/ManageUsers.jsp?created=1");
            } else {
                response.sendRedirect(request.getContextPath() + "/loginjsp.jsp?registered=1");
            }
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Registration failed.");
            applyRolePermissions(request);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }

    private void loadCountries(HttpServletRequest request) {
        List<CountryLoader.Country> countries = CountryLoader.loadCountries();
        request.setAttribute("countries", countries);
    }

    private void applyRolePermissions(HttpServletRequest request) {
        UsersEntity currentUser = getCurrentUser(request);
        boolean managerSession = currentUser != null && isManager(currentUser.getRole());
        boolean canCreateManager = canGrantManagerAccess(currentUser);

        request.setAttribute("managerRegistration", managerSession);
        request.setAttribute("canCreateManagerAccounts", canCreateManager);
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

    private UsersEntity getCurrentUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null || !(session.getAttribute("user") instanceof UsersEntity)) {
            return null;
        }
        return userFacade.find(((UsersEntity) session.getAttribute("user")).getId());
    }

    private boolean isAllowedRegistrationRole(UsersEntity currentUser, String role) {
        if (role == null || role.isEmpty()) {
            return false;
        }

        if (currentUser == null || !isManager(currentUser.getRole())) {
            return "customer".equals(role);
        }

        if ("receptionist".equals(role) || "technician".equals(role)) {
            return true;
        }
        return "manager".equals(role) && canGrantManagerAccess(currentUser);
    }

    private Integer resolveManagerAccess(String role, UsersEntity currentUser) {
        return 0;
    }

    private boolean canGrantManagerAccess(UsersEntity user) {
        return user != null && user.getHave_Manager_access() != null && user.getHave_Manager_access() == 1;
    }

    private boolean isManager(String role) {
        String normalized = trim(role).toLowerCase();
        return "manager".equals(normalized);
    }

    private String normalizeRole(String role) {
        String normalized = trim(role).toLowerCase();
        if ("counter_staff".equals(normalized)) {
            return "receptionist";
        }
        return normalized;
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }

    private java.util.List<Integer> extractUserIds(java.util.List<UsersEntity> users) {
        java.util.List<Integer> ids = new java.util.ArrayList<Integer>();
        if (users == null) {
            return ids;
        }
        for (UsersEntity user : users) {
            if (user != null && user.getId() != null) {
                ids.add(user.getId());
            }
        }
        return ids;
    }
}
