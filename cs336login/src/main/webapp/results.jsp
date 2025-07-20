<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="dbConnection.jsp" %>
<%
    String origin = request.getParameter("origin");
    String destination = request.getParameter("destination");
    String travelDate = request.getParameter("travelDate");
    String sort = request.getParameter("sort");

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        conn = getConnection();

        String orderBy = "Number_of_Stops";
        if ("fare".equals(sort)) {
            orderBy = "Fare";
        } else if ("departure".equals(sort)) {
            orderBy = "Departure_Time";
        } else if ("arrival".equals(sort)) {
            orderBy = "Arrival_Time";
        }

        String sql = "SELECT Train_Number, Transit_Line_Name, Departure_Time, Arrival_Time, Number_of_Stops, Fare " +
                     "FROM train_schedule " +
                     "WHERE Origin_Station = ? AND Destination_Station = ? AND Travel_Date = ? " +
                     "ORDER BY " + orderBy;

        ps = conn.prepareStatement(sql);
        ps.setString(1, origin);
        ps.setString(2, destination);
        ps.setString(3, travelDate);

        rs = ps.executeQuery();
%>

<h2>Results for <%= origin %> → <%= destination %> on <%= travelDate %></h2>

<table border="1">
    <tr>
        <th>Train Number</th>
        <th>Transit Line</th>
        <th>Departure Time</th>
        <th>Arrival Time</th>
        <th>Stops</th>
        <th>Fare</th>
        <th>Details</th>
        <th>Reserve</th>
    </tr>
    <%
        boolean found = false;
        while (rs.next()) {
            found = true;
    %>
        <tr>
            <td><%= rs.getString("Train_Number") %></td>
            <td><%= rs.getString("Transit_Line_Name") %></td>
            <td><%= rs.getString("Departure_Time") %></td>
            <td><%= rs.getString("Arrival_Time") != null ? rs.getString("Arrival_Time") : "N/A" %></td>
            <td><%= rs.getInt("Number_of_Stops") %></td>
            <td>$<%= rs.getDouble("Fare") %></td>
            <td><a href="trainStops.jsp?trainNumber=<%= rs.getString("Train_Number") %>">View Stops</a></td>
            <td><a href="makeReservation.jsp?trainNumber=<%= rs.getString("Train_Number") %>&origin=<%= origin %>&destination=<%= destination %>&travelDate=<%= travelDate %>&fare=<%= rs.getDouble("Fare") %>">Reserve</a></td>
        </tr>
    <%
        }
        if (!found) {
    %>
        <tr><td colspan="8">No matching trains found.</td></tr>
    <%
        }
    %>
</table>

<%
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("search.jsp?error=Search failed");
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (ps != null) ps.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
%>
