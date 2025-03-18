package servlet;

import java.io.IOException;

import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;

import dao.MemoDao;
import dao.MyWorkspaceDao;
import dao.ProjectDao;
import dao.ProjectDao;

@WebServlet("/AjaxProjectDeleteServlet")
public class AjaxProjectDeleteServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int memberIdx = Integer.parseInt(request.getParameter("loginMemberIdx"));
		int projectIdx = Integer.parseInt(request.getParameter("projectIdx"));
		ProjectDao dao = new ProjectDao();
		MemoDao MemoDao = new MemoDao();
		MyWorkspaceDao mwDao = new MyWorkspaceDao();
		int cnt = 0;
		try {
			dao.deleteProjectFromProjectIdx(projectIdx);
			dao.removeProjectFavorites(memberIdx, projectIdx);
			MemoDao.DeleteMemoByprojectIdx(projectIdx);
			cnt = mwDao.favoritesCount(memberIdx);
		} catch (Exception e) {
			e.printStackTrace();
		}
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		JSONObject obj = new JSONObject();
		obj.put("cnt", cnt);
		obj.put("projectIdx", projectIdx);
		out.println(obj);
		
		
	}
}
