<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>
<%@ page import="java.util.*" %>        
 
<%
// 로그인 (인증) 분기
	// diary.login.my_session (DB.table.column)
	// ==> 'OFF' -> redirect("loginForm.jsp")
	
	// 쿼리부터 
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
// 점심 투표를 안 했을 때 -> 투표 폼 보내기 -> 라디오버튼으로 선택 / 데이터 전송 
// 점심 투표를 이미 했을 때 -> 투표 완료 폼 보내기 -> 삭제 버튼 / 이전페이지로? -> diaryOne.jsp?diaryDate= 

	String diaryDate = request.getParameter("diaryDate");
	String lunchDate = request.getParameter("lunchDate");
 	if(lunchDate == null) {
 		
 		lunchDate = diaryDate;
 	}
	// debug
	System.out.println("----------lunchAction-----------");
	System.out.println(diaryDate + " ====== lunchAction diaryDate");
	System.out.println(lunchDate + " ====== lunchAction lunchDate");

	// 결과 값이 있으면 이미 기록한 것 -> 이미 존재하므로 lunchOne.jsp로 보내기
	String sql2 = "SELECT menu FROM lunch WHERE lunch_date = ?";
	
	PreparedStatement stmt2 = null;
	ResultSet rs2 = null;
	stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1, diaryDate);
	rs2 = stmt2.executeQuery();
	
	if(rs2.next()){
		
		String menu = rs2.getString("menu");
	}
	
%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title></title>
	
	<style type="text/css">
	
		.back-box {
	
			background-color: rgba(255, 255, 255, 0.5);
			border-radius: 10px;
			width: 400px;
			padding-top: 20px;
			
			}
	
	</style>
	
	<!-- bootstrap -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
	<!-- google fonts -->
	<link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
	<link href="https://fonts.googleapis.com/css2?family=IBM+Plex+Sans+KR&display=swap" rel="stylesheet">
	
</head>
<body class="container text-center" style="background-image: url(/diary/img/sky.jpg)">
<div class="row">
<div class="back-box mt-5">

	<div class="mb-3">
		이미 기록했습니다.	
	</div>
	
	<div class="mb-3">메뉴는 <%=rs2.getString("menu") %>입니다. </div>


	<div class="btn-group mb-3" style="background-color:  rgba(178, 204, 255, 0.7);">
		<a class="btn" href="/diary/deleteLunch.jsp">삭제하기</a>
		<a class="btn" href="/diary/diaryOne.jsp?diaryDate=<%=diaryDate%>">이전으로</a>
		<a class="btn" href="/diary/statsLunch.jsp">점심통계보기</a>
	</div>

</div>
</div>
</body>
</html>