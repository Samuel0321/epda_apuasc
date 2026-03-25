<%--
    Document   : WorkOrders
    Created on : Mar 24, 2026
    Author     : pinju
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Work Orders</title>
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

        .badge-new {
            background: #dbeafe;
            color: #1e40af;
        }

        .badge-in-progress {
            background: #fed7aa;
            color: #92400e;
        }

        .badge-completed {
            background: #bbf7d0;
            color: #166534;
        }

        .badge-pending-review {
            background: #fef3c7;
            color: #854d0e;
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

        .btn-start {
            background: #dbeafe;
            color: #1e40af;
        }

        .btn-start:hover {
            background: #bfdbfe;
        }

        .btn-complete {
            background: #bbf7d0;
            color: #166534;
        }

        .btn-complete:hover {
            background: #86efac;
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
                ☰ &nbsp; WORK ORDERS
            </div>
            <div class="topbar-right">
                <span class="bell">🔔</span>
                <div class="profile">
                    <div class="avatar">T</div>
                    <div class="user-info">
                        <div class="name">Technician</div>
                        <div class="email">technician@autofix.com</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- HEADER -->
        <div class="header-row">
            <div class="header-text">
                <h1>Work Orders</h1>
                <p>View and manage assigned work orders</p>
            </div>
        </div>

        <!-- FILTERS -->
        <div class="filters">
            <button class="filter-btn active">All</button>
            <button class="filter-btn">New</button>
            <button class="filter-btn">In Progress</button>
            <button class="filter-btn">Completed</button>
            <button class="filter-btn">Pending Review</button>
        </div>

        <!-- TABLE -->
        <div class="table-container">
            <div class="table-header">
                <input type="text" class="search-box" placeholder="Search work orders...">
            </div>

            <table>
                <thead>
                    <tr>
                        <th>Order ID</th>
                        <th>Customer</th>
                        <th>Service</th>
                        <th>Vehicle</th>
                        <th>Status</th>
                        <th>Due Date</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>#WO001</td>
                        <td>Ahmad Faisal</td>
                        <td>Oil Change</td>
                        <td>Toyota Camry (2020)</td>
                        <td><span class="badge badge-new">New</span></td>
                        <td>Mar 25, 10:00 AM</td>
                        <td>
                            <div class="action-buttons">
                                <button class="btn-small btn-start">Start</button>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>#WO002</td>
                        <td>Nurul Huda</td>
                        <td>Brake Inspection</td>
                        <td>Honda CR-V (2019)</td>
                        <td><span class="badge badge-in-progress">In Progress</span></td>
                        <td>Mar 25, 2:30 PM</td>
                        <td>
                            <div class="action-buttons">
                                <button class="btn-small btn-complete">Complete</button>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>#WO003</td>
                        <td>Siti Aminah</td>
                        <td>Tire Rotation</td>
                        <td>Nissan X-Trail (2021)</td>
                        <td><span class="badge badge-completed">Completed</span></td>
                        <td>Mar 24, 11:45 AM</td>
                        <td>
                            <div class="action-buttons">
                                <button class="btn-small btn-start">View</button>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>#WO004</td>
                        <td>Muhammad Ali</td>
                        <td>Engine Inspection</td>
                        <td>Petronas Perdana (2018)</td>
                        <td><span class="badge badge-pending-review">Pending Review</span></td>
                        <td>Mar 23, 3:00 PM</td>
                        <td>
                            <div class="action-buttons">
                                <button class="btn-small btn-start">View</button>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>#WO005</td>
                        <td>Zahra Rahman</td>
                        <td>General Maintenance</td>
                        <td>BMW 3 Series (2021)</td>
                        <td><span class="badge badge-new">New</span></td>
                        <td>Mar 26, 9:00 AM</td>
                        <td>
                            <div class="action-buttons">
                                <button class="btn-small btn-start">Start</button>
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
