<%@ page import="java.sql.*" %>
<%
    String username = request.getParameter("username");
    String password = request.getParameter("password");

    String dbURL = "jdbc:mysql://localhost:3306/reservation"; 
    String dbUser = "root"; 
    String dbPass = "polk6699"; 

    boolean valid = false;
    String userRole = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
        
        // First check users table for authentication and role
        PreparedStatement ps = conn.prepareStatement(
            "SELECT Role FROM users WHERE Username=? AND Password=?"
        ); 
        ps.setString(1, username);
        ps.setString(2, password);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            valid = true;
            userRole = rs.getString("Role");
        } else {
            // Fallback: check customer table for backward compatibility
            PreparedStatement custPs = conn.prepareStatement(
                "SELECT * FROM customer WHERE Username=? AND Password=?"
            );
            custPs.setString(1, username);
            custPs.setString(2, password);
            ResultSet custRs = custPs.executeQuery();
            if (custRs.next()) {
                valid = true;
                userRole = "customer";
            }
            custRs.close();
            custPs.close();
        }
        rs.close();
        ps.close();
        conn.close();

	} catch (Exception e) {
		e.printStackTrace();
        response.sendRedirect("login.jsp?error=Database+connection+error");
        return;
	}

    if (valid) {
        session.setAttribute("username", username);
        session.setAttribute("userRole", userRole);
        
        // Redirect based on user role
        if ("admin".equals(userRole)) {
            response.sendRedirect("adminDashboard.jsp");
        } else if ("rep".equals(userRole)) {
            response.sendRedirect("repDashboard.jsp");
        } else {
            response.sendRedirect("welcome.jsp");
        }
    } else {
        response.sendRedirect("login.jsp?error=Invalid+username+or+password");
    }
%>
}