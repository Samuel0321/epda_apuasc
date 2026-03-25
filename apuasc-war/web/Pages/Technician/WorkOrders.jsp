<%--
    Document   : WorkOrders
    Created on : Mar 24, 2026
    Author     : pinju
    Updated   : Workflow Navigation - Added quotation buttons
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

        .badge-assigned {
            background: #bfdbfe;
            color: #1e40af;
        }

        .badge-inspecting {
            background: #fed7aa;
            color: #92400e;
        }

        .badge-quotation {
            background: #fef08a;
            color: #854d0e;
        }

        .badge-approved {
            background: #bbf7d0;
            color: #166534;
        }

        .badge-in-service {
            background: #a78bfa;
            color: #4c1d95;
        }

        .badge-completed {
            background: #c7d2fe;
            color: #3730a3;
        }

        .action-buttons {
            display: flex;
            gap: 5px;
            flex-wrap: wrap;
        }

        .btn-small {
            padding: 6px 10px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 12px;
            font-weight: 500;
            transition: all 0.3s ease;
            white-space: nowrap;
        }

        .btn-start {
            background: #dbeafe;
            color: #1e40af;
        }

        .btn-start:hover {
            background: #bfdbfe;
        }

        .btn-quotation {
            background: #fcd34d;
            color: #854d0e;
            font-weight: 600;
        }

        .btn-quotation:hover {
            background: #fbbf24;
        }

        .btn-complete {
            background: #bbf7d0;
            color: #166534;
        }

        .btn-complete:hover {
            background: #86efac;
        }

        .btn-view {
            background: #f3f4f6;
            color: #1f2937;
        }

        .btn-view:hover {
            background: #e5e7eb;
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

        .info-banner {
            background: #dbeafe;
            border-left: 4px solid #2563eb;
            padding: 12px;
            border-radius: 6px;
            margin-bottom: 15px;
            font-size: 13px;
            color: #1e40af;
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
                        <div class="name">John Smith</div>
                        <div class="email">john.smith@autofix.com</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- HEADER -->
        <div class="header-row">
            <div class="header-text">
                <h1>Work Orders</h1>
                <p>View all assigned work orders and manage quotations</p>
            </div>
        </div>

        <!-- INFO BANNER -->
        <div class="info-banner">
            💡 <strong>Quick Navigation:</strong> Click "Create Quotation" to submit your inspection and services
        </div>

        <!-- FILTERS -->
        <div class="filters">
            <button class="filter-btn active">All</button>
            <button class="filter-btn">Assigned</button>
            <button class="filter-btn">Inspecting</button>
            <button class="filter-btn">Quotation Ready</button>
            <button class="filter-btn">Approved</button>
            <button class="filter-btn">In Service</button>
            <button class="filter-btn">Completed</button>
        </div>

        <!-- TABLE -->
        <div class="table-container">
            <div class="table-header">
                <input type="text" class="search-box" placeholder="Search by customer, service, or vehicle...">
            </div>

            <table>
                <thead>
                    <tr>
                        <th>Order ID</th>
                        <th>Customer</th>
                        <th>Service</th>
                        <th>Vehicle</th>
                        <th>Workflow Status</th>
                        <th>Scheduled</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <!-- ASSIGNED - Ready for Inspection -->
                    <tr>
                        <td><strong>#WO001</strong></td>
                        <td>Ahmad Faisal</td>
                        <td>Engine Inspection & Oil Change</td>
                        <td>Toyota Camry (2020)</td>
                        <td><span class="badge badge-assigned">🔵 ASSIGNED</span></td>
                        <td>Mar 25, 10:00 AM</td>
                        <td>
                            <div class="action-buttons">
                                <button class="btn-small btn-start" onclick="startInspection('WO001')">Start Inspection</button>
                            </div>
                        </td>
                    </tr>

                    <!-- INSPECTING - In Progress -->
                    <tr>
                        <td><strong>#WO002</strong></td>
                        <td>Nurul Huda</td>
                        <td>Brake System Inspection</td>
                        <td>Honda CR-V (2019)</td>
                        <td><span class="badge badge-inspecting">🔄 INSPECTING</span></td>
                        <td>Mar 25, 2:00 PM</td>
                        <td>
                            <div class="action-buttons">
                                <button class="btn-small btn-quotation" onclick="goToQuotation('WO002')">Create Quotation →</button>
                            </div>
                        </td>
                    </tr>

                    <!-- QUOTATION - Ready to Submit -->
                    <tr>
                        <td><strong>#WO003</strong></td>
                        <td>Siti Aminah</td>
                        <td>Oil Change & Maintenance</td>
                        <td>Nissan X-Trail (2021)</td>
                        <td><span class="badge badge-quotation">📝 QUOTATION READY</span></td>
                        <td>Mar 26, 11:00 AM</td>
                        <td>
                            <div class="action-buttons">
                                <button class="btn-small btn-quotation" onclick="goToQuotation('WO003')">Submit Quotation</button>
                            </div>
                        </td>
                    </tr>

                    <!-- QUOTATION SUBMITTED - Waiting Approval -->
                    <tr>
                        <td><strong>#WO004</strong></td>
                        <td>Muhammad Ali</td>
                        <td>Full Vehicle Inspection</td>
                        <td>Petronas Perdana (2018)</td>
                        <td><span class="badge badge-quotation">⏳ WAITING APPROVAL</span></td>
                        <td>Mar 27, 3:00 PM</td>
                        <td>
                            <div class="action-buttons">
                                <button class="btn-small btn-view" onclick="viewQuotation('WO004')">View Quotation</button>
                            </div>
                        </td>
                    </tr>

                    <!-- APPROVED - Ready to Service -->
                    <tr>
                        <td><strong>#WO005</strong></td>
                        <td>Zahra Rahman</td>
                        <td>General Maintenance</td>
                        <td>BMW 3 Series (2021)</td>
                        <td><span class="badge badge-approved">✅ APPROVED</span></td>
                        <td>Mar 28, 9:00 AM</td>
                        <td>
                            <div class="action-buttons">
                                <button class="btn-small btn-complete" onclick="startService('WO005')">Start Service</button>
                            </div>
                        </td>
                    </tr>

                    <!-- IN SERVICE - Performing Service -->
                    <tr>
                        <td><strong>#WO006</strong></td>
                        <td>Hassan Ibrahim</td>
                        <td>Battery Replacement</td>
                        <td>Toyota Corolla (2018)</td>
                        <td><span class="badge badge-in-service">🔧 IN SERVICE</span></td>
                        <td>Mar 24, 1:00 PM</td>
                        <td>
                            <div class="action-buttons">
                                <button class="btn-small btn-complete" onclick="completeService('WO006')">Mark Complete</button>
                            </div>
                        </td>
                    </tr>

                    <!-- COMPLETED - Service Done -->
                    <tr>
                        <td><strong>#WO007</strong></td>
                        <td>Fatima Karim</td>
                        <td>Spark Plugs & Diagnostics</td>
                        <td>Mazda CX-5 (2020)</td>
                        <td><span class="badge badge-completed">✅ COMPLETED</span></td>
                        <td>Mar 22, 11:00 AM</td>
                        <td>
                            <div class="action-buttons">
                                <button class="btn-small btn-view">View Details</button>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script>
    function startInspection(orderId) {
        alert('🔍 Starting inspection for ' + orderId);
        window.location.href = 'CreateQuotation.jsp?id=' + orderId;
    }

    function goToQuotation(orderId) {
        window.location.href = 'CreateQuotation.jsp?id=' + orderId;
    }

    function viewQuotation(orderId) {
        alert('View quotation for ' + orderId);
    }

    function startService(orderId) {
        alert('🔧 Service starting for ' + orderId);
    }

    function completeService(orderId) {
        if (confirm('Mark this service as COMPLETED?')) {
            alert('✅ Service marked complete! Waiting for payment.');
            location.reload();
        }
    }
</script>

</body>
</html>
