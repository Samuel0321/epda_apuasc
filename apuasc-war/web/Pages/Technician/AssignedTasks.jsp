<%@page import="java.time.LocalDate,java.util.ArrayList,java.util.HashMap,java.util.List,java.util.Map,models.AppointmentService,models.AppointmentServiceFacade,models.Appointments,models.AppointmentsFacade,models.ServiceEntity,models.ServiceEntityFacade,models.UsersEntity,models.UsersEntityFacade,utils.EjbLookup"%>
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

    List<Appointments> appointments = appointmentsFacade.findQuotationWorkflowByTechnicianId(currentUser.getId());
    List<ServiceEntity> quotationServices = new ArrayList<>();
    for (ServiceEntity service : serviceFacade.findAllOrdered()) {
        if (service.getActive() != null && service.getActive() == 0) {
            continue;
        }
        String serviceName = service.getService_name() == null ? "" : service.getService_name().trim().toLowerCase();
        if ("minor service".equals(serviceName) || "major service".equals(serviceName)) {
            continue;
        }
        quotationServices.add(service);
    }

    Map<Integer, String> customerNames = new HashMap<>();
    Map<Integer, String> selectedServices = new HashMap<>();
    Map<Integer, String> selectedServiceIds = new HashMap<>();
    long assignedCount = 0;
    long waitingCount = 0;
    long delayedCount = 0;
    long activeWorkCount = 0;
    long todayCount = 0;
    LocalDate today = LocalDate.now();
    for (Appointments appointment : appointments) {
        UsersEntity customer = appointment.getCustomer_id() == null ? null : userFacade.find(appointment.getCustomer_id());
        customerNames.put(appointment.getAppointment_id(), customer == null ? "Customer" : customer.getName());

        List<AppointmentService> links = appointmentServiceFacade.findByAppointmentId(appointment.getAppointment_id());
        List<String> names = new ArrayList<>();
        List<String> ids = new ArrayList<>();
        for (AppointmentService link : links) {
            ServiceEntity service = serviceFacade.find(link.getService_id());
            if (service != null) {
                names.add(service.getService_name());
                ids.add(String.valueOf(service.getId()));
            }
        }
        selectedServices.put(appointment.getAppointment_id(), names.isEmpty() ? "No quoted services yet" : String.join(", ", names));
        selectedServiceIds.put(appointment.getAppointment_id(), ids.isEmpty() ? "" : String.join(",", ids));

        String status = appointment.getStatus() == null ? "" : appointment.getStatus().trim().toUpperCase();
        if ("ASSIGNED".equals(status)) assignedCount++;
        if ("WAITING APPROVAL".equals(status)) waitingCount++;
        if ("DELAYED".equals(status)) delayedCount++;
        if ("ACCEPTED".equals(status) || "DELAYED".equals(status) || "COMPLETED".equals(status) || "UNPAID".equals(status) || "PAID".equals(status)) activeWorkCount++;
        if (today.equals(appointment.getAppointment_date())) todayCount++;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Assigned Tasks</title>
    <link rel="stylesheet" href="../../Styles/main.css">
    <style>
        .summary-cards{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:18px;margin-bottom:20px}
        .summary-card,.task-card,.modal-panel{background:white;border:1px solid #dbe2ea;border-radius:18px;box-shadow:0 10px 28px rgba(15,23,42,.06)}
        .summary-card{padding:18px}
        .summary-label{color:#64748b;font-size:13px;margin-bottom:8px}
        .summary-value{font-size:30px;font-weight:700;color:#0f172a}
        .filters{display:flex;gap:10px;margin-bottom:20px;flex-wrap:wrap}
        .filter-btn{padding:10px 16px;border:1px solid #dbe2ea;background:white;border-radius:10px;cursor:pointer;font-size:14px}
        .filter-btn.active{background:#334155;color:white;border-color:#334155}
        .tasks-container{display:grid;grid-template-columns:repeat(auto-fill,minmax(330px,1fr));gap:20px}
        .task-card.hide{display:none}
        .task-head{padding:18px 20px;border-bottom:1px solid #e2e8f0;background:#f8fafc}
        .task-id{font-size:12px;color:#64748b;margin-bottom:6px}
        .task-title{font-size:26px;font-weight:700;color:#0f172a}
        .task-body{padding:20px;display:flex;flex-direction:column;gap:14px}
        .task-meta{color:#475569;line-height:1.65}
        .status-box,.quote-box,.detail-card{background:#f8fafc;border:1px solid #e2e8f0;border-radius:14px;padding:14px}
        .status-chip{display:inline-flex;align-items:center;padding:6px 12px;border-radius:999px;font-size:12px;font-weight:700;margin-top:10px;background:#e2e8f0;color:#334155}
        .task-actions{display:flex;flex-direction:column;gap:10px;margin-top:auto}
        .task-btn,.modal-actions button{padding:10px 14px;border:none;border-radius:10px;cursor:pointer;font-size:14px;font-weight:600}
        .task-btn{width:100%}
        .btn-primary{background:#334155;color:white}
        .btn-secondary{background:#e2e8f0;color:#0f172a}
        .btn-note{background:#cbd5e1;color:#0f172a}
        .btn-disabled{background:#e5e7eb;color:#64748b;cursor:not-allowed}
        .alert{margin-bottom:18px;padding:12px 14px;border-radius:12px;font-size:14px}
        .alert-success{background:#dcfce7;color:#166534}
        .alert-error{background:#fee2e2;color:#991b1b}
        .empty-state{background:white;border:1px dashed #cbd5e1;border-radius:18px;padding:32px;text-align:center;color:#64748b}
        .modal{display:none;position:fixed;inset:0;background:rgba(15,23,42,.48);z-index:1000;padding:30px 16px;overflow-y:auto}
        .modal.show{display:block}
        .modal-panel{max-width:820px;margin:0 auto;padding:24px}
        .modal-title{font-size:26px;font-weight:700;margin-bottom:8px;color:#0f172a}
        .modal-subtitle{color:#64748b;margin-bottom:18px}
        .detail-grid,.service-checklist{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:14px}
        .detail-card strong{display:block;margin-bottom:6px}
        .full-span{grid-column:1/-1}
        .form-group{display:flex;flex-direction:column;margin-bottom:16px}
        .form-group label{font-weight:600;color:#1e293b;margin-bottom:8px;font-size:14px}
        .form-group textarea{padding:12px;border:1px solid #e2e8f0;border-radius:10px;font-family:'Segoe UI',sans-serif;font-size:14px;resize:vertical;min-height:120px}
        .service-option{border:1px solid #dbe2ea;border-radius:12px;padding:12px;background:#f8fafc}
        .service-option label{display:flex;gap:10px;cursor:pointer}
        .service-meta{font-size:13px;color:#64748b;margin-top:4px}
        .modal-actions{display:flex;gap:10px;justify-content:flex-end;margin-top:20px}
        .date-lock-note{display:inline-flex;align-items:center;padding:6px 12px;border-radius:999px;font-size:12px;font-weight:700;margin-top:10px;background:#e5e7eb;color:#475569}
        @media (max-width:900px){.summary-cards,.detail-grid,.service-checklist{grid-template-columns:1fr}}
    </style>
</head>
<body>
<div class="layout">
    <jsp:include page="../../Component/Sidebar.jsp" />
    <div class="main">
        <jsp:include page="../../Component/Topbar.jsp"><jsp:param name="section" value="ASSIGNED TASKS" /></jsp:include>
        <div class="header-row">
            <div class="header-text">
                <h1>Assigned Tasks</h1>
                <p>Inspect assigned appointments, submit one quotation bundle per appointment, and update service comments after approval or completion.</p>
            </div>
        </div>
        <% if (request.getParameter("quoted") != null) { %><div class="alert alert-success">Quotation submitted successfully. The customer can now accept or reject it.</div>
        <% } else if (request.getParameter("delayed") != null) { %><div class="alert alert-success">Repair marked as delayed. The customer and overlapping later appointments are now flagged for receptionist follow-up.</div>
        <% } else if (request.getParameter("completed") != null) { %><div class="alert alert-success">Repair marked as completed. Reception can now collect payment from the customer.</div>
        <% } else if (request.getParameter("updated") != null) { %><div class="alert alert-success">Technician comment updated successfully.</div>
        <% } else if ("FinishPreviousFirst".equals(request.getParameter("error"))) { %><div class="alert alert-error">Finish the earlier appointment first before preparing quotation for the next one.</div>
        <% } else if (request.getParameter("error") != null) { %><div class="alert alert-error">The requested technician action could not be completed.</div><% } %>
        <div class="summary-cards">
            <div class="summary-card"><div class="summary-label">Today</div><div class="summary-value"><%= todayCount %></div></div>
            <div class="summary-card"><div class="summary-label">Assigned For Inspection</div><div class="summary-value"><%= assignedCount %></div></div>
            <div class="summary-card"><div class="summary-label">Quote Sent To Customer</div><div class="summary-value"><%= waitingCount %></div></div>
            <div class="summary-card"><div class="summary-label">Repair Delayed</div><div class="summary-value"><%= delayedCount %></div></div>
            <div class="summary-card"><div class="summary-label">Repair / Payment Stage</div><div class="summary-value"><%= activeWorkCount %></div></div>
        </div>
        <div class="filters">
            <button class="filter-btn active" type="button" data-filter="all">All</button>
            <button class="filter-btn" type="button" data-filter="today">Today</button>
            <button class="filter-btn" type="button" data-filter="assigned">Assigned</button>
            <button class="filter-btn" type="button" data-filter="waiting_approval">Waiting Approval</button>
            <button class="filter-btn" type="button" data-filter="delayed">Delayed</button>
            <button class="filter-btn" type="button" data-filter="accepted">Accepted</button>
            <button class="filter-btn" type="button" data-filter="rejected">Rejected</button>
            <button class="filter-btn" type="button" data-filter="completed_group">Completed / Payment</button>
        </div>
        <% if (appointments.isEmpty()) { %><div class="empty-state">No technician appointments are assigned to your account yet.</div>
        <% } else { %>
        <div class="tasks-container">
            <% for (Appointments appointment : appointments) {
                String status = appointment.getStatus() == null ? "ASSIGNED" : appointment.getStatus().trim().toUpperCase();
                String filterGroup = status.toLowerCase().replace(' ', '_');
                if ("COMPLETED".equals(status) || "UNPAID".equals(status) || "PAID".equals(status)) filterGroup = "completed_group";
                String bookingNote = appointment.getCustomer_notes() == null || appointment.getCustomer_notes().trim().isEmpty() ? "No booking note provided." : appointment.getCustomer_notes();
                String technicianNote = appointment.getTechnician_notes() == null || appointment.getTechnician_notes().trim().isEmpty() ? "No technician comment added yet." : appointment.getTechnician_notes();
                String statusLabel = displayTechnicianStatus(status);
                boolean isTodayTask = today.equals(appointment.getAppointment_date());
                boolean isFutureTask = appointment.getAppointment_date() != null && appointment.getAppointment_date().isAfter(today);
            %>
            <div class="task-card" data-filter="<%= filterGroup %>" data-is-today="<%= isTodayTask ? "1" : "0" %>">
                <div class="task-head"><div class="task-id">#APT<%= appointment.getAppointment_id() %></div><div class="task-title"><%= customerNames.get(appointment.getAppointment_id()) %></div></div>
                <div class="task-body">
                    <div class="task-meta">Date: <%= appointment.getAppointment_date() %> | <%= appointment.getAppointment_time() %> - <%= appointmentsFacade.estimateAppointmentEndTime(appointment) %><br>Booking Note: <%= bookingNote %><br>Selected Services: <%= selectedServices.get(appointment.getAppointment_id()) %></div>
                    <div class="status-box"><strong>Status: <%= statusLabel %></strong><div class="status-chip"><%= statusLabel %></div><% if (isFutureTask) { %><div class="date-lock-note">Waiting For Inspection Date</div><% } %></div>
                    <div class="quote-box"><strong>Technician Comment</strong><div style="margin-top:6px;"><%= technicianNote %></div><div style="margin-top:10px;font-weight:700;">Total: <%= displayAmount(appointment.getTotal_amount()) %></div></div>
                    <div class="task-actions">
                        <% if ("ASSIGNED".equals(status) && !isFutureTask && !appointmentsFacade.hasEarlierUnfinishedAppointment(currentUser.getId(), appointment)) { %>
                        <button class="task-btn btn-primary" type="button" onclick="openQuotationModal('<%= appointment.getAppointment_id() %>','<%= escapeForJs(customerNames.get(appointment.getAppointment_id())) %>','<%= escapeForJs(bookingNote) %>','<%= escapeForJs(selectedServiceIds.get(appointment.getAppointment_id())) %>')">Prepare Quotation</button>
                        <% } else if ("ASSIGNED".equals(status) && !isFutureTask && appointmentsFacade.hasEarlierUnfinishedAppointment(currentUser.getId(), appointment)) { %>
                        <button class="task-btn btn-disabled" type="button" disabled>Finish Earlier Appointment First</button>
                        <% } else if ("ASSIGNED".equals(status) && isFutureTask) { %>
                        <button class="task-btn btn-disabled" type="button" disabled>Available On <%= appointment.getAppointment_date() %></button>
                        <% } %>
                        <% if (("ACCEPTED".equals(status) || "DELAYED".equals(status)) && !isFutureTask) { %>
                        <form method="post" action="<%= request.getContextPath() %>/TechnicianCommentServlet" style="margin:0;">
                            <input type="hidden" name="action" value="completeRepair">
                            <input type="hidden" name="appointmentId" value="<%= appointment.getAppointment_id() %>">
                            <button class="task-btn btn-primary" type="submit">Mark Repair Completed</button>
                        </form>
                        <button class="task-btn btn-note" type="button" onclick="openDelayModal('<%= appointment.getAppointment_id() %>','<%= escapeForJs(customerNames.get(appointment.getAppointment_id())) %>','<%= escapeForJs(selectedServices.get(appointment.getAppointment_id())) %>')">Mark Delayed</button>
                        <button class="task-btn btn-note" type="button" onclick="openCommentModal('<%= appointment.getAppointment_id() %>','<%= escapeForJs(customerNames.get(appointment.getAppointment_id())) %>','<%= escapeForJs(technicianNote) %>')">Update Work Note</button>
                        <% } else if (("ACCEPTED".equals(status) || "DELAYED".equals(status)) && isFutureTask) { %>
                        <button class="task-btn btn-disabled" type="button" disabled>Work Starts On <%= appointment.getAppointment_date() %></button>
                        <% } %>
                        <% if (("COMPLETED".equals(status) || "UNPAID".equals(status) || "PAID".equals(status)) && !isFutureTask) { %>
                        <button class="task-btn btn-note" type="button" onclick="openCommentModal('<%= appointment.getAppointment_id() %>','<%= escapeForJs(customerNames.get(appointment.getAppointment_id())) %>','<%= escapeForJs(technicianNote) %>')">Update Work Note</button>
                        <% } else if (("COMPLETED".equals(status) || "UNPAID".equals(status) || "PAID".equals(status)) && isFutureTask) { %>
                        <button class="task-btn btn-disabled" type="button" disabled>Work Starts On <%= appointment.getAppointment_date() %></button>
                        <% } %>
                        <button class="task-btn btn-secondary" type="button" onclick="openDetailsModal('#APT<%= appointment.getAppointment_id() %>','<%= escapeForJs(customerNames.get(appointment.getAppointment_id())) %>','<%= appointment.getAppointment_date() %>','<%= appointment.getAppointment_time() %> - <%= appointmentsFacade.estimateAppointmentEndTime(appointment) %>','<%= escapeForJs(statusLabel) %>','<%= escapeForJs(bookingNote) %>','<%= escapeForJs(selectedServices.get(appointment.getAppointment_id())) %>','<%= escapeForJs(displayAmount(appointment.getTotal_amount())) %>','<%= escapeForJs(technicianNote) %>')">View Details</button>
                    </div>
                </div>
            </div>
            <% } %>
        </div>
        <% } %>
    </div>
</div>

<div id="quotationModal" class="modal"><div class="modal-panel"><div class="modal-title">Prepare Quotation</div><div class="modal-subtitle">Choose one or many services for this single appointment after inspection.</div><form method="post" action="<%= request.getContextPath() %>/TechnicianQuotationServlet"><input type="hidden" name="appointmentId" id="quotationAppointmentId"><div class="detail-grid"><div class="detail-card"><strong>Customer</strong><span id="quotationCustomer"></span></div><div class="detail-card"><strong>Booking Note</strong><span id="quotationBookingNote"></span></div></div><div class="form-group" style="margin-top:16px;"><label>Select Services Needed *</label><div class="service-checklist"><% for (ServiceEntity service : quotationServices) { %><div class="service-option"><label><input type="checkbox" name="serviceIds" value="<%= service.getId() %>"><span><strong><%= service.getService_name() %></strong><div class="service-meta">RM <%= service.getPrice() %></div></span></label></div><% } %></div></div><div class="form-group"><label for="technicianNotes">Inspection / Quotation Notes *</label><textarea id="technicianNotes" name="technicianNotes" required></textarea></div><div class="modal-actions"><button type="button" class="btn-secondary" onclick="closeQuotationModal()">Cancel</button><button type="submit" class="btn-primary">Submit Quotation</button></div></form></div></div>
<div id="delayModal" class="modal"><div class="modal-panel"><div class="modal-title">Mark Repair Delayed</div><div class="modal-subtitle" id="delayModalSubtitle">Add extra time needed so the system can protect the technician schedule and warn later customers.</div><form method="post" action="<%= request.getContextPath() %>/TechnicianCommentServlet"><input type="hidden" name="action" value="delayRepair"><input type="hidden" name="appointmentId" id="delayAppointmentId"><div class="detail-grid"><div class="detail-card"><strong>Customer</strong><span id="delayCustomer"></span></div><div class="detail-card"><strong>Service Bundle</strong><span id="delayServices"></span></div></div><div class="form-group" style="margin-top:16px;"><label for="extraHours">Extra Hours Needed *</label><select id="extraHours" name="extraHours" required><option value="">Select extra time</option><option value="1">1 hour</option><option value="2">2 hours</option><option value="3">3 hours</option><option value="4">4 hours</option><option value="5">5 hours</option><option value="6">6 hours</option></select></div><div class="form-group"><label for="delayReason">Delay Reason / Technician Update *</label><textarea id="delayReason" name="delayReason" required></textarea></div><div class="modal-actions"><button type="button" class="btn-secondary" onclick="closeDelayModal()">Cancel</button><button type="submit" class="btn-primary">Save Delay</button></div></form></div></div>
<div id="commentModal" class="modal"><div class="modal-panel"><div class="modal-title">Technician Work Note</div><div class="modal-subtitle">Update the repair progress, completion summary, or final service note for this appointment.</div><form method="post" action="<%= request.getContextPath() %>/TechnicianCommentServlet"><input type="hidden" name="appointmentId" id="commentAppointmentId"><div class="detail-grid"><div class="detail-card"><strong>Customer</strong><span id="commentCustomer"></span></div></div><div class="form-group" style="margin-top:16px;"><label for="commentNotes">Technician Notes *</label><textarea id="commentNotes" name="technicianNotes" required></textarea></div><div class="modal-actions"><button type="button" class="btn-secondary" onclick="closeCommentModal()">Cancel</button><button type="submit" class="btn-primary">Save Note</button></div></form></div></div>
<div id="detailsModal" class="modal"><div class="modal-panel"><div class="modal-title">Appointment Details</div><div class="modal-subtitle">One appointment can contain multiple quoted services. They are listed below as the single quotation bundle shown to the customer.</div><div class="detail-grid"><div class="detail-card"><strong>Appointment</strong><span id="detailsAppointment"></span></div><div class="detail-card"><strong>Customer</strong><span id="detailsCustomer"></span></div><div class="detail-card"><strong>Date & Time</strong><span id="detailsDateTime"></span></div><div class="detail-card"><strong>Status</strong><span id="detailsStatus"></span></div><div class="detail-card full-span"><strong>Booking Note</strong><span id="detailsBooking"></span></div><div class="detail-card full-span"><strong>Selected Services</strong><span id="detailsServices"></span></div><div class="detail-card"><strong>Total Amount</strong><span id="detailsTotal"></span></div><div class="detail-card full-span"><strong>Technician Comment</strong><span id="detailsNote"></span></div></div><div class="modal-actions"><button type="button" class="btn-secondary" onclick="closeDetailsModal()">Close</button></div></div></div>

<script>
const filterButtons=document.querySelectorAll(".filter-btn"),taskCards=document.querySelectorAll(".task-card");
filterButtons.forEach(function(button){button.addEventListener("click",function(){filterButtons.forEach(function(item){item.classList.remove("active")});button.classList.add("active");const filter=button.dataset.filter;taskCards.forEach(function(card){const matchesStatus=(filter==="all"||filter==="today"||card.dataset.filter===filter);const matchesToday=(filter!=="today"||card.dataset.isToday==="1");card.classList.toggle("hide",!(matchesStatus&&matchesToday))})})});
function openQuotationModal(appointmentId,customerName,bookingNote,selectedIdsCsv){document.getElementById("quotationAppointmentId").value=appointmentId;document.getElementById("quotationCustomer").textContent=customerName||"-";document.getElementById("quotationBookingNote").textContent=bookingNote||"-";document.getElementById("technicianNotes").value="";const selectedIds=selectedIdsCsv?selectedIdsCsv.split(","):[];document.querySelectorAll('input[name="serviceIds"]').forEach(function(checkbox){checkbox.checked=selectedIds.indexOf(checkbox.value)!==-1});document.getElementById("quotationModal").classList.add("show")}
function closeQuotationModal(){document.getElementById("quotationModal").classList.remove("show")}
function openDelayModal(appointmentId,customerName,services){document.getElementById("delayAppointmentId").value=appointmentId;document.getElementById("delayCustomer").textContent=customerName||"-";document.getElementById("delayServices").textContent=services||"-";document.getElementById("extraHours").value="";document.getElementById("delayReason").value="";document.getElementById("delayModal").classList.add("show")}
function closeDelayModal(){document.getElementById("delayModal").classList.remove("show")}
function openCommentModal(appointmentId,customerName,technicianNote){document.getElementById("commentAppointmentId").value=appointmentId;document.getElementById("commentCustomer").textContent=customerName||"-";document.getElementById("commentNotes").value=technicianNote==="No technician comment added yet."?"":technicianNote;document.getElementById("commentModal").classList.add("show")}
function closeCommentModal(){document.getElementById("commentModal").classList.remove("show")}
function openDetailsModal(appointmentId,customerName,date,time,status,bookingNote,services,total,technicianNote){document.getElementById("detailsAppointment").textContent=appointmentId;document.getElementById("detailsCustomer").textContent=customerName||"-";document.getElementById("detailsDateTime").textContent=date+" | "+time;document.getElementById("detailsStatus").textContent=status||"-";document.getElementById("detailsBooking").textContent=bookingNote||"-";document.getElementById("detailsServices").textContent=services||"-";document.getElementById("detailsTotal").textContent=total||"To be assessed by technician";document.getElementById("detailsNote").textContent=technicianNote||"-";document.getElementById("detailsModal").classList.add("show")}
function closeDetailsModal(){document.getElementById("detailsModal").classList.remove("show")}
window.addEventListener("click",function(event){document.querySelectorAll(".modal").forEach(function(modal){if(event.target===modal){modal.classList.remove("show")}})});
</script>
</body>
</html>
<%!
    private String escapeForJs(String value) {
        if (value == null) return "";
        return value.replace("\\", "\\\\").replace("'", "\\'").replace("\"", "&quot;").replace("\r", " ").replace("\n", " ");
    }

    private String displayAmount(java.math.BigDecimal amount) {
        if (amount == null || amount.compareTo(java.math.BigDecimal.ZERO) <= 0) {
            return "To be assessed by technician";
        }
        return "RM " + amount;
    }

    private String displayTechnicianStatus(String status) {
        if (status == null) return "-";
        switch (status) {
            case "ASSIGNED": return "Assigned For Inspection";
            case "WAITING APPROVAL": return "Quote Sent To Customer";
            case "ACCEPTED": return "Accepted, Ready To Repair";
            case "DELAYED": return "Repair Delayed";
            case "COMPLETED": return "Repair Completed";
            case "UNPAID": return "Waiting For Payment";
            case "PAID": return "Paid And Closed";
            default: return status;
        }
    }
%>
