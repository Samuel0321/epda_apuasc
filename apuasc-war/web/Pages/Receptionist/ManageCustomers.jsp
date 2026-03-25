<%--
    Document   : ManageCustomers
    Created on : Mar 25, 2026
    Author     : pinju
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Customers</title>
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
            flex-wrap: wrap;
        }

        .search-box {
            flex: 1;
            min-width: 240px;
            padding: 10px 12px;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            font-size: 14px;
        }

        .btn-new {
            padding: 10px 14px;
            border: none;
            border-radius: 8px;
            background: #2563eb;
            color: white;
            font-weight: 500;
            cursor: pointer;
        }

        .btn-new:hover {
            background: #1d4ed8;
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

        .action-buttons {
            display: flex;
            gap: 6px;
            flex-wrap: wrap;
        }

        .btn-small {
            padding: 6px 10px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 12px;
            font-weight: 500;
        }

        .btn-view {
            background: #dbeafe;
            color: #1e40af;
        }

        .btn-edit {
            background: #fef3c7;
            color: #92400e;
        }

        .btn-delete {
            background: #fecaca;
            color: #7f1d1d;
        }
    </style>
</head>

<body>

<div class="layout">
    <jsp:include page="../../Component/Sidebar.jsp" />

    <div class="main">
        <div class="topbar">
            <div class="topbar-left">
                ☰ &nbsp; MANAGE CUSTOMERS
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

        <div class="header-row">
            <div class="header-text">
                <h1>Customer Directory</h1>
                <p>Search, update, and remove customer records</p>
            </div>
        </div>

        <div class="table-container">
            <div class="table-header">
                <input type="text" class="search-box" placeholder="Search by name, phone, or email...">
                <button class="btn-new" onclick="window.location.href='RegisterCustomer.jsp'">+ Create Customer</button>
            </div>

            <table>
                <thead>
                    <tr>
                        <th>Customer ID</th>
                        <th>Name</th>
                        <th>Phone</th>
                        <th>Email</th>
                        <th>Vehicle</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>#C001</td>
                        <td>Ahmad Faisal</td>
                        <td>+60 12-234 5678</td>
                        <td>ahmad@example.com</td>
                        <td>Toyota Vios</td>
                        <td>
                            <div class="action-buttons">
                                <button class="btn-small btn-view">View</button>
                                <button class="btn-small btn-edit">Update</button>
                                <button class="btn-small btn-delete">Delete</button>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>#C002</td>
                        <td>Nurul Huda</td>
                        <td>+60 13-765 4321</td>
                        <td>nurul@example.com</td>
                        <td>Honda City</td>
                        <td>
                            <div class="action-buttons">
                                <button class="btn-small btn-view">View</button>
                                <button class="btn-small btn-edit">Update</button>
                                <button class="btn-small btn-delete">Delete</button>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>#C003</td>
                        <td>Siti Aminah</td>
                        <td>+60 17-111 2233</td>
                        <td>siti@example.com</td>
                        <td>Perodua Myvi</td>
                        <td>
                            <div class="action-buttons">
                                <button class="btn-small btn-view">View</button>
                                <button class="btn-small btn-edit">Update</button>
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
