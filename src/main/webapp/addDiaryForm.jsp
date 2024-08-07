<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>
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

	// DB연결
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");

	// 일기 기록이 이미 있는 경우 -> ck="F" -> 기록X 	
	String diaryDate = request.getParameter("diaryDate");
	String checkDate = request.getParameter("checkDate");
	
	if(checkDate == null) {
		// null이 들어가지 않도록 공백처리 
		checkDate = "";
	}
	String ck = request.getParameter("ck");
	if(ck == null) {
		// null이 들어가지 않도록 공백처리 
		ck = "";
	}
	
	String msg = "";
	// checkDateAction에서 일기 기록 가능 분기
	if(ck.equals("T")) {
		
		msg = "입력이 가능한 날짜입니다";
		
	} else if(ck.equals("F")) {
		
		msg = "일기가 이미 존재하는 날짜입니다";
	}
	
	conn.close();
	
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
	
	.button {
	
	background-color: rgba(178, 204, 255, 0.7);
	color: rgb(0, 0, 0);
	border-color: rgba(178, 204, 255, 0.7);
	
	}
	
	</style>
</head>

<body class="container text-center" style="background-image: url(/diary/img/sky.jpg)">
<div class="row justify-content-center ">
	<div class="post-box">
		<div class="row">
			<div class="col-2 mt-3 me-3">
				<a href="/diary/diary.jsp">
				<img alt="" src="/diary/img/calendar.png" width="40px" height="40px"></a>
			</div>
			
			<div class="col-1 mt-3 me-3">
				<a href="/diary/diaryList.jsp">
				<img alt="" src="/diary/img/list.png" width="40px" height="40px"></a>
			</div>
			<div class="col-5 mt-3 mb-3" style="font-size: 30px;">하루 기록하기</div>
			<div class="col-4"></div>
		</div>
	<!-- 입력막기 -->
	<form method="post" action="/diary/checkDateAction.jsp">
		
		<div class="input-group mb-3">
		  <span class="input-group-text">checkDate</span>
		  <input type="date" name="checkDate" value="checkDate" class="form-control" >
		  <button class="btn" type="submit" id="button-addon2" style="background-color: rgba(178, 204, 255, 0.7);">check</button>
		  <span class="input-group-text"><%=msg %></span>
		</div>
		
	</form>
	
<hr>

	<form method="post" action="/diary/addDiaryAction.jsp">
	
		<div class="row">
		<div class="col-md-6 input-group mb-3" style="width: 300px;">
			<span class="input-group-text px-2" style="width: 100px;">Date</span>
			<%
				if(ck.equals("T")) {
			%>
			
			<input type="text" class="form-control" id="diaryDate" name="diaryDate" value="<%=checkDate %>" readonly="readonly">
			
			<%
				} else {
			
			%>
			<input type="text" class="form-control" id="diaryDate" name="diaryDate" value="">
			
			<%
				}
			
			%>
			
		</div>
		
		<div class="col-md-6 mt-2 mb-3" style="width: 300px; text-align: center; vertical-align: middle;">
			<label><input type="radio" name="feeling" value="&#128525;">&#128525;</label>
			<label><input type="radio" name="feeling" value="&#128521;">&#128521;</label>
			<label><input type="radio" name="feeling" value="&#128528;">&#128528;</label>
			<label><input type="radio" name="feeling" value="&#128549;">&#128549;</label> 
			<label><input type="radio" name="feeling" value="&#128565;">&#128565;</label>
			<label><input type="radio" name="feeling" value="&#128545;">&#128545;</label>
		</div>
		
		<div class="col-md-6 mb-3" style="width: 200px;">
			<select class="form-select" aria-label="Default select example" name="weather">
				<option value="맑음">맑음 &#127774;</option>
				<option value="흐림">흐림 &#9925;</option>
				<option value="비">비 &#9748;</option>
				<option value="눈">눈 &#9924;</option>
			</select>
		</div>
		</div>
		
		<div class="input-group mb-3">
		  <span class="input-group-text" id="title" style="width: 100px;">Title</span>
		  <input type="text" class="form-control" name="title" placeholder="제목을 입력해주세요." aria-label="Username" aria-describedby="basic-addon1">
		</div>
		

		<div class="input-group">
		  <span class="input-group-text" style="width: 100px;">Content</span>
		  <textarea class="form-control" aria-label="With textarea" name="content" rows="8" cols="50"></textarea>
		</div>
		
		<div>
			<button type="submit" class="mt-3 mb-3 btn" style="width: 100%; background-color: rgba(178, 204, 255, 0.7); ">완료</button>
		</div>	
			
	</form>
	
	</div>
</div>			
</body>
</html>