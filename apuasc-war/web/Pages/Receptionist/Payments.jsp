<%--
    Document   : Payments
    Created on : Mar 24, 2026
    Author     : pinju
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Payments</title>
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

        .badge-paid {
            background: #bbf7d0;
            color: #166534;
        }

        .badge-pending {
            background: #fef08a;
            color: #854d0e;
        }

        .badge-failed {
            background: #fecaca;
            color: #7f1d1d;
        }

        .amount {
            font-weight: 600;
            color: #1e293b;
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

        .btn-pay {
            background: #bbf7d0;
            color: #166534;
        }

        .btn-pay:hover {
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

        .summary {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 20px;
        }

        .summary-card {
            background: white;
            padding: 15px;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
        }

        .summary-label {
            font-size: 12px;
            color: #64748b;
            margin-bottom: 5px;
        }

        .summary-value {
            font-size: 24px;
            font-weight: 700;
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
                ☰ &nbsp; PAYMENTS
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
                <h1>Payment Management</h1>
                <p>Process and track customer payments</p>
            </div>
        </div>

        <!-- SUMMARY CARDS -->
        <div class="summary">
            <div class="summary-card">
                <div class="summary-label">Total Payments Today</div>
                <div class="summary-value">RM 3,450</div>
            </div>
            <div class="summary-card">
                <div class="summary-label">Pending Payments</div>
                <div class="summary-value">5</div>
            </div>
            <div class="summary-card">
                <div class="summary-label">Failed Transactions</div>
                <div class="summary-value">1</div>
            </div>
        </div>

        <!-- FILTERS -->
        <div class="filters">
            <button class="filter-btn active">All</button>
            <button class="filter-btn">Paid</button>
            <button class="filter-btn">Pending</button>
            <button class="filter-btn">Failed</button>
        </div>

        <!-- TABLE -->
        <div class="table-container">
            <div class="table-header">
                <input type="text" class="search-box" placeholder="Search by customer or transaction ID...">
            </div>

            <table>
                <thead>
                    <tr>
                        <th>Invoice ID</th>
                        <th>Customer</th>
                        <th>Service</th>
                        <th>Amount</th>
                        <th>Payment Date</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>#INV001</td>
                        <td>Ahmad Faisal</td>
                        <td>Oil Change</td>
                        <td class="amount">RM 150</td>
                        <td>Mar 20, 2026</td>
                        <td><span class="badge badge-paid">Paid</span></td>
                        <td>
                            <div class="action-buttons">
                                <button class="btn-small btn-info">View</button>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>#INV002</td>
                        <td>Nurul Huda</td>
                        <td>Brake Inspection</td>
                        <td class="amount">RM 200</td>
                        <td>Mar 24, 2026</td>
                        <td><span class="badge badge-pending">Pending</span></td>
                        <td>
                            <div class="action-buttons">
                                <button class="btn-small btn-info">View</button>
                                <button class="btn-small btn-pay">Process</button>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>#INV003</td>
                        <td>Siti Aminah</td>
                        <td>Tire Rotation</td>
                        <td class="amount">RM 100</td>
                        <td>Mar 21, 2026</td>
                        <td><span class="badge badge-paid">Paid</span></td>
                        <td>
                            <div class="action-buttons">
                                <button class="btn-small btn-info">View</button>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>#INV004</td>
                        <td>Muhammad Ali</td>
                        <td>AC Service</td>
                        <td class="amount">RM 250</td>
                        <td>Mar 23, 2026</td>
                        <td><span class="badge badge-failed">Failed</span></td>
                        <td>
                            <div class="action-buttons">
                                <button class="btn-small btn-info">View</button>
                                <button class="btn-small btn-pay">Retry</button>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>#INV005</td>
                        <td>Zahra Rahman</td>
                        <td>General Maintenance</td>
                        <td class="amount">RM 180</td>
                        <td>Mar 24, 2026</td>
                        <td><span class="badge badge-pending">Pending</span></td>
                        <td>
                            <div class="action-buttons">
                                <button class="btn-small btn-info">View</button>
                                <button class="btn-small btn-pay">Process</button>
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
