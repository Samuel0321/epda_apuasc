<%--
    Document   : CreateQuotation
    Created on : Mar 25, 2026
    Author     : pinju
    Description: Technician creates a quotation by adding services and submitting it
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Submit Quotation</title>
    <link rel="stylesheet" href="../../Styles/main.css">
    <style>
        .container {
            max-width: 900px;
            background: white;
            padding: 30px;
            border-radius: 14px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
        }

        .section-title {
            margin-top: 25px;
            margin-bottom: 15px;
            font-size: 16px;
            font-weight: 600;
            color: #1e293b;
            padding-bottom: 10px;
            border-bottom: 2px solid #e2e8f0;
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
            font-size: 13px;
        }

        .info-label {
            font-weight: 600;
            color: #1e293b;
            margin-bottom: 3px;
        }

        .info-value {
            color: #475569;
        }

        .service-item {
            background: white;
            border: 1px solid #e2e8f0;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 10px;
            display: grid;
            grid-template-columns: 1fr 100px 80px 50px;
            gap: 15px;
            align-items: center;
        }

        .service-name-input,
        .service-desc-input {
            display: block;
            width: 100%;
            padding: 8px;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
            font-size: 13px;
            box-sizing: border-box;
        }

        .service-price-input {
            padding: 8px;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
            font-size: 13px;
            width: 100%;
            box-sizing: border-box;
        }

        .service-remove-btn {
            padding: 6px 12px;
            background: #fecaca;
            color: #7f1d1d;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 12px;
            font-weight: 500;
        }

        .service-remove-btn:hover {
            background: #f87171;
        }

        .add-service-btn {
            padding: 10px 16px;
            background: #dbeafe;
            color: #1e40af;
            border: 1px solid #93c5fd;
            border-radius: 6px;
            cursor: pointer;
            font-size: 13px;
            font-weight: 500;
            margin-bottom: 15px;
        }

        .add-service-btn:hover {
            background: #bfdbfe;
        }

        .predefined-services {
            background: #eff6ff;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        .service-button {
            display: inline-block;
            padding: 8px 12px;
            background: white;
            border: 1px solid #93c5fd;
            border-radius: 6px;
            cursor: pointer;
            font-size: 12px;
            margin-right: 8px;
            margin-bottom: 8px;
            transition: all 0.3s ease;
        }

        .service-button:hover {
            background: #dbeafe;
            border-color: #2563eb;
        }

        .remarks-textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            font-family: 'Segoe UI', sans-serif;
            font-size: 13px;
            resize: vertical;
            box-sizing: border-box;
        }

        .summary-box {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 8px;
            margin-top: 20px;
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

        .form-actions {
            display: flex;
            gap: 10px;
            margin-top: 20px;
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

        .btn-submit {
            background: #16a34a;
            color: white;
        }

        .btn-submit:hover {
            background: #15803d;
        }

        .btn-cancel {
            background: #e2e8f0;
            color: #1e293b;
        }

        .btn-cancel:hover {
            background: #cbd5e1;
        }

        .reference-services {
            background: #f1f5f9;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 13px;
        }

        .reference-services strong {
            display: block;
            margin-bottom: 10px;
            color: #1e293b;
        }

        .reference-item {
            margin-bottom: 8px;
            color: #475569;
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
                ☰ &nbsp; SUBMIT QUOTATION
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
                <h1>Create Service Quotation</h1>
                <p>Add services and submit quotation to customer for approval</p>
            </div>
        </div>

        <!-- FORM -->
        <div class="container">
            <!-- Appointment Details -->
            <div class="section-title">📋 Appointment Details</div>
            <div class="appointment-info">
                <div class="info-grid">
                    <div class="info-item">
                        <div class="info-label">Appointment ID</div>
                        <div class="info-value">#APT003</div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Customer</div>
                        <div class="info-value">Siti Aminah</div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Scheduled</div>
                        <div class="info-value">Mar 26, 11:00 AM</div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Service Type</div>
                        <div class="info-value">Normal Service</div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Issue</div>
                        <div class="info-value">Oil change & filter</div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Vehicle</div>
                        <div class="info-value">Nissan X-Trail 2021</div>
                    </div>
                </div>
            </div>

            <!-- Pre-defined Services Quick Add -->
            <div class="section-title">⚡ Quick Add Services</div>
            <div class="reference-services">
                <strong>Common Services:</strong>
                <div class="reference-item">• Engine Inspection - RM 100</div>
                <div class="reference-item">• Oil Change - RM 150</div>
                <div class="reference-item">• Oil Filter - RM 100</div>
                <div class="reference-item">• Brake Check - RM 80</div>
                <div class="reference-item">• Tire Rotation - RM 90</div>
                <div class="reference-item">• Air Filter - RM 120</div>
            </div>

            <button class="service-button" onclick="quickAddService('Oil Change', 'Premium synthetic oil replacement', 150)">+ Oil Change (RM 150)</button>
            <button class="service-button" onclick="quickAddService('Oil Filter', 'OEM quality filter installation', 100)">+ Oil Filter (RM 100)</button>
            <button class="service-button" onclick="quickAddService('Engine Inspection', 'Complete engine diagnostics', 100)">+ Engine Inspection (RM 100)</button>
            <button class="service-button" onclick="quickAddService('Brake Check', 'Brake system inspection', 80)">+ Brake Check (RM 80)</button>
            <button class="service-button" onclick="quickAddService('Tire Rotation', 'Complete tire rotation', 90)">+ Tire Rotation (RM 90)</button>

            <!-- Services List -->
            <div class="section-title">📝 Proposed Services</div>
            <button class="add-service-btn" onclick="addEmptyService()">+ Add Custom Service</button>

            <div id="servicesContainer">
                <!-- Service items will be added here -->
                <div class="service-item" id="service-0">
                    <div>
                        <div>Service Name</div>
                        <input type="text" class="service-name-input" value="Oil Change" placeholder="Service name">
                        <input type="text" class="service-desc-input" style="margin-top: 5px;" value="Premium synthetic oil replacement" placeholder="Description">
                    </div>
                    <div style="text-align: center;">
                        <div style="font-size: 12px; color: #64748b; margin-bottom: 5px;">Price (RM)</div>
                        <input type="number" class="service-price-input" value="150" onchange="calculateTotal()">
                    </div>
                    <div></div>
                    <button class="service-remove-btn" onclick="removeService(0)">Remove</button>
                </div>

                <div class="service-item" id="service-1">
                    <div>
                        <div>Service Name</div>
                        <input type="text" class="service-name-input" value="Oil Filter" placeholder="Service name">
                        <input type="text" class="service-desc-input" style="margin-top: 5px;" value="OEM quality filter installation" placeholder="Description">
                    </div>
                    <div style="text-align: center;">
                        <div style="font-size: 12px; color: #64748b; margin-bottom: 5px;">Price (RM)</div>
                        <input type="number" class="service-price-input" value="100" onchange="calculateTotal()">
                    </div>
                    <div></div>
                    <button class="service-remove-btn" onclick="removeService(1)">Remove</button>
                </div>
            </div>

            <!-- Remarks -->
            <div class="section-title">💬 Remarks/Notes</div>
            <textarea class="remarks-textarea" id="remarks" rows="4" placeholder="Add any additional remarks for the customer (e.g., recommendations, warnings, special notes)...">Vehicle maintenance is due. Oil appears to be at minimum level. Recommended to use synthetic oil for better engine protection. Service will take approximately 1 hour.</textarea>

            <!-- Summary -->
            <div class="summary-box">
                <div class="summary-row">
                    <span id="subtotal-label">Subtotal (2 services):</span>
                    <span id="subtotal-value">RM 250</span>
                </div>
                <div class="summary-row">
                    <span>Service Tax (6%):</span>
                    <span id="tax-value">RM 15</span>
                </div>
                <div class="summary-total">
                    <span>Total Quotation:</span>
                    <span id="total-value">RM 265</span>
                </div>
            </div>

            <!-- Action Buttons -->
            <div class="form-actions">
                <button class="btn btn-submit" onclick="submitQuotation()">✓ Submit Quotation</button>
                <button class="btn btn-cancel" onclick="window.location.href='AssignedTasks.jsp'">Cancel</button>
            </div>
        </div>
    </div>
</div>

<script>
    let serviceCount = 2;

    function quickAddService(name, description, price) {
        const container = document.getElementById('servicesContainer');
        
        const serviceItem = document.createElement('div');
        serviceItem.className = 'service-item';
        serviceItem.id = 'service-' + serviceCount;
        serviceItem.innerHTML = `
            <div>
                <div>Service Name</div>
                <input type="text" class="service-name-input" value="${name}" placeholder="Service name">
                <input type="text" class="service-desc-input" style="margin-top: 5px;" value="${description}" placeholder="Description">
            </div>
            <div style="text-align: center;">
                <div style="font-size: 12px; color: #64748b; margin-bottom: 5px;">Price (RM)</div>
                <input type="number" class="service-price-input" value="${price}" onchange="calculateTotal()">
            </div>
            <div></div>
            <button class="service-remove-btn" onclick="removeService(${serviceCount})">Remove</button>
        `;
        
        container.appendChild(serviceItem);
        serviceCount++;
        calculateTotal();
    }

    function addEmptyService() {
        quickAddService('', '', '');
    }

    function removeService(id) {
        const element = document.getElementById('service-' + id);
        if (element) {
            element.remove();
            calculateTotal();
        }
    }

    function calculateTotal() {
        const services = document.querySelectorAll('.service-price-input');
        let total = 0;
        services.forEach(service => {
            const price = parseFloat(service.value) || 0;
            total += price;
        });

        const tax = Math.round(total * 0.06 * 100) / 100;
        const grandTotal = Math.round((total + tax) * 100) / 100;

        document.getElementById('subtotal-label').textContent = `Subtotal (${services.length} services):`;
        document.getElementById('subtotal-value').textContent = 'RM ' + total.toFixed(2);
        document.getElementById('tax-value').textContent = 'RM ' + tax.toFixed(2);
        document.getElementById('total-value').textContent = 'RM ' + grandTotal.toFixed(2);
    }

    function submitQuotation() {
        const services = document.querySelectorAll('.service-item');
        if (services.length === 0) {
            alert('Please add at least one service.');
            return;
        }

        const remarks = document.getElementById('remarks').value;
        const total = document.getElementById('total-value').textContent;

        if (confirm('Submit quotation for RM ' + total.split(' ')[1] + '?\n\nCustomer will review and approve this quotation.')) {
            alert('✓ Quotation submitted successfully!\n\nStatus: WAITING APPROVAL\nCustomer will be notified to review and approve.');
            window.location.href = 'AssignedTasks.jsp';
        }
    }

    // Calculate total on page load
    window.addEventListener('load', calculateTotal);
</script>

</body>
</html>
