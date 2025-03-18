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
import dto.PortfolioDto;
import dto.ProjectDto;
import dto.WamDto;

public class OtherProfileAction implements Action {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		MemberDao memberDao = new MemberDao();
		MemberDto memberDto = new MemberDto();
		MyWorkspaceDao mwDao = new MyWorkspaceDao();
		PortfolioDao portDao = new PortfolioDao();
		ProjectDao pDao = new ProjectDao();
		WamDao wamDao = new WamDao();
		
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

		//해당 타인프로필 화면의 멤버 idx
		int memberIdx = 1;
		try{
			memberIdx = Integer.parseInt(request.getParameter("member_idx"));
		}catch(NumberFormatException e){
			e.printStackTrace();
		}
		
		//닉네임
		String nickname = null;
		try {
			nickname = memberDao.loginNickname(memberIdx);
		} catch (Exception e) {
			e.printStackTrace();
		}
		//프로필이미지
		String profileImg = null;
		try {
			profileImg = memberDao.loginProfileImg(memberIdx);
		} catch (Exception e) {
			e.printStackTrace();
		}
		//이메일
		String email = null;
		try {
			email = memberDao.loginEmail(memberIdx);
		} catch (Exception e) {
			e.printStackTrace();
		}
		//현재 시간
		String nowTime = null;
		try {
			nowTime = memberDao.nowTime();
		} catch (Exception e) {
			e.printStackTrace();
		}
		//로그인닉네임
		String loginNickname = null;
		try {
			loginNickname = memberDao.loginNickname(loginMemberIdx);
		} catch (Exception e) {
			e.printStackTrace();
		}
		//로그인프로필이미지
		String loginProfileImg = null;
		try {
			loginProfileImg = memberDao.loginProfileImg(loginMemberIdx);
		} catch (Exception e) {
			e.printStackTrace();
		}
		//로그인이메일
		String loginEmail = null;
		try {
			loginEmail = memberDao.loginEmail(loginMemberIdx);
		} catch (Exception e) {
			e.printStackTrace();
		}
		// 참여중인 프로젝트 이름 리스트
		ArrayList<ProjectDto> pDtoList = new ArrayList<>();
		try {
			pDtoList = pDao.getProjectDto(loginMemberIdx);
		} catch (Exception e) {
			e.printStackTrace();
		} 
		// 로그인멤버의 즐겨찾기 중인 프로젝트 이름 리스트
		ArrayList<ProjectDto> pDtoFavoritesList = new ArrayList<ProjectDto>();
		try {
			pDtoFavoritesList = pDao.favoritesProjectListByMemberIdx(loginMemberIdx);
		} catch (Exception e6) {
			e6.printStackTrace();
		}
		// 로그인멤버의 즐겨찾기 중인 프로젝트 개수
		int pDtoFavoritesListLength = pDtoFavoritesList.size();
		// 로그인멤버의 내작업공간 즐겨찾기 유무 
		int favoritesWorkspaceCount = 0;
		try {
			favoritesWorkspaceCount = mwDao.isFavoritesWorkspaceByMemberIdx(loginMemberIdx);
		} catch (Exception e5) {
			e5.printStackTrace();
		}
		// 로그인멤버의 즐겨찾기 총 갯수
		int favoritesCount = 0;
		try {
			favoritesCount = mwDao.favoritesCount(loginMemberIdx);
		} catch (Exception e4) {
			e4.printStackTrace();
		}
		// 로그인멤버의 즐겨찾게 멤버 총 명수
		ArrayList<MemberDto> mDaoFavoritesList = new ArrayList<MemberDto>();
		try {
			mDaoFavoritesList = memberDao.favoritesMemberList(loginMemberIdx);
		} catch (Exception e3) {
			e3.printStackTrace();
		}
		// 로그인멤버의 별표 멤버 유무 상태 ( 0 , 1 )
		int isFavoritesMember = 0;
		try {
			isFavoritesMember = memberDao.favoritesMemberIdxCheckByLoginMemberIdx(loginMemberIdx, memberIdx);
		} catch (Exception e2) {
			e2.printStackTrace();
		}
		// 포트폴리오 참여 리스트
		ArrayList<PortfolioDto> portfolioList = new ArrayList<PortfolioDto>();
		try {
			portfolioList = portDao.getPortfolioDto();
		} catch (Exception e1) {
			e1.printStackTrace();
		}
		//--
		memberDto = null;
		try {
			memberDto = memberDao.getMemberDto(loginMemberIdx);
		} catch (Exception e) {
			e.printStackTrace();
		}
		String myEmail = memberDto.getEmail();
		String myProfile = memberDto.getProfileImg();
		if(myProfile == null){
			myProfile = "Unknown.png";
		}
		String myNickname = memberDto.getNickname();
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
		//로그인멤버와 타인멤버가 같이 협업참여중인 프로젝트 리스트
		ArrayList<ProjectDto> pDtoListByLoginMemberAndOtherMember = null;
		try {
			pDtoListByLoginMemberAndOtherMember = pDao.getProjectDtoByLoginMemberAndOtherMember(loginMemberIdx, memberIdx);
		} catch (Exception e) {
			e.printStackTrace();
		}
		//로그인멤버가 타인멤버에게 배정한 wam list
		ArrayList<WamDto> wamListByLoginMemberAssignsToOtherMember =  null;
		try { 
			wamListByLoginMemberAssignsToOtherMember =  wamDao.AssignWamsDto(loginMemberIdx, memberIdx); 
		} catch (Exception e) {e.printStackTrace();}
		//로그인멤버와 타인멤버가 함께 협업중인 wam list
		ArrayList<WamDto> getTogetherWamsDto = null;
		try {
			getTogetherWamsDto = wamDao.getTogetherWamsDto(loginMemberIdx, memberIdx);
		}catch(Exception e) {e.printStackTrace();}
		//타인멤버의 모든 작업 리스트 (위의 두개 메서드 종합)
		ArrayList<WamDto> getAllWamListByLoginMemberAndOtherMember = null;
		try {
			getAllWamListByLoginMemberAndOtherMember = wamDao.getAllWamListByLoginMemberAndOtherMember(loginMemberIdx, memberIdx);
		} catch (Exception e) {e.printStackTrace();}
		
		request.setAttribute("memberDao", memberDao);
		request.setAttribute("memberDto", memberDto);
		request.setAttribute("mwDao", mwDao);
		request.setAttribute("pDao", pDao);
		request.setAttribute("wamDao", wamDao);
		request.setAttribute("loginMemberIdx", loginMemberIdx);
		request.setAttribute("memberIdx", memberIdx);
		request.setAttribute("nickname", nickname);
		request.setAttribute("profileImg", profileImg);
		request.setAttribute("email", email);
		request.setAttribute("nowTime", nowTime);
		request.setAttribute("loginNickname", loginNickname);
		request.setAttribute("loginProfileImg", loginProfileImg);
		request.setAttribute("loginEmail", loginEmail);
		request.setAttribute("pDtoList", pDtoList);
		request.setAttribute("pDtoFavoritesList", pDtoFavoritesList);
		request.setAttribute("pDtoFavoritesListLength", pDtoFavoritesListLength);
		request.setAttribute("favoritesWorkspaceCount", favoritesWorkspaceCount);
		request.setAttribute("favoritesCount", favoritesCount);
		request.setAttribute("mDaoFavoritesList", mDaoFavoritesList);
		request.setAttribute("favoritesCount", favoritesCount);
		request.setAttribute("mDaoFavoritesList", mDaoFavoritesList);
		request.setAttribute("isFavoritesMember", isFavoritesMember);
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
		request.setAttribute("pDtoListByLoginMemberAndOtherMember",pDtoListByLoginMemberAndOtherMember);
		request.setAttribute("wamListByLoginMemberAssignsToOtherMember", wamListByLoginMemberAssignsToOtherMember);
		request.setAttribute("getTogetherWamsDto", getTogetherWamsDto);
		request.setAttribute("getAllWamListByLoginMemberAndOtherMember", getAllWamListByLoginMemberAndOtherMember);
		
		request.getRequestDispatcher("asana_other_profile.jsp?member_idx="+memberIdx).forward(request, response);
		
	}

}
