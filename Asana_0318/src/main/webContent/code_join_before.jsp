<%@page import="mail.Mail"%>
<%@page import="dao.MemberDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String email = (String)request.getAttribute("email");
	MemberDao dao = (MemberDao)request.getAttribute("dao");
	int cnt = (Integer)request.getAttribute("cnt");
	if(cnt == 1){%>
	<script>
		alert("이미 있는 아이디입니다.");
		history.back();
	</script>	
	<% }else if(cnt == 0){
		int code = (int)(Math.random()*900000)+100000;
		dao.insertMember(email, code);
		Mail.sendMail(email, code);
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src= "js/jquery-3.7.1.min.js"></script>
<script>
function sendData(email, url) {
    const form = document.createElement('form'); // form 태그 생성
    form.setAttribute('method', 'post'); // 전송 방식 결정 (post)

    // URL을 매개변수로 받아 동적으로 설정
    form.setAttribute('action', 'Controller?command=code_join'); // 전송할 URL 지정

    const data_1 = document.createElement('input'); // input 태그 생성
    data_1.setAttribute('type', 'hidden'); // type = hidden
    data_1.setAttribute('name', 'email'); // 데이터의 key
    data_1.setAttribute('value', email); // 데이터의 value

    // form 태그에 input 태그 추가
    form.appendChild(data_1);
    
    // form을 body에 추가하고 제출
    document.body.appendChild(form);

    // form 제출
    form.submit();
}

// 예시 호출
$(document).ready(function() {
    var email = '<%= email %>';  // JSP에서 이메일을 동적으로 가져옴
    sendData(email, 'Controller?command=code_join'); // 이메일과 URL을 전달하여 함수 호출
});
</script>

</head>
<body>
</body>
</html>