<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.net.*"%>
<%
	//0. 로그인 (인증) 분기
	String loginMember = (String) (session.getAttribute("loginMember"));
	// 세션 만료시
	if (loginMember == null) {
	
		String errMsg = URLEncoder.encode("잘못된 접근입니다. 로그인 해주세요.", "UTF-8");
		// OFF인 경우 loginForm 재호출 + 에러메세지
		response.sendRedirect("/diary/loginForm.jsp?errMsg=" + errMsg);
	
		return; // 코드 진행을 끝냄 -> 매서드를 끝낼 때
	
	}
%>
<%
	String diaryDate = request.getParameter("diaryDate");
	System.out.println(diaryDate + "====== diaryOne.jsp diaryDate");
	
	//-------------------- 일기 상세 내용 모델값 ------------------------//
	
	// DB 연결
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	PreparedStatement stmt1 = null;
	ResultSet rs1 = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	
	// 쿼리
	/* SELECT diary_no diaryNo, diary_date diaryDate, title, weather, content, update_date updateDate
	FROM diary
	WHERE diary_date = ?; 
	 */
	String sql = "SELECT diary_date diaryDate, title, weather, content, update_date updateDate FROM diary WHERE diary_date = ?";
	stmt1 = conn.prepareStatement(sql);
	stmt1.setString(1, diaryDate);
	
	System.out.println(stmt1);
	
	rs1 = stmt1.executeQuery();
%>

<!DOCTYPE html>

<html>
<head>
<meta charset="UTF-8">
<title></title>

<!-- bootstrap -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH"
	crossorigin="anonymous">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
	integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
	crossorigin="anonymous"></script>
<!-- google fonts -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link
	href="https://fonts.googleapis.com/css2?family=IBM+Plex+Sans+KR&display=swap"
	rel="stylesheet">

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
	
	.a {
		text-decoration: none; 
	       color: black; 
	}

</style>
</head>
<body class="container text-center"
	style="background-image: url(/diary/img/sky.jpg)">
	<div class="row justify-content-center">
		<div class="post-box">
			<div class="row">
				<div class="col-2 mt-3">
					<a href="/diary/diary.jsp">
					<img alt="" src="/diary/img/calendar.png" width="40px" height="40px"></a>
				</div>
				
				<div class="col-2 mt-3">
					<a href="/diary/diaryList.jsp">
					<img alt="" src="/diary/img/list.png" width="40px" height="40px"></a>
				</div>
				<div class="col-4 mt-3 mb-3" style="font-size: 30px;">하루 기록 보기</div>
				<div class="col-2 mt-3"></div>
				<div class="col-2 mt-3">
					<a href="/diary/lunchForm.jsp">
					<img alt="" src="/diary/img/restaurant.png" width="40px" height="40px"></a>
				</div>
			</div>
			
			<%
			if (rs1.next()) {
			%>

			<div class="row">
				<div class="col-md-6 input-group mb-3" style="width: 60%;">
					<span class="input-group-text px-2" style="width: 100px;">Date</span>
					<input type="text" class="form-control" name="date"
						value="<%=rs1.getString("diaryDate")%>" readonly="readonly">
				</div>


				<div class="col-md-6 mb-3" style="width: 40%;">
					<select class="form-select" aria-label="Default select example"
						name="weather">
						<option value="맑음"
							<%=rs1.getString("weather").equals("맑음") ? "selected" : ""%>>맑음</option>
						<option value="흐림"
							<%=rs1.getString("weather").equals("흐림") ? "selected" : ""%>>흐림</option>
						<option value="비"
							<%=rs1.getString("weather").equals("비") ? "selected" : ""%>>비</option>
						<option value="눈"
							<%=rs1.getString("weather").equals("눈") ? "selected" : ""%>>눈</option>
					</select>
				</div>
			</div>

			<div class="input-group mb-3">
				<span class="input-group-text" id="title" style="width: 100px;">Title</span>
				<input type="text" class="form-control" name="title"
					value="<%=rs1.getString("title")%>" aria-label="Username"
					aria-describedby="basic-addon1" readonly="readonly">
			</div>


			<div class="input-group pb-3">
				<span class="input-group-text" style="width: 100px;">Content</span>
				<textarea class="form-control" aria-label="With textarea"
					name="content" rows="10" cols="50" readonly="readonly"><%=rs1.getString("content")%></textarea>
			</div>

			<%
				}
			rs1.close();
			stmt1.close();
			%>

			<div class="btn-group mb-3 ">
				<div class="me-2">
					<a
						href="/diary/updateDiaryForm.jsp?diaryDate=<%=rs1.getString("diaryDate")%>"
						class="btn active"
						style="background-color: rgba(178, 204, 255, 0.7); border-color: rgba(178, 204, 255, 0.7);">수정하기</a>
				</div>

				<div class="me-2">
					<a href="/diary/deleteDiaryAction.jsp" class="btn active"
						style="background-color: rgba(178, 204, 255, 0.7); border-color: rgba(178, 204, 255, 0.7);">삭제하기</a>
				</div>

				<div class="me-2">
					<a href="/diary/logout.jsp" class="btn active"
						style="background-color: rgba(178, 204, 255, 0.7); border-color: rgba(178, 204, 255, 0.7);">logout</a>
				</div>
			</div>



			<!-- 댓글 입력 폼 -->
			<div class="d-flex align-items-center mb-3">
				<form method="post" action="/diary/addCommentAction.jsp" class="w-100 d-flex">
					<input type="hidden" name="diaryDate" value="<%=diaryDate%>">
					<textarea class="form-control me-2" rows="1" name="memo" placeholder="댓글을 입력하세요" style="flex: 3;"></textarea>
					<button class="btn button" type="submit" style="width: 100px;">댓글등록</button>
				</form>
			</div>



			<!-- 댓글 기능 -->
			<%
				String sql2 = "SELECT comment_no commentNo, diary_date diaryDate, memo, create_date createDate FROM comment where diary_date =?";
	
				PreparedStatement stmt2 = null;
				ResultSet rs2 = null;
	
				stmt2 = conn.prepareStatement(sql2);
				stmt2.setString(1, diaryDate);
				rs2 = stmt2.executeQuery();
			%>
			<table class="table">
				<%
					while (rs2.next()) {
				%>
					<tr>
						<td width="400px;"><%=rs2.getString("memo")%></td>
						<td width="200px;"><%=rs2.getString("createDate")%></td>
						<td >
							<a class="a" href="/diary/deleteCommentAction.jsp?commentNo=<%=rs2.getInt("commentNo")%>&diaryDate=<%=rs2.getString("diaryDate")%>">
							<img alt="" src="/diary/img/close.png" width="16px" height="16px">
							</a>
						</td>
					</tr>
				<%
					}
				rs2.close();
				stmt2.close();
				conn.close();
				%>

			</table>

		</div>
	</div>
</body>
</html>