<%--
    Document   : AssignedTasks
    Created on : Mar 24, 2026
    Author     : pinju
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Assigned Tasks</title>
    <link rel="stylesheet" href="../../Styles/main.css">
    <style>
        .tasks-container {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 20px;
        }

        .task-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
            overflow: hidden;
            border-left: 4px solid #2563eb;
            transition: all 0.3s ease;
            cursor: pointer;
        }

        .task-card:hover {
            box-shadow: 0 8px 20px rgba(0,0,0,0.1);
            transform: translateY(-2px);
        }

        .task-card.completed {
            border-left-color: #10b981;
        }

        .task-card.in-progress {
            border-left-color: #f59e0b;
        }

        .task-header {
            padding: 15px 20px;
            background: #f8fafc;
            border-bottom: 1px solid #e5e7eb;
        }

        .task-id {
            font-size: 12px;
            color: #64748b;
            margin-bottom: 5px;
        }

        .task-title {
            font-size: 16px;
            font-weight: 600;
            color: #1e293b;
        }

        .task-body {
            padding: 15px 20px;
        }

        .task-customer {
            font-size: 14px;
            color: #475569;
            margin-bottom: 8px;
        }

        .task-service {
            font-size: 13px;
            color: #64748b;
            margin-bottom: 10px;
            padding: 6px 10px;
            background: #eff6ff;
            border-radius: 4px;
            display: inline-block;
        }

        .task-time {
            font-size: 12px;
            color: #64748b;
            margin-bottom: 10px;
        }

        .task-status {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: 600;
            margin-bottom: 12px;
        }

        .status-new {
            background: #dbeafe;
            color: #1e40af;
        }

        .status-in-progress {
            background: #fed7aa;
            color: #92400e;
        }

        .status-completed {
            background: #bbf7d0;
            color: #166534;
        }

        .task-progress {
            margin-bottom: 10px;
        }

        .progress-label {
            font-size: 12px;
            color: #64748b;
            margin-bottom: 5px;
        }

        .progress-bar {
            height: 6px;
            background: #e5e7eb;
            border-radius: 3px;
            overflow: hidden;
        }

        .progress-fill {
            height: 100%;
            background: #2563eb;
            border-radius: 3px;
        }

        .task-actions {
            display: flex;
            gap: 8px;
            margin-top: 12px;
        }

        .task-btn {
            flex: 1;
            padding: 8px 12px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 12px;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .btn-action {
            background: #2563eb;
            color: white;
        }

        .btn-action:hover {
            background: #1d4ed8;
        }

        .btn-view {
            background: #e5e7eb;
            color: #1e293b;
        }

        .btn-view:hover {
            background: #d1d5db;
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
                ☰ &nbsp; ASSIGNED TASKS
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
                <h1>My Tasks</h1>
                <p>View and manage your assigned tasks</p>
            </div>
        </div>

        <!-- FILTERS -->
        <div class="filters">
            <button class="filter-btn active">All</button>
            <button class="filter-btn">New</button>
            <button class="filter-btn">In Progress</button>
            <button class="filter-btn">Completed</button>
        </div>

        <!-- TASK CARDS -->
        <div class="tasks-container">
            <!-- Task 1 -->
            <div class="task-card">
                <div class="task-header">
                    <div class="task-id">#TASK001</div>
                    <div class="task-title">Oil Change</div>
                </div>
                <div class="task-body">
                    <div class="task-customer">👤 Ahmad Faisal</div>
                    <span class="task-service">Routine Service</span>
                    <div class="task-time">📅 Mar 25, 2026 · 10:00 AM</div>
                    <div class="task-status status-new">New</div>
                    <div class="task-progress">
                        <div class="progress-label">Progress</div>
                        <div class="progress-bar">
                            <div class="progress-fill" style="width: 0%;"></div>
                        </div>
                    </div>
                    <div class="task-actions">
                        <button class="task-btn btn-action">Start Task</button>
                    </div>
                </div>
            </div>

            <!-- Task 2 -->
            <div class="task-card in-progress">
                <div class="task-header">
                    <div class="task-id">#TASK002</div>
                    <div class="task-title">Brake Inspection</div>
                </div>
                <div class="task-body">
                    <div class="task-customer">👤 Nurul Huda</div>
                    <span class="task-service">Inspection</span>
                    <div class="task-time">📅 Mar 25, 2026 · 11:30 AM</div>
                    <div class="task-status status-in-progress">In Progress</div>
                    <div class="task-progress">
                        <div class="progress-label">Progress</div>
                        <div class="progress-bar">
                            <div class="progress-fill" style="width: 60%;"></div>
                        </div>
                    </div>
                    <div class="task-actions">
                        <button class="task-btn btn-action">Complete</button>
                    </div>
                </div>
            </div>

            <!-- Task 3 -->
            <div class="task-card completed">
                <div class="task-header">
                    <div class="task-id">#TASK003</div>
                    <div class="task-title">Tire Rotation</div>
                </div>
                <div class="task-body">
                    <div class="task-customer">👤 Siti Aminah</div>
                    <span class="task-service">Maintenance</span>
                    <div class="task-time">📅 Mar 24, 2026 · 2:00 PM</div>
                    <div class="task-status status-completed">Completed</div>
                    <div class="task-progress">
                        <div class="progress-label">Progress</div>
                        <div class="progress-bar">
                            <div class="progress-fill" style="width: 100%;"></div>
                        </div>
                    </div>
                    <div class="task-actions">
                        <button class="task-btn btn-view">View Details</button>
                    </div>
                </div>
            </div>

            <!-- Task 4 -->
            <div class="task-card">
                <div class="task-header">
                    <div class="task-id">#TASK004</div>
                    <div class="task-title">AC Service</div>
                </div>
                <div class="task-body">
                    <div class="task-customer">👤 Muhammad Ali</div>
                    <span class="task-service">Service</span>
                    <div class="task-time">📅 Mar 26, 2026 · 9:00 AM</div>
                    <div class="task-status status-new">New</div>
                    <div class="task-progress">
                        <div class="progress-label">Progress</div>
                        <div class="progress-bar">
                            <div class="progress-fill" style="width: 0%;"></div>
                        </div>
                    </div>
                    <div class="task-actions">
                        <button class="task-btn btn-action">Start Task</button>
                    </div>
                </div>
            </div>

            <!-- Task 5 -->
            <div class="task-card">
                <div class="task-header">
                    <div class="task-id">#TASK005</div>
                    <div class="task-title">Battery Check</div>
                </div>
                <div class="task-body">
                    <div class="task-customer">👤 Zahra Rahman</div>
                    <span class="task-service">Inspection</span>
                    <div class="task-time">📅 Mar 26, 2026 · 10:30 AM</div>
                    <div class="task-status status-new">New</div>
                    <div class="task-progress">
                        <div class="progress-label">Progress</div>
                        <div class="progress-bar">
                            <div class="progress-fill" style="width: 0%;"></div>
                        </div>
                    </div>
                    <div class="task-actions">
                        <button class="task-btn btn-action">Start Task</button>
                    </div>
                </div>
            </div>

            <!-- Task 6 -->
            <div class="task-card completed">
                <div class="task-header">
                    <div class="task-id">#TASK006</div>
                    <div class="task-title">Engine Inspection</div>
                </div>
                <div class="task-body">
                    <div class="task-customer">👤 Rashid Hassan</div>
                    <span class="task-service">Inspection</span>
                    <div class="task-time">📅 Mar 23, 2026 · 3:00 PM</div>
                    <div class="task-status status-completed">Completed</div>
                    <div class="task-progress">
                        <div class="progress-label">Progress</div>
                        <div class="progress-bar">
                            <div class="progress-fill" style="width: 100%;"></div>
                        </div>
                    </div>
                    <div class="task-actions">
                        <button class="task-btn btn-view">View Details</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>
