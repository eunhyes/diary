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
	String sql = "SELECT diary_no diaryNo, diary_date diaryDate, title, weather, content, update_date updateDate FROM diary WHERE diary_date = ?";
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
</style>
</head>
<body class="container text-center"
	style="background-image: url(/diary/img/sky.jpg)">
	<div class="row justify-content-center">
		<div class="post-box">
			<div>
				<a href="/diary/diary.jsp">다이어리모양으로보기</a> <a
					href="/diary/diaryList.jsp">게시판모양으로보기</a> <a
					href="/diary/lunchForm.jsp?diaryDate=<%=diaryDate%>">점심 메뉴
					기록하기</a>
			</div>
			<div class="mt-3 mb-3" style="font-size: 30px;">하루 기록 보기</div>

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
			<div>
				<form method="post" action="/diary/addCommentAction.jsp">
					<input type="hidden" name="diaryDate" value="<%=diaryDate%>">
					<textarea rows="2" cols="50" name="memo"></textarea>
					<button type="submit">댓글등록</button>
				</form>

			</div>

			<!-- 댓글 기능 -->
			<%
				String sql2 = "select comment_no commentNo, memo, create_date createDate from comment where diary_date =?";
	
				PreparedStatement stmt2 = null;
				ResultSet rs2 = null;
	
				stmt2 = conn.prepareStatement(sql2);
				stmt2.setString(1, diaryDate);
				rs2 = stmt2.executeQuery();
			%>
			<table border="1">
				<%
					while (rs2.next()) {
				%>
					<tr>
						<td><%=rs2.getString("memo")%></td>
						<td><%=rs2.getString("createDate")%></td>
						<td>
							<a href="/diary/deleteComment.jsp?commentNo=<%=rs2.getInt("commentNo")%>">수정</a>
						</td>
					</tr>

				<%
					}
				%>

			</table>

		</div>
	</div>
</body>
</html>