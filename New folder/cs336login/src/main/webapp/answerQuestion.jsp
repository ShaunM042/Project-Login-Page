<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ include file="dbConnection.jsp" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp?error=Please+login+to+answer+questions");
        return;
    }
    
    String qidStr = request.getParameter("qid");
    String answer = request.getParameter("answer");
    
    if (qidStr == null || answer == null || answer.trim().isEmpty()) {
        response.sendRedirect("customerQuestions.jsp?error=Invalid+question+or+answer");
        return;
    }
    
    Connection conn = null;
    PreparedStatement ps = null;
    
    try {
        conn = getConnection();
        
        int qid = Integer.parseInt(qidStr);
        
        // Generate unique answer ID
        Random rand = new Random();
        int aid = 1000 + rand.nextInt(9000);
        
        // Check if AID already exists and generate new one if needed
        PreparedStatement checkPs = conn.prepareStatement("SELECT AID FROM answers WHERE AID = ?");
        checkPs.setInt(1, aid);
        ResultSet checkRs = checkPs.executeQuery();
        while (checkRs.next()) {
            aid = 1000 + rand.nextInt(9000);
            checkPs.setInt(1, aid);
            checkRs = checkPs.executeQuery();
        }
        checkPs.close();
        
        // Insert answer
        ps = conn.prepareStatement(
            "INSERT INTO answers (AID, QID, AnsweredBy, Answer, DateAnswered) VALUES (?, ?, ?, ?, NOW())"
        );
        ps.setInt(1, aid);
        ps.setInt(2, qid);
        ps.setString(3, username);
        ps.setString(4, answer.trim());
        
        int rowsAffected = ps.executeUpdate();
        
        if (rowsAffected > 0) {
            response.sendRedirect("customerQuestions.jsp?message=Answer submitted successfully");
        } else {
            response.sendRedirect("customerQuestions.jsp?error=Failed to submit answer");
        }
        
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("customerQuestions.jsp?error=Answer submission failed: " + e.getMessage());
    } finally {
        try { if (ps != null) ps.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
%>