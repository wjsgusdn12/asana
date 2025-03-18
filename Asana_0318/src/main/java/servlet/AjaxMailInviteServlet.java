package servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.MemberDao;
import util.MailSender;

@WebServlet("/AjaxMailInviteServlet")
public class AjaxMailInviteServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
		int loginMemberIdx = 0;
		try{
			loginMemberIdx = (int)session.getAttribute("loginMemberIdx");
		}catch(Exception e) {
			loginMemberIdx = Integer.parseInt(request.getParameter("loginMemberIdx"));
		}
		String email = request.getParameter("email");
		int code = 100000 + (int)(Math.random() * 900000);
		
		// using Daos....
		MemberDao mDao = new MemberDao();
		try {
			mDao.insertInviteCode(code);
			System.out.println("데이터베이스에 초대코드 선 등록 완료");
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		MailSender ms = new MailSender();
		ms.send(email, code);
		
	}
}
