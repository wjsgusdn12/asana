package servlet;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.AlarmUpdateDao;


@WebServlet("/ExAlarmUpdateDelete")
public class ExAlarmUpdateDelete extends HttpServlet {
	private static final long serialVersionUID = 1L;
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int memberidx = Integer.parseInt(request.getParameter("memberidx"));
		int projectidx = Integer.parseInt(request.getParameter("projectIdx"));
		System.out.println("삭제할 idx " + memberidx);
		AlarmUpdateDao alarmupdatedao = new AlarmUpdateDao();
		try {
			alarmupdatedao.deleteAlarmUpdate(memberidx);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		RequestDispatcher dispatcher = request.getRequestDispatcher("../../main_outline.jsp?project_idx=" + projectidx);
		dispatcher.forward(request, response);
		
		
		
	}

}
