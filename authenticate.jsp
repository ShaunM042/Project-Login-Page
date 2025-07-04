{\rtf1\ansi\ansicpg1252\cocoartf2822
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs24 \cf0 <%@ page import="java.sql.*" %>\
<%\
    String username = request.getParameter("username");\
    String password = request.getParameter("password");\
\
    String dbURL = "jdbc:mysql://localhost:3306/cs336project"; // UPDATE if needed\
    String dbUser = "root"; // UPDATE to your MySQL username\
    String dbPass = "YOUR_PASSWORD"; // UPDATE to your MySQL password\
\
    boolean valid = false;\
    try \{\
        Class.forName("com.mysql.cj.jdbc.Driver");\
        Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPass);\
        PreparedStatement ps = conn.prepareStatement(\
            "SELECT * FROM customer WHERE Username=? AND Password=?"\
        );\
        ps.setString(1, username);\
        ps.setString(2, password);\
        ResultSet rs = ps.executeQuery();\
        if (rs.next()) \{\
            valid = true;\
        \}\
        rs.close();\
        ps.close();\
        conn.close();\
    \} catch (Exception e) \{\
        // If you want, show DB error: response.sendRedirect("login.jsp?error=Database error");\
        response.sendRedirect("login.jsp?error=Database+connection+error");\
        return;\
    \}\
\
    if (valid) \{\
        session.setAttribute("username", username);\
        response.sendRedirect("welcome.jsp");\
    \} else \{\
        response.sendRedirect("login.jsp?error=Invalid+username+or+password");\
    \}\
%>\
}