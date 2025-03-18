package action;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.MemberDao;

public class CodeAction implements Action{
	public void execute(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String email = request.getParameter("email");
		String code1 = request.getParameter("code1");
		String code2 = request.getParameter("code2");
		String code3 = request.getParameter("code3");
		String code4 = request.getParameter("code4");
		String code5 = request.getParameter("code5");
		String code6 = request.getParameter("code6");
		int inputCode = Integer.parseInt(code1 + code2 + code3 + code4 + code5 + code6);
		MemberDao dao = new MemberDao();
		try {
			boolean login = dao.checkCode(email, inputCode);
			request.setAttribute("login", login);
		} catch (Exception e) {
			e.printStackTrace();
		}
		request.setAttribute("email", email);
		request.setAttribute("inputCode", inputCode);
		request.setAttribute("dao", dao);
		request.getRequestDispatcher("codeAction.jsp").forward(request, response);
	}
}

