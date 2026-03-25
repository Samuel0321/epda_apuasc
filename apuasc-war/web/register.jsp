<%-- 
    Document   : register
    Created on : Mar 22, 2026, 3:37:15 PM
    Author     : Samuel Chong
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>User Registration - AutoFix Pro</title>
        <style>
            * {
                box-sizing: border-box;
            }
            
            html, body {
                margin: 0;
                padding: 0;
                height: 100%;
                width: 100%;
            }
            
            body {
                font-family: 'Segoe UI', sans-serif;
                background: #f5f7fb;
            }
            
            .container {
                width: 100%;
                margin: 0 auto;
                padding: 40px 20px;
                max-width: 900px;
            }
            
            .page-header {
                text-align: center;
                margin-bottom: 40px;
            }
            
            .page-header h1 {
                color: #1e293b;
                margin: 0 0 10px 0;
                font-size: 32px;
            }
            
            .page-header p {
                color: #64748b;
                margin: 0;
                font-size: 16px;
            }
            
            .form-wrapper {
                background: white;
                padding: 40px;
                border-radius: 14px;
                box-shadow: 0 4px 10px rgba(0,0,0,0.05);
            }
            
            .form-grid {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 20px;
            }
            
            .form-group {
                display: flex;
                flex-direction: column;
            }
            
            .form-group.full {
                grid-column: 1 / -1;
            }
            
            .form-group label {
                display: block;
                margin-bottom: 8px;
                font-weight: 500;
                color: #1e293b;
                font-size: 14px;
            }
            
            .form-group input,
            .form-group select {
                padding: 10px 12px;
                border: 1px solid #e2e8f0;
                border-radius: 8px;
                font-size: 14px;
                font-family: 'Segoe UI', sans-serif;
                transition: all 0.3s ease;
            }
            
            .form-group input:focus,
            .form-group select:focus {
                outline: none;
                border-color: #2563eb;
                box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
            }
            
            .form-group input[type="text"],
            .form-group input[type="email"],
            .form-group input[type="password"],
            .form-group select {
                width: 100%;
            }
            
            .password-help {
                color: #ef4444;
                font-size: 12px;
                margin-top: 5px;
                min-height: 16px;
            }
            
            .password-help.valid {
                color: #22c55e;
            }
            
            .form-actions {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 15px;
                margin-top: 30px;
            }
            
            button {
                padding: 12px 20px;
                border: none;
                border-radius: 8px;
                cursor: pointer;
                font-weight: 500;
                transition: all 0.3s ease;
                font-size: 14px;
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
            
            .login-link {
                text-align: center;
                margin-top: 20px;
                color: #64748b;
                font-size: 14px;
            }
            
            .login-link a {
                color: #2563eb;
                text-decoration: none;
                font-weight: 500;
            }
            
            .login-link a:hover {
                text-decoration: underline;
            }
        </style>
    </head> 
    <body>
        <div class="container">
            <div class="page-header">
                <h1>🔧 AutoFix Pro</h1>
                <p>Create Your Account</p>
            </div>
            
            <div class="form-wrapper">
                <form action="RegisterServlet" method="post">
                    <div class="form-grid">
                        <!-- Name -->
                        <div class="form-group">
                            <label for="name">Full Name *</label>
                            <input type="text" id="name" name="name" maxlength="255" required>
                        </div>

                        <!-- Email -->
                        <div class="form-group">
                            <label for="email">Email Address *</label>
                            <input type="email" id="email" name="email" maxlength="255" required>
                        </div>

                        <!-- Password -->
                        <div class="form-group">
                            <label for="password">Password *</label>
                            <input type="password" id="password" name="password" maxlength="255" required>
                            <span id="passwordHelp" class="password-help"></span>
                        </div>

                        <!-- Gender -->
                        <div class="form-group">
                            <label for="gender">Gender *</label>
                            <select id="gender" name="gender" required>
                                <option value="">Select Gender</option>
                                <option value="male">Male</option>
                                <option value="female">Female</option>
                            </select>
                        </div>

                        <!-- Malaysian Selection -->
                        <div class="form-group">
                            <label for="is_malaysian">Are you Malaysian? *</label>
                            <select id="is_malaysian" name="is_malaysian" onchange="toggleIdentityField()" required>
                                <option value="">Select Option</option>
                                <option value="1">Yes</option>
                                <option value="0">No</option>
                            </select>
                        </div>

                        <!-- Identity Field (Dynamic) -->
                        <div id="identityField" class="form-group"></div>

                        <!-- Phone -->
                        <div class="form-group">
                            <label for="phone">Phone Number</label>
                            <input type="text" id="phone" name="phone" maxlength="50">
                        </div>

                        <!-- Country -->
                        <div class="form-group">
                            <label for="origin_country">Origin Country *</label>
                            <select id="origin_country" name="origin_country" onchange="setCountryCode(this)" required>
                                <option value="">Select Country</option>
                                <c:forEach var="c" items="${countries}">
                                    <option value="${c.name}" data-code="${c.code}">${c.name} (+${c.code})</option>
                                </c:forEach>
                            </select>
                        </div>

                        <!-- Address -->
                        <div class="form-group full">
                            <label for="user_address">Address</label>
                            <input type="text" id="user_address" name="user_address" maxlength="255">
                        </div>

                        <!-- Role -->
                        <div class="form-group">
                            <label for="role">Account Type *</label>
                            <select id="role" name="role" onchange="setAccessValues()" required>
                                <option value="">Select Account Type</option>
                                <option value="customer">Customer</option>
                                <option value="technician">Technician</option>
                                <option value="counter_staff">Counter Staff</option>
                                <option value="manager">Manager</option>
                                <option value="super_admin">Super Administrator</option>
                            </select>
                        </div>

                        <!-- Hidden fields -->
                        <input type="hidden" id="country_code" name="country_code">
                        <input type="hidden" id="manager_access" name="manager_access" value="0">
                        <input type="hidden" id="is_super_admin" name="is_super_admin" value="0">
                    </div>

                    <!-- Form Actions -->
                    <div class="form-actions">
                        <button type="submit" class="btn-submit">Create Account</button>
                        <button type="button" class="btn-cancel" onclick="window.location.href='loginjsp.jsp'">Back to Login</button>
                    </div>
                </form>
                
                <div class="login-link">
                    Already have an account? <a href="loginjsp.jsp">Sign in here</a>
                </div>
            </div>
        </div>

        <script>
            document.getElementById("password").addEventListener("input", function() {
                const password = this.value;
                const helpText = document.getElementById("passwordHelp");
                const strongRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/;

                if (password.length === 0) {
                    helpText.textContent = "";
                    helpText.classList.remove("valid");
                } else if (!strongRegex.test(password)) {
                    helpText.textContent = "At least 8 chars, uppercase, lowercase, number, and special character";
                    helpText.classList.remove("valid");
                } else {
                    helpText.textContent = "Strong password ✓";
                    helpText.classList.add("valid");
                }
            });

            function toggleIdentityField() {
                const value = document.getElementById("is_malaysian").value;
                const container = document.getElementById("identityField");
                if (value === "1") {
                    container.innerHTML = `
                        <label for="ic_passport">IC Number *</label>
                        <input type="text" id="ic_passport" name="ic_passport" maxlength="12" required>
                    `;
                } else if (value === "0") {
                    container.innerHTML = `
                        <label for="passport_number">Passport Number *</label>
                        <input type="text" id="passport_number" name="passport_number" maxlength="9" required>
                    `;
                } else {
                    container.innerHTML = "";
                }
            }

            function setCountryCode(select) {
                const code = select.options[select.selectedIndex].dataset.code;
                document.getElementById("country_code").value = code;
            }

            function setAccessValues() {
                const role = document.getElementById("role").value;
                const managerAccess = document.getElementById("manager_access");
                const superAdmin = document.getElementById("is_super_admin");

                if (role === "super_admin") {
                    managerAccess.value = "1";
                    superAdmin.value = "1";
                } else if (role === "manager") {
                    managerAccess.value = "1";
                    superAdmin.value = "0";
                } else {
                    managerAccess.value = "0";
                    superAdmin.value = "0";
                }
            }
        </script>
    </body>
</html>
