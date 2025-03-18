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


@WebServlet("/ExProjectStatusDelete")
public class ExProjectStatusDelete extends HttpServlet {
	private static final long serialVersionUID = 1L;
   
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		int projectStatusIdx = Integer.parseInt(request.getParameter("projectStatusIdx"));
		//System.out.println(projectStatusIdx);
		ProjectDao projectDao = new ProjectDao();
		try {
			projectDao.project_StatusDeleteDto(projectStatusIdx);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		response.setCharacterEncoding("utf-8");
		response.setContentType("application/json"); 
		PrintWriter out = response.getWriter();
		JSONObject obj = new JSONObject();
		obj.put("projectStatusIdx", projectStatusIdx);
		out.println(obj);
		
		
	}

}
