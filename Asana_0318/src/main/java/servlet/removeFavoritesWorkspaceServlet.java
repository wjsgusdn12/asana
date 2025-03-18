package servlet;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;

import dao.MyWorkspaceDao;

@WebServlet("/removeFavoritesWorkspaceServlet")
public class removeFavoritesWorkspaceServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int loginMemberIdx = Integer.parseInt(request.getParameter("loginMemberIdx"));
		MyWorkspaceDao dao = new MyWorkspaceDao();
		int cnt = 0;
		try {
			dao.removeWorkspaceFavorites(loginMemberIdx);
			cnt = dao.favoritesCount(loginMemberIdx);
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
