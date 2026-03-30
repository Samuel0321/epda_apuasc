<%--
    Document   : Appointments
    Created on : Mar 24, 2026
    Author     : pinju
    Updated   : New Workflow (PENDING -> ASSIGNED -> WAITING APPROVAL -> APPROVED -> COMPLETED -> PAID)
--%>

<%@page import="java.math.BigDecimal,java.text.NumberFormat,java.util.Arrays,java.util.List,java.util.Locale,models.AppointmentService,models.AppointmentServiceFacade,models.Appointments,models.AppointmentsFacade,models.ServiceEntity,models.ServiceEntityFacade,models.UsersEntity,models.UsersEntityFacade,utils.EjbLookup"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    UsersEntity currentUser = (UsersEntity) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/loginjsp.jsp");
        return;
    }
    String currentRole = currentUser.getRole() == null ? "" : currentUser.getRole().trim().toLowerCase();
    if (!("receptionist".equals(currentRole) || "counter_staff".equals(currentRole))) {
        response.sendRedirect(request.getContextPath() + "/loginjsp.jsp");
        return;
    }

    AppointmentsFacade appointmentsFacade = EjbLookup.lookup(AppointmentsFacade.class, "AppointmentsFacade");
    UsersEntityFacade usersFacade = EjbLookup.lookup(UsersEntityFacade.class, "UsersEntityFacade");
    AppointmentServiceFacade appointmentServiceFacade = EjbLookup.lookup(AppointmentServiceFacade.class, "AppointmentServiceFacade");
    ServiceEntityFacade serviceEntityFacade = EjbLookup.lookup(ServiceEntityFacade.class, "ServiceEntityFacade");

    List<Appointments> appointments = appointmentsFacade.findAllOrdered();
    NumberFormat currency = NumberFormat.getCurrencyInstance(new Locale("ms", "MY"));

    java.util.Map<Integer, String> userNameById = new java.util.HashMap<Integer, String>();
    for (UsersEntity user : usersFacade.findAll()) {
        userNameById.put(user.getId(), user.getName());
    }
%>
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
        <jsp:include page="../../Component/Topbar.jsp">
            <jsp:param name="section" value="APPOINTMENTS" />
        </jsp:include>

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
            <button class="filter-btn active" data-filter="All">All</button>
            <button class="filter-btn" data-filter="Today">Today</button>
            <button class="filter-btn" data-filter="Pending">Pending</button>
            <button class="filter-btn" data-filter="Assigned">Assigned</button>
            <button class="filter-btn" data-filter="Waiting Approval">Waiting Approval</button>
            <button class="filter-btn" data-filter="Delayed">Delayed</button>
            <button class="filter-btn" data-filter="Accepted">Repair In Progress</button>
            <button class="filter-btn" data-filter="Completed">Completed</button>
            <button class="filter-btn" data-filter="Paid">Paid</button>
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
                    <% if (appointments == null || appointments.isEmpty()) { %>
                    <tr>
                        <td colspan="9">No appointments found.</td>
                    </tr>
                    <% } else {
                        for (Appointments appointment : appointments) {
                            Integer appointmentId = appointment.getId();
                            String status = appointment.getStatus() == null ? "PENDING" : appointment.getStatus().trim().toUpperCase();
                            String customerName = userNameById.get(appointment.getCustomer_id());
                            if (customerName == null || customerName.trim().isEmpty()) {
                                customerName = "Customer #" + appointment.getCustomer_id();
                            }
                            String technicianName = "-";
                            if (appointment.getTechnician_id() != null) {
                                technicianName = userNameById.get(appointment.getTechnician_id());
                                if (technicianName == null || technicianName.trim().isEmpty()) {
                                    technicianName = "Technician #" + appointment.getTechnician_id();
                                }
                            }

                            List<AppointmentService> links = appointmentServiceFacade.findByAppointmentId(appointmentId);
                            String serviceName = "General Service";
                            if (links != null && !links.isEmpty()) {
                                Integer serviceId = links.get(0).getService_id();
                                ServiceEntity service = serviceId == null ? null : serviceEntityFacade.find(serviceId);
                                if (service != null && service.getService_name() != null && !service.getService_name().trim().isEmpty()) {
                                    serviceName = service.getService_name();
                                }
                            }

                            String issueText = appointment.getCustomer_notes() == null ? "-" : appointment.getCustomer_notes();
                            String badgeClass = "badge-pending";
                            if ("ASSIGNED".equals(status)) {
                                badgeClass = "badge-assigned";
                            } else if ("WAITING APPROVAL".equals(status)) {
                                badgeClass = "badge-waiting-approval";
                            } else if ("DELAYED".equals(status)) {
                                badgeClass = "badge-rejected";
                            } else if (Arrays.asList("APPROVED", "ACCEPTED").contains(status)) {
                                badgeClass = "badge-approved";
                            } else if (Arrays.asList("REJECTED", "UNPAID").contains(status)) {
                                badgeClass = "badge-rejected";
                            } else if ("COMPLETED".equals(status)) {
                                badgeClass = "badge-completed";
                            } else if ("PAID".equals(status)) {
                                badgeClass = "badge-paid";
                            } else if ("CANCELLED".equals(status)) {
                                badgeClass = "badge-rejected";
                            }
                    %>
                    <tr class="appointment-row" data-status="<%= status %>" data-date="<%= (appointment.getAppointment_date() == null ? "" : appointment.getAppointment_date().toString()) %>">
                        <td>#APT<%= String.format("%03d", appointmentId) %></td>
                        <td><%= customerName %></td>
                        <td><%= serviceName %></td>
                        <td><%= issueText %></td>
                        <td><%= (appointment.getAppointment_date() == null ? "-" : appointment.getAppointment_date().toString()) %> - <%= (appointment.getAppointment_time() == null ? "-" : appointment.getAppointment_time().toString()) %> to <%= appointmentsFacade.estimateAppointmentEndTime(appointment) == null ? "-" : appointmentsFacade.estimateAppointmentEndTime(appointment).toString() %></td>
                        <td><%= technicianName %></td>
                        <td><span class="badge <%= badgeClass %>"><%= displayReceptionStatus(status) %></span></td>
                        <td><strong><%= displayAmount(appointment.getTotal_amount(), currency) %></strong></td>
                        <td>
                            <div class="action-buttons">
                                  <% if ("PENDING".equals(status) && appointment.getTechnician_id() == null) { %>
                                <button class="btn-small btn-assign" data-id="<%= appointmentId %>" onclick="assignTechnicianFromButton(this)">Assign Tech</button>
                                <% } %>
                                <% if ("WAITING APPROVAL".equals(status)) { %>
                                <button class="btn-small btn-approve" type="button" disabled>Await Customer</button>
                                <% } %>
                                <% if (appointmentsFacade.canReassignTechnician(appointment) && appointment.getTechnician_id() != null) { %>
                                <button class="btn-small btn-assign" data-id="<%= appointmentId %>" onclick="assignTechnicianFromButton(this)">Reassign Tech</button>
                                <% } %>
                                <% if ("COMPLETED".equals(status) || "UNPAID".equals(status)) { %>
                                <form method="post" action="<%= request.getContextPath() %>/ReceptionistPaymentServlet" style="display:inline;">
                                    <input type="hidden" name="appointmentId" value="<%= appointmentId %>">
                                    <button type="submit" class="btn-small btn-collect">Paid</button>
                                </form>
                                <% } %>
                                <% if (appointmentsFacade.canCancel(appointment)) { %>
                                <form method="post" action="<%= request.getContextPath() %>/AppointmentCancellationServlet" style="display:inline;">
                                    <input type="hidden" name="appointmentId" value="<%= appointmentId %>">
                                    <button type="submit" class="btn-small" style="background:#fecaca;color:#991b1b;">Cancel</button>
                                </form>
                                <% } %>
                                <button class="btn-small btn-view"
                                        data-id="#APT<%= String.format("%03d", appointmentId) %>"
                                        data-customer="<%= escapeForJs(customerName) %>"
                                        data-service="<%= escapeForJs(serviceName) %>"
                                        data-date="<%= (appointment.getAppointment_date() == null ? "-" : appointment.getAppointment_date().toString()) %>"
                                        data-time="<%= (appointment.getAppointment_time() == null ? "-" : appointment.getAppointment_time().toString()) %>"
                                        data-status="<%= escapeForJs(displayReceptionStatus(status)) %>"
                                        data-amount="<%= escapeForJs(displayAmount(appointment.getTotal_amount(), currency)) %>"
                                        data-booking-note="<%= escapeForJs(issueText) %>"
                                        data-tech-note="<%= escapeForJs(normalizeNote(appointment.getTechnician_notes())) %>"
                                        data-staff-comment="<%= escapeForJs(normalizeNote(appointmentsFacade.stripSchedulingMetadata(appointment.getCounter_staff_comment()))) %>"
                                        data-technician="<%= escapeForJs(technicianName) %>"
                                        onclick="viewTechnicianNotes(this)">View</button>
                            </div>
                        </td>
                    </tr>
                    <%  }
                       } %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- APPOINTMENT DETAILS MODAL -->
<div id="notesModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">Appointment Details</div>
        <div id="notesBody">
            <!-- Notes will be inserted here -->
        </div>
        <div class="modal-actions">
            <button class="btn-close-modal" onclick="closeNotesModal()">Close</button>
        </div>
    </div>
</div>

<script>
    function assignTechnicianFromButton(button) {
        assignTechnician(button.getAttribute('data-id'));
    }

    function assignTechnician(appointmentId) {
        window.location.href = 'AssignTechnician.jsp?id=' + appointmentId;
    }

    function viewTechnicianNotes(button) {
        const appointmentId = button.getAttribute('data-id');
        const customer = button.getAttribute('data-customer');
        const service = button.getAttribute('data-service');
        const date = button.getAttribute('data-date');
        const time = button.getAttribute('data-time');
        const status = button.getAttribute('data-status');
        const amount = button.getAttribute('data-amount');
        const bookingNote = button.getAttribute('data-booking-note');
        const techNote = button.getAttribute('data-tech-note');
        const staffComment = button.getAttribute('data-staff-comment');
        const technician = button.getAttribute('data-technician');
        const notesBody = document.getElementById('notesBody');
        const cleanedTechNote = normalizeModalText(techNote);
        const cleanedStaffComment = normalizeModalText(staffComment);
        notesBody.innerHTML =
            '<div class="comment-section">' +
                '<div class="comment-label">Appointment</div>' +
                '<div class="comment-text">' + (appointmentId || '-') + ' | ' + (customer || '-') + '</div>' +
            '</div>' +
            '<div class="comment-section">' +
                '<div class="comment-label">Schedule</div>' +
                '<div class="comment-text">' + (date || '-') + ' | ' + (time || '-') + '</div>' +
            '</div>' +
            '<div class="comment-section">' +
                '<div class="comment-label">Service / Status</div>' +
                '<div class="comment-text">' + (service || '-') + ' | ' + (status || '-') + '</div>' +
                '<div class="comment-meta"><strong>Amount:</strong> ' + (amount || '-') + '</div>' +
            '</div>' +
            '<div class="comment-section">' +
                '<div class="comment-label">Booking Note</div>' +
                '<div class="comment-text">' + (bookingNote || '-') + '</div>' +
            '</div>' +
            '<div class="comment-section">' +
                '<div class="comment-label">Technician Notes</div>' +
                '<div class="comment-text">' + cleanedTechNote + '</div>' +
                '<div class="comment-meta"><strong>Technician:</strong> ' + (technician || '-') + '</div>' +
            '</div>' +
            '<div class="comment-section">' +
                '<div class="comment-label">Receptionist Comment</div>' +
                '<div class="comment-text">' + cleanedStaffComment + '</div>' +
            '</div>';

        document.getElementById('notesModal').classList.add('show');
    }

    function closeNotesModal() {
        document.getElementById('notesModal').classList.remove('show');
    }

    function normalizeModalText(value) {
        if (!value) {
            return '-';
        }
        const normalized = String(value).trim().toLowerCase();
        if (normalized === '' || normalized === 'false' || normalized === 'null' || normalized === 'undefined') {
            return '-';
        }
        return value;
    }

    // Close modal when clicking outside
    window.onclick = function(event) {
        const modal = document.getElementById('notesModal');
        if (event.target === modal) {
            closeNotesModal();
        }
    }

    // Filters logic
    document.addEventListener("DOMContentLoaded", function() {
        const filterBtns = document.querySelectorAll('.filter-btn');
        const rows = document.querySelectorAll('.appointment-row');
        
        const today = new Date();
        const todayStr = today.getFullYear() + "-" + String(today.getMonth()+1).padStart(2,'0') + "-" + String(today.getDate()).padStart(2,'0');

        filterBtns.forEach(btn => {
            btn.addEventListener('click', function() {
                // Update active state
                filterBtns.forEach(b => b.classList.remove('active'));
                this.classList.add('active');

                const filterValue = this.getAttribute('data-filter');

                rows.forEach(row => {
                    const status = row.getAttribute('data-status');
                    const date = row.getAttribute('data-date');
                    
                    if (filterValue === 'All') {
                        row.style.display = '';
                    } else if (filterValue === 'Today') {
                        if (date === todayStr) {
                            row.style.display = '';
                        } else {
                            row.style.display = 'none';
                        }
                    } else {
                        if (status.toUpperCase() === filterValue.toUpperCase()) {
                            row.style.display = '';
                        } else {
                            row.style.display = 'none';
                        }
                    }
                });
            });
        });
    });
</script>

</body>
</html>
<%!
    private String escapeForJs(String value) {
        if (value == null) {
            return "";
        }
        return value.replace("\\", "\\\\").replace("'", "\\'").replace("\"", "&quot;").replace("\r", " ").replace("\n", " ");
    }

    private String displayAmount(BigDecimal amount, NumberFormat currency) {
        if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0) {
            return "To be assessed by technician";
        }
        return currency.format(amount);
    }

    private String displayReceptionStatus(String status) {
        if (status == null) {
            return "-";
        }
        switch (status) {
            case "PENDING": return "Pending Assignment";
            case "ASSIGNED": return "Technician Assigned";
            case "WAITING APPROVAL": return "Awaiting Customer Decision";
            case "ACCEPTED": return "Repair In Progress";
            case "DELAYED": return "Repair Delayed";
            case "REJECTED": return "Quotation Rejected";
            case "COMPLETED": return "Ready For Payment";
            case "UNPAID": return "Payment Pending";
            case "PAID": return "Paid";
            case "CANCELLED": return "Cancelled";
            default: return status;
        }
    }

    private String normalizeNote(String value) {
        if (value == null) {
            return "";
        }
        String trimmed = value.trim();
        if (trimmed.isEmpty() || "false".equalsIgnoreCase(trimmed) || "null".equalsIgnoreCase(trimmed) || "undefined".equalsIgnoreCase(trimmed)) {
            return "";
        }
        return trimmed;
    }
%>



