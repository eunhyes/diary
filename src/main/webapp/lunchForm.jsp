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

	String diaryDate = request.getParameter("diaryDate");
	String menu = request.getParameter("menu");
	String lunchDate = diaryDate;
 	if(lunchDate == null) {
 		
 		lunchDate = diaryDate;
 	}
	
	String checkLunch = request.getParameter("checkLunch");
	
	System.out.println("----------lunchForm-----------");
	System.out.println(diaryDate);
	System.out.println(menu);
	System.out.println(lunchDate);
	System.out.println("----------lunchForm-----------");
	

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
		padding-top: 20px;
		}
	</style>
	
	
</head>
<body class="container text-center" style="background-image: url(/diary/img/sky.jpg)">
<div class="row justify-content-center">
	<div class="post-box">
	<form method="post" action="/diary/lunchAction.jsp">
		<input type="hidden" name="diaryDate" value="<%=diaryDate %>">
		<div>
			<input type="radio" name="menu" value="한식">한식
			<input type="radio" name="menu" value="일식">일식
			<input type="radio" name="menu" value="중식">중식
			<input type="radio" name="menu" value="분식">분식
			<input type="radio" name="menu" value="양식">양식
			<input type="radio" name="menu" value="기타">기타
		</div>
	
	
	
		<div>
			<button type="submit"class="mt-3 mb-3 btn" style="width: 200px; background-color: rgba(178, 204, 255, 0.7);">투표하기</button>
		</div>
		
	
	</form>


</div>
</div>
</body>
</html>