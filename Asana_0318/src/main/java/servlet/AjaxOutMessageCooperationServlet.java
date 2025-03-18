package servlet;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;

import dao.MessageCooperationDao;

@WebServlet("/AjaxOutMessageCooperationServlet")
public class AjaxOutMessageCooperationServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int messageIdx = Integer.parseInt(request.getParameter("message_idx"));
		int memberIdx = Integer.parseInt(request.getParameter("member_idx"));
		MessageCooperationDao mDao = new MessageCooperationDao(); 
		try {
			mDao.OutMessageCooperation(messageIdx, memberIdx);
		} catch (Exception e) {
			e.printStackTrace();
		}
		response.setCharacterEncoding("utf-8");
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		JSONObject obj = new JSONObject();
		obj.put("result", 1);
		out.println(obj);
	}

}
