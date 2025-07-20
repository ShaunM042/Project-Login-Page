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
    <title>Reservation Reports</title>
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
    </style>
</head>
<body>
    <h2>Reservation Reports</h2>

    <div class="report-section">
        <h3>Reservations by Transit Line</h3>
        <table>
            <tr>
                <th>Transit Line</th>
                <th>Total Reservations</th>
                <th>Total Revenue</th>
                <th>Average Fare</th>
            </tr>
            <%
                Connection conn = null;
                try {
                    conn = getConnection();
                    String query = "SELECT r.Transit_Line_Name, " +
                                  "COUNT(r.Reservation_Num) as total_reservations, " +
                                  "SUM(r.Total_Fare) as total_revenue, " +
                                  "AVG(r.Total_Fare) as avg_fare " +
                                  "FROM reservation r " +
                                  "GROUP BY r.Transit_Line_Name " +
                                  "ORDER BY total_revenue DESC";

                    PreparedStatement ps = conn.prepareStatement(query);
                    ResultSet rs = ps.executeQuery();

                    while (rs.next()) {
            %>
            <tr>
                <td><%= rs.getString("Transit_Line_Name") %></td>
                <td><%= rs.getInt("total_reservations") %></td>
                <td>$<%= String.format("%.2f", rs.getDouble("total_revenue")) %></td>
                <td>$<%= String.format("%.2f", rs.getDouble("avg_fare")) %></td>
            </tr>
            <%
                    }
                    rs.close();
                    ps.close();
                } catch (Exception e) {
                    out.println("<tr><td colspan='4'>Error loading transit line data: " + e.getMessage() + "</td></tr>");
                }
            %>
        </table>
    </div>

    <div class="report-section">
        <h3>Reservations by Customer</h3>
        <table>
            <tr>
                <th>Customer</th>
                <th>Email</th>
                <th>Total Reservations</th>
                <th>Total Spent</th>
                <th>Last Reservation</th>
            </tr>
            <%
                try {
                    String customerQuery = "SELECT c.Username, c.Email, " +
                                         "COUNT(r.Reservation_Num) as total_reservations, " +
                                         "SUM(r.Total_Fare) as total_spent, " +
                                         "MAX(r.Reservation_Date) as last_reservation " +
                                         "FROM customer c " +
                                         "LEFT JOIN reservation r ON c.Username = r.Username " +
                                         "GROUP BY c.Username, c.Email " +
                                         "HAVING COUNT(r.Reservation_Num) > 0 " +
                                         "ORDER BY total_spent DESC " +
                                         "LIMIT 20";

                    PreparedStatement ps2 = conn.prepareStatement(customerQuery);
                    ResultSet rs2 = ps2.executeQuery();

                    while (rs2.next()) {
            %>
            <tr>
                <td><%= rs2.getString("Username") %></td>
                <td><%= rs2.getString("Email") %></td>
                <td><%= rs2.getInt("total_reservations") %></td>
                <td>$<%= String.format("%.2f", rs2.getDouble("total_spent")) %></td>
                <td><%= rs2.getDate("last_reservation") %></td>
            </tr>
            <%
                    }
                    rs2.close();
                    ps2.close();
                } catch (Exception e) {
                    out.println("<tr><td colspan='5'>Error loading customer data: " + e.getMessage() + "</td></tr>");
                }
            %>
        </table>
    </div>

    <div class="report-section">
        <h3>Recent Reservations</h3>
        <table>
            <tr>
                <th>Reservation #</th>
                <th>Customer</th>
                <th>Transit Line</th>
                <th>Origin</th>
                <th>Destination</th>
                <th>Travel Date</th>
                <th>Fare</th>
                <th>Booking Date</th>
            </tr>
            <%
                try {
                    String recentQuery = "SELECT r.Reservation_Num, r.Username, r.Transit_Line_Name, " +
                                       "r.Origin, r.Destination, r.Departure, " +
                                       "r.Total_Fare, r.Reservation_Date " +
                                       "FROM reservation r " +
                                       "ORDER BY r.Reservation_Date DESC " +
                                       "LIMIT 15";

                    PreparedStatement ps3 = conn.prepareStatement(recentQuery);
                    ResultSet rs3 = ps3.executeQuery();

                    while (rs3.next()) {
            %>
            <tr>
                <td><%= rs3.getInt("Reservation_Num") %></td>
                <td><%= rs3.getString("Username") %></td>
                <td><%= rs3.getString("Transit_Line_Name") %></td>
                <td><%= rs3.getString("Origin") %></td>
                <td><%= rs3.getString("Destination") %></td>
                <td><%= rs3.getTimestamp("Departure") %></td>
                <td>$<%= String.format("%.2f", rs3.getDouble("Total_Fare")) %></td>
                <td><%= rs3.getDate("Reservation_Date") %></td>
            </tr>
            <%
                    }
                    rs3.close();
                    ps3.close();
                } catch (Exception e) {
                    out.println("<tr><td colspan='8'>Error loading recent reservations: " + e.getMessage() + "</td></tr>");
                } finally {
                    if (conn != null) {
                        try {
                            conn.close();
                        } catch (SQLException e) {}
                    }
                }
            %>
        </table>
    </div>

    <p><a href="adminDashboard.jsp">← Back to Admin Dashboard</a></p>
</body>
</html>
