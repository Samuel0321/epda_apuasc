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
import models.AppointmentService;
import models.AppointmentServiceFacade;
import models.Appointments;
import models.AppointmentsFacade;
import models.ServiceEntity;
import models.ServiceEntityFacade;
import models.UsersEntity;
import models.UsersEntityFacade;
import utils.NotificationService;

public class CustomerBookingServlet extends HttpServlet {

    @EJB
    private AppointmentsFacade appointmentsFacade;

    @EJB
    private AppointmentServiceFacade appointmentServiceFacade;

    @EJB
    private ServiceEntityFacade serviceFacade;

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

        String bookingType = trim(request.getParameter("serviceType")).toLowerCase();
        if (!"minor".equals(bookingType) && !"major".equals(bookingType)) {
            response.sendRedirect(request.getContextPath() + "/Pages/Customer/BookAppointment.jsp?error=ServiceRequired");
            return;
        }

        ServiceEntity service = serviceFacade.findOrCreateBookingType(bookingType);
        if (service == null) {
            response.sendRedirect(request.getContextPath() + "/Pages/Customer/BookAppointment.jsp?error=ServiceRequired");
            return;
        }

        LocalDate appointmentDate = parseDate(request.getParameter("appointmentDate"));
        LocalTime appointmentTime = parseTime(request.getParameter("appointmentTime"));
        if (appointmentDate == null || appointmentTime == null) {
            response.sendRedirect(request.getContextPath() + "/Pages/Customer/BookAppointment.jsp?error=DateTimeRequired");
            return;
        }
        if (!isQuarterHourSlot(appointmentTime)) {
            response.sendRedirect(request.getContextPath() + "/Pages/Customer/BookAppointment.jsp?error=DateTimeRequired");
            return;
        }
        if (!isWithinBusinessHours(appointmentTime)) {
            response.sendRedirect(request.getContextPath() + "/Pages/Customer/BookAppointment.jsp?error=DateTimeRequired");
            return;
        }
        if (appointmentsFacade.isPastAppointmentSlot(appointmentDate, appointmentTime)) {
            response.sendRedirect(request.getContextPath() + "/Pages/Customer/BookAppointment.jsp?error=PastDateTime");
            return;
        }

        if (appointmentsFacade.existsByCustomerDateTime(currentUser.getId(), appointmentDate, appointmentTime)) {
            response.sendRedirect(request.getContextPath() + "/Pages/Customer/BookAppointment.jsp?error=DuplicateSlot");
            return;
        }

        Appointments appointment = new Appointments();
        appointment.setCustomer_id(currentUser.getId());
        appointment.setTechnician_id(null);
        appointment.setAppointment_date(appointmentDate);
        appointment.setAppointment_time(appointmentTime);
        appointment.setStatus("PENDING");
        appointment.setTotal_amount(BigDecimal.ZERO);
        appointment.setCustomer_notes(trim(request.getParameter("notes")));
        appointment.setTechnician_notes("");
        appointment.setCustomer_feedback("");
        appointment.setCounter_staff_comment("Booking received. Technician inspection and quotation will be prepared after assignment.");
        appointmentsFacade.create(appointment);

        AppointmentService appointmentService = new AppointmentService();
        appointmentService.setAppointment_id(appointment.getAppointment_id());
        appointmentService.setService_id(service.getId());
        appointmentService.setService_price(service.getPrice());
        appointmentServiceFacade.create(appointmentService);

        String appointmentLink = request.getContextPath() + "/Pages/Customer/MyAppointments.jsp";
        String slotText = appointmentDate + " " + appointmentTime;
        NotificationService.notifyUser(getServletContext(), currentUser.getId(), "appointment",
                "Appointment booked successfully",
                "Your " + service.getService_name() + " appointment was received for " + slotText + ". Reception will review it shortly.",
                appointmentLink);
        NotificationService.notifyUsers(getServletContext(), extractUserIds(userFacade.findByRoles(java.util.Arrays.asList("receptionist"))), "appointment",
                "New customer appointment received",
                currentUser.getName() + " booked " + service.getService_name() + " for " + slotText + ".",
                request.getContextPath() + "/Pages/Receptionist/Appointments.jsp");

        response.sendRedirect(request.getContextPath() + "/Pages/Customer/MyAppointments.jsp?booked=1");
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
