<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>
<%
	// 인증 분기
	
	// 로그인상태에서만 들어올 수 있음 (OFF상태에서는 X)

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
	
// 일기 기록 가능한지 분기
	String checkDate = request.getParameter("checkDate");
	
	String sql2 = "select diary_date diaryDate from diary where diary_date=?";
	// 결과가 있으면 -> 입력 X -> 이 날짜에 일기가 있기 때문에
	ResultSet rs2 = null;
	PreparedStatement stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1,checkDate);
	
	rs2 = stmt2.executeQuery();
	
	if(rs2.next()) {
		// 일기 기록 불가능 -> 결과가 있음 = 일기가 이미 존재함
		response.sendRedirect("/diary/addDiaryForm.jsp?checkDate="+ checkDate + "&ck=F");	

		
	} else {
		// 일기 기록 가능 -> 결과가 없음 = 일기 없음
		response.sendRedirect("/diary/addDiaryForm.jsp?checkDate="+ checkDate + "&ck=T");	

	}
	
	
	
	
	
	


	
	
%>