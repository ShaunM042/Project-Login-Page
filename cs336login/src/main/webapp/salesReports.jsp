<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="dbConnection.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Sales Reports</title>
</head>
<body>
    <h2>Monthly Sales Reports</h2>
    
    <form method="post">
        <label for="reportMonth">Select Month:</label>
        <input type="month" id="reportMonth" name="reportMonth" required>
        <input type="submit" value="Generate Report">
    </form>
    
    <%
    String reportMonth = request.getParameter("reportMonth");
    if (reportMonth != null) {
    %>
        <h3>Sales Report for <%= reportMonth %></h3>
        
        <table border="1">
            <tr>
                <th>Transit Line</th>
                <th>Number of Reservations</th>
                <th>Total Revenue</th>
                <th>Average Fare</th>
            </tr>
            <%
            Connection conn = null;
            PreparedStatement ps = null;
            ResultSet rs = null;
            double totalRevenue = 0;
            int totalReservations = 0;
            
            try {
                conn = getConnection();
                
                String sql = "SELECT Transit_Line_Name, COUNT(*) as ReservationCount, " +
                            "SUM(Total_Fare) as Revenue, AVG(Total_Fare) as AvgFare " +
                            "FROM reservation " +
                            "WHERE DATE_FORMAT(Reservation_Date, '%Y-%m') = ? " +
                            "GROUP BY Transit_Line_Name " +
                            "ORDER BY Revenue DESC";
                
                ps = conn.prepareStatement(sql);
                ps.setString(1, reportMonth);
                rs = ps.executeQuery();
                
                boolean found = false;
                while (rs.next()) {
                    found = true;
                    int count = rs.getInt("ReservationCount");
                    double revenue = rs.getDouble("Revenue");
                    totalReservations += count;
                    totalRevenue += revenue;
            %>
                    <tr>
                        <td><%= rs.getString("Transit_Line_Name") %></td>
                        <td><%= count %></td>
                        <td>$<%= String.format("%.2f", revenue) %></td>
                        <td>$<%= String.format("%.2f", rs.getDouble("AvgFare")) %></td>
                    </tr>
            <%
                }
                if (!found) {
            %>
                    <tr><td colspan="4">No sales data found for this month.</td></tr>
            <%
                }
            %>
            <tr style="background-color: #f0f0f0; font-weight: bold;">
                <td>TOTAL</td>
                <td><%= totalReservations %></td>
                <td>$<%= String.format("%.2f", totalRevenue) %></td>
                <td>$<%= totalReservations > 0 ? String.format("%.2f", totalRevenue / totalReservations) : "0.00" %></td>
            </tr>
        </table>
        
        <%
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<p style='color:red;'>Error generating report: " + e.getMessage() + "</p>");
            } finally {
                try { if (rs != null) rs.close(); } catch (Exception e) {}
                try { if (ps != null) ps.close(); } catch (Exception e) {}
                try { if (conn != null) conn.close(); } catch (Exception e) {}
            }
        %>
    <%
    }
    %>
    
    <br>
    <a href="adminDashboard.jsp">← Back to Admin Dashboard</a>
</body>
</html>