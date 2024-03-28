<%@page import="org.mariadb.jdbc.export.Prepare"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>    
<%@ page import="java.util.*" %>    
<%
//====================== 로그인 인증 분기 ========================//
// 로그인 상태일 경우 페이지가 나오도록 session의 On, Off 상태 분기

	/*
	INSERT INTO MEMBER(member_id, member_pw)
	VALUES('1', '1');
	
	SELECT *FROM MEMBER;
	
	SELECT MEMBER_id memberId
	FROM member
	WHERE member_id = '1' AND member_pw='1';
	
	
	DELETE FROM board WHERE NO=542 and pw='1234';
	
	UPDATE login SET my_session="ON", on_date = NOW();
	*/


	// 로그인 (인증) 분기
	// diary.login.my_session (DB.table.column)
	// ==> 'OFF' -> redirect("loginForm.jsp")
	
	// 쿼리
	String sql1 = "SELECT my_session mySession FROM login";
	// DB연결
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	PreparedStatement stmt1 = null;
	ResultSet rs1 = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	stmt1 = conn.prepareStatement(sql1);
	rs1 = stmt1.executeQuery();
	
	// 로그인 -> ON, OFF 경우 나누기
	String mySession = null;
	
	if(rs1.next()) {
		
		mySession = rs1.getString("mySession");
		
	}
	
	if(mySession.equals("OFF")) { 
		// 한글 인코딩
		String errMsg = URLEncoder.encode("잘못된 접근입니다. 로그인 해주세요.", "UTF-8");
		// OFF인 경우 loginForm 재호출 + 에러메세지
		response.sendRedirect("/diary/loginForm.jsp?errMsg=" + errMsg);	
		// DB 자원 반납 -> return 전에
		rs1.close();
		stmt1.close();
		conn.close();
		
		return; // 코드 진행을 끝냄 -> 매서드를 끝낼 때
		
	}

%>        
<%

//=================== diaryList 페이징 =====================//
/* 	SELECT diary_date diaryDate, title
	FROM diary
	WHERE title LIKE ? -- "%"+searchWord+"%"  // '%%' -> 전체 ( 검색어가 없을 때 )
	ORDER BY diary_date DESC
	LIMIT ?, ?; -- startRow, rowPerPage */

	int currentPage = 1;
	if(request.getParameter("currentPage") != null){
		
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
		
	}
	
	int rowPerPage = 10;
/* 	if(request.getParameter("rowPerPage") != null){
			
		rowPerPage = Integer.parseInt(request.getParameter("rowPerPage"));
			
		}
 */
 
	// 1-10, 11-20, 21-30 ...
	int startRow = (currentPage - 1) * rowPerPage;
	// null은 절대 들어올 수 없음(공백=전체)
	String searchWord ="";
	if(request.getParameter("searchWord") != null){
			
		searchWord = request.getParameter("searchWord");
			
		}
	
	String sql2 = "SELECT diary_date diaryDate, title FROM diary WHERE title LIKE ? ORDER BY diary_date DESC LIMIT ?, ?";
	
	PreparedStatement stmt2 = null;
	ResultSet rs2 = null;
	
	stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1, "%"+searchWord+"%");
	stmt2.setInt(2, startRow);
	stmt2.setInt(3, rowPerPage);
	
	rs2 = stmt2.executeQuery();
	
//------------------ lastPage 모듈 --------------------//
	// 공백이 들어가도록 -> 전체 개수(검색)
	String sql3 = "SELECT count(*) cnt from diary where title like ?";
	
	PreparedStatement stmt3 = null;
	ResultSet rs3 = null;
	
	stmt3 = conn.prepareStatement(sql3);
	stmt3.setString(1, "%"+searchWord+"%");
	rs3 = stmt3.executeQuery();
	
	int totalRow = 0;
	
	if(rs3.next()) {
		
		totalRow = rs3.getInt("cnt");
		
	}
	int lastPage = totalRow / rowPerPage;
	if(totalRow % rowPerPage != 0) {
		
		lastPage = lastPage + 1;
	}
	
	
%>    
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title></title>
	
		<!-- bootstrap -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
	<!-- google fonts -->
	<link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
	<link href="https://fonts.googleapis.com/css2?family=IBM+Plex+Sans+KR&display=swap" rel="stylesheet">
	
</head>
<body>
	
	<form method="get" action="/diary/diary.jsp">
	
		<div>
			제목 검색 :
			<input type="text" name="searchWord">
			<button type="submit">검색</button>
		</div>
	
	</form>
	
	<table>
		<tr>
			<td>날짜</td>
			<td>제목</td>
		
		</tr>
		<%
			while(rs2.next()) {
		
		%>
		<tr>
			<td><%=rs2.getString("diaryDate") %></td>
			<td><%=rs2.getString("title") %></td>
		</tr>
	
		<%
			}
		%>
	
	</table>
	
	<a href="">이전</a>
	<a href="">다음</a>
	
	
	



</body>
</html>