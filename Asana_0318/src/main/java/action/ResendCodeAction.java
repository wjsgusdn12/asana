package action;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.MemberDao;
import mail.Mail;


public class ResendCodeAction implements Action{
public void execute(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String email = request.getParameter("email");
		Integer newCode = (int)(Math.random() * 900000) + 100000;
		MemberDao dao = new MemberDao();
		try {
			dao.updateMemberCode(newCode, email);
			dao.resendCodeDate(email);
		} catch (Exception e) {
			e.printStackTrace();
		}
	    Mail.sendMail(email, newCode);
		request.setAttribute("email", email);
		request.getRequestDispatcher("code_join.jsp").forward(request, response);
	}
}

