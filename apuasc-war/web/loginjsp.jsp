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
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Hello World!</h1>
        <form action="login" method="post">
            Email: <input type="text" name="email">
            Password: <input type="password" name="password">
            <button type="submit">Login</button>
        </form>
        
        <link href="registerjsp.jsp"> register<>
        
        <p style="color:red;">
            ${errorMessage}
        </p>
    </body>
</html>
