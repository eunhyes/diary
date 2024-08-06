<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>
<%
/* // 로그인 (인증) 분기
	
	// diary.login.my_session (DB.table.column)
	// ==> 'ON' -> redirect("diary.jsp")
	
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
	
	if(mySession.equals("ON")) { 
		// ON인 경우 loginForm 재호출
		response.sendRedirect("/diary/diary.jsp");	
		
		return; // 코드 진행을 끝냄 -> 매서드를 끝낼 때
		
	}
	
*/
	// 0-1 로그인(인증) 분기 session 사용으로 변경
	// 로그인 성공시 세션에 loginMember 라는 변수를 만들고 값으로 로그인 아이디를 저장
	String loginMember = (String)(session.getAttribute("loginMember"));
	// 사용하는 Session API
	// session.getAttribute() -> 찾는 변수가 없으면 null 값을 반환
	// session.getAttribute(String) -> 변수 이름으로 변수값 반환
	// null = 로그인 한 적 X(로그아웃 상태) / null != 로그인 상태
	System.out.println ("----------- loginAction -----------");
	System.out.println(loginMember + "====== loginMember");

	
	// loginForm 페이지는 로그아웃 상태에서만 출력되는 페이지 -> 로그인 성공시 diary.jsp 로
	if(loginMember != null) {
		response.sendRedirect("/diary/diary.jsp");
		return; // 메서드 끝내기
	}
	
	String errMsg = request.getParameter("errMsg");
	
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
	
	.login-box {
	
	background-color: rgba(255, 255, 255, 0.5);
	margin: 150px;
	border-radius: 10px;
	width: 400px;
	
	}
	
	</style>
	
</head>
<body class="container text-center" style="background-image: url(/diary/img/sky.jpg)">
<div class="row justify-content-center">
	<div class="login-box">
	
		<div class="mt-5"><h3>MY DIARY</h3></div>
		<div class="mt-3">
			<%
				if(errMsg != null) {
			%>
				<%=errMsg %>		
		
			<%
				}
			
			%>
		</div>
		
		<form action="/diary/loginAction.jsp">
			<div style="text-align: left;">
			
				<div>
				    <label for="memberId" class="mt-2 px-2 form-label">ID</label>
				    <input type="text" class="form-control" id="memberId" placeholder="ID를 입력하세요" name="memberId">
				</div>
				
				<div>
				    <label for="memberPw" class="mt-2 px-2 form-label">PW</label>
				    <input type="password" class="form-control" id="memberPw" placeholder="비밀번호를 입력하세요" name="memberPw">
				</div>
			
				<div>
					<button type="submit" class="mt-3 mb-3 btn" style="width: 100%; background-color: rgba(178, 204, 255, 0.7); ">login</button>
				</div>
			
			</div>
	
		</form>
	</div>
</div>	
</body>
</html>