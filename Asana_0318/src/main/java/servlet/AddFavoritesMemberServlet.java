package servlet;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;

import dao.MemberDao;
import dao.MyWorkspaceDao;
import dto.MemberDto;


@WebServlet("/AddFavoritesMemberServlet")
public class AddFavoritesMemberServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int loginMemberIdx = Integer.parseInt(request.getParameter("loginMemberIdx"));
		int memberIdx = Integer.parseInt(request.getParameter("memberIdx"));
		
		MyWorkspaceDao dao = new MyWorkspaceDao();
		MemberDao mDao = new MemberDao();
		try {
			mDao.addFavoritesMember(loginMemberIdx, memberIdx);
			System.out.println("로그인멤버:"+loginMemberIdx+", 별표할 멤버:"+memberIdx+", 별표추가완료함");
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		JSONObject obj = new JSONObject();
		out.println(obj);
	}

}
