<%--
    Document   : NewAppointment
    Created on : Mar 24, 2026
    Author     : pinju
--%>

<%@page import="java.util.List,java.util.Arrays,java.util.ArrayList,java.time.LocalDateTime,models.Appointments,models.AppointmentsFacade,models.AppointmentServiceFacade,models.UsersEntity,models.UsersEntityFacade,utils.EjbLookup"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    UsersEntityFacade usersFacade = EjbLookup.lookup(UsersEntityFacade.class, "UsersEntityFacade");
    AppointmentsFacade appointmentsFacade = EjbLookup.lookup(AppointmentsFacade.class, "AppointmentsFacade");
    AppointmentServiceFacade appointmentServiceFacade = EjbLookup.lookup(AppointmentServiceFacade.class, "AppointmentServiceFacade");
    List<UsersEntity> customers = usersFacade.findByRoles(Arrays.asList("customer"));
    List<UsersEntity> technicians = usersFacade.findByRoles(Arrays.asList("technician"));
    List<Appointments> allAppointments = appointmentsFacade.findAllOrdered();
    List<Appointments> reservedTechnicianAppointments = new ArrayList<Appointments>();
    for (Appointments item : allAppointments) {
        if (item == null || item.getTechnician_id() == null || item.getAppointment_date() == null || item.getAppointment_time() == null) {
            continue;
        }
        String status = item.getStatus() == null ? "" : item.getStatus().trim().toUpperCase();
        if (Arrays.asList("ASSIGNED", "WAITING APPROVAL", "ACCEPTED", "DELAYED").contains(status)) {
            reservedTechnicianAppointments.add(item);
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>New Appointment</title>
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

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #1e293b;
        }

        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            font-size: 14px;
            box-sizing: border-box;
            font-family: 'Segoe UI', sans-serif;
        }

        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }

        .form-actions {
            display: flex;
            gap: 10px;
            margin-top: 30px;
        }

        .form-actions button {
            flex: 1;
            padding: 12px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .btn-submit {
            background: #2563eb;
            color: white;
        }

        .btn-submit:hover {
            background: #1d4ed8;
        }

        .btn-cancel {
            background: #e2e8f0;
            color: #1e293b;
        }

        .btn-cancel:hover {
            background: #cbd5e1;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        .info-box {
            margin-top: -8px;
            margin-bottom: 16px;
            padding: 10px 12px;
            border-radius: 8px;
            background: #eff6ff;
            color: #1e40af;
            font-size: 13px;
        }

        .availability {
            margin-top: 8px;
            color: #64748b;
            font-size: 13px;
        }

        @media (max-width: 768px) {
            .form-row {
                grid-template-columns: 1fr;
            }
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
            <jsp:param name="section" value="NEW APPOINTMENT" />
        </jsp:include>

        <!-- HEADER -->
        <div class="header-row">
            <div class="header-text">
                <h1>Create New Appointment</h1>
                <p>Schedule a service appointment for a customer</p>
            </div>
        </div>

        <!-- FORM -->
        <div class="form-container">
            <% String error = request.getParameter("error"); %>
            <% if (error != null) { %>
                <div class="info-box" style="background:#fee2e2;color:#991b1b;">
                    <%
                        if ("PastDateTime".equals(error)) {
                            out.print("Please choose a future appointment date and time.");
                        } else if ("DuplicateSlot".equals(error)) {
                            out.print("This customer already has an appointment in that same slot.");
                        } else if ("TechnicianBusy".equals(error)) {
                            out.print("The selected technician is already busy during that service window. Please choose another technician or time.");
                        } else if ("InvalidTechnician".equals(error)) {
                            out.print("Please choose a valid technician.");
                        } else {
                            out.print("Please complete the required appointment details.");
                        }
                    %>
                </div>
            <% } else if ("1".equals(request.getParameter("created"))) { %>
                <div class="info-box" style="background:#dcfce7;color:#166534;">Appointment created successfully.</div>
            <% } %>

            <form id="appointmentForm" method="post" action="<%= request.getContextPath() %>/ReceptionistAppointmentServlet">
                <div class="form-group">
                    <label for="customer">Customer *</label>
                    <select id="customer" name="customer" required>
                        <option value="">Select Customer</option>
                        <% for (UsersEntity cus : customers) { %>
                        <option value="<%= cus.getId() %>"><%= cus.getName() %> (<%= cus.getEmail() %>)</option>
                        <% } %>
                    </select>
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
                        <option value="">Select Service</option>
                        <option value="minor">Minor Service</option>
                        <option value="major">Major Service</option>
                    </select>
                </div>

                <div class="info-box">
                    Minor service reserves 1 hour. Major service reserves 2 hours. This type is only used for scheduling before the technician prepares the final quotation.
                </div>

                <div class="form-group">
                    <label for="technician">Assign Technician</label>
                    <select id="technician" name="technician">
                        <option value="">Select Technician (Optional initially)</option>
                        <% for (UsersEntity tech : technicians) { %>
                        <option value="<%= tech.getId() %>"><%= tech.getName() %></option>
                        <% } %>
                    </select>
                    <div class="availability" id="technicianAvailabilityMessage">Technicians are filtered using the selected service type duration. Busy technicians are hidden automatically.</div>
                    <textarea id="notes" name="notes" rows="4" placeholder="Add any special requests or notes..."></textarea>
                </div>

                <div class="form-actions">
                    <button type="button" class="btn-cancel" onclick="window.history.back()">Cancel</button>
                    <button type="submit" class="btn-submit">Create Appointment</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        const dateInput = document.getElementById("appointmentDate");
        const timeInput = document.getElementById("appointmentTime");
        const serviceTypeInput = document.getElementById("serviceType");
        const technicianInput = document.getElementById("technician");
        const technicianAvailabilityMessage = document.getElementById("technicianAvailabilityMessage");
        const form = document.querySelector("form");
        const businessStart = "10:00";
        const businessEnd = "16:00";
        const technicianSchedules = {
            <% for (int i = 0; i < technicians.size(); i++) {
                UsersEntity tech = technicians.get(i); %>
            "<%= tech.getId() %>": [
                <% boolean firstSlot = true;
                   for (Appointments item : reservedTechnicianAppointments) {
                       if (!tech.getId().equals(item.getTechnician_id())) {
                           continue;
                       }
                       int durationHours = appointmentsFacade.estimateReservedDurationHours(item);
                       LocalDateTime startDateTime = LocalDateTime.of(item.getAppointment_date(), item.getAppointment_time());
                       LocalDateTime endDateTime = startDateTime.plusHours(Math.max(1, durationHours));
                       if (!firstSlot) { %>,<% }
                       firstSlot = false; %>
                {
                    date: "<%= item.getAppointment_date() %>",
                    start: "<%= item.getAppointment_time() %>",
                    end: "<%= endDateTime.toLocalTime() %>",
                    durationHours: <%= Math.max(1, durationHours) %>
                }
                <% } %>
            ]<%= i < technicians.size() - 1 ? "," : "" %>
            <% } %>
        };

        // Set min date to today
        const today = new Date();
        today.setHours(0, 0, 0, 0);
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

        function parseDateInput(value) {
            if (!value) {
                return null;
            }
            const parts = value.split("-");
            if (parts.length !== 3) {
                return null;
            }
            return new Date(Number(parts[0]), Number(parts[1]) - 1, Number(parts[2]));
        }

        function parseDateTime(dateValue, timeValue) {
            if (!dateValue || !timeValue) {
                return null;
            }
            return new Date(dateValue + "T" + timeValue + ":00");
        }

        function addHours(date, hours) {
            const copy = new Date(date.getTime());
            copy.setHours(copy.getHours() + hours);
            return copy;
        }

        function getRequestedDurationHours() {
            return serviceTypeInput.value === "major" ? 2 : 1;
        }

        function resetTechnicianVisibility() {
            Array.from(technicianInput.options).forEach(function(option, index) {
                if (index === 0) {
                    option.hidden = false;
                    option.disabled = false;
                    return;
                }
                option.hidden = false;
                option.disabled = false;
            });
        }

        function updateTechnicianAvailability() {
            resetTechnicianVisibility();

            if (!dateInput.value || !timeInput.value || !serviceTypeInput.value) {
                technicianAvailabilityMessage.textContent = "Choose date, time, and service type to filter technicians by availability.";
                return;
            }

            const requestedStart = parseDateTime(dateInput.value, timeInput.value);
            if (!requestedStart) {
                return;
            }
            const requestedEnd = addHours(requestedStart, getRequestedDurationHours());
            let availableCount = 0;

            Array.from(technicianInput.options).forEach(function(option, index) {
                if (index === 0 || !option.value) {
                    return;
                }
                const schedules = technicianSchedules[option.value] || [];
                const busy = schedules.some(function(slot) {
                    if (slot.date !== dateInput.value) {
                        return false;
                    }
                    const existingStart = parseDateTime(slot.date, slot.start);
                    const existingEnd = parseDateTime(slot.date, slot.end);
                    return requestedStart < existingEnd && existingStart < requestedEnd;
                });

                option.hidden = busy;
                option.disabled = busy;
                if (!busy) {
                    availableCount++;
                } else if (technicianInput.value === option.value) {
                    technicianInput.value = "";
                }
            });

            if (availableCount === 0) {
                technicianAvailabilityMessage.textContent = "No technician is free for this service window. Please choose another time or leave technician assignment empty for now.";
            } else {
                technicianAvailabilityMessage.textContent = availableCount + " technician(s) available for this " + getRequestedDurationHours() + "-hour service window. Busy technicians are hidden automatically.";
            }
        }

        function validateDateTime() {
            const selectedDate = parseDateInput(dateInput.value);
            if (selectedDate && selectedDate < today) {
                dateInput.setCustomValidity("Date cannot be in the past.");
                dateInput.value = todayStr;
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
            updateTechnicianAvailability();
        }

        buildTimeOptions(businessStart);
        validateDateTime();
        dateInput.addEventListener("change", validateDateTime);
        timeInput.addEventListener("change", validateDateTime);
        serviceTypeInput.addEventListener("change", updateTechnicianAvailability);
        
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



