<%@page import="java.text.NumberFormat,java.util.List,java.util.Locale,models.PaymentRecord,models.PaymentRecordFacade,models.ServiceEntity,models.ServiceEntityFacade,models.UsersEntity,models.UsersEntityFacade,utils.EjbLookup"%>
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
    long totalStaff;
    long totalCustomers;
    long activeServices;
    String totalCatalogValue;
    String paidRevenue;
    String pendingRevenue;
    List<Object[]> roleBreakdown;
    List<ServiceEntity> services;
    List<PaymentRecord> payments;

    if (request.getAttribute("totalStaff") != null) {
        totalStaff = (Long) request.getAttribute("totalStaff");
        totalCustomers = (Long) request.getAttribute("totalCustomers");
        activeServices = (Long) request.getAttribute("activeServices");
        totalCatalogValue = (String) request.getAttribute("totalCatalogValue");
        paidRevenue = (String) request.getAttribute("paidRevenue");
        pendingRevenue = (String) request.getAttribute("pendingRevenue");
        roleBreakdown = (List<Object[]>) request.getAttribute("roleBreakdown");
        services = (List<ServiceEntity>) request.getAttribute("services");
        payments = (List<PaymentRecord>) request.getAttribute("payments");
    } else {
        UsersEntityFacade userFacade = EjbLookup.lookup(UsersEntityFacade.class, "UsersEntityFacade");
        ServiceEntityFacade serviceFacade = EjbLookup.lookup(ServiceEntityFacade.class, "ServiceEntityFacade");
        PaymentRecordFacade paymentRecordFacade = EjbLookup.lookup(PaymentRecordFacade.class, "PaymentRecordFacade");
        totalStaff = userFacade.countNonCustomerUsers();
        totalCustomers = userFacade.countByRole("customer");
        activeServices = serviceFacade.countActive();
        totalCatalogValue = currency.format(serviceFacade.totalActivePrice());
        paidRevenue = currency.format(paymentRecordFacade.sumByStatus("paid"));
        pendingRevenue = currency.format(paymentRecordFacade.sumByStatus("pending"));
        roleBreakdown = userFacade.countUsersGroupedByRole();
        services = serviceFacade.findAllOrdered();
        payments = paymentRecordFacade.findAllOrdered();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Reports</title>
    <link rel="stylesheet" href="../../Styles/main.css">
    <style>
        .stats-grid,
        .report-grid {
            display: grid;
            gap: 20px;
        }

        .stats-grid {
            grid-template-columns: repeat(4, 1fr);
            margin-bottom: 24px;
        }

        .report-grid {
            grid-template-columns: 1fr 1fr;
        }

        .report-card {
            background: white;
            border-radius: 18px;
            padding: 22px;
            box-shadow: 0 10px 30px rgba(15, 23, 42, 0.06);
        }

        .report-card h3 {
            margin: 0 0 8px;
        }

        .report-card .sub {
            color: #64748b;
            margin-bottom: 18px;
        }

        .stat-label {
            font-size: 13px;
            color: #64748b;
            margin-bottom: 8px;
        }

        .stat-value {
            font-size: 30px;
            font-weight: 700;
            color: #0f172a;
        }

        .stat-note {
            margin-top: 8px;
            color: #64748b;
            font-size: 13px;
        }

        .stack-list {
            display: flex;
            flex-direction: column;
            gap: 14px;
        }

        .stack-item {
            padding: 14px;
            border-radius: 14px;
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            display: flex;
            justify-content: space-between;
            gap: 16px;
        }

        .stack-item strong {
            display: block;
            margin-bottom: 4px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 12px 10px;
            text-align: left;
            border-bottom: 1px solid #e2e8f0;
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

        @media (max-width: 1100px) {
            .stats-grid {
                grid-template-columns: repeat(2, 1fr);
            }

            .report-grid {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 680px) {
            .stats-grid {
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
            <jsp:param name="section" value="REPORTS" />
        </jsp:include>

        <div class="header-row">
            <div class="header-text">
                <h1>Reports</h1>
                <p>Database-driven statistics for staff, service pricing, and payments.</p>
            </div>
        </div>

        <div class="stats-grid">
            <div class="report-card">
                <div class="stat-label">Total Staff</div>
                <div class="stat-value"><%= totalStaff %></div>
                <div class="stat-note">Non-customer users in the system</div>
            </div>
            <div class="report-card">
                <div class="stat-label">Customers</div>
                <div class="stat-value"><%= totalCustomers %></div>
                <div class="stat-note">Registered customer accounts</div>
            </div>
            <div class="report-card">
                <div class="stat-label">Active Service Pricing</div>
                <div class="stat-value"><%= activeServices %></div>
                <div class="stat-note">Catalog value <%= totalCatalogValue %></div>
            </div>
            <div class="report-card">
                <div class="stat-label">Payment Summary</div>
                <div class="stat-value"><%= paidRevenue %></div>
                <div class="stat-note">Pending amount <%= pendingRevenue %></div>
            </div>
        </div>

        <div class="report-grid">
            <div class="report-card">
                <h3>User Role Distribution</h3>
                <div class="sub">Current role counts from `UsersEntity`</div>
                <div class="stack-list">
                    <% for (Object[] roleRow : roleBreakdown) { %>
                    <div class="stack-item">
                        <div>
                            <strong><%= roleRow[0] %></strong>
                            <span>Accounts in this role</span>
                        </div>
                        <strong><%= roleRow[1] %></strong>
                    </div>
                    <% } %>
                </div>
            </div>

            <div class="report-card">
                <h3>Service Pricing Overview</h3>
                <div class="sub">Active and inactive service price records</div>
                <div class="stack-list">
                    <% int serviceShown = 0;
                       for (ServiceEntity service : services) {
                           if (serviceShown >= 3) {
                               break;
                           }
                           serviceShown++;
                    %>
                    <div class="stack-item">
                        <div>
                            <strong><%= service.getService_name() %></strong>
                            <span><%= service.getDescription() == null || service.getDescription().isEmpty() ? "No description" : service.getDescription() %></span>
                        </div>
                        <div>
                            <strong><%= currency.format(service.getPrice()) %></strong>
                            <span><%= service.getActive() != null && service.getActive() == 1 ? "Active" : "Inactive" %></span>
                        </div>
                    </div>
                    <% } %>
                </div>
            </div>
        </div>

        <div class="report-card" style="margin-top: 24px;">
            <h3>Payment Activity</h3>
            <div class="sub">Latest payment records used for reporting totals</div>
            <table>
                <thead>
                    <tr>
                        <th>Invoice</th>
                        <th>Customer</th>
                        <th>Service</th>
                        <th>Amount</th>
                        <th>Status</th>
                        <th>Receipt</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (PaymentRecord payment : payments) {
                        String statusClass = "paid".equalsIgnoreCase(payment.getStatus()) ? "status-paid" : "status-pending";
                    %>
                    <tr>
                        <td><%= payment.getInvoice_number() %></td>
                        <td><%= payment.getCustomer_name() %></td>
                        <td><%= payment.getService_name() %></td>
                        <td><%= currency.format(payment.getAmount()) %></td>
                        <td><span class="status-pill <%= statusClass %>"><%= payment.getStatus() %></span></td>
                        <td><%= payment.getReceipt_number() %></td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>
