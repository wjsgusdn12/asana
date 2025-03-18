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
import dao.ProjectDao;
import dto.MemberAllDto;
import dto.Project_participantsThingsDto;


@WebServlet("/ExProjectDeleteMemberIdx")
public class ExProjectDeleteMemberIdx extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
   
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int  memberIdx = Integer.parseInt(request.getParameter("memberIdx"));
		int projectIdx = Integer.parseInt(request.getParameter("projectIdx"));
		ProjectDao projectDao = new ProjectDao();
		MemberDao memberDao = new MemberDao();
		try {
			projectDao.deleteProject_participantsDao(projectIdx , memberIdx);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		//프로젝트에 참여된 멤버 idx 들 
		ArrayList<Project_participantsThingsDto> projectMemberList = null;
		try {
			projectMemberList = projectDao.getProject_participantsAllDao(projectIdx);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		JSONArray jsonArr = new JSONArray(); 
		for(Project_participantsThingsDto dto : projectMemberList) {
			JSONObject obj = new JSONObject();
			
			int memberIdxList = dto.getMember_idx();
			MemberAllDto memberAllDto = null;
			try {
				memberAllDto = memberDao.getMemberAllDto(memberIdxList);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			obj.put("memberIdx", memberAllDto.getMemberIdx());
			obj.put("nickName", memberAllDto.getNickname());
			obj.put("profileImg",  memberAllDto.getProfileImg());
			obj.put("authorityName", dto.getAuthority_name());
			obj.put("email", memberAllDto.getEmail());
			obj.put("authorityIdx", dto.getAuthority());
			
			jsonArr.add(obj);
			
			
		}
	
		
		
		 
		
		
		
		 response.setCharacterEncoding("utf-8");
		 response.setContentType("application/json"); 
		 PrintWriter out = response.getWriter();
		 JSONObject obj = new JSONObject();
		 obj.put("jsonArr", jsonArr);
		 out.println(obj);
//		 obj.put("memberIdx", memberIdx);
//		 out.println(obj);
		 
		 
		 
		 
		
		
		
		
	}

}
