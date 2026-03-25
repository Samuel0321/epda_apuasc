<%--
    Document   : Appointments
    Created on : Mar 24, 2026
    Author     : pinju
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Appointments</title>
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

        .badge-pending {
            background: #fef08a;
            color: #854d0e;
        }

        .badge-confirmed {
            background: #bbf7d0;
            color: #166534;
        }

        .badge-completed {
            background: #bfdbfe;
            color: #1e40af;
        }

        .badge-cancelled {
            background: #fecaca;
            color: #7f1d1d;
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
                ☰ &nbsp; APPOINTMENTS
            </div>
            <div class="topbar-right">
                <span class="bell">🔔</span>
                <div class="profile">
                    <div class="avatar">R</div>
                    <div class="user-info">
                        <div class="name">Receptionist</div>
                        <div class="email">receptionist@autofix.com</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- HEADER -->
        <div class="header-row">
            <div class="header-text">
                <h1>Manage Appointments</h1>
                <p>View and manage all customer appointments</p>
            </div>
            <div class="actions">
                <button class="btn btn-primary" onclick="window.location.href='NewAppointment.jsp'">+ New Appointment</button>
            </div>
        </div>

        <!-- FILTERS -->
        <div class="filters">
            <button class="filter-btn active">All</button>
            <button class="filter-btn">Pending</button>
            <button class="filter-btn">Confirmed</button>
            <button class="filter-btn">Completed</button>
            <button class="filter-btn">Cancelled</button>
        </div>

        <!-- TABLE -->
        <div class="table-container">
            <div class="table-header">
                <input type="text" class="search-box" placeholder="Search appointments...">
            </div>

            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Customer</th>
                        <th>Service</th>
                        <th>Date & Time</th>
                        <th>Technician</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>#APT001</td>
                        <td>Ahmad Faisal</td>
                        <td>Oil Change</td>
                        <td>Mar 25, 2026 - 10:00 AM</td>
                        <td>John Smith</td>
                        <td><span class="badge badge-confirmed">Confirmed</span></td>
                        <td>
                            <div class="action-buttons">
                                <button class="btn-small btn-info">View</button>
                                <button class="btn-small btn-edit">Edit</button>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>#APT002</td>
                        <td>Nurul Huda</td>
                        <td>Brake Inspection</td>
                        <td>Mar 25, 2026 - 2:00 PM</td>
                        <td>Ahmad Hassan</td>
                        <td><span class="badge badge-pending">Pending</span></td>
                        <td>
                            <div class="action-buttons">
                                <button class="btn-small btn-info">View</button>
                                <button class="btn-small btn-edit">Edit</button>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>#APT003</td>
                        <td>Siti Aminah</td>
                        <td>Tire Rotation</td>
                        <td>Mar 26, 2026 - 11:00 AM</td>
                        <td>Nurul Amin</td>
                        <td><span class="badge badge-completed">Completed</span></td>
                        <td>
                            <div class="action-buttons">
                                <button class="btn-small btn-info">View</button>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>#APT004</td>
                        <td>Muhammad Ali</td>
                        <td>Engine Inspection</td>
                        <td>Mar 27, 2026 - 3:00 PM</td>
                        <td>John Smith</td>
                        <td><span class="badge badge-cancelled">Cancelled</span></td>
                        <td>
                            <div class="action-buttons">
                                <button class="btn-small btn-info">View</button>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>#APT005</td>
                        <td>Zahra Rahman</td>
                        <td>General Maintenance</td>
                        <td>Mar 28, 2026 - 9:30 AM</td>
                        <td>Ahmad Hassan</td>
                        <td><span class="badge badge-confirmed">Confirmed</span></td>
                        <td>
                            <div class="action-buttons">
                                <button class="btn-small btn-info">View</button>
                                <button class="btn-small btn-edit">Edit</button>
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
