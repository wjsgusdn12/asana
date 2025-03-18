<%@page import="dto.PortfolioDto"%>
<%@page import="dto.ProjectDto"%>
<%@page import="dto.MessageCooperationDto"%>
<%@page import="dao.MessageCooperationDao"%>
<%@page import="dao.LikeDao"%>
<%@page import="dao.ProjectDao"%>
<%@page import="dto.CommentsDto"%>
<%@page import="dao.MyWorkspaceDao"%>
<%@page import="dto.MyWorkspaceDto"%>
<%@page import="java.util.ArrayList"%>
<%@page import="dto.MemberDto"%>
<%@page import="dao.MemberDao"%>
<%@page import="dto.MessageDto"%>
<%@page import="dao.MessageDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String myProfile = (String)request.getAttribute("myProfile");
	int alarm = (Integer)request.getAttribute("alarm");
	ArrayList<MessageDto> listMessages = (ArrayList<MessageDto>)request.getAttribute("listMessages");
	int memberIdx = (Integer)request.getAttribute("memberIdx");
	LikeDao likeDao = (LikeDao)request.getAttribute("likeDao");
	MessageCooperationDao mcDao = (MessageCooperationDao)request.getAttribute("mcDao");
	ArrayList<MyWorkspaceDto> listMyWorkspace = (ArrayList<MyWorkspaceDto>)request.getAttribute("listMyWorkspace");
	//------------------------------------ 상단바&사이드바 변수들
	//로그인멤버의 즐겨찾기 중인 프로젝트 개수
	int pDtoFavoritesListLength = (Integer)request.getAttribute("pDtoFavoritesListLength");
	//로그인멤버의 내작업공간 즐겨찾기 유무 
	int favoritesWorkspaceCount = (Integer)request.getAttribute("favoritesWorkspaceCount");
	//로그인멤버의 즐겨찾기 중인 프로젝트 이름 리스트
	ArrayList<ProjectDto> pDtoFavoritesList = (ArrayList<ProjectDto>)request.getAttribute("pDtoFavoritesList");
	//로그인멤버의 즐겨찾게 멤버 총 명수
	ArrayList<MemberDto> mDaoFavoritesList = (ArrayList<MemberDto>)request.getAttribute("mDaoFavoritesList");
	//로그인멤버의 참여중인 프로젝트 이름 리스트
	ArrayList<ProjectDto> pDtoList = (ArrayList<ProjectDto>)request.getAttribute("pDtoList");
	//포트폴리오 참여 리스트
	ArrayList<PortfolioDto> portfolioList = (ArrayList<PortfolioDto>)request.getAttribute("portfolioList");
	//-------------------------------------- 상단바&사이드바 변수들
	String memberStartDate = (String)request.getAttribute("memberStartDate");
	String memberDeadDate = (String)request.getAttribute("memberDeadDate");
	
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Asana 20241101</title>
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.1/font/bootstrap-icons.css">
	<link rel="stylesheet" href="css/common.css"/>
	<link rel="stylesheet" href="css/Main_Common.css" />
	<link rel="stylesheet" href="css/message_page.css"/>
	<script src="js/jquery-3.7.1.min.js"></script>
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
	<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
	<script>
	
		$(function() { 
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
			// 지역변수 사용
			let messageNum = null; 
			// 상태 업데이트
			$(".status_update").click(function() {
				$(".status_update_box").toggleClass("on");
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
			$(".progress_red").click(function() { // 계획에서 벗어남 눌렀을 때
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
			//미니메시지 닫기 팝업에서 취소 버튼 클릭
 			$(".cancel").click(function(){
				$("#full").css('display','none');
			});
			//미니메시지 닫기 팝업에서 x 버튼 클릭
			$(".icon_x_svg").click(function(){
				$("#full").css('display','none');
			});
			//페이지메시지 닫기 팝업에서 취소 버튼 클릭
			$(".cancel2").click(function(){
				$(".full2").css('display','none');
			});
			//페이지메시지 닫기 팝업에서 x 버튼 클릭
			$(".icon_x_svg2").click(function(){
				$(".full2").css('display','none');
				$(".file_full").css("display","none")
			});
			//미니메시지 닫기 팝업에서 최종 닫기
			$(".delete").click(function(){
				$("#full").css('display','none');
				$("#fullscreen").css('display','none');
				$("#bluemini_message").css('display','none');
			});
			//휴지통 클릭시 닫기 팝업 띄우기
			$(".bi-trash").click(function(){
				$(".full2").css('display','flex');
				messageNum = $(this).closest(".message_idx").attr("message_idx");
			});
			//페이지메시지 닫기 팝업에서 빨간버튼 클릭시
			$(".delete2").click(function(){
				$(".full2").css('display','none');
				
				$.ajax({
					type: 'post',
					url: 'AjaxMessageHideServlet',
					data: {"message_idx": messageNum},
					success: function(data){
						if(data.result == 1) {
							console.log(messageNum);
							$("div[message_idx='" + messageNum + "']").hide(); //해당 messageNum 숨기기
						}
					},
					error: function(r,s,e) {
	        			console.log("[에러] code: " + r.status + ", message: " + r.responseText + ", error: " + e);
	        		}
				});
			});
			//미니메시지 줄이기 버튼(Icon_header) 클릭시
			$(".Icon_header").click(function(){
				$("#fullscreen").css('display','none');
				$("#bluemini_message").css('display','flex');
			});
			//"멤버에게 메시지 보내기" 클릭시
			$(".message_send_click").click(function() {
				$("#fullscreen").toggle();
			});
			//미니메시지에서 x 클릭시
			$(".Icon_header_close").click(function() {
				$("#full").css('display','flex');
			})
			//블루미니메시지 빅 아이콘 클릭
			$(".bluemini_big_icon").click(function(){
				$("#bluemini_message").css('display','none');
				$("#fullscreen").css('display','block');
			});
			//블루미니메시지 x 아이콘 클릭
			$(".bluemini_x_icon").click(function(){
				$("#full").css('display','flex');
			});
			//미니메시지 내용칸에 입력한 내용이 있을때만 전송 버튼 활성화
			$("#textarea, .title_size").keyup(function(){
				let content = $("#textarea").val();
				let title = $(".title_size").val();
				if(content.length>0 && title.length>0){
					$("#button").css({"color":"white",
									"background-color":"#4573D2"}).prop("disabled", false);
				}else{
					$("#button").css({"color":"lightgray",
									"background-color":"white"}).prop("disabled", true);
				}
			});
			// 댓글 생성
			$(".textarea_message").keyup(function(){
				let content = $(this).val();
				if(content.length>0){
					$(this).parent().find(".textarea_message_btn").css({"color":"white",
									"background-color":"#4573D2"}).prop("disabled", false); 
				}else{
					$(this).parent().find(".textarea_message_btn").css({"color":"lightgray",
									"background-color":"white"}).prop("disabled", true);
				}
			});
			// 보내기 클릭시 댓글 생성
			$(".textarea_message_btn").click(function(e) {
			    e.preventDefault();
				let content = $(this).parent().find(".textarea_message").val();
				let memberIdx = $(this).closest(".message_idx").attr("member_idx");
				let messageIdx = $(this).closest(".message_idx").attr("message_idx");
			    let self = $(this);
				if (!message_comment_check(messageIdx)) {
					alert("내용을 작성하세요.");
			        return;
			    }
					$.ajax({
						type: 'post',
						data: {"content":content, "member_idx":memberIdx, "message_idx":messageIdx,},
						url: 'AjaxCreateCommentServlet',
						success: function(data){
							  self.parent().find(".textarea_message").val(''); 
							  self.closest(".message_idx").find(".textarea_message_btn").css({"color":"lightgray",
									"background-color":"white"}).prop("disabled", true);
						        console.log("Ajax 반환 데이터:", data);
						        let newComment = 
						            '<div class="comments" comment_idx="' + data.commentIdx + '" writer_idx="' + data.memberIdx + '" member_idx="' + memberIdx + '">' +
						                '<div class="comments_header">' +
						                    '<div class="comments_profile">' +
						                        '<img src="' + data.profile + '"/>' +
						                    '</div>' +
						                    '<div class="comments_nickname">' +
						                        '<span>' + data.nickname + '</span>' +
						                    '</div>' +
						                    '<div class="comments_writedate">' +
						                        '<li>' + data.writeDate + '</li>' +
						                    '</div>' +
						                    '<div class="likes_count" style="display:none;">' +
						                        '<span>' + data.cnt + '</span>' +
						                    '</div>' +
						                    '<i class="bi-hand-thumbs-up-fill c"></i>';

						        if (data.writerIdx == data.memberIdx || data.MessageWriterIdx == data.memberIdx) {
						        	newComment +=
						                '<div class="message_edit">' +
						                    '<svg class="ArrowDownMiniIcon" viewBox="0 0 24 24" aria-hidden="true" focusable="false">' +
						                        '<path d="m18.185 7.851-6.186 5.191-6.186-5.191a1.499 1.499 0 1 0-1.928 2.298l7.15 6a1.498 1.498 0 0 0 1.928 0l7.15-6a1.5 1.5 0 0 0-1.928-2.298Z"></path>' +
						                    '</svg>' +
						                '</div>';
						        }

						        newComment += 
						                '<div class="message_edit_box c">';

						        if (data.writerIdx == data.memberIdx) {
						        	newComment +=
						                '<div class="edit_text">' +
						                    '<span style="margin-left: 8px;">댓글 편집</span>' +
						                '</div>';
						        }

						        if (data.writerIdx == data.memberIdx || data.MessageWriterIdx == data.memberIdx) {
						        	newComment +=
						                '<div class="edit_delete_comment">' +
						                    '<span style="margin-left: 8px;">댓글 삭제</span>' +
						                '</div>';
						        }

						        newComment += 
						                '</div>' +
						            '</div>' +
						            '<div class="comments_span">' +
						                data.content +
						            '</div>' +
						            '<div class="message_edit_content">' +
						                '<textarea id="textarea_edit" placeholder="메시지 수정">' + data.content + '</textarea>' +
						                '<div class="message_edit_buttons">' +
						                    '<div class="cancel_bt">' +
						                        '<button>취소</button>' +
						                    '</div>' +
						                    '<div class="save_bt c">' +
						                        '<button>변경 사항 저장</button>' +
						                    '</div>' +
						                '</div>' +
						            '</div>' +
						        '</div>';
						        
							 let commentsList = self.closest(".message_idx").find(".comments_list");

							 if (commentsList.length > 0) {
					                // 기존 댓글이 있으면 마지막 댓글 뒤에 추가
					               	commentsList.append(newComment);
					            } else {
					                // 댓글이 없으면 새로 삽입
					            	self.closest(".message_idx").append('<div class="comments_list">' + newComment + '</div>');
					            }
							 
						},
						error: function(r,s,e){
							console.log("[에러] code: " + r.status + ", message: " + r.responseText + ", error: " + e);
						}
					});
			});
			// 메시지생성
			 $("#button").click(function() {
				 if (!message_content_check()) {
				        e.preventDefault();
				    }
				let projectIdx = ${projectIdx};
				let content = $("#textarea").val();
				let title = $(".title_size").val();
				let writerIdx = ${memberIdx};
			 	$.ajax({
					type: 'post',
					data: {"project_idx":projectIdx,"content":content,"title":title,"writer_idx":writerIdx}, 
					url: 'AjaxCreateMessageServlet',
					success: function(data){
						$("#fullscreen").css('display','none');
						location.reload();
					},
					error: function(r,s,e){
						console.log("[에러] code: " + r.status + ", message: " + r.responseText + ", error: " + e);
					}
				});
			});  
			//상단바 프로필이미지 클릭시 프로필 팝업창 나옴
			$("#me_button").click(function(){
				$(".me_button_popup").toggleClass("on");
			});
			//프로필 팝업창 Asana에 초대 아이콘 클릭
			$(".popup_invite_member").click(function(){
				alert("Asana에 초대 클릭");
			});
			//프로필 팝업창 프로필 아이콘 클릭
			$(".popup_profile_info_details").click(function(){
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
				let memberIdx = $(this).closest(".profile_setting_background").attr("member_idx");
				let nickname = $(this).closest(".profile_setting_background").find("#profile_setting_name").val();
				let introduce = $(this).closest(".profile_setting_background").find("#profile_setting_introduction").val();
				let startDate = $("#start_date").val();
				let endDate = $("#end_date").val();
				let alarmOn = $(".toggle_click_view").hasClass("on");
				if(alarmOn){
				if (!startDate || !endDate) {
		            alert("시작일과 종료일을 모두 선택해주세요.");
		            return;
		        	}

		        if (startDate > endDate) {
		            alert("종료일은 시작일보다 작을 수 없습니다.");
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
			            return;
			        	}

			        if (startDate > endDate) {
			            alert("종료일은 시작일보다 작을 수 없습니다.");
			            return;
			        	}
					}
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
			//메시지 내용	좋아요 클릭
			$(".bi-hand-thumbs-up-fill.m").click(function(){
				$(this).toggleClass('on');
				let messageIdx = $(this).closest(".message_idx").attr("message_idx");
				let memberIdx = $(this).closest(".message_idx").attr("member_idx");
				let this_ = $(this);
				if($(this).hasClass('on')) {
				$.ajax({ // 좋아요 추가
					type: 'post',
					data: {"message_idx":messageIdx , "member_idx":memberIdx},
					url: 'AjaxInsertLikeServlet',
					success: function(data){
						if(data.likeCount>0) {
							this_.closest(".message_idx").find(".likes_count.m").text(data.likeCount).show();
						}
					},
					error: function(r,s,e){
						console.log("[에러] code: " + r.status + ", message: " + r.responseText + ", error: " + e);
					}
				});
				}else {
					$.ajax({ // 좋아요 제거
						type: 'post',
						data: {"message_idx":messageIdx , "member_idx":memberIdx},
						url: 'AjaxDeleteMessageLikeServlet',
						success: function(data){
							if(data.likeCount > 0) {
							this_.closest(".message_idx").find(".likes_count.m").text(data.likeCount).show();
							}else if(data.likeCount == 0) {
								this_.closest(".message_idx").find(".likes_count.m").hide();
							}
						},
						error: function(r,s,e){
							console.log("[에러] code: " + r.status + ", message: " + r.responseText + ", error: " + e);
						}
					});
				};
			});
			// 메시지 댓글 좋아요 클릭
			//$(".bi-hand-thumbs-up-fill.c").click(function(){
				$(document).on("click", ".bi-hand-thumbs-up-fill.c", function(e) {
				$(this).toggleClass('on');
				let commentIdx = $(this).closest(".comments").attr("comment_idx");
				let memberIdx = $(this).closest(".comments").attr("member_idx");
				let this_ = $(this);
				if($(this).hasClass('on')) {
				$.ajax({ // 좋아요 추가
					type: 'post',
					data: {"comment_idx":commentIdx , "member_idx":memberIdx},
					url: 'AjaxInsertCommentLikeServlet',
					success: function(data){
						if(data.likeCount>0) {
							this_.closest(".comments").find(".likes_count").text(data.likeCount).show();
						}
					},
					error: function(r,s,e){
						console.log("[에러] code: " + r.status + ", message: " + r.responseText + ", error: " + e);
					}
				});
				}else {
					$.ajax({ // 좋아요 제거
						type: 'post',
						data: {"comment_idx":commentIdx , "member_idx":memberIdx},
						url: 'AjaxDeleteCommentLikeServlet',
						success: function(data){
							if(data.likeCount > 0) {
								this_.closest(".comments").find(".likes_count").text(data.likeCount).show();
								}else if(data.likeCount == 0) {
									this_.closest(".comments").find(".likes_count").hide();
								}
						},
						error: function(r,s,e){
							console.log("[에러] code: " + r.status + ", message: " + r.responseText + ", error: " + e);
						}
					});
				};
			});
			//메시지 작성자 프로필 클릭 (윗쪽)
			$(".writer_profile_img").click(function(){
				alert("메시지 작성자 프로필 클릭 (윗쪽)");
			});
			//메시지 작성자 이름 클릭 (윗쪽)
			$(".writer_profile_button").click(function(){
				alert("메시지 작성자 이름 클릭 (윗쪽)");
			});
			//메시지 작성자 프로필 클릭 (아랫쪽)
			$(".message_content_profile").click(function(){
				alert("메시지 작성자 프로필 클릭 (아랫쪽)");
			});
			//메시지 작성자 이름 클릭 (아랫쪽)
			$(".message_comments_writer, .comments_nickname").click(function(){
				alert("메시지 작성자 이름 클릭 (아랫쪽)");
			});
			//프로필 제거
			$(".delete_myProfile").click(function() {
				let memberIdx = $(this).closest(".profile_setting_background").attr("member_idx");
				let self = $(this);
				let profileImageContainer = self.closest("#profile_setting_main").find(".profile_setting_picture");
			    let image = profileImageContainer.find("img");
				if(image.attr("src") !== "img/Unknown.png"){
				$.ajax({
					type:'post',
					data:{"member_idx":memberIdx},
					url:'AjaxDeleteMyProfileServlet',
					success: function(data){
						image.attr("src", "img/Unknown.png");
					},
					error: function(r,s,e){
						console.log("[에러] code: " + r.status + ", message: " + r.responseText + ", error: " + e);
					}
				});
				}
			});
			//프로필 업로드
			$(".upload_myProfile").click(function() {
				let memberIdx = $(this).closest(".profile_setting_background").attr("member_idx");
			})
			
			// 부재중 토글 클릭
			$(".toggle_input").click(function () {
			    let checked = $(this).is(":checked"); // 체크박스 true or false
			    let memberIdx = ${memberIdx};
			    let startDate = $("#start_date").val();
				let endDate = $("#end_date").val();
				
			    if (checked) {
			        $(".toggle_click_view").addClass("on");
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
			        $("#start_date").val(""); // 시작일 날짜를 초기화
			        $("#end_date").val(""); // 종료일 날짜를 초기화
			        $.ajax({
			            type: 'post',
			            data: { "member_idx": memberIdx,"start_date": null, 
			                "end_date": null},
			            url: 'AjaxSetAlarmEndServlet',
			            success: function (data) {
										            	
			            },
			            error: function (r, s, e) {
			                console.log("[에러] code: " + r.status + ", message: " + r.responseText + ", error: " + e);
			            }
			        });
			    }
			});
			
			
			// 협업참여자 나가기 버튼
			$(document).on("click", ".out_button", function () { 
				$(this).parent().toggleClass("on");
				$(this).parent().next().toggleClass("on");
				let self = $(this);
				let messageIdx = self.closest(".message_idx").attr("message_idx");
				let memberIdx = self.closest(".message_idx").attr("member_idx");
				$.ajax({
					type:'post',
					data: {"message_idx": messageIdx, "member_idx": memberIdx } ,
					url: 'AjaxOutMessageCooperationServlet',
					success: function(data){
						self.closest(".message_idx").find(".message_idx_last_profile[member_idx='" + memberIdx + "']").remove();
						self.closest(".message_idx").find(".show_cooperation .cooperation_profile[member_idx='" + memberIdx + "']").remove();
					},
					error: function(r,s,e) {
	        			console.log("[에러] code: " + r.status + ", message: " + r.responseText + ", error: " + e);
	        		}
				});  
				
			});
			// 협업참여자 참가 버튼
			$(document).on("click", ".in_button", function () {
				let self = $(this);
				let messageIdx = self.closest(".message_idx").attr("message_idx");
				let memberIdx = self.closest(".message_idx").attr("member_idx");
				$(this).parent().parent().find(".out").removeClass("on");
                $(this).parent().removeClass("on");
				$.ajax({
					type:'post',
					data: {"message_idx": messageIdx, "member_idx": memberIdx } ,
					url: 'AjaxInMessageCooperationServlet',
					success: function(data){
						if(data.profile == null){data.profile = "Unknown.png";}
						let str = '<div class="message_idx_last_profile" member_idx="' + memberIdx + '">' +
			              				'<img src="' + data.profile + '"/>' +
			          			  '</div>';
						self.closest(".message_idx").find(".message_cooperation_container").append(str);
						
						 let cooperationStr = '<div class="cooperation_profile" member_idx="' + memberIdx + '">' +
		                         '<img class="writer_profile_img" src="' + data.profile + '">' +
		                         '<div class="cooperation_name">' +
		                             '<span>' + data.nickname + '</span>' +
		                             '<i class="bi-x"></i>' +
		                         '</div>' +
		                       '</div>';
 						self.closest(".message_idx").find(".show_cooperation").prepend(cooperationStr);
					},
					error: function(r,s,e){alert("에러");}
				});
            });
			
			// 협업참여자 + 버튼
			$(".last_plus").click(function(event) { 
				$(this).next().find(".show_cooperation").css("display","flex");
				$(this).next().find(".assignmentOfmanager_list").css("display","block");
				event.stopPropagation();
			});
			$(document).click(function(event) {
		        // .last_plus와 그 자식 요소 외의 영역을 클릭하면 내용을 숨김
		        if (!$(event.target).closest('.last_plus').length) {
		            $(".show_cooperation").css("display", "none");
		            $(".assignmentOfmanager_list").css("display", "none");
		        }
		    });
			// 협업참여자 안에서 x 버튼
			$(document).on("click",".bi-x",function() { 
				let self = $(this);
				let messageIdx = self.closest(".message_idx").attr("message_idx"); 
				let memberIdx = self.closest(".cooperation_profile").attr("member_idx");
				let myMemberIdx = self.closest(".message_idx").attr("member_idx");
				let closestMessage = self.closest(".message_idx");
				$.ajax({
					type:'post',
					data:{"message_idx":messageIdx, "member_idx":memberIdx},
					url:'AjaxOutMessageCooperationServlet',
					success: function(data){
						self.closest(".message_idx").find(".message_idx_last_profile[member_idx='" + memberIdx + "']").remove();
						self.closest(".message_idx").find(".show_cooperation .cooperation_profile[member_idx='" + memberIdx + "']").remove();
						$(".show_cooperation").hide();
						$(".assignmentOfmanager_list").hide();
						if(memberIdx == myMemberIdx){
							console.log(self.closest(".message_idx"));
							closestMessage.find(".in").addClass("on");
							closestMessage.find(".out").addClass("on");
						}
					},
					error: function(r,s,e){
						console.log("[에러] code: " + r.status + ", message: " + r.responseText + ", error: " + e);
					}
				});
			});
			// 협업참여자 추가 후 프로필 넣기
			$(document).on("click",".assignmentOfmanager_list_select",function() { 
				$(".show_cooperation").hide();
				$(".assignmentOfmanager_list").hide();
				let self = $(this);
				let memberIdx = self.attr("member_idx");
				let myMemberIdx = self.closest(".message_idx").attr("member_idx");
				let messageIdx = self.closest(".message_idx").attr("message_idx");
				 let existingProfile = self.closest(".message_idx").find(".message_idx_last_profile[member_idx='" + memberIdx + "']");
				 if (existingProfile.length > 0) {
				        alert("이미 협업 참여 중입니다.");
				        return; 
				    }
				$.ajax({
					type: 'post',
					data: {"member_idx":memberIdx,"message_idx":messageIdx},
					url: 'AjaxInMessageCooperationServlet',
					success:function(data){
						if(data.profile == null){data.profile = "Unknown.png";}
						let str = '<div class="message_idx_last_profile" member_idx="' + memberIdx + '">' +
          							'<img src="' + data.profile + '"/>' +
      			 				 '</div>';
      			 		self.closest(".message_idx").find(".message_cooperation_container").append(str);
      			 		let cooperationStr = '<div class="cooperation_profile" member_idx="' + memberIdx + '">' +
		                        '<img class="writer_profile_img" src="' + data.profile + '">' +
		                        '<div class="cooperation_name">' +
		                            '<span>' + data.nickname + '</span>' +
		                            '<i class="bi-x"></i>' +
		                        '</div>' +
		                      '</div>';
						self.closest(".message_idx").find(".show_cooperation").prepend(cooperationStr);
						if(memberIdx == myMemberIdx) {
							console.log(self.closest(".message_idx"));
							self.closest(".message_idx").find(".in.on").removeClass("on");
							self.closest(".message_idx").find(".out.on").removeClass("on");
						}
					},
					error: function(r,s,e){
						alert("에러");
					}
				});
			});
			// 메시지 아래 화살표 클릭시 메시지 편집 div 노출
			$(document).on("click",".message_edit",function() { 
				$(this).next().toggle();
			});
			// 메시지 편집 클릭시 편집박스 노출, 메시지 편집 텍스트 숨기기
			$(document).on("click",".edit_text",function() { // 댓글
				$(this).closest(".comments").find(".message_edit_content").show();
				$(this).parent().hide();
				/* $(this).parent().parent().parent().find(".fileDown_message_content").hide(); */
			});
			
			$(document).on("click",".message_edit_box.m",function() {  // 내용
				$(this).parent().parent().parent().find(".message_edit_content.m").show();
				$(this).hide();
				
			});
			// 댓글 삭제 클릭시
			
			$(document).on("click",".edit_delete_comment",function() { 
				let yn = confirm("정말로 삭제하시겠습니까?");
				$(this).parent().hide();
				let messageIdx = $(this).closest(".message_idx").attr("message_idx");
				let commentIdx = $(this).closest(".comments").attr("comment_idx");
				 $.ajax({
					type: 'post',
					data: {"comment_idx":commentIdx},
					url: 'AjaxDeleteCommentServlet',
					success: function(data){
						if(yn){
						$(".comments[comment_idx='" + commentIdx + "']").hide();
						} else {
							$(this).parent().hide();
						}
					},
					error: function(r,s,e){
						console.log("[에러] code: " + r.status + ", message: " + r.responseText + ", error: " + e);
					}
				});
			});
			// 취소 눌렀을 때
			$(document).on("click",".cancel_bt button",function() { 
				$(this).closest(".message_edit_content").hide();
			});
			// 저장 눌렀을 때(메시지 내용)
			$(document).on("click",".save_bt.m button",function() { 
				$(this).closest(".message_edit_content").hide();
				let messageContent = $(this).closest(".message_idx").find("#textarea_edit").val();
				let messageIdx = $(this).closest(".message_idx").attr("message_idx");
				console.log(messageContent);
				$.ajax({
					type:'post',
					data:{"message_idx":messageIdx, "content":messageContent},
					url: 'AjaxMessageContentUpdateServlet',
					success: function(data){
				        $(".message_idx[message_idx='" + messageIdx + "'] .fileDown_message_content").text(messageContent);
					},
					error: function(r,s,e){
						console.log("[에러] code: " + r.status + ", message: " + r.responseText + ", error: " + e);
					}
				});
			});
			// 저장 눌렀을 때(메시지 댓글)
			$(document).on("click",".save_bt.c button",function() { 
				$(this).closest(".message_edit_content").hide();
				let messageComment = $(this).closest(".comments").find("#textarea_edit").val();
				let commentIdx = $(this).closest(".comments").attr("comment_idx");
				console.log(commentIdx);
				$.ajax({
					type: 'post',
					data: {"comment":messageComment, "comment_idx":commentIdx},
					url: 'AjaxMessageCommentUpdateServlet',
					success: function(data){
							$(".comments[comment_idx='" + commentIdx + "'] .comments_span").text(messageComment);
					},
					error: function(r,s,e){
						console.log("[에러] code: " + r.status + ", message: " + r.responseText + ", error: " + e);
					}
				})
			});
			 // 파일 x 버튼 눌렀을 때
			$(".bi-x-lg").click(function() {
				$(".file_full").css("display","flex");
				messageNum = $(this).closest(".message_idx").attr("message_idx");
			});
			// 삭제 버튼 눌렀을 때
			$(".file_delete").click(function() { 
				$(".file_full").hide();
				console.log(messageNum);
				$.ajax({
					type: 'post',
					data: {'message_idx':messageNum},
					url: 'AjaxDeleteFileServlet',
					success: function(data){ // 서버에서 보내는 JSON 확인
			        if(data.result == 1) {
			        	$(".img_hide[message_idx='" + messageNum + "']").remove();
			        } else {
			            alert("파일 삭제 실패");
			        }
			    },
					error: function(r,s,e){alert("에러");}
				});
			});
			// 취소 버튼 눌렀을 때
			$(".file_cancel").click(function() { 
				$(".file_full").hide();
			});
			// 부재중 시작
			$("#profile_setting_main").mouseenter(function(){
				let startDate = $("#start_date").val();
				let endDate = $("#end_date").val();
				if(startDate>endDate){
					$(".deadline_red_span").css('display','block');
				}else if (startDate<=endDate){
					$(".deadline_red_span").css('display','none');
				}
			});
		 	// 메시지 제목 변경
			   $('.title input').on('blur', function() {
				let messageIdx = $(this).closest(".message_idx").attr("message_idx");
				let title = $(this).val();
				console.log(title);
				console.log(messageIdx);
				$.ajax({
					type:'post',
					data: {"message_idx":messageIdx,"title":title},
					url: 'AjaxUpdateMessageTitleServlet',
					success: function(data){},
					error: function(r,s,e){
						console.log("[에러] code: " + r.status + ", message: " + r.responseText + ", error: " + e);
					}
				});
			});  
		 	
		}); 
		$(document).ready(function () {
		    // 페이지 로드 시 참여 여부를 확인하여 버튼 상태 설정
		    $(".message_idx").each(function () {
		        let self = $(this); // 현재 요소를 참조
		        let messageIdx = self.attr("message_idx");
		        let memberIdx = self.attr("member_idx");

		        $.ajax({
		            type: 'post',
		            data: { "message_idx": messageIdx, "member_idx": memberIdx },
		            url: 'AjaxCheckMessageCooperationServlet',
		            success: function (data) {
		                if (data.result == 1) { 
		                    // 참여 중인 경우: 나가기 버튼 표시
		                    self.find(".out").removeClass("on");
		                    self.find(".in").removeClass("on");
		                } else {
		                    // 참여 중이 아닌 경우: 참가 버튼 표시
		                    self.find(".in").addClass("on");
		                    self.find(".out").addClass("on");
		                }
		            },
		            error: function (r, s, e) {
		                console.log("[에러] code: " + r.status + ", message: " + r.responseText + ", error: " + e);
		            }
		        });
		    });
		});
		// 화면에서 메시지 내용 좋아요가 0이면 안 보이게 하기
		$(document).ready(function() {
			$(".message_idx").each(function() {
				 let messageIdx = $(this).closest(".message_idx").attr("message_idx"); 
				 let this_ = $(this);
				 $.ajax({
					 type: 'post',
					 data: {"message_idx":messageIdx},
					 url: 'AjaxMessageLikeCountServlet',
					 success: function(data){
						 if(data.likeCount == 0) {
							 this_.closest(".message_idx").find(".likes_count.m").text(data.likeCount).hide();
						 }
					 },
					 error: function(r,s,e){
						 console.log("[에러] code: " + r.status + ", message: " + r.responseText + ", error: " + e);
					 }
				 });
			});
		});
		// 화면에서 메시지 댓글 좋아요가 0이면 안 보이게 하기
		$(document).ready(function() {
			$(".comments").each(function() {
				 let commentIdx = $(this).closest(".comments").attr("comment_idx"); 
				 let this_ = $(this);
				 $.ajax({
					 type: 'post',
					 data: {"comment_idx":commentIdx},
					 url: 'AjaxCommentLikeCountServlet',
					 success: function(data){
						 if(data.likeCount == 0) {
							 this_.closest(".comments").find(".likes_count").hide(); //.text(data.likeCount).hide()
						 }
					 },
					 error: function(r,s,e){
						 console.log("[에러] code: " + r.status + ", message: " + r.responseText + ", error: " + e);
					 }
				 });
			});
		});
		
		$(document).ready(function() {
		    $(".message_idx").each(function() {
				let memberIdx = $(this).closest(".message_idx").attr("member_idx");
		        let messageIdx = $(this).closest(".message_idx").attr("message_idx");
			
		        // 서버에 메시지 내용 좋아요 여부 확인
		        $.ajax({
		            type: 'post',
		            url: 'AjaxMessageLikeCheckServlet',
		            data: { "message_idx": messageIdx, "member_idx": memberIdx },
		            success: function (data) {
		                if (data.result == 1) {
		                    // 메시지 내용이 좋아요가 눌린 상태라면 on 클래스 추가
		                    $(".message_idx[message_idx='" + messageIdx + "'] .bi-hand-thumbs-up-fill.m").addClass('on');
		                }
		            },
		            error: function (r, s, e) {
		                console.log("[에러] code: " + r.status + ", message: " + r.responseText + ", error: " + e);
		            }
		        });
		    });
		    $(".comments").each(function() {
		    	let memberIdx = $(this).attr("member_idx");
		    	let commentIdx = $(this).attr("comment_idx");
		    	
		    	// 서버에 댓글 내용 좋아요 여부 확인
		    	$.ajax({
		    		type: 'post',
		    		data: {"member_idx":memberIdx, "comment_idx":commentIdx},
		    		url: 'AjaxCommentLikeCheckServlet',
		    		success: function(data){
		    			if(data.result == 1) {
		    				// 댓글 좋아요가 눌린 상태라면 on 클래스 추가
		    				$(".comments[comment_idx='" + commentIdx + "'] .bi-hand-thumbs-up-fill.c").addClass('on');
		    			}
		    		},
		    		error: function(r,s,e){
		    			console.log("[에러] code: " + r.status + ", message: " + r.responseText + ", error: " + e);
		    		}
		    	});
		    });
		});
		// 전송 버튼 클릭 시 유효성 체크 하는 펑션
		function message_content_check(){
			let title = $(".title_size").val();
			let content = $("#textarea").val();
			if(content.length>0 && title.length>0){
				return true;
			}
		};
		// 댓글 유효성 체크
		function message_comment_check(message_idx){
			let content = $(".message_idx[message_idx='"+message_idx+"']").find(".textarea_message").val();  // .(".textarea_message")
			if(content.length>0){
				return true;
			}
		};
		$(document).ready(function () {
		    // 파일 선택 시 이미지 미리보기
		    $("#file1").on("change", handleImgFileSelect);

		    // 업로드 버튼 클릭 이벤트 핸들러
		    $("#btn_submit").on("click", fn_submit);
		});

		// 이미지 미리보기
		function handleImgFileSelect(e) {
		    var file = e.target.files[0];
		    var reg = /(.*?)\.(jpg|jpeg|png|bmp)$/i;

		    if (!file.name.match(reg)) {
		        alert("이미지 파일 형식만 가능합니다 (jpg, jpeg, png, bmp).");
		        return;
		    }

		    var reader = new FileReader();
		    reader.onload = function (e) {
		        // 선택된 파일을 #profileImage에 표시
		        $("#profileImage").attr("src", e.target.result);
		    };
		    reader.readAsDataURL(file);
		}

		// 파일 업로드
		function fn_submit() {
		    var file = $("#file1")[0].files[0];
		    if (!file) {
		        alert("업로드할 파일을 선택해주세요.");
		        return;
		    }

		    var form = new FormData();
		    form.append("file1", file);

		    $.ajax({
		        url: "ExAjaxFile",
		        type: "POST",
		        processData: false,
		        contentType: false,
		        data: form,
		        success: function (data) {
		            var uploadUrl = data.result; // 서버에서 반환한 업로드된 파일 URL
		            console.log("업로드된 파일 URL:", uploadUrl);

		            // 두 번째 AJAX 요청: 프로필 업데이트
		            $.ajax({
		                url: "AjaxUpdateProfileServlet",
		                type: "POST",
		                data: {
		                    url: uploadUrl,
		                    memberIdx: ${memberIdx}, // 서버로 전달할 회원 ID
		                },
		                success: function (data) {
		                    console.log("프로필 업데이트 성공:", data.result);
		                    alert("이미지 변경 완료");
		                },
		                error: function (jqXHR) {
		                    alert("프로필 업데이트 실패: " + jqXHR.responseText);
		                },
		            });
		        },
		        error: function (jqXHR) {
		            alert("파일 업로드 실패: " + jqXHR.responseText);
		        },
		    });
		};
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
<!--------------------------------------- 메시지 내용(파일)삭제 팝업창 -------------------------------------------->
<div class="content_back_msg_cancle">
	<div class="file_full">
		<div id="content">
			<div class="top">
				<div class="top_span">
				  <span>정말 진행하시겠어요?</span>
				</div>
					<div class="icon_x">
				  		<svg class="icon_x_svg2" viewBox="0 0 32 32" aria-hidden="true" focusable="false"><path d="M18.1,16L27,7.1c0.6-0.6,0.6-1.5,0-2.1s-1.5-0.6-2.1,0L16,13.9l-8.9-9C6.5,4.3,5.6,4.3,5,4.9S4.4,6.4,5,7l8.9,8.9L5,24.8c-0.6,0.6-0.6,1.5,0,2.1c0.3,0.3,0.7,0.4,1.1,0.4s0.8-0.1,1.1-0.4l8.9-8.9l8.9,8.9c0.3,0.3,0.7,0.4,1.1,0.4s0.8-0.1,1.1-0.4c0.6-0.6,0.6-1.5,0-2.1L18.1,16z"></path></svg>
				  	</div>
			</div>
			<div class="middle">
				<span>'파일 삭제'를 누르면 선택한 파일이 삭제됩니다.</span>
			</div>
			<div class="bottom">
				<div class="file_cancel">
				  	<button>취소</button>
				</div>
				<div class="file_delete" >
					<button>파일 삭제</button>
				</div>
			</div>
		</div>
	</div>
</div>
<!--------------------------------------- 메시지 내용(파일)삭제 팝업창 -------------------------------------------->

<!--메시지A 삭제 팝업창--><!--메시지A 삭제 팝업창--><!--메시지A 삭제 팝업창--><!--메시지A 삭제 팝업창--><!--메시지A 삭제 팝업창-->

<div class="content_back_msg_cancle">
	<div class="full2">
		<div id="content">
			<div class="top">
				<div class="top_span">
				  <span>정말 진행하시겠어요?</span>
				</div>
					<div class="icon_x">
				  		<svg class="icon_x_svg2" viewBox="0 0 32 32" aria-hidden="true" focusable="false"><path d="M18.1,16L27,7.1c0.6-0.6,0.6-1.5,0-2.1s-1.5-0.6-2.1,0L16,13.9l-8.9-9C6.5,4.3,5.6,4.3,5,4.9S4.4,6.4,5,7l8.9,8.9L5,24.8c-0.6,0.6-0.6,1.5,0,2.1c0.3,0.3,0.7,0.4,1.1,0.4s0.8-0.1,1.1-0.4l8.9-8.9l8.9,8.9c0.3,0.3,0.7,0.4,1.1,0.4s0.8-0.1,1.1-0.4c0.6-0.6,0.6-1.5,0-2.1L18.1,16z"></path></svg>
				  	</div>
			</div>
			<div class="middle">
				<span>'메시지 삭제'를 누르면 선택한 메시지가 삭제됩니다.</span>
			</div>
			<div class="bottom">
				<div class="cancel2">
				  	<button>취소</button>
				</div>
				<div class="delete2">
					<button>메시지 삭제</button>
				</div>
			</div>
		</div>
	</div>
</div>
<!--메시지A 삭제 팝업창--><!--메시지A 삭제 팝업창--><!--메시지A 삭제 팝업창--><!--메시지A 삭제 팝업창--><!--메시지A 삭제 팝업창-->
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



<!--프로필이미지 팝업창--><!--프로필이미지 팝업창--><!--프로필이미지 팝업창--><!--프로필이미지 팝업창--><!--프로필이미지 팝업창-->
<div class="me_button_popup">
	<div class="popup_profile">
		<div>
			<img class="popup_profile_img" src="${myProfile}"/>
		</div>
		<div>내 작업 공간</div>
		<div class="popup_email_font">${myEmail}</div>
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

			<div id="message_container">
				<div class="main_page">
					<div class="Topbar">
						<div class="Topbar_top">
							<div class="move">
								<div class="Topbar_tap_in">
								<div class="chiup"></div>
								<div class="chiup-inner">
									<svg class="MiniIcon" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
										<path d="M21,6h-8.4c-0.2,0-0.3,0-0.5-0.1c-0.1-0.1-0.3-0.2-0.4-0.3L9.8,2.5C9.8,2.3,9.6,2.2,9.5,2.1S9.2,2,9,2H1C0.7,2,0.5,2.1,0.3,2.3C0.1,2.5,0,2.7,0,3v16c0,1.7,1.3,3,3,3h18c1.7,0,3-1.3,3-3V9C24,7.3,22.7,6,21,6z M2,4h6.4l1.2,2H2V4L2,4L2,4z M22,19c0,0.6-0.4,1-1,1H3c-0.6,0-1-0.4-1-1V8h19c0.6,0,1,0.4,1,1V19z">
									</path>                   
								</svg>
								<div class="MiniIcon_text">
									<span>취업</span>
								</div>
								<svg class="Slash_MiniIcon" viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path d="M16.21 1.837a1.002 1.002 0 0 0-1.307.541L7.25 20.856a1.001 1.001 0 0 0 1.848.766l7.654-18.478a1.001 1.001 0 0 0-.54-1.307Z"></path></svg>
								</div>
								
								<div class="gaebal">
									<svg class="MiniIcon" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
										<path d="M21,6h-8.4c-0.2,0-0.3,0-0.5-0.1c-0.1-0.1-0.3-0.2-0.4-0.3L9.8,2.5C9.8,2.3,9.6,2.2,9.5,2.1S9.2,2,9,2H1C0.7,2,0.5,2.1,0.3,2.3C0.1,2.5,0,2.7,0,3v16c0,1.7,1.3,3,3,3h18c1.7,0,3-1.3,3-3V9C24,7.3,22.7,6,21,6z M2,4h6.4l1.2,2H2V4L2,4L2,4z M22,19c0,0.6-0.4,1-1,1H3c-0.6,0-1-0.4-1-1V8h19c0.6,0,1,0.4,1,1V19z">
									</path>                   
								</svg>
								<div class="MiniIcon_text">
									<span>개발</span>
								</div>
								<svg class="Slash_MiniIcon" viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path d="M16.21 1.837a1.002 1.002 0 0 0-1.307.541L7.25 20.856a1.001 1.001 0 0 0 1.848.766l7.654-18.478a1.001 1.001 0 0 0-.54-1.307Z"></path></svg>
								</div>
								</div>
								</div>
							</div>
							<div class="Topbar_middle">
								<img class="project" src="img/project.png"/>
								<div class="project_name">
									<input type="text" class="text_project_name" name="project_name" value="${projectName}"/>
								</div>
								<svg class="Icon_DownIcon" viewBox="0 0 32 32" aria-hidden="true" focusable="false"><path d="M27.874 11.036a1.5 1.5 0 0 0-2.113-.185L16 19.042l-9.761-8.191a1.5 1.5 0 1 0-1.928 2.298l10.726 9a1.498 1.498 0 0 0 1.928 0l10.726-9a1.5 1.5 0 0 0 .185-2.113h-.002Z"></path></svg>
								<svg class="Icon_StarIcon" viewBox="0 0 32 32" aria-hidden="true" focusable="false"><path d="M.608 11.301a2.161 2.161 0 0 0 .538 2.224l5.867 5.78-1.386 8.164c-.14.824.192 1.637.868 2.124a2.133 2.133 0 0 0 2.262.155l7.241-3.848 7.24 3.848a2.133 2.133 0 0 0 2.263-.155 2.155 2.155 0 0 0 .868-2.124l-1.386-8.164 5.867-5.78c.59-.582.797-1.434.538-2.224a2.146 2.146 0 0 0-1.734-1.466l-8.1-1.19-3.623-7.42A2.148 2.148 0 0 0 15.998 0c-.828 0-1.57.476-1.935 1.223L10.44 8.645l-8.1 1.19A2.145 2.145 0 0 0 .606 11.3h.002Zm2.025.512 9.143-1.342 4.086-8.37c.012-.023.044-.088.137-.088.093 0 .124.064.137.089l4.086 8.369 9.143 1.342c.023.003.093.014.125.11a.163.163 0 0 1-.042.178l-6.609 6.511 1.56 9.192a.16.16 0 0 1-.065.169c-.074.054-.129.023-.152.01l-8.181-4.346-8.181 4.347c-.022.013-.08.04-.152-.011a.159.159 0 0 1-.065-.17l1.56-9.19-6.61-6.512a.163.163 0 0 1-.041-.178c.032-.096.102-.106.125-.11h-.004Z"></path></svg>
								<div class="status_update">
								<div class="circle">
								</div>
								<span id="status_update_span">상태 설정</span>
								<div class="DownIcon">
								<svg class="ArrowDown" viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path d="m18.185 7.851-6.186 5.191-6.186-5.191a1.499 1.499 0 1 0-1.928 2.298l7.15 6a1.498 1.498 0 0 0 1.928 0l7.15-6a1.5 1.5 0 0 0-1.928-2.298Z"></path></svg>
								</div>
								
								<!--상태설정 체인지-->
								<div class="progress_change_green">
									<div class="green">
									<div class="green_circle">
										<svg class="status_green" viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path d="m20,12c0,4.42-3.58,8-8,8s-8-3.58-8-8S7.58,4,12,4s8,3.58,8,8Z"></path></svg>
									</div>
										<div class="green_span">
											<span>계획대로 진행 중</span>
										</div>
									</div>
								</div>
								<div class="progress_change_yellow">
									<div class="yellow">
									<div class="yellow_circle">
										<svg class="status_yellow" viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path d="m20,12c0,4.42-3.58,8-8,8s-8-3.58-8-8S7.58,4,12,4s8,3.58,8,8Z"></path></svg>
									</div>
									<div class="yellow_span">
										<span>위험함</span>
									</div>
									</div>
								</div>
								<div class="progress_change_red">
									<div class="red">
									<div class="red_circle">
										<svg class="status_red" viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path d="m20,12c0,4.42-3.58,8-8,8s-8-3.58-8-8S7.58,4,12,4s8,3.58,8,8Z"></path></svg>
									</div>
									<div class="red_span">
										<span>계획에서 벗어남</span>
									</div>
									</div>
								</div>
								<div class="progress_change_blue">
									<div class="blue">
									<div class="blue_circle">
										<svg class="status_blue" viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path d="m20,12c0,4.42-3.58,8-8,8s-8-3.58-8-8S7.58,4,12,4s8,3.58,8,8Z"></path></svg>
									</div>
									<div class="blue_span">
										<span>보류 중</span>
									</div>
									</div>
								</div>
								<div class="progress_change_complete">
									<div class="check">
									<div class="complete">
										<svg class="check_icon" viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path d="M19.439 5.439 8 16.878l-3.939-3.939A1.5 1.5 0 1 0 1.94 15.06l5 5c.293.293.677.439 1.061.439.384 0 .768-.146 1.061-.439l12.5-12.5a1.5 1.5 0 1 0-2.121-2.121h-.002Z"></path></svg>
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
											<svg class="status_green" viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path d="m20,12c0,4.42-3.58,8-8,8s-8-3.58-8-8S7.58,4,12,4s8,3.58,8,8Z"></path></svg>
										</div>
											<div class="green_span">
												<span>계획대로 진행 중</span>
											</div>
										</div>
									</div>
									<div class="progress_yellow">
										<div class="yellow">
										<div class="yellow_circle">
											<svg class="status_yellow" viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path d="m20,12c0,4.42-3.58,8-8,8s-8-3.58-8-8S7.58,4,12,4s8,3.58,8,8Z"></path></svg>
										</div>
										<div class="yellow_span">
											<span>위험함</span>
										</div>
										</div>
									</div>
									<div class="progress_red">
										<div class="red">
										<div class="red_circle">
											<svg class="status_red" viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path d="m20,12c0,4.42-3.58,8-8,8s-8-3.58-8-8S7.58,4,12,4s8,3.58,8,8Z"></path></svg>
										</div>
										<div class="red_span">
											<span>계획에서 벗어남</span>
										</div>
										</div>
									</div>
									<div class="progress_blue">
										<div class="blue">
										<div class="blue_circle">
											<svg class="status_blue" viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path d="m20,12c0,4.42-3.58,8-8,8s-8-3.58-8-8S7.58,4,12,4s8,3.58,8,8Z"></path></svg>
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
											<svg class="check_icon" viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path d="M19.439 5.439 8 16.878l-3.939-3.939A1.5 1.5 0 1 0 1.94 15.06l5 5c.293.293.677.439 1.061.439.384 0 .768-.146 1.061-.439l12.5-12.5a1.5 1.5 0 1 0-2.121-2.121h-.002Z"></path></svg>
										</div>
										<div class="complete_span">
											<span>완료</span>
										</div>
										</div>
									</div>
									</div>
								</div>
								</div>
							</div>
							<div class="Topbar_bottom">
								<div class="Topbar_bottom_move">
								<div class="Topbar_bottom_div">
									<svg class="MiniIcon--small MiniIcon ObjectTabNavigationBarItemWithMenu-icon ProjectMiniIcon" aria-current="false" viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path d="M 18 2 h -2 c 0 -1.1 -0.9 -2 -2 -2 h -4 C 8.9 0 8 0.9 8 2 H 6 C 3.8 2 2 3.8 2 6 v 14 c 0 2.2 1.8 4 4 4 h 12 c 2.2 0 4 -1.8 4 -4 V 6 C 22 3.8 20.2 2 18 2 Z M 10 2 h 4 l 0 1 c 0 0 0 0 0 0 s 0 0 0 0 l 0 1 h -4 V 2 Z M 20 20 c 0 1.1 -0.9 2 -2 2 H 6 c -1.1 0 -2 -0.9 -2 -2 V 6 c 0 -1.1 0.9 -2 2 -2 h 2 c 0 1.1 0.9 2 2 2 h 4 c 1.1 0 2 -0.9 2 -2 h 2 c 1.1 0 2 0.9 2 2 V 20 Z M 17 11 c 0 0.6 -0.4 1 -1 1 h -3.5 c -0.6 0 -1 -0.4 -1 -1 s 0.4 -1 1 -1 H 16 C 16.6 10 17 10.4 17 11 Z M 17 15 c 0 0.6 -0.4 1 -1 1 h -3.5 c -0.6 0 -1 -0.4 -1 -1 s 0.4 -1 1 -1 H 16 C 16.6 14 17 14.4 17 15 Z M 10 11 c 0 0.8 -0.7 1.5 -1.5 1.5 S 7 11.8 7 11 s 0.7 -1.5 1.5 -1.5 S 10 10.2 10 11 Z M 10 15 c 0 0.8 -0.7 1.5 -1.5 1.5 S 7 15.8 7 15 s 0.7 -1.5 1.5 -1.5 S 10 14.2 10 15 Z"></path></svg>
									<span class="over_view_button">개요</span>
								</div>
								<div class="Topbar_bottom_div">
									<svg class="MiniIcon--small MiniIcon ObjectTabNavigationBarItemWithMenu-icon ListViewMiniIcon" aria-current="false" viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path d="M5 2H3C1.346 2 0 3.346 0 5v2c0 1.654 1.346 3 3 3h2c1.654 0 3-1.346 3-3V5c0-1.654-1.346-3-3-3Zm1 5c0 .551-.448 1-1 1H3c-.552 0-1-.449-1-1V5c0-.551.448-1 1-1h2c.552 0 1 .449 1 1v2Zm-1 7H3c-1.654 0-3 1.346-3 3v2c0 1.654 1.346 3 3 3h2c1.654 0 3-1.346 3-3v-2c0-1.654-1.346-3-3-3Zm1 5c0 .551-.448 1-1 1H3c-.552 0-1-.449-1-1v-2c0-.551.448-1 1-1h2c.552 0 1 .449 1 1v2Zm4-13a1 1 0 0 1 1-1h12a1 1 0 1 1 0 2H11a1 1 0 0 1-1-1Zm14 12a1 1 0 0 1-1 1H11a1 1 0 1 1 0-2h12a1 1 0 0 1 1 1Z"></path></svg>
									<span class="list_view_button">목록</span>
								</div>
								<div class="Topbar_bottom_div">
									<svg class="MiniIcon--small MiniIcon ObjectTabNavigationBarItemWithMenu-icon BoardMiniIcon" aria-current="false" viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path d="M21,2h-4h-2H9H7H3C1.3,2,0,3.3,0,5v10c0,1.7,1.3,3,3,3h4v1c0,1.7,1.3,3,3,3h4c1.7,0,3-1.3,3-3v-3h4c1.7,0,3-1.3,3-3V5  C24,3.3,22.7,2,21,2z M3,16c-0.6,0-1-0.4-1-1V5c0-0.6,0.4-1,1-1h4v12H3z M15,19c0,0.6-0.4,1-1,1h-4c-0.6,0-1-0.4-1-1v-0.9V4h6v12.2  V19z M22,13c0,0.6-0.4,1-1,1h-4V4h4c0.6,0,1,0.4,1,1V13z"></path></svg>
									<span class="board_view_button">보드</span>
								</div>
								<div class="Topbar_bottom_div">
									<svg class="MiniIcon--small MiniIcon ObjectTabNavigationBarItemWithMenu-icon CommentMiniIcon" aria-current="true" viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path d="M14 22c5.514 0 10-4.486 10-10S19.514 2 14 2h-4C4.486 2 0 6.486 0 12a9.993 9.993 0 0 0 3.655 7.729l.365 2.554a2 2 0 0 0 3.393 1.133l1.417-1.413L14.001 22H14Zm-6-1.995L6 22l-.482-3.374A8 8 0 0 1 10 4h4a8 8 0 0 1 0 16l-6 .005Z"></path></svg>
									<span class="message_view_button">메시지</span>
								</div>
								<div class="Topbar_bottom_div" style="margin-left:10px;">
									<svg class="MiniIcon--small MiniIcon ObjectTabNavigationBarItemWithMenu-icon AttachVerticalMiniIcon" aria-current="false" viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path d="M14,24C10.7,24,8,21.3,8,18V8C8,5.8,9.8,4,12,4C14.2,4,16,5.8,16,8V16.9C16,17.5,15.6,17.9,15,17.9C14.4,17.9,14,17.5,14,16.9V8C14,6.9,13.1,6,12,6C10.9,6,10,6.9,10,8V18C10,20.2,11.8,22,14,22C16.2,22,18,20.2,18,18V8C18,4.7,15.3,2,12,2C8.7,2,6,4.7,6,8V13C6,13.6,5.6,14,5,14C4.4,14,4,13.6,4,13V8C4,3.6,7.6,0,12,0C16.4,0,20,3.6,20,8V18C20,21.3,17.3,24,14,24Z"></path></svg>
									<span class="file_view_button">파일</span>
								</div>
								<div class="Topbar_bottom_div">
									<svg class="MiniIcon--small MiniIcon ObjectTabNavigationBarItemWithMenu-icon DocumentMiniIcon" aria-current="false" viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path d="M5.998 24h12c2.206 0 4-1.794 4-4V9.683a3.984 3.984 0 0 0-1.075-2.729L15.62 1.271A4 4 0 0 0 13.321.065.999.999 0 0 0 12.998 0c-.037 0-.068.017-.103.021-.067-.003-.133-.021-.2-.021H6C3.793 0 2 1.794 2 4v16c0 2.206 1.793 4 4 4Zm8-21.502c.053.046.11.086.158.138l5.008 5.365h-3.69c-.814 0-1.476-.648-1.476-1.444V2.498ZM3.998 4c0-1.103.897-2 2-2h6v4.556c0 1.899 1.56 3.444 3.475 3.444h4.525v10c0 1.103-.897 2-2 2h-12c-1.103 0-2-.897-2-2V4Z"></path></svg>
									<span class="memo_view_button">메모</span>
								</div>
							</div>
							</div>
					</div>
						
						<div class="message_view">
							<div class="message_send">
								<img src="${myProfile}"/>
								<div class="message_send_click">
									<div class="send">
									<span>멤버에게 메시지 보내기</span>
								</div>
								</div>
							</div>
<!------------------------------------------------- 메시지내용 ------------------------------------------------->
<%for(MessageDto dto : listMessages) { String profile = dto.getMemberDto().getProfileImg();%>
<%if(profile == null){profile = "Unknown.png";} %>
	<%if(dto.getdeleteCheck()==0) { %>
							<div class="message_idx" message_idx="<%=dto.getMessageIdx()%>" member_idx="${memberIdx}" writer_idx="<%=dto.getWriterIdx()%>">
								<div class="message_idx_top">
									<svg class="ColorFillIcon" viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path d="M10.4,4h3.2c2.2,0,3,0.2,3.9,0.7c0.8,0.4,1.5,1.1,1.9,1.9s0.7,1.6,0.7,3.9v3.2c0,2.2-0.2,3-0.7,3.9c-0.4,0.8-1.1,1.5-1.9,1.9s-1.6,0.7-3.9,0.7h-3.2c-2.2,0-3-0.2-3.9-0.7c-0.8-0.4-1.5-1.1-1.9-1.9c-0.4-1-0.6-1.8-0.6-4v-3.2c0-2.2,0.2-3,0.7-3.9C5.1,5.7,5.8,5,6.6,4.6C7.4,4.2,8.2,4,10.4,4z"></path></svg>
									<div class="message_idx_top_span">
									<span><%=dto.getProjectDto().getName() %></span>
								</div>
								<div class="top_img">
								<%if(dto.getWriterIdx() == memberIdx) { %>
								<div class="top_img3">
									<i class="bi-trash "data-message-idx="<%= dto.getMessageIdx() %>"></i>
								</div>
								<%} %>
								</div>  
								</div>
								<div class="message_idx_mid">
									<div class="title">
										<input type="text" value="<%=dto.getTitle() %>" placeholder="제목 입력" name="message_title" id="message_title"/>
									</div>
									<div class="start_date">
									<img class="writer_profile_img" src="<%=profile%>"/>
									<div class="writer_profile_button">
									<button><%=dto.getMemberDto().getNickname()%></button>
									</div>
									<div class="when">
									<!-- <span> 님이 시작한 날짜: 4일 전</span> -->
									<span>님이 시작한 날짜: <%=dto.getwriteDate() %></span>
									</div>
									</div>
									<div class="message_content">
									<div style="position:relative;">
									<img class="message_content_profile" src="<%=profile%>" />
									<div class="message_content_name"><span class="message_comments_writer"><%=dto.getMemberDto().getNickname() %></span>
										<span style="font-size: 12px; color: gray; margin-top: 2px; margin-left: 5px;"><li><%=dto.getwriteDate() %><!-- 4일 전 --></li></span>
										<div class="likes_count m">
											<span><%=likeDao.CountMessageLikeDto(dto.getMessageIdx()) %></span>
										</div>
										<i class="bi-hand-thumbs-up-fill m"></i>
										<%if(dto.getWriterIdx() == memberIdx) { %>
										<div class="message_edit"> 
												<svg class="ArrowDownMiniIcon" viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path d="m18.185 7.851-6.186 5.191-6.186-5.191a1.499 1.499 0 1 0-1.928 2.298l7.15 6a1.498 1.498 0 0 0 1.928 0l7.15-6a1.5 1.5 0 0 0-1.928-2.298Z"></path></svg>
											</div>
										<%} %>
											<div class="message_edit_box m">
												<div class="edit_text">
													<span style="margin-left: 8px;">메시지 편집</span>
												</div>
											</div> 
									</div>
									</div>
									<%if(dto.getFileDto().getName() != null){%>
									<div class="img_hide" message_idx="<%=dto.getMessageIdx() %>">
									<%if(dto.getWriterIdx() == memberIdx) { %>
									<div class="img_delete">
									<i class="bi-x-lg"></i>
									</div>
									<%} %>
									<div>
										<img style="width: 483px; height: 457px; margin-left: 45px;" src="img/<%=dto.getFileDto().getName()%>">
									</div>
									</div>
									<%} %>
									<div class="fileDown_message_content" message_idx="">
										<span><%=dto.getContent()%></span>
									</div>
									<div class="message_edit_content m"> <!--메시지 수정  -->
										<textarea id="textarea_edit" placeholder="메시지 수정"><%=dto.getContent() %></textarea>
										<div class="message_edit_buttons">
										<div class="cancel_bt">
										<button>취소</button>
										</div>
										<div class="save_bt m">
											<button>변경 사항 저장</button>
										</div>
										</div>
									</div> 
									
									
<!----------------------------- 댓글 ------------------------------------------>
<div class="comments_list">
<%for(CommentsDto cdto : dto.getListReply()) {String cProfile = cdto.getMemberDto().getProfileImg();%>
<%if(cProfile == null){cProfile = "img/Unknown.png";} %>
								<div class="comments" comment_idx = "<%=cdto.getCommentIdx()%>" writer_idx = "<%=cdto.getMemberIdx()%>" member_idx = "${memberIdx}">
									<div class="comments_header">
									<div class="comments_profile">
										<img src="<%=cProfile%>"/>
									</div>
									<div class="comments_nickname">
										<span><%=cdto.getMemberDto().getNickname() %></span>
									</div>
									<div class="comments_writedate">
										<li><%=cdto.getWriteDate() %></li>
									</div>
									<div class="likes_count">
									<span><%=likeDao.CountMessageCommentsLikeDto(cdto.getCommentIdx()) %></span>
									</div>
									<i class="bi-hand-thumbs-up-fill c"></i>
									<%if(cdto.getMemberIdx() == memberIdx || dto.getWriterIdx() == memberIdx) { %>
									<div class="message_edit"> 
												<svg class="ArrowDownMiniIcon" viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path d="m18.185 7.851-6.186 5.191-6.186-5.191a1.499 1.499 0 1 0-1.928 2.298l7.15 6a1.498 1.498 0 0 0 1.928 0l7.15-6a1.5 1.5 0 0 0-1.928-2.298Z"></path></svg>
									</div>
									<%} %>
									<div class="message_edit_box c">
									<%if(cdto.getMemberIdx() == memberIdx) {%>
												<div class="edit_text">
													<span style="margin-left: 8px;">댓글 편집</span>
												</div>
									<%} %>
									<%if(cdto.getMemberIdx() == memberIdx || dto.getWriterIdx() == memberIdx) { %>
												<div class="edit_delete_comment">
													<span style="margin-left: 8px;">댓글 삭제</span>
												</div>
									<%} %>
											</div> 
									</div>
									<div class="comments_span">
										<%=cdto.getContent()%>
									</div>
									<div class="message_edit_content"> <!--메시지 수정  -->
										<textarea id="textarea_edit" placeholder="메시지 수정"><%=cdto.getContent() %></textarea>
										<div class="message_edit_buttons">
										<div class="cancel_bt">
										<button>취소</button>
										</div>
										<div class="save_bt c">
											<button>변경 사항 저장</button>
										</div>
										</div>
									</div> 
								</div>
<%} %>
</div>
<!-------------------------------- 댓글 ---------------------------------------------->
									</div>
							</div>
								<div class="message_idx_bottom">
									<img class="message_bottom_profile" src="${myProfile}"/>
									<textarea class="textarea_message" placeholder="메시지에 답장하기..." rows="7" cols="64"></textarea>
									<button class="textarea_message_btn" onclick="return message_comment_check(<%=dto.getMessageIdx()%>);">보내기</button>
								<div class="last_bottom">
									<div class="cooperation">
								<span>협업 참여자</span>
							</div>
							<div class="message_cooperation_container">
							<%ArrayList<MessageCooperationDto> listMessageCooperation = mcDao.getMessageCooperationDto(dto.getMessageIdx());%>
							<%for(MessageCooperationDto mcDto : listMessageCooperation) { 
								String mcProfile = mcDto.getMemberDto().getProfileImg();
								if(mcProfile==null){mcProfile = "Unknown.png";}
							%>
								<div class="message_idx_last_profile" member_idx="<%=mcDto.getMemberDto().getMemberIdx()%>">
								<img src="<%=mcProfile%>"/>
								</div>
								<%} %>
								</div>
								<%if(dto.getWriterIdx() == memberIdx) {%>
								<div class="last_plus">
									<svg viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path d="M10,10V4c0-1.1,0.9-2,2-2s2,0.9,2,2v6h6c1.1,0,2,0.9,2,2s-0.9,2-2,2h-6v6c0,1.1-0.9,2-2,2s-2-0.9-2-2v-6H4c-1.1,0-2-0.9-2-2s0.9-2,2-2H10z"></path></svg>
								</div>	
								<%} %>
								
								<div>
									<!--------------------------- 협업참여자 text --------------------------->
									<div class="show_cooperation">
									<%for(MessageCooperationDto mcDto : listMessageCooperation) {String mcProfile = mcDto.getMemberDto().getProfileImg();%>
									<%if(mcProfile == null){mcProfile="Unknown.png";} %>
										<div class="cooperation_profile" member_idx="<%=mcDto.getMemberDto().getMemberIdx()%>">
											<img class="writer_profile_img" src="<%=mcProfile%>">
											<div class="cooperation_name">
											<span><%=mcDto.getMemberDto().getNickname() %></span>
											<i class="bi-x"></i>
											</div>
										</div>
										<%} %>
										<input type="text" name="cooperation" id="plus_cooperation"/>
									</div>	
									<!--------------------------- 협업참여자 text --------------------------->
									<!------------------------------- 초대 멤버 조회 ------------------------->
									<div class="assignmentOfmanager_list">
									<% 
									for(MyWorkspaceDto mdto : listMyWorkspace){ String mwProfile = mdto.getMemberDto().getProfileImg();
									if(mwProfile == null){mwProfile = "Unknown.png";}
									%>
										<div class="assignmentOfmanager_list_select" member_idx="<%=mdto.getMemberDto().getMemberIdx()%>">
										<img src="<%=mwProfile%>">
										<div class="assignmentOfmanager_list_select_memberName"><%=mdto.getMemberDto().getNickname() %></div>
										<div class="assignmentOfmanager_list_select_memberEmail"><%=mdto.getMemberDto().getEmail() %></div>
										</div>
										<% } %>										
									</div>
									<!------------------------------- 초대 멤버 조회 ------------------------->
								</div>

								<div class="out">
									<div class="out_bell">
									<svg viewBox="0 0 32 32" aria-hidden="true" focusable="false"><path d="M2.03 20.635A5.87 5.87 0 0 0 4 16.249V12c0-3.247 1.276-6.288 3.593-8.563C9.909 1.164 12.962-.064 16.224.002 22.717.121 28 5.667 28 12.365v3.884c0 1.675.718 3.273 1.97 4.386 1.047.932 1.33 2.411.704 3.682C30.17 25.339 29.061 26 27.85 26H4.152c-1.211 0-2.32-.661-2.824-1.684-.626-1.271-.344-2.75.704-3.682l-.002.001ZM16 31a5.51 5.51 0 0 0 4.392-2.196c.248-.328.004-.804-.407-.804h-7.969c-.411 0-.655.476-.407.804A5.508 5.508 0 0 0 16 31Z"></path></svg>
									</div>
									<div class="out_button">
									<button>나가기</button>
									</div>
								</div>
								<div class="in">
									<div class="in_bell">
										<svg viewBox="0 0 32 32" aria-hidden="true" focusable="false"><path d="M11.608 28.804c-.248-.328-.004-.804.407-.804h7.969c.411 0 .655.476.407.804A5.51 5.51 0 0 1 15.999 31a5.51 5.51 0 0 1-4.392-2.196h.001ZM28 12.365v3.884c0 1.675.718 3.273 1.97 4.386 1.047.932 1.33 2.411.704 3.682C30.17 25.339 29.061 26 27.85 26H4.152c-1.211 0-2.32-.661-2.824-1.684-.626-1.271-.344-2.75.704-3.682a5.87 5.87 0 0 0 1.97-4.386v-4.249c0-3.247 1.276-6.288 3.593-8.563A11.893 11.893 0 0 1 16.224.002C22.717.121 28 5.667 28 12.365Zm-2 3.884v-3.884c0-5.615-4.402-10.264-9.812-10.363a9.93 9.93 0 0 0-7.194 2.862A9.926 9.926 0 0 0 6 12v4.249a7.872 7.872 0 0 1-2.641 5.881 1.081 1.081 0 0 0-.239 1.302c.167.34.582.568 1.03.568h23.698c.449 0 .863-.228 1.03-.567a1.081 1.081 0 0 0-.239-1.303 7.876 7.876 0 0 1-2.641-5.881H26Z"></path></svg>
									</div>
									<div class="in_button">
										<button>참가</button>
									</div>
								</div>
							</div>
						</div>
						</div>
						<%} %>
<%} %>

						
<!--미니메시지 닫기팝업--><!--미니메시지 닫기팝업--><!--미니메시지 닫기팝업--><!--미니메시지 닫기팝업--><!--미니메시지 닫기팝업-->
<div id="full">
    <div class="content_back"></div>
		<div id="content">
            <div class="top">
                <div class="top_span">
                <span>정말 진행하시겠어요?</span>
                </div>
                <div class="icon_x">
                <svg class="icon_x_svg" viewBox="0 0 32 32" aria-hidden="true" focusable="false"><path d="M18.1,16L27,7.1c0.6-0.6,0.6-1.5,0-2.1s-1.5-0.6-2.1,0L16,13.9l-8.9-9C6.5,4.3,5.6,4.3,5,4.9S4.4,6.4,5,7l8.9,8.9L5,24.8c-0.6,0.6-0.6,1.5,0,2.1c0.3,0.3,0.7,0.4,1.1,0.4s0.8-0.1,1.1-0.4l8.9-8.9l8.9,8.9c0.3,0.3,0.7,0.4,1.1,0.4s0.8-0.1,1.1-0.4c0.6-0.6,0.6-1.5,0-2.1L18.1,16z"></path></svg>
                </div>
            </div>
            <div class="middle">
                <span>'보내기'를 클릭하지 않고 이 창을 닫으면 이 메시지에 추가한 내용이 삭제됩니다.</span>
            </div>
            <div class="bottom">
                <div class="cancel">
                <button>취소</button>
                </div>
                <div class="delete">
                    <button>메시지 삭제</button>
                </div>
            </div>
        </div>
	</div>
	<!--미니메시지 닫기팝업--><!--미니메시지 닫기팝업--><!--미니메시지 닫기팝업--><!--미니메시지 닫기팝업--><!--미니메시지 닫기팝업-->
</div>
	<!--블루 미니 메시지--><!--블루 미니 메시지--><!--블루 미니 메시지--><!--블루 미니 메시지--><!--블루 미니 메시지-->
	<div id="bluemini_message">
		<svg class="bluemini_message_icon" viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path d="M14 2h-4C4.486 2 0 6.485 0 11.997a9.978 9.978 0 0 0 3.793 7.815l.433 3.318a.998.998 0 0 0 1.634.636l2.111-1.77c.01 0 .019.004.029.004h6c5.514 0 10-4.487 10-10.003S19.514 2 14 2Z"></path></svg>
		<div class="bluemini_message_h">
			<h6>새 메시지</h6>
		</div>
		<div>
			<svg class="bluemini_big_icon" viewBox="0 0 32 32" aria-hidden="true" focusable="false"><path d="M13.7,19.7L5.4,28H13c0.6,0,1,0.4,1,1s-0.4,1-1,1H3c-0.6,0-1-0.4-1-1V19c0-0.6,0.4-1,1-1s1,0.4,1,1v7.6l8.3-8.3c0.4-0.4,1-0.4,1.4,0S14.1,19.3,13.7,19.7z M29,2H19c-0.6,0-1,0.4-1,1s0.4,1,1,1h7.6l-8.3,8.3c-0.4,0.4-0.4,1,0,1.4c0.2,0.2,0.5,0.3,0.7,0.3s0.5-0.1,0.7-0.3L28,5.4V13c0,0.6,0.4,1,1,1s1-0.4,1-1V3C30,2.4,29.6,2,29,2z"></path></svg>
		</div>
		<div class="bluemini_x_icon">
			<svg class="Icon XIcon" viewBox="0 0 32 32" aria-hidden="true" focusable="false"><path d="M18.1,16L27,7.1c0.6-0.6,0.6-1.5,0-2.1s-1.5-0.6-2.1,0L16,13.9l-8.9-9C6.5,4.3,5.6,4.3,5,4.9S4.4,6.4,5,7l8.9,8.9L5,24.8c-0.6,0.6-0.6,1.5,0,2.1c0.3,0.3,0.7,0.4,1.1,0.4s0.8-0.1,1.1-0.4l8.9-8.9l8.9,8.9c0.3,0.3,0.7,0.4,1.1,0.4s0.8-0.1,1.1-0.4c0.6-0.6,0.6-1.5,0-2.1L18.1,16z"></path></svg>
		</div>
	</div>
	<!--블루 미니 메시지--><!--블루 미니 메시지--><!--블루 미니 메시지--><!--블루 미니 메시지--><!--블루 미니 메시지-->

						</div>
					</div>

			</div>
		</div>
		<div style="clear:both;"></div>
	</div>

	
	<!-------------------------------------------- 메시지 보내기 --------------------------------------------->
		<div id="fullscreen">
			<header>
			<div class="new_message">
			<span>새 메시지</span>
			</div>
			<svg class="Icon_header_close" viewBox="0 0 32 32" aria-hidden="true" focusable="false"><path d="M18.1,16L27,7.1c0.6-0.6,0.6-1.5,0-2.1s-1.5-0.6-2.1,0L16,13.9l-8.9-9C6.5,4.3,5.6,4.3,5,4.9S4.4,6.4,5,7l8.9,8.9L5,24.8c-0.6,0.6-0.6,1.5,0,2.1c0.3,0.3,0.7,0.4,1.1,0.4s0.8-0.1,1.1-0.4l8.9-8.9l8.9,8.9c0.3,0.3,0.7,0.4,1.1,0.4s0.8-0.1,1.1-0.4c0.6-0.6,0.6-1.5,0-2.1L18.1,16z"></path></svg>
			<svg class="Icon_header" viewBox="0 0 32 32" aria-hidden="true" focusable="false"><path d="M27,28H5c-1.1,0-2-0.9-2-2s0.9-2,2-2h22c1.1,0,2,0.9,2,2S28.1,28,27,28z"></path></svg>
		  	</header>
	  

		<div id="top">
			<input type="hidden" name="projectIdx" value="${projectName}"/>
			<input type="hidden" name="memberIdx" value="${memberIdx}"/>
		  <input class="title_size" type="text" name="title" placeholder="제목 추가"/>
		  <!-- <div class="recevie_span">
		  <span>받는 사람</span>
		  </div>
		  <div class="receive">
			<svg class="Icon_Project" viewBox="0 0 32 32" aria-hidden="true" focusable="false"><path d="M10,13.5c0.8,0,1.5,0.7,1.5,1.5s-0.7,1.5-1.5,1.5S8.5,15.8,8.5,15S9.2,13.5,10,13.5z M23,14h-8c-0.6,0-1,0.4-1,1s0.4,1,1,1h8c0.6,0,1-0.4,1-1S23.6,14,23,14z M23,20h-8c-0.6,0-1,0.4-1,1s0.4,1,1,1h8c0.6,0,1-0.4,1-1S23.6,20,23,20z M10,19.5c0.8,0,1.5,0.7,1.5,1.5s-0.7,1.5-1.5,1.5S8.5,21.8,8.5,21S9.2,19.5,10,19.5z M24,2h-2.2c-0.4-1.2-1.5-2-2.8-2h-6c-1.3,0-2.4,0.8-2.8,2H8C4.7,2,2,4.7,2,8v18c0,3.3,2.7,6,6,6h16c3.3,0,6-2.7,6-6V8C30,4.7,27.3,2,24,2z M13,2h6c0.6,0,1,0.4,1,1v2c0,0.6-0.4,1-1,1h-6c-0.6,0-1-0.4-1-1V3C12,2.4,12.4,2,13,2z M28,26c0,2.2-1.8,4-4,4H8c-2.2,0-4-1.8-4-4V8c0-2.2,1.8-4,4-4h2v1c0,1.7,1.3,3,3,3h6c1.7,0,3-1.3,3-3V4h2c2.2,0,4,1.8,4,4V26z"></path></svg>
			<div class="receive_project">
			<span>프로젝트 gj(4)</span>
			</div>
			<svg class="Icon_receive" viewBox="0 0 32 32" aria-hidden="true" focusable="false"><path d="M18.1,16L27,7.1c0.6-0.6,0.6-1.5,0-2.1s-1.5-0.6-2.1,0L16,13.9l-8.9-9C6.5,4.3,5.6,4.3,5,4.9S4.4,6.4,5,7l8.9,8.9L5,24.8c-0.6,0.6-0.6,1.5,0,2.1c0.3,0.3,0.7,0.4,1.1,0.4s0.8-0.1,1.1-0.4l8.9-8.9l8.9,8.9c0.3,0.3,0.7,0.4,1.1,0.4s0.8-0.1,1.1-0.4c0.6-0.6,0.6-1.5,0-2.1L18.1,16z"></path></svg>
		  </div>
		  <svg class="project_plus" viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path d="M10,10V4c0-1.1,0.9-2,2-2s2,0.9,2,2v6h6c1.1,0,2,0.9,2,2s-0.9,2-2,2h-6v6c0,1.1-0.9,2-2,2s-2-0.9-2-2v-6H4c-1.1,0-2-0.9-2-2s0.9-2,2-2H10z"></path></svg>
		</div> -->
		<div class="main">
		  <textarea id="textarea" name="content"  placeholder="내용을 입력하세요"></textarea>
		</div>
		<div class="bottom">
		  <div class="plus_icon">
		  <svg viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path d="M10,10V4c0-1.1,0.9-2,2-2s2,0.9,2,2v6h6c1.1,0,2,0.9,2,2s-0.9,2-2,2h-6v6c0,1.1-0.9,2-2,2s-2-0.9-2-2v-6H4c-1.1,0-2-0.9-2-2s0.9-2,2-2H10z"></path></svg>
		  </div>
		  <div class="icon">
		  <svg viewBox="0 0 32 32" aria-hidden="true" focusable="false"><path d="m4.357 24.509 4.77-8.012h13.371c.118 0 .227-.03.332-.067l4.81 8.079a1.001 1.001 0 0 0 1.718-1.024l-12.5-21c-.36-.605-1.357-.605-1.719 0l-12.5 21a1 1 0 1 0 1.72 1.023h-.002ZM15.998 4.952l5.681 9.545H10.316l5.682-9.545Zm-13 23.045h26a1 1 0 1 1 0 2h-26a1 1 0 1 1 0-2Z"></path></svg>
		  </div>
		  <div class="icon">
		  <svg viewBox="0 0 32 32" aria-hidden="true" focusable="false"><path d="M16,0 C7.17582609,0 0,7.17585739 0,16 C0,24.8241739 7.17582609,32 16,32 C24.8241739,32 32,24.8241739 32,16 C32,7.17585739 24.8241739,0 16,0 Z M16,2.08695652 C23.696313,2.08695652 29.9130435,8.30372174 29.9130435,16 C29.9130435,23.696313 23.696313,29.9130435 16,29.9130435 C8.30368696,29.9130435 2.08695652,23.696313 2.08695652,16 C2.08695652,8.30372174 8.30368696,2.08695652 16,2.08695652 Z M10.4347826,9.04347826 C9.09005217,9.04347826 8,10.1335652 8,11.4782609 C8,12.8229565 9.09005217,13.9130435 10.4347826,13.9130435 C11.7794748,13.9130435 12.8695652,12.8229565 12.8695652,11.4782609 C12.8695652,10.1335652 11.7794748,9.04347826 10.4347826,9.04347826 Z M21.5652174,9.04347826 C20.220487,9.04347826 19.1304348,10.1335652 19.1304348,11.4782609 C19.1304348,12.8229565 20.220487,13.9130435 21.5652174,13.9130435 C22.909913,13.9130435 24,12.8229565 24,11.4782609 C24,10.1335652 22.909913,9.04347826 21.5652174,9.04347826 Z M8.23913043,19.1304348 C7.90384696,19.149913 7.59775652,19.3392696 7.41304348,19.673913 C7.23693913,20.0104696 7.26069565,20.4386435 7.47826087,20.7499826 C9.34351304,23.5401739 12.4683478,25.3913043 16,25.3913043 C19.5316522,25.3913043 22.656487,23.5401739 24.5217391,20.7499826 C24.8262261,20.294713 24.6944348,19.6088348 24.2391304,19.3043478 C23.7838261,18.9998609 23.0870957,19.1316522 22.7826087,19.5869565 C21.2761043,21.840487 18.8063652,23.3043478 16,23.3043478 C13.1936348,23.3043478 10.7238957,21.840487 9.2173913,19.5869565 C8.93488696,19.2555478 8.57441391,19.1108522 8.23913043,19.1304348 Z M8.23913043,19.1304348 C7.90384696,19.149913 7.59775652,19.3392696 7.41304348,19.673913 C7.23693913,20.0104696 7.26069565,20.4386435 7.47826087,20.7499826 C9.34351304,23.5401739 12.4683478,25.3913043 16,25.3913043 C19.5316522,25.3913043 22.656487,23.5401739 24.5217391,20.7499826 C24.8262261,20.294713 24.6944348,19.6088348 24.2391304,19.3043478 C23.7838261,18.9998609 23.0870957,19.1316522 22.7826087,19.5869565 C21.2761043,21.840487 18.8063652,23.3043478 16,23.3043478 C13.1936348,23.3043478 10.7238957,21.840487 9.2173913,19.5869565 C8.93488696,19.2555478 8.57441391,19.1108522 8.23913043,19.1304348 Z"></path></svg>
		  </div>
		  <div class="icon">
		  <svg viewBox="0 0 32 32" aria-hidden="true" focusable="false"><path d="M16 0C7.178 0 0 7.178 0 16s7.178 16 16 16c3.675 0 7.264-1.276 10.105-3.594a1 1 0 0 0-1.264-1.551A14.025 14.025 0 0 1 15.999 30c-7.72 0-14-6.28-14-14s6.28-14 14-14 14 6.28 14 14v1.5c0 1.93-1.57 3.5-3.5 3.5s-3.5-1.57-3.5-3.5V16c0-3.859-3.14-7-7-7s-7 3.141-7 7 3.14 7 7 7a6.99 6.99 0 0 0 5.658-2.895A5.505 5.505 0 0 0 26.499 23c3.033 0 5.5-2.468 5.5-5.5V16c0-8.822-7.177-16-15.999-16Zm0 21c-2.757 0-5-2.243-5-5s2.243-5 5-5 5 2.243 5 5-2.243 5-5 5Z"></path></svg>
		  </div>
		  <div class="icon">
		  <svg viewBox="0 0 32 32" aria-hidden="true" focusable="false"><path d="M19,32c-3.9,0-7-3.1-7-7V10c0-2.2,1.8-4,4-4s4,1.8,4,4v9c0,0.6-0.4,1-1,1s-1-0.4-1-1v-9c0-1.1-0.9-2-2-2s-2,0.9-2,2v15c0,2.8,2.2,5,5,5s5-2.2,5-5V10c0-4.4-3.6-8-8-8s-8,3.6-8,8v5c0,0.6-0.4,1-1,1s-1-0.4-1-1v-5C6,4.5,10.5,0,16,0s10,4.5,10,10v15C26,28.9,22.9,32,19,32z"></path></svg>
		  </div>
		  <div class="icon">
		  <svg viewBox="0 0 32 32" aria-hidden="true" focusable="false"><path d="M24.75 0h-1.5A5.25 5.25 0 0 1 18 5.25v1.5A5.25 5.25 0 0 1 23.25 12h1.5A5.25 5.25 0 0 1 30 6.75v-1.5A5.25 5.25 0 0 1 24.75 0ZM0 15c4.444 0 7 2.5 7 7h2c0-4.5 2.5-7 7-7v-2c-4.5 0-7-2.5-7-7H7c0 4.5-2.5 7-7 7v2Zm20.75 17A5.25 5.25 0 0 1 26 26.75v-1.5A5.25 5.25 0 0 1 20.75 20h-1.5A5.25 5.25 0 0 1 14 25.25v1.5A5.25 5.25 0 0 1 19.25 32h1.5Z"></path></svg>
		  </div>
		  <!-- <div class="count">
		  <span>2 명이 받습니다</span>
		  </div> -->
		  <div class="button">
		  <button id="button" onclick="return message_content_check()">보내기</button>
		</div>
			
	  </div>
	  <!-------------------------------------------- 메시지 보내기 --------------------------------------------->
</body>
</html>