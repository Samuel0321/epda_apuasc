$content = Get-Content apuasc-war/web/Pages/Customer/MyAppointments.jsp -Raw

$oldWaiting = '<a href="ApproveQuotation.jsp\?id=<%= apt.getAppointment_id\(\) %>" style="text-decoration:none;"><button class="task-btn btn-primary" style="width:100%">Review Quotation</button></a>'
$newWaiting = @""
<div style="display:flex;gap:10px;width:100%">
    <form action="<%= request.getContextPath() %>/CustomerAppointmentActionServlet" method="POST" style="flex:1;margin:0;">
        <input type="hidden" name="action" value="ACCEPT">
        <input type="hidden" name="appointmentId" value="<%= apt.getAppointment_id() %>">
        <button type="submit" class="task-btn btn-primary" style="width:100%">Accept</button>
    </form>
    <form action="<%= request.getContextPath() %>/CustomerAppointmentActionServlet" method="POST" style="flex:1;margin:0;">
        <input type="hidden" name="action" value="REJECT">
        <input type="hidden" name="appointmentId" value="<%= apt.getAppointment_id() %>">
        <button type="submit" class="task-btn" style="width:100%; background:#ef4444; color:white;">Reject</button>
    </form>
</div>
""@

$content = $content -replace $oldWaiting, $newWaiting
$content = $content -replace 'openDetailsModal', 'openAppointmentModal'

$modalHtml = @""
<div id="appointmentModal" class="modal">
    <div class="modal-panel">
        <div class="modal-title">Appointment Details</div>
        <div class="modal-subtitle" id="modalAppointmentId"></div>
        <div class="detail-grid">
            <div class="detail-card"><strong>Date & Time</strong><div id="modalDateTime"></div></div>
            <div class="detail-card"><strong>Status</strong><div id="modalStatus"></div></div>
            <div class="detail-card full-span"><strong>Services</strong><div id="modalService"></div></div>
            <div class="detail-card"><strong>Technician</strong><div id="modalTechnician"></div></div>
            <div class="detail-card"><strong>Total Amount</strong><div id="modalTotal"></div></div>
            <div class="detail-card full-span"><strong>Customer Notes</strong><div id="modalCustomerNote"></div></div>
            <div class="detail-card full-span"><strong>Tech Notes</strong><div id="modalTechnicianNote"></div></div>
            <div class="detail-card full-span"><strong>Staff Comments</strong><div id="modalStaffComment"></div></div>
            <div class="detail-card full-span"><strong>Feedback</strong><div id="modalFeedback"></div></div>
        </div>
        <div class="modal-actions">
            <button class="btn-secondary" onclick="closeAppointmentModal()">Close</button>
        </div>
    </div>
</div>
<script>
""@

$content = $content -replace '<script>', $modalHtml

$content | Set-Content apuasc-war/web/Pages/Customer/MyAppointments.jsp
