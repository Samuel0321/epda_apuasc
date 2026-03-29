<%@page import="java.text.NumberFormat,java.util.List,java.util.Locale,models.ServiceEntity,models.ServiceEntityFacade,models.UsersEntity,utils.EjbLookup"%>
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

    List<ServiceEntity> services;
    if (request.getAttribute("services") != null) {
        services = (List<ServiceEntity>) request.getAttribute("services");
    } else {
        ServiceEntityFacade serviceFacade = EjbLookup.lookup(ServiceEntityFacade.class, "ServiceEntityFacade");
        services = serviceFacade.findAllOrdered();
    }
    NumberFormat currency = NumberFormat.getCurrencyInstance(new Locale("ms", "MY"));
%>
<!DOCTYPE html>
<html>
<head>
    <title>Service Pricing</title>
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
        .form-group textarea,
        .form-group select {
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

        .status-pill {
            display: inline-flex;
            align-items: center;
            padding: 4px 10px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 600;
        }

        .status-active {
            background: #dcfce7;
            color: #166534;
        }

        .status-inactive {
            background: #e2e8f0;
            color: #475569;
        }

        .price {
            font-weight: 700;
            color: #1d4ed8;
        }

        .action-buttons {
            display: flex;
            gap: 8px;
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

        .btn-edit {
            background: #fef3c7;
            color: #92400e;
        }

        .btn-delete {
            background: #fee2e2;
            color: #b91c1c;
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
            max-width: 680px;
            margin: 0 auto;
        }

        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 18px;
        }

        .close-btn {
            border: none;
            background: #e2e8f0;
            border-radius: 10px;
            padding: 8px 10px;
            cursor: pointer;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 14px;
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

        @media (max-width: 860px) {
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
            <jsp:param name="section" value="SERVICE PRICING" />
        </jsp:include>

        <div class="header-row">
            <div class="header-text">
                <h1>Service Pricing</h1>
                <p>Set service prices, edit descriptions, and remove outdated services.</p>
            </div>
            <div class="actions">
                <button class="btn btn-primary" type="button" onclick="openCreateModal()">Add New Service</button>
            </div>
        </div>

        <% if (request.getParameter("created") != null) { %>
            <div class="alert alert-success">Service created successfully.</div>
        <% } else if (request.getParameter("updated") != null) { %>
            <div class="alert alert-success">Service updated successfully.</div>
        <% } else if (request.getParameter("deleted") != null) { %>
            <div class="alert alert-success">Service deleted successfully.</div>
        <% } else if (request.getParameter("error") != null) { %>
            <div class="alert alert-error">The requested service action could not be completed.</div>
        <% } %>

        <div class="table-container">
            <div class="table-header">
                <input id="serviceSearch" type="text" class="search-box" placeholder="Search by service name or description...">
            </div>

            <table id="serviceTable">
                <thead>
                    <tr>
                        <th>Service Name</th>
                        <th>Description</th>
                        <th>Price</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (ServiceEntity service : services) { %>
                    <tr data-id="<%= service.getId() %>"
                        data-name="<%= service.getService_name() %>"
                        data-description="<%= service.getDescription() == null ? "" : service.getDescription() %>"
                        data-price="<%= service.getPrice() == null ? "0.00" : service.getPrice().toPlainString() %>"
                        data-active="<%= service.getActive() != null && service.getActive() == 1 ? "1" : "0" %>">
                        <td><strong><%= service.getService_name() %></strong></td>
                        <td><%= service.getDescription() == null || service.getDescription().isEmpty() ? "-" : service.getDescription() %></td>
                        <td class="price"><%= currency.format(service.getPrice()) %></td>
                        <td>
                            <span class="status-pill <%= service.getActive() != null && service.getActive() == 1 ? "status-active" : "status-inactive" %>">
                                <%= service.getActive() != null && service.getActive() == 1 ? "Active" : "Inactive" %>
                            </span>
                        </td>
                        <td>
                            <div class="action-buttons">
                                <button type="button" class="btn-small btn-edit" onclick="openEditModal(this)">Edit</button>
                                <form method="post" action="<%= request.getContextPath() %>/ManagerServiceServlet" onsubmit="return confirm('Delete this service?');">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="serviceId" value="<%= service.getId() %>">
                                    <button type="submit" class="btn-small btn-delete">Delete</button>
                                </form>
                            </div>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<div id="serviceModal" class="modal">
    <div class="modal-card">
        <div class="modal-header">
            <h3 id="serviceModalTitle">Add Service</h3>
            <button type="button" class="close-btn" onclick="closeServiceModal()">Close</button>
        </div>
        <form method="post" action="<%= request.getContextPath() %>/ManagerServiceServlet">
            <input type="hidden" name="action" id="serviceAction" value="create">
            <input type="hidden" name="serviceId" id="serviceId">
            <div class="form-grid">
                <div class="form-group full-span">
                    <label>Service Name</label>
                    <input type="text" name="service_name" id="serviceName" required>
                </div>
                <div class="form-group full-span">
                    <label>Description</label>
                    <textarea name="description" id="serviceDescription" rows="4"></textarea>
                </div>
                <div class="form-group">
                    <label>Price (RM)</label>
                    <input type="number" name="price" id="servicePrice" min="0" step="0.01" required>
                </div>
                <div class="form-group">
                    <label>Status</label>
                    <select name="active" id="serviceActive">
                        <option value="1">Active</option>
                        <option value="0">Inactive</option>
                    </select>
                </div>
            </div>
            <div class="modal-actions">
                <button type="button" class="btn-small" onclick="closeServiceModal()">Cancel</button>
                <button type="submit" class="btn-small btn-edit" id="serviceSubmit">Save Service</button>
            </div>
        </form>
    </div>
</div>

<script>
    document.getElementById("serviceSearch").addEventListener("input", function () {
        const keyword = this.value.toLowerCase();
        document.querySelectorAll("#serviceTable tbody tr").forEach(function (row) {
            row.style.display = row.innerText.toLowerCase().includes(keyword) ? "" : "none";
        });
    });

    function openCreateModal() {
        document.getElementById("serviceModalTitle").textContent = "Add Service";
        document.getElementById("serviceAction").value = "create";
        document.getElementById("serviceId").value = "";
        document.getElementById("serviceName").value = "";
        document.getElementById("serviceDescription").value = "";
        document.getElementById("servicePrice").value = "";
        document.getElementById("serviceActive").value = "1";
        document.getElementById("serviceSubmit").textContent = "Create Service";
        document.getElementById("serviceModal").classList.add("show");
    }

    function openEditModal(button) {
        const row = button.closest("tr");
        document.getElementById("serviceModalTitle").textContent = "Edit Service";
        document.getElementById("serviceAction").value = "update";
        document.getElementById("serviceId").value = row.dataset.id;
        document.getElementById("serviceName").value = row.dataset.name || "";
        document.getElementById("serviceDescription").value = row.dataset.description || "";
        document.getElementById("servicePrice").value = row.dataset.price || "0.00";
        document.getElementById("serviceActive").value = row.dataset.active || "1";
        document.getElementById("serviceSubmit").textContent = "Save Changes";
        document.getElementById("serviceModal").classList.add("show");
    }

    function closeServiceModal() {
        document.getElementById("serviceModal").classList.remove("show");
    }

    window.addEventListener("click", function (event) {
        const modal = document.getElementById("serviceModal");
        if (event.target === modal) {
            closeServiceModal();
        }
    });
</script>
</body>
</html>
