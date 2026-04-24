<%@ page import="models.UsersEntity" %>

<div class="sidebar">
    <%
        String currentURI = request.getRequestURI();
        String contextPath = request.getContextPath();

        String role = "customer";
        Object userObj = session.getAttribute("user");
        if (userObj instanceof UsersEntity) {
            UsersEntity currentUser = (UsersEntity) userObj;
            String userRole = currentUser.getRole();
            if (userRole != null) {
                String normalized = userRole.trim().toLowerCase();
                if (normalized.equals("receptionist") || normalized.equals("counter_staff")) {
                    role = "receptionist";
                } else if (normalized.equals("technician")) {
                    role = "technician";
                } else if (normalized.equals("manager") || normalized.equals("super_admin")) {
                    role = "manager";
                } else if (normalized.equals("admin")) {
                    role = "admin";
                }
            }
        } else {
            if (currentURI.contains("/Pages/Receptionist/") || currentURI.contains("ReceptionistDashboard")) {
                role = "receptionist";
            } else if (currentURI.contains("/Pages/Technician/") || currentURI.contains("TechnicianDashboard")) {
                role = "technician";
            } else if (currentURI.contains("/Pages/Manager/") || currentURI.contains("ManagerDashboard")) {
                role = "manager";
            } else if (currentURI.contains("/Pages/Admin/") || currentURI.contains("AdminDashboard")) {
                role = "admin";
            }
        }

        String homePath = contextPath + "/Dashboard/CustomerDashboard.jsp";
        if (role.equals("receptionist")) {
            homePath = contextPath + "/Dashboard/ReceptionistDashboard.jsp";
        } else if (role.equals("technician")) {
            homePath = contextPath + "/Dashboard/TechnicianDashboard.jsp";
        } else if (role.equals("manager") || role.equals("admin")) {
            homePath = contextPath + "/Dashboard/ManagerDashboard.jsp";
        }
    %>

    <div class="sidebar-brand" onclick="window.location.href='<%= homePath %>'" style="cursor: pointer;">
        <img src="<%= contextPath %>/Icon/APUASC.png" alt="APU ASC Logo" class="sidebar-logo">
        <h2>APU ASC</h2>
    </div>
    <div class="nav-title">Navigation</div>

    <% if (role.equals("receptionist")) { %>
        <a href="<%= contextPath %>/Dashboard/ReceptionistDashboard.jsp" class="nav-item <%= currentURI.contains("ReceptionistDashboard") ? "active" : "" %>">Dashboard</a>
        <a href="<%= contextPath %>/Pages/Receptionist/Appointments.jsp" class="nav-item <%= currentURI.contains("Appointments.jsp") && !currentURI.contains("MyAppointments") ? "active" : "" %>">All Appointments</a>
        <a href="<%= contextPath %>/Pages/Receptionist/NewAppointment.jsp" class="nav-item <%= currentURI.contains("NewAppointment") ? "active" : "" %>">New Appointment</a>
        <a href="<%= contextPath %>/Pages/Receptionist/Payments.jsp" class="nav-item <%= currentURI.contains("Payments") ? "active" : "" %>">Payments</a>
        <a href="<%= contextPath %>/Pages/Receptionist/ManageCustomers.jsp" class="nav-item <%= currentURI.contains("ManageCustomers") || currentURI.contains("RegisterCustomer") ? "active" : "" %>">Customers</a>
    <% } else if (role.equals("technician")) { %>
        <a href="<%= contextPath %>/Dashboard/TechnicianDashboard.jsp" class="nav-item <%= currentURI.contains("TechnicianDashboard") ? "active" : "" %>">Dashboard</a>
        <a href="<%= contextPath %>/Pages/Technician/AssignedTasks.jsp" class="nav-item <%= currentURI.contains("AssignedTasks") ? "active" : "" %>">Assigned Tasks</a>
        <a href="<%= contextPath %>/Pages/Technician/Schedule.jsp" class="nav-item <%= currentURI.contains("Schedule") ? "active" : "" %>">Schedule</a>
    <% } else if (role.equals("manager") || role.equals("admin")) { %>
        <a href="<%= contextPath %>/Dashboard/ManagerDashboard.jsp" class="nav-item <%= currentURI.contains("ManagerDashboard") ? "active" : "" %>">Dashboard</a>
        <a href="<%= contextPath %>/Pages/Manager/ManageUsers.jsp" class="nav-item <%= currentURI.contains("ManageUsers") ? "active" : "" %>">User Directory</a>
        <a href="<%= contextPath %>/Pages/Manager/Appointments.jsp" class="nav-item <%= currentURI.contains("Pages/Manager/Appointments") ? "active" : "" %>">Appointments</a>
        <a href="<%= contextPath %>/Pages/Manager/Services.jsp" class="nav-item <%= currentURI.contains("Services") ? "active" : "" %>">Service Pricing</a>
        <a href="<%= contextPath %>/Pages/Manager/Reports.jsp" class="nav-item <%= currentURI.contains("Reports") || currentURI.contains("ManagerReportsPageServlet") ? "active" : "" %>">Reports</a>
        <a href="<%= contextPath %>/Pages/Manager/Payments.jsp" class="nav-item <%= currentURI.contains("Payments") ? "active" : "" %>">Payments</a>
    <% } else { %>
        <a href="<%= contextPath %>/Dashboard/CustomerDashboard.jsp" class="nav-item <%= currentURI.contains("CustomerDashboard") ? "active" : "" %>">Dashboard</a>
        <a href="<%= contextPath %>/Pages/Customer/MyAppointments.jsp" class="nav-item <%= currentURI.contains("MyAppointments") ? "active" : "" %>">My Appointments</a>
        <a href="<%= contextPath %>/Pages/Customer/ServiceHistory.jsp" class="nav-item <%= currentURI.contains("ServiceHistory") ? "active" : "" %>">Service History</a>
        <a href="<%= contextPath %>/Pages/Customer/PaymentHistory.jsp" class="nav-item <%= currentURI.contains("PaymentHistory") || currentURI.contains("Invoices") ? "active" : "" %>">Payment History</a>
    <% } %>

    <hr style="margin: 15px 0; border: none; border-top: 1px solid #e2e8f0;">
    <a href="<%= contextPath %>/Pages/Common/Profile.jsp" class="nav-item <%= currentURI.contains("Profile.jsp") ? "active" : "" %>">Profile</a>
    <a href="<%= contextPath %>/loginjsp.jsp?logout=1" class="nav-item">Logout</a>
</div>
