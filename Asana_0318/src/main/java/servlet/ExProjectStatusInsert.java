package servlet;

import static java.time.temporal.ChronoUnit.DAYS;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import dao.AlarmUpdateDao;
import dao.MemberDao;
import dao.ProjectDao;
import dao.StatusGetAllDao;
import dto.MemberAllDto;
import dto.ProjectAllDto;
import dto.ProjectStatusDto;
import dto.StatusAllDto;


@WebServlet("/ExProjectStatusInsert")
public class ExProjectStatusInsert extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
   
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int statusIdx = Integer.parseInt(request.getParameter("statusIdx"));
		int loginMemberIdx = Integer.parseInt(request.getParameter("loginMemberIdx"));
		int projectIdx = Integer.parseInt(request.getParameter("projectIdx"));
		ProjectDao projectDao = new ProjectDao();
		MemberDao memberDao = new MemberDao();
		AlarmUpdateDao alarmupdatedao = new AlarmUpdateDao();
		StatusGetAllDao statusGetAllDao = new StatusGetAllDao();

		try {
			projectDao.projectStatusInsertDto( statusIdx, projectIdx, loginMemberIdx);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		//프로젝트의 이름 조회하기 위해서 
		ProjectAllDto projectAllDto = null;
		try {
			projectAllDto = projectDao.getProjectAllDto(projectIdx);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		//project_status_idx 
		//가장 최신 업데이트 된 데이터 
		ProjectStatusDto projectstatusdto = null;
		try {
			projectstatusdto = projectDao.recentProjectStatusDto(projectIdx);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		String projectStatusDate = projectstatusdto.getStatusDate(); //포맷하기전 Date 
		
		SimpleDateFormat formatterDate01 = new SimpleDateFormat("yyyy-MM-dd"); //SimpleDateFormat 사용 
		SimpleDateFormat formatterDate02 = new SimpleDateFormat("MM월dd일");
		Date projectStatusDatePre = null;
		try {
			projectStatusDatePre = formatterDate01.parse(projectStatusDate.split(" ")[0]);
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		String projectstatusdateFormatPost = formatterDate02.format(projectStatusDatePre); //_월 _ 일 형식인 데이터 
		
		
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
		
		int memberIdx = projectstatusdto.getMemberIdx(); //작성자 idx 
		MemberAllDto memberAllDto = null ;
		try {
			memberAllDto = memberDao.getMemberAllDto(memberIdx);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		int updateStatusIdx = projectstatusdto.getStatusIdx(); // 업데이트된 statusIdx 
		StatusAllDto statusAllDto = null ;
		try {
			statusAllDto = statusGetAllDao.getStatusAllDto(updateStatusIdx);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
		
		//프로젝트 상태 업데이트 목록 
		ArrayList<ProjectStatusDto> projectstatusDtoList = null;
		try {
			projectstatusDtoList = projectDao.projectStatusinventoryDto(projectIdx);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
		
		
		response.setCharacterEncoding("utf-8");
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();

		JSONArray jsonArr = new JSONArray(); //프로젝트 상태 업데이트 목록의 참조값을 저장하는 Array 
		for(ProjectStatusDto dto : projectstatusDtoList) {
			JSONObject obj = new JSONObject();
			// dto --> obj
			dto.getProjectStatusIdx(); //프로젝트 statusIdx 
			String statusDate = dto.getStatusDate();
			SimpleDateFormat formatter01 = new SimpleDateFormat("yyyy-MM-dd"); //SimpleDateFormat 사용 
			SimpleDateFormat formatter02 = new SimpleDateFormat("MM월dd일");
			Date projectStatusDate02 = null;
			try {
				projectStatusDate02 = formatter01.parse(statusDate.split(" ")[0]);
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			String projectstatusdateFormatPost02 = formatter02.format(projectStatusDate02); //__ 월 __일 형식 
			
			//status 색상, 이름 ..
			int statuslistIdx = dto.getStatusIdx();
			StatusGetAllDao statusGetAllDao02 = new StatusGetAllDao();
			StatusAllDto statuslistDto = null;
			try {
				statuslistDto = statusGetAllDao02.getStatusAllDto(statuslistIdx);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			statuslistDto.getBackgroundColor();
			statuslistDto.getCharColor();
			statuslistDto.getCircleColor();
			statuslistDto.getName();
			
			obj.put("porjectStatusListIdx", dto.getProjectStatusIdx());
			obj.put("projectStatusdateFormatPost02", projectstatusdateFormatPost02);
			obj.put("projectStatusListBackground", 	statuslistDto.getBackgroundColor());
			obj.put("projectStatusListCharColor", statuslistDto.getCharColor());
			obj.put("projectStatusCircleColor", statuslistDto.getCircleColor());
			obj.put("projectStatusName", statuslistDto.getName());
			jsonArr.add(obj);
			
		}
		
		JSONObject obj = new JSONObject();
		obj.put("projectStatusIdx",projectstatusdto.getProjectStatusIdx());
		obj.put("projectstatusdateFormatPost", projectstatusdateFormatPost);
		obj.put("nickname", memberAllDto.getNickname());
		obj.put("profileImg", memberAllDto.getProfileImg());
		obj.put("strDaysBefore",strDaysBefore);
		obj.put("statusCharColor", statusAllDto.getCharColor());
		obj.put("statusName", statusAllDto.getName());
		obj.put("arrStatus", jsonArr);
		out.println(obj); 
		
		
		
		
		
		
		
		
		
	}

}
