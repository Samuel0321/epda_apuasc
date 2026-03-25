<%--Document   : Reports
    Created on : Mar 24, 2026
    Author     : pinju
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Reports</title>
    <link rel="stylesheet" href="../../Styles/main.css">
    <style>
        .report-container {
            background: white;
            padding: 20px;
            border-radius: 14px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
            margin-bottom: 20px;
        }

        .report-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .report-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 20px;
        }

        .stat-card {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
        }

        .stat-label {
            font-size: 12px;
            color: #64748b;
            margin-bottom: 8px;
        }

        .stat-value {
            font-size: 28px;
            font-weight: 700;
            color: #1e293b;
        }

        .stat-change {
            font-size: 12px;
            color: #10b981;
            margin-top: 5px;
        }

        .chart-area {
            position: relative;
            width: 100%;
            height: 300px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 18px;
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

        .btn-export {
            padding: 10px 14px;
            background: #2563eb;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 500;
        }

        .btn-export:hover {
            background: #1d4ed8;
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
                ☰ &nbsp; REPORTS
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
                <h1>System Reports</h1>
                <p>View analytics and business reports</p>
            </div>
            <div class="actions">
                <button class="btn-export">📥 Export Report</button>
            </div>
        </div>

        <!-- FILTERS -->
        <div class="filters">
            <button class="filter-btn active">This Month</button>
            <button class="filter-btn">Last Month</button>
            <button class="filter-btn">This Year</button>
            <button class="filter-btn">Custom Range</button>
        </div>

        <!-- KEY STATISTICS -->
        <div class="report-stats">
            <div class="stat-card">
                <div class="stat-label">Total Appointments</div>
                <div class="stat-value">245</div>
                <div class="stat-change">↑ 12% from last month</div>
            </div>
            <div class="stat-card">
                <div class="stat-label">Revenue</div>
                <div class="stat-value">RM 45,320</div>
                <div class="stat-change">↑ 8% from last month</div>
            </div>
            <div class="stat-card">
                <div class="stat-label">Completed Services</div>
                <div class="stat-value">212</div>
                <div class="stat-change">↑ 5% completion rate</div>
            </div>
            <div class="stat-card">
                <div class="stat-label">Customer Satisfaction</div>
                <div class="stat-value">4.8/5</div>
                <div class="stat-change">Based on 89 reviews</div>
            </div>
        </div>

        <!-- APPOINTMENTS CHART -->
        <div class="report-container">
            <h3>Appointments Trend</h3>
            <div class="chart-area">
                📊 Chart visualization would appear here
            </div>
        </div>

        <!-- REVENUE CHART -->
        <div class="report-container">
            <h3>Revenue Overview</h3>
            <div class="chart-area">
                📈 Revenue chart would appear here
            </div>
        </div>

        <!-- SERVICE POPULAR -->
        <div class="report-container">
            <h3>Most Popular Services</h3>
            <div style="padding: 20px 0;">
                <div style="margin-bottom: 15px;">
                    <div style="display: flex; justify-content: space-between; margin-bottom: 5px;">
                        <span>Oil Change</span>
                        <span>45</span>
                    </div>
                    <div style="background: #e5e7eb; height: 8px; border-radius: 4px;">
                        <div style="background: #2563eb; height: 8px; border-radius: 4px; width: 90%;"></div>
                    </div>
                </div>
                <div style="margin-bottom: 15px;">
                    <div style="display: flex; justify-content: space-between; margin-bottom: 5px;">
                        <span>Brake Service</span>
                        <span>38</span>
                    </div>
                    <div style="background: #e5e7eb; height: 8px; border-radius: 4px;">
                        <div style="background: #10b981; height: 8px; border-radius: 4px; width: 76%;"></div>
                    </div>
                </div>
                <div style="margin-bottom: 15px;">
                    <div style="display: flex; justify-content: space-between; margin-bottom: 5px;">
                        <span>Tire Service</span>
                        <span>32</span>
                    </div>
                    <div style="background: #e5e7eb; height: 8px; border-radius: 4px;">
                        <div style="background: #f59e0b; height: 8px; border-radius: 4px; width: 64%;"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>
