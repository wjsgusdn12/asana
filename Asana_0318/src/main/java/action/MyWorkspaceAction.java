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

public class MyWorkspaceAction implements Action {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		MemberDao memberDao = new MemberDao();
		MemberDto memberDto = new MemberDto();
		PortfolioDao portDao = new PortfolioDao();
		ProjectDao pDao = new ProjectDao();
		MyWorkspaceDao dao = new MyWorkspaceDao();
		WamDao wamDao = new WamDao();
		int memberIdx = Integer.parseInt(request.getParameter("member_idx"));
		//로그인 멤버 idx
		// 세션 가져오기
		HttpSession session = request.getSession();
		String sessionEmail = (String)session.getAttribute("email");
		int loginMemberIdx = 0;
		try {
			loginMemberIdx = memberDao.getMemberIdx(sessionEmail);
		} catch (Exception e1) {
			e1.printStackTrace();
		}
		int ownerIdx = Integer.parseInt(request.getParameter("owner_idx"));
		try {
			//닉네임
			String nickname = memberDao.loginNickname(memberIdx);
			//프로필이미지
			String profileImg = memberDao.loginProfileImg(memberIdx);
			//이메일
			String email = memberDao.loginEmail(memberIdx);
			//로그인닉네임
			String loginNickname = memberDao.loginNickname(loginMemberIdx);
			//로그인프로필이미지
			String loginProfileImg = memberDao.loginProfileImg(loginMemberIdx);
			//로그인이메일
			String loginEmail = memberDao.loginEmail(loginMemberIdx);
			ArrayList<MyWorkspaceDto> myWorkspaceMemberList = dao.myWorkspaceMemberList(ownerIdx);
			//내작업공간 멤버 수
			int memberLength = myWorkspaceMemberList.size();
			// 참여중인 프로젝트 이름 리스트
			ArrayList<ProjectDto> pDtoList = pDao.getProjectDto(loginMemberIdx);
			// 로그인멤버의 즐겨찾기 중인 프로젝트 이름 리스트
			ArrayList<ProjectDto> pDtoFavoritesList = pDao.favoritesProjectListByMemberIdx(loginMemberIdx);
			// 로그인멤버의 즐겨찾기 중인 프로젝트 개수
			int pDtoFavoritesListLength = pDtoFavoritesList.size();
			// 로그인멤버의 내작업공간 즐겨찾기 유무 
			int favoritesWorkspaceCount = dao.isFavoritesWorkspaceByMemberIdx(loginMemberIdx);
			// 로그인멤버의 즐겨찾기 총 갯수
			int favoritesCount = dao.favoritesCount(loginMemberIdx);
			//
			int inputEmailNumber = 1;
			// 로그인멤버의 즐겨찾게 멤버 총 명수
			ArrayList<MemberDto> mDaoFavoritesList = memberDao.favoritesMemberList(loginMemberIdx);
			// 포트폴리오 참여 리스트
			ArrayList<PortfolioDto> portfolioList = portDao.getPortfolioDto();
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
			int alarm = (int)memberDto.getAlarm();
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
			
			request.setAttribute("nickname", nickname);
			request.setAttribute("profileImg", profileImg);
			request.setAttribute("email", email);
			request.setAttribute("loginNickname", loginNickname);
			request.setAttribute("loginProfileImg", loginProfileImg);
			request.setAttribute("loginEmail", loginEmail);
			request.setAttribute("myWorkspaceMemberList", myWorkspaceMemberList);
			request.setAttribute("memberLength", memberLength);
			request.setAttribute("pDtoList", pDtoList);
			request.setAttribute("pDtoFavoritesList", pDtoFavoritesList);
			request.setAttribute("pDtoFavoritesListLength", pDtoFavoritesListLength);
			request.setAttribute("favoritesWorkspaceCount", favoritesWorkspaceCount);
			request.setAttribute("favoritesCount", favoritesCount);
			request.setAttribute("inputEmailNumber", inputEmailNumber);
			request.setAttribute("mDaoFavoritesList", mDaoFavoritesList);
			request.setAttribute("portfolioList", portfolioList);
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
			
		}catch(Exception e) {e.printStackTrace();}
		
		request.setAttribute("memberDao", memberDao);
		request.setAttribute("memberDto", memberDto);
		request.setAttribute("portDao", portDao);
		request.setAttribute("pDao", pDao);
		request.setAttribute("dao", dao);
		request.setAttribute("wamDao", wamDao);
		request.setAttribute("memberIdx", memberIdx);
		request.setAttribute("loginMemberIdx", loginMemberIdx);
		request.setAttribute("ownerIdx", ownerIdx);
		
		request.getRequestDispatcher("asana_my_workspace.jsp?member_idx="+loginMemberIdx+"&owner_idx="+ownerIdx).forward(request, response);
		
	}
	
}
