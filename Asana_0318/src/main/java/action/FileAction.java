package action;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.FileDao;
import dao.MemberDao;
import dao.MyWorkspaceDao;
import dao.PortfolioDao;
import dao.ProjectDao;
import dao.WamDao;
import dto.FileListDto;
import dto.MemberDto;
import dto.PortfolioDto;
import dto.ProjectDto;

public class FileAction implements Action {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		MemberDao memberDao = new MemberDao();
		ProjectDao projectDao = new ProjectDao();
		FileDao fileDao = new FileDao();
		MyWorkspaceDao mwDao = new MyWorkspaceDao();
		PortfolioDao portDao = new PortfolioDao();
		MemberDto memberDto = new MemberDto();
		WamDao wamDao = new WamDao();
		
		int projectIdx = 1;
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
		int memberIdx = loginMemberIdx;
		try{
			projectIdx = Integer.parseInt(request.getParameter("project_idx"));
			memberIdx = Integer.parseInt(request.getParameter("member_idx"));
		}catch(NumberFormatException e){}
		
		try {
			ArrayList<FileListDto> fileListDto = fileDao.getFileListDto(projectIdx);
			// 프로필이미지
			String profileImg = memberDao.loginProfileImg(memberIdx);
			// 이메일
			String email = memberDao.loginEmail(memberIdx);
			// 프로젝트 번호
			String projectName = projectDao.getProjectName(projectIdx);
			//로그인닉네임
			String loginNickname = memberDao.loginNickname(loginMemberIdx);
			//로그인프로필이미지
			String loginProfileImg = memberDao.loginProfileImg(loginMemberIdx);
			//로그인이메일
			String loginEmail = memberDao.loginEmail(loginMemberIdx);
			// 참여중인 프로젝트 이름 리스트
			ArrayList<ProjectDto> pDtoList = projectDao.getProjectDto(loginMemberIdx); 
			//
			String nowTime = memberDao.nowDay() + " " + memberDao.nowTime();
			// 로그인멤버의 즐겨찾기 중인 프로젝트 이름 리스트
			ArrayList<ProjectDto> pDtoFavoritesList = projectDao.favoritesProjectListByMemberIdx(loginMemberIdx);
			// 로그인멤버의 즐겨찾기 중인 프로젝트 개수
			int pDtoFavoritesListLength = pDtoFavoritesList.size();
			System.out.println("pDtoFavoritesListLength : " + pDtoFavoritesListLength);
			// 로그인멤버의 내작업공간 즐겨찾기 유무 
			int favoritesWorkspaceCount = mwDao.isFavoritesWorkspaceByMemberIdx(loginMemberIdx);
			// 로그인멤버의 즐겨찾게 멤버 총 명수
			ArrayList<MemberDto> mDaoFavoritesList = memberDao.favoritesMemberList(loginMemberIdx);
			// 포트폴리오 참여 리스트
			ArrayList<PortfolioDto> portfolioList = portDao.getPortfolioDto();
			//
			memberDto = memberDao.getMemberDto(loginMemberIdx);
			String myEmail = memberDto.getEmail();
			String myProfile = memberDto.getProfileImg();
			if(myProfile == null){ myProfile = "Unknown.png"; }
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
			
			request.setAttribute("fileListDto", fileListDto);
			request.setAttribute("profileImg", profileImg);
			request.setAttribute("email", email);
			request.setAttribute("projectName", projectName);
			request.setAttribute("loginNickname", loginNickname);
			request.setAttribute("loginProfileImg", loginProfileImg);
			request.setAttribute("loginEmail", loginEmail);
			request.setAttribute("pDtoList", pDtoList);
			request.setAttribute("nowTime", nowTime);
			request.setAttribute("pDtoFavoritesList", pDtoFavoritesList);
			request.setAttribute("pDtoFavoritesListLength", pDtoFavoritesListLength);
			request.setAttribute("favoritesWorkspaceCount", favoritesWorkspaceCount);
			request.setAttribute("mDaoFavoritesList", mDaoFavoritesList);
			request.setAttribute("portfolioList", portfolioList);
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
		request.setAttribute("projectDao", projectDao);
		request.setAttribute("fileDao", fileDao);
		request.setAttribute("mwDao", mwDao);
		request.setAttribute("portDao", portDao);
		request.setAttribute("memberDto", memberDto);
		request.setAttribute("wamDao", wamDao);
		request.setAttribute("projectIdx", projectIdx);
		request.setAttribute("loginMemberIdx", loginMemberIdx);
		request.setAttribute("memberIdx", memberIdx);
		
		request.getRequestDispatcher("asana_file.jsp?member_idx="+loginMemberIdx+"&project_idx="+projectIdx).forward(request, response);

	}

}
