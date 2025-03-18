package action;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.LikeDao;
import dao.MemberDao;
import dao.MessageCooperationDao;
import dao.MessageDao;
import dao.MyWorkspaceDao;
import dao.PortfolioDao;
import dao.ProjectDao;
import dto.MemberDto;
import dto.MessageDto;
import dto.MyWorkspaceDto;
import dto.PortfolioDto;
import dto.ProjectDto;

public class MessageAction implements Action {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	
		LikeDao likeDao = new LikeDao();
    	MessageDao messageDao = new MessageDao();
    	MemberDao memberDao = new MemberDao();
    	ProjectDao pDao = new ProjectDao();
    	MyWorkspaceDao mwDao = new MyWorkspaceDao();
		PortfolioDao portDao = new PortfolioDao();
    	// 메시지 협업 참여자
    	MessageCooperationDao mcDao = new MessageCooperationDao();
    	// 해당 프로젝트의 메시지 상세 정보 조회
    	int projectIdx = Integer.parseInt(request.getParameter("project_idx"));
    	// 세션 가져오기
		HttpSession session = request.getSession();
		String sessionEmail = (String)session.getAttribute("email");
		int loginMemberIdx = 0;
		try {
			loginMemberIdx = memberDao.getMemberIdx(sessionEmail);
		} catch (Exception e1) {
			loginMemberIdx = 0;
		}
    	//로그인 멤버 idx
    	int memberIdx = loginMemberIdx;
    	
    	ArrayList<MessageDto> listMessages = null;
		try {
			listMessages = messageDao.getMessagesDto(projectIdx);
		} catch (Exception e1) {
			e1.printStackTrace();
		}
    	
    	try {
	    	// 로그인한 멤버 상세조회
	    	MemberDto memberDto = memberDao.getMemberDto(memberIdx);
	    	
	    	// 협업 참여자 초대 내작업공간 멤버 조회 
	    	MyWorkspaceDao myWorkspaceDao = new MyWorkspaceDao();
	    	ArrayList<MyWorkspaceDto> listMyWorkspace = myWorkspaceDao.getMyWorkspaceDto(memberIdx); 
	    	
	    	// 프로젝트 이름 조회
	    	ProjectDao projectDao = new ProjectDao();
	    	String projectName = projectDao.getProjectName(projectIdx);
	    	String myEmail = memberDto.getEmail();
	    	String myProfile = memberDto.getProfileImg();
	    	if(myProfile == null)
	    		myProfile = "img/Unknown.png";
	    	
	    	String myNickname = memberDto.getNickname();
	    	myNickname = (myNickname==null) ? myEmail : myNickname;
	    	String placeholderValue = (myNickname==null) ? myEmail : myNickname;
	    	String myIntroduce = memberDto.getMyIntroduce();
	    	String placeholderIntroduce = (myIntroduce==null) ? "간단하게 자기 소개를 해주세요." : myIntroduce;
	    	   
	    	// null 체크 후 기본값 설정
	    	String startDate = memberDto.getStartDate();
	    	String deadDate = memberDto.getDeadlineDate();
	    	if (startDate == null || startDate.isEmpty()) {
	    		   startDate = ""; // 기본값 설정
	    	}
	    	if (deadDate == null || deadDate.isEmpty()) {
	    		   deadDate = ""; // 기본값 설정
	    	}
	    	
	    	String startDatePart = startDate.split(" ")[0];
	    	String deadDatePart = deadDate.split(" ")[0];
	    	   
	    	int alarm = memberDto.getAlarm();
	    	
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
			
			request.setAttribute("pDtoList", pDtoList);  
			request.setAttribute("portfolioList", portfolioList);  
			request.setAttribute("favoritesWorkspaceCount", favoritesWorkspaceCount);  
			request.setAttribute("mDaoFavoritesList", mDaoFavoritesList);  
			request.setAttribute("pDtoFavoritesList", pDtoFavoritesList);  
			request.setAttribute("pDtoFavoritesListLength", pDtoFavoritesListLength);  
			//-----------------------------------------사이드바&상단바 변수들
	    	
	    	request.setAttribute("memberDto", memberDto);  
	    	request.setAttribute("listMessages", listMessages);
	    	request.setAttribute("myWorkspaceDao", myWorkspaceDao);  
	    	request.setAttribute("listMyWorkspace", listMyWorkspace);  
	    	request.setAttribute("projectDao", projectDao);  
	    	request.setAttribute("projectName", projectName);  
	    	request.setAttribute("myEmail", myEmail);  
	    	request.setAttribute("myProfile", myProfile);  
	    	request.setAttribute("myNickname", myNickname);  
	    	request.setAttribute("placeholderValue", placeholderValue);  
	    	request.setAttribute("myIntroduce", myIntroduce);  
	    	request.setAttribute("placeholderIntroduce", placeholderIntroduce);  
	    	request.setAttribute("startDate", startDate);  
	    	request.setAttribute("deadDate", deadDate);  
	    	request.setAttribute("alarm", alarm);  
	    	request.setAttribute("startDatePart", startDatePart);  
	    	request.setAttribute("deadDatePart", deadDatePart);
	    	
	    	myProfile = memberDto.getProfileImg();
	    	if(myProfile == null){
	    		myProfile = "Unknown.png";
	    	}
	    	alarm = memberDto.getAlarm();
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
	    	String loginNickname = memberDao.loginNickname(loginMemberIdx); //로그인닉네임
			String loginProfileImg = memberDao.loginProfileImg(loginMemberIdx); //로그인프로필이미지
			String loginEmail = memberDao.loginEmail(loginMemberIdx); //로그인이메일
			
			request.setAttribute("loginNickname", loginNickname);
			request.setAttribute("loginProfileImg", loginProfileImg);
			request.setAttribute("loginEmail", loginEmail);

	    	request.setAttribute("myProfile", myProfile);
	    	request.setAttribute("alarm", alarm);
	    	request.setAttribute("memberStartDate", memberStartDate);
	    	request.setAttribute("memberDeadDate", memberDeadDate);
	    	
		}catch(Exception e) {e.printStackTrace();}
    	
    	request.setAttribute("likeDao", likeDao);
    	request.setAttribute("messageDao", messageDao);
    	request.setAttribute("memberDao", memberDao);
    	request.setAttribute("mcDao", mcDao);
    	request.setAttribute("projectIdx", projectIdx);
    	request.setAttribute("memberIdx", memberIdx);
    	request.setAttribute("loginMemberIdx", loginMemberIdx);
    	
    	request.getRequestDispatcher("message_page.jsp?member_idx="+loginMemberIdx+"&project_idx="+projectIdx).forward(request, response);
	}

}
