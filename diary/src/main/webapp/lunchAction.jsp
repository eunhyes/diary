<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>
<%@ page import="java.util.*" %>        
 
<%
// 로그인 (인증) 분기
	// diary.login.my_session (DB.table.column)
	// ==> 'OFF' -> redirect("loginForm.jsp")
	// encoding
	request.setCharacterEncoding("UTF-8");
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
//점심 투표를 안 했을 때 -> 투표 폼(lunchForm.jsp) 보내기 -> 라디오버튼으로 선택 / 데이터 전송 
//점심 투표를 이미 했을 때 -> 투표 완료 폼(lunchOne.jsp) 보내기 -> 삭제 버튼 / 이전페이지로? -> diaryOne.jsp?diaryDate= 

//--------------------- lunch 투표 분기 --------------------//

/* SELECT lunch_date lunchDate, menu FROM lunch
WHERE lunch_date = CURDATE(); */

	String diaryDate = request.getParameter("diaryDate");
	String menu = request.getParameter("menu");
	//String lunchDate = request.getParameter("lunchDate");
	String checkLunch = request.getParameter("checkLunch");
 /* 	if(lunchDate == null) {
 		
 		lunchDate = diaryDate;
 	} */

	String lunchDate = diaryDate;
	// debug
	System.out.println("----------lunchAction-----------");
	System.out.println(diaryDate + " ====== lunchAction diaryDate");
	System.out.println(menu + " ====== lunchAction menu");
	System.out.println(lunchDate + " ====== lunchAction lunchDate");

	// 결과 값이 있으면 이미 기록한 것 -> 이미 존재하므로 lunchOne.jsp로 보내기
	String sql2 = "SELECT lunch_date lunchDate, menu FROM lunch WHERE lunch_date = ?";
	
	PreparedStatement stmt2 = null;
	ResultSet rs2 = null;
	stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1, diaryDate);
	rs2 = stmt2.executeQuery();
	System.out.println(stmt2 + " ====== lunchAction stmt2");
	if(rs2.next()) {
		// 결과 존재 = 이미 기록 O
		response.sendRedirect("/diary/lunchOne.jsp?diaryDate="+ diaryDate);
		
		
	} else {

%>
<%
	//----------------------- lunch 입력 ---------------------//


/* 	INSERT INTO lunch(lunch_date,menu,update_date,create_date)
	VALUES(CURDATE(), ?, NOW(), NOW()); */

	String sql3 = "INSERT INTO lunch(lunch_date, menu, update_date, create_date) VALUES(?, ?, NOW(), NOW())";
	
	PreparedStatement stmt3 = null;
	ResultSet rs3 = null;
	stmt3 = conn.prepareStatement(sql3);
	stmt3.setString(1, diaryDate);
	stmt3.setString(2, menu);
	
	System.out.println(stmt3);
	
 	int row = stmt3.executeUpdate();

	if(row ==1) {
		
		System.out.println("입력성공");
		response.sendRedirect("/diary/lunchOne.jsp?diaryDate="+ diaryDate);	

		
	} else {
		
		System.out.println("입력실패");
		response.sendRedirect("/diary/lunchForm.jsp?diaryDate="+ diaryDate);	 

	} 
			  
}
	
%>
