<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp?error=Please login to view reservations");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>My Reservations</title>
</head>
<body>
    <h2>My Reservations</h2>
    
    <% String message = request.getParameter("message");
       if (message != null) { %>
        <p style="color:green;"><%= message %></p>
    <% } %>
    
    <% String error = request.getParameter("error");
       if (error != null) { %>
        <p style="color:red;"><%= error %></p>
    <% } %>
    
    <h3>Current Reservations</h3>
    <table border="1">
        <tr>
            <th>Reservation #</th>
            <th>Train</th>
            <th>Origin</th>
            <th>Destination</th>
            <th>Departure Date</th>
            <th>Passengers</th>
            <th>Total Fare</th>
            <th>Actions</th>
        </tr>
        <%
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        boolean hasCurrentReservations = false;
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/reservation", "root", "polk6699");
            
            // Current reservations (future dates)
            ps = conn.prepareStatement(
                "SELECT * FROM reservation WHERE Username = ? AND Departure >= CURDATE() ORDER BY Departure"
            );
            ps.setString(1, username);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                hasCurrentReservations = true;
        %>
                <tr>
                    <td><%= rs.getInt("Reservation_Num") %></td>
                    <td><%= rs.getString("TrainID") %></td>
                    <td><%= rs.getString("Origin") %></td>
                    <td><%= rs.getString("Destination") %></td>
                    <td><%= rs.getDate("Departure") %></td>
                    <td><%= rs.getInt("Passenger_Count") %></td>
                    <td>$<%= rs.getDouble("Total_Fare") %></td>
                    <td>
                        <a href="cancelReservation.jsp?reservationNum=<%= rs.getInt("Reservation_Num") %>" 
                           onclick="return confirm('Are you sure you want to cancel this reservation?')">Cancel</a>
                    </td>
                </tr>
        <%
            }
            if (!hasCurrentReservations) {
        %>
                <tr><td colspan="8">No current reservations found.</td></tr>
        <%
            }
        %>
    </table>
    
    <h3>Past Reservations</h3>
    <table border="1">
        <tr>
            <th>Reservation #</th>
            <th>Train</th>
            <th>Origin</th>
            <th>Destination</th>
            <th>Departure Date</th>
            <th>Passengers</th>
            <th>Total Fare</th>
        </tr>
        <%
            // Past reservations
            ps = conn.prepareStatement(
                "SELECT * FROM reservation WHERE Username = ? AND Departure < CURDATE() ORDER BY Departure DESC"
            );
            ps.setString(1, username);
            rs = ps.executeQuery();
            
            boolean hasPastReservations = false;
            while (rs.next()) {
                hasPastReservations = true;
        %>
                <tr>
                    <td><%= rs.getInt("Reservation_Num") %></td>
                    <td><%= rs.getString("TrainID") %></td>
                    <td><%= rs.getString("Origin") %></td>
                    <td><%= rs.getString("Destination") %></td>
                    <td><%= rs.getDate("Departure") %></td>
                    <td><%= rs.getInt("Passenger_Count") %></td>
                    <td>$<%= rs.getDouble("Total_Fare") %></td>
                </tr>
        <%
            }
            if (!hasPastReservations) {
        %>
                <tr><td colspan="7">No past reservations found.</td></tr>
        <%
            }
        %>
    </table>
    
    <%
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<p style='color:red;'>Error loading reservations: " + e.getMessage() + "</p>");
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    %>
    
    <br>
    <div>
        <a href="search.jsp">Book New Trip</a> |
        <a href="welcome.jsp">Home</a>
    </div>
</body>
</html>