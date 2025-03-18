package servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.GoalDao;

@WebServlet("/ExGoalInsert")
public class ExGoalInsert extends HttpServlet {
	private static final long serialVersionUID = 1L;
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int projectIdx = Integer.parseInt(request.getParameter("projectIdx"));
		String goalTitle = request.getParameter("goalTitle");
		int loginMemberIdx = Integer.parseInt(request.getParameter("loginMemberIdx"));
		Integer parentGoalIdx ; // integer 초기화 안해줘도 되나 ?
		if(request.getParameter("parentGoalIdx") != null) {
			parentGoalIdx = Integer.parseInt(request.getParameter("parentGoalIdx"));
		}else {
			parentGoalIdx = null;
		}
		
		int periodIdx = Integer.parseInt(request.getParameter("periodIdx"));
		
		int range = 0;
		String content = null;
		String startDate = null;
		String deadlineDate = null;
		
		int ficalYear = Integer.parseInt(request.getParameter("ficalYear"));
		GoalDao goalDao = new GoalDao();
		int goalIdx = 0; //update 하는 goal_idx 값 리턴 
		try {
			goalIdx = goalDao.insertGoalAllDao(goalTitle, loginMemberIdx, parentGoalIdx, periodIdx, range, content, startDate, deadlineDate, ficalYear);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		System.out.println(goalIdx);
		
		//연결된 목표 테이블에도 insert 문 
		try {
			goalDao.goalConnectionInsert(goalIdx, projectIdx);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
		
	}

}
