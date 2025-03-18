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


@WebServlet("/ExAddPrerequisiteWork")
public class ExAddPrerequisiteWork extends HttpServlet {
	private static final long serialVersionUID = 1L;
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int wamidx = Integer.parseInt(request.getParameter("wamidx")); //선행 작업 
		int followingIdx = Integer.parseInt(request.getParameter("followingIdx")); //내가 선택해 조회되는 idx 
		WamDao wamdao = new WamDao();
		// 선행작업 insert 하는 문 
		try {
			wamdao.wamOfFollowingUpdate(followingIdx, wamidx);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		};
		
		// 선행 작업은 리스트로 뽑아야한다.
		
		JSONArray arrJson = new JSONArray();
		ArrayList<WamAllDto> dtolist = null;
		try {
			dtolist = wamdao.precedingWamGet(followingIdx);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		for(WamAllDto dto : dtolist) {
			JSONObject obj = new JSONObject();
			obj.put("precedingidx", dto.getWamIdx());
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
