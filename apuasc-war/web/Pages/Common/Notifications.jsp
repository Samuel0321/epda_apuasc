<%--
    Document   : Notifications
    Created on : Mar 24, 2026
    Author     : pinju
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Notifications</title>
    <link rel="stylesheet" href="../../Styles/main.css">
    <style>
        .notifications-container {
            background: white;
            border-radius: 14px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
            overflow: hidden;
        }

        .notifications-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .notifications-header h1 {
            font-size: 24px;
            margin: 0;
        }

        .notification-badge {
            background: #ef4444;
            color: white;
            border-radius: 50%;
            width: 32px;
            height: 32px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 14px;
            font-weight: 700;
        }

        .notifications-body {
            padding: 0;
        }

        .notification-item {
            padding: 20px 30px;
            border-bottom: 1px solid #f1f5f9;
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 20px;
            transition: all 0.3s ease;
            cursor: pointer;
        }

        .notification-item:hover {
            background: #f8fafc;
        }

        .notification-item.unread {
            background: #eff6ff;
            border-left: 4px solid #2563eb;
        }

        .notification-content {
            flex: 1;
        }

        .notification-icon {
            font-size: 28px;
            min-width: 40px;
        }

        .notification-title {
            font-weight: 700;
            color: #1e293b;
            font-size: 15px;
            margin-bottom: 5px;
        }

        .notification-message {
            color: #64748b;
            font-size: 14px;
            line-height: 1.5;
            margin-bottom: 8px;
        }

        .notification-meta {
            display: flex;
            gap: 15px;
            align-items: center;
        }

        .notification-time {
            font-size: 12px;
            color: #94a3b8;
        }

        .notification-type-badge {
            display: inline-block;
            font-size: 11px;
            padding: 4px 10px;
            border-radius: 4px;
            font-weight: 700;
        }

        .type-appointment {
            background: #dbeafe;
            color: #1e40af;
        }

        .type-payment {
            background: #fef3c7;
            color: #92400e;
        }

        .type-system {
            background: #f1d5ff;
            color: #7e22ce;
        }

        .notification-actions {
            display: flex;
            gap: 8px;
            opacity: 0;
            transition: opacity 0.3s;
        }

        .notification-item:hover .notification-actions {
            opacity: 1;
        }

        .action-btn {
            background: none;
            border: none;
            color: #2563eb;
            cursor: pointer;
            font-size: 14px;
            padding: 4px 8px;
            border-radius: 4px;
            transition: all 0.2s;
        }

        .action-btn:hover {
            background: #dbeafe;
        }

        .empty-notification {
            padding: 60px 30px;
            text-align: center;
            color: #94a3b8;
        }

        .empty-notification-icon {
            font-size: 48px;
            margin-bottom: 15px;
            opacity: 0.5;
        }

        .empty-notification p {
            margin: 0;
            font-size: 16px;
        }

        .filter-section {
            padding: 20px 30px;
            border-bottom: 1px solid #f1f5f9;
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .filter-btn {
            padding: 8px 14px;
            border: 1px solid #e2e8f0;
            background: white;
            border-radius: 6px;
            cursor: pointer;
            font-size: 13px;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .filter-btn:hover,
        .filter-btn.active {
            background: #2563eb;
            color: white;
            border-color: #2563eb;
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
                ☰ &nbsp; NOTIFICATIONS
            </div>
            <div class="topbar-right">
                <span class="bell">🔔</span>
                <div class="profile">
                    <div class="avatar">U</div>
                    <div class="user-info">
                        <div class="name">User</div>
                        <div class="email">user@autofix.com</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- HEADER -->
        <div class="header-row">
            <div class="header-text">
                <h1>Notifications</h1>
                <p>Stay updated with your latest notifications</p>
            </div>
        </div>

        <!-- NOTIFICATIONS CONTAINER -->
        <div class="notifications-container">
            <div class="notifications-header">
                <h1>📬 Your Notifications</h1>
                <div class="notification-badge">5</div>
            </div>

            <!-- FILTERS -->
            <div class="filter-section">
                <button class="filter-btn active">All</button>
                <button class="filter-btn">Appointments</button>
                <button class="filter-btn">Payments</button>
                <button class="filter-btn">System</button>
                <button class="filter-btn">Unread</button>
            </div>

            <!-- NOTIFICATIONS LIST -->
            <div class="notifications-body">
                <!-- Unread Notification 1 -->
                <div class="notification-item unread">
                    <div class="notification-icon">📅</div>
                    <div class="notification-content">
                        <div class="notification-title">New Appointment Scheduled</div>
                        <div class="notification-message">Ahmad Faisal has booked an Oil Change appointment for tomorrow at 10:00 AM</div>
                        <div class="notification-meta">
                            <span class="notification-type-badge type-appointment">Appointment</span>
                            <span class="notification-time">Just now</span>
                        </div>
                    </div>
                    <div class="notification-actions">
                        <button class="action-btn">✓</button>
                        <button class="action-btn">✕</button>
                    </div>
                </div>

                <!-- Unread Notification 2 -->
                <div class="notification-item unread">
                    <div class="notification-icon">💳</div>
                    <div class="notification-content">
                        <div class="notification-title">Payment Received</div>
                        <div class="notification-message">Payment of RM 150 has been received from Nurul Huda for Brake Inspection service</div>
                        <div class="notification-meta">
                            <span class="notification-type-badge type-payment">Payment</span>
                            <span class="notification-time">15 minutes ago</span>
                        </div>
                    </div>
                    <div class="notification-actions">
                        <button class="action-btn">✓</button>
                        <button class="action-btn">✕</button>
                    </div>
                </div>

                <!-- Unread Notification 3 -->
                <div class="notification-item unread">
                    <div class="notification-icon">⚠️</div>
                    <div class="notification-content">
                        <div class="notification-title">System Maintenance Scheduled</div>
                        <div class="notification-message">Scheduled maintenance will occur tonight from 11:00 PM to 1:00 AM. System will be unavailable during this time</div>
                        <div class="notification-meta">
                            <span class="notification-type-badge type-system">System</span>
                            <span class="notification-time">1 hour ago</span>
                        </div>
                    </div>
                    <div class="notification-actions">
                        <button class="action-btn">✓</button>
                        <button class="action-btn">✕</button>
                    </div>
                </div>

                <!-- Read Notification 1 -->
                <div class="notification-item">
                    <div class="notification-icon">👤</div>
                    <div class="notification-content">
                        <div class="notification-title">New User Added to System</div>
                        <div class="notification-message">A new receptionist named "Siti Aminah" has been successfully added to the system</div>
                        <div class="notification-meta">
                            <span class="notification-type-badge type-system">System</span>
                            <span class="notification-time">Yesterday</span>
                        </div>
                    </div>
                    <div class="notification-actions">
                        <button class="action-btn">✓</button>
                        <button class="action-btn">✕</button>
                    </div>
                </div>

                <!-- Read Notification 2 -->
                <div class="notification-item">
                    <div class="notification-icon">📊</div>
                    <div class="notification-content">
                        <div class="notification-title">Daily Report Generated</div>
                        <div class="notification-message">Your daily operational report for March 23, 2026 has been generated successfully</div>
                        <div class="notification-meta">
                            <span class="notification-type-badge type-system">System</span>
                            <span class="notification-time">2 days ago</span>
                        </div>
                    </div>
                    <div class="notification-actions">
                        <button class="action-btn">✓</button>
                        <button class="action-btn">✕</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>
