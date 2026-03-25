<%--
    Document   : Schedule
    Created on : Mar 24, 2026
    Author     : pinju
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Schedule</title>
    <link rel="stylesheet" href="../../Styles/main.css">
    <style>
        .schedule-container {
            background: white;
            padding: 20px;
            border-radius: 14px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
            margin-bottom: 20px;
        }

        .schedule-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .schedule-nav {
            display: flex;
            gap: 10px;
            align-items: center;
        }

        .schedule-nav button {
            padding: 8px 14px;
            border: 1px solid #e2e8f0;
            background: white;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            transition: all 0.3s ease;
        }

        .schedule-nav button:hover {
            background: #f1f5f9;
        }

        .calendar-grid {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            gap: 10px;
            margin-bottom: 20px;
        }

        .day-header {
            text-align: center;
            font-weight: 600;
            color: #64748b;
            padding: 10px 0;
        }

        .day-cell {
            aspect-ratio: 1;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            padding: 10px;
            background: white;
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
        }

        .day-cell:hover {
            background: #f8fafc;
            border-color: #2563eb;
        }

        .day-cell.today {
            background: #dbeafe;
            border-color: #2563eb;
            font-weight: 600;
        }

        .day-cell.other-month {
            color: #cbd5e1;
        }

        .day-number {
            font-size: 12px;
            margin-bottom: 5px;
        }

        .day-events {
            font-size: 10px;
            color: #10b981;
        }

        .timeline {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        .timeline-item {
            border-left: 4px solid #2563eb;
            padding: 15px;
            background: #f8fafc;
            border-radius: 6px;
        }

        .timeline-time {
            font-weight: 600;
            color: #1e293b;
            margin-bottom: 5px;
        }

        .timeline-title {
            font-size: 14px;
            color: #475569;
            margin-bottom: 3px;
        }

        .timeline-customer {
            font-size: 12px;
            color: #64748b;
        }

        .timeline-item.completed {
            border-left-color: #10b981;
            background: #ecfdf5;
        }

        .timeline-item.in-progress {
            border-left-color: #f59e0b;
            background: #fffbeb;
        }
    </style>
</head>

<body>

<div class="layout">
    <!-- Sidebar -->
    <jsp:include page="../../Component/Sidebar.jsp" />

    <!-- Main Content -->
    <div class="main">
        <!-- TOPBAR -->
        <div class="topbar">
            <div class="topbar-left">
                ☰ &nbsp; SCHEDULE
            </div>
            <div class="topbar-right">
                <span class="bell">🔔</span>
                <div class="profile">
                    <div class="avatar">T</div>
                    <div class="user-info">
                        <div class="name">Technician</div>
                        <div class="email">technician@autofix.com</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- HEADER -->
        <div class="header-row">
            <div class="header-text">
                <h1>My Schedule</h1>
                <p>View your work schedule and appointments</p>
            </div>
        </div>

        <!-- CALENDAR -->
        <div class="schedule-container">
            <div class="schedule-header">
                <h3>March 2026</h3>
                <div class="schedule-nav">
                    <button>&lt; Previous</button>
                    <button>Today</button>
                    <button>Next &gt;</button>
                </div>
            </div>

            <div class="calendar-grid">
                <div class="day-header">Sun</div>
                <div class="day-header">Mon</div>
                <div class="day-header">Tue</div>
                <div class="day-header">Wed</div>
                <div class="day-header">Thu</div>
                <div class="day-header">Fri</div>
                <div class="day-header">Sat</div>

                <div class="day-cell other-month"><div class="day-number">1</div></div>
                <div class="day-cell other-month"><div class="day-number">2</div></div>
                <div class="day-cell other-month"><div class="day-number">3</div></div>
                <div class="day-cell other-month"><div class="day-number">4</div></div>
                <div class="day-cell other-month"><div class="day-number">5</div></div>
                <div class="day-cell other-month"><div class="day-number">6</div></div>
                <div class="day-cell"><div class="day-number">7</div><div class="day-events">2 tasks</div></div>

                <div class="day-cell"><div class="day-number">8</div></div>
                <div class="day-cell"><div class="day-number">9</div></div>
                <div class="day-cell"><div class="day-number">10</div><div class="day-events">1 task</div></div>
                <div class="day-cell"><div class="day-number">11</div></div>
                <div class="day-cell"><div class="day-number">12</div><div class="day-events">3 tasks</div></div>
                <div class="day-cell"><div class="day-number">13</div></div>
                <div class="day-cell"><div class="day-number">14</div></div>

                <div class="day-cell"><div class="day-number">15</div></div>
                <div class="day-cell"><div class="day-number">16</div></div>
                <div class="day-cell"><div class="day-number">17</div><div class="day-events">2 tasks</div></div>
                <div class="day-cell"><div class="day-number">18</div></div>
                <div class="day-cell"><div class="day-number">19</div></div>
                <div class="day-cell"><div class="day-number">20</div></div>
                <div class="day-cell"><div class="day-number">21</div></div>

                <div class="day-cell"><div class="day-number">22</div></div>
                <div class="day-cell"><div class="day-number">23</div></div>
                <div class="day-cell"><div class="day-number">24</div></div>
                <div class="day-cell today"><div class="day-number">25</div><div class="day-events">4 tasks</div></div>
                <div class="day-cell"><div class="day-number">26</div><div class="day-events">2 tasks</div></div>
                <div class="day-cell"><div class="day-number">27</div></div>
                <div class="day-cell"><div class="day-number">28</div></div>

                <div class="day-cell"><div class="day-number">29</div></div>
                <div class="day-cell"><div class="day-number">30</div></div>
                <div class="day-cell"><div class="day-number">31</div></div>
            </div>
        </div>

        <!-- TODAY'S TIMELINE -->
        <div class="schedule-container">
            <h3>Today's Schedule (Mar 25)</h3>
            <div class="timeline">
                <div class="timeline-item">
                    <div class="timeline-time">10:00 AM - 11:00 AM</div>
                    <div class="timeline-title">Oil Change - Toyota Camry</div>
                    <div class="timeline-customer">Customer: Ahmad Faisal</div>
                </div>

                <div class="timeline-item in-progress">
                    <div class="timeline-time">11:30 AM - 1:00 PM</div>
                    <div class="timeline-title">Brake Inspection - Honda CR-V</div>
                    <div class="timeline-customer">Customer: Nurul Huda (Currently Working)</div>
                </div>

                <div class="timeline-item">
                    <div class="timeline-time">2:00 PM - 3:00 PM</div>
                    <div class="timeline-title">AC Service - Nissan X-Trail</div>
                    <div class="timeline-customer">Customer: Siti Aminah</div>
                </div>

                <div class="timeline-item completed">
                    <div class="timeline-time">3:30 PM - 4:00 PM</div>
                    <div class="timeline-title">Battery Check - BMW 3 Series</div>
                    <div class="timeline-customer">Customer: Zahra Rahman (Completed)</div>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>
