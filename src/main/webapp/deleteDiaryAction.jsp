<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>    
<%

	// 입력값 가져오기
	String diaryDate = request.getParameter("diaryDate");
	String memberPw = request.getParameter("memberPw");
	
	System.out.println(diaryDate + " ====== deleteDiaryAction diaryDate"); 
	System.out.println(memberPw + " ====== deleteDiaryAction memberPw"); 
	
	// DB 연결
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");

	String sql = "DELETE FROM diary WHERE diary_date = ?";
	
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, diaryDate);
	int row = stmt.executeUpdate();

	System.out.println(row + "========== deleteDiaryAction row");
	rs = stmt.executeQuery(); 

 	if(row == 1 ){ //디버깅 ->비번 실패시
		response.sendRedirect("/diary/diary.jsp");
		System.out.println("삭제성공");
	} else {
		response.sendRedirect("/diary/deleteDiaryForm.jsp?diaryDate="+diaryDate);
		System.out.println("삭제실패");
	}
 	
 	stmt.close();
    conn.close();
%>    
    
    
   