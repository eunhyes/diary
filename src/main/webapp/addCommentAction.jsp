<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>    
<%@ page import="java.util.*" %>    
<%
	//post방식 -> 인코딩
	request.setCharacterEncoding("UTF-8");

	// 입력값 선언
	String diaryDate = request.getParameter("diaryDate");
	String memo = request.getParameter("memo");
	// 디버깅 코드
	System.out.println(diaryDate + " ====== addCommentAction diaryDate");
	System.out.println(memo + " ====== addCommentAction memo");

	String sql = "INSERT INTO comment(diary_date, memo, update_date, create_date) VALUES (?, ?, NOW(), NOW())";
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	PreparedStatement stmt = conn.prepareStatement(sql);
	
	stmt.setString(1, diaryDate);
	stmt.setString(2, memo);
	
	// 디버깅 코드(stmt)
	System.out.println(stmt);
	
	int row = stmt.executeUpdate();
	
	if(row ==1) {
		
		System.out.println("입력성공");
		response.sendRedirect("/diary/diaryOne.jsp?diaryDate="+diaryDate);
	} else {
		
		System.out.println("입력실패");
		response.sendRedirect("/diary/diaryOne.jsp?diaryDate="+diaryDate);
	} 
			 
	stmt.close();
	conn.close();
				 
%>