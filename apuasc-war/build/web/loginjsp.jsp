<%-- 
    Document   : loginjsp
    Created on : Mar 22, 2026, 1:59:29 PM
    Author     : Samuel Chong
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Login | Enterprise System</title>

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

        .logo {
            text-align: center;
            margin-bottom: 15px;
            font-weight: bold;
            font-size: 18px;
            color: #2a5298;
        }
    </style>
</head>

<body>

    <div class="container">
        <div class="logo">Enterprise Portal</div>
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
            <a href="register.jsp">Create account</a>
            <a href="RegisterServlet">Register (Servlet)</a>
        </div>

        <div class="error">
            ${errorMessage}
        </div>
    </div>

</body>
</html>