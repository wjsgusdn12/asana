<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>아사나 프로젝트 생성하기2</title>
<link rel="stylesheet" href="css/asana_create_portfolio.css" />
<script src="js/jquery-3.7.1.min.js"></script>
<script>
	$(function() {
		$(".title").keyup(function() {
			if ($(this).val().length == 0) {
				$(".no-title-text").css('display', 'block');
				$(".CreateButton").removeClass("on");
			} else if ($(this).val().length > 0) {
				$(".no-title-text").css('display', 'none');
				$(".CreateButton").addClass("on");
			}
		});
		$(".Icon-Back").click(function() {
			history.back();
		});
		$(".Icon-Cancle").click(function() {
			history.go(-2);
		});
		$(".CreateButton").click(function() {
			//alert("프로젝트를 생성합니다");
		});
	});
</script>
</head>
<body>
	<div class="whole-div">
		<div class="top-div">
			<div role="button" aria-label="뒤로 이동" tabindex="0" class="Icon-Back">
				<svg class="Icon" viewBox="0 0 32 32" aria-hidden="true" focusable="false">
					<path d="M29 16.5a1.5 1.5 0 0 0-1.5-1.5H7.621l7.439-7.439a1.5 1.5 0 1 0-2.121-2.121l-10 10a1.5 1.5 0 0 0 0 2.121l10 10c.293.293.677.439 1.061.439a1.5 1.5 0 0 0 1.061-2.56l-7.439-7.439h19.879a1.5 1.5 0 0 0 1.5-1.5L29 16.5Z"></path></svg>
			</div>
			<div role="button" aria-label="닫기" tabindex="0" class="Icon-Cancle">
				<svg class="Icon" viewBox="0 0 32 32" aria-hidden="true" focusable="false">
					<path d="M18.1,16L27,7.1c0.6-0.6,0.6-1.5,0-2.1s-1.5-0.6-2.1,0L16,13.9l-8.9-9C6.5,4.3,5.6,4.3,5,4.9S4.4,6.4,5,7l8.9,8.9L5,24.8c-0.6,0.6-0.6,1.5,0,2.1c0.3,0.3,0.7,0.4,1.1,0.4s0.8-0.1,1.1-0.4l8.9-8.9l8.9,8.9c0.3,0.3,0.7,0.4,1.1,0.4s0.8-0.1,1.1-0.4c0.6-0.6,0.6-1.5,0-2.1L18.1,16z"></path></svg>
			</div>
		</div>
		<div class="under-div">
			<div class="content">
				<div class="main-content">
					<div class="font32">새 프로젝트</div>
					<div class="font12">프로젝트 이름</div>
					<%-- <form action="asana_create_project2_action.jsp?member_idx=${loginMemberIdx}" method="post" class="project_info_form"> --%>
					<form action="Controller" method="get" class="project_info_form">
						<input type="hidden" name="command" value="create_project_action" />
    					<input type="hidden" name="member_idx" value="${loginMemberIdx}" />
						<div>
							<input class="title" type="text" name="project_name" /><br />
							<div class="no-title-text" style="color: red; font-size: 12px;">
								프로젝트 이름이 필요합니다
							</div>
						</div>
						<div class="font12">공개 범위</div>
						<div>
							<select class="selectBox" name="range">
								<option value="1">내 작업 공간에 공개</option>
								<option value="2">프로젝트 멤버에게만 공개</option>
							</select>
						</div>
						<div>
							<button class="CreateButton">생성</button>
						</div>
					</form>
				</div>
				<div class="main-image">
					<img src="img\ProjectView.png" />
				</div>
			</div>
		</div>
	</div>
</body>
</html>