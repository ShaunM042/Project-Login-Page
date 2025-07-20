<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="dbConnection.jsp" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp?error=Please login as customer representative");
        return;
    }
    
    // Check if user is a customer rep
    boolean isRep = false;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/reservation", "root", "polk6699");
        PreparedStatement ps = conn.prepareStatement("SELECT * FROM employee WHERE Username = ?");
        ps.setString(1, username);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) isRep = true;
        conn.close();
    } catch (Exception e) {}
    
    if (!isRep) {
        response.sendRedirect("welcome.jsp?error=Customer representative access required");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Customer Representative Dashboard</title>
<style>
    .dashboard-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 20px; margin: 20px; }
    .dashboard-item { border: 1px solid #ccc; padding: 20px; text-align: center; background-color: #f9f9ff; }
    .dashboard-item h3 { color: #333; }
    .dashboard-item a { text-decoration: none; color: #0066cc; font-weight: bold; }
    .dashboard-item a:hover { color: #004499; }
</style>
</head>
<body>
    <h1>Customer Representative Dashboard</h1>
    <p>Welcome, Representative <%= username %>!</p>
    
    <div class="dashboard-grid">
        <div class="dashboard-item">
            <h3>Manage Train Schedules</h3>
            <p>Add, edit, and delete train schedules</p>
            <a href="manageSchedules.jsp">Manage Schedules →</a>
        </div>
        
        <div class="dashboard-item">
            <h3>Customer Questions</h3>
            <p>Browse and answer customer questions</p>
            <a href="customerQuestions.jsp">View Questions →</a>
        </div>
        
        <div class="dashboard-item">
            <h3>Station Reports</h3>
            <p>Generate train schedules by station</p>
            <a href="stationReports.jsp">Station Reports →</a>
        </div>
        
        <div class="dashboard-item">
            <h3>Customer Reports</h3>
            <p>View customers by transit line and date</p>
            <a href="customerReports.jsp">Customer Reports →</a>
        </div>
    </div>
    
    <div style="margin: 20px;">
        <a href="welcome.jsp">← Back to Home</a> |
        <a href="logout.jsp">Logout</a>
    </div>
</body>
</html>