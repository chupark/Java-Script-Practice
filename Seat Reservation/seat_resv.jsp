<%@page session="true" import="java.util.*" %>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*,javax.sql.*,java.io.*" %>
<%request.setCharacterEncoding("UTF-8");%>
<html>
<head>
<style type="text/css"> 

.no-drag {-ms-user-select: none; -moz-user-select: -moz-none; -webkit-user-select: none; -khtml-user-select: none; user-select:none;} 
</style>
</head>
<%

%>
<script>
var person = 0;

var clicked = new Array(70);

function resv_page(){
	for(var z = 1; z <= 100; z++){
		if(document.getElementById(z).value == '1'){
			document.getElementById(z).style.backgroundColor = "#ff0000";
		}else{
			document.getElementById(z).style.backgroundColor = "#fff6ad";		
		}
	}	
}


//몇좌석 예약됬는지 체크용
function selectedSeat(){
	var a = 0;
	for(var z = 1; z <= 100; z++){
		if(document.getElementById(z).value == 1){
			a++;
		}
	}
	document.getElementById('boocked').value = a;
}

//인원체크용
function valueIn(a){
	person = document.getElementById(a).value;
	document.getElementById('success').value = person;
}

//리셋용
function resetBack_person(){
	document.getElementById('success').value = 0;
	document.getElementById('howmany').value = 0;
}

function person_limit(){
	var nowPerson = document.getElementById('howmany').value;
	if(nowPerson > 8){
		document.getElementById('howmany').value = 8;
		document.getElementById('success').value = 8;
	}else if(nowPerson<=0){
		document.getElementById('howmany').value = 0;
		document.getElementById('success').value = 0;
	}
}

//연속예약 알고리즘 체크
function checkSeat(){
	document.getElementById('seat_Mode').value="연속 예매";
	document.getElementById('seat_Mode').style.color="#ff0000"
	var x = new Array(101);
	for (var i = 0; i <= 100; i++) {
		x[i] = i;
	}
	for (var i = 1; i <=8; i++){
		document.getElementById("ticket"+i).style.display="none";
		document.getElementById("name"+i).required = false;
		document.getElementById("phone"+i).required = false;
		document.getElementById("birth"+i).required = false;
		document.getElementById("seat"+i).value = "";
	}
	//예약된 좌석은 value = 1
	//내가 예약할 수 있는 좌석 value = 2로 변경하고 초록색으로 칠해줌 => 연속예약 처리
	//연속예약 불가시 그냥 value = 0인애들 보여죽??
	for (var a = 13; a <= 100; a++){	
		if(document.getElementById(a).value != 'selected'){
			document.getElementById(a).style.backgroundColor = "skyblue";
			document.getElementById(a).value='possible';
		}
		if(document.getElementById(a).value == 'selected'){
			document.getElementById(a).disabled = true;
		}
		//seatLine++;
	}
	for(var a = 1; a <= 12; a++){
		if(document.getElementById(a).value != 'selected'){
			document.getElementById(a).style.backgroundColor = "skyblue";
			document.getElementById(a).value='business';
		}
		if(document.getElementById(a).value == 'selected'){
			document.getElementById(a).disabled = true;
		}
	}
}

//온클릭 이벤트
function checkTest(aa){	

	for (var i = 1; i <=8; i++){
		document.getElementById("ticket"+i).style.display="none";
		document.getElementById("name"+i).required = false;
		document.getElementById("phone"+i).required = false;
		document.getElementById("birth"+i).required = false;
		document.getElementById("seat"+i).value = "";
	}
	
	//<!--  연속예약 하는곳
	for(var i = 1; i <= 100; i++)	{
		if(document.getElementById(i).style.background == "aqua" && document.getElementById(i).value =='possible'){
			document.getElementById(i).style.background = "green";
			document.getElementById(i).value = "myChoice";
		}else if(document.getElementById(i).value == "myChoice"){
			//예약이 풀리면 아쿠아가 안되서 재클릭하려면 마우스오버를 다시 해야함 ㅠㅠ
			document.getElementById(i).style.background = "skyblue";
			document.getElementById(i).value = "possible";
		}
	}
	
	var inCnt = 0;
	for(var i = 1; i <=100; i++){
		if(document.getElementById(i).value == "myChoice"){
			//alert(document.getElementById(i).innerHTML);
			//seat = document.getElementById(i).innerHTML;
			inCnt++;
			document.getElementById("ticket"+inCnt).style.display="";
			document.getElementById("name"+inCnt).required = true;
			document.getElementById("phone"+inCnt).required = true;
			document.getElementById("birth"+inCnt).required = true;			
			document.getElementById("seat"+inCnt).value = document.getElementById(i).innerHTML;
			document.getElementById("real_seat"+inCnt).value = document.getElementById(i).id
		}
	}
	
	//--  연속예약 하는곳 >
	//alert("haha");
	//<!-- 연속예약 해제시
	
	var choiceCnt = 0;
	var limit = document.getElementById('success').value;

	for(var i = 1; i <=100; i++){
		if(document.getElementById(i).value == "no_Chain_Select"){	
			choiceCnt++;
		}
	}	
	
	//alert(limit);
	if(aa.value*1 == 0 && choiceCnt < limit){
		aa.value = "no_Chain_Select";
		aa.style.background = 'green';
	}else if(aa.value == "no_Chain_Select"){
		aa.value = 0;
		aa.style.background = 'skyblue';
	}
		
	//alert(choiceCnt);
	inCnt = 1;
	for(var i = 1; i <=100; i++){
		if(document.getElementById(i).value == "no_Chain_Select"){
			document.getElementById("ticket"+inCnt).style.display="";
			document.getElementById("name"+inCnt).required = true;
			document.getElementById("phone"+inCnt).required = true;
			document.getElementById("birth"+inCnt).required = true;				
			document.getElementById("seat"+inCnt).value = document.getElementById(i).innerHTML;
			document.getElementById("real_seat"+inCnt).value = document.getElementById(i).id
			inCnt++;
		}
	}
}

//온마우스 오버 이벤트
function change1(obj){
	var needs = document.getElementById('success').value * 1;
	//alert(needs);
	if(obj.value == 0){
		obj.style.background = 'aqua';
		obj.style.color = 'black';
	//알고리즘 체크 했을경우 작동
	}
	//alert('haha');
	
	var flag_arr = ['false', 'false', 'false', 'false', 'false', 'false', 'false', 'false'];
	var nice;
	var nice2;
	var flag=false;
	if (needs >= 1 && needs <= 8){
		var flag = false;
		var arr = [0, 0, 0, 0, 0, 0, 0, 0];
		switch(needs){
			case needs:
				//<!------------------------- 연 석 예 약 최 초 싸 이 클 -----------------------------------------------
				//먼저 인원수를 세고
				//각 arr 배열에 엘리먼츠들을 집어넣음.. 기본id, id+1 순으로 감..
				for (var i = 0; i < needs; i++){
					arr[i] = document.getElementById((obj.id * 1) + i);
				}
				//좌석이 다음줄로 넘어가면 몫이 바뀜
				var arr_id = arr[0].id*1 - 13;
				var flag2 = parseInt(arr_id / 8); // 첫째 줄 : 0 0 0 0 0 0 0 0 , 둘째줄 : 1 1 1 1 1 1 1 1 
				for(var i = 0; i < needs; i++){
					//여기서 자꾸 null value 가져옴 미치겠음... 마지막줄이 문제가 많음
					//마지막줄에선 id가 더이상 나아가지 않으므로 null value가 자꾸 들어옴.. 꼼수를 써서 input type=hidden 몇개를 추가함
					//									만약 몫이 바뀌었다면 flag는 false 
					//연석예약의 예약가능 좌석 value 는 possible 임
					if(arr[i].value == 'possible' && parseInt((arr[i].id*1 - 13)/8) == flag2){
						flag = true;
					}else {
						flag = false;
						break;
					}
				}
				//flag가 참이면 마우스 오버 색을 아쿠아로 변경시킴
				if(flag == true){
					for (var i = 0; i < needs; i++){
						arr[i].style.background = 'aqua';
					}
					break;
				}
				//------------------------------ 여기까지가 최초 싸이클 ----------------------------------------------->
				
				//<!---------------------------- 여 기 서 부 터 그 다 음 싸 이 클 ___ 좌 석 끝 까 지 반 복 -------------------
				for (var i = 0; i < needs - 1; i++){
					if(flag == false){
						for(var j = 0; j < needs; j++){
							arr[j] = document.getElementById((obj.id * 1) + (-1 - i + j));
						}
						var arr_id = arr[0].id*1 - 13;
						var flag2 = parseInt(arr_id / 8); // 0 0 0 0 0 0 0 0						
						for(var j = 0; j < needs; j++){
							if(arr[j].value == 'possible' && parseInt((arr[j].id*1 - 13)/8) == flag2){
								flag = true;
							}else{
								flag = false;
								break;
							}
						}
						if(flag == true){
							for (var j = 0; j < needs; j++){
								arr[j].style.background='aqua';
							}
							break;
						}
					}
				}
				//------------------------------ 연 석 예 약 종 료 -------------------------------------------------->
				//연석예약은 1줄로만 비교했음.. 나중에 1줄 연석이 안되면 앞뒤로 하는거도 추가해봐야지..
		}
	}
}
//온마우스 아웃 이벤트
function change2(obj){
	for(var i = 1; i <= 100; i++){
		if(document.getElementById(i).value == 'possible'){
			document.getElementById(i).style.background = 'skyblue';
			document.getElementById(i).style.color = 'black';
		}
		if(document.getElementById(i).style.background == 'aqua'){
			document.getElementById(i).style.background = 'skyblue';
			document.getElementById(i).style.color = 'black';
		}
	}
}

//따로예약
function checkSeat2(){
	document.getElementById('seat_Mode').value="따로 예매";
	document.getElementById('seat_Mode').style.color="#0000ff"
	for(var i = 1; i <= 100; i++){
		if(document.getElementById(i).value != 'selected'){
			document.getElementById(i).value = 0;
			document.getElementById(i).style.background = "skyblue";
		}
	}
	for (var i = 1; i <=8; i++){
		document.getElementById("ticket"+i).style.display="none";
		document.getElementById("name"+i).required = false;
		document.getElementById("phone"+i).required = false;
		document.getElementById("birth"+i).required = false;		
		document.getElementById("seat"+i).value = "";
	}
}

function finalCheck(){
	var cnt = 0;
	var cnt2 = 0;
	for(var i = 1; i <= 100; i++){
		if(document.getElementById(i).value == "no_Chain_Select"){
			cnt++;
		}
	}
	
	for(var i = 1; i <= 100; i++){
		if(document.getElementById(i).value == "myChoice"){
			cnt2++;
		}
	}
	
	if(cnt == 0 && cnt2 == 0){
		return false;
	}
	
	//alert(document.getElementById('howmany').value);
	//alert("씨엔티 : " + cnt);
	//alert("씨엔티2 : " +cnt2);
	
	if(document.getElementById('seat_Mode').value == "따로 예매"){
		if(cnt != document.getElementById('howmany').value){
			alert('나머지 좌석을 선택 해주세요' + "\n"+"총원 : "+document.getElementById('howmany').value+", 현재 선택 : "+cnt);
			return false;
		}
	}
}
</script>
<script src="https://code.jquery.com/jquery-1.12.3.min.js"></script>
<script>
//첫번째 방법
$(document).ready(function(){ 
    valueIn('howmany');
	if(document.getElementById('success').value == 1){
		checkSeat2();
	}else{
		checkSeat();
	}
});
 
//두번째 방법
$(function(){
    
});
</script>
<body style='font-size: 100%;'>
<%
	String loginOK = null;
	String loginID = null;
	String loginGroup = null;
	
	loginOK = (String)session.getAttribute("login_ok");
	loginID = (String)session.getAttribute("login_id");
	loginGroup = (String)session.getAttribute("login_Group");
%>
<%
	String way_class = request.getParameter("way_class");
	String start_place = request.getParameter("start_place");
	String end_place = request.getParameter("end_place");
	String adult = request.getParameter("adult");
	String young = request.getParameter("young");
	String baby = request.getParameter("baby");
	String url = "";
	int total_person = 0;
	if(way_class != null && start_place!= null && end_place != null & adult != null && young != null && baby != null){
		url = "&way_class="+way_class+"&start_place="+start_place+"&end_place="+end_place+"&adult="+adult+"&young="+young+"&baby="+baby;
		
	}else{
		url="";
	}
	if(adult!= null){
		total_person = total_person + Integer.parseInt(adult);
	}
	if(young!= null){
		total_person = total_person + Integer.parseInt(young);
	}
	if(baby!= null){
		total_person = total_person + Integer.parseInt(baby);
	}	
%>
<%
//커넥션 변수
Connection conn = null;
Statement stmt = null;
ResultSet rset = null;
String sql = "";
total_person = 4;
boolean linechange = false;

String start_date = request.getParameter("date");
String plane = request.getParameter("plane");
url = "?start_date="+start_date+"&plane="+plane +""+ url;
try{
	//DBMS연결
	Class.forName("com.mysql.jdbc.Driver");
	conn = DriverManager.getConnection("jdbc:mysql://localhost/kopoctc2?useSSL=false","root","honor4me1241q@");
	stmt = conn.createStatement();
		
		sql = "SELECT A.SEAT_NUM, B.SEAT_NUM, B.START_DATE, B.PLANE_NAME FROM Go_KIMPO A "+
			  "LEFT OUTER JOIN TICKETINFO B ON A.SEAT_NUM = B.SEAT_NUM "+
			  "AND STR_TO_DATE(SUBSTRING(B.START_DATE,1,10),'%Y-%m-%d %H:%i:%s') = STR_TO_DATE(now(),'%Y-%m-%d %H:%i:%s') "+
			  "AND B.PLANE_NAME = '"+plane+"'"+
			  "ORDER BY A.SEAT_NUM;";
		int resved_seat[] = new int[100];
		//resved_seat[0] => 1번좌석임
		rset = stmt.executeQuery(sql);
		int z = 0;
		while(rset.next()){
			resved_seat[z] = rset.getInt(2);
			z++;
		}
		
		//Go_KIMPO 비행기의 좌석수 리턴
		sql = "select * from Go_KIMPO;";
		rset = stmt.executeQuery(sql);
		int aa[] = new int[100];
		z = 0;
		while(rset.next()){
			aa[z] = rset.getInt(1);
			z++;
		}

		
		int k = 0;
		int h = 0;
		int tdId = 1;
%>
<%
		out.println("<center>");
		out.println("<table border=0 cellspacing=0 width=800 height=80>");
		out.println("<tr>");
		out.println("<td valign=top>");%>
		<table border=0 cellpadding=0 cellspacing=0 width=867>
			<tr>
				<td width=867>
					<font size=4>TWAIR > 항공권 예약 > 여행지 선택 > [편도] 날짜 선택 > <u><b>좌석 선택 [<%=start_place%> -> <%=end_place%>]</b></u> <br></font>　
				</td>
			</tr>
		</TABLE>
		<%
		out.println("</td>");
		out.println("</tr>");
		out.println("<tr>");
		out.println("<td valign=top>");
		out.println("<b>[좌석 예매 모드] : <input style='border:0; font-size:12pt; color:#ff0000; font-weight:bold;' type=text id=seat_Mode name=seat_Mode value='' readonly/></b><br>");
		out.println("※Business Class 연속예매는 불가능합니다.</td>");
		out.println("</tr>");		
		out.println("</table>");
		out.println("<table border=1 cellspacing=0 width=800 height=650");
		out.println("<tr>");
		out.println("<td valign=middle style='border-right:0px solid white' width=370>");
		out.println("<table style='border-bottom:0px;' align=center border=1 cellspacing=0 width=370>");
		
		for (int i = 0; i < 12; i++){
			if(k !=0 && k % 4 == 0){
				out.println("<tr>");
			}
				out.println("<td width=70 style='border:0px' align=center height=30 width=50>");
				
				//디비랑 연동해서 해당날짜랑 좌석 맞으면 여기를 변경합시다
				if(resved_seat[i] == aa[i]){
					out.println("<button id="+tdId+" style='background-color:red;width:80%;height:80%'"+
						" value=selected type=button disabled>");
					out.println("A"+aa[i]);
					out.println("</button>");
				}else{
					out.println("<button id="+tdId+" style='background-color:skyblue;width:80%;height:80%'"+
						" value=0 type=button onmouseover='change1(this);' onmouseout='change2(this);' onClick=checkTest(this);>");
					out.println("A"+aa[i]);
					out.println("</button>");					
				}
				
				
				out.println("</td>");
			if(k % 4 == 0){
				out.println("<td width=30 height=30 style='border:0px'>");
				out.println("</td>");
				h = 1;
			}					
			if(h == 3){
				out.println("<td width=30 width=70 height=30 style='border:0px'>");
				out.println("</td>");
				h = 0;
			}
			h++;
			k++;
			if(k !=0 &&k % 4 == 0){				
				out.println("</tr>");
			}
			tdId++;
		}
		
		k = 0;
		h = 0;
		tdId = 13;
		
		out.println("</tr>");
		out.println("<tr>");
		out.println("<td height=25 style='border:0px'>");
		out.println("</td>");
		out.println("<td height=25 style='border:0px'>");
		out.println("</td>");
		out.println("<td height=25 style='border:0px'>");
		out.println("</td>");
		out.println("<td height=25 style='border:0px'>");
		out.println("</td>");
		out.println("<td height=25 style='border:0px'>");
		out.println("</td>");
		out.println("<td height=25 style='border:0px'>");
		out.println("</td>");		
		out.println("</tr>");
		out.println("</table>");
		out.println("<table align=center border=1 style='border-top:0;' cellspacing=0 width=370>");
		//15씩 더주저
		out.println("<tr>");
		out.println("<td style='border-top:1.4px solid black' align=center width=40 height=25 >EXIT");
		out.println("</td>");
		out.println("<td  style='border-top:1.4px solid black' align=center width=40><img src='/airline/image/plane/diper.png' width='30' height='20'></td>");
		out.println("<td height=25 style='border-top:0;border-bottom:0px'>");
		out.println("</td>");
		out.println("<td style='border-top:1.4px solid black' align=center height=25 width=40><img src='/airline/image/plane/toilet.png' width='30' height='20'>");
		out.println("</td>");
		out.println("<td style='border-top:1.4px solid black' colspan=2 align=center height=25 width=80><img src='/airline/image/plane/drink.png' width='60' height='20'>");
		out.println("</td>");
		out.println("<td style='border-top:1.4px solid black' align=center height=25 width=40><img src='/airline/image/plane/toilet.png' width='30' height='20'>");
		out.println("</td>");		
		out.println("<td style='border-top:0px;border-bottom:0px' height=25>");
		out.println("</td>");
		out.println("<td style='border-top:1.4px solid black' align=center width=40><img src='/airline/image/plane/diper.png' width='30' height='20'></td>");		
		out.println("<td style='border-top:1.4px solid black' align=center height=25 width=40>EXIT");
		out.println("</td>");		
		out.println("</tr>");
		out.println("<tr>");
		out.println("<td height=20 style='border-bottom:0;border-right:0;border-left:0'>");
		out.println("</td>");
		out.println("<td height=20 style='border-bottom:0;border-right:0;border-left:0'>");
		out.println("</td>");
		out.println("<td style='border-bottom:0;border-top:0;border-left:0;border-right:0px'></td>");
		out.println("<td height=20 style='border-bottom:0;border-right:0;border-left:0'>");
		out.println("</td>");
		out.println("<td height=20 style='border-bottom:0;border-right:0;border-left:0'>");
		out.println("</td>");
		out.println("<td height=20 style='border-bottom:0;border-right:0;border-left:0'>");
		out.println("</td>");
		out.println("<td height=20 style='border-bottom:0;border-right:0;border-left:0'>");
		out.println("</td>");		
		out.println("<td height=20 style='border-bottom:0;border-top:0;border-right:0;border-left:0px'>");
		out.println("</td>");
		out.println("<td height=20 style='border-bottom:0;border-right:0;border-left:0px'>");
		out.println("</td>");		
		out.println("<td style='border-bottom:0;border-right:0;border-left:0px'></td>");
		out.println("</tr>");
		//out.println("<tr>");
		
		for (int i = 12; i < z; i++){
			if(k == 0){
				out.println("<tr >");
			}
				out.println("<td align=center style='border:0' height=30 width=50>");
				//디비랑 연동해서 해당날짜랑 좌석 맞으면 여기를 변경합시다
				if(aa[i] == resved_seat[i]){
					out.println("<button id="+tdId+" type=button style='background-color:red;width:80%;height:80%' value='selected' disabled>");
				}else{
					out.println("<button id="+tdId+" style='background-color:skyblue;width:80%;height:80%' value=0 type=button onmouseover='change1(this);' onmouseout='change2(this);' onClick=checkTest(this);>");
				}
				if(aa[i] >= 13 && aa[i] <= 20){
					out.println("C"+(k+1));
				}else if(aa[i] > 20 && aa[i] <= 28){
					out.println("D"+((k % 8)+1));	
				}else if(aa[i] > 28 && aa[i] <= 36){
					out.println("E"+((k % 8)+1));	
				}else if(aa[i] > 36 && aa[i] <= 44){
					out.println("F"+((k % 8)+1));	
				}else if(aa[i] > 44 && aa[i] <= 52){
					out.println("G"+((k % 8)+1));		
				}else if(aa[i] > 52 && aa[i] <= 60){
					out.println("H"+((k % 8)+1));		
				}else if(aa[i] > 60 && aa[i] <= 68){
					out.println("I"+((k % 8)+1));	
				}else if(aa[i] > 68 && aa[i] <= 72){
					out.println("J"+((k % 8)+1));	
				}else if(aa[i] > 72 && aa[i] <= 80){
					out.println("K"+((k % 8)+1));	
				}else if(aa[i] > 80 && aa[i] <= 88){
					out.println("L"+((k % 8)+1));	
				}else if(aa[i] > 88 && aa[i] <= 86){
					out.println("M"+((k % 8)+1));	
				}else if(aa[i] > 86 && aa[i] <= 92){
					out.println("N"+((k % 8)+1));	
				}else if(aa[i] > 92 && aa[i] <= 100){
					out.println("O"+((k % 8)+1));	
				}
				out.println("</button>");				
				out.println("</td>");
			if(h == 1){
				out.println("<td width=35 height=30 style='border:0px'>");
				out.println("</td>");
				
			}					
			if(h == 5){
				out.println("<td width=35 height=30 style='border:0px'>");
				out.println("</td>");
				
			}
			h++;
			k++;
			if(k == 8){				
				out.println("</tr>");
				k = 0;
				h = 0;
			}
			tdId++;
		}
		//연석 예약시 맨 뒷줄은... 그다음 ID의 VALUE가 없기때문에 에러가 올라옴
		//에러를 감추기 위해 아무 작동도 안하는 히든을 넣는 꼼수를 써준다
		//------------------------------ 연 속 좌 석 null value 꼼 수 ---------------------------------------------
		out.println("<input id=101 style='background-color:skyblue;width:80%;height:80%' value=0 type=hidden>");
		out.println("<input id=102 style='background-color:skyblue;width:80%;height:80%' value=0 type=hidden>");
		out.println("<input id=103 style='background-color:skyblue;width:80%;height:80%' value=0 type=hidden>");
		out.println("<input id=104 style='background-color:skyblue;width:80%;height:80%' value=0 type=hidden>");
		out.println("<input id=105 style='background-color:skyblue;width:80%;height:80%' value=0 type=hidden>");
		out.println("<input id=106 style='background-color:skyblue;width:80%;height:80%' value=0 type=hidden>");
		out.println("<input id=107 style='background-color:skyblue;width:80%;height:80%' value=0 type=hidden>");
		out.println("<input id=108 style='background-color:skyblue;width:80%;height:80%' value=0 type=hidden>");
		out.println("<input id=109 style='background-color:skyblue;width:80%;height:80%' value=0 type=hidden>");
		out.println("<input id=110 style='background-color:skyblue;width:80%;height:80%' value=0 type=hidden>");
		out.println("<input id=111 style='background-color:skyblue;width:80%;height:80%' value=0 type=hidden>");
		//------------------------------ 연 속 좌 석 null value 꼼 수 ---------------------------------------------->
		out.println("<tr>");
		out.println("<td height=25 style='border-top:1.4px solid black' align=center>EXIT");
		out.println("</td>");
		out.println("<td style='border-top:0;border-right:0' align=center></td>");
		out.println("<td style='border-top:0;border-left:0' height=25 >");
		out.println("</td>");
		out.println("<td align=center style='border-top:1.4px solid black' width=40 height=25><img src='/airline/image/plane/toilet.png' width='30' height='20'>");
		out.println("</td>");
		out.println("<td align=center style='border-top:1.4px solid black' width=40 height=25 colspan=2><img src='/airline/image/plane/drink.png' width='60' height='20'>");
		out.println("</td>");
		out.println("<td align=center style='border-top:1.4px solid black' width=40 height=25><img src='/airline/image/plane/toilet.png' width='30' height='20'>");
		out.println("</td>");		
		out.println("<td height=25 style='border-top:0;border-right:0'>");
		out.println("</td>");
		out.println("<td height=25 style='border-left:0;border-top:0'>");
		out.println("</td>");		
		out.println("<td style='border-top:1.4px solid black' align=center>EXIT</td>");		
		out.println("</tr>");
		out.println("</table>");
		out.println("</td>");
		out.println("<td style='border-left:0px solid white;border-right:0px solid white' width=30>");%>
		<%out.println("</td>");		
		out.println("<td style='border-left:0px solid white;' valign=top>");%>
		
				<form method=get id=frm name=frm action="b_insert_db.jsp" onsubmit='return finalCheck();'>
					<input type=hidden id=way_class name=way_class value=<%=way_class%> >
					<input type=hidden id=start_place name=start_place value=<%=start_place%>>
					<input type=hidden id=end_place name=end_place value=<%=end_place%>>
					<input type=hidden id=adult name=adult value=<%=adult%>>
					<input type=hidden id=young name=young value=<%=young%>>
					<input type=hidden id=baby name=baby value=<%=baby%>>		
					<input type=hidden id=date name=date value=<%=start_date%>>
					<input type=hidden id=plane name=plane value=<%=plane%>>					
					<table border=0 height=100%>
						<tr>
							<td>
								<table border=1 cellpadding=0 cellspacing=0 width=100% id=ticket1 border=1 style='display:none'>
									<tr>
										<td width=20%>
										좌석번호<br><input type=text id=seat1 name=seat1 style="width:100%;text-align:center;border:none;" value="">
										<input type=hidden id=real_seat1 name=real_seat1 value="">
										</td>
										<td>
											성　　명 : <input type=text id=name1 name=name1 value="" required><br>
											전화번호 : <input type=tel id=phone1 name=phone1 value="" required><br>
											생년월일 : <input type=text id=birth1 name=birth1 value="" required><br>
										</td>
									</tr>
								</table>
								<table height=5 border=0 cellpadding=0 cellpadding=0>
									<tr>
										<td>
										</td>
									</tr>
								</table>
								<table border=1 cellpadding=0 cellspacing=0 width=100% id=ticket2 border=1 style='display:none'>
									<tr>
										<td width=20%>
										좌석번호<br><input type=text id=seat2 name=seat2 style="width:100%;text-align:center;border:none;" value="">
										<input type=hidden id=real_seat2 name=real_seat2 value="">
										</td>
										<td>
											성　　명 : <input type=text id=name2 name=name2 value="" required><br>
											전화번호 : <input type=tel id=phone2 name=phone2 value="" required><br>
											생년월일 : <input type=text id=birth2 name=birth2 value="" required><br>
										</td>
									</tr>
								</table>
								<table height=5 border=0 cellpadding=0 cellpadding=0>
									<tr>
										<td>
										</td>
									</tr>
								</table>						
								<table border=1 cellpadding=0 cellspacing=0 width=100% id=ticket3 border=1 style='display:none'>
									<tr>
										<td width=20%>
										좌석번호<br><input type=text id=seat3 name=seat3 style="width:100%;text-align:center;border:none;" value="">
										<input type=hidden id=real_seat3 name=real_seat3 value="">
										</td>
										<td>
											성　　명 : <input type=text id=name3 name=name3 value="" required><br>
											전화번호 : <input type=tel id=phone3 name=phone3 value="" required><br>
											생년월일 : <input type=text id=birth3 name=birth3 value="" required><br>
										</td>
									</tr>
								</table>
								<table height=5 border=0 cellpadding=0 cellpadding=0>
									<tr>
										<td>
										</td>
									</tr>
								</table>						
								<table border=1 cellpadding=0 cellspacing=0 width=100% id=ticket4 border=1 style='display:none'>
									<tr>
										<td width=20%>
										좌석번호<br><input type=text id=seat4 name=seat4 style="width:100%;text-align:center;border:none;" value="">
										<input type=hidden id=real_seat4 name=real_seat4 value="">
										</td>
										<td>
											성　　명 : <input type=text id=name4 name=name4 value="" required><br>
											전화번호 : <input type=tel id=phone4 name=phone4 value="" required><br>
											생년월일 : <input type=text id=birth4 name=birth4 value="" required><br>
										</td>
									</tr>
								</table>
								<table height=5 border=0 cellpadding=0 cellpadding=0>
									<tr>
										<td>
										</td>
									</tr>
								</table>						
								<table border=1 cellpadding=0 cellspacing=0 width=100% id=ticket5 border=1 style='display:none'>
									<tr>
										<td width=20%>
										좌석번호<br><input type=text id=seat5 name=seat5 style="width:100%;text-align:center;border:none;" value="">
										<input type=hidden id=real_seat5 name=real_seat5 value="">
										</td>
										<td>
											성　　명 : <input type=text id=name5 name=name5 value="" required><br>
											전화번호 : <input type=tel id=phone5 name=phone5 value="" required><br>
											생년월일 : <input type=text id=birth5 name=birth5 value="" required><br>
										</td>
									</tr>
								</table>
								<table height=5 border=0 cellpadding=0 cellpadding=0>
									<tr>
										<td>
										</td>
									</tr>
								</table>						
								<table border=1 cellpadding=0 cellspacing=0 width=100% id=ticket6 border=1 style='display:none'>
									<tr>
										<td width=20%>
										좌석번호<br><input type=text id=seat6 name=seat6 style="width:100%;text-align:center;border:none;" value="">
										<input type=hidden id=real_seat6 name=real_seat6 value="">
										</td>
										<td>
											성　　명 : <input type=text id=name6 name=name6 value="" required><br>
											전화번호 : <input type=tel id=phone6 name=phone6 value="" required><br>
											생년월일 : <input type=text id=birth6 name=birth6 value="" required><br>
										</td>
									</tr>
								</table>
								<table height=5 border=0 cellpadding=0 cellpadding=0>
									<tr>
										<td>
										</td>
									</tr>
								</table>						
								<table border=1 cellpadding=0 cellspacing=0 width=100% id=ticket7 border=1 style='display:none'>
									<tr>
										<td width=20%>
										좌석번호<br><input type=text id=seat7 name=seat7 style="width:100%;text-align:center;border:none;" value="">
										<input type=hidden id=real_seat7 name=real_seat7 value="">
										</td>
										<td>
											성　　명 : <input type=text id=name7 name=name7 value="" required><br>
											전화번호 : <input type=tel id=phone7 name=phone7 value="" required><br>
											생년월일 : <input type=text id=birth7 name=birth7 value="" required><br>
										</td>
									</tr>
								</table>
								<table height=5 border=0 cellpadding=0 cellpadding=0>
									<tr>
										<td>
										</td>
									</tr>
								</table>						
								<table border=1 cellpadding=0 cellspacing=0 width=100% id=ticket8 border=1 style='display:none'>
									<tr>
										<td width=20%>
										좌석번호<br><input type=text id=seat8 name=seat8 style="width:100%;text-align:center;border:none;" value="">
										<input type=hidden id=real_seat8 name=real_seat8 value="">
										</td>
										<td>
											성　　명 : <input type=text id=name8 name=name8 value="" required><br>
											전화번호 : <input type=tel id=phone8 name=phone8 value="" required><br>
											생년월일 : <input type=text id=birth8 name=birth8 value="" required><br>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
		<%out.println("</td>");
		out.println("</tr>");
		out.println("</table");%>
		<br/>
				<table width=800 border=0 cellpadding=0 cellspacing=0>
					<tr>
						<td height=10>
						</td>
					</tr>
					<tr>
						<td width=100>
							<button type=button style='width:80' onclick="location.href='a_01_resv_main.jsp'" value="확인">취소</button>
						</td>					
						<td width= 100>
							<button type=button style='width:80' onClick=checkSeat(); value="확인">연속 예매</button>
						</td>
						<td width= 100>
							<button type=button style='width:80' onClick=checkSeat2(); value="확인">따로 예매</button>						
						</td>
						<td width=500 align=right>
							<input type=submit style='width:80' value="완 료">						
						</td>
					</tr>		
				</table>
<%
		out.println("</center>");
		
		rset.close();
		stmt.close();
		conn.close();

%>
				</form>
<center>
<input type=hidden value=<%=total_person%> id=howmany onkeypress=person_limit();>
<input type=hidden value="0" id=success readonly />
</center>
</body>

<%
	}catch(SQLException ex) {
		out.println("잘못된 접근입니다.");
		out.println(ex);
	} finally {
		if (rset != null) try { rset.close(); } catch(SQLException ex) {}
		if (stmt != null) try { stmt.close(); } catch(SQLException ex) {}
		if (conn != null) try { conn.close(); } catch(SQLException ex) {}
	}
%>

</html>