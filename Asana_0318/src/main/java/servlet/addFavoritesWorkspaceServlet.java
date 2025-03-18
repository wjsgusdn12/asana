package servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.MyWorkspaceDao;

@WebServlet("/addFavoritesWorkspaceServlet")
public class addFavoritesWorkspaceServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int loginMemberIdx = Integer.parseInt(request.getParameter("loginMemberIdx"));
		MyWorkspaceDao dao = new MyWorkspaceDao();
		try {
			dao.addWorkspaceFavorites(loginMemberIdx);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		
	}

}
