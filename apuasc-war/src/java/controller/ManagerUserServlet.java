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

public class ManagerUserServlet extends HttpServlet {

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
        if (currentUser == null || !canAccessManagerPages(currentUser)) {
            response.sendRedirect(request.getContextPath() + "/loginjsp.jsp");
            return;
        }

        String action = trim(request.getParameter("action"));
        Integer userId = parseInteger(request.getParameter("userId"));
        UsersEntity targetUser = userId == null ? null : userFacade.find(userId);

        if (targetUser == null) {
            redirect(response, request, "error=UserNotFound");
            return;
        }

        switch (action) {
            case "update":
                handleUpdate(request, response, currentUser, targetUser);
                break;
            case "delete":
                handleDelete(request, response, currentUser, targetUser);
                break;
            case "toggleManagerAccess":
                handleToggleManagerAccess(request, response, currentUser, targetUser);
                break;
            default:
                redirect(response, request, "error=InvalidAction");
                break;
        }
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response,
            UsersEntity currentUser, UsersEntity targetUser) throws IOException {
        if (isProtectedManagerAccount(targetUser) && !canToggleManagerAccess(currentUser)) {
            redirect(response, request, "error=ProtectedManager");
            return;
        }

        String role = normalizeRole(request.getParameter("role"));
        if (role.isEmpty()) {
            role = targetUser.getRole() == null ? "receptionist" : normalizeRole(targetUser.getRole());
        }

        if ("manager".equals(role) && !canToggleManagerAccess(currentUser)) {
            redirect(response, request, "error=ManagerAccessRequired");
            return;
        }

        String newEmail = trim(request.getParameter("email"));
        UsersEntity existing = userFacade.findByEmail(newEmail);
        if (existing != null && !existing.getId().equals(targetUser.getId())) {
            redirect(response, request, "error=DuplicateEmail");
            return;
        }

        targetUser.setName(trim(request.getParameter("name")));
        targetUser.setEmail(newEmail);
        targetUser.setPhone_number(trim(request.getParameter("phone")));
        targetUser.setGender(trim(request.getParameter("gender")));
        targetUser.setOrigin_country(trim(request.getParameter("origin_country")));
        targetUser.setHome_address(trim(request.getParameter("home_address")));
        targetUser.setRole(role);

        if (!"manager".equals(role)) {
            targetUser.setHave_Manager_access(0);
        }

        userFacade.edit(targetUser);
        redirect(response, request, "updated=1");
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response,
            UsersEntity currentUser, UsersEntity targetUser) throws IOException {
        if (targetUser.getId().equals(currentUser.getId())) {
            redirect(response, request, "error=DeleteSelf");
            return;
        }
        userFacade.remove(targetUser);
        redirect(response, request, "deleted=1");
    }

    private void handleToggleManagerAccess(HttpServletRequest request, HttpServletResponse response,
            UsersEntity currentUser, UsersEntity targetUser) throws IOException {
        if (!canToggleManagerAccess(currentUser)) {
            redirect(response, request, "error=ManagerAccessRequired");
            return;
        }
        if (!"manager".equals(trim(targetUser.getRole()).toLowerCase()) || targetUser.getId().equals(currentUser.getId())) {
            redirect(response, request, "error=ProtectedUser");
            return;
        }

        int current = targetUser.getHave_Manager_access() == null ? 0 : targetUser.getHave_Manager_access();
        targetUser.setHave_Manager_access(current == 1 ? 0 : 1);
        userFacade.edit(targetUser);
        redirect(response, request, "accessUpdated=1");
    }

    private boolean canAccessManagerPages(UsersEntity user) {
        String role = user.getRole() == null ? "" : user.getRole().trim().toLowerCase();
        return "manager".equals(role);
    }

    private boolean canToggleManagerAccess(UsersEntity user) {
        return user.getHave_Manager_access() != null && user.getHave_Manager_access() == 1;
    }

    private boolean isProtectedManagerAccount(UsersEntity user) {
        return user != null
                && "manager".equals(normalizeRole(user.getRole()))
                && user.getHave_Manager_access() != null
                && user.getHave_Manager_access() == 1;
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

    private String normalizeRole(String value) {
        String normalized = trim(value).toLowerCase();
        if ("counter_staff".equals(normalized)) {
            return "receptionist";
        }
        return normalized;
    }

    private void redirect(HttpServletResponse response, HttpServletRequest request, String query) throws IOException {
        response.sendRedirect(request.getContextPath() + "/Pages/Manager/ManageUsers.jsp?" + query);
    }
}
