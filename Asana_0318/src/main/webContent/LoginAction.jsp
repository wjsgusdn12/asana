<%@page import="dto.MemberDto"%>
<%@page import="dao.MemberDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String email = (String)request.getAttribute("email");
	MemberDao dao = (MemberDao)request.getAttribute("dao");
	boolean login = (boolean)request.getAttribute("login");
	MemberDto dto = (MemberDto)request.getAttribute("dto");
	int memberIdx = (Integer)request.getAttribute("memberIdx");
	if(!login){%>
		<script>
			alert("아이디가 없거나 틀렸습니다.");
			location.href = "Controller?command=login";
		</script>
	<%}else if(dto.getCode() != null && dto.getCodeDate() != null) {%>
		<script>
			alert("아이디가 없습니다. 인증을 완료해주세요.");
			location.href = "Controller?command=login";
		</script>
	<% }else if(login) { 
		//session.setAttribute("member_idx",memberIdx);
	%>
		<script>
			let memberIdx = <%= memberIdx %>;
			location.href="Controller?command=home&member_idx="+memberIdx;
		</script>
	<%}%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

</body>
</html>