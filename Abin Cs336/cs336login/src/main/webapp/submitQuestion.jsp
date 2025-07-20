<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ include file="dbConnection.jsp" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp?error=Please login to ask a question");
        return;
    }
    
    String question = request.getParameter("question");
    if (question == null || question.trim().isEmpty()) {
        response.sendRedirect("askQuestion.jsp?error=Please enter a question");
        return;
    }
    
    Connection conn = null;
    PreparedStatement ps = null;
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/reservation", "root", "polk6699");
        
        // Generate unique question ID
        Random rand = new Random();
        int qid = 1000 + rand.nextInt(9000);
        
        // Check if QID already exists and generate new one if needed
        PreparedStatement checkPs = conn.prepareStatement("SELECT QID FROM questions WHERE QID = ?");
        checkPs.setInt(1, qid);
        ResultSet checkRs = checkPs.executeQuery();
        while (checkRs.next()) {
            qid = 1000 + rand.nextInt(9000);
            checkPs.setInt(1, qid);
            checkRs = checkPs.executeQuery();
        }
        checkPs.close();
        
        // Insert question
        ps = conn.prepareStatement(
            "INSERT INTO questions (QID, AskedBy, Question, DateAsked) VALUES (?, ?, ?, NOW())"
        );
        ps.setInt(1, qid);
        ps.setString(2, username);
        ps.setString(3, question.trim());
        
        int rowsAffected = ps.executeUpdate();
        
        if (rowsAffected > 0) {
            response.sendRedirect("customerQuestions.jsp?message=Question submitted successfully");
        } else {
            response.sendRedirect("askQuestion.jsp?error=Failed to submit question");
        }
        
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("askQuestion.jsp?error=Submission failed: " + e.getMessage());
    } finally {
        try { if (ps != null) ps.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
%>