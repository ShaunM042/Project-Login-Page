<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Most Active Transit Lines</title>
</head>
<body>
    <h2>Top 5 Most Active Transit Lines</h2>
    
    <table border="1">
        <tr>
            <th>Rank</th>
            <th>Transit Line</th>
            <th>Total Reservations</th>
            <th>Total Revenue</th>
            <th>Average Fare</th>
            <th>Unique Customers</th>
        </tr>
        <%
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/reservation", "root", "polk6699");
            
            String sql = "SELECT Transit_Line_Name, COUNT(*) as TotalReservations, " +
                        "SUM(Total_Fare) as TotalRevenue, AVG(Total_Fare) as AvgFare, " +
                        "COUNT(DISTINCT Username) as UniqueCustomers " +
                        "FROM reservation " +
                        "GROUP BY Transit_Line_Name " +
                        "ORDER BY TotalReservations DESC " +
                        "LIMIT 5";
            
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            
            int rank = 1;
            boolean found = false;
            while (rs.next()) {
                found = true;
        %>
                <tr <%= rank == 1 ? "style='background-color: #gold; font-weight: bold;'" : 
                       rank == 2 ? "style='background-color: #silver;'" :
                       rank == 3 ? "style='background-color: #cd7f32;'" : "" %>>
                    <td><%= rank %></td>
                    <td><%= rs.getString("Transit_Line_Name") %></td>
                    <td><%= rs.getInt("TotalReservations") %></td>
                    <td>$<%= String.format("%.2f", rs.getDouble("TotalRevenue")) %></td>
                    <td>$<%= String.format("%.2f", rs.getDouble("AvgFare")) %></td>
                    <td><%= rs.getInt("UniqueCustomers") %></td>
                </tr>
        <%
                rank++;
            }
            if (!found) {
        %>
                <tr><td colspan="6">No transit line data found.</td></tr>
        <%
            }
        %>
    </table>
    
    <% if (found) { %>
        <h3>Performance Metrics</h3>
        <p><strong>Note:</strong> Rankings are based on total number of reservations.</p>
        <ul>
            <li>🥇 Gold: #1 Most Active Transit Line</li>
            <li>🥈 Silver: #2 Most Active Transit Line</li>
            <li>🥉 Bronze: #3 Most Active Transit Line</li>
        </ul>
    <% } %>
    
    <%
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<p style='color:red;'>Error loading transit line data: " + e.getMessage() + "</p>");
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