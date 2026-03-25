<%--
    Document   : Analytics
    Created on : Mar 24, 2026
    Author     : pinju
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Analytics</title>
    <link rel="stylesheet" href="../../Styles/main.css">
    <style>
        .analytics-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 20px;
        }

        .analytics-card {
            background: white;
            padding: 20px;
            border-radius: 14px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
        }

        .card-title {
            font-size: 14px;
            color: #64748b;
            margin-bottom: 10px;
        }

        .card-value {
            font-size: 32px;
            font-weight: 700;
            color: #1e293b;
            margin-bottom: 10px;
        }

        .card-subtitle {
            font-size: 12px;
            color: #10b981;
        }

        .card-red {
            color: #ef4444;
        }

        .mini-chart {
            height: 80px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 8px;
            margin-top: 10px;
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

        .large-container {
            background: white;
            padding: 20px;
            border-radius: 14px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
            margin-bottom: 20px;
        }

        .chart-placeholder {
            height: 300px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 18px;
        }

        .table-compact {
            width: 100%;
            border-collapse: collapse;
        }

        .table-compact th {
            background: #f8fafc;
            padding: 12px;
            text-align: left;
            font-weight: 600;
            border-bottom: 2px solid #e2e8f0;
        }

        .table-compact td {
            padding: 12px;
            border-bottom: 1px solid #f1f5f9;
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
                ☰ &nbsp; ANALYTICS
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
                <h1>Business Analytics</h1>
                <p>In-depth analysis of business metrics</p>
            </div>
        </div>

        <!-- FILTERS -->
        <div class="filters">
            <button class="filter-btn active">Today</button>
            <button class="filter-btn">This Week</button>
            <button class="filter-btn">This Month</button>
            <button class="filter-btn">This Year</button>
        </div>

        <!-- KEY METRICS -->
        <div class="analytics-grid">
            <div class="analytics-card">
                <div class="card-title">Total Customers</div>
                <div class="card-value">1,245</div>
                <div class="card-subtitle">↑ 15 new today</div>
            </div>

            <div class="analytics-card">
                <div class="card-title">Appointment Completion Rate</div>
                <div class="card-value">94%</div>
                <div class="card-subtitle">↑ 2% vs last month</div>
            </div>

            <div class="analytics-card">
                <div class="card-title">Average Service Cost</div>
                <div class="card-value">RM 185</div>
                <div class="card-subtitle">↓ 5% vs last month</div>
            </div>

            <div class="analytics-card">
                <div class="card-title">Pending Payments</div>
                <div class="card-value">RM 8,450</div>
                <div class="card-subtitle card-red">↑ 3 failed transactions</div>
            </div>

            <div class="analytics-card">
                <div class="card-title">Average Wait Time</div>
                <div class="card-value">12 min</div>
                <div class="card-subtitle">↓ 3 min improvement</div>
            </div>

            <div class="analytics-card">
                <div class="card-title">Staff Utilization</div>
                <div class="card-value">87%</div>
                <div class="card-subtitle">↑ 5% efficiency gain</div>
            </div>
        </div>

        <!-- DAILY APPOINTMENTS -->
        <div class="large-container">
            <h3>Daily Appointments Trend</h3>
            <div class="chart-placeholder">
                📊 Appointments trend chart
            </div>
        </div>

        <!-- HOURLY DISTRIBUTION -->
        <div class="large-container">
            <h3>Appointments by Hour</h3>
            <table class="table-compact">
                <thead>
                    <tr>
                        <th>Time Slot</th>
                        <th>Total Appointments</th>
                        <th>Completed</th>
                        <th>Pending</th>
                        <th>Utilization</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>8:00 AM - 10:00 AM</td>
                        <td>12</td>
                        <td>11</td>
                        <td>1</td>
                        <td>92%</td>
                    </tr>
                    <tr>
                        <td>10:00 AM - 12:00 PM</td>
                        <td>15</td>
                        <td>14</td>
                        <td>1</td>
                        <td>93%</td>
                    </tr>
                    <tr>
                        <td>12:00 PM - 2:00 PM</td>
                        <td>8</td>
                        <td>8</td>
                        <td>0</td>
                        <td>89%</td>
                    </tr>
                    <tr>
                        <td>2:00 PM - 4:00 PM</td>
                        <td>18</td>
                        <td>16</td>
                        <td>2</td>
                        <td>88%</td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</div>

</body>
</html>
