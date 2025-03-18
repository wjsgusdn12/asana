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
import dao.ProjectDao;
import dto.MemberAllDto;
import dto.Project_participantsThingsDto;


@WebServlet("/ExProjectMemberInviteBtn")
public class ExProjectMemberInviteBtn extends HttpServlet {
	private static final long serialVersionUID = 1L;
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int memberIdx = Integer.parseInt(request.getParameter("memberIdx"));
		int authority = Integer.parseInt(request.getParameter("authority"));
		int projectIdx = Integer.parseInt(request.getParameter("projectIdx"));
		//프로젝트에 멤버 초대 
		ProjectDao projectDao = new ProjectDao();
		MemberDao memberDao = new MemberDao();
		try {
			projectDao.insertpjt_participantsDto(projectIdx, memberIdx, authority);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		//초대된 멤버 닉네임, 이메일 , 프로필, 권한 가져오기 
		MemberAllDto memberAllDto = null;
		try {
			memberAllDto = memberDao.getMemberAllDto(memberIdx);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
		memberAllDto.getNickname();
		memberAllDto.getEmail();
		memberAllDto.getProfileImg();
		
		Project_participantsThingsDto dto = null;
		try {
			dto = projectDao.specificProjectsForSpecifiMembers(projectIdx, memberIdx);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		dto.getAuthority_name();
		dto.getAuthority();
		
		
		
		
		
		response.setCharacterEncoding("utf-8");
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		JSONObject obj = new JSONObject();
		obj.put("nickName", memberAllDto.getNickname());
		obj.put("email", memberAllDto.getEmail());
		obj.put("profileImg", memberAllDto.getProfileImg());
		obj.put("authorityName", dto.getAuthority_name());
		obj.put("authorityIdx", dto.getAuthority());
		obj.put("memberIdx",memberIdx);
		out.println(obj);
		
		
	}

}
