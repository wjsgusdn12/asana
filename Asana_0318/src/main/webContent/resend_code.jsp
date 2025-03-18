<%@page import="mail.Mail"%>
<%@page import="dao.MemberDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    String email = request.getParameter("email");
	Integer newCode = (int)(Math.random() * 900000) + 100000;

    MemberDao dao = new MemberDao();
    dao.updateMemberCode(newCode, email);
    dao.resendCodeDate(email);
    Mail.sendMail(email, newCode);

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
	<script>
		location.href="code_join.jsp?email=<%=email%>";
	</script>
</head>
<body>

</body>
</html>