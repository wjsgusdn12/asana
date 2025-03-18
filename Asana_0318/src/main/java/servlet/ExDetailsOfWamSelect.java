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

import dao.MemberDao;
import dao.ProjectDao;
import dao.WamDao;
import dto.MemberAllDto;
import dto.ProjectAllDto;
import dto.WamAllDto;

@WebServlet("/ExDetailsOfWamSelect")
public class ExDetailsOfWamSelect extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		int wamidx = Integer.parseInt(request.getParameter("wamidx"));
		WamDao wamDao = new WamDao();
		MemberDao memberDao1 = new MemberDao();
		ProjectDao projectDao1 = new ProjectDao();

		// 특정 wamIdx 의 상세 정보 조회
		WamAllDto wamDto = null;
		try {
			wamDto = wamDao.wamGetAlldto(wamidx);
		} catch (Exception e) {
			e.printStackTrace();
		} 

		JSONObject obj = new JSONObject();
		
//		System.out.println("타입 : " + wamDto.getWamType()); // 마일스톤
//		System.out.println("제목 : " + wamDto.getTitle()); // 스토리보드 완성
//		System.out.println("담당자idx : " + wamDto.getManagerIdx()); // ---->
		MemberAllDto managerMemberAllDto = null;
		try {
			managerMemberAllDto = memberDao1.getMemberAllDto(wamDto.getManagerIdx());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
//			if(managerMemberAllDto==null) {
//				System.out.println("null이면 안 되는데... when manager_idx=" + dto.getManagerIdx() + ", wam_idx=" + dto.getWamIdx());
//			}
//		System.out.println("담당자 profile_img : " + managerMemberAllDto.getProfileImg());
//		System.out.println("담당자 name : " + managerMemberAllDto.getNickname());
//		System.out.println("부재 종료일 : " + managerMemberAllDto.getDeadlineDate());

		int projectIdx = wamDto.getProjectIdx();
		System.out.println("프로젝트 idx : " + projectIdx);
		ProjectAllDto projectAllDto11 = null;
		try {
			projectAllDto11 = projectDao1.getProjectAllDto(projectIdx);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		System.out.println("프로젝트 이름 : " + projectAllDto11.getName());

		// 프로젝트 섹션 -- 완료 date null 일때 수행중, 완료 date !=null 시 완료
		String completeDate = wamDto.getCompleteDate();
		// null : 수행중
		// != null : 완료
		
		// 종속보여주기 : 종속보여줄때 null 인지 확인하는 여부
		Integer followingWamIdx = wamDto.getFollowingIdx();
		if (followingWamIdx != null) {
			WamAllDto listwamDtoFollowing = null;
			try {
				listwamDtoFollowing = wamDao.wamGetAlldto(followingWamIdx);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			// wam_idx 를 통해 모든 컬럼 조회

//			System.out.println("후속 작업 -> ");
//			System.out.println("\t타입 : " + listwamDtoFollowing.getWamType()); // 타입 - 빨간색 마름모
//			System.out.println("\t이름 : " + listwamDtoFollowing.getTitle()); // "자바 공부하기"
//			System.out.println("\t마감일 : " + listwamDtoFollowing.getDeadlineDate());// "11월 1일"
			System.out.println("후속 idx :" + listwamDtoFollowing.getWamIdx());
			obj.put("followingidx", listwamDtoFollowing.getWamIdx());
			obj.put("followingType", ""+listwamDtoFollowing.getWamType());
			obj.put("followingTitle", listwamDtoFollowing.getTitle());
			obj.put("followingDeadlineDate", listwamDtoFollowing.getDeadlineDate());
		}

		// 나의 선행 이름 보여주기
		JSONArray precedingArr = new JSONArray();
		ArrayList<WamAllDto> wamDtofollowinglist = null;
		try {
			wamDtofollowinglist = wamDao.precedingWamGet(wamidx);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} // 선행을 보여주는 dto

		if (wamDtofollowinglist != null) {
			for (WamAllDto dto1 : wamDtofollowinglist) {
				JSONObject obj03 = new JSONObject();
//				System.out.println("선행작업 보여주기 -->");
//				System.out.println("선생작업 타입 :" + dto1.getWamType());
//				System.out.println("선생작업 제목 :" + dto1.getTitle());
//				System.out.println("선생작업 마감일 :" + dto1.getDeadlineDate());
				System.out.println("선행 idx :" + dto1.getWamIdx());
				obj03.put("precedingidx", dto1.getWamIdx());
				obj03.put("precedingWamType", ""+ dto1.getWamType());
				obj03.put("precedingTitle",  dto1.getTitle());
				obj03.put("precedingDeadlineDate", dto1.getDeadlineDate());
				precedingArr.add(obj03);

			}

		}

		int precedingIdx = 0; // 선행 리스트 wamDtofollowinglist null 일때 0
		if (wamDtofollowinglist != null) {
			precedingIdx = 1; // null 이 아닐때 1
		}

		// 하위작업 보여주기 - 일단은 안 하는걸로
//			ArrayList<WamAllDto> wamsubTestlist = wamDao.subTaskGet(wamIdx); //선행을 보여주는 dto 
//			for(WamAllDto dto1 : wamsubTestlist) {
//				System.out.println("하위작업보여주기  -->");
//				
//				System.out.println("하위작업 제목 :" + dto1.getTitle());
//				System.out.println("하위작업 마감일 :" + dto1.getDeadlineDate());
//				System.out.println("wam_idx : " + dto1.getWamIdx());
//				System.out.println("하위작업 담당자 Idx  :" + dto1.getManagerIdx());
//				MemberAllDto dto2 = memberDao1.getMemberDto(dto1.getManagerIdx());
//				System.out.println("담당자 name " + dto2.getNickname());
//			    System.out.println("담당자 프로필 " + dto2.getProfileImg() );
//			}
		
		obj.put("wamidx", wamidx);
		obj.put("wamtype", "" + wamDto.getWamType());
		obj.put("title", wamDto.getTitle());
		obj.put("memberIdx", wamDto.getManagerIdx());
		obj.put("memberProfileImg", managerMemberAllDto.getProfileImg());
		obj.put("nickName", managerMemberAllDto.getNickname());
		obj.put("deadlineDate", wamDto.getDeadlineDate());
		obj.put("projectName", projectAllDto11.getName());
		obj.put("projectIdx", projectIdx);
		obj.put("completeDate", completeDate);
		obj.put("followingWamIdx", followingWamIdx); //종속보여줄때 null 인지 확인하는 여부
		obj.put("precedingIdx", precedingIdx); // null 일때 0
		obj.put("wamContent", wamDto.getContent());

		response.setCharacterEncoding("utf-8");
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		JSONObject passobj = new JSONObject();
		passobj.put("obj", obj);
		passobj.put("precedingArr", precedingArr);
		out.println(passobj);

	}

}
