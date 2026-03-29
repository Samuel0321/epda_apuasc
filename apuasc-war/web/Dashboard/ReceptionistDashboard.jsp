<%-- 
    Document   : ReceptionistDashboard
    Created on : Mar 24, 2026
    Author     : pinju
--%>

<%@page import="java.time.LocalDate,java.util.ArrayList,java.util.Arrays,java.util.List,models.Appointments,models.AppointmentsFacade,models.UsersEntity,models.UsersEntityFacade,utils.EjbLookup"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    UsersEntity currentUser = (UsersEntity) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/loginjsp.jsp");
        return;
    }
    String currentRole = currentUser.getRole() == null ? "" : currentUser.getRole().trim().toLowerCase();
    if (!("receptionist".equals(currentRole) || "counter_staff".equals(currentRole))) {
        response.sendRedirect(request.getContextPath() + "/loginjsp.jsp");
        return;
    }

    AppointmentsFacade appointmentsFacade = EjbLookup.lookup(AppointmentsFacade.class, "AppointmentsFacade");
    UsersEntityFacade usersFacade = EjbLookup.lookup(UsersEntityFacade.class, "UsersEntityFacade");

    LocalDate today = LocalDate.now();
    List<Appointments> allAppointments = appointmentsFacade.findAllOrdered();
    int todayAppointmentsCount = 0;
    int waitingQueueCount = 0;
    int pendingPaymentsCount = 0;
    List<Appointments> queueAppointments = new ArrayList<Appointments>();

    for (Appointments appointment : allAppointments) {
        String status = appointment.getStatus() == null ? "" : appointment.getStatus().trim().toUpperCase();
        LocalDate appointmentDate = appointment.getAppointment_date();

        if (today.equals(appointmentDate)) {
            todayAppointmentsCount++;
        }
        if (Arrays.asList("PENDING", "ASSIGNED", "WAITING APPROVAL", "ACCEPTED", "DELAYED").contains(status)) {
            waitingQueueCount++;
            if (today.equals(appointmentDate) && queueAppointments.size() < 6) {
                queueAppointments.add(appointment);
            }
        }
        if ("UNPAID".equals(status) || "COMPLETED".equals(status)) {
            pendingPaymentsCount++;
        }
    }

    java.util.Map<Integer, String> customerNameById = new java.util.HashMap<Integer, String>();
    for (UsersEntity user : usersFacade.findAll()) {
        customerNameById.put(user.getId(), user.getName());
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Counter Dashboard</title>
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
            <jsp:param name="section" value="COUNTER STAFF PANEL" />
        </jsp:include>

        <div class="header-row">
            <div class="header-text">
                <h1>Counter Dashboard</h1>
                <p>Manage walk-ins and appointments</p>
            </div>

            <div class="actions">
                <button class="btn btn-light" onclick="window.location.href='../Pages/Receptionist/RegisterCustomer.jsp'">Register Customer</button>
                <button class="btn btn-primary" onclick="window.location.href='../Pages/Receptionist/NewAppointment.jsp'">+ New Appointment</button>
            </div>
        </div>

        <div class="cards">
            <div class="card">
                <h2><%= todayAppointmentsCount %></h2>
                <p>Today's Appointments</p>
            </div>

            <div class="card">
                <h2><%= waitingQueueCount %></h2>
                <p>Waiting in Queue</p>
            </div>

            <div class="card">
                <h2><%= pendingPaymentsCount %></h2>
                <p>Pending Payments</p>
            </div>
        </div>

        <div class="queue">
            <h3>Customer Queue</h3>
            <p class="sub">Current customers waiting or being serviced</p>
            <% if (queueAppointments.isEmpty()) { %>
            <div class="dashboard-empty">
                <div>
                    <strong>No active queue right now</strong><br>
                    <small>New appointments and walk-ins will appear here once they need counter action.</small>
                </div>
                <span class="empty-badge">Empty</span>
            </div>
            <% } else {
                for (Appointments item : queueAppointments) {
                    String status = item.getStatus() == null ? "PENDING" : item.getStatus().trim().toUpperCase();
                    String customerName = customerNameById.get(item.getCustomer_id());
                    if (customerName == null || customerName.trim().isEmpty()) {
                        customerName = "Customer #" + item.getCustomer_id();
                    }
                    String timeText = item.getAppointment_time() == null ? "-" : item.getAppointment_time().toString();
                    String tagClass = "PENDING".equals(status) || "WAITING APPROVAL".equals(status) || "DELAYED".equals(status) ? "waiting" : "service";
            %>
            <div class="queue-item">
                <div>
                    <strong><%= customerName %></strong><br>
                    <small><%= status %> · <%= timeText %></small>
                </div>
                <div style="display:flex; gap:10px; align-items:center;">
                    <span class="status <%= tagClass %>"><%= status %></span>
                    <% if ("PENDING".equals(status)) { %>
                    <a href="../Pages/Receptionist/AssignTechnician.jsp?id=<%= item.getId() %>" style="text-decoration:none; background:#2563eb; color:white; padding:6px 12px; border-radius:6px; font-size:12px;">Assign</a>
                    <% } else if ("WAITING APPROVAL".equals(status)) { %>
                    <a href="../Pages/Receptionist/ApproveQuotation.jsp?id=<%= item.getId() %>" style="text-decoration:none; background:#2563eb; color:white; padding:6px 12px; border-radius:6px; font-size:12px;">Approve</a>
                    <% } else if ("COMPLETED".equals(status) || "UNPAID".equals(status)) { %>
                    <a href="../Pages/Receptionist/Payments.jsp" style="text-decoration:none; background:#fbbf24; color:#92400e; padding:6px 12px; border-radius:6px; font-size:12px; font-weight:bold;">Pay</a>
                    <% } else { %>
                    <a href="../Pages/Receptionist/Appointments.jsp" style="text-decoration:none; background:#e2e8f0; color:#1e293b; padding:6px 12px; border-radius:6px; font-size:12px;">View</a>
                    <% } %>
                </div>
            </div>
            <%  }
               } %>
        </div>

    </div>
</div>
</body>
</html>
