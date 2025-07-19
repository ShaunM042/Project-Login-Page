<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Reservation Confirmed</title>
</head>
<body>
    <h2>Reservation Confirmed!</h2>
    
    <div style="border: 2px solid green; padding: 20px; margin: 20px; background-color: #f0fff0;">
        <h3>Your Reservation Details</h3>
        <p><strong>Reservation Number:</strong> <%= request.getParameter("reservationNum") %></p>
        <p><strong>Train:</strong> <%= request.getParameter("trainNumber") %></p>
        <p><strong>Route:</strong> <%= request.getParameter("origin") %> → <%= request.getParameter("destination") %></p>
        <p><strong>Travel Date:</strong> <%= request.getParameter("travelDate") %></p>
        <p><strong>Total Paid:</strong> $<%= request.getParameter("totalFare") %></p>
    </div>
    
    <p><strong>Important:</strong> Please save your reservation number for future reference.</p>
    
    <div>
        <a href="myReservations.jsp">View All My Reservations</a> |
        <a href="search.jsp">Book Another Trip</a> |
        <a href="welcome.jsp">Home</a>
    </div>
</body>
</html>