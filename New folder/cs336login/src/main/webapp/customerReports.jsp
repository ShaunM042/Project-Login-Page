<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="dbConnection.jsp" %>
<%
    String username = (String) session.getAttribute("username");
    String userRole = (String) session.getAttribute("userRole");
    
    if (username == null || (!"rep".equals(userRole) && !"admin".equals(userRole))) {
        response.sendRedirect("login.jsp?error=Access+denied");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Customer Reports</title>
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
        .filter-form {
            background-color: #f9f9f9;
            padding: 15px;
            border: 1px solid #ddd;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <h2>Customer Reports</h2>
    
    <div class="filter-form">
        <form method="get">
            <label>Filter by Transit Line: </label>
            <select name="transitLine">
                <option value="">All Transit Lines</option>
                <%
                    Connection conn = null;
                    try {
                        conn = getConnection();
                        String lineQuery = "SELECT DISTINCT Transit_Line_Name FROM reservation ORDER BY Transit_Line_Name";
                        PreparedStatement linePs = conn.prepareStatement(lineQuery);
                        ResultSet lineRs = linePs.executeQuery();
                        
                        String selectedLine = request.getParameter("transitLine");
                        
                        while (lineRs.next()) {
                            String line = lineRs.getString("Transit_Line_Name");
                            boolean isSelected = line.equals(selectedLine);
                %>
                <option value="<%= line %>" <%= isSelected ? "selected" : "" %>><%= line %></option>
                <%
                        }
                        lineRs.close();
                        linePs.close();
                    } catch (Exception e) {
                        out.println("<option>Error loading transit lines</option>");
                    }
                %>
            </select>
            
            <label>Travel Date: </label>
            <input type="date" name="travelDate" value="<%= request.getParameter("travelDate") != null ? request.getParameter("travelDate") : "" %>">
            
            <input type="submit" value="Filter">
        </form>
    </div>

    <div class="report-section">
        <h3>Customer Reservations</h3>
        <table>
            <tr>
                <th>Customer</th>
                <th>Email</th>
                <th>Transit Line</th>
                <th>Origin</th>
                <th>Destination</th>
                <th>Travel Date</th>
                <th>Fare</th>
                <th>Booking Date</th>
            </tr>
            <%
                try {
                    String filterLine = request.getParameter("transitLine");
                    String filterDate = request.getParameter("travelDate");
                    
                    StringBuilder queryBuilder = new StringBuilder();
                    queryBuilder.append("SELECT r.Username, c.Email, r.Transit_Line_Name, ");
                    queryBuilder.append("r.Origin, r.Destination, r.Departure, ");
                    queryBuilder.append("r.Total_Fare, r.Reservation_Date ");
                    queryBuilder.append("FROM reservation r ");
                    queryBuilder.append("LEFT JOIN customer c ON r.Username = c.Username ");
                    queryBuilder.append("WHERE 1=1 ");
                    
                    if (filterLine != null && !filterLine.trim().isEmpty()) {
                        queryBuilder.append("AND r.Transit_Line_Name = ? ");
                    }
                    if (filterDate != null && !filterDate.trim().isEmpty()) {
                        queryBuilder.append("AND r.Departure = ? ");
                    }
                    queryBuilder.append("ORDER BY r.Departure DESC, r.Reservation_Date DESC");
                    
                    PreparedStatement customerPs = conn.prepareStatement(queryBuilder.toString());
                    
                    int paramIndex = 1;
                    if (filterLine != null && !filterLine.trim().isEmpty()) {
                        customerPs.setString(paramIndex++, filterLine);
                    }
                    if (filterDate != null && !filterDate.trim().isEmpty()) {
                        customerPs.setDate(paramIndex++, Date.valueOf(filterDate));
                    }
                    
                    ResultSet customerRs = customerPs.executeQuery();
                    boolean hasData = false;
                    
                    while (customerRs.next()) {
                        hasData = true;
            %>
            <tr>
                <td><%= customerRs.getString("Username") %></td>
                <td><%= customerRs.getString("Email") != null ? customerRs.getString("Email") : "N/A" %></td>
                <td><%= customerRs.getString("Transit_Line_Name") %></td>
                <td><%= customerRs.getString("Origin") %></td>
                <td><%= customerRs.getString("Destination") %></td>
                <td><%= customerRs.getDate("Departure") %></td>
                <td>$<%= String.format("%.2f", customerRs.getDouble("Total_Fare")) %></td>
                <td><%= customerRs.getTimestamp("Reservation_Date") %></td>
            </tr>
            <%
                    }
                    
                    if (!hasData) {
            %>
            <tr><td colspan="8">No customer reservations found for the selected criteria.</td></tr>
            <%
                    }
                    
                    customerRs.close();
                    customerPs.close();
                } catch (Exception e) {
                    out.println("<tr><td colspan='8'>Error loading customer data: " + e.getMessage() + "</td></tr>");
                }
            %>
        </table>
    </div>

    <div class="report-section">
        <h3>Customer Summary by Transit Line</h3>
        <table>
            <tr>
                <th>Transit Line</th>
                <th>Unique Customers</th>
                <th>Total Reservations</th>
                <th>Average Reservations per Customer</th>
                <th>Total Revenue</th>
            </tr>
            <%
                try {
                    String summaryQuery = "SELECT r.Transit_Line_Name, " +
                                        "COUNT(DISTINCT r.Username) as unique_customers, " +
                                        "COUNT(*) as total_reservations, " +
                                        "COUNT(*) / COUNT(DISTINCT r.Username) as avg_per_customer, " +
                                        "SUM(r.Total_Fare) as total_revenue " +
                                        "FROM reservation r " +
                                        "GROUP BY r.Transit_Line_Name " +
                                        "ORDER BY total_revenue DESC";
                    
                    PreparedStatement summaryPs = conn.prepareStatement(summaryQuery);
                    ResultSet summaryRs = summaryPs.executeQuery();
                    
                    while (summaryRs.next()) {
            %>
            <tr>
                <td><%= summaryRs.getString("Transit_Line_Name") %></td>
                <td><%= summaryRs.getInt("unique_customers") %></td>
                <td><%= summaryRs.getInt("total_reservations") %></td>
                <td><%= String.format("%.1f", summaryRs.getDouble("avg_per_customer")) %></td>
                <td>$<%= String.format("%.2f", summaryRs.getDouble("total_revenue")) %></td>
            </tr>
            <%
                    }
                    summaryRs.close();
                    summaryPs.close();
                } catch (Exception e) {
                    out.println("<tr><td colspan='5'>Error loading summary data: " + e.getMessage() + "</td></tr>");
                }
            %>
        </table>
    </div>

    <div class="report-section">
        <h3>Most Active Customers</h3>
        <table>
            <tr>
                <th>Customer</th>
                <th>Email</th>
                <th>Total Reservations</th>
                <th>Favorite Transit Line</th>
                <th>Total Spent</th>
                <th>Last Booking</th>
            </tr>
            <%
                try {
                    String activeQuery = "SELECT r.Username, c.Email, " +
                                       "COUNT(*) as reservation_count, " +
                                       "SUM(r.Total_Fare) as total_spent, " +
                                       "MAX(r.Reservation_Date) as last_booking, " +
                                       "(SELECT Transit_Line_Name FROM reservation r2 " +
                                       " WHERE r2.Username = r.Username " +
                                       " GROUP BY Transit_Line_Name " +
                                       " ORDER BY COUNT(*) DESC LIMIT 1) as favorite_line " +
                                       "FROM reservation r " +
                                       "LEFT JOIN customer c ON r.Username = c.Username " +
                                       "GROUP BY r.Username, c.Email " +
                                       "ORDER BY reservation_count DESC " +
                                       "LIMIT 15";
                    
                    PreparedStatement activePs = conn.prepareStatement(activeQuery);
                    ResultSet activeRs = activePs.executeQuery();
                    
                    while (activeRs.next()) {
            %>
            <tr>
                <td><%= activeRs.getString("Username") %></td>
                <td><%= activeRs.getString("Email") != null ? activeRs.getString("Email") : "N/A" %></td>
                <td><%= activeRs.getInt("reservation_count") %></td>
                <td><%= activeRs.getString("favorite_line") %></td>
                <td>$<%= String.format("%.2f", activeRs.getDouble("total_spent")) %></td>
                <td><%= activeRs.getTimestamp("last_booking") %></td>
            </tr>
            <%
                    }
                    activeRs.close();
                    activePs.close();
                } catch (Exception e) {
                    out.println("<tr><td colspan='6'>Error loading active customer data: " + e.getMessage() + "</td></tr>");
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

    <p><a href="repDashboard.jsp">← Back to Rep Dashboard</a></p>
</body>
</html>