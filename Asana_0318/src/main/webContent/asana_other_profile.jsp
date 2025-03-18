<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="dto.WamDto"%>
<%@page import="dto.ProjectParticipantsDto"%>
<%@page import="dao.WamDao"%>
<%@page import="dto.PortfolioDto"%>
<%@page import="dao.PortfolioDao"%>
<%@page import="dto.MemberDto"%>
<%@page import="dao.MyWorkspaceDao"%>
<%@page import="dto.ProjectDto"%>
<%@page import="java.util.ArrayList"%>
<%@page import="dao.ProjectDao"%>
<%@page import="dao.MemberDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	ProjectDao pDao = (ProjectDao)request.getAttribute("pDao");
	String myProfile = (String)request.getAttribute("myProfile");
	int alarm = (Integer)request.getAttribute("alarm");
	String memberStartDate = (String)request.getAttribute("memberStartDate");
	String memberDeadDate = (String)request.getAttribute("memberDeadDate");
	int pDtoFavoritesListLength = (Integer)request.getAttribute("pDtoFavoritesListLength");
	int favoritesWorkspaceCount = (Integer)request.getAttribute("favoritesWorkspaceCount");
	ArrayList<ProjectDto> pDtoFavoritesList = (ArrayList<ProjectDto>)request.getAttribute("pDtoFavoritesList");
	int isFavoritesMember = (Integer)request.getAttribute("isFavoritesMember");
	ArrayList<PortfolioDto> portfolioList = (ArrayList<PortfolioDto>)request.getAttribute("portfolioList");
	ArrayList<ProjectDto> pDtoList = (ArrayList<ProjectDto>)request.getAttribute("pDtoList");
	ArrayList<ProjectDto> pDtoListByLoginMemberAndOtherMember = (ArrayList<ProjectDto>)request.getAttribute("pDtoListByLoginMemberAndOtherMember");
	ArrayList<MemberDto> mDaoFavoritesList = (ArrayList<MemberDto>)request.getAttribute("mDaoFavoritesList");
	ArrayList<WamDto> wamListByLoginMemberAssignsToOtherMember = (ArrayList<WamDto>)request.getAttribute("wamListByLoginMemberAssignsToOtherMember");
	ArrayList<WamDto> getTogetherWamsDto = (ArrayList<WamDto>)request.getAttribute("getTogetherWamsDto");
	ArrayList<WamDto> getAllWamListByLoginMemberAndOtherMember = (ArrayList<WamDto>)request.getAttribute("getAllWamListByLoginMemberAndOtherMember");
	// 현재 시간 가져오기
    LocalDateTime now = LocalDateTime.now();
    // 포맷 지정 (예: yyyy-MM-dd HH:mm:ss)
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    String formattedNow = now.format(formatter);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>페이지 - 타인 프로필</title>
<link rel="stylesheet" href="css/Main_Common.css" />
<link rel="stylesheet" href="css/asana_other_profile.css" />
<script src="js/jquery-3.7.1.min.js"></script>
<script>
	$(function() {
		/************************* wam 마감일이 현재날짜보다 이전이면 빨간글씨, 이후면 검정글씨 ****************************/
		// 현재 시간 (Java에서 전달된 현재 날짜)
        let nowTime = new Date("<%=formattedNow%>");
        // 각 작업의 데드라인을 확인하여 색상 변경
        $(".under-content").each(function() {
            let deadlineText = $(this).find(".date span").text().trim(); // YY년MM월DD일 형식의 데드라인 텍스트
            let deadlineDate = parseDate(deadlineText); // 데드라인 텍스트를 Date 객체로 변환

            if (deadlineDate < nowTime) {
                // 데드라인이 현재 시간보다 이전 -> 빨간색
                $(this).find(".date span").addClass("wam_red_text").removeClass("wam_normal_text");
            } else {
                // 데드라인이 현재 시간 이후 -> 검정색
                $(this).find(".date span").addClass("wam_normal_text").removeClass("wam_red_text");
            }
        });
        // YY년MM월DD일 형식을 Date 객체로 변환하는 함수
        function parseDate(dateStr) {
            let year = parseInt(dateStr.substring(0, 2)) + 2000; // YY -> YYYY
            let month = parseInt(dateStr.substring(3, 5)) - 1; // 월 (0부터 시작)
            let day = parseInt(dateStr.substring(6, 8)); // 일
            return new Date(year, month, day);
        }
        /************************* wam 마감일이 현재날짜보다 이전이면 빨간글씨, 이후면 검정글씨 ****************************/
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
			let memberIdx = ${loginMemberIdx};
				//$(this).closest(".profile_setting_background").attr("member_idx");
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
			let memberIdx = ${loginMemberIdx};
				//$(this).closest(".profile_setting_background").attr("member_idx");
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
		/* 작업체크동그라미 클릭시 */
		$(".profile_page_work_check").click(function() {
	         $(this).toggleClass("on");
	         $(this).children().toggleClass("on");
	         event.stopPropagation();
	      });

		/* 타인 프로필 페이지 작업 배정 클릭시 */
		$(".center-text").click(function(){
			alert("!");
		});
		/* 타인프로필 페이지 작업목록 div 에 모든 작업 보기 클릭시 */
		$(".my-work-button").click(function(){
			alert("!");
		});
		/******************************** 메시지 팝업창 ***************************************/
		$(".message-box").click(function(){
			$(this).removeClass("on");
			alert("!");
		});
		/******************************** 메시지 팝업창 ***************************************/
		/**************************************** 승인 팝업창 *********************************/
		/* 승인로고 클릭시  */
		$(".icon17").click(function() {
			$(".approve-check").toggleClass('on');
			event.stopPropagation();
		});
		/* 승인 팝업창 요소 클릭시 */
		$(".approve-check-in").click(function(){
			let name = $(this).text().trim();
			/* 체크아이콘 켜져있는거 제거 후 */
			$(".check-icon.on").removeClass("on");
			/* 클릭한 요소에 체크아이콘 표시 */
			$(this).find(".check-icon").addClass("on");
			if(name==="승인 보류 중"){
				/* $(this).parent().prev().children().find*/
				$(".icon17").css({"display":"block", "margin-right":"5px"});
				$(".icon17.approve-green").css({"display":"none", "margin-right":"5px"});
				$(".icon17.approve-yellow").css({"display":"none", "margin-right":"5px"});
				$(".icon17.approve-red").css({"display":"none", "margin-right":"5px"});
				$(".approve-check").removeClass('on');
			}else if(name==="승인됨"){
				$(".icon17").css('display','none');
				$(".icon17.approve-green").css({"display":"block", "margin-right":"5px"});
				$(".icon17.approve-yellow").css({"display":"none", "margin-right":"5px"});
				$(".icon17.approve-red").css({"display":"none", "margin-right":"5px"});
				$(".approve-check").removeClass('on');
			}else if(name==="변경 요청됨"){
				$(".icon17").css('display','none');
				$(".icon17.approve-green").css({"display":"none", "margin-right":"5px"});
				$(".icon17.approve-yellow").css({"display":"block", "margin-right":"5px"});
				$(".icon17.approve-red").css({"display":"none", "margin-right":"5px"});
				$(".approve-check").removeClass('on');
			}else if(name==="거부됨"){
				$(".icon17").css('display','none');
				$(".icon17.approve-green").css({"display":"none", "margin-right":"5px"});
				$(".icon17.approve-yellow").css({"display":"none", "margin-right":"5px"});
				$(".icon17.approve-red").css({"display":"block", "margin-right":"5px"});
				$(".approve-check").removeClass('on');
			}
		});
		/**************************************** 승인 팝업창 *********************************/
		/* 타인프로필페이지 작업박스에 작업리스트 요소 클릭시 */
		$(".under-content").click(function(){
			let wamIdx = $(this).attr("wam_idx");
			alert("wamIdx : " + wamIdx);
		});
		 /* class="bottom_content_project_name" */
		 /* 타인 프로필 페이지 내가 참여 하고 있는 프로젝트에서 요소 클릭시 */
		 $(".bottom-content").click(function(){
			 let projectIdx = $(this).attr("project_idx");
			 location.href="Controller?command=main_inventory&member_idx=${loginMemberIdx}&project_idx="+projectIdx;
		 });
		/************************** 사이드바 프로젝트 "+" 팝업, 열고닫기 ****************************/
		/* 사이드바 프로젝트 + 클릭시 */
		$(".PlusMiniIcon").click(function(){
			$(".sidebar_project_plus_popup").toggleClass("on");
		});
		/* 새 프로젝트 클릭 */
		$(".sidebar_create_project").click(function(){
			let loginMemberIdx = ${loginMemberIdx};
			alert("프로젝트 생성 이동, 로그인멤버 : " + loginMemberIdx);
			location.href="Controller?command=create_project&member_idx=${loginMemberIdx}";
		});
		/* 새 포트폴리오 클릭 */
		$(".sidebar_create_portfolio").click(function(){
			//location.href="Controller?command=create_portfolio&member_idx${loginMemberIdx}";
		});
		/* 사이드바 숨기고 열기 */
		$("#menu_button").click(function() {
			if( $("#sidebar").css('left')!='0px' ) {
				$("#sidebar").animate({left: 0}, 500);
			} else {
				$("#sidebar").animate({left: '-300px'}, 500);
			}
		});
		
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
		/************************** 사이드바 프로젝트 "+" 팝업, 열고닫기 ****************************/
		/* 마우스 대면 별 테두리 켜짐 */
		$(".star-center").hover(function() {
			$(".icon20-star").css('fill', '#fcbd01')
		});
		/* 마우스 나가면 별 테두리 꺼짐 */
		$(".star-center").mouseleave(function() {
			$(".icon20-star").css('fill', 'gray')
		});
		/* 별 클릭시 온오프스위칭 *//* 별 클릭시 온오프스위칭 *//* 별 클릭시 온오프스위칭 *//* 별 클릭시 온오프스위칭 *//* 별 클릭시 온오프스위칭 *//* 별 클릭시 온오프스위칭 *//* 별 클릭시 온오프스위칭 *//* 별 클릭시 온오프스위칭 *//* 별 클릭시 온오프스위칭 */
		$(".star-center").click(function() {
			let loginMemberIdx = ${loginMemberIdx};
			let memberIdx = ${memberIdx};
			let profileImg = $(".Profile-img").attr("src");
			let nickname = $(this).prev().text().trim();
			
			if($(this).hasClass("on")) {
				$(this).removeClass("on");
				$(".sidebar_item.ajax.member_idx_"+memberIdx).remove(); // 내작업공간 div 가 아닌 프로필이미지/닉네임 div
			 	$.ajax({
					type:'post',
					data:{'loginMemberIdx':loginMemberIdx,
							'memberIdx':memberIdx},
					url:'RemoveFavoritesMemberServlet', // 내작업공간 div 가 아닌 프로필이미지/닉네임 div servlet
					success:function(data){
						/* if(data.cnt==0){
							$(".category.ajax").hide();   // hide();
						}else {
							$(".category.ajax").show();
						} */
					},
					error:function(r,s,e){
						alert(error);
					}
				}); 
			} else {
				$(this).addClass("on");
				$.ajax({
					type:'post',
					data:{'loginMemberIdx':loginMemberIdx,
							'memberIdx':memberIdx},
					url:'AddFavoritesMemberServlet', // 내작업공간 div 가 아닌 프로필이미지/닉네임 div servlet
					success:function(data){
						$(".category.ajax").show();   //show();
						//$("").show(); // 내작업공간 div 가 아닌 프로필이미지/닉네임 div
						let str = 	`<div class="sidebar_item ajax member_idx_` + memberIdx + `" member_idx="` + memberIdx + `">
										<img class="img_small_favorites" src="` + data.profileImg + `">
										<span class="ajax_dtos_project_favorites_name">` + nickname + `</span>
									</div>`; // 내작업공간 div 가 아닌 프로필이미지/닉네임 div
						$(".category.with_plus").before(str); 
					},
					error:function(r,s,e){
						alert(error);
					}
				}); 
			}
		});
		/* 별 클릭시 온오프스위칭 *//* 별 클릭시 온오프스위칭 *//* 별 클릭시 온오프스위칭 *//* 별 클릭시 온오프스위칭 *//* 별 클릭시 온오프스위칭 *//* 별 클릭시 온오프스위칭 */
		
		/* 작업배정 옆에 하향화살표(?) 클릭시 메시지 전송 팝업창 on */
		$(".center-more").click(function() {
			$(".message-box").toggleClass('on');
		});
		/* 타인프로필 페이지 작업박스 분류 3가지중 하나 클릭시 */
		$(".gray-font14").click(function() {
			/* 작업리스트 제목 3개 일단 다 on 클래스 제거 */
			$(".gray-font14.on").removeClass('on');
			/* 작업리스트 제목 클릭한 요소만 on 클래스 추가 */
			$(this).addClass('on');
			/* 내작업리스트 내용 div 3개 다 먼저 on 클래스 제거*/
			$(".under-under.on").removeClass('on');
			/* 1번째 제목이 on 이면 1번째 내용 on  */
			if ($(".gray-font14.on").index() == 0) {
				$(".under-under").eq(0).addClass('on');
			/* 2번째 제목이 on 이면 2번째 내용 on  */
			} else if ($(".gray-font14.on").index() == 1) {
				$(".under-under").eq(1).addClass('on');
			/* 3번째 제목이 on 이면 3번째 내용 on  */
			} else if ($(".gray-font14.on").index() == 2) {
				$(".under-under").eq(2).addClass('on');
			}
		});
		$(".CreateButton").click(function() {
			location.href="Controller?command=create_project&member_idx=${loginMemberIdx}";
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
			//location.href="Controller?command=create_portfolio&member_idx=${loginMemberIdx}";
		});
		
	});
</script>
</head>
<body>
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
						<%
						if(myProfile == null){
						%>
						<div class="profile_setting_picture">
							<img src="img/Unknown.png"/>
						</div>
						<%
						}else{
						%>
						<div class="profile_setting_picture">
							<img id="profileImage" src="img/${myProfile}"/>
						</div>
						<%
						}
						%>
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
								<input type="checkbox" class="toggle_input" id="toggle" <%=alarm == 1 ? "checked" : ""%>/>
								<label class="toggle_label" for="toggle"></label>
							</div>
							<div class="toggle_span">
								<span>부재중으로 설정</span>
							</div>
							</div>
							<div class="toggle_click_view <%=alarm == 1 ? "on" : ""%>">
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
										 <input type="date" id="start_date" name="start_date" value="<%=memberStartDate.split(" ")[0]%>" />
										</div>
									<div class="toggle_deadline_box">
										<!-- 종료일 날짜 -->
										 <input type="date" id="end_date" name="end_date" data-placeholder="날짜를 선택하세요"  value="<%=memberDeadDate.split(" ")[0]%>"/>
									</div>
									<!-- <div class="deadline_red_span">
										<span>휴가는 오늘보다 이전에 끝날 수</span><br/>
										<span>없습니다.</span>
									</div> -->
									
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
	                                    <span>${myNickname}</span>
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
	<!--------------------- 사이드바 프로젝트 "+" 팝업창 --------------------->
	<div class="sidebar_project_plus_popup">
		<div class="sidebar_create_project">
			<svg class="sidebar_create_project_logo" viewBox="0 0 32 32" aria-hidden="true" focusable="false">
				<path d="M10,13.5c0.8,0,1.5,0.7,1.5,1.5s-0.7,1.5-1.5,1.5S8.5,15.8,8.5,15S9.2,13.5,10,13.5z M23,14h-8c-0.6,0-1,0.4-1,1s0.4,1,1,1h8c0.6,0,1-0.4,1-1S23.6,14,23,14z M23,20h-8c-0.6,0-1,0.4-1,1s0.4,1,1,1h8c0.6,0,1-0.4,1-1S23.6,20,23,20z M10,19.5c0.8,0,1.5,0.7,1.5,1.5s-0.7,1.5-1.5,1.5S8.5,21.8,8.5,21S9.2,19.5,10,19.5z M24,2h-2.2c-0.4-1.2-1.5-2-2.8-2h-6c-1.3,0-2.4,0.8-2.8,2H8C4.7,2,2,4.7,2,8v18c0,3.3,2.7,6,6,6h16c3.3,0,6-2.7,6-6V8C30,4.7,27.3,2,24,2z M13,2h6c0.6,0,1,0.4,1,1v2c0,0.6-0.4,1-1,1h-6c-0.6,0-1-0.4-1-1V3C12,2.4,12.4,2,13,2z M28,26c0,2.2-1.8,4-4,4H8c-2.2,0-4-1.8-4-4V8c0-2.2,1.8-4,4-4h2v1c0,1.7,1.3,3,3,3h6c1.7,0,3-1.3,3-3V4h2c2.2,0,4,1.8,4,4V26z"></path></svg>
			새 프로젝트
		</div>
		<div class="sidebar_create_portfolio">
			<svg class="sidebar_create_portfolio_logo" viewBox="0 0 32 32" aria-hidden="true" focusable="false">
				<path d="M29 8C30.6569 8 32 9.34315 32 11V25C32 27.7614 29.7614 30 27 30H5C2.23858 30 0 27.7614 0 25V5C0 3.34315 1.34315 2 3 2H12.2C12.5693 2 12.9086 2.20355 13.0824 2.52941L15.1529 6.41177C15.6743 7.38936 16.6921 8 17.8 8H29ZM30 11V25C30 26.6569 28.6569 28 27 28H5C3.34315 28 2 26.6569 2 25V10H29C29.5523 10 30 10.4477 30 11ZM13.7999 8C13.6477 7.79704 13.5099 7.58098 13.3882 7.35294L11.6 4H3C2.44772 4 2 4.44772 2 5V8H13.7999Z"></path></svg>
			새 포트폴리오
		</div>
	</div>
	<!--------------------- 사이드바 프로젝트 "+" 팝업창 --------------------->
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

	<!----------------------- 상단바 생성리스트 팝업창----------------------------------------->
	<div class="create_something_popup">
		<div class="popup_create_work">
			<svg class="topbar_popup_approve" viewBox="0 0 32 32"
				aria-hidden="true" focusable="false">
				<path
					d="M29.1,20.9 M16,32C7.2,32,0,24.8,0,16S7.2,0,16,0s16,7.2,16,16S24.8,32,16,32z M16,2C8.3,2,2,8.3,2,16s6.3,14,14,14s14-6.3,14-14S23.7,2,16,2z M12.9,22.6c-0.3,0-0.5-0.1-0.7-0.3l-3.9-3.9C8,18,8,17.4,8.3,17s1-0.4,1.4,0l3.1,3.1l8.6-8.6c0.4-0.4,1-0.4,1.4,0s0.4,1,0,1.4l-9.4,9.4C13.4,22.5,13.2,22.6,12.9,22.6z"></path></svg>
			작업
		</div>
		<div class="popup_create_project">
			<svg class="topbar_popup_project" viewBox="0 0 32 32"
				aria-hidden="true" focusable="false">
				<path
					d="M10,13.5c0.8,0,1.5,0.7,1.5,1.5s-0.7,1.5-1.5,1.5S8.5,15.8,8.5,15S9.2,13.5,10,13.5z M23,14h-8c-0.6,0-1,0.4-1,1s0.4,1,1,1h8c0.6,0,1-0.4,1-1S23.6,14,23,14z M23,20h-8c-0.6,0-1,0.4-1,1s0.4,1,1,1h8c0.6,0,1-0.4,1-1S23.6,20,23,20z M10,19.5c0.8,0,1.5,0.7,1.5,1.5s-0.7,1.5-1.5,1.5S8.5,21.8,8.5,21S9.2,19.5,10,19.5z M24,2h-2.2c-0.4-1.2-1.5-2-2.8-2h-6c-1.3,0-2.4,0.8-2.8,2H8C4.7,2,2,4.7,2,8v18c0,3.3,2.7,6,6,6h16c3.3,0,6-2.7,6-6V8C30,4.7,27.3,2,24,2z M13,2h6c0.6,0,1,0.4,1,1v2c0,0.6-0.4,1-1,1h-6c-0.6,0-1-0.4-1-1V3C12,2.4,12.4,2,13,2z M28,26c0,2.2-1.8,4-4,4H8c-2.2,0-4-1.8-4-4V8c0-2.2,1.8-4,4-4h2v1c0,1.7,1.3,3,3,3h6c1.7,0,3-1.3,3-3V4h2c2.2,0,4,1.8,4,4V26z"></path></svg>
			프로젝트
		</div>
		<div class="popup_create_message">
			<svg class="topbar_popup_message" viewBox="0 0 32 32"
				aria-hidden="true" focusable="false">
				<path
					d="M20 2h-8C5.383 2 0 7.383 0 14v2c0 3.103 1.239 6.1 3.424 8.342l.586 5.857a1.999 1.999 0 0 0 3.247 1.357L11.662 28h8.339c6.617 0 12-5.383 12-12v-2c0-6.617-5.384-12-12.001-12Zm-9.045 24L6 30l-.659-6.589C3.305 21.58 2 18.953 2 16v-2C2 8.477 6.477 4 12 4h8c5.523 0 10 4.477 10 10v2c0 5.523-4.477 10-10 10h-9.045Z"></path></svg>
			메시지
		</div>
		<div class="popup_create_portfolio">
			<svg class="topbar_popup_portfolio" viewBox="0 0 32 32"
				aria-hidden="true" focusable="false">
				<path
					d="M29 8C30.6569 8 32 9.34315 32 11V25C32 27.7614 29.7614 30 27 30H5C2.23858 30 0 27.7614 0 25V5C0 3.34315 1.34315 2 3 2H12.2C12.5693 2 12.9086 2.20355 13.0824 2.52941L15.1529 6.41177C15.6743 7.38936 16.6921 8 17.8 8H29ZM30 11V25C30 26.6569 28.6569 28 27 28H5C3.34315 28 2 26.6569 2 25V10H29C29.5523 10 30 10.4477 30 11ZM13.7999 8C13.6477 7.79704 13.5099 7.58098 13.3882 7.35294L11.6 4H3C2.44772 4 2 4.44772 2 5V8H13.7999Z"></path></svg>
			포트폴리오
		</div>
		<div class="popup_create_invite">
			<svg class="topbar_popup_invite" viewBox="0 0 32 32"
				aria-hidden="true" focusable="false">
				<path
					d="M31,26h-3v-3c0-0.6-0.4-1-1-1s-1,0.4-1,1v3h-3c-0.6,0-1,0.4-1,1s0.4,1,1,1h3v3c0,0.6,0.4,1,1,1s1-0.4,1-1v-3h3c0.6,0,1-0.4,1-1S31.6,26,31,26z M16,18c4.4,0,8-3.6,8-8s-3.6-8-8-8s-8,3.6-8,8S11.6,18,16,18z M16,4c3.3,0,6,2.7,6,6s-2.7,6-6,6s-6-2.7-6-6S12.7,4,16,4z M21.2,20H8.8C5,20,2,23,2,26.8V31c0,0.6,0.4,1,1,1s1-0.4,1-1v-4.2C4,24.2,6.2,22,8.8,22h12.4c0.6,0,1-0.4,1-1S21.8,20,21.2,20z"></path></svg>
			초대
		</div>
	</div>
	<!----------------------- 상단바 생성리스트 팝업창----------------------------------------->
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
			<img class="profile-img" src="img/${loginProfileImg}"/>
		</div>
		<svg class="MiniIcon ArrowDownMiniIcon" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
			<path d="m18.185 7.851-6.186 5.191-6.186-5.191a1.499 1.499 0 1 0-1.928 2.298l7.15 6a1.498 1.498 0 0 0 1.928 0l7.15-6a1.5 1.5 0 0 0-1.928-2.298Z"></path></svg>
	</div>
	<div id="content">
		<div id="sidebar" class="fl">
			<!-- 사이드바 --><!-- 사이드바 --><!-- 사이드바 --><!-- 사이드바 --><!-- 사이드바 --><!-- 사이드바 --><!-- 사이드바 --><!-- 사이드바 -->
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
				if(pDtoFavoritesListLength>=1 || favoritesWorkspaceCount>=1 || mDaoFavoritesList.size()>=1){ 
					favoritesCheck = true;
				} 
			%>
				<div class="category ajax" style='<%=(favoritesCheck ? "display:block;" : "display: none;")%>'>
					<span>별표 표시</span>
				</div>
			<%
			for(ProjectDto dtos : pDtoFavoritesList){
			%>
				<div class="sidebar_item ajax project_idx=<%=dtos.getProjectIdx()%>" project_idx="<%=dtos.getProjectIdx()%>">
					<svg class="MiniIcon--large MiniIcon ColorFillIcon ColorFillIcon--colorAqua SmallSquircleMiniIcon" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
						<path d="M10.4,4h3.2c2.2,0,3,0.2,3.9,0.7c0.8,0.4,1.5,1.1,1.9,1.9s0.7,1.6,0.7,3.9v3.2c0,2.2-0.2,3-0.7,3.9c-0.4,0.8-1.1,1.5-1.9,1.9s-1.6,0.7-3.9,0.7h-3.2c-2.2,0-3-0.2-3.9-0.7c-0.8-0.4-1.5-1.1-1.9-1.9c-0.4-1-0.6-1.8-0.6-4v-3.2c0-2.2,0.2-3,0.7-3.9C5.1,5.7,5.8,5,6.6,4.6C7.4,4.2,8.2,4,10.4,4z"></path></svg>
					<span class="ajax_dtos_project_favorites_name"><%=dtos.getName()%></span>
				</div>
			<%
			}
			%>
			<%
			for(MemberDto dtos : mDaoFavoritesList){
			%>
				<div class="sidebar_item ajax member_idx_<%=dtos.getMemberIdx()%>" member_idx="<%=dtos.getMemberIdx()%>">
					<img class="img_small_favorites" src="img\<%=dtos.getProfileImg()%>">
					<span class="ajax_dtos_project_favorites_name"><%=dtos.getNickname()%></span>
				</div>
			<%
			}
			%>
			<%
			for(int i=0; i<favoritesWorkspaceCount; i++){
			%>
				<div class="sidebar_item with_gt ajax">
					<svg class="Icon SidebarItemIcon--iconWithoutCustomizationColor UserFillIcon" viewBox="0 0 32 32" aria-hidden="true" focusable="false">
						<path d="M31,30H11c-.552,0-1-.448-1-1v-2c0-3.866,3.134-7,7-7h8c3.866,0,7,3.134,7,7v2c0,.552-.448,1-1,1Zm-23-3c0-2.029,.676-3.901,1.814-5.407,.495-.656,.023-1.593-.799-1.593h-2.015c-3.866,0-7,3.134-7,7v2c0,.552,.448,1,1,1H7c.552,0,1-.448,1-1v-2ZM28.5,10c0-4.142-3.358-7.5-7.5-7.5s-7.5,3.358-7.5,7.5,3.358,7.5,7.5,7.5,7.5-3.358,7.5-7.5Zm-17,0c0-2.125,.698-4.087,1.878-5.67,.431-.579,.176-1.413-.522-1.594-1.074-.278-2.24-.324-3.45-.067-2.917,.619-5.248,2.996-5.779,5.93-.86,4.758,2.773,8.901,7.373,8.901,.632,0,1.245-.08,1.831-.23,.71-.181,.984-1.013,.546-1.601-1.179-1.582-1.877-3.544-1.877-5.669Z"></path></svg>
					<span>내 작업 공간</span>
					<svg class="MiniIcon--small MiniIcon SidebarFlyoutSplitDropdownButton-flyoutChevron ArrowRightMiniIcon" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
						<path d="M10.148 3.885A1.5 1.5 0 1 0 7.85 5.813l5.19 6.186-5.19 6.186a1.499 1.499 0 0 0 1.148 2.464c.428 0 .854-.182 1.15-.536l6-7.15a1.5 1.5 0 0 0 0-1.929l-6-7.149Z"></path></svg>
				</div>
			<%
			}
			%>
			<!------------------------- 즐겨찾기 추가된 프로젝트 & 포트폴리오 & 멤버 ------------------------------->
	
				<div class="category with_plus">
					<span>프로젝트</span>
					<svg class="MiniIcon PlusMiniIcon" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
						<path d="M10,10V4c0-1.1,0.9-2,2-2s2,0.9,2,2v6h6c1.1,0,2,0.9,2,2s-0.9,2-2,2h-6v6c0,1.1-0.9,2-2,2s-2-0.9-2-2v-6H4c-1.1,0-2-0.9-2-2s0.9-2,2-2H10z"></path></svg>
				</div>
				<!--------------------------------- 사이드바 프로젝트/포트폴리오 참여중 리스트 ------------------------------------->
				<!-- 프로젝트 참여 리스트 출력 -->
				<%
				for(ProjectDto dtos : pDtoList){
				%>
					<div class="sidebar_item" project_idx="<%=dtos.getProjectIdx()%>">
						<svg class="MiniIcon--large MiniIcon ColorFillIcon ColorFillIcon--colorAqua SmallSquircleMiniIcon" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
							<path d="M10.4,4h3.2c2.2,0,3,0.2,3.9,0.7c0.8,0.4,1.5,1.1,1.9,1.9s0.7,1.6,0.7,3.9v3.2c0,2.2-0.2,3-0.7,3.9c-0.4,0.8-1.1,1.5-1.9,1.9s-1.6,0.7-3.9,0.7h-3.2c-2.2,0-3-0.2-3.9-0.7c-0.8-0.4-1.5-1.1-1.9-1.9c-0.4-1-0.6-1.8-0.6-4v-3.2c0-2.2,0.2-3,0.7-3.9C5.1,5.7,5.8,5,6.6,4.6C7.4,4.2,8.2,4,10.4,4z"></path></svg>
						<span><%=dtos.getName()%></span>
					</div>
				<%
				}
				%>
				<!-- 사이드바 참여 포트폴리오 리스트 -->
				<%
				for(PortfolioDto dtos : portfolioList){
				%>
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
			<!-- 사이드바 --><!-- 사이드바 --><!-- 사이드바 --><!-- 사이드바 --><!-- 사이드바 --><!-- 사이드바 --><!-- 사이드바 --><!-- 사이드바 -->
		</div>
		<div id="main" class="fl">
			<!-- 이걸... -->
			<div id="main_other_profile">
				<div class="main" style="position: relative; z-index: 1;">
					<div class="main-top">
						<div class="margin23">
							<img class="Profile-img" src="img/${profileImg}"><!-- Jisoo.png -->
							<div class="font32">
								<div style="display: flex; gap: 10px;">
									<div><!-- 지숭 -->${nickname}</div>
									<%if(isFavoritesMember==0){ %>
										<div class="star-center" style="margin-top: 10px; width: 25px; height: 25px;">
											<!-- 꺼진 별 -->
											<svg class="icon20-star" viewBox="0 0 32 32" aria-hidden="true" focusable="false" style="fill: gray;">
												<path d="M.608 11.301a2.161 2.161 0 0 0 .538 2.224l5.867 5.78-1.386 8.164c-.14.824.192 1.637.868 2.124a2.133 2.133 0 0 0 2.262.155l7.241-3.848 7.24 3.848a2.133 2.133 0 0 0 2.263-.155 2.155 2.155 0 0 0 .868-2.124l-1.386-8.164 5.867-5.78c.59-.582.797-1.434.538-2.224a2.146 2.146 0 0 0-1.734-1.466l-8.1-1.19-3.623-7.42A2.148 2.148 0 0 0 15.998 0c-.828 0-1.57.476-1.935 1.223L10.44 8.645l-8.1 1.19A2.145 2.145 0 0 0 .606 11.3h.002Zm2.025.512 9.143-1.342 4.086-8.37c.012-.023.044-.088.137-.088.093 0 .124.064.137.089l4.086 8.369 9.143 1.342c.023.003.093.014.125.11a.163.163 0 0 1-.042.178l-6.609 6.511 1.56 9.192a.16.16 0 0 1-.065.169c-.074.054-.129.023-.152.01l-8.181-4.346-8.181 4.347c-.022.013-.08.04-.152-.011a.159.159 0 0 1-.065-.17l1.56-9.19-6.61-6.512a.163.163 0 0 1-.041-.178c.032-.096.102-.106.125-.11h-.004Z"></path></svg>
											<!-- 켜진 별 -->
											<svg class="icon20-star-on" viewBox="0 0 32 32" aria-hidden="true" focusable="false">
												<path d="m.938 12.86 6.47 6.394-1.526 9.022c-.096.56.131 1.113.592 1.444a1.47 1.47 0 0 0 1.556.105l7.969-4.247 7.969 4.247a1.465 1.465 0 0 0 1.557-.105c.46-.332.688-.885.593-1.443l-1.527-9.024 6.468-6.393c.402-.396.543-.974.368-1.51a1.47 1.47 0 0 0-1.188-1.002l-8.924-1.314L17.328.841C17.078.33 16.57.001 16 .001c-.569 0-1.076.329-1.326.84l-3.987 8.193-8.924 1.314A1.466 1.466 0 0 0 .575 11.35a1.467 1.467 0 0 0 .366 1.508l-.003.002Z"></path></svg>
										</div>
									<%}else{ %>
										<div class="star-center on" style="margin-top: 10px; width: 25px; height: 25px;">
											<!-- 꺼진 별 -->
											<svg class="icon20-star" viewBox="0 0 32 32" aria-hidden="true" focusable="false" style="fill: gray;">
												<path d="M.608 11.301a2.161 2.161 0 0 0 .538 2.224l5.867 5.78-1.386 8.164c-.14.824.192 1.637.868 2.124a2.133 2.133 0 0 0 2.262.155l7.241-3.848 7.24 3.848a2.133 2.133 0 0 0 2.263-.155 2.155 2.155 0 0 0 .868-2.124l-1.386-8.164 5.867-5.78c.59-.582.797-1.434.538-2.224a2.146 2.146 0 0 0-1.734-1.466l-8.1-1.19-3.623-7.42A2.148 2.148 0 0 0 15.998 0c-.828 0-1.57.476-1.935 1.223L10.44 8.645l-8.1 1.19A2.145 2.145 0 0 0 .606 11.3h.002Zm2.025.512 9.143-1.342 4.086-8.37c.012-.023.044-.088.137-.088.093 0 .124.064.137.089l4.086 8.369 9.143 1.342c.023.003.093.014.125.11a.163.163 0 0 1-.042.178l-6.609 6.511 1.56 9.192a.16.16 0 0 1-.065.169c-.074.054-.129.023-.152.01l-8.181-4.346-8.181 4.347c-.022.013-.08.04-.152-.011a.159.159 0 0 1-.065-.17l1.56-9.19-6.61-6.512a.163.163 0 0 1-.041-.178c.032-.096.102-.106.125-.11h-.004Z"></path></svg>
											<!-- 켜진 별 -->
											<svg class="icon20-star-on" viewBox="0 0 32 32" aria-hidden="true" focusable="false">
												<path d="m.938 12.86 6.47 6.394-1.526 9.022c-.096.56.131 1.113.592 1.444a1.47 1.47 0 0 0 1.556.105l7.969-4.247 7.969 4.247a1.465 1.465 0 0 0 1.557-.105c.46-.332.688-.885.593-1.443l-1.527-9.024 6.468-6.393c.402-.396.543-.974.368-1.51a1.47 1.47 0 0 0-1.188-1.002l-8.924-1.314L17.328.841C17.078.33 16.57.001 16 .001c-.569 0-1.076.329-1.326.84l-3.987 8.193-8.924 1.314A1.466 1.466 0 0 0 .575 11.35a1.467 1.467 0 0 0 .366 1.508l-.003.002Z"></path></svg>
										</div>
									<%} %>
								</div>
								<div class="info center">
									<div style="margin-right: 5px;" class="center">
										<svg class="icon15" viewBox="0 0 32 32" aria-hidden="true" focusable="false">
											<path d="M16 0C7.176 0 0 7.178 0 16s7.177 16 16 16c8.821 0 16-7.178 16-16S24.82 0 16 0Zm0 30C8.28 30 2 23.72 2 16S8.28 2 16 2s14 6.28 14 14-6.28 14-14 14Zm8-13a1 1 0 0 1-1 1h-8a1 1 0 0 1-1-1V9a1 1 0 0 1 2 0v7h7a1 1 0 0 1 1 1Z"></path></svg>
									</div>
									<div style="margin-right: 5px;" class="center">현지시간 ${nowTime}</div>
									<div style="margin-right: 5px;" class="center">
										<svg class="icon15" viewBox="0 0 32 32" aria-hidden="true" focusable="false">
											<path d="M25.998 4h-20c-3.309 0-6 2.691-6 6v12c0 3.309 2.691 6 6 6h20c3.31 0 6-2.691 6-6V10c0-3.309-2.69-6-6-6Zm-20 2h20c.74 0 1.424.215 2.02.567L16.704 17.879a1 1 0 0 1-1.414 0L3.98 6.567A3.96 3.96 0 0 1 6 6Zm24 16c0 2.206-1.794 4-4 4h-20c-2.206 0-4-1.794-4-4V10c0-.74.215-1.424.567-2.019l11.312 11.313a2.993 2.993 0 0 0 2.121.876 2.99 2.99 0 0 0 2.121-.877L29.431 7.981A3.96 3.96 0 0 1 29.998 10v12Z"></path></svg>
									</div>
									<div style="margin-right: 5px;" class="center">${email}</div>
								</div>
							</div>
						</div>
						<div>
							<div class="center-button">
								<div class="new-work-button">
									<div class="center-text">
										<svg style="margin: 0px 3px 0px 0px;" class="icon15" viewBox="0 0 32 32" aria-hidden="true" focusable="false">
											<path d="M29.1,20.9 M16,32C7.2,32,0,24.8,0,16S7.2,0,16,0s16,7.2,16,16S24.8,32,16,32z M16,2C8.3,2,2,8.3,2,16s6.3,14,14,14s14-6.3,14-14S23.7,2,16,2z M12.9,22.6c-0.3,0-0.5-0.1-0.7-0.3l-3.9-3.9C8,18,8,17.4,8.3,17s1-0.4,1.4,0l3.1,3.1l8.6-8.6c0.4-0.4,1-0.4,1.4,0s0.4,1,0,1.4l-9.4,9.4C13.4,22.5,13.2,22.6,12.9,22.6z"></path></svg>
										작업 배정
									</div>
									<div class="center-more">
										<svg style="margin: 0;" class="icon15" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
											<path d="m18.185 7.851-6.186 5.191-6.186-5.191a1.499 1.499 0 1 0-1.928 2.298l7.15 6a1.498 1.498 0 0 0 1.928 0l7.15-6a1.5 1.5 0 0 0-1.928-2.298Z"></path></svg>
									</div>
								</div>
								<div class="CreateButton">
									<svg class="icon16" viewBox="0 0 32 32" aria-hidden="true" focusable="false">
										<path d="M21,18c-4.411,0-8-3.589-8-8S16.589,2,21,2s8,3.589,8,8-3.589,8-8,8Zm0-14c-3.309,0-6,2.691-6,6s2.691,6,6,6,6-2.691,6-6-2.691-6-6-6Zm11,25v-2c0-3.86-3.141-7-7-7h-8c-3.859,0-7,3.14-7,7v2c0,.552,.447,1,1,1s1-.448,1-1v-2c0-2.757,2.243-5,5-5h8c2.757,0,5,2.243,5,5v2c0,.552,.447,1,1,1s1-.448,1-1ZM12,17c0-.552-.447-1-1-1-3.309,0-6-2.691-6-6s2.691-6,6-6c.553,0,1-.448,1-1s-.447-1-1-1C6.589,2,3,5.589,3,10s3.589,8,8,8c.553,0,1-.448,1-1ZM2,29v-2c0-2.757,2.243-5,5-5h2c.553,0,1-.448,1-1s-.447-1-1-1h-2C3.141,20,0,23.14,0,27v2C0,29.552,.447,30,1,30s1-.448,1-1Z"></path></svg>
									프로젝트 생성하기
								</div>
							</div>
							<div class="message-box" style="">
								<svg style="margin-right: 5px; fill: gray;" class="icon16" viewBox="0 0 32 32" aria-hidden="true" focusable="false">
									<path d="M20 2h-8C5.383 2 0 7.383 0 14v2c0 3.103 1.239 6.1 3.424 8.342l.586 5.857a1.999 1.999 0 0 0 3.247 1.357L11.662 28h8.339c6.617 0 12-5.383 12-12v-2c0-6.617-5.384-12-12.001-12Zm-9.045 24L6 30l-.659-6.589C3.305 21.58 2 18.953 2 16v-2C2 8.477 6.477 4 12 4h8c5.523 0 10 4.477 10 10v2c0 5.523-4.477 10-10 10h-9.045Z"></path></svg>
								메시지 보내기
							</div>
						</div>
					</div>
					<div class="main-under">
						<div class="under-top">
							<div>
								<div style="margin-top: 30px;">작업</div>
								<div class="wam-list">
									<span class="gray-font14 on">모두</span> 
									<span class="gray-font14">내가 배정한 작업</span> 
									<span class="gray-font14">내가 협업에 참여하고 있는 작업</span>
								</div>
							</div>
							<div>
								<button class="my-work-button">모든 작업 보기</button>
							</div>
						</div>
						<!-- 로그인멤버가 타인멤버에게 배정한 wam 와 로그인멤버와 타인멤버가 함께 협업중인 wam list -->
						<div class="under-under on">
							<%for(WamDto dto : getAllWamListByLoginMemberAndOtherMember){ %>
								<div class="under-content" wam_idx="<%=dto.getWamIdx()%>" wam_type="<%=dto.getWamType()%>">
									<div class="center">
										<svg class="profile_page_work_check" viewBox="0 0 32 32" aria-hidden="true" focusable="false">
						                    <path class="profile_page_work_check_outline" d="M31,16c0,8.3-6.7,15-15,15S1,24.3,1,16S7.7,1,16,1S31,7.7,31,16z"></path>
						                    <path class="profile_page_work_check_inline" d="M13.4,22.1c-0.3,0-0.5-0.1-0.7-0.3l-3.9-3.9c-0.4-0.4-0.4-1,0-1.4s1-0.4,1.4,0l3.1,3.1l8.1-8.1c0.4-0.4,1-0.4,1.4,0   s0.4,1,0,1.4l-8.9,8.9C13.9,22,13.7,22.1,13.4,22.1z"></path></svg>
										<span class="other_profile_project_name"><%=dto.getTitle() %></span>
									</div>
									<div class="center">
										<div style="background-color: #4573d2;" class="project-box">
											<%=dto.getProjectDto().getName() %>
										</div>
										<div class="date">
											<span>
        										<%=dto.getDeadlineDate() %>
    										</span>
										</div>
										<img style="z-index: 4;" class="img-small" src="img/<%=dto.getMemberDto().getProfileImg()%>">
									</div>
								</div>
							<% }%>
							<%-- <div class="under-content approve_wam">
								<div class="under-content">
									<div class="center">
									<!------------------------------------- 승인 상태 로고 ---------------------------->
										<!-- 승인 상태 : 보류중 -->
										<svg class="icon17" style="border: 1px solid gray; border-radius: 5px;"  viewBox="0 0 32 32" aria-hidden="true" focusable="false">
											<path class="icon17-path-border" d="M24,1H8C4.1,1,1,4.1,1,8v16c0,3.9,3.1,7,7,7h16c3.9,0,7-3.1,7-7V8C31,4.1,27.9,1,24,1z"></path>
											<path class="icon17-path-main" d="M24,20h-4.6l1.5-8.1C21.5,8.8,19.1,6,16,6c-3.1,0-5.5,2.8-4.9,5.9l1.5,8.1H8c-1.2,0-2.2,1.1-2,2.3l0.5,2.8  C6.6,25.6,7,26,7.5,26h17.1c0.5,0,0.8-0.3,0.9-0.8l0.5-2.9C26.2,21.1,25.2,20,24,20z M16,8c1.9,0,3.3,1.7,2.9,3.5L17.3,20h-2.7  l-1.6-8.5C12.7,9.7,14.1,8,16,8z M23.7,24H8.3L8,22h16L23.7,24z"></path></svg>
										<!-- 승인 상태 : 승인됨 -->
										<svg style="display:none;" class="icon17 approve-green" viewBox="0 0 32 32" aria-hidden="true" focusable="false">
											<path d="M24,31H8c-3.9,0-7-3.1-7-7V8c0-3.9,3.1-7,7-7h16c3.9,0,7,3.1,7,7v16C31,27.9,27.9,31,24,31z" class="CompoundIcon-outer"></path>
											<path style="fill:white;" d="M13.4,22.1c-0.3,0-0.5-0.1-0.7-0.3l-3.9-3.9c-0.4-0.4-0.4-1,0-1.4s1-0.4,1.4,0l3.1,3.1l8.1-8.1c0.4-0.4,1-0.4,1.4,0   s0.4,1,0,1.4l-8.9,8.9C13.9,22,13.7,22.1,13.4,22.1z"></path></svg>
										<!-- 승인 상태 : 변경 요청됨 -->
										<svg style="display:none;" class="icon17 approve-yellow" viewBox="0 0 32 32" aria-hidden="true" focusable="false">
											<path d="M23,31H9c-4.4,0-8-3.6-8-8V9c0-4.4,3.6-8,8-8h14c4.4,0,8,3.6,8,8v14C31,27.4,27.4,31,23,31z" class="CompoundIcon-outer"></path>
											<path style="fill:white;" d="M22.1,9.4c-1.6-1.6-3.8-2.5-6.1-2.5c-2.3,0-4.5,0.9-6.1,2.5c-3.4,3.4-3.4,8.9,0,12.3c0.1,0.1,0.2,0.2,0.3,0.3H7.3  c-0.6,0-1,0.4-1,1s0.4,1,1,1H13c0.6,0,1-0.4,1-1v-5.7c0-0.6-0.4-1-1-1s-1,0.4-1,1v3.6c-0.3-0.2-0.5-0.4-0.7-0.6  c-2.6-2.6-2.6-6.8,0-9.5c1.3-1.3,2.9-2,4.7-2c1.8,0,3.5,0.7,4.7,2s2,2.9,2,4.7c0,1.8-0.7,3.5-2,4.7c-0.4,0.4-0.4,1,0,1.4  s1,0.4,1.4,0c1.6-1.6,2.5-3.8,2.5-6.1C24.7,13.2,23.8,11.1,22.1,9.4z"></path></svg>
										<!-- 승인 상태 : 거부됨 -->
										<svg style="display:none;" class="icon17 approve-red" viewBox="0 0 32 32" aria-hidden="true" focusable="false">
											<path d="M23,31H9c-4.4,0-8-3.6-8-8V9c0-4.4,3.6-8,8-8h14c4.4,0,8,3.6,8,8v14C31,27.4,27.4,31,23,31z"></path>
											<path style="fill:white;" d="M17.4,16l5.3-5.3c0.4-0.4,0.4-1,0-1.4s-1-0.4-1.4,0L16,14.6l-5.3-5.3c-0.4-0.4-1-0.4-1.4,0s-0.4,1,0,1.4l5.3,5.3l-5.3,5.3  c-0.4,0.4-0.4,1,0,1.4C9.5,22.9,9.7,23,10,23s0.5-0.1,0.7-0.3l5.3-5.3l5.3,5.3c0.2,0.2,0.5,0.3,0.7,0.3s0.5-0.1,0.7-0.3  c0.4-0.4,0.4-1,0-1.4L17.4,16z"></path></svg>
									<!------------------------------------ 승인 상태 로고 ----------------------------->
										<span class="other_profile_project_name">금요일 조회 승인서</span>
									</div>
									<div class="center">
										<div style="background-color: #f26fb2;" class="project-box">
											협업 툴 ...</div>
										<div style="color: red;" class="date">10월 29일</div>
										<img style="z-index: 4;" class="img-small" src="img/${profileImg}">
									</div>
								</div>
								<!----------------------- 승인 팝업창 ------------------------------>
								<div class="approve-check">
									<div class="approve-check-in">
										<div class="check-area">
											<svg class="check-icon on" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
												<path d="M19.439 5.439 8 16.878l-3.939-3.939A1.5 1.5 0 1 0 1.94 15.06l5 5c.293.293.677.439 1.061.439.384 0 .768-.146 1.061-.439l12.5-12.5a1.5 1.5 0 1 0-2.121-2.121h-.002Z"></path></svg>
										</div>
										<svg class="icon17-approve" viewBox="0 0 32 32" aria-hidden="true" focusable="false">
											<path class="approve-wait-background" d="M24,1H8C4.1,1,1,4.1,1,8v16c0,3.9,3.1,7,7,7h16c3.9,0,7-3.1,7-7V8C31,4.1,27.9,1,24,1z"></path>
											<path class="approve-wait-main" d="M24,20h-4.6l1.5-8.1C21.5,8.8,19.1,6,16,6c-3.1,0-5.5,2.8-4.9,5.9l1.5,8.1H8c-1.2,0-2.2,1.1-2,2.3l0.5,2.8  C6.6,25.6,7,26,7.5,26h17.1c0.5,0,0.8-0.3,0.9-0.8l0.5-2.9C26.2,21.1,25.2,20,24,20z M16,8c1.9,0,3.3,1.7,2.9,3.5L17.3,20h-2.7  l-1.6-8.5C12.7,9.7,14.1,8,16,8z M23.7,24H8.3L8,22h16L23.7,24z"></path></svg>
										<span>승인 보류 중</span>
									</div>
									<div class="approve-check-in">
										<div class="check-area">
											<svg class="check-icon" viewBox="0 0 24 24"	aria-hidden="true" focusable="false">
												<path d="M19.439 5.439 8 16.878l-3.939-3.939A1.5 1.5 0 1 0 1.94 15.06l5 5c.293.293.677.439 1.061.439.384 0 .768-.146 1.061-.439l12.5-12.5a1.5 1.5 0 1 0-2.121-2.121h-.002Z"></path></svg>
										</div>
										<svg class="approve-green" viewBox="0 0 32 32"	aria-hidden="true" focusable="false">
											<path	d="M24,31H8c-3.9,0-7-3.1-7-7V8c0-3.9,3.1-7,7-7h16c3.9,0,7,3.1,7,7v16C31,27.9,27.9,31,24,31z" class="CompoundIcon-outer"></path>
											<path style="fill:white;" d="M13.4,22.1c-0.3,0-0.5-0.1-0.7-0.3l-3.9-3.9c-0.4-0.4-0.4-1,0-1.4s1-0.4,1.4,0l3.1,3.1l8.1-8.1c0.4-0.4,1-0.4,1.4,0   s0.4,1,0,1.4l-8.9,8.9C13.9,22,13.7,22.1,13.4,22.1z"></path></svg>
										<span>승인됨</span>
									</div>
									<div class="approve-check-in">
										<div class="check-area">
											<svg class="check-icon" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
												<path d="M19.439 5.439 8 16.878l-3.939-3.939A1.5 1.5 0 1 0 1.94 15.06l5 5c.293.293.677.439 1.061.439.384 0 .768-.146 1.061-.439l12.5-12.5a1.5 1.5 0 1 0-2.121-2.121h-.002Z"></path></svg>
										</div>
										<svg class="approve-yellow" viewBox="0 0 32 32" aria-hidden="true" focusable="false">
											<path d="M23,31H9c-4.4,0-8-3.6-8-8V9c0-4.4,3.6-8,8-8h14c4.4,0,8,3.6,8,8v14C31,27.4,27.4,31,23,31z" class="CompoundIcon-outer"></path>
											<path style="fill:white;" d="M22.1,9.4c-1.6-1.6-3.8-2.5-6.1-2.5c-2.3,0-4.5,0.9-6.1,2.5c-3.4,3.4-3.4,8.9,0,12.3c0.1,0.1,0.2,0.2,0.3,0.3H7.3  c-0.6,0-1,0.4-1,1s0.4,1,1,1H13c0.6,0,1-0.4,1-1v-5.7c0-0.6-0.4-1-1-1s-1,0.4-1,1v3.6c-0.3-0.2-0.5-0.4-0.7-0.6  c-2.6-2.6-2.6-6.8,0-9.5c1.3-1.3,2.9-2,4.7-2c1.8,0,3.5,0.7,4.7,2s2,2.9,2,4.7c0,1.8-0.7,3.5-2,4.7c-0.4,0.4-0.4,1,0,1.4  s1,0.4,1.4,0c1.6-1.6,2.5-3.8,2.5-6.1C24.7,13.2,23.8,11.1,22.1,9.4z"></path></svg>
										<span>변경 요청됨</span>
									</div>
									<div class="approve-check-in">
										<div class="check-area">
											<svg class="check-icon" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
												<path d="M19.439 5.439 8 16.878l-3.939-3.939A1.5 1.5 0 1 0 1.94 15.06l5 5c.293.293.677.439 1.061.439.384 0 .768-.146 1.061-.439l12.5-12.5a1.5 1.5 0 1 0-2.121-2.121h-.002Z"></path></svg>
										</div>
										<svg class="approve-red" viewBox="0 0 32 32" aria-hidden="true" focusable="false">
											<path d="M23,31H9c-4.4,0-8-3.6-8-8V9c0-4.4,3.6-8,8-8h14c4.4,0,8,3.6,8,8v14C31,27.4,27.4,31,23,31z"></path>
											<path style="fill:white;" d="M17.4,16l5.3-5.3c0.4-0.4,0.4-1,0-1.4s-1-0.4-1.4,0L16,14.6l-5.3-5.3c-0.4-0.4-1-0.4-1.4,0s-0.4,1,0,1.4l5.3,5.3l-5.3,5.3  c-0.4,0.4-0.4,1,0,1.4C9.5,22.9,9.7,23,10,23s0.5-0.1,0.7-0.3l5.3-5.3l5.3,5.3c0.2,0.2,0.5,0.3,0.7,0.3s0.5-0.1,0.7-0.3  c0.4-0.4,0.4-1,0-1.4L17.4,16z"></path></svg>
										<span>거부됨</span>
									</div>
								</div>
								<!----------------------- 승인 팝업창 ------------------------------>
							</div> --%>
						</div>
						<!-- 로그인멤버가 타인멤버에게 배정한 wam list -->
						<div class="under-under">
							<%for(WamDto dto : wamListByLoginMemberAssignsToOtherMember){ %>
								<div class="under-content" wam_idx="<%=dto.getWamIdx()%>" wam_type="<%=dto.getWamType()%>">
									<div class="center">
										<svg class="profile_page_work_check" viewBox="0 0 32 32" aria-hidden="true" focusable="false">
						                    <path class="profile_page_work_check_outline" d="M31,16c0,8.3-6.7,15-15,15S1,24.3,1,16S7.7,1,16,1S31,7.7,31,16z"></path>
						                    <path class="profile_page_work_check_inline" d="M13.4,22.1c-0.3,0-0.5-0.1-0.7-0.3l-3.9-3.9c-0.4-0.4-0.4-1,0-1.4s1-0.4,1.4,0l3.1,3.1l8.1-8.1c0.4-0.4,1-0.4,1.4,0   s0.4,1,0,1.4l-8.9,8.9C13.9,22,13.7,22.1,13.4,22.1z"></path></svg>
										<span class="other_profile_project_name"><%=dto.getTitle() %></span>
									</div>
									<div class="center">
										<div style="background-color: #4573d2;" class="project-box">
											<%=dto.getProjectDto().getName() %>
										</div>
										<div class="date">
											<span>
        										<%=dto.getDeadlineDate() %>
    										</span>
										</div>
										<img style="z-index: 4;" class="img-small" src="img/<%=dto.getMemberDto().getProfileImg()%>">
									</div>
								</div>
							<% }%>
						</div>
						<!-- 로그인멤버와 타인멤버가 같이 협업중인 wam list -->
						<div class="under-under">
							<%for(WamDto dto : getTogetherWamsDto){ %>
								<div class="under-content" wam_idx="<%=dto.getWamIdx()%>" wam_type="<%=dto.getWamType()%>">
									<div class="center">
										<svg class="profile_page_work_check" viewBox="0 0 32 32" aria-hidden="true" focusable="false">
						                    <path class="profile_page_work_check_outline" d="M31,16c0,8.3-6.7,15-15,15S1,24.3,1,16S7.7,1,16,1S31,7.7,31,16z"></path>
						                    <path class="profile_page_work_check_inline" d="M13.4,22.1c-0.3,0-0.5-0.1-0.7-0.3l-3.9-3.9c-0.4-0.4-0.4-1,0-1.4s1-0.4,1.4,0l3.1,3.1l8.1-8.1c0.4-0.4,1-0.4,1.4,0   s0.4,1,0,1.4l-8.9,8.9C13.9,22,13.7,22.1,13.4,22.1z"></path></svg>
										<span class="other_profile_project_name"><%=dto.getTitle() %></span>
									</div>
									<div class="center">
										<div style="background-color: #4573d2;" class="project-box">
											<%=dto.getProjectDto().getName() %>
										</div>
										<div class="date">
											<span>
        										<%=dto.getDeadlineDate() %>
    										</span>
										</div>
										<img style="z-index: 4;" class="img-small" src="img/<%=dto.getMemberDto().getProfileImg()%>">
									</div>
								</div>
							<% }%>
						</div>
					</div>
					<div class="main-bottom">
						<div class="bottom-top">프로젝트</div>
						<div class="gray-font14-under">내가 협업에 참여하고 있는 프로젝트</div>
						<div class="bottom-under">
							<%for(ProjectDto dto : pDtoListByLoginMemberAndOtherMember){ %>
								<div class="bottom-content" project_idx="<%=dto.getProjectIdx()%>">
									<!-- 프로젝트 이름 -->
									<div class="profile_page_center">
										<div style="background-color: #4573D2;" class="project-logo">
											<svg class="project-logo-mini" viewBox="0 0 24 24" title="list" services="[object Object]">
												<path class="MultiColorIcon-path--fadedBlack" d="M1.5,17C2.3,17,3,17.7,3,18.5S2.3,20,1.5,20S0,19.3,0,18.5S0.7,17,1.5,17z M1.5,10C2.3,10,3,10.7,3,11.5S2.3,13,1.5,13  S0,12.3,0,11.5S0.7,10,1.5,10z M1.5,3C2.3,3,3,3.7,3,4.5S2.3,6,1.5,6S0,5.3,0,4.5S0.7,3,1.5,3z"></path>
												<path class="MultiColorIcon-path--white" d="M22.5,20h-14C7.7,20,7,19.3,7,18.5l0,0C7,17.7,7.7,17,8.5,17h14c0.8,0,1.5,0.7,1.5,1.5l0,0C24,19.3,23.3,20,22.5,20z   M22.5,13h-14C7.7,13,7,12.3,7,11.5l0,0C7,10.7,7.7,10,8.5,10h14c0.8,0,1.5,0.7,1.5,1.5l0,0C24,12.3,23.3,13,22.5,13z M22.5,6h-14  C7.7,6,7,5.3,7,4.5l0,0C7,3.7,7.7,3,8.5,3h14C23.3,3,24,3.6,24,4.5l0,0C24,5.3,23.3,6,22.5,6z"></path></svg>
										</div>
										<div class="together_project_name"><%=dto.getName() %></div>
									</div>
									<!-- 프로젝트 참여자 -->
									<div>
										<div class="list-image">
											<%	
											int projectIdx = dto.getProjectIdx();
											ArrayList<ProjectParticipantsDto> pDtoGetMember = pDao.getPerson(projectIdx);
											int zIndexCount = 10;
											int forEachCount = 1;
											
											for(ProjectParticipantsDto list : pDtoGetMember){
												if(forEachCount==1){%>
													<img style="z-index: <%=zIndexCount-- %>;" class="img-small" src="img/<%=list.getMemberDto().getProfileImg() %>" />
													<%forEachCount++;
												}else{%>
													<img style="z-index: <%=zIndexCount-- %>; margin-left: -10px;" class="img-small" src="img/<%=list.getMemberDto().getProfileImg() %>" />
												 	<%forEachCount++;
												}
												if(forEachCount==6){
													break;
												}
											}%>
										</div>
									</div>
								</div>
							<%} %>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div style="clear: both;"></div>
	</div>
</body>
</html>