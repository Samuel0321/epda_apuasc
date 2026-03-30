<%@page contentType="text/html" pageEncoding="UTF-8"%>
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

    List<Appointments> paymentHistory = appointmentsFacade.findByCustomerIdAndStatuses(currentUser.getId(), Arrays.asList("UNPAID", "PAID"));
    Map<Integer, String> serviceNames = new HashMap<>();
    BigDecimal totalPaid = BigDecimal.ZERO;
    BigDecimal outstanding = BigDecimal.ZERO;
    for (Appointments appointment : paymentHistory) {
        List<AppointmentService> links = appointmentServiceFacade.findByAppointmentId(appointment.getAppointment_id());
        List<String> names = new ArrayList<>();
        for (AppointmentService link : links) {
            ServiceEntity service = serviceFacade.find(link.getService_id());
            if (service != null) {
                names.add(service.getService_name());
            }
        }
        serviceNames.put(appointment.getAppointment_id(), names.isEmpty() ? "Service Request" : String.join(", ", names));
        if ("PAID".equalsIgnoreCase(appointment.getStatus()) && appointment.getTotal_amount() != null) {
            totalPaid = totalPaid.add(appointment.getTotal_amount());
        } else if ("UNPAID".equalsIgnoreCase(appointment.getStatus()) && appointment.getTotal_amount() != null) {
            outstanding = outstanding.add(appointment.getTotal_amount());
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Payment History</title>
    <link rel="stylesheet" href="../../Styles/main.css">
    <style>
        .table-container {
            background: white;
            padding: 22px;
            border-radius: 18px;
            box-shadow: 0 10px 30px rgba(15,23,42,0.06);
        }

        .table-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            gap: 10px;
            flex-wrap: wrap;
        }

        .search-box {
            flex: 1;
            min-width: 220px;
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
            vertical-align: top;
        }

        table tbody tr:hover {
            background: #f8fafc;
        }

        .summary-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 20px;
        }

        .summary-card { background: white; padding: 18px; border-radius: 18px; box-shadow: 0 10px 30px rgba(15,23,42,0.06); }

        .summary-label {
            font-size: 12px;
            color: #64748b;
            margin-bottom: 5px;
        }

        .summary-value {
            font-size: 24px;
            font-weight: 700;
            color: #1e293b;
        }

        .badge {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 500;
        }

        .badge-paid {
            background: #bbf7d0;
            color: #166534;
        }

        .badge-pending {
            background: #fef08a;
            color: #854d0e;
        }

        .amount {
            font-weight: 600;
            color: #1e293b;
        }

        .payment-note {
            color: #475569;
            font-size: 13px;
            line-height: 1.5;
        }

        .empty-state {
            padding: 22px;
            border: 1px dashed #cbd5e1;
            border-radius: 14px;
            color: #64748b;
            text-align: center;
        }

        .action-buttons {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }

        .btn-small {
            padding: 6px 10px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 12px;
            font-weight: 500;
        }

        .btn-view {
            background: #dbeafe;
            color: #1e40af;
        }

        .btn-service {
            background: #e5e7eb;
            color: #1e293b;
        }

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
            padding: 24px;
            border-radius: 12px;
            width: 90%;
            max-width: 680px;
            max-height: 85vh;
            overflow-y: auto;
        }

        .modal-grid {
            display: grid;
            gap: 12px;
        }

        .modal-block {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 10px;
            padding: 14px;
        }

        .modal-block strong {
            display: block;
            color: #1e293b;
            margin-bottom: 6px;
        }

        .modal-actions {
            display: flex;
            justify-content: flex-end;
            margin-top: 18px;
        }

        .btn-close-modal {
            padding: 10px 16px;
            border: none;
            background: #e2e8f0;
            color: #1e293b;
            border-radius: 6px;
            cursor: pointer;
        }
    </style>
</head>
<body>

<div class="layout">
    <jsp:include page="../../Component/Sidebar.jsp" />

    <div class="main">
        <jsp:include page="../../Component/Topbar.jsp">
            <jsp:param name="section" value="PAYMENT HISTORY" />
        </jsp:include>

        <div class="header-row">
            <div class="header-text">
                <h1>Payment History</h1>
                <p>Review cash payments and pending amounts confirmed by the receptionist.</p>
            </div>
            <div class="actions">
                <button class="btn btn-primary" onclick="window.location.href='../../Pages/Customer/ServiceHistory.jsp'">Service History</button>
            </div>
        </div>

        <div class="summary-cards">
            <div class="summary-card"><div class="summary-label">Total Transactions</div><div class="summary-value"><%= paymentHistory.size() %></div></div>
            <div class="summary-card"><div class="summary-label">Amount Paid</div><div class="summary-value">RM <%= totalPaid %></div></div>
            <div class="summary-card"><div class="summary-label">Outstanding</div><div class="summary-value">RM <%= outstanding %></div></div>
        </div>

        <div class="table-container">
            <div class="table-header">
                <input id="paymentSearch" type="text" class="search-box" placeholder="Search payment history by invoice, service, or status...">
            </div>
            <% if (paymentHistory.isEmpty()) { %>
                <div class="empty-state">No paid or unpaid appointment records are available yet.</div>
            <% } else { %>
            <table id="paymentTable">
                <thead>
                    <tr>
                        <th>Invoice #</th>
                        <th>Date</th>
                        <th>Service</th>
                        <th>Amount</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Appointments appointment : paymentHistory) { %>
                    <tr data-id="<%= appointment.getAppointment_id() %>"
                        data-date="<%= appointment.getAppointment_date() %>"
                        data-service="<%= serviceNames.get(appointment.getAppointment_id()) %>"
                        data-total="<%= appointment.getTotal_amount() %>"
                        data-status="<%= appointment.getStatus() %>"
                        data-notes="<%= appointment.getCounter_staff_comment() == null || appointment.getCounter_staff_comment().trim().isEmpty() ? "Receptionist will confirm this cash payment at the counter." : appointment.getCounter_staff_comment() %>">
                        <td>#INV-APT<%= appointment.getAppointment_id() %></td>
                        <td><%= appointment.getAppointment_date() %></td>
                        <td><%= serviceNames.get(appointment.getAppointment_id()) %></td>
                        <td class="amount">RM <%= appointment.getTotal_amount() %></td>
                        <td>
                            <span class="badge <%= "PAID".equalsIgnoreCase(appointment.getStatus()) ? "badge-paid" : "badge-pending" %>">
                                <%= appointment.getStatus() %>
                            </span>
                        </td>
                        <td>
                            <div class="action-buttons">
                                <button class="btn-small btn-view" type="button" onclick="openPaymentDetails(this)">Details</button>
                                <button class="btn-small btn-service" type="button" onclick="downloadInvoice('<%= appointment.getAppointment_id() %>')">Invoice</button>
                            </div>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
            <% } %>
        </div>
    </div>
</div>

<div id="paymentModal" class="modal">
    <div class="modal-content">
        <h3 id="paymentModalTitle">Payment Details</h3>
        <div id="paymentModalBody" class="modal-grid"></div>
        <div class="modal-actions">
            <button class="btn-close-modal" onclick="closePaymentModal()">Close</button>
        </div>
    </div>
</div>

<script>
    const paymentSearch = document.getElementById("paymentSearch");
    if (paymentSearch) {
        paymentSearch.addEventListener("input", function () {
            const keyword = this.value.toLowerCase();
            document.querySelectorAll("#paymentTable tbody tr").forEach(function (row) {
                row.style.display = row.innerText.toLowerCase().includes(keyword) ? "" : "none";
            });
        });
    }

    function openPaymentDetails(button) {
        const row = button.closest("tr");
        const invoiceNumber = "INV-APT" + (row.dataset.id || "-");
        document.getElementById("paymentModalTitle").textContent = "Invoice #" + invoiceNumber;
        document.getElementById("paymentModalBody").innerHTML =
            '<div class="modal-block"><strong>Appointment</strong><div>#APT' + (row.dataset.id || "-") + '</div></div>' +
            '<div class="modal-block"><strong>Date</strong><div>' + (row.dataset.date || '-') + '</div></div>' +
            '<div class="modal-block"><strong>Amount</strong><div>RM ' + (row.dataset.total || '0.00') + '</div></div>' +
            '<div class="modal-block"><strong>Status</strong><div>' + (row.dataset.status || '-') + '</div></div>' +
            '<div class="modal-block"><strong>Payment Type</strong><div>Cash payment at counter</div></div>' +
            '<div class="modal-block"><strong>Payment Approval</strong><div>Receptionist updates the payment status</div></div>' +
            '<div class="modal-block"><strong>Linked Service</strong><div>' + (row.dataset.service || '-') + '</div></div>' +
            '<div class="modal-block"><strong>Receptionist Note</strong><div>' + (row.dataset.notes || '-') + '</div></div>';

        document.getElementById("paymentModal").classList.add("show");
    }

    function closePaymentModal() {
        document.getElementById("paymentModal").classList.remove("show");
    }

    function downloadInvoice(appointmentId) {
        window.location.href = '<%= request.getContextPath() %>/CustomerInvoiceDownloadServlet?appointmentId=' + encodeURIComponent(appointmentId);
    }

    window.onclick = function(event) {
        const modal = document.getElementById("paymentModal");
        if (event.target === modal) {
            closePaymentModal();
        }
    };
</script>

</body>
</html>
