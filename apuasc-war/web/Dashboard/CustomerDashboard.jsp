<%@page import="java.math.BigDecimal,java.util.ArrayList,java.util.Arrays,java.util.HashMap,java.util.List,java.util.Map,models.AppointmentService,models.AppointmentServiceFacade,models.Appointments,models.AppointmentsFacade,models.ServiceEntity,models.ServiceEntityFacade,models.UsersEntity,models.UsersEntityFacade,utils.EjbLookup"%>
<%
    UsersEntity currentUser = (UsersEntity) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/loginjsp.jsp");
        return;
    }

    UsersEntityFacade userFacade = EjbLookup.lookup(UsersEntityFacade.class, "UsersEntityFacade");
    AppointmentsFacade appointmentsFacade = EjbLookup.lookup(AppointmentsFacade.class, "AppointmentsFacade");
    AppointmentServiceFacade appointmentServiceFacade = EjbLookup.lookup(AppointmentServiceFacade.class, "AppointmentServiceFacade");
    ServiceEntityFacade serviceFacade = EjbLookup.lookup(ServiceEntityFacade.class, "ServiceEntityFacade");

    currentUser = userFacade.find(currentUser.getId());
    session.setAttribute("user", currentUser);

    List<Appointments> allAppointments = appointmentsFacade.findByCustomerId(currentUser.getId());
    List<String> activeStatuses = Arrays.asList("PENDING", "ASSIGNED", "WAITING APPROVAL", "ACCEPTED", "DELAYED", "REJECTED");
    List<String> completedStatuses = Arrays.asList("COMPLETED", "UNPAID", "PAID");
    List<String> pendingPaymentStatuses = Arrays.asList("UNPAID");

    long activeCount = appointmentsFacade.countByCustomerIdAndStatuses(currentUser.getId(), activeStatuses);
    long completedCount = appointmentsFacade.countByCustomerIdAndStatuses(currentUser.getId(), completedStatuses);
    long pendingPaymentCount = appointmentsFacade.countByCustomerIdAndStatuses(currentUser.getId(), pendingPaymentStatuses);

    Map<Integer, String> serviceNamesByAppointment = new HashMap<>();
    for (Appointments appointment : allAppointments) {
        List<AppointmentService> links = appointmentServiceFacade.findByAppointmentId(appointment.getAppointment_id());
        List<String> names = new ArrayList<>();
        for (AppointmentService link : links) {
            ServiceEntity service = serviceFacade.find(link.getService_id());
            if (service != null) {
                names.add(service.getService_name());
            }
        }
        serviceNamesByAppointment.put(appointment.getAppointment_id(),
                names.isEmpty() ? appointmentsFacade.getBookingTypeLabel(appointment.getCounter_staff_comment()) : String.join(", ", names));
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Customer Dashboard</title>
    <link rel="stylesheet" href="../Styles/main.css">
    <style>
        .dashboard-empty {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 16px;
            padding: 18px 0;
        }

        .empty-badge {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-width: 92px;
            padding: 8px 14px;
            border-radius: 999px;
            background: #e2e8f0;
            color: #475569;
            font-size: 12px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.04em;
        }
    </style>
</head>
<body>
<div class="layout">
    <jsp:include page="../Component/Sidebar.jsp" />

    <div class="main">
        <jsp:include page="../Component/Topbar.jsp">
            <jsp:param name="section" value="CUSTOMER PORTAL" />
        </jsp:include>

        <div class="header-row">
            <div class="header-text">
                <h1>Customer Dashboard</h1>
                <p>Track your saved bookings, completed services, and payment status from the database.</p>
            </div>
            <div class="actions">
                <button class="btn btn-primary" onclick="window.location.href='../Pages/Customer/BookAppointment.jsp'">+ Book Appointment</button>
            </div>
        </div>

        <div class="cards">
            <div class="card">
                <h2><%= activeCount %></h2>
                <p>Active Appointments</p>
            </div>

            <div class="card">
                <h2><%= completedCount %></h2>
                <p>Completed Services</p>
            </div>

            <div class="card">
                <h2><%= pendingPaymentCount %></h2>
                <p>Pending Payments</p>
            </div>
        </div>

        <div class="queue">
            <h3>My Latest Appointments</h3>
            <p class="sub">Recent booking records saved under your account</p>

            <% if (allAppointments.isEmpty()) { %>
                <div class="dashboard-empty">
                    <div>
                        <strong>No appointments yet</strong><br>
                        <small>Your new bookings will appear here.</small>
                    </div>
                    <span class="empty-badge">Empty</span>
                </div>
            <% } else {
                int shown = 0;
                for (Appointments appointment : allAppointments) {
                    if (shown >= 4) {
                        break;
                    }
                    shown++;
            %>
                <div class="queue-item">
                    <div>
                        <strong><%= serviceNamesByAppointment.get(appointment.getAppointment_id()) %></strong><br>
                        <small><%= appointment.getAppointment_date() %> | <%= appointment.getAppointment_time() %> - <%= appointmentsFacade.estimateAppointmentEndTime(appointment) %></small>
                    </div>
                    <span class="status waiting"><%= displayCustomerStatus(appointment.getStatus()) %></span>
                </div>
            <%  }
               } %>
        </div>
    </div>
</div>
</body>
</html>
<%!
    private String displayCustomerStatus(String status) {
        if (status == null) {
            return "-";
        }
        String normalized = status.trim().toUpperCase();
        switch (normalized) {
            case "PENDING": return "Pending Review";
            case "ASSIGNED": return "Inspection Assigned";
            case "WAITING APPROVAL": return "Quotation Ready";
            case "ACCEPTED": return "Repair In Progress";
            case "DELAYED": return "Repair Delayed";
            case "REJECTED": return "Quotation Rejected";
            case "COMPLETED": return "Ready For Payment";
            case "UNPAID": return "Payment Pending";
            case "PAID": return "Paid";
            default: return normalized;
        }
    }
%>
