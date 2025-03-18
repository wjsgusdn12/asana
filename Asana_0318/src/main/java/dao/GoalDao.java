package dao;

import java.sql.CallableStatement;


import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;

import dto.Access_settingAllDto;
import dto.CommentsAllDto;
import dto.GoalOfGoal_statusGetDto;
import dto.GoalOfPeriodGetDto;
import dto.GoalSelectAllDto;
import dto.GoalThingsDto;
import dto.Goal_STATUS_CooperationAllDto;
import dto.Goal_statusGetAllDto;
import dto.MemberDto;
import dto.MessageThingsDto;
import dto.PortfolioAllDto;
import dto.Progress_statusAllDto;
import dto.ProjectAllDto;
import dto.ProjectStatusDto;
import dto.Project_participantsAllDto;
import dto.Project_participantsThingsDto;
import dto.Related_workAllDto;
import dto.StatusAllDto;
import dto.TimeLineThingDto;
import dto.WamAllDto;

public class GoalDao {
	public Connection getConnection() throws Exception {
		String driver = "oracle.jdbc.driver.OracleDriver";
		String url = "jdbc:oracle:thin:@gusdntkd.cafe24.com:1521:xe";
		String id = "asana_hw";
		String pw = "asana12345";

		Class.forName(driver);
		Connection conn = DriverManager.getConnection(url, id, pw);
		return conn;
	}
	
	// 특정 프로젝트와 연결된 목표를 제외한 목표 조회 
	// 파라미터 : projectIdx
	// 리턴값 : goal_idx 
	// 특정 프로젝트와 연결되어진 목표를 제외한 목표 idx 를 조회하는 메서드 
	public ArrayList<Integer> getAllGoalIdxFromProjectIdx(int projectIdx) throws Exception {
		String sql = "SELECT goal_idx" + " FROM GOAL" + " WHERE goal_idx NOT IN (SELECT g.goal_idx"
				+ "                        FROM GOAL g INNER JOIN GOAL_CONNECTION c"
				+ "                        ON g.goal_idx = c.goal_idx"
				+ "                        WHERE c.project_connection=?)";
		ArrayList<Integer> listRet = new ArrayList<Integer>();

		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, projectIdx);
		ResultSet rs = pstmt.executeQuery();
		while (rs.next()) {
			listRet.add(rs.getInt("goal_idx"));
		}
		rs.close();
		pstmt.close();
		conn.close();
		return listRet;
	}
	
	
	// 프로젝트에 연결된 목표 조회 
	// 파라미터 : listGoalIdx
	// 리턴값 : title , goal.period_idx,  member.profile_img, project_period.name, goal.fical_year
	// 특정 목표 list를 파라미터로 넘겼을때 해당되는 list들의 저장된 목표 컬럼을 조회하는 메서드 
	public ArrayList<GoalThingsDto> getGoalThingsListFromGoalIdx(ArrayList<Integer> listGoalIdx) throws Exception {
		String sql = "SELECT title , goal.period_idx,  member.profile_img, project_period.name, goal.fical_year"
				+ " FROM goal INNER JOIN member " + " ON goal.owner= member.member_idx" + " INNER JOIN project_period"
				+ " ON goal.period_idx =  project_period. period_idx" + " WHERE goal_idx IN ("
				+ listGoalIdx.toString().replace("[", "").replace("]", "") + " )";

		ArrayList<GoalThingsDto> listRet = new ArrayList<GoalThingsDto>();

		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		ResultSet rs = pstmt.executeQuery();
		while (rs.next()) {
			String title = rs.getString("title");
			int periodIdx = rs.getInt("period_idx");
			String profileImg = rs.getString("profile_img");
			String name = rs.getString("name");
			int ficalYear = rs.getInt("fical_year");
			GoalThingsDto dto = new GoalThingsDto(title, periodIdx, profileImg, name, ficalYear);
			listRet.add(dto);
		}
		rs.close();
		pstmt.close();
		conn.close();
		return listRet;
	}
	
	// 특정 목표의 가장 최신 상태 조회 
	// 파라미터 : GoalIdx
	// 리턴값 : status_idx, name ,char_color ,background_color ,circle_color ,type
	// 특정 목표의 가장 최신 상태의 상태 idx, 상태 이름, 상태 색깔, 배경색깔, 타입을 조회하는 메서드 
	public StatusAllDto getStatusNameFromGoalIdx(int GoalIdx) throws Exception {
		String sql = "SELECT status_idx, name,char_color,background_color,circle_color,type" + " FROM status "
				+ " WHERE status_idx IN(" + " SELECT status_idx" + " FROM  ( SELECT *" + " FROM goal_status"
				+ " WHERE goal_idx=?" + " ORDER BY update_date DESC) " + " WHERE ROWNUM=1 )" + "";

		StatusAllDto dto = null;

		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, GoalIdx);
		ResultSet rs = pstmt.executeQuery();
		if (rs.next()) {
			int status_idx = rs.getInt("status_idx");
			String name = rs.getString("name");
			String char_color = rs.getString("char_color");
			String background_color = rs.getString("background_color");
			String circle_color = rs.getString("circle_color");
			String type = rs.getString("type");
			dto = new StatusAllDto(status_idx, name, char_color, background_color, circle_color, type);

		}
		rs.close();
		pstmt.close();
		conn.close();
		return dto;
	}
	
	// 특정 목표의 모든 컬럼 조회 
	// 파라미터 : goalIdx 
	// 리턴값 : project_idx, title, owner, parent_goal_idx, period_idx, range, content, start_date, deadline_date, fical_year
	// 특정 목표의 모든 컬럼을 조회하는 메서드 
	public GoalSelectAllDto getGoalSelectAllDao(int goalIdx) throws Exception {
		String sql = "SELECT project_idx, title, owner, parent_goal_idx, period_idx, range, content, start_date, deadline_date, fical_year"
				+ " FROM goal" + " WHERE goal_idx=?";
		GoalSelectAllDto dto = null;
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, goalIdx);
		ResultSet rs = pstmt.executeQuery();
		if (rs.next()) {

			int project_idx = rs.getInt("project_idx");
			String title = rs.getString("title");
			int owner = rs.getInt("owner");
			Integer parent_goal_idx = rs.getInt("parent_goal_idx");
			// int parent_goal_idx = rs.getInt("parent_goal_idx");
			int period_idx = rs.getInt("period_idx");
			int range = rs.getInt("range");
			String content = rs.getString("content");
			String start_date = rs.getString("start_date");
			String deadline_date = rs.getString("deadline_date");
			int fical_year = rs.getInt("fical_year");
			dto = new GoalSelectAllDto(goalIdx, project_idx, title, owner, parent_goal_idx, period_idx, range, content,
					start_date, deadline_date, fical_year);
		}

		rs.close();
		pstmt.close();
		conn.close();
		return dto;
	}
	
	// 목표 생성
	// 파라미터 : title,owner, parentGoalIdx, periodIdx,range, content, startDate,deadlineDate ,ficalYear
	// 리턴값 : goal_idx
	// 목표를 생성하고 생성된 목표idx를 리턴하는 메서드 
	public int insertGoalAllDao(String title, int owner, Integer parentGoalIdx, int periodIdx, int range, String content, String startDate, String deadlineDate , int ficalYear) throws Exception {
		String sql ="INSERT INTO goal (goal_idx,title,owner,parent_goal_idx,period_idx,range,content,start_date,deadline_date,fical_year) "
				+ " VALUES (seq_goal_idx.nextval, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
		Connection conn = getConnection();
		String[] arr = {"goal_idx"};
		PreparedStatement pstmt = conn.prepareStatement(sql, arr); 
		pstmt.setString(1, title);
		pstmt.setInt(2, owner);
		if(parentGoalIdx == null) {
			pstmt.setNull(3, Types.INTEGER);
		}else {
			pstmt.setInt(3, parentGoalIdx); 
		}
		pstmt.setInt(4, periodIdx);
		pstmt.setInt(5, range);
		pstmt.setString(6, content);
		pstmt.setString(7, startDate);
		pstmt.setString(8, deadlineDate);
		pstmt.setInt(9, ficalYear);
		pstmt.executeUpdate();
		
		ResultSet rs = pstmt.getGeneratedKeys(); 
		Integer pkValue = null;
		if (rs.next()) {
	        pkValue = rs.getInt(1);
	    }
		rs.close();
		pstmt.close();
		conn.close();
		
		return pkValue;
	}

	// 목표 설명 변경
	// 파라미터 :  contents,goalIdx
	// 특정 목표의 설명을 변경하는 메서드 
	public void updateGoalOfContentDao(String contents, int goalIdx) throws Exception {
		String sql = "UPDATE goal set content=? where goal_idx=?";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, contents);
		pstmt.setInt(2, goalIdx);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}
	
	// 목표의 사용자 지정 마감일 변경 
	// 파라미터 : startDate, dealineDate, goalIdx
	// 특정 목표의 사용자 지정 시작일, 마감일 변경하는 메서드 
	public void updateGoalOfCustomizedPeriodDao(String startDate, String dealineDate, int goalIdx) throws Exception {
		String sql = "UPDATE goal SET start_date=TO_DATE(?, 'YYYY/MM/DD HH24:MI:SS') , deadline_date= TO_DATE(?, 'YYYY/MM/DD HH24:MI:SS')WHERE goal_idx=?";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, startDate);
		pstmt.setString(2, dealineDate);
		pstmt.setInt(3, goalIdx);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}

	// 목표 상태의 업데이트 날짜 , 목표 번호 조회 
	// 파라미터 : goalIdx 
	// 리턴값 : update_date, status_idx
	// 특정 목표의 목표 idx, 업데이트 날짜 조회 하는 메서드 
	public ArrayList<GoalOfGoal_statusGetDto> getGoalOfGoal_statusDao(int goalIdx) throws Exception {
		String sql = "select update_date, status_idx" + " from goal INNER JOIN goal_status"
				+ " on goal.goal_idx = goal_status. goal_idx" + " WHERE goal.goal_idx=?";
		ArrayList<GoalOfGoal_statusGetDto> ListRet = new ArrayList<GoalOfGoal_statusGetDto>();
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, goalIdx);
		ResultSet rs = pstmt.executeQuery();

		while (rs.next()) {
			String update_date = rs.getString("update_date");
			int status_idx = rs.getInt("status_idx");
			GoalOfGoal_statusGetDto dto = new GoalOfGoal_statusGetDto(update_date, status_idx);
			ListRet.add(dto);
		}

		rs.close();
		pstmt.close();
		conn.close();
		return ListRet;
	}
	
	// 특정 목표의 하위 목표 조회 
	// 파라미터 : parentGoalIdx
	// 리턴값 : goal_idx
	// 특정 목표를 부모 목표로 저장하고있는 하위 목표 조회 
	public ArrayList<GoalSelectAllDto> getGoalOfParent_goal_idxDao(int parentGoalIdx) throws Exception {
		String sql = "SELECT goal_idx" + " FROM goal" + " WHERE parent_goal_idx = ?";
		ArrayList<GoalSelectAllDto> list = new ArrayList<GoalSelectAllDto>();
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, parentGoalIdx);
		ResultSet rs = pstmt.executeQuery();

		while (rs.next()) {
			int goal_idx = rs.getInt("goal_idx");
			GoalSelectAllDto dto = new GoalSelectAllDto();
			dto.setGoalIdx(goal_idx);
			list.add(dto);
		}

		rs.close();
		pstmt.close();
		conn.close();
		return list;
	}
	
	// 목표의 상목표 변경
	// 파라미터 :  parentGoalIdx, goalIdx
	// 특정 목표의 부모목표를 변경하는 메서드 
	public void updateGoalOfParent_goal_idxDao(int parentGoalIdx, int goalIdx) throws Exception {
		String sql = "UPDATE goal SET parent_goal_idx = ? WHERE goal_idx=?";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, parentGoalIdx);
		pstmt.setInt(2, goalIdx);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}
	
	// 목표의 기간 조회 
	// 파라미터 : goalIdx
	// 리턴값 : fical_year, period_idx, name, term
	// 특정 목표의 년도, 목표 idx , 기간이름, 세부 기간을 조회하는 메서드 
	public GoalOfPeriodGetDto getGoalOfPeriodGetDao(int goalIdx) throws Exception {
		String sql = "SELECT goal.fical_year,project_period.period_idx," + " project_period.name,project_period.term"
				+ " FROM goal inner join  project_period" + " ON goal.period_idx = project_period.period_idx"
				+ " WHERE goal.goal_idx=?";

		GoalOfPeriodGetDto dto = null;
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, goalIdx);
		ResultSet rs = pstmt.executeQuery();

		if (rs.next()) {
			int fical_year = rs.getInt("fical_year");
			int period_idx = rs.getInt("period_idx");
			String name = rs.getString("name");
			String term = rs.getString("term");
			dto = new GoalOfPeriodGetDto(fical_year, period_idx, name, term);
		}

		rs.close();
		pstmt.close();
		conn.close();
		return dto;
	}
	
	// 목표의 기간 변경
	// 파라미터 : periodIdx, ficalYear, goalIdx
	// 목표의 기간, 해당년도 변경하는 메서드 
	public void updateGoalOfPeriodDao(int periodIdx, int ficalYear, int goalIdx) throws Exception {
		String sql = "UPDATE goal set period_idx = ? , fical_year = ?  WHERE goal_idx=?";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, periodIdx);
		pstmt.setInt(2, ficalYear);
		pstmt.setInt(3, goalIdx);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}
	
	// 목표의 상위목표 변경
	// 파라미터 : parentGoalIdx, goalIdx
	// 특정 목표의 상위목표를 변경하는 메서드 
	public void updateGoalParent_Goal_IdxDao(int parentGoalIdx, int goalIdx) throws Exception {
		String sql = "UPDATE goal SET parent_goal_idx=? WHERE goal_idx=?";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, parentGoalIdx);
		pstmt.setInt(2, goalIdx);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}
	
	// 목표의 제목 변경 
	// 파라미터 : title, goalIdx
	// 특정 목표의 제목을 변경하는 메서드 
	public void updateGoalTitleDao(String title, int goalIdx) throws Exception {
		String sql = "UPDATE goal" + " SET title=?" + " WHERE goal_idx=?";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, title);
		pstmt.setInt(2, goalIdx);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}
	
	// 연결된 목표 검색시 조회되는 모든 목표 
	// 파라미터 : goalIdx
	// 리턴값 :  goal_idx , title , owner , period_idx , start_date, deadline_date, fical_year
	// 목표의 상위 목표와 나 자신 목표를 제외한 목표를 조회할 메서드 
	public ArrayList<GoalSelectAllDto> getSubGoalClickDao(int goalIdx) throws Exception {
		String sql = "SELECT  goal_idx , title , owner , period_idx , start_date, deadline_date, fical_year"
				+ " FROM goal" + " WHERE goal_idx NOT IN(SELECT goal_idx" + " FROM goal" + " WHERE parent_goal_idx =?)"
				+ " AND goal_idx NOT IN(?)";
		ArrayList<GoalSelectAllDto> ListSet = new ArrayList<GoalSelectAllDto>();
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, goalIdx);
		pstmt.setInt(2, goalIdx);
		ResultSet rs = pstmt.executeQuery();
		while (rs.next()) {
			goalIdx = rs.getInt("goal_Idx");
			String title = rs.getString("title");
			int owner = rs.getInt("owner");
			int period_idx = rs.getInt("period_idx");
			String start_date = rs.getString("start_date");
			String deadline_date = rs.getString("deadline_date");
			int fical_year = rs.getInt("fical_year");
			GoalSelectAllDto dto = new GoalSelectAllDto();
			dto.setGoalIdx(goalIdx);
			dto.setTitle(title);
			dto.setOwner(owner);
			dto.setPeriodIdx(period_idx);
			dto.setStartDate(start_date);
			dto.setDeadlineDate(deadline_date);
			dto.setFicalYear(fical_year);
			ListSet.add(dto);
		}

		rs.close();
		pstmt.close();
		conn.close();
		return ListSet;
	}
	
	// 관련 업무 (포트폴리오) 검색 조회 
	// 파라미터 : goalIdx
	// 리턴값 : portfolio_idx,  name, status_idx, range, default_view, priority, member_idx, parent_idx
	// 특정 목표와 연결되어진 포트폴리오를 제외한 관련업무에 추가할 수 있는 포트폴리오를 조회할수있는 메서드 
	public ArrayList<PortfolioAllDto> getRelated_workClickGetPortfolioDao(int goalIdx) throws Exception {
		String sql = "SELECT portfolio_idx,  name, status_idx, range, default_view, priority, member_idx, parent_idx"
				+ " FROM PORTFOLIO" + " WHERE portfolio_idx NOT IN (SELECT portfolio_idx" + " FROM  Related_work"
				+ " WHERE goal_idx = ?" + " AND portfolio_idx IS NOT NULL)";
		ArrayList<PortfolioAllDto> list = new ArrayList<PortfolioAllDto>();
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, goalIdx);
		ResultSet rs = pstmt.executeQuery();
		while (rs.next()) {
			int portfolioIdx = rs.getInt("portfolio_idx");
			String name = rs.getString("name");
			Integer status_idx = rs.getInt("status_idx");
			int range = rs.getInt("range");
			int defaultView = rs.getInt("default_view");
			Integer priority = rs.getInt("priority");
			int memberIdx = rs.getInt("member_idx");
			Integer parentIdx = rs.getInt("parent_idx");
			PortfolioAllDto dto = new PortfolioAllDto();
			dto.setPortfolioIdx(portfolioIdx);
			dto.setName(name);
			dto.setStatus_idx(status_idx);
			dto.setRange(range);
			dto.setDefaultView(defaultView);
			dto.setPriority(priority);
			dto.setMemberIdx(memberIdx);
			dto.setParentIdx(parentIdx);
			dto.setPortfolioIdx(portfolioIdx);
			list.add(dto);
		}

		rs.close();
		pstmt.close();
		conn.close();
		return list;
	}
	
	// 관련 업무(프로젝트) 검색 조회 
	// 파라미터 : goalIdx
	// 리턴값 : name
	// 특정 목표의 관련업무에 추가할수있는 프로젝트 이름 조회하는 메서드 
	public ArrayList<ProjectAllDto> getRelated_workClickGetProjectNameDao(int goalIdx) throws Exception {
		String sql = "SELECT name" + " FROM project" + " WHERE project_idx NOT IN (SELECT project_idx"
				+ " FROM related_work" + " WHERE goal_idx=?" + " AND project_idx IS NOT NULL)";
		ArrayList<ProjectAllDto> list = new ArrayList<ProjectAllDto>();
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, goalIdx);
		ResultSet rs = pstmt.executeQuery();
		while (rs.next()) {
			String name = rs.getString("name");
			ProjectAllDto dto = new ProjectAllDto();
			dto.setName(name);
			list.add(dto);
		}

		rs.close();
		pstmt.close();
		conn.close();
		return list;
	}
	
	// 관련 업무(작업) 검색 조회 
	// 파라미터 : goalIdx
	// 리턴값 : wam_idx, project_idx, wam_type, title, manager_idx , creator_idx , complete_date, approval
	// 특정 목표의 관련업무에 추가할수있는 작업 조회하는 메서드 
	public ArrayList<WamAllDto> getRelated_workClickWamDao(int goalIdx) throws Exception {
		String sql = "SELECT wam_idx, project_idx, wam_type, title, manager_idx , creator_idx , complete_date, approval"
				+ " FROM wam" + " WHERE wam_idx NOT IN (SELECT wam_idx" + " FROM Related_work" + " WHERE goal_idx = ?"
				+ " AND wam_idx IS NOT NULL)";
		ArrayList<WamAllDto> list = new ArrayList<WamAllDto>();
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, goalIdx);
		ResultSet rs = pstmt.executeQuery();
		while (rs.next()) {
			int wamIdx = rs.getInt("wam_idx");
			int projectIdx = rs.getInt("project_idx");
			String wamType = rs.getString("wam_type");
			String title = rs.getString("title");
			int managerIdx = rs.getInt("manager_idx");
			int creatorIdx = rs.getInt("creator_idx");
			String completeDate = rs.getString("complete_date");
			int approval = rs.getInt("approval");
			WamAllDto dto = new WamAllDto();
			dto.setWamIdx(wamIdx);
			dto.setProjectIdx(projectIdx);
			dto.setWamIdx(wamIdx);
			dto.setTitle(title);
			dto.setManagerIdx(managerIdx);
			dto.setCreatorIdx(creatorIdx);
			dto.setCompleteDate(completeDate);
			dto.getApproval();
			list.add(dto);
		}

		rs.close();
		pstmt.close();
		conn.close();
		return list;
	}
	
	// 프로젝트의 최신 진행상태 조회 
	// 파라미터 : projectConnection
	// 리턴값 : goal_idx, project_connection, progress_status, update_date
	// 연결된 프로젝트의 가장 최신 진행상태 조회 
	public Progress_statusAllDto getProgress_statusAllDao(int projectConnection) throws Exception {
		String sql = "SELECT goal_idx, project_connection, progress_status, update_date" + " FROM (SELECT *"
				+ " FROM progress_status" + " WHERE  project_connection = ?" + " ORDER BY update_date DESC)"
				+ " WHERE rownum=1";
		Progress_statusAllDto dto = null;
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, projectConnection);
		ResultSet rs = pstmt.executeQuery();

		if (rs.next()) {
			int goal_idx = rs.getInt("goal_idx");
			int progress_status = rs.getInt("progress_status");
			String update_date = rs.getString("update_date");
			dto = new Progress_statusAllDto(goal_idx, projectConnection, progress_status, update_date);
		}

		rs.close();
		pstmt.close();
		conn.close();
		return dto;
	}
	
	// 목표의 최신 진행상태 조회 
	// 파라미터 : goalIdx
	// 리턴값 : project_connection, progress_status, update_date
	// 특정 목표의 가장 최신 진행상태 퍼센트, 날짜 조회하는 메서드 
	public Progress_statusAllDto getProgress_statusRecentOfgoal_idxDao(int goalIdx) throws Exception {
		String sql = "SELECT project_connection, progress_status, update_date" + " FROM (SELECT *"
				+ " FROM progress_status" + " WHERE goal_idx = ?" + " order by update_date DESC)" + " WHERE ROWNUM=1";
		Progress_statusAllDto dto = null;
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, goalIdx);
		ResultSet rs = pstmt.executeQuery();
		if (rs.next()) {
			int project_connection = rs.getInt("project_connection");
			int progress_status = rs.getInt("progress_status");
			String update_date = rs.getString("update_date");
			dto = new Progress_statusAllDto(goalIdx, project_connection, progress_status, update_date);
		}
		
		rs.close();
		pstmt.close();
		conn.close();
		return dto;
	}
	
	// 연결된 목표 제거 
	// 파라미터 : goalIdx, projectConnection
	// 특정목표와 연결된 특정 프로젝트를 제거하는 메서드 
	public void deleteGoal_connectionDao(int goalIdx, int projectConnection) throws Exception {
		String sql = "delete from goal_connection where  goal_idx = ? and  project_connection = ?";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, goalIdx);
		pstmt.setInt(2, projectConnection);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}
	
	// 연결된 목표 추가
	// 파라미터 : goalIdx, projectConnection
	// 특정 프로젝트와 특정 목표를 연결하는 메서드 
	public void insertGoal_connectionDao(int goalIdx, int projectConnection) throws Exception {
		String sql = "INSERT INTO goal_connection(goal_idx,project_connection) VALUES (?,?)";

		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, goalIdx);
		pstmt.setInt(2, projectConnection);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}
	
	// 연결된 프로젝트 조회 
	// 파라미터 : goalIdx
	// 특정 목표와 연결되어진 프로젝트를 조회하는 메서드 
	public ArrayList<ProjectAllDto> getGoal_connectionOfProjectDao(int goalIdx) throws Exception {
		String sql = "select project_idx, name, member_idx" + " from PROJECT" + " where project_idx in("
				+ " select project_connection" + " from goal_connection" + " where goal_idx=?)";
		ArrayList<ProjectAllDto> ListRet = new ArrayList<ProjectAllDto>();
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
			ListRet.add(dto);
		}

		rs.close();
		pstmt.close();
		conn.close();
		return ListRet;
	}
	
	// 목표의 상태업데이트의 협업참여자 삭제 
	// 파라미터 :  statusIdx, memberIdx
	// 특정 목표의 상태업데이트의 협업참여자를 삭제하는 메서드 
	public void deleteGoal_STATUS_cooperationDao(int statusIdx, int memberIdx) throws Exception {
		String sql = "delete from goal_STATUS_cooperation where status_idx=? and member_idx=?";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, statusIdx);
		pstmt.setInt(2, memberIdx);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}
	
	// 목표의 상태업데이트의 협업참여자 조회
	// 파라미터 : statusIdx
	// 특정 목표의 상태업데이트의 협업참여자 조회하는 메서드 
	public ArrayList<Goal_STATUS_CooperationAllDto> getGoal_STATUS_CooperationAllDao(int statusIdx) throws Exception {
		String sql = "select member_idx" + " from goal_STATUS_cooperation" + " where status_idx = ? ";
		ArrayList<Goal_STATUS_CooperationAllDto> ListSet = new ArrayList<Goal_STATUS_CooperationAllDto>();
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, statusIdx);
		ResultSet rs = pstmt.executeQuery();

		while (rs.next()) {
			int member_idx = rs.getInt("member_idx");
			Goal_STATUS_CooperationAllDto dto = new Goal_STATUS_CooperationAllDto(statusIdx, member_idx);
			ListSet.add(dto);
		}

		rs.close();
		pstmt.close();
		conn.close();
		return ListSet;
	}
	
	// 목표의 상태업데이트의 협업참여자 추가 
	// 파라미터 :  statusIdx, memberIdx
	// 특정 목표의 상태업데이트의 협업참여자 추가하는 메서드 
	public void insertGoal_status_cooperationDao(int statusIdx, int memberIdx) throws Exception {
		String sql = "insert into goal_status_cooperation(status_idx,member_idx) values(?,?)";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, statusIdx);
		pstmt.setInt(2, memberIdx);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}
	
	// 목표의 상태 삭제 
	// 파라미터 : goalStatus_idx
	// 목표의 상태를 삭제하는 메서드 
	public void deleteGoal_statusDao(int goalStatus_idx) throws Exception {
		String sql = "delete from goal_status where goal_status_idx = ?";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, goalStatus_idx);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}
	
	// 목표의 상태 조회 
	// 파라미터 : goalIdx
	// 특정 목표의 상태를 세부 조회 하는 메서드 
	public Goal_statusGetAllDto getGoal_statusAllDao(int goalIdx) throws Exception {
		String sql = "SELECT  goal_idx, status_idx,  member_idx, update_date" + " FROM goal_status"
				+ " WHERE goal_status_idx = ?";
		Goal_statusGetAllDto dto = null;
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, goalIdx);
		ResultSet rs = pstmt.executeQuery();
		if (rs.next()) {
			int status_idx = rs.getInt("status_idx");
			int member_idx = rs.getInt("member_idx");
			String update_date = rs.getString("update_date");
			dto = new Goal_statusGetAllDto(goalIdx, status_idx, member_idx, update_date);
		}

		rs.close();
		pstmt.close();
		conn.close();
		return dto;
	}
	
	// 목표의 상태를 업데이트 
	// 파라미터 : int goalIdx, statusIdx, memberIdx, updateDate
	// 목표의 상태를 업데이트 하는 메서드 
	public void insertGoal_statustDao(int goalIdx, int statusIdx, int memberIdx, String updateDate) throws Exception {
		String sql = "INSERT INTO goal_status (goal_status_idx, goal_idx , status_idx, member_idx, update_date)"
				+ " VALUES (seq_goal_status_idx.nextval, ?, ?, ?, to_date(?, 'YYYY/MM/DD HH24:MI')";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, goalIdx);
		pstmt.setInt(2, statusIdx);
		pstmt.setInt(3, memberIdx);
		pstmt.setString(4, updateDate);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}
	
	// 목표의 최신 상태 조회 
	// 파라미터 : goalIdx
	// 리턴값 :  name, char_color, background_color, circle_color, type
	// 특정 목표의 가장 최신 업데이트된 상태이름, 색깔, 타입 조회하는 메서드  
	public StatusAllDto getStatusAllDao(int goalIdx) throws Exception {
		String sql = "SELECT name, char_color, background_color, circle_color, type" + " FROM status"
				+ " WHERE status_idx IN(" + "SELECT status_idx" + "FROM (SELECT" + " FROM goal_status"
				+ " WHERE goal_idx=?" + " ORDER BY update_date DESC)" + " WHERE ROWNUM=1)";

		StatusAllDto dto = null;
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, goalIdx);
		ResultSet rs = pstmt.executeQuery();

		if (rs.next()) {
			int status_idx = rs.getInt("status_idx");
			String name = rs.getString("name");
			String char_color = rs.getString("char_color");
			String background_color = rs.getString("background_color");
			String circle_color = rs.getString("circle_color");
			String type = rs.getString("type");
			dto = new StatusAllDto(status_idx, name, char_color, background_color, circle_color, type);
		}

		rs.close();
		pstmt.close();
		conn.close();
		return dto;
	}
	
	// 포트폴리오에 속한 프로젝트의 갯수 
	// 파라미터 :  portfolioIdx
	// 리턴값 : 프로젝트 갯수 
	// 포트폴리오에 속한 프로젝트의 갯수 조회하는 메서드 
	public int countPortfolio_CompositionOfProjectDao(int portfolioIdx) throws Exception {
		String sql = "SELECT count(project_idx)" + " FROM PORTFOLIO_COMPOSITION" + " WHERE portfolio_idx=?";
		int result = 0;
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, portfolioIdx);
		ResultSet rs = pstmt.executeQuery();
		if (rs.next()) {
			result = rs.getInt("count(project_idx)");
		}

		pstmt.close();
		conn.close();
		return result;
	}
	
	// 상위 포트폴리오에 속한 포트폴리오 갯수 
	// 파라미터 : parentIdx
	// 리턴값 : 포트폴리오 갯수 
	// 상위 포트폴리오에 속한 포트폴리오 갯수 조회 하는 메서드 
	public int portfolioOfCountParentDao(int parentIdx) throws Exception {
		String sql = "SELECT count(portfolio_idx)" + " FROM PORTFOLIO" + " WHERE parent_idx = ?";
		int result = 0;
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, parentIdx);
		ResultSet rs = pstmt.executeQuery();
		if (rs.next()) {
			result = rs.getInt("count(portfolio_idx)");
		}

		rs.close();
		pstmt.close();
		conn.close();
		return result;
	}
	
	// 목표의 관련업무(작업) 조회 
	// 파라미터 : goalIdx
	// 리턴값 :  wam_idx
	// 목표의 관련업무에 저장되어진 작업 조회 
	public ArrayList<Related_workAllDto> relatedWorkOfWamGetDto(int goalIdx) throws Exception {
		String sql = "SELECT wam_idx" + " FROM Related_work" + " WHERE goal_idx=? AND wam_idx IS NOT NULL";

		ArrayList<Related_workAllDto> related_workAllDtolist = new ArrayList<Related_workAllDto>();

		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, goalIdx);
		ResultSet rs = pstmt.executeQuery();
		while (rs.next()) {
			int wamIdx = rs.getInt("wam_idx");
			Related_workAllDto related_workAllDto = new Related_workAllDto();
			related_workAllDto.setWamIdx(wamIdx);
			related_workAllDtolist.add(related_workAllDto);
		}

		rs.close();
		pstmt.close();
		conn.close();
		return related_workAllDtolist;
	}
	
	// 목표의 관련업무(프로젝트) 조회 
	// 파라미터 : goalIdx
	// 리턴값 :   project_idx
	// 목표의 관련업무에 저장되어진 프로젝트 조회 
	public ProjectAllDto relatedWorkOfProjectGetDto(int goalIdx) throws Exception {
		String sql = "SELECT project_idx" + " FROM Related_work" + " WHERE goal_idx=? AND project_idx  IS NOT NULL";
		ProjectAllDto projectAllDto = null;
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, goalIdx);
		ResultSet rs = pstmt.executeQuery();

		if (rs.next()) {
			int projectIdx = rs.getInt("project_idx");
			projectAllDto = new ProjectAllDto();
			projectAllDto.setProject_idx(projectIdx);
		}

		rs.close();
		pstmt.close();
		conn.close();
		return projectAllDto;
	}
	
	// 타임라인 조회 
	// 파라미터 : projectIdx
	// 리턴값 : idx, date, type
	// 프로젝트 멤버참여 , 메세지 , 상태업데이트 내림차순 조회하는 메서드 
	public ArrayList<TimeLineThingDto> timeLineThingGetDto(int projectIdx) throws Exception {
		String sql = "SELECT *" + " FROM"
				+ " (SELECT project_status_idx \"idx\", status_date \"date\", 'project_status' \"type\""
				+ " FROM project_status" + " WHERE project_idx=?" + " UNION ALL"
				+ " SELECT project_participants \"idx\", participant_date \"date\", 'project_participants' \"type\""
				+ " FROM project_participants" + " WHERE project_idx=? " + " UNION ALL"
				+ " SELECT message_idx \"idx\", write_date \"date\", 'message' \"type\"" + " FROM message"
				+ " WHERE project_idx=?)" + " ORDER BY \"date\" DESC";
		ArrayList<TimeLineThingDto> TimeLineThingDtolist = new ArrayList<TimeLineThingDto>();
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, projectIdx);
		pstmt.setInt(2, projectIdx);
		pstmt.setInt(3, projectIdx);
		ResultSet rs = pstmt.executeQuery();
		while (rs.next()) {
			int idx = rs.getInt("idx");
			String date = rs.getString("date");
			String type = rs.getString("type");
			TimeLineThingDto timeLineThingDto = new TimeLineThingDto();
			timeLineThingDto.setIdx(idx);
			timeLineThingDto.setType(type);
			timeLineThingDto.setDate(date);
			TimeLineThingDtolist.add(timeLineThingDto);
		}

		rs.close();
		pstmt.close();
		conn.close();
		return TimeLineThingDtolist;
	}
	
	// 프로젝트 상태 조회 
	// 파라미터 : projectStatusIdx
	// 리턴값 : status_idx , member_idx , status_date
	// 특정 프로젝트의 상태 세부 조회 
	public ProjectStatusDto getProjectStatusThingsDto(int projectStatusIdx) throws Exception {
		String sql = "SELECT status_idx , member_idx , status_date" + " FROM project_status"
				+ " WHERE project_status_idx = ?";
		ProjectStatusDto projectStatusDto = null;
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, projectStatusIdx);
		ResultSet rs = pstmt.executeQuery();
		if (rs.next()) {
			int statusIdx = rs.getInt("status_idx");
			int memberIdx = rs.getInt("member_idx");
			String statusDate = rs.getString("status_date");
			projectStatusDto = new ProjectStatusDto();
			projectStatusDto.setStatusIdx(statusIdx);
			projectStatusDto.setMemberIdx(memberIdx);
			projectStatusDto.setStatusDate(statusDate);
		}

		rs.close();
		pstmt.close();
		conn.close();
		return projectStatusDto;
	}
	
	// 메세지 조회 
	// 파라미터 : messageIdx
	// 리턴값 : title , writer_idx , write_date
	// 메세지 클릭시 메세지의 세부내용 조회 
	public MessageThingsDto getMessageThingsDto(int messageIdx) throws Exception {
		String sql = "SELECT title , writer_idx , write_date" + " FROM message" + " WHERE message_idx = ?";
		MessageThingsDto dto = null;
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, messageIdx);
		ResultSet rs = pstmt.executeQuery();
		if (rs.next()) {
			String title = rs.getString("title");
			int writerIdx = rs.getInt("writer_idx");
			String writeDate = rs.getString("write_date");
			dto = new MessageThingsDto(title, writerIdx, writeDate);
		}

		rs.close();
		pstmt.close();
		conn.close();
		return dto;
	}
	
	// 프로젝트 참여자 조회 
	// 파라미터 :  projectParticipants
	// 리턴값 : member_idx, participant_date
	// 특정 프로젝트의 참여자 조회하는 메서드 
	public Project_participantsAllDto getProject_participantsThingsDto(int projectParticipants) throws Exception {
		String sql = "SELECT member_idx, participant_date" + " FROM project_participants"
				+ " WHERE project_participants = ?";
		Project_participantsAllDto dto = null;
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, projectParticipants);
		ResultSet rs = pstmt.executeQuery();
		if (rs.next()) {
			int memberIdx = rs.getInt("member_idx");
			String participantDate = rs.getString("participant_date");
			dto = new Project_participantsAllDto();
			dto.setMember_idx(memberIdx);
			dto.setParticipant_date(participantDate);
		}

		rs.close();
		pstmt.close();
		conn.close();
		return dto;
	}
	
	// 프로젝트의 연결된 목표조회 
	// 파라미터 :  projectIdx
	// 리턴값 :  goal_idx, title , owner, parent_goal_idx, period_idx, range, content, start_date, deadline_date, fical_year
	// 특정 프로젝트에 연결된 목표 세부 조회하는 메서드 
	public ArrayList<GoalSelectAllDto> getGoalAllOfProject(int projectIdx) throws Exception {
		String sql = "SELECT g.goal_idx, g.title , g.owner, g.parent_goal_idx, g.period_idx, g.range, g.content, g.start_date, g.deadline_date, g.fical_year"
				+ " FROM goal g INNER JOIN goal_connection c " + " ON g.goal_idx = c.goal_idx"
				+ " WHERE c.project_connection=?";
		ArrayList<GoalSelectAllDto> goalSelectAllDtolist = new ArrayList<GoalSelectAllDto>();
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, projectIdx);
		ResultSet rs = pstmt.executeQuery();
		while (rs.next()) {
			GoalSelectAllDto goalSelectAllDto = new GoalSelectAllDto();
			int goalIdx = rs.getInt("goal_idx");
			String title = rs.getString("title");
			int owner = rs.getInt("owner");
			rs.getInt("parent_goal_idx");
			Integer parentGoalIdx;
			if (!rs.wasNull())
				parentGoalIdx = rs.getInt("parent_goal_idx");
			else
				parentGoalIdx = null;
			int periodIdx = rs.getInt("period_idx");
			int range = rs.getInt("range");
			String content = rs.getString("content");
			String startDate = rs.getString("start_date");
			String deadlineDate = rs.getString("deadline_date");
			int ficalYear = rs.getInt("fical_year");
			goalSelectAllDto.setGoalIdx(goalIdx);
			goalSelectAllDto.setTitle(title);
			goalSelectAllDto.setOwner(owner);
			goalSelectAllDto.setParentGoalIdx(parentGoalIdx);
			goalSelectAllDto.setPeriodIdx(periodIdx);
			goalSelectAllDto.setContent(content);
			goalSelectAllDto.setRange(range);
			goalSelectAllDto.setStartDate(startDate);
			goalSelectAllDto.setDeadlineDate(deadlineDate);
			goalSelectAllDto.setFicalYear(ficalYear);
			goalSelectAllDtolist.add(goalSelectAllDto);
		}

		rs.close();
		pstmt.close();
		conn.close();
		return goalSelectAllDtolist;
	}
	
	// 연결된 목표 검색 
	// 파라미터 : projectIdx, goalTitle
	// 리턴값 :  goal_idx
	// 프로젝트에 연결하고 싶은 목표를 검색할때 조회되는 메서드 
	public ArrayList<Integer> connectedGoalSearch(int projectIdx, String goalTitle) throws Exception {
		String sql = "SELECT goal_idx" + " FROM GOAL" + " WHERE goal_idx NOT IN (SELECT g.goal_idx"
				+ "                       FROM GOAL g INNER JOIN GOAL_CONNECTION c"
				+ "                       ON g.goal_idx = c.goal_idx"
				+ "                       WHERE c.project_connection=?)" + " AND title LIKE ?";

		ArrayList<Integer> listRet = new ArrayList<Integer>();

		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, projectIdx);
		pstmt.setString(2, "%" + goalTitle + "%");
		ResultSet rs = pstmt.executeQuery();
		while (rs.next()) {
			listRet.add(rs.getInt("goal_idx"));
		}
		
		rs.close();
		pstmt.close();
		conn.close();
		return listRet;
	}
	
	// 연결된 목표 검색시 조회 목표 갯수 
	// 파라미터 : projectIdx, goalTitle
	// 리턴값 :  goal_idx의 갯수 
	// 프로젝트에 연결하고 싶은 목표를 검색할때 조회되는 목표의 갯수를 조회하는 메서드 
	public Integer connectedGoalSearchCheck(int projectIdx, String goalTitle) throws Exception {
		String sql = "SELECT count(*)" + " FROM GOAL" + " WHERE goal_idx NOT IN (SELECT g.goal_idx"
				+ "					   FROM GOAL g INNER JOIN goal_connection c"
				+ "                    ON g.goal_idx = c.goal_idx"
				+ "					   WHERE c.project_connection=?)" + " AND title LIKE ?";

		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, projectIdx);
		pstmt.setString(2, "%" + goalTitle + "%");
		ResultSet rs = pstmt.executeQuery();
		Integer count = null;
		if (rs.next()) {
			count = rs.getInt("count(*)");
		}
		
		rs.close();
		pstmt.close();
		conn.close();
		return count;
	}

	// 목표 생성 
	// 파라미터 : goalIdx, projectConnection 
	// 목표 생성시 해당 프로젝와 연결시키기는 메서드 
	public void goalConnectionInsert(int goalIdx, int projectConnection) throws Exception {
		String sql = "insert into goal_connection(goal_idx,project_connection) values(?,?)";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, goalIdx);
		pstmt.setInt(2, projectConnection);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}

	public static void main(String[] args) throws Exception {
	
		
	}

}
