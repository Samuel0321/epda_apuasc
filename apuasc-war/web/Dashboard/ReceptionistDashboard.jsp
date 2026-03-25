<%-- 
    Document   : ReceptionistDashboard
    Created on : Mar 24, 2026, 5:26:10 PM
    Author     : pinju
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Counter Dashboard</title>
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
            ☰ &nbsp; COUNTER STAFF PANEL
        </div>

        <div class="topbar-right">
            <a href="../Pages/Common/Notifications.jsp" class="bell" style="cursor: pointer; text-decoration: none; color: inherit;">🔔</a>

            <div class="profile" style="cursor: pointer;" onclick="window.location.href='../Pages/Common/Profile.jsp'">
                <div class="avatar">SA</div>
                <div class="user-info">
                    <div class="name">Siti Aminah</div>
                    <div class="email">counter@autofix.com</div>
                </div>
            </div>
        </div>

    </div>

    <!-- HEADER -->
    <div class="header-row">

        <div class="header-text">
            <h1>Counter Dashboard</h1>
            <p>Manage walk-ins and appointments</p>
        </div>

        <div class="actions">
            <button class="btn btn-light" onclick="window.location.href='../Pages/Receptionist/RegisterCustomer.jsp'">👤 Register Customer</button>
            <button class="btn btn-primary" onclick="window.location.href='../Pages/Receptionist/NewAppointment.jsp'">+ New Appointment</button>
        </div>

    </div>

    <!-- CARDS -->
    <div class="cards">
        <div class="card">
            <h2>8</h2>
            <p>Today's Appointments</p>
        </div>

        <div class="card">
            <h2>3</h2>
            <p>Waiting in Queue</p>
        </div>

        <div class="card">
            <h2>5</h2>
            <p>Pending Payments</p>
        </div>
    </div>

    <!-- QUEUE -->
    <div class="queue">
        <h3>Customer Queue</h3>
        <p class="sub">Current customers waiting or being serviced</p>

        <div class="queue-item">
            <div>
                <strong>Ahmad Faisal</strong><br>
                <small>Oil Change · 9:00 AM</small>
            </div>
            <span class="status waiting">Waiting</span>
        </div>

        <div class="queue-item">
            <div>
                <strong>Nurul Huda</strong><br>
                <small>Brake Inspection · 9:30 AM</small>
            </div>
            <span class="status service">In Service</span>
        </div>
    </div>

</div>
</body>
</html>