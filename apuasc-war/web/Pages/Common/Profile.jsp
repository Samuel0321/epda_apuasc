<%--
    Document   : Profile
    Created on : Mar 24, 2026
    Author     : pinju
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>My Profile</title>
    <link rel="stylesheet" href="../../Styles/main.css">
    <style>
        .profile-container {
            background: white;
            border-radius: 14px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
            overflow: hidden;
        }

        .profile-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 40px 30px;
            text-align: center;
            position: relative;
        }

        .profile-avatar {
            width: 100px;
            height: 100px;
            background: rgba(255, 255, 255, 0.2);
            border: 3px solid white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 50px;
            margin: 0 auto 15px;
        }

        .profile-header h1 {
            font-size: 28px;
            margin-bottom: 5px;
            font-weight: 700;
        }

        .profile-header p {
            opacity: 0.9;
            font-size: 16px;
        }

        .profile-body {
            padding: 40px;
            max-width: 700px;
        }

        .profile-section {
            margin-bottom: 35px;
        }

        .section-title {
            font-size: 13px;
            color: #64748b;
            margin-bottom: 15px;
            text-transform: uppercase;
            letter-spacing: 0.8px;
            font-weight: 700;
        }

        .profile-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 0;
            border-bottom: 1px solid #f1f5f9;
        }

        .profile-item:last-child {
            border-bottom: none;
        }

        .profile-label {
            color: #64748b;
            font-size: 14px;
            font-weight: 500;
        }

        .profile-value {
            color: #1e293b;
            font-weight: 600;
            font-size: 15px;
        }

        .badge-role {
            display: inline-block;
            background: #dbeafe;
            color: #1e40af;
            padding: 6px 14px;
            border-radius: 12px;
            font-size: 13px;
            font-weight: 700;
        }

        .badge-status {
            display: inline-block;
            background: #bbf7d0;
            color: #166534;
            padding: 6px 14px;
            border-radius: 12px;
            font-size: 13px;
            font-weight: 700;
        }

        .profile-actions {
            display: flex;
            gap: 15px;
            margin-top: 30px;
            padding-top: 30px;
            border-top: 1px solid #f1f5f9;
        }

        .btn {
            flex: 1;
            padding: 12px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            font-size: 14px;
            transition: all 0.3s ease;
        }

        .btn-primary {
            background: #2563eb;
            color: white;
        }

        .btn-primary:hover {
            background: #1d4ed8;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.3);
        }

        .btn-secondary {
            background: #e5e7eb;
            color: #1e293b;
        }

        .btn-secondary:hover {
            background: #d1d5db;
            transform: translateY(-2px);
        }

        .close-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .back-btn {
            background: none;
            border: none;
            font-size: 24px;
            color: #475569;
            cursor: pointer;
            padding: 5px;
            display: flex;
            align-items: center;
            gap: 5px;
            font-weight: 600;
        }

        .back-btn:hover {
            color: #1e293b;
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
                ☰ &nbsp; MY PROFILE
            </div>
            <div class="topbar-right">
                <span class="bell">🔔</span>
                <div class="profile">
                    <div class="avatar">A</div>
                    <div class="user-info">
                        <div class="name">Ahmad Hassan</div>
                        <div class="email">ahmad@autofix.com</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- HEADER -->
        <div class="header-row">
            <div class="header-text">
                <h1>My Profile</h1>
                <p>View and manage your account information</p>
            </div>
        </div>

        <!-- PROFILE CONTAINER -->
        <div class="profile-container">
            <div class="profile-header">
                <div class="profile-avatar">👤</div>
                <h1>Ahmad Hassan</h1>
                <p>Receptionist / Counter Staff</p>
            </div>

            <div class="profile-body">
                <!-- Personal Information -->
                <div class="profile-section">
                    <div class="section-title">📋 Personal Information</div>
                    <div class="profile-item">
                        <span class="profile-label">Email</span>
                        <span class="profile-value">ahmad@autofix.com</span>
                    </div>
                    <div class="profile-item">
                        <span class="profile-label">Phone</span>
                        <span class="profile-value">+60-12-345-6789</span>
                    </div>
                    <div class="profile-item">
                        <span class="profile-label">Employee ID</span>
                        <span class="profile-value">EMP-001</span>
                    </div>
                </div>

                <!-- Role & Status -->
                <div class="profile-section">
                    <div class="section-title">👑 Role & Permissions</div>
                    <div class="profile-item">
                        <span class="profile-label">Role</span>
                        <span class="badge-role">Receptionist</span>
                    </div>
                    <div class="profile-item">
                        <span class="profile-label">Status</span>
                        <span class="badge-status">Active</span>
                    </div>
                    <div class="profile-item">
                        <span class="profile-label">Joined Date</span>
                        <span class="profile-value">January 15, 2026</span>
                    </div>
                </div>

                <!-- Account Actions -->
                <div class="profile-actions">
                    <button class="btn btn-primary">✏️ Edit Profile</button>
                    <button class="btn btn-secondary">🔒 Change Password</button>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>
