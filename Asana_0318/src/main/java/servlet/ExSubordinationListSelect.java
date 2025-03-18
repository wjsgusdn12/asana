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

@WebServlet("/ExSubordinationListSelect")
public class ExSubordinationListSelect extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		int wamidx = Integer.parseInt(request.getParameter("wamidx"));
		WamDao wamDao = new WamDao();
		ProjectDao  projectDao = new ProjectDao();
		
		
		//나의 후속이 있는지 없는지 체크 
		WamAllDto subtaskcheckdto = null;
		try {
			subtaskcheckdto = wamDao.wamGetAlldto(wamidx);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		Integer followingidx = subtaskcheckdto.getFollowingIdx(); //후속 idx 
		
		
		//나의 선행이 있는지 없는지 체크 
		ArrayList<WamAllDto> wamalldtolist = null;
		try {
			wamalldtolist = wamDao.precedingWamGet(wamidx);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
		
		
		
		
		//나의 종속과 선행모두 null 인 경우 
				
		JSONArray objArr = new JSONArray(); // 나의 종속, 선행 모두 null 이 아닌경우 
		JSONArray nopreobjArr = new JSONArray(); // 나의 선행만 null 인 경우 
		JSONArray nosubobjArr = new JSONArray(); // 나의 종속만 null 인 경우 
		JSONArray allnoobjArr = new JSONArray(); //나의 종속, 선행 모두 null 
		
		if(wamalldtolist !=null && followingidx !=null) {//나의 종속이 null이 아닌경우, 나의 선행도 null 이 아닌경우 
			ArrayList<WamAllDto> dtolist = null;
			try {
				dtolist = wamDao.dependencyOfClick(wamidx);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

			
			for (WamAllDto dto : dtolist) {
				JSONObject obj = new JSONObject();

				dto.getTitle();
				

				int projectidx = dto.getProjectIdx();
				// System.out.println("프로젝트 idx :" +projectidx);
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
				obj.put("projectTitle", projectTitle);
				obj.put("completedate", completedate);
				obj.put("wamidx", dto.getWamIdx());
				objArr.add(obj);

			}
			
		}else if(wamalldtolist==null && followingidx !=null) { //나의 선행만 null인 경우 : 후속만 있고 , 선행은 없음 
			ArrayList<WamAllDto> dtolist = null;
			try {
				dtolist = wamDao.dependencyOfClickNopreceding(wamidx);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

			
			for (WamAllDto dto : dtolist) {
				JSONObject obj = new JSONObject();

				dto.getTitle();
				

				int projectidx = dto.getProjectIdx();
				// System.out.println("프로젝트 idx :" +projectidx);
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
				obj.put("projectTitle", projectTitle);
				obj.put("completedate", completedate);
				obj.put("wamidx", dto.getWamIdx());
				nopreobjArr.add(obj);

			}
			
			
		}else if(wamalldtolist!=null && followingidx==null) {//나의 종속만 null 인 경우 : 선행은 있고 종속은 없음 
			System.out.println("종속이 null 인경우 ");
			ArrayList<WamAllDto> dtolist = null;
			try {
				dtolist = wamDao.dependencyOfClickNosubtask(wamidx);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

			
			for (WamAllDto dto : dtolist) {
				JSONObject obj = new JSONObject();

				dto.getTitle();
				

				int projectidx = dto.getProjectIdx();
				// System.out.println("프로젝트 idx :" +projectidx);
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
				obj.put("projectTitle", projectTitle);
				obj.put("completedate", completedate);
				obj.put("wamidx", dto.getWamIdx());
				nosubobjArr.add(obj);

			}
			
		}else { //후속, 선행 모두 null 인 경우 
			ArrayList<WamAllDto> dtolist = null;
			try {
				dtolist = wamDao.dependencyOfClickNoAll(wamidx);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

			
			for (WamAllDto dto : dtolist) {
				JSONObject obj = new JSONObject();

				dto.getTitle();
				

				int projectidx = dto.getProjectIdx();
				// System.out.println("프로젝트 idx :" +projectidx);
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
				obj.put("projectTitle", projectTitle);
				obj.put("completedate", completedate);
				obj.put("wamidx", dto.getWamIdx());
				allnoobjArr.add(obj);

			}
			
			
		}
		
		
		
		
		
		
		
		
		
		
		
		
		JSONObject obj = new JSONObject();
		response.setCharacterEncoding("utf-8");
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		obj.put("objArr", objArr);
		obj.put("nopreobjArr", nopreobjArr);
		obj.put("nosubobjArr", nosubobjArr);
		obj.put("allnoobjArr", allnoobjArr);
		out.println(obj);
	}

}
