<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>아사나 프로젝트 생성하기</title>
<link rel="stylesheet" href="css/asana_create_project.css" />
<script src="js/jquery-3.7.1.min.js"></script>
<script>
	$(function() {
		$(".three-in-one-box").click(function() {
			location.href = "Controller?command=create_project2&member_idx=${loginMemberIdx}";
		});
		$(".Icon-Back").click(function(){
			history.back();
		});
		$(".Icon-Cancle").click(function(){
			history.back();
		});
		$(".three-in-one-box").click(function(){
			
		});
	});
</script>
</head>
<body>
	<div class="whole-div">
		<div class="top-div">
			<div role="button" aria-label="뒤로 이동" tabindex="0" class="Icon-Back">
				<svg class="Icon-back" viewBox="0 0 32 32" aria-hidden="true" focusable="false">
					<path d="M29 16.5a1.5 1.5 0 0 0-1.5-1.5H7.621l7.439-7.439a1.5 1.5 0 1 0-2.121-2.121l-10 10a1.5 1.5 0 0 0 0 2.121l10 10c.293.293.677.439 1.061.439a1.5 1.5 0 0 0 1.061-2.56l-7.439-7.439h19.879a1.5 1.5 0 0 0 1.5-1.5L29 16.5Z"></path></svg>
			</div>
			<div role="button" aria-label="닫기" tabindex="0" class="Icon-Cancle">
				<svg class="Icon-close" viewBox="0 0 32 32" aria-hidden="true" focusable="false">
					<path d="M18.1,16L27,7.1c0.6-0.6,0.6-1.5,0-2.1s-1.5-0.6-2.1,0L16,13.9l-8.9-9C6.5,4.3,5.6,4.3,5,4.9S4.4,6.4,5,7l8.9,8.9L5,24.8c-0.6,0.6-0.6,1.5,0,2.1c0.3,0.3,0.7,0.4,1.1,0.4s0.8-0.1,1.1-0.4l8.9-8.9l8.9,8.9c0.3,0.3,0.7,0.4,1.1,0.4s0.8-0.1,1.1-0.4c0.6-0.6,0.6-1.5,0-2.1L18.1,16z"></path></svg>
			</div>
		</div>
		<div class="under-div">
			<div class="content">
				<div>
					<div class="text32">새 프로젝트 생성</div>
					<div class="text20">어떻게 시작하고 싶으세요?</div>
				</div>
				<div class="three-in-one-box">
					<div class="NewProject">
						<svg class="PlusIcon" viewBox="0 0 32 32" aria-hidden="true" focusable="false">
							<path d="M26,14h-8V6c0-1.1-0.9-2-2-2l0,0c-1.1,0-2,0.9-2,2v8H6c-1.1,0-2,0.9-2,2l0,0c0,1.1,0.9,2,2,2h8v8c0,1.1,0.9,2,2,2l0,0c1.1,0,2-0.9,2-2v-8h8c1.1,0,2-0.9,2-2l0,0C28,14.9,27.1,14,26,14z"></path></svg>
					</div>
					<div class="bin-project">빈 프로젝트</div>
					<div class="first-start">처음부터 시작하기</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>