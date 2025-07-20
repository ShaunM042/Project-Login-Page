<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="dbConnection.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Best Customer</title>
</head>
<body>
    <h2>Best Customer (Highest Revenue)</h2>
    
    <table border="1">
        <tr>
            <th>Rank</th>
            <th>Customer Username</th>
            <th>Customer Name</th>
            <th>Total Spent</th>
            <th>Number of Reservations</th>
            <th>Average Per Reservation</th>
        </tr>
        <%
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/reservation", "root", "abinmathew1A");
            
            String sql = "SELECT r.Username, c.Name, SUM(r.Total_Fare) as TotalSpent, " +
                        "COUNT(*) as ReservationCount, AVG(r.Total_Fare) as AvgPerReservation " +
                        "FROM reservation r " +
                        "LEFT JOIN customer c ON r.Username = c.Username " +
                        "GROUP BY r.Username " +
                        "ORDER BY TotalSpent DESC " +
                        "LIMIT 10";
            
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            
            int rank = 1;
            boolean found = false;
            while (rs.next()) {
                found = true;
                String customerName = rs.getString("Name");
                if (customerName == null) customerName = "N/A";
        %>
                <tr <%= rank == 1 ? "style='background-color: #gold; font-weight: bold;'" : "" %>>
                    <td><%= rank %></td>
                    <td><%= rs.getString("Username") %></td>
                    <td><%= customerName %></td>
                    <td>$<%= String.format("%.2f", rs.getDouble("TotalSpent")) %></td>
                    <td><%= rs.getInt("ReservationCount") %></td>
                    <td>$<%= String.format("%.2f", rs.getDouble("AvgPerReservation")) %></td>
                </tr>
        <%
                rank++;
            }
            if (!found) {
        %>
                <tr><td colspan="6">No customer data found.</td></tr>
        <%
            }
        %>
    </table>
    
    <%
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<p style='color:red;'>Error loading customer data: " + e.getMessage() + "</p>");
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