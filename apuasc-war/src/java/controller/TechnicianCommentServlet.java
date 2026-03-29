package controller;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;
import models.Appointments;
import models.AppointmentsFacade;
import models.UsersEntity;
import models.UsersEntityFacade;
import models.AppointmentServiceFacade;

public class TechnicianCommentServlet extends HttpServlet {

    @EJB
    private AppointmentsFacade appointmentsFacade;

    @EJB
    private UsersEntityFacade userFacade;

    @EJB
    private AppointmentServiceFacade appointmentServiceFacade;

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
        String action = trim(request.getParameter("action")).toLowerCase();
        Appointments appointment = appointmentId == null ? null : appointmentsFacade.find(appointmentId);
        if (appointment == null || appointment.getTechnician_id() == null || !appointment.getTechnician_id().equals(currentUser.getId())) {
            response.sendRedirect(request.getContextPath() + "/Pages/Technician/AssignedTasks.jsp?error=InvalidAppointment");
            return;
        }

        if ("completerepair".equals(action)) {
            String status = appointment.getStatus() == null ? "" : appointment.getStatus().trim().toUpperCase();
            if (!"ACCEPTED".equals(status) && !"DELAYED".equals(status)) {
                response.sendRedirect(request.getContextPath() + "/Pages/Technician/AssignedTasks.jsp?error=InvalidStatus");
                return;
            }

            appointment.setStatus("COMPLETED");
            appointment.setCounter_staff_comment("Repair work completed. Please find receptionist at the counter for payment and vehicle collection.");
            appointmentsFacade.edit(appointment);
            response.sendRedirect(request.getContextPath() + "/Pages/Technician/AssignedTasks.jsp?completed=1");
            return;
        }

        if ("delayrepair".equals(action)) {
            String status = appointment.getStatus() == null ? "" : appointment.getStatus().trim().toUpperCase();
            if (!"ACCEPTED".equals(status) && !"DELAYED".equals(status)) {
                response.sendRedirect(request.getContextPath() + "/Pages/Technician/AssignedTasks.jsp?error=InvalidStatus");
                return;
            }

            Integer extraHours = parseInteger(request.getParameter("extraHours"));
            String delayReason = trim(request.getParameter("delayReason"));
            if (extraHours == null || extraHours <= 0 || delayReason.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/Pages/Technician/AssignedTasks.jsp?error=InvalidDelay");
                return;
            }

            int baseDurationHours = appointmentServiceFacade.estimateAppointmentDurationHours(appointment.getAppointment_id());
            LocalDateTime delayedEnd = LocalDateTime.of(appointment.getAppointment_date(), appointment.getAppointment_time())
                    .plusHours(Math.max(1, baseDurationHours + extraHours));

            appointment.setStatus("DELAYED");
            appointment.setTechnician_notes(delayReason);
            appointment.setCounter_staff_comment(appointmentsFacade.buildDelayedComment(extraHours,
                    "Repair is delayed and needs about " + extraHours + " more hour(s) to complete. Reception may reassign upcoming appointments if needed."));
            appointmentsFacade.edit(appointment);

            List<Appointments> technicianAppointments = appointmentsFacade.findByTechnicianId(currentUser.getId());
            for (Appointments impacted : technicianAppointments) {
                if (impacted == null || impacted.getAppointment_id() == null || impacted.getAppointment_id().equals(appointment.getAppointment_id())) {
                    continue;
                }
                if (impacted.getAppointment_date() == null || impacted.getAppointment_time() == null) {
                    continue;
                }
                if (!appointment.getAppointment_date().equals(impacted.getAppointment_date())) {
                    continue;
                }

                String impactedStatus = impacted.getStatus() == null ? "" : impacted.getStatus().trim().toUpperCase();
                if (!"ASSIGNED".equals(impactedStatus) && !"WAITING APPROVAL".equals(impactedStatus) && !"ACCEPTED".equals(impactedStatus)) {
                    continue;
                }

                LocalDateTime impactedStart = LocalDateTime.of(impacted.getAppointment_date(), impacted.getAppointment_time());
                if (!impactedStart.isAfter(LocalDateTime.of(appointment.getAppointment_date(), appointment.getAppointment_time()))
                        || !impactedStart.isBefore(delayedEnd)) {
                    continue;
                }

                impacted.setStatus("DELAYED");
                impacted.setCounter_staff_comment("Your appointment is delayed because the previous repair needs more time. Reception may reassign another technician or contact you with an updated slot.");
                appointmentsFacade.edit(impacted);
            }

            response.sendRedirect(request.getContextPath() + "/Pages/Technician/AssignedTasks.jsp?delayed=1");
            return;
        }

        appointment.setTechnician_notes(trim(request.getParameter("technicianNotes")));
        appointmentsFacade.edit(appointment);
        response.sendRedirect(request.getContextPath() + "/Pages/Technician/AssignedTasks.jsp?updated=1");
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
