<%--
    Document   : ServiceHistory
    Created on : Mar 24, 2026
    Author     : pinju
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Service History</title>
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

        .service-badge {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 500;
            background: #eff6ff;
            color: #1e40af;
        }

        .cost {
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

        .btn-view {
            background: #dbeafe;
            color: #1e40af;
        }

        .btn-view:hover {
            background: #bfdbfe;
        }

        .btn-invoice {
            background: #fef3c7;
            color: #92400e;
        }

        .btn-invoice:hover {
            background: #fde68a;
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

        .summary-cards {
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
                ☰ &nbsp; SERVICE HISTORY
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
                <h1>Service History</h1>
                <p>View your complete service records</p>
            </div>
        </div>

        <!-- SUMMARY CARDS -->
        <div class="summary-cards">
            <div class="summary-card">
                <div class="summary-label">Total Services</div>
                <div class="summary-value">12</div>
            </div>
            <div class="summary-card">
                <div class="summary-label">Total Spent</div>
                <div class="summary-value">RM 2,450</div>
            </div>
            <div class="summary-card">
                <div class="summary-label">Last Service</div>
                <div class="summary-value">Mar 20</div>
            </div>
        </div>

        <!-- FILTERS -->
        <div class="filters">
            <button class="filter-btn active">All</button>
            <button class="filter-btn">Maintenance</button>
            <button class="filter-btn">Repair</button>
            <button class="filter-btn">Inspection</button>
        </div>

        <!-- TABLE -->
        <div class="table-container">
            <div class="table-header">
                <input type="text" class="search-box" placeholder="Search service history...">
            </div>

            <table>
                <thead>
                    <tr>
                        <th>Date</th>
                        <th>Service</th>
                        <th>Vehicle</th>
                        <th>Technician</th>
                        <th>Cost</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>Mar 20, 2026</td>
                        <td><span class="service-badge">Engine Inspection</span></td>
                        <td>Nissan X-Trail</td>
                        <td>Nurul Amin</td>
                        <td class="cost">RM 200</td>
                        <td>
                            <div class="action-buttons">
                                <button class="btn-small btn-view">Details</button>
                                <button class="btn-small btn-invoice">Invoice</button>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>Mar 10, 2026</td>
                        <td><span class="service-badge">Oil Change</span></td>
                        <td>Toyota Camry</td>
                        <td>John Smith</td>
                        <td class="cost">RM 150</td>
                        <td>
                            <div class="action-buttons">
                                <button class="btn-small btn-view">Details</button>
                                <button class="btn-small btn-invoice">Invoice</button>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>Feb 28, 2026</td>
                        <td><span class="service-badge">Brake Service</span></td>
                        <td>BMW 3 Series</td>
                        <td>Ahmad Hassan</td>
                        <td class="cost">RM 250</td>
                        <td>
                            <div class="action-buttons">
                                <button class="btn-small btn-view">Details</button>
                                <button class="btn-small btn-invoice">Invoice</button>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>Feb 15, 2026</td>
                        <td><span class="service-badge">Tire Rotation</span></td>
                        <td>Honda CR-V</td>
                        <td>John Smith</td>
                        <td class="cost">RM 100</td>
                        <td>
                            <div class="action-buttons">
                                <button class="btn-small btn-view">Details</button>
                                <button class="btn-small btn-invoice">Invoice</button>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>Feb 01, 2026</td>
                        <td><span class="service-badge">AC Service</span></td>
                        <td>Nissan X-Trail</td>
                        <td>Nurul Amin</td>
                        <td class="cost">RM 180</td>
                        <td>
                            <div class="action-buttons">
                                <button class="btn-small btn-view">Details</button>
                                <button class="btn-small btn-invoice">Invoice</button>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>Jan 20, 2026</td>
                        <td><span class="service-badge">General Maintenance</span></td>
                        <td>Toyota Camry</td>
                        <td>Ahmad Hassan</td>
                        <td class="cost">RM 175</td>
                        <td>
                            <div class="action-buttons">
                                <button class="btn-small btn-view">Details</button>
                                <button class="btn-small btn-invoice">Invoice</button>
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
