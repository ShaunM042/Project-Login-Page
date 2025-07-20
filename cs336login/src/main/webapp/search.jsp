<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Search</title>
</head>
<body>
    <h2>Search for Trains</h2>

    <form action="results.jsp" method="get">
        Origin Station: <input type="text" name="origin" required><br>
        Destination Station: <input type="text" name="destination" required><br>
        Travel Date: <input type="date" name="travelDate" required><br>
        Sort by:
        <select name="sort">
            <option value="stops">Number of Stops</option>
            <option value="fare">Fare</option>
            <option value="departure">Departure Time</option>
            <option value="arrival">Arrival Time</option>
        </select><br><br>

        <input type="submit" value="Search">
    </form>

    <% String error = request.getParameter("error");
       if (error != null) { %>
        <p style="color:red;"><%= error %></p>
    <% } %>
</body>
</html>