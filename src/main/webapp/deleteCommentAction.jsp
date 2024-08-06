<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>    
<%
	//입력값 가져오기
	String commentNo = request.getParameter("commentNo");
	String diaryDate = request.getParameter("diaryDate");
	// 디버깅 코드
	System.out.println(commentNo + " ====== deleteCommentAction commentNo"); 
	System.out.println(diaryDate + " ====== deleteCommentAction diaryDate"); 
	
	// DB 연결
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");

	String sql = "DELETE FROM comment WHERE comment_no = ?";
	
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, commentNo);
	
	System.out.println(stmt);
	
	int row = stmt.executeUpdate();
	
	if(row == 1 ){ //디버깅 ->비번 실패시
		response.sendRedirect("/diary/diaryOne.jsp?diaryDate="+diaryDate);
		System.out.println("삭제성공");
	} else {
		response.sendRedirect("/diary/diaryOne.jsp?diaryDate="+diaryDate);
		System.out.println("삭제실패");
	}
	
	stmt.close();
    conn.close();
%>