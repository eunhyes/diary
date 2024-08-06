<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>
<%
	//입력값 가져오기
	String diaryDate = request.getParameter("diaryDate");
	System.out.println("--------- deleteLunchAction ---------"); 
	System.out.println(diaryDate + " ======  diaryDate"); 

	// DB연결
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");

	String sql = "delete from lunch where lunch_date = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, diaryDate);
	
	int row = stmt.executeUpdate();
	
	if(row == 0) { // 삭제 X -> 다시 lunchOne.jsp 로
		
		response.sendRedirect("/diary/lunchOne.jsp?diaryDate="+diaryDate);
		
	} else { // 삭제 O -> 다시 diaryOne.jsp 로
		
		response.sendRedirect("/diary/diaryOne.jsp?diaryDate="+diaryDate);

	}
	stmt.close();
	conn.close();
	
%>    
    
