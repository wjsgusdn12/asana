<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.time.Duration"%>
<%@page import="dto.MemberDto"%>
<%@page import="dao.MemberDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    // 이메일을 받아서 해당 사용자에 대한 인증 코드 시간 가져오기
    // 이메일을 POST 방식으로 받아오기
    String email = (String)request.getAttribute("email");
    if (email == null) {
        response.sendRedirect("Controller?command=login");
        return;
    }

    MemberDao dao = new MemberDao();
	
    // 코드 날짜를 가져오기
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
    String str = dao.showCodeTime(email); // db에서 code_date -> sysdate + 5분
    LocalDateTime date = LocalDateTime.parse(str, formatter);

    // 현재 시간과 db에 저장된 시간 차이를 계산
    Duration duration = Duration.between(LocalDateTime.now(), date); 
    long remainingSeconds = duration.getSeconds(); // 남은 초 계산
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="js/jquery-3.7.1.min.js"></script>
    <link rel="stylesheet" href="css/Code_join.css"/>
    <title>Document</title>
    <script>
    // 서버에서 전달한 remainingSeconds 값을 JavaScript로 받음
    let remainingTimeInSeconds = <%= remainingSeconds %>;  // JSP에서 서버 값을 받아옴

    // 남은 시간을 분과 초로 변환
    let g_min = Math.floor(remainingTimeInSeconds / 60);  // 분 계산
    let g_sec = remainingTimeInSeconds % 60;              // 초 계산

    // 타이머 설정
    let timer = setInterval(function() {
        g_sec -= 1;
        if (g_sec < 0) {
            g_sec += 60;
            g_min -= 1;
        }
        if (g_min < 0) {
            g_min = 0;
            g_sec = 0;
            clearInterval(timer);
            updateCodeToNull();
        }
        
        // 남은 시간 표시
        $("#min").text(g_min);
        $("#sec").text(g_sec);
    }, 1000);
    
	    function updateCodeToNull() {
	        $.ajax({
	            url: 'AjaxUpdateCodeServlet',  // 인증 코드를 업데이트할 JSP 파일
	            type: 'POST',
	            data: { email: "<%=email %>" },  // 이메일을 서버로 전달
	            success: function(response) {
	                alert("인증 코드 시간이 만료되었습니다.");
	            },
	            error: function(r,s,e) {
	                console.error("코드 업데이트 실패: " + error);
	            }
	        });
	    };
		$(function() {
		    let codeInputs = $(".code");
		    let submitBtn = $("input[type='submit']");

		    // 각 코드 필드에 keyup 이벤트 추가
		    codeInputs.on("keyup", function() {
		        // 모든 입력 필드가 채워졌는지 확인
		        let all = true;
		        codeInputs.each(function() {
		            if ($(this).val().trim() === "") {
		                all = false; // 하나라도 비어 있으면 false
		            }
		        });

		        // 모든 필드가 채워졌으면 버튼 활성화, 아니면 비활성화
		        if (all) {
		            submitBtn.prop("disabled", false); // 버튼 활성화
		            $(".btn").css("background-color", "black");
		        } else {
		            $(".btn").css("background-color", "#6d6e6f");
		            submitBtn.prop("disabled", true); // 버튼 비활성화
		        }
		    });

		    // 숫자만 허용, 자동으로 다음 칸으로 이동
		    codeInputs.on("input", function() {
		        let $this = $(this);
		        let code = $this.val();

		        // 숫자만 입력 가능하게 하기
		        if (isNaN(code) || code.length > 1) {
		            $this.val("");
		            return;
		        }

		        // 숫자 입력 시, 1글자 입력되면 다음 칸으로 포커스 이동
		        if (code.length == 1) {
		            let nextCode = $this.next(".code");
		            if (nextCode.length == 1) {
		                nextCode.focus();
		            }
		        }
		    });

		    // Backspace 키가 눌렸을 때 이전 칸으로 포커스 이동
		    codeInputs.on("keydown", function(e) {
		        let $this = $(this);
		        let code = $this.val();

		        // Backspace 키 눌렀을 때 처리
		        if (e.key === "Backspace" && code.length === 0) {
		            let prevCode = $this.prev(".code");
		            if (prevCode.length == 1) {
		                prevCode.focus();
		            }
		        }
		    });
		    $(".resend").click(function() {
		    	let email = "${email}";
		    	alert("코드가 재전송되었습니다.");
		    	location.href="Controller?command=resend_code&email=" + encodeURIComponent(email);
		    });
		});
    </script>
</head>
<body>
    <div id="content">
        <div class="mark">
            <svg fill="none" onclick="location.href='Controller?command=first_page';" aria-labelledby="asana-logo-title"><title id="asana-logo-title">Asana Home</title><path onclick="location.href='join.html'" class="_nav_logo-link__text__2RL6n" id="asana-horizontal-logo__text" d="M108.202 16.703c.067.765.679 1.739 1.74 1.739h.62a.44.44 0 0 0 .438-.438V4.359h-.003a.437.437 0 0 0-.435-.414h-1.922a.437.437 0 0 0-.435.414h-.003v1.109c-1.178-1.452-3.035-2.055-4.897-2.055a7.667 7.667 0 0 0-7.665 7.67 7.668 7.668 0 0 0 7.665 7.672c1.862 0 3.892-.723 4.897-2.054v.002Zm-4.89-.633c-2.692 0-4.874-2.232-4.874-4.986 0-2.754 2.182-4.986 4.874-4.986 2.693 0 4.875 2.232 4.875 4.986 0 2.754-2.182 4.986-4.875 4.986ZM93.21 17.172v-7.06c0-3.981-2.51-6.666-6.51-6.666-1.91 0-3.476 1.105-4.029 2.055-.12-.743-.513-1.523-1.735-1.523h-.622a.439.439 0 0 0-.438.438v13.646h.003c.012.23.203.414.435.414h1.923c.029 0 .058-.004.086-.009.013-.002.024-.008.037-.011l.043-.013c.017-.008.032-.017.048-.026l.024-.013a.44.44 0 0 0 .053-.043l.01-.007a.434.434 0 0 0 .134-.292h.002v-8.06a3.87 3.87 0 0 1 3.868-3.871 3.87 3.87 0 0 1 3.868 3.87l.001 6.738v-.002l.002.018v1.307h.002c.013.23.203.414.435.414h1.923a.45.45 0 0 0 .086-.009c.011-.002.022-.007.033-.01.016-.004.032-.008.047-.014.016-.007.03-.016.045-.024l.027-.015a.49.49 0 0 0 .05-.04l.013-.01a.452.452 0 0 0 .049-.057l.003-.004a.434.434 0 0 0 .082-.23h.003v-.891ZM73.188 16.703c.067.765.68 1.739 1.74 1.739h.62c.24 0 .437-.197.437-.438V4.359h-.002a.438.438 0 0 0-.435-.414h-1.923a.438.438 0 0 0-.435.414h-.002v1.109c-1.178-1.452-3.035-2.055-4.898-2.055a7.667 7.667 0 0 0-7.664 7.67c0 4.237 3.431 7.672 7.664 7.672 1.863 0 3.892-.723 4.898-2.054v.002Zm-4.89-.633c-2.692 0-4.875-2.232-4.875-4.986 0-2.754 2.183-4.986 4.875-4.986s4.874 2.232 4.874 4.986c0 2.754-2.182 4.986-4.874 4.986ZM49.257 14.748c1.283.89 2.684 1.322 4.03 1.322 1.283 0 2.609-.665 2.609-1.823 0-1.546-2.89-1.787-4.705-2.405-1.815-.617-3.379-1.893-3.379-3.96 0-3.163 2.816-4.47 5.444-4.47 1.665 0 3.383.55 4.497 1.338.384.29.15.625.15.625l-1.063 1.52c-.12.17-.328.318-.628.133s-1.352-.93-2.956-.93c-1.603 0-2.57.74-2.57 1.66 0 1.1 1.256 1.447 2.727 1.823 2.562.691 5.357 1.522 5.357 4.666 0 2.786-2.604 4.508-5.483 4.508-2.181 0-4.038-.622-5.596-1.766-.324-.325-.098-.627-.098-.627l1.058-1.512c.216-.282.487-.184.606-.102ZM41.866 16.703c.068.765.68 1.739 1.74 1.739h.62a.44.44 0 0 0 .438-.438V4.359h-.003a.437.437 0 0 0-.435-.414h-1.922a.438.438 0 0 0-.435.414h-.003v1.109c-1.178-1.452-3.035-2.055-4.897-2.055a7.668 7.668 0 0 0-7.665 7.67c0 4.237 3.432 7.672 7.665 7.672 1.862 0 3.892-.723 4.897-2.054v.002Zm-4.89-.633c-2.692 0-4.874-2.232-4.874-4.986 0-2.754 2.182-4.986 4.875-4.986 2.692 0 4.874 2.232 4.874 4.986 0 2.754-2.182 4.986-4.874 4.986Z" fill="#0D0E10"></path><path onclick="location.href='join.html'" class="_nav_logo-link__asana-icon__Un0sE" id="asana-horizontal-logo__icon" d="M18.559 11.605a5.158 5.158 0 1 0 0 10.317 5.158 5.158 0 0 0 0-10.317Zm-13.401.001a5.158 5.158 0 1 0 0 10.315 5.158 5.158 0 0 0 0-10.315Zm11.858-6.448a5.158 5.158 0 1 1-10.316 0 5.158 5.158 0 0 1 10.316 0Z" fill="#FF584A"></path></svg>
            <div class="title">
                <h1>코드가 이메일로 전송되었습니다</h1>
            </div>
            <div class="code_title">
                <span>다음으로 6자리 코드를 전송했습니다 <%=email %> 아래 코드를 입력하세요:</span>
            </div>
            <form action="Controller" method="post">
            <input type="hidden" name="command" value="code_action"/>
            <div class="code_input">
            	<input type="hidden" name="email" value="<%=email%>"/>
                <input type="text" class="code" name="code1" maxlength="1"/>
                <input type="text" class="code" name="code2" maxlength="1"/>
                <input type="text" class="code" name="code3" maxlength="1"/>
                <input type="text" class="code" name="code4" maxlength="1"/>
                <input type="text" class="code" name="code5" maxlength="1"/>
                <input type="text" class="code" name="code6" maxlength="1"/>
            </div>
            <div class="code_btn">
            	<div class="time">시간제한 : <span id="min">00</span>분<span id="sec">00</span>초</div>
            	<div class="resend">
            	<span>재전송</span>
            	</div>
                <input type="submit" class="btn" value="인증" disabled/>
            </div>
            </form>
        </div>
        <div class="move">
            <div class="circle1">
                <svg width="30" height="30" viewBox="0 0 16 16" xmlns="http://www.w3.org/2000/svg" role="graphics-symbol" aria-labelledby="check-icon-title-id" aria-hidden="false" fill="var(--lightmode-text)" style="fill: var(--lightmode-text);"><title id="check-icon-title-id">check icon</title><path d="M8 16C3.6 16 0 12.4 0 8C0 3.6 3.6 0 8 0C12.4 0 16 3.6 16 8C16 12.4 12.4 16 8 16ZM8 1C4.15 1 1 4.15 1 8C1 11.85 4.15 15 8 15C11.85 15 15 11.85 15 8C15 4.15 11.85 1 8 1ZM11.4 6.45C11.6 6.25 11.6 5.95 11.4 5.75C11.2 5.55 10.9 5.55 10.7 5.75L6.4 10.05L4.85 8.5C4.65 8.3 4.3 8.3 4.15 8.5C4 8.7 4 9 4.15 9.2L6.05 11.1C6.25 11.3 6.55 11.3 6.75 11.1L11.4 6.45Z"></path></svg>
                <div class="circle1_span">
                <span>작업, 프로젝트, 저장 공간에 무제한으로</span><br><span>액세스해 보세요.</span>
                </div>
            </div>
            <div class="circle2">
                <svg width="30" height="30" viewBox="0 0 16 16" xmlns="http://www.w3.org/2000/svg" role="graphics-symbol" aria-labelledby="check-icon-title-id" aria-hidden="false" fill="var(--lightmode-text)" style="fill: var(--lightmode-text);"><title id="check-icon-title-id">check icon</title><path d="M8 16C3.6 16 0 12.4 0 8C0 3.6 3.6 0 8 0C12.4 0 16 3.6 16 8C16 12.4 12.4 16 8 16ZM8 1C4.15 1 1 4.15 1 8C1 11.85 4.15 15 8 15C11.85 15 15 11.85 15 8C15 4.15 11.85 1 8 1ZM11.4 6.45C11.6 6.25 11.6 5.95 11.4 5.75C11.2 5.55 10.9 5.55 10.7 5.75L6.4 10.05L4.85 8.5C4.65 8.3 4.3 8.3 4.15 8.5C4 8.7 4 9 4.15 9.2L6.05 11.1C6.25 11.3 6.55 11.3 6.75 11.1L11.4 6.45Z"></path></svg>
                <div class="circle2_span">
                    <span>목록, 보드, 캘린더와 같이 다양한 보기에서</span><br><span>업무를 확인하세요.</span>
                </div>
            </div>
            <div class="circle3">
                <svg width="30" height="30" viewBox="0 0 16 16" xmlns="http://www.w3.org/2000/svg" role="graphics-symbol" aria-labelledby="check-icon-title-id" aria-hidden="false" fill="var(--lightmode-text)" style="fill: var(--lightmode-text);"><title id="check-icon-title-id">check icon</title><path d="M8 16C3.6 16 0 12.4 0 8C0 3.6 3.6 0 8 0C12.4 0 16 3.6 16 8C16 12.4 12.4 16 8 16ZM8 1C4.15 1 1 4.15 1 8C1 11.85 4.15 15 8 15C11.85 15 15 11.85 15 8C15 4.15 11.85 1 8 1ZM11.4 6.45C11.6 6.25 11.6 5.95 11.4 5.75C11.2 5.55 10.9 5.55 10.7 5.75L6.4 10.05L4.85 8.5C4.65 8.3 4.3 8.3 4.15 8.5C4 8.7 4 9 4.15 9.2L6.05 11.1C6.25 11.3 6.55 11.3 6.75 11.1L11.4 6.45Z"></path></svg>
                <div class="circle3_span">
                    <span>Asana를 둘러볼 수 있도록 팀원을 초대하</span><br><span>세요.</span>
                </div>
            </div>
        </div>
    </div>
</body>
</html>