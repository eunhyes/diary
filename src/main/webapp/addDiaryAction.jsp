<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>    
<%@ page import="java.util.*" %>    

<%
	// post방식 -> 인코딩
	request.setCharacterEncoding("UTF-8");

	// 입력값 선언
	String diaryDate = request.getParameter("diaryDate");
	String feeling = request.getParameter("feeling");
	String title = request.getParameter("title");
	String weather = request.getParameter("weather");
	String content = request.getParameter("content");
	String updateDate = request.getParameter("updateDate");
	String createDate = request.getParameter("createDate");
	// 디버깅 코드
	System.out.println(diaryDate + " ====== addDiaryAction diaryDate");
	System.out.println(title + " ====== title");
	System.out.println(weather + " ====== weather");
	System.out.println(content + " ====== content");
	System.out.println(updateDate + " ====== updateDate");
	System.out.println(createDate + " ====== createDate");

	// DB 연동, 쿼리 입력
	

/* 	INSERT INTO diary(diary_date, title, weather, content, update_date, create_date)
	VALUES(?, ?, ?, ?, NOW(), NOW());
	 */
	 
	String sql="INSERT INTO diary(diary_date, feeling, title, weather, content, update_date, create_date) VALUES(?, ?, ?, ?, ?, NOW(), NOW())";
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	PreparedStatement stmt = conn.prepareStatement(sql);
	
	 // ? 4개 -> diary_date, title, weather, content
	stmt.setString(1, diaryDate);
	stmt.setString(2, feeling);
	stmt.setString(3, title);
	stmt.setString(4, weather);
	stmt.setString(5, content);

	// 디버깅 코드(stmt)
	System.out.println(stmt);
			 
	int row = stmt.executeUpdate();

	if(row ==1) {
		
		System.out.println("입력성공");
		
	} else {
		
		System.out.println("입력실패");
		
	} 
			 
	stmt.close();
	conn.close();
			 
	// diary.jsp 페이지 재요청(redirect)
	response.sendRedirect("/diary/diary.jsp");	
			 
%>

    