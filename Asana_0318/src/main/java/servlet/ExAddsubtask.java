package servlet;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;

import dao.WamDao;
import dto.WamAllDto;


@WebServlet("/ExAddsubtask")
public class ExAddsubtask extends HttpServlet {
	private static final long serialVersionUID = 1L;
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int wamidx = Integer.parseInt(request.getParameter("wamidx"));
		int followingidx = Integer.parseInt(request.getParameter("followingIdx"));
		
		
		
		// 후속 : //milestonidx 가 2일때 후속 작업을 3으로 넣고싶다면  
		//update wam set following_idx = 3 where wam_idx=2;
		//followingIdx = 3, wamidx = 2
		//let wamidx; 내가 클릭한 idx -> following_idx 
		//let followingIdx; 지금 마일스톤 -> wam_idx 
		
		
		WamDao wamdao = new WamDao();
		// 종속작업 insert 하는 문 
		try {
			wamdao.wamOfFollowingUpdate(wamidx, followingidx);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		};
		
		//종속 작업 select 
		//followingidx
		WamAllDto dto = null;
		try {
			dto = wamdao.wamGetAlldto(followingidx);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		JSONObject obj = new JSONObject();
		Integer subtaskidx = dto.getFollowingIdx(); // 종속 idx 조회 
		WamAllDto subtaskDto = null;
		if(subtaskidx != null) {
			try {
				subtaskDto = wamdao.wamGetAlldto(subtaskidx);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			obj.put("title", subtaskDto.getTitle());
			obj.put("completedate", subtaskDto.getCompleteDate());
			
			
			
			
		}
		obj.put("followingidx", followingidx);
		
		
		response.setCharacterEncoding("utf-8");
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		out.println(obj);
		
		
		
		
		
		
		
		
		
	}

}
