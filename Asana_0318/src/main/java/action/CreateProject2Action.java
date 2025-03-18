package action;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.MemberDao;

public class CreateProject2Action implements Action {

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
		
		request.setAttribute("loginMemberIdx", loginMemberIdx);
		
		request.getRequestDispatcher("asana_create_project2.jsp?member_idx="+loginMemberIdx).forward(request, response);
		
	}

}