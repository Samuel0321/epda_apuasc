<%@page import="java.util.ArrayList,java.util.Arrays,java.util.HashMap,java.util.List,java.util.Map,models.AppointmentService,models.AppointmentServiceFacade,models.Appointments,models.AppointmentsFacade,models.ServiceEntity,models.ServiceEntityFacade,models.UsersEntity,models.UsersEntityFacade,utils.EjbLookup"%>
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

    List<Appointments> appointments = appointmentsFacade.findByCustomerId(currentUser.getId());
    List<String> attentionStatuses = Arrays.asList("WAITING APPROVAL", "UNPAID", "REJECTED", "DELAYED");
    List<String> pendingPaymentStatuses = Arrays.asList("UNPAID");

    Map<Integer, String> serviceNames = new HashMap<>();
    Map<Integer, String> technicianNames = new HashMap<>();
    long attentionCount = 0;
    long pendingPaymentCount = 0;

    for (Appointments appointment : appointments) {
        List<AppointmentService> links = appointmentServiceFacade.findByAppointmentId(appointment.getAppointment_id());
        List<String> names = new ArrayList<>();
        for (AppointmentService link : links) {
            ServiceEntity service = serviceFacade.find(link.getService_id());
            if (service != null) {
                names.add(service.getService_name());
            }
        }
        serviceNames.put(appointment.getAppointment_id(),
                names.isEmpty() ? appointmentsFacade.getBookingTypeLabel(appointment.getCounter_staff_comment()) : String.join(", ", names));

        UsersEntity technician = appointment.getTechnician_id() == null ? null : userFacade.find(appointment.getTechnician_id());
        technicianNames.put(appointment.getAppointment_id(), technician == null ? "Pending assignment" : technician.getName());

        String status = appointment.getStatus() == null ? "" : appointment.getStatus().trim().toUpperCase();
        if (attentionStatuses.contains(status)) {
            attentionCount++;
        }
        if (pendingPaymentStatuses.contains(status)) {
            pendingPaymentCount++;
        }
    }

    String successMessage = null;
    if (request.getParameter("booked") != null) {
        successMessage = "Appointment saved successfully.";
    } else if (request.getParameter("updated") != null) {
        successMessage = "Your quotation decision was saved successfully.";
    } else if (request.getParameter("feedbackSaved") != null) {
        successMessage = "Thank you. Your feedback was saved successfully.";
    } else if (request.getParameter("cancelled") != null) {
        successMessage = "Appointment cancelled successfully.";
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>My Appointments</title>
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
        .task-head{padding:18px 20px;border-bottom:1px solid #e2e8f0;background:#f8fafc;display:flex;justify-content:space-between;align-items:center;}
        .task-id{font-size:14px;color:#64748b;font-weight:600;}
        .task-title{font-size:20px;font-weight:700;color:#0f172a}
        .task-body{padding:20px;display:flex;flex-direction:column;gap:14px}    
        .task-meta{color:#475569;line-height:1.65;font-size:14px}
        .status-box,.quote-box,.detail-card{background:#f8fafc;border:1px solid #e2e8f0;border-radius:14px;padding:14px;font-size:14px;}
        .status-chip{display:inline-flex;align-items:center;padding:6px 12px;border-radius:999px;font-size:12px;font-weight:700;margin-top:10px;background:#e2e8f0;color:#334155}
        .task-actions{display:flex;flex-direction:column;gap:10px;margin-top:auto}
        .task-btn,.modal-actions button{padding:10px 14px;border:none;border-radius:10px;cursor:pointer;font-size:14px;font-weight:600}
        .task-btn{width:100%}
        .btn-primary{background:#2563eb;color:white}
        .btn-secondary{background:#e2e8f0;color:#0f172a}
        .btn-note{background:#cbd5e1;color:#0f172a}
        .btn-disabled{background:#e5e7eb;color:#64748b;cursor:not-allowed}      
        .alert{margin-bottom:18px;padding:12px 14px;border-radius:12px;font-size:14px}
        .alert-success{background:#dcfce7;color:#166534}
        .alert-error{background:#fee2e2;color:#991b1b}
        .empty-state{background:white;border:1px dashed #cbd5e1;border-radius:18px;padding:32px;text-align:center;color:#64748b}
        .modal{display:none;position:fixed;inset:0;background:rgba(15,23,42,.48);z-index:1000;padding:30px 16px;overflow-y:auto}
        .modal.show{display:block}
        .modal-panel{max-width:820px;margin:0 auto;padding:24px;background:white;border-radius:20px;}
        .modal-title{font-size:26px;font-weight:700;margin-bottom:8px;color:#0f172a}
        .modal-subtitle{color:#64748b;margin-bottom:18px}
        .detail-grid,.service-checklist{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:14px}
        .detail-card strong{display:block;margin-bottom:6px}
        .full-span{grid-column:1/-1}
        .modal-actions{display:flex;gap:10px;justify-content:flex-end;margin-top:20px}
        @media (max-width:900px){.summary-cards,.detail-grid,.service-checklist{grid-template-columns:1fr}}
    </style>
</head>
<body>
<div class="layout">
    <jsp:include page="../../Component/Sidebar.jsp" />
    <div class="main">
        <jsp:include page="../../Component/Topbar.jsp">
            <jsp:param name="section" value="MY APPOINTMENTS" />
        </jsp:include>

        <div class="header-row"><div class="header-text"><h1>My Appointments</h1><p>View and manage all your appointments.</p></div><div class="actions"><button class="btn btn-primary" onclick="window.location.href='../../Pages/Customer/BookAppointment.jsp'">+ Book Appointment</button></div></div>        <% if (successMessage != null) { %>
            <div class="alert alert-success"><%= successMessage %></div>
        <% } %>
        <% if ("FeedbackRequired".equals(request.getParameter("error"))) { %>
            <div class="alert alert-error">Please enter your feedback before saving.</div>
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
            <button class="filter-btn" data-filter="delayed">Delayed</button>
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
                    if ("DELAYED".equals(status)) { filterClass = "delayed"; }
                    if ("COMPLETED".equals(status) || "PAID".equals(status) || "UNPAID".equals(status) || "REJECTED".equals(status) || "CANCELLED".equals(status)) { filterClass = "completed_group"; }
                    
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
                            <strong>Time:</strong> <%= apt.getAppointment_time() %> - <%= appointmentsFacade.estimateAppointmentEndTime(apt) %><br>
                            <strong>Services:</strong> <%= aptServices %><br>
                            <strong>Technician:</strong> <%= tName %>
                        </div>
                        
                        <div class="status-box">
                            <strong>Status</strong>
                            <div class="status-chip"><%= displayCustomerStatus(status) %></div>
                        </div>

                        <div class="quote-box">
                            <strong>Amount</strong>
                            <div style="font-weight:700;margin-top:6px;"><%= displayAmount(apt.getTotal_amount()) %></div>
                            <% if ("DELAYED".equals(status)) { %>
                                <div style="margin-top:10px;color:#b45309;"><%= appointmentsFacade.stripSchedulingMetadata(apt.getCounter_staff_comment()) %></div>
                            <% } %>
                            <% if ("COMPLETED".equals(status) || "UNPAID".equals(status)) { %>
                                <div style="margin-top:10px;color:#92400e;">Please find receptionist at the counter for payment.</div>
                            <% } else if ("PAID".equals(status) && (apt.getCustomer_feedback() == null || apt.getCustomer_feedback().trim().isEmpty())) { %>
                                <div style="margin-top:10px;color:#166534;">Payment received. You can now share your service feedback.</div>
                            <% } %>
                        </div>

                        <div class="task-actions">
                            <% if ("WAITING APPROVAL".equals(status)) { %>
                                <div style="display:flex;gap:10px;width:100%">
                                    <form action="<%= request.getContextPath() %>/CustomerAppointmentActionServlet" method="POST" style="flex:1;margin:0;">
                                        <input type="hidden" name="action" value="ACCEPT">
                                        <input type="hidden" name="appointmentId" value="<%= apt.getAppointment_id() %>">
                                        <button type="submit" class="task-btn btn-primary" style="width:100%">Accept</button>
                                    </form>
                                    <form action="<%= request.getContextPath() %>/CustomerAppointmentActionServlet" method="POST" style="flex:1;margin:0;">
                                        <input type="hidden" name="action" value="REJECT">
                                        <input type="hidden" name="appointmentId" value="<%= apt.getAppointment_id() %>">
                                        <button type="submit" class="task-btn" style="width:100%; background:#ef4444; color:white;">Reject</button>
                                    </form>
                                </div>
                            <% } %>
                            <% if ("UNPAID".equals(status)) { %>
                                <div class="status-box" style="color:#92400e;">Please find receptionist at the counter for payment.</div>
                            <% } %>
                            <% if ("COMPLETED".equals(status)) { %>
                                <div class="status-box" style="color:#92400e;">Repair is completed. Please find receptionist at the counter for payment.</div>
                            <% } %>
                            <% if ("PAID".equals(status) && (apt.getCustomer_feedback() == null || apt.getCustomer_feedback().trim().isEmpty())) { %>
                                <button class="task-btn btn-primary" type="button" onclick="openFeedbackModal('<%= apt.getAppointment_id() %>', '<%= escapeForJs(aptServices) %>')">Provide Feedback</button>
                            <% } %>
                            <% if (appointmentsFacade.canCancel(apt)) { %>
                                <form action="<%= request.getContextPath() %>/AppointmentCancellationServlet" method="POST" style="margin:0;">
                                    <input type="hidden" name="appointmentId" value="<%= apt.getAppointment_id() %>">
                                    <button type="submit" class="task-btn" style="background:#ef4444;color:white;">Cancel Appointment</button>
                                </form>
                            <% } %>
                            <button class="task-btn btn-secondary" type="button" onclick="openAppointmentModal('#APT<%= String.format("%03d", apt.getAppointment_id()) %>', '<%= apt.getAppointment_date() %>', '<%= apt.getAppointment_time() %> - <%= appointmentsFacade.estimateAppointmentEndTime(apt) %>', '<%= escapeForJs(aptServices) %>', '<%= escapeForJs(tName) %>', '<%= escapeForJs(displayCustomerStatus(status)) %>', '<%= escapeForJs(displayAmount(apt.getTotal_amount())) %>', '<%= escapeForJs(apt.getCustomer_notes()) %>', '<%= escapeForJs(appointmentsFacade.stripSchedulingMetadata(apt.getCounter_staff_comment())) %>', '<%= escapeForJs(apt.getTechnician_notes()) %>', '<%= escapeForJs(apt.getCustomer_feedback()) %>')">View Details</button>
                        </div>
                    </div>
                </div>
                <% } %>
            </div>
        <% } %>

<div id="appointmentModal" class="modal">
    <div class="modal-panel">
        <div class="modal-title">Appointment Details</div>
        <div class="modal-subtitle" id="modalAppointmentId"></div>
        <div class="detail-grid">
            <div class="detail-card"><strong>Date &amp; Time</strong><div id="modalDateTime"></div></div>
            <div class="detail-card"><strong>Status</strong><div id="modalStatus"></div></div>
            <div class="detail-card full-span"><strong>Services</strong><div id="modalService"></div></div>
            <div class="detail-card"><strong>Technician</strong><div id="modalTechnician"></div></div>
            <div class="detail-card"><strong>Total Amount</strong><div id="modalTotal"></div></div>
            <div class="detail-card full-span"><strong>Customer Notes</strong><div id="modalCustomerNote"></div></div>
            <div class="detail-card full-span"><strong>Tech Notes</strong><div id="modalTechnicianNote"></div></div>
            <div class="detail-card full-span"><strong>Staff Comments</strong><div id="modalStaffComment"></div></div>
            <div class="detail-card full-span"><strong>Feedback</strong><div id="modalFeedback"></div></div>
        </div>
        <div class="modal-actions">
            <button class="btn-secondary" onclick="closeAppointmentModal()">Close</button>
        </div>
    </div>
</div>

<div id="feedbackModal" class="modal">
    <div class="modal-panel">
        <div class="modal-title">Share Feedback</div>
        <div class="modal-subtitle" id="feedbackModalSubtitle"></div>
        <form method="post" action="<%= request.getContextPath() %>/CustomerAppointmentActionServlet">
            <input type="hidden" name="action" value="SAVE_FEEDBACK">
            <input type="hidden" name="appointmentId" id="feedbackAppointmentId">
            <div class="detail-card full-span">
                <strong>Your Feedback</strong>
                <textarea id="feedbackText" name="feedback" rows="5" style="width:100%;margin-top:10px;padding:12px;border:1px solid #dbe2ea;border-radius:12px;font-family:'Segoe UI',sans-serif;font-size:14px;" required placeholder="Tell us about the repair quality, technician service, and your overall experience..."></textarea>
            </div>
            <div class="modal-actions">
                <button type="button" class="btn-secondary" onclick="closeFeedbackModal()">Cancel</button>
                <button type="submit" class="btn-primary">Save Feedback</button>
            </div>
        </form>
    </div>
</div>

<script>
    const filterButtons = document.querySelectorAll(".filter-btn");
    const appointmentCards = document.querySelectorAll(".task-card");

    filterButtons.forEach(function (button) {
        button.addEventListener("click", function () {
            filterButtons.forEach(function (item) {
                item.classList.remove("active");
            });
            button.classList.add("active");

            const filter = button.dataset.filter;
            appointmentCards.forEach(function (card) {
                const cardFilter = card.dataset.filter;
                card.classList.toggle("hide", !(filter === "all" || cardFilter === filter));
            });
        });
    });

    function openAppointmentModal(id, date, time, service, technician, status, total, customerNote, staffComment, technicianNote, feedback) {
        document.getElementById("modalAppointmentId").textContent = id || "-";
        document.getElementById("modalDateTime").textContent = date + " | " + time;
        document.getElementById("modalService").textContent = service || "-";
        document.getElementById("modalTechnician").textContent = technician || "-";
        document.getElementById("modalStatus").textContent = status || "-";
        document.getElementById("modalTotal").textContent = total || "To be assessed by technician";
        document.getElementById("modalCustomerNote").textContent = customerNote || "-";
        document.getElementById("modalStaffComment").textContent = staffComment || "-";
        document.getElementById("modalTechnicianNote").textContent = technicianNote || "-";
        document.getElementById("modalFeedback").textContent = feedback || "-";
        document.getElementById("appointmentModal").classList.add("show");
    }

    function openFeedbackModal(appointmentId, services) {
        document.getElementById("feedbackAppointmentId").value = appointmentId;
        document.getElementById("feedbackModalSubtitle").textContent = services || "Completed service";
        document.getElementById("feedbackText").value = "";
        document.getElementById("feedbackModal").classList.add("show");
    }

    function closeAppointmentModal() {
        document.getElementById("appointmentModal").classList.remove("show");
    }

    function closeFeedbackModal() {
        document.getElementById("feedbackModal").classList.remove("show");
    }

    window.addEventListener("click", function (event) {
        const modal = document.getElementById("appointmentModal");
        if (event.target === modal) {
            closeAppointmentModal();
        }
        const feedbackModal = document.getElementById("feedbackModal");
        if (event.target === feedbackModal) {
            closeFeedbackModal();
        }
    });
</script>
</body>
</html>
<%!
    private String escapeForJs(String value) {
        if (value == null) {
            return "";
        }
        return value.replace("\\", "\\\\")
                .replace("'", "\\'")
                .replace("\"", "&quot;")
                .replace("\r", " ")
                .replace("\n", " ");
    }

    private String displayAmount(java.math.BigDecimal amount) {
        if (amount == null || amount.compareTo(java.math.BigDecimal.ZERO) <= 0) {
            return "To be assessed by technician";
        }
        return "RM " + amount;
    }

    private String displayCustomerStatus(String status) {
        if (status == null) {
            return "-";
        }
        String normalized = status.trim().toUpperCase();
        switch (normalized) {
            case "PENDING": return "Pending Review";
            case "ASSIGNED": return "Inspection Assigned";
            case "WAITING APPROVAL": return "Quotation Ready";
            case "ACCEPTED": return "Repair In Progress";
            case "DELAYED": return "Repair Delayed";
            case "COMPLETED": return "Find Receptionist For Payment";
            case "UNPAID": return "Find Receptionist For Payment";
            case "PAID": return "Paid";
            case "CANCELLED": return "Cancelled";
            case "REJECTED": return "Quotation Rejected";
            default: return normalized;
        }
    }
%>

