<%--
    Document   : Sidebar
    Created on : 24 Mar 2026, 5:30:09?pm
    Author     : pinju
    Updated   : Workflow Navigation Flow with proper paths
--%>

<%@ page import="java.util.*, models.UsersEntity" %>

<div class="sidebar">
    <div class="nav-title">Navigation</div>
    
    <%
        String currentURI = request.getRequestURI();
        String contextPath = request.getContextPath();
        
        // Determine user role safely - prefer session role, then fallback to URI
        String role = "customer";
        
        // Try to get role from session user
        Object userObj = session.getAttribute("user");
        if (userObj != null && userObj instanceof UsersEntity) {
            UsersEntity user = (UsersEntity) userObj;
            String userRole = user.getRole();
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
                } else {
                    role = "customer";
                }
            }
        } else {
            // Fallback by URI for demo/static pages
            if (currentURI.contains("/Pages/Receptionist/") || currentURI.contains("ReceptionistDashboard")) {
                role = "receptionist";
            } else if (currentURI.contains("/Pages/Technician/") || currentURI.contains("TechnicianDashboard")) {
                role = "technician";
            } else if (currentURI.contains("/Pages/Manager/") || currentURI.contains("ManagerDashboard")) {
                role = "manager";
            } else if (currentURI.contains("/Pages/Admin/") || currentURI.contains("AdminDashboard")) {
                role = "admin";
            } else if (currentURI.contains("/Pages/Customer/") || currentURI.contains("CustomerDashboard")) {
                role = "customer";
            }
        }

        String homePath;
        if (role.equals("receptionist")) {
            homePath = contextPath + "/Dashboard/ReceptionistDashboard.jsp";
        } else if (role.equals("technician")) {
            homePath = contextPath + "/Dashboard/TechnicianDashboard.jsp";
        } else if (role.equals("manager") || role.equals("admin")) {
            homePath = contextPath + "/Dashboard/ManagerDashboard.jsp";
        } else {
            homePath = contextPath + "/Dashboard/CustomerDashboard.jsp";
        }
    %>
    <h2 onclick="window.location.href='<%= homePath %>'" style="cursor: pointer;">🔧 AutoFix Pro</h2>
    
    <!-- NAVIGATION FOR RECEPTIONIST -->
    <% if (role.equals("receptionist")) { %>
        <a href="<%= contextPath %>/Dashboard/ReceptionistDashboard.jsp" class="nav-item <%= currentURI.contains("ReceptionistDashboard") ? "active" : "" %>">
            📊 Dashboard
        </a>
        <a href="<%= contextPath %>/Pages/Receptionist/Appointments.jsp" class="nav-item <%= currentURI.contains("Appointments.jsp") && !currentURI.contains("MyAppointments") ? "active" : "" %>">
            📅 All Appointments
        </a>
        <a href="<%= contextPath %>/Pages/Receptionist/NewAppointment.jsp" class="nav-item <%= currentURI.contains("NewAppointment") ? "active" : "" %>">
            ➕ New Appointment
        </a>
        <a href="<%= contextPath %>/Pages/Receptionist/Payments.jsp" class="nav-item <%= currentURI.contains("Payments") ? "active" : "" %>">
            💰 Payments
        </a>
        <a href="<%= contextPath %>/Pages/Receptionist/ManageCustomers.jsp" class="nav-item <%= currentURI.contains("ManageCustomers") ? "active" : "" %>">
            👥 Customers
        </a>
        <hr style="margin: 15px 0; border: none; border-top: 1px solid #e2e8f0;">
        <a href="<%= contextPath %>/Pages/Common/Profile.jsp" class="nav-item">
            ⚙️ Settings
        </a>
        <a href="<%= contextPath %>/Dashboard/Login.jsp" class="nav-item">
            🚪 Logout
        </a>
    
    <!-- NAVIGATION FOR TECHNICIAN -->
    <% } else if (role.equals("technician")) { %>
        <a href="<%= contextPath %>/Dashboard/TechnicianDashboard.jsp" class="nav-item <%= currentURI.contains("TechnicianDashboard") ? "active" : "" %>">
            📊 Dashboard
        </a>
        <a href="<%= contextPath %>/Pages/Technician/AssignedTasks.jsp" class="nav-item <%= currentURI.contains("AssignedTasks") ? "active" : "" %>">
            ✅ Assigned Tasks
        </a>
        <a href="<%= contextPath %>/Pages/Technician/Schedule.jsp" class="nav-item <%= currentURI.contains("Schedule") ? "active" : "" %>">
            📅 Schedule
        </a>
        <a href="<%= contextPath %>/Pages/Technician/WorkOrders.jsp" class="nav-item <%= currentURI.contains("WorkOrders") ? "active" : "" %>">
            📋 Work Orders
        </a>
        <hr style="margin: 15px 0; border: none; border-top: 1px solid #e2e8f0;">
        <div style="padding: 10px 0; font-size: 12px; color: #64748b; border-left: 3px solid #fbbf24; padding-left: 10px; margin: 10px 0;">
            💡 Tip: Click "Create Quotation" on work orders to submit quotation
        </div>
        <hr style="margin: 15px 0; border: none; border-top: 1px solid #e2e8f0;">
        <a href="<%= contextPath %>/Pages/Common/Profile.jsp" class="nav-item">
            ⚙️ Settings
        </a>
        <a href="<%= contextPath %>/Dashboard/Login.jsp" class="nav-item">
            🚪 Logout
        </a>
    
    <!-- NAVIGATION FOR MANAGER -->
    <% } else if (role.equals("manager") || role.equals("admin")) { %>
        <a href="<%= contextPath %>/Dashboard/ManagerDashboard.jsp" class="nav-item <%= currentURI.contains("ManagerDashboard") ? "active" : "" %>">
            📊 Dashboard
        </a>
        <a href="<%= contextPath %>/Pages/Manager/ManageUsers.jsp" class="nav-item <%= currentURI.contains("ManageUsers") ? "active" : "" %>">
            👥 Manage Staff
        </a>
        <a href="<%= contextPath %>/Pages/Manager/Services.jsp" class="nav-item <%= currentURI.contains("Services") ? "active" : "" %>">
            🛠 Service Pricing
        </a>
        <a href="<%= contextPath %>/Pages/Manager/Reports.jsp" class="nav-item <%= currentURI.contains("Reports") ? "active" : "" %>">
            📈 Reports
        </a>
        <a href="<%= contextPath %>/Pages/Manager/Payments.jsp" class="nav-item <%= currentURI.contains("Payments") ? "active" : "" %>">
            💰 Payments
        </a>
        <hr style="margin: 15px 0; border: none; border-top: 1px solid #e2e8f0;">
        <a href="<%= contextPath %>/Pages/Common/Profile.jsp" class="nav-item">
            ⚙️ Settings
        </a>
        <a href="<%= contextPath %>/Dashboard/Login.jsp" class="nav-item">
            🚪 Logout
        </a>

    <!-- NAVIGATION FOR CUSTOMER -->
    <% } else { %>
        <a href="<%= contextPath %>/Dashboard/CustomerDashboard.jsp" class="nav-item <%= currentURI.contains("CustomerDashboard") ? "active" : "" %>">
            📊 Dashboard
        </a>
        <a href="<%= contextPath %>/Pages/Customer/MyAppointments.jsp" class="nav-item <%= currentURI.contains("MyAppointments") ? "active" : "" %>">
            📅 My Appointments
        </a>
        <a href="<%= contextPath %>/Pages/Customer/ServiceHistory.jsp" class="nav-item <%= currentURI.contains("ServiceHistory") ? "active" : "" %>">
            📋 Service History
        </a>
        <a href="<%= contextPath %>/Pages/Customer/Invoices.jsp" class="nav-item <%= currentURI.contains("Invoices") ? "active" : "" %>">
            🧾 Invoices
        </a>
        <hr style="margin: 15px 0; border: none; border-top: 1px solid #e2e8f0;">
        <a href="<%= contextPath %>/Pages/Common/Profile.jsp" class="nav-item">
            ⚙️ Settings
        </a>
        <a href="<%= contextPath %>/Dashboard/Login.jsp" class="nav-item">
            🚪 Logout
        </a>
    <% } %>
</div>