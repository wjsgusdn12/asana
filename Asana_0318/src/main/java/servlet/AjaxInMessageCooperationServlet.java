package servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import dao.MemberDao;
import dao.MessageCooperationDao;
import dto.MemberDto;
import dto.MessageCooperationDto;



@WebServlet("/AjaxInMessageCooperationServlet")
public class AjaxInMessageCooperationServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int messageIdx = Integer.parseInt(request.getParameter("message_idx"));
		int memberIdx = Integer.parseInt(request.getParameter("member_idx"));
		MessageCooperationDao mDao = new MessageCooperationDao(); 
		MemberDao dao = new MemberDao();
		MemberDto dto = null;
		
		try {
			mDao.MessageCooperation(messageIdx, memberIdx);
			dto = dao.getMyProfile(memberIdx);
		} catch (Exception e) {
			e.printStackTrace();
		}
		response.setCharacterEncoding("utf-8");
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		JSONObject obj = new JSONObject();
		obj.put("profile", dto.getProfileImg());
		obj.put("nickname", dto.getNickname());
		out.println(obj);
	}
}
