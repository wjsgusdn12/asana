package servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.WamDao;


@WebServlet("/ExSubtaskDelete")
public class ExSubtaskDelete extends HttpServlet {
	private static final long serialVersionUID = 1L;
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int wamidx = Integer.parseInt(request.getParameter("wamidx")); //지금 마일스톤 idx 
		int clickidx = Integer.parseInt(request.getParameter("clickidx")); //클릭한 wamidx 
		WamDao wamdao = new WamDao();
		try {
			wamdao.deletePrecedingIdx(wamidx);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
		
	}

}
