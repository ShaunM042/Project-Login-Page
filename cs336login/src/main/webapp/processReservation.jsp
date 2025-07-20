<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ include file="dbConnection.jsp" %>
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
    String baseFareStr = request.getParameter("baseFare");
    String passengerCountStr = request.getParameter("passengerCount");
    String ageGroup = request.getParameter("ageGroup");
    String tripType = request.getParameter("tripType");
    
    Connection conn = null;
    PreparedStatement ps = null;
    
    try {
        double baseFare = Double.parseDouble(baseFareStr);
        int passengerCount = Integer.parseInt(passengerCountStr);
        
        // Calculate discount based on age group
        double discount = 1.0;
        if ("child".equals(ageGroup)) discount = 0.5;
        else if ("senior".equals(ageGroup) || "disabled".equals(ageGroup)) discount = 0.75;
        
        // Calculate total fare
        double totalFare = baseFare * passengerCount * discount;
        boolean isRoundTrip = "roundtrip".equals(tripType);
        if (isRoundTrip) totalFare *= 2;
        
        conn = getConnection();
        
        // Generate unique reservation number
        Random rand = new Random();
        int reservationNum = 100000 + rand.nextInt(900000);
        
        // Check if reservation number already exists and generate new one if needed
        PreparedStatement checkPs = conn.prepareStatement("SELECT Reservation_Num FROM reservation WHERE Reservation_Num = ?");
        checkPs.setInt(1, reservationNum);
        ResultSet checkRs = checkPs.executeQuery();
        while (checkRs.next()) {
            reservationNum = 100000 + rand.nextInt(900000);
            checkPs.setInt(1, reservationNum);
            checkRs = checkPs.executeQuery();
        }
        checkPs.close();
        
        // Insert reservation
        String sql = "INSERT INTO reservation (Reservation_Num, Username, Transit_Line_Name, TrainID, Origin, Destination, " +
                     "Departure, Reservation_Date, Passenger_Count, Age_Group, Round_Trip, Total_Fare) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, CURDATE(), ?, ?, ?, ?)";
        
        ps = conn.prepareStatement(sql);
        ps.setInt(1, reservationNum);
        ps.setString(2, username);
        ps.setString(3, trainNumber); // Using train number as transit line for now
        ps.setString(4, trainNumber); // TrainID as string for compatibility
        ps.setString(5, origin);
        ps.setString(6, destination);
        ps.setString(7, travelDate + " 00:00:00"); // Convert date to datetime
        ps.setInt(8, passengerCount);
        ps.setString(9, ageGroup);
        ps.setBoolean(10, isRoundTrip);
        ps.setDouble(11, totalFare);
        
        int rowsAffected = ps.executeUpdate();
        
        if (rowsAffected > 0) {
            // Redirect to confirmation page
            response.sendRedirect("reservationConfirmation.jsp?reservationNum=" + reservationNum + 
                                "&totalFare=" + totalFare + "&trainNumber=" + trainNumber + 
                                "&origin=" + origin + "&destination=" + destination + "&travelDate=" + travelDate);
        } else {
            response.sendRedirect("makeReservation.jsp?error=Failed to create reservation");
        }
        
    } catch (NumberFormatException e) {
        response.sendRedirect("makeReservation.jsp?error=Invalid fare or passenger count");
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("makeReservation.jsp?error=Reservation failed: " + e.getMessage());
    } finally {
        try { if (ps != null) ps.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
%>