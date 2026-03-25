<%--
    Document   : TechnicianDashboard
    Created on : Mar 24, 2026
    Author     : pinju
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Technician Dashboard</title>
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
            ☰ &nbsp; TECHNICIAN PANEL
        </div>

        <div class="topbar-right">
            <a href="../Pages/Common/Notifications.jsp" class="bell" style="cursor: pointer; text-decoration: none; color: inherit;">🔔</a>

            <div class="profile" style="cursor: pointer;" onclick="window.location.href='../Pages/Common/Profile.jsp'">
                <div class="avatar">T</div>
                <div class="user-info">
                    <div class="name">Technician Name</div>
                    <div class="email">technician@autofix.com</div>
                </div>
            </div>
        </div>

    </div>

    <!-- HEADER -->
    <div class="header-row">

        <div class="header-text">
            <h1>Technician Dashboard</h1>
            <p>Manage work orders and scheduled tasks</p>
        </div>

        <div class="actions">
            <button class="btn btn-light" onclick="window.location.href='../Pages/Technician/Schedule.jsp'">📅 Schedule</button>
            <button class="btn btn-primary" onclick="window.location.href='../Pages/Technician/WorkOrders.jsp'">+ New Work Order</button>
        </div>

    </div>

    <!-- CARDS -->
    <div class="cards">
        <div class="card">
            <h2>6</h2>
            <p>Assigned Tasks</p>
        </div>

        <div class="card">
            <h2>2</h2>
            <p>In Progress</p>
        </div>

        <div class="card">
            <h2>4</h2>
            <p>Pending Review</p>
        </div>
    </div>

    <!-- WORK ORDERS -->
    <div class="queue">
        <h3>Work Orders</h3>
        <p class="sub">Your assigned tasks and work orders</p>

        <div class="queue-item">
            <div>
                <strong>Replace Air Filter - Car ID #001</strong><br>
                <small>Regular Maintenance · 10:00 AM</small>
            </div>
            <span class="status waiting">Pending</span>
        </div>

        <div class="queue-item">
            <div>
                <strong>Engine Oil Change - Car ID #015</strong><br>
                <small>Routine Service · 11:30 AM</small>
            </div>
            <span class="status service">In Progress</span>
        </div>

        <div class="queue-item">
            <div>
                <strong>Brake Pad Replacement - Car ID #023</strong><br>
                <small>Repair Service · 1:00 PM</small>
            </div>
            <span class="status waiting">Pending</span>
        </div>
    </div>

</div>
</body>
</html>
