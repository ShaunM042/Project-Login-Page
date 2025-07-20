<%@ page import="java.sql.*" %>
<%@ include file="dbConnection.jsp" %>
<%
    String ssn = request.getParameter("ssn");
    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String address = request.getParameter("address");
    String username = request.getParameter("username");
    String password = request.getParameter("password");

    Connection conn = null;
    PreparedStatement psUser = null;
    PreparedStatement psCustomer = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/reservation", "root", "polk6699");

        PreparedStatement checkUser = conn.prepareStatement("SELECT * FROM users WHERE Username = ?");
        checkUser.setString(1, username);
        ResultSet rs = checkUser.executeQuery();
        if (rs.next()) {
            response.sendRedirect("register.jsp?error=Username already exists");
            return;
        }

        psUser = conn.prepareStatement("INSERT INTO users (Username, Password, Role) VALUES (?, ?, 'customer')");
        psUser.setString(1, username);
        psUser.setString(2, password);
        psUser.executeUpdate();

        psCustomer = conn.prepareStatement("INSERT INTO customer (SSN, Username, Name, Email, Address) VALUES (?, ?, ?, ?, ?)");
        psCustomer.setString(1, ssn);
        psCustomer.setString(2, username);
        psCustomer.setString(3, name);
        psCustomer.setString(4, email);
        psCustomer.setString(5, address);
        psCustomer.executeUpdate();

        response.sendRedirect("login.jsp");

    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("register.jsp?error=Registration failed");
    } finally {
        try { if (psUser != null) psUser.close(); } catch (Exception e) {}
        try { if (psCustomer != null) psCustomer.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
%>
