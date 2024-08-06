<%@page import="org.eclipse.jdt.internal.compiler.ast.WhileStatement"%>
<%@page import="javax.print.attribute.standard.Media"%>
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
/* SELECT menu, COUNT(*) FROM lunch
WHERE YEAR(lunch_date) = 2024
GROUP BY menu
ORDER BY COUNT(*) DESC; */
	// DB연결
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");

	// 전체 개수 구하기(메뉴 그룹별로)
	String sql2 = "SELECT menu, COUNT(*) cnt FROM lunch GROUP BY menu";

	PreparedStatement stmt2 = null;
	ResultSet rs2 = null;
	stmt2 = conn.prepareStatement(sql2);
	rs2 = stmt2.executeQuery();

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
				width: 800px;
				
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
	<%
		// 개수세기
		double maxHeight = 300;
		double totalCnt = 0;
		
		while(rs2.next()){
			
			totalCnt = totalCnt + rs2.getInt("cnt");
			
		}
		// 커서 다시 처음으로
		rs2.beforeFirst();

	%>		
			
<div>
	전체 메뉴 선택 수 : <%=(int)totalCnt %>

</div>

<div class="">
	<table border="1">
		<tr>
			<%
				int i = 0;
				// 그림그리기
				while(rs2.next()) {
					// 정수X -> double
					int h = (int)(maxHeight* (rs2.getInt("cnt")/totalCnt));
			
			%>
			
				<td style="vertical-align: bottom;">
					<div style="height: <%=h %>px; background-color: rgba(36, 87, 189, 0.8); text-align: center;">
						 <%=rs2.getInt("cnt") %>
					</div>
				
				</td>
					
			<%		
					i = i+1;
			
				}
			%>
		</tr>
		<tr>
			<%
				// 메뉴 읽어오기
				rs2.beforeFirst();
				
				while(rs2.next()) {
			%>
				<td><%=rs2.getString("menu") %></td>
			<%
				}
				
				rs2.close();
				stmt2.close();
				conn.close();
			%>
		
		</tr>
	
	</table>
</div>
</div>
</div>
</body>
</html>