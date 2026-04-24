<%@page import="java.math.BigDecimal,java.math.RoundingMode,java.text.NumberFormat,java.time.LocalDate,java.time.YearMonth,java.time.format.TextStyle,java.util.ArrayList,java.util.Collections,java.util.HashMap,java.util.LinkedHashMap,java.util.List,java.util.Locale,java.util.Map,models.AppointmentService,models.AppointmentServiceFacade,models.Appointments,models.AppointmentsFacade,models.PaymentRecord,models.PaymentRecordFacade,models.ServiceEntity,models.ServiceEntityFacade,models.UsersEntity,models.UsersEntityFacade,utils.EjbLookup"%>
<%!
    private String safeText(String value) {
        return value == null ? "" : value.trim();
    }

    private String formatMonthLabel(YearMonth yearMonth) {
        return yearMonth.getMonth().getDisplayName(TextStyle.SHORT, Locale.ENGLISH) + " " + yearMonth.getYear();
    }

    private LinkedHashMap<YearMonth, BigDecimal> initMonthTotals(int monthCount) {
        LinkedHashMap<YearMonth, BigDecimal> totals = new LinkedHashMap<>();
        YearMonth startMonth = YearMonth.from(LocalDate.now()).minusMonths(monthCount - 1L);
        for (int i = 0; i < monthCount; i++) {
            totals.put(startMonth.plusMonths(i), BigDecimal.ZERO);
        }
        return totals;
    }

    private List<Object[]> buildMonthlySalesRows(List<PaymentRecord> payments, int monthCount) {
        LinkedHashMap<YearMonth, BigDecimal> totals = initMonthTotals(monthCount);
        for (PaymentRecord payment : payments) {
            if (payment == null
                    || payment.getPayment_date() == null
                    || payment.getAmount() == null
                    || !"paid".equalsIgnoreCase(safeText(payment.getStatus()))) {
                continue;
            }
            YearMonth paymentMonth = YearMonth.from(payment.getPayment_date());
            if (totals.containsKey(paymentMonth)) {
                totals.put(paymentMonth, totals.get(paymentMonth).add(payment.getAmount()));
            }
        }
        List<Object[]> rows = new ArrayList<>();
        for (Map.Entry<YearMonth, BigDecimal> entry : totals.entrySet()) {
            rows.add(new Object[]{formatMonthLabel(entry.getKey()), entry.getValue()});
        }
        return rows;
    }

    private List<Object[]> buildMonthlyAppointmentRows(List<Appointments> appointments, int monthCount) {
        LinkedHashMap<YearMonth, Long> totals = new LinkedHashMap<>();
        YearMonth startMonth = YearMonth.from(LocalDate.now()).minusMonths(monthCount - 1L);
        for (int i = 0; i < monthCount; i++) {
            totals.put(startMonth.plusMonths(i), 0L);
        }
        for (Appointments appointment : appointments) {
            if (appointment == null || appointment.getAppointment_date() == null) {
                continue;
            }
            YearMonth appointmentMonth = YearMonth.from(appointment.getAppointment_date());
            if (totals.containsKey(appointmentMonth)) {
                totals.put(appointmentMonth, totals.get(appointmentMonth) + 1L);
            }
        }
        List<Object[]> rows = new ArrayList<>();
        for (Map.Entry<YearMonth, Long> entry : totals.entrySet()) {
            rows.add(new Object[]{formatMonthLabel(entry.getKey()), entry.getValue()});
        }
        return rows;
    }

    private List<Object[]> buildStatusRows(List<Appointments> appointments) {
        LinkedHashMap<String, Long> counts = new LinkedHashMap<>();
        counts.put("Pending", 0L);
        counts.put("Assigned", 0L);
        counts.put("Waiting Approval", 0L);
        counts.put("In Progress", 0L);
        counts.put("Delayed", 0L);
        counts.put("Completed / Unpaid", 0L);
        counts.put("Paid", 0L);
        counts.put("Cancelled", 0L);

        for (Appointments appointment : appointments) {
            String status = safeText(appointment == null ? null : appointment.getStatus()).toUpperCase();
            if ("PENDING".equals(status)) {
                counts.put("Pending", counts.get("Pending") + 1L);
            } else if ("ASSIGNED".equals(status)) {
                counts.put("Assigned", counts.get("Assigned") + 1L);
            } else if ("WAITING APPROVAL".equals(status)) {
                counts.put("Waiting Approval", counts.get("Waiting Approval") + 1L);
            } else if ("ACCEPTED".equals(status)) {
                counts.put("In Progress", counts.get("In Progress") + 1L);
            } else if ("DELAYED".equals(status)) {
                counts.put("Delayed", counts.get("Delayed") + 1L);
            } else if ("COMPLETED".equals(status) || "UNPAID".equals(status)) {
                counts.put("Completed / Unpaid", counts.get("Completed / Unpaid") + 1L);
            } else if ("PAID".equals(status)) {
                counts.put("Paid", counts.get("Paid") + 1L);
            } else if ("CANCELLED".equals(status)) {
                counts.put("Cancelled", counts.get("Cancelled") + 1L);
            }
        }

        List<Object[]> rows = new ArrayList<>();
        for (Map.Entry<String, Long> entry : counts.entrySet()) {
            rows.add(new Object[]{entry.getKey(), entry.getValue()});
        }
        return rows;
    }

    private List<Object[]> buildTopServiceRows(List<AppointmentService> appointmentServices, List<ServiceEntity> services, int limit) {
        Map<Integer, String> serviceNames = new HashMap<>();
        for (ServiceEntity service : services) {
            if (service != null && service.getId() != null) {
                serviceNames.put(service.getId(), safeText(service.getService_name()));
            }
        }

        Map<String, Long> counts = new HashMap<>();
        for (AppointmentService item : appointmentServices) {
            if (item == null || item.getService_id() == null) {
                continue;
            }
            String serviceName = serviceNames.get(item.getService_id());
            if (serviceName == null || serviceName.isEmpty()) {
                continue;
            }
            counts.put(serviceName, counts.getOrDefault(serviceName, 0L) + 1L);
        }

        List<Map.Entry<String, Long>> sorted = new ArrayList<>(counts.entrySet());
        Collections.sort(sorted, (left, right) -> Long.compare(right.getValue(), left.getValue()));

        List<Object[]> rows = new ArrayList<>();
        int shown = 0;
        for (Map.Entry<String, Long> entry : sorted) {
            if (shown >= limit) {
                break;
            }
            rows.add(new Object[]{entry.getKey(), entry.getValue()});
            shown++;
        }
        return rows;
    }

    private BigDecimal averagePaidTicketAmount(List<PaymentRecord> payments) {
        BigDecimal total = BigDecimal.ZERO;
        int count = 0;
        for (PaymentRecord payment : payments) {
            if (payment == null || payment.getAmount() == null || !"paid".equalsIgnoreCase(safeText(payment.getStatus()))) {
                continue;
            }
            total = total.add(payment.getAmount());
            count++;
        }
        if (count == 0) {
            return BigDecimal.ZERO;
        }
        return total.divide(BigDecimal.valueOf(count), 2, RoundingMode.HALF_UP);
    }

    private long feedbackTotal(List<Appointments> appointments) {
        long count = 0;
        for (Appointments appointment : appointments) {
            if (appointment != null && !safeText(appointment.getCustomer_feedback()).isEmpty()) {
                count++;
            }
        }
        return count;
    }
%>
<%
    UsersEntity currentUser = (UsersEntity) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/loginjsp.jsp");
        return;
    }
    String currentRole = currentUser.getRole() == null ? "" : currentUser.getRole().trim().toLowerCase();
    if (!"manager".equals(currentRole)) {
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
    List<Object[]> monthlySales;
    List<Object[]> monthlyAppointments;
    List<Object[]> statusBreakdown;
    List<Object[]> topServices;
    String averagePaidTicket;
    long feedbackCount;
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
        monthlySales = (List<Object[]>) request.getAttribute("monthlySales");
        monthlyAppointments = (List<Object[]>) request.getAttribute("monthlyAppointments");
        statusBreakdown = (List<Object[]>) request.getAttribute("statusBreakdown");
        topServices = (List<Object[]>) request.getAttribute("topServices");
        averagePaidTicket = (String) request.getAttribute("averagePaidTicket");
        feedbackCount = request.getAttribute("feedbackCount") == null ? 0L : (Long) request.getAttribute("feedbackCount");
    } else {
        UsersEntityFacade userFacade = EjbLookup.lookup(UsersEntityFacade.class, "UsersEntityFacade");
        ServiceEntityFacade serviceFacade = EjbLookup.lookup(ServiceEntityFacade.class, "ServiceEntityFacade");
        PaymentRecordFacade paymentRecordFacade = EjbLookup.lookup(PaymentRecordFacade.class, "PaymentRecordFacade");
        AppointmentsFacade appointmentsFacade = EjbLookup.lookup(AppointmentsFacade.class, "AppointmentsFacade");
        AppointmentServiceFacade appointmentServiceFacade = EjbLookup.lookup(AppointmentServiceFacade.class, "AppointmentServiceFacade");
        List<Appointments> appointmentItems = appointmentsFacade.findAllOrdered();
        totalStaff = userFacade.countNonCustomerUsers();
        totalCustomers = userFacade.countByRole("customer");
        activeServices = serviceFacade.countActive();
        totalCatalogValue = currency.format(serviceFacade.totalActivePrice());
        paidRevenue = currency.format(paymentRecordFacade.sumByStatus("paid"));
        pendingRevenue = currency.format(paymentRecordFacade.sumByStatus("pending"));
        roleBreakdown = userFacade.countUsersGroupedByRole();
        services = serviceFacade.findAllOrdered();
        payments = paymentRecordFacade.findAllOrdered();
        monthlySales = buildMonthlySalesRows(payments, 6);
        monthlyAppointments = buildMonthlyAppointmentRows(appointmentItems, 6);
        statusBreakdown = buildStatusRows(appointmentItems);
        topServices = buildTopServiceRows(appointmentServiceFacade.findAll(), services, 5);
        averagePaidTicket = currency.format(averagePaidTicketAmount(payments));
        feedbackCount = feedbackTotal(appointmentItems);
    }

    BigDecimal maxMonthlySales = BigDecimal.ONE;
    for (Object[] row : monthlySales) {
        BigDecimal value = row[1] instanceof BigDecimal ? (BigDecimal) row[1] : BigDecimal.ZERO;
        if (value.compareTo(maxMonthlySales) > 0) {
            maxMonthlySales = value;
        }
    }

    long maxMonthlyAppointments = 1L;
    for (Object[] row : monthlyAppointments) {
        long value = row[1] instanceof Number ? ((Number) row[1]).longValue() : 0L;
        if (value > maxMonthlyAppointments) {
            maxMonthlyAppointments = value;
        }
    }

    long totalStatusItems = 0L;
    long maxStatusCount = 1L;
    for (Object[] row : statusBreakdown) {
        long value = row[1] instanceof Number ? ((Number) row[1]).longValue() : 0L;
        totalStatusItems += value;
        if (value > maxStatusCount) {
            maxStatusCount = value;
        }
    }

    long maxServiceUsage = 1L;
    for (Object[] row : topServices) {
        long value = row[1] instanceof Number ? ((Number) row[1]).longValue() : 0L;
        if (value > maxServiceUsage) {
            maxServiceUsage = value;
        }
    }

    UsersEntityFacade reportUserFacade = EjbLookup.lookup(UsersEntityFacade.class, "UsersEntityFacade");
    Map<Integer, String> userNameById = new HashMap<Integer, String>();
    for (UsersEntity user : reportUserFacade.findAll()) {
        if (user != null && user.getId() != null) {
            userNameById.put(user.getId(), user.getName() == null ? ("User #" + user.getId()) : user.getName().trim());
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Reports</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/Styles/main.css">
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

        .chart-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-top: 24px;
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

        .chart-card {
            min-height: 360px;
        }

        .mini-stats {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
            margin-top: 24px;
        }

        .mini-stat {
            padding: 18px 20px;
            border-radius: 16px;
            background: linear-gradient(180deg, #f8fbff 0%, #f1f5f9 100%);
            border: 1px solid #dbeafe;
        }

        .mini-stat .label {
            color: #64748b;
            font-size: 13px;
            margin-bottom: 8px;
        }

        .mini-stat .value {
            color: #0f172a;
            font-size: 28px;
            font-weight: 700;
        }

        .svg-chart {
            width: 100%;
            height: auto;
            margin-top: 8px;
            display: block;
        }

        .chart-legend {
            display: flex;
            justify-content: space-between;
            gap: 12px;
            flex-wrap: wrap;
            margin-top: 14px;
        }

        .legend-item {
            color: #475569;
            font-size: 13px;
            font-weight: 600;
        }

        .progress-list {
            display: flex;
            flex-direction: column;
            gap: 14px;
        }

        .progress-item {
            display: grid;
            grid-template-columns: 180px 1fr auto;
            align-items: center;
            gap: 16px;
        }

        .progress-label {
            font-size: 14px;
            font-weight: 600;
            color: #0f172a;
        }

        .progress-track {
            height: 12px;
            border-radius: 999px;
            background: #e2e8f0;
            overflow: hidden;
        }

        .progress-fill {
            height: 100%;
            border-radius: 999px;
            background: linear-gradient(90deg, #60a5fa 0%, #2563eb 100%);
        }

        .progress-fill.warning {
            background: linear-gradient(90deg, #fbbf24 0%, #f59e0b 100%);
        }

        .progress-fill.success {
            background: linear-gradient(90deg, #34d399 0%, #059669 100%);
        }

        .progress-fill.danger {
            background: linear-gradient(90deg, #f87171 0%, #dc2626 100%);
        }

        .progress-value {
            font-size: 13px;
            color: #475569;
            font-weight: 600;
            min-width: 50px;
            text-align: right;
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

            .report-grid,
            .chart-grid,
            .mini-stats {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 680px) {
            .stats-grid {
                grid-template-columns: 1fr;
            }

            .progress-item {
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
                <p>Useful manager insights across sales, appointments, services, staff, and customer activity.</p>
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
                <div class="sub">Current staff and customer distribution in the system</div>
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
                <div class="sub">A quick look at the current service catalog</div>
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

        <div class="mini-stats">
            <div class="mini-stat">
                <div class="label">Average Paid Ticket</div>
                <div class="value"><%= averagePaidTicket %></div>
            </div>
            <div class="mini-stat">
                <div class="label">Customer Feedback Submitted</div>
                <div class="value"><%= feedbackCount %></div>
            </div>
        </div>

        <div class="chart-grid">
            <div class="report-card chart-card">
                <h3>Monthly Sales</h3>
                <div class="sub">Paid revenue trend for the last 6 months</div>
                <% if (monthlySales == null || monthlySales.isEmpty()) { %>
                <div class="sub">No payment data yet.</div>
                <% } else { %>
                <svg class="svg-chart" viewBox="0 0 640 300" preserveAspectRatio="none">
                    <line x1="50" y1="250" x2="610" y2="250" stroke="#cbd5e1" stroke-width="2" />
                    <line x1="50" y1="30" x2="50" y2="250" stroke="#cbd5e1" stroke-width="2" />
                    <% for (int i = 0; i < monthlySales.size(); i++) {
                        Object[] row = monthlySales.get(i);
                        String label = String.valueOf(row[0]);
                        BigDecimal value = row[1] instanceof BigDecimal ? (BigDecimal) row[1] : BigDecimal.ZERO;
                        int x = 75 + (i * 88);
                        int barWidth = 46;
                        int barHeight = maxMonthlySales.compareTo(BigDecimal.ZERO) == 0 ? 0 : Math.max(6, value.multiply(BigDecimal.valueOf(180)).divide(maxMonthlySales, 0, RoundingMode.HALF_UP).intValue());
                        int y = 230 - barHeight;
                    %>
                    <rect x="<%= x %>" y="<%= y %>" width="<%= barWidth %>" height="<%= barHeight %>" rx="10" fill="#2563eb" />
                    <text x="<%= x + (barWidth / 2) %>" y="<%= y - 8 %>" text-anchor="middle" font-size="11" fill="#334155"><%= currency.format(value) %></text>
                    <text x="<%= x + (barWidth / 2) %>" y="270" text-anchor="middle" font-size="11" fill="#64748b"><%= label %></text>
                    <% } %>
                </svg>
                <div class="chart-legend">
                    <span class="legend-item">Blue bars: paid sales by month</span>
                </div>
                <% } %>
            </div>

            <div class="report-card chart-card">
                <h3>Appointments Per Month</h3>
                <div class="sub">Booking volume trend for the last 6 months</div>
                <% if (monthlyAppointments == null || monthlyAppointments.isEmpty()) { %>
                <div class="sub">No appointment data yet.</div>
                <% } else { %>
                <svg class="svg-chart" viewBox="0 0 640 300" preserveAspectRatio="none">
                    <line x1="50" y1="250" x2="610" y2="250" stroke="#cbd5e1" stroke-width="2" />
                    <line x1="50" y1="30" x2="50" y2="250" stroke="#cbd5e1" stroke-width="2" />
                    <% StringBuilder points = new StringBuilder();
                       for (int i = 0; i < monthlyAppointments.size(); i++) {
                           Object[] row = monthlyAppointments.get(i);
                           long value = row[1] instanceof Number ? ((Number) row[1]).longValue() : 0L;
                           int x = 85 + (i * 88);
                           int y = 230 - (maxMonthlyAppointments == 0 ? 0 : (int) Math.max(value == 0 ? 0 : 12, (value * 180.0) / maxMonthlyAppointments));
                           points.append(x).append(",").append(y).append(" ");
                       }
                    %>
                    <polyline fill="none" stroke="#059669" stroke-width="4" stroke-linecap="round" stroke-linejoin="round" points="<%= points.toString().trim() %>" />
                    <% for (int i = 0; i < monthlyAppointments.size(); i++) {
                        Object[] row = monthlyAppointments.get(i);
                        String label = String.valueOf(row[0]);
                        long value = row[1] instanceof Number ? ((Number) row[1]).longValue() : 0L;
                        int x = 85 + (i * 88);
                        int y = 230 - (maxMonthlyAppointments == 0 ? 0 : (int) Math.max(value == 0 ? 0 : 12, (value * 180.0) / maxMonthlyAppointments));
                    %>
                    <circle cx="<%= x %>" cy="<%= y %>" r="6" fill="#059669" />
                    <text x="<%= x %>" y="<%= y - 10 %>" text-anchor="middle" font-size="11" fill="#334155"><%= value %></text>
                    <text x="<%= x %>" y="270" text-anchor="middle" font-size="11" fill="#64748b"><%= label %></text>
                    <% } %>
                </svg>
                <div class="chart-legend">
                    <span class="legend-item">Green line: appointments booked per month</span>
                </div>
                <% } %>
            </div>
        </div>

        <div class="chart-grid">
            <div class="report-card">
                <h3>Appointment Status Breakdown</h3>
                <div class="sub">Current workflow mix across all appointments</div>
                <div class="progress-list">
                    <% for (Object[] row : statusBreakdown) {
                        String label = String.valueOf(row[0]);
                        long value = row[1] instanceof Number ? ((Number) row[1]).longValue() : 0L;
                        int width = maxStatusCount == 0 ? 0 : (int) Math.max(value == 0 ? 0 : 10, (value * 100.0) / maxStatusCount);
                        String fillClass = "progress-fill";
                        if ("Paid".equalsIgnoreCase(label)) {
                            fillClass += " success";
                        } else if ("Delayed".equalsIgnoreCase(label) || "Cancelled".equalsIgnoreCase(label)) {
                            fillClass += " danger";
                        } else if ("Waiting Approval".equalsIgnoreCase(label) || "Completed / Unpaid".equalsIgnoreCase(label)) {
                            fillClass += " warning";
                        }
                    %>
                    <div class="progress-item">
                        <div class="progress-label"><%= label %></div>
                        <div class="progress-track">
                            <div class="<%= fillClass %>" style="width: <%= width %>%"></div>
                        </div>
                        <div class="progress-value"><%= value %> / <%= totalStatusItems %></div>
                    </div>
                    <% } %>
                </div>
            </div>

            <div class="report-card">
                <h3>Top Requested Services</h3>
                <div class="sub">Most frequently selected services from appointment quotations</div>
                <% if (topServices == null || topServices.isEmpty()) { %>
                <div class="sub">No service usage data yet.</div>
                <% } else { %>
                <div class="progress-list">
                    <% for (Object[] row : topServices) {
                        String label = String.valueOf(row[0]);
                        long value = row[1] instanceof Number ? ((Number) row[1]).longValue() : 0L;
                        int width = maxServiceUsage == 0 ? 0 : (int) Math.max(value == 0 ? 0 : 10, (value * 100.0) / maxServiceUsage);
                    %>
                    <div class="progress-item">
                        <div class="progress-label"><%= label %></div>
                        <div class="progress-track">
                            <div class="progress-fill success" style="width: <%= width %>%"></div>
                        </div>
                        <div class="progress-value"><%= value %> time<%= value == 1 ? "" : "s" %></div>
                    </div>
                    <% } %>
                </div>
                <% } %>
            </div>
        </div>

        <div class="report-card" style="margin-top: 24px;">
            <h3>Payment Activity</h3>
            <div class="sub">Latest 3 payment records for a quick manager snapshot</div>
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
                    <% int paymentShown = 0;
                       for (PaymentRecord payment : payments) {
                        if (paymentShown >= 3) {
                            break;
                        }
                        paymentShown++;
                        String statusClass = "paid".equalsIgnoreCase(payment.getStatus()) ? "status-paid" : "status-pending";
                        String customerText = payment.getUser_id() == null ? "-" : userNameById.getOrDefault(payment.getUser_id(), "User #" + payment.getUser_id());
                    %>
                    <tr>
                        <td><%= payment.getInvoice_number() %></td>
                        <td><%= customerText %></td>
                        <td><%= payment.getService_name() %></td>
                        <td><%= currency.format(payment.getAmount()) %></td>
                        <td><span class="status-pill <%= statusClass %>"><%= payment.getStatus() %></span></td>
                        <td><%= payment.getReceipt_number() %></td>
                    </tr>
                    <% } %>
                    <% if (payments == null || payments.isEmpty()) { %>
                    <tr>
                        <td colspan="6" style="color: #64748b;">No payment records yet.</td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>
