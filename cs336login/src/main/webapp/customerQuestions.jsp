<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Customer Questions</title>
</head>
<body>
    <h2>Customer Questions & Answers</h2>
    
    <% String message = request.getParameter("message");
       if (message != null) { %>
        <p style="color:green;"><%= message %></p>
    <% } %>
    
    <h3>Search Questions</h3>
    <form method="post">
        <input type="text" name="searchKeywords" placeholder="Enter keywords to search..." 
               value="<%= request.getParameter("searchKeywords") != null ? request.getParameter("searchKeywords") : "" %>">
        <input type="submit" value="Search">
        <a href="customerQuestions.jsp">Show All</a>
    </form>
    
    <h3>Questions</h3>
    <%
    String searchKeywords = request.getParameter("searchKeywords");
    String sql = "SELECT q.QID, q.Question, q.AskedBy, q.DateAsked, a.Answer, a.AnsweredBy, a.DateAnswered " +
                 "FROM questions q LEFT JOIN answers a ON q.QID = a.QID ";
    
    if (searchKeywords != null && !searchKeywords.trim().isEmpty()) {
        sql += "WHERE q.Question LIKE ? ";
    }
    sql += "ORDER BY q.DateAsked DESC";
    
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/reservation", "root", "polk6699");
        
        ps = conn.prepareStatement(sql);
        if (searchKeywords != null && !searchKeywords.trim().isEmpty()) {
            ps.setString(1, "%" + searchKeywords.trim() + "%");
        }
        rs = ps.executeQuery();
        
        boolean found = false;
        while (rs.next()) {
            found = true;
    %>
            <div style="border: 1px solid #ccc; margin: 15px 0; padding: 15px; background-color: #f9f9f9;">
                <div style="background-color: #e6f3ff; padding: 10px; margin-bottom: 10px;">
                    <strong>Question:</strong> <%= rs.getString("Question") %><br>
                    <em>Asked by: <%= rs.getString("AskedBy") %> on <%= rs.getTimestamp("DateAsked") %></em>
                </div>
                
                <%
                String answer = rs.getString("Answer");
                if (answer != null && !answer.trim().isEmpty()) {
                %>
                    <div style="background-color: #e6ffe6; padding: 10px;">
                        <strong>Answer:</strong> <%= answer %><br>
                        <em>Answered by: <%= rs.getString("AnsweredBy") %> on <%= rs.getTimestamp("DateAnswered") %></em>
                    </div>
                <%
                } else {
                %>
                    <div style="background-color: #fff2e6; padding: 10px;">
                        <strong>Status:</strong> <span style="color: red;">Unanswered</span>
                        <form action="answerQuestion.jsp" method="post" style="margin-top: 10px;">
                            <input type="hidden" name="qid" value="<%= rs.getInt("QID") %>">
                            <textarea name="answer" rows="3" cols="80" placeholder="Type your answer here..." required></textarea><br>
                            <input type="submit" value="Submit Answer" style="margin-top: 5px;">
                        </form>
                    </div>
                <%
                }
                %>
            </div>
    <%
        }
        if (!found) {
    %>
            <p>No questions found.</p>
    <%
        }
        
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<p style='color:red;'>Error loading questions: " + e.getMessage() + "</p>");
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (ps != null) ps.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
    %>
    
    <div style="margin-top: 20px;">
        <a href="askQuestion.jsp">Ask a New Question</a> |
        <a href="repDashboard.jsp">← Back to Rep Dashboard</a>
    </div>
</body>
</html>