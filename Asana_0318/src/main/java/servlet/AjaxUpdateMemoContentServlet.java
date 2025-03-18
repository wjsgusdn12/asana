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


@WebServlet("/AjaxUpdateMemoContentServlet")
public class AjaxUpdateMemoContentServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int projectIdx = Integer.parseInt(request.getParameter("projectIdx"));
		String memoContent = request.getParameter("memoContent");
		MemoDao dao = new MemoDao();
		try {
			dao.registerMemoContent(projectIdx, memoContent);
		} catch (Exception e) {
			e.printStackTrace();
		}
		response.setCharacterEncoding("utf-8");
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		JSONObject obj = new JSONObject();
		obj.put("memoContent", memoContent);
		out.println(obj);
	}

}
