<%@ page import="java.sql.*" %>
<%
    String ssn = request.getParameter("ssn");
    if (ssn == null) {
        response.sendRedirect("manageReps.jsp?error=No representative specified");
        return;
    }
    
    Connection conn = null;
    PreparedStatement psEmployee = null;
    PreparedStatement psUser = null;
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/reservation", "root", "polk6699");
        
        // Get username before deleting employee record
        PreparedStatement getUsername = conn.prepareStatement("SELECT Username FROM employee WHERE SSN = ?");
        getUsername.setInt(1, Integer.parseInt(ssn));
        ResultSet rs = getUsername.executeQuery();
        
        String username = null;
        if (rs.next()) {
            username = rs.getString("Username");
        } else {
            response.sendRedirect("manageReps.jsp?error=Representative not found");
            return;
        }
        
        // Delete from employee table first (due to foreign key)
        psEmployee = conn.prepareStatement("DELETE FROM employee WHERE SSN = ?");
        psEmployee.setInt(1, Integer.parseInt(ssn));
        psEmployee.executeUpdate();
        
        // Delete from users table
        psUser = conn.prepareStatement("DELETE FROM users WHERE Username = ? AND Role = 'rep'");
        psUser.setString(1, username);
        psUser.executeUpdate();
        
        response.sendRedirect("manageReps.jsp?message=Representative deleted successfully");
        
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("manageReps.jsp?error=Failed to delete representative: " + e.getMessage());
    } finally {
        try { if (psEmployee != null) psEmployee.close(); } catch (Exception e) {}
        try { if (psUser != null) psUser.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
%>