package servlet;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;

import dao.LikeDao;

@WebServlet("/AjaxCommentLikeCheckServlet")
public class AjaxCommentLikeCheckServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int commentIdx = Integer.parseInt(request.getParameter("comment_idx"));
		int memberIdx = Integer.parseInt(request.getParameter("member_idx"));
		LikeDao dao = new LikeDao();
		int result = 0;
		try {
			result = dao.getMessageCommentLikeCheckDto(memberIdx, commentIdx);
		} catch (Exception e) {
			e.printStackTrace();
		}
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		JSONObject obj = new JSONObject();
		obj.put("result", result);
		out.println(obj);
	}

}
