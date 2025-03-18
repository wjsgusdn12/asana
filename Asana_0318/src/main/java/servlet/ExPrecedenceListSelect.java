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
import dao.WamDao;
import dto.ProjectAllDto;
import dto.WamAllDto;


@WebServlet("/ExPrecedenceListSelect")
public class ExPrecedenceListSelect extends HttpServlet {
	private static final long serialVersionUID = 1L;
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		int wamidx = Integer.parseInt(request.getParameter("wamidx")); //마일스톤의 idx 값 
		WamDao wamDao = new WamDao();
		ProjectDao projectDao = new ProjectDao();
		
		//나의 후속이 있는지 없지 체크 
		WamAllDto subtaskcheckdto = null;
		try {
			subtaskcheckdto = wamDao.wamGetAlldto(wamidx);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		System.out.println("subtaskcheckdto:" + subtaskcheckdto.getContent());
		
		Integer followingidx = subtaskcheckdto.getFollowingIdx();
		
		//후속이 있는지 없는지에 따라 리스트업 다름 
		JSONArray ArrJson = new JSONArray(); //후속작업이 있을경우 
		JSONArray ArrJsonNoSubtask = new JSONArray(); //후속작업이 없을경우 
		
		
		if(followingidx == null) {
			ArrayList<WamAllDto> wamdtolist = null;
			try {
				wamdtolist = wamDao.precedingOfClickNoSubtask(wamidx);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			for(WamAllDto dto : wamdtolist) {
				JSONObject obj = new JSONObject();
				
				dto.getTitle();
				
				int projectidx = dto.getProjectIdx();
				//System.out.println("프로젝트 idx :"  +projectidx);
				String completedate = dto.getCompleteDate();
				
				ProjectAllDto projectAllDto = null;
				try {
					projectAllDto = projectDao.getProjectAllDto(projectidx);
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} 
				String projectTitle = projectAllDto.getName();
				
				obj.put("wamtitle", dto.getTitle());
				obj.put("projectTitle",  projectTitle);
				obj.put("completedate", completedate);
				obj.put("wamidx", dto.getWamIdx());
				ArrJsonNoSubtask.add(obj);
				
				}
			
		}else {
			System.out.println("들어감 ?");
			ArrayList<WamAllDto> wamdtolist = null;
			try {
				wamdtolist = wamDao.precedingOfClick(wamidx);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			System.out.println("wamdtolist:" + wamdtolist.size());
			
			for(WamAllDto dto : wamdtolist) {
				JSONObject obj = new JSONObject();
				
				dto.getTitle();
				
				int projectidx = dto.getProjectIdx();
				//System.out.println("프로젝트 idx :"  +projectidx);
				String completedate = dto.getCompleteDate();
				
				ProjectAllDto projectAllDto = null;
				try {
					projectAllDto = projectDao.getProjectAllDto(projectidx);
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} 
				String projectTitle = projectAllDto.getName();
				
				obj.put("wamtitle", dto.getTitle());
				obj.put("projectTitle",  projectTitle);
				obj.put("completedate", completedate);
				obj.put("wamidx", dto.getWamIdx());
				ArrJson.add(obj);
				
				}
			
		}
		
		
		
		
		
		
		
		
		JSONObject obj = new JSONObject();
		response.setCharacterEncoding("utf-8");
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		obj.put("ArrJson", ArrJson);
		obj.put("ArrJsonNoSubtask", ArrJsonNoSubtask);
		out.println(obj);
		
		
		
		
		
	}

}
