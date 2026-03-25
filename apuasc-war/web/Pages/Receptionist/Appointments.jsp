<%--
    Document   : Appointments
    Created on : Mar 24, 2026
    Author     : pinju
    Updated   : New Workflow (PENDING -> ASSIGNED -> WAITING APPROVAL -> APPROVED -> COMPLETED -> PAID)
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Appointments Management</title>
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

        .badge-assigned {
            background: #bfdbfe;
            color: #1e40af;
        }

        .badge-waiting-approval {
            background: #fed7aa;
            color: #92400e;
        }

        .badge-approved {
            background: #bbf7d0;
            color: #166534;
        }

        .badge-rejected {
            background: #fecaca;
            color: #7f1d1d;
        }

        .badge-completed {
            background: #c7d2fe;
            color: #3730a3;
        }

        .badge-paid {
            background: #86efac;
            color: #166534;
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
        }

        .btn-assign {
            background: #bfdbfe;
            color: #1e40af;
        }

        .btn-assign:hover {
            background: #93c5fd;
        }

        .btn-approve {
            background: #bbf7d0;
            color: #166534;
        }

        .btn-approve:hover {
            background: #86efac;
        }

        .btn-view {
            background: #dbeafe;
            color: #1e40af;
        }

        .btn-view:hover {
            background: #bfdbfe;
        }

        .btn-collect {
            background: #fbbf24;
            color: #92400e;
        }

        .btn-collect:hover {
            background: #fcd34d;
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

        /* Comment Modal Styles */
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
            max-width: 600px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            max-height: 80vh;
            overflow-y: auto;
        }

        .modal-header {
            font-size: 20px;
            font-weight: 600;
            color: #1e293b;
            margin-bottom: 20px;
        }

        .comment-section {
            background: #f8fafc;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 15px;
            border-left: 4px solid #2563eb;
        }

        .comment-label {
            font-weight: 600;
            color: #1e293b;
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 8px;
        }

        .comment-text {
            color: #475569;
            line-height: 1.6;
            font-size: 14px;
            white-space: pre-wrap;
        }

        .comment-meta {
            font-size: 12px;
            color: #64748b;
            margin-top: 10px;
            padding-top: 10px;
            border-top: 1px solid #e2e8f0;
        }

        .modal-actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 20px;
        }

        .btn-close-modal {
            padding: 10px 16px;
            border: none;
            background: #e2e8f0;
            color: #1e293b;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .btn-close-modal:hover {
            background: #cbd5e1;
        }

        .comment-icon {
            display: inline-block;
            padding: 4px 8px;
            background: #dbeafe;
            color: #1e40af;
            border-radius: 4px;
            font-size: 11px;
            font-weight: 600;
            margin-right: 5px;
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
            <button class="filter-btn">Assigned</button>
            <button class="filter-btn">Waiting Approval</button>
            <button class="filter-btn">Approved</button>
            <button class="filter-btn">Completed</button>
            <button class="filter-btn">Paid</button>
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
                        <th>Service Type</th>
                        <th>Issue Description</th>
                        <th>Appointment Date</th>
                        <th>Technician</th>
                        <th>Status</th>
                        <th>Quotation</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <!-- STATUS: PENDING (Waiting for Technician Assignment) -->
                    <tr>
                        <td>#APT001</td>
                        <td>Ahmad Faisal</td>
                        <td>Normal Service</td>
                        <td>Engine loud noise, vibrations</td>
                        <td>Mar 25, 2026 - 10:00 AM</td>
                        <td>-</td>
                        <td><span class="badge badge-pending">PENDING</span></td>
                        <td>-</td>
                        <td>
                            <div class="action-buttons">
                                <button class="btn-small btn-view">View Details</button>
                                <button class="btn-small btn-assign" onclick="assignTechnician(1)">Assign Tech</button>
                            </div>
                        </td>
                    </tr>

                    <!-- STATUS: ASSIGNED (Technician Assigned, Waiting Quotation) -->
                    <tr>
                        <td>#APT002</td>
                        <td>Nurul Huda</td>
                        <td>Major Service</td>
                        <td>Brake system inspection needed</td>
                        <td>Mar 25, 2026 - 2:00 PM</td>
                        <td>John Smith</td>
                        <td><span class="badge badge-assigned">ASSIGNED</span></td>
                        <td>-</td>
                        <td>
                            <div class="action-buttons">
                                <button class="btn-small btn-view">View Details</button>
                            </div>
                        </td>
                    </tr>

                    <!-- STATUS: WAITING APPROVAL (Technician submitted Quotation) -->
                    <tr>
                        <td>#APT003</td>
                        <td>Siti Aminah</td>
                        <td>Normal Service</td>
                        <td>Oil change and filter replacement</td>
                        <td>Mar 26, 2026 - 11:00 AM</td>
                        <td>Ahmad Hassan</td>
                        <td><span class="badge badge-waiting-approval">WAITING APPROVAL</span></td>
                        <td><strong>RM 250</strong></td>
                        <td>
                            <div class="action-buttons">
                                <button class="btn-small btn-view">View Quotation</button>
                                <button class="btn-small btn-approve" onclick="approveQuotation(3)">Approve</button>
                            </div>
                        </td>
                    </tr>

                    <!-- STATUS: APPROVED (Customer approved Quotation) -->
                    <tr>
                        <td>#APT004</td>
                        <td>Muhammad Ali</td>
                        <td>Major Service</td>
                        <td>Full vehicle inspection and maintenance</td>
                        <td>Mar 27, 2026 - 3:00 PM</td>
                        <td>Nurul Amin</td>
                        <td><span class="badge badge-approved">APPROVED</span></td>
                        <td><strong>RM 450</strong></td>
                        <td>
                            <div class="action-buttons">
                                <button class="btn-small btn-view">View Quotation</button>
                            </div>
                        </td>
                    </tr>

                    <!-- STATUS: REJECTED (Customer rejected Quotation) -->
                    <tr>
                        <td>#APT005</td>
                        <td>Zahra Rahman</td>
                        <td>Normal Service</td>
                        <td>Tire rotation and balancing</td>
                        <td>Mar 28, 2026 - 9:30 AM</td>
                        <td>John Smith</td>
                        <td><span class="badge badge-rejected">REJECTED</span></td>
                        <td><strong>RM 320</strong></td>
                        <td>
                            <div class="action-buttons">
                                <button class="btn-small btn-view">View Details</button>
                                <button class="btn-small btn-assign" onclick="reassignTechnician(5)">New Quote</button>
                            </div>
                        </td>
                    </tr>

                    <!-- STATUS: COMPLETED - UNPAID (Service Performed, Awaiting Payment) -->
                    <tr>
                        <td>#APT006</td>
                        <td>Hassan Ibrahim</td>
                        <td>Normal Service</td>
                        <td>Battery replacement and terminals cleaning</td>
                        <td>Mar 23, 2026 - 1:00 PM</td>
                        <td>Ahmad Hassan</td>
                        <td><span class="badge badge-rejected">UNPAID</span></td>
                        <td><strong>RM 180</strong></td>
                        <td>
                            <div class="action-buttons">
                                <button class="btn-small btn-view" onclick="viewTechnicianNotes(6)">Technician Notes</button>
                                <button class="btn-small btn-view">View Invoice</button>
                                <button class="btn-small btn-collect" onclick="markAsPaid(6)">Paid</button>
                            </div>
                        </td>
                    </tr>

                    <!-- STATUS: PAID (Payment Received) -->
                    <tr>
                        <td>#APT007</td>
                        <td>Fatima Karim</td>
                        <td>Normal Service</td>
                        <td>Spark plugs replacement and diagnostics</td>
                        <td>Mar 22, 2026 - 11:00 AM</td>
                        <td>John Smith</td>
                        <td><span class="badge badge-paid">PAID</span></td>
                        <td><strong>RM 150</strong></td>
                        <td>
                            <div class="action-buttons">
                                <button class="btn-small btn-view">View Receipt</button>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- TECHNICIAN NOTES MODAL -->
<div id="notesModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">📋 Technician's Service Notes</div>
        <div id="notesBody">
            <!-- Notes will be inserted here -->
        </div>
        <div class="modal-actions">
            <button class="btn-close-modal" onclick="closeNotesModal()">Close</button>
        </div>
    </div>
</div>

<script>
    function assignTechnician(appointmentId) {
        window.location.href = 'AssignTechnician.jsp?id=' + appointmentId;
    }

    function approveQuotation(appointmentId) {
        window.location.href = 'ApproveQuotation.jsp?id=' + appointmentId;
    }

    function markAsPaid(appointmentId) {
        alert('Appointment #APT' + appointmentId.toString().padStart(3, '0') + ' marked as PAID');
        location.reload();
    }

    function viewTechnicianNotes(appointmentId) {
        // Get completion data from localStorage
        const completions = JSON.parse(localStorage.getItem('completions') || '[]');
        const completion = completions.find(c => c.taskId === appointmentId);

        const notesBody = document.getElementById('notesBody');
        
        if (completion) {
            notesBody.innerHTML = `
                <div class="comment-section">
                    <div class="comment-label">📝 Service Completion Notes</div>
                    <div class="comment-text">${completion.comment}</div>
                    <div class="comment-meta">
                        <strong>Technician:</strong> ${completion.technician}<br>
                        <strong>Completed:</strong> ${completion.completedAt}
                    </div>
                </div>
            `;
        } else {
            notesBody.innerHTML = `
                <div class="comment-section">
                    <div class="comment-label">⚠️ No notes available</div>
                    <div class="comment-text">Technician has not yet provided completion notes for this service.</div>
                </div>
            `;
        }

        document.getElementById('notesModal').classList.add('show');
    }

    function closeNotesModal() {
        document.getElementById('notesModal').classList.remove('show');
    }

    // Close modal when clicking outside
    window.onclick = function(event) {
        const modal = document.getElementById('notesModal');
        if (event.target === modal) {
            closeNotesModal();
        }
    }
</script>

</body>
</html>
