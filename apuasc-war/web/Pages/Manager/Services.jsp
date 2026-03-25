<%--
    Document   : Services
    Created on : Mar 24, 2026
    Author     : pinju
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Service Management</title>
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

        .price {
            font-weight: 600;
            color: #2563eb;
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
                ☰ &nbsp; SERVICE MANAGEMENT
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
                <h1>Service Management</h1>
                <p>Add, update, and manage available services</p>
            </div>
            <div class="actions">
                <button class="btn btn-primary">+ Add New Service</button>
            </div>
        </div>

        <!-- TABLE -->
        <div class="table-container">
            <div class="table-header">
                <input type="text" class="search-box" placeholder="Search services...">
            </div>

            <table>
                <thead>
                    <tr>
                        <th>Service Name</th>
                        <th>Description</th>
                        <th>Price</th>
                        <th>Est. Duration</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td><strong>Oil Change</strong></td>
                        <td>Complete oil and filter replacement with top-up fluids</td>
                        <td class="price">RM 150</td>
                        <td>60 minutes</td>
                        <td><span class="badge badge-paid">Active</span></td>
                        <td>
                            <div class="action-buttons">
                                <button class="btn-small btn-edit">Edit</button>
                                <button class="btn-small btn-delete">Delete</button>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td><strong>Brake Service</strong></td>
                        <td>Brake pad replacement and rotor inspection</td>
                        <td class="price">RM 250</td>
                        <td>90 minutes</td>
                        <td><span class="badge badge-paid">Active</span></td>
                        <td>
                            <div class="action-buttons">
                                <button class="btn-small btn-edit">Edit</button>
                                <button class="btn-small btn-delete">Delete</button>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td><strong>Tire Rotation</strong></td>
                        <td>Tire rotation and balancing service</td>
                        <td class="price">RM 100</td>
                        <td>45 minutes</td>
                        <td><span class="badge badge-paid">Active</span></td>
                        <td>
                            <div class="action-buttons">
                                <button class="btn-small btn-edit">Edit</button>
                                <button class="btn-small btn-delete">Delete</button>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td><strong>AC Service</strong></td>
                        <td>Air conditioning inspection and recharge</td>
                        <td class="price">RM 180</td>
                        <td>75 minutes</td>
                        <td><span class="badge badge-paid">Active</span></td>
                        <td>
                            <div class="action-buttons">
                                <button class="btn-small btn-edit">Edit</button>
                                <button class="btn-small btn-delete">Delete</button>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td><strong>Engine Inspection</strong></td>
                        <td>Comprehensive engine diagnostic and inspection</td>
                        <td class="price">RM 200</td>
                        <td>120 minutes</td>
                        <td><span class="badge badge-paid">Active</span></td>
                        <td>
                            <div class="action-buttons">
                                <button class="btn-small btn-edit">Edit</button>
                                <button class="btn-small btn-delete">Delete</button>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td><strong>General Maintenance</strong></td>
                        <td>Routine vehicle maintenance and check-up</td>
                        <td class="price">RM 175</td>
                        <td>90 minutes</td>
                        <td><span class="badge badge-paid">Active</span></td>
                        <td>
                            <div class="action-buttons">
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
