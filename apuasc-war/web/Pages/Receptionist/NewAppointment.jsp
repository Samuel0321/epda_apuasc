<%--
    Document   : NewAppointment
    Created on : Mar 24, 2026
    Author     : pinju
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>New Appointment</title>
    <link rel="stylesheet" href="../../Styles/main.css">
    <style>
        .form-container {
            max-width: 600px;
            background: white;
            padding: 30px;
            border-radius: 14px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #1e293b;
        }

        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            font-size: 14px;
            box-sizing: border-box;
            font-family: 'Segoe UI', sans-serif;
        }

        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }

        .form-actions {
            display: flex;
            gap: 10px;
            margin-top: 30px;
        }

        .form-actions button {
            flex: 1;
            padding: 12px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .btn-submit {
            background: #2563eb;
            color: white;
        }

        .btn-submit:hover {
            background: #1d4ed8;
        }

        .btn-cancel {
            background: #e2e8f0;
            color: #1e293b;
        }

        .btn-cancel:hover {
            background: #cbd5e1;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
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
                ☰ &nbsp; NEW APPOINTMENT
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
                <h1>Create New Appointment</h1>
                <p>Schedule a service appointment for a customer</p>
            </div>
        </div>

        <!-- FORM -->
        <div class="form-container">
            <form id="appointmentForm">
                <div class="form-group">
                    <label for="customer">Customer Name *</label>
                    <input type="text" id="customer" name="customer" placeholder="Select or type customer name" required>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="appointmentDate">Appointment Date *</label>
                        <input type="date" id="appointmentDate" name="appointmentDate" required>
                    </div>
                    <div class="form-group">
                        <label for="appointmentTime">Appointment Time *</label>
                        <input type="time" id="appointmentTime" name="appointmentTime" required>
                    </div>
                </div>

                <div class="form-group">
                    <label for="serviceType">Service Type *</label>
                    <select id="serviceType" name="serviceType" required>
                        <option value="">Select Service</option>
                        <option value="oil_change">Oil Change</option>
                        <option value="tire_rotation">Tire Rotation</option>
                        <option value="brake_inspection">Brake Inspection</option>
                        <option value="engine_inspection">Engine Inspection</option>
                        <option value="battery_check">Battery Check</option>
                        <option value="ac_service">AC Service</option>
                        <option value="transmission">Transmission Service</option>
                        <option value="general_maintenance">General Maintenance</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="technician">Assign Technician</label>
                    <select id="technician" name="technician">
                        <option value="">Select Technician</option>
                        <option value="tech_001">John Smith</option>
                        <option value="tech_002">Ahmad Hassan</option>
                        <option value="tech_003">Nurul Amin</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="notes">Notes / Comments</label>
                    <textarea id="notes" name="notes" rows="4" placeholder="Add any special requests or notes..."></textarea>
                </div>

                <div class="form-actions">
                    <button type="button" class="btn-cancel" onclick="window.history.back()">Cancel</button>
                    <button type="submit" class="btn-submit">Create Appointment</button>
                </div>
            </form>
        </div>
    </div>
</div>

</body>
</html>
