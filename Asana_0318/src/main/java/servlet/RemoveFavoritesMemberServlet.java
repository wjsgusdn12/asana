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


@WebServlet("/RemoveFavoritesMemberServlet")
public class RemoveFavoritesMemberServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int loginMemberIdx = Integer.parseInt(request.getParameter("loginMemberIdx"));
		int memberIdx = Integer.parseInt(request.getParameter("memberIdx"));
		System.out.println("로그인멤버:"+loginMemberIdx+", 별표 제거할 멤버:"+memberIdx);
		MyWorkspaceDao dao = new MyWorkspaceDao();
		MemberDao mDao = new MemberDao();
		int cnt = 0;
		
		try {
			mDao.removeFavoritesMember(loginMemberIdx, memberIdx);
			cnt = dao.favoritesCount(loginMemberIdx);
			System.out.println("별표제거완료함, cnt:" + cnt);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		JSONObject obj = new JSONObject();
		obj.put("cnt", cnt);
		out.println(obj);
	}

}
