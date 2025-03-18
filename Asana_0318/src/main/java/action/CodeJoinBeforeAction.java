package action;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.MemberDao;

public class CodeJoinBeforeAction implements Action{
	public void execute(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String email = request.getParameter("email");
		MemberDao dao = new MemberDao();
		try {
			int cnt = dao.loginCheckMember(email);
			request.setAttribute("cnt", cnt);
		} catch (Exception e) {
			e.printStackTrace();
		}
		request.setAttribute("email", email);
		request.setAttribute("dao", dao);
		request.getRequestDispatcher("code_join_before.jsp").forward(request, response);
	}
}
