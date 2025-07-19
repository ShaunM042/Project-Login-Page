<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp?error=Please login as admin");
        return;
    }
    
    // Check if user is admin
    boolean isAdmin = false;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/reservation", "root", "polk6699");
        PreparedStatement ps = conn.prepareStatement("SELECT Role FROM users WHERE Username = ?");
        ps.setString(1, username);
        ResultSet rs = ps.executeQuery();
        if (rs.next() && "admin".equals(rs.getString("Role"))) {
            isAdmin = true;
        }
        conn.close();
    } catch (Exception e) {}
    
    if (!isAdmin) {
        response.sendRedirect("welcome.jsp?error=Admin access required");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin Dashboard</title>
<style>
    .dashboard-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; margin: 20px; }
    .dashboard-item { border: 1px solid #ccc; padding: 20px; text-align: center; background-color: #f9f9f9; }
    .dashboard-item h3 { color: #333; }
    .dashboard-item a { text-decoration: none; color: #0066cc; font-weight: bold; }
    .dashboard-item a:hover { color: #004499; }
</style>
</head>
<body>
    <h1>Admin Dashboard</h1>
    <p>Welcome, Administrator <%= username %>!</p>
    
    <div class="dashboard-grid">
        <div class="dashboard-item">
            <h3>Customer Representatives</h3>
            <p>Manage customer service representatives</p>
            <a href="manageReps.jsp">Manage Representatives →</a>
        </div>
        
        <div class="dashboard-item">
            <h3>Sales Reports</h3>
            <p>View monthly sales and revenue reports</p>
            <a href="salesReports.jsp">View Sales Reports →</a>
        </div>
        
        <div class="dashboard-item">
            <h3>Reservation Reports</h3>
            <p>View reservations by transit line and customer</p>
            <a href="reservationReports.jsp">View Reservations →</a>
        </div>
        
        <div class="dashboard-item">
            <h3>Revenue Analysis</h3>
            <p>Analyze revenue by transit line and customer</p>
            <a href="revenueReports.jsp">Revenue Reports →</a>
        </div>
        
        <div class="dashboard-item">
            <h3>Best Customer</h3>
            <p>View highest revenue generating customer</p>
            <a href="bestCustomer.jsp">View Best Customer →</a>
        </div>
        
        <div class="dashboard-item">
            <h3>Active Transit Lines</h3>
            <p>Top 5 most active transit lines</p>
            <a href="activeTransitLines.jsp">View Active Lines →</a>
        </div>
    </div>
    
    <div style="margin: 20px;">
        <a href="welcome.jsp">← Back to Home</a> |
        <a href="logout.jsp">Logout</a>
    </div>
</body>
</html>