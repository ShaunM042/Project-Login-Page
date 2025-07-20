<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp?error=Please+login+to+make+a+reservation");
        return;
    }
    
    String trainNumber = request.getParameter("trainNumber");
    String origin = request.getParameter("origin");
    String destination = request.getParameter("destination");
    String travelDate = request.getParameter("travelDate");
    String fare = request.getParameter("fare");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Make Reservation</title>
<script>
function calculateTotal() {
    var baseFare = parseFloat('<%= fare %>');
    var passengers = parseInt(document.getElementById('passengerCount').value) || 1;
    var ageGroup = document.getElementById('ageGroup').value;
    var roundTrip = document.getElementById('roundTrip').checked;
    
    var discount = 1.0;
    if (ageGroup === 'child') discount = 0.5;
    else if (ageGroup === 'senior' || ageGroup === 'disabled') discount = 0.75;
    
    var total = baseFare * passengers * discount;
    if (roundTrip) total *= 2;
    
    document.getElementById('totalFare').innerText = '$' + total.toFixed(2);
}
</script>
</head>
<body>
    <h2>Make a Reservation</h2>
    
    <h3>Trip Details</h3>
    <p><strong>Train:</strong> <%= trainNumber %></p>
    <p><strong>Route:</strong> <%= origin %> → <%= destination %></p>
    <p><strong>Date:</strong> <%= travelDate %></p>
    <p><strong>Base Fare:</strong> $<%= fare %></p>
    
    <form action="processReservation.jsp" method="post">
        <input type="hidden" name="trainNumber" value="<%= trainNumber %>">
        <input type="hidden" name="origin" value="<%= origin %>">
        <input type="hidden" name="destination" value="<%= destination %>">
        <input type="hidden" name="travelDate" value="<%= travelDate %>">
        <input type="hidden" name="baseFare" value="<%= fare %>">
        
        <table>
            <tr>
                <td>Number of Passengers:</td>
                <td><input type="number" id="passengerCount" name="passengerCount" min="1" max="10" value="1" required onchange="calculateTotal()"></td>
            </tr>
            <tr>
                <td>Age Group:</td>
                <td>
                    <select id="ageGroup" name="ageGroup" onchange="calculateTotal()">
                        <option value="adult">Adult (Full Price)</option>
                        <option value="child">Child (50% discount)</option>
                        <option value="senior">Senior (25% discount)</option>
                        <option value="disabled">Disabled (25% discount)</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td>Trip Type:</td>
                <td>
                    <input type="radio" name="tripType" value="oneway" checked onchange="calculateTotal()"> One Way
                    <input type="radio" id="roundTrip" name="tripType" value="roundtrip" onchange="calculateTotal()"> Round Trip (2x fare)
                </td>
            </tr>
            <tr>
                <td><strong>Total Fare:</strong></td>
                <td><strong><span id="totalFare">$<%= fare %></span></strong></td>
            </tr>
        </table>
        
        <br>
        <input type="submit" value="Confirm Reservation">
        <a href="results.jsp?origin=<%= origin %>&destination=<%= destination %>&travelDate=<%= travelDate %>&sort=stops">Cancel</a>
    </form>
    
    <script>calculateTotal();</script>
</body>
</html>