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

@WebServlet("/AjaxDeleteCommentLikeServlet")
public class AjaxDeleteCommentLikeServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int commentIdx = Integer.parseInt(request.getParameter("comment_idx"));
		int memberIdx = Integer.parseInt(request.getParameter("member_idx"));
		LikeDao dao = new LikeDao();
		int likeCount = 0;
		try {
			dao.deleteCommentLike(memberIdx, commentIdx);
			likeCount = dao.CountMessageCommentsLikeDto(commentIdx);
		} catch (Exception e) {
			e.printStackTrace();
		}
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		JSONObject obj = new JSONObject();
		obj.put("result", 1);
		obj.put("likeCount",likeCount);
		out.println(obj);
	}
}
