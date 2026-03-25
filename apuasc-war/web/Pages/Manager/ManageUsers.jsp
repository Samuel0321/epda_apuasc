<%--
    Document   : ManageUsers
    Created on : Mar 24, 2026
    Author     : pinju
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Users</title>
    <link rel="stylesheet" href="../../Styles/main.css">
    <style>
        .table-container {
            background: white;
            padding: 20px;
            border-radius: 14px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
        }

        .table-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            gap: 10px;
        }

        .search-box {
            flex: 1;
            padding: 10px 12px;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            font-size: 14px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        table thead {
            background: #f8fafc;
        }

        table th {
            padding: 12px;
            text-align: left;
            font-weight: 600;
            color: #1e293b;
            border-bottom: 2px solid #e2e8f0;
        }

        table td {
            padding: 12px;
            border-bottom: 1px solid #f1f5f9;
        }

        table tbody tr:hover {
            background: #f8fafc;
        }

        .badge {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 500;
        }

        .badge-active {
            background: #bbf7d0;
            color: #166534;
        }

        .badge-inactive {
            background: #d1d5db;
            color: #374151;
        }

        .role-badge {
            background: #dbeafe;
            color: #1e40af;
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 500;
        }

        .action-buttons {
            display: flex;
            gap: 5px;
        }

        .btn-small {
            padding: 6px 10px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 12px;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .btn-info {
            background: #dbeafe;
            color: #1e40af;
        }

        .btn-info:hover {
            background: #bfdbfe;
        }

        .btn-edit {
            background: #fef3c7;
            color: #92400e;
        }

        .btn-edit:hover {
            background: #fde68a;
        }

        .btn-delete {
            background: #fecaca;
            color: #7f1d1d;
        }

        .btn-delete:hover {
            background: #f87171;
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

        .toggle-switch {
            position: relative;
            width: 45px;
            height: 24px;
            background: #cbd5e1;
            border-radius: 12px;
            cursor: pointer;
            transition: background 0.3s;
            border: none;
            outline: none;
        }

        .toggle-switch.active {
            background: #2563eb;
        }

        .toggle-switch::after {
            content: '';
            position: absolute;
            width: 20px;
            height: 20px;
            background: white;
            border-radius: 50%;
            top: 2px;
            left: 2px;
            transition: left 0.3s;
        }

        .toggle-switch.active::after {
            left: 23px;
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
                ☰ &nbsp; MANAGE USERS
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
                <h1>User Management</h1>
                <p>View and manage system users</p>
            </div>
            <div class="actions">
                <button class="btn btn-primary">+ Add New User</button>
            </div>
        </div>

        <!-- FILTERS -->
        <div class="filters">
            <button class="filter-btn active">All</button>
            <button class="filter-btn">Receptionist</button>
            <button class="filter-btn">Technician</button>
            <button class="filter-btn">Manager</button>
            <button class="filter-btn">Active</button>
            <button class="filter-btn">Inactive</button>
        </div>

        <!-- TABLE -->
        <div class="table-container">
            <div class="table-header">
                <input type="text" class="search-box" placeholder="Search users by name or email...">
            </div>

            <table>
                <thead>
                    <tr>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Role</th>
                        <th>Status</th>
                        <th>Manager Access</th>
                        <th>Joined</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>Ahmad Hassan</td>
                        <td>ahmad@autofix.com</td>
                        <td><span class="role-badge">Receptionist</span></td>
                        <td><span class="badge badge-active">Active</span></td>
                        <td>—</td>
                        <td>Jan 15, 2026</td>
                        <td>
                            <div class="action-buttons">
                                <button class="btn-small btn-info">View</button>
                                <button class="btn-small btn-edit">Edit</button>
                                <button class="btn-small btn-delete">Delete</button>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>Nurul Amin</td>
                        <td>nurul@autofix.com</td>
                        <td><span class="role-badge">Technician</span></td>
                        <td><span class="badge badge-active">Active</span></td>
                        <td>—</td>
                        <td>Feb 01, 2026</td>
                        <td>
                            <div class="action-buttons">
                                <button class="btn-small btn-info">View</button>
                                <button class="btn-small btn-edit">Edit</button>
                                <button class="btn-small btn-delete">Delete</button>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>Sarah Manager</td>
                        <td>sarah@autofix.com</td>
                        <td><span class="role-badge" style="background: #f3d7f1; color: #c2185b;">Manager</span></td>
                        <td><span class="badge badge-active">Active</span></td>
                        <td><button class="toggle-switch active" title="Can create/manage managers"></button></td>
                        <td>Dec 01, 2025</td>
                        <td>
                            <div class="action-buttons">
                                <button class="btn-small btn-info">View</button>
                                <button class="btn-small btn-edit">Edit</button>
                                <button class="btn-small btn-delete">Delete</button>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>Siti Aminah</td>
                        <td>siti@autofix.com</td>
                        <td><span class="role-badge">Receptionist</span></td>
                        <td><span class="badge badge-active">Active</span></td>
                        <td>—</td>
                        <td>Jan 20, 2026</td>
                        <td>
                            <div class="action-buttons">
                                <button class="btn-small btn-info">View</button>
                                <button class="btn-small btn-edit">Edit</button>
                                <button class="btn-small btn-delete">Delete</button>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>John Smith</td>
                        <td>john@autofix.com</td>
                        <td><span class="role-badge" style="background: #f3d7f1; color: #c2185b;">Manager</span></td>
                        <td><span class="badge badge-inactive">Inactive</span></td>
                        <td><button class="toggle-switch" title="Cannot create/manage managers"></button></td>
                        <td>Dec 10, 2025</td>
                        <td>
                            <div class="action-buttons">
                                <button class="btn-small btn-info">View</button>
                                <button class="btn-small btn-edit">Edit</button>
                                <button class="btn-small btn-delete">Delete</button>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</div>

</body>
</html>
