<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>
<%@ page import="java.util.*" %>    

<%
// 0. 로그인 (인증) 분기
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
	// 달력 출력
	
	// 1. 요청 분석
	// 출력하고자 하는 달력의 년과 월 값을 넘겨받는다
	String targetYear = request.getParameter("targetYear");
	String targetMonth = request.getParameter("targetMonth");

	Calendar target = Calendar.getInstance(); // target에 오늘 날짜 넣기
	
	if(targetYear != null && targetMonth != null) { // 둘 다 null이 아니면 -> 둘 다 나오면
		
		target.set(Calendar.YEAR, Integer.parseInt(targetYear));
		target.set(Calendar.MONTH, Integer.parseInt(targetMonth)); // 출력하고자 하는 년도, 월 값 구하기
		
	}
	
	// 시작 공백의 개수 -> 1일의 요일 필요 -> 요일에 맵핑된 숫자값 구하기 -> 타겟 날짜를 1일로 변경 ... 년도, 월 먼저 설정 후
	target.set(Calendar.DATE, 1);
	// 달력 타이들로 출력할 변수
	int tYear = target.get(Calendar.YEAR);
	int tMonth = target.get(Calendar.MONTH);
	
	int yoNum = target.get(Calendar.DAY_OF_WEEK); // 일 = 1, 월 = 2 ... 토 = 7
	System.out.println(yoNum);
	// 시작 공백의 개수 : 일 = 0, 월 = 1, 화 = 2 ... 토 = 6 --> yoNum -1 = startBlank
	int startBlank = yoNum - 1;
	int lastDate = target.getActualMaximum(Calendar.DATE); // target 달의 마지막 날 날짜 반환
	System.out.println(lastDate + "====== lastDate");
	int countDiv = startBlank + lastDate;
	
	// 1. 월을 숫자에서 영어로 변수 선언
	String strMonth = "";
	
	if(tMonth == 0) {
		
		strMonth = "JANUARY";
		
	} else if(tMonth == 1) {
		
		strMonth = "FABRUARY";
		
	} else if(tMonth == 2) {
		
		strMonth = "MARCH";
		
	} else if(tMonth == 3) {
		
		strMonth = "APRIL";
	
	} else if(tMonth == 4) {
		
		strMonth = "MAY";
	
	} else if(tMonth == 5) {
		
		strMonth = "JUNE";
	
	} else if(tMonth == 6) {
		
		strMonth = "JULY";
	
	} else if(tMonth == 7) {
		
		strMonth = "AUGUST";
	
	} else if(tMonth == 8) {
		
		strMonth = "SEPTEMBER";
	
	} else if(tMonth == 9) {
		
		strMonth = "OCTOBER";
	
	} else if(tMonth == 10) {
		
		strMonth = "NOVEMBER";
	
	} else if(tMonth == 11) {
		
		strMonth = "DECEMBER";
	
	} 
	
	
	
	// 2. 전달, 다음달 화살표로 설정
	
	
	// 3. 오늘 날짜는 배경 색 바꾸기
	
	Calendar today = Calendar.getInstance();
	int todayYear = today.get(Calendar.YEAR);
    int todayMonth = today.get(Calendar.MONTH);
    int todayDate = today.get(Calendar.DATE);
	
%>
<%
	// DB에서 tYear와 tMonth에 해당되는 diary목록 추출 -> 달력에 title 출력
	
/* 	SELECT day(diary_date) day, LEFT(title, 5) title
FROM diary
WHERE YEAR(diary_date) = 2024
AND MONTH(diary_date) = 3 ;

-- tYear
-- tMonth + 1
 */

	String sql2 = "select diary_date diaryDate, feeling,  day(diary_date) day, left(title, 5) title from diary where year(diary_date)=? and month(diary_date)=?";
	// DB연결
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	PreparedStatement stmt2 = null;
	ResultSet rs2 = null;
	stmt2 = conn.prepareStatement(sql2);
	stmt2.setInt(1,tYear);
	stmt2.setInt(2,tMonth + 1);
	System.out.println(stmt2);
	
	rs2 = stmt2.executeQuery();
 
%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title></title>
	<style type="text/css">
	
/* 	.calendar {
			background-color: rgba(255, 255, 255, 0.5);
			margin: 100px;
			border-radius: 10px;
			width: 800px;
			text-align: center;
		
		} */
	
	.back-box {
	
			background-color: rgba(255, 255, 255, 0.5);
			border-radius: 10px;
			width: 800px;
			box-sizing: border-box;
			
			}
	
/* 	.cell {
			display: flex;
			width :calc(100%/7);
			height : 70px;;
			text-align: center;
			margin : 0 0;
			border-radius: 4px;
			box-sizing: border-box;
			flex-wrap: wrap;
			
		} */
		
	.sat {
			color: #0000FF;
			text-align: center;
		
		}
		
	
	.sun {
			color: #FF0000;
			text-align: center;
		}
		
	.today {
		
			background-color:  rgba(196, 222, 255, 0.5);
			text-align: center;
		}
		
	.yo {
			display: flex;
			width:100%;
			flex-wrap: wrap;
			
		} 
		
	.yo > div {
	
			width :calc(100%/7);
			box-sizing: border-box;
			background-color: rgba(178, 204, 255, 0.7);
	 		height: 30px;		
			border-radius: 4px;
			text-align: center;
		}
		
	.button {
	
		background-color: rgba(178, 204, 255, 0.7);
		color: rgb(0, 0, 0);
		border-color: rgba(178, 204, 255, 0.7);
		text-decoration: none;
		
		}
	.calendar {
		display: flex;
		width:100%;
		flex-wrap: wrap;
	}
	
	.calendar > div {
		width :calc(100%/7);
 		height: 80px;		
		box-sizing: border-box;
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
	<div class="back-box mt-5" style="padding-left: 30px; padding-right: 30px;">
	<div style="margin: 10px; padding-left: 10px;">
		<!-- 메뉴 이미지 -->
		<div class="row">
			<div class="col-md-1">
				<a href="/diary/diary.jsp">
				<img alt="" src="/diary/img/calendar.png" width="40px" height="40px"></a>
			</div>
			
			<div class="col-md-1">
				<a href="/diary/diaryList.jsp">
				<img alt="" src="/diary/img/list.png" width="40px" height="40px"></a>
			</div>
			<div class="col-md-1"></div>
			<!-- 년도, 달력, 전/후 버튼 -->
				<!-- 이전달 -->
				<div class="col-md-1" style=" height: 50px; ">
					<a href="/diary/diary.jsp?targetYear=<%=tYear %>&targetMonth=<%=tMonth-1 %>">
					<img alt="" src="/diary/img/left.png" width="40px" height="40px"></a>
				</div>
				
				<!-- 년도, 월 -->
				<div class="col-md-4"><h2><%=strMonth %> <%=tYear %></h2></div>
				
				<!-- 다음달 -->
				<div class="col-md-1" style="width: 50px; height: 50px; ">
					<a href="/diary/diary.jsp?targetYear=<%=tYear %>&targetMonth=<%=tMonth+1 %>">
					<img alt="" src="/diary/img/right.png" width="40px" height="40px"></a>
				</div>
				<div class="col-md-1"></div>
				
				<div class="col-md-1">
					<a href="/diary/statsLunch.jsp">
					<img alt="" src="/diary/img/restaurant.png" width="40px" height="40px"></a>
				</div>
				<div class="col-md-1">
			         <a href="/diary/addDiaryForm.jsp">
			         <img alt="" src="/diary/img/write.png" width="40px" height="40px"></a>
		      	</div>
				
			</div>
		</div>
		
		<!-- 상단 요일 -->
		<div class="yo">
			<div class="">SUN</div>
			<div class="">MON</div>
			<div class="">TUE</div>
			<div class="">WED</div>
			<div class="">THR</div>
			<div class="">FRI</div>
			<div class="">SAT</div>
		</div>
		
		<!-- DATE 값이 들어갈 div -->
		<div class="calendar">
		<%
			for(int i=1; i <= countDiv; i=i+1) {
				
				if(i-startBlank > 0) {
						
				%>
					<div><%=i-startBlank %><br>
						
				<%
					// 현재날짜(i-startBlank)의 일기가 rs2 목록에 있는지 비교
					while(rs2.next()) {
						// 날짜에 일기가 존재한다 -> day에 출력
						if(rs2.getInt("day") == (i-startBlank)) {
				%>
								<span><%=rs2.getString("feeling") %></span>
								<a href='/diary/diaryOne.jsp?diaryDate=<%=rs2.getString("diaryDate")%>' ><%=rs2.getString("title") %>..</a>
							
				<%
							// 찾았다 = 더 이상 찾을 필요 없이 끝낸다
							break;
						}
						
					}
					
				%>
					</div>
				<%
					// 다시 찾으러 커서가 위로 올라간다
					// ResultSet의 위치를 다시 위로 올리는 API
					rs2.beforeFirst();
				
				
					} else { 
						
				%>
					<div>&nbsp;</div>
					
				<%
					}
				%>
					
		<%		
			}
		%>
		</div>
			<div class="row">
				<div class="col-md-10"></div>
				<div class="col-md-2 mb-4">
		        	<a href="/diary/logout.jsp">
		        	<img alt="" src="/diary/img/logout.png" width="40px" height="40px"></a>
		     	</div>
		     </div>
		
		</div>
			
		</div>
</body>
</html>