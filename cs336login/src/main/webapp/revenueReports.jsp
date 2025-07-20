<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="dbConnection.jsp" %>
<%
    String username = (String) session.getAttribute("username");
    String userRole = (String) session.getAttribute("userRole");
    
    if (username == null || !"admin".equals(userRole)) {
        response.sendRedirect("login.jsp?error=Please+login+as+admin");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Revenue Reports</title>
    <style>
        table {
            border-collapse: collapse;
            width: 100%;
            margin-bottom: 20px;
        }
        th, td {
            border: 1px solid #ccc;
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #f0f0f0;
        }
        .report-section {
            margin-bottom: 30px;
        }
        .report-section h3 {
            color: #333;
            border-bottom: 2px solid #0066cc;
            padding-bottom: 5px;
        }
        .summary-box {
            background-color: #f9f9f9;
            border: 1px solid #ddd;
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 5px;
        }
        .summary-item {
            display: inline-block;
            margin-right: 30px;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <h2>Revenue Analysis Reports</h2>
    
    <%
        Connection conn = null;
        double totalRevenue = 0;
        int totalReservations = 0;
        try {
            conn = getConnection();
            
            // Get overall summary
            String summaryQuery = "SELECT COUNT(*) as total_reservations, SUM(Total_Fare) as total_revenue FROM reservation";
            PreparedStatement summaryPs = conn.prepareStatement(summaryQuery);
            ResultSet summaryRs = summaryPs.executeQuery();
            if (summaryRs.next()) {
                totalReservations = summaryRs.getInt("total_reservations");
                totalRevenue = summaryRs.getDouble("total_revenue");
            }
            summaryRs.close();
            summaryPs.close();
    %>
    
    <div class="summary-box">
        <div class="summary-item">Total Reservations: <%= totalReservations %></div>
        <div class="summary-item">Total Revenue: $<%= String.format("%.2f", totalRevenue) %></div>
        <div class="summary-item">Average Fare: $<%= String.format("%.2f", totalReservations > 0 ? totalRevenue/totalReservations : 0) %></div>
    </div>

    <div class="report-section">
        <h3>Revenue by Transit Line</h3>
        <table>
            <tr>
                <th>Transit Line</th>
                <th>Total Revenue</th>
                <th>Number of Reservations</th>
                <th>Average Fare</th>
                <th>% of Total Revenue</th>
            </tr>
            <%
                String lineQuery = "SELECT Transit_Line_Name, " +
                                 "SUM(Total_Fare) as line_revenue, " +
                                 "COUNT(*) as line_reservations, " +
                                 "AVG(Total_Fare) as avg_fare " +
                                 "FROM reservation " +
                                 "GROUP BY Transit_Line_Name " +
                                 "ORDER BY line_revenue DESC";
                
                PreparedStatement linePs = conn.prepareStatement(lineQuery);
                ResultSet lineRs = linePs.executeQuery();
                
                while (lineRs.next()) {
                    double lineRevenue = lineRs.getDouble("line_revenue");
                    double percentage = totalRevenue > 0 ? (lineRevenue / totalRevenue) * 100 : 0;
            %>
            <tr>
                <td><%= lineRs.getString("Transit_Line_Name") %></td>
                <td>$<%= String.format("%.2f", lineRevenue) %></td>
                <td><%= lineRs.getInt("line_reservations") %></td>
                <td>$<%= String.format("%.2f", lineRs.getDouble("avg_fare")) %></td>
                <td><%= String.format("%.1f", percentage) %>%</td>
            </tr>
            <%
                }
                lineRs.close();
                linePs.close();
            %>
        </table>
    </div>

    <div class="report-section">
        <h3>Revenue by Month</h3>
        <table>
            <tr>
                <th>Month</th>
                <th>Revenue</th>
                <th>Reservations</th>
                <th>Growth vs Previous Month</th>
            </tr>
            <%
                String monthQuery = "SELECT DATE_FORMAT(Reservation_Date, '%Y-%m') as month, " +
                                  "SUM(Total_Fare) as monthly_revenue, " +
                                  "COUNT(*) as monthly_reservations " +
                                  "FROM reservation " +
                                  "GROUP BY DATE_FORMAT(Reservation_Date, '%Y-%m') " +
                                  "ORDER BY month DESC " +
                                  "LIMIT 12";
                
                PreparedStatement monthPs = conn.prepareStatement(monthQuery);
                ResultSet monthRs = monthPs.executeQuery();
                
                double previousRevenue = 0;
                boolean isFirst = true;
                
                while (monthRs.next()) {
                    double currentRevenue = monthRs.getDouble("monthly_revenue");
                    double growth = 0;
                    String growthText = "N/A";
                    
                    if (!isFirst && previousRevenue > 0) {
                        growth = ((currentRevenue - previousRevenue) / previousRevenue) * 100;
                        growthText = String.format("%.1f%%", growth);
                        if (growth > 0) growthText = "+" + growthText;
                    }
            %>
            <tr>
                <td><%= monthRs.getString("month") %></td>
                <td>$<%= String.format("%.2f", currentRevenue) %></td>
                <td><%= monthRs.getInt("monthly_reservations") %></td>
                <td><%= growthText %></td>
            </tr>
            <%
                    previousRevenue = currentRevenue;
                    isFirst = false;
                }
                monthRs.close();
                monthPs.close();
            %>
        </table>
    </div>

    <div class="report-section">
        <h3>Top Revenue Generating Customers</h3>
        <table>
            <tr>
                <th>Customer</th>
                <th>Total Revenue</th>
                <th>Number of Reservations</th>
                <th>Average Fare</th>
                <th>First Booking</th>
                <th>Last Booking</th>
            </tr>
            <%
                String customerQuery = "SELECT r.Username, " +
                                     "SUM(r.Total_Fare) as customer_revenue, " +
                                     "COUNT(*) as customer_reservations, " +
                                     "AVG(r.Total_Fare) as avg_customer_fare, " +
                                     "MIN(r.Reservation_Date) as first_booking, " +
                                     "MAX(r.Reservation_Date) as last_booking " +
                                     "FROM reservation r " +
                                     "GROUP BY r.Username " +
                                     "ORDER BY customer_revenue DESC " +
                                     "LIMIT 15";
                
                PreparedStatement customerPs = conn.prepareStatement(customerQuery);
                ResultSet customerRs = customerPs.executeQuery();
                
                while (customerRs.next()) {
            %>
            <tr>
                <td><%= customerRs.getString("Username") %></td>
                <td>$<%= String.format("%.2f", customerRs.getDouble("customer_revenue")) %></td>
                <td><%= customerRs.getInt("customer_reservations") %></td>
                <td>$<%= String.format("%.2f", customerRs.getDouble("avg_customer_fare")) %></td>
                <td><%= customerRs.getDate("first_booking") %></td>
                <td><%= customerRs.getDate("last_booking") %></td>
            </tr>
            <%
                }
                customerRs.close();
                customerPs.close();
            %>
        </table>
    </div>

    <div class="report-section">
        <h3>Revenue by Route</h3>
        <table>
            <tr>
                <th>Route</th>
                <th>Revenue</th>
                <th>Reservations</th>
                <th>Average Fare</th>
            </tr>
            <%
                String routeQuery = "SELECT CONCAT(Origin, ' → ', Destination) as route, " +
                                  "SUM(Total_Fare) as route_revenue, " +
                                  "COUNT(*) as route_reservations, " +
                                  "AVG(Total_Fare) as avg_route_fare " +
                                  "FROM reservation " +
                                  "GROUP BY Origin, Destination " +
                                  "ORDER BY route_revenue DESC " +
                                  "LIMIT 10";
                
                PreparedStatement routePs = conn.prepareStatement(routeQuery);
                ResultSet routeRs = routePs.executeQuery();
                
                while (routeRs.next()) {
            %>
            <tr>
                <td><%= routeRs.getString("route") %></td>
                <td>$<%= String.format("%.2f", routeRs.getDouble("route_revenue")) %></td>
                <td><%= routeRs.getInt("route_reservations") %></td>
                <td>$<%= String.format("%.2f", routeRs.getDouble("avg_route_fare")) %></td>
            </tr>
            <%
                }
                routeRs.close();
                routePs.close();
            %>
        </table>
    </div>

    <%
        } catch (Exception e) {
            out.println("<div style='color: red;'>Error loading revenue data: " + e.getMessage() + "</div>");
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {}
            }
        }
    %>

    <p><a href="adminDashboard.jsp">← Back to Admin Dashboard</a></p>
</body>
</html>