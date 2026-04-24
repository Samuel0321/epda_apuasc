<%-- 
    Document   : loginjsp
    Created on : Mar 22, 2026, 1:59:29 PM
    Author     : Samuel Chong
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    if ("1".equals(request.getParameter("logout"))) {
        session.invalidate();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Login | APU ASC</title>

    <!-- Google Font -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet">

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Inter', sans-serif;
        }

        body {
            height: 100vh;
            background: linear-gradient(135deg, #1e3c72, #2a5298);
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .container {
            width: 100%;
            max-width: 420px;
            background: #fff;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.2);
        }

        .title {
            font-size: 24px;
            font-weight: 600;
            margin-bottom: 25px;
            text-align: center;
            color: #333;
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            font-size: 14px;
            margin-bottom: 6px;
            color: #555;
        }

        input {
            width: 100%;
            padding: 12px;
            border: 1px solid #ccc;
            border-radius: 8px;
            font-size: 14px;
            transition: 0.3s;
        }

        input:focus {
            border-color: #2a5298;
            outline: none;
            box-shadow: 0 0 0 2px rgba(42,82,152,0.2);
        }

        .btn {
            width: 100%;
            padding: 12px;
            background: #2a5298;
            color: white;
            border: none;
            border-radius: 8px;
            font-weight: 500;
            cursor: pointer;
            transition: 0.3s;
        }

        .btn:hover {
            background: #1e3c72;
        }

        .links {
            margin-top: 15px;
            display: flex;
            justify-content: space-between;
            font-size: 13px;
        }

        .links a {
            text-decoration: none;
            color: #2a5298;
        }

        .links a:hover {
            text-decoration: underline;
        }

        .error {
            margin-top: 15px;
            color: red;
            font-size: 13px;
            text-align: center;
        }

        .success {
            margin-top: 15px;
            color: #166534;
            font-size: 13px;
            text-align: center;
        }

        .logo {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 10px;
            margin-bottom: 16px;
            color: #1e3c72;
        }

        .logo img {
            width: 64px;
            height: 64px;
            object-fit: contain;
            border-radius: 12px;
            background: #ffffff;
            padding: 6px;
            border: 1px solid #dbeafe;
        }

        .logo strong {
            font-weight: 700;
            font-size: 18px;
            letter-spacing: 0.04em;
        }

    </style>
</head>

<body>

    <div class="container">
        <div class="logo">
            <img src="Icon/APUASC.png" alt="APU ASC Logo">
            <strong>APU ASC</strong>
        </div>
        <div class="title">Sign in to your account</div>

        <form action="loginServlet" method="post">
            <div class="form-group">
                <label>Email</label>
                <input type="text" name="email" placeholder="Enter your email" required>
            </div>

            <div class="form-group">
                <label>Password</label>
                <input type="password" name="password" placeholder="Enter your password" required>
            </div>

            <button type="submit" class="btn">Login</button>
        </form>

        <div class="links">
            <a href="RegisterServlet">Create new acc</a>
        </div>

        <div class="error">
            ${errorMessage}
        </div>

        <div class="success">
            ${param.registered eq '1' ? 'Registration completed. You can log in now.' : ''}
        </div>
    </div>

</body>
</html>
