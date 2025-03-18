package action;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.MemberDao;
import dao.MemoDao;
import dao.ProjectDao;

public class CreateProjectFinalAction implements Action {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		MemberDao memberDao = new MemberDao();
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
	    
	    String name = request.getParameter("project_name");
	    
	    int range = Integer.parseInt(request.getParameter("range"));
	    ProjectDao pDao = new ProjectDao();
	    
	    try {
	        // 프로젝트 추가
	        pDao.createProject(name, memberIdx, range);
	        // 프로젝트 idx 추적
	        int createdProjectIdx = pDao.findCreatedProjectIdx(name);
	        // 프로젝트 생성자 자동 참여
	        pDao.projectParticipants(createdProjectIdx, memberIdx);
	        
	        MemoDao memoDao = new MemoDao();
	        // 프로젝트 메모 생성
	        memoDao.CreateMemoByProjectIdx(createdProjectIdx);
	        
	        // request에 값 설정
	        request.setAttribute("createdProjectIdx", createdProjectIdx);
	        request.setAttribute("memoDao", memoDao);
	        
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    
	    // request에 추가 정보 설정
	    request.setAttribute("loginMemberIdx", loginMemberIdx);
	    request.setAttribute("name", name);
	    request.setAttribute("memberIdx", memberIdx);
	    request.setAttribute("range", range);
	    request.setAttribute("pDao", pDao);
	    
	    // 리다이렉트 처리
	    response.sendRedirect("Controller?command=home&member_idx=" + loginMemberIdx);
		
	}

}
