<%@page import="dto.PortfolioDto"%>
<%@page import="dto.MemberDto"%>
<%@page import="dto.ProjectDto"%>
<%@page import="dto.AlarmUpdateDto"%>
<%@page import="dao.AlarmUpdateDao"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="dto.MemberAllDto"%>
<%@page import="dao.MemberDao"%>
<%@page import="dao.WamDao"%>
<%@page import="dto.WamAllDto"%>
<%@page import="dto.ProjectAllDto"%>
<%@page import="dao.ProjectDao"%>
<%@page import="dao.PortfolioDao"%>
<%@page import="dto.PortfolioAllDto"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

 <%
	 ArrayList<AlarmUpdateDto> alarmUpdateList = (ArrayList<AlarmUpdateDto>)request.getAttribute("alarmUpdateList");
	 ArrayList<PortfolioAllDto> portfolioAllDtolist = (ArrayList<PortfolioAllDto>)request.getAttribute("portfolioAllDtolist");
	 PortfolioDao portfolioDao = (PortfolioDao)request.getAttribute("portfolioDao");
	 ArrayList<WamAllDto> completedSectionWamList = (ArrayList<WamAllDto>)request.getAttribute("completedSectionWamList");
	 SimpleDateFormat formatter1 = (SimpleDateFormat)request.getAttribute("formatter1");
	 SimpleDateFormat formatter2 = (SimpleDateFormat)request.getAttribute("formatter2");
	 ArrayList<WamAllDto> runningwamAllDtoList = (ArrayList<WamAllDto>)request.getAttribute("runningwamAllDtoList");
	 ArrayList<WamAllDto> wamAllSectionlist = (ArrayList<WamAllDto>)request.getAttribute("wamAllSectionlist");
	 MemberDao memberDao = (MemberDao)request.getAttribute("memberDao");
	 int pDtoFavoritesListLength = (Integer)request.getAttribute("pDtoFavoritesListLength");
	 int favoritesWorkspaceCount = (Integer)request.getAttribute("favoritesWorkspaceCount");
	 ArrayList<ProjectDto> pDtoFavoritesList = (ArrayList<ProjectDto>)request.getAttribute("pDtoFavoritesList");
	 ArrayList<MemberDto> mDaoFavoritesList = (ArrayList<MemberDto>)request.getAttribute("mDaoFavoritesList");
	 ArrayList<ProjectDto> pDtoList = (ArrayList<ProjectDto>)request.getAttribute("pDtoList");
	 ArrayList<PortfolioDto> portfolioList = (ArrayList<PortfolioDto>)request.getAttribute("portfolioList");
	 String myProfile = (String)request.getAttribute("myProfile");
	 int alarm = (Integer)request.getAttribute("alarm");
	 String memberStartDate = (String)request.getAttribute("memberStartDate");
	 String memberDeadDate = (String)request.getAttribute("memberDeadDate");
 %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Asana 보드</title>
<!-- <link rel="stylesheet" href="http://localhost:9090/WebProject1/asana/asana_css/asana_main.css"/> -->
<link rel="stylesheet" href="css/main_board.css" />
<link rel="stylesheet" href="css/main_outline.css" />
<link rel="stylesheet" href="css/asana_main.css" />
<link rel="stylesheet" href="css/inventory_milestone_content.css" />
<link rel="stylesheet" href="css/blank_inventory_milestone_content.css" />
<link rel="stylesheet" href="https://code.jquery.com/ui/1.14.1/themes/base/jquery-ui.css">
<link rel="stylesheet" href="http://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/css/toastr.min.css">
<link rel="stylesheet" href="css/Main_Common.css"/>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://code.jquery.com/ui/1.14.1/jquery-ui.js"></script>
<script src="http://cdnjs.cloudflare.com/ajax/libs/toastr.js/2.0.2/js/toastr.min.js"></script>

<script>
	/*********************************** 요소 클릭시 어느 페이지로 이동할지 *************************************/
	$(function(){
		/* 사이드바 목록 선택 시 어디로 이동 할지 *//* 사이드바 목록 선택 시 어디로 이동 할지 *//* 사이드바 목록 선택 시 어디로 이동 할지 */
		$(".sidebar_item").click(function() {
			const text = $(this).text().trim();
			let projectIdx = $(this).attr("project_idx")||null;
			let portfolioIdx = $(this).attr("portfolio_idx")||null;
			let memberIdx = $(this).attr("member_idx")||null;
			
			if(projectIdx!=null){
				location.href="Controller?command=main_inventory&member_idx=${loginMemberIdx}&project_idx="+projectIdx;
			}
			if(portfolioIdx!=null){
				//location.href="main_inventory.jsp?portfolio_idx="+portfolioIdx;
			}
			if(memberIdx!=null){
				location.href="Controller?command=other_profile&member_idx="+memberIdx;
			}
			
			if (text === "내 작업 공간") {
				location.href="Controller?command=my_workspace&member_idx=${loginMemberIdx}&owner_idx=1";
			} else if (text === "수신함") {
				location.href="alarm_page.jsp?loginMemberIdx=${loginMemberIdx}";
			} else if (text === "내 작업") {
				alert("내 작업 이동");
			} else if (text === "홈") {
				location.href = "Controller?command=home&member_idx=${loginMemberIdx}";
			} else if (text === "팀원 초대") {
				$(".popup_invite_whole-div").css('display', 'flex');
			}
		});
		/* 사이드바 목록 선택 시 어디로 이동 할지 *//* 사이드바 목록 선택 시 어디로 이동 할지 *//* 사이드바 목록 선택 시 어디로 이동 할지 */
		/* 개요 클릭시 */
		$(document).on("click", ".over_view_button", function () {
			location.href="Controller?command=main_outline&member_idx=${loginMemberIdx}&project_idx=${projectIdx}";
		});
		/* 목록 클릭시 */
		$(document).on("click", ".list_view_button", function () {
			location.href="Controller?command=main_inventory&member_idx=${loginMemberIdx}&project_idx=${projectIdx}";
		});
		/* 보드 클릭시 */
		$(document).on("click", ".board_view_button", function () {
			location.href="Controller?command=main_board&member_idx=${loginMemberIdx}&project_idx=${projectIdx}";
		});
		/* 메시지 클릭시 */
		$(document).on("click", ".message_view_button", function () {
			location.href="Controller?command=message&member_idx=${loginMemberIdx}&project_idx=${projectIdx}";
		});
		/* 파일 클릭시 */
		$(document).on("click", ".file_view_button", function () {
			location.href="Controller?command=file&member_idx=${loginMemberIdx}&project_idx=${projectIdx}";
		});
		/* 메모 클릭시 */
		$(document).on("click", ".memo_view_button", function () {
			location.href="Controller?command=memo&member_idx=${loginMemberIdx}&project_idx=${projectIdx}";
		});
		/* 상단바 생성버튼 클릭시 */
		$("#creation_button").click(function() {
			$(".create_something_popup").toggleClass("on");
		});
		/* 상단바 팝업창 작업 생성 클릭 */
		$(".popup_create_work").click(function() {
			alert("작업 생성 클릭!");
		});
		/* 상단바 팝업창 프로젝트 생성 클릭 */
		$(".popup_create_project").click(function() {
			location.href="Controller?command=create_project&member_idx=${loginMemberIdx}";
		});
		/* 상단바 팝업창 메시지 생성 클릭 */
		$(".popup_create_message").click(function() {
			alert("메시지 생성 클릭!");
		});
		/* 상단바 팝업창 포트폴리오 생성 클릭 */
		$(".popup_create_portfolio").click(function() {
			//location.href="Controller?command=create_portfolio&member_idx=${memberIdx}";
		});
/*************************************** 상단바 프로필셋팅 팝업창 **************************************/
		// 부재중 시작
		$("#start_date, #end_date").on("input change", function () {
		    let startDate = $("#start_date").val();
		    let endDate = $("#end_date").val();

		    if (startDate > endDate) {
		        $(".deadline_red_span").show(); // 빨간 글씨 표시
		    } else {
		        $(".deadline_red_span").hide(); // 빨간 글씨 숨김
		    }
		});
		// 부재중 토글 클릭
		$(".toggle_input").click(function () {
		    let checked = $(this).is(":checked"); // 체크박스 true or false
		    let memberIdx = ${loginMemberIdx};
		
		    if (checked) {
		        $(".toggle_click_view").addClass("on");
		        $(".deadline_red_span").show();
		        $.ajax({
		            type: 'post',
		            data: { "member_idx": memberIdx },
		            url: 'AjaxSetAlarmServlet',
		            success: function (data) {
		                console.log("알림 설정 성공:", data);
		            },
		            error: function (r, s, e) {
		                console.log("[에러] code: " + r.status + ", message: " + r.responseText + ", error: " + e);
		            }
		        });
		    } else {
		        $(".toggle_click_view").removeClass("on");
		        $(".deadline_red_span").hide();
		        $("#start_date").val(""); // 시작일 날짜를 초기화
		        $("#end_date").val(""); // 종료일 날짜를 초기화
		        $.ajax({
		            type: 'post',
		            data: { "member_idx": memberIdx },
		            url: 'AjaxSetAlarmEndServlet',
		            success: function (data) {
		                console.log("알림 해제 성공:", data);
		            },
		            error: function (r, s, e) {
		                console.log("[에러] code: " + r.status + ", message: " + r.responseText + ", error: " + e);
		            }
		        });
		    }
		});
		//프로필 셋팅 팝업창 닫기 클릭
		$(".profile_setting_XIcon").click(function(){
			let memberIdx = $(this).closest(".profile_setting_background").attr("member_idx");
			let nickname = $(this).closest(".profile_setting_background").find("#profile_setting_name").val();
			let introduce = $(this).closest(".profile_setting_background").find("#profile_setting_introduction").val();
			let startDate = $("#start_date").val();
			let endDate = $("#end_date").val();
			let alarmOn = $(".toggle_click_view").hasClass("on");
			if(alarmOn){
				if (!startDate || !endDate) {
		            alert("시작일과 종료일을 모두 선택해주세요.");
		            e.preventDefault(); // 기본 동작(예: 폼 제출, 링크 이동 등) 차단
		            e.stopPropagation(); // 이벤트 전파 차단
		            return;
   	    	 	}
			        if (startDate > endDate) {
		            alert("종료일은 시작일보다 작을 수 없습니다.");
		            e.preventDefault(); // 기본 동작(예: 폼 제출, 링크 이동 등) 차단
		            e.stopPropagation(); // 이벤트 전파 차단
		            return;
   		     	}
			}
			$(".profile_setting_background").css('display','none');
			$.ajax({
				type: 'post',
				url: 'AjaxUpdateStartDateServlet',
				data: {"start_date":startDate , "member_idx":memberIdx},
					success: function(data){},
					error: function(r,s,e){
						console.log("[에러] code: " + r.status + ", message: " + r.responseText + ", error: " + e);
					}
			});
			$.ajax({
				type: 'post',
				url: 'AjaxUpdateDeadlineDateServlet',
				data: {"end_date":endDate , "member_idx":memberIdx},
				success: function(data){},
				error: function(r,s,e){
					console.log("[에러] code: " + r.status + ", message: " + r.responseText + ", error: " + e);
				}
			});
			$.ajax({
				type: 'post',
				url: 'AjaxUpdateNicknameServlet',
				data:{"member_idx":memberIdx, "nickname":nickname},
				success: function(data){
					location.reload();
				},
				error: function(r,s,e){
					console.log("[에러] code: " + r.status + ", message: " + r.responseText + ", error: " + e);
				}
			});
			$.ajax({
				type: 'post',
				url: 'AjaxUpdateIntroduceServlet',
				data: {"member_idx":memberIdx, "introduce":introduce},
				success: function(data){
				},
				error: function(r,s,e){
					console.log("[에러] code: " + r.status + ", message: " + r.responseText + ", error: " + e);
				}
			});
		});
		// 프로필 설정창 배경화면 누르면 꺼지게
		$(".profile_setting_background").click(function() {
			let memberIdx = $(this).closest(".profile_setting_background").attr("member_idx");
			let nickname = $(this).closest(".profile_setting_background").find("#profile_setting_name").val();
			let introduce = $(this).closest(".profile_setting_background").find("#profile_setting_introduction").val();
			let startDate = $("#start_date").val();
			let endDate = $("#end_date").val();
			let alarmOn = $(".toggle_click_view").hasClass("on");
			if(alarmOn){
				if (!startDate || !endDate) {
		            alert("시작일과 종료일을 모두 선택해주세요.");
		            e.preventDefault(); // 기본 동작(예: 폼 제출, 링크 이동 등) 차단
		            e.stopPropagation(); // 이벤트 전파 차단
		            return;
   	    	 	}
			        if (startDate > endDate) {
		            alert("종료일은 시작일보다 작을 수 없습니다.");
		            e.preventDefault(); // 기본 동작(예: 폼 제출, 링크 이동 등) 차단
		            e.stopPropagation(); // 이벤트 전파 차단
		            return;
   		     	}
			}
			$(".profile_setting_background").css('display','none');
			$.ajax({ // 시작일 업데이트
				type: 'post',
				url: 'AjaxUpdateStartDateServlet',
				data: {"start_date":startDate , "member_idx":memberIdx},
				success: function(data){
					
				},
				error: function(r,s,e){
					console.log("[에러] code: " + r.status + ", message: " + r.responseText + ", error: " + e);
				}
			});
			$.ajax({ // 마감일 업데이트 
				type: 'post',
				url: 'AjaxUpdateDeadlineDateServlet',
				data: {"end_date":endDate , "member_idx":memberIdx},
				success: function(data){},
				error: function(r,s,e){
					console.log("[에러] code: " + r.status + ", message: " + r.responseText + ", error: " + e);
				}
			});
			
			$.ajax({ // 닉네임 업데이트
				type: 'post',
				url: 'AjaxUpdateNicknameServlet',
				data:{"member_idx":memberIdx, "nickname":nickname},
				success: function(data){
					location.reload();
				},
				error: function(r,s,e){
					console.log("[에러] code: " + r.status + ", message: " + r.responseText + ", error: " + e);
				}
			});
			$.ajax({ // 내소개 업데이트
				type: 'post',
				url: 'AjaxUpdateIntroduceServlet',
				data: {"member_idx":memberIdx, "introduce":introduce},
				success: function(data){
				},
				error: function(r,s,e){
					console.log("[에러] code: " + r.status + ", message: " + r.responseText + ", error: " + e);
				}
			});
		});
		// 프로필 설정 메인 영역 클릭 시 이벤트가 부모로 전달되지 않도록 설정
		$("#profile_setting_main").click(function() {
			event.stopPropagation();
		});
		/*************************************** 상단바 프로필셋팅 팝업창 **************************************/
		/********************************** 상단바 미니 프로필 팝업창 *******************************/
		//상단바 프로필이미지 클릭시 프로필 팝업창 나옴
		$("#me_button").click(function(){
			$(".me_button_popup").toggleClass("on");
		});
		//프로필 팝업창 Asana에 초대 아이콘 클릭
		$(".popup_invite_member").click(function(){
			$(".popup_invite_whole-div").css('display', 'flex');
			$(".me_button_popup").removeClass("on");
		});
		//프로필 팝업창 프로필 아이콘 클릭
		$(".popup_profile_info_details").click(function(){
			let loginMemberIdx = ${loginMemberIdx};
			location.href="Controller?command=profile_page&member_idx=${loginMemberIdx}";
		});
		//프로필 팝업창 설정 아이콘 클릭
		$(".popup_setting").click(function(){
			$(".profile_setting_background").css('display','block');
			$(".me_button_popup.on").removeClass("on");
		});
		//프로필 팝업창 로그아웃 클릭
		$(".popup_logout").click(function(){
			location.href="LogOut.jsp";
		});
		//프로필 셋팅 팝업창 닫기 클릭
		$(".profile_setting_XIcon").click(function(){
			$(".profile_setting_background").css('display','none');
		});
		// 프로필 설정창 배경화면 누르면 꺼지게
		$(".profile_setting_background").click(function() { 
			$(this).hide();
		});
		/********************************** 상단바 미니 프로필 팝업창 *******************************/
/************************** 사이드바 프로젝트 "+" 팝업, 열고닫기 ****************************/
	/* 사이드바 프로젝트 + 클릭시 */
	$(".PlusMiniIcon").click(function(){
		$(".sidebar_project_plus_popup").toggleClass("on");
	});
	/* 새 프로젝트 클릭 */	
	$(".sidebar_create_project").click(function(){
		location.href="Controller?command=create_project&member_idx=${loginMemberIdx}";
	});
	/* 새 포트폴리오 클릭 */
	$(".sidebar_create_portfolio").click(function(){
		//location.href="Controller?command=create_portfolio&member_idx=${memberIdx}";
	});
	/* 사이드바 숨기고 열기 */
	$("#menu_button").click(function() {
		if( $("#sidebar").css('left')!='0px' ) {
			$("#sidebar").animate({left: 0}, 500);
		} else {
			$("#sidebar").animate({left: '-300px'}, 500);
		}
	});
	/************************** 사이드바 프로젝트 "+" 팝업, 열고닫기 ****************************/
/* 사이드바 목록 선택 시 어디로 이동 할지 *//* 사이드바 목록 선택 시 어디로 이동 할지 *//* 사이드바 목록 선택 시 어디로 이동 할지 */
	$(".sidebar_item").click(function() {
		const text = $(this).text().trim();
		let projectIdx = $(this).attr("project_idx")||null;
		let portfolioIdx = $(this).attr("portfolio_idx")||null;
		let memberIdx = $(this).attr("member_idx")||null;
		
		if(projectIdx!=null){
			location.href="Controller?command=main_inventory&member_idx=${loginMemberIdx}&project_idx="+projectIdx;
		}
		if(portfolioIdx!=null){
			//location.href="main_inventory.jsp?portfolio_idx="+portfolioIdx;
		}
		if(memberIdx!=null){
			location.href="Controller?command=other_profile&member_idx="+memberIdx;
		}
		
		if (text === "내 작업 공간") {
			location.href="Controller?command=my_workspace&member_idx=${loginMemberIdx}&owner_idx=1";
		} else if (text === "수신함") {
			location.href="alarm_page.jsp?loginMemberIdx=${loginMemberIdx}";
		} else if (text === "내 작업") {
			alert("내 작업 이동");
		} else if (text === "홈") {
			location.href = "Controller?command=home&member_idx=${loginMemberIdx}";
		} else if (text === "팀원 초대") {
			$(".popup_invite_whole-div").css('display', 'flex');
		}
	});
	/* 사이드바 목록 선택 시 어디로 이동 할지 *//* 사이드바 목록 선택 시 어디로 이동 할지 *//* 사이드바 목록 선택 시 어디로 이동 할지 */
/* 초대창 제이쿼리 *//* 초대창 제이쿼리 *//* 초대창 제이쿼리 *//* 초대창 제이쿼리 *//* 초대창 제이쿼리 *//* 초대창 제이쿼리 *//* 초대창 제이쿼리 */
		/* 인풋 이메일 x아이콘 hover */
		$(document).on("mouseenter", ".invite_email_remove_button", function(){
			$(this).find(".invite_email_remove_button_outline").css('fill','black');
			$(this).find(".invite_email_remove_button_inline").css('fill','white');
		});
		$(document).on("mouseleave", ".invite_email_remove_button", function(){
			$(this).find(".invite_email_remove_button_outline").css('fill','lightgray');
			$(this).find(".invite_email_remove_button_inline").css('fill','black');
		});
		/* 인풋 이메일 요소 삭제 */
		$(document).on("click", ".invite_email_remove_button", function(){
			$(this).parent().remove();
			let len = 0;
			document.querySelectorAll(".input_email_div").forEach(function(item){
				str += $(item).text().trim() + "\n";
				len++;
			});
			if (len != 0) {
		        $(".popup_invite_button").addClass("on"); // 인풋된 이메일div 갯수가 있으면 버튼 활성화
		    }
			if(len==0){
		        $(".popup_invite_button").removeClass("on"); // 인풋된 이메일div 갯수가 없으면 버튼 비활성화
		    }
		});
		$(".invite_input_text_area").keydown(function(e) {
			// 이메일 div 및 기타 요소를 제외한 순수 텍스트만 가져오기
			let inputEmail = $(".invite_input_text_area").val();
			$(function(){
				let len = 0;
				document.querySelectorAll(".input_email_div").forEach(function(item){
					str += $(item).text().trim() + "\n";
					len++;
				});
				if (len != 0) {
			        $(".popup_invite_button").addClass("on"); // 인풋된 이메일div 갯수가 있으면 버튼 활성화
			    }
				if(len==0){
			        $(".popup_invite_button").removeClass("on"); // 인풋된 이메일div 갯수가 없으면 버튼 비활성화
			    }
			});
			if(e.key === "Backspace"){
				if(inputEmail===''){
					alert("이메일 입력값이 없습니다, 이메일을 작성해주세요.");
					e.preventDefault();
				}
			}
		    if (e.key === "Enter" || e.keyCode === 32) { // 엔터키 감지
		    	let boolean = true;
		    	document.querySelectorAll(".input_email_div").forEach(function(item, index){
		    		let str = $(item).text().trim();
		    		if(inputEmail == str){
		    			alert("중복된 이메일이 있습니다, 다시 작성해주세요.\n중복된 이메일 : " + inputEmail);
		    			e.preventDefault();
		    			boolean = false;
		    		}
		    	});
		    	if(!boolean){
		    		return;
		    	}
		    	e.preventDefault();
		    	if(inputEmail===''){
		    		alert("이메일 입력값이 없습니다, 이메일을 작성해주세요.");
		    		e.preventDefault();
		    		return;
		    	}
		    	e.preventDefault(); // 엔터키 동작 무시
				let len = $(this).find("div[role='gridcell']").length; // 인풋된 이메일div 갯수
				$.ajax({
		        	type:'post',
		        	data:{"inputEmail":inputEmail},
		        	url:'AjaxAddInputEmail',
		        	success:function(data){
		        		let str = `<div contenteditable="false" role="gridcell" tabindex="-1" class="fl input_email_div">
										<div class="" style="">
											<span class="">` + data.inputEmail + `</span>
											<svg class="" viewBox="0 0 24 24" aria-hidden="true" focusable="false" style="width: 15px; height: 15px; fill: gray;">
											<path d="M12 0C5.383 0 0 5.383 0 12s5.383 12 12 12 12-5.383 12-12S18.617 0 12 0Zm9.159 8h-3.482c-.342-2.061-.943-3.837-1.739-5.189A10.057 10.057 0 0 1 21.159 8ZM12 2c1.413 0 2.951 2.396 3.636 6H8.365c.685-3.604 2.222-6 3.636-6H12Zm-3.938.811C7.266 4.163 6.665 5.939 6.323 8H2.841a10.057 10.057 0 0 1 5.221-5.189ZM2 12c0-.685.07-1.354.202-2h3.881c-.05.649-.083 1.313-.083 2s.033 1.351.083 2H2.202A9.983 9.983 0 0 1 2 12Zm.841 4h3.482c.342 2.061.943 3.837 1.739 5.189A10.057 10.057 0 0 1 2.841 16ZM12 22c-1.413 0-2.951-2.396-3.636-6h7.271c-.685 3.604-2.222 6-3.636 6H12Zm-3.911-8a22.636 22.636 0 0 1 0-4h7.821a22.636 22.636 0 0 1 0 4H8.089Zm7.849 7.189c.796-1.352 1.397-3.128 1.739-5.189h3.482a10.057 10.057 0 0 1-5.221 5.189ZM17.917 14c.05-.649.083-1.313.083-2s-.033-1.351-.083-2h3.881a9.983 9.983 0 0 1 0 4h-3.881Z"></path></svg>
										</div>
										<!-- 인풋요소 x 아이콘 -->
										<div class="invite_email_remove_button" data-testid="token-remove-button" role="presentation" style="width: 15px; height: 15px;">
											<svg class="" viewBox="0 0 32 32" aria-hidden="true" focusable="false">
											<path class="invite_email_remove_button_outline" d="M31,16c0,8.3-6.7,15-15,15S1,24.3,1,16S7.7,1,16,1S31,7.7,31,16z"></path>
											<path class="invite_email_remove_button_inline" d="M22.5,20.7c0.5,0.5,0.5,1.3,0,1.8c-0.2,0.2-0.5,0.4-0.9,0.4s-0.6-0.1-0.9-0.4L16,17.8l-4.7,4.7c-0.2,0.2-0.5,0.4-0.9,0.4s-0.6-0.1-0.9-0.4C9,22,9,21.2,9.5,20.7l4.7-4.7l-4.7-4.7C9,10.8,9,10,9.5,9.5c0.2-0.2,0.5-0.4,0.9-0.4s0.6,0.1,0.9,0.4l4.7,4.7l4.7-4.7c0.2-0.2,0.5-0.4,0.9-0.4s0.6,0.1,0.9,0.4c0.5,0.5,0.5,1.3,0,1.8L17.8,16L22.5,20.7z"></path></svg>
										</div>
									</div>`;
						let current_content = $(".popup_EmailInput").html();
						$(".invite_input_text_area").val("");
		        		$(".popup_EmailInput").find(".invite_input_text_area").before(str);
		        		$(".popup_invite_button").addClass("on");
		        	},
		        	error:function(r,s,e){
		        		console.log("[에러] code: " + r.status + ", message: " + r.responseText + ", error: " + e);
		        	}
		        });
		    }else{
		    	let len = 0;
				document.querySelectorAll(".input_email_div").forEach(function(item){
					str += $(item).text().trim() + "\n";
					len++;
				});
		        if (len !== 0) {
		            $(".popup_invite_button").addClass("on"); // 인풋된 이메일div 갯수가 있으면 버튼 활성화
		        } else {
		            $(".popup_invite_button").removeClass("on"); // 인풋된 이메일div 갯수가 없으면 버튼 비활성화
		        }
		    }
		});
		
		/* 보내기 버튼 클릭시 초대 발송 */
		$(".popup_invite_button").click(function(){
			if($(".popup_invite_button").hasClass("on")){
				let str = "";
				document.querySelectorAll(".input_email_div").forEach(function(item){
		    		str += $(item).text().trim() + "\n";
		    	});
				alert("해당 이메일에게 초대를 발송합니다 : \n" + str);
			}else{
				alert("초대할 이메일이 없습니다, 이메일을 입력해주세요.");
			}
		});
		$(".popup_EmailInput").keyup(function(e) {
			if(e.key === "Backspace"){
				let len = $(this).find("div[role='gridcell']").length; // 인풋된 이메일div 갯수
		        if (len !== 0) {
		            $(".popup_invite_button").addClass("on"); // 인풋된 이메일div 갯수가 있으면 버튼 활성화
		        } else {
		            $(".popup_invite_button").removeClass("on"); // 인풋된 이메일div 갯수가 없으면 버튼 비활성화
		        }
			}
		});
		/* 상단바 팝업창 초대 생성 클릭 */
		$(".popup_create_invite").click(function() {
			$(".popup_invite_whole-div").css('display', 'flex');
			$(".create_something_popup.on").removeClass("on");
		});
		/* 상단바 생성 버튼 마우스 대면 포인터 손모양으로 변경 (css에서 안먹어서 제이쿼리로 먹임..) */
		$("#creation_button").hover(function() {
			$(this).css('cursor', 'pointer');
		});
		/* 초대 팝업창 닫기 */
		$(".popup_invite_XIcon").click(function() {
			$(".popup_invite_whole-div").css('display', 'none');
		});
		/* 초대창 제이쿼리 *//* 초대창 제이쿼리 *//* 초대창 제이쿼리 *//* 초대창 제이쿼리 *//* 초대창 제이쿼리 *//* 초대창 제이쿼리 *//* 초대창 제이쿼리 */

	});
	/*********************************** 요소 클릭시 어느 페이지로 이동할지 *************************************/
	//토스터 사용 
	function ssonda_toast(msg) {
		if(msg.indexOf('상태를 업데이트 했습니다')>-1) {
			toastr.info("", msg);			// blue
		} else if(msg.indexOf('삭제하였습니다')>-1 || msg.indexOf('끊어졌습니다')>-1) {
			toastr.warning("", msg);		// yellow
		} else {
			toastr.success("", msg);		// green
		}
	}

	///알림을 조회 : 토스터를 사용 //알림을 조회 : 토스터를 사용 
	$(function(){
		<% for(AlarmUpdateDto dto : alarmUpdateList) { %>
			ssonda_toast('<%=dto.getContent()%>');
		<% } %>
	})
	//알림을 조회 : 토스터를 사용 //알림을 조회 : 토스터를 사용 
	
	let webSocket = new WebSocket("ws://localhost:9091/Asana/broadcasting") //서버와 연결 
	webSocket.onmessage = function(e){
	//	alert("서버로부터의 메시지 : " + e.data);
		// e.data = "새알림_3_message://프로젝트 협업방법의 상태를 업데이트 했습니다."
		if(e.data.startsWith("새알림_")) {
			let s = e.data.replace("새알림_","");	// 3_message://프로젝트 협업방법의 상태를 업데이트 했습니다.
			let alarm_member_idx = Number( s.substring(0, s.indexOf("_")) );
			if(alarm_member_idx == ${memberidx}) {
				let msg = s.substring(s.indexOf("_")).replace("_message://","");
				ssonda_toast(msg);	
				//$.ajax() ---> AjaxDeleteAlarmUpdateServlet ---> DELETE FROM alarm_update WHERE member_idx=?
				$.ajax({ //삭제 ajax는 잘 되는지 확인해봐야함 ***** 1/ 24
					type:'post',
					url:'ExAlarmUpdateDeleteInventory',
					data:{"memberidx" : alarm_member_idx, "projectidx" :${projectIdx}},
					success:function(data){
						
					},
					error:function(r,s,e){
						console.log("[에러] code: " + r.status + ", message: " + r.responseText + ", error: " + e);
					}
					
				});
						
			}
		}
		
	}
	
	webSocket.onopen = function(e){
		console.log("연결되었습니다.")
	}
	webSocket.onerror = function(e){
		console.log("error ! ");
	}
	
	/* 목록 ajax  */
	//wam 상세보기 
	$(function(){
 		/* $(document).on("click", ".spread_sheet_Header_Structure > div.milestone", function(e) {
			e.stopPropagation();
		}); */
		$(document).on("click", ".board_card_layout", function(){
			
			let wamidx = $(this).attr("wamidx");
			$.ajax({
				type:'post',
				data:{"wamidx" : wamidx },
				url:'ExDetailsOfWamSelect',
				success:function(data){
					let wamlist = data.obj;  
					let precedingArr =  data.precedingArr;
					let followingWamIdx = wamlist.followingWamIdx; // 종속 데이터가 존재하는지 확인 하는 idx 
					let precedingIdx = wamlist.precedingIdx; //선행 데이터가 존재하는지 확인하는 idx , null 일때 0 
					
					
					let wamidx = wamlist.wamidx;
					$(".milestone").attr("wamidx", wamidx);
					
					//wam type 
					if(wamlist.wamtype == "w"){
						$(".milestone_content_child01_02 > span").text("작업");
					}else if(wamlist.wamtype == "m"){
						$(".milestone_content_child01_02 > span").text("마일스톤");
					}else{
						$(".milestone_content_child01_02 > span").text("승인");
					}
					
					//wam 제목 
					$(".milestone_content_title > input ").val(wamlist.title);
					
					//wam 담당자
					
					if(wamlist.nickName !=null){
						$(".manager_right").attr("manageridx", wamlist.memberIdx);
						$(".manager_right_img > img").attr({src:"img01/"+wamlist.memberProfileImg});
						$(".manager_right > span").text(wamlist.nickName);
					}else {
						$(".no_contact_person").css("display" , "flex");
						$(".manager_right").css("display", "none");
					}
				
					//마감일 조회 
					const statusDate = wamlist.deadlineDate; // 예시 날짜 문자열
					const dateParts = statusDate.split(' ')[0]; // "2023-01-15"만 추출
					let projectstatusdateFormatPost = dateParts.substring(5,7) + "월 " + dateParts.substring(8) + "일";
					/* console.log("포맷후 : "  + projectstatusdateFormatPost);  // "10월 29일" 형식으로 출력됩니다.  */
					
					
					if(wamlist.deadlineDate != null){
						$(".deadline_right").css("display" , "flex");
						$(".deadline_right > span").text(projectstatusdateFormatPost);
						$(".no_deadline").css("display", "none");
					}else{
						$(".deadline_right").css("display" , "none");
						$(".no_deadline").css("display", "flex");
					}
					
					//프로젝트 
					$(".project_add_title > span").text(wamlist.projectName);
					let completeDate = wamlist.completeDate;
					if(completeDate == null){
						$(".project_add_title > .section > span").text("수행중")
					}else{
						$(".project_add_title > .section > span").text("완료")
						
					}
					//종속관계 조회 
					// 만약에 종속 idx 가 null이 아니라면 append 처리 해두기 
					// 만약에 선행 Idx 가 null이 아니라면 append 처리 해두기 
					//console.log(precedingArr); //ok - 선행 리스트 
					//console.log(followingWamIdx); //ok - 종속 리스트 
					//console.log(precedingIdx); // ok  - 쓰지 않기로 
					if(precedingArr.length > 0){
						$(".prior_work_parent").html("");
						for(let i=0; i<precedingArr.length; i++){
							
							let str = `<div class="prior_work" idx="`+precedingArr[i].precedingidx+`">
											<div class="prior_work_type">선행 작업</div>
											<div class="prior_work_title">`+precedingArr[i].precedingTitle+`</div>
											<div class="prior_delBtn">
												<svg
													class="HighlightSol HighlightSol--core CompoundIcon--small CompoundIcon XCircleCompoundIcon TokenizerPillRemoveButton-removeIcon"
													viewBox="0 0 32 32" aria-hidden="true" focusable="false">
																	<path
														d="M31,16c0,8.3-6.7,15-15,15S1,24.3,1,16S7.7,1,16,1S31,7.7,31,16z"
														class="CompoundIcon-outer"></path>
																	<path
														d="M22.5,20.7c0.5,0.5,0.5,1.3,0,1.8c-0.2,0.2-0.5,0.4-0.9,0.4s-0.6-0.1-0.9-0.4L16,17.8l-4.7,4.7c-0.2,0.2-0.5,0.4-0.9,0.4s-0.6-0.1-0.9-0.4C9,22,9,21.2,9.5,20.7l4.7-4.7l-4.7-4.7C9,10.8,9,10,9.5,9.5c0.2-0.2,0.5-0.4,0.9-0.4s0.6,0.1,0.9,0.4l4.7,4.7l4.7-4.7c0.2-0.2,0.5-0.4,0.9-0.4s0.6,0.1,0.9,0.4c0.5,0.5,0.5,1.3,0,1.8L17.8,16L22.5,20.7z"
														class="CompoundIcon-inner"></path>
																</svg>
											</div>
										</div>`;
							$(".prior_work_parent").append(str);
						}
						$(".prior_work").css("display" , "block");
					}else{
						$(".prior_work").css("display", "none");
					}
					
					if(followingWamIdx != null){
						$(".dependent_tasks_parent").html("");
						let str = `<div class="dependent_tasks" idx="`+wamlist.followingidx+`">
										<div class="dependent_tasks_type">후속 작업</div>
										<div class="dependent_tasks_title">`+wamlist.followingTitle+`</div>
										<div class="dependent_tasks_delBtn">
											<svg
												class="HighlightSol HighlightSol--core CompoundIcon--small CompoundIcon XCircleCompoundIcon TokenizerPillRemoveButton-removeIcon"
												viewBox="0 0 32 32" aria-hidden="true" focusable="false">
																<path
													d="M31,16c0,8.3-6.7,15-15,15S1,24.3,1,16S7.7,1,16,1S31,7.7,31,16z"
													class="CompoundIcon-outer"></path>
																<path
													d="M22.5,20.7c0.5,0.5,0.5,1.3,0,1.8c-0.2,0.2-0.5,0.4-0.9,0.4s-0.6-0.1-0.9-0.4L16,17.8l-4.7,4.7c-0.2,0.2-0.5,0.4-0.9,0.4s-0.6-0.1-0.9-0.4C9,22,9,21.2,9.5,20.7l4.7-4.7l-4.7-4.7C9,10.8,9,10,9.5,9.5c0.2-0.2,0.5-0.4,0.9-0.4s0.6,0.1,0.9,0.4l4.7,4.7l4.7-4.7c0.2-0.2,0.5-0.4,0.9-0.4s0.6,0.1,0.9,0.4c0.5,0.5,0.5,1.3,0,1.8L17.8,16L22.5,20.7z"
													class="CompoundIcon-inner"></path>
															</svg>
										</div>
									</div>`;
						$(".dependent_tasks_parent").append(str);
						$(".dependent_tasks").css("display" , "block");
					}else{
						$(".dependent_tasks").css("display" , "none");
					}
					
					//wam 내용 조회 
					if(wamlist.wamContent != null){
					
						$(".rowstructure_05 > textarea").html(wamlist.wamContent);
					}else{
						$(".rowstructure_05 > textarea").html("");
					}
				},
				error:function(r,s,e){
					console.log("[에러] code: " + r.status + ", message: " + r.responseText + ", error: " + e);
				}
			});
		});
		
		//종속관계 클릭시 리스트 조회 
		//wam 세부창 이벤트전파 막기 
		/* $(".milestone").click(function(e){
			event.stopPropagation();
		}); */
		
		
		//종속 작업일때 조회 리스트 보여주기 
		$(".selectTask > input").click(function(){
			let idx = $(this).parent().find(".typeOfWork_parent > div.on").attr("idx");
			let wamidx = $(this).closest(".milestone").attr("wamidx");
			if(idx == 1){ //선행작업을 선택했을때 
				$.ajax({
					type:'post',
					data:{"wamidx" : wamidx},
					url:'ExPrecedenceListSelect',
					success:function(data){
						let ArrJson = data.ArrJson;
						let ArrJsonNoSubtask = data.ArrJsonNoSubtask;
						if(ArrJson.length>0){
							$(".clickingDependencies_list").html("");
							for(let i=0; i<ArrJson.length; i++){
								let str = `<div class="clickingDependencies_list_workSelect" wamidx="`+ArrJson[i].wamidx+`">
										   	<div class="clickingDependencies_list_workSelect_svg">`
								if(ArrJson[i].completedate != null){
									str += `<svg class="disabledIcon" viewBox="0 0 32 32" aria-hidden="true" focusable="false">
										<path d="M16,0C7.2,0,0,7.2,0,16s7.2,16,16,16s16-7.2,16-16l0,0C32,7.2,24.8,0,16,0z M2,16C2,8.3,8.2,2,16,2c3.4,0,6.6,1.2,9.2,3.4  L5.4,25.2C3.2,22.6,2,19.4,2,16z M16,30c-3.4,0-6.6-1.2-9.2-3.4L26.6,6.8c5.1,5.8,4.5,14.7-1.4,19.7C22.6,28.8,19.4,30,16,30z"></path>
										</svg>`;
								}else{
									str +=`<svg
										class="taskCompletionCompoundIcon"
										viewBox="0 0 32 32" aria-hidden="true" focusable="false">
									<path
											d="M31,16c0,8.3-6.7,15-15,15S1,24.3,1,16S7.7,1,16,1S31,7.7,31,16z"
											class="CompoundIcon-outer"></path>
									<path
											d="M13.4,22.1c-0.3,0-0.5-0.1-0.7-0.3l-3.9-3.9c-0.4-0.4-0.4-1,0-1.4s1-0.4,1.4,0l3.1,3.1l8.1-8.1c0.4-0.4,1-0.4,1.4,0   s0.4,1,0,1.4l-8.9,8.9C13.9,22,13.7,22.1,13.4,22.1z"
											class="CompoundIcon-inner"></path>
									</svg>`;
								}
								str += `</div>
											<div class="clickingDependencies_list_workSelect_wamOfName">
											`+ ArrJson[i].wamtitle+`
											</div>
											<div class="clickingDependencies_list_workSelect_project">
											`+ArrJson[i].projectTitle+`
											</div>
										</div>`;
									//console.log(str);	
	/* 								if(precedencelist[i].completedate != null){
										
										//$(".clickingDependencies_list_workSelect").css("background", "#d7d7d7");
										$(".clickingDependencies_list_workSelect").css("background", "#d7d7d7");
									}
									
	 */								
									$(".clickingDependencies_list").append(str);
									if(ArrJson[i].completedate != null){
										$(".clickingDependencies_list > div:last-child").css("background", "#d7d7d7");
									}
							}
						}else{
							$(".clickingDependencies_list").html("");
							for(let i=0; i<ArrJsonNoSubtask.length; i++){
								let str = `<div class="clickingDependencies_list_workSelect" wamidx="`+ArrJsonNoSubtask[i].wamidx+`">
										   	<div class="clickingDependencies_list_workSelect_svg">`
								if(ArrJsonNoSubtask[i].completedate != null){
									str += `<svg class="disabledIcon" viewBox="0 0 32 32" aria-hidden="true" focusable="false">
										<path d="M16,0C7.2,0,0,7.2,0,16s7.2,16,16,16s16-7.2,16-16l0,0C32,7.2,24.8,0,16,0z M2,16C2,8.3,8.2,2,16,2c3.4,0,6.6,1.2,9.2,3.4  L5.4,25.2C3.2,22.6,2,19.4,2,16z M16,30c-3.4,0-6.6-1.2-9.2-3.4L26.6,6.8c5.1,5.8,4.5,14.7-1.4,19.7C22.6,28.8,19.4,30,16,30z"></path>
										</svg>`;
								}else{
									str +=`<svg
										class="taskCompletionCompoundIcon"
										viewBox="0 0 32 32" aria-hidden="true" focusable="false">
									<path
											d="M31,16c0,8.3-6.7,15-15,15S1,24.3,1,16S7.7,1,16,1S31,7.7,31,16z"
											class="CompoundIcon-outer"></path>
									<path
											d="M13.4,22.1c-0.3,0-0.5-0.1-0.7-0.3l-3.9-3.9c-0.4-0.4-0.4-1,0-1.4s1-0.4,1.4,0l3.1,3.1l8.1-8.1c0.4-0.4,1-0.4,1.4,0   s0.4,1,0,1.4l-8.9,8.9C13.9,22,13.7,22.1,13.4,22.1z"
											class="CompoundIcon-inner"></path>
									</svg>`;
								}
								str += `</div>
											<div class="clickingDependencies_list_workSelect_wamOfName">
											`+ ArrJsonNoSubtask[i].wamtitle+`
											</div>
											<div class="clickingDependencies_list_workSelect_project">
											`+ ArrJsonNoSubtask[i].projectTitle+`
											</div>
										</div>`;
									//console.log(str);	
	/* 								if(precedencelist[i].completedate != null){
										
										//$(".clickingDependencies_list_workSelect").css("background", "#d7d7d7");
										$(".clickingDependencies_list_workSelect").css("background", "#d7d7d7");
									}
									
	 */								
									$(".clickingDependencies_list").append(str);
									if(ArrJsonNoSubtask[i].completedate != null){
										$(".clickingDependencies_list > div:last-child").css("background", "#d7d7d7");
									}
							}
						}
					}, 
					error(r,s,e){
						console.log("[에러] code: " + r.status + ", message: " + r.responseText + ", error: " + e);
					}
				});
			}else if(idx == 2){ 
				// 후속 작업 클릭시 보여줄 리스트 
				$.ajax({
					type:'post',
					data:{"wamidx" : wamidx},
					url:'ExSubordinationListSelect',
					success:function(data){
						let objArr = data.objArr;  // 나의 종속, 선행 모두 null 이 아닌경우 
						let nopreobjArr = data.nopreobjArr; // 나의 선행만 null 인 경우 
						let nosubobjArr = data.nosubobjArr; // 나의 종속만 null 인 경우
						let allnoobjArr  = data.allnoobjArr; //나의 종속, 선행 모두 null
						
						if(objArr.length>0){
							$(".clickingDependencies_list").html("");
							for(let i=0; i< objArr.length; i++){
								let str = `<div class="clickingDependencies_list_workSelect" wamidx="`+ objArr[i].wamidx+`">
										   	<div class="clickingDependencies_list_workSelect_svg">`
								if( objArr[i].completedate != null){
									str += `<svg class="disabledIcon" viewBox="0 0 32 32" aria-hidden="true" focusable="false">
										<path d="M16,0C7.2,0,0,7.2,0,16s7.2,16,16,16s16-7.2,16-16l0,0C32,7.2,24.8,0,16,0z M2,16C2,8.3,8.2,2,16,2c3.4,0,6.6,1.2,9.2,3.4  L5.4,25.2C3.2,22.6,2,19.4,2,16z M16,30c-3.4,0-6.6-1.2-9.2-3.4L26.6,6.8c5.1,5.8,4.5,14.7-1.4,19.7C22.6,28.8,19.4,30,16,30z"></path>
										</svg>`;
								}else{
									str +=`<svg
										class="taskCompletionCompoundIcon"
										viewBox="0 0 32 32" aria-hidden="true" focusable="false">
									<path
											d="M31,16c0,8.3-6.7,15-15,15S1,24.3,1,16S7.7,1,16,1S31,7.7,31,16z"
											class="CompoundIcon-outer"></path>
									<path
											d="M13.4,22.1c-0.3,0-0.5-0.1-0.7-0.3l-3.9-3.9c-0.4-0.4-0.4-1,0-1.4s1-0.4,1.4,0l3.1,3.1l8.1-8.1c0.4-0.4,1-0.4,1.4,0   s0.4,1,0,1.4l-8.9,8.9C13.9,22,13.7,22.1,13.4,22.1z"
											class="CompoundIcon-inner"></path>
									</svg>`;
								}
								str += `</div>
											<div class="clickingDependencies_list_workSelect_wamOfName">
											`+  objArr[i].wamtitle+`
											</div>
											<div class="clickingDependencies_list_workSelect_project">
											`+  objArr[i].projectTitle+`
											</div>
										</div>`;
									
									$(".clickingDependencies_list").append(str);
									if( objArr[i].completedate != null){
										$(".clickingDependencies_list > div:last-child").css("background", "#d7d7d7");
									}
							}
							
						}else if(nopreobjArr.length>0){ 
							$(".clickingDependencies_list").html("");
							for(let i=0; i< nopreobjArr.length; i++){
								let str = `<div class="clickingDependencies_list_workSelect" wamidx="`+ nopreobjArr[i].wamidx+`">
										   	<div class="clickingDependencies_list_workSelect_svg">`
								if( nopreobjArr[i].completedate != null){
									str += `<svg class="disabledIcon" viewBox="0 0 32 32" aria-hidden="true" focusable="false">
										<path d="M16,0C7.2,0,0,7.2,0,16s7.2,16,16,16s16-7.2,16-16l0,0C32,7.2,24.8,0,16,0z M2,16C2,8.3,8.2,2,16,2c3.4,0,6.6,1.2,9.2,3.4  L5.4,25.2C3.2,22.6,2,19.4,2,16z M16,30c-3.4,0-6.6-1.2-9.2-3.4L26.6,6.8c5.1,5.8,4.5,14.7-1.4,19.7C22.6,28.8,19.4,30,16,30z"></path>
										</svg>`;
								}else{
									str +=`<svg
										class="taskCompletionCompoundIcon"
										viewBox="0 0 32 32" aria-hidden="true" focusable="false">
									<path
											d="M31,16c0,8.3-6.7,15-15,15S1,24.3,1,16S7.7,1,16,1S31,7.7,31,16z"
											class="CompoundIcon-outer"></path>
									<path
											d="M13.4,22.1c-0.3,0-0.5-0.1-0.7-0.3l-3.9-3.9c-0.4-0.4-0.4-1,0-1.4s1-0.4,1.4,0l3.1,3.1l8.1-8.1c0.4-0.4,1-0.4,1.4,0   s0.4,1,0,1.4l-8.9,8.9C13.9,22,13.7,22.1,13.4,22.1z"
											class="CompoundIcon-inner"></path>
									</svg>`;
								}
								str += `</div>
											<div class="clickingDependencies_list_workSelect_wamOfName">
											`+ nopreobjArr[i].wamtitle+`
											</div>
											<div class="clickingDependencies_list_workSelect_project">
											`+ nopreobjArr[i].projectTitle+`
											</div>
										</div>`;
									
									$(".clickingDependencies_list").append(str);
									if(nopreobjArr[i].completedate != null){
										$(".clickingDependencies_list > div:last-child").css("background", "#d7d7d7");
									}
							}
							
							
						}else if(nosubobjArr.length>0){
							$(".clickingDependencies_list").html("");
							for(let i=0; i< nosubobjArr.length; i++){
								let str = `<div class="clickingDependencies_list_workSelect" wamidx="`+ nosubobjArr[i].wamidx+`">
										   	<div class="clickingDependencies_list_workSelect_svg">`
								if(nosubobjArr[i].completedate != null){
									str += `<svg class="disabledIcon" viewBox="0 0 32 32" aria-hidden="true" focusable="false">
										<path d="M16,0C7.2,0,0,7.2,0,16s7.2,16,16,16s16-7.2,16-16l0,0C32,7.2,24.8,0,16,0z M2,16C2,8.3,8.2,2,16,2c3.4,0,6.6,1.2,9.2,3.4  L5.4,25.2C3.2,22.6,2,19.4,2,16z M16,30c-3.4,0-6.6-1.2-9.2-3.4L26.6,6.8c5.1,5.8,4.5,14.7-1.4,19.7C22.6,28.8,19.4,30,16,30z"></path>
										</svg>`;
								}else{
									str +=`<svg
										class="taskCompletionCompoundIcon"
										viewBox="0 0 32 32" aria-hidden="true" focusable="false">
									<path
											d="M31,16c0,8.3-6.7,15-15,15S1,24.3,1,16S7.7,1,16,1S31,7.7,31,16z"
											class="CompoundIcon-outer"></path>
									<path
											d="M13.4,22.1c-0.3,0-0.5-0.1-0.7-0.3l-3.9-3.9c-0.4-0.4-0.4-1,0-1.4s1-0.4,1.4,0l3.1,3.1l8.1-8.1c0.4-0.4,1-0.4,1.4,0   s0.4,1,0,1.4l-8.9,8.9C13.9,22,13.7,22.1,13.4,22.1z"
											class="CompoundIcon-inner"></path>
									</svg>`;
								}
								str += `</div>
											<div class="clickingDependencies_list_workSelect_wamOfName">
											`+ nosubobjArr[i].wamtitle+`
											</div>
											<div class="clickingDependencies_list_workSelect_project">
											`+ nosubobjArr[i].projectTitle+`
											</div>
										</div>`;
									
									$(".clickingDependencies_list").append(str);
									if(nosubobjArr[i].completedate != null){
										$(".clickingDependencies_list > div:last-child").css("background", "#d7d7d7");
									}
							}
							
							
						}else if(allnoobjArr.length>0){
							$(".clickingDependencies_list").html("");
							for(let i=0; i< allnoobjArr.length; i++){
								let str = `<div class="clickingDependencies_list_workSelect" wamidx="`+ allnoobjArr[i].wamidx+`">
										   	<div class="clickingDependencies_list_workSelect_svg">`
								if(allnoobjArr[i].completedate != null){
									str += `<svg class="disabledIcon" viewBox="0 0 32 32" aria-hidden="true" focusable="false">
										<path d="M16,0C7.2,0,0,7.2,0,16s7.2,16,16,16s16-7.2,16-16l0,0C32,7.2,24.8,0,16,0z M2,16C2,8.3,8.2,2,16,2c3.4,0,6.6,1.2,9.2,3.4  L5.4,25.2C3.2,22.6,2,19.4,2,16z M16,30c-3.4,0-6.6-1.2-9.2-3.4L26.6,6.8c5.1,5.8,4.5,14.7-1.4,19.7C22.6,28.8,19.4,30,16,30z"></path>
										</svg>`;
								}else{
									str +=`<svg
										class="taskCompletionCompoundIcon"
										viewBox="0 0 32 32" aria-hidden="true" focusable="false">
									<path
											d="M31,16c0,8.3-6.7,15-15,15S1,24.3,1,16S7.7,1,16,1S31,7.7,31,16z"
											class="CompoundIcon-outer"></path>
									<path
											d="M13.4,22.1c-0.3,0-0.5-0.1-0.7-0.3l-3.9-3.9c-0.4-0.4-0.4-1,0-1.4s1-0.4,1.4,0l3.1,3.1l8.1-8.1c0.4-0.4,1-0.4,1.4,0   s0.4,1,0,1.4l-8.9,8.9C13.9,22,13.7,22.1,13.4,22.1z"
											class="CompoundIcon-inner"></path>
									</svg>`;
								}
								str += `</div>
											<div class="clickingDependencies_list_workSelect_wamOfName">
											`+ allnoobjArr[i].wamtitle+`
											</div>
											<div class="clickingDependencies_list_workSelect_project">
											`+ allnoobjArr[i].projectTitle+`
											</div>
										</div>`;
									
									$(".clickingDependencies_list").append(str);
									if( allnoobjArr[i].completedate != null){
										$(".clickingDependencies_list > div:last-child").css("background", "#d7d7d7");
									}
							}
						}
					},
					error(r,s,e){
						console.log("[에러] code: " + r.status + ", message: " + r.responseText + ", error: " + e);
					}
				})
			}
		})
		
		//종속 insert 기능 
 	   $(document).on("click", ".clickingDependencies_list_workSelect", function(){
 		   	let idx = $(this).parent().parent().find(".selectTask").find(".typeOfWork_parent > div.on").attr("idx");
 		   //	console.log("선행 후속 : " + idx); 1 선행 2후속 
 		   	
			let wamidx = $(this).attr("wamidx"); // 선행작업 
			let followingIdx = $(this).closest(".milestone").attr("wamidx"); //내가 선택해 조회되는 idx 
			
			// 지금 띄워져있는 idx 가 following_idx , 내가 클릭한 선행 작업이 wam_idx 
			//UPDATE wam SET following_idx = 3 WHERE wam_idx =2;
			if(idx==1){
				$.ajax({ //선행작업 insert 기능 
					type:'post',
					data:{"wamidx" : wamidx, "followingIdx" : followingIdx},
					url:'ExAddPrerequisiteWork',
					success:function(data){
						let arrJson = data;
						$(".clickingDependencies").css("display" , "none");
						$(".prior_work_parent").html("");
						
						for(let i=0; i<arrJson.length; i++){
							
							
							let str = `<div class="prior_work" idx="`+arrJson[i].precedingidx+`">
											<div class="prior_work_type">선행 작업</div>
											<div class="prior_work_title">`+arrJson[i].wamtitle +`</div>
											<div class="prior_delBtn">
												<svg
													class="HighlightSol HighlightSol--core CompoundIcon--small CompoundIcon XCircleCompoundIcon TokenizerPillRemoveButton-removeIcon"
													viewBox="0 0 32 32" aria-hidden="true" focusable="false">
																	<path
														d="M31,16c0,8.3-6.7,15-15,15S1,24.3,1,16S7.7,1,16,1S31,7.7,31,16z"
														class="CompoundIcon-outer"></path>
																	<path
														d="M22.5,20.7c0.5,0.5,0.5,1.3,0,1.8c-0.2,0.2-0.5,0.4-0.9,0.4s-0.6-0.1-0.9-0.4L16,17.8l-4.7,4.7c-0.2,0.2-0.5,0.4-0.9,0.4s-0.6-0.1-0.9-0.4C9,22,9,21.2,9.5,20.7l4.7-4.7l-4.7-4.7C9,10.8,9,10,9.5,9.5c0.2-0.2,0.5-0.4,0.9-0.4s0.6,0.1,0.9,0.4l4.7,4.7l4.7-4.7c0.2-0.2,0.5-0.4,0.9-0.4s0.6,0.1,0.9,0.4c0.5,0.5,0.5,1.3,0,1.8L17.8,16L22.5,20.7z"
														class="CompoundIcon-inner"></path>
																</svg>
											</div>
										</div>`;
							$(".prior_work_parent").append(str);
						}
						
						
						//선행 리스트가 없다가 생겼을때 모래시계로 svg 변경하는거 해야함 1/29 !!
						/* if(arrJson.length > 0 ){
							let str =`<svg class="preceding_check_svg" viewBox="0 0 32 32" aria-hidden="true" focusable="false">
									  <path d="M29 28h-3v-4.677c0-1.895-.887-3.687-2.369-4.793a20.347 20.347 0 0 0-4.517-2.529 20.358 20.358 0 0 0 4.516-2.529C25.113 12.366 26 10.574 26 8.678V4.001h3a1 1 0 1 0 0-2H3a1 1 0 1 0 0 2h3v4.677c0 1.895.885 3.687 2.367 4.793A20.347 20.347 0 0 0 12.884 16a20.358 20.358 0 0 0-4.516 2.53C6.885 19.634 6 21.426 6 23.322V28H3a1 1 0 1 0 0 2h26a1 1 0 1 0 0-2ZM9.562 11.868C8.584 11.137 8 9.944 8 8.677V4h16v4.677c0 1.267-.585 2.46-1.564 3.191-1.928 1.438-4.035 2.454-6.436 3.099-2.4-.645-4.509-1.661-6.436-3.099ZM24 28H8v-4.677c0-1.267.585-2.46 1.564-3.191 1.928-1.438 4.035-2.454 6.436-3.099 2.401.645 4.51 1.66 6.436 3.098.98.731 1.564 1.924 1.564 3.191V28Z"></path>
									  </svg>`
							//structure 의 wamidx 가 followingidx 와 같은 것의 svg를 바꾸면 된다. ..... 
							//parent안에서 같은 idx 를 만났을경우 svg 변경 ...?
							 /* const parentDiv = document.querySelector('.performing_div_parent');  // 부모 div 선택
 							 const childDivs = parentDiv.querySelectorAll('.spread_sheet_Header_Structure');  // 클래스명이 'childDiv'인 자식 div 선택
  							 console.log(childDivs.length);  // 자식 div의 갯수 출력
  							 for(let i=0; i<= childDivs.length; i++){
  								let wamidx =  $(".performing_div_parent > .spread_sheet_Header_Structure").attr("wamidx");
  								
  							 }
  							
									  
							if($(".performing_div_parent >.spread_sheet_Header_Structure").attr("wamidx") == followingIdx ){
								$(this).closest(".work_name > .check_svg").remove();
								$(this).closest(".work_name").prepend(str);
								
							}
						} */ 
						
						
						
						$(".dependency_list_parent").css("display", "block");
						$(".prior_work").css("display", "block");
						
					},
					error:function(r,s,e){
						console.log("[에러] code: " + r.status + ", message: " + r.responseText + ", error: " + e);
					}
				});
				
			
			}else if(idx==2){
				// 종속작업 insert 문 
				//let wamidx; 내가 클릭한 idx -> following_idx 
				//let followingIdx; 지금 마일스톤 -> wam_idx 
				
				$.ajax({
					type:'post',
					data:{"wamidx" : wamidx, "followingIdx" : followingIdx},
					url:'ExAddsubtask',
					success:function(data){
						let title = data.title;
						let completedate = data.completedate;
						let followingidx = data.followingidx;
						
						$(".clickingDependencies").css("display" , "none");
						$(".dependent_tasks_parent").html("");
						let str = `<div class="dependent_tasks" idx="`+followingidx+`">
										<div class="dependent_tasks_type">후속 작업</div>
										<div class="dependent_tasks_title">`+title+`</div>
										<div class="dependent_tasks_delBtn">
											<svg
												class="HighlightSol HighlightSol--core CompoundIcon--small CompoundIcon XCircleCompoundIcon TokenizerPillRemoveButton-removeIcon"
												viewBox="0 0 32 32" aria-hidden="true" focusable="false">
																<path
													d="M31,16c0,8.3-6.7,15-15,15S1,24.3,1,16S7.7,1,16,1S31,7.7,31,16z"
													class="CompoundIcon-outer"></path>
																<path
													d="M22.5,20.7c0.5,0.5,0.5,1.3,0,1.8c-0.2,0.2-0.5,0.4-0.9,0.4s-0.6-0.1-0.9-0.4L16,17.8l-4.7,4.7c-0.2,0.2-0.5,0.4-0.9,0.4s-0.6-0.1-0.9-0.4C9,22,9,21.2,9.5,20.7l4.7-4.7l-4.7-4.7C9,10.8,9,10,9.5,9.5c0.2-0.2,0.5-0.4,0.9-0.4s0.6,0.1,0.9,0.4l4.7,4.7l4.7-4.7c0.2-0.2,0.5-0.4,0.9-0.4s0.6,0.1,0.9,0.4c0.5,0.5,0.5,1.3,0,1.8L17.8,16L22.5,20.7z"
													class="CompoundIcon-inner"></path>
															</svg>
										</div>
									</div>`;
						
						$(".dependent_tasks_parent").append(str);
						$(".dependency_list_parent").css("display", "block");
						$(".dependent_tasks").css("display" , "block");
						
						
						
					},
					error:function(r,s,e){
						console.log("[에러] code: " + r.status + ", message : " + r.responseText + ",error : "+  e);
					}
					
				});
				
				
			}
		});
		
		//일단 여기 
		//wam content update 기능 
		$(".rowstructure_05 > textarea ").keyup(function(){
			let content = $(this).val();
			let wamidx = $(this).closest(".milestone").attr("wamidx");
			if(content.length>0){
				$.ajax({
					type:'post',
					data:{"wamidx" : wamidx, "content" : content},
					url:'ExWamContentInsert',
					success:function(data){
						let content = data.content;
						$(".rowstructure_05 > textarea").val(content);
					},
					error:function(r,s,e){
						console.log("[에러] code:" + r.status + ", message: " + r.responseText + ",error:" + e);
					}
				})
			}
			
		});
		
		//담당자 제거 안함 
		/* $(document).on("click", ".manager_right > .wam_contact_person_svg", function(){
			let wamidx = $(this).closest(".milestone").attr("wamidx");
			let manageridx = $(this).closest(".manager_right").attr("manageridx");
			alert("wamidx:" + wamidx);
			alert("manageridx:" + manageridx);
			$.ajax({
				type:'post',
				data:
			}); 
		}); */
		
		//일단 여기
		//종속관계 선행작업 삭제하기 
		$(document).on("click", ".prior_delBtn", function(){
			let clickidx = $(this).closest(".prior_work").attr("idx"); //삭제하고싶은 idx 
			let wamidx = $(this).closest(".milestone").attr("wamidx"); //milestone 의 idx 
			$.ajax({
				type:'post',
				data:{"wamidx" : wamidx, "clickidx" : clickidx},
				url:'ExPrecedingDelete',
				success:function(data){
					
					let precedinglist = data;
					$(".clickingDependencies").css("display" , "none");
					$(".prior_work_parent").html("");
					
					if(precedinglist.length==0){ /* 선행이 모두 사라졌을시 : svg 변경 1/29 수정 !! 그때 당시 wamidx 만 바꿔야함 */
						let str = `<svg class="check_svg" viewBox="0 0 32 32" aria-hidden="true" focusable="false">
									 <path d="M31,16c0,8.3-6.7,15-15,15S1,24.3,1,16S7.7,1,16,1S31,7.7,31,16z" class="CompoundIcon-outer"></path>
									 <path d="M13.4,22.1c-0.3,0-0.5-0.1-0.7-0.3l-3.9-3.9c-0.4-0.4-0.4-1,0-1.4s1-0.4,1.4,0l3.1,3.1l8.1-8.1c0.4-0.4,1-0.4,1.4,0   s0.4,1,0,1.4l-8.9,8.9C13.9,22,13.7,22.1,13.4,22.1z" class="CompoundIcon-inner"></path>
									 </svg>`;
						$(".preceding_check_svg").remove();
						$(".work_name").prepend(str);
					}else{ /* 선행 여러개 중 한개만 삭제될때 */
						for(let i=0; i<precedinglist.length; i++){
							let str = `<div class="prior_work" idx="`+precedinglist[i].wamidx+`">
											<div class="prior_work_type">선행 작업</div>
											<div class="prior_work_title">`+precedinglist[i].wamtitle +`</div>
											<div class="prior_delBtn">
												<svg
													class="HighlightSol HighlightSol--core CompoundIcon--small CompoundIcon XCircleCompoundIcon TokenizerPillRemoveButton-removeIcon"
													viewBox="0 0 32 32" aria-hidden="true" focusable="false">
																	<path
														d="M31,16c0,8.3-6.7,15-15,15S1,24.3,1,16S7.7,1,16,1S31,7.7,31,16z"
														class="CompoundIcon-outer"></path>
																	<path
														d="M22.5,20.7c0.5,0.5,0.5,1.3,0,1.8c-0.2,0.2-0.5,0.4-0.9,0.4s-0.6-0.1-0.9-0.4L16,17.8l-4.7,4.7c-0.2,0.2-0.5,0.4-0.9,0.4s-0.6-0.1-0.9-0.4C9,22,9,21.2,9.5,20.7l4.7-4.7l-4.7-4.7C9,10.8,9,10,9.5,9.5c0.2-0.2,0.5-0.4,0.9-0.4s0.6,0.1,0.9,0.4l4.7,4.7l4.7-4.7c0.2-0.2,0.5-0.4,0.9-0.4s0.6,0.1,0.9,0.4c0.5,0.5,0.5,1.3,0,1.8L17.8,16L22.5,20.7z"
														class="CompoundIcon-inner"></path>
																</svg>
											</div>
										</div>`;
							$(".prior_work_parent").append(str);
						}
						$(".dependency_list_parent").css("display", "block");
						$(".prior_work").css("display", "block");
					}
					
					
					
					
				},
				error:function(r,s,e){
					console.log("[에러] code: " + r.status + ",message: " + r.responseText + ",error :" + e);
				}
				
			}); 
			
		});
		
		//종속관계 후속작업 삭제하기 
		$(document).on("click", ".dependent_tasks_delBtn", function(){
			let clickidx = $(this).closest(".dependent_tasks").attr("idx"); // 클릭한 idx 
			let wamidx = $(this).closest(".milestone").attr("wamidx"); // 지금 마일스톤 idx 
			$.ajax({
				type:'post',
				data:{"clickidx" : clickidx, "wamidx" : wamidx},
				url:'ExSubtaskDelete',
				success:function(data){
					 
					$(".dependent_tasks_parent").html("");
					$(".dependency_list_parent").css("display", "block"); 
					
				},
				error:function(r,s,e){
					console.log("[에러] code:" + r.status + ",message :" + r.responseText + ",error : " + e);
				}
				
			});
		});
		
		//작업 완료 체크기능 
		$(document).on("click", ".board_card_layout_header_miliestoneIcon", function(){
			alert("!!!");
			let wamidx = $(this).closest(".board_card_layout").attr("wamidx");
			let projectidx =${projectIdx};
			$.ajax({
				type:'post',
				data:{"wamidx" : wamidx , "projectidx" : projectidx},
				url:'ExCheckWam',
				success:function(data){
					let completeobj = data.completeobj;
					let runningobj = data.runningobj;
					let allobj = data.allobj;
					//완료 섹션 업데이트 
					$(".complete_div_parent").html("");
					for(let i=0; i<completeobj.length; i++){
						let str=`<div class="board_card_layout" wamidx="`+completeobj[i].wamidx01+`">
						<div class="board_card_layout_header">
						<div class="board_card_layout_header_miliestoneIcon">
							<svg class="work_type" viewBox="0 0 32 32" aria-hidden="true" focusable="false">
								<path d="M31,16c0,8.3-6.7,15-15,15S1,24.3,1,16S7.7,1,16,1S31,7.7,31,16z" class="CompoundIcon-outer" style="fill:#5da283; stroke:#5da283;"></path>
								<path d="M13.4,22.1c-0.3,0-0.5-0.1-0.7-0.3l-3.9-3.9c-0.4-0.4-0.4-1,0-1.4s1-0.4,1.4,0l3.1,3.1l8.1-8.1c0.4-0.4,1-0.4,1.4,0   s0.4,1,0,1.4l-8.9,8.9C13.9,22,13.7,22.1,13.4,22.1z" class="CompoundIcon-inner" style="fill:#f5f4f3;"></path>
							</svg>
						</div>
						<div class="board_card_layout_header_title">`+completeobj[i].title+`</div>
					</div>
					<div class="boardcardLayout_assigneeduedateactions">
						<div
							class="boardcardLayout_assigneeduedateactions_profile_img">
							
							<img src="img01/`+completeobj[i].profileimg+`" />
						</div>
						<div class="boardcardLayout_assigneeduedateactions_deadline">
							`+completeobj[i].deadlineformatDate+`
						</div>
					</div>
			  </div>`;
							
							$(".complete_div_parent").append(str);
					}
					
					//수행중 섹션 업데이트 
					$(".performing_div_parent").html("");
					for(let i=0; i<runningobj.length; i++){
						let str=`<div class="board_card_layout" wamidx="`+runningobj[i].wamidx01+`">
							<div class="board_card_layout_header">
							<div class="board_card_layout_header_miliestoneIcon">`
							if(runningobj[i].completedatecheck>0){
								str+= `<svg class="preceding_check_svg" viewBox="0 0 32 32" aria-hidden="true" focusable="false">
									<path d="M29 28h-3v-4.677c0-1.895-.887-3.687-2.369-4.793a20.347 20.347 0 0 0-4.517-2.529 20.358 20.358 0 0 0 4.516-2.529C25.113 12.366 26 10.574 26 8.678V4.001h3a1 1 0 1 0 0-2H3a1 1 0 1 0 0 2h3v4.677c0 1.895.885 3.687 2.367 4.793A20.347 20.347 0 0 0 12.884 16a20.358 20.358 0 0 0-4.516 2.53C6.885 19.634 6 21.426 6 23.322V28H3a1 1 0 1 0 0 2h26a1 1 0 1 0 0-2ZM9.562 11.868C8.584 11.137 8 9.944 8 8.677V4h16v4.677c0 1.267-.585 2.46-1.564 3.191-1.928 1.438-4.035 2.454-6.436 3.099-2.4-.645-4.509-1.661-6.436-3.099ZM24 28H8v-4.677c0-1.267.585-2.46 1.564-3.191 1.928-1.438 4.035-2.454 6.436-3.099 2.401.645 4.51 1.66 6.436 3.098.98.731 1.564 1.924 1.564 3.191V28Z"></path>
									</svg>`
							}else{
								str+=`<svg class="work_type" viewBox="0 0 32 32" aria-hidden="true" focusable="false">
									<path d="M31,16c0,8.3-6.7,15-15,15S1,24.3,1,16S7.7,1,16,1S31,7.7,31,16z" class="CompoundIcon-outer"></path>
									<path d="M13.4,22.1c-0.3,0-0.5-0.1-0.7-0.3l-3.9-3.9c-0.4-0.4-0.4-1,0-1.4s1-0.4,1.4,0l3.1,3.1l8.1-8.1c0.4-0.4,1-0.4,1.4,0   s0.4,1,0,1.4l-8.9,8.9C13.9,22,13.7,22.1,13.4,22.1z" class="CompoundIcon-inner" ></path>
								</svg>`
							}
							str+=`</div>
							<div class="board_card_layout_header_title">`+runningobj[i].title+`</div>
						</div>
						<div class="boardcardLayout_assigneeduedateactions">
							<div
								class="boardcardLayout_assigneeduedateactions_profile_img">
								
								<img src="img01/`+runningobj[i].profileimg+`" />
							</div>
							<div class="boardcardLayout_assigneeduedateactions_deadline">
								`+runningobj[i].deadlineformatDate+`
							</div>
						</div>
				  </div>`
							$(".performing_div_parent").append(str);
					}
					
					//모두 섹션 업데이트 
					$(".every_div_parent").html("");
					for(let i=0; i<allobj.length; i++){
						let str=`<div class="board_card_layout" wamidx="`+allobj[i].wamidx01+`">
						<div class="board_card_layout_header">
						<div class="board_card_layout_header_miliestoneIcon">`
						if(allobj[i].completeDate==null){
							if(allobj[i].completedatecheck>0){
								str+= `<svg class="preceding_check_svg" viewBox="0 0 32 32" aria-hidden="true" focusable="false">
								<path d="M29 28h-3v-4.677c0-1.895-.887-3.687-2.369-4.793a20.347 20.347 0 0 0-4.517-2.529 20.358 20.358 0 0 0 4.516-2.529C25.113 12.366 26 10.574 26 8.678V4.001h3a1 1 0 1 0 0-2H3a1 1 0 1 0 0 2h3v4.677c0 1.895.885 3.687 2.367 4.793A20.347 20.347 0 0 0 12.884 16a20.358 20.358 0 0 0-4.516 2.53C6.885 19.634 6 21.426 6 23.322V28H3a1 1 0 1 0 0 2h26a1 1 0 1 0 0-2ZM9.562 11.868C8.584 11.137 8 9.944 8 8.677V4h16v4.677c0 1.267-.585 2.46-1.564 3.191-1.928 1.438-4.035 2.454-6.436 3.099-2.4-.645-4.509-1.661-6.436-3.099ZM24 28H8v-4.677c0-1.267.585-2.46 1.564-3.191 1.928-1.438 4.035-2.454 6.436-3.099 2.401.645 4.51 1.66 6.436 3.098.98.731 1.564 1.924 1.564 3.191V28Z"></path>
								</svg>`
							}else{
								str+= `<svg class="work_type" viewBox="0 0 32 32" aria-hidden="true" focusable="false">
									<path d="M31,16c0,8.3-6.7,15-15,15S1,24.3,1,16S7.7,1,16,1S31,7.7,31,16z" class="CompoundIcon-outer" ></path>
									<path d="M13.4,22.1c-0.3,0-0.5-0.1-0.7-0.3l-3.9-3.9c-0.4-0.4-0.4-1,0-1.4s1-0.4,1.4,0l3.1,3.1l8.1-8.1c0.4-0.4,1-0.4,1.4,0   s0.4,1,0,1.4l-8.9,8.9C13.9,22,13.7,22.1,13.4,22.1z" class="CompoundIcon-inner"></path>
								  </svg>`
								
							}
						}else{
							str+= `<svg class="work_type" viewBox="0 0 32 32" aria-hidden="true" focusable="false">
								<path d="M31,16c0,8.3-6.7,15-15,15S1,24.3,1,16S7.7,1,16,1S31,7.7,31,16z" class="CompoundIcon-outer" style="fill:#5da283; stroke:#5da283;"></path>
								<path d="M13.4,22.1c-0.3,0-0.5-0.1-0.7-0.3l-3.9-3.9c-0.4-0.4-0.4-1,0-1.4s1-0.4,1.4,0l3.1,3.1l8.1-8.1c0.4-0.4,1-0.4,1.4,0   s0.4,1,0,1.4l-8.9,8.9C13.9,22,13.7,22.1,13.4,22.1z" class="CompoundIcon-inner" style="fill:#f5f4f3;"></path>
							</svg>`
						}
						
							
						str+=`</div>
						<div class="board_card_layout_header_title">`+allobj[i].title+`</div>
					</div>
					<div class="boardcardLayout_assigneeduedateactions">
						<div
							class="boardcardLayout_assigneeduedateactions_profile_img">
							<img src="img01/`+allobj[i].profileimg+`" />
						</div>
						<div class="boardcardLayout_assigneeduedateactions_deadline">
							`+allobj[i].deadlineformatDate+`
						</div>
					</div>
			  </div>`
							
							$(".every_div_parent").append(str);
					}
					
					
				},
				error:function(r,s,e){
					alert("에러[code]:" + r.status + ",message : " + r.responseText + ",error : " + e);
				}
			});
		});
		
		//새로운 작업 insert
		$(".blank_complete_btn").click(function(){
			let title = $(".blank_milestone_content_title > input").val();
			let deadline = $(".blank_deadline_right").attr("date");
			let content = $(".blank_rowstructure_05 > textarea").val();
			/* 선행관계는 생성후에 변경할 수 있음 */
			if(title=="작업 이름 입력" || deadline == ""){
				alert("담담자, 마감일을 지정해주세요. ")
			}else if (title=="작업 이름 입력" && deadline == ""){
				alert("담담자, 마감일을 지정해주세요. ")
			}else{
				$.ajax({
					type:'post',
					data:{"title" : title, "manageridx" : ${memberidx}, "deadline" : deadline, "content" : content, "projectidx" : ${projectIdx}},
					url:'ExWamInsert',
					success:function(data){
						let wamidx = data.wamidx;
						let title = data.title;
						let nickname = data.nickname;
						let deadlineDate = data.deadlineDate;
						let correctionDate = data.correctionDate;
						let createDate = data.createDate;
						let profileimg = data.profileimg;
						
						let str =`<div class="board_card_layout" wamidx="`+wamidx+`">
							<div class="board_card_layout_header">
							<div class="board_card_layout_header_miliestoneIcon">
								<svg class="work_type" viewBox="0 0 32 32" aria-hidden="true" focusable="false">
									<path d="M31,16c0,8.3-6.7,15-15,15S1,24.3,1,16S7.7,1,16,1S31,7.7,31,16z" class="CompoundIcon-outer" ></path>
									<path d="M13.4,22.1c-0.3,0-0.5-0.1-0.7-0.3l-3.9-3.9c-0.4-0.4-0.4-1,0-1.4s1-0.4,1.4,0l3.1,3.1l8.1-8.1c0.4-0.4,1-0.4,1.4,0   s0.4,1,0,1.4l-8.9,8.9C13.9,22,13.7,22.1,13.4,22.1z" class="CompoundIcon-inner" ></path>
								</svg>
							</div>
							<div class="board_card_layout_header_title">`+title+`</div>
						</div>
						<div class="boardcardLayout_assigneeduedateactions">
							<div
								class="boardcardLayout_assigneeduedateactions_profile_img">
								
								<img src="img01/`+profileimg+`" />
							</div>
							<div class="boardcardLayout_assigneeduedateactions_deadline">
								`+deadlineDate+`
							</div>
						</div>
				  </div>`;
						$(".blank_milestone").css("display", "none");
						$(".transparent_screen").css("display", "none");
						$(".performing_div_parent").append(str);
						
						
						
					},
					error:function(r,s,e){
						console.log("[에러] : " + r.status + ",message : " + r.responseText + ",error :" + e);
					}
				}); 
			}
		
		});
		
		
		
	});
	
	
	
	//작업추가 
	$(function(){
		$("#input_deadline").datepicker({
			onSelect: function(txt, instance) {
				/* alert(txt);  // "01/24/2025" */
				beforetxt = txt.substring(6,10) +"/"+txt.substring(0,5);  // 2025/01/24 
				$(".blank_no_deadline").css('display', 'none');
				// txt : "01/24/2025"
				// "01월 24일"
				/* 1월 29일 날짜 형식이 문제다 .. 이걸 심어놓을까 ............ */
				txt = txt.substring(0,2) + "월 " + txt.substring(3,5) + "일";
				$(".blank_deadline_right > span").text(txt);
				$(".blank_deadline_right").css('display', 'flex');
				$(".blank_deadline_right").attr("date", beforetxt);
			}
		});
		$(".blank_no_deadline").click(function(){
			$("#input_deadline").datepicker("show");
		}); 
		
	});
	
	
	
	/* 목록 ajax  */

	function func1() {

		$(".black_screen").css('display', 'block');
		$(".add_member_content").css('display', 'block');
	}
	function func2() {
		$(".tatus_update_parent02").css('display', 'block');
		$(".black_screen").css('display', 'block');
	}

	$(function() {
		/* 			$("#share_button").click(function(){
		 window.location.href = "http://localhost:9090/WebProject1/asana/add_member_page.html";
		 }); */
		$("#share_button").click(function() {
			func1();
		});
		$(".list-image").click(function() {
			func1();
		});
		$(".status_update_content").click(function() {
			func2();
		});

		$(".black_screen").click(function() {
			$(".black_screen").css('display', 'none');
			$(".add_member_content").css('display', 'none');
			$(".tatus_update_parent02").css('display', 'none');

		});
		$(".add_member_child01_icon > svg:last-child").click(function() {
			$(".black_screen").css('display', 'none');
			$(".add_member_content").css('display', 'none');
		});
		//div를 누르면 보여주기 
		$("#member_profile_view").click(function() {
			func1();
		});

		/* 별 온오프 제이쿼리 *//* 별 온오프 제이쿼리 *//* 별 온오프 제이쿼리 *//* 별 온오프 제이쿼리 *//* 별 온오프 제이쿼리 */
		$(".star-center").mouseenter(function() {
			$(".icon20-star").css('fill', '#fcbd01')
		});
		$(".star-center").mouseleave(function() {
			$(".icon20-star").css('fill', 'gray')
		});
		$(".star-center").click(function() {
			// .on 은 토글.  --> .hasClass() , .addClass() , .removeClass(), toggleClass()
			$(this).toggleClass("on");
			/* if($(this).hasClass("on")) {
			$(this).removeClass("on");
			} else {
			$(this).addClass("on");
			} */
		});
		/* 별 온오프 제이쿼리 *//* 별 온오프 제이쿼리 *//* 별 온오프 제이쿼리 *//* 별 온오프 제이쿼리 *//* 별 온오프 제이쿼리 */
		$(".spread_sheet_Header_Structure").click(function(){
			$(this).find(".milestone").toggleClass("on");
			/*마일스톤 세부창 나오기*/
			
		})
		
		
		
		
		
		
		
	});

	$(function() {
		$(".click_status_update").click(function() {
			//$(".status_update_box").toggleClass("on");
			$(this).find(".status_update_box").toggleClass("on");
		});
		$(".progress_blue").click(function() { // 보류 중 눌렀을 때
			$(".progress_change_green").removeClass("on");
			$(".progress_change_yellow").removeClass("on");
			$(".progress_change_red").removeClass("on");
			$(".progress_change_complete").removeClass("on");
			$(".progress_change_blue").removeClass("on");
			$(".progress_change_blue").addClass("on");
			$("#status_update_span").css("display", "none");
		});
		$(".progress_yellow").click(function() { // 위험함 눌렀을 때
			$(".progress_change_green").removeClass("on");
			$(".progress_change_yellow").removeClass("on");
			$(".progress_change_red").removeClass("on");
			$(".progress_change_complete").removeClass("on");
			$(".progress_change_blue").removeClass("on");
			$(".progress_change_yellow").addClass("on");
			$("#status_update_span").css("display", "none");
		});
		$(".progress_green").click(function() { // 계획대로 진행 중 눌렀을 때
			$(".progress_change_green").removeClass("on");
			$(".progress_change_yellow").removeClass("on");
			$(".progress_change_red").removeClass("on");
			$(".progress_change_complete").removeClass("on");
			$(".progress_change_blue").removeClass("on");
			$(".progress_change_green").addClass("on");
			$("#status_update_span").css("display", "none");
		});
		$(".progress_red").click(function() { // 계획에서 벗어남 눌렀을 때click_status_update
			$(".progress_change_green").removeClass("on");
			$(".progress_change_yellow").removeClass("on");
			$(".progress_change_red").removeClass("on");
			$(".progress_change_complete").removeClass("on");
			$(".progress_change_blue").removeClass("on");
			$(".progress_change_red").addClass("on");
			$("#status_update_span").css("display", "none");
		});
		$(".progress_complete").click(function() { // 완료 눌렀을 때
			$(".progress_change_green").removeClass("on");
			$(".progress_change_yellow").removeClass("on");
			$(".progress_change_red").removeClass("on");
			$(".progress_change_complete").removeClass("on");
			$(".progress_change_blue").removeClass("on");
			$(".progress_change_complete").addClass("on");
			$("#status_update_span").css("display", "none");
		});

	});
	
	//wam의 세부창 동적 //wam의 세부창 동적 //wam의 세부창 동적 //wam의 세부창 동적 //wam의 세부창 동적 //wam의 세부창 동적 
	
	//wam 세부창 : wam의 세부창 , 배경창 보여주기 
	function clickWamOfDetails(){
		$(".transparent_screen").css('display','block');
		$(".milestone").css('display','block');
	}
	//wam세부창 : 담당자 제거클릭시  담당자 삭제 
	function removeAssignee(){
		$(".manager_right").css('display','none');
		$(".no_contact_person").css('display','flex');
	}
	//wam 세부창 : 담당자 없음 상태시 멤버 리스트 보여주기 
	function managerOfAssign(){
		$(".noContactPerson_clickPopUp").css('display','block');
		$(".no_contact_person").css('display','none');
		$(".transparent_screen").css('display','block');
		$(".milestone_transparent_screen").css('display','block');
	}
	//wam세부창 :work 의 세부창 띄워주기 
	function clickWorkOfDetail(){
		$(".transparent_screen").css('display','block');
		$(".work").css('display','block');
	}
	
	//wam 세부창 : 마감일 없애기 
	function removeDeadline(){
		$(".deadline_right").css('display','none');
		$(".no_deadline").css('display','flex');
	}
	
	//wam 세부창 : 1.마일스톤을 프로젝트에서 제거 
	function removeProject(){
		$(".project_add_title").css('display','none');
	}
	
	//wam 세부창 : 2.마일스톤을 프로젝트 추가 
	function clickAddProject(){
		$(".AddProject_click_Projectlist").css('display','block');
		$(".transparent_screen").css('display','block');
		$(".milestone_transparent_screen").css('display','block');
	}
	
	//wam 세부창 : 1.종속관계 추가 기능 
	function clickAddDependencies(){
		$(".dependency_list_parent").css("display", "none");
		$(".clickingDependencies").css('display','block');
		$(".transparent_screen").css('display','block');
		$(".milestone_transparent_screen").css('display','block');
		
	}
	
	//wam 세부창 : 2.선행 , 종속 종류 선택 
	function clickPriorWork(){
		$(".typeOfWork_select").css('display','block');
		$(".clickingDependencies_list").css('display','none');
	}
	
	//wam 세부창 : 3. 종속관계 프로젝트 리스트 
	function clickselectTask_input(){
		$(".typeOfWork_select").css('display','none');
		$(".clickingDependencies_list").css('display','block');
	}
	
	//wam 세부창 : 담당자 svg 클릭시 리스트 보여주기 
	function clickAssignmentOfSubTask(){
		//$(".assignmentOfmanager").css('display','block');
		if( $(this).parent().parent().find(".assignmentOfmanager").css('display')=='none' ) {
			$(this).parent().parent().find(".assignmentOfmanager").css('display','block');
			$(this).parent().parent().find(".assignmentOfmanager_list").css('display','block');
		} else {	// 'block'
			$(this).parent().parent().find(".assignmentOfmanager").css('display','none');
			$(this).parent().parent().find(".assignmentOfmanager_list").css('display','none');
		}
	}
	
	//wam 세부창 : 하위작업 담당자 선택 , 리스트 닫기 
	function closeAssignmentOfSubTask(){
		$(".assignmentOfmanager").css('display','none');
		$(".assignmentOfmanager_list").css('display','none');
	}
	//wam 세부창 : 하위작업 담당자 선택 , 리스트 열기 
	function show_Manager_Deadline(){
		$(".Add_subtask_save_deadline").css('display','block');
		$(".Add_subtask_save_manager").css('display','block');
	}
	
	
	$(function(){
		//해당 wam클릭시 세부 wam 보여주기 
		$(".board_card_layout").click(function(){
		
			clickWamOfDetails();
		});
		
		//wam 세부창 : 담당자 없음 클릭시 메서드 실행 
		$(".no_contact_person").click(function(){
			managerOfAssign();
		});
		
		//wam 세부창 : 담당자제거 메서드 실행 
		$(".wam_contact_person_svg").click(function(){
			removeAssignee();
		});
	
		//wam의 세부창 보여주는 메서드 실행 
		$(".spread_sheet_Header_Structure_work").click(function(){
			clickWorkOfDetail();
		});
		
		//전체 배경을 클릭시 세부 wam 창 닫기 
		$(".transparent_screen").click(function(){
			$(".transparent_screen").css('display','none');
			$(".milestone").css('display','none');
			$(".noContactPerson_clickPopUp").css('display','none');
			$(".clickingDependencies").css('display','none');
			$(".work").css('display','none');
			$(".dependency_list_parent").css("display", "block"); 
			$(".blank_milestone").css("display", "none");
			//종속관계 있을시 조회 
			//일단 안된다... 1/20
		
		});
		
		
		//wam 세부창 : wam의 여백 누를시 display none 처리 
		$(".milestone_transparent_screen").click(function(){
			$(".noContactPerson_clickPopUp").css('display','none');
			$(".AddProject_click_Projectlist").css('display','none');
			$(".milestone_transparent_screen").css('display','none');
			$(".clickingDependencies").css('display','none');
		});
		
		//wam 세부창 : 마감일 없애는 메서드 실행하기 
		$(".deadline_remove_svg").click(function(){
			removeDeadline();
		});
		
		//wam: 세부창 : 1.wam을 프로젝트에서 제거 
		$(".delete_project_svg").click(function(){
			removeProject();
		});
		
		//wam 세부창 : 2.wam을 프로젝트에 추가하기 
		$(".project_add_title_under_projectAddBtn").click(function(){
			clickAddProject();
		});
		
		//wam 세부창 : 1.종속 관계 추가 버튼 클릭시 메서드 실행 
		$(".manager_right_03").click(function(){
			clickAddDependencies();
		});
		
		// wam 세부창 :  2.선행 , 종속 종류 선택  메서드 실행 
		$(".preceding_typeOfWork").click(function(){
			clickPriorWork();
		});
		
		$(".typeOfWork").click(function(){
			clickPriorWork();
		});
		
		//wam 세부창 : 3. 종속관계 프로젝트 리스트 메서드 실행 
		$(".selectTask_input").click(function(){
			clickselectTask_input();
		})
		
		$(".preceding_typeOfWork_select_list").click(function(){
			$(this).parent().parent().find(".preceding_typeOfWork").removeClass("on");
			$(this).parent().parent().find(".typeOfWork").removeClass("on");
			$(this).parent().parent().find(".preceding_typeOfWork").toggleClass("on");
			$(".typeOfWork_select").css("display", "none");
		});
		
		$(".typeOfWork_select_list").click(function(){
			$(this).parent().parent().find(".preceding_typeOfWork").removeClass("on");
			$(this).parent().parent().find(".typeOfWork").removeClass("on");
			$(this).parent().parent().find(".typeOfWork").toggleClass("on");
			$(".typeOfWork_select").css("display", "none");
		});
		
		
		
		//wam 세부창 : 1. 하위작업 버튼 클릭시 html코드 생성 
		$(".rowstructure_06_btn").click(function() {
			//alert("!");
			let str = `<div class="Add_subtask_parent">
							<div class="Add_subtask">
									<div class="Add_subtask_checkSvg">
								<svg class="HighlightSol HighlightSol--core CompoundIcon--small CompoundIcon TaskCompletionCompoundIcon TaskCompletionStatusIndicator--incomplete TaskCompletionStatusIndicator TaskRowCompletionStatus-taskCompletionIcon--incomplete TaskRowCompletionStatus-taskCompletionIcon" viewBox="0 0 32 32" aria-hidden="true" focusable="false">
								<path d="M31,16c0,8.3-6.7,15-15,15S1,24.3,1,16S7.7,1,16,1S31,7.7,31,16z" class="check_CompoundIcon-outer"></path>
								<path d="M13.4,22.1c-0.3,0-0.5-0.1-0.7-0.3l-3.9-3.9c-0.4-0.4-0.4-1,0-1.4s1-0.4,1.4,0l3.1,3.1l8.1-8.1c0.4-0.4,1-0.4,1.4,0   s0.4,1,0,1.4l-8.9,8.9C13.9,22,13.7,22.1,13.4,22.1z" class="check_CompoundIcon-inner"></path>
								</svg>
							</div>
							<div class="Add_subtask_title">
								<input name="Add_subtask_title" type="text">
							</div>
							<div class="Add_subtask_deadline">
								<svg class="HighlightSol HighlightSol--core Icon CalendarIcon" viewBox="0 0 32 32" aria-hidden="true" focusable="false"><path d="M24,2V1c0-0.6-0.4-1-1-1s-1,0.4-1,1v1H10V1c0-0.6-0.4-1-1-1S8,0.4,8,1v1C4.7,2,2,4.7,2,8v16c0,3.3,2.7,6,6,6h16c3.3,0,6-2.7,6-6V8C30,4.7,27.3,2,24,2z M8,4v1c0,0.6,0.4,1,1,1s1-0.4,1-1V4h12v1c0,0.6,0.4,1,1,1s1-0.4,1-1V4c2.2,0,4,1.8,4,4v2H4V8C4,5.8,5.8,4,8,4z M24,28H8c-2.2,0-4-1.8-4-4V12h24v12C28,26.2,26.2,28,24,28z"></path></svg>
							</div>
							<div class="Add_subtask_manager">
								<svg class="HighlightSol HighlightSol--core Icon UserIcon" viewBox="0 0 32 32" aria-hidden="true" focusable="false"><path d="M16,18c-4.4,0-8-3.6-8-8s3.6-8,8-8s8,3.6,8,8S20.4,18,16,18z M16,4c-3.3,0-6,2.7-6,6s2.7,6,6,6s6-2.7,6-6S19.3,4,16,4z M29,32c-0.6,0-1-0.4-1-1v-4.2c0-2.6-2.2-4.8-4.8-4.8H8.8C6.2,22,4,24.2,4,26.8V31c0,0.6-0.4,1-1,1s-1-0.4-1-1v-4.2C2,23,5,20,8.8,20h14.4c3.7,0,6.8,3,6.8,6.8V31C30,31.6,29.6,32,29,32z"></path></svg>
							</div>
							<div class="assignmentOfmanager">
								<div class="assignmentOfmanager_title">
									<span>담당자</span>
									<svg class="assignmentOfmanager_title_XIcon" viewBox="0 0 32 32" aria-hidden="true" focusable="false"><path d="M18.1,16L27,7.1c0.6-0.6,0.6-1.5,0-2.1s-1.5-0.6-2.1,0L16,13.9l-8.9-9C6.5,4.3,5.6,4.3,5,4.9S4.4,6.4,5,7l8.9,8.9L5,24.8c-0.6,0.6-0.6,1.5,0,2.1c0.3,0.3,0.7,0.4,1.1,0.4s0.8-0.1,1.1-0.4l8.9-8.9l8.9,8.9c0.3,0.3,0.7,0.4,1.1,0.4s0.8-0.1,1.1-0.4c0.6-0.6,0.6-1.5,0-2.1L18.1,16z"></path></svg>
								</div>
								<div class="assignmentOfmanager_select">
									<div class="assignmentOfmanager_select_input">
										<input name="manager" type="text" placeholder="이름 또는 이메일"/>
										<svg class="HighlightSol HighlightSol--core CompoundIcon--xsmall CompoundIcon XCircleCompoundIcon" viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path d="M23,12c0,6.1-4.9,11-11,11S1,18.1,1,12S5.9,1,12,1S23,5.9,23,12z" class="CompoundIcon-outer"></path><path d="M13.4,12l4.3-4.3c0.4-0.4,0.4-1,0-1.4s-1-0.4-1.4,0L12,10.6L7.7,6.3c-0.4-0.4-1-0.4-1.4,0s-0.4,1,0,1.4l4.3,4.3l-4.3,4.3c-0.4,0.4-0.4,1,0,1.4C6.5,17.9,6.7,18,7,18s0.5-0.1,0.7-0.3l4.3-4.3l4.3,4.3c0.2,0.2,0.5,0.3,0.7,0.3s0.5-0.1,0.7-0.3c0.4-0.4,0.4-1,0-1.4L13.4,12z" class="CompoundIcon-inner"></path></svg>
									</div>
									또는 
									<div class="assignmentOfmanager_select_assignedToMe">나에게 배정</div>
								</div>
							</div>
							<div class="assignmentOfmanager_list">
								<div class="assignmentOfmanager_list_select">
									<img src="../../img01/짱구1.jpg">
									<div class="assignmentOfmanager_list_select_memberName">지숭</div>
									<div class="assignmentOfmanager_list_select_memberEmail">jisooasana02@gmail.com</div>
								</div>
								<div class="assignmentOfmanager_list_select">
									<img src="../../img01/짱구2.jpg">
									<div class="assignmentOfmanager_list_select_memberName">현우</div>
									<div class="assignmentOfmanager_list_select_memberEmail">jisooasana02@gmail.com</div>
								</div>
								<div class="assignmentOfmanager_list_select">
									<img src="../../img01/철수.png">
									<div class="assignmentOfmanager_list_select_memberName">길주</div>
									<div class="assignmentOfmanager_list_select_memberEmail">jisooasana02@gmail.com</div>
								</div>
								<div class="invite_team_members_by_email">
									<svg class="HighlightSol HighlightSol--core Icon TypeaheadActionItemStructure-icon PlusIcon" viewBox="0 0 32 32" aria-hidden="true" focusable="false"><path d="M26,14h-8V6c0-1.1-0.9-2-2-2l0,0c-1.1,0-2,0.9-2,2v8H6c-1.1,0-2,0.9-2,2l0,0c0,1.1,0.9,2,2,2h8v8c0,1.1,0.9,2,2,2l0,0c1.1,0,2-0.9,2-2v-8h8c1.1,0,2-0.9,2-2l0,0C28,14.9,27.1,14,26,14z"></path></svg>
									<span>이메일로 팀원 초대</span>
								</div>
							</div>
						</div>
				      </div>`;
			$(".rowstructure_06").before(str);
		});
		
		//wam 세부창 : 2.하위작업 버튼 클릭시 html코드 생성 후 메서드 실행 
		$(document).on("click",".Add_subtask_manager",clickAssignmentOfSubTask);
		$(document).on("click",".Add_subtask_save_manager",clickAssignmentOfSubTask);
		
		//wam 세부창 : 하위작업 담당자 리스트 창 닫기 
		$(".assignmentOfmanager_title_XIcon").click(function(){
			closeAssignmentOfSubTask();
			
		});
		
		//새로운 wam 팝업
		$(".boardcolumn_header_plusIcon").click(function(){
			$(".blank_milestone").css("display", "block");
		});
		
	});
	
	
	
	//wam의 세부창 동적 //wam의 세부창 동적 //wam의 세부창 동적 
</script>
</head>
<body>
	<div class="transparent_screen" style="display: none;"></div>
	<!-- 프로필셋팅 팝업창 --><!-- 프로필셋팅 팝업창 --><!-- 프로필셋팅 팝업창 --><!-- 프로필셋팅 팝업창 --><!-- 프로필셋팅 팝업창 -->
	<div class="profile_setting_background" member_idx="${memberIdx}">
		<div id="profile_setting_main">
			<div id="profile_setting_header">
				<h2 style="font-weight: 500; margin-top: 10px;" >설정</h2>
				<div class="profile_setting_XIcon">
				<svg viewBox="0 0 32 32" aria-hidden="true" focusable="false"><path d="M18.1,16L27,7.1c0.6-0.6,0.6-1.5,0-2.1s-1.5-0.6-2.1,0L16,13.9l-8.9-9C6.5,4.3,5.6,4.3,5,4.9S4.4,6.4,5,7l8.9,8.9L5,24.8c-0.6,0.6-0.6,1.5,0,2.1c0.3,0.3,0.7,0.4,1.1,0.4s0.8-0.1,1.1-0.4l8.9-8.9l8.9,8.9c0.3,0.3,0.7,0.4,1.1,0.4s0.8-0.1,1.1-0.4c0.6-0.6,0.6-1.5,0-2.1L18.1,16z"></path></svg>
				</div>
			</div>
			<div style="clear:both;"></div>
			<div id="profile_setting_profile">
				<div class="profile_setting_profiles">
					<span>프로필</span>
				</div>
			</div>
					<div id="profile_setting_contents">
						<div class="profile_setting_picture_span">
						<span>사진</span>
						</div>
						<%if(myProfile == null){ %>
						<div class="profile_setting_picture">
							<img src="img/Unknown.png"/>
						</div>
						<%}else{ %>
						<div class="profile_setting_picture">
							<img id="profileImage" src="img/${myProfile}"/>
						</div>
						<%} %>
						<!-- <div class="null_icon">
						<svg class="null_icon_svg" viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path d="M12,14c-3.859,0-7-3.14-7-7S8.141,0,12,0s7,3.14,7,7-3.141,7-7,7Zm0-12c-2.757,0-5,2.243-5,5s2.243,5,5,5,5-2.243,5-5-2.243-5-5-5Zm10,21v-2c0-2.757-2.243-5-5-5H7c-2.757,0-5,2.243-5,5v2c0,.552,.447,1,1,1s1-.448,1-1v-2c0-1.654,1.346-3,3-3h10c1.654,0,3,1.346,3,3v2c0,.552,.447,1,1,1s1-.448,1-1Z"></path></svg>
						</div> -->
						<div class="profile_setting_new_picture">
						<form method="post" enctype="multipart/form-data" id="form">
						<input type="file" name="profile" class="upload_myProfile"/>
						<button type="button" onclick="uploadFunction();" class="form-control btn btn-primary">파일업로드</button>
						</form>
						<!-- <span class="upload_myProfile">새 사진 업로드</span> -->
						<span>•</span>
						<span class="delete_myProfile">사진 제거</span>
						</div>
						<div class="profile_setting_explanation">
							<span>사진이 있으면 Asana에서 팀원들이 회원님을 알아볼 수 있습니다</span>
						</div>
						<div class="profile_setting_input_name">
						<div class="profile_setting_name">
							<span>성명</span>
						</div>
						<div class="profile_setting_col">
							<svg viewBox="0 0 12 12" role="img"><path d="M 7.97721 7.61997 L 6.36863 6.50067 L 6.53619 8.43096 H 5.46381 L 5.63137 6.49397 L 4.02279 7.61997 L 3.5 6.66153 L 5.26944 5.85054 L 3.5 5.03284 L 4.02279 4.06099 L 5.63137 5.21381 L 5.46381 3.25 H 6.53619 L 6.36863 5.21381 L 7.97721 4.06099 L 8.5 5.03284 L 6.73727 5.85054 L 8.5 6.66153 L 7.97721 7.61997 Z"></path><title>필수</title></svg>
						</div>
						<div class="profile_setting_input_text">
						<input type="text" id="profile_setting_name" name="name" value="${placeholderValue}"/>
						</div>
						</div>
						<div class="profile_setting_email">
							<span>이메일</span>
						</div>
						<div class="profile_setting_email_address">
							<div id="profile_setting_email_address">
							<span>${myEmail}</span>
							</div>
						</div>
						<div class="profile_setting_introduction">
							<span>내 소개</span>
						</div>
							<div class="profile_setting_introduction_text">
								<textarea id="profile_setting_introduction" name="introduction">${placeholderIntroduce}</textarea>
							</div>
							<!--부재중 설정 구간-->
							<div class="toggle_line">
							<div class="toggle_switch">
								<input type="checkbox" class="toggle_input" id="toggle" <%= alarm == 1 ? "checked" : "" %>/>
								<label class="toggle_label" for="toggle"></label>
							</div>
							<div class="toggle_span">
								<span>부재중으로 설정</span>
							</div>
							</div>
							<div class="toggle_click_view <%= alarm == 1 ? "on" : "" %>">
								<div class="toggle_day">
									<div class="toggle_start_day_span">
										<span>시작일</span>
									</div>
									<div class="toggle_deadline_day_span">
										<span>종료일</span>
									</div>
								</div>
								<div class="toggle_day_box">
									<div class="toggle_start_box">
										<!-- 시작일 날짜 -->
										 <input type="date" id="start_date" name="start_date" value="<%=memberStartDate.split(" ")[0] %>" />
										</div>
									<div class="toggle_deadline_box">
										<!-- 종료일 날짜 -->
										 <input type="date" id="end_date" name="end_date" data-placeholder="날짜를 선택하세요"  value="<%=memberDeadDate.split(" ")[0] %>"/>
										 
										</div>
									
								</div>
								<div class="preview">
									<div class="preview_span">
										<span>미리보기</span>
									</div>
								</div>
								<div class="preview_main">
								<div class="preview_profileImg">
									    <img src="img/${myProfile}"/>
	                                </div>
									<div class="preview_name">
	                                    <span>${myNickname }</span>
	                                </div>
									<div class="preview_alarm_img">
										<svg viewBox="0 0 32 32" aria-hidden="true" focusable="false"><path d="M11.606 28.804c-.248-.328-.004-.804.407-.804h7.97c.41 0 .654.476.406.804A5.51 5.51 0 0 1 15.997 31a5.508 5.508 0 0 1-4.39-2.196Zm16.392-12.555V12a1 1 0 1 0-2 0v4.249c0 2.246.962 4.389 2.641 5.881.366.326.462.849.238 1.303-.167.339-.58.567-1.029.567H4.15c-.448 0-.862-.228-1.029-.567a1.082 1.082 0 0 1 .238-1.303A7.872 7.872 0 0 0 6 16.249V12a9.926 9.926 0 0 1 2.994-7.136c1.931-1.896 4.484-2.931 7.193-2.862.86.016 1.711.146 2.53.387A.999.999 0 1 0 19.28.47c-.99-.292-2.02-.449-3.058-.468-3.279-.058-6.315 1.161-8.632 3.435A11.915 11.915 0 0 0 3.997 12v4.249a5.875 5.875 0 0 1-1.969 4.386c-1.048.931-1.33 2.411-.705 3.682.505 1.023 1.613 1.684 2.824 1.684h23.7c1.21 0 2.318-.661 2.823-1.684.626-1.271.343-2.75-.705-3.682a5.873 5.873 0 0 1-1.969-4.386h.002Zm3-10.249h-3.586l4.293-4.293A1 1 0 0 0 30.998 0h-6a1 1 0 1 0 0 2h3.586l-4.293 4.293A1 1 0 0 0 24.998 8h6a1 1 0 1 0 0-2Zm-17 3a1 1 0 0 0 1 1h3.586l-4.293 4.293A1 1 0 0 0 14.998 16h6a1 1 0 1 0 0-2h-3.586l4.293-4.293A1 1 0 0 0 20.998 8h-6a1 1 0 0 0-1 1Z"></path></svg>
									</div>
									<div class="preview_deadline">
										<span>(12월 26일까지 부재중)</span>
									</div>
								</div>
								</div>
								<div class="deadline_red_span">
									<span>휴가는 오늘보다 이전에 끝날 수</span><br/>
									<span>없습니다.</span>
								</div>
							</div>
	
							<!--부재중 설정 구간-->
					</div>
		</div>
	</div>
	<!-- 프로필셋팅 팝업창 --><!-- 프로필셋팅 팝업창 --><!-- 프로필셋팅 팝업창 --><!-- 프로필셋팅 팝업창 --><!-- 프로필셋팅 팝업창 -->
	<!--프로필이미지 팝업창--><!--프로필이미지 팝업창--><!--프로필이미지 팝업창--><!--프로필이미지 팝업창--><!--프로필이미지 팝업창-->
	<div class="me_button_popup">
		<div class="popup_profile">
			<div>
				<img class="popup_profile_img" src="img/${loginProfileImg}"/>
			</div>
			<div>내 작업 공간</div>
			<div class="popup_email_font">${loginEmail}</div>
		</div>
		<div class="pop_bottom">
			<div class="popup_invite_member">
				<svg class="invite_member_icon" viewBox="0 0 32 32" aria-hidden="true" focusable="false"><path d="M31,26h-3v-3c0-0.6-0.4-1-1-1s-1,0.4-1,1v3h-3c-0.6,0-1,0.4-1,1s0.4,1,1,1h3v3c0,0.6,0.4,1,1,1s1-0.4,1-1v-3h3c0.6,0,1-0.4,1-1S31.6,26,31,26z M16,18c4.4,0,8-3.6,8-8s-3.6-8-8-8s-8,3.6-8,8S11.6,18,16,18z M16,4c3.3,0,6,2.7,6,6s-2.7,6-6,6s-6-2.7-6-6S12.7,4,16,4z M21.2,20H8.8C5,20,2,23,2,26.8V31c0,0.6,0.4,1,1,1s1-0.4,1-1v-4.2C4,24.2,6.2,22,8.8,22h12.4c0.6,0,1-0.4,1-1S21.8,20,21.2,20z"></path></svg>
				Asana에 초대
			</div>
			<div class="popup_profile_info_details">
				<svg class="info_details_icon" viewBox="0 0 32 32" aria-hidden="true" focusable="false"><path d="M16 5c-3.86 0-7 3.14-7 7s3.14 7 7 7 7-3.14 7-7-3.14-7-7-7Zm0 12c-2.757 0-5-2.243-5-5s2.243-5 5-5 5 2.243 5 5-2.243 5-5 5Zm0-17C7.178 0 0 7.178 0 16c0 5.16 2.465 9.743 6.269 12.671a.977.977 0 0 0 .265.198C9.189 30.827 12.456 32 16.001 32c8.822 0 16-7.178 16-16S24.822 0 16 0Zm0 30a13.91 13.91 0 0 1-8-2.527V26c0-2.206 1.794-4 4-4h8c2.206 0 4 1.794 4 4v1c0 .145.034.281.09.406A13.909 13.909 0 0 1 16 30Zm9.989-4.209C25.878 22.58 23.238 20 20 20h-8c-3.238 0-5.878 2.58-5.989 5.791A13.948 13.948 0 0 1 2 16C2 8.28 8.28 2 16 2s14 6.28 14 14a13.95 13.95 0 0 1-4.011 9.791Z"></path></svg>
				프로필
			</div>
			<div class="popup_setting">
				<svg class="setting_icon" viewBox="0 0 32 32" aria-hidden="true" focusable="false"><path d="M16,21c-2.8,0-5-2.2-5-5s2.2-5,5-5s5,2.2,5,5S18.8,21,16,21z M16,13c-1.7,0-3,1.3-3,3s1.3,3,3,3s3-1.3,3-3S17.7,13,16,13z M16.1,32H16c-1.6,0-3-0.9-3.6-2.4l-1.2-2.8c-0.4-0.8-1.2-1.3-2-1.2L6,26c-1.6,0.2-3.1-0.6-3.9-2L2,23.9c-0.8-1.4-0.7-3.1,0.2-4.3 L4,17.2c0.5-0.7,0.5-1.6,0-2.3l-1.8-2.4c-0.9-1.3-1-3-0.2-4.3l0.1-0.1C3,6.6,4.5,5.8,6,6l3,0.3c0.9,0.1,1.7-0.4,2-1.2l1.2-2.7 C12.9,0.9,14.4,0,15.9,0H16c1.6,0,3,0.9,3.7,2.4l1.2,2.7c0.4,0.8,1.2,1.3,2,1.2L26,6c1.6-0.2,3.1,0.6,3.9,2l0,0 c0.8,1.4,0.7,3.1-0.2,4.3l-1.8,2.4c-0.5,0.7-0.5,1.6,0,2.3l1.8,2.5c0.9,1.3,1,3,0.2,4.3L29.8,24c-0.8,1.4-2.3,2.1-3.9,2l-3-0.3 c-0.9-0.1-1.7,0.4-2,1.2l-1.2,2.8C19.1,31.1,17.6,32,16.1,32z M9.2,23.7c1.6,0,3,0.9,3.6,2.4l1.2,2.8c0.3,0.7,1,1.2,1.8,1.2h0.1 c0.8,0,1.5-0.5,1.8-1.2l1.2-2.8c0.7-1.6,2.3-2.5,4.1-2.3l3,0.3c0.8,0.1,1.5-0.3,1.9-1L28,23c0.4-0.7,0.4-1.5-0.1-2.2l-1.8-2.5 c-1-1.4-1-3.3,0-4.7l1.8-2.4c0.5-0.6,0.5-1.5,0.1-2.2l-0.1-0.1c-0.4-0.7-1.1-1.1-1.9-1l-3,0.3c-1.7,0.2-3.3-0.8-4-2.3l-1.2-2.7 C17.5,2.5,16.8,2,16,2h-0.1c-0.8,0-1.5,0.5-1.8,1.2l-1.2,2.7c-0.7,1.6-2.3,2.5-4,2.3L5.8,8C5,7.9,4.3,8.3,3.9,9L3.8,9.1 C3.5,9.7,3.5,10.6,4,11.2l1.8,2.4c1,1.4,1,3.3,0,4.7L4,20.8c-0.5,0.6-0.5,1.5-0.1,2.2L4,23.1c0.4,0.7,1.1,1.1,1.9,1l3-0.3 C9,23.7,9.1,23.7,9.2,23.7z"></path></svg>
				설정
			</div>
			<div class="popup_logout">
				<svg class="logout_icon" viewBox="0 0 32 32" aria-hidden="true" focusable="false"><path d="M3 16.5A1.5 1.5 0 0 0 4.5 18h19.879l-7.439 7.439a1.5 1.5 0 1 0 2.122 2.121l10-10a1.5 1.5 0 0 0 0-2.121l-10-10a1.5 1.5 0 1 0-2.121 2.121L24.38 15H4.501a1.5 1.5 0 0 0-1.5 1.5H3Z"></path></svg>
				로그아웃
			</div>
		</div>
	</div>
	<!--프로필이미지 팝업창--><!--프로필이미지 팝업창--><!--프로필이미지 팝업창--><!--프로필이미지 팝업창--><!--프로필이미지 팝업창-->
	<!---------------------------------------- 초대 팝업창--------------------------------------------->
	<div class="popup_invite_whole-div">
		<div class="popup_Invite">
			<div class="popup_InviteTitle">
				<div>내 작업 공간에 초대</div>
				<div class="popup_invite_x_icon_div" style="width: 27px; height: 27px;">
					<svg class="popup_invite_XIcon" viewBox="0 0 32 32" aria-hidden="true" focusable="false">
						<path d="M18.1,16L27,7.1c0.6-0.6,0.6-1.5,0-2.1s-1.5-0.6-2.1,0L16,13.9l-8.9-9C6.5,4.3,5.6,4.3,5,4.9S4.4,6.4,5,7l8.9,8.9L5,24.8c-0.6,0.6-0.6,1.5,0,2.1c0.3,0.3,0.7,0.4,1.1,0.4s0.8-0.1,1.1-0.4l8.9-8.9l8.9,8.9c0.3,0.3,0.7,0.4,1.1,0.4s0.8-0.1,1.1-0.4c0.6-0.6,0.6-1.5,0-2.1L18.1,16z"></path></svg>
				</div>
			</div>
			<div class="popup_InviteContent">
				<div class="popup_invite_text">이메일 주소</div>
				<div contenteditable="false" class="popup_EmailInput" type="text" placeholder="name@naver.com, name@naver.com, ...">
					<!-------------------- 인풋된 이메일 주소 ----------------------->
					<span class="invite_input_email_area"></span>
					<!-- 인풋 입력될 장소 -->
					<input type="text" contenteditable="true" class="invite_input_text_area"/><br/>
					<!-------------------- 인풋된 이메일 주소 ----------------------->
				</div>
				<button class="popup_invite_button">보내기</button>
			</div>
		</div>
	</div>
	<!---------------------------------------- 초대 팝업창----------------------------------------->

	<!-- 상단바 생성리스트 팝업창 -->	<!-- 상단바 생성리스트 팝업창 -->	<!-- 상단바 생성리스트 팝업창 -->	<!-- 상단바 생성리스트 팝업창 -->
	<div class="create_something_popup">
		<div class="popup_create_work">
			<svg class="topbar_popup_approve" viewBox="0 0 32 32" aria-hidden="true" focusable="false">
				<path d="M29.1,20.9 M16,32C7.2,32,0,24.8,0,16S7.2,0,16,0s16,7.2,16,16S24.8,32,16,32z M16,2C8.3,2,2,8.3,2,16s6.3,14,14,14s14-6.3,14-14S23.7,2,16,2z M12.9,22.6c-0.3,0-0.5-0.1-0.7-0.3l-3.9-3.9C8,18,8,17.4,8.3,17s1-0.4,1.4,0l3.1,3.1l8.6-8.6c0.4-0.4,1-0.4,1.4,0s0.4,1,0,1.4l-9.4,9.4C13.4,22.5,13.2,22.6,12.9,22.6z"></path></svg>
			작업
		</div>
		<div class="popup_create_project">
			<svg class="topbar_popup_project" viewBox="0 0 32 32" aria-hidden="true" focusable="false">
				<path d="M10,13.5c0.8,0,1.5,0.7,1.5,1.5s-0.7,1.5-1.5,1.5S8.5,15.8,8.5,15S9.2,13.5,10,13.5z M23,14h-8c-0.6,0-1,0.4-1,1s0.4,1,1,1h8c0.6,0,1-0.4,1-1S23.6,14,23,14z M23,20h-8c-0.6,0-1,0.4-1,1s0.4,1,1,1h8c0.6,0,1-0.4,1-1S23.6,20,23,20z M10,19.5c0.8,0,1.5,0.7,1.5,1.5s-0.7,1.5-1.5,1.5S8.5,21.8,8.5,21S9.2,19.5,10,19.5z M24,2h-2.2c-0.4-1.2-1.5-2-2.8-2h-6c-1.3,0-2.4,0.8-2.8,2H8C4.7,2,2,4.7,2,8v18c0,3.3,2.7,6,6,6h16c3.3,0,6-2.7,6-6V8C30,4.7,27.3,2,24,2z M13,2h6c0.6,0,1,0.4,1,1v2c0,0.6-0.4,1-1,1h-6c-0.6,0-1-0.4-1-1V3C12,2.4,12.4,2,13,2z M28,26c0,2.2-1.8,4-4,4H8c-2.2,0-4-1.8-4-4V8c0-2.2,1.8-4,4-4h2v1c0,1.7,1.3,3,3,3h6c1.7,0,3-1.3,3-3V4h2c2.2,0,4,1.8,4,4V26z"></path></svg>
			프로젝트
		</div>
		<div class="popup_create_message">
			<svg class="topbar_popup_message" viewBox="0 0 32 32" aria-hidden="true" focusable="false">
				<path d="M20 2h-8C5.383 2 0 7.383 0 14v2c0 3.103 1.239 6.1 3.424 8.342l.586 5.857a1.999 1.999 0 0 0 3.247 1.357L11.662 28h8.339c6.617 0 12-5.383 12-12v-2c0-6.617-5.384-12-12.001-12Zm-9.045 24L6 30l-.659-6.589C3.305 21.58 2 18.953 2 16v-2C2 8.477 6.477 4 12 4h8c5.523 0 10 4.477 10 10v2c0 5.523-4.477 10-10 10h-9.045Z"></path></svg>
			메시지
		</div>
		<div class="popup_create_portfolio">
			<svg class="topbar_popup_portfolio" viewBox="0 0 32 32" aria-hidden="true" focusable="false">
				<path d="M29 8C30.6569 8 32 9.34315 32 11V25C32 27.7614 29.7614 30 27 30H5C2.23858 30 0 27.7614 0 25V5C0 3.34315 1.34315 2 3 2H12.2C12.5693 2 12.9086 2.20355 13.0824 2.52941L15.1529 6.41177C15.6743 7.38936 16.6921 8 17.8 8H29ZM30 11V25C30 26.6569 28.6569 28 27 28H5C3.34315 28 2 26.6569 2 25V10H29C29.5523 10 30 10.4477 30 11ZM13.7999 8C13.6477 7.79704 13.5099 7.58098 13.3882 7.35294L11.6 4H3C2.44772 4 2 4.44772 2 5V8H13.7999Z"></path></svg>
			포트폴리오
		</div>
		<div class="popup_create_invite">
			<svg class="topbar_popup_invite" viewBox="0 0 32 32" aria-hidden="true" focusable="false">
				<path d="M31,26h-3v-3c0-0.6-0.4-1-1-1s-1,0.4-1,1v3h-3c-0.6,0-1,0.4-1,1s0.4,1,1,1h3v3c0,0.6,0.4,1,1,1s1-0.4,1-1v-3h3c0.6,0,1-0.4,1-1S31.6,26,31,26z M16,18c4.4,0,8-3.6,8-8s-3.6-8-8-8s-8,3.6-8,8S11.6,18,16,18z M16,4c3.3,0,6,2.7,6,6s-2.7,6-6,6s-6-2.7-6-6S12.7,4,16,4z M21.2,20H8.8C5,20,2,23,2,26.8V31c0,0.6,0.4,1,1,1s1-0.4,1-1v-4.2C4,24.2,6.2,22,8.8,22h12.4c0.6,0,1-0.4,1-1S21.8,20,21.2,20z"></path></svg>
			초대
		</div>
	</div>
	<!-- 상단바 생성리스트 팝업창 -->	<!-- 상단바 생성리스트 팝업창 -->	<!-- 상단바 생성리스트 팝업창 -->	<!-- 상단바 생성리스트 팝업창 -->
	<!-- 상단바&사이드바 --><!-- 상단바&사이드바 --><!-- 상단바&사이드바 --><!-- 상단바&사이드바 --><!-- 상단바&사이드바 --><!-- 상단바&사이드바 --><!-- 상단바&사이드바 -->
	<div id="header">
		<div id="menu_button">
			<svg class="Icon BurgerExpand" viewBox="0 0 32 32" aria-hidden="true" focusable="false">
				<path d="M0 4.5A1.5 1.5 0 0 1 1.5 3h29a1.5 1.5 0 1 1 0 3h-29A1.5 1.5 0 0 1 0 4.5ZM30.5 15h-29a1.5 1.5 0 1 0 0 3h29a1.5 1.5 0 1 0 0-3Zm0 12h-29a1.5 1.5 0 1 0 0 3h29a1.5 1.5 0 1 0 0-3Z"></path></svg>
		</div>
		<div id="creation_button">
			<div>
				<svg viewBox="0 0 24 24" aria-hidden="true" focusable="false">
					<path d="M10,10V4c0-1.1,0.9-2,2-2s2,0.9,2,2v6h6c1.1,0,2,0.9,2,2s-0.9,2-2,2h-6v6c0,1.1-0.9,2-2,2s-2-0.9-2-2v-6H4c-1.1,0-2-0.9-2-2s0.9-2,2-2H10z"></path></svg>
			</div>
			<span>생성</span>
		</div>
		<div id="search_div">
			<svg class="Icon TopbarSearchTypeahead-icon--isInverse TopbarSearchTypeahead-icon MagnifyerIcon" viewBox="0 0 32 32" aria-hidden="true" focusable="false">
				<path d="M13.999 28c3.5 0 6.697-1.3 9.154-3.432l6.139 6.139a.997.997 0 0 0 1.414 0 .999.999 0 0 0 0-1.414l-6.139-6.139A13.93 13.93 0 0 0 27.999 14c0-7.72-6.28-14-14-14s-14 6.28-14 14 6.28 14 14 14Zm0-26c6.617 0 12 5.383 12 12s-5.383 12-12 12-12-5.383-12-12 5.383-12 12-12Z"></path></svg>
			<span>검색</span>
		</div>
		<div id="experience25">체험 25일 남음</div>
		<div id="charge_info">
			<span>청구 정보 추가</span>
		</div>
		<div id="question_button">
			<svg class="MiniIcon QuestionMarkMiniIcon" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
				<path d="M13.749 20a1.75 1.75 0 1 1-3.499.001A1.75 1.75 0 0 1 13.75 20Zm-1.75-18c-4.139 0-6 3-6 5.131V8a.5.5 0 0 0 .5.5h2a.5.5 0 0 0 .5-.5v-.869c0-.45.509-2.131 3-2.131 2.783 0 3 2.095 3 2.736 0 1.375-1.021 2.073-1.463 2.311-1.209.651-3.037 1.635-3.037 4.347V15.5a.5.5 0 0 0 .5.5h2a.5.5 0 0 0 .5-.5v-1.106c0-.835.276-1.068 1.461-1.705C16.863 11.665 18 9.813 18 7.737c0-2.763-1.878-5.737-6-5.737Z"></path></svg>
		</div>
		<div id="me_button">
			<img class="img_small" src="img/${loginProfileImg}"/>
		</div>
		<svg class="MiniIcon ArrowDownMiniIcon" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
			<path d="m18.185 7.851-6.186 5.191-6.186-5.191a1.499 1.499 0 1 0-1.928 2.298l7.15 6a1.498 1.498 0 0 0 1.928 0l7.15-6a1.5 1.5 0 0 0-1.928-2.298Z"></path></svg>
	</div>
	<div id="content">
		<!-- 사이드바 --><!-- 사이드바 --><!-- 사이드바 --><!-- 사이드바 --><!-- 사이드바 --><!-- 사이드바 --><!-- 사이드바 --><!-- 사이드바 -->
		<div id="sidebar" class="fl">
			<div class="sidebar_item active">
				<svg class="NavIcon HomeNavIcon" viewBox="0 0 40 40" aria-hidden="true" focusable="false">
					<path d="M37.9,15L22.2,3.8c-1.3-1-3.1-1-4.4-0.1L2.2,14.4c-0.7,0.5-0.9,1.4-0.4,2.1c0.5,0.7,1.4,0.9,2.1,0.4L6,15.4v12.3c0,4.6,3.7,8.3,8.3,8.3h11.4c4.6,0,8.3-3.7,8.3-8.3V15.9l2.1,1.5c0.3,0.2,0.6,0.3,0.9,0.3c0.5,0,0.9-0.2,1.2-0.6C38.7,16.4,38.5,15.5,37.9,15z M31,27.7c0,2.9-2.4,5.3-5.3,5.3H14.3C11.4,33,9,30.6,9,27.7V13.3l10.6-7.2c0.2-0.2,0.5-0.2,0.8,0L31,13.7V27.7z"></path></svg>
				<span>홈</span>
			</div>
			<div class="sidebar_item">
				<svg class="NavIcon CheckNavIcon" viewBox="0 0 40 40" aria-hidden="true" focusable="false">
					<path d="M20,2.5C10.4,2.5,2.5,10.4,2.5,20S10.4,37.5,20,37.5S37.5,29.6,37.5,20S29.6,2.5,20,2.5z M20,34.5C12,34.5,5.5,28,5.5,20S12,5.5,20,5.5S34.5,12,34.5,20S28,34.5,20,34.5z M27.7,15c0.6,0.6,0.6,1.5,0,2.1l-10,10c-0.2,0.2-0.6,0.3-1,0.3c-0.4,0-0.8-0.1-1.1-0.4l-4.1-4.1c-0.6-0.6-0.6-1.5,0-2.1c0.6-0.6,1.5-0.6,2.1,0l3.1,3.1l8.9-8.9C26.2,14.4,27.1,14.4,27.7,15z"></path></svg>
				<span>내 작업</span>
			</div>
			<div class="sidebar_item">
				<svg class="CompoundNavIcon BellNotificationCompoundIcon SidebarTopNavLinks-bellNotificationCompoundIcon--red" viewBox="0 0 40 40" aria-hidden="true" focusable="false">
					<path d="M31 14a7 7 0 1 0 0-14 7 7 0 0 0 0 14Z" class="CompoundNavIcon-outer"></path>
					<path d="M15.422 34h9.156A4.998 4.998 0 0 1 20 37a4.998 4.998 0 0 1-4.578-3Zm20.037-9.007A5.483 5.483 0 0 1 34 21.263v-2.7a1.5 1.5 0 0 0-3 0v2.7a8.48 8.48 0 0 0 2.254 5.765l.813.882a.62.62 0 0 1 .117.701.62.62 0 0 1-.595.39H6.41a.621.621 0 0 1-.595-.39.623.623 0 0 1 .118-.702l.812-.88a8.482 8.482 0 0 0 2.254-5.766V16a10.976 10.976 0 0 1 10.5-10.989 1.499 1.499 0 0 0 1.431-1.565c-.036-.827-.719-1.499-1.565-1.431A13.97 13.97 0 0 0 6 16v5.263a5.484 5.484 0 0 1-1.459 3.731l-.812.88a3.6 3.6 0 0 0-.662 3.939A3.603 3.603 0 0 0 6.41 32h27.18a3.603 3.603 0 0 0 3.343-2.187 3.6 3.6 0 0 0-.661-3.938l-.813-.882Z" class="CompoundNavIcon-inner"></path></svg>
				<span>수신함</span>
			</div>
			<div class="separator"></div>
			<div style="overflow-y:scroll; overflow-x:hidden; height:707px; margin-top:-7px;">
			<!------------------------ 즐겨찾기 추가된 프로젝트 & 포트폴리오 & 멤버 ------------------------------>
			<%
				boolean favoritesCheck = false;
				if(pDtoFavoritesListLength!=0 || favoritesWorkspaceCount!=0){ 
					favoritesCheck = true;
				} 
			%>
				<div class="category ajax" style='<%=(favoritesCheck ? "" : "display: none;")%>'>
					<span>별표 표시</span>
				</div>
			<% for(ProjectDto dtos : pDtoFavoritesList){ %>
				<div class="sidebar_item ajax project_idx=<%=dtos.getProjectIdx()%>" project_idx="<%=dtos.getProjectIdx()%>">
					<svg class="MiniIcon--large MiniIcon ColorFillIcon ColorFillIcon--colorAqua SmallSquircleMiniIcon" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
						<path d="M10.4,4h3.2c2.2,0,3,0.2,3.9,0.7c0.8,0.4,1.5,1.1,1.9,1.9s0.7,1.6,0.7,3.9v3.2c0,2.2-0.2,3-0.7,3.9c-0.4,0.8-1.1,1.5-1.9,1.9s-1.6,0.7-3.9,0.7h-3.2c-2.2,0-3-0.2-3.9-0.7c-0.8-0.4-1.5-1.1-1.9-1.9c-0.4-1-0.6-1.8-0.6-4v-3.2c0-2.2,0.2-3,0.7-3.9C5.1,5.7,5.8,5,6.6,4.6C7.4,4.2,8.2,4,10.4,4z"></path></svg>
					<span class="ajax_dtos_project_favorites_name"><%=dtos.getName() %></span>
				</div>
			<%} %>
			<%for(MemberDto dtos : mDaoFavoritesList){ %>
				<div class="sidebar_item ajax member_idx_<%=dtos.getMemberIdx()%>" member_idx="<%=dtos.getMemberIdx()%>">
					<img class="img_small_favorites" src="img\<%=dtos.getProfileImg()%>">
					<span class="ajax_dtos_project_favorites_name"><%=dtos.getNickname() %></span>
				</div>
			<% }%>
			<%for(int i=0; i<favoritesWorkspaceCount; i++){ %>
				<div class="sidebar_item with_gt ajax">
					<svg class="Icon SidebarItemIcon--iconWithoutCustomizationColor UserFillIcon" viewBox="0 0 32 32" aria-hidden="true" focusable="false">
						<path d="M31,30H11c-.552,0-1-.448-1-1v-2c0-3.866,3.134-7,7-7h8c3.866,0,7,3.134,7,7v2c0,.552-.448,1-1,1Zm-23-3c0-2.029,.676-3.901,1.814-5.407,.495-.656,.023-1.593-.799-1.593h-2.015c-3.866,0-7,3.134-7,7v2c0,.552,.448,1,1,1H7c.552,0,1-.448,1-1v-2ZM28.5,10c0-4.142-3.358-7.5-7.5-7.5s-7.5,3.358-7.5,7.5,3.358,7.5,7.5,7.5,7.5-3.358,7.5-7.5Zm-17,0c0-2.125,.698-4.087,1.878-5.67,.431-.579,.176-1.413-.522-1.594-1.074-.278-2.24-.324-3.45-.067-2.917,.619-5.248,2.996-5.779,5.93-.86,4.758,2.773,8.901,7.373,8.901,.632,0,1.245-.08,1.831-.23,.71-.181,.984-1.013,.546-1.601-1.179-1.582-1.877-3.544-1.877-5.669Z"></path></svg>
					<span>내 작업 공간</span>
					<svg class="MiniIcon--small MiniIcon SidebarFlyoutSplitDropdownButton-flyoutChevron ArrowRightMiniIcon" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
						<path d="M10.148 3.885A1.5 1.5 0 1 0 7.85 5.813l5.19 6.186-5.19 6.186a1.499 1.499 0 0 0 1.148 2.464c.428 0 .854-.182 1.15-.536l6-7.15a1.5 1.5 0 0 0 0-1.929l-6-7.149Z"></path></svg>
				</div>
			<%} %>
			<!------------------------- 즐겨찾기 추가된 프로젝트 & 포트폴리오 & 멤버 ------------------------------->
	
				<div class="category with_plus">
					<span>프로젝트</span>
					<svg class="MiniIcon PlusMiniIcon" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
						<path d="M10,10V4c0-1.1,0.9-2,2-2s2,0.9,2,2v6h6c1.1,0,2,0.9,2,2s-0.9,2-2,2h-6v6c0,1.1-0.9,2-2,2s-2-0.9-2-2v-6H4c-1.1,0-2-0.9-2-2s0.9-2,2-2H10z"></path></svg>
				</div>
				<!--------------------------------- 사이드바 프로젝트/포트폴리오 참여중 리스트 ------------------------------------->
				<!-- 프로젝트 참여 리스트 출력 -->
				<% for(ProjectDto dtos : pDtoList){ %>
					<div class="sidebar_item" project_idx="<%=dtos.getProjectIdx()%>">
						<svg class="MiniIcon--large MiniIcon ColorFillIcon ColorFillIcon--colorAqua SmallSquircleMiniIcon" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
							<path d="M10.4,4h3.2c2.2,0,3,0.2,3.9,0.7c0.8,0.4,1.5,1.1,1.9,1.9s0.7,1.6,0.7,3.9v3.2c0,2.2-0.2,3-0.7,3.9c-0.4,0.8-1.1,1.5-1.9,1.9s-1.6,0.7-3.9,0.7h-3.2c-2.2,0-3-0.2-3.9-0.7c-0.8-0.4-1.5-1.1-1.9-1.9c-0.4-1-0.6-1.8-0.6-4v-3.2c0-2.2,0.2-3,0.7-3.9C5.1,5.7,5.8,5,6.6,4.6C7.4,4.2,8.2,4,10.4,4z"></path></svg>
						<span><%=dtos.getName() %></span>
					</div>
				<%} %>
				<!-- 사이드바 참여 포트폴리오 리스트 -->
				<% for(PortfolioDto dtos : portfolioList){%>
					<div class="sidebar_item portfolio_idx_<%=dtos.getPortfolioIdx() %>" portfolio_idx="<%=dtos.getPortfolioIdx() %>">
						<div class="PortfolioColorIcon PortfolioColorIcon--size20">
							<svg class="PortfolioColorIcon-duotoneBaseLayer ColorFillIcon ColorFillIcon--colorIndigo" viewBox="0 0 20 20" aria-labelledby="titlelui_43" role="img" focusable="false">
								<title id="titlelui_43">포트폴리오</title>
								<path d="M 0 2.5 C 0 1.65 0.65 1 1.5 1 H 7.7 C 7.9 1 8.05 1.1 8.15 1.3 L 9.6 4.2 C 9.85 4.7 10.35 5.05 10.95 5.05 H 18.5 C 19.35 5.05 20 5.7 20 6.55 V 16.55 C 20 17.95 18.9 19.05 17.5 19.05 H 2.5 C 1.1 19.05 0 17.95 0 16.55 V 2.5 Z"></path></svg>
							<svg style="fill: #dfdbff;" class="PortfolioColorIcon-duotoneTopLayer" viewBox="0 0 20 20" aria-hidden="true" focusable="false">
								<path d="M 1.5 1 C 0.65 1 0 1.65 0 2.5 V 7.5 C 0 6.65 0.65 6 1.5 6 H 18.5 C 19.35 6 20 6.65 20 7.5 V 6.5 C 20 5.65 19.35 5 18.5 5 H 10.95 C 10.4 5 9.85 4.7 9.6 4.15 L 8.15 1.25 C 8.05 1.1 7.9 1 7.7 1 H 1.5 Z"></path></svg>
						</div>
						<span><%=dtos.getName() %></span>
					</div>
				<% }%>
				<!--------------------------------- 사이드바 프로젝트/포트폴리오 참여중 리스트 ------------------------------------->
				<div class="category">
					<span>팀</span>
				</div>
				<div class="sidebar_item with_gt">
					<svg class="Icon SidebarItemIcon--iconWithoutCustomizationColor UserFillIcon" viewBox="0 0 32 32" aria-hidden="true" focusable="false">
						<path d="M31,30H11c-.552,0-1-.448-1-1v-2c0-3.866,3.134-7,7-7h8c3.866,0,7,3.134,7,7v2c0,.552-.448,1-1,1Zm-23-3c0-2.029,.676-3.901,1.814-5.407,.495-.656,.023-1.593-.799-1.593h-2.015c-3.866,0-7,3.134-7,7v2c0,.552,.448,1,1,1H7c.552,0,1-.448,1-1v-2ZM28.5,10c0-4.142-3.358-7.5-7.5-7.5s-7.5,3.358-7.5,7.5,3.358,7.5,7.5,7.5,7.5-3.358,7.5-7.5Zm-17,0c0-2.125,.698-4.087,1.878-5.67,.431-.579,.176-1.413-.522-1.594-1.074-.278-2.24-.324-3.45-.067-2.917,.619-5.248,2.996-5.779,5.93-.86,4.758,2.773,8.901,7.373,8.901,.632,0,1.245-.08,1.831-.23,.71-.181,.984-1.013,.546-1.601-1.179-1.582-1.877-3.544-1.877-5.669Z"></path></svg>
					<span>내 작업 공간</span>
					<svg class="MiniIcon--small MiniIcon SidebarFlyoutSplitDropdownButton-flyoutChevron ArrowRightMiniIcon" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
						<path d="M10.148 3.885A1.5 1.5 0 1 0 7.85 5.813l5.19 6.186-5.19 6.186a1.499 1.499 0 0 0 1.148 2.464c.428 0 .854-.182 1.15-.536l6-7.15a1.5 1.5 0 0 0 0-1.929l-6-7.149Z"></path></svg>
				</div>
				<div class="sidebar_item">
					<div>
						<svg
							class="Icon ButtonThemeablePresentation-leftIcon SidebarInvite-icon EmailIcon"
							viewBox="0 0 32 32" aria-hidden="true" focusable="false">
							<path
								d="M25.998 4h-20c-3.309 0-6 2.691-6 6v12c0 3.309 2.691 6 6 6h20c3.31 0 6-2.691 6-6V10c0-3.309-2.69-6-6-6Zm-20 2h20c.74 0 1.424.215 2.02.567L16.704 17.879a1 1 0 0 1-1.414 0L3.98 6.567A3.96 3.96 0 0 1 6 6Zm24 16c0 2.206-1.794 4-4 4h-20c-2.206 0-4-1.794-4-4V10c0-.74.215-1.424.567-2.019l11.312 11.313a2.993 2.993 0 0 0 2.121.876 2.99 2.99 0 0 0 2.121-.877L29.431 7.981A3.96 3.96 0 0 1 29.998 10v12Z"></path></svg>
						<span>팀원 초대</span>
					</div>
				</div>
			</div>
		</div>
		<!-- 사이드바 --><!-- 사이드바 --><!-- 사이드바 --><!-- 사이드바 --><!-- 사이드바 --><!-- 사이드바 --><!-- 사이드바 --><!-- 사이드바 -->

		<div id="main">
			<div id="main_outline">
				<div id="header">
					<div id="header1">
						<%for(PortfolioAllDto dto : portfolioAllDtolist){ 
							int portfolioIdx = dto.getPortfolioIdx();
							 PortfolioAllDto portfolioNameDto =portfolioDao.getPortfolioDto(portfolioIdx);
						%>
							<div id="employment">
								<svg class="MiniIcon PortfolioGenericMiniIcon"
									viewBox="0 0 24 24" aria-hidden="true" focusable="false">
							<path
										d="M21,6h-8.4c-0.2,0-0.3,0-0.5-0.1c-0.1-0.1-0.3-0.2-0.4-0.3L9.8,2.5C9.8,2.3,9.6,2.2,9.5,2.1S9.2,2,9,2H1C0.7,2,0.5,2.1,0.3,2.3C0.1,2.5,0,2.7,0,3v16c0,1.7,1.3,3,3,3h18c1.7,0,3-1.3,3-3V9C24,7.3,22.7,6,21,6z M2,4h6.4l1.2,2H2V4L2,4L2,4z M22,19c0,0.6-0.4,1-1,1H3c-0.6,0-1-0.4-1-1V8h19c0.6,0,1,0.4,1,1V19z"></path></svg>
								<span><%= portfolioNameDto.getName()%></span>
								<svg
									class="MiniIcon NavigationBreadcrumbContent-divider SlashMiniIcon"
									viewBox="0 0 24 24" aria-hidden="true" focusable="false">
							<path
										d="M16.21 1.837a1.002 1.002 0 0 0-1.307.541L7.25 20.856a1.001 1.001 0 0 0 1.848.766l7.654-18.478a1.001 1.001 0 0 0-.54-1.307Z"></path></svg>
							</div>
						<%}%>
						<div style="width: auto;" class="list-image">
							<img style="z-index: 4;" class="img-small"
								src="..\..\img01\짱구1.jpg"> <img
								style="z-index: 3; margin-left: -10px;" class="img-small"
								src="..\..\img01\짱구2.jpg"> <img
								style="z-index: 2; margin-left: -10px;" class="img-small"
								src="..\..\img01\철수.png">
						</div>
						<div id="share_button">
							<svg class="MiniIcon LockFillMiniIcon" viewBox="0 0 24 24"
								aria-hidden="true" focusable="false">
						<path
									d="M19.499 8h-1.5V6c0-3.309-2.691-6-6-6s-6 2.691-6 6v2h-1.5a2.503 2.503 0 0 0-2.5 2.5v9c0 1.378 1.121 2.5 2.5 2.5h15c1.379 0 2.5-1.122 2.5-2.5v-9c0-1.378-1.121-2.5-2.5-2.5Zm-3.5 0h-8V6c0-2.206 1.794-4 4-4s4 1.794 4 4v2Z"></path></svg>
							<span>공유</span>
						</div>
						<div id="horizontal_line"></div>
						<div id="customized">
							<img
								class="DeprecatedMiniIllustration DeprecatedMiniIllustration--smallMiniIcon ButtonThemeablePresentation-leftIcon"
								alt=""
								src="https://d3ki9tyy5l5ruj.cloudfront.net/obj/ce625ef5536516f31458c34d0c9d41457cae8470/customize_12.svg">
							<span>사용자 지정</span>
						</div>
					</div>
					<div id="header2">
						<img src="img01/초록색2.png"></img>
						<div id="project_title">
							<span>${projectAllDto.name}</span>
							<svg class="first_icon" style="margin-top: 7px;"
								viewBox="0 0 24 24" aria-hidden="true" focusable="false">
						<path
									d="m18.185 7.851-6.186 5.191-6.186-5.191a1.499 1.499 0 1 0-1.928 2.298l7.15 6a1.498 1.498 0 0 0 1.928 0l7.15-6a1.5 1.5 0 0 0-1.928-2.298Z"></path></svg>


							<!-- 별 html -->
							<!-- 별 html -->
							<!-- 별 html -->
							<!-- 별 html -->
							<!-- 별 html -->
							<div class="star-center" style="width: 25px; height: 25px;">
								<svg class="icon20-star" viewBox="0 0 32 32" aria-hidden="true"
									focusable="false" style="fill: gray;">
                           <path
										d="M.608 11.301a2.161 2.161 0 0 0 .538 2.224l5.867 5.78-1.386 8.164c-.14.824.192 1.637.868 2.124a2.133 2.133 0 0 0 2.262.155l7.241-3.848 7.24 3.848a2.133 2.133 0 0 0 2.263-.155 2.155 2.155 0 0 0 .868-2.124l-1.386-8.164 5.867-5.78c.59-.582.797-1.434.538-2.224a2.146 2.146 0 0 0-1.734-1.466l-8.1-1.19-3.623-7.42A2.148 2.148 0 0 0 15.998 0c-.828 0-1.57.476-1.935 1.223L10.44 8.645l-8.1 1.19A2.145 2.145 0 0 0 .606 11.3h.002Zm2.025.512 9.143-1.342 4.086-8.37c.012-.023.044-.088.137-.088.093 0 .124.064.137.089l4.086 8.369 9.143 1.342c.023.003.093.014.125.11a.163.163 0 0 1-.042.178l-6.609 6.511 1.56 9.192a.16.16 0 0 1-.065.169c-.074.054-.129.023-.152.01l-8.181-4.346-8.181 4.347c-.022.013-.08.04-.152-.011a.159.159 0 0 1-.065-.17l1.56-9.19-6.61-6.512a.163.163 0 0 1-.041-.178c.032-.096.102-.106.125-.11h-.004Z"></path></svg>
								<svg class="icon20-star-on" viewBox="0 0 32 32"
									aria-hidden="true" focusable="false">
                           <path
										d="m.938 12.86 6.47 6.394-1.526 9.022c-.096.56.131 1.113.592 1.444a1.47 1.47 0 0 0 1.556.105l7.969-4.247 7.969 4.247a1.465 1.465 0 0 0 1.557-.105c.46-.332.688-.885.593-1.443l-1.527-9.024 6.468-6.393c.402-.396.543-.974.368-1.51a1.47 1.47 0 0 0-1.188-1.002l-8.924-1.314L17.328.841C17.078.33 16.57.001 16 .001c-.569 0-1.076.329-1.326.84l-3.987 8.193-8.924 1.314A1.466 1.466 0 0 0 .575 11.35a1.467 1.467 0 0 0 .366 1.508l-.003.002Z"></path></svg>
							</div>
							<!-- 별 html -->
							<!-- 별 html -->
							<!-- 별 html -->
							<!-- 별 html -->
							<!-- 별 html -->

						</div>


						<!-- 상단바의 프로젝트 상태 업데이트  수정중 -->
						<div class="click_status_update header_click_status_update">
							<div class="circle"></div>
							<span id="status_update_span">상태 설정</span>
							<div class="DownIcon">
								<svg class="ArrowDown" viewBox="0 0 24 24" aria-hidden="true"
									focusable="false">
									<path
										d="m18.185 7.851-6.186 5.191-6.186-5.191a1.499 1.499 0 1 0-1.928 2.298l7.15 6a1.498 1.498 0 0 0 1.928 0l7.15-6a1.5 1.5 0 0 0-1.928-2.298Z"></path></svg>
							</div>
							<!--상태설정 체인지-->
							<div class="progress_change_green">
								<div class="green">
									<div class="green_circle">
										<svg class="status_green" viewBox="0 0 24 24"
											aria-hidden="true" focusable="false">
											<path
												d="m20,12c0,4.42-3.58,8-8,8s-8-3.58-8-8S7.58,4,12,4s8,3.58,8,8Z"></path></svg>
									</div>
									<div class="green_span">
										<span>계획대로 진행 중</span>
									</div>
								</div>
							</div>
							<div class="progress_change_yellow">
								<div class="yellow">
									<div class="yellow_circle">
										<svg class="status_yellow" viewBox="0 0 24 24"
											aria-hidden="true" focusable="false">
											<path
												d="m20,12c0,4.42-3.58,8-8,8s-8-3.58-8-8S7.58,4,12,4s8,3.58,8,8Z"></path></svg>
									</div>
									<div class="yellow_span">
										<span>위험함</span>
									</div>
								</div>
							</div>
							<div class="progress_change_red">
								<div class="red">
									<div class="red_circle">
										<svg class="status_red" viewBox="0 0 24 24" aria-hidden="true"
											focusable="false">
											<path
												d="m20,12c0,4.42-3.58,8-8,8s-8-3.58-8-8S7.58,4,12,4s8,3.58,8,8Z"></path></svg>
									</div>
									<div class="red_span">
										<span>계획에서 벗어남</span>
									</div>
								</div>
							</div>
							<div class="progress_change_blue">
								<div class="blue">
									<div class="blue_circle">
										<svg class="status_blue" viewBox="0 0 24 24"
											aria-hidden="true" focusable="false">
											<path
												d="m20,12c0,4.42-3.58,8-8,8s-8-3.58-8-8S7.58,4,12,4s8,3.58,8,8Z"></path></svg>
									</div>
									<div class="blue_span">
										<span>보류 중</span>
									</div>
								</div>
							</div>
							<div class="progress_change_complete">
								<div class="check">
									<div class="complete">
										<svg class="check_icon" viewBox="0 0 24 24" aria-hidden="true"
											focusable="false">
											<path
												d="M19.439 5.439 8 16.878l-3.939-3.939A1.5 1.5 0 1 0 1.94 15.06l5 5c.293.293.677.439 1.061.439.384 0 .768-.146 1.061-.439l12.5-12.5a1.5 1.5 0 1 0-2.121-2.121h-.002Z"></path></svg>
									</div>
									<div class="complete_span">
										<span>완료</span>
									</div>
								</div>
							</div>
							<!--상태설정 토글-->
							<div class="status_update_box">
								<div class="status">
									<div class="progress_green">
										<div class="green">
											<div class="green_circle">
												<svg class="status_green" viewBox="0 0 24 24"
													aria-hidden="true" focusable="false">
													<path
														d="m20,12c0,4.42-3.58,8-8,8s-8-3.58-8-8S7.58,4,12,4s8,3.58,8,8Z"></path></svg>
											</div>
											<div class="green_span">
												<span>계획대로 진행 중</span>
											</div>
										</div>
									</div>
									<div class="progress_yellow">
										<div class="yellow">
											<div class="yellow_circle">
												<svg class="status_yellow" viewBox="0 0 24 24"
													aria-hidden="true" focusable="false">
													<path
														d="m20,12c0,4.42-3.58,8-8,8s-8-3.58-8-8S7.58,4,12,4s8,3.58,8,8Z"></path></svg>
											</div>
											<div class="yellow_span">
												<span>위험함</span>
											</div>
										</div>
									</div>
									<div class="progress_red">
										<div class="red">
											<div class="red_circle">
												<svg class="status_red" viewBox="0 0 24 24"
													aria-hidden="true" focusable="false">
													<path
														d="m20,12c0,4.42-3.58,8-8,8s-8-3.58-8-8S7.58,4,12,4s8,3.58,8,8Z"></path></svg>
											</div>
											<div class="red_span">
												<span>계획에서 벗어남</span>
											</div>
										</div>
									</div>
									<div class="progress_blue">
										<div class="blue">
											<div class="blue_circle">
												<svg class="status_blue" viewBox="0 0 24 24"
													aria-hidden="true" focusable="false">
													<path
														d="m20,12c0,4.42-3.58,8-8,8s-8-3.58-8-8S7.58,4,12,4s8,3.58,8,8Z"></path></svg>
											</div>
											<div class="blue_span">
												<span>보류 중</span>
											</div>
										</div>
									</div>
								</div>
								<div class="check_move">
									<div class="progress_complete">
										<div class="check">
											<div class="complete">
												<svg class="check_icon" viewBox="0 0 24 24"
													aria-hidden="true" focusable="false">
													<path
														d="M19.439 5.439 8 16.878l-3.939-3.939A1.5 1.5 0 1 0 1.94 15.06l5 5c.293.293.677.439 1.061.439.384 0 .768-.146 1.061-.439l12.5-12.5a1.5 1.5 0 1 0-2.121-2.121h-.002Z"></path></svg>
											</div>
											<div class="complete_span">
												<span>완료</span>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
						<!--프로젝트 상태 업데이트  수정중 -->
					</div>
					<div id="header3">
						<div id="header3_item">
							<svg
								class="MiniIcon--small MiniIcon ObjectTabNavigationBarItemWithMenu-icon ProjectMiniIcon"
								aria-current="false" viewBox="0 0 24 24" aria-hidden="true"
								focusable="false">
						<path
									d="M 18 2 h -2 c 0 -1.1 -0.9 -2 -2 -2 h -4 C 8.9 0 8 0.9 8 2 H 6 C 3.8 2 2 3.8 2 6 v 14 c 0 2.2 1.8 4 4 4 h 12 c 2.2 0 4 -1.8 4 -4 V 6 C 22 3.8 20.2 2 18 2 Z M 10 2 h 4 l 0 1 c 0 0 0 0 0 0 s 0 0 0 0 l 0 1 h -4 V 2 Z M 20 20 c 0 1.1 -0.9 2 -2 2 H 6 c -1.1 0 -2 -0.9 -2 -2 V 6 c 0 -1.1 0.9 -2 2 -2 h 2 c 0 1.1 0.9 2 2 2 h 4 c 1.1 0 2 -0.9 2 -2 h 2 c 1.1 0 2 0.9 2 2 V 20 Z M 17 11 c 0 0.6 -0.4 1 -1 1 h -3.5 c -0.6 0 -1 -0.4 -1 -1 s 0.4 -1 1 -1 H 16 C 16.6 10 17 10.4 17 11 Z M 17 15 c 0 0.6 -0.4 1 -1 1 h -3.5 c -0.6 0 -1 -0.4 -1 -1 s 0.4 -1 1 -1 H 16 C 16.6 14 17 14.4 17 15 Z M 10 11 c 0 0.8 -0.7 1.5 -1.5 1.5 S 7 11.8 7 11 s 0.7 -1.5 1.5 -1.5 S 10 10.2 10 11 Z M 10 15 c 0 0.8 -0.7 1.5 -1.5 1.5 S 7 15.8 7 15 s 0.7 -1.5 1.5 -1.5 S 10 14.2 10 15 Z"></path></svg>
							<span class="over_view_button">개요</span>
						</div>
						<div id="header3_item">
							<svg
								class="MiniIcon--small MiniIcon ObjectTabNavigationBarItemWithMenu-icon ListViewMiniIcon"
								aria-current="true" viewBox="0 0 24 24" aria-hidden="true"
								focusable="false">
						<path
									d="M5 2H3C1.346 2 0 3.346 0 5v2c0 1.654 1.346 3 3 3h2c1.654 0 3-1.346 3-3V5c0-1.654-1.346-3-3-3Zm1 5c0 .551-.448 1-1 1H3c-.552 0-1-.449-1-1V5c0-.551.448-1 1-1h2c.552 0 1 .449 1 1v2Zm-1 7H3c-1.654 0-3 1.346-3 3v2c0 1.654 1.346 3 3 3h2c1.654 0 3-1.346 3-3v-2c0-1.654-1.346-3-3-3Zm1 5c0 .551-.448 1-1 1H3c-.552 0-1-.449-1-1v-2c0-.551.448-1 1-1h2c.552 0 1 .449 1 1v2Zm4-13a1 1 0 0 1 1-1h12a1 1 0 1 1 0 2H11a1 1 0 0 1-1-1Zm14 12a1 1 0 0 1-1 1H11a1 1 0 1 1 0-2h12a1 1 0 0 1 1 1Z"></path></svg>
							<span class="list_view_button">목록</span>
						</div>
						<div id="header3_item">
							<svg
								class="MiniIcon--small MiniIcon ObjectTabNavigationBarItemWithMenu-icon BoardMiniIcon"
								aria-current="false" viewBox="0 0 24 24" aria-hidden="true"
								focusable="false">
						<path
									d="M21,2h-4h-2H9H7H3C1.3,2,0,3.3,0,5v10c0,1.7,1.3,3,3,3h4v1c0,1.7,1.3,3,3,3h4c1.7,0,3-1.3,3-3v-3h4c1.7,0,3-1.3,3-3V5  C24,3.3,22.7,2,21,2z M3,16c-0.6,0-1-0.4-1-1V5c0-0.6,0.4-1,1-1h4v12H3z M15,19c0,0.6-0.4,1-1,1h-4c-0.6,0-1-0.4-1-1v-0.9V4h6v12.2  V19z M22,13c0,0.6-0.4,1-1,1h-4V4h4c0.6,0,1,0.4,1,1V13z"></path></svg>
							<span class="board_view_button">보드</span>
						</div>
						<div id="header3_item">
							<svg
								class="MiniIcon--small MiniIcon ObjectTabNavigationBarItemWithMenu-icon BoardMiniIcon"
								aria-current="false" viewBox="0 0 24 24" aria-hidden="true"
								focusable="false">
						<path
									d="M21,2h-4h-2H9H7H3C1.3,2,0,3.3,0,5v10c0,1.7,1.3,3,3,3h4v1c0,1.7,1.3,3,3,3h4c1.7,0,3-1.3,3-3v-3h4c1.7,0,3-1.3,3-3V5  C24,3.3,22.7,2,21,2z M3,16c-0.6,0-1-0.4-1-1V5c0-0.6,0.4-1,1-1h4v12H3z M15,19c0,0.6-0.4,1-1,1h-4c-0.6,0-1-0.4-1-1v-0.9V4h6v12.2  V19z M22,13c0,0.6-0.4,1-1,1h-4V4h4c0.6,0,1,0.4,1,1V13z"></path></svg>
							<span class="message_view_button">메세지</span>
						</div>
						<div id="header3_item">
							<svg
								class="MiniIcon--small MiniIcon ObjectTabNavigationBarItemWithMenu-icon AttachVerticalMiniIcon"
								aria-current="false" viewBox="0 0 24 24" aria-hidden="true"
								focusable="false">
						<path
									d="M14,24C10.7,24,8,21.3,8,18V8C8,5.8,9.8,4,12,4C14.2,4,16,5.8,16,8V16.9C16,17.5,15.6,17.9,15,17.9C14.4,17.9,14,17.5,14,16.9V8C14,6.9,13.1,6,12,6C10.9,6,10,6.9,10,8V18C10,20.2,11.8,22,14,22C16.2,22,18,20.2,18,18V8C18,4.7,15.3,2,12,2C8.7,2,6,4.7,6,8V13C6,13.6,5.6,14,5,14C4.4,14,4,13.6,4,13V8C4,3.6,7.6,0,12,0C16.4,0,20,3.6,20,8V18C20,21.3,17.3,24,14,24Z"></path></svg>
							<span class="file_view_button">파일</span>
						</div>
						<div id="header3_item">
							<svg
								class="MiniIcon--small MiniIcon ObjectTabNavigationBarItemWithMenu-icon DocumentMiniIcon"
								aria-current="false" viewBox="0 0 24 24" aria-hidden="true"
								focusable="false">
						<path
									d="M5.998 24h12c2.206 0 4-1.794 4-4V9.683a3.984 3.984 0 0 0-1.075-2.729L15.62 1.271A4 4 0 0 0 13.321.065.999.999 0 0 0 12.998 0c-.037 0-.068.017-.103.021-.067-.003-.133-.021-.2-.021H6C3.793 0 2 1.794 2 4v16c0 2.206 1.793 4 4 4Zm8-21.502c.053.046.11.086.158.138l5.008 5.365h-3.69c-.814 0-1.476-.648-1.476-1.444V2.498ZM3.998 4c0-1.103.897-2 2-2h6v4.556c0 1.899 1.56 3.444 3.475 3.444h4.525v10c0 1.103-.897 2-2 2h-12c-1.103 0-2-.897-2-2V4Z"></path></svg>
							<span class="memo_view_button">메모</span>
						</div>
						<div id="header3_item">
							<svg class="Icon PlusIcon" viewBox="0 0 32 32" aria-hidden="true"
								focusable="false">
								<path
									d="M26,14h-8V6c0-1.1-0.9-2-2-2l0,0c-1.1,0-2,0.9-2,2v8H6c-1.1,0-2,0.9-2,2l0,0c0,1.1,0.9,2,2,2h8v8c0,1.1,0.9,2,2,2l0,0c1.1,0,2-0.9,2-2v-8h8c1.1,0,2-0.9,2-2l0,0C28,14.9,27.1,14,26,14z"></path></svg>
						</div>
					</div>
				</div>

				<div id="main_content">
					<div class="page_tool_bar">
						<div class="page_tool_bar_left">
							<div class="work_add">
								<div class="work_add_left">
									<svg
										class="HighlightSol HighlightSol--core MiniIcon ButtonThemeablePresentation-leftIcon PlusMiniIcon"
										viewBox="0 0 24 24" aria-hidden="true" focusable="false">
										<path
											d="M10,10V4c0-1.1,0.9-2,2-2s2,0.9,2,2v6h6c1.1,0,2,0.9,2,2s-0.9,2-2,2h-6v6c0,1.1-0.9,2-2,2s-2-0.9-2-2v-6H4c-1.1,0-2-0.9-2-2s0.9-2,2-2H10z"></path></svg>
									<span>작업추가</span>
								</div>
								<div class="work_add_right">
									<svg
										class="HighlightSol HighlightSol--core MiniIcon ButtonThemeablePresentation-leftIcon ArrowDownMiniIcon"
										viewBox="0 0 24 24" aria-hidden="true" focusable="false">
										<path
											d="m18.185 7.851-6.186 5.191-6.186-5.191a1.499 1.499 0 1 0-1.928 2.298l7.15 6a1.498 1.498 0 0 0 1.928 0l7.15-6a1.5 1.5 0 0 0-1.928-2.298Z"></path></svg>
								</div>
							</div>
						</div>
						<div class="filtering_menu">
							<div class="filtering_menu_child">
								<svg
									class="HighlightSol HighlightSol--core MiniIcon ButtonThemeablePresentation-leftIcon FilterMiniIcon"
									viewBox="0 0 24 24" aria-hidden="true" focusable="false">
									<path
										d="M24 5a1 1 0 0 1-1 1H1a1 1 0 1 1 0-2h22a1 1 0 0 1 1 1Zm-4 7H4a1 1 0 1 0 0 2h16a1 1 0 1 0 0-2Zm-3 8H7a1 1 0 1 0 0 2h10a1 1 0 1 0 0-2Z"></path></svg>
								필터링
							</div>
							<div class="filtering_menu_child">
								<svg
									class="HighlightSol HighlightSol--core MiniIcon ButtonThemeablePresentation-leftIcon SortMiniIcon"
									viewBox="0 0 24 24" aria-hidden="true" focusable="false">
									<path
										d="M17.999 5v13h3a1 1 0 0 1 .707 1.707l-4 4a.997.997 0 0 1-1.414 0l-4-4A1 1 0 0 1 12.999 18h3V5a1 1 0 1 1 2 0Zm-15.924.383A1 1 0 0 0 2.999 6h3v13a1 1 0 1 0 2 0V6h3a1 1 0 0 0 .707-1.707l-4-4a.999.999 0 0 0-1.414 0l-4 4a1 1 0 0 0-.217 1.09Z"></path></svg>
								정렬
							</div>
							<div class="filtering_menu_child">
								<svg
									class="HighlightSol HighlightSol--core MiniIcon ButtonThemeablePresentation-leftIcon GroupByMiniIcon"
									viewBox="0 0 24 24" aria-hidden="true" focusable="false">
									<path
										d="M5.454 22h13.09A3.455 3.455 0 0 0 22 18.545V5.455A3.455 3.455 0 0 0 18.544 2H5.454A3.455 3.455 0 0 0 2 5.455v13.091A3.454 3.454 0 0 0 5.454 22ZM4 5.455C4 4.653 4.651 4 5.454 4h13.091C19.348 4 20 4.652 20 5.455v13.092c0 .802-.652 1.455-1.455 1.455H5.455a1.456 1.456 0 0 1-1.456-1.455V5.455ZM6.5 9a1.5 1.5 0 1 1 3.001.001A1.5 1.5 0 0 1 6.5 9Zm5 0a1 1 0 0 1 1-1H17a1 1 0 1 1 0 2h-4.5a1 1 0 0 1-1-1Zm-5 6a1.5 1.5 0 1 1 3.001.001 1.5 1.5 0 0 1-3-.001Zm5 0a1 1 0 0 1 1-1H17a1 1 0 1 1 0 2h-4.5a1 1 0 0 1-1-1Z"></path></svg>
								그룹
							</div>
							<div class="filtering_menu_child">
								<svg
									class="HighlightSol HighlightSol--core MiniIcon ButtonThemeablePresentation-leftIcon SettingsMiniIcon"
									viewBox="0 0 24 24" aria-hidden="true" focusable="false">
									<path
										d="M20.999 16H9.894a5.005 5.005 0 0 0-4.895-4c-2.757 0-5 2.243-5 5s2.243 5 5 5a5.005 5.005 0 0 0 4.895-4h11.105a1 1 0 1 0 0-2Zm-16 4c-1.654 0-3-1.346-3-3s1.346-3 3-3 3 1.346 3 3-1.346 3-3 3Zm14-18a5.005 5.005 0 0 0-4.895 4H2.999a1 1 0 1 0 0 2h11.105a5.005 5.005 0 0 0 4.895 4c2.757 0 5-2.243 5-5s-2.243-5-5-5Zm0 8c-1.654 0-3-1.346-3-3s1.346-3 3-3 3 1.346 3 3-1.346 3-3 3Z"></path></svg>
								옵션
							</div>
						</div>
					</div>
					<div class="scrollable_withCompositingLayer">
						<!-- 반복될 섹션 div  -->
						<!-- 반복될 섹션 div  -->
						<!-- 반복될 섹션 div  -->
						<div class="boardcolumn_boardBody">
							<div class="boardcolumn_header">
								<div class="boardcolumn_header_title">완료</div>
								<div class="boardcolumn_header_count">${completecount}</div>
								<!-- <div class="boardcolumn_header_plusIcon">
									<svg class="HighlightSol HighlightSol--core Icon PlusIcon"
										viewBox="0 0 32 32" aria-hidden="true" focusable="false">
										<path
											d="M26,14h-8V6c0-1.1-0.9-2-2-2l0,0c-1.1,0-2,0.9-2,2v8H6c-1.1,0-2,0.9-2,2l0,0c0,1.1,0.9,2,2,2h8v8c0,1.1,0.9,2,2,2l0,0c1.1,0,2-0.9,2-2v-8h8c1.1,0,2-0.9,2-2l0,0C28,14.9,27.1,14,26,14z"></path></svg>
								</div> -->
							</div>
							<div class="board_card_layout_body">
								<div class="complete_div_parent">
								<!-- 완료섹션의 wam list  --> <!-- 완료섹션의 wam list  --> <!-- 완료섹션의 wam list  -->
									<%for(WamAllDto dto : completedSectionWamList){ %>
										<div class="board_card_layout" wamidx="<%=dto.getWamIdx()%>">
											<div class="board_card_layout_header">
												<div class="board_card_layout_header_miliestoneIcon">
													<svg class="work_type" viewBox="0 0 32 32" aria-hidden="true" focusable="false">
														<path d="M31,16c0,8.3-6.7,15-15,15S1,24.3,1,16S7.7,1,16,1S31,7.7,31,16z" class="CompoundIcon-outer" style="fill:#5da283; stroke:#5da283;"></path>
														<path d="M13.4,22.1c-0.3,0-0.5-0.1-0.7-0.3l-3.9-3.9c-0.4-0.4-0.4-1,0-1.4s1-0.4,1.4,0l3.1,3.1l8.1-8.1c0.4-0.4,1-0.4,1.4,0   s0.4,1,0,1.4l-8.9,8.9C13.9,22,13.7,22.1,13.4,22.1z" class="CompoundIcon-inner" style="fill:#f5f4f3;"></path>
													</svg>
												</div>
												<div class="board_card_layout_header_title"><%=dto.getTitle() %></div>
											</div>
											<div class="boardcardLayout_assigneeduedateactions">
												<div
													class="boardcardLayout_assigneeduedateactions_profile_img">
													<%int memberIdx = dto.getManagerIdx(); //담당자 idx 
													MemberAllDto memberAllDto = memberDao.getMemberAllDto(memberIdx);
													%>
													<img src="img01/<%=memberAllDto.getProfileImg()%>"/>
												</div>
												<div class="boardcardLayout_assigneeduedateactions_deadline">
													<%String deadlineDate = dto.getDeadlineDate();  //마감일 
													  String deadlineDateFormat = null;
													  if(deadlineDate!=null){
														  Date projectStatusDate01 = formatter1.parse(deadlineDate.split(" ")[0]);
														  deadlineDateFormat = formatter2.format( projectStatusDate01);
													  }
													  if(deadlineDateFormat!=null){%>
													  	<%=deadlineDateFormat%>
													 <% }else{ %>
													 	<div class="manager_generation_div">
													 		<svg class="HighlightSol HighlightSol--core MiniIcon CalendarMiniIcon" viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path d="M19.1,2H18V1c0-0.6-0.4-1-1-1s-1,0.4-1,1v1H8V1c0-0.6-0.4-1-1-1S6,0.4,6,1v1H4.9C2.2,2,0,4.2,0,6.9v12.1  C0,21.8,2.2,24,4.9,24h14.1c2.7,0,4.9-2.2,4.9-4.9V6.9C24,4.2,21.8,2,19.1,2z M4.9,4H6v1c0,0.6,0.4,1,1,1s1-0.4,1-1V4h8v1  c0,0.6,0.4,1,1,1s1-0.4,1-1V4h1.1C20.7,4,22,5.3,22,6.9V8H2V6.9C2,5.3,3.3,4,4.9,4z M19.1,22H4.9C3.3,22,2,20.7,2,19.1V10h20v9.1  C22,20.7,20.7,22,19.1,22z"></path></svg>
														</div>
													 <% }%>
												</div>
											</div>
									  </div>
									<%}%>
								</div>
								<!-- 완료섹션의 wam list  --> <!-- 완료섹션의 wam list  --> <!-- 완료섹션의 wam list  -->
							</div>
						</div>
						<!-- 반복될 섹션 div  -->
						<!-- 반복될 섹션 div  -->
						<!-- 반복될 섹션 div  -->
						<div class="boardcolumn_boardBody">
							<div class="boardcolumn_header">
								<div class="boardcolumn_header_title">수행중</div>
								<div class="boardcolumn_header_count">${runningcount}</div>
								<div class="boardcolumn_header_plusIcon">
									<svg class="HighlightSol HighlightSol--core Icon PlusIcon"
										viewBox="0 0 32 32" aria-hidden="true" focusable="false">
										<path
											d="M26,14h-8V6c0-1.1-0.9-2-2-2l0,0c-1.1,0-2,0.9-2,2v8H6c-1.1,0-2,0.9-2,2l0,0c0,1.1,0.9,2,2,2h8v8c0,1.1,0.9,2,2,2l0,0c1.1,0,2-0.9,2-2v-8h8c1.1,0,2-0.9,2-2l0,0C28,14.9,27.1,14,26,14z"></path></svg>
								</div>
							</div>
							<div class="board_card_layout_body">
								<div class="performing_div_parent">
									<%
										for(WamAllDto runningdto : runningwamAllDtoList){%>
										<div class="board_card_layout" wamidx="<%=runningdto.getWamIdx()%>">
											<div class="board_card_layout_header">
												<div class="board_card_layout_header_miliestoneIcon">
													<% WamDao wamdao = new WamDao();
													   ArrayList<WamAllDto> wamdtolist = wamdao.precedingWamGet(runningdto.getWamIdx());
													   if(wamdtolist.size()>0){ %>
													   	<svg class="preceding_check_svg" viewBox="0 0 32 32" aria-hidden="true" focusable="false">
															<path d="M29 28h-3v-4.677c0-1.895-.887-3.687-2.369-4.793a20.347 20.347 0 0 0-4.517-2.529 20.358 20.358 0 0 0 4.516-2.529C25.113 12.366 26 10.574 26 8.678V4.001h3a1 1 0 1 0 0-2H3a1 1 0 1 0 0 2h3v4.677c0 1.895.885 3.687 2.367 4.793A20.347 20.347 0 0 0 12.884 16a20.358 20.358 0 0 0-4.516 2.53C6.885 19.634 6 21.426 6 23.322V28H3a1 1 0 1 0 0 2h26a1 1 0 1 0 0-2ZM9.562 11.868C8.584 11.137 8 9.944 8 8.677V4h16v4.677c0 1.267-.585 2.46-1.564 3.191-1.928 1.438-4.035 2.454-6.436 3.099-2.4-.645-4.509-1.661-6.436-3.099ZM24 28H8v-4.677c0-1.267.585-2.46 1.564-3.191 1.928-1.438 4.035-2.454 6.436-3.099 2.401.645 4.51 1.66 6.436 3.098.98.731 1.564 1.924 1.564 3.191V28Z"></path>
														</svg>
													  <% }else{%>
														<!-- 선행있을시 모래시꼐 jsp 처리 2/1 -->
														<svg class="work_type" viewBox="0 0 32 32" aria-hidden="true" focusable="false">
															<path d="M31,16c0,8.3-6.7,15-15,15S1,24.3,1,16S7.7,1,16,1S31,7.7,31,16z" class="CompoundIcon-outer"></path>
															<path d="M13.4,22.1c-0.3,0-0.5-0.1-0.7-0.3l-3.9-3.9c-0.4-0.4-0.4-1,0-1.4s1-0.4,1.4,0l3.1,3.1l8.1-8.1c0.4-0.4,1-0.4,1.4,0   s0.4,1,0,1.4l-8.9,8.9C13.9,22,13.7,22.1,13.4,22.1z" class="CompoundIcon-inner"></path>
														</svg>
													<% } %>
												</div>
												<div class="board_card_layout_header_title"><%=runningdto.getTitle() %></div>
											</div>
											<div class="boardcardLayout_assigneeduedateactions">
												<div
													class="boardcardLayout_assigneeduedateactions_profile_img">
													<%int memberIdx = runningdto.getManagerIdx(); //담당자 idx 
													MemberAllDto memberAllDto = memberDao.getMemberAllDto(memberIdx);
													%>
													<img src="img01/<%=memberAllDto.getProfileImg()%>"/>
												</div>
												<div class="boardcardLayout_assigneeduedateactions_deadline">
													<%String deadlineDate02 = runningdto.getDeadlineDate();  //마감일 
													  String deadlineDateFormat02 = null;
													  if(deadlineDate02!=null){
														  Date projectStatusDate02 = formatter1.parse(deadlineDate02.split(" ")[0]);
														  deadlineDateFormat02 = formatter2.format(projectStatusDate02);
													  }
													  if(deadlineDateFormat02!=null){%>
													  	<%=deadlineDateFormat02%>
													 <% }else{ %>
													 	<div class="manager_generation_div">
													 		<svg class="HighlightSol HighlightSol--core MiniIcon CalendarMiniIcon" viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path d="M19.1,2H18V1c0-0.6-0.4-1-1-1s-1,0.4-1,1v1H8V1c0-0.6-0.4-1-1-1S6,0.4,6,1v1H4.9C2.2,2,0,4.2,0,6.9v12.1  C0,21.8,2.2,24,4.9,24h14.1c2.7,0,4.9-2.2,4.9-4.9V6.9C24,4.2,21.8,2,19.1,2z M4.9,4H6v1c0,0.6,0.4,1,1,1s1-0.4,1-1V4h8v1  c0,0.6,0.4,1,1,1s1-0.4,1-1V4h1.1C20.7,4,22,5.3,22,6.9V8H2V6.9C2,5.3,3.3,4,4.9,4z M19.1,22H4.9C3.3,22,2,20.7,2,19.1V10h20v9.1  C22,20.7,20.7,22,19.1,22z"></path></svg>
														</div>
													 <% }%>
												</div>
											</div>
									  </div>
								<%}%>
								</div>
							</div>
						</div>
						<!-- 모두 섹션의 wam 리스트들  -->
						
						 
						<div class="boardcolumn_boardBody">
							<div class="boardcolumn_header">
								<div class="boardcolumn_header_title">모두</div>
								<div class="boardcolumn_header_count">${allcount}</div>
								<!-- <div class="boardcolumn_header_plusIcon">
									<svg class="HighlightSol HighlightSol--core Icon PlusIcon"
										viewBox="0 0 32 32" aria-hidden="true" focusable="false">
										<path
											d="M26,14h-8V6c0-1.1-0.9-2-2-2l0,0c-1.1,0-2,0.9-2,2v8H6c-1.1,0-2,0.9-2,2l0,0c0,1.1,0.9,2,2,2h8v8c0,1.1,0.9,2,2,2l0,0c1.1,0,2-0.9,2-2v-8h8c1.1,0,2-0.9,2-2l0,0C28,14.9,27.1,14,26,14z"></path></svg>
								</div> -->
							</div>
							<div class="board_card_layout_body">
								<div class="every_div_parent">
									<%
										for(WamAllDto wamAllSectionDto : wamAllSectionlist){%>
										<div class="board_card_layout" wamidx="<%=wamAllSectionDto.getWamIdx()%>">
											<div class="board_card_layout_header">
												<div class="board_card_layout_header_miliestoneIcon">
												<%if(wamAllSectionDto.getCompleteDate()!= null){ %>
													<svg class="work_type" viewBox="0 0 32 32" aria-hidden="true" focusable="false">
														<path d="M31,16c0,8.3-6.7,15-15,15S1,24.3,1,16S7.7,1,16,1S31,7.7,31,16z" class="CompoundIcon-outer" style="fill:#5da283; stroke:#5da283"></path>
														<path d="M13.4,22.1c-0.3,0-0.5-0.1-0.7-0.3l-3.9-3.9c-0.4-0.4-0.4-1,0-1.4s1-0.4,1.4,0l3.1,3.1l8.1-8.1c0.4-0.4,1-0.4,1.4,0   s0.4,1,0,1.4l-8.9,8.9C13.9,22,13.7,22.1,13.4,22.1z" class="CompoundIcon-inner" style="fill:#f5f4f3;"></path>
													</svg>
													<%}else{ 
														WamDao wamdao = new WamDao();
														ArrayList<WamAllDto> wamdtolist = wamdao.precedingWamGet(wamAllSectionDto.getWamIdx());
														if(wamdtolist.size()>0){%>
													   	<svg class="preceding_check_svg" viewBox="0 0 32 32" aria-hidden="true" focusable="false">
															<path d="M29 28h-3v-4.677c0-1.895-.887-3.687-2.369-4.793a20.347 20.347 0 0 0-4.517-2.529 20.358 20.358 0 0 0 4.516-2.529C25.113 12.366 26 10.574 26 8.678V4.001h3a1 1 0 1 0 0-2H3a1 1 0 1 0 0 2h3v4.677c0 1.895.885 3.687 2.367 4.793A20.347 20.347 0 0 0 12.884 16a20.358 20.358 0 0 0-4.516 2.53C6.885 19.634 6 21.426 6 23.322V28H3a1 1 0 1 0 0 2h26a1 1 0 1 0 0-2ZM9.562 11.868C8.584 11.137 8 9.944 8 8.677V4h16v4.677c0 1.267-.585 2.46-1.564 3.191-1.928 1.438-4.035 2.454-6.436 3.099-2.4-.645-4.509-1.661-6.436-3.099ZM24 28H8v-4.677c0-1.267.585-2.46 1.564-3.191 1.928-1.438 4.035-2.454 6.436-3.099 2.401.645 4.51 1.66 6.436 3.098.98.731 1.564 1.924 1.564 3.191V28Z"></path>
														</svg>
													  <% }else{%>
														<!-- 선행있을시 모래시꼐 jsp 처리 2/1 -->
														<svg class="work_type" viewBox="0 0 32 32" aria-hidden="true" focusable="false">
															<path d="M31,16c0,8.3-6.7,15-15,15S1,24.3,1,16S7.7,1,16,1S31,7.7,31,16z" class="CompoundIcon-outer"></path>
															<path d="M13.4,22.1c-0.3,0-0.5-0.1-0.7-0.3l-3.9-3.9c-0.4-0.4-0.4-1,0-1.4s1-0.4,1.4,0l3.1,3.1l8.1-8.1c0.4-0.4,1-0.4,1.4,0   s0.4,1,0,1.4l-8.9,8.9C13.9,22,13.7,22.1,13.4,22.1z" class="CompoundIcon-inner"></path>
														</svg>
													<% } 
													}
													%>
												</div>
												<div class="board_card_layout_header_title"><%=wamAllSectionDto.getTitle() %></div>
											</div>
											<div class="boardcardLayout_assigneeduedateactions">
												<div
													class="boardcardLayout_assigneeduedateactions_profile_img">
													<%int memberIdx = wamAllSectionDto.getManagerIdx(); //담당자 idx 
													MemberAllDto memberAllDto = memberDao.getMemberAllDto(memberIdx);
													%>
													<img src="img01/<%=memberAllDto.getProfileImg() %>" />
												</div>
												<div class="boardcardLayout_assigneeduedateactions_deadline">
													<%String deadlineDate03 = wamAllSectionDto.getDeadlineDate();  //마감일 
													  String deadlineDateFormat03 = null;
													  if(deadlineDate03!=null){
														  Date projectStatusDate03 = formatter1.parse(deadlineDate03.split(" ")[0]);
														  deadlineDateFormat03 = formatter2.format(projectStatusDate03);
													  }
													  if(deadlineDateFormat03!=null){%>
													  	<%=deadlineDateFormat03%>
													 <% }else{ %>
													 	<div class="manager_generation_div">
													 		<svg class="HighlightSol HighlightSol--core MiniIcon CalendarMiniIcon" viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path d="M19.1,2H18V1c0-0.6-0.4-1-1-1s-1,0.4-1,1v1H8V1c0-0.6-0.4-1-1-1S6,0.4,6,1v1H4.9C2.2,2,0,4.2,0,6.9v12.1  C0,21.8,2.2,24,4.9,24h14.1c2.7,0,4.9-2.2,4.9-4.9V6.9C24,4.2,21.8,2,19.1,2z M4.9,4H6v1c0,0.6,0.4,1,1,1s1-0.4,1-1V4h8v1  c0,0.6,0.4,1,1,1s1-0.4,1-1V4h1.1C20.7,4,22,5.3,22,6.9V8H2V6.9C2,5.3,3.3,4,4.9,4z M19.1,22H4.9C3.3,22,2,20.7,2,19.1V10h20v9.1  C22,20.7,20.7,22,19.1,22z"></path></svg>
														</div>
													 <% }%>
												</div>
											</div>
									  </div>
									<%}%>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<!-- 마일스톤 상세 페이지 --><!-- 마일스톤 상세 페이지 --><!-- 마일스톤 상세 페이지 -->
		<div class="milestone" wamidx="">
			<div class="milestone_transparent_screen"></div>
			<div class="milestone_header">
				<div class="complete_btn">
					<svg
						class="MiniIcon ButtonThemeablePresentation-leftIcon CheckMiniIcon"
						viewBox="0 0 24 24" aria-hidden="true" focusable="false">
										<path
							d="M19.439 5.439 8 16.878l-3.939-3.939A1.5 1.5 0 1 0 1.94 15.06l5 5c.293.293.677.439 1.061.439.384 0 .768-.146 1.061-.439l12.5-12.5a1.5 1.5 0 1 0-2.121-2.121h-.002Z"></path></svg>
					<span>완료됨</span>
				</div>
				<div class="milestone_header_right">
					<div>
						<svg
							class="Icon ButtonThemeablePresentation-rightIcon ThumbsUpLineIcon"
							viewBox="0 0 32 32" aria-hidden="true" focusable="false">
											<path
								d="M5 28h19.94a3.987 3.987 0 0 0 3.961-3.395l1.552-10.03a3.96 3.96 0 0 0-.909-3.187 3.962 3.962 0 0 0-3.01-1.384H20V4.006C20 2.045 18.71.469 16.785.084c-1.918-.383-3.723.573-4.477 2.383l-3.975 9.536H5c-1.654 0-3 1.345-3 2.999V25c0 1.654 1.346 3 3 3Zm5-14.8 4.154-9.969c.465-1.116 1.5-1.341 2.238-1.191.742.148 1.608.751 1.608 1.961V12h8.532c.574 0 1.118.25 1.492.687.374.437.54 1.012.451 1.58l-1.552 10.032A1.997 1.997 0 0 1 24.94 26H10V13.2H10ZM4 15c0-.551.448-1 1-1h3v12H5c-.552 0-1-.449-1-1V15Z"></path></svg>
					</div>
					<div>
						<svg class="Icon AttachVerticalIcon" viewBox="0 0 32 32"
							aria-hidden="true" focusable="false">
											<path
								d="M19,32c-3.9,0-7-3.1-7-7V10c0-2.2,1.8-4,4-4s4,1.8,4,4v9c0,0.6-0.4,1-1,1s-1-0.4-1-1v-9c0-1.1-0.9-2-2-2s-2,0.9-2,2v15c0,2.8,2.2,5,5,5s5-2.2,5-5V10c0-4.4-3.6-8-8-8s-8,3.6-8,8v5c0,0.6-0.4,1-1,1s-1-0.4-1-1v-5C6,4.5,10.5,0,16,0s10,4.5,10,10v15C26,28.9,22.9,32,19,32z"></path></svg>
					</div>
					<div>
						<svg class="Icon SubtaskIcon" viewBox="0 0 32 32"
							aria-hidden="true" focusable="false">
											<path
								d="M25,20c-2.4,0-4.4,1.7-4.9,4H11c-3.9,0-7-3.1-7-7v-5h16.1c0.5,2.3,2.5,4,4.9,4c2.8,0,5-2.2,5-5s-2.2-5-5-5c-2.4,0-4.4,1.7-4.9,4H4V3c0-0.6-0.4-1-1-1S2,2.4,2,3v14c0,5,4,9,9,9h9.1c0.5,2.3,2.5,4,4.9,4c2.8,0,5-2.2,5-5S27.8,20,25,20z M25,8c1.7,0,3,1.3,3,3s-1.3,3-3,3s-3-1.3-3-3S23.3,8,25,8z M25,28c-1.7,0-3-1.3-3-3s1.3-3,3-3s3,1.3,3,3S26.7,28,25,28z"></path></svg>
					</div>
					<div>
						<svg class="Icon LinkIcon" viewBox="0 0 32 32" aria-hidden="true"
							focusable="false">
											<path
								d="M19.365 12.636a8.94 8.94 0 0 1 2.636 6.366 8.945 8.945 0 0 1-2.636 6.366l-4.001 4a8.976 8.976 0 0 1-6.366 2.634 8.976 8.976 0 0 1-6.366-2.634c-3.51-3.51-3.51-9.22 0-12.73l3.658-3.659a.999.999 0 1 1 1.414 1.415l-3.658 3.658a7.01 7.01 0 0 0 0 9.901c2.73 2.73 7.173 2.732 9.903 0l4.001-4a7.01 7.01 0 0 0 0-9.902 6.925 6.925 0 0 0-2.877-1.739 1 1 0 0 1 .592-1.91 9.019 9.019 0 0 1 3.699 2.235l.001-.002ZM29.368 2.633c-3.511-3.51-9.221-3.51-12.732 0l-4.001 4A8.94 8.94 0 0 0 9.999 13c0 2.405.936 4.665 2.636 6.367a9.019 9.019 0 0 0 3.699 2.235 1.001 1.001 0 0 0 .592-1.911 6.925 6.925 0 0 1-2.877-1.738 7.01 7.01 0 0 1 0-9.903l4.001-4c2.731-2.73 7.174-2.73 9.903 0 2.729 2.728 2.73 7.171 0 9.902l-3.658 3.657a.999.999 0 1 0 1.414 1.415l3.658-3.659c3.51-3.51 3.51-9.22 0-12.73l.001-.002Z"></path></svg>
					</div>
					<div>
						<svg class="Icon ButtonThemeablePresentation-leftIcon ExpandIcon"
							viewBox="0 0 32 32" aria-hidden="true" focusable="false">
											<path
								d="M13.7,19.7L5.4,28H13c0.6,0,1,0.4,1,1s-0.4,1-1,1H3c-0.6,0-1-0.4-1-1V19c0-0.6,0.4-1,1-1s1,0.4,1,1v7.6l8.3-8.3c0.4-0.4,1-0.4,1.4,0S14.1,19.3,13.7,19.7z M29,2H19c-0.6,0-1,0.4-1,1s0.4,1,1,1h7.6l-8.3,8.3c-0.4,0.4-0.4,1,0,1.4c0.2,0.2,0.5,0.3,0.7,0.3s0.5-0.1,0.7-0.3L28,5.4V13c0,0.6,0.4,1,1,1s1-0.4,1-1V3C30,2.4,29.6,2,29,2z"></path></svg>
					</div>
					<div>
						<svg class="HighlightSol Icon MoreIcon" viewBox="0 0 32 32"
							aria-hidden="true" focusable="false">
											<path
								d="M16,13c1.7,0,3,1.3,3,3s-1.3,3-3,3s-3-1.3-3-3S14.3,13,16,13z M3,13c1.7,0,3,1.3,3,3s-1.3,3-3,3s-3-1.3-3-3S1.3,13,3,13z M29,13c1.7,0,3,1.3,3,3s-1.3,3-3,3s-3-1.3-3-3S27.3,13,29,13z"></path></svg>
					</div>
					<div>
						<svg class="HighlightSol Icon CloseIcon" viewBox="0 0 32 32"
							aria-hidden="true" focusable="false">
											<path
								d="M3 15h18.379L13.94 7.561a1.5 1.5 0 1 1 2.121-2.121l10 10a1.5 1.5 0 0 1 0 2.121l-10 10A1.495 1.495 0 0 1 15 28a1.5 1.5 0 0 1-1.061-2.56l7.439-7.439H3a1.5 1.5 0 1 1 0-3V15ZM30.5 2.5A1.5 1.5 0 0 0 29 4v25a1.5 1.5 0 1 0 3 0V4a1.5 1.5 0 0 0-1.5-1.5Z"></path></svg>
					</div>
				</div>
			</div>
			<div class="milestone_content">
				<div class="milestone_content_child01">
					<div class="milestone_content_child01_02">
						<svg
							class="CompoundIcon--small CompoundIcon MilestoneCompletionCompoundIcon MilestoneCompletionStatusIndicator--complete MilestoneCompletionStatusIndicator MilestoneIndicator--complete MilestoneIndicator-icon"
							data-testid="milestone_completion_status_indicator"
							viewBox="0 0 32 32" aria-hidden="true" focusable="false">
											<path
								d="M20.1,2.8c-2.3-2.3-5.9-2.3-8.2,0L2.7,12c-2.3,2.3-2.3,5.9,0,8.2l9.2,9.2c2.3,2.3,5.9,2.3,8.2,0l9.2-9.2  c2.3-2.3,2.3-5.9,0-8.2L20.1,2.8z"
								class="CompoundIcon-outer"></path>
											<path
								d="M13.4,22.2c-0.3,0-0.5-0.1-0.7-0.3L8.8,18c-0.4-0.4-0.4-1,0-1.4s1-0.4,1.4,0l3.1,3.1l8.1-8.1c0.4-0.4,1-0.4,1.4,0   s0.4,1,0,1.4l-8.9,8.9C13.9,22.1,13.7,22.2,13.4,22.2z"
								class="CompoundIcon-inner"></path></svg>
						<span>마일스톤</span>
					</div>
					<div class="milestone_content_child01_03">
						<div class="milestone_content_title">
							<input type="text" name="milestone_content_title" value="마일스톤 제목" />
						</div>
					</div>

				</div>
				<div class="milestone_content_child02">
					<div class="rowstructure">
						<div class="rowstructure_title">
							<span>담당자</span>
						</div>
						<div class="manager_right" manageridx="">
							<div class="manager_right_img">
								<img src="img01/철수.png"></img>
							</div>
							<span>현우</span>
							<svg class="wam_contact_person_svg" viewBox="0 0 24 24"
								aria-hidden="true" focusable="false">
												<path
									d="M14.5,12l6-6C20.8,5.7,21,5.2,21,4.8s-0.2-0.9-0.5-1.2C20.1,3.2,19.7,3,19.2,3S18.3,3.2,18,3.5l-6,6l-6-6 C5.7,3.2,5.2,3,4.8,3S3.9,3.2,3.5,3.5C3.2,3.9,3,4.3,3,4.8S3.2,5.7,3.5,6l6,6l-6,6c-0.7,0.7-0.7,1.8,0,2.5C3.9,20.8,4.3,21,4.8,21 s0.9-0.2,1.2-0.5l6-6l6,6c0.3,0.3,0.8,0.5,1.2,0.5s0.9-0.2,1.2-0.5c0.7-0.7,0.7-1.8,0-2.5L14.5,12z"></path></svg>
						</div>
						<div class="no_contact_person">
							<div class="no_contact_person_UserIcon">
								<svg class="HighlightSol HighlightSol--core Icon UserIcon"
									viewBox="0 0 32 32" aria-hidden="true" focusable="false">
													<path
										d="M16,18c-4.4,0-8-3.6-8-8s3.6-8,8-8s8,3.6,8,8S20.4,18,16,18z M16,4c-3.3,0-6,2.7-6,6s2.7,6,6,6s6-2.7,6-6S19.3,4,16,4z M29,32c-0.6,0-1-0.4-1-1v-4.2c0-2.6-2.2-4.8-4.8-4.8H8.8C6.2,22,4,24.2,4,26.8V31c0,0.6-0.4,1-1,1s-1-0.4-1-1v-4.2C2,23,5,20,8.8,20h14.4c3.7,0,6.8,3,6.8,6.8V31C30,31.6,29.6,32,29,32z"></path></svg>
							</div>
							담당자 없음
						</div>

						<!-- 수정중  -->
						<div class="noContactPerson_clickPopUp">
							<div class="noContactPerson_clickPopUp_inputDiv">
								<div class="noContactPerson_input">
									<div class="noContactPerson_input_svg">
										<svg class="HighlightSol HighlightSol--core Icon UserIcon"
											viewBox="0 0 32 32" aria-hidden="true" focusable="false">
															<path
												d="M16,18c-4.4,0-8-3.6-8-8s3.6-8,8-8s8,3.6,8,8S20.4,18,16,18z M16,4c-3.3,0-6,2.7-6,6s2.7,6,6,6s6-2.7,6-6S19.3,4,16,4z M29,32c-0.6,0-1-0.4-1-1v-4.2c0-2.6-2.2-4.8-4.8-4.8H8.8C6.2,22,4,24.2,4,26.8V31c0,0.6-0.4,1-1,1s-1-0.4-1-1v-4.2C2,23,5,20,8.8,20h14.4c3.7,0,6.8,3,6.8,6.8V31C30,31.6,29.6,32,29,32z"></path></svg>
									</div>
									<input name="responsiblePerson" type="text"
										placeholder="이름 또는 이메일" />
								</div>
							</div>
							<div class="noContactPerson_clickPopUp_member">
								<div class="noContactPerson_clickPopUp_member_list">
									<img src="../../img01/짱구1.jpg" />
									<div class="noContactPerson_clickPopUp_member_list_name">지숭</div>
									<div class="noContactPerson_clickPopUp_member_list_email">jisooasana02@gmail.com</div>
								</div>
								<div class="noContactPerson_clickPopUp_member_list">
									<img src="../../img01/짱구1.jpg" />
									<div class="noContactPerson_clickPopUp_member_list_name">지숭</div>
									<div class="noContactPerson_clickPopUp_member_list_email">jisooasana02@gmail.com</div>
								</div>
								<div class="noContactPerson_clickPopUp_member_list">
									<img src="../../img01/짱구1.jpg" />
									<div class="noContactPerson_clickPopUp_member_list_name">지숭</div>
									<div class="noContactPerson_clickPopUp_member_list_email">jisooasana02@gmail.com</div>
								</div>
								<div class="Invite_by_email">
									<img src="../../img01/free-icon-mail-646094.png" /> 이메일로 팀원초대
								</div>
							</div>
						</div>
						<!-- 수정중  -->

					</div>
					<div class="rowstructure">
						<div class="rowstructure_title">
							<span>마감일</span>
						</div>
						<div class="deadline_right">
							<div class="second">
								<svg class="HighlightSol Icon CalendarIcon" viewBox="0 0 32 32"
									aria-hidden="true" focusable="false">
													<path
										d="M24,2V1c0-0.6-0.4-1-1-1s-1,0.4-1,1v1H10V1c0-0.6-0.4-1-1-1S8,0.4,8,1v1C4.7,2,2,4.7,2,8v16c0,3.3,2.7,6,6,6h16c3.3,0,6-2.7,6-6V8C30,4.7,27.3,2,24,2z M8,4v1c0,0.6,0.4,1,1,1s1-0.4,1-1V4h12v1c0,0.6,0.4,1,1,1s1-0.4,1-1V4c2.2,0,4,1.8,4,4v2H4V8C4,5.8,5.8,4,8,4z M24,28H8c-2.2,0-4-1.8-4-4V12h24v12C28,26.2,26.2,28,24,28z"></path></svg>
							</div>
							<span></span>
							<svg class="deadline_remove_svg" viewBox="0 0 24 24"
								aria-hidden="true" focusable="false">
												<path
									d="M14.5,12l6-6C20.8,5.7,21,5.2,21,4.8s-0.2-0.9-0.5-1.2C20.1,3.2,19.7,3,19.2,3S18.3,3.2,18,3.5l-6,6l-6-6 C5.7,3.2,5.2,3,4.8,3S3.9,3.2,3.5,3.5C3.2,3.9,3,4.3,3,4.8S3.2,5.7,3.5,6l6,6l-6,6c-0.7,0.7-0.7,1.8,0,2.5C3.9,20.8,4.3,21,4.8,21 s0.9-0.2,1.2-0.5l6-6l6,6c0.3,0.3,0.8,0.5,1.2,0.5s0.9-0.2,1.2-0.5c0.7-0.7,0.7-1.8,0-2.5L14.5,12z"></path></svg>
						</div>

						<!-- 수정중  -->
						<div class="no_deadline">
							<div class="no_deadline_svg">
								<svg class="HighlightSol HighlightSol--core Icon CalendarIcon"
									viewBox="0 0 32 32" aria-hidden="true" focusable="false">
													<path
										d="M24,2V1c0-0.6-0.4-1-1-1s-1,0.4-1,1v1H10V1c0-0.6-0.4-1-1-1S8,0.4,8,1v1C4.7,2,2,4.7,2,8v16c0,3.3,2.7,6,6,6h16c3.3,0,6-2.7,6-6V8C30,4.7,27.3,2,24,2z M8,4v1c0,0.6,0.4,1,1,1s1-0.4,1-1V4h12v1c0,0.6,0.4,1,1,1s1-0.4,1-1V4c2.2,0,4,1.8,4,4v2H4V8C4,5.8,5.8,4,8,4z M24,28H8c-2.2,0-4-1.8-4-4V12h24v12C28,26.2,26.2,28,24,28z"></path></svg>
							</div>
							마감일 없음
						</div>
						<!-- 수정중  -->
					</div>
					<div class="rowstructure_02">
						<div class="rowstructure_title_02">
							<span>프로젝트</span>
						</div>
						<div class="manager_right_02">
							<div class="project_add_title">
								<svg class="HighlightSol_MiniIcon" viewBox="0 0 24 24"
									aria-hidden="true" focusable="false">
													<path
										d="M10.4,4h3.2c2.2,0,3,0.2,3.9,0.7c0.8,0.4,1.5,1.1,1.9,1.9s0.7,1.6,0.7,3.9v3.2c0,2.2-0.2,3-0.7,3.9c-0.4,0.8-1.1,1.5-1.9,1.9s-1.6,0.7-3.9,0.7h-3.2c-2.2,0-3-0.2-3.9-0.7c-0.8-0.4-1.5-1.1-1.9-1.9c-0.4-1-0.6-1.8-0.6-4v-3.2c0-2.2,0.2-3,0.7-3.9C5.1,5.7,5.8,5,6.6,4.6C7.4,4.2,8.2,4,10.4,4z"></path></svg>
								<span>협업툴 개발 (1)</span>
								<div class="section">
									<span>수행중</span>

									<svg
										class="HighlightSol MiniIcon ButtonThemeablePresentation-rightIcon ArrowDownMiniIcon"
										viewBox="0 0 24 24" aria-hidden="true" focusable="false">
														<path
											d="m18.185 7.851-6.186 5.191-6.186-5.191a1.499 1.499 0 1 0-1.928 2.298l7.15 6a1.498 1.498 0 0 0 1.928 0l7.15-6a1.5 1.5 0 0 0-1.928-2.298Z"></path></svg>
								</div>
								<svg class="delete_project_svg" viewBox="0 0 24 24"
									aria-hidden="true" focusable="false">
													<path
										d="M14.5,12l6-6C20.8,5.7,21,5.2,21,4.8s-0.2-0.9-0.5-1.2C20.1,3.2,19.7,3,19.2,3S18.3,3.2,18,3.5l-6,6l-6-6 C5.7,3.2,5.2,3,4.8,3S3.9,3.2,3.5,3.5C3.2,3.9,3,4.3,3,4.8S3.2,5.7,3.5,6l6,6l-6,6c-0.7,0.7-0.7,1.8,0,2.5C3.9,20.8,4.3,21,4.8,21 s0.9-0.2,1.2-0.5l6-6l6,6c0.3,0.3,0.8,0.5,1.2,0.5s0.9-0.2,1.2-0.5c0.7-0.7,0.7-1.8,0-2.5L14.5,12z"></path></svg>
							</div>
							<div class="project_add_title_under_projectAddBtn">이름</div>
							<div class="AddProject_click_Projectlist">
								<input name="project_name" type="text"
									placeholder="마일스톤을 프로젝트에 추가 ..." />
								<div class="AddProject_click_Projectlist_projectName">
									<div class="AddProject_click_Projectlist_projectdiv">프로젝트
										hw(3)</div>
									<div class="AddProject_click_Projectlist_projectdiv">개발자로
										취업하기(2)</div>
									<div class="AddProject_click_Projectlist_projectdiv">프로젝트
										gj(4)</div>
								</div>
							</div>
						</div>
					</div>
					<div class="rowstructure_03">
						<div class="rowstructure_title_03">
							<span>종속관계</span>
						</div>
						<div class="manager_right_03">종속 관계 추가</div>
						<div class="clickingDependencies">
							<div class="selectTask">
								<div class="typeOfWork_parent">
									<div class="preceding_typeOfWork" idx="1">
										<svg
											class="HighlightSol HighlightSol--core MiniIcon ButtonThemeablePresentation-leftIcon TaskDependencyDirectionSelector-hourglassIcon HourglassMiniIcon"
											data-testid="HourGlassIcon" viewBox="0 0 24 24"
											aria-hidden="true" focusable="false">
															<path
												d="M20 6.93V4h1a1 1 0 1 0 0-2H3a1 1 0 1 0 0 2h1v2.93c0 1.43.737 2.775 1.975 3.597.87.578 1.78 1.067 2.744 1.473-.964.406-1.875.896-2.744 1.473C4.738 14.295 4 15.64 4 17.07V20H3a1 1 0 1 0 0 2h18a1 1 0 1 0 0-2h-1v-2.93c0-1.43-.738-2.775-1.976-3.597A16.532 16.532 0 0 0 15.28 12a16.566 16.566 0 0 0 2.744-1.473C19.26 9.705 20 8.36 20 6.93Zm-3.084 8.209c.68.45 1.083 1.172 1.083 1.93V20H6v-2.93c0-.76.404-1.48 1.083-1.931 1.472-.978 3.082-1.67 4.917-2.112 1.835.442 3.446 1.134 4.917 2.112ZM18 6.93c0 .76-.404 1.48-1.083 1.931-1.472.978-3.082 1.67-4.917 2.112-1.835-.442-3.446-1.134-4.917-2.112C6.403 8.411 6 7.689 6 6.93V4h12v2.93Z"></path></svg>
										선행작업
										<svg
											class="HighlightSol HighlightSol--core MiniIcon ButtonThemeablePresentation-rightIcon TaskDependencyDirectionSelector-arrowDownIcon ArrowDownMiniIcon"
											viewBox="0 0 24 24" aria-hidden="true" focusable="false">
															<path
												d="m18.185 7.851-6.186 5.191-6.186-5.191a1.499 1.499 0 1 0-1.928 2.298l7.15 6a1.498 1.498 0 0 0 1.928 0l7.15-6a1.5 1.5 0 0 0-1.928-2.298Z"></path></svg>
									</div>
									<div class="typeOfWork on" idx="2">
										<svg
											class="HighlightSol HighlightSol--core MiniIcon ButtonThemeablePresentation-leftIcon TaskDependencyDirectionSelector-hourglassIcon HourglassMiniIcon"
											data-testid="HourGlassIcon" viewBox="0 0 24 24"
											aria-hidden="true" focusable="false">
															<path
												d="M20 6.93V4h1a1 1 0 1 0 0-2H3a1 1 0 1 0 0 2h1v2.93c0 1.43.737 2.775 1.975 3.597.87.578 1.78 1.067 2.744 1.473-.964.406-1.875.896-2.744 1.473C4.738 14.295 4 15.64 4 17.07V20H3a1 1 0 1 0 0 2h18a1 1 0 1 0 0-2h-1v-2.93c0-1.43-.738-2.775-1.976-3.597A16.532 16.532 0 0 0 15.28 12a16.566 16.566 0 0 0 2.744-1.473C19.26 9.705 20 8.36 20 6.93Zm-3.084 8.209c.68.45 1.083 1.172 1.083 1.93V20H6v-2.93c0-.76.404-1.48 1.083-1.931 1.472-.978 3.082-1.67 4.917-2.112 1.835.442 3.446 1.134 4.917 2.112ZM18 6.93c0 .76-.404 1.48-1.083 1.931-1.472.978-3.082 1.67-4.917 2.112-1.835-.442-3.446-1.134-4.917-2.112C6.403 8.411 6 7.689 6 6.93V4h12v2.93Z"></path></svg>
										후속작업
										<svg
											class="HighlightSol HighlightSol--core MiniIcon ButtonThemeablePresentation-rightIcon TaskDependencyDirectionSelector-arrowDownIcon ArrowDownMiniIcon"
											viewBox="0 0 24 24" aria-hidden="true" focusable="false">
															<path
												d="m18.185 7.851-6.186 5.191-6.186-5.191a1.499 1.499 0 1 0-1.928 2.298l7.15 6a1.498 1.498 0 0 0 1.928 0l7.15-6a1.5 1.5 0 0 0-1.928-2.298Z"></path></svg>
									</div>

									<div class="typeOfWork_select">
										<div class="preceding_typeOfWork_select_list">
											<svg
												class="HighlightSol HighlightSol--core MiniIcon ButtonThemeablePresentation-leftIcon TaskDependencyDirectionSelector-hourglassIcon HourglassMiniIcon"
												data-testid="HourGlassIcon" viewBox="0 0 24 24"
												aria-hidden="true" focusable="false">
																<path
													d="M20 6.93V4h1a1 1 0 1 0 0-2H3a1 1 0 1 0 0 2h1v2.93c0 1.43.737 2.775 1.975 3.597.87.578 1.78 1.067 2.744 1.473-.964.406-1.875.896-2.744 1.473C4.738 14.295 4 15.64 4 17.07V20H3a1 1 0 1 0 0 2h18a1 1 0 1 0 0-2h-1v-2.93c0-1.43-.738-2.775-1.976-3.597A16.532 16.532 0 0 0 15.28 12a16.566 16.566 0 0 0 2.744-1.473C19.26 9.705 20 8.36 20 6.93Zm-3.084 8.209c.68.45 1.083 1.172 1.083 1.93V20H6v-2.93c0-.76.404-1.48 1.083-1.931 1.472-.978 3.082-1.67 4.917-2.112 1.835.442 3.446 1.134 4.917 2.112ZM18 6.93c0 .76-.404 1.48-1.083 1.931-1.472.978-3.082 1.67-4.917 2.112-1.835-.442-3.446-1.134-4.917-2.112C6.403 8.411 6 7.689 6 6.93V4h12v2.93Z"></path></svg>
											선행작업
										</div>
										<div class="typeOfWork_select_list">
											<svg
												class="HighlightSol HighlightSol--core MiniIcon TaskDependencyDirectionSelector-blockingIcon BlockingMiniIcon"
												data-testid="BlockingIcon" viewBox="0 0 24 24"
												aria-hidden="true" focusable="false">
																<path
													d="M12 0C5.383 0 0 5.383 0 12s5.383 12 12 12 12-5.383 12-12S18.617 0 12 0Zm0 22C6.486 22 2 17.514 2 12S6.486 2 12 2s10 4.486 10 10-4.486 10-10 10Zm5-10a1 1 0 0 1-1 1H8a1 1 0 0 1 0-2h8a1 1 0 0 1 1 1Z"></path></svg>
											후속작업
										</div>
									</div>
								</div>





								<input name="wamOfName" type="text" placeholder="작업찾기"
									class="selectTask_input" />
							</div>

							<div class="clickingDependencies_list">
								<div class="clickingDependencies_list_workSelect">
									<div class="clickingDependencies_list_workSelect_svg">
										<svg class="taskCompletionCompoundIcon" viewBox="0 0 32 32"
											aria-hidden="true" focusable="false">
														<path
												d="M31,16c0,8.3-6.7,15-15,15S1,24.3,1,16S7.7,1,16,1S31,7.7,31,16z"
												class="CompoundIcon-outer"></path>
														<path
												d="M13.4,22.1c-0.3,0-0.5-0.1-0.7-0.3l-3.9-3.9c-0.4-0.4-0.4-1,0-1.4s1-0.4,1.4,0l3.1,3.1l8.1-8.1c0.4-0.4,1-0.4,1.4,0   s0.4,1,0,1.4l-8.9,8.9C13.9,22,13.7,22.1,13.4,22.1z"
												class="CompoundIcon-inner"></path>
														</svg>
										<svg class="disabledIcon" viewBox="0 0 32 32"
											aria-hidden="true" focusable="false">
															<path
												d="M16,0C7.2,0,0,7.2,0,16s7.2,16,16,16s16-7.2,16-16l0,0C32,7.2,24.8,0,16,0z M2,16C2,8.3,8.2,2,16,2c3.4,0,6.6,1.2,9.2,3.4  L5.4,25.2C3.2,22.6,2,19.4,2,16z M16,30c-3.4,0-6.6-1.2-9.2-3.4L26.6,6.8c5.1,5.8,4.5,14.7-1.4,19.7C22.6,28.8,19.4,30,16,30z"></path>
														</svg>

									</div>
									<div class="clickingDependencies_list_workSelect_wamOfName">프로젝트
										초안 작성하기</div>
									<div class="clickingDependencies_list_workSelect_project">협업툴
										개발(1)</div>
								</div>
								<div class="clickingDependencies_list_workSelect">
									<div class="clickingDependencies_list_workSelect_svg">
										<svg
											class="HighlightSol HighlightSol--core CompoundIcon--small CompoundIcon TaskCompletionCompoundIcon TaskCompletionStatusIndicator--incomplete TaskCompletionStatusIndicator"
											viewBox="0 0 32 32" aria-hidden="true" focusable="false">
														<path
												d="M31,16c0,8.3-6.7,15-15,15S1,24.3,1,16S7.7,1,16,1S31,7.7,31,16z"
												class="CompoundIcon-outer"></path>
														<path
												d="M13.4,22.1c-0.3,0-0.5-0.1-0.7-0.3l-3.9-3.9c-0.4-0.4-0.4-1,0-1.4s1-0.4,1.4,0l3.1,3.1l8.1-8.1c0.4-0.4,1-0.4,1.4,0   s0.4,1,0,1.4l-8.9,8.9C13.9,22,13.7,22.1,13.4,22.1z"
												class="CompoundIcon-inner"></path>
														</svg>
									</div>
									<div class="clickingDependencies_list_workSelect_wamOfName">미팅
										일정 확인</div>
									<div class="clickingDependencies_list_workSelect_project">협업툴
										개발(1)</div>
								</div>
								<div class="clickingDependencies_list_workSelect">
									<div class="clickingDependencies_list_workSelect_svg">
										<svg
											class="HighlightSol HighlightSol--core CompoundIcon--small CompoundIcon MilestoneCompletionCompoundIcon MilestoneCompletionStatusIndicator--incomplete MilestoneCompletionStatusIndicator"
											data-testid="milestone_completion_status_indicator"
											viewBox="0 0 32 32" aria-hidden="true" focusable="false">
														<path
												d="M20.1,2.8c-2.3-2.3-5.9-2.3-8.2,0L2.7,12c-2.3,2.3-2.3,5.9,0,8.2l9.2,9.2c2.3,2.3,5.9,2.3,8.2,0l9.2-9.2  c2.3-2.3,2.3-5.9,0-8.2L20.1,2.8z"
												class="milestone_CompoundIcon-outer"></path>
														<path
												d="M13.4,22.2c-0.3,0-0.5-0.1-0.7-0.3L8.8,18c-0.4-0.4-0.4-1,0-1.4s1-0.4,1.4,0l3.1,3.1l8.1-8.1c0.4-0.4,1-0.4,1.4,0   s0.4,1,0,1.4l-8.9,8.9C13.9,22.1,13.7,22.2,13.4,22.2z"
												class="milestone_CompoundIcon-inner"></path>
														</svg>
									</div>
									<div class="clickingDependencies_list_workSelect_wamOfName">기능명세서
										완성</div>
									<div class="clickingDependencies_list_workSelect_project"></div>
								</div>
								<div class="clickingDependencies_list_workSelect">
									<div class="clickingDependencies_list_workSelect_svg">
										<svg
											class="HighlightSol HighlightSol--core CompoundIcon--small CompoundIcon TaskCompletionCompoundIcon TaskCompletionStatusIndicator--incomplete TaskCompletionStatusIndicator"
											viewBox="0 0 32 32" aria-hidden="true" focusable="false">
														<path
												d="M31,16c0,8.3-6.7,15-15,15S1,24.3,1,16S7.7,1,16,1S31,7.7,31,16z"
												class="CompoundIcon-outer"></path>
														<path
												d="M13.4,22.1c-0.3,0-0.5-0.1-0.7-0.3l-3.9-3.9c-0.4-0.4-0.4-1,0-1.4s1-0.4,1.4,0l3.1,3.1l8.1-8.1c0.4-0.4,1-0.4,1.4,0   s0.4,1,0,1.4l-8.9,8.9C13.9,22,13.7,22.1,13.4,22.1z"
												class="CompoundIcon-inner"></path>
														</svg>
									</div>
									<div class="clickingDependencies_list_workSelect_wamOfName">자소서
										작성하기</div>
									<div class="clickingDependencies_list_workSelect_project">개발자로
										취업하기(2)</div>
								</div>
							</div>
						</div>


						<!--선행관계 select -->
						<!--선행관계 select -->
						<!--선행관계 select -->
						<div class="dependency_list_parent">
							<div class="prior_work_parent">
								<div class="prior_work" wamidx="">
									<div class="prior_work_type">선행 작업</div>
									<div class="prior_work_title">wam 의 이름</div>
									<div class="prior_delBtn">
										<svg
											class="HighlightSol HighlightSol--core CompoundIcon--small CompoundIcon XCircleCompoundIcon TokenizerPillRemoveButton-removeIcon"
											viewBox="0 0 32 32" aria-hidden="true" focusable="false">
															<path
												d="M31,16c0,8.3-6.7,15-15,15S1,24.3,1,16S7.7,1,16,1S31,7.7,31,16z"
												class="CompoundIcon-outer"></path>
															<path
												d="M22.5,20.7c0.5,0.5,0.5,1.3,0,1.8c-0.2,0.2-0.5,0.4-0.9,0.4s-0.6-0.1-0.9-0.4L16,17.8l-4.7,4.7c-0.2,0.2-0.5,0.4-0.9,0.4s-0.6-0.1-0.9-0.4C9,22,9,21.2,9.5,20.7l4.7-4.7l-4.7-4.7C9,10.8,9,10,9.5,9.5c0.2-0.2,0.5-0.4,0.9-0.4s0.6,0.1,0.9,0.4l4.7,4.7l4.7-4.7c0.2-0.2,0.5-0.4,0.9-0.4s0.6,0.1,0.9,0.4c0.5,0.5,0.5,1.3,0,1.8L17.8,16L22.5,20.7z"
												class="CompoundIcon-inner"></path>
														</svg>
									</div>
								</div>
							</div>
							<!--종속관계 select -->
							<!--종속관계 select -->
							<!--종속관계 select -->
							<div class="dependent_tasks_parent">
								<div class="dependent_tasks" idx="">
									<div class="dependent_tasks_type">후속 작업</div>
									<div class="dependent_tasks_title">wam 의 이름</div>
									<div class="dependent_tasks_delBtn">
										<svg
											class="HighlightSol HighlightSol--core CompoundIcon--small CompoundIcon XCircleCompoundIcon TokenizerPillRemoveButton-removeIcon"
											viewBox="0 0 32 32" aria-hidden="true" focusable="false">
															<path
												d="M31,16c0,8.3-6.7,15-15,15S1,24.3,1,16S7.7,1,16,1S31,7.7,31,16z"
												class="CompoundIcon-outer"></path>
															<path
												d="M22.5,20.7c0.5,0.5,0.5,1.3,0,1.8c-0.2,0.2-0.5,0.4-0.9,0.4s-0.6-0.1-0.9-0.4L16,17.8l-4.7,4.7c-0.2,0.2-0.5,0.4-0.9,0.4s-0.6-0.1-0.9-0.4C9,22,9,21.2,9.5,20.7l4.7-4.7l-4.7-4.7C9,10.8,9,10,9.5,9.5c0.2-0.2,0.5-0.4,0.9-0.4s0.6,0.1,0.9,0.4l4.7,4.7l4.7-4.7c0.2-0.2,0.5-0.4,0.9-0.4s0.6,0.1,0.9,0.4c0.5,0.5,0.5,1.3,0,1.8L17.8,16L22.5,20.7z"
												class="CompoundIcon-inner"></path>
														</svg>
									</div>
								</div>
							</div>
						</div>


					</div>
					<div class="rowstructure_04">
						<div class="rowstructure_title_04">
							<span>설명</span>
						</div>
						<div class="manager_right_04"></div>
					</div>
					<div class="rowstructure_05">
						<textarea name="milestone_content">마일스톤 내용</textarea>
					</div>


					<!-- 수정중  -->
					<!-- 수정중  -->
					<div class="Add_subtask_save_parent">
						<div class="Add_subtask_save">
							<div class="Add_subtask_checkSvg_save">
								<svg
									class="HighlightSol HighlightSol--core CompoundIcon--small CompoundIcon TaskCompletionCompoundIcon TaskCompletionStatusIndicator--incomplete TaskCompletionStatusIndicator TaskRowCompletionStatus-taskCompletionIcon--incomplete TaskRowCompletionStatus-taskCompletionIcon"
									viewBox="0 0 32 32" aria-hidden="true" focusable="false">
												<path
										d="M31,16c0,8.3-6.7,15-15,15S1,24.3,1,16S7.7,1,16,1S31,7.7,31,16z"
										class="check_CompoundIcon-outer"></path>
												<path
										d="M13.4,22.1c-0.3,0-0.5-0.1-0.7-0.3l-3.9-3.9c-0.4-0.4-0.4-1,0-1.4s1-0.4,1.4,0l3.1,3.1l8.1-8.1c0.4-0.4,1-0.4,1.4,0   s0.4,1,0,1.4l-8.9,8.9C13.9,22,13.7,22.1,13.4,22.1z"
										class="check_CompoundIcon-inner"></path>
												</svg>
							</div>
							<div class="Add_subtask_save_title">
								<input name="Add_subtask_title" type="text" />
							</div>
							<div class="Add_subtask_save_deadline">
								<svg class="HighlightSol HighlightSol--core Icon CalendarIcon"
									viewBox="0 0 32 32" aria-hidden="true" focusable="false">
													<path
										d="M24,2V1c0-0.6-0.4-1-1-1s-1,0.4-1,1v1H10V1c0-0.6-0.4-1-1-1S8,0.4,8,1v1C4.7,2,2,4.7,2,8v16c0,3.3,2.7,6,6,6h16c3.3,0,6-2.7,6-6V8C30,4.7,27.3,2,24,2z M8,4v1c0,0.6,0.4,1,1,1s1-0.4,1-1V4h12v1c0,0.6,0.4,1,1,1s1-0.4,1-1V4c2.2,0,4,1.8,4,4v2H4V8C4,5.8,5.8,4,8,4z M24,28H8c-2.2,0-4-1.8-4-4V12h24v12C28,26.2,26.2,28,24,28z"></path></svg>
							</div>
							<div class="Add_subtask_save_manager">
								<svg class="HighlightSol HighlightSol--core Icon UserIcon"
									viewBox="0 0 32 32" aria-hidden="true" focusable="false">
													<path
										d="M16,18c-4.4,0-8-3.6-8-8s3.6-8,8-8s8,3.6,8,8S20.4,18,16,18z M16,4c-3.3,0-6,2.7-6,6s2.7,6,6,6s6-2.7,6-6S19.3,4,16,4z M29,32c-0.6,0-1-0.4-1-1v-4.2c0-2.6-2.2-4.8-4.8-4.8H8.8C6.2,22,4,24.2,4,26.8V31c0,0.6-0.4,1-1,1s-1-0.4-1-1v-4.2C2,23,5,20,8.8,20h14.4c3.7,0,6.8,3,6.8,6.8V31C30,31.6,29.6,32,29,32z"></path></svg>
							</div>
							<!-- 매니저 버튼 클릭시  -->
							<div class="assignmentOfmanager">
								<div class="assignmentOfmanager_title">
									<span>담당자</span>
									<svg class="assignmentOfmanager_title_XIcon"
										viewBox="0 0 32 32" aria-hidden="true" focusable="false">
														<path
											d="M18.1,16L27,7.1c0.6-0.6,0.6-1.5,0-2.1s-1.5-0.6-2.1,0L16,13.9l-8.9-9C6.5,4.3,5.6,4.3,5,4.9S4.4,6.4,5,7l8.9,8.9L5,24.8c-0.6,0.6-0.6,1.5,0,2.1c0.3,0.3,0.7,0.4,1.1,0.4s0.8-0.1,1.1-0.4l8.9-8.9l8.9,8.9c0.3,0.3,0.7,0.4,1.1,0.4s0.8-0.1,1.1-0.4c0.6-0.6,0.6-1.5,0-2.1L18.1,16z"></path></svg>
								</div>
								<div class="assignmentOfmanager_select">
									<div class="assignmentOfmanager_select_input">
										<input name="manager" type="text" placeholder="이름 또는 이메일" />
										<svg
											class="HighlightSol HighlightSol--core CompoundIcon--xsmall CompoundIcon XCircleCompoundIcon"
											viewBox="0 0 24 24" aria-hidden="true" focusable="false">
															<path
												d="M23,12c0,6.1-4.9,11-11,11S1,18.1,1,12S5.9,1,12,1S23,5.9,23,12z"
												class="CompoundIcon-outer"></path>
															<path
												d="M13.4,12l4.3-4.3c0.4-0.4,0.4-1,0-1.4s-1-0.4-1.4,0L12,10.6L7.7,6.3c-0.4-0.4-1-0.4-1.4,0s-0.4,1,0,1.4l4.3,4.3l-4.3,4.3c-0.4,0.4-0.4,1,0,1.4C6.5,17.9,6.7,18,7,18s0.5-0.1,0.7-0.3l4.3-4.3l4.3,4.3c0.2,0.2,0.5,0.3,0.7,0.3s0.5-0.1,0.7-0.3c0.4-0.4,0.4-1,0-1.4L13.4,12z"
												class="CompoundIcon-inner"></path></svg>
									</div>
									또는
									<div class="assignmentOfmanager_select_assignedToMe">나에게
										배정</div>
								</div>
							</div>
							<div class="assignmentOfmanager_list">
								<div class="assignmentOfmanager_list_select">
									<img src="../../img01/짱구1.jpg">
									<div class="assignmentOfmanager_list_select_memberName">지숭</div>
									<div class="assignmentOfmanager_list_select_memberEmail">jisooasana02@gmail.com</div>
								</div>
								<div class="assignmentOfmanager_list_select">
									<img src="../../img01/짱구2.jpg">
									<div class="assignmentOfmanager_list_select_memberName">현우</div>
									<div class="assignmentOfmanager_list_select_memberEmail">jisooasana02@gmail.com</div>
								</div>
								<div class="assignmentOfmanager_list_select">
									<img src="../../img01/철수.png">
									<div class="assignmentOfmanager_list_select_memberName">길주</div>
									<div class="assignmentOfmanager_list_select_memberEmail">jisooasana02@gmail.com</div>
								</div>
								<div class="invite_team_members_by_email">
									<svg
										class="HighlightSol HighlightSol--core Icon TypeaheadActionItemStructure-icon PlusIcon"
										viewBox="0 0 32 32" aria-hidden="true" focusable="false">
														<path
											d="M26,14h-8V6c0-1.1-0.9-2-2-2l0,0c-1.1,0-2,0.9-2,2v8H6c-1.1,0-2,0.9-2,2l0,0c0,1.1,0.9,2,2,2h8v8c0,1.1,0.9,2,2,2l0,0c1.1,0,2-0.9,2-2v-8h8c1.1,0,2-0.9,2-2l0,0C28,14.9,27.1,14,26,14z"></path></svg>
									<span>이메일로 팀원 초대</span>
								</div>
							</div>
							<!-- 매니저 버튼 클릭시  -->
						</div>
					</div>
					<!-- 수정중  -->
					<!-- 수정중  -->


					<div class="rowstructure_06">
						<button class="rowstructure_06_btn">
							<svg
								class="HighlightSol MiniIcon ButtonThemeablePresentation-leftIcon PlusMiniIcon"
								viewBox="0 0 24 24" aria-hidden="true" focusable="false">
												<path
									d="M10,10V4c0-1.1,0.9-2,2-2s2,0.9,2,2v6h6c1.1,0,2,0.9,2,2s-0.9,2-2,2h-6v6c0,1.1-0.9,2-2,2s-2-0.9-2-2v-6H4c-1.1,0-2-0.9-2-2s0.9-2,2-2H10z"></path></svg>
							<span>하위 작업 추가</span>
						</button>
					</div>
					<div class="comment">
						<div class="comment_title">
							<span>댓글</span>
						</div>
						<div class="comment_story">
							<div class="profile_img">
								<img src="../img01/짱구1.jpg"></img>
							</div>
							<div class="profile_name">지숭</div>
							<div>님이 이 작업을 생성했습니다</div>
							<div class="milestone_update_date">3일전</div>
						</div>
						<div class="feedblockstroy">
							<div class="feedblockstroy_complete">
								<svg
									class="HighlightSol CompoundIcon--large CompoundIcon MilestoneCompletionCompoundIcon MilestoneCompletionStatusIndicator--complete MilestoneCompletionStatusIndicator"
									data-testid="milestone_completion_status_indicator"
									viewBox="0 0 32 32" aria-hidden="true" focusable="false">
													<path
										d="M20.1,2.8c-2.3-2.3-5.9-2.3-8.2,0L2.7,12c-2.3,2.3-2.3,5.9,0,8.2l9.2,9.2c2.3,2.3,5.9,2.3,8.2,0l9.2-9.2  c2.3-2.3,2.3-5.9,0-8.2L20.1,2.8z"
										class="CompoundIcon-outer"></path>
													<path
										d="M13.4,22.2c-0.3,0-0.5-0.1-0.7-0.3L8.8,18c-0.4-0.4-0.4-1,0-1.4s1-0.4,1.4,0l3.1,3.1l8.1-8.1c0.4-0.4,1-0.4,1.4,0   s0.4,1,0,1.4l-8.9,8.9C13.9,22.1,13.7,22.2,13.4,22.2z"
										class="CompoundIcon-inner"></path></svg>
							</div>
							<div class="feedblockstroy_name">지숭</div>
							<div>님이 마일스톤을 완료로 표시했습니다</div>
							<div class="feedblockstroy_update_date">3일전</div>
						</div>
					</div>
				</div>

			</div>
			<div class="milestone_footer">
				<div class="milestone_comment_content">
					<div class="profile_img">
						<img src="../img01/짱구1.jpg"></img>
					</div>
					<div class="milestone_comment_input_child02">
						<textarea>댓글추가</textarea>
					</div>
				</div>
				<div class="milestone_Participants">
					<div class="milestone_Participants_child01">협업 참여자</div>
					<div class="collaboration_profile">
						<div>
							<img src="img01/짱구1.jpg"></img>
						</div>
						<div>
							<img src="img01/철수.jpeg"></img>
						</div>
						<div>
							<svg class="HighlightSol MiniIcon UserMiniIcon"
								viewBox="0 0 24 24" aria-hidden="true" focusable="false">
												<path
									d="M12,14c-3.859,0-7-3.14-7-7S8.141,0,12,0s7,3.14,7,7-3.141,7-7,7Zm0-12c-2.757,0-5,2.243-5,5s2.243,5,5,5,5-2.243,5-5-2.243-5-5-5Zm10,21v-2c0-2.757-2.243-5-5-5H7c-2.757,0-5,2.243-5,5v2c0,.552,.447,1,1,1s1-.448,1-1v-2c0-1.654,1.346-3,3-3h10c1.654,0,3,1.346,3,3v2c0,.552,.447,1,1,1s1-.448,1-1Z"></path></svg>
						</div>
						<div class="add_collaboration_profile">
							<svg class="HighlightSol MiniIcon UserMiniIcon"
								viewBox="0 0 24 24" aria-hidden="true" focusable="false">
												<path
									d="M12,14c-3.859,0-7-3.14-7-7S8.141,0,12,0s7,3.14,7,7-3.141,7-7,7Zm0-12c-2.757,0-5,2.243-5,5s2.243,5,5,5,5-2.243,5-5-2.243-5-5-5Zm10,21v-2c0-2.757-2.243-5-5-5H7c-2.757,0-5,2.243-5,5v2c0,.552,.447,1,1,1s1-.448,1-1v-2c0-1.654,1.346-3,3-3h10c1.654,0,3,1.346,3,3v2c0,.552,.447,1,1,1s1-.448,1-1Z"></path></svg>
						</div>
						<div class="plus_icon_coooperation">
							<svg class="HighlightSol MiniIcon--small MiniIcon PlusMiniIcon"
								viewBox="0 0 24 24" aria-hidden="true" focusable="false">
												<path
									d="M10,10V4c0-1.1,0.9-2,2-2s2,0.9,2,2v6h6c1.1,0,2,0.9,2,2s-0.9,2-2,2h-6v6c0,1.1-0.9,2-2,2s-2-0.9-2-2v-6H4c-1.1,0-2-0.9-2-2s0.9-2,2-2H10z"></path></svg>
						</div>
					</div>
					<div class="milestone_Participants_child03">
						<svg
							class="HighlightSol Icon--small Icon ButtonThemeablePresentation-leftIcon BellIcon"
							viewBox="0 0 32 32" aria-hidden="true" focusable="false">
											<path
								d="M2.03 20.635A5.87 5.87 0 0 0 4 16.249V12c0-3.247 1.276-6.288 3.593-8.563C9.909 1.164 12.962-.064 16.224.002 22.717.121 28 5.667 28 12.365v3.884c0 1.675.718 3.273 1.97 4.386 1.047.932 1.33 2.411.704 3.682C30.17 25.339 29.061 26 27.85 26H4.152c-1.211 0-2.32-.661-2.824-1.684-.626-1.271-.344-2.75.704-3.682l-.002.001ZM16 31a5.51 5.51 0 0 0 4.392-2.196c.248-.328.004-.804-.407-.804h-7.969c-.411 0-.655.476-.407.804A5.508 5.508 0 0 0 16 31Z"></path></svg>
						<span>마일스톤 나가기</span>
					</div>


					<!-- input 길주  -->
					<!-- input 길주  -->

					<!--------------------------- 협업참여자 text --------------------------->
					<div class="show_cooperation">
						<div class="cooperation_profile">
							<img class="writer_profile_img" src="img/jjangu.png">
							<div class="cooperation_name">
								<span>길주</span> <i class="bi-x"></i>
							</div>
						</div>
						<input type="text" name="cooperation" id="plus_cooperation" />
					</div>
					<!--------------------------- 협업참여자 text --------------------------->
					<!------------------------------- 초대 멤버 조회 ------------------------->
					<div class="assignmentOfmanager_list">
						<div class="assignmentOfmanager_list_select">
							<img src="img/jjangu.png">
							<div class="assignmentOfmanager_list_select_memberName">지숭</div>
							<div class="assignmentOfmanager_list_select_memberEmail">jisooasana02@gmail.com</div>
						</div>
						<div class="assignmentOfmanager_list_select">
							<img src="img/cute.jjang.png">
							<div class="assignmentOfmanager_list_select_memberName">현우</div>
							<div class="assignmentOfmanager_list_select_memberEmail">jisooasana02@gmail.com</div>
						</div>
						<div class="assignmentOfmanager_list_select">
							<img src="img/개 아이콘.jpeg">
							<div class="assignmentOfmanager_list_select_memberName">길주</div>
							<div class="assignmentOfmanager_list_select_memberEmail">jisooasana02@gmail.com</div>
						</div>
					</div>
					<!-- input 길주  -->
					<!-- input 길주  -->
				</div>
			</div>
		</div>
		<!-- 마일스톤 상세 페이지 --><!-- 마일스톤 상세 페이지 --><!-- 마일스톤 상세 페이지 -->
		
		<!-- 새로운 마일스톤 생성 페이지  --><!-- 새로운 마일스톤 생성 페이지  --><!-- 새로운 마일스톤 생성 페이지  -->
		<div class="blank_milestone" wamidx="">
			<div class="blank_milestone_transparent_screen"></div>
			<div class="blank_milestone_header">
				<div class="blank_complete_btn">
					<svg
						class="MiniIcon ButtonThemeablePresentation-leftIcon CheckMiniIcon"
						viewBox="0 0 24 24" aria-hidden="true" focusable="false">
										<path
							d="M19.439 5.439 8 16.878l-3.939-3.939A1.5 1.5 0 1 0 1.94 15.06l5 5c.293.293.677.439 1.061.439.384 0 .768-.146 1.061-.439l12.5-12.5a1.5 1.5 0 1 0-2.121-2.121h-.002Z"></path></svg>
					<span>저장</span>
				</div>
				<div class="blank_milestone_header_right">
					<div>
						<svg
							class="Icon ButtonThemeablePresentation-rightIcon ThumbsUpLineIcon"
							viewBox="0 0 32 32" aria-hidden="true" focusable="false">
											<path
								d="M5 28h19.94a3.987 3.987 0 0 0 3.961-3.395l1.552-10.03a3.96 3.96 0 0 0-.909-3.187 3.962 3.962 0 0 0-3.01-1.384H20V4.006C20 2.045 18.71.469 16.785.084c-1.918-.383-3.723.573-4.477 2.383l-3.975 9.536H5c-1.654 0-3 1.345-3 2.999V25c0 1.654 1.346 3 3 3Zm5-14.8 4.154-9.969c.465-1.116 1.5-1.341 2.238-1.191.742.148 1.608.751 1.608 1.961V12h8.532c.574 0 1.118.25 1.492.687.374.437.54 1.012.451 1.58l-1.552 10.032A1.997 1.997 0 0 1 24.94 26H10V13.2H10ZM4 15c0-.551.448-1 1-1h3v12H5c-.552 0-1-.449-1-1V15Z"></path></svg>
					</div>
					<div>
						<svg class="Icon AttachVerticalIcon" viewBox="0 0 32 32"
							aria-hidden="true" focusable="false">
											<path
								d="M19,32c-3.9,0-7-3.1-7-7V10c0-2.2,1.8-4,4-4s4,1.8,4,4v9c0,0.6-0.4,1-1,1s-1-0.4-1-1v-9c0-1.1-0.9-2-2-2s-2,0.9-2,2v15c0,2.8,2.2,5,5,5s5-2.2,5-5V10c0-4.4-3.6-8-8-8s-8,3.6-8,8v5c0,0.6-0.4,1-1,1s-1-0.4-1-1v-5C6,4.5,10.5,0,16,0s10,4.5,10,10v15C26,28.9,22.9,32,19,32z"></path></svg>
					</div>
					<div>
						<svg class="Icon SubtaskIcon" viewBox="0 0 32 32"
							aria-hidden="true" focusable="false">
											<path
								d="M25,20c-2.4,0-4.4,1.7-4.9,4H11c-3.9,0-7-3.1-7-7v-5h16.1c0.5,2.3,2.5,4,4.9,4c2.8,0,5-2.2,5-5s-2.2-5-5-5c-2.4,0-4.4,1.7-4.9,4H4V3c0-0.6-0.4-1-1-1S2,2.4,2,3v14c0,5,4,9,9,9h9.1c0.5,2.3,2.5,4,4.9,4c2.8,0,5-2.2,5-5S27.8,20,25,20z M25,8c1.7,0,3,1.3,3,3s-1.3,3-3,3s-3-1.3-3-3S23.3,8,25,8z M25,28c-1.7,0-3-1.3-3-3s1.3-3,3-3s3,1.3,3,3S26.7,28,25,28z"></path></svg>
					</div>
					<div>
						<svg class="Icon LinkIcon" viewBox="0 0 32 32" aria-hidden="true"
							focusable="false">
											<path
								d="M19.365 12.636a8.94 8.94 0 0 1 2.636 6.366 8.945 8.945 0 0 1-2.636 6.366l-4.001 4a8.976 8.976 0 0 1-6.366 2.634 8.976 8.976 0 0 1-6.366-2.634c-3.51-3.51-3.51-9.22 0-12.73l3.658-3.659a.999.999 0 1 1 1.414 1.415l-3.658 3.658a7.01 7.01 0 0 0 0 9.901c2.73 2.73 7.173 2.732 9.903 0l4.001-4a7.01 7.01 0 0 0 0-9.902 6.925 6.925 0 0 0-2.877-1.739 1 1 0 0 1 .592-1.91 9.019 9.019 0 0 1 3.699 2.235l.001-.002ZM29.368 2.633c-3.511-3.51-9.221-3.51-12.732 0l-4.001 4A8.94 8.94 0 0 0 9.999 13c0 2.405.936 4.665 2.636 6.367a9.019 9.019 0 0 0 3.699 2.235 1.001 1.001 0 0 0 .592-1.911 6.925 6.925 0 0 1-2.877-1.738 7.01 7.01 0 0 1 0-9.903l4.001-4c2.731-2.73 7.174-2.73 9.903 0 2.729 2.728 2.73 7.171 0 9.902l-3.658 3.657a.999.999 0 1 0 1.414 1.415l3.658-3.659c3.51-3.51 3.51-9.22 0-12.73l.001-.002Z"></path></svg>
					</div>
					<div>
						<svg class="Icon ButtonThemeablePresentation-leftIcon ExpandIcon"
							viewBox="0 0 32 32" aria-hidden="true" focusable="false">
											<path
								d="M13.7,19.7L5.4,28H13c0.6,0,1,0.4,1,1s-0.4,1-1,1H3c-0.6,0-1-0.4-1-1V19c0-0.6,0.4-1,1-1s1,0.4,1,1v7.6l8.3-8.3c0.4-0.4,1-0.4,1.4,0S14.1,19.3,13.7,19.7z M29,2H19c-0.6,0-1,0.4-1,1s0.4,1,1,1h7.6l-8.3,8.3c-0.4,0.4-0.4,1,0,1.4c0.2,0.2,0.5,0.3,0.7,0.3s0.5-0.1,0.7-0.3L28,5.4V13c0,0.6,0.4,1,1,1s1-0.4,1-1V3C30,2.4,29.6,2,29,2z"></path></svg>
					</div>
					<div>
						<svg class="HighlightSol Icon MoreIcon" viewBox="0 0 32 32"
							aria-hidden="true" focusable="false">
											<path
								d="M16,13c1.7,0,3,1.3,3,3s-1.3,3-3,3s-3-1.3-3-3S14.3,13,16,13z M3,13c1.7,0,3,1.3,3,3s-1.3,3-3,3s-3-1.3-3-3S1.3,13,3,13z M29,13c1.7,0,3,1.3,3,3s-1.3,3-3,3s-3-1.3-3-3S27.3,13,29,13z"></path></svg>
					</div>
					<div>
						<svg class="HighlightSol Icon CloseIcon" viewBox="0 0 32 32"
							aria-hidden="true" focusable="false">
											<path
								d="M3 15h18.379L13.94 7.561a1.5 1.5 0 1 1 2.121-2.121l10 10a1.5 1.5 0 0 1 0 2.121l-10 10A1.495 1.495 0 0 1 15 28a1.5 1.5 0 0 1-1.061-2.56l7.439-7.439H3a1.5 1.5 0 1 1 0-3V15ZM30.5 2.5A1.5 1.5 0 0 0 29 4v25a1.5 1.5 0 1 0 3 0V4a1.5 1.5 0 0 0-1.5-1.5Z"></path></svg>
					</div>
				</div>
			</div>
			<div class="blank_milestone_content">
				<div class="blank_milestone_content_child01">
					<div class="blank_milestone_content_child01_02">
						<svg
							class="CompoundIcon--small CompoundIcon MilestoneCompletionCompoundIcon MilestoneCompletionStatusIndicator--complete MilestoneCompletionStatusIndicator MilestoneIndicator--complete MilestoneIndicator-icon"
							data-testid="milestone_completion_status_indicator"
							viewBox="0 0 32 32" aria-hidden="true" focusable="false">
											<path
								d="M20.1,2.8c-2.3-2.3-5.9-2.3-8.2,0L2.7,12c-2.3,2.3-2.3,5.9,0,8.2l9.2,9.2c2.3,2.3,5.9,2.3,8.2,0l9.2-9.2  c2.3-2.3,2.3-5.9,0-8.2L20.1,2.8z"
								class="CompoundIcon-outer"></path>
											<path
								d="M13.4,22.2c-0.3,0-0.5-0.1-0.7-0.3L8.8,18c-0.4-0.4-0.4-1,0-1.4s1-0.4,1.4,0l3.1,3.1l8.1-8.1c0.4-0.4,1-0.4,1.4,0   s0.4,1,0,1.4l-8.9,8.9C13.9,22.1,13.7,22.2,13.4,22.2z"
								class="CompoundIcon-inner"></path></svg>
						<span>마일스톤</span>
					</div>
					<div class="blank_milestone_content_child01_03">
						<div class="blank_milestone_content_title">
							<input type="text" name="milestone_content_title" value="작업 이름 입력" />
						</div>
					</div>

				</div>
				<div class="blank_milestone_content_child02">
					<div class="blank_rowstructure">
						<div class="blank_rowstructure_title">
							<span>담당자</span>
						</div>
						
						<div class="blank_manager_right" manageridx="">
							<div class="blank_manager_right_img">
								<img src="img01/${memberAllDto.profileImg}"></img>
							</div>
							<span>${memberAllDto.nickname}</span>
							<svg class="blank_wam_contact_person_svg" viewBox="0 0 24 24"
								aria-hidden="true" focusable="false">
												<path
									d="M14.5,12l6-6C20.8,5.7,21,5.2,21,4.8s-0.2-0.9-0.5-1.2C20.1,3.2,19.7,3,19.2,3S18.3,3.2,18,3.5l-6,6l-6-6 C5.7,3.2,5.2,3,4.8,3S3.9,3.2,3.5,3.5C3.2,3.9,3,4.3,3,4.8S3.2,5.7,3.5,6l6,6l-6,6c-0.7,0.7-0.7,1.8,0,2.5C3.9,20.8,4.3,21,4.8,21 s0.9-0.2,1.2-0.5l6-6l6,6c0.3,0.3,0.8,0.5,1.2,0.5s0.9-0.2,1.2-0.5c0.7-0.7,0.7-1.8,0-2.5L14.5,12z"></path></svg>
						</div>
						<div class="blank_no_contact_person">
							<div class="blank_no_contact_person_UserIcon">
								<svg class="HighlightSol HighlightSol--core Icon UserIcon"
									viewBox="0 0 32 32" aria-hidden="true" focusable="false">
													<path
										d="M16,18c-4.4,0-8-3.6-8-8s3.6-8,8-8s8,3.6,8,8S20.4,18,16,18z M16,4c-3.3,0-6,2.7-6,6s2.7,6,6,6s6-2.7,6-6S19.3,4,16,4z M29,32c-0.6,0-1-0.4-1-1v-4.2c0-2.6-2.2-4.8-4.8-4.8H8.8C6.2,22,4,24.2,4,26.8V31c0,0.6-0.4,1-1,1s-1-0.4-1-1v-4.2C2,23,5,20,8.8,20h14.4c3.7,0,6.8,3,6.8,6.8V31C30,31.6,29.6,32,29,32z"></path></svg>
							</div>
							담당자 없음
						</div>

						<!-- 수정중  -->
						<div class="blank_noContactPerson_clickPopUp">
							<div class="blank_noContactPerson_clickPopUp_inputDiv">
								<div class="blank_noContactPerson_input">
									<div class="blank_noContactPerson_input_svg">
										<svg class="HighlightSol HighlightSol--core Icon UserIcon"
											viewBox="0 0 32 32" aria-hidden="true" focusable="false">
															<path
												d="M16,18c-4.4,0-8-3.6-8-8s3.6-8,8-8s8,3.6,8,8S20.4,18,16,18z M16,4c-3.3,0-6,2.7-6,6s2.7,6,6,6s6-2.7,6-6S19.3,4,16,4z M29,32c-0.6,0-1-0.4-1-1v-4.2c0-2.6-2.2-4.8-4.8-4.8H8.8C6.2,22,4,24.2,4,26.8V31c0,0.6-0.4,1-1,1s-1-0.4-1-1v-4.2C2,23,5,20,8.8,20h14.4c3.7,0,6.8,3,6.8,6.8V31C30,31.6,29.6,32,29,32z"></path></svg>
									</div>
									<input name="responsiblePerson" type="text"
										placeholder="이름 또는 이메일" />
								</div>
							</div>
							<div class="blank_noContactPerson_clickPopUp_member">
								<div class="blank_noContactPerson_clickPopUp_member_list">
									<img src="../../img01/짱구1.jpg" />
									<div class="noContactPerson_clickPopUp_member_list_name">지숭</div>
									<div class="noContactPerson_clickPopUp_member_list_email">jisooasana02@gmail.com</div>
								</div>
								<div class="blank_noContactPerson_clickPopUp_member_list">
									<img src="../../img01/짱구1.jpg" />
									<div class="noContactPerson_clickPopUp_member_list_name">지숭</div>
									<div class="noContactPerson_clickPopUp_member_list_email">jisooasana02@gmail.com</div>
								</div>
								<div class="blank_noContactPerson_clickPopUp_member_list">
									<img src="../../img01/짱구1.jpg" />
									<div class="noContactPerson_clickPopUp_member_list_name">지숭</div>
									<div class="noContactPerson_clickPopUp_member_list_email">jisooasana02@gmail.com</div>
								</div>
								<div class="blank_Invite_by_email">
									<img src="../../img01/free-icon-mail-646094.png" /> 이메일로 팀원초대
								</div>
							</div>
						</div>
						<!-- 수정중  -->

					</div>
					<div class="blank_rowstructure">
						<div class="blank_rowstructure_title">
							<span>마감일</span>
						</div>
						<%-- 
						<div class="blank_deadline_right">
							<div class="blank_second">
								<svg class="HighlightSol Icon CalendarIcon" viewBox="0 0 32 32"
									aria-hidden="true" focusable="false">
													<path
										d="M24,2V1c0-0.6-0.4-1-1-1s-1,0.4-1,1v1H10V1c0-0.6-0.4-1-1-1S8,0.4,8,1v1C4.7,2,2,4.7,2,8v16c0,3.3,2.7,6,6,6h16c3.3,0,6-2.7,6-6V8C30,4.7,27.3,2,24,2z M8,4v1c0,0.6,0.4,1,1,1s1-0.4,1-1V4h12v1c0,0.6,0.4,1,1,1s1-0.4,1-1V4c2.2,0,4,1.8,4,4v2H4V8C4,5.8,5.8,4,8,4z M24,28H8c-2.2,0-4-1.8-4-4V12h24v12C28,26.2,26.2,28,24,28z"></path></svg>
							</div>
							<span>10월 31일</span>
							<svg class="blank_deadline_remove_svg" viewBox="0 0 24 24"
								aria-hidden="true" focusable="false">
												<path
									d="M14.5,12l6-6C20.8,5.7,21,5.2,21,4.8s-0.2-0.9-0.5-1.2C20.1,3.2,19.7,3,19.2,3S18.3,3.2,18,3.5l-6,6l-6-6 C5.7,3.2,5.2,3,4.8,3S3.9,3.2,3.5,3.5C3.2,3.9,3,4.3,3,4.8S3.2,5.7,3.5,6l6,6l-6,6c-0.7,0.7-0.7,1.8,0,2.5C3.9,20.8,4.3,21,4.8,21 s0.9-0.2,1.2-0.5l6-6l6,6c0.3,0.3,0.8,0.5,1.2,0.5s0.9-0.2,1.2-0.5c0.7-0.7,0.7-1.8,0-2.5L14.5,12z"></path></svg>
						</div>
						--%>
						<!-- 수정중  -->
						<div class="blank_deadline_right" style="/* display: flex; */display: none;" date="">
							<div class="second">
								<svg class="HighlightSol Icon CalendarIcon" viewBox="0 0 32 32" aria-hidden="true" focusable="false">
													<path d="M24,2V1c0-0.6-0.4-1-1-1s-1,0.4-1,1v1H10V1c0-0.6-0.4-1-1-1S8,0.4,8,1v1C4.7,2,2,4.7,2,8v16c0,3.3,2.7,6,6,6h16c3.3,0,6-2.7,6-6V8C30,4.7,27.3,2,24,2z M8,4v1c0,0.6,0.4,1,1,1s1-0.4,1-1V4h12v1c0,0.6,0.4,1,1,1s1-0.4,1-1V4c2.2,0,4,1.8,4,4v2H4V8C4,5.8,5.8,4,8,4z M24,28H8c-2.2,0-4-1.8-4-4V12h24v12C28,26.2,26.2,28,24,28z"></path></svg>
							</div>
							<span></span>
							<svg class="deadline_remove_svg" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
												<path d="M14.5,12l6-6C20.8,5.7,21,5.2,21,4.8s-0.2-0.9-0.5-1.2C20.1,3.2,19.7,3,19.2,3S18.3,3.2,18,3.5l-6,6l-6-6 C5.7,3.2,5.2,3,4.8,3S3.9,3.2,3.5,3.5C3.2,3.9,3,4.3,3,4.8S3.2,5.7,3.5,6l6,6l-6,6c-0.7,0.7-0.7,1.8,0,2.5C3.9,20.8,4.3,21,4.8,21 s0.9-0.2,1.2-0.5l6-6l6,6c0.3,0.3,0.8,0.5,1.2,0.5s0.9-0.2,1.2-0.5c0.7-0.7,0.7-1.8,0-2.5L14.5,12z"></path></svg>
						</div>
						<div class="blank_no_deadline">
							<div class="blank_no_deadline_svg">
								<svg class="HighlightSol HighlightSol--core Icon CalendarIcon"
									viewBox="0 0 32 32" aria-hidden="true" focusable="false">
													<path
										d="M24,2V1c0-0.6-0.4-1-1-1s-1,0.4-1,1v1H10V1c0-0.6-0.4-1-1-1S8,0.4,8,1v1C4.7,2,2,4.7,2,8v16c0,3.3,2.7,6,6,6h16c3.3,0,6-2.7,6-6V8C30,4.7,27.3,2,24,2z M8,4v1c0,0.6,0.4,1,1,1s1-0.4,1-1V4h12v1c0,0.6,0.4,1,1,1s1-0.4,1-1V4c2.2,0,4,1.8,4,4v2H4V8C4,5.8,5.8,4,8,4z M24,28H8c-2.2,0-4-1.8-4-4V12h24v12C28,26.2,26.2,28,24,28z"></path></svg>
							</div>
							마감일 없음
						</div>
						<input type="text" id="input_deadline" style="height:0; width:0; border:0;"/>
						<!-- 수정중  -->
					</div>
					<div class="blank_rowstructure_02">
						<div class="blank_rowstructure_title_02">
							<span>프로젝트</span>
						</div>
						<div class="blank_manager_right_02">
							<div class="blank_project_add_title">
								<svg class="HighlightSol_MiniIcon" viewBox="0 0 24 24"
									aria-hidden="true" focusable="false">
													<path
										d="M10.4,4h3.2c2.2,0,3,0.2,3.9,0.7c0.8,0.4,1.5,1.1,1.9,1.9s0.7,1.6,0.7,3.9v3.2c0,2.2-0.2,3-0.7,3.9c-0.4,0.8-1.1,1.5-1.9,1.9s-1.6,0.7-3.9,0.7h-3.2c-2.2,0-3-0.2-3.9-0.7c-0.8-0.4-1.5-1.1-1.9-1.9c-0.4-1-0.6-1.8-0.6-4v-3.2c0-2.2,0.2-3,0.7-3.9C5.1,5.7,5.8,5,6.6,4.6C7.4,4.2,8.2,4,10.4,4z"></path></svg>
								<span>협업툴 개발 (1)</span>
								<div class="blank_section">
									<span>수행중</span>

									<svg
										class="HighlightSol MiniIcon ButtonThemeablePresentation-rightIcon ArrowDownMiniIcon"
										viewBox="0 0 24 24" aria-hidden="true" focusable="false">
														<path
											d="m18.185 7.851-6.186 5.191-6.186-5.191a1.499 1.499 0 1 0-1.928 2.298l7.15 6a1.498 1.498 0 0 0 1.928 0l7.15-6a1.5 1.5 0 0 0-1.928-2.298Z"></path></svg>
								</div>
								<svg class="blank_delete_project_svg" viewBox="0 0 24 24"
									aria-hidden="true" focusable="false">
													<path
										d="M14.5,12l6-6C20.8,5.7,21,5.2,21,4.8s-0.2-0.9-0.5-1.2C20.1,3.2,19.7,3,19.2,3S18.3,3.2,18,3.5l-6,6l-6-6 C5.7,3.2,5.2,3,4.8,3S3.9,3.2,3.5,3.5C3.2,3.9,3,4.3,3,4.8S3.2,5.7,3.5,6l6,6l-6,6c-0.7,0.7-0.7,1.8,0,2.5C3.9,20.8,4.3,21,4.8,21 s0.9-0.2,1.2-0.5l6-6l6,6c0.3,0.3,0.8,0.5,1.2,0.5s0.9-0.2,1.2-0.5c0.7-0.7,0.7-1.8,0-2.5L14.5,12z"></path></svg>
							</div>
							<div class="blank_project_add_title_under_projectAddBtn">이름</div>
							<div class="blank_AddProject_click_Projectlist">
								<input name="project_name" type="text"
									placeholder="마일스톤을 프로젝트에 추가 ..." />
								<div class="blank_AddProject_click_Projectlist_projectName">
									<div class="blank_AddProject_click_Projectlist_projectdiv">프로젝트
										hw(3)</div>
									<div class="blank_AddProject_click_Projectlist_projectdiv">개발자로
										취업하기(2)</div>
									<div class="blank_AddProject_click_Projectlist_projectdiv">프로젝트
										gj(4)</div>
								</div>
							</div>
						</div>
					</div>
					<div class="blank_rowstructure_03">
						<div class="blank_rowstructure_title_03">
							<span>종속관계</span>
						</div>
						<div class="blank_manager_right_03">종속 관계 추가</div>
						<div class="blank_clickingDependencies">
							<div class="blank_selectTask">
								<div class="blank_typeOfWork_parent">
									<div class="blank_preceding_typeOfWork" idx="1">
										<svg
											class="HighlightSol HighlightSol--core MiniIcon ButtonThemeablePresentation-leftIcon TaskDependencyDirectionSelector-hourglassIcon HourglassMiniIcon"
											data-testid="HourGlassIcon" viewBox="0 0 24 24"
											aria-hidden="true" focusable="false">
															<path
												d="M20 6.93V4h1a1 1 0 1 0 0-2H3a1 1 0 1 0 0 2h1v2.93c0 1.43.737 2.775 1.975 3.597.87.578 1.78 1.067 2.744 1.473-.964.406-1.875.896-2.744 1.473C4.738 14.295 4 15.64 4 17.07V20H3a1 1 0 1 0 0 2h18a1 1 0 1 0 0-2h-1v-2.93c0-1.43-.738-2.775-1.976-3.597A16.532 16.532 0 0 0 15.28 12a16.566 16.566 0 0 0 2.744-1.473C19.26 9.705 20 8.36 20 6.93Zm-3.084 8.209c.68.45 1.083 1.172 1.083 1.93V20H6v-2.93c0-.76.404-1.48 1.083-1.931 1.472-.978 3.082-1.67 4.917-2.112 1.835.442 3.446 1.134 4.917 2.112ZM18 6.93c0 .76-.404 1.48-1.083 1.931-1.472.978-3.082 1.67-4.917 2.112-1.835-.442-3.446-1.134-4.917-2.112C6.403 8.411 6 7.689 6 6.93V4h12v2.93Z"></path></svg>
										선행작업
										<svg
											class="HighlightSol HighlightSol--core MiniIcon ButtonThemeablePresentation-rightIcon TaskDependencyDirectionSelector-arrowDownIcon ArrowDownMiniIcon"
											viewBox="0 0 24 24" aria-hidden="true" focusable="false">
															<path
												d="m18.185 7.851-6.186 5.191-6.186-5.191a1.499 1.499 0 1 0-1.928 2.298l7.15 6a1.498 1.498 0 0 0 1.928 0l7.15-6a1.5 1.5 0 0 0-1.928-2.298Z"></path></svg>
									</div>
									<div class="blank_typeOfWork on" idx="2">
										<svg
											class="HighlightSol HighlightSol--core MiniIcon ButtonThemeablePresentation-leftIcon TaskDependencyDirectionSelector-hourglassIcon HourglassMiniIcon"
											data-testid="HourGlassIcon" viewBox="0 0 24 24"
											aria-hidden="true" focusable="false">
															<path
												d="M20 6.93V4h1a1 1 0 1 0 0-2H3a1 1 0 1 0 0 2h1v2.93c0 1.43.737 2.775 1.975 3.597.87.578 1.78 1.067 2.744 1.473-.964.406-1.875.896-2.744 1.473C4.738 14.295 4 15.64 4 17.07V20H3a1 1 0 1 0 0 2h18a1 1 0 1 0 0-2h-1v-2.93c0-1.43-.738-2.775-1.976-3.597A16.532 16.532 0 0 0 15.28 12a16.566 16.566 0 0 0 2.744-1.473C19.26 9.705 20 8.36 20 6.93Zm-3.084 8.209c.68.45 1.083 1.172 1.083 1.93V20H6v-2.93c0-.76.404-1.48 1.083-1.931 1.472-.978 3.082-1.67 4.917-2.112 1.835.442 3.446 1.134 4.917 2.112ZM18 6.93c0 .76-.404 1.48-1.083 1.931-1.472.978-3.082 1.67-4.917 2.112-1.835-.442-3.446-1.134-4.917-2.112C6.403 8.411 6 7.689 6 6.93V4h12v2.93Z"></path></svg>
										후속작업
										<svg
											class="HighlightSol HighlightSol--core MiniIcon ButtonThemeablePresentation-rightIcon TaskDependencyDirectionSelector-arrowDownIcon ArrowDownMiniIcon"
											viewBox="0 0 24 24" aria-hidden="true" focusable="false">
															<path
												d="m18.185 7.851-6.186 5.191-6.186-5.191a1.499 1.499 0 1 0-1.928 2.298l7.15 6a1.498 1.498 0 0 0 1.928 0l7.15-6a1.5 1.5 0 0 0-1.928-2.298Z"></path></svg>
									</div>

									<div class="blank_typeOfWork_select">
										<div class="blank_preceding_typeOfWork_select_list">
											<svg
												class="HighlightSol HighlightSol--core MiniIcon ButtonThemeablePresentation-leftIcon TaskDependencyDirectionSelector-hourglassIcon HourglassMiniIcon"
												data-testid="HourGlassIcon" viewBox="0 0 24 24"
												aria-hidden="true" focusable="false">
																<path
													d="M20 6.93V4h1a1 1 0 1 0 0-2H3a1 1 0 1 0 0 2h1v2.93c0 1.43.737 2.775 1.975 3.597.87.578 1.78 1.067 2.744 1.473-.964.406-1.875.896-2.744 1.473C4.738 14.295 4 15.64 4 17.07V20H3a1 1 0 1 0 0 2h18a1 1 0 1 0 0-2h-1v-2.93c0-1.43-.738-2.775-1.976-3.597A16.532 16.532 0 0 0 15.28 12a16.566 16.566 0 0 0 2.744-1.473C19.26 9.705 20 8.36 20 6.93Zm-3.084 8.209c.68.45 1.083 1.172 1.083 1.93V20H6v-2.93c0-.76.404-1.48 1.083-1.931 1.472-.978 3.082-1.67 4.917-2.112 1.835.442 3.446 1.134 4.917 2.112ZM18 6.93c0 .76-.404 1.48-1.083 1.931-1.472.978-3.082 1.67-4.917 2.112-1.835-.442-3.446-1.134-4.917-2.112C6.403 8.411 6 7.689 6 6.93V4h12v2.93Z"></path></svg>
											선행작업
										</div>
										<div class="blank_typeOfWork_select_list">
											<svg
												class="HighlightSol HighlightSol--core MiniIcon TaskDependencyDirectionSelector-blockingIcon BlockingMiniIcon"
												data-testid="BlockingIcon" viewBox="0 0 24 24"
												aria-hidden="true" focusable="false">
																<path
													d="M12 0C5.383 0 0 5.383 0 12s5.383 12 12 12 12-5.383 12-12S18.617 0 12 0Zm0 22C6.486 22 2 17.514 2 12S6.486 2 12 2s10 4.486 10 10-4.486 10-10 10Zm5-10a1 1 0 0 1-1 1H8a1 1 0 0 1 0-2h8a1 1 0 0 1 1 1Z"></path></svg>
											후속작업
										</div>
									</div>
								</div>





								<input name="wamOfName" type="text" placeholder="작업찾기"
									class="selectTask_input" />
							</div>

							<div class="blank_clickingDependencies_list">
								<div class="blank_clickingDependencies_list_workSelect">
									<div class="blank_clickingDependencies_list_workSelect_svg">
										<svg class="blank_taskCompletionCompoundIcon" viewBox="0 0 32 32"
											aria-hidden="true" focusable="false">
														<path
												d="M31,16c0,8.3-6.7,15-15,15S1,24.3,1,16S7.7,1,16,1S31,7.7,31,16z"
												class="CompoundIcon-outer"></path>
														<path
												d="M13.4,22.1c-0.3,0-0.5-0.1-0.7-0.3l-3.9-3.9c-0.4-0.4-0.4-1,0-1.4s1-0.4,1.4,0l3.1,3.1l8.1-8.1c0.4-0.4,1-0.4,1.4,0   s0.4,1,0,1.4l-8.9,8.9C13.9,22,13.7,22.1,13.4,22.1z"
												class="CompoundIcon-inner"></path>
														</svg>
										<svg class="blank_disabledIcon" viewBox="0 0 32 32"
											aria-hidden="true" focusable="false">
															<path
												d="M16,0C7.2,0,0,7.2,0,16s7.2,16,16,16s16-7.2,16-16l0,0C32,7.2,24.8,0,16,0z M2,16C2,8.3,8.2,2,16,2c3.4,0,6.6,1.2,9.2,3.4  L5.4,25.2C3.2,22.6,2,19.4,2,16z M16,30c-3.4,0-6.6-1.2-9.2-3.4L26.6,6.8c5.1,5.8,4.5,14.7-1.4,19.7C22.6,28.8,19.4,30,16,30z"></path>
														</svg>

									</div>
									<div class="blank_clickingDependencies_list_workSelect_wamOfName">프로젝트
										초안 작성하기</div>
									<div class="blank_clickingDependencies_list_workSelect_project">협업툴
										개발(1)</div>
								</div>
								<div class="blank_clickingDependencies_list_workSelect">
									<div class="blank_clickingDependencies_list_workSelect_svg">
										<svg
											class="HighlightSol HighlightSol--core CompoundIcon--small CompoundIcon TaskCompletionCompoundIcon TaskCompletionStatusIndicator--incomplete TaskCompletionStatusIndicator"
											viewBox="0 0 32 32" aria-hidden="true" focusable="false">
														<path
												d="M31,16c0,8.3-6.7,15-15,15S1,24.3,1,16S7.7,1,16,1S31,7.7,31,16z"
												class="CompoundIcon-outer"></path>
														<path
												d="M13.4,22.1c-0.3,0-0.5-0.1-0.7-0.3l-3.9-3.9c-0.4-0.4-0.4-1,0-1.4s1-0.4,1.4,0l3.1,3.1l8.1-8.1c0.4-0.4,1-0.4,1.4,0   s0.4,1,0,1.4l-8.9,8.9C13.9,22,13.7,22.1,13.4,22.1z"
												class="CompoundIcon-inner"></path>
														</svg>
									</div>
									<div class="blank_clickingDependencies_list_workSelect_wamOfName">미팅
										일정 확인</div>
									<div class="blank_clickingDependencies_list_workSelect_project">협업툴
										개발(1)</div>
								</div>
								<div class="blank_clickingDependencies_list_workSelect">
									<div class="blank_clickingDependencies_list_workSelect_svg">
										<svg
											class="HighlightSol HighlightSol--core CompoundIcon--small CompoundIcon MilestoneCompletionCompoundIcon MilestoneCompletionStatusIndicator--incomplete MilestoneCompletionStatusIndicator"
											data-testid="milestone_completion_status_indicator"
											viewBox="0 0 32 32" aria-hidden="true" focusable="false">
														<path
												d="M20.1,2.8c-2.3-2.3-5.9-2.3-8.2,0L2.7,12c-2.3,2.3-2.3,5.9,0,8.2l9.2,9.2c2.3,2.3,5.9,2.3,8.2,0l9.2-9.2  c2.3-2.3,2.3-5.9,0-8.2L20.1,2.8z"
												class="milestone_CompoundIcon-outer"></path>
														<path
												d="M13.4,22.2c-0.3,0-0.5-0.1-0.7-0.3L8.8,18c-0.4-0.4-0.4-1,0-1.4s1-0.4,1.4,0l3.1,3.1l8.1-8.1c0.4-0.4,1-0.4,1.4,0   s0.4,1,0,1.4l-8.9,8.9C13.9,22.1,13.7,22.2,13.4,22.2z"
												class="milestone_CompoundIcon-inner"></path>
														</svg>
									</div>
									<div class="blank_clickingDependencies_list_workSelect_wamOfName">기능명세서
										완성</div>
									<div class="blank_clickingDependencies_list_workSelect_project"></div>
								</div>
								<div class="blank_clickingDependencies_list_workSelect">
									<div class="blank_clickingDependencies_list_workSelect_svg">
										<svg
											class="HighlightSol HighlightSol--core CompoundIcon--small CompoundIcon TaskCompletionCompoundIcon TaskCompletionStatusIndicator--incomplete TaskCompletionStatusIndicator"
											viewBox="0 0 32 32" aria-hidden="true" focusable="false">
														<path
												d="M31,16c0,8.3-6.7,15-15,15S1,24.3,1,16S7.7,1,16,1S31,7.7,31,16z"
												class="CompoundIcon-outer"></path>
														<path
												d="M13.4,22.1c-0.3,0-0.5-0.1-0.7-0.3l-3.9-3.9c-0.4-0.4-0.4-1,0-1.4s1-0.4,1.4,0l3.1,3.1l8.1-8.1c0.4-0.4,1-0.4,1.4,0   s0.4,1,0,1.4l-8.9,8.9C13.9,22,13.7,22.1,13.4,22.1z"
												class="CompoundIcon-inner"></path>
														</svg>
									</div>
									<div class="blank_clickingDependencies_list_workSelect_wamOfName">자소서
										작성하기</div>
									<div class="blank_clickingDependencies_list_workSelect_project">개발자로
										취업하기(2)</div>
								</div>
							</div>
						</div>


						<!--선행관계 select -->
						<!--선행관계 select -->
						<!--선행관계 select -->
						<div class="blank_dependency_list_parent">
							<div class="blank_prior_work_parent">
								<div class="blank_prior_work" wamidx="">
									<div class="blank_prior_work_type">선행 작업</div>
									<div class="blank_prior_work_title">wam 의 이름</div>
									<div class="blank_prior_delBtn">
										<svg
											class="HighlightSol HighlightSol--core CompoundIcon--small CompoundIcon XCircleCompoundIcon TokenizerPillRemoveButton-removeIcon"
											viewBox="0 0 32 32" aria-hidden="true" focusable="false">
															<path
												d="M31,16c0,8.3-6.7,15-15,15S1,24.3,1,16S7.7,1,16,1S31,7.7,31,16z"
												class="CompoundIcon-outer"></path>
															<path
												d="M22.5,20.7c0.5,0.5,0.5,1.3,0,1.8c-0.2,0.2-0.5,0.4-0.9,0.4s-0.6-0.1-0.9-0.4L16,17.8l-4.7,4.7c-0.2,0.2-0.5,0.4-0.9,0.4s-0.6-0.1-0.9-0.4C9,22,9,21.2,9.5,20.7l4.7-4.7l-4.7-4.7C9,10.8,9,10,9.5,9.5c0.2-0.2,0.5-0.4,0.9-0.4s0.6,0.1,0.9,0.4l4.7,4.7l4.7-4.7c0.2-0.2,0.5-0.4,0.9-0.4s0.6,0.1,0.9,0.4c0.5,0.5,0.5,1.3,0,1.8L17.8,16L22.5,20.7z"
												class="CompoundIcon-inner"></path>
														</svg>
									</div>
								</div>
							</div>
							<!--종속관계 select -->
							<!--종속관계 select -->
							<!--종속관계 select -->
							<div class="blank_dependent_tasks_parent">
								<div class="blank_dependent_tasks" idx="">
									<div class="blank_dependent_tasks_type">후속 작업</div>
									<div class="blank_dependent_tasks_title">wam 의 이름</div>
									<div class="blank_dependent_tasks_delBtn">
										<svg
											class="HighlightSol HighlightSol--core CompoundIcon--small CompoundIcon XCircleCompoundIcon TokenizerPillRemoveButton-removeIcon"
											viewBox="0 0 32 32" aria-hidden="true" focusable="false">
															<path
												d="M31,16c0,8.3-6.7,15-15,15S1,24.3,1,16S7.7,1,16,1S31,7.7,31,16z"
												class="CompoundIcon-outer"></path>
															<path
												d="M22.5,20.7c0.5,0.5,0.5,1.3,0,1.8c-0.2,0.2-0.5,0.4-0.9,0.4s-0.6-0.1-0.9-0.4L16,17.8l-4.7,4.7c-0.2,0.2-0.5,0.4-0.9,0.4s-0.6-0.1-0.9-0.4C9,22,9,21.2,9.5,20.7l4.7-4.7l-4.7-4.7C9,10.8,9,10,9.5,9.5c0.2-0.2,0.5-0.4,0.9-0.4s0.6,0.1,0.9,0.4l4.7,4.7l4.7-4.7c0.2-0.2,0.5-0.4,0.9-0.4s0.6,0.1,0.9,0.4c0.5,0.5,0.5,1.3,0,1.8L17.8,16L22.5,20.7z"
												class="CompoundIcon-inner"></path>
														</svg>
									</div>
								</div>
							</div>
						</div>


					</div>
					<div class="blank_rowstructure_04">
						<div class="blank_rowstructure_title_04">
							<span>설명</span>
						</div>
						<div class="blank_manager_right_04"></div>
					</div>
					<div class="blank_rowstructure_05">
						<textarea name="milestone_content">내용 입력하세요 ..</textarea>
					</div>


					<!-- 수정중  -->
					<!-- 수정중  -->
					<div class="blank_Add_subtask_save_parent">
						<div class="blank_Add_subtask_save">
							<div class="blank_Add_subtask_checkSvg_save">
								<svg
									class="HighlightSol HighlightSol--core CompoundIcon--small CompoundIcon TaskCompletionCompoundIcon TaskCompletionStatusIndicator--incomplete TaskCompletionStatusIndicator TaskRowCompletionStatus-taskCompletionIcon--incomplete TaskRowCompletionStatus-taskCompletionIcon"
									viewBox="0 0 32 32" aria-hidden="true" focusable="false">
												<path
										d="M31,16c0,8.3-6.7,15-15,15S1,24.3,1,16S7.7,1,16,1S31,7.7,31,16z"
										class="check_CompoundIcon-outer"></path>
												<path
										d="M13.4,22.1c-0.3,0-0.5-0.1-0.7-0.3l-3.9-3.9c-0.4-0.4-0.4-1,0-1.4s1-0.4,1.4,0l3.1,3.1l8.1-8.1c0.4-0.4,1-0.4,1.4,0   s0.4,1,0,1.4l-8.9,8.9C13.9,22,13.7,22.1,13.4,22.1z"
										class="check_CompoundIcon-inner"></path>
												</svg>
							</div>
							<div class="blank_Add_subtask_save_title">
								<input name="Add_subtask_title" type="text" />
							</div>
							<div class="blank_Add_subtask_save_deadline">
								<svg class="HighlightSol HighlightSol--core Icon CalendarIcon"
									viewBox="0 0 32 32" aria-hidden="true" focusable="false">
													<path
										d="M24,2V1c0-0.6-0.4-1-1-1s-1,0.4-1,1v1H10V1c0-0.6-0.4-1-1-1S8,0.4,8,1v1C4.7,2,2,4.7,2,8v16c0,3.3,2.7,6,6,6h16c3.3,0,6-2.7,6-6V8C30,4.7,27.3,2,24,2z M8,4v1c0,0.6,0.4,1,1,1s1-0.4,1-1V4h12v1c0,0.6,0.4,1,1,1s1-0.4,1-1V4c2.2,0,4,1.8,4,4v2H4V8C4,5.8,5.8,4,8,4z M24,28H8c-2.2,0-4-1.8-4-4V12h24v12C28,26.2,26.2,28,24,28z"></path></svg>
							</div>
							<div class="blank_Add_subtask_save_manager">
								<svg class="HighlightSol HighlightSol--core Icon UserIcon"
									viewBox="0 0 32 32" aria-hidden="true" focusable="false">
													<path
										d="M16,18c-4.4,0-8-3.6-8-8s3.6-8,8-8s8,3.6,8,8S20.4,18,16,18z M16,4c-3.3,0-6,2.7-6,6s2.7,6,6,6s6-2.7,6-6S19.3,4,16,4z M29,32c-0.6,0-1-0.4-1-1v-4.2c0-2.6-2.2-4.8-4.8-4.8H8.8C6.2,22,4,24.2,4,26.8V31c0,0.6-0.4,1-1,1s-1-0.4-1-1v-4.2C2,23,5,20,8.8,20h14.4c3.7,0,6.8,3,6.8,6.8V31C30,31.6,29.6,32,29,32z"></path></svg>
							</div>
							<!-- 매니저 버튼 클릭시  -->
							<div class="blank_assignmentOfmanager">
								<div class="blank_assignmentOfmanager_title">
									<span>담당자</span>
									<svg class="assignmentOfmanager_title_XIcon"
										viewBox="0 0 32 32" aria-hidden="true" focusable="false">
														<path
											d="M18.1,16L27,7.1c0.6-0.6,0.6-1.5,0-2.1s-1.5-0.6-2.1,0L16,13.9l-8.9-9C6.5,4.3,5.6,4.3,5,4.9S4.4,6.4,5,7l8.9,8.9L5,24.8c-0.6,0.6-0.6,1.5,0,2.1c0.3,0.3,0.7,0.4,1.1,0.4s0.8-0.1,1.1-0.4l8.9-8.9l8.9,8.9c0.3,0.3,0.7,0.4,1.1,0.4s0.8-0.1,1.1-0.4c0.6-0.6,0.6-1.5,0-2.1L18.1,16z"></path></svg>
								</div>
								<div class="blank_assignmentOfmanager_select">
									<div class="blank_assignmentOfmanager_select_input">
										<input name="manager" type="text" placeholder="이름 또는 이메일" />
										<svg
											class="HighlightSol HighlightSol--core CompoundIcon--xsmall CompoundIcon XCircleCompoundIcon"
											viewBox="0 0 24 24" aria-hidden="true" focusable="false">
															<path
												d="M23,12c0,6.1-4.9,11-11,11S1,18.1,1,12S5.9,1,12,1S23,5.9,23,12z"
												class="CompoundIcon-outer"></path>
															<path
												d="M13.4,12l4.3-4.3c0.4-0.4,0.4-1,0-1.4s-1-0.4-1.4,0L12,10.6L7.7,6.3c-0.4-0.4-1-0.4-1.4,0s-0.4,1,0,1.4l4.3,4.3l-4.3,4.3c-0.4,0.4-0.4,1,0,1.4C6.5,17.9,6.7,18,7,18s0.5-0.1,0.7-0.3l4.3-4.3l4.3,4.3c0.2,0.2,0.5,0.3,0.7,0.3s0.5-0.1,0.7-0.3c0.4-0.4,0.4-1,0-1.4L13.4,12z"
												class="CompoundIcon-inner"></path></svg>
									</div>
									또는
									<div class="blank_assignmentOfmanager_select_assignedToMe">나에게
										배정</div>
								</div>
							</div>
							<div class="blank_assignmentOfmanager_list">
								<div class="blank_assignmentOfmanager_list_select">
									<img src="../../img01/짱구1.jpg">
									<div class="assignmentOfmanager_list_select_memberName">지숭</div>
									<div class="assignmentOfmanager_list_select_memberEmail">jisooasana02@gmail.com</div>
								</div>
								<div class="blank_assignmentOfmanager_list_select">
									<img src="../../img01/짱구2.jpg">
									<div class="assignmentOfmanager_list_select_memberName">현우</div>
									<div class="assignmentOfmanager_list_select_memberEmail">jisooasana02@gmail.com</div>
								</div>
								<div class="blank_assignmentOfmanager_list_select">
									<img src="../../img01/철수.png">
									<div class="assignmentOfmanager_list_select_memberName">길주</div>
									<div class="assignmentOfmanager_list_select_memberEmail">jisooasana02@gmail.com</div>
								</div>
								<div class="blank_invite_team_members_by_email">
									<svg
										class="HighlightSol HighlightSol--core Icon TypeaheadActionItemStructure-icon PlusIcon"
										viewBox="0 0 32 32" aria-hidden="true" focusable="false">
														<path
											d="M26,14h-8V6c0-1.1-0.9-2-2-2l0,0c-1.1,0-2,0.9-2,2v8H6c-1.1,0-2,0.9-2,2l0,0c0,1.1,0.9,2,2,2h8v8c0,1.1,0.9,2,2,2l0,0c1.1,0,2-0.9,2-2v-8h8c1.1,0,2-0.9,2-2l0,0C28,14.9,27.1,14,26,14z"></path></svg>
									<span>이메일로 팀원 초대</span>
								</div>
							</div>
							<!-- 매니저 버튼 클릭시  -->
						</div>
					</div>
					<!-- 수정중  -->
					<!-- 수정중  -->


					<div class="blank_rowstructure_06">
						<button class="blank_rowstructure_06_btn">
							<svg
								class="HighlightSol MiniIcon ButtonThemeablePresentation-leftIcon PlusMiniIcon"
								viewBox="0 0 24 24" aria-hidden="true" focusable="false">
												<path
									d="M10,10V4c0-1.1,0.9-2,2-2s2,0.9,2,2v6h6c1.1,0,2,0.9,2,2s-0.9,2-2,2h-6v6c0,1.1-0.9,2-2,2s-2-0.9-2-2v-6H4c-1.1,0-2-0.9-2-2s0.9-2,2-2H10z"></path></svg>
							<span>하위 작업 추가</span>
						</button>
					</div>
					<div class="blank_comment">
						<div class="blank_comment_title">
							<span>댓글</span>
						</div>
						<div class="blank_comment_story">
							<div class="blank_profile_img">
								<img src="../img01/짱구1.jpg"></img>
							</div>
							<div class="blank_profile_name">지숭</div>
							<div>님이 이 작업을 생성했습니다</div>
							<div class="blank_milestone_update_date">3일전</div>
						</div>
						<div class="blank_feedblockstroy">
							<div class="blank_feedblockstroy_complete">
								<svg
									class="HighlightSol CompoundIcon--large CompoundIcon MilestoneCompletionCompoundIcon MilestoneCompletionStatusIndicator--complete MilestoneCompletionStatusIndicator"
									data-testid="milestone_completion_status_indicator"
									viewBox="0 0 32 32" aria-hidden="true" focusable="false">
													<path
										d="M20.1,2.8c-2.3-2.3-5.9-2.3-8.2,0L2.7,12c-2.3,2.3-2.3,5.9,0,8.2l9.2,9.2c2.3,2.3,5.9,2.3,8.2,0l9.2-9.2  c2.3-2.3,2.3-5.9,0-8.2L20.1,2.8z"
										class="CompoundIcon-outer"></path>
													<path
										d="M13.4,22.2c-0.3,0-0.5-0.1-0.7-0.3L8.8,18c-0.4-0.4-0.4-1,0-1.4s1-0.4,1.4,0l3.1,3.1l8.1-8.1c0.4-0.4,1-0.4,1.4,0   s0.4,1,0,1.4l-8.9,8.9C13.9,22.1,13.7,22.2,13.4,22.2z"
										class="CompoundIcon-inner"></path></svg>
							</div>
							<div class="blank_feedblockstroy_name">지숭</div>
							<div>님이 마일스톤을 완료로 표시했습니다</div>
							<div class="blank_feedblockstroy_update_date">3일전</div>
						</div>
					</div>
				</div>

			</div>
			<div class="blank_milestone_footer">
				<div class="blank_milestone_comment_content">
					<div class="blank_profile_img">
						<img src="../img01/짱구1.jpg"></img>
					</div>
					<div class="blank_milestone_comment_input_child02">
						<textarea>댓글추가</textarea>
					</div>
				</div>
				<div class="blank_milestone_Participants">
					<div class="blank_milestone_Participants_child01">협업 참여자</div>
					<div class="blank_collaboration_profile">
						<div>
							<img src="img01/짱구1.jpg"></img>
						</div>
						<div>
							<img src="img01/철수.jpeg"></img>
						</div>
						<div>
							<svg class="HighlightSol MiniIcon UserMiniIcon"
								viewBox="0 0 24 24" aria-hidden="true" focusable="false">
												<path
									d="M12,14c-3.859,0-7-3.14-7-7S8.141,0,12,0s7,3.14,7,7-3.141,7-7,7Zm0-12c-2.757,0-5,2.243-5,5s2.243,5,5,5,5-2.243,5-5-2.243-5-5-5Zm10,21v-2c0-2.757-2.243-5-5-5H7c-2.757,0-5,2.243-5,5v2c0,.552,.447,1,1,1s1-.448,1-1v-2c0-1.654,1.346-3,3-3h10c1.654,0,3,1.346,3,3v2c0,.552,.447,1,1,1s1-.448,1-1Z"></path></svg>
						</div>
						<div class="blank_add_collaboration_profile">
							<svg class="HighlightSol MiniIcon UserMiniIcon"
								viewBox="0 0 24 24" aria-hidden="true" focusable="false">
												<path
									d="M12,14c-3.859,0-7-3.14-7-7S8.141,0,12,0s7,3.14,7,7-3.141,7-7,7Zm0-12c-2.757,0-5,2.243-5,5s2.243,5,5,5,5-2.243,5-5-2.243-5-5-5Zm10,21v-2c0-2.757-2.243-5-5-5H7c-2.757,0-5,2.243-5,5v2c0,.552,.447,1,1,1s1-.448,1-1v-2c0-1.654,1.346-3,3-3h10c1.654,0,3,1.346,3,3v2c0,.552,.447,1,1,1s1-.448,1-1Z"></path></svg>
						</div>
						<div class="blank_plus_icon_coooperation">
							<svg class="HighlightSol MiniIcon--small MiniIcon PlusMiniIcon"
								viewBox="0 0 24 24" aria-hidden="true" focusable="false">
												<path
									d="M10,10V4c0-1.1,0.9-2,2-2s2,0.9,2,2v6h6c1.1,0,2,0.9,2,2s-0.9,2-2,2h-6v6c0,1.1-0.9,2-2,2s-2-0.9-2-2v-6H4c-1.1,0-2-0.9-2-2s0.9-2,2-2H10z"></path></svg>
						</div>
					</div>
					<div class="blank_milestone_Participants_child03">
						<svg
							class="HighlightSol Icon--small Icon ButtonThemeablePresentation-leftIcon BellIcon"
							viewBox="0 0 32 32" aria-hidden="true" focusable="false">
											<path
								d="M2.03 20.635A5.87 5.87 0 0 0 4 16.249V12c0-3.247 1.276-6.288 3.593-8.563C9.909 1.164 12.962-.064 16.224.002 22.717.121 28 5.667 28 12.365v3.884c0 1.675.718 3.273 1.97 4.386 1.047.932 1.33 2.411.704 3.682C30.17 25.339 29.061 26 27.85 26H4.152c-1.211 0-2.32-.661-2.824-1.684-.626-1.271-.344-2.75.704-3.682l-.002.001ZM16 31a5.51 5.51 0 0 0 4.392-2.196c.248-.328.004-.804-.407-.804h-7.969c-.411 0-.655.476-.407.804A5.508 5.508 0 0 0 16 31Z"></path></svg>
						<span>마일스톤 나가기</span>
					</div>


					<!-- input 길주  -->
					<!-- input 길주  -->

					<!--------------------------- 협업참여자 text --------------------------->
					<div class="blank_show_cooperation">
						<div class="blank_cooperation_profile">
							<img class="blank_writer_profile_img" src="img/jjangu.png">
							<div class="blank_cooperation_name">
								<span>길주</span> <i class="bi-x"></i>
							</div>
						</div>
						<input type="text" name="cooperation" id="plus_cooperation" />
					</div>
					<!--------------------------- 협업참여자 text --------------------------->
					<!------------------------------- 초대 멤버 조회 ------------------------->
					<div class="blank_assignmentOfmanager_list">
						<div class="blank_assignmentOfmanager_list_select">
							<img src="img/jjangu.png">
							<div class="blank_assignmentOfmanager_list_select_memberName">지숭</div>
							<div class="blank_assignmentOfmanager_list_select_memberEmail">jisooasana02@gmail.com</div>
						</div>
						<div class="blank_assignmentOfmanager_list_select">
							<img src="img/cute.jjang.png">
							<div class="blank_assignmentOfmanager_list_select_memberName">현우</div>
							<div class="blank_assignmentOfmanager_list_select_memberEmail">jisooasana02@gmail.com</div>
						</div>
						<div class="blank_assignmentOfmanager_list_select">
							<img src="img/개 아이콘.jpeg">
							<div class="blank_assignmentOfmanager_list_select_memberName">길주</div>
							<div class="ablank_ssignmentOfmanager_list_select_memberEmail">jisooasana02@gmail.com</div>
						</div>
					</div>
					<!-- input 길주  -->
					<!-- input 길주  -->
				</div>
			</div>
		</div>
		<!-- 새로운 마일스톤 생성 페이지  --><!-- 새로운 마일스톤 생성 페이지  --><!-- 새로운 마일스톤 생성 페이지  -->
		<div class="black_screen" style="display: none;"></div>
	
	</div>
	
</body>
</html>