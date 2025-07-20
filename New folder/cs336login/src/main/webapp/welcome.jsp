<%
    String username = (String) session.getAttribute("username");
    String userRole = (String) session.getAttribute("userRole");
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Default role to customer if not set
    if (userRole == null) userRole = "customer";
%>
<!DOCTYPE html>
<html>
<head>
    <title>Welcome</title>
    <style>
        .nav-menu { margin: 20px 0; }
        .nav-menu ul { list-style-type: none; padding: 0; }
        .nav-menu li { display: inline-block; margin-right: 20px; }
        .nav-menu a { text-decoration: none; color: #0066cc; font-weight: bold; }
        .nav-menu a:hover { color: #004499; }
        .role-badge { background-color: #f0f0f0; padding: 5px 10px; border-radius: 5px; display: inline-block; margin-left: 10px; }
    </style>
</head>
<body>
    <h2>Welcome, <%= username %>! 
        <span class="role-badge"><%= userRole.substring(0,1).toUpperCase() + userRole.substring(1) %></span>
    </h2>
    
    <div class="nav-menu">
        <h3>Navigation</h3>
        <ul>
            <% if ("admin".equals(userRole)) { %>
                <li><a href="adminDashboard.jsp">🔧 Admin Dashboard</a></li>
                <li><a href="manageReps.jsp">👥 Manage Representatives</a></li>
                <li><a href="salesReports.jsp">📊 Sales Reports</a></li>
                <li><a href="bestCustomer.jsp">🏆 Best Customer</a></li>
            <% } else if ("rep".equals(userRole)) { %>
                <li><a href="repDashboard.jsp">🎧 Rep Dashboard</a></li>
                <li><a href="manageSchedules.jsp">🚂 Manage Schedules</a></li>
                <li><a href="customerQuestions.jsp">❓ Customer Questions</a></li>
                <li><a href="stationReports.jsp">📋 Station Reports</a></li>
            <% } else { %>
                <li><a href="search.jsp">🔍 Search Trains</a></li>
                <li><a href="myReservations.jsp">🎫 My Reservations</a></li>
                <li><a href="askQuestion.jsp">❓ Ask Question</a></li>
                <li><a href="customerQuestions.jsp">💬 Browse Q&A</a></li>
            <% } %>
        </ul>
    </div>
    
    <% if (request.getParameter("error") != null) { %>
        <p style="color:red;"><%= request.getParameter("error") %></p>
    <% } %>
    
    <% if (request.getParameter("message") != null) { %>
        <p style="color:green;"><%= request.getParameter("message") %></p>
    <% } %>
    
    <div style="margin-top: 30px;">
        <form action="logout.jsp" method="post" style="display: inline;">
            <input type="submit" value="Logout">
        </form>
        <% if (!"customer".equals(userRole)) { %>
            | <a href="welcome.jsp">Home</a>
        <% } %>
    </div>
</body>
</html>
