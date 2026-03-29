<%@page import="models.UsersEntity,models.UsersEntityFacade,utils.EjbLookup"%>
<%
    UsersEntity currentUser = (UsersEntity) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/loginjsp.jsp");
        return;
    }

    UsersEntityFacade userFacade = EjbLookup.lookup(UsersEntityFacade.class, "UsersEntityFacade");
    currentUser = userFacade.find(currentUser.getId());
    session.setAttribute("user", currentUser);
%>
<!DOCTYPE html>
<html>
<head>
    <title>Book Appointment</title>
    <link rel="stylesheet" href="../../Styles/main.css">
    <style>
        .form-container {
            width: 100%;
            max-width: none;
            background: white;
            padding: 30px;
            border-radius: 14px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
        }

        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; margin-bottom: 8px; font-weight: 500; color: #1e293b; }
        .form-group input, .form-group select, .form-group textarea {
            width: 100%; padding: 10px 12px; border: 1px solid #e2e8f0; border-radius: 8px;
            font-size: 14px; box-sizing: border-box; font-family: 'Segoe UI', sans-serif;
        }
        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
        .info-box {
            margin-top: -8px; margin-bottom: 16px; padding: 10px 12px; border-radius: 8px;
            background: #eff6ff; color: #1e40af; font-size: 13px;
        }
        .availability { margin-top: 8px; color: #64748b; font-size: 13px; }
        .form-actions { display: flex; gap: 10px; margin-top: 30px; }
        .form-actions button {
            flex: 1; padding: 12px; border: none; border-radius: 8px; cursor: pointer;
            font-weight: 500; transition: all 0.3s ease;
        }
        .btn-submit { background: #2563eb; color: white; }
        .btn-cancel { background: #e2e8f0; color: #1e293b; }
        .alert { margin-bottom: 18px; padding: 12px 14px; border-radius: 12px; font-size: 14px; }
        .alert-error { background: #fee2e2; color: #991b1b; }
        .alert-success { background: #dcfce7; color: #166534; }
        @media (max-width: 768px) { .form-row { grid-template-columns: 1fr; } }
    </style>
</head>
<body>
<div class="layout">
    <jsp:include page="../../Component/Sidebar.jsp" />

    <div class="main">
        <jsp:include page="../../Component/Topbar.jsp">
            <jsp:param name="section" value="BOOK APPOINTMENT" />
        </jsp:include>

        <div class="header-row">
            <div class="header-text">
                <h1>Book Appointment</h1>
                <p>Choose only the initial service type here. The technician will inspect the vehicle later and prepare the quotation and detailed services for you to accept or reject.</p>
            </div>
        </div>

        <% String error = request.getParameter("error"); %>
        <% if (error != null) { %>
            <div class="alert alert-error">
                <%
                    if ("PastDateTime".equals(error)) {
                        out.print("Please choose a future appointment date and time.");
                    } else if ("DuplicateSlot".equals(error)) {
                        out.print("You already have an appointment at that same date and time. Please choose another slot.");
                    } else if ("ServiceRequired".equals(error)) {
                        out.print("Please choose a service type before submitting the booking.");
                    } else {
                        out.print("Please complete the required booking fields before submitting.");
                    }
                %>
            </div>
        <% } %>

        <div class="form-container">
            <form method="post" action="<%= request.getContextPath() %>/CustomerBookingServlet">
                <div class="form-group">
                    <label for="customer">Customer Name</label>
                    <input type="text" id="customer" name="customer" value="<%= currentUser.getName() %>" readonly>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="appointmentDate">Appointment Date *</label>
                        <input type="date" id="appointmentDate" name="appointmentDate" min="<%= java.time.LocalDate.now() %>" required>
                    </div>
                    <div class="form-group">
                        <label for="appointmentTime">Appointment Time *</label>
                        <select id="appointmentTime" name="appointmentTime" required>
                            <option value="">Select Appointment Time</option>
                        </select>
                        <div class="availability">Available booking time is from 10:00 AM to 4:00 PM. Past time slots for today are hidden automatically.</div>
                    </div>
                </div>

                <div class="form-group">
                    <label for="serviceType">Service Type *</label>
                    <select id="serviceType" name="serviceType" required>
                        <option value="">Select Service Type</option>
                        <option value="minor">Minor Service (Est. 1h)</option>
                        <option value="major">Major Service (Est. 3h)</option>
                    </select>
                </div>
                <div class="info-box">
                    Booking only uses two appointment types: Minor Service for a 1-hour slot, or Major Service for a 3-hour slot. Detailed quoted services are added later by the technician.
                </div>

                <div class="form-group">
                    <label for="notes">Booking Notes</label>
                    <textarea id="notes" name="notes" rows="5" placeholder="Add your issue description or special requests..."></textarea>
                </div>

                <div class="form-actions">
                    <button type="button" class="btn-cancel" onclick="window.location.href='../../Dashboard/CustomerDashboard.jsp'">Cancel</button>
                    <button type="submit" class="btn-submit">Submit Booking</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        const dateInput = document.getElementById("appointmentDate");
        const timeInput = document.getElementById("appointmentTime");
        const form = document.querySelector("form");
        const businessStart = "10:00";
        const businessEnd = "16:00";

        // Set min date to today
        const today = new Date();
        const yyyy = today.getFullYear();
        const mm = String(today.getMonth() + 1).padStart(2, '0');
        const dd = String(today.getDate()).padStart(2, '0');
        const todayStr = yyyy + "-" + mm + "-" + dd;
        dateInput.min = todayStr;

        function buildTimeOptions(minTime) {
            const previousValue = timeInput.value;
            timeInput.innerHTML = '<option value="">Select Appointment Time</option>';

            for (let hour = 10; hour <= 16; hour++) {
                for (let minute = 0; minute < 60; minute += 15) {
                    const value = String(hour).padStart(2, '0') + ":" + String(minute).padStart(2, '0');
                    if (value > businessEnd) {
                        continue;
                    }
                    if (minTime && value < minTime) {
                        continue;
                    }

                    const option = document.createElement("option");
                    option.value = value;
                    option.textContent = formatTimeLabel(hour, minute);
                    if (value === previousValue) {
                        option.selected = true;
                    }
                    timeInput.appendChild(option);
                }
            }
        }

        function formatTimeLabel(hour, minute) {
            const suffix = hour >= 12 ? "PM" : "AM";
            const displayHour = hour % 12 === 0 ? 12 : hour % 12;
            return displayHour + ":" + String(minute).padStart(2, '0') + " " + suffix;
        }

        function roundUpToQuarter(date) {
            const rounded = new Date(date.getTime());
            rounded.setSeconds(0, 0);
            const minutes = rounded.getMinutes();
            const remainder = minutes % 15;
            if (remainder !== 0) {
                rounded.setMinutes(minutes + (15 - remainder));
            }
            return String(rounded.getHours()).padStart(2, '0') + ":" + String(rounded.getMinutes()).padStart(2, '0');
        }

        function validateDateTime() {
            if (dateInput.value < todayStr) {
                dateInput.setCustomValidity("Date cannot be in the past.");
            } else {
                dateInput.setCustomValidity("");
            }

            if (dateInput.value === todayStr) {
                const minTimeStr = roundUpToQuarter(new Date());
                buildTimeOptions(minTimeStr > businessStart ? minTimeStr : businessStart);
                
                if (timeInput.value && timeInput.value < minTimeStr) {
                    timeInput.setCustomValidity("Time cannot be in the past for today's appointments.");
                } else if (timeInput.value && timeInput.value > businessEnd) {
                    timeInput.setCustomValidity("Time must be within business hours.");
                } else if (timeInput.options.length <= 1) {
                    timeInput.setCustomValidity("No appointment time is left for today. Please choose another date.");
                } else {
                    timeInput.setCustomValidity("");
                }
            } else {
                buildTimeOptions(businessStart);
                timeInput.setCustomValidity("");
            }
        }

        buildTimeOptions(businessStart);
        dateInput.addEventListener("change", validateDateTime);
        timeInput.addEventListener("change", validateDateTime);
        
        form.addEventListener("submit", function(e) {
            validateDateTime();
            if (!form.checkValidity()) {
                e.preventDefault();
                form.reportValidity();
            }
        });
    });
</script>
</body>
</html>
