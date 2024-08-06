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

//=================== diaryList 페이징 =====================//
/* 	SELECT diary_date diaryDate, title
	FROM diary
	WHERE title LIKE ? -- "%"+searchWord+"%"  // '%%' -> 전체 ( 검색어가 없을 때 )
	ORDER BY diary_date DESC
	LIMIT ?, ?; -- startRow, rowPerPage */
	
	// DB연결
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");

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
	
	rs3.close();
 	stmt3.close();
%>    
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Diary List</title>
	
	<!-- bootstrap -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
	<!-- google fonts -->
	<link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
	<link href="https://fonts.googleapis.com/css2?family=IBM+Plex+Sans+KR&display=swap" rel="stylesheet">
		
	<style>
	body {
		background-image: url('/diary/img/sky.jpg');
		background-size: cover;
		height: 100vh;
		display: flex;
		align-items: center;
		justify-content: center;
		font-family: 'IBM Plex Sans KR', sans-serif;
	}

	.post-box {
		background-color: rgba(255, 255, 255, 0.5);
		padding: 30px;
		border-radius: 10px;
		width: 100%;
		max-width: 800px;
		box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
	}

	.table {
		margin-top: 20px;
	}

	.table th, .table td {
		vertical-align: middle;
	}

	.button {
		background-color: rgba(178, 204, 255, 0.7);
		color: #000;
		border: none;
		padding: 10px 20px;
		cursor: pointer;
	}

	.button:hover {
		background-color: rgba(178, 204, 255, 1);
		color: #fff;
	}

	.pagination {
		display: flex;
		justify-content: center;
		margin-top: 20px;
	}
	</style>
</head>
<body>
	<div class="post-box">
		<div class="d-flex justify-content-center mb-3">
			<div class="row">
				<div class="col-1 me-3">
					<a href="/diary/diary.jsp">
					<img alt="" src="/diary/img/calendar.png" width="40px" height="40px"></a>
				</div>
				
				<div class="col-1 me-3">
					<a href="/diary/diaryList.jsp">
					<img alt="" src="/diary/img/list.png" width="40px" height="40px"></a>
				</div>
				<div class="col-4">
					<form method="get" action="/diary/diaryList.jsp">
						<div class="input-group mb-3" style="width: 400px;">
							<input type="text" class="form-control" name="searchWord" placeholder="제목 검색" value="<%=searchWord %>">
							<button class="btn button" type="submit">검색</button>
						</div>
					</form>
				</div>	
			</div>
			<div class="col-1">
					<a href="/diary/statsLunch.jsp">
					<img alt="" src="/diary/img/restaurant.png" width="40px" height="40px"></a>
				</div>
		</div>
		<table class="table table-hover">
			<thead>
				<tr>
					<th scope="col">날짜</th>
					<th scope="col">제목</th>
				</tr>
			</thead>
			<tbody>
			<%
				while(rs2.next()) {
			%>
				<tr onclick="location.href='/diary/diaryOne.jsp?diaryDate=<%=rs2.getString("diaryDate") %>'">
					<td><%=rs2.getString("diaryDate") %></td>
					<td><%=rs2.getString("title") %></td>
				</tr>
			<%
				}
				rs2.close();
			 	stmt2.close();
			    conn.close();
			%>
			</tbody>
		</table>
		
		<div class="pagination">
			<a class="btn btn-outline-primary <%= currentPage == 1 ? "disabled" : "" %>" href="?currentPage=<%= currentPage - 1 %>&searchWord=<%= URLEncoder.encode(searchWord, "UTF-8") %>">이전</a>
			<a class="btn btn-outline-primary <%= currentPage == lastPage ? "disabled" : "" %>" href="?currentPage=<%= currentPage + 1 %>&searchWord=<%= URLEncoder.encode(searchWord, "UTF-8") %>">다음</a>
		</div>
	</div>
</body>
</html>
