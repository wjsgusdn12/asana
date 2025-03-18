package servlet;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;

import dao.ProjectDao;
import dto.Project_participantsThingsDto;


@WebServlet("/ExMemberAuthorityUpdate")
public class ExMemberAuthorityUpdate extends HttpServlet {
	private static final long serialVersionUID = 1L;
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int authority = Integer.parseInt(request.getParameter("authority"));
		int  memberidx = Integer.parseInt(request.getParameter("memberidx"));
		int projectIdx = Integer.parseInt(request.getParameter("projectIdx"));
		ProjectDao projectDao = new ProjectDao();
		try {
			projectDao.updateProject_participantsAuthorityDao(projectIdx, memberidx, authority);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		//update 된 authority name 조회 
		Project_participantsThingsDto dto = null;
		try {
			dto = projectDao.specificProjectsForSpecifiMembers(projectIdx, memberidx);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		response.setCharacterEncoding("utf-8");
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		JSONObject obj = new JSONObject();
		obj.put("memberidx", memberidx);
		obj.put("authority", authority);
		obj.put("projectIdx", projectIdx);
		obj.put("authorityName", dto.getAuthority_name());
		out.println(obj);

		
	}

}
