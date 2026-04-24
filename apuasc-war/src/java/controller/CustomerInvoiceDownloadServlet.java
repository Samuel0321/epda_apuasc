package controller;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Base64;
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

public class CustomerInvoiceDownloadServlet extends HttpServlet {

    @EJB
    private AppointmentsFacade appointmentsFacade;

    @EJB
    private AppointmentServiceFacade appointmentServiceFacade;

    @EJB
    private ServiceEntityFacade serviceFacade;

    @EJB
    private UsersEntityFacade userFacade;

    @EJB
    private PaymentRecordFacade paymentRecordFacade;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !(session.getAttribute("user") instanceof UsersEntity)) {
            response.sendRedirect(request.getContextPath() + "/loginjsp.jsp");
            return;
        }

        UsersEntity currentUser = userFacade.find(((UsersEntity) session.getAttribute("user")).getId());
        if (currentUser == null || !canDownloadInvoice(currentUser)) {
            response.sendRedirect(request.getContextPath() + "/loginjsp.jsp");
            return;
        }

        Integer appointmentId = parseInteger(request.getParameter("appointmentId"));
        Appointments appointment = appointmentId == null ? null : appointmentsFacade.find(appointmentId);
        if (appointment == null || appointment.getCustomer_id() == null) {
            response.sendRedirect(request.getContextPath() + "/Pages/Customer/PaymentHistory.jsp?error=InvalidInvoice");
            return;
        }

        String currentRole = trim(currentUser.getRole()).toLowerCase();
        boolean customerDownload = "customer".equals(currentRole);
        if (customerDownload && !appointment.getCustomer_id().equals(currentUser.getId())) {
            response.sendRedirect(request.getContextPath() + "/Pages/Customer/PaymentHistory.jsp?error=InvalidInvoice");
            return;
        }
        UsersEntity customer = userFacade.find(appointment.getCustomer_id());
        if (customer == null) {
            response.sendRedirect(request.getContextPath() + "/Pages/Customer/PaymentHistory.jsp?error=InvalidInvoice");
            return;
        }

        String invoiceNumber = "INV-APT" + appointment.getAppointment_id();
        PaymentRecord paymentRecord = paymentRecordFacade.findByInvoiceNumber(invoiceNumber);
        List<String> serviceNames = new ArrayList<String>();
        for (AppointmentService link : appointmentServiceFacade.findByAppointmentId(appointment.getAppointment_id())) {
            ServiceEntity service = link == null || link.getService_id() == null ? null : serviceFacade.find(link.getService_id());
            if (service != null && service.getService_name() != null && !service.getService_name().trim().isEmpty()) {
                serviceNames.add(service.getService_name().trim());
            }
        }

        response.setContentType("text/html; charset=UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + invoiceNumber + ".html\"");
        String logoDataUri = loadLogoDataUri();

        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html><head><meta charset=\"UTF-8\"><title>" + escape(invoiceNumber) + "</title>");
            out.println("<style>");
            out.println("body{font-family:'Segoe UI',sans-serif;background:#f8fafc;color:#0f172a;padding:32px;}");
            out.println(".invoice{max-width:820px;margin:0 auto;background:#fff;border:1px solid #e2e8f0;border-radius:18px;padding:32px;}");
            out.println(".top{display:flex;justify-content:space-between;align-items:flex-start;gap:20px;margin-bottom:28px;}");
            out.println(".brand-wrap{display:flex;align-items:center;gap:12px;}");
            out.println(".brand-logo{width:46px;height:46px;object-fit:contain;border:1px solid #e2e8f0;border-radius:10px;padding:4px;background:#fff;}");
            out.println(".brand{font-size:28px;font-weight:700;}");
            out.println(".muted{color:#64748b;font-size:14px;}");
            out.println(".grid{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:16px;margin-bottom:24px;}");
            out.println(".card{background:#f8fafc;border:1px solid #e2e8f0;border-radius:14px;padding:16px;}");
            out.println(".card strong{display:block;margin-bottom:8px;}");
            out.println(".services{margin-bottom:24px;}");
            out.println(".services ul{margin:10px 0 0 20px;}");
            out.println(".summary{border-top:1px solid #e2e8f0;padding-top:20px;display:grid;gap:10px;}");
            out.println(".row{display:flex;justify-content:space-between;gap:20px;}");
            out.println(".total{font-size:22px;font-weight:700;}");
            out.println("</style></head><body><div class=\"invoice\">");
            out.println("<div class=\"top\"><div><div class=\"brand-wrap\">");
            if (!logoDataUri.isEmpty()) {
                out.println("<img class=\"brand-logo\" src=\"" + logoDataUri + "\" alt=\"APU ASC Logo\">");
            }
            out.println("<div><div class=\"brand\">APU ASC</div><div class=\"muted\">Customer Invoice</div></div></div></div>");
            out.println("<div style=\"text-align:right\"><div><strong>" + escape(invoiceNumber) + "</strong></div>");
            out.println("<div class=\"muted\">Generated " + escape(java.time.LocalDate.now().toString()) + "</div></div></div>");

            out.println("<div class=\"grid\">");
            out.println("<div class=\"card\"><strong>Customer</strong><div>" + escape(customer.getName()) + "</div><div class=\"muted\">" + escape(nullToDash(customer.getEmail())) + "</div></div>");
            out.println("<div class=\"card\"><strong>Appointment</strong><div>#APT" + appointment.getAppointment_id() + "</div><div class=\"muted\">"
                    + escape(String.valueOf(appointment.getAppointment_date())) + " | "
                    + escape(String.valueOf(appointment.getAppointment_time())) + " - "
                    + escape(String.valueOf(appointmentsFacade.estimateAppointmentEndTime(appointment))) + "</div></div>");
            out.println("</div>");

            out.println("<div class=\"card services\"><strong>Service Bundle</strong><ul>");
            if (serviceNames.isEmpty()) {
                out.println("<li>Service Request</li>");
            } else {
                for (String serviceName : serviceNames) {
                    out.println("<li>" + escape(serviceName) + "</li>");
                }
            }
            out.println("</ul></div>");

            out.println("<div class=\"summary\">");
            out.println("<div class=\"row\"><span>Status</span><span>" + escape(normalizeStatus(appointment.getStatus())) + "</span></div>");
            out.println("<div class=\"row\"><span>Payment Method</span><span>Cash at counter</span></div>");
            if (paymentRecord != null && paymentRecord.getPayment_date() != null) {
                out.println("<div class=\"row\"><span>Payment Date</span><span>" + escape(paymentRecord.getPayment_date().format(DateTimeFormatter.ISO_LOCAL_DATE)) + "</span></div>");
            }
            if (paymentRecord != null && paymentRecord.getReceipt_number() != null) {
                out.println("<div class=\"row\"><span>Receipt</span><span>" + escape(paymentRecord.getReceipt_number()) + "</span></div>");
            }
            out.println("<div class=\"row total\"><span>Total</span><span>RM " + escape(formatAmount(appointment.getTotal_amount())) + "</span></div>");
            out.println("</div>");

            out.println("<div class=\"card\"><strong>Note</strong><div>"
                    + escape(appointment.getCounter_staff_comment() == null || appointment.getCounter_staff_comment().trim().isEmpty()
                            ? "Please refer to the receptionist for payment confirmation and invoice assistance."
                            : appointment.getCounter_staff_comment().trim())
                    + "</div></div>");

            out.println("</div></body></html>");
        }
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

    private boolean canDownloadInvoice(UsersEntity user) {
        String role = trim(user.getRole()).toLowerCase();
        return "customer".equals(role)
                || "receptionist".equals(role)
                || "counter_staff".equals(role)
                || "manager".equals(role)
                || "admin".equals(role)
                || "super_admin".equals(role);
    }

    private String normalizeStatus(String value) {
        return value == null || value.trim().isEmpty() ? "-" : value.trim().toUpperCase();
    }

    private String formatAmount(BigDecimal amount) {
        return amount == null ? "0.00" : amount.toPlainString();
    }

    private String nullToDash(String value) {
        return value == null || value.trim().isEmpty() ? "-" : value.trim();
    }

    private String escape(String value) {
        if (value == null) {
            return "";
        }
        return value.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;");
    }

    private String loadLogoDataUri() {
        try (InputStream in = getServletContext().getResourceAsStream("/Icon/APUASC.png")) {
            if (in == null) {
                return "";
            }

            ByteArrayOutputStream buffer = new ByteArrayOutputStream();
            byte[] chunk = new byte[4096];
            int read;
            while ((read = in.read(chunk)) != -1) {
                buffer.write(chunk, 0, read);
            }

            String base64 = Base64.getEncoder().encodeToString(buffer.toByteArray());
            return "data:image/png;base64," + base64;
        } catch (IOException ex) {
            return "";
        }
    }
}
