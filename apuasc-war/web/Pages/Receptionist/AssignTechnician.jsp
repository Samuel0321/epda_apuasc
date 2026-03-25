<%--
    Document   : AssignTechnician
    Created on : Mar 25, 2026
    Author     : pinju
    Description: Receptionist assigns a technician to a pending appointment
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Assign Technician</title>
    <link rel="stylesheet" href="../../Styles/main.css">
    <style>
        .form-container {
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

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        .info-box {
            background: #dbeafe;
            border-left: 4px solid #2563eb;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            color: #1e40af;
            font-size: 14px;
        }

        .info-box strong {
            display: block;
            margin-bottom: 5px;
        }

        .technician-list {
            background: white;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            max-height: 300px;
            overflow-y: auto;
            margin-top: 5px;
        }

        .technician-item {
            padding: 12px;
            border-bottom: 1px solid #f1f5f9;
            cursor: pointer;
            transition: background 0.3s ease;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .technician-item:hover {
            background: #f8fafc;
        }

        .technician-item input[type="radio"] {
            width: auto;
            cursor: pointer;
        }

        .technician-info {
            flex: 1;
            margin-left: 10px;
        }

        .technician-name {
            font-weight: 600;
            color: #1e293b;
        }

        .technician-specialty {
            font-size: 12px;
            color: #64748b;
        }

        .specialist-badge {
            display: inline-block;
            padding: 2px 8px;
            background: #d1fae5;
            color: #065f46;
            border-radius: 4px;
            font-size: 12px;
            margin-right: 5px;
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

        .appointment-details {
            background: #f8fafc;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        .detail-row {
            display: grid;
            grid-template-columns: 150px 1fr;
            margin-bottom: 10px;
            font-size: 14px;
        }

        .detail-label {
            font-weight: 600;
            color: #1e293b;
        }

        .detail-value {
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
                ☰ &nbsp; ASSIGN TECHNICIAN
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
                <h1>Assign Technician to Appointment</h1>
                <p>Select a qualified technician for this service</p>
            </div>
        </div>

        <!-- FORM -->
        <div class="form-container">
            <!-- Appointment Details -->
            <div class="appointment-details">
                <div class="detail-row">
                    <div class="detail-label">Appointment ID:</div>
                    <div class="detail-value">#APT001</div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">Customer:</div>
                    <div class="detail-value">Ahmad Faisal</div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">Service Type:</div>
                    <div class="detail-value">Normal Service</div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">Issue:</div>
                    <div class="detail-value">Engine loud noise, vibrations</div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">Date/Time:</div>
                    <div class="detail-value">Mar 25, 2026 - 10:00 AM</div>
                </div>
            </div>

            <form method="POST" action="#">
                <!-- Technician Selection -->
                <div class="form-group">
                    <label for="technician">Select Technician *</label>
                    <div class="info-box">
                        <strong>Available Technicians:</strong>
                        Showing technicians available on the selected date
                    </div>
                    
                    <div class="technician-list">
                        <!-- Technician 1 -->
                        <div class="technician-item">
                            <div style="display: flex; align-items: center; flex: 1;">
                                <input type="radio" name="technician" id="tech1" value="1" required>
                                <div class="technician-info">
                                    <div class="technician-name">John Smith</div>
                                </div>
                            </div>
                        </div>

                        <!-- Technician 2 -->
                        <div class="technician-item">
                            <div style="display: flex; align-items: center; flex: 1;">
                                <input type="radio" name="technician" id="tech2" value="2">
                                <div class="technician-info">
                                    <div class="technician-name">Ahmad Hassan</div>
                                </div>
                            </div>
                        </div>

                        <!-- Technician 3 -->
                        <div class="technician-item">
                            <div style="display: flex; align-items: center; flex: 1;">
                                <input type="radio" name="technician" id="tech3" value="3">
                                <div class="technician-info">
                                    <div class="technician-name">Nurul Amin</div>
                                </div>
                            </div>
                        </div>

                        <!-- Technician 4 -->
                        <div class="technician-item">
                            <div style="display: flex; align-items: center; flex: 1;">
                                <input type="radio" name="technician" id="tech4" value="4">
                                <div class="technician-info">
                                    <div class="technician-name">Hassan Ibrahim</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Notes -->
                <div class="form-group">
                    <label for="notes">Special Notes/Instructions (Optional)</label>
                    <textarea id="notes" name="notes" rows="4" placeholder="Add any special instructions for the technician..."></textarea>
                </div>

                <!-- Form Actions -->
                <div class="form-actions">
                    <button type="submit" class="btn-submit">Assign Technician</button>
                    <button type="button" class="btn-cancel" onclick="window.location.href='Appointments.jsp'">Cancel</button>
                </div>
            </form>
        </div>
    </div>
</div>

</body>
</html>
