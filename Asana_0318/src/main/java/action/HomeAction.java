package action;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.MemberDao;
import dao.MyWorkspaceDao;
import dao.PortfolioDao;
import dao.ProjectDao;
import dao.WamDao;
import dto.MemberDto;
import dto.MyWorkspaceDto;
import dto.PortfolioDto;
import dto.ProjectDto;
import dto.WamDto;

public class HomeAction implements Action {
	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		MemberDao memberDao = new MemberDao();
		MemberDto memberDto = new MemberDto();
		MyWorkspaceDao mwDao = new MyWorkspaceDao();
		PortfolioDao portDao = new PortfolioDao();
		WamDao wamDao = new WamDao();
		ProjectDao pDao = new ProjectDao();
		// 로그인한 Member_idx :: 나중에 세션에서 읽어오는 걸로 변경 (TODO).
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
		try {
		
			int ownerIdx = 1;
			ArrayList<MyWorkspaceDto> myWorkspaceMemberList = mwDao.getMinusMyWorkspaceDto(loginMemberIdx, ownerIdx); // 팀원 리스트 본인제외
			int myWorkspaceMemberCount = myWorkspaceMemberList.size();

			//예정중인 wam list
			ArrayList<WamDto> wamDtoList = wamDao.getWamsDtoBeforeDeadline(loginMemberIdx);
			//마감일 지난 wan list
			ArrayList<WamDto> wamDtoListAfterDeadline = wamDao.PastDeadline(loginMemberIdx);
			//마감일 지난 wam list 갯수
			int wamQuantityAfterDeadline = wamDtoListAfterDeadline.size();
			// 완료된 작업 보여주기
			ArrayList<WamDto> completeWamList = wamDao.CheckWamDto(loginMemberIdx);
			//완료된 wam 의 갯수
			int completeWamQuantity = completeWamList.size();
			
			//dao : MemberDao
			String loginNickname = memberDao.loginNickname(loginMemberIdx); //로그인닉네임
			String loginProfileImg = memberDao.loginProfileImg(loginMemberIdx); //로그인프로필이미지
			String loginEmail = memberDao.loginEmail(loginMemberIdx); //로그인이메일
			String nickname = memberDao.loginNickname(memberIdx); //닉네임
			String profileImg = memberDao.loginProfileImg(memberIdx); //프로필이미지
			String email = memberDao.loginEmail(memberIdx); //이메일
			String nowTime = memberDao.nowTime(); //현재 시간
			String nowDay = memberDao.nowDay(); // 현재 날짜
			//---------------------------------------사이드바&상단바 변수들
			// 로그인멤버의 참여중인 프로젝트 이름 리스트
			ArrayList<ProjectDto> pDtoList = pDao.getProjectDto(loginMemberIdx); 
			// 포트폴리오 참여 리스트
			ArrayList<PortfolioDto> portfolioList = portDao.getPortfolioDto();
			// 로그인멤버의 내작업공간 즐겨찾기 유무 
			int favoritesWorkspaceCount = mwDao.isFavoritesWorkspaceByMemberIdx(loginMemberIdx);
			// 로그인멤버의 즐겨찾게 멤버 총 명수
			ArrayList<MemberDto> mDaoFavoritesList = memberDao.favoritesMemberList(loginMemberIdx);
			// 로그인멤버의 즐겨찾기 중인 프로젝트 이름 리스트
			ArrayList<ProjectDto> pDtoFavoritesList = pDao.favoritesProjectListByMemberIdx(loginMemberIdx);
			// 로그인멤버의 즐겨찾기 중인 프로젝트 개수
			int pDtoFavoritesListLength = pDtoFavoritesList.size();
			//-----------------------------------------사이드바&상단바 변수들
			memberDto = memberDao.getMemberDto(loginMemberIdx);
			String myEmail = memberDto.getEmail();
			String myProfile = memberDto.getProfileImg();
			if(myProfile == null){
				myProfile = "Unknown.png";
			}
			String myNickname = (memberDto.getNickname()==null)?email:memberDto.getNickname();
			String placeholderValue = (myNickname==null) ? myEmail : myNickname;
			String myIntroduce = memberDto.getMyIntroduce();
			String placeholderIntroduce = (myIntroduce==null) ? "간단하게 자기 소개를 해주세요." : myIntroduce;
			int alarm = memberDto.getAlarm();
			// null 체크 후 기본값 설정
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
			
			request.setAttribute("ownerIdx", ownerIdx);
			request.setAttribute("myWorkspaceMemberList", myWorkspaceMemberList);
			request.setAttribute("myWorkspaceMemberCount", myWorkspaceMemberCount);
			request.setAttribute("wamDtoList", wamDtoList);
			request.setAttribute("wamDtoListAfterDeadline", wamDtoListAfterDeadline);
			request.setAttribute("wamQuantityAfterDeadline", wamQuantityAfterDeadline);
			request.setAttribute("completeWamList", completeWamList);
			request.setAttribute("completeWamQuantity", completeWamQuantity);
			request.setAttribute("loginNickname", loginNickname);
			request.setAttribute("loginProfileImg", loginProfileImg);
			request.setAttribute("loginEmail", loginEmail);
			request.setAttribute("nickname", nickname);
			request.setAttribute("profileImg", profileImg);
			request.setAttribute("email", email);
			request.setAttribute("nowTime", nowTime);
			request.setAttribute("nowDay", nowDay);
			// 사이드바 리스트 변수들--------------------------------------------------
			request.setAttribute("pDtoList", pDtoList);
			request.setAttribute("portfolioList", portfolioList);
			request.setAttribute("favoritesWorkspaceCount", favoritesWorkspaceCount);
			request.setAttribute("mDaoFavoritesList", mDaoFavoritesList);
			request.setAttribute("pDtoFavoritesList", pDtoFavoritesList);
			request.setAttribute("pDtoFavoritesListLength", pDtoFavoritesListLength);
			// 사이드바 리스트 변수들--------------------------------------------------
			request.setAttribute("memberDto", memberDto);
			request.setAttribute("myEmail", myEmail);
			request.setAttribute("myProfile", myProfile);
			request.setAttribute("myNickname", myNickname);
			request.setAttribute("placeholderValue", placeholderValue);
			request.setAttribute("myIntroduce", myIntroduce);
			request.setAttribute("placeholderIntroduce", placeholderIntroduce);
			request.setAttribute("alarm", alarm);
			request.setAttribute("memberStartDate", memberStartDate);
			request.setAttribute("memberDeadDate", memberDeadDate);
		} catch(Exception e) { e.printStackTrace(); }

		request.setAttribute("memberDao", memberDao);
		request.setAttribute("memberDto", memberDto);
		request.setAttribute("mwDao", mwDao);
		request.setAttribute("portDao", portDao);
		request.setAttribute("wamDao", wamDao);
		request.setAttribute("pDao", pDao);
		request.setAttribute("loginMemberIdx", loginMemberIdx);
		request.setAttribute("memberIdx", memberIdx);
		
		request.getRequestDispatcher("asana_home.jsp").forward(request, response);
	}
}
