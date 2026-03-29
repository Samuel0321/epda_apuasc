<%@page import="java.text.NumberFormat,java.util.List,java.util.Locale,models.PaymentRecord,models.PaymentRecordFacade,models.UsersEntity,utils.EjbLookup"%>
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

    NumberFormat currency = NumberFormat.getCurrencyInstance(new Locale("ms", "MY"));
    List<PaymentRecord> payments;
    String paidRevenue;
    String pendingRevenue;
    long paidCount;
    long pendingCount;
    if (request.getAttribute("payments") != null) {
        payments = (List<PaymentRecord>) request.getAttribute("payments");
        paidRevenue = (String) request.getAttribute("paidRevenue");
        pendingRevenue = (String) request.getAttribute("pendingRevenue");
        paidCount = (Long) request.getAttribute("paidCount");
        pendingCount = (Long) request.getAttribute("pendingCount");
    } else {
        PaymentRecordFacade paymentRecordFacade = EjbLookup.lookup(PaymentRecordFacade.class, "PaymentRecordFacade");
        payments = paymentRecordFacade.findAllOrdered();
        paidRevenue = currency.format(paymentRecordFacade.sumByStatus("paid"));
        pendingRevenue = currency.format(paymentRecordFacade.sumByStatus("pending"));
        paidCount = paymentRecordFacade.countByStatus("paid");
        pendingCount = paymentRecordFacade.countByStatus("pending");
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Manager Payments</title>
    <link rel="stylesheet" href="../../Styles/main.css">
    <style>
        .summary-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 18px;
            margin-bottom: 24px;
        }

        .summary-card,
        .table-container,
        .modal-card {
            background: white;
            border-radius: 18px;
            padding: 22px;
            box-shadow: 0 10px 30px rgba(15, 23, 42, 0.06);
        }

        .summary-label {
            color: #64748b;
            font-size: 13px;
            margin-bottom: 10px;
        }

        .summary-value {
            font-size: 30px;
            font-weight: 700;
            color: #0f172a;
        }

        .table-header {
            margin-bottom: 18px;
        }

        .search-box {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #dbe2ea;
            border-radius: 10px;
            box-sizing: border-box;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 14px 12px;
            border-bottom: 1px solid #e2e8f0;
            text-align: left;
        }

        th {
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 0.04em;
            color: #64748b;
        }

        .status-pill {
            display: inline-flex;
            padding: 4px 10px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 600;
        }

        .status-paid {
            background: #dcfce7;
            color: #166534;
        }

        .status-pending {
            background: #fef3c7;
            color: #92400e;
        }

        .btn-small {
            padding: 8px 10px;
            border: none;
            border-radius: 8px;
            font-size: 12px;
            font-weight: 600;
            cursor: pointer;
            background: #dbeafe;
            color: #1d4ed8;
        }

        .modal {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(15, 23, 42, 0.45);
            z-index: 1000;
            padding: 30px 16px;
        }

        .modal.show {
            display: block;
        }

        .modal-card {
            max-width: 680px;
            margin: 0 auto;
        }

        .detail-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 14px;
        }

        .detail-card {
            padding: 14px;
            background: #f8fafc;
            border-radius: 14px;
            border: 1px solid #e2e8f0;
        }

        .detail-card strong {
            display: block;
            margin-bottom: 6px;
        }

        .full-span {
            grid-column: 1 / -1;
        }

        @media (max-width: 1000px) {
            .summary-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 700px) {
            .summary-grid,
            .detail-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
<div class="layout">
    <jsp:include page="../../Component/Sidebar.jsp" />

    <div class="main">
        <jsp:include page="../../Component/Topbar.jsp">
            <jsp:param name="section" value="PAYMENTS" />
        </jsp:include>

        <div class="header-row">
            <div class="header-text">
                <h1>Payments</h1>
                <p>Manager overview of recorded cash payments and receipt history.</p>
            </div>
        </div>

        <div class="summary-grid">
            <div class="summary-card">
                <div class="summary-label">Paid Revenue</div>
                <div class="summary-value"><%= paidRevenue %></div>
            </div>
            <div class="summary-card">
                <div class="summary-label">Pending Revenue</div>
                <div class="summary-value"><%= pendingRevenue %></div>
            </div>
            <div class="summary-card">
                <div class="summary-label">Paid Transactions</div>
                <div class="summary-value"><%= paidCount %></div>
            </div>
            <div class="summary-card">
                <div class="summary-label">Pending Transactions</div>
                <div class="summary-value"><%= pendingCount %></div>
            </div>
        </div>

        <div class="table-container">
            <div class="table-header">
                <input id="paymentSearch" type="text" class="search-box" placeholder="Search by invoice, customer, service, or receipt...">
            </div>

            <table id="paymentTable">
                <thead>
                    <tr>
                        <th>Invoice</th>
                        <th>Customer</th>
                        <th>Service</th>
                        <th>Amount</th>
                        <th>Date</th>
                        <th>Status</th>
                        <th>Receipt</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (PaymentRecord payment : payments) {
                        String statusClass = "paid".equalsIgnoreCase(payment.getStatus()) ? "status-paid" : "status-pending";
                    %>
                    <tr data-invoice="<%= payment.getInvoice_number() %>"
                        data-customer="<%= payment.getCustomer_name() %>"
                        data-service="<%= payment.getService_name() %>"
                        data-amount="<%= currency.format(payment.getAmount()) %>"
                        data-date="<%= payment.getPayment_date() %>"
                        data-status="<%= payment.getStatus() %>"
                        data-receipt="<%= payment.getReceipt_number() %>"
                        data-received-by="<%= payment.getReceived_by() %>">
                        <td><%= payment.getInvoice_number() %></td>
                        <td><%= payment.getCustomer_name() %></td>
                        <td><%= payment.getService_name() %></td>
                        <td><%= currency.format(payment.getAmount()) %></td>
                        <td><%= payment.getPayment_date() %></td>
                        <td><span class="status-pill <%= statusClass %>"><%= payment.getStatus() %></span></td>
                        <td><%= payment.getReceipt_number() %></td>
                        <td><button type="button" class="btn-small" onclick="openPaymentModal(this)">View</button></td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<div id="paymentModal" class="modal">
    <div class="modal-card">
        <div class="header-row" style="margin-bottom: 18px;">
            <div class="header-text">
                <h1 style="font-size: 28px;">Payment Details</h1>
                <p>Recorded payment information</p>
            </div>
            <div class="actions">
                <button type="button" class="btn btn-light" onclick="closePaymentModal()">Close</button>
            </div>
        </div>
        <div class="detail-grid">
            <div class="detail-card"><strong>Invoice</strong><span id="paymentInvoice"></span></div>
            <div class="detail-card"><strong>Receipt</strong><span id="paymentReceipt"></span></div>
            <div class="detail-card"><strong>Customer</strong><span id="paymentCustomer"></span></div>
            <div class="detail-card"><strong>Service</strong><span id="paymentService"></span></div>
            <div class="detail-card"><strong>Amount</strong><span id="paymentAmount"></span></div>
            <div class="detail-card"><strong>Status</strong><span id="paymentStatus"></span></div>
            <div class="detail-card"><strong>Payment Date</strong><span id="paymentDate"></span></div>
            <div class="detail-card"><strong>Received By</strong><span id="paymentReceivedBy"></span></div>
            <div class="detail-card full-span"><strong>Payment Type</strong><span>Cash payment recorded at counter</span></div>
        </div>
    </div>
</div>

<script>
    document.getElementById("paymentSearch").addEventListener("input", function () {
        const keyword = this.value.toLowerCase();
        document.querySelectorAll("#paymentTable tbody tr").forEach(function (row) {
            row.style.display = row.innerText.toLowerCase().includes(keyword) ? "" : "none";
        });
    });

    function openPaymentModal(button) {
        const row = button.closest("tr");
        document.getElementById("paymentInvoice").textContent = row.dataset.invoice || "-";
        document.getElementById("paymentReceipt").textContent = row.dataset.receipt || "-";
        document.getElementById("paymentCustomer").textContent = row.dataset.customer || "-";
        document.getElementById("paymentService").textContent = row.dataset.service || "-";
        document.getElementById("paymentAmount").textContent = row.dataset.amount || "-";
        document.getElementById("paymentStatus").textContent = row.dataset.status || "-";
        document.getElementById("paymentDate").textContent = row.dataset.date || "-";
        document.getElementById("paymentReceivedBy").textContent = row.dataset.receivedBy || "-";
        document.getElementById("paymentModal").classList.add("show");
    }

    function closePaymentModal() {
        document.getElementById("paymentModal").classList.remove("show");
    }

    window.addEventListener("click", function (event) {
        const modal = document.getElementById("paymentModal");
        if (event.target === modal) {
            closePaymentModal();
        }
    });
</script>
</body>
</html>
