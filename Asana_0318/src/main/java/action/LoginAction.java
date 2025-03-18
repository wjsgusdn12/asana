package action;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.MemberDao;
import dto.MemberDto;

public class LoginAction implements Action {

	public void execute(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String email = request.getParameter("email");
		// 세션 가져오기
		HttpSession session = request.getSession();
		session.setAttribute("email", email); // 세션에 이메일 저장
		MemberDao dao = new MemberDao();
		try {
			boolean login = dao.CheckMember(email);
			MemberDto dto = dao.getMember(email);
			int memberIdx = dao.getMemberIdx(email);
			request.setAttribute("login", login);
			request.setAttribute("dto", dto);
			request.setAttribute("memberIdx", memberIdx);
		} catch (Exception e) {
			e.printStackTrace();
		}
		request.setAttribute("dao", dao);
		request.setAttribute("email", email);
		request.getRequestDispatcher("LoginAction.jsp").forward(request, response);
	}
}
