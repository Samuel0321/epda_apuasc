<%--
    Document   : AssignTechnician
    Created on : Mar 25, 2026
    Author     : pinju
    Description: Receptionist assigns a technician to a pending appointment
--%>

<%@page import="java.util.List,java.util.Arrays,java.util.LinkedHashMap,java.util.Map,java.time.format.DateTimeFormatter,models.UsersEntity,models.UsersEntityFacade,models.Appointments,models.AppointmentsFacade,models.AppointmentService,models.AppointmentServiceFacade,models.ServiceEntity,models.ServiceEntityFacade,utils.EjbLookup"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    UsersEntityFacade usersFacade = EjbLookup.lookup(UsersEntityFacade.class, "UsersEntityFacade");
    AppointmentsFacade appointmentsFacade = EjbLookup.lookup(AppointmentsFacade.class, "AppointmentsFacade");
    AppointmentServiceFacade aptServiceFacade = EjbLookup.lookup(AppointmentServiceFacade.class, "AppointmentServiceFacade");
    ServiceEntityFacade serviceFacade = EjbLookup.lookup(ServiceEntityFacade.class, "ServiceEntityFacade");
    
    List<UsersEntity> technicians = usersFacade.findByRoles(Arrays.asList("technician"));
    
    String appointmentIdStr = request.getParameter("id");
    Appointments appointment = null;
    if (appointmentIdStr != null && !appointmentIdStr.isEmpty()) {
        try {
            Integer id = Integer.parseInt(appointmentIdStr);
            appointment = appointmentsFacade.find(id);
        } catch (NumberFormatException e) {
            // handle error
        }
    }

    Integer requestedDurationHours = 1;
    String serviceName = "-";
    if (appointment != null) {
        requestedDurationHours = appointmentsFacade.estimateReservedDurationHours(appointment);
        List<AppointmentService> links = aptServiceFacade.findByAppointmentId(appointment.getId());
        if (links != null && !links.isEmpty()) {
            ServiceEntity s = serviceFacade.find(links.get(0).getService_id());
            if (s != null) {
                serviceName = s.getService_name();
            }
        }
    }

    if ("POST".equalsIgnoreCase(request.getMethod()) && appointment != null) {
        String techIdStr = request.getParameter("technician");
        String specialNotes = request.getParameter("notes");
        if (techIdStr != null && !techIdStr.isEmpty()) {
            Integer technicianId = Integer.parseInt(techIdStr);
            if (appointmentsFacade.isPastAppointmentSlot(appointment.getAppointment_date(), appointment.getAppointment_time())) {
                response.sendRedirect("AssignTechnician.jsp?id=" + appointment.getId() + "&error=PastDateTime");
                return;
            }
            if (appointmentsFacade.hasTechnicianConflict(technicianId, appointment.getAppointment_date(),
                    appointment.getAppointment_time(), requestedDurationHours, appointment.getId())) {
                response.sendRedirect("AssignTechnician.jsp?id=" + appointment.getId() + "&error=TechnicianBusy");
                return;
            }
            appointment.setTechnician_id(technicianId);
            appointment.setStatus("ASSIGNED");
            if (specialNotes != null && !specialNotes.trim().isEmpty()) {
                appointment.setTechnician_notes(specialNotes);
            }
            appointmentsFacade.edit(appointment);
            response.sendRedirect("Appointments.jsp?assigned=1");
            return;
        }
    }

    Map<Integer, Boolean> technicianAvailability = new LinkedHashMap<>();
    if (appointment != null) {
        for (UsersEntity tech : technicians) {
            boolean busy = appointmentsFacade.hasTechnicianConflict(tech.getId(), appointment.getAppointment_date(),
                    appointment.getAppointment_time(), requestedDurationHours, appointment.getId());
            technicianAvailability.put(tech.getId(), !busy);
        }
    }
%>
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
    <jsp:include page="../../Component/Sidebar.jsp" />

    <div class="main">
        <jsp:include page="../../Component/Topbar.jsp">
            <jsp:param name="section" value="ASSIGN TECHNICIAN" />
        </jsp:include>

        <div class="header-row">
            <div class="header-text">
                <h1>Assign Technician to Appointment</h1>
                <p>Select a qualified technician for this service</p>
            </div>
        </div>

        <div class="form-container">
            <% String error = request.getParameter("error"); %>
            <% if (error != null) { %>
                <div class="info-box" style="background:#fee2e2;color:#991b1b;">
                    <%
                        if ("PastDateTime".equals(error)) {
                            out.print("This appointment slot is already in the past, so it cannot be assigned anymore.");
                        } else if ("TechnicianBusy".equals(error)) {
                            out.print("That technician is already busy during this appointment window. Please choose an available technician.");
                        } else {
                            out.print("Technician assignment could not be completed.");
                        }
                    %>
                </div>
            <% } %>
            <% if (appointment != null) { 
                String formattedDate = appointment.getAppointment_date() != null ? appointment.getAppointment_date().format(DateTimeFormatter.ofPattern("MMM dd, yyyy")) : "-";
                String formattedTime = appointment.getAppointment_time() != null ? appointment.getAppointment_time().format(DateTimeFormatter.ofPattern("hh:mm a")) : "-";
                
                String customerName = "-";
                if (appointment.getCustomer_id() != null) {
                    UsersEntity cust = usersFacade.find(appointment.getCustomer_id());
                    if (cust != null) customerName = cust.getName();
                }

                String notes = appointment.getCustomer_notes() != null ? appointment.getCustomer_notes() : "-";
            %>
            <div class="appointment-details">
                <div class="detail-row">
                    <div class="detail-label">Appointment ID:</div>
                    <div class="detail-value">#APT<%= String.format("%03d", appointment.getId()) %></div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">Customer:</div>
                    <div class="detail-value"><%= customerName %></div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">Service Type:</div>
                    <div class="detail-value"><%= serviceName %></div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">Issue:</div>
                    <div class="detail-value"><%= notes %></div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">Date/Time:</div>
                    <div class="detail-value"><%= formattedDate %> - <%= formattedTime %></div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">Reserved Duration:</div>
                    <div class="detail-value"><%= requestedDurationHours %> hour(s)</div>
                </div>
            </div>

            <form method="POST">
                <div class="form-group">
                    <label for="technician">Select Technician *</label>
                    <div class="info-box">
                        <strong>Available Technicians:</strong>
                        Only technicians without overlapping work during this service window can be assigned.
                    </div>
                    
                    <div class="technician-list">
                        <% for (UsersEntity tech : technicians) { %>
                        <div class="technician-item">
                            <div style="display: flex; align-items: center; flex: 1;">
                                <input type="radio" name="technician" id="tech<%= tech.getId() %>" value="<%= tech.getId() %>" <%= Boolean.TRUE.equals(technicianAvailability.get(tech.getId())) ? "" : "disabled" %> required>
                                <div class="technician-info">
                                    <div class="technician-name"><%= tech.getName() %></div>
                                    <div class="availability"><%= Boolean.TRUE.equals(technicianAvailability.get(tech.getId())) ? "Available for this slot" : "Busy during this slot" %></div>
                                </div>
                            </div>
                        </div>
                        <% } %>
                    </div>
                </div>

                <div class="form-group">
                    <label for="notes">Special Notes/Instructions (Optional)</label>
                    <textarea id="notes" name="notes" rows="4" placeholder="Add any special instructions for the technician..."></textarea>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn-submit">Assign Technician</button>
                    <button type="button" class="btn-cancel" onclick="window.location.href='Appointments.jsp'">Cancel</button>
                </div>
            </form>
            <% } else { %>
            <div class="appointment-details">
                <p>Appointment details not found.</p>
            </div>
            <% } %>
        </div>
    </div>
</div>

</body>
</html>



