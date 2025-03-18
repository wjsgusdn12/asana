<%@page import="dao.MemberDao"%>
<%@page import="org.json.simple.parser.JSONParser"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.net.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<script type="text/javascript" src="https://static.nid.naver.com/js/naverLogin_implicit-1.0.3.js" charset="utf-8"></script>
	<script type="text/javascript" src="http://code.jquery.com/jquery-1.11.3.min.js"></script>
</head>
<body>
<%
    String error = request.getParameter("error"); // 네이버에서 전달한 에러 코드
    String errorDescription = request.getParameter("error_description");

    // 사용자가 로그인 동의를 취소한 경우
    if ("access_denied".equals(error)) {
%>
    <script>
    	location.href="Controller?command=join";
    </script>
<%
        return; // 아래 코드 실행 안 되도록 처리
    }%>
 <%
    String clientId = "SlpzkF26RVQ5YhX7pku7";//애플리케이션 클라이언트 아이디값";
    String clientSecret = "SOnxWZKWmZ";//애플리케이션 클라이언트 시크릿값";
    String code = request.getParameter("code");
    String state = request.getParameter("state");
    String redirectURI = URLEncoder.encode("http://localhost:9091/WebProject1/callback_naver_login.jsp", "UTF-8");
    String apiURL;
    apiURL = "https://nid.naver.com/oauth2.0/token?grant_type=authorization_code&";
    apiURL += "client_id=" + clientId;
    apiURL += "&client_secret=" + clientSecret;
    apiURL += "&redirect_uri=" + redirectURI;
    apiURL += "&code=" + code;
    apiURL += "&state=" + state;
    String access_token = "";
    String refresh_token = "";
    StringBuffer res = new StringBuffer();
    try {
      URL url = new URL(apiURL);
      HttpURLConnection con = (HttpURLConnection)url.openConnection();
      con.setRequestMethod("GET");
      int responseCode = con.getResponseCode();
      BufferedReader br;
      System.out.print("responseCode="+responseCode);
      if(responseCode==200) { // 정상 호출
        br = new BufferedReader(new InputStreamReader(con.getInputStream()));
      } else {  // 에러 발생
        br = new BufferedReader(new InputStreamReader(con.getErrorStream()));
      }
      String inputLine;
      while ((inputLine = br.readLine()) != null) {
        res.append(inputLine);
      }
      br.close();
      if(responseCode==200) {
       // System.out.println(res.toString());
      }
    } catch (Exception e) {
      System.out.println(e);
    }
    
    // res(String, StringBuffer) ---> JSON(access_token)
    JSONParser parser = new JSONParser();        
    JSONObject jsonObject = (JSONObject) parser.parse(res.toString());
    access_token = (String)jsonObject.get("access_token");
  %>
  
<%
	String token = access_token;// 네아로 접근 토큰 값";
	String header = "Bearer " + token; // Bearer 다음에 공백 추가
    StringBuffer res2 = new StringBuffer();
	try {
	    apiURL = "https://openapi.naver.com/v1/nid/me";
	    URL url = new URL(apiURL);
	    HttpURLConnection con = (HttpURLConnection)url.openConnection();
	    con.setRequestMethod("GET");
	    con.setRequestProperty("Authorization", header);
	    int responseCode = con.getResponseCode();
	    BufferedReader br;
	    if(responseCode==200) { // 정상 호출
	        br = new BufferedReader(new InputStreamReader(con.getInputStream()));
	    } else {  // 에러 발생
	        br = new BufferedReader(new InputStreamReader(con.getErrorStream()));
	    }
	    String inputLine;
	    while ((inputLine = br.readLine()) != null) {
	        res2.append(inputLine);
	    }
	    br.close();
	    
	    jsonObject = (JSONObject) parser.parse(res2.toString());
	    JSONObject jsonObject2 = (JSONObject) jsonObject.get("response");
	    String naverId = (String)jsonObject2.get("id");
	    String naverEmail = (String)jsonObject2.get("email");
	    String nickname = (String)jsonObject2.get("nickname");
	    /* request.setAttribute("naverEmail", naverEmail); */
/* 	    String name = (String)jsonObject2.get("name");
	    System.out.println("name : " + name);
	    System.out.println("name : " + korToUni(name)); */
	    MemberDao dao = new MemberDao();
	    Integer cnt = dao.selectNaverId(naverId);
	    if(cnt==1){%>
	   <%--  <%String naversEmail = (String) request.getAttribute("naverEmail"); %> --%>
	    	<script>
	    	location.href="Controller?command=login_action&email=<%= naverEmail %>";
	    	</script>
	    <%}
	    else if(cnt!=1){%>
	    	<script>
	    	alert("아이디가 존재하지 않습니다.");
	    	alert("회원가입 페이지로 이동합니다.");
	    	location.href="Controller?command=join";
	    	</script>
	    <%}
	} catch (Exception e) {
	    System.out.println(e);
	}
%>
</body>
</html>