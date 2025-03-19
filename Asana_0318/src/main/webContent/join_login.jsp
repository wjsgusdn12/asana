<%@page import="java.math.BigInteger"%>
<%@page import="java.security.SecureRandom"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="dao.MemberDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String clientId = "SlpzkF26RVQ5YhX7pku7";//애플리케이션 클라이언트 아이디값";
	String redirectURI = URLEncoder.encode("http://localhost:9091/WebProject1/callback_naver_login.jsp", "UTF-8");
	SecureRandom random = new SecureRandom();
	String state = new BigInteger(130, random).toString();
	String apiURL = "https://nid.naver.com/oauth2.0/authorize?response_type=code";
	apiURL += "&client_id=" + clientId;
	apiURL += "&redirect_uri=" + redirectURI;
	apiURL += "&state=" + state;
	session.setAttribute("state", state);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="js/jquery-3.7.1.min.js"></script>
    <link rel="stylesheet" href="css/Join_login.css"/>
    <title>Document</title>
    <script>
    $(function() {
    	$(".kakao_login").click(function() {
    		alert("카카오 로그인");
    	})
    	$(".naver_login").click(function() {
    		location.href="<%=apiURL%>";
    	})
    });
  		function check(){
  			let email = $(".email").val();
  			let pw = $(".pw").val();
  			
  			if(email.length<=0){
  				alert("이메일 입력해주세요");
  				return false;
  			}else if(pw.length<=0){
  				alert("비번을 입력해주세요");
  				return false;
  			}else{
  				return true;
  			}
  		}
    </script> 
</head>
<body>
    <div id="content">
        <div class="mark">
            <svg fill="none" onclick="location.href='Controller?command=first_page';" aria-labelledby="asana-logo-title"><title id="asana-logo-title">Asana Home</title><path class="_nav_logo-link__text__2RL6n" id="asana-horizontal-logo__text" d="M108.202 16.703c.067.765.679 1.739 1.74 1.739h.62a.44.44 0 0 0 .438-.438V4.359h-.003a.437.437 0 0 0-.435-.414h-1.922a.437.437 0 0 0-.435.414h-.003v1.109c-1.178-1.452-3.035-2.055-4.897-2.055a7.667 7.667 0 0 0-7.665 7.67 7.668 7.668 0 0 0 7.665 7.672c1.862 0 3.892-.723 4.897-2.054v.002Zm-4.89-.633c-2.692 0-4.874-2.232-4.874-4.986 0-2.754 2.182-4.986 4.874-4.986 2.693 0 4.875 2.232 4.875 4.986 0 2.754-2.182 4.986-4.875 4.986ZM93.21 17.172v-7.06c0-3.981-2.51-6.666-6.51-6.666-1.91 0-3.476 1.105-4.029 2.055-.12-.743-.513-1.523-1.735-1.523h-.622a.439.439 0 0 0-.438.438v13.646h.003c.012.23.203.414.435.414h1.923c.029 0 .058-.004.086-.009.013-.002.024-.008.037-.011l.043-.013c.017-.008.032-.017.048-.026l.024-.013a.44.44 0 0 0 .053-.043l.01-.007a.434.434 0 0 0 .134-.292h.002v-8.06a3.87 3.87 0 0 1 3.868-3.871 3.87 3.87 0 0 1 3.868 3.87l.001 6.738v-.002l.002.018v1.307h.002c.013.23.203.414.435.414h1.923a.45.45 0 0 0 .086-.009c.011-.002.022-.007.033-.01.016-.004.032-.008.047-.014.016-.007.03-.016.045-.024l.027-.015a.49.49 0 0 0 .05-.04l.013-.01a.452.452 0 0 0 .049-.057l.003-.004a.434.434 0 0 0 .082-.23h.003v-.891ZM73.188 16.703c.067.765.68 1.739 1.74 1.739h.62c.24 0 .437-.197.437-.438V4.359h-.002a.438.438 0 0 0-.435-.414h-1.923a.438.438 0 0 0-.435.414h-.002v1.109c-1.178-1.452-3.035-2.055-4.898-2.055a7.667 7.667 0 0 0-7.664 7.67c0 4.237 3.431 7.672 7.664 7.672 1.863 0 3.892-.723 4.898-2.054v.002Zm-4.89-.633c-2.692 0-4.875-2.232-4.875-4.986 0-2.754 2.183-4.986 4.875-4.986s4.874 2.232 4.874 4.986c0 2.754-2.182 4.986-4.874 4.986ZM49.257 14.748c1.283.89 2.684 1.322 4.03 1.322 1.283 0 2.609-.665 2.609-1.823 0-1.546-2.89-1.787-4.705-2.405-1.815-.617-3.379-1.893-3.379-3.96 0-3.163 2.816-4.47 5.444-4.47 1.665 0 3.383.55 4.497 1.338.384.29.15.625.15.625l-1.063 1.52c-.12.17-.328.318-.628.133s-1.352-.93-2.956-.93c-1.603 0-2.57.74-2.57 1.66 0 1.1 1.256 1.447 2.727 1.823 2.562.691 5.357 1.522 5.357 4.666 0 2.786-2.604 4.508-5.483 4.508-2.181 0-4.038-.622-5.596-1.766-.324-.325-.098-.627-.098-.627l1.058-1.512c.216-.282.487-.184.606-.102ZM41.866 16.703c.068.765.68 1.739 1.74 1.739h.62a.44.44 0 0 0 .438-.438V4.359h-.003a.437.437 0 0 0-.435-.414h-1.922a.438.438 0 0 0-.435.414h-.003v1.109c-1.178-1.452-3.035-2.055-4.897-2.055a7.668 7.668 0 0 0-7.665 7.67c0 4.237 3.432 7.672 7.665 7.672 1.862 0 3.892-.723 4.897-2.054v.002Zm-4.89-.633c-2.692 0-4.874-2.232-4.874-4.986 0-2.754 2.182-4.986 4.875-4.986 2.692 0 4.874 2.232 4.874 4.986 0 2.754-2.182 4.986-4.874 4.986Z" fill="#0D0E10"></path><path  class="_nav_logo-link__asana-icon__Un0sE" id="asana-horizontal-logo__icon" d="M18.559 11.605a5.158 5.158 0 1 0 0 10.317 5.158 5.158 0 0 0 0-10.317Zm-13.401.001a5.158 5.158 0 1 0 0 10.315 5.158 5.158 0 0 0 0-10.315Zm11.858-6.448a5.158 5.158 0 1 1-10.316 0 5.158 5.158 0 0 1 10.316 0Z" fill="#FF584A"></path></svg>
	        <div class="top_text_area">
	            <div class="title">
	                <h1>Asana에 오신 것을 환영합니다</h1>
	            </div>
	            <div class="start_login">
	                <h3>시작하려면 로그인하세요</h3>
	            </div>
	        </div>
        </div>
        <div class="login_button_area">
	        <div class="kakao_login">
	            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 20 20" class="kakao_logo"><title>kakao 로고</title><path fill-rule="evenodd" clip-rule="evenodd" d="M9.96052 3C5.83983 3 2.5 5.59377 2.5 8.79351C2.5 10.783 3.79233 12.537 5.75942 13.5807L4.9313 16.6204C4.85835 16.8882 5.1634 17.1029 5.39883 16.9479L9.02712 14.5398C9.33301 14.5704 9.64386 14.587 9.96052 14.587C14.0812 14.587 17.421 11.9932 17.421 8.79351C17.421 5.59377 14.0812 3 9.96052 3Z" fill="black"></path></svg>
	            <span>카카오 로그인</span>
	        </div>
	        <div class="naver_login">
	            <img src="img/naver.png"/>
	            <span>네이버 로그인</span>
	        </div>
	    </div>
        <div class="line_div_area">
	        <div class="line_left"></div>
	        <div class="line_in_span">
	            <span>또는</span>
	        </div>
	        <div class="line_right"></div>
	    </div>
	    <div class="form_area">
	        <div class="email_span">
	            <span>이메일 주소</span>
	            <span style="color:red;">테스트 계정 : hw@gmail.com</span>
	        </div>
	        <!--로그인 유효성 체크 -->
	        <form action="Controller" method="post">
	        <input type="hidden" name="command" value="login_action"/>
		        <div class="email_input">
		            <input type="email" class= "email" name="email" placeholder="이메일 주소" required/>
		        </div>
		        <div class="send_bt">
		            <input type="submit" class="send_bt_input" value="계속" onclick="return check();"/>
		        </div>
	        </form>
        </div>
        <!--로그인 유효성 체크 -->
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