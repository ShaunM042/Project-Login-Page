{\rtf1\ansi\ansicpg1252\cocoartf2822
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\margl1440\margr1440\vieww30040\viewh16780\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs24 \cf0 <%@ page contentType="text/html; charset=UTF-8" %>\
<!DOCTYPE html>\
<html>\
<head>\
    <title>Login Page</title>\
</head>\
<body>\
    <h2>Login</h2>\
    <form action="authenticate.jsp" method="post">\
        Username: <input type="text" name="username" required><br>\
        Password: <input type="password" name="password" required><br>\
        <input type="submit" value="Login">\
    </form>\
    <%-- Show error message if redirected with error --%>\
    <%\
        String error = request.getParameter("error");\
        if (error != null && !error.isEmpty()) \{\
    %>\
        <p style="color:red;"><%= error %></p>\
    <%\
        \}\
    %>\
</body>\
</html>\
}