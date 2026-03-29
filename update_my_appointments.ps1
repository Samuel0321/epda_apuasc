$content = Get-Content apuasc-war/web/Pages/Customer/MyAppointments.jsp -Raw
$newStyle = @""
    <style>
        .summary-cards{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:18px;margin-bottom:20px}
        .summary-card,.task-card,.modal-panel{background:white;border:1px solid #dbe2ea;border-radius:18px;box-shadow:0 10px 28px rgba(15,23,42,.06)}
        .summary-card{padding:18px}
        .summary-label{color:#64748b;font-size:13px;margin-bottom:8px}
        .summary-value{font-size:30px;font-weight:700;color:#0f172a}
        .filters{display:flex;gap:10px;margin-bottom:20px;flex-wrap:wrap}
        .filter-btn{padding:10px 16px;border:1px solid #dbe2ea;background:white;border-radius:10px;cursor:pointer;font-size:14px}
        .filter-btn.active{background:#334155;color:white;border-color:#334155}
        .tasks-container{display:grid;grid-template-columns:repeat(auto-fill,minmax(300px,1fr));gap:20px}
        .task-card.hide{display:none}
        .task-head{padding:18px 20px;border-bottom:1px solid #e2e8f0;background:#f8fafc;display:flex;justify-content:space-between;align-items:center;}
        .task-id{font-size:14px;color:#64748b;font-weight:600;}
        .task-title{font-size:20px;font-weight:700;color:#0f172a}
        .task-body{padding:20px;display:flex;flex-direction:column;gap:14px}
        .task-meta{color:#475569;line-height:1.65;font-size:14px}
        .status-box,.quote-box,.detail-card{background:#f8fafc;border:1px solid #e2e8f0;border-radius:14px;padding:14px;font-size:14px;}
        .status-chip{display:inline-flex;align-items:center;padding:6px 12px;border-radius:999px;font-size:12px;font-weight:700;margin-top:10px;background:#e2e8f0;color:#334155}
        .task-actions{display:flex;flex-direction:column;gap:10px;margin-top:auto}
        .task-btn,.modal-actions button{padding:10px 14px;border:none;border-radius:10px;cursor:pointer;font-size:14px;font-weight:600;width:100%}
        .btn-primary{background:#334155;color:white}
        .btn-secondary{background:#e2e8f0;color:#0f172a}
        .btn-note{background:#cbd5e1;color:#0f172a}
        .btn-disabled{background:#e5e7eb;color:#64748b;cursor:not-allowed}
        .alert{margin-bottom:18px;padding:12px 14px;border-radius:12px;font-size:14px}
        .alert-success{background:#dcfce7;color:#166534}
        .alert-error{background:#fee2e2;color:#991b1b}
        .empty-state{background:white;border:1px dashed #cbd5e1;border-radius:18px;padding:32px;text-align:center;color:#64748b}
        .modal{display:none;position:fixed;inset:0;background:rgba(15,23,42,.48);z-index:1000;padding:30px 16px;overflow-y:auto}
        .modal.show{display:block; display:flex; align-items:center; justify-content:center;}
        .modal-panel{max-width:820px;width:100%;margin:0 auto;padding:24px;background:white;border-radius:20px;}
        .modal-title{font-size:26px;font-weight:700;margin-bottom:8px;color:#0f172a}
        .modal-subtitle{color:#64748b;margin-bottom:18px}
        .detail-grid,.service-checklist{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:14px}
        .detail-card strong{display:block;margin-bottom:6px}
        .full-span{grid-column:1/-1}
        .modal-actions{display:flex;gap:10px;justify-content:flex-end;margin-top:20px}
        @media (max-width:900px){.summary-cards,.detail-grid,.service-checklist{grid-template-columns:1fr}}
    </style>
""@
$content = $content -replace '(?s)<style>.*?</style>', $newStyle

$newHtml = @""
        <% if (successMessage != null) { %>
            <div class="alert alert-success"><%= successMessage %></div>
        <% } %>

        <div class="summary-cards">
            <div class="summary-card">
                <div class="summary-label">Total Appointments</div>
                <div class="summary-value"><%= appointments.size() %></div>
            </div>
            <div class="summary-card">
                <div class="summary-label">Needs Attention</div>
                <div class="summary-value"><%= attentionCount %></div>
            </div>
            <div class="summary-card">
                <div class="summary-label">Pending Payments</div>
                <div class="summary-value"><%= pendingPaymentCount %></div>
            </div>
        </div>

        <div class="filters">
            <button class="filter-btn active" data-filter="all">All</button>
            <button class="filter-btn" data-filter="pending">Pending</button>
            <button class="filter-btn" data-filter="assigned">Assigned</button>
            <button class="filter-btn" data-filter="waiting_approval">Action Required</button>
            <button class="filter-btn" data-filter="accepted">Accepted / In Progress</button>
            <button class="filter-btn" data-filter="completed_group">Completed / Past</button>
        </div>

        <% if (appointments.isEmpty()) { %>
            <div class="empty-state">You have no appointments booked yet.</div>
        <% } else { %>
            <div class="tasks-container">
                <% for (Appointments apt : appointments) {
                    String status = apt.getStatus() == null ? "PENDING" : apt.getStatus().trim().toUpperCase();
                    String filterClass = status.replace(' ', '_').toLowerCase();
                    if ("WAITING APPROVAL".equals(status)) { filterClass = "waiting_approval"; }
                    if ("COMPLETED".equals(status) || "PAID".equals(status) || "UNPAID".equals(status) || "REJECTED".equals(status)) { filterClass = "completed_group"; }
                    
                    String aptServices = serviceNames.get(apt.getAppointment_id());
                    String tName = technicianNames.get(apt.getAppointment_id());
                %>
                <div class="task-card" data-filter="<%= filterClass %>">
                    <div class="task-head">
                        <div class="task-title"><%= apt.getAppointment_date() %></div>
                        <div class="task-id">#APT<%= String.format("%03d", apt.getAppointment_id()) %></div>
                    </div>
                    <div class="task-body">
                        <div class="task-meta">
                            <strong>Time:</strong> <%= apt.getAppointment_time() %><br>
                            <strong>Services:</strong> <%= aptServices %><br>
                            <strong>Technician:</strong> <%= tName %>
                        </div>
                        
                        <div class="status-box">
                            <strong>Status</strong>
                            <div class="status-chip"><%= status %></div>
                        </div>

                        <% if (apt.getTotal_amount() != null) { %>
                        <div class="quote-box">
                            <strong>Amount</strong>
                            <div style="font-weight:700;margin-top:6px;">RM <%= apt.getTotal_amount() %></div>
                        </div>
                        <% } %>

                        <div class="task-actions">
                            <% if ("WAITING APPROVAL".equals(status)) { %>
                                <a href="ApproveQuotation.jsp?id=<%= apt.getAppointment_id() %>" style="text-decoration:none;"><button class="task-btn btn-primary" type="button" style="width:100%">Review Quotation</button></a>
                            <% } %>
                            <% if ("UNPAID".equals(status)) { %>
                                <button class="task-btn btn-note" type="button" onclick="alert('Please proceed to counter for payment.')">Pay at Counter</button>
                            <% } %>
                            <button class="task-btn btn-secondary" type="button" onclick="openDetailsModal('#APT<%= String.format("%03d", apt.getAppointment_id()) %>', '<%= apt.getAppointment_date() %>', '<%= apt.getAppointment_time() %>', '<%= aptServices %>', '<%= tName %>', '<%= escapeForJs(status) %>', '<%= escapeForJs(apt.getCustomer_notes()) %>', '<%= escapeForJs(apt.getTechnician_notes()) %>', '<%= escapeForJs(apt.getCounter_staff_comment()) %>', '<%= apt.getTotal_amount() %>')">View Details</button>
                        </div>
                    </div>
                </div>
                <% } %>
            </div>
        <% } %>
""@
$content = $content -replace '(?s)<div class="header-row">.*?<script>', ('<div class="header-row"><div class="header-text"><h1>My Appointments</h1><p>View and manage all your appointments.</p></div><div class="actions"><button class="btn btn-primary" onclick="window.location.href=''../../Pages/Customer/BookAppointment.jsp''">+ Book Appointment</button></div></div>' + $newHtml + '<script>')

if ($content -notmatch 'escapeForJs') {
    $content = $content -replace '<%@page', "<%@page
<%!
private String escapeForJs(String input) {
    if (input == null) return " ";
    return input.replace(""", "\\"").replace("\n", "\\n").replace("\r", "");
}
%>"
}

$content | Set-Content apuasc-war/web/Pages/Customer/MyAppointments.jsp
