<%@ page import="java.sql.*" %>
<%! 
    public Connection getConnection() {
        try {
            String url = "jdbc:mysql://localhost:3306/reservation";
            String user = "root";
            String password = "abinmathew1A"; // ✅ this must match your terminal login

            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(url, user, password);
        } catch (Exception e) {
            return null;
        }
    }
%>

