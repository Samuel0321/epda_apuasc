<%--
    Document   : ApproveQuotation
    Created on : Mar 25, 2026
    Author     : pinju
    Description: Receptionist approves or rejects quotation from technician
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Approve Quotation</title>
    <link rel="stylesheet" href="../../Styles/main.css">
    <style>
        .container {
            max-width: 900px;
            background: white;
            padding: 30px;
            border-radius: 14px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
        }

        .quotation-header {
            border-bottom: 2px solid #e2e8f0;
            padding-bottom: 20px;
            margin-bottom: 20px;
        }

        .quotation-header h2 {
            color: #1e293b;
            margin-bottom: 5px;
        }

        .quotation-id {
            color: #64748b;
            font-size: 14px;
        }

        .appointment-info {
            background: #f8fafc;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        .info-grid {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr;
            gap: 15px;
        }

        .info-item {
            font-size: 14px;
        }

        .info-label {
            font-weight: 600;
            color: #1e293b;
            margin-bottom: 3px;
        }

        .info-value {
            color: #475569;
        }

        .technician-details {
            background: #eff6ff;
            border-left: 4px solid #2563eb;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        .services-section {
            margin-bottom: 30px;
        }

        .services-section h3 {
            color: #1e293b;
            margin-bottom: 15px;
            font-size: 16px;
        }

        .services-table {
            width: 100%;
            border-collapse: collapse;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            overflow: hidden;
        }

        .services-table thead {
            background: #f8fafc;
        }

        .services-table th,
        .services-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #e2e8f0;
        }

        .services-table th {
            font-weight: 600;
            color: #1e293b;
        }

        .services-table tbody tr:hover {
            background: #f8fafc;
        }

        .service-name {
            font-weight: 500;
            color: #1e293b;
        }

        .service-description {
            font-size: 13px;
            color: #64748b;
            margin-top: 3px;
        }

        .price-cell {
            text-align: right;
            font-weight: 600;
            color: #1e293b;
        }

        .remarks-section {
            background: #f1f5f9;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        .remarks-section h4 {
            color: #1e293b;
            margin-bottom: 8px;
        }

        .remarks-text {
            color: #475569;
            font-size: 14px;
            line-height: 1.6;
        }

        .summary-box {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        .summary-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 8px;
            font-size: 14px;
        }

        .summary-total {
            display: flex;
            justify-content: space-between;
            margin-top: 12px;
            padding-top: 12px;
            border-top: 1px solid rgba(255,255,255,0.3);
            font-size: 18px;
            font-weight: 700;
        }

        .action-buttons {
            display: flex;
            gap: 10px;
            margin-top: 30px;
        }

        .btn {
            flex: 1;
            padding: 12px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            font-size: 14px;
            transition: all 0.3s ease;
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

        .btn-cancel {
            background: #e2e8f0;
            color: #1e293b;
        }

        .btn-cancel:hover {
            background: #cbd5e1;
        }

        .modal {
            display: none;
            position: fixed;
            z-index: 1;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.4);
        }

        .modal-content {
            background-color: white;
            margin: 10% auto;
            padding: 20px;
            border: 1px solid #888;
            width: 90%;
            max-width: 500px;
            border-radius: 8px;
        }

        .modal-header {
            margin-bottom: 15px;
        }

        .modal-header h3 {
            color: #1e293b;
            margin: 0;
        }

        .modal-body {
            margin-bottom: 15px;
        }

        .modal-body textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            font-family: 'Segoe UI', sans-serif;
            font-size: 14px;
            box-sizing: border-box;
            resize: vertical;
        }

        .modal-footer {
            display: flex;
            gap: 10px;
        }

        .modal-footer button {
            flex: 1;
            padding: 10px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 500;
        }
    </style>
</head>

<body>

<div class="layout">
    <!-- Sidebar -->
    <jsp:include page="../../Component/Sidebar.jsp" />

    <!-- Main Content -->
    <div class="main">
        <jsp:include page="../../Component/Topbar.jsp">
            <jsp:param name="section" value="APPROVE QUOTATION" />
        </jsp:include>

        <!-- HEADER -->
        <div class="header-row">
            <div class="header-text">
                <h1>Review Quotation</h1>
                <p>Review and approve/reject technician quotation</p>
            </div>
        </div>

        <!-- QUOTATION DETAILS -->
        <div class="container">
            <!-- Header -->
            <div class="quotation-header">
                <h2>Quotation #QT-20260325-001</h2>
                <div class="quotation-id">Appointment: #APT003 | Submitted: Mar 25, 2026</div>
            </div>

            <!-- Appointment Info -->
            <div class="appointment-info">
                <div class="info-grid">
                    <div class="info-item">
                        <div class="info-label">Customer</div>
                        <div class="info-value">Siti Aminah</div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Service Type</div>
                        <div class="info-value">Normal Service</div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Issue</div>
                        <div class="info-value">Oil change & filter replacement</div>
                    </div>
                </div>
            </div>

            <!-- Technician Details -->
            <div class="technician-details">
                <strong>Technician:</strong> Ahmad Hassan | â­â­â­â­ (35 jobs) | Specialty: Brake Service, Suspension
            </div>

            <!-- Services Breakdown -->
            <div class="services-section">
                <h3>ðŸ“‹ Proposed Services</h3>
                <table class="services-table">
                    <thead>
                        <tr>
                            <th>Service</th>
                            <th>Description</th>
                            <th style="text-align: right;">Price</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>
                                <div class="service-name">Oil Change</div>
                                <div class="service-description">Premium synthetic oil replacement</div>
                            </td>
                            <td>Complete oil change with new filter and cap check</td>
                            <td class="price-cell">RM 150</td>
                        </tr>
                        <tr>
                            <td>
                                <div class="service-name">Oil Filter Replacement</div>
                                <div class="service-description">High-quality filter installation</div>
                            </td>
                            <td>Replace with OEM quality filter</td>
                            <td class="price-cell">RM 100</td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <!-- Remarks -->
            <div class="remarks-section">
                <h4>ðŸ” Technician Remarks</h4>
                <div class="remarks-text">
                    "Vehicle maintenance is due. Oil appears to be at minimum level. Recommended to use synthetic oil for better engine protection. All filters will be replaced with premium quality parts. Service will take approximately 1 hour."
                </div>
            </div>

            <!-- Summary -->
            <div class="summary-box">
                <div class="summary-row">
                    <span>Subtotal:</span>
                    <span>RM 250</span>
                </div>
                <div class="summary-row">
                    <span>Service Tax (6%):</span>
                    <span>RM 15</span>
                </div>
                <div class="summary-total">
                    <span>Total Amount:</span>
                    <span>RM 265</span>
                </div>
            </div>

            <!-- Action Buttons -->
            <div class="action-buttons">
                <button class="btn btn-approve" onclick="approveQuotation()">âœ“ Approve Quotation</button>
                <button class="btn btn-reject" onclick="openRejectModal()">âœ— Reject Quotation</button>
                <button class="btn btn-cancel" onclick="window.location.href='Appointments.jsp'">Cancel</button>
            </div>
        </div>
    </div>
</div>

<!-- Rejection Modal -->
<div id="rejectModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3>Reject Quotation</h3>
        </div>
        <div class="modal-body">
            <p>Please provide a reason for rejecting this quotation:</p>
            <textarea id="rejectionReason" rows="4" placeholder="E.g., Price too high, Services not adequate, etc."></textarea>
        </div>
        <div class="modal-footer">
            <button onclick="submitRejection()" style="background: #dc2626; color: white;">Reject</button>
            <button onclick="closeRejectModal()" style="background: #e2e8f0; color: #1e293b;">Cancel</button>
        </div>
    </div>
</div>

<script>
    function approveQuotation() {
        if (confirm('Are you sure you want to approve this quotation? The customer will be notified.')) {
            alert('âœ“ Quotation approved successfully!\nCustomer will be notified to review and approve.');
            window.location.href = 'Appointments.jsp';
        }
    }

    function openRejectModal() {
        document.getElementById('rejectModal').style.display = 'block';
    }

    function closeRejectModal() {
        document.getElementById('rejectModal').style.display = 'none';
    }

    function submitRejection() {
        const reason = document.getElementById('rejectionReason').value;
        if (reason.trim() === '') {
            alert('Please provide a reason for rejection.');
            return;
        }
        alert('âœ— Quotation rejected!\nTechnician will be notified: "' + reason + '"');
        window.location.href = 'Appointments.jsp';
    }

    window.onclick = function(event) {
        const modal = document.getElementById('rejectModal');
        if (event.target === modal) {
            modal.style.display = 'none';
        }
    }
</script>

</body>
</html>



