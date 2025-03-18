package action;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.AlarmUpdateDao;
import dao.MemberDao;
import dao.MyWorkspaceDao;
import dao.PortfolioDao;
import dao.ProjectDao;
import dao.WamDao;
import dto.AlarmUpdateDto;
import dto.MemberAllDto;
import dto.MemberDto;
import dto.PortfolioAllDto;
import dto.PortfolioDto;
import dto.ProjectAllDto;
import dto.ProjectDto;
import dto.WamAllDto;

public class MainBoardAction implements Action{

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//파라미터 project_id 을 받는 변수 
		int projectIdx = Integer.parseInt(request.getParameter("project_idx"));
		PortfolioDao portfolioDao = new PortfolioDao();
		ProjectDao projectDao = new ProjectDao();
		WamDao wamDao = new WamDao();
		MemberDao memberDao = new MemberDao();
		MyWorkspaceDao myDao = new MyWorkspaceDao();
		MemberDto memberDto = new MemberDto();
		
		// 세션 가져오기
		HttpSession session = request.getSession();
		String sessionEmail = (String)session.getAttribute("email");
		int loginMemberIdx = 0;
		try {
			loginMemberIdx = memberDao.getMemberIdx(sessionEmail);
		} catch (Exception e1) {
				e1.printStackTrace();
		}
		int memberIdx = loginMemberIdx;
		int memberidx = loginMemberIdx;


		//프로젝트가 속한 포트폴리오 이름 조회 
		ArrayList<PortfolioAllDto> portfolioAllDtolist = null;
		try {
			portfolioAllDtolist = portfolioDao.portfolioTheProjectBelongsTo(projectIdx);
		} catch (Exception e) {
			e.printStackTrace();
		}

		//프로젝트의 모든 컬럼 조회 
		ProjectAllDto projectAllDto = null;
		try {
			projectAllDto = projectDao.getProjectAllDto(projectIdx);
		} catch (Exception e) {
			e.printStackTrace();
		} 
		
		

		//완료 섹션에 보여줄 wam 리스트 
		ArrayList<WamAllDto> completedSectionWamList = null;
		try {
			completedSectionWamList =  wamDao.boardOfCompletedWam(projectIdx);
		} catch (Exception e) {
			e.printStackTrace();
		}

		//날짜 포맷되는 클래스 
		SimpleDateFormat formatter1 = new SimpleDateFormat("yyyy-MM-dd"); //SimpleDateFormat 사용 
		SimpleDateFormat formatter2 = new SimpleDateFormat("MM월dd일");
		
		int runningcount = 0;
		 try {
			runningcount = wamDao.countWamRunningSection(projectIdx);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		int allcount = 0;
		try {
			allcount = wamDao.countWamAllSection(projectIdx);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		MemberAllDto memberAllDto = null;
		try {
			memberAllDto = memberDao.getMemberAllDto(memberidx);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		
		int completecount = 0;
		try {
			completecount = wamDao.countWamCompletedSection(projectIdx);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		ArrayList<WamAllDto> runningwamAllDtoList = null;
		try {
			runningwamAllDtoList = wamDao.runningWamlist(projectIdx);
		} catch (Exception e) {
			e.printStackTrace();
		} 
		
		ArrayList<WamAllDto> wamAllSectionlist = null;
		try {
			wamAllSectionlist = wamDao.allSectionWamlist(projectIdx);
		} catch (Exception e) {
			e.printStackTrace();
		}


		/*******************로딩 했을때 알림 조회 : 조회 하자마자 삭제 ***************************/
		AlarmUpdateDao auDao = new AlarmUpdateDao();
		ArrayList<AlarmUpdateDto> alarmUpdateList = null;
		try {
			alarmUpdateList = auDao.getAlarmSelect(memberidx);
		} catch (Exception e) {
			e.printStackTrace();
		}
		try {
			auDao.deleteAlarmUpdate(memberidx);
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
			int favoritesWorkspaceCount = myDao.isFavoritesWorkspaceByMemberIdx(loginMemberIdx);
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

		
		request.setAttribute("projectIdx", projectIdx);
		request.setAttribute("loginMemberIdx", loginMemberIdx);
		request.setAttribute("portfolioDao", portfolioDao);
		request.setAttribute("projectDao", projectDao);
		request.setAttribute("wamDao", wamDao);	
		request.setAttribute("memberDao", memberDao);
		request.setAttribute("memberidx", memberidx);
		request.setAttribute("portfolioAllDtolist", portfolioAllDtolist);
		request.setAttribute("projectAllDto", projectAllDto);
		request.setAttribute("completedSectionWamList", completedSectionWamList);
		request.setAttribute("formatter1", formatter1);		
		request.setAttribute("formatter2", formatter2);
		request.setAttribute("runningcount", runningcount);
		request.setAttribute("allcount", allcount);
		request.setAttribute("memberAllDto", memberAllDto);
		request.setAttribute("alarmUpdateList", alarmUpdateList);
		request.setAttribute("completecount", completecount);
		request.setAttribute("runningwamAllDtoList", runningwamAllDtoList);
		request.setAttribute("wamAllSectionlist", wamAllSectionlist);
		
		
		request.getRequestDispatcher("main_board.jsp?member_idx="+loginMemberIdx+"&project_idx="+projectIdx).forward(request, response);
	}

}
