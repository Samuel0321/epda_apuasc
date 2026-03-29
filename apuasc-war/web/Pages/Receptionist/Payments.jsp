<%--
    Document   : Payments
    Created on : Mar 24, 2026
    Author     : pinju
--%>

<%@page import="java.math.BigDecimal,java.text.NumberFormat,java.time.LocalDate,java.util.ArrayList,java.util.List,java.util.Locale,models.AppointmentService,models.AppointmentServiceFacade,models.Appointments,models.AppointmentsFacade,models.ServiceEntity,models.ServiceEntityFacade,models.UsersEntity,models.UsersEntityFacade,utils.EjbLookup"%>
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

    NumberFormat currency = NumberFormat.getCurrencyInstance(new Locale("ms", "MY"));
    List<Appointments> allAppointments = appointmentsFacade.findAllOrdered();
    List<Appointments> payments = new ArrayList<Appointments>();
    BigDecimal paidToday = BigDecimal.ZERO;
    int pendingPayments = 0;
    int failedTransactions = 0;
    LocalDate today = LocalDate.now();

    for (Appointments appointment : allAppointments) {
        String status = appointment.getStatus() == null ? "" : appointment.getStatus().trim().toUpperCase();
        if (!("PAID".equals(status) || "UNPAID".equals(status) || "COMPLETED".equals(status) || "FAILED".equals(status))) {
            continue;
        }
        payments.add(appointment);

        if ("PAID".equals(status) && today.equals(appointment.getAppointment_date())) {
            paidToday = paidToday.add(appointment.getTotal_amount() == null ? BigDecimal.ZERO : appointment.getTotal_amount());
        }
        if ("UNPAID".equals(status) || "COMPLETED".equals(status)) {
            pendingPayments++;
        }
        if ("FAILED".equals(status)) {
            failedTransactions++;
        }
    }

    java.util.Map<Integer, String> userNameById = new java.util.HashMap<Integer, String>();
    for (UsersEntity user : usersFacade.findAll()) {
        userNameById.put(user.getId(), user.getName());
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Payments</title>
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

        .badge-paid {
            background: #bbf7d0;
            color: #166534;
        }

        .badge-pending {
            background: #fef08a;
            color: #854d0e;
        }

        .badge-failed {
            background: #fecaca;
            color: #7f1d1d;
        }

        .amount {
            font-weight: 600;
            color: #1e293b;
        }

        .action-buttons {
            display: flex;
            gap: 5px;
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

        .btn-info {
            background: #dbeafe;
            color: #1e40af;
        }

        .btn-info:hover {
            background: #bfdbfe;
        }

        .btn-pay {
            background: #bbf7d0;
            color: #166534;
        }

        .btn-pay:hover {
            background: #86efac;
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

        .summary {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 20px;
        }

        .summary-card {
            background: white;
            padding: 15px;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
        }

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

        .toolbar {
            display: flex;
            justify-content: flex-end;
            margin-bottom: 14px;
        }

        .btn-primary-action {
            padding: 10px 14px;
            border: none;
            border-radius: 8px;
            background: #2563eb;
            color: white;
            cursor: pointer;
            font-weight: 500;
        }

        .btn-primary-action:hover {
            background: #1d4ed8;
        }

        .btn-receipt {
            background: #e0e7ff;
            color: #3730a3;
        }

        .btn-receipt:hover {
            background: #c7d2fe;
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
            <jsp:param name="section" value="PAYMENTS" />
        </jsp:include>

        <!-- HEADER -->
        <div class="header-row">
            <div class="header-text">
                <h1>Payment Management</h1>
                <p>Process and track customer payments</p>
            </div>
        </div>

        <!-- SUMMARY CARDS -->
        <div class="summary">
            <div class="summary-card">
                <div class="summary-label">Total Payments Today</div>
                <div class="summary-value"><%= currency.format(paidToday) %></div>
            </div>
            <div class="summary-card">
                <div class="summary-label">Pending Payments</div>
                <div class="summary-value"><%= pendingPayments %></div>
            </div>
            <div class="summary-card">
                <div class="summary-label">Failed Transactions</div>
                <div class="summary-value"><%= failedTransactions %></div>
            </div>
        </div>

        <!-- FILTERS -->
        <div class="filters">
            <button class="filter-btn active" data-filter="All">All</button>
            <button class="filter-btn" data-filter="Paid">Paid</button>
            <button class="filter-btn" data-filter="Pending">Pending</button>
            <button class="filter-btn" data-filter="Failed">Failed</button>
        </div>

        <!-- TABLE -->
        <div class="table-container">

            <div class="table-header">
                <input type="text" class="search-box" placeholder="Search by customer or transaction ID...">
            </div>

            <table>
                <thead>
                    <tr>
                        <th>Invoice ID</th>
                        <th>Customer</th>
                        <th>Service</th>
                        <th>Amount</th>
                        <th>Payment Date</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (payments.isEmpty()) { %>
                    <tr>
                        <td colspan="7">No payment records found.</td>
                    </tr>
                    <% } else {
                        for (Appointments appointment : payments) {
                            Integer appointmentId = appointment.getId();
                            String customerName = userNameById.get(appointment.getCustomer_id());
                            if (customerName == null || customerName.trim().isEmpty()) {
                                customerName = "Customer #" + appointment.getCustomer_id();
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

                            String status = appointment.getStatus() == null ? "PENDING" : appointment.getStatus().trim().toUpperCase();
                            String statusText = "PENDING";
                            String statusClass = "badge-pending";
                            if ("PAID".equals(status)) {
                                statusText = "Paid";
                                statusClass = "badge-paid";
                            } else if ("FAILED".equals(status)) {
                                statusText = "Failed";
                                statusClass = "badge-failed";
                            }
                    %>
                    <tr class="payment-row" data-status="<%= statusText %>">
                        <td>#INV<%= String.format("%03d", appointmentId) %></td>
                        <td><%= customerName %></td>
                        <td><%= serviceName %></td>
                        <td class="amount"><%= currency.format(appointment.getTotal_amount() == null ? BigDecimal.ZERO : appointment.getTotal_amount()) %></td>
                        <td><%= "PAID".equals(status) ? (appointment.getAppointment_date() == null ? "-" : appointment.getAppointment_date().toString()) : "-" %></td>
                        <td><span class="badge <%= statusClass %>"><%= statusText %></span></td>
                        <td>
                            <div class="action-buttons">
                                <button class="btn-small btn-info" onclick="window.location.href='Appointments.jsp'">View</button>
                                <% if ("PAID".equals(status)) { %><button class="btn-small btn-receipt" onclick="alert('Receipt generated.')">Receipt</button><% } %>
                                <% if (!("PAID".equals(status) || "FAILED".equals(status))) { %>
                                <form method="post" action="<%= request.getContextPath() %>/ReceptionistPaymentServlet" style="display:inline;">
                                    <input type="hidden" name="appointmentId" value="<%= appointmentId %>">
                                    <button type="submit" class="btn-small btn-pay">Mark as Paid</button>
                                </form>
                                <% } %>
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

<script>
    document.addEventListener("DOMContentLoaded", function() {
        const filters = document.querySelectorAll(".filter-btn");
        const rows = document.querySelectorAll(".payment-row");

        filters.forEach(btn => {
            btn.addEventListener("click", function() {
                filters.forEach(f => f.classList.remove("active"));
                this.classList.add("active");
                const filter = this.getAttribute("data-filter");

                rows.forEach(row => {
                    if (filter === "All" || row.getAttribute("data-status").toUpperCase() === filter.toUpperCase()) {
                        row.style.display = "";
                    } else {
                        row.style.display = "none";
                    }
                });
            });
        });
    });
</script>
</body>
</html>



