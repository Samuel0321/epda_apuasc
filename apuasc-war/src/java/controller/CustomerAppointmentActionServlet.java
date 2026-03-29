package controller;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import models.Appointments;
import models.AppointmentsFacade;
import models.UsersEntity;
import models.UsersEntityFacade;

public class CustomerAppointmentActionServlet extends HttpServlet {

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
        String action = normalize(request.getParameter("action"));
        Appointments appointment = appointmentId == null ? null : appointmentsFacade.find(appointmentId);

        if (appointment == null || appointment.getCustomer_id() == null || !appointment.getCustomer_id().equals(currentUser.getId())) {
            response.sendRedirect(request.getContextPath() + "/Pages/Customer/MyAppointments.jsp?error=InvalidAppointment");
            return;
        }

        if ("SAVE_FEEDBACK".equals(action)) {
            String normalizedStatus = normalize(appointment.getStatus());
            if (!"PAID".equals(normalizedStatus)) {
                response.sendRedirect(request.getContextPath() + "/Pages/Customer/MyAppointments.jsp?error=InvalidStatus");
                return;
            }

            String feedback = trim(request.getParameter("feedback"));
            if (feedback.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/Pages/Customer/MyAppointments.jsp?error=FeedbackRequired");
                return;
            }

            appointment.setCustomer_feedback(feedback);
            appointmentsFacade.edit(appointment);
            response.sendRedirect(request.getContextPath() + "/Pages/Customer/MyAppointments.jsp?feedbackSaved=1");
            return;
        }

        if (!"WAITING APPROVAL".equals(normalize(appointment.getStatus()))) {
            response.sendRedirect(request.getContextPath() + "/Pages/Customer/MyAppointments.jsp?error=InvalidStatus");
            return;
        }

        if ("ACCEPT".equals(action)) {
            appointment.setStatus("ACCEPTED");
            appointment.setCounter_staff_comment("Customer accepted the quotation. Repair work can begin.");
            appointmentsFacade.edit(appointment);
            response.sendRedirect(request.getContextPath() + "/Pages/Customer/MyAppointments.jsp?updated=1");
            return;
        }

        if ("REJECT".equals(action)) {
            appointment.setStatus("REJECTED");
            appointment.setCounter_staff_comment("Customer rejected the quotation and requested revision before proceeding.");
            appointmentsFacade.edit(appointment);
            response.sendRedirect(request.getContextPath() + "/Pages/Customer/MyAppointments.jsp?updated=1");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/Pages/Customer/MyAppointments.jsp?error=InvalidAction");
    }

    private Integer parseInteger(String value) {
        try {
            return value == null || value.trim().isEmpty() ? null : Integer.valueOf(value.trim());
        } catch (NumberFormatException ex) {
            return null;
        }
    }

    private String normalize(String value) {
        return value == null ? "" : value.trim().toUpperCase();
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }
}
