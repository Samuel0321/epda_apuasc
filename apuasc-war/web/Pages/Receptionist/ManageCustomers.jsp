<%--
    Document   : ManageCustomers
    Created on : Mar 25, 2026
    Author     : pinju
--%>

<%@page import="java.util.Arrays,java.util.List,models.UsersEntity,models.UsersEntityFacade,utils.EjbLookup"%>
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

    UsersEntityFacade usersFacade = EjbLookup.lookup(UsersEntityFacade.class, "UsersEntityFacade");

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String action = request.getParameter("action");
        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.isEmpty()) {
            Integer cid = Integer.parseInt(idStr);
            UsersEntity c = usersFacade.find(cid);
            if (c != null && c.getRole() != null && "customer".equalsIgnoreCase(c.getRole().trim())) {
                if ("delete".equals(action)) {
                    usersFacade.remove(c);
                    response.sendRedirect("ManageCustomers.jsp?success=deleted");
                    return;
                }
            }
        }
    }

    List<UsersEntity> customers = usersFacade.findByRoles(Arrays.asList("customer"));
%>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Customers</title>
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
            flex-wrap: wrap;
        }

        .search-box {
            flex: 1;
            min-width: 240px;
            padding: 10px 12px;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            font-size: 14px;
        }

        .btn-new {
            padding: 10px 14px;
            border: none;
            border-radius: 8px;
            background: #2563eb;
            color: white;
            font-weight: 500;
            cursor: pointer;
        }

        .btn-new:hover {
            background: #1d4ed8;
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

        .action-buttons {
            display: flex;
            gap: 6px;
            flex-wrap: wrap;
        }

        .btn-small {
            padding: 6px 10px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 12px;
            font-weight: 500;
        }

        .btn-view {
            background: #dbeafe;
            color: #1e40af;
        }

        .btn-edit {
            background: #fef3c7;
            color: #92400e;
        }

        .btn-delete {
            background: #fecaca;
            color: #7f1d1d;
        }
        .message { margin-bottom: 16px; padding: 12px 14px; border-radius: 8px; font-size: 14px; }
        .message.success { background: #dcfce7; color: #166534; }
        .message.error { background: #fee2e2; color: #991b1b; }
    </style>
</head>

<body>

<div class="layout">
    <jsp:include page="../../Component/Sidebar.jsp" />

    <div class="main">
        <jsp:include page="../../Component/Topbar.jsp">
            <jsp:param name="section" value="MANAGE CUSTOMERS" />
        </jsp:include>

        <div class="header-row">
            <div class="header-text">
                <h1>Customer Directory</h1>
                <p>Search, update, and remove customer records</p>
            </div>
        </div>

        <div class="table-container">
            <% if ("deleted".equals(request.getParameter("success"))) { %>
                <div class="message success">Customer record deleted successfully.</div>
            <% } %>
            <% if ("CustomerNotFound".equals(request.getParameter("error"))) { %>
                <div class="message error">The selected customer record could not be found.</div>
            <% } %>
            <div class="table-header">
                <input type="text" class="search-box" placeholder="Search by name, phone, or email...">
                <button class="btn-new" onclick="window.location.href='RegisterCustomer.jsp'">+ Create Customer</button>
            </div>

            <table>
                <thead>
                    <tr>
                        <th>Customer ID</th>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Gender</th>
                        <th>Malaysian</th>
                        <th>Identity</th>
                        <th>Country</th>
                        <th>Address</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (customers == null || customers.isEmpty()) { %>       
                    <tr>
                        <td colspan="10">No customer records found.</td>
                    </tr>
                    <% } else {
                        for (UsersEntity customer : customers) {
                            String customerName = customer.getName() == null ? "-" : customer.getName();
                            String phone = customer.getPhone_number() == null ? "-" : customer.getPhone_number();
                            String email = customer.getEmail() == null ? "-" : customer.getEmail();
                            String address = customer.getHome_address() == null ? "-" : customer.getHome_address();
                            String origin = customer.getOrigin_country() == null ? "-" : customer.getOrigin_country();
                            String gender = customer.getGender() == null ? "-" : customer.getGender();
                            String malaysian = customer.getIs_malaysian() != null && customer.getIs_malaysian() == 1 ? "Yes" : "No";
                            String identity = maskIdentity(customer.getIC_number_passportnumber());
                    %>
                    <tr>
                        <td>#C<%= String.format("%03d", customer.getId()) %></td>
                        <td><%= customerName %></td>
                        <td><%= email %></td>
                        <td><%= phone %></td>
                        <td><%= gender %></td>
                        <td><%= malaysian %></td>
                        <td><%= identity %></td>
                        <td><%= origin %></td>
                        <td><%= address %></td>
                          <td>
                              <div class="action-buttons">
                                  <a href="EditCustomer.jsp?id=<%= customer.getId() %>" class="btn-small btn-edit" style="text-decoration:none; display:inline-block; text-align:center;">Edit Profile</a>
                                <form method="post" style="display:inline;" onsubmit="return confirm('Are you sure you want to delete this customer?');">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="id" value="<%= customer.getId() %>">
                                    <button type="submit" class="btn-small btn-delete">Delete</button>
                                </form>
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
</body>
</html>
<%!
    private String maskIdentity(String value) {
        if (value == null) {
            return "-";
        }
        String trimmed = value.trim();
        if (trimmed.isEmpty()) {
            return "-";
        }
        if (trimmed.length() <= 4) {
            return "****";
        }
        return trimmed.substring(0, 2) + "****" + trimmed.substring(trimmed.length() - 2);
    }
%>
