<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>
<%
/* 	// ON -> 

	//쿼리부터 
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
	
	// 강제로 logout페이지를 불러왔을 때
	if(mySession.equals("OFF")) { 
		// 한글 인코딩
		String errMsg = URLEncoder.encode("잘못된 접근입니다. 로그인 해주세요.", "UTF-8");
		// OFF인 경우 loginForm 재호출 + 에러메세지
		response.sendRedirect("/diary/loginForm.jsp?errMsg=" + errMsg);	
		return; // 코드 진행을 끝냄 -> 매서드를 끝낼 때
		
	}
	
	// 현재값이 OFF가 아니고 ON이면(정상적인 logout) -> OFF로 변경 후 loginForm으로 재호출
	String sql2 = "UPDATE login SET my_session='OFF', off_date=NOW()";
	
	PreparedStatement stmt2 = null;
	ResultSet rs2 = null;
	stmt2 = conn.prepareStatement(sql2);
	int row = stmt2.executeUpdate();
	System.out.println(row + " ====== row");
	
	 */
	 
	 
	// session.removeAttribute("loginMember");
	// 세션 공간 초기화(포맷) -> 로그인할 때 할당된 공간 사라짐 -> 로그아웃
	session.invalidate(); 
	response.sendRedirect("/diary/loginForm.jsp");
	
	
%>




