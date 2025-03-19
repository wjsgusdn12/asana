<%@page import="dto.PortfolioDto"%>
<%@page import="dto.MemberDto"%>
<%@page import="dto.ProjectDto"%>
<%@page import="dto.AlarmUpdateDto"%>
<%@page import="dao.AlarmUpdateDao"%>
<%@page import="dto.Project_participantsAllDto"%>
<%@page import="dto.MessageThingsDto"%>
<%@page import="dto.TimeLineThingDto"%>
<%@page import="dto.Access_settingAllDto"%>
<%@page import="dto.ProjectStatusDto"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="dto.WamAllDto"%>

<%@page import="dao.StatusGetAllDao"%>
<%@page import="dao.PortfolioDao"%>
<%@page import="dto.PortfolioAllDto"%>
<%@page import="dto.StatusAllDto"%>
<%@page import="dto.GoalSelectAllDto"%>
<%@page import="dto.GoalThingsDto"%>
<%@page import="dao.GoalDao"%>
<%@page import="dto.MemberAllDto"%>
<%@page import="dao.MemberDao"%>
<%@page import="java.util.ArrayList"%>
<%@page import="dto.Project_participantsThingsDto"%>
<%@page import="dto.ProjectAllDto"%>
<%@page import="dao.ProjectDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
	ArrayList<AlarmUpdateDto> alarmUpdateList = (ArrayList<AlarmUpdateDto>)request.getAttribute("alarmUpdateList");
	ArrayList<Project_participantsThingsDto> listProject_participants = (ArrayList<Project_participantsThingsDto>)request.getAttribute("listProject_participants");
	int loginMemberIdx = (int)request.getAttribute("loginMemberIdx");
	ProjectAllDto projectAllDto1 = (ProjectAllDto)request.getAttribute("projectAllDto1");
	String title = (String)request.getAttribute("title");
	ArrayList<Project_participantsThingsDto> projectParticipantsIdx = (ArrayList<Project_participantsThingsDto>)request.getAttribute("projectParticipantsIdx");
	MemberDao memberDao = (MemberDao)request.getAttribute("memberDao");
	StatusAllDto statusAllDto = (StatusAllDto)request.getAttribute("statusAllDto");
	ArrayList<GoalSelectAllDto> goalSelectProjectlist = (ArrayList<GoalSelectAllDto>)request.getAttribute("goalSelectProjectlist");
	GoalDao goalDao = (GoalDao)request.getAttribute("goalDao");
	ArrayList<PortfolioAllDto> portfolioAllDtolist11 = (ArrayList<PortfolioAllDto>)request.getAttribute("portfolioAllDtolist11");
	StatusGetAllDao statusGetAllDao = (StatusGetAllDao)request.getAttribute("statusGetAllDao");
	ArrayList<WamAllDto> wamDtolist = (ArrayList<WamAllDto>)request.getAttribute("wamDtolist");
	String startDate = (String)request.getAttribute("startDate");
	ProjectAllDto projectAllDto2 = (ProjectAllDto)request.getAttribute("projectAllDto2");
	ArrayList<TimeLineThingDto> timeLineThingDto1 = (ArrayList<TimeLineThingDto>)request.getAttribute("timeLineThingDto1");
	int projectRange = (int)request.getAttribute("projectRange");
	ArrayList<Project_participantsThingsDto> projectMemberList = (ArrayList<Project_participantsThingsDto>)request.getAttribute("projectMemberList");
	ArrayList<ProjectStatusDto> projectStatusDtolist = (ArrayList<ProjectStatusDto>)request.getAttribute("projectStatusDtolist");
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
<html>
<head>
<meta charset="UTF-8">
<title>Asana 개요</title>
<link rel="stylesheet" href="css/main_outline.css" />
<link rel="stylesheet" href="css/asana_main.css" />
<link rel="stylesheet" href="css/add_member_content.css" />
<link rel="stylesheet" href="css/project_status_update.css" />
<link rel="stylesheet" href="css/member_alarm_setting_page.css" />
<link rel="stylesheet" href="css/Main_Common.css" />

<script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
<link rel="stylesheet" href="http://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/css/toastr.min.css">
<script src="http://cdnjs.cloudflare.com/ajax/libs/toastr.js/2.0.2/js/toastr.min.js"></script>

<script>
	/************************************** 상단바&사이드바 js ****************************************/
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
	/************************************** 상단바&사이드바 js ****************************************/
	//토스터 사용기 : 내용마다 색상 변경 //토스터 사용기 : 내용마다 색상 변경  //토스터 사용기 : 내용마다 색상 변경 
	function ssonda_toast(msg) {
		if(msg.indexOf('상태를 업데이트 했습니다')>-1) {
			toastr.info("", msg);			// blue
		} else if(msg.indexOf('삭제하였습니다')>-1 || msg.indexOf('끊어졌습니다')>-1) {
			toastr.warning("", msg);		// yellow
		} else {
			toastr.success("", msg);		// green
		}
	}
		
		let webSocket = new WebSocket("ws://localhost:9091/Asana_0318/broadcasting") //서버와 연결 
		webSocket.onmessage = function(e){
//			alert("서버로부터의 메시지 : " + e.data);
			// e.data = "새알림_3_message://프로젝트 협업방법의 상태를 업데이트 했습니다."
			if(e.data.startsWith("새알림_")) {
				let s = e.data.replace("새알림_","");	// 3_message://프로젝트 협업방법의 상태를 업데이트 했습니다.
				let alarm_member_idx = Number( s.substring(0, s.indexOf("_")) );
				if(alarm_member_idx ==${loginMemberIdx}) {
					let msg = s.substring(s.indexOf("_")).replace("_message://","");
					ssonda_toast(msg);	
					//$.ajax() ---> AjaxDeleteAlarmUpdateServlet ---> DELETE FROM alarm_update WHERE member_idx=?
					$.ajax({ //삭제 ajax는 잘 되는지 확인해봐야함 ***** 1/ 24
						type:'post',
						url:'ExAlarmUpdateDelete',
						data:{"memberidx" : alarm_member_idx, "projectidx" : ${projectIdx}},
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
	
	//알림을 조회 : 토스터를 사용 //알림을 조회 : 토스터를 사용 
	$(function(){
		<% for(AlarmUpdateDto dto : alarmUpdateList) { %>
			ssonda_toast('<%=dto.getContent()%>');
		<% } %>
	//알림을 조회 : 토스터를 사용 //알림을 조회 : 토스터를 사용 
	
		/* 최신상태 업데이트 클릭시 조회되는 ajax  */ 
		$(".status_update_content").click(function(){
			let projectStatusIdx = $(this).closest(".status_update_content").attr("id");
			$.ajax({
				type: 'post',
				data:{"projectStatusIdx" : projectStatusIdx},
				url : 'ExProjectStatus',
				success:function(data){
				//	console.log(data);
					let projectstatusdateFormatPost = data.projectstatusdateFormatPost;
					let profileImg = data.profileImg;
					let nickName = data.nickName;
					let backgroundColor = data.statusBackGroundColor;
					let statusName = data.statusName;
					let statusCharColor = data.statusChar;
					$(".status_update_content_right_child01_title").find("span:nth-child(2)").html(projectstatusdateFormatPost);
					$(".status_update_content_right_child02").find("img").attr("src","img/" + profileImg);
					$(".status_update_content_right_text01").html(nickName);
					$(".status_update_name").find("span").html(statusName);
					$(".status_update_name").css("background" , backgroundColor);
					$(".status_update_name").find("span").css("color" , statusCharColor);
					$(".status_update_content_right_name02").html(nickName);
					$(".status_update_content_right_text02").html( data.strDaysBefore);
					$(".status_update_content_right_child01").css("border-top-color", statusCharColor);
				},
				error:function(r,s,e){}
			});
		});
	});

	/*프로젝트 상태 업데이트 목록 클릭시 ajax *//*프로젝트 상태 업데이트 목록 클릭시 ajax *//*프로젝트 상태 업데이트 목록 클릭시 ajax */
	 $(function(){
		$(document).on("click", ".status_update_content_left_child", function(){
			let clickProjectStatusIdx = $(this).attr("idx");
			$.ajax({
				type: 'post',
				data:{"clickProjectStatusIdx" :  clickProjectStatusIdx},
				url : 'ExClickProjectStatus',
				success:function(data){
					//console.log(data);
					let projectstatusdateFormatPost = data.projectstatusdateFormatPost;
					let profileImg = data.profileImg;
					let nickName = data.nickName;
					let backgroundColor = data.statusBackGroundColor;
					let statusName = data.statusName;
					let statusCharColor = data.statusChar;
					
					$(".status_update_content_right_child01_title").find("span:nth-child(2)").html(projectstatusdateFormatPost);
					$(".status_update_content_right_child02").find("img").attr("src","img/" + profileImg);
					$(".status_update_content_right_text01").html(nickName);
					$(".status_update_name").find("span").html(statusName);
					$(".status_update_name").css("background" , backgroundColor);
					$(".status_update_name").find("span").css("color" , statusCharColor);
					$(".status_update_content_right_name02").html(nickName);
					$(".status_update_content_right_text02").html( data.strDaysBefore);
					$(".status_update_content_right_child01").css("border-top-color", statusCharColor);
				},
				error:function(r,s,e){}
			});
		});
	 });
	 
	 //프로젝트 상태 업데이트 최신 insert하는 ajax 
	 //프로젝트 상태 업데이트시 웹소켓에 메세지 보내기 
	 $(function(){
		 $(".status > div").click(function(){
			let statusIdx = $(this).attr("idx"); 
			/* alert(str);  */
			$.ajax({
				type:'post',
				data:{"statusIdx":statusIdx , "loginMemberIdx":${loginMemberIdx} , "projectIdx":${projectIdx} },
				url:'ExProjectStatusInsert',
				success:function(data){
					/* 프로젝트 참여자중 나를 제외한 멤버idx 와 실시간 알림 내용을 업데이트 */
					<% for(Project_participantsThingsDto dto : listProject_participants) { %>
						<% if(dto.getMember_idx() != loginMemberIdx) { %>
							webSocket.send("새알림_<%=dto.getMember_idx()%>_message://<%=projectAllDto1.getTitle()%>의 상태를 업데이트 했습니다.");
						<% } %>
					<% } %>				
					console.log(data);
					let projectStatusIdx = data.projectStatusIdx;
					let projectstatusdateFormatPost = data.projectstatusdateFormatPost;
					let nickname = data.nickname;
					let profileImg = data.profileImg;
					let strDaysBefore = data.strDaysBefore;
					let statusCharColor = data.statusCharColor;
					let statusName = data.statusName;
					let arrStatus = data.arrStatus;
					$(".status_update_content").attr("id",projectStatusIdx);
					$(".status_update_content02_span01").find("span").html(projectstatusdateFormatPost);
					$(".status_update_content04_span1").html(nickname);
					$(".status_update_content04_span2").html(strDaysBefore);
					$(".status_update_content01").css("background", statusCharColor);
					$(".status_update_title").find("span").html(statusName);
					$(".status_update_title").find("span").css("color", statusCharColor);
		
					$(".status_update_content_left").html("");
					for(let i=0; i<arrStatus.length; i++){
						//console.log("목록 list 들 : "+ arrStatus[i].porjectStatusListIdx);
						let appendList = `<div class="status_update_content_left_child" idx="`+arrStatus[i].porjectStatusListIdx+`">
											<div class="status_update_content_left_child_01">
												<span class="span01">상태 업데이트 - </span> 
												<span class="span01">`+arrStatus[i].projectStatusdateFormatPost02+`</span> 
												<span class="span02">`+arrStatus[i].projectStatusdateFormatPost02+`</span>
											</div>
											<div class="status_update_content_left_child_02">
												<div class="status_update_name_second" style="background-color:`+arrStatus[i].projectStatusListBackground+`">
													<svg class="MiniIcon StatusDotFillMiniIcon" viewBox="0 0 24 24"
														aria-hidden="true" focusable="false" style="fill:`+arrStatus[i].projectStatusCircleColor+`">
														<path
															d="m20,12c0,4.42-3.58,8-8,8s-8-3.58-8-8S7.58,4,12,4s8,3.58,8,8Z"></path></svg>
													<span style="color:`+arrStatus[i].projectStatusListCharColor+`">`+arrStatus[i].projectStatusName+`</span>
												</div>
											</div>
										</div>`; 
						$(".status_update_content_left").append(appendList);
					};
				},
				error:function(r,s,e){}
			});
		 });
	 });
 
	function func1() {
		$(".black_screen").css('display', 'block');
		$(".add_member_content").css('display', 'block');
	}
	function func2() {
		$(".tatus_update_parent02").css('display', 'block');
		$(".black_screen").css('display', 'block');
	}
	function linkedprojectcreation_pop_up() {
		
		$(".transparent_screen").css('display', 'block');
		$(".connected_goal_update").css('display', 'block');
	}
	function linkedPortfolioCreationPopUp() {
		$(".transparent_screen").css('display', 'block');
		$(".connected_portfolio_click").css('display', 'block');
		$(".linked_portflio_search_list_popup").css('display', 'block');
		/* $(".connected_portfolio_click_parent").css('display', 'block'); */
	}
	function milestoneCreationPopUp() {
		$(".transparent_screen").css('display', 'block');
		$(".milestone_click_add").css('display', 'flex');
	}
	function timelineClickStatusUpdate() {
		$(".tatus_update_parent02").css('display', 'block');
		$(".black_screen").css('display', 'block');
	}
	function PublicAccessSettings() {
		$(".access_setting_option").css('display', 'block');
	}
	function Click_Notification_management() {
		$(".member_alarm_main").css('display', 'block');
		$(".darker_wallpapers").css('display', 'block');
	}

	$(function() {
		/****************** 상태 업데이트 팝업창 *****************/
		$(".Icon_XIcon").click(function() {
			$(".tatus_update_parent02").css('display', 'none');
			$(".black_screen").css('display', 'none');
		});
		/****************** 상태 업데이트 팝업창 *****************/

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
		$(".transparent_screen").click(function() {
			$(".connected_goal_update").css('display', 'none');
			$(".transparent_screen").css('display', 'none');
			$(".connected_portfolio_click").css('display', 'none');
			$(".linked_portflio_search_list_popup").css('display', 'none');
			$(".milestone_click_add").css('display', 'none');
		});

		$(".add_member_child01_icon > svg:last-child").click(function() {
			$(".black_screen").css('display', 'none');
			$(".add_member_content").css('display', 'none');
		});
		//div를 누르면 보여주기 
		$(document).on("click", "#member_profile_view" , function(){
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

		$(".darker_wallpapers").click(function() {
			$(".darker_wallpapers").css('display', 'none');
			$(".member_alarm_main").css('display', 'none');
		});

		/* 별 온오프 제이쿼리 *//* 별 온오프 제이쿼리 *//* 별 온오프 제이쿼리 *//* 별 온오프 제이쿼리 *//* 별 온오프 제이쿼리 */
		$(".Parent_Icon_Plus").click(function() {
			linkedprojectcreation_pop_up();
		});
		$(".connected_portfolio1_plusIcon").click(function() {
			linkedPortfolioCreationPopUp();
		});
		$(".milestone_title_Icon_PlusIcon").click(function() {
			milestoneCreationPopUp();
		});
		$(".activityfeed_timeline_vesion3").click(function() {
			timelineClickStatusUpdate();
		});
		$(".activityfeed_timeline").click(function() {
			func1();
		});

		// 이건가 ..?
		
		$(".role_button").click(function() {
			$(this).parent().find(".click_change_authority_under").toggleClass("on");
		});
		
		$(".role_button_havingOn").click(function() {
			$(this).parent().find(".click_change_authority").toggleClass("on");
		});

		//공유 : 선택되어진 권한 클릭시 리스트 div 보여주기 
		$(".role_button_projectManager").click(function() {
			$(this).parent().find(".click_change_authority_under").toggleClass("on");
		});

		//공유 : 편집자 선택시 해당 div 보여주기 
		$(".role_button_editor").click(function() {
			$(this).parent().find(".click_change_authority_under").toggleClass("on");
		});

		//공유 : 댓글작성자 선택시 해당 div 보여주기 
		$(".role_button_CommentManager").click(function() {
			$(this).parent().find(".click_change_authority_under").toggleClass("on");
		});

		//공유 : 조회자 선택시 해당 div 보여주기 
		$(".role_button_Viewer").click(function() {
			$(this).parent().find(".click_change_authority_under").toggleClass("on");
		});

		//공유 : 선택되어진 권한 클릭시 리스트 div 보여주기 : 언더 
		$(".role_button_projectManager").click(
				function() {
					$(this).parent().find(".click_change_authority_under")
							.toggleClass("on");
				});

		//공유 : 편집자 선택시 해당 div 보여주기  : 언더 
		$(".role_button_editor").click(
				function() {
					$(this).parent().find(".click_change_authority_under")
							.toggleClass("on");
				});

		//공유 : 댓글작성자 선택시 해당 div 보여주기 : 언더 
		$(".role_button_CommentManager").click(
				function() {
					$(this).parent().find(".click_change_authority_under")
							.toggleClass("on");
				});
		
		//append --> 동적으로 생성된 태그에 이벤트 핸들러 처리 
		//공유 : 선택되어진 권한 클릭시 리스트 div 보여주기 : 언더 
		$(document).on("click", ".role_button_projectManager", function(){
			$(this).parent().find(".click_change_authority_under").toggleClass("on");
		});
		
		$(document).on("click", ".role_button_editor", function(){
			$(this).parent().find(".click_change_authority_under").toggleClass("on");
		});
		
		$(document).on("click", ".role_button_CommentManager", function(){
			$(this).parent().find(".click_change_authority_under").toggleClass("on");
		});

		//공유 : 조회자 선택시 해당 div 보여주기 : 언더 
		$(".role_button_Viewer").click(
				function() {
					$(this).parent().find(".click_change_authority_under").toggleClass("on");
				});

		$(".add_member_child03_02").click(function() {
			PublicAccessSettings();
		});
		$(".add_member_child04_01").click(function() {
			Click_Notification_management();
		});

		//공유 : 리스트에서 클릭시 권한 변경하기 
		//권한변경시 모든 div 토글 없애기 
		$(".click_change_authority_line").click(function() {
			$(this).parent().parent().find(".role_button_projectManager").removeClass("on");
			$(this).parent().parent().find(".role_button_editor").removeClass("on");
			$(this).parent().parent().find(".role_button_CommentManager").removeClass("on");
			$(this).parent().parent().find(".role_button_Viewer").removeClass("on");
			//만약에 첫번째  span의 첫번째 자식의 이름이 같다면 on붙여주기 
			let name = $(this).find("span:first-child").text().trim();
			if (name === "프로젝트 관리자") {
				$(this).parent().parent().find(
						".role_button_projectManager")
						.toggleClass("on");
				//$(".role_button_projectManager").addClass("on");
			} else if (name === "편집자") {
				$(this).parent().parent().find(".role_button_editor")
						.toggleClass("on");
				//$(".role_button_editor").toggleClass("on");
			} else if (name === "댓글 작성자") {
				$(this).parent().parent().find(
						".role_button_CommentManager")
						.toggleClass("on");
				//$(".role_button_CommentManager").toggleClass("on");
			} else if (name === "조회자") {
				$(this).parent().parent().find(".role_button_Viewer")
						.toggleClass("on");
				//$(".role_button_Viewer").toggleClass("on");
			}
		});

		//공유 : 리스트에서 클릭시 권한 변경하기 : 언더 
		//권한변경시 모든 div 토글 없애기 
		//동적으로 생성된 데이터 이벤트 적용하기 
		$(document).on("click", ".click_change_authority_list_under",function(){
			$(this).parent().parent().find(
					".role_button_projectManager").removeClass("on");
			$(this).parent().parent().find(".role_button_editor")
					.removeClass("on");
			$(this).parent().parent().find(
					".role_button_CommentManager").removeClass("on");
			$(this).parent().parent().find(".role_button_Viewer")
					.removeClass("on");

			//만약에 첫번째  span의 첫번째 자식의 이름이 같다면 on붙여주기 
			let name = $(this).find("span:first-child").text().trim();
			if (name === "프로젝트 관리자") {
				//this 를 이용해서 
				$(this).parent().parent().find(".role_button_projectManager").addClass("on");
				//$(".role_button_projectManager").addClass("on");
			} else if (name === "편집자") {
				$(this).parent().parent().find(".role_button_editor").addClass("on");
				//$(".role_button_editor").toggleClass("on");
			} else if (name === "댓글 작성자") {
				$(this).parent().parent().find(".role_button_CommentManager").addClass("on");
				//$(".role_button_CommentManager").toggleClass("on");
			} else if (name === "조회자") {
				$(this).parent().parent().find(".role_button_Viewer").addClass("on");
				//$(".role_button_Viewer").toggleClass("on");
			}
		});
		
		//공유 : 리스트에서 클릭시 권한 변경하기 : 언더 
		//권한변경시 모든 div 토글 없애기 
	/* 	$(".click_change_authority_list_under").click(function(){
			$(this).parent().parent().find(
			".role_button_projectManager").removeClass("on");
			$(this).parent().parent().find(".role_button_editor")
					.removeClass("on");
			$(this).parent().parent().find(
					".role_button_CommentManager").removeClass("on");
			$(this).parent().parent().find(".role_button_Viewer")
					.removeClass("on");
		
			//만약에 첫번째  span의 첫번째 자식의 이름이 같다면 on붙여주기 
			let name = $(this).find("span:first-child").text().trim();
			if (name === "프로젝트 관리자") {
				//this 를 이용해서 
				$(this).parent().parent().find(
						".role_button_projectManager").addClass("on");
				//$(".role_button_projectManager").addClass("on");
			} else if (name === "편집자") {
				$(this).parent().parent().find(".role_button_editor")
						.addClass("on");
				//$(".role_button_editor").toggleClass("on");
			} else if (name === "댓글 작성자") {
				$(this).parent().parent().find(
						".role_button_CommentManager").addClass("on");
				//$(".role_button_CommentManager").toggleClass("on");
			} else if (name === "조회자") {
				$(this).parent().parent().find(".role_button_Viewer")
						.addClass("on");
				//$(".role_button_Viewer").toggleClass("on");
			}
		}); */
		
		$(".click_change_authority_list_under").click(function() {
			$(this).parent().parent().find(".role_button_projectManager").removeClass("on");
			$(this).parent().parent().find(".role_button_editor").removeClass("on");
			$(this).parent().parent().find(".role_button_CommentManager").removeClass("on");
			$(this).parent().parent().find(".role_button_Viewer").removeClass("on");

			//만약에 첫번째  span의 첫번째 자식의 이름이 같다면 on붙여주기 
			let name = $(this).find("span:first-child").text().trim();
			if (name === "프로젝트 관리자") {
				//this 를 이용해서 
				$(this).parent().parent().find(".role_button_projectManager").addClass("on");
				//$(".role_button_projectManager").addClass("on");
			} else if (name === "편집자") {
				$(this).parent().parent().find(".role_button_editor").addClass("on");
				//$(".role_button_editor").toggleClass("on");
			} else if (name === "댓글 작성자") {
				$(this).parent().parent().find(".role_button_CommentManager").addClass("on");
				//$(".role_button_CommentManager").toggleClass("on");
			} else if (name === "조회자") {
				$(this).parent().parent().find(".role_button_Viewer").addClass("on");
				//$(".role_button_Viewer").toggleClass("on");
			}
		}); 
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
	
	//프로젝트 상태 업데이트 목록 
	$(document).on("click", ".status_update_content_left > div", function(){
		$(".status_update_content_left_child").css("background" , "white");
		$(this).css("background" , "#f1f2fc");
	});
	
	//프로젝트 상태 업데이트 목록 삭제 
	$(function(){
		$(".status_update_content_right_icon > .Icon.MoreIcon").click(function(){
			$(".showMoreButton").toggleClass("on");
		});
	/* 	$(".showMoreButton").click(function(){
			let projectStatusIdx 1= $(".status_update_content").attr("id");
			let yn = confirm("정말 삭제하겠습니까 ? ");
			if(yn==true){
				location.href="../../ExProjectStatusDelete?projectStatusIdx=" + projectStatusIdx;
			}
		});  */
	});
	
	//프로젝트 상태 업데이트 목록 삭제 ajax //프로젝트 상태 업데이트 목록 삭제 ajax //프로젝트 상태 업데이트 목록 삭제 ajax 
	$(function(){
		$(".showMoreButton").click(function(){
			let projectStatusIdx = $(".status_update_content").attr("id");
			$.ajax({
				type: 'post',
				data:{"projectStatusIdx" :  projectStatusIdx},
				url : 'ExProjectStatusDelete',
				success:function(data){
					//console.log(data);
					location.reload();
				
				},
				error:function(r,s,e){}
			});
		});
	});
	
	//프로젝트 멤버 관련 ajax 
	
	$(function(){
		$(document).on("click",".member_profile_view_save_parent" , function(){
			$(".member_profile_view_save_parent").find(".delete_memberProfile_view").removeClass("on");
			$(this).find(".delete_memberProfile_view").toggleClass("on");
		});
		
		//프로젝트 멤버에서 삭제하기 
		$(document).on("click",".delete_memberProfile_view",function(){
		let memberIdx = $(this).parent(".member_profile_view_save_parent").attr("idx");
			$.ajax({
				type:'post',
				data:{"memberIdx" : memberIdx , "projectIdx" : ${projectIdx}},
				url:'ExProjectDeleteMemberIdx',
				success:function(data){
					//console.log(data);
					let jsonArr = data.jsonArr;
					//삭제시 html clear 
					//멤버 추가 append  
					$("#member_profile_parent").html("");
					let str = `
						<div id="member_profile_view">
							<div id="member_profile_default">
								<svg class="Icon PlusIcon" viewBox="0 0 32 32" aria-hidden="true" focusable="false">
									<path d="M26,14h-8V6c0-1.1-0.9-2-2-2l0,0c-1.1,0-2,0.9-2,2v8H6c-1.1,0-2,0.9-2,2l0,0c0,1.1,0.9,2,2,2h8v8c0,1.1,0.9,2,2,2l0,0c1.1,0,2-0.9,2-2v-8h8c1.1,0,2-0.9,2-2l0,0C28,14.9,27.1,14,26,14z"></path></svg>
							</div>
							<span>멤버 추가</span>
						</div>`;
					$("#member_profile_parent").append(str);
					
					//멤버 list 
					for(let i=0; i<jsonArr.length; i++){
						
					let str =`<div class="member_profile_view_save_parent" idx="`+jsonArr[i].memberIdx+`">
								<div id="member_profile_view_save">
									<div id="member_profile_save">
										<img src="img/`+ jsonArr[i].profileImg+`"/>
									</div>
									<div id="member_profile_name1_save">
										<div id="member_profile_name_save">
											<span>`+jsonArr[i].nickName+`</span>
										</div>
										<div id="member_profile_role_save">
											<span>`+jsonArr[i].authorityName+`</span>
										</div>
									</div>
								</div>
								<div class="delete_memberProfile_view">
									프로젝트에서 제거 
								</div>
							</div>`;
				//	console.log(str); 
					$("#member_profile_parent").append(str); 
					}
					
					$(".parent_of_the_popup_manager_parent").html("");
					
					//멤버 팝업창 list 
					for(let i=0; i<jsonArr.length; i++){
						let strDiv02 = `<div class="Parent_of_the_popup_manager" memberidx="`+jsonArr[i].memberIdx+`">
							<div class="add_member_child06">
							<div class="add_member_child06_child_left">
								<img src="img/`+jsonArr[i].profileImg+`"></img>
							</div>
							<div class="add_member_child06_child_center">
								<span>`+jsonArr[i].nickName+`</span> <br /> 
								<span>`+jsonArr[i].email+`</span>
							</div>
							<!-- 원래 데이터의 span 와 이름이 같을때 class 에 on 붙여주기  -->

							<div class="role_button_projectManager` + (jsonArr[i].authorityIdx==1 ? ` on` : `` )+`" idx="1">
								<span>프로젝트 관리자</span>
								<svg
									class="MiniIcon ButtonThemeablePresentation-rightIcon ArrowDownMiniIcon"
									viewBox="0 0 24 24" aria-hidden="true" focusable="false">
																<path
										d="m18.185 7.851-6.186 5.191-6.186-5.191a1.499 1.499 0 1 0-1.928 2.298l7.15 6a1.498 1.498 0 0 0 1.928 0l7.15-6a1.5 1.5 0 0 0-1.928-2.298Z"></path></svg>
							</div>
							<div class="role_button_editor`+(jsonArr[i].authorityIdx==2 ? ` on` : `` )+`" idx="2">
								<span>편집자</span>
								<svg
									class="MiniIcon ButtonThemeablePresentation-rightIcon ArrowDownMiniIcon"
									viewBox="0 0 24 24" aria-hidden="true" focusable="false">
																<path
										d="m18.185 7.851-6.186 5.191-6.186-5.191a1.499 1.499 0 1 0-1.928 2.298l7.15 6a1.498 1.498 0 0 0 1.928 0l7.15-6a1.5 1.5 0 0 0-1.928-2.298Z"></path></svg>
							</div>
							<div class="role_button_CommentManager `+(jsonArr[i].authorityIdx==3 ? ` on` : ``)+`" idx="3">
								<span>댓글 작성자</span>
								<svg
									class="MiniIcon ButtonThemeablePresentation-rightIcon ArrowDownMiniIcon"
									viewBox="0 0 24 24" aria-hidden="true" focusable="false">
																<path
										d="m18.185 7.851-6.186 5.191-6.186-5.191a1.499 1.499 0 1 0-1.928 2.298l7.15 6a1.498 1.498 0 0 0 1.928 0l7.15-6a1.5 1.5 0 0 0-1.928-2.298Z"></path></svg>
							</div>

							<div class="click_change_authority_under projectmanager">
								<div class="click_change_authority_list_under" idx="1">
									<div class="transparent_div"></div>
									<div class="click_change_authority_list_under_div">
										<span>프로젝트 관리자</span><br /> <span>설정을 변경하고 프로젝트를 수정하거나
											삭제를 할 수 있는 모든 액세스 권한 </span>
									</div>
								</div>
								<div class="click_change_authority_list_under editor" idx="2">
									<div class="transparent_div"></div>
									<div class="click_change_authority_list_under_div">
										<span>편집자</span><br /> <span>프로젝트에 있는 모든것을 추가 , 편집, 삭제 할
											수 있습니다.</span>
									</div>
								</div>
								<div class="click_change_authority_list_under CommentManager"
									idx="3">
									<div class="transparent_div"></div>
									<div class="click_change_authority_list_under_div">
										<span>댓글 작성자</span><br /> <span>댓글을 작성할 수 있지만 프로젝트에 있는
											내용은 편집할 수 없습니다.</span>
									</div>
								</div>
							</div>
						</div>
					</div>`;
					
					$(".parent_of_the_popup_manager_parent").append(strDiv02);
						
					}
				},
				error:function(r,s,e){}
			});
		});
		
		//프로젝트 멤버 : 초대시 검색창 
		$(".add_member_child_save_input_parent > input").keyup(function(){
			let memberidx = ${loginMemberIdx};
			let nickName = $(".add_member_child_save_input_parent > input").val();
			if(nickName.length>0){
				$.ajax({
					type:'post',
					data:{"projectIdx":${projectIdx} , "nickName" : nickName, "memberidx" :memberidx },
					url:'ExProjectMemberInsert',
					success:function(arr){
						$(".member_search_box").html("");
						//console.log(arr);
						let jsonArr = arr;
						let memberIdx = null;
						for(let i=0; i<jsonArr.length; i++){
							let searchDiv=`
											<div class="member_search_box_list" idx="`+jsonArr[i].memberIdx+`">
												<div class="member_search_box_img">
													<img src="img/`+jsonArr[i].profileImg+`"/>
												</div>
												<div class="member_search_box_text">
													<span>`+jsonArr[i].nickName+`</span><br/>
													<span>`+jsonArr[i].email+`</span>
												</div>
											</div>
										`;
							$(".member_search_box").append(searchDiv);
						} 
					},
					error:function(r,s,e){}
				});
			}
		});
		
		//프로젝트 멤버 검색 : 프로젝트 멤버 idx 선택 
		$(document).on("click" , ".member_search_box_list" , function(){
			let memberIdx = $(this).attr("idx");
			$.ajax({
				type:'post',
				data:{"memberIdx" : memberIdx },
				url:'ExProjectMemberClick',
				success:function(data){
					let profileImg = data.profileImg;
					let nickName = data.nickName;
					let memberIdx = data.memberIdx;
					//console.log(nickName);
					$(".add_member_child_save_span").css("display", "flex");
					$(".add_member_child_save_span > span").html(nickName);
					$(".add_member_child_save_span").attr("idx",memberIdx);
				 	$(".member_search_box_list").css("display","none"); 
				 	$(".add_member_child_save_input_parent > input").css("display" , "none");
				},
				error:function(r,s,e){}
			});
		});
		
		//프로젝트 멤버 검색 : 두번째 
		$(document).on("click" , ".add_member_child_save_input_parent", function(){
			$(".add_member_child_save_input_parent > input").css("display","block")
		});
		
		//프로젝트 멤버 검색  : 프로젝트 멤버 idx 선택 -->삭제svg
		$(".add_member_child_save_span > svg").click(function(){
			$(".add_member_child_save_span").css("display","none");
		});	
		
		//프로젝트 멤버 초대 : 멤버 idx, 권한 idx 데이터 넘기기 
		$(".projectMemberInvite").click(function(){
			let memberIdx = $(".add_member_child_save_span").attr("idx");
			let authority = $(".role_button_havingOn > div.on").attr("idx");
			$.ajax({
				type:'post',
				data:{"memberIdx":memberIdx, "authority":authority, "projectIdx":${projectIdx}},
				url:'ExProjectMemberInviteBtn',
				success:function(data){
					let nickName = data.nickName;
					let email= data.email;
					let profileImg = data.profileImg;
					let authorityName = data.authorityName;
					let authorityIdx = data.authorityIdx;
					let memberIdx = data.memberIdx;
					
					//멤버 추가 팝업창에서 append 처리 
					let addDiv = `
					<div class="Parent_of_the_popup_manager" memberidx="`+memberIdx+`">
						<div class="add_member_child06">
						<div class="add_member_child06_child_left">
							<img src="img/`+profileImg+`"></img>
						</div>
						<div class="add_member_child06_child_center">
							<span>`+nickName+`</span> <br /> <span>`+email+`</span>
						</div>
						<!-- 원래 데이터의 span 와 이름이 같을때 class 에 on 붙여주기  -->
	
						<div class="role_button_projectManager `+(authorityIdx==1 ? ` on` : ``)+`" idx="1">
							<span>프로젝트 관리자</span>
							<svg
								class="MiniIcon ButtonThemeablePresentation-rightIcon ArrowDownMiniIcon"
								viewBox="0 0 24 24" aria-hidden="true" focusable="false">
															<path
									d="m18.185 7.851-6.186 5.191-6.186-5.191a1.499 1.499 0 1 0-1.928 2.298l7.15 6a1.498 1.498 0 0 0 1.928 0l7.15-6a1.5 1.5 0 0 0-1.928-2.298Z"></path></svg>
						</div>
						<div class="role_button_editor`+ (authorityIdx ==2 ? ` on` : ``)+`" idx="2">
							<span>편집자</span>
							<svg
								class="MiniIcon ButtonThemeablePresentation-rightIcon ArrowDownMiniIcon"
								viewBox="0 0 24 24" aria-hidden="true" focusable="false">
															<path
									d="m18.185 7.851-6.186 5.191-6.186-5.191a1.499 1.499 0 1 0-1.928 2.298l7.15 6a1.498 1.498 0 0 0 1.928 0l7.15-6a1.5 1.5 0 0 0-1.928-2.298Z"></path></svg>
						</div>
						<div class="role_button_CommentManager`+(authorityIdx==3 ? ` on` : ``)+` " idx="3">
							<span>댓글 작성자</span>
							<svg
								class="MiniIcon ButtonThemeablePresentation-rightIcon ArrowDownMiniIcon"
								viewBox="0 0 24 24" aria-hidden="true" focusable="false">
															<path
									d="m18.185 7.851-6.186 5.191-6.186-5.191a1.499 1.499 0 1 0-1.928 2.298l7.15 6a1.498 1.498 0 0 0 1.928 0l7.15-6a1.5 1.5 0 0 0-1.928-2.298Z"></path></svg>
						</div>
	
						<div class="click_change_authority_under projectmanager">
							<div class="click_change_authority_list_under" idx="1">
								<div class="transparent_div"></div>
								<div class="click_change_authority_list_under_div">
									<span>프로젝트 관리자</span><br /> <span>설정을 변경하고 프로젝트를 수정하거나
										삭제를 할 수 있는 모든 액세스 권한 </span>
								</div>
							</div>
							<div class="click_change_authority_list_under editor" idx="2">
								<div class="transparent_div"></div>
								<div class="click_change_authority_list_under_div">
									<span>편집자</span><br /> <span>프로젝트에 있는 모든것을 추가 , 편집, 삭제 할
										수 있습니다.</span>
								</div>
							</div>
							<div class="click_change_authority_list_under CommentManager"
								idx="3">
								<div class="transparent_div"></div>
								<div class="click_change_authority_list_under_div">
									<span>댓글 작성자</span><br /> <span>댓글을 작성할 수 있지만 프로젝트에 있는
										내용은 편집할 수 없습니다.</span>
								</div>
							</div>
						</div>
					</div>
				</div>`;
				
				//프로젝트 역할에서 멤버 list 에서 append 처리
				
				let addDiv02 = `
					<div class="member_profile_view_save_parent"
					idx="`+memberIdx+`">
					<div id="member_profile_view_save">
						<div id="member_profile_save">
							<img src="img/`+profileImg+`" />
						</div>
						<div id="member_profile_name1_save">
							<div id="member_profile_name_save">
								<span>`+nickName+`</span>
							</div>
							<div id="member_profile_role_save">
								<span>`+authorityName+`</span>
							</div>
						</div>
					</div>
					<div class="delete_memberProfile_view">프로젝트에서 제거</div>
				</div>`;
				
				$("#member_profile_parent").append(addDiv02);
				$(".parent_of_the_popup_manager_parent").append(addDiv);
					
				}, 
				error:function(r,s,e){}
				
			});
		});
		
		//프로젝트 멤베 엑세스설정 변경 
		$(".access_setting_option_member").click(function(){
			let range = $(this).attr("idx");
			$.ajax({
				type:'post',
				data:{"range" : range , "projectIdx" : ${projectIdx}},
				url:'ExupdateProjectRange',
				success:function(data){
					let updateRange = data.range;
					$(".access_setting_option").css("display" , "none");
					let range02 = `<div class="add_member_child03_02_left">
											<svg class="Icon PrivacyDropdown-buttonIcon LockIcon"
											viewBox="0 0 32 32" aria-hidden="true" focusable="false">
											<path
												d="M25.999 10h-2V8c0-4.411-3.589-8-8-8s-8 3.589-8 8v2h-2c-2.206 0-4 1.794-4 4v10c0 2.206 1.794 4 4 4h20c2.206 0 4-1.794 4-4V14c0-2.206-1.794-4-4-4Zm-16-2c0-3.309 2.691-6 6-6s6 2.691 6 6v2h-12V8Zm18 16c0 1.103-.897 2-2 2h-20c-1.103 0-2-.897-2-2V14c0-1.103.897-2 2-2h20c1.103 0 2 .897 2 2v10Z"></path></svg>
										<span>멤버들에게만 공개</span>
									</div>`;
					let range01 = 
						`<div class="add_member_child03_02_left">
							<svg class="Icon PrivacyDropdown-optionIcon UsersIcon"
								viewBox="0 0 32 32" aria-hidden="true" focusable="false">
								<path
									d="M21,18c-4.411,0-8-3.589-8-8S16.589,2,21,2s8,3.589,8,8-3.589,8-8,8Zm0-14c-3.309,0-6,2.691-6,6s2.691,6,6,6,6-2.691,6-6-2.691-6-6-6Zm11,25v-2c0-3.86-3.141-7-7-7h-8c-3.859,0-7,3.14-7,7v2c0,.552,.447,1,1,1s1-.448,1-1v-2c0-2.757,2.243-5,5-5h8c2.757,0,5,2.243,5,5v2c0,.552,.447,1,1,1s1-.448,1-1ZM12,17c0-.552-.447-1-1-1-3.309,0-6-2.691-6-6s2.691-6,6-6c.553,0,1-.448,1-1s-.447-1-1-1C6.589,2,3,5.589,3,10s3.589,8,8,8c.553,0,1-.448,1-1ZM2,29v-2c0-2.757,2.243-5,5-5h2c.553,0,1-.448,1-1s-.447-1-1-1h-2C3.141,20,0,23.14,0,27v2C0,29.552,.447,30,1,30s1-.448,1-1Z"></path>
							</svg>
							<span>내 작업 공간 </span>
						</div>`; 
					$(".add_member_child03_02").html("");
					if(updateRange==1){
						$(".add_member_child03_02").append(range01);
					}else{
						$(".add_member_child03_02").append(range02);
					}
				},
				error:function(r,s,e){}
			});
		});
		
		//프로젝트 멤버 권한 변경 
		$(document).on("click", ".click_change_authority_under.projectmanager > div", function(){
			let authority = $(this).attr("idx");
			let memberidx = $(this).parent().parent().parent().closest(".Parent_of_the_popup_manager").attr("memberidx");
			
			$.ajax({
				type:'post',
				data:{"authority" : authority, "memberidx" : memberidx , "projectIdx":${projectIdx}},
				url:'ExMemberAuthorityUpdate',
				success:function(data){
					let memberidx = data.memberidx;
					let authorityName = data.authorityName;
					let authority = data.authority;
					let projectIdx = data.projectIdx;
					console.log(authorityName);
					
					//for- each 문 
					//member_profile_view_save_parent div 의 idx 만큼 반복하는데 item 은 this 의 값과 같음 
					$(".member_profile_view_save_parent").each(function(idx, item){
						if($(item).attr("idx") == memberidx){
							$(item).find("#member_profile_role_save").html("<span>"+authorityName+"</span>");
						}
					});
				},
				error:function(r,s,e){}
			});
		});
	});
	
	
	//연결된 목표 
	$(function(){
		//연결된 목표 + 클릭시 검색할수있는 리스트 조회 
		$(".Parent_Icon_Plus").click(function(){
			$.ajax({
				type:'post',
				data:{"projectIdx" : ${projectIdx}},
				url:'ExLinkedGoalOfList',
				success:function(data){
					let goalIdxArr = data.goalIdxArr; //목표 idx array 
					let goalDetailjsonArr = data.goalDetailjsonArr; //목표 디테일 array 
					console.log(goalIdxArr);
					//console.log(jsonArr);
					$(".connected_goal_click_content_child_parent").html("");
					// 조회될 목표 리스트들 
					for(let i=0; i<goalDetailjsonArr.length; i++){
						let str = `
							<div class="connected_goal_click_content_child" goalIdx="`+goalIdxArr[i].goalIdx+`">
								<div class="goal_icon_click">
									<svg
										class="HighlightSol HighlightSol--core Icon--small Icon Omnibutton-menuIcon GoalSimpleIcon"
										viewBox="0 0 32 32" aria-hidden="true" focusable="false">
											<path
											d="M19.533 3.417A4.208 4.208 0 0 0 15.998 1.5a4.204 4.204 0 0 0-3.534 1.916L.694 21.443a4.186 4.186 0 0 0-.179 4.342A4.166 4.166 0 0 0 4.228 28h23.54a4.166 4.166 0 0 0 3.712-2.215 4.184 4.184 0 0 0-.179-4.342L19.532 3.416l.001.001Zm10.188 21.417a2.193 2.193 0 0 1-1.954 1.167H4.228a2.192 2.192 0 0 1-1.954-1.167 2.217 2.217 0 0 1 .094-2.296L14.14 4.51A2.183 2.183 0 0 1 16 3.501c.762 0 1.44.368 1.86 1.01l11.77 18.027c.456.701.49 1.559.092 2.296Z"></path></svg>
								</div>
								<div class="click_content">
									<div class="click_content_title">`+goalDetailjsonArr[i].title+`</div>
									<span>FY`+goalDetailjsonArr[i].ficalYear+` `+goalDetailjsonArr[i].projectPeriodName+`</span> 
								</div>
								<div class="click_profile_img">
									<img src="img/`+goalDetailjsonArr[i].profileImg+`" />
								</div>
							</div>`;
							$(".connected_goal_click_content_child_parent").append(str);
					} 
					
					//새 목표 생성 div 
					/* let str02 =`<div class="create_new_goal">
						<div class="create_new_goal_icon">
						<svg class="HighlightSol HighlightSol--core Icon PlusIcon"
							viewBox="0 0 32 32" aria-hidden="true" focusable="false">
								<path
								d="M26,14h-8V6c0-1.1-0.9-2-2-2l0,0c-1.1,0-2,0.9-2,2v8H6c-1.1,0-2,0.9-2,2l0,0c0,1.1,0.9,2,2,2h8v8c0,1.1,0.9,2,2,2l0,0c1.1,0,2-0.9,2-2v-8h8c1.1,0,2-0.9,2-2l0,0C28,14.9,27.1,14,26,14z"></path></svg>
					</div>
					<span>새 목표 생성</span> 
				<!-- 새로운 목표 팝업  --><!-- 새로운 목표 팝업  --><!-- 새로운 목표 팝업  -->
				<div class="createGoal_popup">
					<div class="createGoal_TopUp">
						<span>새로운 목표 생성</span>
						<div class="createGoal_deleteBtn">
							<svg class="HighlightSol HighlightSol--core Icon XIcon" viewBox="0 0 32 32" aria-hidden="true" focusable="false"><path d="M18.1,16L27,7.1c0.6-0.6,0.6-1.5,0-2.1s-1.5-0.6-2.1,0L16,13.9l-8.9-9C6.5,4.3,5.6,4.3,5,4.9S4.4,6.4,5,7l8.9,8.9L5,24.8c-0.6,0.6-0.6,1.5,0,2.1c0.3,0.3,0.7,0.4,1.1,0.4s0.8-0.1,1.1-0.4l8.9-8.9l8.9,8.9c0.3,0.3,0.7,0.4,1.1,0.4s0.8-0.1,1.1-0.4c0.6-0.6,0.6-1.5,0-2.1L18.1,16z"></path></svg>
						</div>
					</div>
					<div class="createGoal_content">
						<div class="createGoalLog_name">
							<div class="createGoalLog_name_firstLable">목표 제목</div>
							<div class="createGoalLog_name_input">
								<input type="text" name="createGoal"/>
							</div>
						</div>
						<div class="createGoal_middleRow">
								<div class="createGoal_timePeriod">
									<div class="createGoal_timePeriod_child01">
										기간
									</div>
									<div class="createGoal_timePeriod_child02_parent">
										<div class="createGoal_timePeriod_child02">
											<div class="createGoal_timePeriod_child02_SelectedDate">
												<span>FY25 1분기</span>
												<span>1월 1일 - 3월 3일</span>
											</div>
											<div class="createGoal_timePeriod_child02_svg">
												<svg class="HighlightSol HighlightSol--core Icon ButtonThemeablePresentation-rightIcon TimePeriodSingleSelect-downIcon DownIcon" viewBox="0 0 32 32" aria-hidden="true" focusable="false"><path d="M27.874 11.036a1.5 1.5 0 0 0-2.113-.185L16 19.042l-9.761-8.191a1.5 1.5 0 1 0-1.928 2.298l10.726 9a1.498 1.498 0 0 0 1.928 0l10.726-9a1.5 1.5 0 0 0 .185-2.113h-.002Z"></path></svg>
											</div>
										</div>
										<div class="timePeriodSelectDropdown">
											<div class="last_year">
												<svg class="HighlightSol HighlightSol--core Icon LeftIcon" viewBox="0 0 32 32" aria-hidden="true" focusable="false"><path d="M8.8,16c0-0.3,0.1-0.7,0.3-0.9l9-11c0.5-0.6,1.5-0.7,2.1-0.2s0.7,1.5,0.2,2.1l-8.2,10l8.2,10c0.5,0.6,0.4,1.6-0.2,2.1s-1.6,0.4-2.1-0.2l-9-11C8.9,16.7,8.8,16.3,8.8,16z"></path></svg>
											</div>
											<div class="timePeriodSelectDropdown_card">
												<div class="timePeriodSelectDropdown_card_child01">
													<div class="timePeriodSelectDropdown_option_year">
														<span>FY 25</span>
														<span>1월 1일 - 12월 31일</span>
													</div>
												</div>
												<div class="timePeriodSelectDropdown_card_child02">
													<div class="timePeriodSelectDropdown_option_FirstHalfyear">상반기</div>
													<div class="timePeriodSelectDropdown_option_SecondHalfyear">하반기</div>
												</div>
												<div class="timePeriodSelectDropdown_card_child03">
													<div class="timePeriodSelectDropdown_option">1분기</div>
													<div class="timePeriodSelectDropdown_option">2분기</div>
													<div class="timePeriodSelectDropdown_option">3분기</div>
													<div class="timePeriodSelectDropdown_option">4분기</div>
												</div>
											</div>
											<div class="next_year">
												<svg class="HighlightSol HighlightSol--core Icon RightIcon" viewBox="0 0 32 32" aria-hidden="true" focusable="false"><path d="M13.148 4.31a1.5 1.5 0 0 0-2.298 1.928L19.04 16l-8.19 9.761a1.499 1.499 0 1 0 2.298 1.928l9-10.726a1.5 1.5 0 0 0 0-1.929l-9-10.726v.003Z"></path></svg>
											</div>
										</div>
									</div>
								</div>
						</div>
					</div>
					<div class="createGoal_bottomBar">
						<div class="cancle_btn">
							<span>취소</span>
						</div>
						<div class="saveGoal">
							<span>목표 저장</span>
						</div>
					</div>
				</div>
				</div> `;
					
					$(".connected_goal_click_content").append(str02); */
				},
				error:function(r,s,e){
					console.log("[에러] code: " + r.status + ", message: " + r.responseText + ", error: " + e);
				}
			});
		});
		
		//연결된 목표 검색 : 해당 목표 조회 LIKE %문자열% 
		$(".connected_goal_click_search > input").keyup(function(){
			let goalTitle = $(this).val();
			if(goalTitle.length>0){
				$.ajax({
					type:'post',
					data:{"projectIdx" : ${projectIdx} , "goalTitle" : goalTitle},
					url:'ExConnectedGoalSearch',
					success:function(data){
						let count = data.count; // 0 와 1 을 확인 
						if(count > 0){
							let goalIdxArr = data.goalIdxArr;
							let goalDetailjsonArr = data.goalDetailjsonArr;
							
							$(".connected_goal_click_content_child_parent").html("");
							$(".connected_goal_click_content").css("height","165px");
							// 조회될 목표 리스트들 
							for(let i=0; i<goalDetailjsonArr.length; i++){
								let str = `
									<div class="connected_goal_click_content_child" goalIdx="`+goalIdxArr[i].goalIdx+`">
										<div class="goal_icon_click">
											<svg
												class="HighlightSol HighlightSol--core Icon--small Icon Omnibutton-menuIcon GoalSimpleIcon"
												viewBox="0 0 32 32" aria-hidden="true" focusable="false">
													<path
													d="M19.533 3.417A4.208 4.208 0 0 0 15.998 1.5a4.204 4.204 0 0 0-3.534 1.916L.694 21.443a4.186 4.186 0 0 0-.179 4.342A4.166 4.166 0 0 0 4.228 28h23.54a4.166 4.166 0 0 0 3.712-2.215 4.184 4.184 0 0 0-.179-4.342L19.532 3.416l.001.001Zm10.188 21.417a2.193 2.193 0 0 1-1.954 1.167H4.228a2.192 2.192 0 0 1-1.954-1.167 2.217 2.217 0 0 1 .094-2.296L14.14 4.51A2.183 2.183 0 0 1 16 3.501c.762 0 1.44.368 1.86 1.01l11.77 18.027c.456.701.49 1.559.092 2.296Z"></path></svg>
										</div>
										<div class="click_content">
											<div class="click_content_title">`+goalDetailjsonArr[i].title+`</div>
											<span>FY`+goalDetailjsonArr[i].ficalYear+` `+goalDetailjsonArr[i].projectPeriodName+`</span> 
										</div>
										<div class="click_profile_img">
											<img src="img/`+goalDetailjsonArr[i].profileImg+`" />
										</div>
									</div>`;
									$(".connected_goal_click_content_child_parent").append(str);
							}
							
							//새 목표 생성 div 
							let str02 =`<div class="create_new_goal">
								<div class="create_new_goal_icon">
								<svg class="HighlightSol HighlightSol--core Icon PlusIcon"
									viewBox="0 0 32 32" aria-hidden="true" focusable="false">
										<path
										d="M26,14h-8V6c0-1.1-0.9-2-2-2l0,0c-1.1,0-2,0.9-2,2v8H6c-1.1,0-2,0.9-2,2l0,0c0,1.1,0.9,2,2,2h8v8c0,1.1,0.9,2,2,2l0,0c1.1,0,2-0.9,2-2v-8h8c1.1,0,2-0.9,2-2l0,0C28,14.9,27.1,14,26,14z"></path></svg>
							</div>
							<span>새 목표 생성</span> 
						<!-- 새로운 목표 팝업  --><!-- 새로운 목표 팝업  --><!-- 새로운 목표 팝업  -->
						<div class="createGoal_popup">
							<div class="createGoal_TopUp">
								<span>새로운 목표 생성</span>
								<div class="createGoal_deleteBtn">
									<svg class="HighlightSol HighlightSol--core Icon XIcon" viewBox="0 0 32 32" aria-hidden="true" focusable="false"><path d="M18.1,16L27,7.1c0.6-0.6,0.6-1.5,0-2.1s-1.5-0.6-2.1,0L16,13.9l-8.9-9C6.5,4.3,5.6,4.3,5,4.9S4.4,6.4,5,7l8.9,8.9L5,24.8c-0.6,0.6-0.6,1.5,0,2.1c0.3,0.3,0.7,0.4,1.1,0.4s0.8-0.1,1.1-0.4l8.9-8.9l8.9,8.9c0.3,0.3,0.7,0.4,1.1,0.4s0.8-0.1,1.1-0.4c0.6-0.6,0.6-1.5,0-2.1L18.1,16z"></path></svg>
								</div>
							</div>
							<div class="createGoal_content">
								<div class="createGoalLog_name">
									<div class="createGoalLog_name_firstLable">목표 제목</div>
									<div class="createGoalLog_name_input">
										<input type="text" name="createGoal"/>
									</div>
								</div>
								<div class="createGoal_middleRow">
										<div class="createGoal_timePeriod">
											<div class="createGoal_timePeriod_child01">
												기간
											</div>
											<div class="createGoal_timePeriod_child02_parent">
												<div class="createGoal_timePeriod_child02">
													<div class="createGoal_timePeriod_child02_SelectedDate">
														<span>FY25 1분기</span>
														<span>1월 1일 - 3월 3일</span>
													</div>
													<div class="createGoal_timePeriod_child02_svg">
														<svg class="HighlightSol HighlightSol--core Icon ButtonThemeablePresentation-rightIcon TimePeriodSingleSelect-downIcon DownIcon" viewBox="0 0 32 32" aria-hidden="true" focusable="false"><path d="M27.874 11.036a1.5 1.5 0 0 0-2.113-.185L16 19.042l-9.761-8.191a1.5 1.5 0 1 0-1.928 2.298l10.726 9a1.498 1.498 0 0 0 1.928 0l10.726-9a1.5 1.5 0 0 0 .185-2.113h-.002Z"></path></svg>
													</div>
												</div>
												<div class="timePeriodSelectDropdown">
													<div class="last_year">
														<svg class="HighlightSol HighlightSol--core Icon LeftIcon" viewBox="0 0 32 32" aria-hidden="true" focusable="false"><path d="M8.8,16c0-0.3,0.1-0.7,0.3-0.9l9-11c0.5-0.6,1.5-0.7,2.1-0.2s0.7,1.5,0.2,2.1l-8.2,10l8.2,10c0.5,0.6,0.4,1.6-0.2,2.1s-1.6,0.4-2.1-0.2l-9-11C8.9,16.7,8.8,16.3,8.8,16z"></path></svg>
													</div>
													<div class="timePeriodSelectDropdown_card">
														<div class="timePeriodSelectDropdown_card_child01">
															<div class="timePeriodSelectDropdown_option_year">
																<span>FY 25</span>
																<span>1월 1일 - 12월 31일</span>
															</div>
														</div>
														<div class="timePeriodSelectDropdown_card_child02">
															<div class="timePeriodSelectDropdown_option_FirstHalfyear">상반기</div>
															<div class="timePeriodSelectDropdown_option_SecondHalfyear">하반기</div>
														</div>
														<div class="timePeriodSelectDropdown_card_child03">
															<div class="timePeriodSelectDropdown_option">1분기</div>
															<div class="timePeriodSelectDropdown_option">2분기</div>
															<div class="timePeriodSelectDropdown_option">3분기</div>
															<div class="timePeriodSelectDropdown_option">4분기</div>
														</div>
													</div>
													<div class="next_year">
														<svg class="HighlightSol HighlightSol--core Icon RightIcon" viewBox="0 0 32 32" aria-hidden="true" focusable="false"><path d="M13.148 4.31a1.5 1.5 0 0 0-2.298 1.928L19.04 16l-8.19 9.761a1.499 1.499 0 1 0 2.298 1.928l9-10.726a1.5 1.5 0 0 0 0-1.929l-9-10.726v.003Z"></path></svg>
													</div>
												</div>
											</div>
										</div>
								</div>
							</div>
							<div class="createGoal_bottomBar">
								<div class="cancle_btn">
									<span>취소</span>
								</div>
								<div class="saveGoal">
									<span>목표 저장</span>
								</div>
							</div>
						</div>
						</div> `;
							/* $(".connected_goal_click_content").append(str02); */
							
						}else{
							$(".connected_goal_click_content_child_parent").html("");
							$(".connected_goal_click_content").css("height","30px");
							
							//새 목표 생성 div
							let str02 =`<div class="create_new_goal">
								<div class="create_new_goal_icon">
								<svg class="HighlightSol HighlightSol--core Icon PlusIcon"
									viewBox="0 0 32 32" aria-hidden="true" focusable="false">
										<path
										d="M26,14h-8V6c0-1.1-0.9-2-2-2l0,0c-1.1,0-2,0.9-2,2v8H6c-1.1,0-2,0.9-2,2l0,0c0,1.1,0.9,2,2,2h8v8c0,1.1,0.9,2,2,2l0,0c1.1,0,2-0.9,2-2v-8h8c1.1,0,2-0.9,2-2l0,0C28,14.9,27.1,14,26,14z"></path></svg>
							</div>
							<span>새 목표 생성</span> 
						<!-- 새로운 목표 팝업  --><!-- 새로운 목표 팝업  --><!-- 새로운 목표 팝업  -->
						<div class="createGoal_popup">
							<div class="createGoal_TopUp">
								<span>새로운 목표 생성</span>
								<div class="createGoal_deleteBtn">
									<svg class="HighlightSol HighlightSol--core Icon XIcon" viewBox="0 0 32 32" aria-hidden="true" focusable="false"><path d="M18.1,16L27,7.1c0.6-0.6,0.6-1.5,0-2.1s-1.5-0.6-2.1,0L16,13.9l-8.9-9C6.5,4.3,5.6,4.3,5,4.9S4.4,6.4,5,7l8.9,8.9L5,24.8c-0.6,0.6-0.6,1.5,0,2.1c0.3,0.3,0.7,0.4,1.1,0.4s0.8-0.1,1.1-0.4l8.9-8.9l8.9,8.9c0.3,0.3,0.7,0.4,1.1,0.4s0.8-0.1,1.1-0.4c0.6-0.6,0.6-1.5,0-2.1L18.1,16z"></path></svg>
								</div>
							</div>
							<div class="createGoal_content">
								<div class="createGoalLog_name">
									<div class="createGoalLog_name_firstLable">목표 제목</div>
									<div class="createGoalLog_name_input">
										<input type="text" name="createGoal"/>
									</div>
								</div>
								<div class="createGoal_middleRow">
										<div class="createGoal_timePeriod">
											<div class="createGoal_timePeriod_child01">
												기간
											</div>
											<div class="createGoal_timePeriod_child02_parent">
												<div class="createGoal_timePeriod_child02">
													<div class="createGoal_timePeriod_child02_SelectedDate">
														<span>FY25 1분기</span>
														<span>1월 1일 - 3월 3일</span>
													</div>
													<div class="createGoal_timePeriod_child02_svg">
														<svg class="HighlightSol HighlightSol--core Icon ButtonThemeablePresentation-rightIcon TimePeriodSingleSelect-downIcon DownIcon" viewBox="0 0 32 32" aria-hidden="true" focusable="false"><path d="M27.874 11.036a1.5 1.5 0 0 0-2.113-.185L16 19.042l-9.761-8.191a1.5 1.5 0 1 0-1.928 2.298l10.726 9a1.498 1.498 0 0 0 1.928 0l10.726-9a1.5 1.5 0 0 0 .185-2.113h-.002Z"></path></svg>
													</div>
												</div>
												<div class="timePeriodSelectDropdown">
													<div class="last_year">
														<svg class="HighlightSol HighlightSol--core Icon LeftIcon" viewBox="0 0 32 32" aria-hidden="true" focusable="false"><path d="M8.8,16c0-0.3,0.1-0.7,0.3-0.9l9-11c0.5-0.6,1.5-0.7,2.1-0.2s0.7,1.5,0.2,2.1l-8.2,10l8.2,10c0.5,0.6,0.4,1.6-0.2,2.1s-1.6,0.4-2.1-0.2l-9-11C8.9,16.7,8.8,16.3,8.8,16z"></path></svg>
													</div>
													<div class="timePeriodSelectDropdown_card">
														<div class="timePeriodSelectDropdown_card_child01">
															<div class="timePeriodSelectDropdown_option_year">
																<span>FY 25</span>
																<span>1월 1일 - 12월 31일</span>
															</div>
														</div>
														<div class="timePeriodSelectDropdown_card_child02">
															<div class="timePeriodSelectDropdown_option_FirstHalfyear">상반기</div>
															<div class="timePeriodSelectDropdown_option_SecondHalfyear">하반기</div>
														</div>
														<div class="timePeriodSelectDropdown_card_child03">
															<div class="timePeriodSelectDropdown_option">1분기</div>
															<div class="timePeriodSelectDropdown_option">2분기</div>
															<div class="timePeriodSelectDropdown_option">3분기</div>
															<div class="timePeriodSelectDropdown_option">4분기</div>
														</div>
													</div>
													<div class="next_year">
														<svg class="HighlightSol HighlightSol--core Icon RightIcon" viewBox="0 0 32 32" aria-hidden="true" focusable="false"><path d="M13.148 4.31a1.5 1.5 0 0 0-2.298 1.928L19.04 16l-8.19 9.761a1.499 1.499 0 1 0 2.298 1.928l9-10.726a1.5 1.5 0 0 0 0-1.929l-9-10.726v.003Z"></path></svg>
													</div>
												</div>
											</div>
										</div>
								</div>
							</div>
							<div class="createGoal_bottomBar">
								<div class="cancle_btn">
									<span>취소</span>
								</div>
								<div class="saveGoal">
									<span>목표 저장</span>
								</div>
							</div>
						</div>
						</div> `;
							/* $(".connected_goal_click_content").append(str02); */
						}
					},
					error:function(r,s,e){
						console.log("[에러] code : " + r.status + ", message: " + r.responseText + ",error:" + e);
						//alert("다시 검색해주세요.");
					}
				});
			}
		});
		//연결된 목표 : 클릭시 해당 프로젝트 목표에 insert 
		//문제 : 연결된 프로젝트 db 수정 -> sql문 다시 작성해야함 
	});

	$(function() {
		$(document).on('scroll', '.transparent_screen', function() {
			alert("!");
		});
	});
	
	//연결된 목표 : 새로운 목표 생성 팝업 
	$(function(){
//$("#main_outline .connected_goal_update").css('display', 'block');
		$(document).on("click", ".create_new_goal", function(){
			$(".createGoal_popup").css("display", "block");
			$(".black_screen").css("display" , "block");
		});
		
		//연결된 목표 : 새로운 목표 생성 팝업 닫기 
		$(document).on("click", ".createGoal_deleteBtn > svg" ,function(e) {
//			$(this).closest(".createGoal_popup").css("display", "none");	// NOT WORKING
//			$("#main_outline .connected_goal_update").css('display', 'none');  // WORKING
			e.stopPropagation();   // 이벤트 전파 막기.!!
			$(".createGoal_popup").css("display", "none");
			$(".black_screen").css("display" , "none"); 
			$(".darker_wallpapers").css("display", "none");
			$(".transparent_screen").css("display", "none");
			$(".connected_goal_update").css("display", "none"); 
			$(".connected_goal_click_content").css("height", "165px");
		});
		
		//연결된 목표 : 새로운 목표 생성 팝업 닫기 
		$(document).on("click" , ".cancle_btn" , function(){
			e.stopPropagation(); //이벤트 전파 막기 
			$(".timePeriodSelectDropdown").toggleClass("on");
		});
		
		// 연결된 목표 : 새로운 목표 생성 - 기간 팝업 열기 
		$(document).on("click", ".createGoal_timePeriod_child02", function(e){
			e.stopPropagation(); //이벤트 전파 막기 
			$(".timePeriodSelectDropdown").toggleClass("on");
		});
		// 연결된 목표 : 새로운 목표 생성 - 기간 선택하기 
		// 나중에 선생님과
		
		// 연결된 목표 : 새 목표 생성 insert ajax 
		// 서블릿에서 insert 되는 goal_idx 를 가져올수없음 
		$(document).on("click", ".saveGoal", function(){
			let goalTitle = $(".createGoalLog_name_input > input").val();
			let periodIdx = 1; /* 예시 :  선택해서 토글할수있게 해야함 */
			let ficalYear = 2025; /*자바스크립트로 요번년도를 알수있게 하는 함수 있을듯 */
			$.ajax({
				type:'post',
				data:{"projectIdx" : ${projectIdx}, "loginMemberIdx" : ${loginMemberIdx}, 
					"goalTitle" :  goalTitle, "periodIdx" : periodIdx, "ficalYear" : ficalYear},
				url:'ExGoalInsert',
				success:function(data){
					<% for(Project_participantsThingsDto dto : listProject_participants) { %>
					<% if(dto.getMember_idx() != loginMemberIdx) { %>
						webSocket.send("새알림_<%=dto.getMember_idx()%>_message://목표의 진행상태를 업데이트하고 있습니다.");
					<% } %>
				<% } %>	
				location.reload();
				},
				error:function(r,s,e){
					console.log("[에러] code : " + r.status + ", message : " + r.responseText + ",error : " + e);
				}
			});
		}); 
	});
	
	//연결된 포트폴리오 
	$(function(){
		//연결된 포트폴리오 : 검색 전 조회 되는 리스트 
		$(".connected_portfolio1_plusIcon").click(function(){
			$.ajax({
				type:'post',
				data:{"projectIdx": ${projectIdx}},
				url:'ExLinkedPortfolioViewList',
				success:function(data){
					let searchPortfoliList = data; //조회될 리스트 
					//console.log(searchPortfoliList);
					console.log(searchPortfoliList.length);
					if(searchPortfoliList.length==0){
						$(".linked_portfolio_search_list_parent").css("height" , "0px");
					}else if(searchPortfoliList.length>1){
						$(".linked_portfolio_search_list_parent").css("height" , "61px");
					}
					$(".linked_portfolio_search_list_parent").html("");
					for(let i=0; i<searchPortfoliList.length; i++){
						let str =
							`<div class="linked_portfolio_search_list" portfolioIdx="`+searchPortfoliList[i].selectPortfolioIdx+`">
								<div class="linked_portfolio_search_list_icon">
									<svg class="PortfolioColorIcon-duotoneBaseLayer ColorFillIcon ColorFillIcon--colorIndigo" viewBox="0 0 20 20" aria-labelledby="titlelui_36389" role="img" focusable="false">
										<title id="titlelui_36389">포트폴리오</title>
										<path d="M 0 2.5 C 0 1.65 0.65 1 1.5 1 H 7.7 C 7.9 1 8.05 1.1 8.15 1.3 L 9.6 4.2 C 9.85 4.7 10.35 5.05 10.95 5.05 H 18.5 C 19.35 5.05 20 5.7 20 6.55 V 16.55 C 20 17.95 18.9 19.05 17.5 19.05 H 2.5 C 1.1 19.05 0 17.95 0 16.55 V 2.5 Z"></path>
									</svg>
								</div>
								<div class="linked_portfolio_search_list_title">
									`+searchPortfoliList[i].selectPortfolioName+`
								</div>
							</div>`;
						$(".linked_portfolio_search_list_parent").append(str);
					}
				},
				error:function(r,s,e){
					console.log("[에러] code : " + r.status + ", message : " + r.responseText + ",error : " + e);
				}
			})
		});
		
		//연결된 포트폴리오 : 검색 시 조회 되는 리스트 
		$(".connected_portfolio_click_title > input").keyup(function(){
			let portfolioName = $(this).val();
			if(portfolioName.length>0){
				$.ajax({
					type:'post',
					data:{"portfolioName":portfolioName, "projectIdx" : ${projectIdx}},
					url:'ExPortfolioListsearching',
					success:function(data){
						let searchPortfoliolist = data;
						/* for(let i=0; i<searchPortfoliolist.length; i++){
							console.log(searchPortfoliolist[i].portfolioName);
						} */
						//복붙 코드 
						if(searchPortfoliolist.length==0){
							$(".linked_portfolio_search_list_parent").css("height" , "0px");
						}else if(searchPortfoliolist.length>1){
							$(".linked_portfolio_search_list_parent").css("height" , "62px");
						}else if(searchPortfoliolist.length==1){
							$(".linked_portfolio_search_list_parent").css("height" , "31px");
						}
						$(".linked_portfolio_search_list_parent").html("");
						for(let i=0; i<searchPortfoliolist.length; i++){
							let str =
								`<div class="linked_portfolio_search_list"  portfolioIdx="`+searchPortfoliolist[i].portfolioIdx+`">
									<div class="linked_portfolio_search_list_icon">
										<svg class="PortfolioColorIcon-duotoneBaseLayer ColorFillIcon ColorFillIcon--colorIndigo" viewBox="0 0 20 20" aria-labelledby="titlelui_36389" role="img" focusable="false">
											<title id="titlelui_36389">포트폴리오</title>
											<path d="M 0 2.5 C 0 1.65 0.65 1 1.5 1 H 7.7 C 7.9 1 8.05 1.1 8.15 1.3 L 9.6 4.2 C 9.85 4.7 10.35 5.05 10.95 5.05 H 18.5 C 19.35 5.05 20 5.7 20 6.55 V 16.55 C 20 17.95 18.9 19.05 17.5 19.05 H 2.5 C 1.1 19.05 0 17.95 0 16.55 V 2.5 Z"></path>
										</svg>
									</div>
									<div class="linked_portfolio_search_list_title">
										`+searchPortfoliolist[i].portfolioName+`
									</div>
								</div>`;
							$(".linked_portfolio_search_list_parent").append(str);
						}
					},
					error:function(r,s,e){
						console.log("[에러] code :" + r.status + ",message : " + r.responseText + ",error : " + e);
					}
				})
			}
		});
	
		//포트폴리오 생성 팝업 열기 
		$(".linked_portfolio_create").click(function(){
			$(".newPortfolioCreationPopup").css("display", "block");
			$(".black_screen").css("display", "block");
		});
		
		//포트폴리오 생성 팝업 닫기 
		$(document).on("click",".newPortfolioCreationPopup_deleteBtn", function(){
			$(".connected_portfolio_click").css("display" , "none");
			$(".linked_portflio_search_list_popup").css("display","none");
			$(".newPortfolioCreationPopup").css("display", "none");
			$(".black_screen").css("display", "none");
			/* $(".connected_portfolio_click_parent").css("display", "none"); */
		});
		
		//연결된 포트폴리오 : 새로운 포트폴리오 생성 
		$(document).on("click", ".newPortfolioCreationPopup_saveBtn",function(){
			let portfolioName = $(".newPortfolioCreationPopup_logoName_input > input").val();
			$.ajax({
				type:'post',
				data:{"portfolioName" : portfolioName, "loginMemberIdx" : ${loginMemberIdx}, "projectIdx" : ${projectIdx}},
				url:'ExPortfolioCreate',
				success:function(data){
					location.reload();
				},
				error:function(r,s,e){
					console.log("[에러] code :" + r.status + ",message : " + r.responseText + ",error : " + e);
				}
			})
		});
		
		//연결된 포트폴리오 : 추가 
		$(document).on("click", ".linked_portfolio_search_list", function(){
			let portfolioidx = $(this).attr("portfolioidx");
			$.ajax({
				type:'post',
				data:{"portfolioidx" : portfolioidx, "projectIdx" : ${projectIdx}},
				url:'ExAddLinkedPortfolio',
				success:function(data){
					<% for(Project_participantsThingsDto dto : listProject_participants) { %>
						<% if(dto.getMember_idx() != loginMemberIdx) { %>
							webSocket.send("새알림_<%=dto.getMember_idx()%>_message://프로젝트, 포리폴리오가 추가 되었습니다.회원님은 이 프로젝트 / 포트폴리오의 새 상태 업데이트에 관한 알림을 받게 됩니다.");
						<% } %>
					<% } %>	
					
					$(".connected_portfolio_click").css("display", "none");
					$(".linked_portflio_search_list_popup").css("display", "none");
					$(".connected_portfolio2_parent").html("");
					let portfoliolist = data;
					for(let i=0; i<portfoliolist.length; i++){
						let str =
							`<div class="connected_portfolio2" portfolioIdx="`+portfoliolist[i].portfolioIdx+`">
							<div class="connected_portfolio2_child1">
							<svg
								class="PortfolioColorIcon-duotoneBaseLayer ColorFillIcon ColorFillIcon--colorIndigo"
								viewBox="0 0 20 20" aria-labelledby="titlelui_36389"
								role="img" focusable="false">
								<title id="titlelui_36389">포트폴리오</title><path
									d="M 0 2.5 C 0 1.65 0.65 1 1.5 1 H 7.7 C 7.9 1 8.05 1.1 8.15 1.3 L 9.6 4.2 C 9.85 4.7 10.35 5.05 10.95 5.05 H 18.5 C 19.35 5.05 20 5.7 20 6.55 V 16.55 C 20 17.95 18.9 19.05 17.5 19.05 H 2.5 C 1.1 19.05 0 17.95 0 16.55 V 2.5 Z"></path></svg>
						</div>

						<div class="connected_portfolio2_child2">
							<span>`+portfoliolist[i].portfolioName+`</span>
						</div>`;
						
						//portfoliolist[i].statusNullCheck 이 null 이 아니라면 
						if(portfoliolist[i].statusNullCheck == 1){ 
							str +=
							`<div class="status_going_according_to_plan" style="background-color : `+ portfoliolist[i].statusBackground+`">
								<svg class="HighlightSol MiniIcon StatusDotFillMiniIcon"
									viewBox="0 0 24 24" aria-hidden="true" focusable="false" style="fill:`+portfoliolist[i].statusCharColor+`">
									<path
										d="m20,12c0,4.42-3.58,8-8,8s-8-3.58-8-8S7.58,4,12,4s8,3.58,8,8Z"></path></svg>
								<span style="color:`+ portfoliolist[i].statusCharColor +`">
								`+portfoliolist[i].statusName+`
								</span>
							</div>`;
						}
						
						str+=
						`<div class="connected_portfolio2_child3">
							<img src="img/`+portfoliolist[i].memberprofileImg+`" class="portfolio_parent"></img>
						</div>
						<div class="connected_portfolio2_child4_parent">
							<div class="connected_portfolio2_child4">
								<svg class="Icon MoreIcon" viewBox="0 0 32 32"
									aria-hidden="true" focusable="false">
							<path
										d="M16,13c1.7,0,3,1.3,3,3s-1.3,3-3,3s-3-1.3-3-3S14.3,13,16,13z M3,13c1.7,0,3,1.3,3,3s-1.3,3-3,3s-3-1.3-3-3S1.3,13,3,13z M29,13c1.7,0,3,1.3,3,3s-1.3,3-3,3s-3-1.3-3-3S27.3,13,29,13z"></path></svg>
							</div>
							<div class="connected_portfolio2_deleteBtn">
								포트폴리오에서 제거 
							</div>
						</div>`;
					
					$(".connected_portfolio2_parent").append(str);
					}
				},
				error:function(r,s,e){
					console.log("[에러] code: " + r.status + ",message : " + r.responseText + ",error : " + e);
				}
			});
		});
		
		//연결된 포트폴리오 : 해당 프로젝트에서 제거 팝업 띄우기 
		$(document).on("click", ".connected_portfolio2_child4", function(){
			$(this).parent().find(".connected_portfolio2_deleteBtn").toggleClass("on");
		});
		
		//연결된 포트폴리오 : 해당 프로젝트에서 제거 
		$(document).on("click", ".connected_portfolio2_deleteBtn", function(){
			let portfolioidx = $(this).parent().closest(".connected_portfolio2").attr("portfolioidx");
			$.ajax({
				type:'post',
				data:{"portfolioidx" : portfolioidx, "projectIdx" : ${projectIdx}},
				url:'ExConnectionPortfolioDelete',
				success:function(data){
					<% for(Project_participantsThingsDto dto : listProject_participants) { %>
						<% if(dto.getMember_idx() != loginMemberIdx) { %>
							webSocket.send("새알림_<%=dto.getMember_idx()%>_message://이 프로젝트에서 포트폴리오의 연결이 끊어졌습니다.");
						<% } %>
					<% } %>	
					$(".connected_portfolio_click").css("display", "none");
					$(".linked_portflio_search_list_popup").css("display", "none");
					$(".connected_portfolio2_parent").html("");
					let portfoliolist = data;
					for(let i=0; i<portfoliolist.length; i++){
						let str =
							`<div class="connected_portfolio2" portfolioIdx="`+portfoliolist[i].portfolioIdx+`">
							<div class="connected_portfolio2_child1">
							<svg
								class="PortfolioColorIcon-duotoneBaseLayer ColorFillIcon ColorFillIcon--colorIndigo"
								viewBox="0 0 20 20" aria-labelledby="titlelui_36389"
								role="img" focusable="false">
								<title id="titlelui_36389">포트폴리오</title><path
									d="M 0 2.5 C 0 1.65 0.65 1 1.5 1 H 7.7 C 7.9 1 8.05 1.1 8.15 1.3 L 9.6 4.2 C 9.85 4.7 10.35 5.05 10.95 5.05 H 18.5 C 19.35 5.05 20 5.7 20 6.55 V 16.55 C 20 17.95 18.9 19.05 17.5 19.05 H 2.5 C 1.1 19.05 0 17.95 0 16.55 V 2.5 Z"></path></svg>
						</div>

						<div class="connected_portfolio2_child2">
							<span>`+portfoliolist[i].portfolioName+`</span>
						</div>`;
						
						//portfoliolist[i].statusNullCheck 이 null 이 아니라면 
						if(portfoliolist[i].statusNullCheck == 1){ 
							str +=
							`<div class="status_going_according_to_plan" style="background-color : `+ portfoliolist[i].statusBackground+`">
								<svg class="HighlightSol MiniIcon StatusDotFillMiniIcon"
									viewBox="0 0 24 24" aria-hidden="true" focusable="false" style="fill:`+portfoliolist[i].statusCharColor+`">
									<path
										d="m20,12c0,4.42-3.58,8-8,8s-8-3.58-8-8S7.58,4,12,4s8,3.58,8,8Z"></path></svg>
								<span style="color:`+ portfoliolist[i].statusCharColor +`">
								`+portfoliolist[i].statusName+`
								</span>
							</div>`;
						}
						
						str+=
						`<div class="connected_portfolio2_child3">
							<img src="img/`+portfoliolist[i].memberprofileImg+`" class="portfolio_parent"></img>
						</div>
						<div class="connected_portfolio2_child4_parent">
							<div class="connected_portfolio2_child4">
								<svg class="Icon MoreIcon" viewBox="0 0 32 32"
									aria-hidden="true" focusable="false">
							<path
										d="M16,13c1.7,0,3,1.3,3,3s-1.3,3-3,3s-3-1.3-3-3S14.3,13,16,13z M3,13c1.7,0,3,1.3,3,3s-1.3,3-3,3s-3-1.3-3-3S1.3,13,3,13z M29,13c1.7,0,3,1.3,3,3s-1.3,3-3,3s-3-1.3-3-3S27.3,13,29,13z"></path></svg>
							</div>
							<div class="connected_portfolio2_deleteBtn">
								포트폴리오에서 제거 
							</div>
						</div>`;
					$(".connected_portfolio2_parent").append(str);
					}
				},
				error:function(r,s,e){
					console.log("[에러] code: " + r.status + ",message : " + r.responseText + ",error : " + e);
				}
			});
		}); 
	});	
	
	</script>
</head>
<body>
	<div class="transparent_screen" style="display: none"></div>
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
						<div id="employment">
							<svg class="MiniIcon PortfolioGenericMiniIcon"
								viewBox="0 0 24 24" aria-hidden="true" focusable="false">
						<path
									d="M21,6h-8.4c-0.2,0-0.3,0-0.5-0.1c-0.1-0.1-0.3-0.2-0.4-0.3L9.8,2.5C9.8,2.3,9.6,2.2,9.5,2.1S9.2,2,9,2H1C0.7,2,0.5,2.1,0.3,2.3C0.1,2.5,0,2.7,0,3v16c0,1.7,1.3,3,3,3h18c1.7,0,3-1.3,3-3V9C24,7.3,22.7,6,21,6z M2,4h6.4l1.2,2H2V4L2,4L2,4z M22,19c0,0.6-0.4,1-1,1H3c-0.6,0-1-0.4-1-1V8h19c0.6,0,1,0.4,1,1V19z"></path></svg>
							<span>취업 </span>
							<svg
								class="MiniIcon NavigationBreadcrumbContent-divider SlashMiniIcon"
								viewBox="0 0 24 24" aria-hidden="true" focusable="false">
						<path
									d="M16.21 1.837a1.002 1.002 0 0 0-1.307.541L7.25 20.856a1.001 1.001 0 0 0 1.848.766l7.654-18.478a1.001 1.001 0 0 0-.54-1.307Z"></path></svg>
						</div>
						<div style="width: auto;" class="list-image">
							<img style="z-index: 4;" class="img-small"
								src="..\..\img\짱구1.jpg"> <img
								style="z-index: 3; margin-left: -10px;" class="img-small"
								src="..\..\img\짱구2.jpg"> <img
								style="z-index: 2; margin-left: -10px;" class="img-small"
								src="..\..\img\철수.png">
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
						<img src="img/초록색2.png"></img>
						<div id="project_title">
							<span>${name}</span>
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
									<div class="progress_green" idx="2">
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
									<div class="progress_yellow" idx="3">
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
									<div class="progress_red" idx="4">
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
									<div class="progress_blue" idx="5">
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
					<div id="outline_content">
						<div id="inline_content">
							<div id="project_description">
								<input name="project_description" type="text"
									value="<%if (title == null) {%> 프로젝트설명 <%} else {%> <%=title%> <%}%>"
									class="project_description_input" />


							</div>
							<div id="project_role">
								<div id="add_member">
									<span>프로젝트 역할</span>
								</div>

								<div id="member_profile_parent">
									<div id="member_profile_view">
										<div id="member_profile_default">
											<svg class="Icon PlusIcon" viewBox="0 0 32 32"
												aria-hidden="true" focusable="false">
									<path
													d="M26,14h-8V6c0-1.1-0.9-2-2-2l0,0c-1.1,0-2,0.9-2,2v8H6c-1.1,0-2,0.9-2,2l0,0c0,1.1,0.9,2,2,2h8v8c0,1.1,0.9,2,2,2l0,0c1.1,0,2-0.9,2-2v-8h8c1.1,0,2-0.9,2-2l0,0C28,14.9,27.1,14,26,14z"></path></svg>
										</div>
										<span>멤버 추가</span>
									</div>
									<!-- 프로젝트 멤버 div  -->
									<!-- 프로젝트 멤버 div  -->
									<!-- 프로젝트 멤버 div  -->
									
									<%
									
									for (Project_participantsThingsDto dto : projectParticipantsIdx) {
										int participantsIdx = dto.getMember_idx(); // 참여자 memberIdx 
										String authorityName = dto.getAuthority_name();
										MemberAllDto participantsIdxDto = memberDao.getMemberAllDto(participantsIdx);
									%>
									<div class="member_profile_view_save_parent"
										idx="<%=participantsIdx%>">
										<div id="member_profile_view_save">
											<div id="member_profile_save">
												<img src="img/<%=participantsIdxDto.getProfileImg()%>" />
											</div>
											<div id="member_profile_name1_save">
												<div id="member_profile_name_save">
													<span> <%=participantsIdxDto.getNickname()%></span>
												</div>
												<div id="member_profile_role_save">
													<span><%=authorityName%></span>
												</div>
											</div>
										</div>
										<div class="delete_memberProfile_view">프로젝트에서 제거</div>
									</div>

									<%
									}
									%>
									<!-- 프로젝트 멤버 div  -->
									<!-- 프로젝트 멤버 div  -->
									<!-- 프로젝트 멤버 div  -->
								</div>


							</div>
							<div id="connected_goals">
								<div id="connected_goals_title">
									<span>연결된 목표</span>
									<div class="Parent_Icon_Plus">
										<svg class="Icon PlusIcon" viewBox="0 0 32 32"
											aria-hidden="true" focusable="false">
							<path
												d="M26,14h-8V6c0-1.1-0.9-2-2-2l0,0c-1.1,0-2,0.9-2,2v8H6c-1.1,0-2,0.9-2,2l0,0c0,1.1,0.9,2,2,2h8v8c0,1.1,0.9,2,2,2l0,0c1.1,0,2-0.9,2-2v-8h8c1.1,0,2-0.9,2-2l0,0C28,14.9,27.1,14,26,14z"></path></svg>
									</div>
								</div>

								<!-- 클릭했을때 나오는 div 수정중  -->
								<div class="connected_goal_update">
									<div class="connected_goal_click_search">
										<input type="text" name="goalTitle" value="목표 이름을 입력하세요"/>
									</div>
									<!-- ajax 처리 해둠  --> <!-- ajax 처리 해둠  --> <!-- ajax 처리 해둠  -->
									<div class="connected_goal_click_content">
										<div class="connected_goal_click_content_child_parent">
											<div class="connected_goal_click_content_child">
												<!-- <div class="goal_icon_click">
													<svg
														class="HighlightSol HighlightSol--core Icon--small Icon Omnibutton-menuIcon GoalSimpleIcon"
														viewBox="0 0 32 32" aria-hidden="true" focusable="false">
															<path
															d="M19.533 3.417A4.208 4.208 0 0 0 15.998 1.5a4.204 4.204 0 0 0-3.534 1.916L.694 21.443a4.186 4.186 0 0 0-.179 4.342A4.166 4.166 0 0 0 4.228 28h23.54a4.166 4.166 0 0 0 3.712-2.215 4.184 4.184 0 0 0-.179-4.342L19.532 3.416l.001.001Zm10.188 21.417a2.193 2.193 0 0 1-1.954 1.167H4.228a2.192 2.192 0 0 1-1.954-1.167 2.217 2.217 0 0 1 .094-2.296L14.14 4.51A2.183 2.183 0 0 1 16 3.501c.762 0 1.44.368 1.86 1.01l11.77 18.027c.456.701.49 1.559.092 2.296Z"></path></svg>
												</div>
												<div class="click_content">
													<div class="click_content_title">11월 둘째주 모의면접</div>
													<span>FY25 상반기</span> <span>계획대로 진행 중 </span>
												</div>
												<div class="click_profile_img">
													<img src="../../img/짱구1.jpg" />
												</div> -->
											</div>
											<div class="connected_goal_click_content_child">
												<!-- <div class="goal_icon_click">
													<svg
														class="HighlightSol HighlightSol--core Icon--small Icon Omnibutton-menuIcon GoalSimpleIcon"
														viewBox="0 0 32 32" aria-hidden="true" focusable="false">
															<path
															d="M19.533 3.417A4.208 4.208 0 0 0 15.998 1.5a4.204 4.204 0 0 0-3.534 1.916L.694 21.443a4.186 4.186 0 0 0-.179 4.342A4.166 4.166 0 0 0 4.228 28h23.54a4.166 4.166 0 0 0 3.712-2.215 4.184 4.184 0 0 0-.179-4.342L19.532 3.416l.001.001Zm10.188 21.417a2.193 2.193 0 0 1-1.954 1.167H4.228a2.192 2.192 0 0 1-1.954-1.167 2.217 2.217 0 0 1 .094-2.296L14.14 4.51A2.183 2.183 0 0 1 16 3.501c.762 0 1.44.368 1.86 1.01l11.77 18.027c.456.701.49 1.559.092 2.296Z"></path></svg>
												</div>
												<div class="click_content">
													<div class="click_content_title">11월 둘째주 모의면접</div>
													<span>FY25 상반기</span> <span>계획대로 진행 중 </span>
												</div>
												<div class="click_profile_img">
													<img src="../../img/짱구1.jpg" />
												</div> -->
											</div>
										</div>
										<div class="create_new_goal">
											<div class="create_new_goal_icon">
												<svg class="HighlightSol HighlightSol--core Icon PlusIcon"
													viewBox="0 0 32 32" aria-hidden="true" focusable="false">
														<path
														d="M26,14h-8V6c0-1.1-0.9-2-2-2l0,0c-1.1,0-2,0.9-2,2v8H6c-1.1,0-2,0.9-2,2l0,0c0,1.1,0.9,2,2,2h8v8c0,1.1,0.9,2,2,2l0,0c1.1,0,2-0.9,2-2v-8h8c1.1,0,2-0.9,2-2l0,0C28,14.9,27.1,14,26,14z"></path></svg>
											</div>
											<span>새 목표 생성</span>
										<!-- 새로운 목표 팝업  --><!-- 새로운 목표 팝업  --><!-- 새로운 목표 팝업  -->
										<div class="createGoal_popup">
											<div class="createGoal_TopUp">
												<span>새로운 목표 생성</span>
												<div class="createGoal_deleteBtn">
													<svg class="HighlightSol HighlightSol--core Icon XIcon" viewBox="0 0 32 32" aria-hidden="true" focusable="false"><path d="M18.1,16L27,7.1c0.6-0.6,0.6-1.5,0-2.1s-1.5-0.6-2.1,0L16,13.9l-8.9-9C6.5,4.3,5.6,4.3,5,4.9S4.4,6.4,5,7l8.9,8.9L5,24.8c-0.6,0.6-0.6,1.5,0,2.1c0.3,0.3,0.7,0.4,1.1,0.4s0.8-0.1,1.1-0.4l8.9-8.9l8.9,8.9c0.3,0.3,0.7,0.4,1.1,0.4s0.8-0.1,1.1-0.4c0.6-0.6,0.6-1.5,0-2.1L18.1,16z"></path></svg>
												</div>
											</div>
											<div class="createGoal_content">
												<div class="createGoalLog_name">
													<div class="createGoalLog_name_firstLable">목표 제목</div>
													<div class="createGoalLog_name_input">
														<input type="text" name="createGoal"/>
													</div>
												</div>
												<div class="createGoal_middleRow">
														<div class="createGoal_timePeriod">
															<div class="createGoal_timePeriod_child01">
																기간
															</div>
															<div class="createGoal_timePeriod_child02_parent">
																<div class="createGoal_timePeriod_child02">
																	<div class="createGoal_timePeriod_child02_SelectedDate">
																		<span>FY25 1분기</span>
																		<span>1월 1일 - 3월 3일</span>
																	</div>
																	<div class="createGoal_timePeriod_child02_svg">
																		<svg class="HighlightSol HighlightSol--core Icon ButtonThemeablePresentation-rightIcon TimePeriodSingleSelect-downIcon DownIcon" viewBox="0 0 32 32" aria-hidden="true" focusable="false"><path d="M27.874 11.036a1.5 1.5 0 0 0-2.113-.185L16 19.042l-9.761-8.191a1.5 1.5 0 1 0-1.928 2.298l10.726 9a1.498 1.498 0 0 0 1.928 0l10.726-9a1.5 1.5 0 0 0 .185-2.113h-.002Z"></path></svg>
																	</div>
																</div>
																<div class="timePeriodSelectDropdown">
																	<div class="last_year">
																		<svg class="HighlightSol HighlightSol--core Icon LeftIcon" viewBox="0 0 32 32" aria-hidden="true" focusable="false"><path d="M8.8,16c0-0.3,0.1-0.7,0.3-0.9l9-11c0.5-0.6,1.5-0.7,2.1-0.2s0.7,1.5,0.2,2.1l-8.2,10l8.2,10c0.5,0.6,0.4,1.6-0.2,2.1s-1.6,0.4-2.1-0.2l-9-11C8.9,16.7,8.8,16.3,8.8,16z"></path></svg>
																	</div>
																	<div class="timePeriodSelectDropdown_card">
																		<div class="timePeriodSelectDropdown_card_child01">
																			<div class="timePeriodSelectDropdown_option_year">
																				<span>FY 25</span>
																				<span>1월 1일 - 12월 31일</span>
																			</div>
																		</div>
																		<div class="timePeriodSelectDropdown_card_child02">
																			<div class="timePeriodSelectDropdown_option_FirstHalfyear">상반기</div>
																			<div class="timePeriodSelectDropdown_option_SecondHalfyear">하반기</div>
																		</div>
																		<div class="timePeriodSelectDropdown_card_child03">
																			<div class="timePeriodSelectDropdown_option">1분기</div>
																			<div class="timePeriodSelectDropdown_option">2분기</div>
																			<div class="timePeriodSelectDropdown_option">3분기</div>
																			<div class="timePeriodSelectDropdown_option">4분기</div>
																		</div>
																	</div>
																	<div class="next_year">
																		<svg class="HighlightSol HighlightSol--core Icon RightIcon" viewBox="0 0 32 32" aria-hidden="true" focusable="false"><path d="M13.148 4.31a1.5 1.5 0 0 0-2.298 1.928L19.04 16l-8.19 9.761a1.499 1.499 0 1 0 2.298 1.928l9-10.726a1.5 1.5 0 0 0 0-1.929l-9-10.726v.003Z"></path></svg>
																	</div>
																</div>
															</div>
														</div>
												</div>
											</div>
											<div class="createGoal_bottomBar">
												<div class="cancle_btn">
													<span>취소</span>
												</div>
												<div class="saveGoal">
													<span>목표 저장</span>
												</div>
											</div>
										</div>
										</div> 
									</div> 
								</div>


								<div id="connected_goal_content_parent">
									<!-- div 수정중  -->
									<!-- div 수정중  -->
									<!-- div 수정중  -->
									<%
									for (GoalSelectAllDto dto : goalSelectProjectlist) {
										int owneridx = dto.getOwner(); //작성자 
										MemberDao memberdao = new MemberDao();
										MemberAllDto memberdto = memberdao.getMemberAllDto(owneridx);
										int goalIdx = dto.getGoalIdx(); // goalIdx --> 목표의 가장 최신상태 

										statusAllDto = goalDao.getStatusNameFromGoalIdx(goalIdx);
									%>
									<div id="connected_goal_content">
										<div id="connected_goal_content1">
											<span>${name}</span>
											<svg
												class="MiniIcon Breadcrumb-divider--compact Breadcrumb-divider ArrowRightMiniIcon"
												viewBox="0 0 24 24" aria-hidden="true" focusable="false">
														<path
													d="M10.148 3.885A1.5 1.5 0 1 0 7.85 5.813l5.19 6.186-5.19 6.186a1.499 1.499 0 0 0 1.148 2.464c.428 0 .854-.182 1.15-.536l6-7.15a1.5 1.5 0 0 0 0-1.929l-6-7.149Z"></path></svg>
										</div>
										<div id="connected_goal_content2">
											<span><%=dto.getTitle()%></span>
										</div>
										<%
										if (statusAllDto == null) {
										%>
										<div id="connected_goal_content3">
											<div id="color"></div>
											<div id="state_of_the_goal">
												<span>상태없음(0%)</span>
											</div>
											<div id="connected_goal_content3_svg1">
												<svg
													class="MiniIcon ParentGoalCardContent-automaticIndicator AutomationMiniIcon"
													viewBox="0 0 24 24" aria-hidden="true" focusable="false">
													<path
														d="M5.414 14h4.198L7.39 20.666a1.968 1.968 0 0 0 .846 2.333c.333.206.699.307 1.06.307a1.98 1.98 0 0 0 1.405-.594l9.298-9.298a1.995 1.995 0 0 0 .434-2.179A1.994 1.994 0 0 0 18.585 10h-4.2l2.223-6.666a1.968 1.968 0 0 0-.846-2.333 1.969 1.969 0 0 0-2.465.287l-9.298 9.298a1.995 1.995 0 0 0-.434 2.179A1.994 1.994 0 0 0 5.413 14Z"></path></svg>
											</div>
											<div id="dotted">
												<span>•</span>
											</div>
											<div id="connected_goal_content3_period">
												<span>FY24 4분기</span>
											</div>
											<div id="profile_img">
												<img src="img/<%=memberdto.getProfileImg()%>"/>
											</div>
										</div>
										<%
										} else {
										%>
										<div id="connected_goal_content3">
											<div id="color"></div>
											<div id="state_of_the_goal">
												<span> ${statusAllDto.name}</span>
											</div>
											<div id="connected_goal_content3_svg1">
												<svg
													class="MiniIcon ParentGoalCardContent-automaticIndicator AutomationMiniIcon"
													viewBox="0 0 24 24" aria-hidden="true" focusable="false">
													<path
														d="M5.414 14h4.198L7.39 20.666a1.968 1.968 0 0 0 .846 2.333c.333.206.699.307 1.06.307a1.98 1.98 0 0 0 1.405-.594l9.298-9.298a1.995 1.995 0 0 0 .434-2.179A1.994 1.994 0 0 0 18.585 10h-4.2l2.223-6.666a1.968 1.968 0 0 0-.846-2.333 1.969 1.969 0 0 0-2.465.287l-9.298 9.298a1.995 1.995 0 0 0-.434 2.179A1.994 1.994 0 0 0 5.413 14Z"></path></svg>
											</div>
											<div id="dotted">
												<span>•</span>
											</div>
											<div id="connected_goal_content3_period">
												<span>FY24 4분기</span>
											</div>
											<div id="profile_img">
												<img src="img/<%=memberdto.getProfileImg()%>"/>
											</div>
										</div>
										<%
										}
										%>


									</div>



									<%-- <div id="connected_goal_content">
										<div id="connected_goal_content1">
											<span>java 학습하기</span>
											<svg
												class="MiniIcon Breadcrumb-divider--compact Breadcrumb-divider ArrowRightMiniIcon"
												viewBox="0 0 24 24" aria-hidden="true" focusable="false">
											<path
													d="M10.148 3.885A1.5 1.5 0 1 0 7.85 5.813l5.19 6.186-5.19 6.186a1.499 1.499 0 0 0 1.148 2.464c.428 0 .854-.182 1.15-.536l6-7.15a1.5 1.5 0 0 0 0-1.929l-6-7.149Z"></path></svg>
										</div>
										<div id="connected_goal_content2">
											<span><%=goalGetTitle.get(2) %></span>
										</div>
										<div id="connected_goal_content3">
											<div id="color"></div>
											<div id="state_of_the_goal">
												<span><%=mostUpdateStatusOfGoal.get(2) %></span>
											</div>
											<div id="connected_goal_content3_svg1">
												<svg
													class="MiniIcon ParentGoalCardContent-automaticIndicator AutomationMiniIcon"
													viewBox="0 0 24 24" aria-hidden="true" focusable="false">
										<path
														d="M5.414 14h4.198L7.39 20.666a1.968 1.968 0 0 0 .846 2.333c.333.206.699.307 1.06.307a1.98 1.98 0 0 0 1.405-.594l9.298-9.298a1.995 1.995 0 0 0 .434-2.179A1.994 1.994 0 0 0 18.585 10h-4.2l2.223-6.666a1.968 1.968 0 0 0-.846-2.333 1.969 1.969 0 0 0-2.465.287l-9.298 9.298a1.995 1.995 0 0 0-.434 2.179A1.994 1.994 0 0 0 5.413 14Z"></path></svg>
											</div>
											<div id="dotted">
												<span>•</span>
											</div>
											<div id="connected_goal_content3_period">
												<span>FY24 4분기</span>
											</div>
											<div id="profile_img"></div>
										</div>

									</div> --%>



									<%-- <div id="connected_goal_content">
										<div id="connected_goal_content1">
											<span></span>
											<svg
												class="MiniIcon Breadcrumb-divider--compact Breadcrumb-divider ArrowRightMiniIcon"
												viewBox="0 0 24 24" aria-hidden="true" focusable="false">
							<path
													d="M10.148 3.885A1.5 1.5 0 1 0 7.85 5.813l5.19 6.186-5.19 6.186a1.499 1.499 0 0 0 1.148 2.464c.428 0 .854-.182 1.15-.536l6-7.15a1.5 1.5 0 0 0 0-1.929l-6-7.149Z"></path></svg>
										</div>
										<div id="connected_goal_content2">
											<span><%=goalGetTitle.get(1) %></span>
										</div>
										<div id="connected_goal_content3">
											<div id="color"></div>
											<div id="state_of_the_goal">
												<span><%=mostUpdateStatusOfGoal.get(1) %></span>
											</div>
											<div id="connected_goal_content3_svg1">
												<svg
													class="MiniIcon ParentGoalCardContent-automaticIndicator AutomationMiniIcon"
													viewBox="0 0 24 24" aria-hidden="true" focusable="false">
										<path
														d="M5.414 14h4.198L7.39 20.666a1.968 1.968 0 0 0 .846 2.333c.333.206.699.307 1.06.307a1.98 1.98 0 0 0 1.405-.594l9.298-9.298a1.995 1.995 0 0 0 .434-2.179A1.994 1.994 0 0 0 18.585 10h-4.2l2.223-6.666a1.968 1.968 0 0 0-.846-2.333 1.969 1.969 0 0 0-2.465.287l-9.298 9.298a1.995 1.995 0 0 0-.434 2.179A1.994 1.994 0 0 0 5.413 14Z"></path></svg>
											</div>
											<div id="dotted">
												<span>•</span>
											</div>
											<div id="connected_goal_content3_period">
												<span>FY24 4분기</span>
											</div>
											<div id="profile_img"></div>
										</div>

									</div> --%>
									<%-- <div id="connected_goal_content">
										<div id="connected_goal_content2">
											<span><%=goalGetTitle.get(0) %></span>
										</div>
										<div id="connected_goal_content3">
											<div id="color"></div>
											<div id="state_of_the_goal">
												<span><%=mostUpdateStatusOfGoal.get(0) %></span>
											</div>
											<div id="connected_goal_content3_svg1">
												<svg
													class="MiniIcon ParentGoalCardContent-automaticIndicator AutomationMiniIcon"
													viewBox="0 0 24 24" aria-hidden="true" focusable="false">
										<path
														d="M5.414 14h4.198L7.39 20.666a1.968 1.968 0 0 0 .846 2.333c.333.206.699.307 1.06.307a1.98 1.98 0 0 0 1.405-.594l9.298-9.298a1.995 1.995 0 0 0 .434-2.179A1.994 1.994 0 0 0 18.585 10h-4.2l2.223-6.666a1.968 1.968 0 0 0-.846-2.333 1.969 1.969 0 0 0-2.465.287l-9.298 9.298a1.995 1.995 0 0 0-.434 2.179A1.994 1.994 0 0 0 5.413 14Z"></path></svg>
											</div>
											<div id="dotted">
												<span>•</span>
											</div>
											<div id="connected_goal_content3_period">
												<span>FY24 4분기</span>
											</div>
											<div id="profile_img"></div>
										</div>

									</div> --%>
									<!-- div 수정중  -->
									<!-- div 수정중  -->
									<!-- div 수정중  -->
									<%}%>
								</div>
							</div>
							<div id="main_connected_portfolio">

								<div id="connected_portfolio1">
									<span>연결된 포트폴리오</span>
									<div class="connected_portfolio1_plusIcon">
										<svg class="Icon PlusIcon" viewBox="0 0 32 32"
											aria-hidden="true" focusable="false">
								<path
												d="M26,14h-8V6c0-1.1-0.9-2-2-2l0,0c-1.1,0-2,0.9-2,2v8H6c-1.1,0-2,0.9-2,2l0,0c0,1.1,0.9,2,2,2h8v8c0,1.1,0.9,2,2,2l0,0c1.1,0,2-0.9,2-2v-8h8c1.1,0,2-0.9,2-2l0,0C28,14.9,27.1,14,26,14z"></path></svg>
									</div>
								</div>
								<!-- 연결된 포트폴리오 null 일시 띄워주는 div 생성  -->
								<!-- <div class="connected_portfolioOverviewSection_content">
										포트폴리오를 연결하여 이 프로젝트를 더 큰 규모의 <br/>
										작업에 연결하세요.
										<div class="Btn_portfolio_img">
											<svg class="HighlightSol HighlightSol--core Icon ButtonThemeablePresentation-leftIcon PortfolioGenericIcon" viewBox="0 0 32 32" aria-hidden="true" focusable="false"><path d="M29 8C30.6569 8 32 9.34315 32 11V25C32 27.7614 29.7614 30 27 30H5C2.23858 30 0 27.7614 0 25V5C0 3.34315 1.34315 2 3 2H12.2C12.5693 2 12.9086 2.20355 13.0824 2.52941L15.1529 6.41177C15.6743 7.38936 16.6921 8 17.8 8H29ZM30 11V25C30 26.6569 28.6569 28 27 28H5C3.34315 28 2 26.6569 2 25V10H29C29.5523 10 30 10.4477 30 11ZM13.7999 8C13.6477 7.79704 13.5099 7.58098 13.3882 7.35294L11.6 4H3C2.44772 4 2 4.44772 2 5V8H13.7999Z"></path></svg>
											포트폴리오 추가 
										</div>
									</div> -->

								<!-- 연결된 포트폴리오 클릭시 팝업  -->

								<div class="connected_portfolio_click_parent">
									<div class="connected_portfolio_click">
										<div class="connected_portfolio_click_title">
											<svg class="Icon PlusIcon" viewBox="0 0 32 32"
												aria-hidden="true" focusable="false">
														<path
													d="M26,14h-8V6c0-1.1-0.9-2-2-2l0,0c-1.1,0-2,0.9-2,2v8H6c-1.1,0-2,0.9-2,2l0,0c0,1.1,0.9,2,2,2h8v8c0,1.1,0.9,2,2,2l0,0c1.1,0,2-0.9,2-2v-8h8c1.1,0,2-0.9,2-2l0,0C28,14.9,27.1,14,26,14z"></path></svg>
											<input class="connected_portfolio_search_text"
												name="connectedPortfolio" type="text"
												placeholder="포트폴리오의 이름을 입력하세요 ..." />
										</div>
										<!-- <div class="connected_portfolio_click_content">
											<div class="connected_portfolio_click_portfolio_icon">
												<svg
													class="PortfolioColorIcon-duotoneBaseLayer ColorFillIcon ColorFillIcon--colorIndigo"
													viewBox="0 0 20 20" aria-labelledby="titlelui_36389"
													role="img" focusable="false">
																		<title id="titlelui_36389">포트폴리오</title><path
														d="M 0 2.5 C 0 1.65 0.65 1 1.5 1 H 7.7 C 7.9 1 8.05 1.1 8.15 1.3 L 9.6 4.2 C 9.85 4.7 10.35 5.05 10.95 5.05 H 18.5 C 19.35 5.05 20 5.7 20 6.55 V 16.55 C 20 17.95 18.9 19.05 17.5 19.05 H 2.5 C 1.1 19.05 0 17.95 0 16.55 V 2.5 Z"></path></svg>
											</div>
											<div class="connected_portfolio_click_content_title">취업성공</div>
										</div> -->
									</div>
									<div class="linked_portflio_search_list_popup">
										<div class="linked_portfolio_search_list_parent">
											<div class="linked_portfolio_search_list">
												<div class="linked_portfolio_search_list_icon">
													<svg class="PortfolioColorIcon-duotoneBaseLayer ColorFillIcon ColorFillIcon--colorIndigo" viewBox="0 0 20 20" aria-labelledby="titlelui_36389" role="img" focusable="false">
														<title id="titlelui_36389">포트폴리오</title>
														<path d="M 0 2.5 C 0 1.65 0.65 1 1.5 1 H 7.7 C 7.9 1 8.05 1.1 8.15 1.3 L 9.6 4.2 C 9.85 4.7 10.35 5.05 10.95 5.05 H 18.5 C 19.35 5.05 20 5.7 20 6.55 V 16.55 C 20 17.95 18.9 19.05 17.5 19.05 H 2.5 C 1.1 19.05 0 17.95 0 16.55 V 2.5 Z"></path>
													</svg>
												</div>
												<div class="linked_portfolio_search_list_title">
													포트폴리오 이름 3
												</div>
											</div>
										</div>
										<div class="linked_portfolio_create">
											<div class="linked_portfolio_create_icon">
												<svg class="HighlightSol HighlightSol--core Icon PlusIcon" viewBox="0 0 32 32" aria-hidden="true" focusable="false">
												<path d="M26,14h-8V6c0-1.1-0.9-2-2-2l0,0c-1.1,0-2,0.9-2,2v8H6c-1.1,0-2,0.9-2,2l0,0c0,1.1,0.9,2,2,2h8v8c0,1.1,0.9,2,2,2l0,0c1.1,0,2-0.9,2-2v-8h8c1.1,0,2-0.9,2-2l0,0C28,14.9,27.1,14,26,14z"></path>
												</svg>
											</div>
											<div class="linked_portfolio_create_div">새 포트폴리오 생성</div>
										</div>
									</div>
									<div class="newPortfolioCreationPopup">
										<div class="newPortfolioCreationPopup_Top">
											<span>새 포트폴리오</span>
											<div class="newPortfolioCreationPopup_deleteBtn">
												<svg class="HighlightSol HighlightSol--core Icon XIcon" viewBox="0 0 32 32" aria-hidden="true" focusable="false"><path d="M18.1,16L27,7.1c0.6-0.6,0.6-1.5,0-2.1s-1.5-0.6-2.1,0L16,13.9l-8.9-9C6.5,4.3,5.6,4.3,5,4.9S4.4,6.4,5,7l8.9,8.9L5,24.8c-0.6,0.6-0.6,1.5,0,2.1c0.3,0.3,0.7,0.4,1.1,0.4s0.8-0.1,1.1-0.4l8.9-8.9l8.9,8.9c0.3,0.3,0.7,0.4,1.1,0.4s0.8-0.1,1.1-0.4c0.6-0.6,0.6-1.5,0-2.1L18.1,16z"></path></svg>
											</div>
										</div>
										<div class="newPortfolioCreationPopup_content">
											<div class="newPortfolioCreationPopup_logoName">
												<div class="newPortfolioCreationPopup_logoName_firstLable">포트폴리오 제목</div>
												<div class="newPortfolioCreationPopup_logoName_input">
													<input name="portfolioName" type="text"/>
												</div>
											</div>
										</div>
										<div class="newPortfolioCreationPopup_bottom">
											<div class="newPortfolioCreationPopup_cancleBtn">취소</div>
											<div class="newPortfolioCreationPopup_saveBtn">목표 저장</div>
										</div>
									</div>
								</div>


								<!-- 연결된 포트폴리오 클릭시 팝업  -->
								<!-- 연결된 포트폴리오 조회  -->
								<!-- 연결된 포트폴리오 조회  -->
								<div class="connected_portfolio2_parent">
									<%
									for (PortfolioAllDto dto1 : portfolioAllDtolist11) {
										String statusName = null;
										String background= null;
										String charColor = null;
										String circleColor = null;
										int authoridx = dto1.getMemberIdx(); //작성자 idx 
										MemberDao dao = new MemberDao();
										MemberAllDto dto = dao.getMemberAllDto(authoridx);
										String authorProfile = dto.getProfileImg(); //작성자 프로필 사진 
										if(dto1.getStatus_idx()!=null){
											int statusIdx02 = dto1.getStatus_idx();
											StatusAllDto statusAllDto02 = statusGetAllDao.getStatusAllDto(statusIdx02);
											statusName = statusAllDto02.getName();
											background = statusAllDto02.getBackgroundColor();
											charColor = statusAllDto02.getCharColor();
											circleColor = statusAllDto02.getCircleColor(); %>
											<div class="connected_portfolio2" portfolioIdx="<%=dto1.getPortfolioIdx()%>">
												<div class="connected_portfolio2_child1">
													<svg
														class="PortfolioColorIcon-duotoneBaseLayer ColorFillIcon ColorFillIcon--colorIndigo"
														viewBox="0 0 20 20" aria-labelledby="titlelui_36389"
														role="img" focusable="false">
														<title id="titlelui_36389">포트폴리오</title><path
															d="M 0 2.5 C 0 1.65 0.65 1 1.5 1 H 7.7 C 7.9 1 8.05 1.1 8.15 1.3 L 9.6 4.2 C 9.85 4.7 10.35 5.05 10.95 5.05 H 18.5 C 19.35 5.05 20 5.7 20 6.55 V 16.55 C 20 17.95 18.9 19.05 17.5 19.05 H 2.5 C 1.1 19.05 0 17.95 0 16.55 V 2.5 Z"></path></svg>
												</div>
	
	
												<div class="connected_portfolio2_child2">
													<span><%=dto1.getName()%></span>
												</div>
												<%if(statusName != null){
												%>
												<div class="status_going_according_to_plan" style="background-color : <%=background%>">
													<svg class="HighlightSol MiniIcon StatusDotFillMiniIcon"
														viewBox="0 0 24 24" aria-hidden="true" focusable="false" style="fill: <%=circleColor%>">
														<path
															d="m20,12c0,4.42-3.58,8-8,8s-8-3.58-8-8S7.58,4,12,4s8,3.58,8,8Z"></path></svg>
													<span style="color:<%=charColor%>"><%if(statusName!=null){
													%><%=statusName%><%}%>
													</span>
												</div>
												<%} %>
										
												<div class="connected_portfolio2_child3">
													<img src="img/<%=authorProfile %>" class="portfolio_parent"></img>
												</div>
												<div class="connected_portfolio2_child4_parent">
													<div class="connected_portfolio2_child4">
														<svg class="Icon MoreIcon" viewBox="0 0 32 32"
															aria-hidden="true" focusable="false">
												<path
																d="M16,13c1.7,0,3,1.3,3,3s-1.3,3-3,3s-3-1.3-3-3S14.3,13,16,13z M3,13c1.7,0,3,1.3,3,3s-1.3,3-3,3s-3-1.3-3-3S1.3,13,3,13z M29,13c1.7,0,3,1.3,3,3s-1.3,3-3,3s-3-1.3-3-3S27.3,13,29,13z"></path></svg>
													</div>
													<div class="connected_portfolio2_deleteBtn">
														포트폴리오에서 제거 
													</div>
												</div>
										</div>
												<% }else{ %>
												<div class="connected_portfolio2" portfolioIdx="<%=dto1.getPortfolioIdx()%>">
												<div class="connected_portfolio2_child1">
													<svg
														class="PortfolioColorIcon-duotoneBaseLayer ColorFillIcon ColorFillIcon--colorIndigo"
														viewBox="0 0 20 20" aria-labelledby="titlelui_36389"
														role="img" focusable="false">
														<title id="titlelui_36389">포트폴리오</title><path
															d="M 0 2.5 C 0 1.65 0.65 1 1.5 1 H 7.7 C 7.9 1 8.05 1.1 8.15 1.3 L 9.6 4.2 C 9.85 4.7 10.35 5.05 10.95 5.05 H 18.5 C 19.35 5.05 20 5.7 20 6.55 V 16.55 C 20 17.95 18.9 19.05 17.5 19.05 H 2.5 C 1.1 19.05 0 17.95 0 16.55 V 2.5 Z"></path></svg>
												</div>
												<div class="connected_portfolio2_child2">
													<span><%=dto1.getName() %></span>
												</div>
												<div class="status_going_according_to_plan" style="display:none;">
													<svg class="HighlightSol MiniIcon StatusDotFillMiniIcon"
														viewBox="0 0 24 24" aria-hidden="true" focusable="false">
														<path
															d="m20,12c0,4.42-3.58,8-8,8s-8-3.58-8-8S7.58,4,12,4s8,3.58,8,8Z"></path></svg>
													<span>
													</span>
												</div>
												<div class="connected_portfolio2_child3">
													<img src="img/<%=authorProfile %>" class="portfolio_parent"></img>
												</div>
												<div class="connected_portfolio2_child4_parent">
													<div class="connected_portfolio2_child4">
														<svg class="Icon MoreIcon" viewBox="0 0 32 32"
															aria-hidden="true" focusable="false">
												<path
																d="M16,13c1.7,0,3,1.3,3,3s-1.3,3-3,3s-3-1.3-3-3S14.3,13,16,13z M3,13c1.7,0,3,1.3,3,3s-1.3,3-3,3s-3-1.3-3-3S1.3,13,3,13z M29,13c1.7,0,3,1.3,3,3s-1.3,3-3,3s-3-1.3-3-3S27.3,13,29,13z"></path></svg>
													</div>
													<div class="connected_portfolio2_deleteBtn">
														포트폴리오에서 제거 
													</div>
												</div>
										</div>
										<%} %>
									<%
									}
									%>
								</div>
								
								<!-- 연결된 포트폴리오 조회  -->
								<!-- 연결된 포트폴리오 조회  -->





							</div>

							<!-- 핵심리소스 삭제  -->
							<!-- <div class="core_resources">
								<div class="core_resources_01">
									<span>핵심 리소스</span>
								</div>
								<div class="core_resources_02">
									<div class="core_resources_03">
										<div class="core_resources_04">
											<img src="img/01.png"></img>
										</div>
										<div class="core_resources_05">
											<span>프로젝트 브리프와 도움이 되는 리소스를 사용하여 공유된 비전을 중심으로 팀을
												조율하세요.</span> <br /> <br />
											<svg
												class="Icon ButtonThemeablePresentation-leftIcon BriefIcon"
												viewBox="0 0 32 32" aria-hidden="true" focusable="false">
												<path
													d="M22 0H10C6.691 0 4 2.691 4 6v20c0 3.309 2.691 6 6 6h12c3.309 0 6-2.691 6-6V6c0-3.309-2.691-6-6-6Zm4 26c0 2.206-1.794 4-4 4H10c-2.206 0-4-1.794-4-4V6c0-2.206 1.794-4 4-4h12c2.206 0 4 1.794 4 4v20ZM22.611 8.75l-4.083-.597-1.822-3.714a.778.778 0 0 0-.706-.44.778.778 0 0 0-.706.44l-1.822 3.714-4.083.597a.786.786 0 0 0-.437 1.339l2.958 2.901-.697 4.09a.788.788 0 0 0 1.143.827l3.645-1.927 3.645 1.927a.788.788 0 0 0 1.143-.827l-.697-4.09 2.958-2.901a.786.786 0 0 0-.437-1.339h-.002Zm-3.922 2.812-.747.733.176 1.032.283 1.661-1.466-.776-.935-.495-.935.495-1.466.776.283-1.661.176-1.032-.747-.733-1.21-1.187 1.662-.243 1.042-.152.464-.946.732-1.492.732 1.492.464.946 1.042.152 1.662.243-1.21 1.187h-.002ZM22.999 21a1 1 0 0 1-1 1h-12a1 1 0 0 1 0-2h12a1 1 0 0 1 1 1Zm0 4a1 1 0 0 1-1 1h-12a1 1 0 0 1 0-2h12a1 1 0 0 1 1 1Z"></path></svg>
											<span class="core_resources_05_child">프로젝트 브리프 생성</span>
											<svg
												class="Icon ButtonThemeablePresentation-leftIcon AttachVerticalIcon"
												viewBox="0 0 32 32" aria-hidden="true" focusable="false">
												<path
													d="M19,32c-3.9,0-7-3.1-7-7V10c0-2.2,1.8-4,4-4s4,1.8,4,4v9c0,0.6-0.4,1-1,1s-1-0.4-1-1v-9c0-1.1-0.9-2-2-2s-2,0.9-2,2v15c0,2.8,2.2,5,5,5s5-2.2,5-5V10c0-4.4-3.6-8-8-8s-8,3.6-8,8v5c0,0.6-0.4,1-1,1s-1-0.4-1-1v-5C6,4.5,10.5,0,16,0s10,4.5,10,10v15C26,28.9,22.9,32,19,32z"></path></svg>
											<span class="core_resources_05_child">링크 및 파일 추가 </span>
										</div>
									</div>
								</div>
							</div> -->
							<div class="milestone">
								<div class="milestone_title">
									<span>마일스톤</span>
									<svg class="milestone_title_Icon_PlusIcon" viewBox="0 0 32 32"
										aria-hidden="true" focusable="false">
										<path
											d="M26,14h-8V6c0-1.1-0.9-2-2-2l0,0c-1.1,0-2,0.9-2,2v8H6c-1.1,0-2,0.9-2,2l0,0c0,1.1,0.9,2,2,2h8v8c0,1.1,0.9,2,2,2l0,0c1.1,0,2-0.9,2-2v-8h8c1.1,0,2-0.9,2-2l0,0C28,14.9,27.1,14,26,14z"></path></svg>
								</div>
								<!--마일스톤 검색창   -->
								<div class="milestone_click_add">
									<div class="milestone_click_add_icon">
										<svg
											class="HighlightSol HighlightSol--core CompoundIcon--small CompoundIcon MilestoneCompletionCompoundIcon MilestoneCompletionStatusIndicator--overdue MilestoneCompletionStatusIndicator MilestoneRowCompletionStatus-icon--enabled MilestoneRowCompletionStatus-icon--incomplete MilestoneRowCompletionStatus-icon--overdue MilestoneRowCompletionStatus-icon"
											data-testid="milestone_completion_status_indicator"
											viewBox="0 0 32 32" aria-hidden="true" focusable="false">
										<path
												d="M20.1,2.8c-2.3-2.3-5.9-2.3-8.2,0L2.7,12c-2.3,2.3-2.3,5.9,0,8.2l9.2,9.2c2.3,2.3,5.9,2.3,8.2,0l9.2-9.2  c2.3-2.3,2.3-5.9,0-8.2L20.1,2.8z"
												class="CompoundIcon-outer"></path>
										<path
												d="M13.4,22.2c-0.3,0-0.5-0.1-0.7-0.3L8.8,18c-0.4-0.4-0.4-1,0-1.4s1-0.4,1.4,0l3.1,3.1l8.1-8.1c0.4-0.4,1-0.4,1.4,0   s0.4,1,0,1.4l-8.9,8.9C13.9,22.1,13.7,22.2,13.4,22.2z"
												class="CompoundIcon-inner"></path></svg>
									</div>
									<div class="milestone_click_add_search_text">
										<input class="milestone_connected_portfolio_search_text"
											name="connectedPortfolio" type="text"
											placeholder="마일스톤 추가 ..." />
									</div>
									<div class="milestone_click_add_svg">
										<svg class="Icon CalendarIcon" viewBox="0 0 32 32"
											aria-hidden="true" focusable="false">
										<path
												d="M24,2V1c0-0.6-0.4-1-1-1s-1,0.4-1,1v1H10V1c0-0.6-0.4-1-1-1S8,0.4,8,1v1C4.7,2,2,4.7,2,8v16c0,3.3,2.7,6,6,6h16c3.3,0,6-2.7,6-6V8C30,4.7,27.3,2,24,2z M8,4v1c0,0.6,0.4,1,1,1s1-0.4,1-1V4h12v1c0,0.6,0.4,1,1,1s1-0.4,1-1V4c2.2,0,4,1.8,4,4v2H4V8C4,5.8,5.8,4,8,4z M24,28H8c-2.2,0-4-1.8-4-4V12h24v12C28,26.2,26.2,28,24,28z"></path></svg>
									</div>
									<div class="milestone_click_add_svg">
										<svg class="HighlightSol HighlightSol--core Icon UsersIcon"
											viewBox="0 0 32 32" aria-hidden="true" focusable="false">
											<path
												d="M21,18c-4.411,0-8-3.589-8-8S16.589,2,21,2s8,3.589,8,8-3.589,8-8,8Zm0-14c-3.309,0-6,2.691-6,6s2.691,6,6,6,6-2.691,6-6-2.691-6-6-6Zm11,25v-2c0-3.86-3.141-7-7-7h-8c-3.859,0-7,3.14-7,7v2c0,.552,.447,1,1,1s1-.448,1-1v-2c0-2.757,2.243-5,5-5h8c2.757,0,5,2.243,5,5v2c0,.552,.447,1,1,1s1-.448,1-1ZM12,17c0-.552-.447-1-1-1-3.309,0-6-2.691-6-6s2.691-6,6-6c.553,0,1-.448,1-1s-.447-1-1-1C6.589,2,3,5.589,3,10s3.589,8,8,8c.553,0,1-.448,1-1ZM2,29v-2c0-2.757,2.243-5,5-5h2c.553,0,1-.448,1-1s-.447-1-1-1h-2C3.141,20,0,23.14,0,27v2C0,29.552,.447,30,1,30s1-.448,1-1Z"></path></svg>
									</div>
								</div>
								<!--마일스톤 검색창   -->

								<!-- 연결된 마일스톤  -->
								<!-- 연결된 마일스톤  -->
								<!-- 연결된 마일스톤  -->
								<%
								//wamDtolist ? 

								for (WamAllDto dto02 : wamDtolist) {
									String deadline = dto02.getDeadlineDate(); //null 이라면 
									String newFormatDate = null;
									if (deadline != null) {
										SimpleDateFormat formatter1 = new SimpleDateFormat("yyyyMMdd"); //SimpleDateFormat 사용 
										SimpleDateFormat formatter2 = new SimpleDateFormat("MM월dd일");
										Date formatDate = formatter1.parse(deadline); //yyyyMMdd 으로 형식 변경 
										newFormatDate = formatter2.format(formatDate); // MM월dd일 으로 형식 변경 

									}

									//작성자 사진 출력 
									int memberIdx03 = dto02.getManagerIdx();
									MemberAllDto memberAllDto01 = memberDao.getMemberAllDto(memberIdx03);
									String profileImg = memberAllDto01.getProfileImg();
								%>

								<div class="milestone_content1">
									<div class="milestone_content1_child01">
										<svg
											class="CompoundIcon--small CompoundIcon MilestoneCompletionCompoundIcon MilestoneCompletionStatusIndicator--complete MilestoneCompletionStatusIndicator MilestoneRowCompletionStatus-icon--complete MilestoneRowCompletionStatus-icon--enabled MilestoneRowCompletionStatus-icon"
											data-testid="milestone_completion_status_indicator"
											viewBox="0 0 32 32" aria-hidden="true" focusable="false">
											<path
												d="M20.1,2.8c-2.3-2.3-5.9-2.3-8.2,0L2.7,12c-2.3,2.3-2.3,5.9,0,8.2l9.2,9.2c2.3,2.3,5.9,2.3,8.2,0l9.2-9.2  c2.3-2.3,2.3-5.9,0-8.2L20.1,2.8z"
												class="CompoundIcon-outer"></path>
											<path
												d="M13.4,22.2c-0.3,0-0.5-0.1-0.7-0.3L8.8,18c-0.4-0.4-0.4-1,0-1.4s1-0.4,1.4,0l3.1,3.1l8.1-8.1c0.4-0.4,1-0.4,1.4,0   s0.4,1,0,1.4l-8.9,8.9C13.9,22.1,13.7,22.2,13.4,22.2z"
												class="CompoundIcon-inner"></path></svg>
									</div>
									<div class="milestone_content1_child02">
										<span><%=dto02.getTitle()%></span>
									</div>
									<div class="milestone_content1_child03">
										<span>
											<%
											if (newFormatDate != null) {
											%> <%=newFormatDate%> <%}%>
										</span>
									</div>
									<img class="profile_img" src="img/<%=profileImg%>"></img>
								</div>
								<%
								}
								%>
								<!-- 연결된 마일스톤  -->
								<!-- 연결된 마일스톤  -->
								<!-- 연결된 마일스톤  -->
								<!-- <div class="milestone_content1">
									<div class="milestone_content1_child01">
										<svg
											class="CompoundIcon--small CompoundIcon MilestoneCompletionCompoundIcon MilestoneCompletionStatusIndicator--complete MilestoneCompletionStatusIndicator MilestoneRowCompletionStatus-icon--complete MilestoneRowCompletionStatus-icon--enabled MilestoneRowCompletionStatus-icon"
											data-testid="milestone_completion_status_indicator"
											viewBox="0 0 32 32" aria-hidden="true" focusable="false">
											<path
												d="M20.1,2.8c-2.3-2.3-5.9-2.3-8.2,0L2.7,12c-2.3,2.3-2.3,5.9,0,8.2l9.2,9.2c2.3,2.3,5.9,2.3,8.2,0l9.2-9.2  c2.3-2.3,2.3-5.9,0-8.2L20.1,2.8z"
												class="CompoundIcon-outer"></path>
											<path
												d="M13.4,22.2c-0.3,0-0.5-0.1-0.7-0.3L8.8,18c-0.4-0.4-0.4-1,0-1.4s1-0.4,1.4,0l3.1,3.1l8.1-8.1c0.4-0.4,1-0.4,1.4,0   s0.4,1,0,1.4l-8.9,8.9C13.9,22.1,13.7,22.2,13.4,22.2z"
												class="CompoundIcon-inner"></path></svg>
									</div>
									<div class="milestone_content1_child02">
										<span>기능명세서 완성</span>
									</div>
									<div class="milestone_content1_child03">
										<span>12월 7일</span>
									</div>
									<img class="profile_img" src="img/짱구2.jpg"></img>
								</div> -->
							</div>
							<div class="blank_margin"></div>
						</div>
					</div>
					<div id="activity_feed">
						<div class="status_update">
							<div class="status_update_title">
								<span style="color:${updqteStatusAllDtoGetCharColor}">
									${updateStatusAllDtoGetName}</span>

								<!-- 상태업데이트 동적 수정중  -->
								<div class="click_status_update content">
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
								<!-- 상태업데이트 동적 수정중  -->
							</div>

							<!-- 상태업데이트 div  -->
							<!-- 상태업데이트 div  -->
							
							<div class="status_update_content" id="${projectStatusDto.projectStatusIdx}">
								<div class="status_update_content01"
									style="background:${statusAllDto11.charColor}"></div>
								<div class="status_update_content02_parent">
									<div class="status_update_content02">
										<span class="status_update_content02_span01"> 상태 업데이트 -
											<span>${projectstatusdateFormatPost}</span>
										</span> <br> <br> <span
											class="status_update_content02_span02">요약</span>
									</div>
									<div class="status_update_content03">
										<img src="img/${memberAllDto.profileImg}"></img>
										<div class="status_update_content04">
											<span class="status_update_content04_span1">
											${memberAllDto.nickname}
											</span>
											<br> <span class="status_update_content04_span2">25일
												전</span>
										</div>
										<svg class="Icon_Button" viewBox="0 0 32 32"
											aria-hidden="true" focusable="false">
											<path
												d="M5 28h19.94a3.987 3.987 0 0 0 3.961-3.395l1.552-10.03a3.96 3.96 0 0 0-.909-3.187 3.962 3.962 0 0 0-3.01-1.384H20V4.006C20 2.045 18.71.469 16.785.084c-1.918-.383-3.723.573-4.477 2.383l-3.975 9.536H5c-1.654 0-3 1.345-3 2.999V25c0 1.654 1.346 3 3 3Zm5-14.8 4.154-9.969c.465-1.116 1.5-1.341 2.238-1.191.742.148 1.608.751 1.608 1.961V12h8.532c.574 0 1.118.25 1.492.687.374.437.54 1.012.451 1.58l-1.552 10.032A1.997 1.997 0 0 1 24.94 26H10V13.2H10ZM4 15c0-.551.448-1 1-1h3v12H5c-.552 0-1-.449-1-1V15Z"></path></svg>
									</div>
								</div>
							</div>
							<!-- 상태업데이트 div  -->
							<!-- 상태업데이트 div  -->

						</div>
						<div class="project_summary">
							<div class="main_project_summary">
								<div class="project_summary_content1">
									<img alt=""
										src="https://d3ki9tyy5l5ruj.cloudfront.net/obj/7dba910df709118d839d60fa095ed87acc71ec4c/ai_icon_12.svg"
										class="AiCopilotMiniIcon--undefined"> <span>프로젝트
										요약</span>
								</div>
								<div class="project_summary_content2">
									<span>인공 지능을 사용하여 이 프로젝트의 최근 진행 상황을 파악하세요.</span>
								</div>
								<div class="project_summary_content3">
									<div class="project_summary_content3_child">
										<div class="Compound_button">
											<svg
												class="CompoundIcon--xsmall CompoundIcon TaskCompletionCompoundIcon SwitchPresentation-checkCircle"
												viewBox="0 0 24 24" aria-hidden="true" focusable="false">
												<path
													d="M23,12c0,6.1-4.9,11-11,11S1,18.1,1,12S5.9,1,12,1S23,5.9,23,12z"
													class="CompoundIcon-outer"></path>
												<path
													d="M10.6,16.9c-0.4,0.4-1,0.4-1.4,0l-3.4-3.4c-0.4-0.4-0.4-1,0-1.4l0,0c0.4-0.4,1-0.4,1.4,0l2.7,2.7l6.4-6.4   c0.4-0.4,1-0.4,1.4,0l0,0c0.4,0.4,0.4,1,0,1.4L10.6,16.9z"
													class="CompoundIcon-inner"></path></svg>
										</div>
										<span>구독</span>
									</div>
								</div>
							</div>
						</div>
						<div class="deadline">

							<!-- 프로젝트 마감일 조회  -->
							<!-- 프로젝트 마감일 조회  -->
							<%
							Date startDatePre = null;
							String newFormatstartDate = null;
							if (startDate != null) {
								SimpleDateFormat formatter03 = new SimpleDateFormat("yyyyMMdd"); //SimpleDateFormat 사용 
								SimpleDateFormat formatter04 = new SimpleDateFormat("MM월dd일");
								startDatePre = formatter03.parse(startDate);
								newFormatstartDate = formatter04.format(startDatePre); //마감일의 시작일 포맷 

							}
							SimpleDateFormat formatter05 = new SimpleDateFormat("yyyyMMdd"); //SimpleDateFormat 사용 
							SimpleDateFormat formatter06 = new SimpleDateFormat("MM월dd일");
							String deadline = projectAllDto2.getDeadline_date(); // 마감일의 종료일 
							Date deadlinePre = formatter05.parse(deadline);
							String newFormatdeadline = formatter06.format(deadlinePre); //마감일의 종료일 포맷
							%>
							<div class="deadline_content">
								<div class="calendar">
									<svg class="Icon CalendarIcon" viewBox="0 0 32 32"
										aria-hidden="true" focusable="false">
										<path
											d="M24,2V1c0-0.6-0.4-1-1-1s-1,0.4-1,1v1H10V1c0-0.6-0.4-1-1-1S8,0.4,8,1v1C4.7,2,2,4.7,2,8v16c0,3.3,2.7,6,6,6h16c3.3,0,6-2.7,6-6V8C30,4.7,27.3,2,24,2z M8,4v1c0,0.6,0.4,1,1,1s1-0.4,1-1V4h12v1c0,0.6,0.4,1,1,1s1-0.4,1-1V4c2.2,0,4,1.8,4,4v2H4V8C4,5.8,5.8,4,8,4z M24,28H8c-2.2,0-4-1.8-4-4V12h24v12C28,26.2,26.2,28,24,28z"></path></svg>
								</div>
								<span> <%
 if (startDate == null) {
 %> <%=newFormatdeadline%> <%
 } else {
 %> <%=newFormatstartDate%> - <%=newFormatdeadline%>
									<%
									}
									%>
								</span>
							</div>
							<!-- 프로젝트 마감일 조회  -->
							<!-- 프로젝트 마감일 조회  -->

						</div>
						<div class="message_line">
							<svg
								class="Icon ProjectOverviewActivityFeed-messageButtonIcon CommentIcon"
								viewBox="0 0 32 32" aria-hidden="true" focusable="false">
								<path
									d="M20 28c6.617 0 12-5.383 12-12v-2c0-6.617-5.383-12-12-12h-8C5.383 2 0 7.383 0 14v2c0 3.368 1.459 6.611 4.004 8.898.068.061.151.098.226.149l.778 6.079a.998.998 0 0 0 1.634.639l4.492-3.766h8.865L20 28Z"></path></svg>
							<span>멤버에게 메시지 보내기</span>
						</div>
						<!-- 타임라인 jsp 수정 --><!-- 타임라인 jsp 수정 --><!-- 타임라인 jsp 수정 -->
						<!-- <div class="activityfeed_timeline">
							<div class="activityfeed_timeline_child01">
								<svg class="Icon UsersIcon" viewBox="0 0 32 32"
									aria-hidden="true" focusable="false">
									<path
										d="M21,18c-4.411,0-8-3.589-8-8S16.589,2,21,2s8,3.589,8,8-3.589,8-8,8Zm0-14c-3.309,0-6,2.691-6,6s2.691,6,6,6,6-2.691,6-6-2.691-6-6-6Zm11,25v-2c0-3.86-3.141-7-7-7h-8c-3.859,0-7,3.14-7,7v2c0,.552,.447,1,1,1s1-.448,1-1v-2c0-2.757,2.243-5,5-5h8c2.757,0,5,2.243,5,5v2c0,.552,.447,1,1,1s1-.448,1-1ZM12,17c0-.552-.447-1-1-1-3.309,0-6-2.691-6-6s2.691-6,6-6c.553,0,1-.448,1-1s-.447-1-1-1C6.589,2,3,5.589,3,10s3.589,8,8,8c.553,0,1-.448,1-1ZM2,29v-2c0-2.757,2.243-5,5-5h2c.553,0,1-.448,1-1s-.447-1-1-1h-2C3.141,20,0,23.14,0,27v2C0,29.552,.447,30,1,30s1-.448,1-1Z"></path></svg>
								<span>zingh1113@gmail.com 님이 참가했습니다</span>
							</div>
							<div class="activityfeed_timeline_child02">
								<span>4일 전 </span>
							</div>
							<div class="activityfeed_timeline_child03">
								<div class="member_profile"></div>
							</div>
						</div>
						<div class="activityfeed_timeline_vesion2 timeline_02">
							<div class="activityfeed_timeline_child01">
								<svg class="Icon CommentLineIcon" viewBox="0 0 32 32"
									aria-hidden="true" focusable="false">
									<path
										d="M20 2h-8C5.383 2 0 7.383 0 14v2c0 3.103 1.239 6.1 3.424 8.342l.586 5.857a1.999 1.999 0 0 0 3.247 1.357L11.662 28h8.339c6.617 0 12-5.383 12-12v-2c0-6.617-5.384-12-12.001-12Zm-9.045 24L6 30l-.659-6.589C3.305 21.58 2 18.953 2 16v-2C2 8.477 6.477 4 12 4h8c5.523 0 10 4.477 10 10v2c0 5.523-4.477 10-10 10h-9.045Z"></path></svg>
								<span>협업툴 개발 파일</span>
							</div>
							<div class="activityfeed_timeline_child02_version2">
								<span class="timeline_child02_version2_01">현우</span> <span
									class="timeline_child02_version2_02">4일 전 </span>
							</div>
						</div>
						<div class="activityfeed_timeline timeline_03">
							<div class="activityfeed_timeline_child01">
								<svg class="Icon UsersIcon" viewBox="0 0 32 32"
									aria-hidden="true" focusable="false">
									<path
										d="M21,18c-4.411,0-8-3.589-8-8S16.589,2,21,2s8,3.589,8,8-3.589,8-8,8Zm0-14c-3.309,0-6,2.691-6,6s2.691,6,6,6,6-2.691,6-6-2.691-6-6-6Zm11,25v-2c0-3.86-3.141-7-7-7h-8c-3.859,0-7,3.14-7,7v2c0,.552,.447,1,1,1s1-.448,1-1v-2c0-2.757,2.243-5,5-5h8c2.757,0,5,2.243,5,5v2c0,.552,.447,1,1,1s1-.448,1-1ZM12,17c0-.552-.447-1-1-1-3.309,0-6-2.691-6-6s2.691-6,6-6c.553,0,1-.448,1-1s-.447-1-1-1C6.589,2,3,5.589,3,10s3.589,8,8,8c.553,0,1-.448,1-1ZM2,29v-2c0-2.757,2.243-5,5-5h2c.553,0,1-.448,1-1s-.447-1-1-1h-2C3.141,20,0,23.14,0,27v2C0,29.552,.447,30,1,30s1-.448,1-1Z"></path></svg>
								<span>길주 님이 참가했습니다</span>
							</div>
							<div class="activityfeed_timeline_child02">
								<span>18일 전</span>
							</div>
							<div class="activityfeed_timeline_child03">
								<div class="member_profile"></div>
							</div>
						</div>
						<div class="activityfeed_timeline timeline_04">
							<div class="activityfeed_timeline_child01">
								<svg class="Icon UsersIcon" viewBox="0 0 32 32"
									aria-hidden="true" focusable="false">
									<path
										d="M21,18c-4.411,0-8-3.589-8-8S16.589,2,21,2s8,3.589,8,8-3.589,8-8,8Zm0-14c-3.309,0-6,2.691-6,6s2.691,6,6,6,6-2.691,6-6-2.691-6-6-6Zm11,25v-2c0-3.86-3.141-7-7-7h-8c-3.859,0-7,3.14-7,7v2c0,.552,.447,1,1,1s1-.448,1-1v-2c0-2.757,2.243-5,5-5h8c2.757,0,5,2.243,5,5v2c0,.552,.447,1,1,1s1-.448,1-1ZM12,17c0-.552-.447-1-1-1-3.309,0-6-2.691-6-6s2.691-6,6-6c.553,0,1-.448,1-1s-.447-1-1-1C6.589,2,3,5.589,3,10s3.589,8,8,8c.553,0,1-.448,1-1ZM2,29v-2c0-2.757,2.243-5,5-5h2c.553,0,1-.448,1-1s-.447-1-1-1h-2C3.141,20,0,23.14,0,27v2C0,29.552,.447,30,1,30s1-.448,1-1Z"></path></svg>
								<span>현우 님이 참가했습니다</span>
							</div>
							<div class="activityfeed_timeline_child02">
								<span>27일 전</span>
							</div>
							<div class="activityfeed_timeline_child03">
								<div class="member_profile"></div>
							</div>
						</div>
						<div class="activityfeed_timeline_vesion3 timeline_05">
							<div class="activityfeed_timeline_child01">
								<svg class="Icon_state_update" viewBox="0 0 32 32"
									aria-hidden="true" focusable="false">
									<path
										d="M16,0c8.8,0,16,7.2,16,16s-7.2,16-16,16S0,24.8,0,16S7.2,0,16,0z"></path></svg>
								<span>상태 업데이트 - </span> <span>10월 28일</span>
							</div>
							<div class="activityfeed_timeline_child02_version2">
								<span class="timeline_child02_version2_01">지숭</span> <span
									class="timeline_child02_version2_02">27일 전</span>
							</div>
						</div>
						<div class="activityfeed_timeline_vesion3 timeline_06">
							<div class="activityfeed_timeline_child01">
								<svg class="Icon_state_update" viewBox="0 0 32 32"
									aria-hidden="true" focusable="false">
									<path
										d="M16,0c8.8,0,16,7.2,16,16s-7.2,16-16,16S0,24.8,0,16S7.2,0,16,0z"></path></svg>
								<span>상태 업데이트 - </span> <span>10월 28일</span>
							</div>
							<div class="activityfeed_timeline_child02_version2">
								<span class="timeline_child02_version2_01">지숭</span> <span
									class="timeline_child02_version2_02">27일 전</span>
							</div>
						</div>
						<div class="activityfeed_timeline timeline_07">
							<div class="activityfeed_timeline_child01">
								<svg class="Icon UsersIcon" viewBox="0 0 32 32"
									aria-hidden="true" focusable="false">
									<path
										d="M21,18c-4.411,0-8-3.589-8-8S16.589,2,21,2s8,3.589,8,8-3.589,8-8,8Zm0-14c-3.309,0-6,2.691-6,6s2.691,6,6,6,6-2.691,6-6-2.691-6-6-6Zm11,25v-2c0-3.86-3.141-7-7-7h-8c-3.859,0-7,3.14-7,7v2c0,.552,.447,1,1,1s1-.448,1-1v-2c0-2.757,2.243-5,5-5h8c2.757,0,5,2.243,5,5v2c0,.552,.447,1,1,1s1-.448,1-1ZM12,17c0-.552-.447-1-1-1-3.309,0-6-2.691-6-6s2.691-6,6-6c.553,0,1-.448,1-1s-.447-1-1-1C6.589,2,3,5.589,3,10s3.589,8,8,8c.553,0,1-.448,1-1ZM2,29v-2c0-2.757,2.243-5,5-5h2c.553,0,1-.448,1-1s-.447-1-1-1h-2C3.141,20,0,23.14,0,27v2C0,29.552,.447,30,1,30s1-.448,1-1Z"></path></svg>
								<span>회원님이 참가했습니다</span>
							</div>
							<div class="activityfeed_timeline_child02">
								<span>29일 전</span>
							</div>
							<div class="activityfeed_timeline_child03">
								<div class="member_profile"></div>
							</div>
						</div> -->
						<!-- 타임라인 jsp 수정 --><!-- 타임라인 jsp 수정 --><!-- 타임라인 jsp 수정 -->
						<div class="project_timeline_parent">
						<%
						 //타임라인 : 프로젝트 멤버참여 , 메세지 , 상태업데이트 내림차순 조회 
						 for(TimeLineThingDto timeLineThingDto11 :timeLineThingDto1 ) {
							 String type = timeLineThingDto11.getType();
							
							 if (type.equals("project_status")) { 
								 int getIdx = timeLineThingDto11.getIdx(); 
								 ProjectStatusDto dto =  goalDao.getProjectStatusThingsDto(getIdx);
								
								//프로젝트 상태의 상태의 번호를 통해 status_idx 상태번호 , member_idx 상태의 작성자 조회 
								/*  System.out.println("상태 idx " + dto.getStatusIdx()); */
								 StatusAllDto statusAllDto01 = statusGetAllDao.getStatusAllDto(dto.getStatusIdx());
								/*  System.out.println("상태 배경색 : " +  statusAllDto01.getBackgroundColor());
								 System.out.println("작성자 idx " + dto.getMemberIdx()); */
								 MemberAllDto memberAllDto01 = memberDao.getMemberAllDto(dto.getMemberIdx());
								/*  System.out.println("작성자 닉네임 :" + memberAllDto01.getNickname());
								 System.out.println("작성시간" + dto.getStatusDate()); */
								 String statusDate =dto.getStatusDate(); //포맷전 Date 
								 SimpleDateFormat formatterDate01 = new SimpleDateFormat("yyyy-MM-dd"); //SimpleDateFormat 사용 
								 SimpleDateFormat formatterDate02 = new SimpleDateFormat("MM월dd일");
								 Date projectFormatDate = formatterDate01.parse(statusDate.split(" ")[0]);
								 String projectFormatDatePost = formatterDate02.format(projectFormatDate); //포맷후 Date
								 %>
								 <div class="activityfeed_timeline_vesion3 timeline_06">
									<div class="activityfeed_timeline_child01">
										<svg class="Icon_state_update" viewBox="0 0 32 32"
											aria-hidden="true" focusable="false" fill="<%=statusAllDto01.getBackgroundColor()%>">
											<path
												d="M16,0c8.8,0,16,7.2,16,16s-7.2,16-16,16S0,24.8,0,16S7.2,0,16,0z"></path></svg>
										<span>상태 업데이트 - </span> <span><%=projectFormatDatePost%></span>
									</div>
									<div class="activityfeed_timeline_child02_version2">
										<span class="timeline_child02_version2_01"><%=memberAllDto01.getNickname() %></span> <span
											class="timeline_child02_version2_02"></span> 
									</div>
								</div>
							<% } 
							 
							 if (type.equals("message")) {
								 int getIdx = timeLineThingDto11.getIdx(); //당시의 idx 
								 MessageThingsDto dto =  goalDao.getMessageThingsDto(getIdx);
								 //메세지의 제목 , 작성자 , 작성시간 조회 
								
								 MemberAllDto memberAllDto02 = memberDao.getMemberAllDto(dto.getWriterIdx());
								
								
								 String statusDate = dto.getWriteDate(); //포맷전 Date 
								 SimpleDateFormat formatterDate01 = new SimpleDateFormat("yyyy-MM-dd"); //SimpleDateFormat 사용 
								 SimpleDateFormat formatterDate02 = new SimpleDateFormat("MM월dd일");
								 Date projectFormatDate = formatterDate01.parse(statusDate.split(" ")[0]);
								 String projectFormatDatePost = formatterDate02.format(projectFormatDate); //포맷후 Date

								 %> 
								 <div class="activityfeed_timeline_vesion2 timeline_02">
									<div class="activityfeed_timeline_child01">
										<svg class="Icon CommentLineIcon" viewBox="0 0 32 32"
											aria-hidden="true" focusable="false">
											<path
												d="M20 2h-8C5.383 2 0 7.383 0 14v2c0 3.103 1.239 6.1 3.424 8.342l.586 5.857a1.999 1.999 0 0 0 3.247 1.357L11.662 28h8.339c6.617 0 12-5.383 12-12v-2c0-6.617-5.384-12-12.001-12Zm-9.045 24L6 30l-.659-6.589C3.305 21.58 2 18.953 2 16v-2C2 8.477 6.477 4 12 4h8c5.523 0 10 4.477 10 10v2c0 5.523-4.477 10-10 10h-9.045Z"></path></svg>
										<span><%=dto.getTitle() %></span>
									</div>
									<div class="activityfeed_timeline_child02_version2">
										<span class="timeline_child02_version2_01"><%= memberAllDto02.getNickname()%></span> <span
											class="timeline_child02_version2_02"> <%= projectFormatDatePost%></span>
									</div>
								</div>
								 
								 
							<% } 
							 
							 if (type.equals("project_participants")) {
								 
								 int getIdx = timeLineThingDto11.getIdx(); //당시의 Pk idx 
								 Project_participantsAllDto dto = goalDao.getProject_participantsThingsDto(getIdx);
								//프로젝트 참여자의 member_idx, participant_date 조회 
								/*  System.out.println("프로젝트 참여자 회원번호" + dto.getMember_idx()); */
								 MemberAllDto memberAllDto03 = memberDao.getMemberAllDto(dto.getMember_idx());
								/*  System.out.println("작성자 닉네임 :" + memberAllDto03.getNickname());
								 System.out.println("작성자 이미지 : " + memberAllDto03.getProfileImg());
								 System.out.println("프로젝트 참여자 날짜 " + dto.getParticipant_date()); */
								 String statusDate = dto.getParticipant_date(); //포맷전 Date 
								 SimpleDateFormat formatterDate01 = new SimpleDateFormat("yyyy-MM-dd"); //SimpleDateFormat 사용 
								 SimpleDateFormat formatterDate02 = new SimpleDateFormat("MM월dd일");
								 Date projectFormatDate = formatterDate01.parse(statusDate.split(" ")[0]);
								 String projectFormatDatePost = formatterDate02.format(projectFormatDate); //포맷후 Date
								 %>
								 <div class="activityfeed_timeline timeline_04">
									<div class="activityfeed_timeline_child01">
										<svg class="Icon UsersIcon" viewBox="0 0 32 32"
											aria-hidden="true" focusable="false">
											<path
												d="M21,18c-4.411,0-8-3.589-8-8S16.589,2,21,2s8,3.589,8,8-3.589,8-8,8Zm0-14c-3.309,0-6,2.691-6,6s2.691,6,6,6,6-2.691,6-6-2.691-6-6-6Zm11,25v-2c0-3.86-3.141-7-7-7h-8c-3.859,0-7,3.14-7,7v2c0,.552,.447,1,1,1s1-.448,1-1v-2c0-2.757,2.243-5,5-5h8c2.757,0,5,2.243,5,5v2c0,.552,.447,1,1,1s1-.448,1-1ZM12,17c0-.552-.447-1-1-1-3.309,0-6-2.691-6-6s2.691-6,6-6c.553,0,1-.448,1-1s-.447-1-1-1C6.589,2,3,5.589,3,10s3.589,8,8,8c.553,0,1-.448,1-1ZM2,29v-2c0-2.757,2.243-5,5-5h2c.553,0,1-.448,1-1s-.447-1-1-1h-2C3.141,20,0,23.14,0,27v2C0,29.552,.447,30,1,30s1-.448,1-1Z"></path></svg>
										<span><%= memberAllDto03.getNickname()%>님이 참가했습니다</span>
									</div>
									<div class="activityfeed_timeline_child02">
										<span><%= projectFormatDatePost %></span>
									</div>
									<div class="activityfeed_timeline_child03">
										<div class="member_profile">
											<img src="img/<%=memberAllDto03.getProfileImg()%>"/>
										</div>
									</div>
								</div>
						<% 
							 }
							 
						 }
						 
						 %> 
							
							<!-- ~님이 참가했습니다. --><!-- ~님이 참가했습니다. --><!-- ~님이 참가했습니다. -->
							<!-- <div class="activityfeed_timeline timeline_04">
								<div class="activityfeed_timeline_child01">
									<svg class="Icon UsersIcon" viewBox="0 0 32 32"
										aria-hidden="true" focusable="false">
										<path
											d="M21,18c-4.411,0-8-3.589-8-8S16.589,2,21,2s8,3.589,8,8-3.589,8-8,8Zm0-14c-3.309,0-6,2.691-6,6s2.691,6,6,6,6-2.691,6-6-2.691-6-6-6Zm11,25v-2c0-3.86-3.141-7-7-7h-8c-3.859,0-7,3.14-7,7v2c0,.552,.447,1,1,1s1-.448,1-1v-2c0-2.757,2.243-5,5-5h8c2.757,0,5,2.243,5,5v2c0,.552,.447,1,1,1s1-.448,1-1ZM12,17c0-.552-.447-1-1-1-3.309,0-6-2.691-6-6s2.691-6,6-6c.553,0,1-.448,1-1s-.447-1-1-1C6.589,2,3,5.589,3,10s3.589,8,8,8c.553,0,1-.448,1-1ZM2,29v-2c0-2.757,2.243-5,5-5h2c.553,0,1-.448,1-1s-.447-1-1-1h-2C3.141,20,0,23.14,0,27v2C0,29.552,.447,30,1,30s1-.448,1-1Z"></path></svg>
									<span>현우 님이 참가했습니다</span>
								</div>
								<div class="activityfeed_timeline_child02">
									<span>27일 전</span>
								</div>
								<div class="activityfeed_timeline_child03">
									<div class="member_profile"></div>
								</div>
							</div> -->
							<!-- 상태 업데이트  --><!-- 상태 업데이트  --><!-- 상태 업데이트  -->
							<!-- <div class="activityfeed_timeline_vesion3 timeline_06">
								<div class="activityfeed_timeline_child01">
									<svg class="Icon_state_update" viewBox="0 0 32 32"
										aria-hidden="true" focusable="false">
										<path
											d="M16,0c8.8,0,16,7.2,16,16s-7.2,16-16,16S0,24.8,0,16S7.2,0,16,0z"></path></svg>
									<span>상태 업데이트 - </span> <span>10월 28일</span>
								</div>
								<div class="activityfeed_timeline_child02_version2">
									<span class="timeline_child02_version2_01">지숭</span> <span
										class="timeline_child02_version2_02">27일 전</span>
								</div>
							</div> -->
							<!-- 메세지  --><!-- 메세지  --><!-- 메세지  -->
							<!-- <div class="activityfeed_timeline_vesion2 timeline_02">
								<div class="activityfeed_timeline_child01">
									<svg class="Icon CommentLineIcon" viewBox="0 0 32 32"
										aria-hidden="true" focusable="false">
										<path
											d="M20 2h-8C5.383 2 0 7.383 0 14v2c0 3.103 1.239 6.1 3.424 8.342l.586 5.857a1.999 1.999 0 0 0 3.247 1.357L11.662 28h8.339c6.617 0 12-5.383 12-12v-2c0-6.617-5.384-12-12.001-12Zm-9.045 24L6 30l-.659-6.589C3.305 21.58 2 18.953 2 16v-2C2 8.477 6.477 4 12 4h8c5.523 0 10 4.477 10 10v2c0 5.523-4.477 10-10 10h-9.045Z"></path></svg>
									<span>협업툴 개발 파일</span>
								</div>
								<div class="activityfeed_timeline_child02_version2">
									<span class="timeline_child02_version2_01">현우</span> <span
										class="timeline_child02_version2_02">4일 전 </span>
								</div>
							</div> -->
						</div>
						
						
						
						<div class="activityfeed_timeline_vesion4 timeline_08">
							<div class="activityfeed_timeline_child01">
								<svg class="Icon_ProjectIcon" viewBox="0 0 32 32"
									aria-hidden="true" focusable="false">
									<path
										d="M10,13.5c0.8,0,1.5,0.7,1.5,1.5s-0.7,1.5-1.5,1.5S8.5,15.8,8.5,15S9.2,13.5,10,13.5z M23,14h-8c-0.6,0-1,0.4-1,1s0.4,1,1,1h8c0.6,0,1-0.4,1-1S23.6,14,23,14z M23,20h-8c-0.6,0-1,0.4-1,1s0.4,1,1,1h8c0.6,0,1-0.4,1-1S23.6,20,23,20z M10,19.5c0.8,0,1.5,0.7,1.5,1.5s-0.7,1.5-1.5,1.5S8.5,21.8,8.5,21S9.2,19.5,10,19.5z M24,2h-2.2c-0.4-1.2-1.5-2-2.8-2h-6c-1.3,0-2.4,0.8-2.8,2H8C4.7,2,2,4.7,2,8v18c0,3.3,2.7,6,6,6h16c3.3,0,6-2.7,6-6V8C30,4.7,27.3,2,24,2z M13,2h6c0.6,0,1,0.4,1,1v2c0,0.6-0.4,1-1,1h-6c-0.6,0-1-0.4-1-1V3C12,2.4,12.4,2,13,2z M28,26c0,2.2-1.8,4-4,4H8c-2.2,0-4-1.8-4-4V8c0-2.2,1.8-4,4-4h2v1c0,1.7,1.3,3,3,3h6c1.7,0,3-1.3,3-3V4h2c2.2,0,4,1.8,4,4V26z"></path></svg>
								<span>프로젝트 생성됨</span>
							</div>
							<div class="activityfeed_timeline_child02_version2">
								<span class="timeline_child02_version2_01">지숭</span> <span
									class="timeline_child02_version2_02">29일 전</span>
							</div>
							<div class="last_bottom_activityfeed_timeline"></div>
						</div>
					</div>
				</div>
			</div>

		</div>

	</div>
	<div class="darker_wallpapers" style="display: none;"></div>
	<div class="black_screen" style="display: none;"></div>
	<div class="add_member_content" style="display: none;">
		<div class="add_member_child01">
			<span>협업툴 개발(1) 공유</span>
			<div class="add_member_child01_icon">
				<svg class="Icon SettingsIcon" viewBox="0 0 32 32"
					aria-hidden="true" focusable="false">
					<path
						d="M25.999 3c-2.967 0-5.43 2.167-5.91 5H3a1 1 0 1 0 0 2h17.09c.478 2.833 2.942 5 5.91 5 3.309 0 6-2.691 6-6s-2.691-6-6-6Zm0 10c-2.206 0-4-1.794-4-4s1.794-4 4-4 4 1.794 4 4-1.794 4-4 4Zm-20 16c2.967 0 5.43-2.167 5.91-5h17.09a1 1 0 1 0 0-2h-17.09c-.478-2.833-2.942-5-5.91-5-3.309 0-6 2.691-6 6s2.691 6 6 6Zm0-10c2.206 0 4 1.794 4 4s-1.794 4-4 4-4-1.794-4-4 1.794-4 4-4Z"></path></svg>
				<svg class="Icon XIcon" viewBox="0 0 32 32" aria-hidden="true"
					focusable="false">
					<path
						d="M18.1,16L27,7.1c0.6-0.6,0.6-1.5,0-2.1s-1.5-0.6-2.1,0L16,13.9l-8.9-9C6.5,4.3,5.6,4.3,5,4.9S4.4,6.4,5,7l8.9,8.9L5,24.8c-0.6,0.6-0.6,1.5,0,2.1c0.3,0.3,0.7,0.4,1.1,0.4s0.8-0.1,1.1-0.4l8.9-8.9l8.9,8.9c0.3,0.3,0.7,0.4,1.1,0.4s0.8-0.1,1.1-0.4c0.6-0.6,0.6-1.5,0-2.1L18.1,16z"></path></svg>

			</div>
		</div>
		<div class="add_member_child02">
			<div class="add_member_child02_01">
				<span>이메일로 초대</span>
			</div>
			<div class="Parent_of_the_popup_manager">
				<div class="add_member_child02_02">
					<!-- input 구조 변경  --><!-- input 구조 변경  -->
					<div class="add_member_child_save_input_parent">
						<div class="add_member_child_save_span" idx="">
							<span>지숭</span>
							<svg class="HighlightSol HighlightSol--core CompoundIcon--small CompoundIcon XCircleCompoundIcon TokenRemoveButton-icon" viewBox="0 0 32 32" aria-hidden="true" focusable="false">
							<path d="M31,16c0,8.3-6.7,15-15,15S1,24.3,1,16S7.7,1,16,1S31,7.7,31,16z" class="CompoundIcon-outer"></path>
							<path d="M22.5,20.7c0.5,0.5,0.5,1.3,0,1.8c-0.2,0.2-0.5,0.4-0.9,0.4s-0.6-0.1-0.9-0.4L16,17.8l-4.7,4.7c-0.2,0.2-0.5,0.4-0.9,0.4s-0.6-0.1-0.9-0.4C9,22,9,21.2,9.5,20.7l4.7-4.7l-4.7-4.7C9,10.8,9,10,9.5,9.5c0.2-0.2,0.5-0.4,0.9-0.4s0.6,0.1,0.9,0.4l4.7,4.7l4.7-4.7c0.2-0.2,0.5-0.4,0.9-0.4s0.6,0.1,0.9,0.4c0.5,0.5,0.5,1.3,0,1.8L17.8,16L22.5,20.7z" class="CompoundIcon-inner"></path></svg>
						</div>
						<input placeholder="이름 또는 이메일로 멤버 추가 ..." name="nickName" value=""/>
					</div>
					<!-- input 구조 변경  --><!-- input 구조 변경  -->
					<div class="role_button_havingOn">
						<div class="role_button_projectManager on" idx="1">
							<span>프로젝트 관리자</span>
							<svg
								class="MiniIcon ButtonThemeablePresentation-rightIcon ArrowDownMiniIcon"
								viewBox="0 0 24 24" aria-hidden="true" focusable="false">
								<path
									d="m18.185 7.851-6.186 5.191-6.186-5.191a1.499 1.499 0 1 0-1.928 2.298l7.15 6a1.498 1.498 0 0 0 1.928 0l7.15-6a1.5 1.5 0 0 0-1.928-2.298Z"></path></svg>
						</div>
						<div class="role_button_editor" idx="2">
							<span>편집자</span>
							<svg
								class="MiniIcon ButtonThemeablePresentation-rightIcon ArrowDownMiniIcon"
								viewBox="0 0 24 24" aria-hidden="true" focusable="false">
								<path
									d="m18.185 7.851-6.186 5.191-6.186-5.191a1.499 1.499 0 1 0-1.928 2.298l7.15 6a1.498 1.498 0 0 0 1.928 0l7.15-6a1.5 1.5 0 0 0-1.928-2.298Z"></path></svg>
						</div>
						<div class="role_button_CommentManager" idx="3">
							<span>댓글 작성자</span>
							<svg
								class="MiniIcon ButtonThemeablePresentation-rightIcon ArrowDownMiniIcon"
								viewBox="0 0 24 24" aria-hidden="true" focusable="false">
								<path
									d="m18.185 7.851-6.186 5.191-6.186-5.191a1.499 1.499 0 1 0-1.928 2.298l7.15 6a1.498 1.498 0 0 0 1.928 0l7.15-6a1.5 1.5 0 0 0-1.928-2.298Z"></path></svg>
						</div>
					</div>
					

					<!-- 수정중  -->
					<!-- 수정중  -->
					<!-- 수정중  -->


					<div class="click_change_authority">
						<div class="click_change_authority_line projectmanager">
							<div class="click_change_authority_check_svg">
								<svg
									class="HighlightSol HighlightSol--core MiniIcon CheckMiniIcon"
									viewBox="0 0 24 24" aria-hidden="true" focusable="false">
									<path
										d="M19.439 5.439 8 16.878l-3.939-3.939A1.5 1.5 0 1 0 1.94 15.06l5 5c.293.293.677.439 1.061.439.384 0 .768-.146 1.061-.439l12.5-12.5a1.5 1.5 0 1 0-2.121-2.121h-.002Z"></path></svg>
							</div>
							<div class="click_change_authority_list">
								<span>프로젝트 관리자</span><br /> <span>설정을 변경하고 프로젝트를 수정하거나
									삭제를 할 수 있는 모든 액세스 권한 </span>
							</div>
						</div>
						<div class="click_change_authority_line editor">
							<div class="click_change_authority_check_svg">
								<svg
									class="HighlightSol HighlightSol--core MiniIcon CheckMiniIcon"
									viewBox="0 0 24 24" aria-hidden="true" focusable="false">
									<path
										d="M19.439 5.439 8 16.878l-3.939-3.939A1.5 1.5 0 1 0 1.94 15.06l5 5c.293.293.677.439 1.061.439.384 0 .768-.146 1.061-.439l12.5-12.5a1.5 1.5 0 1 0-2.121-2.121h-.002Z"></path></svg>
							</div>
							<div class="click_change_authority_list">
								<span>편집자</span><br /> <span>프로젝트에 있는 모든것을 추가 , 편집, 삭제 할
									수 있습니다. </span>
							</div>
						</div>
						<div class="click_change_authority_line CommentManager">
							<div class="click_change_authority_check_svg">
								<svg
									class="HighlightSol HighlightSol--core MiniIcon CheckMiniIcon"
									viewBox="0 0 24 24" aria-hidden="true" focusable="false">
									<path
										d="M19.439 5.439 8 16.878l-3.939-3.939A1.5 1.5 0 1 0 1.94 15.06l5 5c.293.293.677.439 1.061.439.384 0 .768-.146 1.061-.439l12.5-12.5a1.5 1.5 0 1 0-2.121-2.121h-.002Z"></path></svg>
							</div>
							<div class="click_change_authority_list">
								<span>댓글 작성자</span><br /> <span>댓글을 작성할 수 있지만 프로젝트에 있는
									내용은 편집할 수 없습니다. </span>
							</div>
						</div>
					</div>

					<button class="projectMemberInvite">초대</button>
				</div>
				<!-- 검색창 조회  --><!-- 검색창 조회  --><!-- 검색창 조회  -->
				<div class="member_search_box">
				<!-- 	<div class="member_search_box_list">
							<div class="member_search_box_img">
								<img src="img/짱구1.jpg"/>
							</div>
							<div class="member_search_box_text">
								<span>지숭</span><br/>
								<span>cba1008@naver.com</span>
							</div>
					</div>  -->
				</div> 
				<!-- 검색창 조회  --><!-- 검색창 조회  --><!-- 검색창 조회  -->
				
			</div>

			<div class="add_member_child02_03">
				<input type="checkbox" name="alarm" value="check" /> <span>프로젝트에
					작업이 초대될 때 알림</span>
			</div>
		</div>
		<div class="access_setting_scroll">
			<div class="add_member_child03">
				<div class="add_member_child03_01">
					<span>엑세스 설정</span>
				</div>
				<%-- <% 
				Access_settingAllDto access_settingAllDto = projectDao.getAccess_settingAllDao(projectIdx);
				int projectRange = access_settingAllDto.getRange(); 
				%> --%>
				<div class="add_member_child03_02 <%=projectRange==2 ? "on" : "" %>" >
					<div class="add_member_child03_02_left">
						<svg class="Icon PrivacyDropdown-buttonIcon LockIcon"
							viewBox="0 0 32 32" aria-hidden="true" focusable="false">
							<path
								d="M25.999 10h-2V8c0-4.411-3.589-8-8-8s-8 3.589-8 8v2h-2c-2.206 0-4 1.794-4 4v10c0 2.206 1.794 4 4 4h20c2.206 0 4-1.794 4-4V14c0-2.206-1.794-4-4-4Zm-16-2c0-3.309 2.691-6 6-6s6 2.691 6 6v2h-12V8Zm18 16c0 1.103-.897 2-2 2h-20c-1.103 0-2-.897-2-2V14c0-1.103.897-2 2-2h20c1.103 0 2 .897 2 2v10Z"></path></svg>
						<span>멤버들에게만 공개</span>
					</div>
					<div class="add_member_child03_02_right">
						<svg
							class="MiniIcon ButtonThemeablePresentation-rightIcon PrivacyDropdown-buttonRightIcon ArrowDownMiniIcon"
							viewBox="0 0 24 24" aria-hidden="true" focusable="false">
							<path
								d="m18.185 7.851-6.186 5.191-6.186-5.191a1.499 1.499 0 1 0-1.928 2.298l7.15 6a1.498 1.498 0 0 0 1.928 0l7.15-6a1.5 1.5 0 0 0-1.928-2.298Z"></path></svg>
					</div>
				</div> 
				<div class="add_member_child03_02 <%=projectRange==1 ? "on" : "" %>" >
					<div class="add_member_child03_02_left">
						<svg class="Icon PrivacyDropdown-optionIcon UsersIcon"
								viewBox="0 0 32 32" aria-hidden="true" focusable="false">
								<path
									d="M21,18c-4.411,0-8-3.589-8-8S16.589,2,21,2s8,3.589,8,8-3.589,8-8,8Zm0-14c-3.309,0-6,2.691-6,6s2.691,6,6,6,6-2.691,6-6-2.691-6-6-6Zm11,25v-2c0-3.86-3.141-7-7-7h-8c-3.859,0-7,3.14-7,7v2c0,.552,.447,1,1,1s1-.448,1-1v-2c0-2.757,2.243-5,5-5h8c2.757,0,5,2.243,5,5v2c0,.552,.447,1,1,1s1-.448,1-1ZM12,17c0-.552-.447-1-1-1-3.309,0-6-2.691-6-6s2.691-6,6-6c.553,0,1-.448,1-1s-.447-1-1-1C6.589,2,3,5.589,3,10s3.589,8,8,8c.553,0,1-.448,1-1ZM2,29v-2c0-2.757,2.243-5,5-5h2c.553,0,1-.448,1-1s-.447-1-1-1h-2C3.141,20,0,23.14,0,27v2C0,29.552,.447,30,1,30s1-.448,1-1Z"></path>
							</svg>
						<span>내 작업 공간</span>
					</div>
					<div class="add_member_child03_02_right">
						<svg
							class="MiniIcon ButtonThemeablePresentation-rightIcon PrivacyDropdown-buttonRightIcon ArrowDownMiniIcon"
							viewBox="0 0 24 24" aria-hidden="true" focusable="false">
							<path
								d="m18.185 7.851-6.186 5.191-6.186-5.191a1.499 1.499 0 1 0-1.928 2.298l7.15 6a1.498 1.498 0 0 0 1.928 0l7.15-6a1.5 1.5 0 0 0-1.928-2.298Z"></path></svg>
					</div>
				</div>
				<div class="access_setting_option">
					<div class="access_setting_option_member" idx="1">
						<div class="access_setting_option_member_left access_setting_02">
							<svg class="Icon PrivacyDropdown-optionIcon UsersIcon"
								viewBox="0 0 32 32" aria-hidden="true" focusable="false">
								<path
									d="M21,18c-4.411,0-8-3.589-8-8S16.589,2,21,2s8,3.589,8,8-3.589,8-8,8Zm0-14c-3.309,0-6,2.691-6,6s2.691,6,6,6,6-2.691,6-6-2.691-6-6-6Zm11,25v-2c0-3.86-3.141-7-7-7h-8c-3.859,0-7,3.14-7,7v2c0,.552,.447,1,1,1s1-.448,1-1v-2c0-2.757,2.243-5,5-5h8c2.757,0,5,2.243,5,5v2c0,.552,.447,1,1,1s1-.448,1-1ZM12,17c0-.552-.447-1-1-1-3.309,0-6-2.691-6-6s2.691-6,6-6c.553,0,1-.448,1-1s-.447-1-1-1C6.589,2,3,5.589,3,10s3.589,8,8,8c.553,0,1-.448,1-1ZM2,29v-2c0-2.757,2.243-5,5-5h2c.553,0,1-.448,1-1s-.447-1-1-1h-2C3.141,20,0,23.14,0,27v2C0,29.552,.447,30,1,30s1-.448,1-1Z"></path>
							</svg>
						</div>
						<div class="access_setting_option_member_right">
							<span class="access_setting_option_member_right01">내 작업 공간</span>
							<br /> <span class="access_setting_option_member_right02">작업
								공간의 모든 사용자가 이 프로젝트를 찾아 액세스할 수 있습니다.</span>
						</div>
					</div>
					<div class="access_setting_option_member" idx="2">
						<div class="access_setting_option_member_left">
							<svg class="Icon PrivacyDropdown-buttonIcon LockIcon"
								viewBox="0 0 32 32" aria-hidden="true" focusable="false">
								<path
									d="M25.999 10h-2V8c0-4.411-3.589-8-8-8s-8 3.589-8 8v2h-2c-2.206 0-4 1.794-4 4v10c0 2.206 1.794 4 4 4h20c2.206 0 4-1.794 4-4V14c0-2.206-1.794-4-4-4Zm-16-2c0-3.309 2.691-6 6-6s6 2.691 6 6v2h-12V8Zm18 16c0 1.103-.897 2-2 2h-20c-1.103 0-2-.897-2-2V14c0-1.103.897-2 2-2h20c1.103 0 2 .897 2 2v10Z"></path></svg>
						</div>
						<div class="access_setting_option_member_right">
							<span class="access_setting_option_member_right01">멤버들에게만
								공개</span> <br /> <span class="access_setting_option_member_right02">오직
								초대받은 멤버만 이 프로젝트를 찾아 엑세스할 수 있습니다.</span>
						</div>
					</div>
				</div>
			</div>
			<div class="add_member_child04">
				<span>멤버</span>
				<div class="add_member_child04_01">알림관리</div>
			</div>
			<div class="Parent_of_the_popup_manager">
				<div class="add_member_child05">
					<div class="icon_user_back">
						<svg class="Icon UsersIcon" viewBox="0 0 32 32"
							aria-labelledby="titlelui_1702" role="img" focusable="false">
							<title id="titlelui_1702">UsersIcon</title><path
								d="M21,18c-4.411,0-8-3.589-8-8S16.589,2,21,2s8,3.589,8,8-3.589,8-8,8Zm0-14c-3.309,0-6,2.691-6,6s2.691,6,6,6,6-2.691,6-6-2.691-6-6-6Zm11,25v-2c0-3.86-3.141-7-7-7h-8c-3.859,0-7,3.14-7,7v2c0,.552,.447,1,1,1s1-.448,1-1v-2c0-2.757,2.243-5,5-5h8c2.757,0,5,2.243,5,5v2c0,.552,.447,1,1,1s1-.448,1-1ZM12,17c0-.552-.447-1-1-1-3.309,0-6-2.691-6-6s2.691-6,6-6c.553,0,1-.448,1-1s-.447-1-1-1C6.589,2,3,5.589,3,10s3.589,8,8,8c.553,0,1-.448,1-1ZM2,29v-2c0-2.757,2.243-5,5-5h2c.553,0,1-.448,1-1s-.447-1-1-1h-2C3.141,20,0,23.14,0,27v2C0,29.552,.447,30,1,30s1-.448,1-1Z"></path></svg>
					</div>
					<span>작업의 협업 참여자</span>
					<!-- 숨겨진 div버튼들  -->
					<!-- 숨겨진 div버튼들  -->
					<div class="role_button_projectManager on" idx ="1">
						<span>프로젝트 관리자</span>
						<svg
							class="MiniIcon ButtonThemeablePresentation-rightIcon ArrowDownMiniIcon"
							viewBox="0 0 24 24" aria-hidden="true" focusable="false">
							<path
								d="m18.185 7.851-6.186 5.191-6.186-5.191a1.499 1.499 0 1 0-1.928 2.298l7.15 6a1.498 1.498 0 0 0 1.928 0l7.15-6a1.5 1.5 0 0 0-1.928-2.298Z"></path></svg>
					</div>
					<div class="role_button_editor" idx="2">
						<span>편집자</span>
						<svg
							class="MiniIcon ButtonThemeablePresentation-rightIcon ArrowDownMiniIcon"
							viewBox="0 0 24 24" aria-hidden="true" focusable="false">
							<path
								d="m18.185 7.851-6.186 5.191-6.186-5.191a1.499 1.499 0 1 0-1.928 2.298l7.15 6a1.498 1.498 0 0 0 1.928 0l7.15-6a1.5 1.5 0 0 0-1.928-2.298Z"></path></svg>
					</div>
					<div class="role_button_CommentManager" idx="3">
						<span>댓글 작성자</span>
						<svg
							class="MiniIcon ButtonThemeablePresentation-rightIcon ArrowDownMiniIcon"
							viewBox="0 0 24 24" aria-hidden="true" focusable="false">
							<path
								d="m18.185 7.851-6.186 5.191-6.186-5.191a1.499 1.499 0 1 0-1.928 2.298l7.15 6a1.498 1.498 0 0 0 1.928 0l7.15-6a1.5 1.5 0 0 0-1.928-2.298Z"></path></svg>
					</div>
					



					<!-- 숨겨진 div버튼들  -->
					<!-- 숨겨진 div버튼들  -->

					<!-- 수정중  -->
					<!-- 수정중  -->
					<!-- 수정중  -->
					<div class="click_change_authority_under">
						<div class="click_change_authority_list_under projectmanager">
							<div class="transparent_div"></div>
							<div class="click_change_authority_list_under_div">
								<span>프로젝트 관리자</span><br /> <span>설정을 변경하고 프로젝트를 수정하거나
									삭제를 할 수 있는 모든 액세스 권한 </span>
							</div>
						</div>
						<div class="click_change_authority_list_under editor">
							<div class="transparent_div"></div>
							<div class="click_change_authority_list_under_div">
								<span>편집자</span><br /> <span>프로젝트에 있는 모든것을 추가 , 편집, 삭제 할
									수 있습니다.</span>
							</div>
						</div>
						<div class="click_change_authority_list_under CommentManager">
							<div class="transparent_div"></div>
							<div class="click_change_authority_list_under_div">
								<span>댓글 작성자</span><br /> <span>댓글을 작성할 수 있지만 프로젝트에 있는
									내용은 편집할 수 없습니다.</span>
							</div>
						</div>
						<div class="click_change_authority_list_under Viewer">
							<div class="transparent_div"></div>
							<div class="click_change_authority_list_under_div">
								<span>조회자</span><br /> <span>볼 수는 있지만 댓글을 추가하거나 프로젝트를
									편집할 수는 없습니다.</span>
							</div>
						</div>
					</div>







					<!-- 수정중  -->
					<!-- 수정중  -->
					<!-- 수정중  -->
				</div>
			</div>
			<div class="parent_of_the_popup_manager_parent">
			<!-- 프로젝트 멤버 & 역할 조회  -->
			<!-- 프로젝트 멤버 & 역할 조회  -->
			<!-- 프로젝트 멤버 & 역할 조회  -->
			<script>
			let roleProjectManager = $(".role_button_projectManager").find("span").first().text();
			let roleEditor = $(".role_button_editor").find("span").first().text();
			let roleCommentManager = $(".role_button_CommentManager").find("span").first().text();
			</script>
			
			
			<%
			
			for (Project_participantsThingsDto dto : projectMemberList) {
				int participantsIdx = dto.getMember_idx(); //멤버 idx 
				MemberAllDto projectMemberAllDto = memberDao.getMemberAllDto(participantsIdx);
				
				String authorityName = dto.getAuthority_name();
				int authorityIdx = dto.getAuthority();
				
			%>
			<div class="Parent_of_the_popup_manager" memberidx="<%=participantsIdx%>">
				<div class="add_member_child06">
					<div class="add_member_child06_child_left">
						<img src="img/<%=projectMemberAllDto.getProfileImg()%>"></img>
					</div>
					<div class="add_member_child06_child_center">
						<span><%=projectMemberAllDto.getNickname()%></span> <br /> <span><%=projectMemberAllDto.getEmail()%></span>
					</div>
					<!-- 원래 데이터의 span 와 이름이 같을때 class 에 on 붙여주기  -->

					<div class="role_button_projectManager <%=authorityIdx==1 ? "on" : " " %>" idx="1">
						<span>프로젝트 관리자</span>
						<svg
							class="MiniIcon ButtonThemeablePresentation-rightIcon ArrowDownMiniIcon"
							viewBox="0 0 24 24" aria-hidden="true" focusable="false">
														<path
								d="m18.185 7.851-6.186 5.191-6.186-5.191a1.499 1.499 0 1 0-1.928 2.298l7.15 6a1.498 1.498 0 0 0 1.928 0l7.15-6a1.5 1.5 0 0 0-1.928-2.298Z"></path></svg>
					</div>
					<div class="role_button_editor <%=authorityIdx==2 ? "on" : " " %>" idx="2">
						<span>편집자</span>
						<svg
							class="MiniIcon ButtonThemeablePresentation-rightIcon ArrowDownMiniIcon"
							viewBox="0 0 24 24" aria-hidden="true" focusable="false">
														<path
								d="m18.185 7.851-6.186 5.191-6.186-5.191a1.499 1.499 0 1 0-1.928 2.298l7.15 6a1.498 1.498 0 0 0 1.928 0l7.15-6a1.5 1.5 0 0 0-1.928-2.298Z"></path></svg>
					</div>
					<div class="role_button_CommentManager <%=authorityIdx==3 ? "on" : " " %>" idx="3">
						<span>댓글 작성자</span>
						<svg
							class="MiniIcon ButtonThemeablePresentation-rightIcon ArrowDownMiniIcon"
							viewBox="0 0 24 24" aria-hidden="true" focusable="false">
														<path
								d="m18.185 7.851-6.186 5.191-6.186-5.191a1.499 1.499 0 1 0-1.928 2.298l7.15 6a1.498 1.498 0 0 0 1.928 0l7.15-6a1.5 1.5 0 0 0-1.928-2.298Z"></path></svg>
					</div>

					<div class="click_change_authority_under projectmanager">
						<div class="click_change_authority_list_under" idx="1">
							<div class="transparent_div"></div>
							<div class="click_change_authority_list_under_div">
								<span>프로젝트 관리자</span><br /> <span>설정을 변경하고 프로젝트를 수정하거나
									삭제를 할 수 있는 모든 액세스 권한 </span>
							</div>
						</div>
						<div class="click_change_authority_list_under editor" idx="2">
							<div class="transparent_div"></div>
							<div class="click_change_authority_list_under_div">
								<span>편집자</span><br /> <span>프로젝트에 있는 모든것을 추가 , 편집, 삭제 할
									수 있습니다.</span>
							</div>
						</div>
						<div class="click_change_authority_list_under CommentManager"
							idx="3">
							<div class="transparent_div"></div>
							<div class="click_change_authority_list_under_div">
								<span>댓글 작성자</span><br /> <span>댓글을 작성할 수 있지만 프로젝트에 있는
									내용은 편집할 수 없습니다.</span>
							</div>
						</div>
					</div>
				</div>
			</div>

			<%
			}
			%>
			</div>
			




<!-- 			
			<div class="Parent_of_the_popup_manager">
				<div class="add_member_child06">
					<div class="add_member_child06_child_left">
						<img src="img/철수.png"></img>
					</div>
					<div class="add_member_child06_child_center">
						<span>현우</span> <br /> <span>gusdntkd2@gmail.com</span>
					</div>
					<div class="role_button_editor on">
						<span>편집자</span>
						<svg
							class="MiniIcon ButtonThemeablePresentation-rightIcon ArrowDownMiniIcon"
							viewBox="0 0 24 24" aria-hidden="true" focusable="false">
							<path
								d="m18.185 7.851-6.186 5.191-6.186-5.191a1.499 1.499 0 1 0-1.928 2.298l7.15 6a1.498 1.498 0 0 0 1.928 0l7.15-6a1.5 1.5 0 0 0-1.928-2.298Z"></path></svg>
					</div>
					<div class="role_button_CommentManager">
						<span>댓글 작성자</span>
						<svg
							class="MiniIcon ButtonThemeablePresentation-rightIcon ArrowDownMiniIcon"
							viewBox="0 0 24 24" aria-hidden="true" focusable="false">
							<path
								d="m18.185 7.851-6.186 5.191-6.186-5.191a1.499 1.499 0 1 0-1.928 2.298l7.15 6a1.498 1.498 0 0 0 1.928 0l7.15-6a1.5 1.5 0 0 0-1.928-2.298Z"></path></svg>
					</div>
					<div class="role_button_Viewer">
						<span>조회자</span>
						<svg
							class="MiniIcon ButtonThemeablePresentation-rightIcon ArrowDownMiniIcon"
							viewBox="0 0 24 24" aria-hidden="true" focusable="false">
							<path
								d="m18.185 7.851-6.186 5.191-6.186-5.191a1.499 1.499 0 1 0-1.928 2.298l7.15 6a1.498 1.498 0 0 0 1.928 0l7.15-6a1.5 1.5 0 0 0-1.928-2.298Z"></path></svg>
					</div>

					<div class="click_change_authority_under">
						<div class="click_change_authority_list_under projectmanager">
							<div class="transparent_div"></div>
							<div class="click_change_authority_list_under_div">
								<span>프로젝트 관리자</span><br /> <span>설정을 변경하고 프로젝트를 수정하거나
									삭제를 할 수 있는 모든 액세스 권한 </span>
							</div>
						</div>
						<div class="click_change_authority_list_under editor">
							<div class="transparent_div"></div>
							<div class="click_change_authority_list_under_div">
								<span>편집자</span><br /> <span>프로젝트에 있는 모든것을 추가 , 편집, 삭제 할
									수 있습니다.</span>
							</div>
						</div>
						<div class="click_change_authority_list_under CommentManager">
							<div class="transparent_div"></div>
							<div class="click_change_authority_list_under_div">
								<span>댓글 작성자</span><br /> <span>댓글을 작성할 수 있지만 프로젝트에 있는
									내용은 편집할 수 없습니다.</span>
							</div>
						</div>
						<div class="click_change_authority_list_under Viewer">
							<div class="transparent_div"></div>
							<div class="click_change_authority_list_under_div">
								<span>조회자</span><br /> <span>볼 수는 있지만 댓글을 추가하거나 프로젝트를
									편집할 수는 없습니다.</span>
							</div>
						</div>
					</div>
				</div>
			</div> -->
		</div>
		<div class="add_member_child07">
			<div class="link_button">
				<svg
					class="MiniIcon ButtonThemeablePresentation-leftIcon LinkMiniIcon"
					viewBox="0 0 24 24" aria-hidden="true" focusable="false">
					<path
						d="M14.654 9.345a6.872 6.872 0 0 1 0 9.71L11.72 21.99a6.848 6.848 0 0 1-4.855 2.008 6.84 6.84 0 0 1-4.854-2.008 6.817 6.817 0 0 1-2.012-4.855c0-1.834.714-3.559 2.012-4.854l1.781-1.782a.999.999 0 1 1 1.414 1.414l-1.781 1.781A4.833 4.833 0 0 0 2 17.134c0 1.3.506 2.523 1.426 3.442A4.835 4.835 0 0 0 6.865 22a4.838 4.838 0 0 0 3.441-1.424l2.934-2.934a4.872 4.872 0 0 0-1.186-7.755 1 1 0 1 1 .928-1.773 6.862 6.862 0 0 1 1.672 1.231Zm-2.377-7.334L9.343 4.946a6.872 6.872 0 0 0 1.672 10.941 1 1 0 0 0 .928-1.772 4.872 4.872 0 0 1-1.186-7.755l2.934-2.933A4.836 4.836 0 0 1 17.132 2c1.3 0 2.521.506 3.44 1.425a4.833 4.833 0 0 1 1.426 3.44 4.833 4.833 0 0 1-1.426 3.441l-1.781 1.782a.999.999 0 1 0 1.414 1.415l1.781-1.782a6.817 6.817 0 0 0 2.012-4.855 6.816 6.816 0 0 0-2.012-4.856 6.873 6.873 0 0 0-9.709 0Z"></path></svg>
				<span>프로젝트 링크복사</span>
			</div>
		</div>
	</div>
	<div class="member_alarm_main">
		<div class="member_alarm_header">
			<span>멤버 알림 설정</span>
			<svg class="Icon XIcon" viewBox="0 0 32 32" aria-hidden="true"
				focusable="false">
				<path
					d="M18.1,16L27,7.1c0.6-0.6,0.6-1.5,0-2.1s-1.5-0.6-2.1,0L16,13.9l-8.9-9C6.5,4.3,5.6,4.3,5,4.9S4.4,6.4,5,7l8.9,8.9L5,24.8c-0.6,0.6-0.6,1.5,0,2.1c0.3,0.3,0.7,0.4,1.1,0.4s0.8-0.1,1.1-0.4l8.9-8.9l8.9,8.9c0.3,0.3,0.7,0.4,1.1,0.4s0.8-0.1,1.1-0.4c0.6-0.6,0.6-1.5,0-2.1L18.1,16z"></path></svg>
		</div>
		<div class="member_alarm_content">
			<div class="member_alarm_inventory">
				<span>상태 업데이트</span> <span>메시지</span> <span>작업 추가됨</span>
			</div>
			<div class="member_alarm_user">
				<span>내 알림</span>
			</div>
			<div class="member_alarm_user_check">
				<div class="member_alarm_user_check_01">
					<img src="img/짱구1.jpg"></img>
				</div>
				<div class="member_alarm_user_check_02">
					<span>지숭</span> <br /> <span>asanajisoo02@gmail.com</span>
				</div>
				<div class="member_alarm_user_check_03">
					<input type="checkbox" name="member_alarm_setting" value="status" />
					<input type="checkbox" name="member_alarm_setting" value="message" />
					<input type="checkbox" name="member_alarm_setting" value="work" />
				</div>
			</div>
			<div class="member_alarm_user second">
				<span>사용자</span>
			</div>
			<div class="member_alarm_user_check">
				<div class="member_alarm_user_check_01">
					<img src="img/짱구2.jpg"></img>
				</div>
				<div class="member_alarm_user_check_02">
					<span>길주</span> <br /> <span>wjdrlfwn217@gmail.com</span>
				</div>
				<div class="member_alarm_user_check_03">
					<input type="checkbox" name="member_alarm_setting" value="status" />
					<input type="checkbox" name="member_alarm_setting" value="message" />
					<input type="checkbox" name="member_alarm_setting" value="work" />
				</div>
			</div>
			<div class="member_alarm_user_check">
				<div class="member_alarm_user_check_01">
					<img src="img/철수.png"></img>
				</div>
				<div class="member_alarm_user_check_02">
					<span>현우</span> <br /> <span>hyunwooasana@gmail.com</span>
				</div>
				<div class="member_alarm_user_check_03">
					<input type="checkbox" name="member_alarm_setting" value="status" />
					<input type="checkbox" name="member_alarm_setting" value="message" />
					<input type="checkbox" name="member_alarm_setting" value="work" />
				</div>
			</div>
		</div>
	</div>

	<!-- 상태 업데이트  -->


	<div class="tatus_update_parent02" style="display: none">
		<div class="status_update_header">
			<span>${name}</span>
			<div class="status_update_header_right">
				<svg class="Icon_BellLineIcon" viewBox="0 0 32 32"
					aria-hidden="true" focusable="false">
					<path
						d="M11.608 28.804c-.248-.328-.004-.804.407-.804h7.969c.411 0 .655.476.407.804A5.51 5.51 0 0 1 15.999 31a5.51 5.51 0 0 1-4.392-2.196h.001ZM28 12.365v3.884c0 1.675.718 3.273 1.97 4.386 1.047.932 1.33 2.411.704 3.682C30.17 25.339 29.061 26 27.85 26H4.152c-1.211 0-2.32-.661-2.824-1.684-.626-1.271-.344-2.75.704-3.682a5.87 5.87 0 0 0 1.97-4.386v-4.249c0-3.247 1.276-6.288 3.593-8.563A11.893 11.893 0 0 1 16.224.002C22.717.121 28 5.667 28 12.365Zm-2 3.884v-3.884c0-5.615-4.402-10.264-9.812-10.363a9.93 9.93 0 0 0-7.194 2.862A9.926 9.926 0 0 0 6 12v4.249a7.872 7.872 0 0 1-2.641 5.881 1.081 1.081 0 0 0-.239 1.302c.167.34.582.568 1.03.568h23.698c.449 0 .863-.228 1.03-.567a1.081 1.081 0 0 0-.239-1.303 7.876 7.876 0 0 1-2.641-5.881H26Z"></path></svg>
				<select name="status_ud">
					<option value="none">상태 업데이트</option>
					<option value="status_name1">계획대로 진행 중</option>
					<option value="status_name2">위험</option>
					<option value="status_name3">계획에서 벗어남</option>
					<option value="status_name4">보류 중</option>
					<option value="status_name5">완료</option>
				</select>
				<svg class="Icon_XIcon" viewBox="0 0 32 32" aria-hidden="true"
					focusable="false">
					<path
						d="M18.1,16L27,7.1c0.6-0.6,0.6-1.5,0-2.1s-1.5-0.6-2.1,0L16,13.9l-8.9-9C6.5,4.3,5.6,4.3,5,4.9S4.4,6.4,5,7l8.9,8.9L5,24.8c-0.6,0.6-0.6,1.5,0,2.1c0.3,0.3,0.7,0.4,1.1,0.4s0.8-0.1,1.1-0.4l8.9-8.9l8.9,8.9c0.3,0.3,0.7,0.4,1.1,0.4s0.8-0.1,1.1-0.4c0.6-0.6,0.6-1.5,0-2.1L18.1,16z"></path></svg>
			</div>
		</div>

		<div class="status_update_content_modalwrapper">
			<!-- 프로젝트 상태 업데이트 목록 조회  -->
			<!-- 프로젝트 상태 업데이트 목록 조회  -->
			<!-- 프로젝트 상태 업데이트 목록 조회  -->
			<div class="status_update_content_left">
				<%
				for (ProjectStatusDto dto : projectStatusDtolist) {
					int projectstatusIdx = dto.getStatusIdx();
					String statusDate = dto.getStatusDate(); //포맷전 Date 
					SimpleDateFormat formatterDate10 = new SimpleDateFormat("yyyy-MM-dd"); //SimpleDateFormat 사용 
					SimpleDateFormat formatterDate11 = new SimpleDateFormat("MM월dd일");
					Date projectFormatDate = formatterDate10.parse(statusDate.split(" ")[0]);
					String projectFormatDatePost = formatterDate11.format(projectFormatDate); //포맷후 Date

					StatusAllDto projectStatusDto02 = statusGetAllDao.getStatusAllDto(projectstatusIdx);
					
				%>
				<div class="status_update_content_left_child"
					idx="<%=dto.getProjectStatusIdx()%>">
					<div class="status_update_content_left_child_01">
						<span class="span01">상태 업데이트 - </span> <span class="span01"><%=projectFormatDatePost%></span>
						<span class="span02"><%=projectFormatDatePost%></span>
					</div>
					<div class="status_update_content_left_child_02">
						<div class="status_update_name_second"
							style="background-color:<%=projectStatusDto02.getBackgroundColor()%>">
							<svg class="MiniIcon StatusDotFillMiniIcon" viewBox="0 0 24 24"
								aria-hidden="true" focusable="false"
								style="fill:<%=projectStatusDto02.getCircleColor()%>">
								<path
									d="m20,12c0,4.42-3.58,8-8,8s-8-3.58-8-8S7.58,4,12,4s8,3.58,8,8Z"></path></svg>
							<span style="color:<%=projectStatusDto02.getCharColor()%>"><%=projectStatusDto02.getName()%></span>
						</div>
					</div>
				</div>

				<%}%>


				<!-- <div class="status_update_content_left_child">
					<div class="status_update_content_left_child_01">
						<span class="span01">상태 업데이트 - </span> <span class="span01">10월
							28일</span> <span class="span02">10월 28일</span>
					</div>
					<div class="status_update_content_left_child_02">
						<div class="status_update_name">
							<svg class="MiniIcon StatusDotFillMiniIcon" viewBox="0 0 24 24"
								aria-hidden="true" focusable="false">
								<path
									d="m20,12c0,4.42-3.58,8-8,8s-8-3.58-8-8S7.58,4,12,4s8,3.58,8,8Z"></path></svg>
							<span>계획대로 진행 중</span>
						</div>
					</div>
				</div> -->
			</div>
			<!-- 프로젝트 상태 업데이트 목록 조회  -->
			<!-- 프로젝트 상태 업데이트 목록 조회  -->
			<!-- 프로젝트 상태 업데이트 목록 조회  -->
			<div class="status_update_content_right">
				<div class="status_update_content_right_main">
					<div class="status_update_content_right_child01">
						<div class="status_update_content_right_child01_title">
							<span>상태 업데이트 - </span> <span>10월 28일</span>
							<div class="status_update_content_right_icon_parent">
								<div class="status_update_content_right_icon">
									<svg class="Icon ExpandIcon" viewBox="0 0 32 32"
										aria-hidden="true" focusable="false">
										<path
											d="M13.7,19.7L5.4,28H13c0.6,0,1,0.4,1,1s-0.4,1-1,1H3c-0.6,0-1-0.4-1-1V19c0-0.6,0.4-1,1-1s1,0.4,1,1v7.6l8.3-8.3c0.4-0.4,1-0.4,1.4,0S14.1,19.3,13.7,19.7z M29,2H19c-0.6,0-1,0.4-1,1s0.4,1,1,1h7.6l-8.3,8.3c-0.4,0.4-0.4,1,0,1.4c0.2,0.2,0.5,0.3,0.7,0.3s0.5-0.1,0.7-0.3L28,5.4V13c0,0.6,0.4,1,1,1s1-0.4,1-1V3C30,2.4,29.6,2,29,2z"></path></svg>
									<svg
										class="Icon ButtonThemeablePresentation-rightIcon ThumbsUpLineIcon"
										viewBox="0 0 32 32" aria-hidden="true" focusable="false">
										<path
											d="M5 28h19.94a3.987 3.987 0 0 0 3.961-3.395l1.552-10.03a3.96 3.96 0 0 0-.909-3.187 3.962 3.962 0 0 0-3.01-1.384H20V4.006C20 2.045 18.71.469 16.785.084c-1.918-.383-3.723.573-4.477 2.383l-3.975 9.536H5c-1.654 0-3 1.345-3 2.999V25c0 1.654 1.346 3 3 3Zm5-14.8 4.154-9.969c.465-1.116 1.5-1.341 2.238-1.191.742.148 1.608.751 1.608 1.961V12h8.532c.574 0 1.118.25 1.492.687.374.437.54 1.012.451 1.58l-1.552 10.032A1.997 1.997 0 0 1 24.94 26H10V13.2H10ZM4 15c0-.551.448-1 1-1h3v12H5c-.552 0-1-.449-1-1V15Z"></path></svg>
									<svg class="Icon LinkIcon" viewBox="0 0 32 32"
										aria-hidden="true" focusable="false">
										<path
											d="M19.365 12.636a8.94 8.94 0 0 1 2.636 6.366 8.945 8.945 0 0 1-2.636 6.366l-4.001 4a8.976 8.976 0 0 1-6.366 2.634 8.976 8.976 0 0 1-6.366-2.634c-3.51-3.51-3.51-9.22 0-12.73l3.658-3.659a.999.999 0 1 1 1.414 1.415l-3.658 3.658a7.01 7.01 0 0 0 0 9.901c2.73 2.73 7.173 2.732 9.903 0l4.001-4a7.01 7.01 0 0 0 0-9.902 6.925 6.925 0 0 0-2.877-1.739 1 1 0 0 1 .592-1.91 9.019 9.019 0 0 1 3.699 2.235l.001-.002ZM29.368 2.633c-3.511-3.51-9.221-3.51-12.732 0l-4.001 4A8.94 8.94 0 0 0 9.999 13c0 2.405.936 4.665 2.636 6.367a9.019 9.019 0 0 0 3.699 2.235 1.001 1.001 0 0 0 .592-1.911 6.925 6.925 0 0 1-2.877-1.738 7.01 7.01 0 0 1 0-9.903l4.001-4c2.731-2.73 7.174-2.73 9.903 0 2.729 2.728 2.73 7.171 0 9.902l-3.658 3.657a.999.999 0 1 0 1.414 1.415l3.658-3.659c3.51-3.51 3.51-9.22 0-12.73l.001-.002Z"></path></svg>
									<svg class="Icon MoreIcon" viewBox="0 0 32 32"
										aria-hidden="true" focusable="false">
										<path
											d="M16,13c1.7,0,3,1.3,3,3s-1.3,3-3,3s-3-1.3-3-3S14.3,13,16,13z M3,13c1.7,0,3,1.3,3,3s-1.3,3-3,3s-3-1.3-3-3S1.3,13,3,13z M29,13c1.7,0,3,1.3,3,3s-1.3,3-3,3s-3-1.3-3-3S27.3,13,29,13z"></path></svg>
								</div>
								<div class="showMoreButton">
									<span>삭제</span>
								</div>
							</div>
						</div>
					</div>
					<div class="status_update_content_right_child02">
						<img src="img/짱구1.jpg"></img>
						<div class="status_update_content_right_child02_text">
							<span class="status_update_content_right_text01">지숭</span> <span
								class="status_update_content_right_text02">27일 전</span>
						</div>
					</div>
					<div class="status_update_content_right_child03">
						<span class="status_update_content_right_name">상태</span>
						<div class="status_update_name">
							<span>계획대로 진행 중</span>
						</div>
					</div>
					<div class="status_update_content_right_child04">
						<span class="status_update_content_right_name">소유자</span> <span
							class="status_update_content_right_name02">지숭</span>
					</div>
				</div>
				<div class="status_update_content_comment_main">
					<div class="status_update_content_comment_parent01">
						<div class="status_update_content_comment_parent01_child01">
							<img src="img/짱구1.jpg"></img>
						</div>
						<div class="status_update_content_comment_parent01_child02">
							<textarea placeholder="메세지에 답장하기 ..."></textarea>
						</div>
					</div>
					<div class="status_update_content_comment_parent02">
						<div class="status_update_content_comment_parent02_child01">
							<span>협업 참여자</span>
						</div>
						<div class="status_update_content_comment_parent02_child02">
							<div>
								<img src="img/짱구1.jpg"></img>
							</div>
							<div class="add_participant">
								<svg class="MiniIcon UserMiniIcon" viewBox="0 0 24 24"
									aria-hidden="true" focusable="false">
									<path
										d="M12,14c-3.859,0-7-3.14-7-7S8.141,0,12,0s7,3.14,7,7-3.141,7-7,7Zm0-12c-2.757,0-5,2.243-5,5s2.243,5,5,5,5-2.243,5-5-2.243-5-5-5Zm10,21v-2c0-2.757-2.243-5-5-5H7c-2.757,0-5,2.243-5,5v2c0,.552,.447,1,1,1s1-.448,1-1v-2c0-1.654,1.346-3,3-3h10c1.654,0,3,1.346,3,3v2c0,.552,.447,1,1,1s1-.448,1-1Z"></path></svg>
							</div>
							<div class="add_participant">
								<svg class="MiniIcon UserMiniIcon" viewBox="0 0 24 24"
									aria-hidden="true" focusable="false">
									<path
										d="M12,14c-3.859,0-7-3.14-7-7S8.141,0,12,0s7,3.14,7,7-3.141,7-7,7Zm0-12c-2.757,0-5,2.243-5,5s2.243,5,5,5,5-2.243,5-5-2.243-5-5-5Zm10,21v-2c0-2.757-2.243-5-5-5H7c-2.757,0-5,2.243-5,5v2c0,.552,.447,1,1,1s1-.448,1-1v-2c0-1.654,1.346-3,3-3h10c1.654,0,3,1.346,3,3v2c0,.552,.447,1,1,1s1-.448,1-1Z"></path></svg>
							</div>
							<div>
								<svg class="miniIcon_small" viewBox="0 0 24 24"
									aria-hidden="true" focusable="false">
									<path
										d="M10,10V4c0-1.1,0.9-2,2-2s2,0.9,2,2v6h6c1.1,0,2,0.9,2,2s-0.9,2-2,2h-6v6c0,1.1-0.9,2-2,2s-2-0.9-2-2v-6H4c-1.1,0-2-0.9-2-2s0.9-2,2-2H10z"></path></svg>
							</div>
						</div>
						<div class="status_update_content_comment_parent02_child03">
							<svg
								class="Icon--small Icon ButtonThemeablePresentation-leftIcon BellIcon"
								viewBox="0 0 32 32" aria-hidden="true" focusable="false">
								<path
									d="M2.03 20.635A5.87 5.87 0 0 0 4 16.249V12c0-3.247 1.276-6.288 3.593-8.563C9.909 1.164 12.962-.064 16.224.002 22.717.121 28 5.667 28 12.365v3.884c0 1.675.718 3.273 1.97 4.386 1.047.932 1.33 2.411.704 3.682C30.17 25.339 29.061 26 27.85 26H4.152c-1.211 0-2.32-.661-2.824-1.684-.626-1.271-.344-2.75.704-3.682l-.002.001ZM16 31a5.51 5.51 0 0 0 4.392-2.196c.248-.328.004-.804-.407-.804h-7.969c-.411 0-.655.476-.407.804A5.508 5.508 0 0 0 16 31Z"></path></svg>
							<span>나가기</span>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

</body>
</html>