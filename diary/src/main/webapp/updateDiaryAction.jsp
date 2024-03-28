<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>    
<%@ page import="java.util.*" %>   
<%


/* UPDATE diary
SET title = '랄라',
weather = '맑음',
content = '집중력',
update_date = NOW()
WHERE diary_date = '2024-03-22'; */


	//입력값 선언
	String diaryDate = request.getParameter("diaryDate");
	String title = request.getParameter("title");
	String weather = request.getParameter("weather");
	String content = request.getParameter("content");
	String updateDate = request.getParameter("updateDate");
	String createDate = request.getParameter("createDate");
	// 디버깅 코드
	System.out.println(diaryDate + " ====== updateDiaryAction diaryDate");
	System.out.println(title + " ====== title");
	System.out.println(weather + " ====== weather");
	System.out.println(content + " ====== content");
	System.out.println(updateDate + " ====== updateDate");
	System.out.println(createDate + " ====== createDate");
	
	// 쿼리 -> title, weather, content, update_date, diary_date
	String sql1 = "UPDATE diary SET title = ?, weather = ?, content = ?, update_date = NOW() WHERE diary_date = ?;";
	//DB 연결
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	PreparedStatement stmt1 = null;
	ResultSet rs1 = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	stmt1 = conn.prepareStatement(sql1);
	int row = 0;
	stmt1.setString(1, title);
	stmt1.setString(2, weather);
	stmt1.setString(3, content);
	stmt1.setString(4, title);
	stmt1.setString(5, diaryDate);

	row = stmt1.executeUpdate();
	
	
	if(row == 1) { // 수정 성공
		
		System.out.println("수정 성공");

		response.sendRedirect("/diary/diary/diaryOne.jsp?diaryDate="+diaryDate);
	
	} else { // 수정 실패
		
		response.sendRedirect("/diary/diary/updateDiaryFrom.jsp?diaryDate="+diaryDate);
		
	}
	
	stmt1.close();
	conn.close();
	
	

%>