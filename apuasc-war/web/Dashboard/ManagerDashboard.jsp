<%@page import="java.text.NumberFormat,java.util.Collections,java.util.List,java.util.Locale,models.PaymentRecord,models.PaymentRecordFacade,models.ServiceEntityFacade,models.UsersEntity,models.UsersEntityFacade,utils.EjbLookup"%>
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

    long totalStaff;
    long totalCustomers;
    long managerAccessCount;
    long activeServices;
    long pendingPayments;
    String collectedRevenue;
    List<UsersEntity> staffUsers;
    List<PaymentRecord> recentPayments;

    if (request.getAttribute("totalStaff") != null) {
        totalStaff = (Long) request.getAttribute("totalStaff");
        totalCustomers = (Long) request.getAttribute("totalCustomers");
        managerAccessCount = (Long) request.getAttribute("managerAccessCount");
        activeServices = (Long) request.getAttribute("activeServices");
        pendingPayments = (Long) request.getAttribute("pendingPayments");
        collectedRevenue = (String) request.getAttribute("collectedRevenue");
        staffUsers = (List<UsersEntity>) request.getAttribute("staffUsers");
        recentPayments = (List<PaymentRecord>) request.getAttribute("recentPayments");
    } else {
        UsersEntityFacade userFacade = EjbLookup.lookup(UsersEntityFacade.class, "UsersEntityFacade");
        ServiceEntityFacade serviceFacade = EjbLookup.lookup(ServiceEntityFacade.class, "ServiceEntityFacade");
        PaymentRecordFacade paymentRecordFacade = EjbLookup.lookup(PaymentRecordFacade.class, "PaymentRecordFacade");
        NumberFormat currency = NumberFormat.getCurrencyInstance(new Locale("ms", "MY"));

        totalStaff = userFacade.countNonCustomerUsers();
        totalCustomers = userFacade.countByRole("customer");
        managerAccessCount = userFacade.countManagerAccessUsers();
        activeServices = serviceFacade.countActive();
        pendingPayments = paymentRecordFacade.countByStatus("pending");
        collectedRevenue = currency.format(paymentRecordFacade.sumByStatus("paid"));
        staffUsers = userFacade.findStaffUsers();
        recentPayments = paymentRecordFacade.findAllOrdered();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Manager Dashboard</title>
    <link rel="stylesheet" href="../Styles/main.css">
    <style>
        .mini-grid {
            display: grid;
            grid-template-columns: 1.2fr 0.8fr;
            gap: 24px;
        }

        .panel {
            background: white;
            border-radius: 18px;
            padding: 24px;
            box-shadow: 0 10px 30px rgba(15, 23, 42, 0.06);
        }

        .panel h3 {
            margin: 0 0 8px;
        }

        .panel .sub {
            color: #64748b;
            margin-bottom: 18px;
        }

        .queue-item + .queue-item {
            border-top: 1px solid #e2e8f0;
        }

        .queue-item small {
            color: #64748b;
        }

        .metric-note {
            margin-top: 8px;
            color: #64748b;
            font-size: 13px;
        }

        .payment-line {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 14px 0;
            border-bottom: 1px solid #e2e8f0;
        }

        .payment-line:last-child {
            border-bottom: none;
        }

        .payment-line strong {
            display: block;
        }

        .status-pill {
            display: inline-flex;
            align-items: center;
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

        @media (max-width: 960px) {
            .mini-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
<div class="layout">
    <jsp:include page="../Component/Sidebar.jsp" />

    <div class="main">
        <jsp:include page="../Component/Topbar.jsp">
            <jsp:param name="section" value="MANAGER PANEL" />
        </jsp:include>

        <div class="header-row">
            <div class="header-text">
                <h1>Manager Dashboard</h1>
                <p>Live overview of staff, services, and payment activity from the database.</p>
            </div>
            <div class="actions">
                <button class="btn btn-light" onclick="window.location.href='../Pages/Manager/Reports.jsp'">Open Reports</button>
                <button class="btn btn-primary" onclick="window.location.href='../Pages/Manager/ManageUsers.jsp'">User Directory</button>
            </div>
        </div>

        <div class="cards">
            <div class="card">
                <h2><%= totalStaff %></h2>
                <p>Total Staff</p>
                <div class="metric-note"><%= managerAccessCount %> with manager access enabled</div>
            </div>
            <div class="card">
                <h2><%= totalCustomers %></h2>
                <p>Registered Customers</p>
                <div class="metric-note">Based on current user records</div>
            </div>
            <div class="card">
                <h2><%= activeServices %></h2>
                <p>Active Services</p>
                <div class="metric-note">Managed from service pricing</div>
            </div>
            <div class="card">
                <h2><%= collectedRevenue %></h2>
                <p>Paid Revenue</p>
                <div class="metric-note"><%= pendingPayments %> payment(s) still pending</div>
            </div>
        </div>

        <div class="mini-grid">
            <div class="panel">
                <h3>Staff Directory</h3>
                <div class="sub">Recent staff accounts from the database</div>
                <%
                    int staffShown = 0;
                    for (UsersEntity staff : staffUsers) {
                        if (staffShown >= 6) {
                            break;
                        }
                        staffShown++;
                        boolean staffHasManagerAccess = staff.getHave_Manager_access() != null && staff.getHave_Manager_access() == 1;
                %>
                <div class="queue-item">
                    <div>
                        <strong><%= staff.getName() %></strong><br>
                        <small><%= staff.getEmail() %> | <%= staff.getRole() %></small>
                        <% if (staffHasManagerAccess) { %>
                        <div class="metric-note">Manager access enabled</div>
                        <% } %>
                    </div>
                </div>
                <% } %>
            </div>

            <div class="panel">
                <h3>Recent Payments</h3>
                <div class="sub">Latest payment records entered into the system</div>
                <%
                    int paymentsShown = 0;
                    for (PaymentRecord payment : recentPayments) {
                        if (paymentsShown >= 3) {
                            break;
                        }
                        paymentsShown++;
                        String statusClass = "paid".equalsIgnoreCase(payment.getStatus()) ? "status-paid" : "status-pending";
                %>
                <div class="payment-line">
                    <div>
                        <strong><%= payment.getInvoice_number() %></strong>
                        <small><%= payment.getCustomer_name() %> | <%= payment.getService_name() %></small>
                    </div>
                    <span class="status-pill <%= statusClass %>"><%= payment.getStatus() %></span>
                </div>
                <% } %>
            </div>
        </div>
    </div>
</div>
</body>
</html>
