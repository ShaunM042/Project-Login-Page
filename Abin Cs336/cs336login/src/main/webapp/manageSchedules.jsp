<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="dbConnection.jsp" %>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("userRole");

    if (username == null || (!"rep".equals(role) && !"admin".equals(role))) {
        response.sendRedirect("login.jsp?error=Access denied");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Train Schedules</title>
    <style>
        table { border-collapse: collapse; width: 100%; margin-bottom: 20px; }
        th, td { border: 1px solid #ccc; padding: 8px; text-align: left; }
        th { background-color: #f0f0f0; }
        form { margin-top: 20px; }
    </style>
</head>
<body>
    <h2>Train Schedules</h2>

    <table>
        <tr>
            <th>ScheduleID</th>
            <th>Train Number</th>
            <th>Transit Line</th>
            <th>Origin</th>
            <th>Destination</th>
            <th>Travel Date</th>
            <th>Departure Time</th>
            <th>Stops</th>
            <th>Fare</th>
            <th>Action</th>
        </tr>
        <%
            try {
                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/reservation", "root", "polk6699");
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery("SELECT * FROM train_schedule");

                while (rs.next()) {
        %>
        <tr>
            <td><%= rs.getInt("ScheduleID") %></td>
            <td><%= rs.getString("Train_Number") %></td>
            <td><%= rs.getString("Transit_Line_Name") %></td>
            <td><%= rs.getString("Origin_Station") %></td>
            <td><%= rs.getString("Destination_Station") %></td>
            <td><%= rs.getDate("Travel_Date") %></td>
            <td><%= rs.getTime("Departure_Time") %></td>
            <td><%= rs.getInt("Number_of_Stops") %></td>
            <td>$<%= rs.getBigDecimal("Fare") %></td>
            <td>
                <form action="deleteSchedule.jsp" method="post" style="display:inline;">
                    <input type="hidden" name="scheduleID" value="<%= rs.getInt("ScheduleID") %>">
                    <input type="submit" value="Delete" onclick="return confirm('Are you sure?');">
                </form>
            </td>
        </tr>
        <%
                }
                rs.close();
                conn.close();
            } catch (Exception e) {
                out.println("<tr><td colspan='10'>Error loading data.</td></tr>");
            }
        %>
    </table>

    <h3>Add New Schedule</h3>
    <form action="addSchedule.jsp" method="post">
        Train Number: <input type="text" name="Train_Number" required><br>
        Transit Line Name: <input type="text" name="Transit_Line_Name" required><br>
        Origin Station: <input type="text" name="Origin_Station" required><br>
        Destination Station: <input type="text" name="Destination_Station" required><br>
        Travel Date: <input type="date" name="Travel_Date" required><br>
        Departure Time: <input type="time" name="Departure_Time" required><br>
        Number of Stops: <input type="number" name="Number_of_Stops" required><br>
        Fare: <input type="number" step="0.01" name="Fare" required><br><br>
        <input type="submit" value="Add Schedule">
    </form>

    <p><a href="repDashboard.jsp">← Back to Dashboard</a></p>
</body>
</html>
