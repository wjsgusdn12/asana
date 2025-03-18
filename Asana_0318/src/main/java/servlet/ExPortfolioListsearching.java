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

import dao.PortfolioDao;
import dto.PortfolioAllDto;


@WebServlet("/ExPortfolioListsearching")
public class ExPortfolioListsearching extends HttpServlet {
	private static final long serialVersionUID = 1L;
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String portfolioName = request.getParameter("portfolioName");
		int projectIdx = Integer.parseInt(request.getParameter("projectIdx"));		
		
		//일단 검색한 내용이 존재하는지 확인하는메서드 -> count > 0 리스트 뽑아 상세 내용 조회 
		PortfolioDao portfolioDao = new PortfolioDao();
		int count = 0;
		try {
			count =portfolioDao.portfolioSearchCount(projectIdx, portfolioName);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		ArrayList<PortfolioAllDto> searchPortfoliolist = null;
		if(count>0) {
			try {
				searchPortfoliolist = portfolioDao.connectedPortfolioSearch(projectIdx, portfolioName);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			JSONArray JsonArr = new JSONArray();
			for(PortfolioAllDto dto : searchPortfoliolist) {
				JSONObject obj = new JSONObject();
				obj.put("portfolioName", dto.getName());
				obj.put("portfolioIdx", dto.getPortfolioIdx());
				JsonArr.add(obj);
				
				
			}
			
			response.setCharacterEncoding("utf-8");
			response.setContentType("application/json");
			PrintWriter out = response.getWriter();
			out.println(JsonArr);
		}
		
		
		
		
	}

}
