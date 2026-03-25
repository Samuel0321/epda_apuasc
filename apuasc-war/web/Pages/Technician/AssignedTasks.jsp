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

        /* Modal Styles */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.5);
        }

        .modal.show {
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .modal-content {
            background: white;
            padding: 30px;
            border-radius: 12px;
            width: 90%;
            max-width: 500px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
        }

        .modal-header {
            font-size: 20px;
            font-weight: 600;
            color: #1e293b;
            margin-bottom: 20px;
        }

        .modal-body {
            margin-bottom: 20px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
        }

        .form-group label {
            font-weight: 500;
            color: #1e293b;
            margin-bottom: 8px;
            font-size: 14px;
        }

        .form-group textarea {
            padding: 12px;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            font-family: 'Segoe UI', sans-serif;
            font-size: 14px;
            resize: vertical;
            min-height: 120px;
        }

        .form-group textarea:focus {
            outline: none;
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }

        .modal-actions {
            display: flex;
            gap: 10px;
            justify-content: flex-end;
        }

        .modal-actions button {
            padding: 10px 16px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .btn-confirm {
            background: #10b981;
            color: white;
        }

        .btn-confirm:hover {
            background: #059669;
        }

        .btn-cancel-modal {
            background: #e2e8f0;
            color: #1e293b;
        }

        .btn-cancel-modal:hover {
            background: #cbd5e1;
        }

        .comment-info {
            background: #eff6ff;
            border-left: 3px solid #2563eb;
            padding: 12px;
            border-radius: 4px;
            font-size: 13px;
            color: #1e40af;
            margin-bottom: 15px;
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
            <button class="filter-btn">Assigned</button>
            <button class="filter-btn">Inspection</button>
            <button class="filter-btn">Quotation</button>
            <button class="filter-btn">In Service</button>
            <button class="filter-btn">Completed</button>
        </div>

        <!-- TASK CARDS -->
        <div class="tasks-container">
            <!-- Task 1: ASSIGNED -->
            <div class="task-card">
                <div class="task-header">
                    <div class="task-id">#APT001</div>
                    <div class="task-title">Engine Inspection</div>
                </div>
                <div class="task-body">
                    <div class="task-customer">👤 Ahmad Faisal</div>
                    <span class="task-service">Normal Service</span>
                    <div class="task-time">📅 Mar 25, 2026 · 10:00 AM</div>
                    <div class="task-status status-new">🔵 ASSIGNED</div>
                    <div class="task-time" style="color: #1e293b; margin-top: 8px;">Issue: Engine loud noise & vibrations</div>
                    <div class="task-actions">
                        <button class="task-btn btn-action" onclick="startInspection(1)">Start Inspection</button>
                    </div>
                </div>
            </div>

            <!-- Task 2: INSPECTION IN PROGRESS -->
            <div class="task-card in-progress">
                <div class="task-header">
                    <div class="task-id">#APT002</div>
                    <div class="task-title">Brake System Inspection</div>
                </div>
                <div class="task-body">
                    <div class="task-customer">👤 Nurul Huda</div>
                    <span class="task-service">Major Service</span>
                    <div class="task-time">📅 Mar 25, 2026 · 2:00 PM</div>
                    <div class="task-status status-in-progress">🔄 INSPECTING</div>
                    <div class="task-progress">
                        <div class="progress-label">Inspection Progress</div>
                        <div class="progress-bar">
                            <div class="progress-fill" style="width: 50%;"></div>
                        </div>
                    </div>
                    <div class="task-actions">
                        <button class="task-btn btn-action" onclick="finishInspection(2)">Finish Inspection</button>
                    </div>
                </div>
            </div>

            <!-- Task 3: READY FOR QUOTATION -->
            <div class="task-card">
                <div class="task-header">
                    <div class="task-id">#APT003</div>
                    <div class="task-title">Oil Change & Maintenance</div>
                </div>
                <div class="task-body">
                    <div class="task-customer">👤 Siti Aminah</div>
                    <span class="task-service">Normal Service</span>
                    <div class="task-time">📅 Mar 26, 2026 · 11:00 AM</div>
                    <div class="task-status status-in-progress">📝 INSPECTION DONE</div>
                    <div class="task-time" style="color: #1e293b; margin-top: 8px;">Status: Ready to submit quotation</div>
                    <div class="task-actions">
                        <button class="task-btn btn-action" onclick="submitQuotation(3)">Submit Quotation</button>
                    </div>
                </div>
            </div>

            <!-- Task 4: QUOTATION SUBMITTED WAITING APPROVAL -->
            <div class="task-card">
                <div class="task-header">
                    <div class="task-id">#APT004</div>
                    <div class="task-title">Full Vehicle Inspection</div>
                </div>
                <div class="task-body">
                    <div class="task-customer">👤 Muhammad Ali</div>
                    <span class="task-service">Major Service</span>
                    <div class="task-time">📅 Mar 27, 2026 · 3:00 PM</div>
                    <div class="task-status status-in-progress">⏳ QUOTATION SUBMITTED</div>
                    <div class="task-time" style="color: #1e293b; margin-top: 8px;">Quotation: RM 450 | Waiting for approval</div>
                    <div class="task-actions">
                        <button class="task-btn btn-view">View Quotation</button>
                    </div>
                </div>
            </div>

            <!-- Task 5: APPROVED - IN SERVICE -->
            <div class="task-card in-progress">
                <div class="task-header">
                    <div class="task-id">#APT005</div>
                    <div class="task-title">Battery Replacement</div>
                </div>
                <div class="task-body">
                    <div class="task-customer">👤 Hassan Ibrahim</div>
                    <span class="task-service">Normal Service</span>
                    <div class="task-time">📅 Mar 24, 2026 · 1:00 PM</div>
                    <div class="task-status status-in-progress">🔧 IN SERVICE</div>
                    <div class="task-progress">
                        <div class="progress-label">Service Progress</div>
                        <div class="progress-bar">
                            <div class="progress-fill" style="width: 75%;"></div>
                        </div>
                    </div>
                    <div class="task-actions">
                        <button class="task-btn btn-action" onclick="completeService(5)">Mark Complete</button>
                    </div>
                </div>
            </div>

            <!-- Task 6: COMPLETED -->
            <div class="task-card completed">
                <div class="task-header">
                    <div class="task-id">#APT006</div>
                    <div class="task-title">Spark Plugs & Diagnostics</div>
                </div>
                <div class="task-body">
                    <div class="task-customer">👤 Fatima Karim</div>
                    <span class="task-service">Normal Service</span>
                    <div class="task-time">📅 Mar 22, 2026 · 11:00 AM</div>
                    <div class="task-status status-completed">✅ COMPLETED</div>
                    <div class="task-time" style="color: #1e293b; margin-top: 8px;">Amount: RM 150 | Awaiting payment</div>
                    <div class="task-actions">
                        <button class="task-btn btn-view">View Details</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- COMPLETION COMMENT MODAL -->
<div id="completeModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">📝 Mark Service as Complete</div>
        <div class="modal-body">
            <div class="comment-info">
                ℹ️ Please provide a summary of the work completed. This will be visible to the receptionist and customer.
            </div>
            <div class="form-group">
                <label for="completionComment">Service Completion Notes *</label>
                <textarea id="completionComment" placeholder="Describe what was done, any repairs made, parts replaced, findings, recommendations for future maintenance, etc..."></textarea>
            </div>
        </div>
        <div class="modal-actions">
            <button class="btn-cancel-modal" onclick="closeCompleteModal()">Cancel</button>
            <button class="btn-confirm" onclick="confirmCompletion()">✓ Mark Complete</button>
        </div>
    </div>
</div>

</body>
</html>
