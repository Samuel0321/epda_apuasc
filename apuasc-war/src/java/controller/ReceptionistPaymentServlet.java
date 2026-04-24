package controller;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import models.AppointmentService;
import models.AppointmentServiceFacade;
import models.Appointments;
import models.AppointmentsFacade;
import models.PaymentRecord;
import models.PaymentRecordFacade;
import models.ServiceEntity;
import models.ServiceEntityFacade;
import models.UsersEntity;
import models.UsersEntityFacade;
import utils.NotificationService;

public class ReceptionistPaymentServlet extends HttpServlet {

    @EJB
    private AppointmentsFacade appointmentsFacade;

    @EJB
    private UsersEntityFacade userFacade;

    @EJB
    private AppointmentServiceFacade appointmentServiceFacade;

    @EJB
    private ServiceEntityFacade serviceFacade;

    @EJB
    private PaymentRecordFacade paymentRecordFacade;

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

        String role = currentUser.getRole() == null ? "" : currentUser.getRole().trim().toLowerCase();
        if (!"receptionist".equals(role) && !"counter_staff".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/loginjsp.jsp");
            return;
        }

        Integer appointmentId = parseInteger(request.getParameter("appointmentId"));
        Appointments appointment = appointmentId == null ? null : appointmentsFacade.find(appointmentId);
        if (appointment == null) {
            response.sendRedirect(request.getContextPath() + "/Pages/Receptionist/Payments.jsp?error=InvalidAppointment");
            return;
        }

        String status = normalize(appointment.getStatus());
        if (!"UNPAID".equals(status) && !"COMPLETED".equals(status)) {
            response.sendRedirect(request.getContextPath() + "/Pages/Receptionist/Payments.jsp?error=InvalidStatus");
            return;
        }

        appointment.setStatus("PAID");
        String existingComment = appointment.getCounter_staff_comment() == null ? "" : appointment.getCounter_staff_comment().trim();
    String operatorName = currentUser.getName() == null || currentUser.getName().trim().isEmpty()
        ? "counter staff"
        : currentUser.getName().trim();
    String paymentComment = "Cash payment collected by " + operatorName + " at "
        + LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm")) + ".";
        appointment.setCounter_staff_comment(existingComment.isEmpty() ? paymentComment : existingComment + " " + paymentComment);
        appointmentsFacade.edit(appointment);

        PaymentRecord paymentRecord = new PaymentRecord();
        paymentRecord.setAppointment_id(appointment.getAppointment_id());
        paymentRecord.setUser_id(appointment.getCustomer_id());
        paymentRecord.setInvoice_number("INV-APT" + appointment.getAppointment_id());
        paymentRecord.setReceipt_number("RCPT-" + appointment.getAppointment_id() + "-" + LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmm")));
        paymentRecord.setService_name(resolveServiceNames(appointment.getAppointment_id()));
        paymentRecord.setAmount(appointment.getTotal_amount() == null ? BigDecimal.ZERO : appointment.getTotal_amount());
        paymentRecord.setStatus("paid");
        paymentRecord.setPayment_date(LocalDateTime.now().toLocalDate());
        paymentRecord.setReceived_by_user_id(currentUser.getId());
        paymentRecordFacade.create(paymentRecord);

        NotificationService.notifyUser(getServletContext(), currentUser.getId(), "payment",
                "Payment recorded",
                "You recorded payment for appointment #APT" + appointment.getAppointment_id() + ".",
                request.getContextPath() + "/Pages/Receptionist/Payments.jsp");
        if (appointment.getCustomer_id() != null) {
            NotificationService.notifyUser(getServletContext(), appointment.getCustomer_id(), "payment",
                    "Payment confirmation",
                    "Your payment for appointment #APT" + appointment.getAppointment_id() + " was received successfully.",
                    request.getContextPath() + "/Pages/Customer/MyAppointments.jsp");
        }
        NotificationService.notifyUsers(getServletContext(), extractUserIds(userFacade.findByRoles(java.util.Arrays.asList("manager"))), "payment",
                "Payment received",
                "Payment for appointment #APT" + appointment.getAppointment_id() + " was recorded by " + operatorName + ".",
                request.getContextPath() + "/Pages/Manager/Payments.jsp");

        response.sendRedirect(request.getContextPath() + "/Pages/Receptionist/Payments.jsp?paid=1");
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

    private String resolveServiceNames(Integer appointmentId) {
        List<AppointmentService> links = appointmentId == null ? new ArrayList<AppointmentService>() : appointmentServiceFacade.findByAppointmentId(appointmentId);
        List<String> names = new ArrayList<String>();
        for (AppointmentService link : links) {
            ServiceEntity service = link == null || link.getService_id() == null ? null : serviceFacade.find(link.getService_id());
            if (service != null && service.getService_name() != null && !service.getService_name().trim().isEmpty()) {
                names.add(service.getService_name().trim());
            }
        }
        return names.isEmpty() ? "Service Request" : String.join(", ", names);
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
