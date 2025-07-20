<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Register</title>
</head>
<body>
	<h2>Register</h2>
    <form action="registrationHandling.jsp" method="post">
        SSN: <input type="text" name="ssn" required><br>
        Name: <input type="text" name="name" required><br>
        Email: <input type="email" name="email" required><br>
        Address: <input type="text" name="address" required><br>
        Username: <input type="text" name="username" required><br>
        Password: <input type="password" name="password" required><br>
        <input type="submit" value="Register">
    </form>

    <% String error = request.getParameter("error");
       if (error != null) { %>
        <p style="color:red;"><%= error %></p>
    <% } %>
</body>
</html>