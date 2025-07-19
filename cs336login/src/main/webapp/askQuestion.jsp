<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp?error=Please login to ask a question");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Ask a Question</title>
</head>
<body>
    <h2>Ask a Question</h2>
    
    <% String error = request.getParameter("error");
       if (error != null) { %>
        <p style="color:red;"><%= error %></p>
    <% } %>
    
    <form action="submitQuestion.jsp" method="post">
        <table>
            <tr>
                <td><strong>Your Question:</strong></td>
            </tr>
            <tr>
                <td>
                    <textarea name="question" rows="5" cols="80" 
                              placeholder="Please describe your question in detail..." required></textarea>
                </td>
            </tr>
            <tr>
                <td>
                    <input type="submit" value="Submit Question">
                    <input type="button" value="Cancel" onclick="history.back()">
                </td>
            </tr>
        </table>
    </form>
    
    <p><strong>Note:</strong> Your question will be answered by our customer service representatives.</p>
    
    <div>
        <a href="customerQuestions.jsp">View All Questions</a> |
        <a href="welcome.jsp">Home</a>
    </div>
</body>
</html>