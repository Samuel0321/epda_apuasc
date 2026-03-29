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
        appointment.setCounter_staff_comment("Technician prepared the quotation. Awaiting customer decision before repair work begins.");
        appointmentsFacade.edit(appointment);

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
}
