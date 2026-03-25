<%--
    Document   : MyAppointments
    Created on : Mar 24, 2026
    Author     : pinju
    Updated   : New Workflow support
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>My Appointments</title>
    <link rel="stylesheet" href="../../Styles/main.css">
    <style>
        .appointments-container {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 20px;
            margin-bottom: 20px;
        }

        .appointment-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
            overflow: hidden;
            transition: all 0.3s ease;
            border-left: 4px solid #2563eb;
        }

        .appointment-card:hover {
            box-shadow: 0 8px 20px rgba(0,0,0,0.1);
        }

        .appointment-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
        }

        .appointment-date {
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 5px;
        }

        .appointment-time {
            font-size: 14px;
            opacity: 0.9;
        }

        .appointment-body {
            padding: 20px;
        }

        .appointment-service {
            font-size: 16px;
            font-weight: 600;
            color: #1e293b;
            margin-bottom: 8px;
        }

        .appointment-detail {
            font-size: 13px;
            color: #64748b;
            margin-bottom: 6px;
        }

        .workflow-status {
            background: #f1f5f9;
            padding: 12px;
            border-radius: 8px;
            margin: 10px 0;
            font-size: 13px;
        }

        .workflow-label {
            font-weight: 600;
            color: #1e293b;
            margin-bottom: 5px;
        }

        .appointment-status {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: 600;
            margin-top: 5px;
        }

        .status-pending {
            background: #fef08a;
            color: #854d0e;
        }

        .status-assigned {
            background: #bfdbfe;
            color: #1e40af;
        }

        .status-waiting-approval {
            background: #fed7aa;
            color: #92400e;
        }

        .status-approved {
            background: #bbf7d0;
            color: #166534;
        }

        .status-rejected {
            background: #fecaca;
            color: #7f1d1d;
        }

        .status-completed {
            background: #c7d2fe;
            color: #3730a3;
        }

        .status-paid {
            background: #86efac;
            color: #166534;
        }

        .quotation-section {
            background: #fef3c7;
            padding: 10px;
            border-radius: 6px;
            margin: 10px 0;
            font-size: 13px;
        }

        .quotation-price {
            font-weight: 700;
            color: #92400e;
            font-size: 16px;
        }

        .appointment-actions {
            display: flex;
            flex-direction: column;
            gap: 8px;
            margin-top: 12px;
        }

        .appointment-btn {
            padding: 8px 12px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 12px;
            font-weight: 500;
            transition: all 0.3s ease;
            text-align: center;
        }

        .btn-primary {
            background: #2563eb;
            color: white;
        }

        .btn-primary:hover {
            background: #1d4ed8;
        }

        .btn-approve {
            background: #16a34a;
            color: white;
        }

        .btn-approve:hover {
            background: #15803d;
        }

        .btn-reject {
            background: #dc2626;
            color: white;
        }

        .btn-reject:hover {
            background: #b91c1c;
        }

        .btn-secondary {
            background: #e5e7eb;
            color: #1e293b;
        }

        .btn-secondary:hover {
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

        .header-actions {
            display: flex;
            gap: 10px;
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
                ☰ &nbsp; MY APPOINTMENTS
            </div>
            <div class="topbar-right">
                <span class="bell">🔔</span>
                <div class="profile">
                    <div class="avatar">C</div>
                    <div class="user-info">
                        <div class="name">Siti Aminah</div>
                        <div class="email">siti.aminah@email.com</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- HEADER -->
        <div class="header-row">
            <div class="header-text">
                <h1>My Appointments</h1>
                <p>Track your service appointments through the workflow</p>
            </div>
            <div class="header-actions">
                <button class="btn btn-primary" onclick="window.location.href='../../Receptionist/NewAppointment.jsp'">+ Book New Appointment</button>
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
        </div>

        <!-- APPOINTMENTS CARDS -->
        <div class="appointments-container">
            <!-- Appointment 1: PENDING -->
            <div class="appointment-card">
                <div class="appointment-header">
                    <div class="appointment-date">25 Mar</div>
                    <div class="appointment-time">10:00 AM</div>
                </div>
                <div class="appointment-body">
                    <div class="appointment-service">Normal Service</div>
                    <div class="appointment-detail">🚗 Toyota Camry 2020 (Engine noise)</div>
                    <div class="appointment-detail">📍 AutoFix Pro Service Center</div>
                    
                    <div class="workflow-status">
                        <div class="workflow-label">Status: PENDING</div>
                        <span class="appointment-status status-pending">⏳ Waiting for Technician Assignment</span>
                    </div>
                    
                    <div class="appointment-actions">
                        <button class="appointment-btn btn-secondary">View Details</button>
                    </div>
                </div>
            </div>

            <!-- Appointment 2: ASSIGNED -->
            <div class="appointment-card">
                <div class="appointment-header">
                    <div class="appointment-date">25 Mar</div>
                    <div class="appointment-time">2:00 PM</div>
                </div>
                <div class="appointment-body">
                    <div class="appointment-service">Major Service</div>
                    <div class="appointment-detail">🚗 Honda CR-V 2019 (Brake inspection)</div>
                    <div class="appointment-detail">👨‍🔧 Assigned to: John Smith</div>
                    
                    <div class="workflow-status">
                        <div class="workflow-label">Status: ASSIGNED</div>
                        <span class="appointment-status status-assigned">📋 Technician Assigned</span>
                    </div>
                    
                    <div class="appointment-actions">
                        <button class="appointment-btn btn-secondary">View Details</button>
                    </div>
                </div>
            </div>

            <!-- Appointment 3: WAITING APPROVAL -->
            <div class="appointment-card">
                <div class="appointment-header">
                    <div class="appointment-date">26 Mar</div>
                    <div class="appointment-time">11:00 AM</div>
                </div>
                <div class="appointment-body">
                    <div class="appointment-service">Normal Service</div>
                    <div class="appointment-detail">🚗 Nissan X-Trail 2021 (Oil change)</div>
                    <div class="appointment-detail">👨‍🔧 Technician: Ahmad Hassan</div>
                    
                    <div class="workflow-status">
                        <div class="workflow-label">Status: WAITING APPROVAL</div>
                        <span class="appointment-status status-waiting-approval">🔍 Quotation Ready</span>
                    </div>

                    <div class="quotation-section">
                        <div>Proposed Services:</div>
                        <div style="margin-top: 5px;">• Oil Change - RM 150</div>
                        <div>• Oil Filter - RM 100</div>
                        <div class="quotation-price" style="margin-top: 8px;">Total: RM 250</div>
                    </div>
                    
                    <div class="appointment-actions">
                        <button class="appointment-btn btn-approve" onclick="approveQuotation(3)">✓ Approve</button>
                        <button class="appointment-btn btn-reject" onclick="rejectQuotation(3)">✗ Reject</button>
                    </div>
                </div>
            </div>

            <!-- Appointment 4: APPROVED -->
            <div class="appointment-card">
                <div class="appointment-header">
                    <div class="appointment-date">27 Mar</div>
                    <div class="appointment-time">3:00 PM</div>
                </div>
                <div class="appointment-body">
                    <div class="appointment-service">Major Service</div>
                    <div class="appointment-detail">🚗 BMW 3 Series 2021 (Full maintenance)</div>
                    <div class="appointment-detail">👨‍🔧 Technician: Nurul Amin</div>
                    
                    <div class="workflow-status">
                        <div class="workflow-label">Status: APPROVED</div>
                        <span class="appointment-status status-approved">✓ Service Starting Soon</span>
                    </div>

                    <div class="quotation-section">
                        <div style="font-weight: 600;">Approved Quotation: RM 450</div>
                    </div>
                    
                    <div class="appointment-actions">
                        <button class="appointment-btn btn-secondary">View Quotation</button>
                    </div>
                </div>
            </div>

            <!-- Appointment 5: COMPLETED -->
            <div class="appointment-card">
                <div class="appointment-header">
                    <div class="appointment-date">23 Mar</div>
                    <div class="appointment-time">1:00 PM</div>
                </div>
                <div class="appointment-body">
                    <div class="appointment-service">Normal Service</div>
                    <div class="appointment-detail">🚗 Toyota Corolla 2018 (Battery replacement)</div>
                    <div class="appointment-detail">👨‍🔧 Technician: Hassan Ibrahim</div>
                    
                    <div class="workflow-status">
                        <div class="workflow-label">Status: COMPLETED</div>
                        <span class="appointment-status status-completed">✅ Service Completed</span>
                    </div>

                    <div class="quotation-section">
                        <div style="font-weight: 600;">Final Amount: RM 180</div>
                        <div style="margin-top: 5px; color: #dc2626;">⚠️ Payment Pending</div>
                    </div>
                    
                    <div class="appointment-actions">
                        <button class="appointment-btn btn-secondary" onclick="viewCustomerTechnicianNotes(6)">Technician Notes</button>
                        <button class="appointment-btn btn-primary">View Receipt</button>
                    </div>
                </div>
            </div>

            <!-- Appointment 6: PAID -->
            <div class="appointment-card">
                <div class="appointment-header">
                    <div class="appointment-date">22 Mar</div>
                    <div class="appointment-time">11:00 AM</div>
                </div>
                <div class="appointment-body">
                    <div class="appointment-service">Normal Service</div>
                    <div class="appointment-detail">🚗 Mazda CX-5 2020 (Spark plugs & diagnostics)</div>
                    <div class="appointment-detail">👨‍🔧 Technician: John Smith</div>
                    
                    <div class="workflow-status">
                        <div class="workflow-label">Status: PAID</div>
                        <span class="appointment-status status-paid">💰 Payment Received</span>
                    </div>

                    <div class="quotation-section">
                        <div style="font-weight: 600;">Amount Paid: RM 150</div>
                        <div style="margin-top: 5px; color: #16a34a;">✓ Completed & Paid</div>
                    </div>

                    <div class="appointment-actions">
                        <button class="appointment-btn btn-secondary" onclick="viewCustomerTechnicianNotes(7)">Technician Notes</button>
                    </div>
                    
                    <div class="appointment-actions">
                        <button class="appointment-btn btn-primary">Download Invoice</button>
                    </div>
                </div>
            </div>
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
    function approveQuotation(appointmentId) {
        if (confirm('Approve this quotation? Service will proceed with the proposed services.')) {
            alert('✓ Quotation approved! Your service is now confirmed. Technician will start on scheduled date.');
            location.reload();
        }
    }

    function rejectQuotation(appointmentId) {
        const reason = prompt('Please provide reason for rejection:');
        if (reason) {
            alert('✗ Quotation rejected. Receptionist will contact technician for revision.');
            location.reload();
        }
    }

    function viewCustomerTechnicianNotes(appointmentId) {
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
