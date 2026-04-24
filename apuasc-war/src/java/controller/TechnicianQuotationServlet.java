package controller;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import models.AppointmentService;
import models.AppointmentServiceFacade;
import models.Appointments;
import models.AppointmentsFacade;
import models.ServiceEntity;
import models.ServiceEntityFacade;
import models.UsersEntity;
import models.UsersEntityFacade;
import utils.NotificationService;

public class TechnicianQuotationServlet extends HttpServlet {

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

        Integer appointmentId = parseInteger(request.getParameter("appointmentId"));
        Appointments appointment = appointmentId == null ? null : appointmentsFacade.find(appointmentId);
        if (appointment == null || appointment.getTechnician_id() == null || !appointment.getTechnician_id().equals(currentUser.getId())) {
            response.sendRedirect(request.getContextPath() + "/Pages/Technician/AssignedTasks.jsp?error=InvalidAppointment");
            return;
        }
        String appointmentStatus = appointment.getStatus() == null ? "" : appointment.getStatus().trim().toUpperCase();
        if (!"ASSIGNED".equals(appointmentStatus)) {
            response.sendRedirect(request.getContextPath() + "/Pages/Technician/AssignedTasks.jsp?error=InvalidStatus");
            return;
        }
        if (appointmentsFacade.hasEarlierUnfinishedAppointment(currentUser.getId(), appointment)) {
            response.sendRedirect(request.getContextPath() + "/Pages/Technician/AssignedTasks.jsp?error=FinishPreviousFirst");
            return;
        }

        String[] selectedServiceIds = request.getParameterValues("serviceIds");
        if (selectedServiceIds == null || selectedServiceIds.length == 0) {
            response.sendRedirect(request.getContextPath() + "/Pages/Technician/AssignedTasks.jsp?error=SelectService");
            return;
        }

        appointmentServiceFacade.deleteByAppointmentId(appointment.getAppointment_id());

        BigDecimal total = BigDecimal.ZERO;
        for (String serviceIdValue : selectedServiceIds) {
            Integer serviceId = parseInteger(serviceIdValue);
            ServiceEntity service = serviceId == null ? null : serviceFacade.find(serviceId);
            if (service == null) {
                continue;
            }

            AppointmentService link = new AppointmentService();
            link.setAppointment_id(appointment.getAppointment_id());
            link.setService_id(service.getId());
            link.setService_price(service.getPrice());
            appointmentServiceFacade.create(link);

            if (service.getPrice() != null) {
                total = total.add(service.getPrice());
            }
        }

        appointment.setTechnician_notes(trim(request.getParameter("technicianNotes")));
        appointment.setTotal_amount(total);
        appointment.setStatus("WAITING APPROVAL");
        appointment.setCounter_staff_comment(appointmentsFacade.preserveSchedulingMetadata(
                appointment.getCounter_staff_comment(),
                "Technician prepared the quotation. Awaiting customer decision before repair work begins."));
        appointmentsFacade.edit(appointment);

        UsersEntity customer = appointment.getCustomer_id() == null ? null : userFacade.find(appointment.getCustomer_id());
        String customerName = customer == null ? "Customer" : customer.getName();
        NotificationService.notifyUser(getServletContext(), currentUser.getId(), "appointment",
                "Quotation submitted",
                "Your quotation for " + customerName + " was sent successfully.",
                request.getContextPath() + "/Pages/Technician/AssignedTasks.jsp");
        if (customer != null) {
            NotificationService.notifyUser(getServletContext(), customer.getId(), "appointment",
                    "Quotation ready for review",
                    "Your technician prepared a quotation. Please review and accept or reject it.",
                    request.getContextPath() + "/Pages/Customer/MyAppointments.jsp");
        }
        NotificationService.notifyUsers(getServletContext(), extractUserIds(userFacade.findByRoles(java.util.Arrays.asList("receptionist"))), "appointment",
                "Quotation prepared",
                "Quotation for " + customerName + " is ready for customer review.",
                request.getContextPath() + "/Pages/Receptionist/Appointments.jsp");

        response.sendRedirect(request.getContextPath() + "/Pages/Technician/AssignedTasks.jsp?quoted=1");
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
