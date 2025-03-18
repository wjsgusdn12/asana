package servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import static java.time.temporal.ChronoUnit.DAYS;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;

import dao.MemberDao;
import dao.ProjectDao;
import dao.StatusGetAllDao;
import dto.MemberAllDto;
import dto.ProjectStatusDto;
import dto.StatusAllDto;


@WebServlet("/ExProjectStatus")
public class ExProjectStatus extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int projectStatusIdx = Integer.parseInt(request.getParameter("projectStatusIdx"));
		//System.out.println(projectStatusIdx);
		ProjectDao projectDao = new ProjectDao();
		MemberDao memberDao = new MemberDao();
		StatusGetAllDao statusGetAllDao = new StatusGetAllDao();
		ProjectStatusDto projectStatusDto = null; 
		try {
			projectStatusDto = projectDao.projectStatusUpdateDetails(projectStatusIdx);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
		String projectStatusDate = projectStatusDto.getStatusDate(); // 상태 업데이트 날짜 
		SimpleDateFormat formatterprojectStatusDate01 = new SimpleDateFormat("yyyy-MM-dd"); //SimpleDateFormat 사용 
		SimpleDateFormat formatterprojectStatusDate02 = new SimpleDateFormat("MM월dd일");
		Date projectStatusDatePre = null ;
		try {
			projectStatusDatePre = formatterprojectStatusDate01.parse(projectStatusDate.split(" ")[0]);
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		String projectstatusdateFormatPost = formatterprojectStatusDate02.format(projectStatusDatePre);

		//포맷후 날짜 -> obj 로 보내줘야함 10월 12일 
		// projectStatusDatePre --> 상태업데이트 날짜 (Date 타입)
		// TODO : 이 날짜를 오늘 날짜와 비교 ---> "___일 전"
		String strDaysBefore = "일 전";
		String d1 = projectStatusDate.split(" ")[0];   // "yyyy-MM-dd"
		String theDayStatusUpdate = d1.replaceAll("-", "");  //d1.substring(0,4) + d1.substring(5,7) + d1.substring(8);
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMdd");

		LocalDate date1 = LocalDate.parse(theDayStatusUpdate, formatter);
		LocalDate date2 = LocalDate.now();
		long days = DAYS.between(date1, date2);
		strDaysBefore = days + strDaysBefore;
		
		int memberIdx = projectStatusDto.getMemberIdx(); //작성자 idx 
		MemberAllDto memberAllDto = null ;
		try {
			memberAllDto = memberDao.getMemberAllDto(memberIdx);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		int statusIdx = projectStatusDto.getStatusIdx();
		StatusAllDto statusAllDto = null ;
		try {
			statusAllDto = statusGetAllDao.getStatusAllDto(statusIdx);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		 
		 
		 response.setCharacterEncoding("utf-8");
		 response.setContentType("application/json"); 
		 PrintWriter out = response.getWriter();
		 JSONObject obj = new JSONObject();
		 obj.put("projectstatusdateFormatPost", projectstatusdateFormatPost);
		 obj.put("profileImg", memberAllDto.getProfileImg());
		 obj.put("nickName", memberAllDto.getNickname());
		 obj.put("statusBackGroundColor",statusAllDto.getBackgroundColor());
		 obj.put("statusName", statusAllDto.getName());
		 obj.put("statusChar", statusAllDto.getCharColor());
		 obj.put("strDaysBefore", strDaysBefore);
		 out.println(obj);
	}
}
