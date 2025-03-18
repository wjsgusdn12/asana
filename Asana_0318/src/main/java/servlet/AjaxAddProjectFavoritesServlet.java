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
import dao.ProjectDao;
import dao.ProjectDao;


@WebServlet("/AjaxAddProjectFavoritesServlet")
public class AjaxAddProjectFavoritesServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int memberIdx = Integer.parseInt(request.getParameter("loginMemberIdx"));
		int projectIdx = Integer.parseInt(request.getParameter("projectIdx"));
		ProjectDao dao = new ProjectDao();
		MyWorkspaceDao mdao = new MyWorkspaceDao();
		int cnt = 0;
		try {
			dao.addProjectFavorites(memberIdx, projectIdx);
			cnt = mdao.favoritesCount(memberIdx);
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
