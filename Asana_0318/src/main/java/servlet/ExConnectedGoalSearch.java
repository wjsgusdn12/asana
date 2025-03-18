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

@WebServlet("/ExConnectedGoalSearch")
public class ExConnectedGoalSearch extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		int projectIdx = Integer.parseInt(request.getParameter("projectIdx"));
		String goalTitle = request.getParameter("goalTitle");
		GoalDao goalDao = new GoalDao();
		
		Integer count = null; // 0보다 크면 데이터 존재 , 0과 같으면 데이터 없음
		try {
			count = goalDao.connectedGoalSearchCheck(projectIdx, goalTitle);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		if (count > 0) {
			JSONArray goalIdxArr = new JSONArray();
			ArrayList<Integer> searchGoalList = null; // 검색되어지는 goalList
			try {
				searchGoalList = goalDao.connectedGoalSearch(projectIdx, goalTitle);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

			for (Integer i : searchGoalList) {
				JSONObject obj = new JSONObject();
				obj.put("goalIdx", i);
				goalIdxArr.add(obj);
			}

//			for(int i=0; i<searchGoalList.size(); i++) {
//				System.out.println(searchGoalList.get(i));
//			}

			ArrayList<GoalThingsDto> goallistDetail = null; // goallist 를 통해 세부 내용 조회
			try {
				goallistDetail = goalDao.getGoalThingsListFromGoalIdx(searchGoalList);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

			JSONArray goalDetailjsonArr = new JSONArray();
			for (GoalThingsDto dto : goallistDetail) {
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
			obj.put("count", 1);
			obj.put("goalIdxArr", goalIdxArr);
			obj.put("goalDetailjsonArr", goalDetailjsonArr);
			out.println(obj);

		}else {
			response.setCharacterEncoding("utf-8");
			response.setContentType("application/json");
			PrintWriter out = response.getWriter();
			JSONObject obj = new JSONObject();
			obj.put("count", 0);
			out.println(obj);
			
		}

	}

}
