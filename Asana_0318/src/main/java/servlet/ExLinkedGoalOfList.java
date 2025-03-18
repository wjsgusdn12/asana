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

import dao.GoalDao;
import dto.GoalThingsDto;


@WebServlet("/ExLinkedGoalOfList")
public class ExLinkedGoalOfList extends HttpServlet {
	private static final long serialVersionUID = 1L;
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int projectIdx = Integer.parseInt(request.getParameter("projectIdx"));
		GoalDao goalDao = new GoalDao();
		JSONArray goalIdxArr = new JSONArray(); //목표 idx 리스트들이 남긴 JSONArray 
		ArrayList<Integer> goallist = null; // 조회할 목표들의 idx 리스트 
		try {
			goallist = goalDao.getAllGoalIdxFromProjectIdx(projectIdx);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		for(Integer i : goallist) {
			JSONObject obj = new JSONObject();
			obj.put("goalIdx", i);
			goalIdxArr.add(obj);
			
		}
		
//		for(int i=0; i<goalIdxArr.size(); i++) {
//			System.out.println(goalIdxArr.get(i));
//		}
		
		
		
		ArrayList<GoalThingsDto> goallistDetail = null; // goallist 를 통해 세부 내용 조회 
		try {
			goallistDetail = goalDao.getGoalThingsListFromGoalIdx(goallist);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		JSONArray goalDetailjsonArr = new JSONArray(); 
		for(GoalThingsDto dto : goallistDetail) {
			JSONObject obj = new JSONObject();
			obj.put("profileImg", dto.getProfileImg());
			obj.put("projectPeriodName", dto.getProjectPeriodName());
			obj.put("title", dto.getTitle());
			obj.put("periodIx", dto.getPeriodIdx());
			obj.put("ficalYear", dto.getFicalYear());
			goalDetailjsonArr.add(obj);
			
		}
		
		
		
		response.setCharacterEncoding("utf-8");
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		JSONObject obj = new JSONObject();
		obj.put("goalIdxArr", goalIdxArr);
		obj.put("goalDetailjsonArr", goalDetailjsonArr);
		out.println(obj);
		
	}

}
