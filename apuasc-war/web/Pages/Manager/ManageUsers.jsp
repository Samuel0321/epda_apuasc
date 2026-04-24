<%@page import="java.util.List,models.UsersEntity,models.UsersEntityFacade,utils.EjbLookup"%>
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

    List<UsersEntity> directoryUsers;
    boolean canToggleManagerAccess;

    if (request.getAttribute("currentUser") != null) {
        currentUser = (UsersEntity) request.getAttribute("currentUser");
        directoryUsers = request.getAttribute("directoryUsers") != null
                ? (List<UsersEntity>) request.getAttribute("directoryUsers")
                : (List<UsersEntity>) request.getAttribute("staffUsers");
        canToggleManagerAccess = (Boolean) request.getAttribute("canToggleManagerAccess");
    } else {
        UsersEntityFacade userFacade = EjbLookup.lookup(UsersEntityFacade.class, "UsersEntityFacade");
        currentUser = userFacade.find(currentUser.getId());
        directoryUsers = userFacade.findDirectoryUsers();
        canToggleManagerAccess = currentUser.getHave_Manager_access() != null && currentUser.getHave_Manager_access() == 1;
    }
    session.setAttribute("user", currentUser);
%>
<!DOCTYPE html>
<html>
<head>
    <title>User Directory</title>
    <link rel="stylesheet" href="../../Styles/main.css">
    <style>
        .table-container,
        .modal-card {
            background: white;
            padding: 22px;
            border-radius: 18px;
            box-shadow: 0 10px 30px rgba(15, 23, 42, 0.06);
        }

        .table-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
            margin-bottom: 18px;
            flex-wrap: wrap;
        }

        .search-box,
        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #dbe2ea;
            border-radius: 10px;
            box-sizing: border-box;
            font-size: 14px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 14px 12px;
            border-bottom: 1px solid #e2e8f0;
            text-align: left;
            vertical-align: top;
        }

        th {
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 0.04em;
            color: #64748b;
        }

        .role-badge,
        .status-badge {
            display: inline-flex;
            align-items: center;
            padding: 4px 10px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 600;
        }

        .role-badge {
            background: #dbeafe;
            color: #1d4ed8;
        }

        .status-badge {
            background: #dcfce7;
            color: #166534;
        }

        .access-pill {
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .access-toggle-form {
            display: inline-flex;
            align-items: center;
            gap: 10px;
        }

        .switch {
            position: relative;
            display: inline-block;
            width: 54px;
            height: 30px;
        }

        .switch input {
            opacity: 0;
            width: 0;
            height: 0;
        }

        .slider {
            position: absolute;
            inset: 0;
            cursor: pointer;
            background: #cbd5e1;
            transition: 0.2s ease;
            border-radius: 999px;
        }

        .slider:before {
            content: "";
            position: absolute;
            height: 22px;
            width: 22px;
            left: 4px;
            top: 4px;
            background: white;
            transition: 0.2s ease;
            border-radius: 50%;
            box-shadow: 0 2px 6px rgba(15, 23, 42, 0.2);
        }

        .switch input:checked + .slider {
            background: #2563eb;
        }

        .switch input:checked + .slider:before {
            transform: translateX(24px);
        }

        .switch input:disabled + .slider {
            cursor: not-allowed;
            opacity: 0.55;
        }

        .toggle-form,
        .inline-form {
            display: inline;
        }

        .action-buttons {
            display: flex;
            gap: 6px;
            flex-wrap: wrap;
        }

        .btn-small {
            padding: 8px 10px;
            border: none;
            border-radius: 8px;
            font-size: 12px;
            font-weight: 600;
            cursor: pointer;
        }

        .btn-view {
            background: #dbeafe;
            color: #1d4ed8;
        }

        .btn-edit {
            background: #fef3c7;
            color: #92400e;
        }

        .btn-delete {
            background: #fee2e2;
            color: #b91c1c;
        }

        .helper-text {
            color: #64748b;
            font-size: 13px;
            margin-top: 6px;
        }

        .password-help {
            display: block;
            color: #ef4444;
            font-size: 12px;
            margin-top: 5px;
            min-height: 16px;
        }

        .password-help.valid {
            color: #16a34a;
        }

        .access-select {
            max-width: 220px;
        }

        .alert {
            margin-bottom: 18px;
            padding: 12px 14px;
            border-radius: 12px;
            font-size: 14px;
        }

        .alert-success {
            background: #dcfce7;
            color: #166534;
        }

        .alert-error {
            background: #fee2e2;
            color: #991b1b;
        }

        .modal {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(15, 23, 42, 0.45);
            z-index: 1000;
            padding: 30px 16px;
            overflow-y: auto;
        }

        .modal.show {
            display: block;
        }

        .modal-card {
            max-width: 720px;
            margin: 0 auto;
        }

        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 18px;
        }

        .modal-header h3 {
            margin: 0;
        }

        .close-btn {
            border: none;
            background: #e2e8f0;
            border-radius: 10px;
            padding: 8px 10px;
            cursor: pointer;
        }

        .detail-grid,
        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 14px;
        }

        .detail-card {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 14px;
            padding: 14px;
        }

        .detail-card strong {
            display: block;
            margin-bottom: 6px;
        }

        .full-span {
            grid-column: 1 / -1;
        }

        .modal-actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 18px;
        }

        .btn-primary {
            background: #2563eb;
            color: white;
        }

        .btn-secondary {
            background: #e2e8f0;
            color: #1e293b;
        }

        @media (max-width: 900px) {
            .detail-grid,
            .form-grid {
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
            <jsp:param name="section" value="USER DIRECTORY" />
        </jsp:include>

        <div class="header-row">
            <div class="header-text">
                <h1>User Directory</h1>
                <p>View all staff and customers, update profiles, and control manager access for manager-level accounts.</p>
            </div>
            <div class="actions">
                <button class="btn btn-light" onclick="window.location.href='../Common/Profile.jsp'">My Profile</button>
            </div>
        </div>

        <% if (request.getParameter("updated") != null) { %>
            <div class="alert alert-success">User details updated successfully.</div>
        <% } else if (request.getParameter("created") != null) { %>
            <div class="alert alert-success">User account created successfully.</div>
        <% } else if (request.getParameter("deleted") != null) { %>
            <div class="alert alert-success">User account deleted successfully.</div>
        <% } else if (request.getParameter("accessUpdated") != null) { %>
            <div class="alert alert-success">Manager access updated successfully.</div>
        <% } else if ("ProtectedManager".equals(request.getParameter("error"))) { %>
            <div class="alert alert-error">Managers without manager access cannot edit managers who already have manager access.</div>
        <% } else if ("CannotDeleteManager".equals(request.getParameter("error"))) { %>
            <div class="alert alert-error">Managers with manager access cannot be deleted.</div>
        <% } else if ("DeleteSelf".equals(request.getParameter("error"))) { %>
            <div class="alert alert-error">You cannot delete your own account.</div>
        <% } else if ("WeakPassword".equals(request.getParameter("error"))) { %>
            <div class="alert alert-error">Password must be at least 8 characters and include uppercase, lowercase, number, and special character.</div>
        <% } else if (request.getParameter("error") != null) { %>
            <div class="alert alert-error">The requested manager action could not be completed.</div>
        <% } %>

        <div class="table-container">
            <div class="table-header">
                <input id="staffSearch" type="text" class="search-box" placeholder="Search users by name, email, phone, or role...">
                <div class="helper-text">
                    <% if (canToggleManagerAccess) { %>
                        You can toggle manager access for other manager-level accounts.
                    <% } else { %>
                        Manager access controls are disabled for your account.
                    <% } %>
                </div>
                <button class="btn btn-primary" type="button" onclick="window.location.href='<%= request.getContextPath() %>/RegisterServlet'">Register User</button>
            </div>

            <table id="staffTable">
                <thead>
                    <tr>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Role</th>
                        <th>Phone</th>
                        <th>Manager Access</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (UsersEntity staff : directoryUsers) {
                        String staffRole = staff.getRole() == null ? "" : staff.getRole().trim().toLowerCase();
                        boolean managerLike = "manager".equals(staffRole);
                        boolean protectedManager = managerLike && staff.getHave_Manager_access() != null && staff.getHave_Manager_access() == 1;
                    %>
                    <tr class="staff-row"
                        data-name="<%= staff.getName() %>"
                        data-email="<%= staff.getEmail() %>"
                        data-phone="<%= staff.getPhone_number() == null ? "" : staff.getPhone_number() %>"
                        data-role="<%= staff.getRole() %>"
                        data-gender="<%= staff.getGender() == null ? "" : staff.getGender() %>"
                        data-is-malaysian="<%= staff.getIs_malaysian() == null ? "" : staff.getIs_malaysian() %>"
                        data-identity-number="<%= staff.getIC_number_passportnumber() == null ? "" : staff.getIC_number_passportnumber() %>"
                        data-country="<%= staff.getOrigin_country() == null ? "" : staff.getOrigin_country() %>"
                        data-country-code="<%= staff.getCountry_code() == null ? "" : staff.getCountry_code() %>"
                        data-address="<%= staff.getHome_address() == null ? "" : staff.getHome_address() %>"
                        data-manager-access="<%= staff.getHave_Manager_access() != null && staff.getHave_Manager_access() == 1 ? "1" : "0" %>">
                        <td><strong><%= staff.getName() %></strong></td>
                        <td><%= staff.getEmail() %></td>
                        <td><span class="role-badge"><%= staff.getRole() %></span></td>
                        <td><%= staff.getPhone_number() == null || staff.getPhone_number().isEmpty() ? "-" : staff.getPhone_number() %></td>
                        <td>
                            <% if (managerLike) { %>
                                <div class="access-pill">
                                    <form class="access-toggle-form" method="post" action="<%= request.getContextPath() %>/ManagerUserServlet">
                                        <input type="hidden" name="action" value="toggleManagerAccess">
                                        <input type="hidden" name="userId" value="<%= staff.getId() %>">
                                        <label class="switch" title="<%= canToggleManagerAccess && !staff.getId().equals(currentUser.getId()) ? "Toggle manager access" : "Manager access toggle unavailable" %>">
                                            <input type="checkbox"
                                                   <%= staff.getHave_Manager_access() != null && staff.getHave_Manager_access() == 1 ? "checked" : "" %>
                                                   <%= (!canToggleManagerAccess || staff.getId().equals(currentUser.getId())) ? "disabled" : "" %>
                                                   onchange="this.form.submit()">
                                            <span class="slider"></span>
                                        </label>
                                    </form>
                                    <span><%= staff.getHave_Manager_access() != null && staff.getHave_Manager_access() == 1 ? "Enabled" : "Disabled" %></span>
                                </div>
                            <% } else { %>
                                <span class="helper-text">Not applicable</span>
                            <% } %>
                        </td>
                        <td>
                            <div class="action-buttons">
                                <button type="button" class="btn-small btn-view" onclick="openViewModal(this)">View</button>
                                <button type="button" class="btn-small btn-edit" onclick="openEditModal(this, '<%= staff.getId() %>')">Edit</button>
                                <% if (!staff.getId().equals(currentUser.getId()) && !protectedManager) { %>
                                <form class="inline-form" method="post" action="<%= request.getContextPath() %>/ManagerUserServlet" onsubmit="return confirm('Delete this user account? This action cannot be undone.');">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="userId" value="<%= staff.getId() %>">
                                    <button type="submit" class="btn-small btn-delete">Delete</button>
                                </form>
                                <% } %>
                            </div>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<div id="viewModal" class="modal">
    <div class="modal-card">
        <div class="modal-header">
            <h3>User Profile</h3>
            <button class="close-btn" type="button" onclick="closeModal('viewModal')">Close</button>
        </div>
            <div class="detail-grid">
                <div class="detail-card"><strong>Name</strong><span id="viewName"></span></div>
                <div class="detail-card"><strong>Email</strong><span id="viewEmail"></span></div>
                <div class="detail-card"><strong>Role</strong><span id="viewRole"></span></div>
                <div class="detail-card"><strong>Phone</strong><span id="viewPhone"></span></div>
                <div class="detail-card"><strong>Gender</strong><span id="viewGender"></span></div>
                <div class="detail-card"><strong>Is Malaysian</strong><span id="viewMalaysian"></span></div>
                <div class="detail-card"><strong>IC / Passport Number</strong><span id="viewIdentityNumber"></span></div>
                <div class="detail-card"><strong>Country Code</strong><span id="viewCountryCode"></span></div>
                <div class="detail-card"><strong>Manager Access</strong><span id="viewManagerAccess"></span></div>
                <div class="detail-card full-span"><strong>Country</strong><span id="viewCountry"></span></div>
                <div class="detail-card full-span"><strong>Address</strong><span id="viewAddress"></span></div>
            </div>
    </div>
</div>

<div id="editModal" class="modal">
    <div class="modal-card">
        <div class="modal-header">
            <h3>Edit User</h3>
            <button class="close-btn" type="button" onclick="closeModal('editModal')">Close</button>
        </div>
        <form method="post" action="<%= request.getContextPath() %>/ManagerUserServlet" onsubmit="return validateOptionalPassword('editPassword', 'editPasswordHelp');">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="userId" id="editUserId">
            <div class="form-grid">
                <div class="form-group">
                    <label>Name</label>
                    <input type="text" name="name" id="editName" required>
                </div>
                <div class="form-group">
                    <label>Email</label>
                    <input type="email" name="email" id="editEmail" required>
                </div>
                <div class="form-group">
                    <label>Phone</label>
                    <input type="text" name="phone" id="editPhone">
                </div>
                <div class="form-group">
                    <label>Role</label>
                    <input type="text" id="editRole" readonly>
                    <div class="helper-text">Managers can edit profile details here, but role changes are disabled.</div>
                </div>
                <div class="form-group">
                    <label>Gender</label>
                    <select name="gender" id="editGender">
                        <option value="">Select Gender</option>
                        <option value="male">Male</option>
                        <option value="female">Female</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Is Malaysian</label>
                    <select name="is_malaysian" id="editIsMalaysian">
                        <option value="">Select Option</option>
                        <option value="1">Yes</option>
                        <option value="0">No</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>IC / Passport Number</label>
                    <input type="text" name="identity_number" id="editIdentityNumber">
                </div>
                <div class="form-group">
                    <label>Origin Country</label>
                    <input type="text" name="origin_country" id="editCountry">
                </div>
                <div class="form-group">
                    <label>Country Code</label>
                    <input type="number" name="country_code" id="editCountryCode">
                </div>
                <div class="form-group full-span">
                    <label>Home Address</label>
                    <textarea name="home_address" id="editAddress" rows="3"></textarea>
                </div>
                <div class="form-group full-span">
                    <label>Reset Password</label>
                    <input type="password" name="new_password" id="editPassword" placeholder="Leave blank to keep current password">
                    <span id="editPasswordHelp" class="password-help"></span>
                </div>
                <div class="form-group full-span">
                    <label>Manager Access</label>
                    <input type="text" id="editManagerAccessDisplay" value="Use the toggle in the table to change manager access." readonly>
                    <div class="helper-text">Manager access can only be changed from the toggle in the user directory table.</div>
                </div>
            </div>
            <div class="modal-actions">
                <button type="button" class="btn-small btn-secondary" onclick="closeModal('editModal')">Cancel</button>
                <button type="submit" class="btn-small btn-primary">Save Changes</button>
            </div>
        </form>
    </div>
</div>

<script>
    document.getElementById("staffSearch").addEventListener("input", function () {
        const keyword = this.value.toLowerCase();
        document.querySelectorAll("#staffTable tbody tr").forEach(function (row) {
            row.style.display = row.innerText.toLowerCase().includes(keyword) ? "" : "none";
        });
    });

    function openViewModal(button) {
        const row = button.closest("tr");
        document.getElementById("viewName").textContent = row.dataset.name || "-";
        document.getElementById("viewEmail").textContent = row.dataset.email || "-";
        document.getElementById("viewRole").textContent = row.dataset.role || "-";
        document.getElementById("viewPhone").textContent = row.dataset.phone || "-";
        document.getElementById("viewGender").textContent = row.dataset.gender || "-";
        document.getElementById("viewMalaysian").textContent =
            row.dataset.isMalaysian === "1" ? "Yes" : (row.dataset.isMalaysian === "0" ? "No" : "-");
        document.getElementById("viewIdentityNumber").textContent = row.dataset.identityNumber || "-";
        document.getElementById("viewCountryCode").textContent = row.dataset.countryCode || "-";
        document.getElementById("viewCountry").textContent = row.dataset.country || "-";
        document.getElementById("viewAddress").textContent = row.dataset.address || "-";
        document.getElementById("viewManagerAccess").textContent = row.dataset.managerAccess === "1" ? "Enabled" : "Disabled";
        document.getElementById("viewModal").classList.add("show");
    }

    function openEditModal(button, userId) {
        const row = button.closest("tr");
        document.getElementById("editUserId").value = userId;
        document.getElementById("editName").value = row.dataset.name || "";
        document.getElementById("editEmail").value = row.dataset.email || "";
        document.getElementById("editPhone").value = row.dataset.phone || "";
        document.getElementById("editRole").value = row.dataset.role || "";
        document.getElementById("editGender").value = row.dataset.gender || "";
        document.getElementById("editIsMalaysian").value = row.dataset.isMalaysian || "";
        document.getElementById("editIdentityNumber").value = row.dataset.identityNumber || "";
        document.getElementById("editCountry").value = row.dataset.country || "";
        document.getElementById("editCountryCode").value = row.dataset.countryCode || "";
        document.getElementById("editAddress").value = row.dataset.address || "";
        document.getElementById("editPassword").value = "";
        document.getElementById("editPasswordHelp").textContent = "";
        document.getElementById("editPasswordHelp").classList.remove("valid");
        document.getElementById("editManagerAccessDisplay").value =
            row.dataset.managerAccess === "1" ? "Enabled in table toggle" : "Disabled in table toggle";

        document.getElementById("editModal").classList.add("show");
    }

    function closeModal(id) {
        document.getElementById(id).classList.remove("show");
    }

    document.getElementById("editPassword").addEventListener("input", function () {
        updatePasswordHelp(this.value, document.getElementById("editPasswordHelp"));
    });

    function validateOptionalPassword(inputId, helpId) {
        const password = document.getElementById(inputId).value;
        if (password.length === 0) {
            return true;
        }
        return updatePasswordHelp(password, document.getElementById(helpId));
    }

    function updatePasswordHelp(password, helpText) {
        const strongRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^\w\s]).{8,}$/;
        if (password.length === 0) {
            helpText.textContent = "";
            helpText.classList.remove("valid");
            return true;
        }
        if (!strongRegex.test(password)) {
            helpText.textContent = "At least 8 chars, uppercase, lowercase, number, and special character";
            helpText.classList.remove("valid");
            return false;
        }
        helpText.textContent = "Strong password";
        helpText.classList.add("valid");
        return true;
    }

    window.addEventListener("click", function (event) {
        document.querySelectorAll(".modal").forEach(function (modal) {
            if (event.target === modal) {
                modal.classList.remove("show");
            }
        });
    });
</script>
</body>
</html>
