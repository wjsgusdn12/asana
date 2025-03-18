package servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import dao.MemberDao;
import dao.WamDao;
import dto.MemberAllDto;
import dto.WamAllDto;


@WebServlet("/ExCheckWam")
public class ExCheckWam extends HttpServlet {
	private static final long serialVersionUID = 1L;
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int wamidx = Integer.parseInt(request.getParameter("wamidx"));
		int projectidx = Integer.parseInt(request.getParameter("projectidx"));
		
		//작업이 완료 되었는지 확인 
		WamDao wamdao = new WamDao();
		MemberDao memberdao = new MemberDao();
		WamAllDto checkcompletedatedto = null;
		try {
			checkcompletedatedto = wamdao.wamGetAlldto(wamidx);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		String completedate = checkcompletedatedto.getCompleteDate();
		if(completedate==null) {
			//작업이 완료 되었지 않았다면 완료 : update 
			try {
				wamdao.wamofCompleteUpdateDto(wamidx);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		
		JSONArray completeobj = new JSONArray(); // 완료 섹션의 리스트들 
		ArrayList<WamAllDto> completelist = null;
		try {
			completelist = wamdao.boardOfCompletedWam(projectidx);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
		for(WamAllDto dto : completelist) {
			//데이터 받아와서 넘겨야함 
			JSONObject obj = new JSONObject();
			int wamidx01 = dto.getWamIdx(); //wamidx  
			WamDao wamdao01 = new WamDao();
			ArrayList<WamAllDto> completedtolist01 = null; 
			try {
				completedtolist01 = wamdao01.precedingWamGet(wamidx);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			int completedatecheck = completedtolist01.size(); // 0 : 선행없음 0이상시 : 선행있
			String title = dto.getTitle(); 
			MemberAllDto memberAllDto = null;
			try {
				memberAllDto = memberdao.getMemberAllDto(dto.getManagerIdx());
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			
			String nickname = memberAllDto.getNickname(); 
			String profileimg = memberAllDto.getProfileImg();
			
			
			
			String deadlineDate = dto.getDeadlineDate();
			SimpleDateFormat formatterDate01 = new SimpleDateFormat("yyyy-MM-dd"); //SimpleDateFormat 사용 
			SimpleDateFormat formatterDate02 = new SimpleDateFormat("MM월dd일");
			String deadlineformatDate = null; 
			if (deadlineDate != null) {
				Date projectStatusDate = null;
				try {
					projectStatusDate = formatterDate01.parse(deadlineDate.split(" ")[0]);
				} catch (ParseException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				deadlineformatDate = formatterDate02.format(projectStatusDate);
			}
			
			int createIdx = dto.getCreatorIdx(); //생성한 사용자 idx 
			MemberAllDto memberAllDto02 = null;
			try {
				memberAllDto02 = memberdao.getMemberAllDto(createIdx);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			String createnickname = memberAllDto02.getNickname(); 
			
			String createDate = dto.getCreateDate(); //생성한 날짜 
			String createPostDate = null; 
			if (createDate != null) {
				Date createDate01 = null;
				try {
					createDate01 = formatterDate01.parse(createDate.split(" ")[0]);
				} catch (ParseException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				createPostDate = formatterDate02.format(createDate01);
			}
			
			String correctionDate = dto.getCorrectionDate(); //마지막 수정일 
			String correctionFormat = null;  
			if (correctionDate != null) {
				Date correctionDate01 = null;
				try {
					correctionDate01 = formatterDate01.parse(correctionDate.split(" ")[0]);
				} catch (ParseException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				correctionFormat = formatterDate02.format(correctionDate01);
			}
			
			//완료일 데이터 
			String completeDate = dto.getCompleteDate(); //값 넘기기 
			String completeDateFormat = null; //값 넘기기 
			if (completeDate != null) {
				Date completeDate01 = null;
				try {
					completeDate01 = formatterDate01.parse(completeDate.split(" ")[0]);
				} catch (ParseException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				completeDateFormat = formatterDate02.format(completeDate01);
			}
			
			System.out.println(completeDate);
			
			obj.put("wamidx01", wamidx01);
			obj.put("completedatecheck", completedatecheck); // 0이면 선행 없음 0 이상시 선행 있음
			obj.put("title", title);
			obj.put("nickname", nickname); 
			obj.put("profileimg", profileimg);
			obj.put("deadlineformatDate", deadlineformatDate);
			obj.put("createnickname", createnickname);
			obj.put("createPostDate", createPostDate);
			obj.put("correctionFormat", correctionFormat);
			obj.put("completeDate", completeDate); // 완료 데이터 포맷 전 --> 체크 svg 할때 필ㄹ요 
			obj.put("completeDateFormat", completeDateFormat);
			completeobj.add(obj);
			
		}
		
		//수행중 섹션의 wamlist 
		JSONArray runningobj = new JSONArray();
		ArrayList<WamAllDto> runningwamlist = null;
		try {
			runningwamlist = wamdao.runningWamlist(projectidx);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		for(WamAllDto dto : runningwamlist) {
			JSONObject obj = new JSONObject();
			int wamidx01 = dto.getWamIdx(); //wamidx  
			WamDao wamdao01 = new WamDao();
			int aaa = dto.getCreatorIdx();
			System.out.println(aaa);
			ArrayList<WamAllDto> completedtolist01 = null; 
			try {
				completedtolist01 = wamdao01.precedingWamGet(wamidx);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			int completedatecheck = completedtolist01.size(); // 0 : 선행없음 0이상시 : 선행있
			String title = dto.getTitle(); 
			MemberAllDto memberAllDto = null;
			try {
				memberAllDto = memberdao.getMemberAllDto(dto.getManagerIdx());
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			String nickname = memberAllDto.getNickname(); 
			String profileimg = memberAllDto.getProfileImg();
			
			
			
			String deadlineDate = dto.getDeadlineDate();
			SimpleDateFormat formatterDate01 = new SimpleDateFormat("yyyy-MM-dd"); //SimpleDateFormat 사용 
			SimpleDateFormat formatterDate02 = new SimpleDateFormat("MM월dd일");
			String deadlineformatDate = null; 
			if (deadlineDate != null) {
				Date projectStatusDate = null;
				try {
					projectStatusDate = formatterDate01.parse(deadlineDate.split(" ")[0]);
				} catch (ParseException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				deadlineformatDate = formatterDate02.format(projectStatusDate);
			}
			
			int createIdx = dto.getCreatorIdx(); //생성한 사용자 idx 
			MemberAllDto memberAllDto02 = null;
			try {
				memberAllDto02 = memberdao.getMemberAllDto(createIdx);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			String createnickname = memberAllDto02.getNickname(); 
			
			String createDate = dto.getCreateDate(); //생성한 날짜 
			String createPostDate = null; 
			if (createDate != null) {
				Date createDate01 = null;
				try {
					createDate01 = formatterDate01.parse(createDate.split(" ")[0]);
				} catch (ParseException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				createPostDate = formatterDate02.format(createDate01);
			}
			
			String correctionDate = dto.getCorrectionDate(); //마지막 수정일 
			String correctionFormat = null;  
			if (correctionDate != null) {
				Date correctionDate01 = null;
				try {
					correctionDate01 = formatterDate01.parse(correctionDate.split(" ")[0]);
				} catch (ParseException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				correctionFormat = formatterDate02.format(correctionDate01);
			}
			
			//완료일 데이터 
			String completeDate = dto.getCompleteDate(); //값 넘기기 
			String completeDateFormat = null; //값 넘기기 
			if (completeDate != null) {
				Date completeDate01 = null;
				try {
					completeDate01 = formatterDate01.parse(completeDate.split(" ")[0]);
				} catch (ParseException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				completeDateFormat = formatterDate02.format(completeDate01);
			}
			
			obj.put("wamidx01", wamidx01);
			obj.put("completedatecheck", completedatecheck); // 0이면 선행 없음 0 이상시 선행 있음
			obj.put("title", title);
			obj.put("nickname", nickname); 
			obj.put("profileimg", profileimg);
			obj.put("deadlineformatDate", deadlineformatDate);
			obj.put("createnickname", createnickname);
			obj.put("createPostDate", createPostDate);
			obj.put("correctionFormat", correctionFormat);
			obj.put("completeDate", completeDate); // 완료 데이터 포맷 전 --> 체크 svg 할때 필ㄹ요 
			obj.put("completeDateFormat", completeDateFormat);
			runningobj.add(obj);
		}
		
		
		
		
		
		JSONArray allobj = new JSONArray();
		ArrayList <WamAllDto> allwamlist = null;
		try {
			allwamlist = wamdao.allSectionWamlist(projectidx);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		for(WamAllDto dto : allwamlist) {
			JSONObject obj = new JSONObject();
			int wamidx01 = dto.getWamIdx(); //wamidx  
			WamDao wamdao01 = new WamDao();
			ArrayList<WamAllDto> completedtolist01 = null; 
			try {
				completedtolist01 = wamdao01.precedingWamGet(wamidx);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			int completedatecheck = completedtolist01.size(); // 0 : 선행없음 0이상시 : 선행있
			String title = dto.getTitle(); 
			MemberAllDto memberAllDto = null;
			try {
				memberAllDto = memberdao.getMemberAllDto(dto.getManagerIdx());
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			String nickname = memberAllDto.getNickname(); 
			String profileimg = memberAllDto.getProfileImg();
			
			
			
			String deadlineDate = dto.getDeadlineDate();
			SimpleDateFormat formatterDate01 = new SimpleDateFormat("yyyy-MM-dd"); //SimpleDateFormat 사용 
			SimpleDateFormat formatterDate02 = new SimpleDateFormat("MM월dd일");
			String deadlineformatDate = null; 
			if (deadlineDate != null) {
				Date projectStatusDate = null;
				try {
					projectStatusDate = formatterDate01.parse(deadlineDate.split(" ")[0]);
				} catch (ParseException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				deadlineformatDate = formatterDate02.format(projectStatusDate);
			}
			
			int createIdx = dto.getCreatorIdx(); //생성한 사용자 idx 
			MemberAllDto memberAllDto02 = null;
			try {
				memberAllDto02 = memberdao.getMemberAllDto(createIdx);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			String createnickname = memberAllDto02.getNickname(); 
			
			String createDate = dto.getCreateDate(); //생성한 날짜 
			String createPostDate = null; 
			if (createDate != null) {
				Date createDate01 = null;
				try {
					createDate01 = formatterDate01.parse(createDate.split(" ")[0]);
				} catch (ParseException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				createPostDate = formatterDate02.format(createDate01);
			}
			
			String correctionDate = dto.getCorrectionDate(); //마지막 수정일 
			String correctionFormat = null;  
			if (correctionDate != null) {
				Date correctionDate01 = null;
				try {
					correctionDate01 = formatterDate01.parse(correctionDate.split(" ")[0]);
				} catch (ParseException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				correctionFormat = formatterDate02.format(correctionDate01);
			}
			
			//완료일 데이터 
			String completeDate = dto.getCompleteDate(); //값 넘기기 
			String completeDateFormat = null; //값 넘기기 
			if (completeDate != null) {
				Date completeDate01 = null;
				try {
					completeDate01 = formatterDate01.parse(completeDate.split(" ")[0]);
				} catch (ParseException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				completeDateFormat = formatterDate02.format(completeDate01);
			}
			
			obj.put("wamidx01", wamidx01);
			obj.put("completedatecheck", completedatecheck); // 0이면 선행 없음 0 이상시 선행 있음
			obj.put("title", title);
			obj.put("nickname", nickname); 
			obj.put("profileimg", profileimg);
			obj.put("deadlineformatDate", deadlineformatDate);
			obj.put("createnickname", createnickname);
			obj.put("createPostDate", createPostDate);
			obj.put("correctionFormat", correctionFormat);
			obj.put("completeDate", completeDate); // 완료 데이터 포맷 전 --> 체크 svg 할때 필ㄹ요 
			obj.put("completeDateFormat", completeDateFormat);
			allobj.add(obj);
			
			
		}
		
		
		response.setCharacterEncoding("utf-8");
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		JSONObject obj = new JSONObject();
		obj.put("completeobj", completeobj);
		obj.put("runningobj", runningobj);
		obj.put("allobj", allobj);
		out.println(obj);
		
		
	}

}
