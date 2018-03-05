# 항공기 좌석 예약 자바스크립트



## 다음 사항이 필요합니다.

### 1. 데이터 테이블
좌석예약 자바스크립트를 동작하기 위해 mysql 서버를 준비하고, 다음과 같은 테이블들이 필요합니다.<br>
![enter image description here](https://github.com/chupark/Java-Script-Practice/blob/master/Seat%20Reservation/images/1.%20tables.PNG?raw=true)
<br>5개의 테이블이 있지만 AIRLINEUSER 을 제외한 4개의 테이블만 생성합니다.
<br><br>
### 2. Go_JEJU 
Go_JEJU 그리고 Go_KIMPO 는 해당 항공기의 좌석 속성을 나타낸 테이블입니다.
- Go_JEJU<br>
![enter image description here](https://github.com/chupark/Java-Script-Practice/blob/master/Seat%20Reservation/images/2.Go_JEJU.PNG?raw=true)
- Go_JEJU 의 테이블 속성 입니다.<br>

	- SEAT_NUM : 각각 좌석의 실제 번호입니다 1, 2, 3, 4 ....
  	 자바스크립트 동작시  좌석은 A1, A2.. 이런식으로 표시됩니다.
<br>
- SELECT * <br>
![enter image description here](https://github.com/chupark/Java-Script-Practice/blob/master/Seat%20Reservation/images/2_1.Go_JEJU_SELECT.PNG?raw=true)
- Go_JEJU 테이블 조회 결과 입니다.

- SEAT CLASS 는 좌석 클래스 입니다 BUSINESS, ECONOMY 두개가 있습니다. SEAT_CODE 는 '좌석 클래스의 코드' 입니다.<br>1 = first, 　2 = economy, 　3 = business 입니다.
<br><br>
### 3. PLANEINFO

PLANEINFO 테이블은 비행기 속성을 저장하는 테이블 입니다.
해당 비행기의 경로, 비행기 모델명 (그냥 넣어봄.. 실제로 쓰진않음), 일등석, 비즈니스, 이코노미 석이 총 몇석인지 보여줍니다.

- PLANEINFO<br>
![enter image description here](https://github.com/chupark/Java-Script-Practice/blob/master/Seat%20Reservation/images/4.planeinfo.PNG?raw=true)
<br>
	- NAME : 비행기 경로
	- KIND : 기종
	- FIRST : 기내 FIRSTCLASS 좌석 수
 	- BUSINESS : 기내 BUSINESS 좌석 수
 	- ECONOMY : 기내 ECONOMY 좌석 수
 	
  테이블 구조를 좀 변경해야하지만... 지금은 연습이므로 그냥 합니다.
  비행기 이름도 넣어야 하는데 NAME 에 비행기 경로를 넣어버렸네요.

- SELECT *<br>
![enter image description here](https://github.com/chupark/Java-Script-Practice/blob/master/Seat%20Reservation/images/4_1.planeinfo_SELECT.PNG?raw=true)
<br>테이블 조회 결과는 위와 같습니다.
<br><br>
### 4. TICKETINFO
TICKETINFO 테이블은 예약 현황을 보여주는 마스터테이블 입니다.
JSP 파일 실행시 예약된 좌석이 보고싶다면 MYSQL 내에 INSERT 를 해주시면 됩니다.<br>
![enter image description here](https://github.com/chupark/Java-Script-Practice/blob/master/Seat%20Reservation/images/5.ticketinfo.PNG?raw=true)
<br>
- TICKETINFO 에 모든 정보가 담겨있습니다.
	- NAME : 실제 탑승자 이름
	- TICKETNUM : 티켓번호
	- PLANE_NAME : 행선지
	- RESV_DATE : 예약일
	- RESV_SEAT : 예약 좌석 클래스
	- SEAT_NUM : 예악 좌석 번호 (숫자)
	- START_DATE : 출발일
	- ADDR : 예약 좌석 (UI상 좌석번호)
	- TELNUM : 전화번호
	- IN_NAME : 예약자 성명
	- PROCESSING : 진행상태 (입금전, 환불요청, 등등)

- SELECT *<br>
![enter image description here](https://github.com/chupark/Java-Script-Practice/blob/master/Seat%20Reservation/images/5_1.ticketinfo_SELECT.PNG?raw=true)
<br>
	- 쿼리 결과는 위와 같습니다.
