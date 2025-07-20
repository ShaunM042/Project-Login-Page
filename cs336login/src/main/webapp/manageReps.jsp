<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="dbConnection.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Manage Customer Representatives</title>
</head>
<body>
    <h2>Manage Customer Representatives</h2>
    
    <% String message = request.getParameter("message");
       if (message != null) { %>
        <p style="color:green;"><%= message %></p>
    <% } %>
    
    <% String error = request.getParameter("error");
       if (error != null) { %>
        <p style="color:red;"><%= error %></p>
    <% } %>
    
    <h3>Add New Representative</h3>
    <form action="addRep.jsp" method="post">
        <table>
            <tr><td>SSN:</td><td><input type="text" name="ssn" required></td></tr>
            <tr><td>First Name:</td><td><input type="text" name="firstName" required></td></tr>
            <tr><td>Last Name:</td><td><input type="text" name="lastName" required></td></tr>
            <tr><td>Username:</td><td><input type="text" name="username" required></td></tr>
            <tr><td>Password:</td><td><input type="password" name="password" required></td></tr>
        </table>
        <input type="submit" value="Add Representative">
    </form>
    
    <h3>Current Representatives</h3>
    <table border="1">
        <tr>
            <th>SSN</th>
            <th>Name</th>
            <th>Username</th>
            <th>Actions</th>
        </tr>
        <%
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            
            ps = conn.prepareStatement("SELECT * FROM employee ORDER BY FirstName, LastName");
            rs = ps.executeQuery();
            
            boolean found = false;
            while (rs.next()) {
                found = true;
        %>
                <tr>
                    <td><%= rs.getInt("SSN") %></td>
                    <td><%= rs.getString("FirstName") %> <%= rs.getString("LastName") %></td>
                    <td><%= rs.getString("Username") %></td>
                    <td>
                        <a href="editRep.jsp?ssn=<%= rs.getInt("SSN") %>">Edit</a> |
                        <a href="deleteRep.jsp?ssn=<%= rs.getInt("SSN") %>" 
                           onclick="return confirm('Are you sure you want to delete this representative?')">Delete</a>
                    </td>
                </tr>
        <%
            }
            if (!found) {
        %>
                <tr><td colspan="4">No representatives found.</td></tr>
        <%
            }
        %>
    </table>
    
    <%
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<p style='color:red;'>Error loading representatives: " + e.getMessage() + "</p>");
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    %>
    
    <br>
    <a href="adminDashboard.jsp">← Back to Admin Dashboard</a>
</body>
</html>