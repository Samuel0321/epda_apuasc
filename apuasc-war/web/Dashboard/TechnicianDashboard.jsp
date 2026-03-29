<%@page import="java.util.ArrayList,java.util.List,models.AppointmentService,models.AppointmentServiceFacade,models.Appointments,models.AppointmentsFacade,models.ServiceEntity,models.ServiceEntityFacade,models.UsersEntity,models.UsersEntityFacade,utils.EjbLookup"%>
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
    List<Appointments> appointments = appointmentsFacade.findQuotationWorkflowByTechnicianId(currentUser.getId());
    long assignedCount = 0, waitingApprovalCount = 0, followUpCount = 0;
    for (Appointments appointment : appointments) {
        String status = appointment.getStatus() == null ? "" : appointment.getStatus().trim().toUpperCase();
        if ("ASSIGNED".equals(status)) assignedCount++;
        if ("WAITING APPROVAL".equals(status)) waitingApprovalCount++;
        if ("ACCEPTED".equals(status) || "DELAYED".equals(status) || "COMPLETED".equals(status) || "UNPAID".equals(status) || "PAID".equals(status)) followUpCount++;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Technician Dashboard</title>
    <link rel="stylesheet" href="../Styles/main.css">
</head>
<body>
<div class="layout">
    <jsp:include page="../Component/Sidebar.jsp" />
    <div class="main">
        <jsp:include page="../Component/Topbar.jsp"><jsp:param name="section" value="TECHNICIAN PANEL" /></jsp:include>
        <div class="header-row">
            <div class="header-text">
                <h1>Technician Dashboard</h1>
                <p>Track inspection work, quotation responses, repairs in progress, and payment-ready jobs.</p>
            </div>
            <div class="actions">
                <button class="btn btn-light" onclick="window.location.href='../Pages/Technician/Schedule.jsp'">Schedule</button>
                <button class="btn btn-primary" onclick="window.location.href='../Pages/Technician/AssignedTasks.jsp'">Assigned Tasks</button>
            </div>
        </div>
        <div class="cards">
            <div class="card"><h2><%= assignedCount %></h2><p>Assigned For Inspection</p></div>
            <div class="card"><h2><%= waitingApprovalCount %></h2><p>Quote Sent To Customer</p></div>
            <div class="card"><h2><%= followUpCount %></h2><p>Repair / Payment Stage</p></div>
        </div>
        <div class="queue">
            <h3>Current Work Queue</h3>
            <p class="sub">Appointments currently assigned to your technician account</p>
            <% if (appointments.isEmpty()) { %>
                <div class="queue-item"><div><strong>No technician appointments yet</strong><br><small>Your work queue will appear here.</small></div><span class="status waiting">Empty</span></div>
            <% } else {
                int shown = 0;
                for (Appointments appointment : appointments) {
                    if (shown >= 5) break;
                    shown++;
                    UsersEntity customer = appointment.getCustomer_id() == null ? null : userFacade.find(appointment.getCustomer_id());
                    List<AppointmentService> links = appointmentServiceFacade.findByAppointmentId(appointment.getAppointment_id());
                    List<String> names = new ArrayList<>();
                    for (AppointmentService link : links) {
                        ServiceEntity service = serviceFacade.find(link.getService_id());
                        if (service != null) names.add(service.getService_name());
                    }
            %>
                <div class="queue-item">
                    <div>
                        <strong><%= customer == null ? "Customer" : customer.getName() %> - #APT<%= appointment.getAppointment_id() %></strong><br>
                        <small><%= names.isEmpty() ? "No services selected yet" : String.join(", ", names) %> | <%= appointment.getAppointment_date() %> <%= appointment.getAppointment_time() %></small>
                    </div>
                    <span class="status waiting"><%= displayTechnicianStatus(appointment.getStatus()) %></span>
                </div>
            <%   }
               } %>
        </div>
    </div>
</div>
</body>
</html>
<%!
    private String displayTechnicianStatus(String status) {
        if (status == null) {
            return "-";
        }
        String normalized = status.trim().toUpperCase();
        switch (normalized) {
            case "ASSIGNED": return "Assigned For Inspection";
            case "WAITING APPROVAL": return "Quote Sent To Customer";
            case "ACCEPTED": return "Accepted, Ready To Repair";
            case "DELAYED": return "Repair Delayed";
            case "COMPLETED": return "Repair Completed";
            case "UNPAID": return "Waiting For Payment";
            case "PAID": return "Paid And Closed";
            default: return normalized;
        }
    }
%>
