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

@WebServlet("/AjaxCheckMessageCooperationServlet")
public class AjaxCheckMessageCooperationServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int messageIdx = Integer.parseInt(request.getParameter("message_idx"));
		int memberIdx = Integer.parseInt(request.getParameter("member_idx"));
		MessageCooperationDao dao = new MessageCooperationDao();
		int count = 0;
		try {
			count = dao.checkMessageCooperation(messageIdx, memberIdx);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		 response.setContentType("application/json");
		 PrintWriter out = response.getWriter();
		 JSONObject obj = new JSONObject();
		 obj.put("result", count);
		 out.println(obj);
	}

}
