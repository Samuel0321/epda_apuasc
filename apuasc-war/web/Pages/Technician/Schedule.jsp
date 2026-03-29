<%@page import="java.time.LocalDate,java.time.YearMonth,java.time.format.DateTimeParseException,java.util.HashMap,java.util.List,java.util.Map,models.Appointments,models.AppointmentsFacade,models.UsersEntity,models.UsersEntityFacade,utils.EjbLookup"%>
<%
    UsersEntity currentUser = (UsersEntity) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/loginjsp.jsp");
        return;
    }

    UsersEntityFacade userFacade = EjbLookup.lookup(UsersEntityFacade.class, "UsersEntityFacade");
    AppointmentsFacade appointmentsFacade = EjbLookup.lookup(AppointmentsFacade.class, "AppointmentsFacade");
    currentUser = userFacade.find(currentUser.getId());
    session.setAttribute("user", currentUser);

    List<Appointments> appointments = appointmentsFacade.findByTechnicianId(currentUser.getId());
    Map<LocalDate, Integer> perDay = new HashMap<>();
    for (Appointments appointment : appointments) {
        if (appointment.getAppointment_date() != null) {
            perDay.put(appointment.getAppointment_date(), perDay.getOrDefault(appointment.getAppointment_date(), 0) + 1);
        }
    }

    LocalDate today = LocalDate.now();
    LocalDate selectedDate = today;
    try {
        String selectedDateParam = request.getParameter("selectedDate");
        if (selectedDateParam != null && !selectedDateParam.trim().isEmpty()) {
            selectedDate = LocalDate.parse(selectedDateParam.trim());
        }
    } catch (DateTimeParseException ex) {
        selectedDate = today;
    }

    YearMonth currentMonth = YearMonth.from(selectedDate);
    LocalDate monthStart = currentMonth.atDay(1);
    int daysInMonth = currentMonth.lengthOfMonth();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Schedule</title>
    <link rel="stylesheet" href="../../Styles/main.css">
    <style>
        .schedule-container {
            background: white;
            padding: 22px;
            border-radius: 18px;
            box-shadow: 0 10px 28px rgba(15, 23, 42, 0.06);
            margin-bottom: 20px;
            border: 1px solid #dbe2ea;
        }

        .schedule-layout {
            display: grid;
            grid-template-columns: 7fr 3fr;
            gap: 20px;
            align-items: start;
        }

        .schedule-toolbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
            flex-wrap: wrap;
            margin-bottom: 18px;
        }

        .schedule-picker {
            display: flex;
            gap: 10px;
            align-items: center;
            flex-wrap: wrap;
        }

        .schedule-picker input[type="date"] {
            padding: 10px 12px;
            border: 1px solid #dbe2ea;
            border-radius: 10px;
            font-size: 14px;
        }

        .schedule-picker button {
            padding: 10px 14px;
            border: none;
            border-radius: 10px;
            background: #334155;
            color: white;
            cursor: pointer;
            font-weight: 600;
        }

        .calendar-grid {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            gap: 10px;
            margin-top: 18px;
        }

        .day-header {
            text-align: center;
            font-weight: 600;
            color: #64748b;
            padding: 10px 0;
        }

        .day-cell {
            min-height: 88px;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            padding: 10px;
            background: white;
            text-decoration: none;
            color: inherit;
            display: block;
        }

        .day-cell:hover {
            background: #f8fafc;
            border-color: #94a3b8;
        }

        .day-cell.today {
            background: #f8fafc;
            border-color: #94a3b8;
        }

        .day-cell.selected {
            background: #e2e8f0;
            border-color: #334155;
        }

        .day-number {
            font-size: 13px;
            color: #0f172a;
            margin-bottom: 8px;
            font-weight: 600;
        }

        .day-events {
            font-size: 12px;
            color: #475569;
        }

        .timeline {
            display: flex;
            flex-direction: column;
            gap: 14px;
        }

        .timeline-item {
            border-left: 4px solid #94a3b8;
            padding: 15px;
            background: #f8fafc;
            border-radius: 10px;
        }

        .timeline-status {
            display: inline-block;
            margin-top: 6px;
            padding: 4px 10px;
            border-radius: 999px;
            background: #e2e8f0;
            color: #334155;
            font-size: 12px;
            font-weight: 600;
        }

        .timeline-panel {
            position: sticky;
            top: 20px;
        }

        .timeline-panel h3 {
            margin-top: 0;
        }

        @media (max-width: 1100px) {
            .schedule-layout {
                grid-template-columns: 1fr;
            }

            .timeline-panel {
                position: static;
            }
        }

        @media (max-width: 900px) {
            .calendar-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }
    </style>
</head>
<body>
<div class="layout">
    <jsp:include page="../../Component/Sidebar.jsp" />
    <div class="main">
        <jsp:include page="../../Component/Topbar.jsp"><jsp:param name="section" value="SCHEDULE" /></jsp:include>
        <div class="header-row">
            <div class="header-text">
                <h1>My Schedule</h1>
                <p>Select any date to view that day’s appointment timeline for your technician account.</p>
            </div>
        </div>

        <div class="schedule-layout">
            <div class="schedule-container">
                <div class="schedule-toolbar">
                    <h3><%= currentMonth.getMonth() %> <%= currentMonth.getYear() %></h3>
                    <form method="get" class="schedule-picker">
                        <input type="date" name="selectedDate" value="<%= selectedDate %>">
                        <button type="submit">View Day</button>
                    </form>
                </div>

                <div class="calendar-grid">
                    <div class="day-header">Mon</div>
                    <div class="day-header">Tue</div>
                    <div class="day-header">Wed</div>
                    <div class="day-header">Thu</div>
                    <div class="day-header">Fri</div>
                    <div class="day-header">Sat</div>
                    <div class="day-header">Sun</div>

                    <% for (int day = 1; day <= daysInMonth; day++) {
                        LocalDate cellDate = monthStart.withDayOfMonth(day);
                    %>
                    <a class="day-cell <%= cellDate.equals(today) ? "today" : "" %> <%= cellDate.equals(selectedDate) ? "selected" : "" %>"
                       href="?selectedDate=<%= cellDate %>">
                        <div class="day-number"><%= day %></div>
                        <div class="day-events"><%= perDay.getOrDefault(cellDate, 0) %> task(s)</div>
                    </a>
                    <% } %>
                </div>
            </div>

            <div class="schedule-container timeline-panel">
                <h3>Timeline For <%= selectedDate %></h3>
                <div class="timeline">
                    <% boolean hasSelectedDay = false;
                       for (Appointments appointment : appointments) {
                           if (!selectedDate.equals(appointment.getAppointment_date())) {
                               continue;
                           }
                           hasSelectedDay = true;
                           UsersEntity customer = appointment.getCustomer_id() == null ? null : userFacade.find(appointment.getCustomer_id());
                    %>
                    <div class="timeline-item">
                        <div><strong><%= appointment.getAppointment_time() %></strong></div>
                        <div>#APT<%= appointment.getAppointment_id() %> - <%= customer == null ? "Customer" : customer.getName() %></div>
                        <div style="color:#64748b;"><%= appointment.getCustomer_notes() == null || appointment.getCustomer_notes().trim().isEmpty() ? "No booking note provided." : appointment.getCustomer_notes() %></div>
                        <span class="timeline-status"><%= appointment.getStatus() %></span>
                    </div>
                    <% }
                       if (!hasSelectedDay) { %>
                    <div class="timeline-item">No appointments are scheduled for <%= selectedDate %>.</div>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
