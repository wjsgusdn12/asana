package action;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.AlarmUpdateDao;
import dao.GoalDao;
import dao.MemberDao;
import dao.MyWorkspaceDao;
import dao.PortfolioDao;
import dao.ProjectDao;
import dao.StatusGetAllDao;
import dto.Access_settingAllDto;
import dto.AlarmUpdateDto;
import dto.GoalSelectAllDto;
import dto.MemberAllDto;
import dto.MemberDto;
import dto.PortfolioAllDto;
import dto.PortfolioDto;
import dto.ProjectAllDto;
import dto.ProjectDto;
import dto.ProjectStatusDto;
import dto.Project_participantsThingsDto;
import dto.StatusAllDto;
import dto.TimeLineThingDto;
import dto.WamAllDto;

public class MainOutlineAction implements Action{
	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		MyWorkspaceDao mwDao = new MyWorkspaceDao();
		MemberDao memberDao2 = new MemberDao();
		MemberDto memberDto = new MemberDto();
		
		// 세션 가져오기
		HttpSession session = request.getSession();
		String sessionEmail = (String)session.getAttribute("email");
		int loginMemberIdx = 0;
		try {
			loginMemberIdx = memberDao2.getMemberIdx(sessionEmail);
		} catch (Exception e1) {
				e1.printStackTrace();
		}
		int memberIdx = loginMemberIdx; 
		int projectIdx = 0;
		try {
			projectIdx = Integer.parseInt(request.getParameter("project_idx"));
		}catch(Exception e) {}
		
		ProjectDao projectDao = new ProjectDao();
		ProjectAllDto projectAllDto1 = null;
		try {
			projectAllDto1 = projectDao.getProjectAllDto(projectIdx);
		} catch (Exception e) {
			
			e.printStackTrace();
		}
		
		StatusGetAllDao statusGetAllDao = new StatusGetAllDao();
		String name = projectAllDto1.getName();
		String title = projectAllDto1.getTitle();

		int num = 0; //projectIdx 변수 
		MemberDao memberDao = new MemberDao(); //회원 Dao 
//			MemberAllDto memberAllDto = memberDao.getMemberDto(num);

		int participantsMemberIdx;
		ArrayList<Project_participantsThingsDto> listProject_participants = null;
		try {
			listProject_participants = projectDao.getProject_participantsAllDao(projectIdx);
		} catch (Exception e) {
			
			e.printStackTrace();
		}
		
		//프로젝트의 참여자idx 와 권한조회하는 메서드 
		ArrayList<String> participantsNickName = new ArrayList<String>(); // 해당 프로젝트의 참여자 닉네임 
		ArrayList<String> participantsAuthority = new ArrayList<String>(); //해당 프로젝트의 참여자 권한 
		for (Project_participantsThingsDto project_participantsThingsDto : listProject_participants) {
			num = project_participantsThingsDto.getMember_idx(); //해당 프로젝트의 멤버 idx 
			MemberAllDto memberAllDto = null;
			try {
				memberAllDto = memberDao.getMemberAllDto(num);
			} catch (Exception e) {
				
				e.printStackTrace();
			}
			participantsNickName.add(memberAllDto.getNickname()); // 참여자 닉네임 리스트에 저장 
			participantsAuthority.add(project_participantsThingsDto.getAuthority_name()); // 참여자 권한 리스트에 저장 
		}

		
		//연결된 목표 조회 
		GoalDao goalDao = new GoalDao();
		ArrayList<GoalSelectAllDto> goalSelectProjectlist = null;
		try {
			goalSelectProjectlist = goalDao.getGoalAllOfProject(projectIdx);
		} catch (Exception e) {
			
			e.printStackTrace();
		}
		StatusAllDto statusAllDto = new StatusAllDto();

		
		//연결된 포트폴리오 조회  - select
		PortfolioDao portfolioDao = new PortfolioDao();
		ArrayList<PortfolioAllDto> portfolioAllDtolist11 = null;
		try {
			portfolioAllDtolist11 = portfolioDao.connectedPortfolioGetDto(projectIdx);
		} catch (Exception e) {
			
			e.printStackTrace();
		}
		
		for (PortfolioAllDto dto1 : portfolioAllDtolist11) {
			dto1.getName();
			dto1.getStatus_idx();
		}

		
		//프로젝트의 가장 최신 상태 업데이트 조회 
		ProjectStatusDto projectStatusDto = null;
		try {
			projectStatusDto = projectDao.recentProjectStatusDto(projectIdx);
		} catch (Exception e) {
			
			e.printStackTrace();
		}
		
		
		String statusdate = projectStatusDto.getStatusDate(); //상태 날짜 조회 
		//날짜 포맷되는 클래스 
		SimpleDateFormat formatterProjectStatusDate01 = new SimpleDateFormat("yyyy-MM-dd"); //SimpleDateFormat 사용 
		SimpleDateFormat formatterProjectStatusDate02 = new SimpleDateFormat("MM월dd일");
		Date projectStatusDate = null;
		try {
			projectStatusDate = formatterProjectStatusDate01.parse(statusdate.split(" ")[0]);
		} catch (ParseException e) {
			
			e.printStackTrace();
		}
		
		String projectstatusdateFormatPost = formatterProjectStatusDate02.format(projectStatusDate);

		
		int statusIdx = projectStatusDto.getStatusIdx(); //statusIdx 조회 
		StatusAllDto statusAllDto11 = null;
		try {
			statusAllDto11 = statusGetAllDao.getStatusAllDto(statusIdx);
		} catch (Exception e) {
			
			e.printStackTrace();
		}
		statusAllDto11.getCharColor(); //status 의 색상조회 

		
		memberIdx = projectStatusDto.getMemberIdx();
		MemberAllDto memberAllDto = null;
		try {
			memberAllDto = memberDao.getMemberAllDto(memberIdx);
		} catch (Exception e) {
			
			e.printStackTrace();
		}
		memberAllDto.getProfileImg(); // 작성자 프로필 이미지 
		memberAllDto.getNickname(); // 작성자 닉네임
		

		int updateProjectStatusIdx = projectStatusDto.getStatusIdx(); //가장 최신 업데이트된 projectStatusIdx
		StatusAllDto updateStatusAllDto = null;
		try {
			updateStatusAllDto = statusGetAllDao.getStatusAllDto(updateProjectStatusIdx);
		} catch (Exception e) {
			
			e.printStackTrace();
		}
		
		updateStatusAllDto.getCharColor();
		updateStatusAllDto.getName();
		
		Access_settingAllDto access_settingAllDto = null;
		try {
			access_settingAllDto = projectDao.getAccess_settingAllDao(projectIdx);
		} catch (Exception e) {
			
			e.printStackTrace();
		}
		
		
		
		//수정중 access_settingAllDto is null 
		int projectRange = 0; //일단 0이라고 넘기자 db에는 1로 데이터 있음 
		if(access_settingAllDto !=null) {
			projectRange = access_settingAllDto.getRange(); 
		}
		
		
		
		
		
		ArrayList<Project_participantsThingsDto> projectParticipantsIdx = null;
		try {
			projectParticipantsIdx = projectDao.getProject_participantsAllDao(projectIdx);
		} catch (Exception e) {
			
			e.printStackTrace();
		}
		
		ArrayList<WamAllDto> wamDtolist = null;
		try {
			wamDtolist = projectDao.milestonesToTheProjectSelectDto(projectIdx);
		} catch (Exception e) {
			
			e.printStackTrace();
		}
		
		ProjectAllDto projectAllDto2 = null;
		try {
			projectAllDto2 = projectDao.getProjectAllDto(projectIdx);
		} catch (Exception e) {
			
			e.printStackTrace();
		}
		String startDate = projectAllDto2.getStart_date(); 
		
		ArrayList<TimeLineThingDto> timeLineThingDto1 = null;
		try {
			timeLineThingDto1 =  goalDao.timeLineThingGetDto(projectIdx);
		} catch (Exception e) {
			
			e.printStackTrace();
		}
		
		ArrayList<Project_participantsThingsDto> projectMemberList = null;
		try {
			projectMemberList = projectDao.getProject_participantsAllDao(projectIdx);
		} catch (Exception e) {
			
			e.printStackTrace();
		}
		
		ArrayList<ProjectStatusDto> projectStatusDtolist = null;
		try {
			projectStatusDtolist =  projectDao.projectStatusinventoryDto(projectIdx);
		} catch (Exception e) {
			
			e.printStackTrace();
		}
		

		
		/*******************로딩 했을때 알림 조회 : 조회 하자마자 삭제 ***************************/
		AlarmUpdateDao auDao = new AlarmUpdateDao();
		ArrayList<AlarmUpdateDto> alarmUpdateList = null;
		try {
			alarmUpdateList = auDao.getAlarmSelect(loginMemberIdx);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		try {
			auDao.deleteAlarmUpdate(loginMemberIdx);
		} catch (Exception e) {
			
			e.printStackTrace();
		}
		/*******************로딩 했을때 알림 조회 : 조회 하자마자 삭제 ***************************/
		
		// 사이드바 리스트 변수들--------------------------------------------------
		try {
			// 로그인멤버의 참여중인 프로젝트 이름 리스트
			ArrayList<ProjectDto> pDtoList = projectDao.getProjectDto(loginMemberIdx); 
			// 포트폴리오 참여 리스트
			ArrayList<PortfolioDto> portfolioList = portfolioDao.getPortfolioDto();
			// 로그인멤버의 내작업공간 즐겨찾기 유무 
			int favoritesWorkspaceCount = mwDao.isFavoritesWorkspaceByMemberIdx(loginMemberIdx);
			// 로그인멤버의 즐겨찾게 멤버 총 명수
			ArrayList<MemberDto> mDaoFavoritesList = memberDao.favoritesMemberList(loginMemberIdx);
			// 로그인멤버의 즐겨찾기 중인 프로젝트 이름 리스트
			ArrayList<ProjectDto> pDtoFavoritesList = projectDao.favoritesProjectListByMemberIdx(loginMemberIdx);
			// 로그인멤버의 즐겨찾기 중인 프로젝트 개수
			int pDtoFavoritesListLength = pDtoFavoritesList.size();
			
			request.setAttribute("pDtoList", pDtoList);
			request.setAttribute("portfolioList", portfolioList);
			request.setAttribute("favoritesWorkspaceCount", favoritesWorkspaceCount);
			request.setAttribute("mDaoFavoritesList", mDaoFavoritesList);
			request.setAttribute("pDtoFavoritesList", pDtoFavoritesList);
			request.setAttribute("pDtoFavoritesListLength", pDtoFavoritesListLength);
			
			memberDto = memberDao.getMemberDto(loginMemberIdx);
			String myEmail = memberDto.getEmail();
			String myProfile = memberDto.getProfileImg();
			if(myProfile == null){
				myProfile = "Unknown.png";
			}
			String myNickname = memberDto.getNickname();
			String placeholderValue = (myNickname==null) ? myEmail : myNickname;
			String myIntroduce = memberDto.getMyIntroduce();
			String placeholderIntroduce = (myIntroduce==null) ? "간단하게 자기 소개를 해주세요." : myIntroduce;
			String memberStartDate = memberDto.getStartDate();
			String memberDeadDate = memberDto.getDeadlineDate();
			
			if (memberStartDate == null || memberStartDate.isEmpty()) {
				memberStartDate = ""; // 기본값 설정
			    System.out.println("startDate가 null이어서 기본값으로 설정됨");
			}
			
			if (memberDeadDate == null || memberDeadDate.isEmpty()) {
				memberDeadDate = ""; // 기본값 설정
			    System.out.println("deadDate가 null이어서 기본값으로 설정됨");
			}
			
			int alarm = memberDto.getAlarm();
			String loginNickname = memberDao.loginNickname(loginMemberIdx); //로그인닉네임
			String loginProfileImg = memberDao.loginProfileImg(loginMemberIdx); //로그인프로필이미지
			String loginEmail = memberDao.loginEmail(loginMemberIdx); //로그인이메일
			
			request.setAttribute("loginNickname", loginNickname);
			request.setAttribute("loginProfileImg", loginProfileImg);
			request.setAttribute("loginEmail", loginEmail);

			request.setAttribute("myEmail", myEmail);
			request.setAttribute("myNickname", myNickname);
			request.setAttribute("placeholderValue", placeholderValue);
			request.setAttribute("myIntroduce", myIntroduce);
			request.setAttribute("placeholderIntroduce", placeholderIntroduce);
			request.setAttribute("myProfile", myProfile);
			request.setAttribute("alarm", alarm);
			request.setAttribute("memberStartDate", memberStartDate);
			request.setAttribute("memberDeadDate", memberDeadDate);
			
		}catch(Exception e) {e.printStackTrace();}
		// 사이드바 리스트 변수들--------------------------------------------------

		
		request.setAttribute("alarmUpdateList", alarmUpdateList);
		request.setAttribute("loginMemberIdx", loginMemberIdx);
		request.setAttribute("projectIdx", projectIdx);
		request.setAttribute("projectAllDto1", projectAllDto1);
		request.setAttribute("name", name);
		request.setAttribute("title", title);
		request.setAttribute("listProject_participants", listProject_participants );
		request.setAttribute("participantsNickName", participantsNickName);
		request.setAttribute("participantsAuthority",participantsAuthority);
		request.setAttribute("goalSelectProjectlist", goalSelectProjectlist);
		request.setAttribute("portfolioAllDtolist11", portfolioAllDtolist11);
		request.setAttribute("projectStatusDto", projectStatusDto);
		request.setAttribute("projectstatusdateFormatPost", projectstatusdateFormatPost);
		request.setAttribute("statusAllDto11", statusAllDto11);
		request.setAttribute("memberAllDto", memberAllDto);
		request.setAttribute("updateStatusAllDto", updateStatusAllDto);
		request.setAttribute("updqteStatusAllDtoGetCharColor", updateStatusAllDto.getCharColor());
		request.setAttribute("updateStatusAllDtoGetName", updateStatusAllDto.getName());
		request.setAttribute("projectRange", projectRange);
		request.setAttribute("projectParticipantsIdx", projectParticipantsIdx);
		request.setAttribute("memberDao", memberDao);
		request.setAttribute("statusAllDto", statusAllDto);
		request.setAttribute("goalDao", goalDao);
		request.setAttribute("statusGetAllDao", statusGetAllDao);
		request.setAttribute("wamDtolist", wamDtolist);
		request.setAttribute("projectAllDto2", projectAllDto2);
		request.setAttribute("startDate", startDate);
		request.setAttribute("timeLineThingDto1", timeLineThingDto1);
		request.setAttribute("projectMemberList", projectMemberList);
		request.setAttribute("projectStatusDtolist", projectStatusDtolist);
		
		
		request.getRequestDispatcher("main_outline.jsp?member_idx="+loginMemberIdx+"&project_idx="+projectIdx).forward(request, response);
		
		
		
		
	}

}
