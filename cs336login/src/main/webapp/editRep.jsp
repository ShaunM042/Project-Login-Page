<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="dbConnection.jsp" %>

<%
    String action = request.getParameter("action");
    String ssn = request.getParameter("ssn");
    
    // Handle form submission
    if ("update".equals(action)) {
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String oldUsername = request.getParameter("oldUsername");
        
        Connection conn = null;
        PreparedStatement psUser = null;
        PreparedStatement psEmployee = null;
        
        try {
            conn = getConnection();
            
            // Check if new username already exists (excluding current user)
            if (!username.equals(oldUsername)) {
                PreparedStatement checkUser = conn.prepareStatement("SELECT * FROM users WHERE Username = ?");
                checkUser.setString(1, username);
                ResultSet rs = checkUser.executeQuery();
                if (rs.next()) {
                    response.sendRedirect("editRep.jsp?ssn=" + ssn + "&error=Username+already+exists");
                    return;
                }
            }
            
            // Update employee table
            psEmployee = conn.prepareStatement("UPDATE employee SET FirstName = ?, LastName = ?, Username = ? WHERE SSN = ?");
            psEmployee.setString(1, firstName);
            psEmployee.setString(2, lastName);
            psEmployee.setString(3, username);
            psEmployee.setInt(4, Integer.parseInt(ssn));
            psEmployee.executeUpdate();
            
            // Update users table
            if (password != null && !password.trim().isEmpty()) {
                // Update with new password
                psUser = conn.prepareStatement("UPDATE users SET Username = ?, Password = ? WHERE Username = ?");
                psUser.setString(1, username);
                psUser.setString(2, password);
                psUser.setString(3, oldUsername);
            } else {
                // Update without changing password
                psUser = conn.prepareStatement("UPDATE users SET Username = ? WHERE Username = ?");
                psUser.setString(1, username);
                psUser.setString(2, oldUsername);
            }
            psUser.executeUpdate();
            
            response.sendRedirect("manageReps.jsp?message=Representative+updated+successfully");
            return;
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("editRep.jsp?ssn=" + ssn + "&error=Failed+to+update+representative:+" + e.getMessage());
            return;
        } finally {
            try { if (psUser != null) psUser.close(); } catch (Exception e) {}
            try { if (psEmployee != null) psEmployee.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Edit Customer Representative</title>
</head>
<body>
    <h2>Edit Customer Representative</h2>
    
    <% String message = request.getParameter("message");
       if (message != null) { %>
        <p style="color:green;"><%= message %></p>
    <% } %>
    
    <% String error = request.getParameter("error");
       if (error != null) { %>
        <p style="color:red;"><%= error %></p>
    <% } %>
    
    <%
    if (ssn == null || ssn.trim().isEmpty()) {
        out.println("<p style='color:red;'>No representative selected for editing.</p>");
        out.println("<a href='manageReps.jsp'>← Back to Manage Representatives</a>");
        return;
    }
    
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    
    try {
        conn = getConnection();
        
        ps = conn.prepareStatement("SELECT * FROM employee WHERE SSN = ?");
        ps.setInt(1, Integer.parseInt(ssn));
        rs = ps.executeQuery();
        
        if (rs.next()) {
            String currentSSN = rs.getString("SSN");
            String currentFirstName = rs.getString("FirstName");
            String currentLastName = rs.getString("LastName");
            String currentUsername = rs.getString("Username");
    %>
    
    <form action="editRep.jsp" method="post">
        <input type="hidden" name="action" value="update">
        <input type="hidden" name="ssn" value="<%= currentSSN %>">
        <input type="hidden" name="oldUsername" value="<%= currentUsername %>">
        
        <table>
            <tr><td>SSN:</td><td><input type="text" value="<%= currentSSN %>" readonly style="background-color:#f0f0f0;"></td></tr>
            <tr><td>First Name:</td><td><input type="text" name="firstName" value="<%= currentFirstName %>" required></td></tr>
            <tr><td>Last Name:</td><td><input type="text" name="lastName" value="<%= currentLastName %>" required></td></tr>
            <tr><td>Username:</td><td><input type="text" name="username" value="<%= currentUsername %>" required></td></tr>
            <tr><td>New Password:</td><td><input type="password" name="password" placeholder="Leave blank to keep current password"></td></tr>
        </table>
        <br>
        <input type="submit" value="Update Representative">
        <input type="button" value="Cancel" onclick="window.location.href='manageReps.jsp'">
    </form>
    
    <%
        } else {
            out.println("<p style='color:red;'>Representative not found.</p>");
        }
    %>
    
    <%
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<p style='color:red;'>Error loading representative: " + e.getMessage() + "</p>");
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    %>
    
    <br>
    <a href="manageReps.jsp">← Back to Manage Representatives</a>
</body>
</html>