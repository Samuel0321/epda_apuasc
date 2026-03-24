<%-- 
    Document   : AdminDashboard
    Created on : Mar 23, 2026, 9:34:10 PM
    Author     : Samuel Chong
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Admin Dashboard Page</title>
    </head>
    <body>
        <h2>User List</h2>
            <div style="display:flex; flex-wrap:wrap; gap:20px;">
                <c:forEach var="user" items="${userList}">
                    <div style="border:1px solid #ccc; padding:15px; width:200px; border-radius:8px;">
                        <h3>${user.name}</h3>
                        <p>Email: ${user.email}</p>
                        <p>Role: ${user.role}</p>
                    </div>
                </c:forEach>
            </div>

            <button onclick="location.href='register.jsp'">Create User</button>

    </body>
</html>
