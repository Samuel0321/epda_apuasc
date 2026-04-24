<%--
    Document   : RegisterCustomer
    Created on : Mar 24, 2026
    Author     : pinju
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List,utils.CountryLoader"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    List<CountryLoader.Country> countries = CountryLoader.loadCountries();
    request.setAttribute("countries", countries);
%>
<!DOCTYPE html>
<html>
<head>
    <title>Register Customer</title>
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

        .brand-inline {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 10px;
        }

        .brand-inline img {
            width: 44px;
            height: 44px;
            object-fit: contain;
            border-radius: 10px;
            border: 1px solid #dbeafe;
            background: #ffffff;
            padding: 4px;
        }

        .message {
            margin-bottom: 20px;
            padding: 12px 14px;
            border-radius: 8px;
            font-size: 14px;
        }

        .message.error {
            background: #fef2f2;
            color: #b91c1c;
            border: 1px solid #fecaca;
        }

        .message.success {
            background: #f0fdf4;
            color: #166534;
            border: 1px solid #bbf7d0;
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

        @media (max-width: 768px) {
            .form-row {
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
            <jsp:param name="section" value="REGISTER NEW CUSTOMER" />
        </jsp:include>

        <div class="header-row">
            <div class="header-text">
                <div class="brand-inline">
                    <img src="../../Icon/APUASC.png" alt="APU ASC Logo">
                    <h1>APU ASC</h1>
                </div>
                <p>New Customer Registration</p>
                <p>Create a customer login and store their basic information.</p>
            </div>
        </div>

        <div class="form-container">
            <c:if test="${not empty errorMessage}">
                <div class="message error">${errorMessage}</div>
            </c:if>
            <c:if test="${param.success eq '1'}">
                <div class="message success">Customer registered successfully.</div>
            </c:if>

            <form action="../../CustomerRegistrationServlet" method="post" onsubmit="return validateRequiredPassword();">
                <div class="form-row">
                    <div class="form-group">
                        <label for="name">Full Name *</label>
                        <input type="text" id="name" name="name" required>
                    </div>
                    <div class="form-group">
                        <label for="email">Email Address *</label>
                        <input type="email" id="email" name="email" required>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="password">Temporary Password *</label>
                        <input type="password" id="password" name="password" required>
                        <span id="passwordHelp" class="password-help"></span>
                    </div>
                    <div class="form-group">
                        <label for="phone">Phone Number</label>
                        <input type="text" id="phone" name="phone">
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="gender">Gender *</label>
                        <select id="gender" name="gender" required>
                            <option value="">Select Gender</option>
                            <option value="male">Male</option>
                            <option value="female">Female</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="is_malaysian">Is Malaysian? *</label>
                        <select id="is_malaysian" name="is_malaysian" onchange="toggleIdentityField()" required>
                            <option value="">Select Option</option>
                            <option value="1">Yes</option>
                            <option value="0">No</option>
                        </select>
                    </div>
                </div>

                <div id="identityField" class="form-group"></div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="origin_country">Origin Country *</label>
                        <select id="origin_country" name="origin_country" onchange="setCountryCode(this)" required>
                            <option value="">Select Country</option>
                            <c:forEach var="c" items="${countries}">
                                <option value="${c.name}" data-code="${c.code}">${c.name} (+${c.code})</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="user_address">Home Address</label>
                        <input type="text" id="user_address" name="user_address">
                    </div>
                </div>

                <div class="info-box">
                    This page creates a customer account only. Role is fixed as <strong>customer</strong>.
                </div>

                <input type="hidden" id="country_code" name="country_code">

                <div class="form-actions">
                    <button type="button" class="btn-cancel" onclick="window.location.href='ManageCustomers.jsp'">Cancel</button>
                    <button type="submit" class="btn-submit">Register Customer</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    function toggleIdentityField() {
        const value = document.getElementById("is_malaysian").value;
        const container = document.getElementById("identityField");
        if (value === "1") {
            container.innerHTML = '<label for="ic_passport">IC Number *</label><input type="text" id="ic_passport" name="ic_passport" maxlength="12" required>';
        } else if (value === "0") {
            container.innerHTML = '<label for="passport_number">Passport Number *</label><input type="text" id="passport_number" name="passport_number" maxlength="20" required>';
        } else {
            container.innerHTML = '';
        }
    }

    function setCountryCode(select) {
        const code = select.options[select.selectedIndex].dataset.code || "";
        document.getElementById("country_code").value = code;
    }

    document.getElementById("password").addEventListener("input", function () {
        updatePasswordHelp(this.value, document.getElementById("passwordHelp"), false);
    });

    function validateRequiredPassword() {
        return updatePasswordHelp(document.getElementById("password").value, document.getElementById("passwordHelp"), true);
    }

    function updatePasswordHelp(password, helpText, blockSubmit) {
        const strongRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^\w\s]).{8,}$/;
        if (password.length === 0) {
            helpText.textContent = "";
            helpText.classList.remove("valid");
            return !blockSubmit;
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
