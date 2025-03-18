package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Scanner;

import dto.ProjectAllDto;
import dto.ProjectDto;
import dto.ProjectMemberInsertDto;
import dto.ProjectParticipantsDto;
import dto.ProjectStatusDto;
import dto.Project_participantsThingsDto;
import dto.SelectProject_idxGetmemberDto;
import dto.StatusAllDto;
import dto.WamAllDto;
import dto.Access_settingAllDto;
import dto.Alarm_settingAllDto;
import dto.CommentsAllDto;
import dto.MemberAllDto;
import dto.MemberDto;

public class ProjectDao {
	public Connection getConnection() throws Exception {
		String driver = "oracle.jdbc.driver.OracleDriver";
		String url = "jdbc:oracle:thin:@gusdntkd.cafe24.com:1521:xe";
		String id = "asana_hw";
		String pw = "asana12345";

		Class.forName(driver);
		Connection conn = DriverManager.getConnection(url, id, pw);
		return conn;
	}
	
	// 연결되지 않은 프로젝트 조회 
	// 파라미터 :  goalIdx
	// 리턴값 : project_idx, name, member_idx
	// 특정 목표와 연결된 프로젝트를 제외한 프로젝트 조회하는 메서드 
	public ArrayList<ProjectAllDto> project_connectionClickDao(int goalIdx) throws Exception {
		String sql = "select project_idx, name, member_idx" + " from PROJECT" + " where project_idx not in("
				+ " select project_connection" + " from goal_connection" + " where goal_idx=?)";
		
		ArrayList<ProjectAllDto> ListSet = new ArrayList<ProjectAllDto>();
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, goalIdx);
		ResultSet rs = pstmt.executeQuery();

		while (rs.next()) {
			int project_idx = rs.getInt("project_idx");
			String name = rs.getString("name");
			int member_idx = rs.getInt("member_idx");
			ProjectAllDto dto = new ProjectAllDto();
			dto.setProject_idx(project_idx);
			dto.setName(name);
			dto.setMember_idx(member_idx);
			dto.setProject_idx(project_idx);
			ListSet.add(dto);
		}
		rs.close();
		pstmt.close();
		conn.close();
		return ListSet;
	}
	
	// 프로젝트 참여자 삭제 
	// 파라미터 : projectIdx, memberIdx
	// 특정 프로젝트의 특정 참여자 삭제하는 메서드 
	public void deleteProject_participantsDao(int projectIdx, int memberIdx) throws Exception {
		String sql = "DELETE FROM project_participants" + " WHERE project_idx=? AND member_idx=?";
		
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, projectIdx);
		pstmt.setInt(2, memberIdx);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}
	
	// 프로젝트의 참여자 권한 조회 
	// 파라미터 :  project_idx
	// 리턴값 : member_idx, authority_name, authority
	// 특정 프로젝트의 참여자 권한 조회하는 메서드 
	public ArrayList<Project_participantsThingsDto> getProject_participantsAllDao(int project_idx) throws Exception {
		String sql = "SELECT p.member_idx, a.authority_name, p.authority"
				+ " FROM project_participants p INNER JOIN member_authority a" + " ON p.authority = a.authority"
				+ " WHERE project_idx=?";

		ArrayList<Project_participantsThingsDto> listRet = new ArrayList<Project_participantsThingsDto>();

		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, project_idx);
		ResultSet rs = pstmt.executeQuery();

		while (rs.next()) {
			int member_idx = rs.getInt("member_idx");
			String authority_name = rs.getString("authority_name");
			int authority = rs.getInt("authority");
			Project_participantsThingsDto dto = new Project_participantsThingsDto(member_idx, authority_name, authority);
			listRet.add(dto);
		}
		rs.close();
		pstmt.close();
		conn.close();
		return listRet;
	}
	
	// 참여자 권한 변경
	// 파라미터 :  projectIdx, memberIdx, authority
	// 특정 프로젝트의 특정 참여자 권한변경하는 메서드 
	public void updateProject_participantsAuthorityDao(int projectIdx, int memberIdx, int authority) throws Exception {
		String sql = "UPDATE project_participants" + " SET authority=?" + " WHERE project_idx=? AND member_idx=?";
		
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, authority);
		pstmt.setInt(2, projectIdx);
		pstmt.setInt(3, memberIdx);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}
	
	// 프로젝트 설명 제목 변경 
	// 파라미터 :  title, projectIdx
	// 프로젝트의 설명 제목을 변경하는 메서드 
	public void updateProjectContentTitleDto(String title, int projectIdx) throws Exception {
		String sql = "UPDATE project" + " SET title=?" + " WHERE project_idx=?";
		
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, title);
		pstmt.setInt(2, projectIdx);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}
	
	// 프로젝트 설명 내용 변경 
	// 파라미터 : content,projectIdx
	// 프로젝트의 설명 내용을 변경하는 메서드 
	public void updateProjectContentDto(String content, int projectIdx) throws Exception {
		String sql = "UPDATE project" + " SET content=?" + " WHERE project_idx=?";
		
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, content);
		pstmt.setInt(2, projectIdx);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}
	
	// 프로젝트 조회 
	// 파라미터 :  projectIdx
	// 리턴값 : project_idx, name, member_idx,range, default_view, create_date, recent_date, start_date, deadline_date, title, content
	// 특정 프로젝트의 세부내용 조회하는 메서드 
	public ProjectAllDto getProjectAllDto(int projectIdx) throws Exception {
		String sql = "SELECT project_idx, name, member_idx,range, default_view, create_date, recent_date, start_date, deadline_date, title, content"
				+ " FROM project" + " WHERE project_idx=?";
		
		ProjectAllDto dto = null; 
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, projectIdx);
		ResultSet rs = pstmt.executeQuery();

		if (rs.next()) {
			String name = rs.getString("name");
			int member_idx = rs.getInt("member_idx");
			int range = rs.getInt("range");
			int default_view = rs.getInt("default_view");
			String create_date = rs.getString("create_date");
			String recent_date = rs.getString("recent_date");
			String start_date = rs.getString("start_date");
			String deadline_date = rs.getString("deadline_date");
			String title = rs.getString("title");
			String content = rs.getString("content");
			dto = new ProjectAllDto(projectIdx, name, member_idx, range, default_view, create_date, recent_date, start_date, deadline_date, title, content);
		}
		rs.close();
		pstmt.close();
		conn.close();
		return dto;
	}
	
	// 프로젝트 이름변경 
	// 파라미터 : name, projectIdx
	// 프로젝트 이름변경 하는 메서드 
	public void updateProjectNameDto(String name, int projectIdx) throws Exception {
		String sql = "UPDATE project SET name=? WHERE project_idx=?";
		
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, name);
		pstmt.setInt(2, projectIdx);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}
	
	// 프로젝트 공개범위 변경 
	// 파라미터 : range, projectIdx
	// 프로젝트 공개범위(엑세스 설정) 변경하는 메서드  
	public void updateProjectRangeDto(int range, int projectIdx) throws Exception {
		String sql = "UPDATE project SET range=? WHERE project_idx=?";
		
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, range);
		pstmt.setInt(2, projectIdx);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}
	
	// 프로젝트 참여자 조회 
	// 파라미터 : projectIdx
	// 리턴값 :  member_idx, profile_img, nickname
	// 특정 프로젝트의 참여자 정보조회하는 메서드 
	public ArrayList<MemberDto> getSelectProject_idxmemberDao(int projectIdx) throws Exception {
		String sql = "SELECT member_idx, profile_img, nickname" + " FROM member"
				+ " WHERE member_idx IN(SELECT member_idx" + " FROM Project_PARTICIPANTS" + " WHERE project_idx=?)";
		
		ArrayList<MemberDto> listRet = new ArrayList<MemberDto>();
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, projectIdx);
		ResultSet rs = pstmt.executeQuery();
		while (rs.next()) {
			int memberIdx = rs.getInt("memberIdx");
			String profileImg = rs.getString("profile_img");
			String nickname = rs.getString("nickname");

			MemberDto dto = new MemberDto();
			dto.setMemberIdx(memberIdx);
			dto.setProfileImg(profileImg);
			dto.setNickname(nickname);
			listRet.add(dto);
		}
		rs.close();
		pstmt.close();
		conn.close();
		return listRet;
	}
	
	// 프로젝트 초대 
	// 파라미터 : projectIdx, memberIdx, authority
	// 특정 프로젝트 멤버를 초대하는 메서드 
	public void insertpjt_participantsDto(int projectIdx, int memberIdx, int authority) throws Exception {
		String sql ="INSERT INTO project_participants (project_idx, member_idx, authority, project_participants, participant_date ) "
				+ " VALUES (?,?,?, seq_project_participants.nextval, sysdate)";
		
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1,projectIdx);
		pstmt.setInt(2, memberIdx);
		pstmt.setInt(3, authority);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}
	
	// 프로젝트의 엑세스 설정 조회 
	// 파라미터 : projectIdx
	// 리턴값 : range ,title, content
	// 특정 프로젝트의 엑세스 설정 조회하는 메서드 
	public Access_settingAllDto getAccess_settingAllDao(int projectIdx) throws Exception {
		String sql = "SELECT a.range ,a.title, a.content" + " FROM project p" + " INNER JOIN access_setting a"
				+ " ON p.range = a.range" + " WHERE project_idx=?";

		Access_settingAllDto dto = null;
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, projectIdx);
		ResultSet rs = pstmt.executeQuery();

		if (rs.next()) {
			int range = rs.getInt("range");
			String title = rs.getString("title");
			String content = rs.getString("content");
			dto = new Access_settingAllDto(range, title, content);
		}
		rs.close();
		pstmt.close();
		conn.close();
		return dto;
	}
	
	// 프로젝트에서 참여자 삭제 
	// 파라미터 : projectIidx, memberIdx
	// 프로젝트에서 참여자 삭제할때 알림관리에서 삭제하는 메서드  
	public void deleteAlarm_settingDao(int projectIidx, int memberIdx) throws Exception {
		String sql = " DELETE FROM alarm_setting" + " WHERE project_idx=? AND member_idx=?";
		
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, projectIidx);
		pstmt.setInt(2, memberIdx);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}
	
	// 프로젝트의 참여자 알림관리 조회 
	// 파라미터 : projectIidx
	// 리턴값 : member_idx, sts_update, message_alarm, work
	// 프로젝트의 참여자별 설정된 알림관리를 조회하는 메서드 
	public ArrayList<Alarm_settingAllDto> getAlarm_settingDao(int projectIidx) throws Exception {
		String sql = "SELECT member_idx, sts_update, message_alarm, work" + " FROM alarm_setting"
				+ " WHERE project_idx=?";
		
		ArrayList<Alarm_settingAllDto> alarm_settingAllDtolist = new ArrayList<Alarm_settingAllDto>();
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, projectIidx);
		ResultSet rs = pstmt.executeQuery();

		while (rs.next()) {
			int member_idx = rs.getInt("member_idx");
			int sts_update = rs.getInt("sts_update");
			int message_alarm = rs.getInt("message_alarm");
			int work = rs.getInt("work");
			Alarm_settingAllDto alarm_settingAllDto1 = new Alarm_settingAllDto();
			alarm_settingAllDto1.setMember_idx(member_idx);
			alarm_settingAllDto1.setSts_update(sts_update);
			alarm_settingAllDto1.setMessage_alarm(message_alarm);
			alarm_settingAllDto1.setWork(work);
			alarm_settingAllDtolist.add(alarm_settingAllDto1);
		}
		rs.close();
		pstmt.close();
		conn.close();
		return alarm_settingAllDtolist;
	}
	
	// 프로젝트 참여자 초대 
	// 파라미터 : projectIdx, memberIdx
	// 프로젝트 참여자 초대시 참여자별 알림관리 저장하는 메서드 
	public void insertAlarm_settingDto(int projectIdx, int memberIdx) throws Exception {
		String sql = "INSERT INTO alarm_setting (project_idx, member_idx)" + " VALUES (?,?)";
		
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, projectIdx);
		pstmt.setInt(2, memberIdx);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}
	
	// 프로젝트 최신상태 조회 
	// 파라미터 : projectIdx
	// 리턴값 :  status_date, member_idx , status_idx, project_status_idx
	// 특정 프로젝트의 가장 최신 상태의 정보 조회하는 메서드 
	public ProjectStatusDto recentProjectStatusDto(int projectIdx) throws Exception {
		String sql = "SELECT status_date, member_idx , status_idx, project_status_idx"
				+ " FROM (SELECT  status_date, member_idx , status_idx, project_status_idx" + " FROM project_STATUS"
				+ " WHERE project_idx=?" + " ORDER BY status_date DESC)" + " WHERE ROWNUM=1";
		
		ProjectStatusDto dto = null;
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, projectIdx);
		ResultSet rs = pstmt.executeQuery();
		if (rs.next()) {
			String statusDate = rs.getString("status_date");
			int memberIdx = rs.getInt("member_idx");
			int statusIdx = rs.getInt("status_idx");
			int projectStatusIdx = rs.getInt("project_status_idx");
			dto = new ProjectStatusDto(projectStatusIdx, statusIdx, memberIdx, statusDate);
		}
		rs.close();
		pstmt.close();
		conn.close();
		return dto;
	}
	
	// 프로젝트 상태 업데이트
	// 파라미터 :  statusIdx, projectIdx, memberIdx
	// 프로젝트의 상태를 업데이트하는 메서드 
	public void projectStatusInsertDto(int statusIdx, int projectIdx, int memberIdx) throws Exception {
		String sql = "INSERT INTO project_status (project_status_idx, status_idx, project_idx, member_idx, status_date) "
				+ "VALUES (seq_project_status_idx.nextval, ?, ?, ?, sysdate)";
		
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, statusIdx);
		pstmt.setInt(2, projectIdx);
		pstmt.setInt(3, memberIdx);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}
	
	// 프로젝트 상태 목록 조회 
	// 파라미터 : projectIdx
	// 리턴값 : project_status_idx, status_idx, project_idx, member_idx, status_date
	// 특정 프로젝트의 상태를 시간대 내림차순으로 보여주는 메서드 
	public ArrayList<ProjectStatusDto> projectStatusinventoryDto(int projectIdx) throws Exception {
		String sql = "SELECT project_status_idx, status_idx, project_idx, member_idx, status_date"
				+ " FROM project_STATUS" + " WHERE project_idx = ?" + " ORDER BY status_date ";
		
		ArrayList<ProjectStatusDto> list = new ArrayList<ProjectStatusDto>();
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, projectIdx);
		ResultSet rs = pstmt.executeQuery();

		while (rs.next()) {
			int projectStatusIdx = rs.getInt("project_status_idx");
			int statusIdx = rs.getInt("status_idx");
			projectIdx = rs.getInt("project_idx");
			int memberIdx = rs.getInt("member_idx");
			String statusDate = rs.getString("status_date");
			ProjectStatusDto dto = new ProjectStatusDto();
			dto.setProjectStatusIdx(projectStatusIdx);
			dto.setStatusIdx(statusIdx);
			dto.setProjectIdx(projectIdx);
			dto.setMemberIdx(memberIdx);
			dto.setStatusDate(statusDate);
			list.add(dto);
		}
		rs.close();
		pstmt.close();
		conn.close();
		return list;
	}
	
	// 프로젝트 상태 삭제
	// 파라미터 : projectStatusIdx
	// 프로젝트 상태 삭제하는 메서드 
	public void project_StatusDeleteDto(int projectStatusIdx) throws Exception {
		String sql = "DELETE FROM project_STATUS WHERE project_status_idx = ?";
		
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, projectStatusIdx);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}
	
	// 프로젝트 작업 (마일스톤) 조회 
	// 파라미터 : projectIdx
	// 리턴값 : wam_idx, title, manager_idx, deadline_date, complete_date, following_idx 
	// 프로젝트의 작업 (마일스톤) 을 조회하는 메서드 
	public ArrayList<WamAllDto> milestonesToTheProjectSelectDto(int projectIdx) throws Exception {
		String sql = "SELECT wam_idx, title, manager_idx, deadline_date, complete_date, following_idx" + " FROM WAM"
				+ " WHERE project_idx = ? and wam_type = 'm'";
		
		ArrayList<WamAllDto> list = new ArrayList<WamAllDto>();
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, projectIdx);
		ResultSet rs = pstmt.executeQuery();
		while (rs.next()) {
			int wamIdx = rs.getInt("wam_idx");
			String title = rs.getString("title");
			int managerIdx = rs.getInt("manager_idx");
			String deadlineDate = rs.getString("deadline_date");
			String completeDate = rs.getString("complete_date");
			int followingIdx = rs.getInt("following_idx");
			WamAllDto dto = new WamAllDto();
			dto.setWamIdx(wamIdx);
			dto.setTitle(title);
			dto.setManagerIdx(managerIdx);
			dto.setDeadlineDate(deadlineDate);
			dto.setCompleteDate(completeDate);
			dto.setFollowingIdx(followingIdx);
			list.add(dto);
		}
		rs.close();
		pstmt.close();
		rs.close();
		return list;
	}
	
	// 프로젝트의 상태 댓글 작성 
	// 파라미터 : projectStatusIdx, memberIdx, content, writedate, fix
	// 프로젝트의 상태별 댓글 작성하는 메서드 
	public void projectOfStatusCommentsInsertDto(int projectStatusIdx, int memberIdx, String content, String writedate, int fix) throws Exception {
		String sql = "insert into comments(comments_idx, project_status_idx, goal_idx, goal_status_idx, wam_idx, message_idx, member_idx, content, file_name, writedate, fix)"
				+ "values(seq_comments_idx.nextval, ? , NULL ,NULL,NULL,NULL, ? , ? ,'NULL',to_date( ? ,'YYYY/MM/DD HH24:MI'), ? )";
		
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, projectStatusIdx);
		pstmt.setInt(2, memberIdx);
		pstmt.setString(3, content);
		pstmt.setString(4, writedate);
		pstmt.setInt(5, fix);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}
	
	// 프로젝트의 상태 댓글 조회 
	// 파라미터 : projectStatusIdx
	// 리턴값 :  member_idx, writedate, fix , content
	// 특정 프로젝트의 상태 댓글을 조회하는 메서드 
	public ArrayList<CommentsAllDto> projectOfStatusCommentsGetDto(int projectStatusIdx) throws Exception {
		String sql = "SELECT member_idx, writedate, fix , content" + " FROM comments" + " WHERE  project_status_idx= ?";
		
		ArrayList<CommentsAllDto> list = new ArrayList<CommentsAllDto>();
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, projectStatusIdx);
		ResultSet rs = pstmt.executeQuery();
		while (rs.next()) {
			int memberIdx = rs.getInt("member_idx");
			String writedate = rs.getString("writedate");
			int fix = rs.getInt("fix");
			String content = rs.getString("content");
			CommentsAllDto dto = new CommentsAllDto();
			dto.setMemberIdx(memberIdx);
			dto.setWritedate(writedate);
			dto.setFix(fix);
			dto.setContent(content);
			list.add(dto);
		}
		rs.close();
		pstmt.close();
		conn.close();
		return list;
	}
	
	// 프로젝트 상태 세부내용 조회 
	// 파라미터 : projectStatusIdx
	// 리턴값 : status_idx, project_idx, member_idx, status_date
	// 프로젝트 상태 업데이트 클릭시 상세 페이지 조회하는 메서드 
	public ProjectStatusDto projectStatusUpdateDetails(int projectStatusIdx) throws Exception {
		String sql = "SELECT status_idx, project_idx, member_idx, status_date" + " FROM project_status"
				+ " WHERE project_status_idx=?";
		
		ProjectStatusDto dto = new ProjectStatusDto();
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, projectStatusIdx);
		ResultSet rs = pstmt.executeQuery();
		if (rs.next()) {
			int statusIdx = rs.getInt("status_idx");
			int projectIdx = rs.getInt("project_idx");
			int memberIdx = rs.getInt("member_idx");
			String statusDate = rs.getString("status_date");
			dto.setMemberIdx(memberIdx);
			dto.setStatusIdx(statusIdx);
			dto.setStatusDate(statusDate);
			dto.setProjectIdx(projectIdx);
		}
		rs.close();
		pstmt.close();
		conn.close();
		return dto;
	}
	
	// 프로젝트 참여자 초대 
	// 파라미터 : memberIdx, projectIdx, nickName
	// 리턴값 : member_idx, email, nickname, profile_img, project_idx, authority
	// 나와 같은 작업공간에 있는 멤버중에서 이미 포함된 참여자를 제외하고 닉네임을 통해서 멤버를 조회하는 메서드 
	public ArrayList<ProjectMemberInsertDto> projectMemberInsert(int memberIdx, int projectIdx, String nickName) throws Exception {
		String sql = "SELECT m.member_idx, m.email, m.nickname, m.profile_img, p.project_idx, p.authority" + " FROM ("
				+ "        SELECT *" + "        FROM MY_WORKSPACE" + "        WHERE owner_idx IN (SELECT owner_idx "
				+ "                            FROM my_workspace" + "                            WHERE member_idx=?)"
				+ " ) w" + " INNER JOIN project_participants p" + " ON w.member_idx = p.member_idx"
				+ " INNER JOIN member m" + " ON p.member_idx = m.member_idx "
				+ " WHERE m.member_idx NOT IN (SELECT member_idx"
				+ "                            FROM project_participants "
				+ "                            WHERE project_idx=?)" + " AND m.nickname LIKE ?";
		
		ArrayList<ProjectMemberInsertDto> projectMemberInsertList = new ArrayList<ProjectMemberInsertDto>();
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, memberIdx);
		pstmt.setInt(2, projectIdx);
		pstmt.setString(3, '%' + nickName + '%');
		ResultSet rs = pstmt.executeQuery();
		while (rs.next()) {
			memberIdx = rs.getInt("member_idx");
			String email = rs.getString("email");
			String nickname = rs.getString("nickname");
			String profileImg = rs.getString("profile_img");
			projectIdx = rs.getInt("project_idx");
			int authority = rs.getInt("authority");
			ProjectMemberInsertDto dto = new ProjectMemberInsertDto(memberIdx, email, nickname, profileImg, projectIdx, authority);
			projectMemberInsertList.add(dto);
		}
		rs.close();
		pstmt.close();
		conn.close();
		return projectMemberInsertList;
	}
	
	// 프로젝트 참여된 멤버 조회 
	// 파라미터 : project_idx, memberIdx
	// 리턴값 : member_idx, authority_name, authority
	// 특정 프로젝트에 참여된 멤버 조회하는 메서드 
	public Project_participantsThingsDto specificProjectsForSpecifiMembers(int project_idx, int memberIdx) throws Exception {
		String sql = "SELECT p.member_idx, a.authority_name, p.authority"
				+ " FROM project_participants p INNER JOIN member_authority a" + " ON p.authority = a.authority"
				+ " WHERE project_idx=?" + " AND member_idx=?";

		Project_participantsThingsDto ProjectDto = null;
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, project_idx);
		pstmt.setInt(2, memberIdx);
		ResultSet rs = pstmt.executeQuery();
		if (rs.next()) {
			int member_idx = rs.getInt("member_idx");
			String authority_name = rs.getString("authority_name");
			int authority = rs.getInt("authority");
			ProjectDto = new Project_participantsThingsDto(member_idx, authority_name, authority);
		}
		rs.close();
		pstmt.close();
		conn.close();
		return ProjectDto;
	}

	// 프로젝트 생성
	// 파라미터 : name, memberIdx, range
	// 프로젝트 생성하는 메서드 
	public void createProject(String name, int memberIdx, int range) throws Exception {
		String sql = "INSERT INTO project(project_idx, name, member_idx, range)"
				+ " VALUES(SEQ_PROJECT_IDX.nextval, ?, ?, ?)";

		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, name);
		pstmt.setInt(2, memberIdx);
		pstmt.setInt(3, range);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}

	// 프로젝트 이름 조회
	// 파라미터 : projectIdx
	// 리턴값 : name 
	// 프로젝트 이름 조회하는 메서드 
	public String getProjectName(int projectIdx) throws Exception {
		String sql = "SELECT name FROM project WHERE project_idx = ?";
		
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, projectIdx);
		ResultSet rs = pstmt.executeQuery();
		String name = null;
		if (rs.next()) {
			name = rs.getString("name");
		}
		rs.close();
		pstmt.close();
		conn.close();
		return name;
	}

	// 참여하고 있는 프로젝트 보여주기
	// 파라미터 : 로그인된 member_idx
	// 리턴값 : project.name
	// 로그인멤버가 협업중인 프로젝트 이름 조회 하는 메서드
	public ArrayList<ProjectDto> getProjectDto(int memberIdx) throws Exception {
		String sql = "SELECT p.name, p.project_idx FROM project p INNER JOIN project_participants pp ON pp.project_idx = p.project_idx WHERE pp.member_idx = ?";

		ArrayList<ProjectDto> list = new ArrayList<>();
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, memberIdx);
		ResultSet rs = pstmt.executeQuery();
		while (rs.next()) {
			String name = rs.getString("name");
			int projectIdx = rs.getInt("project_idx");
			ProjectDto dto = new ProjectDto();
			dto.setName(name);
			dto.setProjectIdx(projectIdx);
			list.add(dto);
		}
		rs.close();
		pstmt.close();
		conn.close();
		return list;
	}

	// 프로젝트 이름 수정
	// 파라미터 : name, project_idx
	// 프로젝트의 이름을 수정하는 메서드
	public void updateProjectNameFromProjectIdx(String name, int projectIdx) throws Exception {
		String sql = "UPDATE project SET name=? WHERE project_idx=?";

		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, name);
		pstmt.setInt(2, projectIdx);
		pstmt.executeUpdate();

		pstmt.close();
		conn.close();
	}

	// 프로젝트 공개범위 수정
	// 파라미터 : range, project_idx
	// 프로젝트의 공개범위를 수정하는 메서드
	public void updateProjectRangeFromProjectIdx(int range, int projectIdx) throws Exception {
		String sql = "UPDATE project SET range=? WHERE project_idx=?";

		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, range);
		pstmt.setInt(2, projectIdx);
		pstmt.executeUpdate();

		pstmt.close();
		conn.close();
	}

	// 프로젝트 최근 활동일시 수정
	// 파라미터 : recent_date, project_idx
	// 프로젝트의 최근활동시간을 수정하는 메서드
	public void updateProjectRecentDateFromProjectIdx(String recentDate, int projectIdx) throws Exception {
		String sql = "UPDATE project SET recent_date=TO_DATE(?,'YYYY/MM/DD HH24:MI') WHERE project_idx=?";

		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, recentDate);
		pstmt.setInt(2, projectIdx);
		pstmt.executeUpdate();

		pstmt.close();
		conn.close();
	}

	// 프로젝트 시작일 수정
	// 파라미터 : start_date, project_idx
	// 프로젝트의 시작일를 수정하는 메서드
	public void updateProjectStartDateFromProjectIdx(String startDate, int projectIdx, int memberIdx) throws Exception {
		String sql = "UPDATE project SET start_date=TO_DATE(?,'YYYY/MM/DD HH24:MI') WHERE project_idx = ? AND member_idx = ?";

		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, startDate);
		pstmt.setInt(2, projectIdx);
		pstmt.setInt(3, memberIdx);
		pstmt.executeUpdate();

		pstmt.close();
		conn.close();
	}

	// 프로젝트 마감일 수정
	// 파라미터 : deadline_date, project_idx
	// 프로젝트의 마감일을 수정하는 메서드
	public void updateProjectDeadlineDateFromProjectIdx(String deadlineDate, int projectIdx, int memberIdx)
			throws Exception {
		String sql = "UPDATE project SET deadline_date=TO_DATE(?,'YYYY/MM/DD HH24:MI') WHERE project_idx=? AND member_idx = ?";

		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, deadlineDate);
		pstmt.setInt(2, projectIdx);
		pstmt.setInt(3, memberIdx);
		pstmt.executeUpdate();

		pstmt.close();
		conn.close();
	}

	// 프로젝트 설명 제목 수정
	// 파라미터 : title, project_idx
	// 프로젝트의 설명을 수정하는 메서드
	public void updateProjectTitleFromProjectIdx(String title, int projectIdx) throws Exception {
		String sql = "UPDATE project SET title=? WHERE project_idx=?";

		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, title);
		pstmt.setInt(2, projectIdx);
		pstmt.executeUpdate();

		pstmt.close();
		conn.close();
	}

	// 프로젝트 설명 내용 수정
	// 파라미터 : content, project_idx
	// 프로젝트의 내용을 수정하는 메서드
	public void updateProjectContentFromProjectIdx(String content, int projectIdx) throws Exception {
		String sql = "UPDATE project SET content=? WHERE project_idx=?";

		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, content);
		pstmt.setInt(2, projectIdx);
		pstmt.executeUpdate();

		pstmt.close();
		conn.close();
	}

	// 프로젝트 삭제
	// 파라미터 : project_idx
	// 해당 프로젝트를 삭제하는 메서드
	public void deleteProjectFromProjectIdx(int projecIdx) throws Exception {
		String sql = "DELETE project WHERE project_idx=?";

		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, projecIdx);
		pstmt.executeUpdate();

		pstmt.close();
		conn.close();
	}

	// 프로젝트 생성자가 프로젝트 생성 후 자동으로 프로젝트 참여 1
	// 파라미터 : name
	// 리턴값 : project_idx
	// 프로젝트 생성 후 DB에 추가된 해당 프로젝트 이름의 project_idx 를 찾는 메서드
	public int findCreatedProjectIdx(String findProjectName) throws Exception {
		String sql = "SELECT project_idx FROM project WHERE name=?";

		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, findProjectName);
		ResultSet rs = pstmt.executeQuery();
		int findProjectIdx = -1;
		if (rs.next()) {
			findProjectIdx = rs.getInt("project_idx");
		}
		rs.close();
		pstmt.close();
		conn.close();
		return findProjectIdx;
	}

	// 프로젝트 생성자가 프로젝트 생성 후 자동으로 프로젝트 참여 2
	// 파라미터 : name, member_idx
	// 찾은 프로젝트에 생성한멤버를 즉시 추가하는 메서드
	public void projectParticipants(int projectName, int memberIdx) throws Exception {
		String sql = "INSERT INTO project_participants(project_participants, project_idx, member_idx)"
				+ " VALUES(seq_project_participants.nextval, ?, ?)";

		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, projectName);
		pstmt.setInt(2, memberIdx);
		pstmt.executeUpdate();

		pstmt.close();
		conn.close();
	}

	// 프로젝트 즐겨찾기 추가
	// 파라미터 : member_idx, project_idx
	// 로그인멤버가 해당 프로젝트 즐겨찾기 추가하는 메서드
	public void addProjectFavorites(int memberIdx, int projectIdx) throws Exception {
		String sql = "INSERT INTO favorites (member_idx, project_idx) VALUES (?, ?)";

		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, memberIdx);
		pstmt.setInt(2, projectIdx);
		pstmt.executeUpdate();

		pstmt.close();
		conn.close();
	}

	// 프로젝트 즐겨찾기 삭제
	// 파라미터 : member_idx, project_idx
	// 로그인멤버가 해당 프로젝트 즐겨찾기 삭제하는 메서드
	public void removeProjectFavorites(int memberIdx, int projectIdx) throws Exception {
		String sql = "DELETE FROM favorites WHERE member_idx = ? AND project_idx = ?";

		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, memberIdx);
		pstmt.setInt(2, projectIdx);
		pstmt.executeUpdate();

		pstmt.close();
		conn.close();
	}

	// 로그인멤버의 즐겨찾기 프로젝트 리스트
	// 파라미터 : member_idx
	// 리턴값 : name, project_idx
	// 로그인멤버가 즐겨찾기한 프로젝트들을 조회하는 메서드
	public ArrayList<ProjectDto> favoritesProjectListByMemberIdx(int memberIdx) throws Exception {
		String sql = "SELECT p.name, p.project_idx" + " FROM project p"
				+ " INNER JOIN favorites f ON p.project_idx = f.project_idx" + " WHERE f.member_idx=?";

		ArrayList<ProjectDto> list = new ArrayList<ProjectDto>();
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, memberIdx);
		ResultSet rs = pstmt.executeQuery();
		while (rs.next()) {
			String name = rs.getString("name");
			int projectIdx = rs.getInt("project_idx");
			ProjectDto dto = new ProjectDto();
			dto.setName(name);
			dto.setProjectIdx(projectIdx);
			list.add(dto);
		}
		rs.close();
		pstmt.close();
		conn.close();
		return list;
	}

	// 프로젝트 협업참여자 리스트
	// gilju-4. 프로젝트 참여 멤버 조회 (p.95/ )
	// input : member_idx(숫자)
	// output : 리스트 of { email(문자열),nickname(문자열), profile_img(문자열) }
	public ArrayList<ProjectParticipantsDto> getPerson(int projectIdx) throws Exception { // getProjectParticipantDtos
		String sql = "SELECT m.email, m.nickname, m.profile_img" + " FROM project_participants pp "
				+ " INNER JOIN member m ON pp.member_idx = m.member_idx" + " WHERE pp.project_idx=?";

		ArrayList<ProjectParticipantsDto> listPerson = new ArrayList<>();

		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, projectIdx);
		ResultSet rs = pstmt.executeQuery();// 이 세개를 담고 있는 메서드 생성(코드 중복을 제거)
		while (rs.next()) {
			String email = rs.getString("email");
			String profileImg = rs.getString("profile_img");
			String nickName = rs.getString("nickname");

			MemberDto mdto = new MemberDto();
			mdto.setNickname(nickName);
			mdto.setProfileImg(profileImg);
			mdto.setEmail(email);

			ProjectParticipantsDto pdto = new ProjectParticipantsDto();
			pdto.setMemberDto(mdto);

			listPerson.add(pdto);
		}
		rs.close();
		pstmt.close();
		conn.close();
		return listPerson;
	}

	//	gilju-22 참여하고 있는 프로젝트 보여주기(p.126/    ) (프로젝트 보여줌)
	//	input:  member_idx(숫자)
	//	output: list of project
	public ArrayList<ProjectDto> getOtherProjectsDto(int memberIdx) throws Exception {
		String sql = "SELECT name FROM project p " + " INNER JOIN project_participants pp"
				+ " ON p.project_idx = pp.project_idx WHERE pp.member_idx = ? ";
		ArrayList<ProjectDto> list = new ArrayList<>();
		ProjectDto dto = null;

		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, memberIdx);
		ResultSet rs = pstmt.executeQuery();
		while (rs.next()) {
			String name = rs.getString("name");
			dto = new ProjectDto();
			dto.setName(name);
			list.add(dto);
		}
		rs.close();
		pstmt.close();
		conn.close();

		return list;
	}
	
	//	gilju-32 프로젝트 검색  (p.142/   ) 
	//	input: (사용자가 입력한 문자열) like 사용
	//	output: project_idx(숫자)
	public ArrayList<ProjectDto> getProjectNameDto(String keyword) throws Exception {
		String sql = "SELECT name FROM project WHERE name LIKE ?";
		ArrayList<ProjectDto> list = new ArrayList<>();
		ProjectDto dto = null;

		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, "%" + keyword + "%");
		ResultSet rs = pstmt.executeQuery();
		while (rs.next()) {
			String name = rs.getString("name");
			dto = new ProjectDto();
			dto.setName(name);
			list.add(dto);
		}
		rs.close();
		pstmt.close();
		conn.close();

		return list;
	}
	
	//	gilju-36 더보기(프로젝트 삭제) (p.145/    )  
	//	input: 삭제 할 project_idx(숫자)
	public void DeleteProjectDto(int projectIdx) throws Exception {
		String sql = "DELETE FROM project WHERE project_idx = ?";
		Connection conn = getConnection();

		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, projectIdx);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}

	// 프로젝트 마감일 조회
	// 파라미터 : project_idx
	// 리턴값 : deadline_date
	// 해당 프로젝트의 마감일을 조회하는 메서드
	public String getProjectDeadlineDateDto(int projectIdx) throws Exception {
		String sql = "SELECT deadline_date FROM project WHERE project_idx = ?";
		Connection conn = getConnection();

		String ret = null;
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, projectIdx);
		ResultSet rs = pstmt.executeQuery();
		if (rs.next()) {
			ret = rs.getString("deadline_date");
		}
		rs.close();
		pstmt.close();
		conn.close();

		return ret;
	}
	
	// 로그인멤버와 타인멤버가 같이 협업 참여중인 프로젝트 리스트
	// 파라미터 : 로그인 member_idx, 해당 member_idx
	// 리턴값 : name, project_idx
	// 로그인멤버와 해당 타인멤버가 함께 협업중인 프로젝트 리스트 조회
	public ArrayList<ProjectDto> getProjectDtoByLoginMemberAndOtherMember(int loginMemberIdx, int memberIdx) throws Exception{
		String sql  = "SELECT p.name, p.project_idx"
				+ " FROM project p"
				+ " INNER JOIN project_participants pp ON pp.project_idx = p.project_idx"
				+ " WHERE pp.member_idx = ?"
				+ " INTERSECT"
				+ " SELECT p.name, p.project_idx"
				+ " FROM project p"
				+ " INNER JOIN project_participants pp ON pp.project_idx = p.project_idx"
				+ " AND pp.member_idx = ?"
				+ " ORDER BY 2";
		
		ArrayList<ProjectDto> list = new ArrayList<>();
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);

		pstmt.setInt(1, loginMemberIdx);
		pstmt.setInt(2, memberIdx);
		ResultSet rs = pstmt.executeQuery();

		while (rs.next()) {
			String name = rs.getString("name");
			int projectIdx = rs.getInt("project_idx");
			ProjectDto dto = new ProjectDto();
			dto.setName(name);
			dto.setProjectIdx(projectIdx);
			list.add(dto);
		}
		rs.close();
		pstmt.close();
		conn.close();
		return list;
	}

	public static void main(String[] args) throws Exception {
		
	}
}
