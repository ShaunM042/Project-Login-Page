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
    <title>Station Reports</title>
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
    <h2>Station Reports</h2>
    
    <div class="filter-form">
        <form method="get">
            <label>Filter by Station: </label>
            <select name="station">
                <option value="">All Stations</option>
                <%
                    Connection conn = null;
                    try {
                        conn = getConnection();
                        String stationQuery = "SELECT DISTINCT Origin_Station FROM train_schedule " +
                                            "UNION SELECT DISTINCT Destination_Station FROM train_schedule " +
                                            "ORDER BY Origin_Station";
                        PreparedStatement stationPs = conn.prepareStatement(stationQuery);
                        ResultSet stationRs = stationPs.executeQuery();
                        
                        String selectedStation = request.getParameter("station");
                        
                        while (stationRs.next()) {
                            String station = stationRs.getString(1);
                            boolean isSelected = station.equals(selectedStation);
                %>
                <option value="<%= station %>" <%= isSelected ? "selected" : "" %>><%= station %></option>
                <%
                        }
                        stationRs.close();
                        stationPs.close();
                    } catch (Exception e) {
                        out.println("<option>Error loading stations</option>");
                    }
                %>
            </select>
            <input type="submit" value="Filter">
        </form>
    </div>

    <div class="report-section">
        <h3>Train Schedules by Station</h3>
        <table>
            <tr>
                <th>Train Number</th>
                <th>Transit Line</th>
                <th>Origin</th>
                <th>Destination</th>
                <th>Travel Date</th>
                <th>Departure Time</th>
                <th>Stops</th>
                <th>Fare</th>
            </tr>
            <%
                try {
                    String filterStation = request.getParameter("station");
                    String scheduleQuery;
                    PreparedStatement schedulePs;
                    
                    if (filterStation != null && !filterStation.trim().isEmpty()) {
                        scheduleQuery = "SELECT * FROM train_schedule " +
                                      "WHERE Origin_Station = ? OR Destination_Station = ? " +
                                      "ORDER BY Travel_Date, Departure_Time";
                        schedulePs = conn.prepareStatement(scheduleQuery);
                        schedulePs.setString(1, filterStation);
                        schedulePs.setString(2, filterStation);
                    } else {
                        scheduleQuery = "SELECT * FROM train_schedule " +
                                      "ORDER BY Travel_Date, Departure_Time";
                        schedulePs = conn.prepareStatement(scheduleQuery);
                    }
                    
                    ResultSet scheduleRs = schedulePs.executeQuery();
                    boolean hasData = false;
                    
                    while (scheduleRs.next()) {
                        hasData = true;
            %>
            <tr>
                <td><%= scheduleRs.getString("Train_Number") %></td>
                <td><%= scheduleRs.getString("Transit_Line_Name") %></td>
                <td><%= scheduleRs.getString("Origin_Station") %></td>
                <td><%= scheduleRs.getString("Destination_Station") %></td>
                <td><%= scheduleRs.getDate("Travel_Date") %></td>
                <td><%= scheduleRs.getTime("Departure_Time") %></td>
                <td><%= scheduleRs.getInt("Number_of_Stops") %></td>
                <td>$<%= scheduleRs.getBigDecimal("Fare") %></td>
            </tr>
            <%
                    }
                    
                    if (!hasData) {
            %>
            <tr><td colspan="8">No schedules found for the selected criteria.</td></tr>
            <%
                    }
                    
                    scheduleRs.close();
                    schedulePs.close();
                } catch (Exception e) {
                    out.println("<tr><td colspan='8'>Error loading schedule data: " + e.getMessage() + "</td></tr>");
                }
            %>
        </table>
    </div>

    <div class="report-section">
        <h3>Station Activity Summary</h3>
        <table>
            <tr>
                <th>Station</th>
                <th>Departures</th>
                <th>Arrivals</th>
                <th>Total Traffic</th>
            </tr>
            <%
                try {
                    String activityQuery = "SELECT station, " +
                                         "SUM(departures) as total_departures, " +
                                         "SUM(arrivals) as total_arrivals, " +
                                         "(SUM(departures) + SUM(arrivals)) as total_traffic " +
                                         "FROM (" +
                                         "  SELECT Origin_Station as station, COUNT(*) as departures, 0 as arrivals " +
                                         "  FROM train_schedule GROUP BY Origin_Station " +
                                         "  UNION ALL " +
                                         "  SELECT Destination_Station as station, 0 as departures, COUNT(*) as arrivals " +
                                         "  FROM train_schedule GROUP BY Destination_Station" +
                                         ") as station_activity " +
                                         "GROUP BY station " +
                                         "ORDER BY total_traffic DESC";
                    
                    PreparedStatement activityPs = conn.prepareStatement(activityQuery);
                    ResultSet activityRs = activityPs.executeQuery();
                    
                    while (activityRs.next()) {
            %>
            <tr>
                <td><%= activityRs.getString("station") %></td>
                <td><%= activityRs.getInt("total_departures") %></td>
                <td><%= activityRs.getInt("total_arrivals") %></td>
                <td><%= activityRs.getInt("total_traffic") %></td>
            </tr>
            <%
                    }
                    activityRs.close();
                    activityPs.close();
                } catch (Exception e) {
                    out.println("<tr><td colspan='4'>Error loading activity data: " + e.getMessage() + "</td></tr>");
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