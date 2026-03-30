package controller;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import models.Appointments;
import models.AppointmentsFacade;
import models.UsersEntity;
import models.UsersEntityFacade;
import utils.NotificationService;

public class AppointmentCancellationServlet extends HttpServlet {

    @EJB
    private AppointmentsFacade appointmentsFacade;

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
        if (currentUser == null) {
            session.invalidate();
            response.sendRedirect(request.getContextPath() + "/loginjsp.jsp");
            return;
        }

        Integer appointmentId = parseInteger(request.getParameter("appointmentId"));
        Appointments appointment = appointmentId == null ? null : appointmentsFacade.find(appointmentId);
        if (appointment == null) {
            response.sendRedirect(request.getContextPath() + "/Pages/Common/Notifications.jsp");
            return;
        }

        String role = trim(currentUser.getRole()).toLowerCase();
        boolean isCustomer = "customer".equals(role);
        boolean isReceptionist = "receptionist".equals(role) || "counter_staff".equals(role);
        if ((isCustomer && !currentUser.getId().equals(appointment.getCustomer_id())) || (!isCustomer && !isReceptionist)) {
            response.sendRedirect(request.getContextPath() + "/loginjsp.jsp");
            return;
        }

        if (!appointmentsFacade.canCancel(appointment)) {
            redirectBack(request, response, isCustomer, "error=InvalidStatus");
            return;
        }

        appointment.setStatus("CANCELLED");
        String actor = isCustomer ? "Customer cancelled the appointment." : "Receptionist cancelled the appointment.";
        appointment.setCounter_staff_comment(actor);
        appointmentsFacade.edit(appointment);

        notifyCancellation(request, appointment, currentUser, isCustomer);
        redirectBack(request, response, isCustomer, "cancelled=1");
    }

    private void notifyCancellation(HttpServletRequest request, Appointments appointment, UsersEntity actor, boolean byCustomer) {
        String customerMsg = byCustomer
                ? "You cancelled appointment #APT" + appointment.getAppointment_id() + "."
                : "Reception cancelled your appointment #APT" + appointment.getAppointment_id() + ".";
        if (appointment.getCustomer_id() != null) {
            NotificationService.notifyUser(getServletContext(), appointment.getCustomer_id(), "appointment",
                    "Appointment cancelled", customerMsg, request.getContextPath() + "/Pages/Customer/MyAppointments.jsp");
        }
        if (appointment.getTechnician_id() != null) {
            NotificationService.notifyUser(getServletContext(), appointment.getTechnician_id(), "appointment",
                    "Appointment cancelled", "Appointment #APT" + appointment.getAppointment_id() + " was cancelled.", request.getContextPath() + "/Pages/Technician/AssignedTasks.jsp");
        }
        NotificationService.notifyUsers(getServletContext(), extractUserIds(userFacade.findByRoles(Arrays.asList("receptionist"))), "appointment",
                "Appointment cancelled", actor.getName() + " cancelled appointment #APT" + appointment.getAppointment_id() + ".", request.getContextPath() + "/Pages/Receptionist/Appointments.jsp");
    }

    private void redirectBack(HttpServletRequest request, HttpServletResponse response, boolean customer, String query) throws IOException {
        response.sendRedirect(request.getContextPath() + (customer ? "/Pages/Customer/MyAppointments.jsp?" : "/Pages/Receptionist/Appointments.jsp?") + query);
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

    private List<Integer> extractUserIds(List<UsersEntity> users) {
        List<Integer> ids = new ArrayList<Integer>();
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
