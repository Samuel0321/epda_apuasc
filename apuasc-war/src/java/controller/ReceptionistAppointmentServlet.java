package controller;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalTime;
import models.Appointments;
import models.AppointmentsFacade;
import models.UsersEntity;
import models.UsersEntityFacade;
import utils.NotificationService;

public class ReceptionistAppointmentServlet extends HttpServlet {

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
        if (currentUser == null || !canManageAppointments(currentUser)) {
            response.sendRedirect(request.getContextPath() + "/loginjsp.jsp");
            return;
        }

        Integer customerId = parseInteger(request.getParameter("customer"));
        Integer technicianId = parseInteger(request.getParameter("technician"));
        String bookingType = trim(request.getParameter("serviceType")).toLowerCase();

        UsersEntity customer = customerId == null ? null : userFacade.find(customerId);

        if (customer == null || !isValidBookingType(bookingType) || !"customer".equalsIgnoreCase(trim(customer.getRole()))) {
            response.sendRedirect(request.getContextPath() + "/Pages/Receptionist/NewAppointment.jsp?error=InvalidSelection");
            return;
        }

        LocalDate appointmentDate = parseDate(request.getParameter("appointmentDate"));
        LocalTime appointmentTime = parseTime(request.getParameter("appointmentTime"));
        if (appointmentDate == null || appointmentTime == null) {
            response.sendRedirect(request.getContextPath() + "/Pages/Receptionist/NewAppointment.jsp?error=DateTimeRequired");
            return;
        }
        if (!isQuarterHourSlot(appointmentTime)) {
            response.sendRedirect(request.getContextPath() + "/Pages/Receptionist/NewAppointment.jsp?error=DateTimeRequired");
            return;
        }
        if (!isWithinBusinessHours(appointmentTime)) {
            response.sendRedirect(request.getContextPath() + "/Pages/Receptionist/NewAppointment.jsp?error=DateTimeRequired");
            return;
        }
        if (appointmentsFacade.isPastAppointmentSlot(appointmentDate, appointmentTime)) {
            response.sendRedirect(request.getContextPath() + "/Pages/Receptionist/NewAppointment.jsp?error=PastDateTime");
            return;
        }
        if (appointmentsFacade.existsByCustomerDateTime(customer.getId(), appointmentDate, appointmentTime)) {
            response.sendRedirect(request.getContextPath() + "/Pages/Receptionist/NewAppointment.jsp?error=DuplicateSlot");
            return;
        }

        if (technicianId != null) {
            UsersEntity technician = userFacade.find(technicianId);
            if (technician == null || !"technician".equalsIgnoreCase(trim(technician.getRole()))) {
                response.sendRedirect(request.getContextPath() + "/Pages/Receptionist/NewAppointment.jsp?error=InvalidTechnician");
                return;
            }

            int requestedDurationHours = appointmentsFacade.estimateBookingTypeDurationHours(bookingType);
            if (appointmentsFacade.hasTechnicianConflict(technicianId, appointmentDate, appointmentTime, requestedDurationHours, null)) {
                response.sendRedirect(request.getContextPath() + "/Pages/Receptionist/NewAppointment.jsp?error=TechnicianBusy");
                return;
            }
        }

        Appointments appointment = new Appointments();
        appointment.setCustomer_id(customer.getId());
        appointment.setTechnician_id(technicianId);
        appointment.setAppointment_date(appointmentDate);
        appointment.setAppointment_time(appointmentTime);
        appointment.setStatus(technicianId == null ? "PENDING" : "ASSIGNED");
        appointment.setTotal_amount(BigDecimal.ZERO);
        appointment.setCustomer_notes(trim(request.getParameter("notes")));
        appointment.setTechnician_notes("");
        appointment.setCustomer_feedback("");
        appointment.setCounter_staff_comment(appointmentsFacade.buildInitialBookingComment(bookingType,
                technicianId == null
                        ? "Appointment created by receptionist. Technician assignment is still pending."
                        : "Appointment created by receptionist and technician assignment was confirmed."));
        appointmentsFacade.create(appointment);

        String slotText = appointmentDate + " " + appointmentTime;
        String bookingLabel = appointmentsFacade.getBookingTypeLabel(appointment.getCounter_staff_comment());
        NotificationService.notifyUser(getServletContext(), currentUser.getId(), "appointment",
                "Appointment created",
                "You created " + bookingLabel + " for " + customer.getName() + " at " + slotText + ".",
                request.getContextPath() + "/Pages/Receptionist/Appointments.jsp");
        NotificationService.notifyUser(getServletContext(), customer.getId(), "appointment",
                "Appointment confirmation",
                "Reception scheduled your " + bookingLabel + " appointment for " + slotText + ".",
                request.getContextPath() + "/Pages/Customer/MyAppointments.jsp");
        if (technicianId != null) {
            NotificationService.notifyUser(getServletContext(), technicianId, "appointment",
                    "New technician assignment",
                    "You were assigned to " + customer.getName() + "'s " + bookingLabel + " appointment at " + slotText + ".",
                    request.getContextPath() + "/Pages/Technician/AssignedTasks.jsp");
        }

        response.sendRedirect(request.getContextPath() + "/Pages/Receptionist/NewAppointment.jsp?created=1");
    }

    private boolean canManageAppointments(UsersEntity user) {
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

    private LocalDate parseDate(String value) {
        try {
            return value == null || value.trim().isEmpty() ? null : LocalDate.parse(value.trim());
        } catch (Exception ex) {
            return null;
        }
    }

    private LocalTime parseTime(String value) {
        try {
            return value == null || value.trim().isEmpty() ? null : LocalTime.parse(value.trim());
        } catch (Exception ex) {
            return null;
        }
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }

    private boolean isValidBookingType(String bookingType) {
        return "minor".equals(bookingType) || "major".equals(bookingType);
    }

    private boolean isQuarterHourSlot(LocalTime value) {
        if (value == null) {
            return false;
        }
        int minute = value.getMinute();
        return minute == 0 || minute == 15 || minute == 30 || minute == 45;
    }

    private boolean isWithinBusinessHours(LocalTime value) {
        if (value == null) {
            return false;
        }
        LocalTime start = LocalTime.of(10, 0);
        LocalTime end = LocalTime.of(16, 0);
        return !value.isBefore(start) && !value.isAfter(end);
    }
}
