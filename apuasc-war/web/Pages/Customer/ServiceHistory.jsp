<%@page import="java.math.BigDecimal,java.util.ArrayList,java.util.Arrays,java.util.HashMap,java.util.List,java.util.Map,models.AppointmentService,models.AppointmentServiceFacade,models.Appointments,models.AppointmentsFacade,models.ServiceEntity,models.ServiceEntityFacade,models.UsersEntity,models.UsersEntityFacade,utils.EjbLookup"%>
<%
    UsersEntity currentUser = (UsersEntity) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/loginjsp.jsp");
        return;
    }

    UsersEntityFacade userFacade = EjbLookup.lookup(UsersEntityFacade.class, "UsersEntityFacade");
    AppointmentsFacade appointmentsFacade = EjbLookup.lookup(AppointmentsFacade.class, "AppointmentsFacade");
    AppointmentServiceFacade appointmentServiceFacade = EjbLookup.lookup(AppointmentServiceFacade.class, "AppointmentServiceFacade");
    ServiceEntityFacade serviceFacade = EjbLookup.lookup(ServiceEntityFacade.class, "ServiceEntityFacade");

    currentUser = userFacade.find(currentUser.getId());
    session.setAttribute("user", currentUser);

    List<Appointments> serviceHistory = appointmentsFacade.findByCustomerIdAndStatuses(currentUser.getId(), Arrays.asList("COMPLETED", "UNPAID", "PAID"));
    Map<Integer, String> serviceNames = new HashMap<>();
    Map<Integer, String> technicianNames = new HashMap<>();
    Map<Integer, String> technicianNotes = new HashMap<>();
    Map<Integer, String> customerFeedback = new HashMap<>();
    BigDecimal totalSpent = BigDecimal.ZERO;
    for (Appointments appointment : serviceHistory) {
        List<AppointmentService> links = appointmentServiceFacade.findByAppointmentId(appointment.getAppointment_id());
        List<String> names = new ArrayList<>();
        for (AppointmentService link : links) {
            ServiceEntity service = serviceFacade.find(link.getService_id());
            if (service != null) {
                names.add(service.getService_name());
            }
        }
        serviceNames.put(appointment.getAppointment_id(), names.isEmpty() ? "Service Request" : String.join(", ", names));
        UsersEntity technician = appointment.getTechnician_id() == null ? null : userFacade.find(appointment.getTechnician_id());
        technicianNames.put(appointment.getAppointment_id(), technician == null ? "Pending assignment" : technician.getName());
        technicianNotes.put(appointment.getAppointment_id(), appointment.getTechnician_notes() == null || appointment.getTechnician_notes().trim().isEmpty()
                ? "No technician note yet."
                : appointment.getTechnician_notes());
        customerFeedback.put(appointment.getAppointment_id(), appointment.getCustomer_feedback() == null || appointment.getCustomer_feedback().trim().isEmpty()
                ? "No customer feedback saved yet."
                : appointment.getCustomer_feedback());
        if ("PAID".equalsIgnoreCase(appointment.getStatus()) && appointment.getTotal_amount() != null) {
            totalSpent = totalSpent.add(appointment.getTotal_amount());
        }
    }
    String latestRecord = serviceHistory.isEmpty() ? "-" : String.valueOf(serviceHistory.get(0).getAppointment_date());
%>
<!DOCTYPE html>
<html>
<head>
    <title>Service History</title>
    <link rel="stylesheet" href="../../Styles/main.css">
    <style>
        .table-container, .modal-card { background:white; padding:22px; border-radius:18px; box-shadow:0 10px 30px rgba(15,23,42,0.06); }
        .summary-cards { display:grid; grid-template-columns:repeat(3,1fr); gap:18px; margin-bottom:20px; }
        .summary-card { background:white; padding:18px; border-radius:18px; box-shadow:0 10px 30px rgba(15,23,42,0.06); }
        .summary-label { font-size:13px; color:#64748b; margin-bottom:10px; }
        .summary-value { font-size:30px; font-weight:700; color:#0f172a; }
        .search-box { width:100%; padding:10px 12px; border:1px solid #dbe2ea; border-radius:10px; box-sizing:border-box; }
        table { width:100%; border-collapse:collapse; }
        th,td { padding:14px 12px; border-bottom:1px solid #e2e8f0; text-align:left; vertical-align:top; }
        th { font-size:12px; text-transform:uppercase; letter-spacing:0.04em; color:#64748b; }
        .status-pill {
            display:inline-flex; align-items:center; padding:4px 10px; border-radius:999px; font-size:12px; font-weight:600;
            background:#dbeafe; color:#1d4ed8;
        }
        .status-pill.paid { background:#dcfce7; color:#166534; }
        .status-pill.unpaid { background:#fef3c7; color:#92400e; }
        .btn-small { padding:8px 10px; border:none; border-radius:8px; font-size:12px; font-weight:600; cursor:pointer; background:#dbeafe; color:#1d4ed8; }
        .empty-state { padding:22px; border:1px dashed #cbd5e1; border-radius:14px; color:#64748b; text-align:center; }
        .modal { display:none; position:fixed; inset:0; background:rgba(15,23,42,0.48); z-index:1000; padding:30px 16px; }
        .modal.show { display:block; }
        .modal-card { max-width:760px; margin:0 auto; }
        .detail-grid { display:grid; grid-template-columns:repeat(2,1fr); gap:14px; }
        .detail-card { background:#f8fafc; border:1px solid #e2e8f0; border-radius:14px; padding:14px; }
        .detail-card strong { display:block; margin-bottom:6px; }
        .full-span { grid-column:1 / -1; }
        @media (max-width: 800px) { .summary-cards,.detail-grid { grid-template-columns:1fr; } }
    </style>
</head>
<body>
<div class="layout">
    <jsp:include page="../../Component/Sidebar.jsp" />
    <div class="main">
        <jsp:include page="../../Component/Topbar.jsp">
            <jsp:param name="section" value="SERVICE HISTORY" />
        </jsp:include>

        <div class="header-row">
            <div class="header-text">
                <h1>Service History</h1>
                <p>Completed appointment records and technician notes saved from your appointment data.</p>
            </div>
            <div class="actions">
                <button class="btn btn-primary" onclick="window.location.href='../../Pages/Customer/PaymentHistory.jsp'">Payment History</button>
            </div>
        </div>

        <div class="summary-cards">
            <div class="summary-card"><div class="summary-label">Completed Services</div><div class="summary-value"><%= serviceHistory.size() %></div></div>
            <div class="summary-card"><div class="summary-label">Total Spent</div><div class="summary-value">RM <%= totalSpent %></div></div>
            <div class="summary-card"><div class="summary-label">Latest Record</div><div class="summary-value"><%= latestRecord %></div></div>
        </div>

        <div class="table-container">
            <div class="table-header" style="margin-bottom:18px;">
                <input id="serviceSearch" type="text" class="search-box" placeholder="Search service history by service, technician, or status...">
            </div>
            <% if (serviceHistory.isEmpty()) { %>
                <div class="empty-state">No completed or billed appointments have been saved for your account yet.</div>
            <% } else { %>
            <table id="serviceTable">
                <thead>
                    <tr>
                        <th>Appointment</th>
                        <th>Date</th>
                        <th>Service</th>
                        <th>Technician</th>
                        <th>Status</th>
                        <th>Amount</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Appointments appointment : serviceHistory) { %>
                    <tr data-id="<%= appointment.getAppointment_id() %>"
                        data-date="<%= appointment.getAppointment_date() %>"
                        data-service="<%= serviceNames.get(appointment.getAppointment_id()) %>"
                        data-technician="<%= technicianNames.get(appointment.getAppointment_id()) %>"
                        data-status="<%= appointment.getStatus() %>"
                        data-total="<%= appointment.getTotal_amount() %>"
                        data-tech-note="<%= technicianNotes.get(appointment.getAppointment_id()) %>"
                        data-feedback="<%= customerFeedback.get(appointment.getAppointment_id()) %>">
                        <td>#APT<%= appointment.getAppointment_id() %></td>
                        <td><%= appointment.getAppointment_date() %></td>
                        <td><%= serviceNames.get(appointment.getAppointment_id()) %></td>
                        <td><%= technicianNames.get(appointment.getAppointment_id()) %></td>
                        <td>
                            <span class="status-pill <%= "PAID".equalsIgnoreCase(appointment.getStatus()) ? "paid" : ("UNPAID".equalsIgnoreCase(appointment.getStatus()) ? "unpaid" : "") %>">
                                <%= appointment.getStatus() %>
                            </span>
                        </td>
                        <td>RM <%= appointment.getTotal_amount() %></td>
                        <td><button type="button" class="btn-small" onclick="openServiceModal(this)">Details</button></td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
            <% } %>
        </div>
    </div>
</div>

<div id="serviceModal" class="modal">
    <div class="modal-card">
        <div class="header-row" style="margin-bottom:18px;">
            <div class="header-text"><h1 style="font-size:28px;">Service Details</h1><p>Completed service notes and feedback</p></div>
            <div class="actions"><button class="btn btn-light" type="button" onclick="closeServiceModal()">Close</button></div>
        </div>
        <div class="detail-grid">
            <div class="detail-card"><strong>Appointment</strong><span id="serviceModalAppointment"></span></div>
            <div class="detail-card"><strong>Date</strong><span id="serviceModalDate"></span></div>
            <div class="detail-card"><strong>Service</strong><span id="serviceModalService"></span></div>
            <div class="detail-card"><strong>Technician</strong><span id="serviceModalTechnician"></span></div>
            <div class="detail-card"><strong>Status</strong><span id="serviceModalStatus"></span></div>
            <div class="detail-card"><strong>Total Amount</strong><span id="serviceModalAmount"></span></div>
            <div class="detail-card full-span"><strong>Technician Notes</strong><span id="serviceModalTechNote"></span></div>
            <div class="detail-card full-span"><strong>Your Feedback</strong><span id="serviceModalFeedback"></span></div>
        </div>
    </div>
</div>

<script>
    document.getElementById("serviceSearch").addEventListener("input", function () {
        const keyword = this.value.toLowerCase();
        document.querySelectorAll("#serviceTable tbody tr").forEach(function (row) {
            row.style.display = row.innerText.toLowerCase().includes(keyword) ? "" : "none";
        });
    });
    function openServiceModal(button) {
        const row = button.closest("tr");
        document.getElementById("serviceModalAppointment").textContent = "#APT" + (row.dataset.id || "-");
        document.getElementById("serviceModalDate").textContent = row.dataset.date || "-";
        document.getElementById("serviceModalService").textContent = row.dataset.service || "-";
        document.getElementById("serviceModalTechnician").textContent = row.dataset.technician || "-";
        document.getElementById("serviceModalStatus").textContent = row.dataset.status || "-";
        document.getElementById("serviceModalAmount").textContent = "RM " + (row.dataset.total || "0.00");
        document.getElementById("serviceModalTechNote").textContent = row.dataset.techNote || "-";
        document.getElementById("serviceModalFeedback").textContent = row.dataset.feedback || "-";
        document.getElementById("serviceModal").classList.add("show");
    }
    function closeServiceModal() { document.getElementById("serviceModal").classList.remove("show"); }
</script>
</body>
</html>
