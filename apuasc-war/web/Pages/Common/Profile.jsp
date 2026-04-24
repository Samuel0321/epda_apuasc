<%@page import="models.UsersEntity"%>
<%
    UsersEntity profileUser = (UsersEntity) session.getAttribute("user");
    if (profileUser == null) {
        response.sendRedirect(request.getContextPath() + "/loginjsp.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>My Profile</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/Styles/main.css">
    <style>
        .profile-container { background: white; border-radius: 14px; box-shadow: 0 4px 10px rgba(0,0,0,0.05); overflow: hidden; }
        .profile-header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 40px 30px; text-align: center; }
        .profile-avatar { width: 100px; height: 100px; background: rgba(255,255,255,0.2); border: 3px solid white; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 42px; margin: 0 auto 15px; }
        .profile-header h1 { font-size: 28px; margin: 0 0 5px; }
        .profile-header p { opacity: 0.9; font-size: 16px; margin: 0; text-transform: capitalize; }
        .profile-body { padding: 30px; }
        .message { margin-bottom: 20px; padding: 12px 14px; border-radius: 8px; font-size: 14px; }
        .message.success { background: #f0fdf4; color: #166534; border: 1px solid #bbf7d0; }
        .message.error { background: #fee2e2; color: #991b1b; border: 1px solid #fecaca; }
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
        .form-group { margin-bottom: 18px; }
        .form-group.full { grid-column: 1 / -1; }
        .form-group label { display: block; margin-bottom: 8px; font-weight: 500; color: #1e293b; }
        .form-group input, .form-group select { width: 100%; padding: 10px 12px; border: 1px solid #e2e8f0; border-radius: 8px; font-size: 14px; }
        .form-group input:focus, .form-group select:focus { outline: none; border-color: #2563eb; box-shadow: 0 0 0 3px rgba(37,99,235,0.1); }
        .profile-actions { display: flex; gap: 15px; margin-top: 20px; }
        .btn { flex: 1; padding: 12px; border: none; border-radius: 8px; cursor: pointer; font-weight: 600; font-size: 14px; }
        .btn-primary { background: #2563eb; color: white; }
        .btn-secondary { background: #e5e7eb; color: #1e293b; }
        .readonly-box { background: #f8fafc; padding: 12px; border-radius: 8px; border: 1px solid #e2e8f0; color: #475569; }
        .password-help { display: block; color: #ef4444; font-size: 12px; margin-top: 5px; min-height: 16px; }
        .password-help.valid { color: #16a34a; }
        @media (max-width: 768px) { .form-grid { grid-template-columns: 1fr; } }
    </style>
</head>
<body>
<div class="layout">
    <jsp:include page="../../Component/Sidebar.jsp" />
    <div class="main">
        <jsp:include page="../../Component/Topbar.jsp">
            <jsp:param name="section" value="MY PROFILE" />
        </jsp:include>

        <div class="header-row">
            <div class="header-text">
                <h1>My Profile</h1>
                <p>View and update your account information</p>
            </div>
        </div>

        <div class="profile-container">
            <div class="profile-header">
                <div class="profile-avatar"><%= profileUser.getName() != null && !profileUser.getName().isEmpty() ? profileUser.getName().substring(0,1).toUpperCase() : "U" %></div>
                <h1><%= profileUser.getName() %></h1>
                <p><%= profileUser.getRole() != null ? profileUser.getRole().replace("_", " ") : "user" %></p>
            </div>

            <div class="profile-body">
                <% if ("1".equals(request.getParameter("updated"))) { %>
                    <div class="message success">Profile updated successfully.</div>
                <% } %>
                <% if ("WeakPassword".equals(request.getParameter("error"))) { %>
                    <div class="message error">Password must be at least 8 characters and include uppercase, lowercase, number, and special character.</div>
                <% } %>

                <form action="<%= request.getContextPath() %>/UpdateProfileServlet" method="post" onsubmit="return validateOptionalPassword('new_password', 'passwordHelp');">
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="name">Full Name</label>
                            <input type="text" id="name" name="name" value="<%= profileUser.getName() != null ? profileUser.getName() : "" %>" required>
                        </div>
                        <div class="form-group">
                            <label for="email">Email</label>
                            <input type="email" id="email" name="email" value="<%= profileUser.getEmail() != null ? profileUser.getEmail() : "" %>" required>
                        </div>
                        <div class="form-group">
                            <label for="phone">Phone</label>
                            <input type="text" id="phone" name="phone" value="<%= profileUser.getPhone_number() != null ? profileUser.getPhone_number() : "" %>">
                        </div>
                        <div class="form-group">
                            <label for="gender">Gender</label>
                            <select id="gender" name="gender">
                                <option value="">Select Gender</option>
                                <option value="male" <%= "male".equalsIgnoreCase(profileUser.getGender()) ? "selected" : "" %>>Male</option>
                                <option value="female" <%= "female".equalsIgnoreCase(profileUser.getGender()) ? "selected" : "" %>>Female</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="origin_country">Origin Country</label>
                            <input type="text" id="origin_country" name="origin_country" value="<%= profileUser.getOrigin_country() != null ? profileUser.getOrigin_country() : "" %>">
                        </div>
                        <div class="form-group">
                            <label for="identity_number">IC / Passport</label>
                            <input type="text" id="identity_number" name="identity_number" value="<%= profileUser.getIC_number_passportnumber() != null ? profileUser.getIC_number_passportnumber() : "" %>">
                        </div>
                        <div class="form-group full">
                            <label for="home_address">Home Address</label>
                            <input type="text" id="home_address" name="home_address" value="<%= profileUser.getHome_address() != null ? profileUser.getHome_address() : "" %>">
                        </div>
                        <div class="form-group">
                            <label>Role</label>
                            <div class="readonly-box"><%= profileUser.getRole() != null ? profileUser.getRole().replace("_", " ") : "" %></div>
                        </div>
                        <div class="form-group">
                            <label for="new_password">New Password</label>
                            <input type="password" id="new_password" name="new_password" placeholder="Leave blank to keep current password">
                            <span id="passwordHelp" class="password-help"></span>
                        </div>
                    </div>

                    <div class="profile-actions">
                        <button type="button" class="btn btn-secondary" onclick="window.history.back()">Cancel</button>
                        <button type="submit" class="btn btn-primary">Save Profile</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<script>
    document.getElementById("new_password").addEventListener("input", function () {
        updatePasswordHelp(this.value, document.getElementById("passwordHelp"));
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
</script>
</body>
</html>
