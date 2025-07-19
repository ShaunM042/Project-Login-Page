<%@ page import="java.sql.*" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp?error=Please login to cancel reservations");
        return;
    }
    
    String reservationNum = request.getParameter("reservationNum");
    if (reservationNum == null) {
        response.sendRedirect("myReservations.jsp?error=No reservation specified");
        return;
    }
    
    Connection conn = null;
    PreparedStatement ps = null;
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/reservation", "root", "polk6699");
        
        // Verify reservation belongs to current user and is future dated
        PreparedStatement checkPs = conn.prepareStatement(
            "SELECT * FROM reservation WHERE Reservation_Num = ? AND Username = ? AND Departure >= CURDATE()"
        );
        checkPs.setInt(1, Integer.parseInt(reservationNum));
        checkPs.setString(2, username);
        ResultSet checkRs = checkPs.executeQuery();
        
        if (!checkRs.next()) {
            response.sendRedirect("myReservations.jsp?error=Reservation not found or cannot be cancelled");
            return;
        }
        
        // Delete the reservation
        ps = conn.prepareStatement(
            "DELETE FROM reservation WHERE Reservation_Num = ? AND Username = ?"
        );
        ps.setInt(1, Integer.parseInt(reservationNum));
        ps.setString(2, username);
        
        int rowsAffected = ps.executeUpdate();
        
        if (rowsAffected > 0) {
            response.sendRedirect("myReservations.jsp?message=Reservation cancelled successfully");
        } else {
            response.sendRedirect("myReservations.jsp?error=Failed to cancel reservation");
        }
        
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("myReservations.jsp?error=Cancellation failed: " + e.getMessage());
    } finally {
        try { if (ps != null) ps.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
%>