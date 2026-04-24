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
import utils.NotificationService;

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
            appointment.setCounter_staff_comment(appointmentsFacade.preserveSchedulingMetadata(
                    appointment.getCounter_staff_comment(),
                    "Repair work completed. Please find receptionist at the counter for payment and vehicle collection."));
            appointmentsFacade.edit(appointment);
            notifyRelevantParties(request, appointment, currentUser,
                    "Repair completed",
                    "Repair for appointment #APT" + appointment.getAppointment_id() + " is completed and ready for payment.",
                    "Your repair is completed. Please find receptionist at the counter for payment and vehicle collection.");
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

            int baseDurationHours = appointmentsFacade.estimateReservedDurationHours(appointment)
                    - appointmentsFacade.extractDelayHours(appointment.getCounter_staff_comment());
            LocalDateTime delayedEnd = LocalDateTime.of(appointment.getAppointment_date(), appointment.getAppointment_time())
                    .plusHours(Math.max(1, baseDurationHours + extraHours));

            appointment.setStatus("DELAYED");
            appointment.setTechnician_notes(delayReason);
            appointment.setCounter_staff_comment(appointmentsFacade.buildDelayedComment(
                    appointment.getCounter_staff_comment(),
                    extraHours,
                    "Repair is delayed and needs about " + extraHours + " more hour(s) to complete. Reception may reassign upcoming appointments if needed."));
            appointmentsFacade.edit(appointment);
            notifyRelevantParties(request, appointment, currentUser,
                    "Repair delayed",
                    "Repair for appointment #APT" + appointment.getAppointment_id() + " was marked delayed and needs about " + extraHours + " more hour(s).",
                    "Your repair needs about " + extraHours + " more hour(s) to complete.");

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

                if ("ASSIGNED".equals(impactedStatus)) {
                    impacted.setCounter_staff_comment(appointmentsFacade.preserveSchedulingMetadata(
                            impacted.getCounter_staff_comment(),
                            "Inspection may start later because the earlier repair needs more time. Reception should consider another technician before quotation preparation."));
                } else {
                    impacted.setStatus("DELAYED");
                    impacted.setCounter_staff_comment(appointmentsFacade.preserveSchedulingMetadata(
                            impacted.getCounter_staff_comment(),
                            "Your appointment is delayed because the previous repair needs more time. Reception may reassign another technician or contact you with an updated slot."));
                }
                appointmentsFacade.edit(impacted);
                if (impacted.getCustomer_id() != null) {
                    NotificationService.notifyUser(getServletContext(), impacted.getCustomer_id(), "appointment",
                            "ASSIGNED".equals(impactedStatus) ? "Inspection schedule affected" : "Appointment delayed",
                            "ASSIGNED".equals(impactedStatus)
                                    ? "Your inspection may start later because the technician is delayed on an earlier repair. Reception may assign another technician before preparing your quotation."
                                    : "Your appointment is delayed because the previous repair needs more time. Reception may reassign another technician or update your slot.",
                            request.getContextPath() + "/Pages/Customer/MyAppointments.jsp");
                }
                NotificationService.notifyUsers(getServletContext(), extractUserIds(userFacade.findByRoles(java.util.Arrays.asList("receptionist"))), "appointment",
                        "ASSIGNED".equals(impactedStatus) ? "Inspection schedule affected" : "Appointment delayed",
                        "ASSIGNED".equals(impactedStatus)
                                ? "Appointment #APT" + impacted.getAppointment_id() + " may need technician reassignment before quotation because an earlier repair is delayed."
                                : "Appointment #APT" + impacted.getAppointment_id() + " was delayed because the previous repair needs more time.",
                        request.getContextPath() + "/Pages/Receptionist/Appointments.jsp");
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

    private void notifyRelevantParties(HttpServletRequest request, Appointments appointment, UsersEntity technician,
            String title, String staffMessage, String customerMessage) {
        NotificationService.notifyUser(getServletContext(), technician.getId(), "appointment",
                title, "You updated appointment #APT" + appointment.getAppointment_id() + ".",
                request.getContextPath() + "/Pages/Technician/AssignedTasks.jsp");
        if (appointment.getCustomer_id() != null) {
            NotificationService.notifyUser(getServletContext(), appointment.getCustomer_id(), "appointment",
                    title, customerMessage, request.getContextPath() + "/Pages/Customer/MyAppointments.jsp");
        }
        NotificationService.notifyUsers(getServletContext(), extractUserIds(userFacade.findByRoles(java.util.Arrays.asList("receptionist"))), "appointment",
                title, staffMessage, request.getContextPath() + "/Pages/Receptionist/Appointments.jsp");
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
