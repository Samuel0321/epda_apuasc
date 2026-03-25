<%--
    Document   : Settings
    Created on : Mar 24, 2026
    Author     : pinju
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Settings</title>
    <link rel="stylesheet" href="../../Styles/main.css">
    <style>
        .settings-container {
            background: white;
            padding: 20px;
            border-radius: 14px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
            margin-bottom: 20px;
            max-width: 600px;
        }

        .settings-group {
            padding: 20px;
            border-bottom: 1px solid #e5e7eb;
        }

        .settings-group:last-child {
            border-bottom: none;
        }

        .settings-title {
            font-size: 16px;
            font-weight: 600;
            color: #1e293b;
            margin-bottom: 10px;
        }

        .settings-description {
            font-size: 14px;
            color: #64748b;
            margin-bottom: 12px;
        }

        .setting-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 12px;
        }

        .setting-label {
            color: #475569;
            font-size: 14px;
        }

        .toggle-switch {
            position: relative;
            width: 50px;
            height: 26px;
            background: #cbd5e1;
            border-radius: 13px;
            cursor: pointer;
            transition: background 0.3s;
        }

        .toggle-switch.active {
            background: #2563eb;
        }

        .toggle-switch::after {
            content: '';
            position: absolute;
            width: 22px;
            height: 22px;
            background: white;
            border-radius: 50%;
            top: 2px;
            left: 2px;
            transition: left 0.3s;
        }

        .toggle-switch.active::after {
            left: 26px;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: 500;
            color: #1e293b;
        }

        .form-group input,
        .form-group select {
            width: 100%;
            padding: 8px 12px;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
            font-size: 14px;
            box-sizing: border-box;
        }

        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }

        .btn-save {
            background: #2563eb;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 500;
        }

        .btn-save:hover {
            background: #1d4ed8;
        }

        .btn-cancel {
            background: #e2e8f0;
            color: #1e293b;
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 500;
            margin-left: 10px;
        }

        .btn-cancel:hover {
            background: #cbd5e1;
        }

        .action-buttons {
            margin-top: 15px;
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
                ☰ &nbsp; SETTINGS
            </div>
            <div class="topbar-right">
                <span class="bell">🔔</span>
                <div class="profile">
                    <div class="avatar">M</div>
                    <div class="user-info">
                        <div class="name">Manager</div>
                        <div class="email">manager@autofix.com</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- HEADER -->
        <div class="header-row">
            <div class="header-text">
                <h1>System Settings</h1>
                <p>Configure system preferences and options</p>
            </div>
        </div>

        <!-- GENERAL SETTINGS -->
        <div class="settings-container">
            <div class="settings-group">
                <div class="settings-title">General Settings</div>
                <div class="settings-description">Basic system configuration</div>

                <div class="form-group">
                    <label>Business Name</label>
                    <input type="text" value="AutoFix Pro">
                </div>

                <div class="form-group">
                    <label>Business Email</label>
                    <input type="email" value="info@autofix.com">
                </div>

                <div class="form-group">
                    <label>Phone Number</label>
                    <input type="tel" value="+60-3-1234-5678">
                </div>

                <div class="form-group">
                    <label>Business Address</label>
                    <input type="text" value="123 Main Street, Kuala Lumpur">
                </div>
            </div>
        </div>

        <!-- NOTIFICATION SETTINGS -->
        <div class="settings-container">
            <div class="settings-group">
                <div class="settings-title">Notifications</div>
                <div class="settings-description">Manage notification preferences</div>

                <div class="setting-item">
                    <span class="setting-label">Email Notifications</span>
                    <div class="toggle-switch active"></div>
                </div>

                <div class="setting-item">
                    <span class="setting-label">SMS Notifications</span>
                    <div class="toggle-switch"></div>
                </div>

                <div class="setting-item">
                    <span class="setting-label">Appointment Reminders</span>
                    <div class="toggle-switch active"></div>
                </div>

                <div class="setting-item">
                    <span class="setting-label">Payment Reminders</span>
                    <div class="toggle-switch active"></div>
                </div>
            </div>
        </div>

        <!-- BUSINESS HOURS -->
        <div class="settings-container">
            <div class="settings-group">
                <div class="settings-title">Business Hours</div>
                <div class="settings-description">Set your operating hours</div>

                <div class="form-group">
                    <label>Opening Time</label>
                    <input type="time" value="08:00">
                </div>

                <div class="form-group">
                    <label>Closing Time</label>
                    <input type="time" value="18:00">
                </div>

                <div class="setting-item">
                    <span class="setting-label">Open on Sundays</span>
                    <div class="toggle-switch"></div>
                </div>
            </div>
        </div>

        <!-- SAVE BUTTON -->
        <div style="margin-top: 20px;">
            <button class="btn-save">💾 Save Settings</button>
            <button class="btn-cancel">Cancel</button>
        </div>
    </div>
</div>

</body>
</html>
