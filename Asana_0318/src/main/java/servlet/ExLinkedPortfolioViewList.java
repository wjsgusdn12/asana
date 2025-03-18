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

@WebServlet("/ExLinkedPortfolioViewList")
public class ExLinkedPortfolioViewList extends HttpServlet {
	private static final long serialVersionUID = 1L;
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int projectIdx = Integer.parseInt(request.getParameter("projectIdx"));
		PortfolioDao portfolioDao = new PortfolioDao();
		ArrayList<PortfolioAllDto> portfolioAllDto = null; //조회될 포트폴리오 이름, idx 
		try {
			portfolioAllDto = portfolioDao.connectedPortfolioClickGetDto(projectIdx);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
		JSONArray JsonArr = new JSONArray();
		
//		for(PortfolioAllDto dto: portfolioAllDto) {
//			JSONObject obj = new JSONObject();
//			obj.put("selectPortfolioList", dto);
//			JsonArr.add(obj);
//			//JsonArr.add(dto);
//		}
//		
//		//근데 만약 for 문 돌리지 않고 
//	//	JsonArr.add(portfolioAllDto);
//		out.println(JsonArr);
		
		//내가 지금 하고싶은게 뭐냐 portfolioAllDto 는 ArrayList 로 값이 들어있음
		//이걸 리스트 타입으로 참조값 자체를 넘길수없는건가 ?.. 
		
		for(PortfolioAllDto dto : portfolioAllDto) {
			JSONObject obj = new JSONObject();
			obj.put("selectPortfolioName", dto.getName());
			obj.put("selectPortfolioIdx", dto.getPortfolioIdx());
			JsonArr.add(obj);
		}
		
		response.setCharacterEncoding("utf-8");
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		out.println(JsonArr);
		
		
		
		
		
		
		
		
		
		
	}

}
