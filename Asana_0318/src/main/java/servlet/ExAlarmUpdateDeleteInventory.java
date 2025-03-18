package servlet;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.AlarmUpdateDao;


@WebServlet("/ExAlarmUpdateDeleteInventory")
public class ExAlarmUpdateDeleteInventory extends HttpServlet {
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int memberidx = Integer.parseInt(request.getParameter("memberidx"));
		int projectidx = Integer.parseInt(request.getParameter("projectidx"));
		//System.out.println("삭제할 idx " + memberidx);
		AlarmUpdateDao alarmupdatedao = new AlarmUpdateDao();
		try {
			alarmupdatedao.deleteAlarmUpdate(memberidx);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		RequestDispatcher dispatcher = request.getRequestDispatcher("../../main_inventory.jsp?project_idx="+projectidx);
		dispatcher.forward(request, response);
		
		
	}
}
