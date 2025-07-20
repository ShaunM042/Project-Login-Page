<%@ page import="java.sql.*" %>
<%@ include file="dbConnection.jsp" %>
<%
    String username = request.getParameter("username");
    String userPassword = request.getParameter("password");

    boolean valid = false;
    String userRole = null;

    Connection conn = null;

    try {
        conn = getConnection();
        PreparedStatement ps = conn.prepareStatement(
            "SELECT Role FROM users WHERE Username=? AND Password=?"
        ); 
        ps.setString(1, username);
        ps.setString(2, userPassword);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            valid = true;
            userRole = rs.getString("Role");
        } else {
            PreparedStatement custPs = conn.prepareStatement(
                "SELECT * FROM customer WHERE Username=? AND Password=?"
            );
            custPs.setString(1, username);
            custPs.setString(2, userPassword);
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
        response.sendRedirect("login.jsp?error=Database+query+failed");
        return;
    }

    if (valid) {
        session.setAttribute("username", username);
        session.setAttribute("userRole", userRole);

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
