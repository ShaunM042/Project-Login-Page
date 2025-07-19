<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login Page</title>
</head>
<body>
    <h2>Login</h2>
    <form action="authenticate.jsp" method="post">
        Username: <input type="text" name="username" required><br>
        Password: <input type="password" name="password" required><br>
        <input type="submit" value="Login">
    </form>

    <%-- Show error message if redirected with error --%>
    <%
        String error = request.getParameter("error");
        if (error != null && !error.isEmpty()) {
    %>
        <p style="color:red;"><%= error %></p>
    <%
        }
        
        String message = request.getParameter("message");
        if (message != null && !message.isEmpty()) {
    %>
        <p style="color:green;"><%= message %></p>
    <%
        }
    %>
    
    <p>Don't have an account? <a href="register.jsp">Register here</a></p>
    
    <p><strong>Demo Users:</strong><br>
    Admin: username="admin", password="admin123"<br>
    Customer: Register new account or use existing customer credentials</p>
</body>
</html>


