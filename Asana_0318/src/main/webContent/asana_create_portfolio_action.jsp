<%@page import="dto.PortfolioDto"%>
<%@page import="dao.PortfolioDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("utf-8");
	String name = request.getParameter("portfolio_name");
	int memberIdx = Integer.parseInt(request.getParameter("member_idx"));
	PortfolioDao dao = new PortfolioDao();
	dao.createPortfolio(name, memberIdx);
%>
<script>
	alert("포트폴리오 생성을 완료하였습니다");
	location.href="asana_home.jsp?member_idx=<%=memberIdx%>";
</script>