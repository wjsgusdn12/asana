package servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;

import dao.MemberDao;
import dao.WamDao;
import dto.MemberAllDto;
import dto.WamAllDto;


@WebServlet("/ExWamInsert")
public class ExWamInsert extends HttpServlet {
	private static final long serialVersionUID = 1L;
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String title = request.getParameter("title");
		int manageridx = Integer.parseInt(request.getParameter("manageridx"));
		String deadline = request.getParameter("deadline");
		String content = request.getParameter("content");
		int projectidx = Integer.parseInt(request.getParameter("projectidx"));
		
		
		//wam 테이블에 insert 하는 문  .. 이때도 리턴 idx해서 
		WamDao wamdao = new WamDao();
		int wamidx = 0; //wamidx 리턴함 
		try {
			wamidx = wamdao.insertNewWam(projectidx, title, manageridx, deadline, content);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		//success 시 넘겨야할것들  .. 조건으로 
		WamAllDto wamalldto = null;
		try {
			wamalldto = wamdao.wamGetAlldto(wamidx);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
	
		MemberDao memdao = new MemberDao();
		MemberAllDto memdto = null;
		try {
			memdto = memdao.getMemberAllDto(wamalldto.getManagerIdx());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		String deadlineDate = wamalldto.getDeadlineDate(); //2024/01/20
		SimpleDateFormat formatterDate01 = new SimpleDateFormat("yyyy-MM-dd"); //SimpleDateFormat 사용 
		SimpleDateFormat formatterDate02 = new SimpleDateFormat("MM월dd일");
		String formatdeadlineDate = null;
		if (deadlineDate != null) {
			Date projectStatusDate = null;
			try {
				projectStatusDate = formatterDate01.parse(deadlineDate.split(" ")[0]);
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			formatdeadlineDate = formatterDate02.format(projectStatusDate);
		}
		
		String correctionDate = wamalldto.getCorrectionDate();
		String formatcorrectionDate = null; //포맷후 
		if (correctionDate != null) {
			Date projectStatusDate = null;
			try {
				projectStatusDate = formatterDate01.parse(correctionDate.split(" ")[0]);
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			formatcorrectionDate = formatterDate02.format(projectStatusDate);
		}
		
		String createDate = wamalldto.getCreateDate();
		String formatcreateDate = null;
		if (createDate != null) {
			Date projectStatusDate = null;
			try {
				projectStatusDate = formatterDate01.parse(createDate.split(" ")[0]);
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			formatcreateDate = formatterDate02.format(projectStatusDate);
		}
		
		response.setCharacterEncoding("utf-8");
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		JSONObject obj = new JSONObject();
		obj.put("wamidx",  wamidx);
		obj.put("title", wamalldto.getTitle());
		obj.put("nickname", memdto.getNickname());
		obj.put("profileimg", memdto.getProfileImg());
		obj.put("deadlineDate", formatdeadlineDate);
		obj.put("correctionDate", formatcorrectionDate);
		obj.put("createDate", formatcreateDate);
		out.println(obj);
		
		
		
		
	
		
		
		
		
		
	}

}
