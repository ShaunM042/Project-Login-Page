<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="dbConnection.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Train Stops</title>
</head>
<body>
    <h2>All Stops for Train <%= request.getParameter("trainNumber") %></h2>
    
    <%
    String trainNumber = request.getParameter("trainNumber");
    if (trainNumber == null) {
        response.sendRedirect("search.jsp?error=No train specified");
        return;
    }
    
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    
    try {
        conn = getConnection();
        
        String sql = "SELECT s.Name, s.City, s.State, ts.Arrival_Time, ts.Departure_Time, ts.Stop_Sequence " +
                     "FROM train_stops ts " +
                     "JOIN station s ON ts.StationID = s.StationID " +
                     "WHERE ts.Train_Number = ? " +
                     "ORDER BY ts.Stop_Sequence";
        
        ps = conn.prepareStatement(sql);
        ps.setString(1, trainNumber);
        rs = ps.executeQuery();
    %>
    
    <table border="1">
        <tr>
            <th>Stop #</th>
            <th>Station</th>
            <th>City, State</th>
            <th>Arrival Time</th>
            <th>Departure Time</th>
        </tr>
        <%
        boolean found = false;
        while (rs.next()) {
            found = true;
        %>
            <tr>
                <td><%= rs.getInt("Stop_Sequence") %></td>
                <td><%= rs.getString("Name") %></td>
                <td><%= rs.getString("City") %>, <%= rs.getString("State") %></td>
                <td><%= rs.getTime("Arrival_Time") != null ? rs.getTime("Arrival_Time") : "N/A" %></td>
                <td><%= rs.getTime("Departure_Time") != null ? rs.getTime("Departure_Time") : "N/A" %></td>
            </tr>
        <%
        }
        if (!found) {
        %>
            <tr><td colspan="5">No stops found for this train.</td></tr>
        <%
        }
        %>
    </table>
    
    <br>
    <a href="search.jsp">Back to Search</a>
    
    <%
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<p style='color:red;'>Error loading train stops: " + e.getMessage() + "</p>");
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (ps != null) ps.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
    %>
</body>
</html>