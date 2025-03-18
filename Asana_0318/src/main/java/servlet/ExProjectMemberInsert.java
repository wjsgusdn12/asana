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

import dao.ProjectDao;
import dto.ProjectMemberInsertDto;


@WebServlet("/ExProjectMemberInsert")
public class ExProjectMemberInsert extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
  
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int projectIdx = Integer.parseInt(request.getParameter("projectIdx"));
		int memberidx = Integer.parseInt(request.getParameter("memberidx"));
		//int nickName = Integer.parseInt("nickName");
		String nickName = request.getParameter("nickName");   // 검색할 키워드.
		//System.out.println("프로젝트 idx : " + projectIdx);
		//System.out.println("nickName : " + nickName);

		ProjectDao pDao = new ProjectDao();
		ArrayList<ProjectMemberInsertDto> list = null;
		
		try {
			list = pDao.projectMemberInsert(memberidx, projectIdx, nickName);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
//		for(ProjectMemberInsertDto dto : list) {
//			System.out.println(dto.getNickname());
//			System.out.println(dto.getEmail());
//			System.out.println(dto.getProfileImg());
//		}
		
		response.setCharacterEncoding("utf-8");
		response.setContentType("application/json"); 
		PrintWriter out = response.getWriter();
		JSONArray jsonArr = new JSONArray();
		for(ProjectMemberInsertDto dto : list) {
			JSONObject obj = new JSONObject();
			obj.put("memberIdx", dto.getMemberIdx());
			obj.put("nickName", dto.getNickname());
			obj.put("email", dto.getEmail());
			obj.put("profileImg", dto.getProfileImg());
			obj.put("authority", dto.getAuthority());
			obj.put("projectIdx", dto.getProjectIdx());
			jsonArr.add(obj);
		}
//		obj.put("strDaysBefore", strDaysBefore);
		out.println(jsonArr);

	}

}
