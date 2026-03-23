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
        <title>User Registration</title>
        <style>
            body { font-family: Arial, sans-serif; margin: 20px; }
            form { max-width: 600px; margin: auto; }
            label { display: block; margin-top: 10px; }
            input, select { width: 100%; padding: 8px; margin-top: 5px; }
            button { margin-top: 20px; padding: 10px 15px; }
        </style>
    </head> 
    <body>
        <h2>User Registration</h2>
        <form action="RegisterServlet" method="post">
            <!-- PK user_id usually auto-generated, so not in form -->

            <label for="name">Name</label>
            <input type="text" id="name" name="name" maxlength="255" required>

            <label for="password">Password</label>
            <input type="password" id="password" name="password" maxlength="255" required>
            <span id="passwordHelp" style="color:red; font-size:12px;"></span>

            <script>
            document.getElementById("password").addEventListener("input", function() {
                const password = this.value;
                const helpText = document.getElementById("passwordHelp");

                // Strong password criteria:
                // - At least 8 characters
                // - Contains uppercase
                // - Contains lowercase
                // - Contains number
                // - Contains special character
                const strongRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/;

                if (!strongRegex.test(password)) {
                    helpText.textContent = "Password must be at least 8 characters, include uppercase, lowercase, number, and special character.";
                } else {
                    helpText.textContent = "Strong password ✔";
                    helpText.style.color = "green";
                }
            });
            </script>


            <label for="gender">Gender</label>
            <select id="gender" name="gender" required>
                <option value="male">Male</option>
                <option value="female">Female</option>
            </select>

            <label for="is_malaysian">Is Malaysian</label>
            <select id="is_malaysian" name="is_malaysian" onchange="toggleIdentityField()" required>
                <option value="1">Yes</option>
                <option value="0">No</option>
            </select>
            
            <div id="identityField"></div>

            <script>
            function toggleIdentityField() {
                const value = document.getElementById("is_malaysian").value;
                const container = document.getElementById("identityField");
                if (value === "1") {
                    container.innerHTML = `
                        <label for="ic_passport">IC Number</label>
                        <input type="text" id="ic_passport" name="ic_passport" maxlength="12">
                    `;
                } else {
                    container.innerHTML = `
                        <label for="passport_number">Passport Number</label>
                        <input type="text" id="passport_number" name="passport_number" maxlength="9">
                    `;
                }
            }
            </script>

<!--            <label for="origin_country">Origin Country</label>
            <input type="text" id="origin_country" name="origin_country" maxlength="100">-->
            
            <label for="origin_country">Origin Country</label>
            <select id="origin_country" name="origin_country" required>
                <c:forEach var="c" items="${countries}">
                    <option value="${c.name}">${c.name} (+${c.code})</option>
                </c:forEach>
            </select>
            

            <label for="phone">Phone</label>
            <input type="text" id="phone" name="phone" maxlength="50">

<!--            <label for="ic_passport">IC Number / Passport</label>
            <input type="text" id="ic_passport" name="ic_passport" maxlength="50">

            <label for="passport_number">Passport Number</label>
            <input type="text" id="passport_number" name="passport_number" maxlength="50">-->

            <label for="email">Email</label>
            <input type="email" id="email" name="email" maxlength="255" required>

            <label for="user_address">User Address</label>
            <input type="text" id="user_address" name="user_address" maxlength="255">

            <label for="role">Role</label>
            <select id="role" name="role" onchange="setAccessValues()">
                <option value="manager">Manager</option>
                <option value="super_admin">Super Administrator</option>
                <option value="counter_staff">Counter Staff</option>
                <option value="technician">Technician</option>
                <option value="customer">Customer</option>
            </select>

            <!-- Hidden fields that will be controlled by JavaScript -->
            <input type="hidden" id="manager_access" name="manager_access" value="0">
            <input type="hidden" id="is_super_admin" name="is_super_admin" value="0">

            <script>
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

            <button type="submit">Register</button>
        </form>
    </body>
</html>
