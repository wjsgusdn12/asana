package action;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.MemberDao;
import dao.MemoDao;
import dao.MyWorkspaceDao;
import dao.PortfolioDao;
import dao.ProjectDao;
import dao.WamDao;
import dto.LookMemoDto;
import dto.MemberDto;
import dto.PortfolioDto;
import dto.ProjectDto;

public class MemoAction implements Action {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		MemberDao mDao = new MemberDao();
		MemberDto memberDto = new MemberDto();
		ProjectDao projectDao = new ProjectDao();
		MyWorkspaceDao mwDao = new MyWorkspaceDao();
		PortfolioDao portDao = new PortfolioDao();
		MemoDao memoDao = new MemoDao();
		WamDao wamDao = new WamDao();
		
		int projectIdx = Integer.parseInt(request.getParameter("project_idx"));
		/* try{
			projectIdx = Integer.parseInt(request.getParameter("project_idx"));
		}catch(NumberFormatException e){} */
		
//		int loginMemberIdx = 2; // 기본값 설정
//		try {
//		    // 세션 객체 가져오기
//		    HttpSession session = request.getSession();
//		    // 세션에서 "loginMemberIdx"라는 키로 저장된 값을 가져옴
//		    Object sessionValue = session.getAttribute("loginMemberIdx");
//		    // 값이 존재하면 int로 변환
//		    if (sessionValue != null) { loginMemberIdx = (int) sessionValue; } 
//		    else { System.out.println("세션에 'loginMemberIdx'가 존재하지 않습니다."); }
//		} catch (Exception e) { e.printStackTrace(); }
		
		//로그인 멤버 idx
		// 세션 가져오기
		HttpSession session = request.getSession();
		String sessionEmail = (String)session.getAttribute("email");
		int loginMemberIdx = 0;
		try {
			loginMemberIdx = mDao.getMemberIdx(sessionEmail);
		} catch (Exception e1) {
			e1.printStackTrace();
		}

		
		int memberIdx = 1;
		try{
			memberIdx = Integer.parseInt(request.getParameter("member_idx"));
		}catch(NumberFormatException e){}
		
		try {
		//로그인닉네임
		String loginNickname = mDao.loginNickname(loginMemberIdx);
		//로그인프로필이미지
		String loginProfileImg = mDao.loginProfileImg(loginMemberIdx);
		//로그인이메일
		String loginEmail = mDao.loginEmail(loginMemberIdx);
		//프로젝트 이름
		String projectName = projectDao.getProjectName(projectIdx);
		// 참여중인 프로젝트 이름 리스트
		ArrayList<ProjectDto> pDtoList = projectDao.getProjectDto(loginMemberIdx); 
		//메모 내용 조회 리스트
		LookMemoDto lookMemoDto = memoDao.getLookMemoDtoFromProjectIdx(projectIdx);
		//현재시간
		String nowMemoTime = memoDao.nowMemoTime();
		// 로그인멤버의 즐겨찾기 중인 프로젝트 이름 리스트
		ArrayList<ProjectDto> pDtoFavoritesList = projectDao.favoritesProjectListByMemberIdx(loginMemberIdx);
		// 로그인멤버의 즐겨찾기 중인 프로젝트 개수
		int pDtoFavoritesListLength = pDtoFavoritesList.size();
		// 로그인멤버의 내작업공간 즐겨찾기 유무 
		int favoritesWorkspaceCount = mwDao.isFavoritesWorkspaceByMemberIdx(loginMemberIdx);
		// 로그인멤버의 즐겨찾게 멤버 총 명수
		ArrayList<MemberDto> mDaoFavoritesList = mDao.favoritesMemberList(loginMemberIdx);
		// 포트폴리오 참여 리스트
		ArrayList<PortfolioDto> portfolioList = portDao.getPortfolioDto();
		
		memberDto = mDao.getMemberDto(loginMemberIdx);
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
		int memoIdx = memoDao.getMemoIdxByProjectIdx(lookMemoDto.getProjectIdx());
		
		request.setAttribute("loginNickname", loginNickname);
		request.setAttribute("loginProfileImg", loginProfileImg);
		request.setAttribute("loginEmail", loginEmail);
		request.setAttribute("projectName", projectName);
		request.setAttribute("pDtoList", pDtoList);
		request.setAttribute("lookMemoDto", lookMemoDto);
		request.setAttribute("nowMemoTime", nowMemoTime);
		request.setAttribute("pDtoFavoritesList", pDtoFavoritesList);
		request.setAttribute("pDtoFavoritesListLength", pDtoFavoritesListLength);
		request.setAttribute("favoritesWorkspaceCount", favoritesWorkspaceCount);
		request.setAttribute("mDaoFavoritesList", mDaoFavoritesList);
		request.setAttribute("portfolioList", portfolioList);
		request.setAttribute("memberDto", memberDto);
		request.setAttribute("myEmail", myEmail);
		request.setAttribute("myProfile", myProfile);
		request.setAttribute("myNickname", myNickname);
		request.setAttribute("placeholderValue", placeholderValue);
		request.setAttribute("myIntroduce", myIntroduce);
		request.setAttribute("placeholderIntroduce", placeholderIntroduce);
		request.setAttribute("memberStartDate", memberStartDate);
		request.setAttribute("memberDeadDate", memberDeadDate);
		request.setAttribute("alarm", alarm);
		request.setAttribute("memoIdx", memoIdx);
		
		}catch(Exception e) {e.printStackTrace();}
		
		request.setAttribute("mDao", mDao);
		request.setAttribute("memberDto", memberDto);
		request.setAttribute("projectDao", projectDao);
		request.setAttribute("mwDao", mwDao);
		request.setAttribute("portDao", portDao);
		request.setAttribute("memoDao", memoDao);
		request.setAttribute("wamDao", wamDao);
		request.setAttribute("projectIdx", projectIdx);
		request.setAttribute("loginMemberIdx", loginMemberIdx);
		request.setAttribute("memberIdx", memberIdx);
		
		request.getRequestDispatcher("asana_memo.jsp?member_idx="+loginMemberIdx+"&project_idx="+projectIdx).forward(request, response);
		
	}

}
