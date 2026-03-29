<%@page import="java.util.ArrayList,java.util.Arrays,java.util.HashMap,java.util.List,java.util.Map,models.AppointmentService,models.AppointmentServiceFacade,models.Appointments,models.AppointmentsFacade,models.ServiceEntity,models.ServiceEntityFacade,models.UsersEntity,models.UsersEntityFacade,utils.EjbLookup"%>
<%
    UsersEntity currentUser = (UsersEntity) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/loginjsp.jsp");
        return;
    }
    String currentRole = currentUser.getRole() == null ? "" : currentUser.getRole().trim().toLowerCase();
    if (!("manager".equals(currentRole) || "admin".equals(currentRole) || "super_admin".equals(currentRole))) {
        response.sendRedirect(request.getContextPath() + "/loginjsp.jsp");
        return;
    }

    AppointmentsFacade appointmentsFacade = EjbLookup.lookup(AppointmentsFacade.class, "AppointmentsFacade");
    UsersEntityFacade userFacade = EjbLookup.lookup(UsersEntityFacade.class, "UsersEntityFacade");
    AppointmentServiceFacade appointmentServiceFacade = EjbLookup.lookup(AppointmentServiceFacade.class, "AppointmentServiceFacade");
    ServiceEntityFacade serviceFacade = EjbLookup.lookup(ServiceEntityFacade.class, "ServiceEntityFacade");

    List<Appointments> appointments = appointmentsFacade.findAllOrdered();
    Map<Integer, UsersEntity> usersById = new HashMap<>();
    for (UsersEntity user : userFacade.findAll()) {
        usersById.put(user.getId(), user);
    }

    long totalAppointments = appointments.size();
    long completedCount = 0;
    long waitingApprovalCount = 0;
    long pendingConfirmedCount = 0;
    for (Appointments appointment : appointments) {
        String status = appointment.getStatus() == null ? "PENDING" : appointment.getStatus().trim().toUpperCase();
        if (Arrays.asList("COMPLETED", "UNPAID", "PAID").contains(status)) {
            completedCount++;
        } else if ("WAITING APPROVAL".equals(status)) {
            waitingApprovalCount++;
        } else if (Arrays.asList("PENDING", "ASSIGNED", "ACCEPTED").contains(status)) {
            pendingConfirmedCount++;
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Manager Appointments</title>
    <link rel="stylesheet" href="../../Styles/main.css">
    <style>
        .table-container,.modal-card{background:white;padding:22px;border-radius:18px;box-shadow:0 10px 30px rgba(15,23,42,.06)}
        .table-header{display:flex;justify-content:space-between;align-items:center;gap:12px;margin-bottom:18px;flex-wrap:wrap}
        .search-box{flex:1;min-width:280px;padding:10px 12px;border:1px solid #dbe2ea;border-radius:10px;box-sizing:border-box;font-size:14px}
        .filters{display:flex;gap:10px;margin-bottom:18px;flex-wrap:wrap}
        .filter-btn{padding:8px 14px;border:1px solid #dbe2ea;background:white;border-radius:999px;cursor:pointer;font-size:14px;transition:all .2s ease}
        .filter-btn.active,.filter-btn:hover{background:#2563eb;color:white;border-color:#2563eb}
        table{width:100%;border-collapse:collapse}
        th,td{padding:14px 12px;border-bottom:1px solid #e2e8f0;text-align:left;vertical-align:top}
        th{font-size:12px;text-transform:uppercase;letter-spacing:.04em;color:#64748b}
        .status-pill{display:inline-flex;align-items:center;padding:4px 10px;border-radius:999px;font-size:12px;font-weight:600}
        .status-pending{background:#fef3c7;color:#92400e}
        .status-assigned{background:#dbeafe;color:#1d4ed8}
        .status-waiting-approval{background:#fde68a;color:#92400e}
        .status-accepted{background:#dcfce7;color:#166534}
        .status-completed{background:#e2e8f0;color:#334155}
        .status-rejected{background:#fee2e2;color:#b91c1c}
        .btn-small{padding:8px 10px;border:none;border-radius:8px;font-size:12px;font-weight:600;cursor:pointer;background:#dbeafe;color:#1d4ed8}
        .summary-grid{display:grid;grid-template-columns:repeat(4,1fr);gap:18px;margin-bottom:22px}
        .summary-card{background:white;border-radius:18px;padding:20px;box-shadow:0 10px 30px rgba(15,23,42,.06)}
        .summary-label{font-size:13px;color:#64748b;margin-bottom:10px}
        .summary-value{font-size:30px;font-weight:700;color:#0f172a}
        .empty-table{text-align:center;color:#64748b;padding:22px}
        .modal{display:none;position:fixed;inset:0;background:rgba(15,23,42,.48);z-index:1000;padding:30px 16px;overflow-y:auto}
        .modal.show{display:block}
        .modal-card{max-width:940px;margin:0 auto}
        .modal-header{display:flex;justify-content:space-between;align-items:center;margin-bottom:18px}
        .close-btn{border:none;background:#e2e8f0;border-radius:10px;padding:8px 10px;cursor:pointer}
        .detail-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:14px}
        .detail-card{background:#f8fafc;border:1px solid #e2e8f0;border-radius:14px;padding:14px}
        .detail-card strong{display:block;margin-bottom:6px}
        .full-span{grid-column:1/-1}
        @media (max-width:1080px){.summary-grid{grid-template-columns:repeat(2,1fr)}.detail-grid{grid-template-columns:1fr}}
        @media (max-width:680px){.summary-grid{grid-template-columns:1fr}}
    </style>
</head>
<body>
<div class="layout">
    <jsp:include page="../../Component/Sidebar.jsp" />
    <div class="main">
        <jsp:include page="../../Component/Topbar.jsp">
            <jsp:param name="section" value="APPOINTMENTS" />
        </jsp:include>

        <div class="header-row">
            <div class="header-text">
                <h1>Appointments Oversight</h1>
                <p>Live appointment records from the database for manager review.</p>
            </div>
        </div>

        <div class="summary-grid">
            <div class="summary-card"><div class="summary-label">Total Appointments</div><div class="summary-value"><%= totalAppointments %></div></div>
            <div class="summary-card"><div class="summary-label">Completed / Paid</div><div class="summary-value"><%= completedCount %></div></div>
            <div class="summary-card"><div class="summary-label">Waiting Approval</div><div class="summary-value"><%= waitingApprovalCount %></div></div>
            <div class="summary-card"><div class="summary-label">Pending / Confirmed</div><div class="summary-value"><%= pendingConfirmedCount %></div></div>
        </div>

        <div class="filters">
            <button class="filter-btn active" data-filter="all">All</button>
            <button class="filter-btn" data-filter="pending">Pending</button>
            <button class="filter-btn" data-filter="assigned">Assigned</button>
            <button class="filter-btn" data-filter="waiting_approval">Waiting Approval</button>
            <button class="filter-btn" data-filter="accepted">Accepted</button>
            <button class="filter-btn" data-filter="completed">Completed / Paid</button>
            <button class="filter-btn" data-filter="rejected">Rejected</button>
        </div>

        <div class="table-container">
            <div class="table-header">
                <input id="appointmentSearch" type="text" class="search-box" placeholder="Search by appointment, customer, technician, service, or status...">
            </div>

            <table id="appointmentTable">
                <thead>
                    <tr>
                        <th>Appointment</th>
                        <th>Date & Time</th>
                        <th>Customer</th>
                        <th>Technician</th>
                        <th>Service</th>
                        <th>Price</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (appointments.isEmpty()) { %>
                    <tr><td colspan="8" class="empty-table">No appointment data is available yet.</td></tr>
                    <% } else {
                        for (Appointments appointment : appointments) {
                            String status = appointment.getStatus() == null ? "PENDING" : appointment.getStatus().trim().toUpperCase();
                            String filterStatus = status.toLowerCase().replace(' ', '_');
                            if ("COMPLETED".equals(status) || "UNPAID".equals(status) || "PAID".equals(status)) {
                                filterStatus = "completed";
                            }

                            UsersEntity customer = appointment.getCustomer_id() == null ? null : usersById.get(appointment.getCustomer_id());
                            UsersEntity technician = appointment.getTechnician_id() == null ? null : usersById.get(appointment.getTechnician_id());
                            String customerName = customer == null ? "Customer" : customer.getName();
                            String technicianName = technician == null ? "-" : technician.getName();

                            List<AppointmentService> links = appointmentServiceFacade.findByAppointmentId(appointment.getAppointment_id());
                            List<String> serviceNames = new ArrayList<>();
                            for (AppointmentService link : links) {
                                ServiceEntity service = serviceFacade.find(link.getService_id());
                                if (service != null && service.getService_name() != null) {
                                    serviceNames.add(service.getService_name());
                                }
                            }
                            String serviceLabel = serviceNames.isEmpty() ? "Appointment Booking" : String.join(", ", serviceNames);
                            String badgeClass = "status-pending";
                            if ("ASSIGNED".equals(status)) badgeClass = "status-assigned";
                            else if ("WAITING APPROVAL".equals(status)) badgeClass = "status-waiting-approval";
                            else if ("ACCEPTED".equals(status)) badgeClass = "status-accepted";
                            else if ("REJECTED".equals(status)) badgeClass = "status-rejected";
                            else if ("COMPLETED".equals(status) || "UNPAID".equals(status) || "PAID".equals(status)) badgeClass = "status-completed";
                    %>
                    <tr class="appointment-row"
                        data-status="<%= filterStatus %>"
                        data-search="<%= (customerName + " " + technicianName + " " + serviceLabel + " " + status + " #APT" + appointment.getAppointment_id()).toLowerCase() %>"
                        data-id="#APT<%= String.format("%03d", appointment.getAppointment_id()) %>"
                        data-date="<%= appointment.getAppointment_date() %>"
                        data-time="<%= appointment.getAppointment_time() %>"
                        data-customer="<%= escapeForJs(customerName) %>"
                        data-technician="<%= escapeForJs(technicianName) %>"
                        data-service="<%= escapeForJs(serviceLabel) %>"
                        data-price="RM <%= appointment.getTotal_amount() == null ? "0.00" : appointment.getTotal_amount() %>"
                        data-status-label="<%= escapeForJs(status) %>"
                        data-customer-note="<%= escapeForJs(appointment.getCustomer_notes()) %>"
                        data-tech-note="<%= escapeForJs(appointment.getTechnician_notes()) %>"
                        data-staff-comment="<%= escapeForJs(appointment.getCounter_staff_comment()) %>"
                        data-feedback="<%= escapeForJs(appointment.getCustomer_feedback()) %>">
                        <td>#APT<%= String.format("%03d", appointment.getAppointment_id()) %></td>
                        <td><%= appointment.getAppointment_date() %><br><small><%= appointment.getAppointment_time() %></small></td>
                        <td><%= customerName %></td>
                        <td><%= technicianName %></td>
                        <td><%= serviceLabel %></td>
                        <td>RM <%= appointment.getTotal_amount() == null ? "0.00" : appointment.getTotal_amount() %></td>
                        <td><span class="status-pill <%= badgeClass %>"><%= status %></span></td>
                        <td><button type="button" class="btn-small" onclick="openAppointmentModal(this)">View</button></td>
                    </tr>
                    <%  }
                       } %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<div id="appointmentModal" class="modal">
    <div class="modal-card">
        <div class="modal-header">
            <h3>Appointment Details</h3>
            <button type="button" class="close-btn" onclick="closeAppointmentModal()">Close</button>
        </div>
        <div class="detail-grid">
            <div class="detail-card"><strong>Appointment ID</strong><span id="modalAppointmentId"></span></div>
            <div class="detail-card"><strong>Date</strong><span id="modalDate"></span></div>
            <div class="detail-card"><strong>Time</strong><span id="modalTime"></span></div>
            <div class="detail-card"><strong>Customer</strong><span id="modalCustomer"></span></div>
            <div class="detail-card"><strong>Technician</strong><span id="modalTechnician"></span></div>
            <div class="detail-card"><strong>Status</strong><span id="modalStatus"></span></div>
            <div class="detail-card full-span"><strong>Service Bundle</strong><span id="modalService"></span></div>
            <div class="detail-card"><strong>Total</strong><span id="modalPrice"></span></div>
            <div class="detail-card full-span"><strong>Customer Note</strong><span id="modalCustomerNote"></span></div>
            <div class="detail-card full-span"><strong>Staff Comment</strong><span id="modalStaffComment"></span></div>
            <div class="detail-card full-span"><strong>Technician Note</strong><span id="modalTechNote"></span></div>
            <div class="detail-card full-span"><strong>Customer Feedback</strong><span id="modalFeedback"></span></div>
        </div>
    </div>
</div>

<script>
    const filterButtons = document.querySelectorAll(".filter-btn");
    const appointmentRows = document.querySelectorAll(".appointment-row");
    const searchInput = document.getElementById("appointmentSearch");

    if (searchInput) {
        searchInput.addEventListener("input", applyAppointmentFilters);
    }

    filterButtons.forEach(function (button) {
        button.addEventListener("click", function () {
            filterButtons.forEach(function (btn) { btn.classList.remove("active"); });
            button.classList.add("active");
            applyAppointmentFilters();
        });
    });

    function applyAppointmentFilters() {
        const activeFilter = document.querySelector(".filter-btn.active").dataset.filter;
        const keyword = (searchInput.value || "").toLowerCase();
        appointmentRows.forEach(function (row) {
            const matchesFilter = activeFilter === "all" || row.dataset.status === activeFilter;
            const matchesSearch = !keyword || (row.dataset.search || "").includes(keyword);
            row.style.display = matchesFilter && matchesSearch ? "" : "none";
        });
    }

    function openAppointmentModal(button) {
        const row = button.closest("tr");
        document.getElementById("modalAppointmentId").textContent = row.dataset.id || "-";
        document.getElementById("modalDate").textContent = row.dataset.date || "-";
        document.getElementById("modalTime").textContent = row.dataset.time || "-";
        document.getElementById("modalCustomer").textContent = row.dataset.customer || "-";
        document.getElementById("modalTechnician").textContent = row.dataset.technician || "-";
        document.getElementById("modalStatus").textContent = row.dataset.statusLabel || "-";
        document.getElementById("modalService").textContent = row.dataset.service || "-";
        document.getElementById("modalPrice").textContent = row.dataset.price || "-";
        document.getElementById("modalCustomerNote").textContent = row.dataset.customerNote || "-";
        document.getElementById("modalStaffComment").textContent = row.dataset.staffComment || "-";
        document.getElementById("modalTechNote").textContent = row.dataset.techNote || "-";
        document.getElementById("modalFeedback").textContent = row.dataset.feedback || "-";
        document.getElementById("appointmentModal").classList.add("show");
    }

    function closeAppointmentModal() {
        document.getElementById("appointmentModal").classList.remove("show");
    }

    window.addEventListener("click", function (event) {
        const modal = document.getElementById("appointmentModal");
        if (event.target === modal) {
            closeAppointmentModal();
        }
    });
</script>
</body>
</html>
<%!
    private String escapeForJs(String value) {
        if (value == null) return "";
        return value.replace("\\", "\\\\").replace("'", "\\'").replace("\"", "&quot;").replace("\r", " ").replace("\n", " ");
    }
%>
