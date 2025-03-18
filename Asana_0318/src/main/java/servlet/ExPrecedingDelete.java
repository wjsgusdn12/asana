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

import dao.WamDao;
import dto.WamAllDto;


@WebServlet("/ExPrecedingDelete")
public class ExPrecedingDelete extends HttpServlet {
	private static final long serialVersionUID = 1L;
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int wamidx = Integer.parseInt(request.getParameter("wamidx")); // 마일스톤 idx 
		int clickidx = Integer.parseInt(request.getParameter("clickidx")); // 삭제할 선행 idx 
		
		WamDao wamdao = new WamDao();
		try {
			wamdao.deletePrecedingIdx(clickidx);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		//선행 리스트 조회하기 
		JSONArray arrJson = new JSONArray();
		ArrayList<WamAllDto> dtolist = null;
		try {
			dtolist = wamdao.precedingWamGet(wamidx);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		for(WamAllDto dto : dtolist) {
			JSONObject obj = new JSONObject();
			obj.put("wamidx", dto.getWamIdx());
			obj.put("wamtitle", dto.getTitle());
			obj.put("completedate", dto.getCompleteDate());
			arrJson.add(obj);
			
		}
		
		
		response.setCharacterEncoding("utf-8");
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		out.println(arrJson);
		
	}

}
