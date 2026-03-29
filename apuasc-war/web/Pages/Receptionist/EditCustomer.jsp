<%@page import="models.UsersEntity,models.UsersEntityFacade,utils.EjbLookup"%>
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
    Integer customerId = null;
    try {
        customerId = request.getParameter("id") == null || request.getParameter("id").trim().isEmpty()
                ? null : Integer.valueOf(request.getParameter("id").trim());
    } catch (NumberFormatException ex) {
        customerId = null;
    }

    UsersEntity customer = customerId == null ? null : usersFacade.find(customerId);
    if (customer == null || customer.getRole() == null || !"customer".equalsIgnoreCase(customer.getRole().trim())) {
        response.sendRedirect(request.getContextPath() + "/Pages/Receptionist/ManageCustomers.jsp?error=CustomerNotFound");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Customer Profile</title>
    <link rel="stylesheet" href="../../Styles/main.css">
    <style>
        .profile-container { background: white; border-radius: 14px; box-shadow: 0 4px 10px rgba(0,0,0,0.05); overflow: hidden; }
        .profile-header { background: linear-gradient(135deg, #0f766e 0%, #115e59 100%); color: white; padding: 36px 30px; text-align: center; }
        .profile-avatar { width: 96px; height: 96px; background: rgba(255,255,255,0.18); border: 3px solid white; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 40px; margin: 0 auto 15px; }
        .profile-header h1 { font-size: 28px; margin: 0 0 6px; }
        .profile-header p { margin: 0; opacity: 0.92; }
        .profile-body { padding: 30px; }
        .message { margin-bottom: 20px; padding: 12px 14px; border-radius: 8px; font-size: 14px; }
        .message.success { background: #dcfce7; color: #166534; border: 1px solid #bbf7d0; }
        .message.error { background: #fee2e2; color: #991b1b; border: 1px solid #fecaca; }
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
        .form-group { margin-bottom: 18px; }
        .form-group.full { grid-column: 1 / -1; }
        .form-group label { display: block; margin-bottom: 8px; font-weight: 500; color: #1e293b; }
        .form-group input, .form-group select { width: 100%; padding: 10px 12px; border: 1px solid #e2e8f0; border-radius: 8px; font-size: 14px; box-sizing: border-box; }
        .readonly-box { background: #f8fafc; padding: 12px; border-radius: 8px; border: 1px solid #e2e8f0; color: #475569; }
        .profile-actions { display: flex; gap: 15px; margin-top: 20px; }
        .btn { flex: 1; padding: 12px; border: none; border-radius: 8px; cursor: pointer; font-weight: 600; font-size: 14px; }
        .btn-primary { background: #0f766e; color: white; }
        .btn-secondary { background: #e5e7eb; color: #1e293b; }
        @media (max-width: 768px) { .form-grid { grid-template-columns: 1fr; } }
    </style>
</head>
<body>
<div class="layout">
    <jsp:include page="../../Component/Sidebar.jsp" />
    <div class="main">
        <jsp:include page="../../Component/Topbar.jsp">
            <jsp:param name="section" value="CUSTOMER PROFILE" />
        </jsp:include>

        <div class="header-row">
            <div class="header-text">
                <h1>Edit Customer Profile</h1>
                <p>Receptionist can manage the full customer profile from here.</p>
            </div>
        </div>

        <div class="profile-container">
            <div class="profile-header">
                <div class="profile-avatar"><%= customer.getName() != null && !customer.getName().isEmpty() ? customer.getName().substring(0, 1).toUpperCase() : "C" %></div>
                <h1><%= customer.getName() == null ? "Customer" : customer.getName() %></h1>
                <p>Customer ID #C<%= String.format("%03d", customer.getId()) %></p>
            </div>

            <div class="profile-body">
                <% if ("1".equals(request.getParameter("updated"))) { %>
                    <div class="message success">Customer profile updated successfully.</div>
                <% } %>
                <% if ("DuplicateEmail".equals(request.getParameter("error"))) { %>
                    <div class="message error">That email is already used by another account.</div>
                <% } %>

                <form action="<%= request.getContextPath() %>/ReceptionistCustomerProfileServlet" method="post">
                    <input type="hidden" name="customerId" value="<%= customer.getId() %>">
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="name">Full Name</label>
                            <input type="text" id="name" name="name" value="<%= customer.getName() == null ? "" : customer.getName() %>" required>
                        </div>
                        <div class="form-group">
                            <label for="email">Email</label>
                            <input type="email" id="email" name="email" value="<%= customer.getEmail() == null ? "" : customer.getEmail() %>" required>
                        </div>
                        <div class="form-group">
                            <label for="phone">Phone Number</label>
                            <input type="text" id="phone" name="phone" value="<%= customer.getPhone_number() == null ? "" : customer.getPhone_number() %>">
                        </div>
                        <div class="form-group">
                            <label for="gender">Gender</label>
                            <select id="gender" name="gender">
                                <option value="">Select Gender</option>
                                <option value="male" <%= "male".equalsIgnoreCase(customer.getGender()) ? "selected" : "" %>>Male</option>
                                <option value="female" <%= "female".equalsIgnoreCase(customer.getGender()) ? "selected" : "" %>>Female</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="is_malaysian">Is Malaysian</label>
                            <select id="is_malaysian" name="is_malaysian">
                                <option value="">Select Option</option>
                                <option value="1" <%= customer.getIs_malaysian() != null && customer.getIs_malaysian() == 1 ? "selected" : "" %>>Yes</option>
                                <option value="0" <%= customer.getIs_malaysian() != null && customer.getIs_malaysian() == 0 ? "selected" : "" %>>No</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="identity_number">IC / Passport Number</label>
                            <input type="text" id="identity_number" name="identity_number" value="<%= customer.getIC_number_passportnumber() == null ? "" : customer.getIC_number_passportnumber() %>">
                        </div>
                        <div class="form-group">
                            <label for="origin_country">Origin Country</label>
                            <input type="text" id="origin_country" name="origin_country" value="<%= customer.getOrigin_country() == null ? "" : customer.getOrigin_country() %>">
                        </div>
                        <div class="form-group">
                            <label for="country_code">Country Code</label>
                            <input type="number" id="country_code" name="country_code" value="<%= customer.getCountry_code() == null ? "" : customer.getCountry_code() %>">
                        </div>
                        <div class="form-group full">
                            <label for="home_address">Home Address</label>
                            <input type="text" id="home_address" name="home_address" value="<%= customer.getHome_address() == null ? "" : customer.getHome_address() %>">
                        </div>
                        <div class="form-group">
                            <label>Role</label>
                            <div class="readonly-box">customer</div>
                        </div>
                        <div class="form-group">
                            <label for="new_password">Reset Password</label>
                            <input type="password" id="new_password" name="new_password" placeholder="Leave blank to keep current password">
                        </div>
                    </div>

                    <div class="profile-actions">
                        <button type="button" class="btn btn-secondary" onclick="window.location.href='ManageCustomers.jsp'">Back</button>
                        <button type="submit" class="btn btn-primary">Save Customer</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
</body>
</html>
