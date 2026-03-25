<%--
    Document   : MyAppointments
    Created on : Mar 24, 2026
    Author     : pinju
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>My Appointments</title>
    <link rel="stylesheet" href="../../Styles/main.css">
    <style>
        .appointments-container {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 20px;
        }

        .appointment-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
            overflow: hidden;
            transition: all 0.3s ease;
        }

        .appointment-card:hover {
            box-shadow: 0 8px 20px rgba(0,0,0,0.1);
        }

        .appointment-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
        }

        .appointment-date {
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 5px;
        }

        .appointment-time {
            font-size: 14px;
            opacity: 0.9;
        }

        .appointment-body {
            padding: 20px;
        }

        .appointment-service {
            font-size: 16px;
            font-weight: 600;
            color: #1e293b;
            margin-bottom: 8px;
        }

        .appointment-detail {
            font-size: 13px;
            color: #64748b;
            margin-bottom: 6px;
        }

        .appointment-status {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: 600;
            margin-top: 10px;
        }

        .status-scheduled {
            background: #dbeafe;
            color: #1e40af;
        }

        .status-in-progress {
            background: #fed7aa;
            color: #92400e;
        }

        .status-completed {
            background: #bbf7d0;
            color: #166534;
        }

        .status-cancelled {
            background: #fecaca;
            color: #7f1d1d;
        }

        .appointment-actions {
            display: flex;
            gap: 8px;
            margin-top: 12px;
        }

        .appointment-btn {
            flex: 1;
            padding: 8px 12px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 12px;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .btn-primary {
            background: #2563eb;
            color: white;
        }

        .btn-primary:hover {
            background: #1d4ed8;
        }

        .btn-secondary {
            background: #e5e7eb;
            color: #1e293b;
        }

        .btn-secondary:hover {
            background: #d1d5db;
        }

        .filters {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }

        .filter-btn {
            padding: 8px 14px;
            border: 1px solid #e2e8f0;
            background: white;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            transition: all 0.3s ease;
        }

        .filter-btn:hover,
        .filter-btn.active {
            background: #2563eb;
            color: white;
            border-color: #2563eb;
        }

        .header-actions {
            display: flex;
            gap: 10px;
        }
    </style>
</head>

<body>

<div class="layout">
    <!-- Sidebar -->
    <jsp:include page="../../Component/Sidebar.jsp" />

    <!-- Main Content -->
    <div class="main">
        <!-- TOPBAR -->
        <div class="topbar">
            <div class="topbar-left">
                ☰ &nbsp; MY APPOINTMENTS
            </div>
            <div class="topbar-right">
                <span class="bell">🔔</span>
                <div class="profile">
                    <div class="avatar">C</div>
                    <div class="user-info">
                        <div class="name">Customer</div>
                        <div class="email">customer@email.com</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- HEADER -->
        <div class="header-row">
            <div class="header-text">
                <h1>My Appointments</h1>
                <p>View and manage your service appointments</p>
            </div>
            <div class="header-actions">
                <button class="btn btn-primary">+ Book New Appointment</button>
            </div>
        </div>

        <!-- FILTERS -->
        <div class="filters">
            <button class="filter-btn active">All</button>
            <button class="filter-btn">Scheduled</button>
            <button class="filter-btn">In Progress</button>
            <button class="filter-btn">Completed</button>
            <button class="filter-btn">Cancelled</button>
        </div>

        <!-- APPOINTMENTS CARDS -->
        <div class="appointments-container">
            <!-- Appointment 1 -->
            <div class="appointment-card">
                <div class="appointment-header">
                    <div class="appointment-date">25 Mar</div>
                    <div class="appointment-time">10:00 AM</div>
                </div>
                <div class="appointment-body">
                    <div class="appointment-service">Oil Change</div>
                    <div class="appointment-detail">🏢 AutoFix Pro Service Center</div>
                    <div class="appointment-detail">👨‍🔧 Technician: John Smith</div>
                    <div class="appointment-detail">🚗 Toyota Camry 2020</div>
                    <div class="appointment-status status-scheduled">Scheduled</div>
                    <div class="appointment-actions">
                        <button class="appointment-btn btn-secondary">Reschedule</button>
                        <button class="appointment-btn btn-secondary">Cancel</button>
                    </div>
                </div>
            </div>

            <!-- Appointment 2 -->
            <div class="appointment-card">
                <div class="appointment-header">
                    <div class="appointment-date">28 Mar</div>
                    <div class="appointment-time">2:00 PM</div>
                </div>
                <div class="appointment-body">
                    <div class="appointment-service">Tire Rotation</div>
                    <div class="appointment-detail">🏢 AutoFix Pro Service Center</div>
                    <div class="appointment-detail">👨‍🔧 Technician: Ahmad Hassan</div>
                    <div class="appointment-detail">🚗 Honda CR-V 2019</div>
                    <div class="appointment-status status-scheduled">Scheduled</div>
                    <div class="appointment-actions">
                        <button class="appointment-btn btn-secondary">Reschedule</button>
                        <button class="appointment-btn btn-secondary">Cancel</button>
                    </div>
                </div>
            </div>

            <!-- Appointment 3 -->
            <div class="appointment-card">
                <div class="appointment-header">
                    <div class="appointment-date">20 Mar</div>
                    <div class="appointment-time">11:00 AM</div>
                </div>
                <div class="appointment-body">
                    <div class="appointment-service">Engine Inspection</div>
                    <div class="appointment-detail">🏢 AutoFix Pro Service Center</div>
                    <div class="appointment-detail">👨‍🔧 Technician: Nurul Amin</div>
                    <div class="appointment-detail">🚗 Nissan X-Trail 2021</div>
                    <div class="appointment-status status-completed">Completed</div>
                    <div class="appointment-actions">
                        <button class="appointment-btn btn-primary">View Invoice</button>
                    </div>
                </div>
            </div>

            <!-- Appointment 4 -->
            <div class="appointment-card">
                <div class="appointment-header">
                    <div class="appointment-date">15 Mar</div>
                    <div class="appointment-time">9:30 AM</div>
                </div>
                <div class="appointment-body">
                    <div class="appointment-service">Brake Service</div>
                    <div class="appointment-detail">🏢 AutoFix Pro Service Center</div>
                    <div class="appointment-detail">👨‍🔧 Technician: John Smith</div>
                    <div class="appointment-detail">🚗 BMW 3 Series 2021</div>
                    <div class="appointment-status status-cancelled">Cancelled</div>
                    <div class="appointment-actions">
                        <button class="appointment-btn btn-primary">Reschedule</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>
