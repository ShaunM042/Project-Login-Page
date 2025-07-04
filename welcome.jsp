{\rtf1\ansi\ansicpg1252\cocoartf2822
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs24 \cf0 <%@ page contentType="text/html; charset=UTF-8" %>\
<%\
    String username = (String) session.getAttribute("username");\
    if (username == null) \{\
        response.sendRedirect("login.jsp");\
        return;\
    \}\
%>\
<!DOCTYPE html>\
<html>\
<head>\
    <title>Welcome</title>\
</head>\
<body>\
    <h2>Welcome, <%= username %>!</h2>\
    <form action="logout.jsp" method="post">\
        <input type="submit" value="Logout">\
    </form>\
</body>\
</html>\
}