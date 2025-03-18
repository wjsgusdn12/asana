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


@WebServlet("/ExupdateProjectRange")
public class ExupdateProjectRange extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
  
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	int range = Integer.parseInt(request.getParameter("range"));
	int projectIdx = Integer.parseInt(request.getParameter("projectIdx"));
	ProjectDao projectDao = new ProjectDao();
	try {
		projectDao.updateProjectRangeDto(range, projectIdx);
	} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
	
	response.setCharacterEncoding("utf-8");
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	JSONObject obj = new JSONObject();
	obj.put("range", range);
	out.println(obj);
	
	
	
	
	
	
	
	}

}
