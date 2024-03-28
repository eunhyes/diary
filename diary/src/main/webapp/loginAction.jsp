<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>    
<%
	//로그인 (인증) 분기


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
	
	// 1. 요청값 분석
	String memberId = request.getParameter("memberId");
	String memberPw = request.getParameter("memberPw");
	
	// 쿼리 생성
	String sql2 = "SELECT MEMBER_id memberId FROM member WHERE member_id =? AND member_pw=?";

	PreparedStatement stmt2 = null;
	ResultSet rs2 = null;
	stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1,memberId);
	stmt2.setString(2,memberPw);
	rs2= stmt2.executeQuery();

	if(rs2.next()) {
		// 로그인 성공시 (쿼리에 뜸)
		// diary.login.my_session -> "ON"으로 변경
		
		System.out.println("로그인 성공");
		String sql3 = "UPDATE login SET my_session= 'ON', on_date = NOW()";
		
		PreparedStatement stmt3 = null;
		ResultSet rs3 = null;
	
		stmt3 = conn.prepareStatement(sql3);
		int row = stmt3.executeUpdate();
		System.out.println(row+ " ====== row");
		response.sendRedirect("/diary/diary.jsp");
		
		
	} else {
		// 로그인 실패시
		System.out.println("로그인 실패");

		// 에러메세지 후 로그인페이지 재요청
		String errMsg = URLEncoder.encode("아이디 또는 비밀번호가 일치하지 않습니다.", "UTF-8");
		response.sendRedirect("/diary/loginForm.jsp?errMsg=" + errMsg);	
		
		
	}
	
	
	
	
	
	
	// if문에 안 걸릴 때 자원 반납
	rs1.close();
	stmt1.close();
	
	rs2.close();
	stmt2.close();
	conn.close();
	
	
	
	
	
	

%>