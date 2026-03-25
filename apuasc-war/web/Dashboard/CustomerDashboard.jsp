<%--
    Document   : CustomerDashboard
    Created on : Mar 24, 2026
    Author     : pinju
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Customer Dashboard</title>
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
            ☰ &nbsp; CUSTOMER PORTAL
        </div>

        <div class="topbar-right">
            <a href="../Pages/Common/Notifications.jsp" class="bell" style="cursor: pointer; text-decoration: none; color: inherit;">🔔</a>

            <div class="profile" style="cursor: pointer;" onclick="window.location.href='../Pages/Common/Profile.jsp'">
                <div class="avatar">C</div>
                <div class="user-info">
                    <div class="name">Customer Name</div>
                    <div class="email">customer@email.com</div>
                </div>
            </div>
        </div>

    </div>

    <!-- HEADER -->
    <div class="header-row">

        <div class="header-text">
            <h1>Your Dashboard</h1>
            <p>Track your appointments and services</p>
        </div>

        <div class="actions">
            <button class="btn btn-light">💬 Contact Support</button>
            <button class="btn btn-primary" onclick="window.location.href='../Pages/Customer/MyAppointments.jsp'">+ Book Appointment</button>
        </div>

    </div>

    <!-- CARDS -->
    <div class="cards">
        <div class="card">
            <h2>3</h2>
            <p>Upcoming Appointments</p>
        </div>

        <div class="card">
            <h2>12</h2>
            <p>Completed Services</p>
        </div>

        <div class="card">
            <h2>2</h2>
            <p>Pending Invoices</p>
        </div>
    </div>

    <!-- APPOINTMENTS -->
    <div class="queue">
        <h3>My Appointments</h3>
        <p class="sub">Your upcoming and past appointments</p>

        <div class="queue-item">
            <div>
                <strong>Regular Oil Change</strong><br>
                <small>Mar 25, 2026 · 10:00 AM</small>
            </div>
            <span class="status waiting">Scheduled</span>
        </div>

        <div class="queue-item">
            <div>
                <strong>Tire Rotation & Balancing</strong><br>
                <small>Mar 28, 2026 · 2:00 PM</small>
            </div>
            <span class="status waiting">Scheduled</span>
        </div>

        <div class="queue-item">
            <div>
                <strong>Engine Inspection</strong><br>
                <small>Mar 30, 2026 · 9:30 AM</small>
            </div>
            <span class="status waiting">Pending Confirmation</span>
        </div>
    </div>

</div>
</body>
</html>
