$content = Get-Content apuasc-war/web/Pages/Receptionist/RegisterCustomer.jsp -Raw
$content = $content -replace 'Register Customer', 'Edit Customer'
$content = $content -replace '<form action=".*?/CustomerRegistrationServlet".*?>', '<form action="../../ManageCustomers.jsp" method="POST">'
$content | Set-Content apuasc-war/web/Pages/Receptionist/EditCustomer.jsp
