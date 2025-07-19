<%@ page import="java.sql.*" %>
<%
    String ssn = request.getParameter("ssn");
    String firstName = request.getParameter("firstName");
    String lastName = request.getParameter("lastName");
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    
    Connection conn = null;
    PreparedStatement psUser = null;
    PreparedStatement psEmployee = null;
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/reservation", "root", "polk6699");
        
        // Check if username already exists
        PreparedStatement checkUser = conn.prepareStatement("SELECT * FROM users WHERE Username = ?");
        checkUser.setString(1, username);
        ResultSet rs = checkUser.executeQuery();
        if (rs.next()) {
            response.sendRedirect("manageReps.jsp?error=Username already exists");
            return;
        }
        
        // Check if SSN already exists
        PreparedStatement checkSSN = conn.prepareStatement("SELECT * FROM employee WHERE SSN = ?");
        checkSSN.setInt(1, Integer.parseInt(ssn));
        ResultSet ssnRs = checkSSN.executeQuery();
        if (ssnRs.next()) {
            response.sendRedirect("manageReps.jsp?error=Employee with this SSN already exists");
            return;
        }
        
        // Add to users table with rep role
        psUser = conn.prepareStatement("INSERT INTO users (Username, Password, Role) VALUES (?, ?, 'rep')");
        psUser.setString(1, username);
        psUser.setString(2, password);
        psUser.executeUpdate();
        
        // Add to employee table
        psEmployee = conn.prepareStatement("INSERT INTO employee (SSN, FirstName, LastName, Username) VALUES (?, ?, ?, ?)");
        psEmployee.setInt(1, Integer.parseInt(ssn));
        psEmployee.setString(2, firstName);
        psEmployee.setString(3, lastName);
        psEmployee.setString(4, username);
        psEmployee.executeUpdate();
        
        response.sendRedirect("manageReps.jsp?message=Representative added successfully");
        
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("manageReps.jsp?error=Failed to add representative: " + e.getMessage());
    } finally {
        try { if (psUser != null) psUser.close(); } catch (Exception e) {}
        try { if (psEmployee != null) psEmployee.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
%>