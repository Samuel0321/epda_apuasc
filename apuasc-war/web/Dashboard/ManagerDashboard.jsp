<%--
    Document   : ManagerDashboard
    Created on : Mar 24, 2026
    Author     : pinju
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, models.UsersEntity"%>
<!DOCTYPE html>
<html>
<head>
    <title>Manager Dashboard</title>
    <link rel="stylesheet" href="../Styles/main.css">
</head>

<body>

<div class="layout">

    <!-- Sidebar -->
    <jsp:include page="../Component/Sidebar.jsp" />

    <!-- Main Content -->
<div class="main">

    <!-- TOPBAR -->
    <div class="topbar">

        <div class="topbar-left">
            ☰ &nbsp; MANAGER PANEL
        </div>

        <div class="topbar-right">
            <a href="../Pages/Common/Notifications.jsp" class="bell" style="cursor: pointer; text-decoration: none; color: inherit;">🔔</a>

            <div class="profile" style="cursor: pointer;" onclick="window.location.href='../Pages/Common/Profile.jsp'">
                <div class="avatar">M</div>
                <div class="user-info">
                    <div class="name">Manager Name</div>
                    <div class="email">manager@autofix.com</div>
                </div>
            </div>
        </div>

    </div>

    <!-- HEADER -->
    <div class="header-row">

        <div class="header-text">
            <h1>Manager Dashboard</h1>
            <p>System administration and reporting</p>
        </div>

        <div class="actions">
            <button class="btn btn-light" onclick="window.location.href='../Pages/Manager/Reports.jsp'">📊 Generate Report</button>
            <button class="btn btn-primary" onclick="window.location.href='../Pages/Manager/ManageUsers.jsp'">+ Add User</button>
        </div>

    </div>

    <!-- CARDS -->
    <div class="cards">
        <div class="card">
            <h2>
                <%
                    List<UsersEntity> userList = (List<UsersEntity>) request.getAttribute("userList");
                    int userCount = (userList != null) ? userList.size() : 0;
                    out.print(userCount);
                %>
            </h2>
            <p>Total Users</p>
        </div>

        <div class="card">
            <h2>12</h2>
            <p>Active Sessions</p>
        </div>

        <div class="card">
            <h2>5</h2>
            <p>Pending Reports</p>
        </div>
    </div>

    <!-- USERS TABLE -->
    <div class="queue">
        <h3>System Users</h3>
        <p class="sub">All registered users in the system</p>

        <%
            if (userList != null && !userList.isEmpty()) {
                for (UsersEntity user : userList) {
        %>
        <div class="queue-item">
            <div>
                <strong><%= user.getName() %></strong><br>
                <small><%= user.getEmail() %> · <%= user.getRole() %></small>
            </div>
            <span class="status service"><%= user.getRole() %></span>
        </div>
        <%
                }
            }
        %>
    </div>

</div>
</body>
</html>
