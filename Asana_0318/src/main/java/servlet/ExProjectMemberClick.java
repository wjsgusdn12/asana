package servlet;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;

import dao.MemberDao;
import dto.MemberAllDto;


@WebServlet("/ExProjectMemberClick")
public class ExProjectMemberClick extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
   
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int memberIdx = Integer.parseInt(request.getParameter("memberIdx"));
		MemberDao memberDao = new MemberDao();
		MemberAllDto memberAllDto = null;
		try {
			memberAllDto = memberDao.getMemberAllDto(memberIdx);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		response.setCharacterEncoding("utf-8");
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		JSONObject obj = new JSONObject();
		obj.put("profileImg", memberAllDto.getProfileImg());
		obj.put("nickName", memberAllDto.getNickname());
		obj.put("memberIdx", memberAllDto.getMemberIdx());
		out.println(obj);
	}

}
