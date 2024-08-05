<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>    
<%@ page import="java.util.*" %>       
<%
//0. 로그인 (인증) 분기
	String loginMember = (String)(session.getAttribute("loginMember"));
	// 세션 만료시
	if(loginMember == null) {
		
		String errMsg = URLEncoder.encode("잘못된 접근입니다. 로그인 해주세요.", "UTF-8");
		// OFF인 경우 loginForm 재호출 + 에러메세지
		response.sendRedirect("/diary/loginForm.jsp?errMsg=" + errMsg);
		
		return; // 코드 진행을 끝냄 -> 매서드를 끝낼 때

	}

%>
<%

	//입력값 선언
	String diaryDate = request.getParameter("diaryDate");
	// 디버깅 코드
	System.out.println(diaryDate + " ====== updateDiaryForm diaryDate");

	// 쿼리 -> diaryDate, title, weather, content, updateDate, createDate
	String sql1 = "SELECT diary_date diaryDate, title, weather, content, update_date updateDate, create_date createDate FROM diary WHERE diary_date = ?;";

	//DB 연결
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	PreparedStatement stmt1 = null;
	ResultSet rs1 = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	stmt1 = conn.prepareStatement(sql1);
	stmt1.setString(1, diaryDate);
	rs1 = stmt1.executeQuery();
	
	if(rs1.next()) {
	

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


	<style type="text/css">
	
	.post-box {
	
	background-color: rgba(255, 255, 255, 0.5);
	margin: 100px;
	border-radius: 10px;
	width: 800px;
	
	}
	
	</style>
	
</head>
<body class="container text-center" style="background-image: url(/diary/img/sky.jpg)">
<div class="row justify-content-center">
	<div class="post-box">
		<div>
			<a href="/diary/diary.jsp">다이어리모양으로보기</a>
			<a href="/diary/diaryList.jsp">게시판모양으로보기</a>
		</div>
		<div class="mt-3 mb-3" style="font-size: 30px;">수정하기</div>
	
<hr>
	
		<form method="post" action="/diary/updateDiaryAction.jsp">
		
			<div class="row">
			<div class="col-md-6 input-group mb-3" style="width: 60%;">
				<span class="input-group-text px-2" style="width: 100px;">Date</span>
				<input type="text" class="form-control" name="diaryDate" value="<%=rs1.getString("diaryDate") %>" readonly="readonly">
			</div>
			
			<div class="col-md-6 mb-3" style="width: 40%;">
				<select class="form-select" aria-label="Default select example" name="weather">
					<option value="맑음">맑음</option>
					<option value="흐림">흐림</option>
					<option value="비">비</option>
					<option value="눈">눈</option>
				</select>
			</div>
			</div>
			
			<div class="input-group mb-3">
			  <span class="input-group-text" id="title" style="width: 100px;">Title</span>
			  <input type="text" class="form-control" name="title" value="<%=rs1.getString("title") %>" aria-label="Username" aria-describedby="basic-addon1">
			</div>
	
			<div class="input-group">
			  <span class="input-group-text" style="width: 100px;">Content</span>
			  <textarea class="form-control" aria-label="With textarea" name="content" rows="8" cols="50"><%=rs1.getString("content") %></textarea>
			</div>
			
			<div>
				<button type="submit" class="mt-3 mb-3 btn" style="width: 100%; background-color: rgba(178, 204, 255, 0.7); ">완료</button>
			</div>	
				
		</form>
	
	</div>
</div>			
</body>
</html>

<%
	}
%>

