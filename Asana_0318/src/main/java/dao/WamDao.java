package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Scanner;

import dto.MemberAllDto;
import dto.MemberDto;
import dto.ProjectAllDto;
import dto.ProjectDto;
import dto.SectionAllDto;
import dto.WamAllDto;
import dto.WamDto;

public class WamDao {
	public Connection getConnection() throws Exception {
		String driver = "oracle.jdbc.driver.OracleDriver";
		String url = "jdbc:oracle:thin:@gusdntkd.cafe24.com:1521:xe";
		String id = "asana_hw";
		String pw = "asana12345";

		Class.forName(driver);
		Connection conn = DriverManager.getConnection(url, id, pw);
		return conn;
	}
	
	// 작업 생성 
	// 파라미터 : projectIdx, title, managerIdx, deadlineDate, content
	// 새로운 작업을 생성하는 메서드 
	public int insertNewWam(int projectIdx, String title, int managerIdx, String deadlineDate, String content)
			throws Exception {

		String sql = "INSERT INTO wam(wam_idx, project_idx, wam_type, title, manager_idx, creator_idx, deadline_date, create_date, start_date, complete_date, wam_parent_idx, content, following_idx, approval, correction_date, orders, section_idx, file_idx)"
				+ " VALUES(seq_wam_idx.nextval, ?, 'w', ?, ?, ?, TO_DATE(?, 'YYYY/MM/DD HH24:MI'), SYSDATE, NULL, NULL, NULL, ?, NULL, NULL, SYSDATE, NULL, NULL, NULL)";
		Connection conn = getConnection();
		String arr[] = { "wam_idx" };
		PreparedStatement pstmt = conn.prepareStatement(sql, arr);
		pstmt.setInt(1, projectIdx);
		pstmt.setString(2, title);
		pstmt.setInt(3, managerIdx);
		pstmt.setInt(4, managerIdx);
		pstmt.setString(5, deadlineDate);
		pstmt.setString(6, content);
		pstmt.executeUpdate();
		ResultSet rs = pstmt.getGeneratedKeys();
		Integer pkValue = null;
		if (rs.next()) {
			pkValue = rs.getInt(1);
		}
		pstmt.close();
		conn.close();
		return pkValue;
	}

	// 후속 검색 리스트 조회 
	// 파라미터 : wamIdx
	// 리턴값 : wam_type, title, project_idx, complete_date, approval, wam_idx
	// 나의 종속, 선행이 모두 없을때 후속 검색 리스트 조회 하는 메서드  
	public ArrayList<WamAllDto> dependencyOfClickNoAll(int wamIdx) throws Exception {
		String sql = "SELECT wam_type, title, project_idx, complete_date, approval, wam_idx" + " FROM wam"
				+ " WHERE wam_idx !=?";
		ArrayList<WamAllDto> list = new ArrayList<WamAllDto>();
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, wamIdx);

		ResultSet rs = pstmt.executeQuery();
		while (rs.next()) {
			char wamType = rs.getString("wam_type").charAt(0);
			String title = rs.getString("title");
			int projectIdx = rs.getInt("project_idx");
			String completeDate = rs.getString("complete_date");
			Integer approval;
			rs.getInt("approval");
			if (!rs.wasNull()) {
				approval = rs.getInt("approval");
			} else {
				approval = null;
			}
			wamIdx = rs.getInt("wam_idx");
			WamAllDto dto1 = new WamAllDto(projectIdx, wamIdx, wamType, title, completeDate, approval);
			list.add(dto1);
		}
		rs.close();
		pstmt.close();
		conn.close();
		return list;
	}
	
	// 후속 검색 리스트 조회 
	// 파라미터 : wamIdx
	// 리턴값 : wam_type, title, project_idx, complete_date, approval, wam_idx
	// 나의 선행이 있을때 선행을 제외하고 검색 리스트 조회 하는 메서드  
	public ArrayList<WamAllDto> dependencyOfClickNosubtask(int wamIdx) throws Exception {
		String sql = "SELECT wam_type, title, project_idx, complete_date, approval, wam_idx" + " FROM wam"
				+ " WHERE wam_idx !=?" + " AND wam_idx NOT IN (SELECT wam_idx" + "FROM wam"
				+ "                    WHERE following_idx=?)";

		ArrayList<WamAllDto> list = new ArrayList<WamAllDto>();
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, wamIdx);
		pstmt.setInt(2, wamIdx);
		ResultSet rs = pstmt.executeQuery();
		while (rs.next()) {
			char wamType = rs.getString("wam_type").charAt(0);
			String title = rs.getString("title");
			int projectIdx = rs.getInt("project_idx");
			String completeDate = rs.getString("complete_date");

			Integer approval;
			rs.getInt("approval");
			if (!rs.wasNull()) {
				approval = rs.getInt("approval");
			} else {
				approval = null;
			}
			wamIdx = rs.getInt("wam_idx");
			WamAllDto dto1 = new WamAllDto(projectIdx, wamIdx, wamType, title, completeDate, approval);
			list.add(dto1);
		}
		rs.close();
		pstmt.close();
		conn.close();
		return list;
	}
	
	// 후속 검색 리스트 조회 
	// 파라미터 : wamIdx
	// 리턴값 : wam_type, title, project_idx, complete_date, approval, wam_idx
	// 나의 종속이 있을때 종속을 제외하고 검색 리스트 조회 하는 메서드  
	public ArrayList<WamAllDto> dependencyOfClickNopreceding(int wamIdx) throws Exception {
		String sql = "SELECT wam_type, title, project_idx, complete_date, approval, wam_idx" + " FROM wam"
				+ " WHERE wam_idx !=?" + " AND wam_idx NOT IN (SELECT following_idx" + "                    FROM wam"
				+ "                    WHERE wam_idx=?)";
		ArrayList<WamAllDto> list = new ArrayList<WamAllDto>();
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, wamIdx);
		pstmt.setInt(2, wamIdx);
		ResultSet rs = pstmt.executeQuery();
		while (rs.next()) {
			char wamType = rs.getString("wam_type").charAt(0);
			String title = rs.getString("title");
			int projectIdx = rs.getInt("project_idx");
			String completeDate = rs.getString("complete_date");

			Integer approval;
			rs.getInt("approval");
			if (!rs.wasNull()) {
				approval = rs.getInt("approval");
			} else {
				approval = null;
			}
			wamIdx = rs.getInt("wam_idx");
			WamAllDto dto1 = new WamAllDto(projectIdx, wamIdx, wamType, title, completeDate, approval);
			list.add(dto1);
		}
		rs.close();
		pstmt.close();
		conn.close();
		return list;
	}
	
	// 선행 삭제 
	// 파라미터 :  wamIdx
	// 나의 선행작업을 삭제하는 메서드 
	public void deletePrecedingIdx(int wamIdx) throws Exception {
		String sql = "update wam set following_idx = null where wam_idx = ?";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, wamIdx);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}
	
	// 선행 검색 리스트 조회 
	// 파라미터 : wamIdx
	// 리턴값 :  wam_idx, wam_type, title, project_idx, complete_date, approval
	// 나의 선행을 제외하고 선행작업에 추가할수있는 작업을 조회하는 메서드 
	public ArrayList<WamAllDto> precedingOfClickNoSubtask(int wamIdx) throws Exception {
		String sql = "SELECT wam_idx, wam_type, title, project_idx, complete_date, approval" + " FROM wam"
				+ " WHERE wam_idx !=?" + " AND wam_idx NOT IN (SELECT wam_idx" + "				     FROM wam"
				+ "                     WHERE following_idx=?)";

		ArrayList<WamAllDto> list = new ArrayList<WamAllDto>();
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, wamIdx);
		pstmt.setInt(2, wamIdx);

		ResultSet rs = pstmt.executeQuery();
		while (rs.next()) {
			wamIdx = rs.getInt("wam_idx");
			char wamType = rs.getString("wam_type").charAt(0);
			String title = rs.getString("title");
			int projectIdx = rs.getInt("project_idx");
			String completeDate = rs.getString("complete_date");

			Integer approval;
			rs.getInt("approval");
			if (!rs.wasNull()) {
				approval = rs.getInt("approval");
			} else {
				approval = null;
			}
			WamAllDto dto1 = new WamAllDto(projectIdx, wamIdx, wamType, title, completeDate, approval);
			list.add(dto1);
		}
		rs.close();
		pstmt.close();
		conn.close();
		return list;
	}
	
	// 선행 조회 
	// 파라미터 :  followingIdx
	// 리턴값 : wam_idx, wam_type, title, deadline_date
	// 특정 작업의 선행 작업으로 저장되어있는 작업 조회하는 메서드 
	public ArrayList<WamAllDto> precedingWamGet(int followingIdx) throws Exception {
		String sql = "SELECT wam_idx, wam_type, title, deadline_date" + " FROM wam" + " WHERE following_idx =?";
		ArrayList<WamAllDto> list = new ArrayList<WamAllDto>();
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, followingIdx);
		ResultSet rs = pstmt.executeQuery();
		while (rs.next()) {
			int wamIdx = rs.getInt("wam_idx");
			char wamType = rs.getString("wam_type").charAt(0);
			String title = rs.getString("title");
			String deadlineDate = rs.getString("deadline_date");
			WamAllDto dto = new WamAllDto();
			dto.setWamIdx(wamIdx);
			dto.setWamType(wamType);
			dto.setTitle(title);
			dto.setDeadlineDate("deadlineDate");
			list.add(dto);
		}
		rs.close();
		pstmt.close();
		conn.close();
		return list;
	}
	
	// 작업조회 
	// 파라미터 :  wamIdx
	// 리턴값 :  wam_idx, project_idx, wam_type, title, manager_idx, creator_idx, deadline_date, create_date, start_date, complete_date, wam_parent_idx, content, following_idx, correction_date, approval, correction_date, orders, section_idx, file_idx
	// 특정 작업의 세부내용 조회하는 메서드 
	public WamAllDto wamGetAlldto(int wamIdx) throws Exception {
		String sql = "SELECT wam_idx, project_idx, wam_type, title, manager_idx, creator_idx, deadline_date, create_date, start_date, complete_date, wam_parent_idx, content, following_idx, correction_date, approval, correction_date, orders, section_idx, file_idx"
				+ " FROM wam" + " WHERE wam_idx= ?";

		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, wamIdx);
		ResultSet rs = pstmt.executeQuery();
		WamAllDto dto = null;
		if (rs.next()) {
			wamIdx = rs.getInt("wam_idx");
			int projectIdx = rs.getInt("project_idx");
			char wamType = rs.getString("wam_type").charAt(0);
			String title = rs.getString("title");
			int managerIdx = rs.getInt("manager_Idx"); 
			int creatorIdx = rs.getInt("creator_idx");
			String deadlineDate = rs.getString("deadline_date");
			String createDate = rs.getString("create_date");
			String startDate = rs.getString("start_date");
			String completeDate = rs.getString("complete_date");
			rs.getInt("wam_parent_idx"); 
			Integer wamParentIdx = null;
			if (!rs.wasNull()) {
				wamParentIdx = rs.getInt("wam_parent_idx");
			} else {
				wamParentIdx = null;
			}
			String content = rs.getString("content");
			rs.getInt("following_idx");
			Integer followingIdx;
			if (!rs.wasNull()) {
				followingIdx = rs.getInt("following_idx");
			} else {
				followingIdx = null;
			}
			rs.getInt("approval");
			Integer approval;
			if (!rs.wasNull()) {
				approval = rs.getInt("approval");
			} else {
				approval = null;
			}
			String correctionDate = rs.getString("correction_date");
			rs.getInt("orders");
			Integer orders;
			if (!rs.wasNull()) {
				orders = rs.getInt("orders");
			} else {
				orders = null;

			}
			rs.getInt("section_idx");
			Integer sectionIdx;
			if (!rs.wasNull()) {
				sectionIdx = rs.getInt("section_idx");
			} else {
				sectionIdx = null;
			}
			rs.getInt("file_idx");
			Integer fileIdx;
			if (!rs.wasNull()) {
				fileIdx = rs.getInt("file_idx");
			} else {
				fileIdx = null;
			}

			dto = new WamAllDto(wamIdx, projectIdx, wamType, title, managerIdx, creatorIdx, deadlineDate, createDate,
					startDate, completeDate, wamParentIdx, content, followingIdx, approval, correctionDate, orders,
					sectionIdx, fileIdx);
		}
		rs.close();
		pstmt.close();
		conn.close();
		return dto;
	}
	
	// 작업 완료 
	// 파라미터 :  wamIdx
	// 작업을 완료하는 메서드 
	public void wamofCompleteUpdateDto(int wamIdx) throws Exception {
		String sql = "UPDATE WAM set complete_date = SYSDATE" + " where wam_idx = ?";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, wamIdx);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}
	
	// 작업의 완료를 확인 
	// 파라미터 : wamIdx
	// 리턴값 : 1 또는 0 
	// 특정 작업이 완료 되었다면 1 , 완료되지 않았다면 0으로 작업의 완료를 구분하는 메서드 
	public int wamOfCompleteCheckDto(int wamIdx) throws Exception {
		String sql = "SELECT case when complete_date is not null then 1"
				+ " when complete_date is null then 0 end as check_box" + " FROM wam" + " WHERE wam_idx = ?";
		int result = 0;
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, wamIdx);
		ResultSet rs = pstmt.executeQuery();
		if (rs.next()) {
			int checkBox = rs.getInt("check_box");
			result = checkBox;
		}
		rs.close();
		pstmt.close();
		conn.close();
		return result;
	}
	
	// 작업의 담당자 삭제 
	// 파라미터 :  wamIdx
	// 특정 작업의 담당자를 삭제하는 메서드 
	public void wamOfManagerDeleteDto(int wamIdx) throws Exception {
		String sql = "update wam set manager_idx = null where wam_idx = ?";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, wamIdx);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}
	
	// 작업 생성
	// 파라미터 : projectIdx, wamType, title, managerIdx, creatorIdx, deadlineDate, startDate, wamParentIdx, content, followingIdx,
	//	approval, orders, sectionIdx, fileIdx
	// 작업을 생성하는 메서드 
	public void insertWamAllDto(int projectIdx, char wamType, String title, int managerIdx, int creatorIdx,
			String deadlineDate, String startDate, Integer wamParentIdx, String content, Integer followingIdx,
			Integer approval, Integer orders, Integer sectionIdx, Integer fileIdx) throws Exception {
		String sql = "INSERT INTO wam(wam_idx, project_idx, wam_type, title, manager_idx,"
				+ " creator_idx, deadline_date, create_date, start_date, complete_date, wam_parent_idx, content, following_idx, approval, correction_date, "
				+ " orders, section_idx, file_idx)" + " VALUES(seq_wam_idx.nextval, ?, ?, ?, ?, "
				+ " ?, TO_DATE(?, 'YYYY/MM/DD HH24:MI'), sysdate, TO_DATE(?, 'YYYY/MM/DD HH24:MI'), NULL, "
				+ " ?,  ?,  ?, ?, sysdate" + " ,? ,?, ?)";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, projectIdx);
		pstmt.setString(2, wamType + "");
		pstmt.setString(3, title);
		pstmt.setInt(4, managerIdx);
		pstmt.setInt(5, creatorIdx);
		pstmt.setString(6, deadlineDate);
		pstmt.setString(7, startDate);
		if (wamParentIdx != null)
			pstmt.setInt(8, wamParentIdx);
		else
			pstmt.setNull(8, Types.INTEGER);
		pstmt.setString(9, content);
		if (followingIdx != null)
			pstmt.setInt(10, followingIdx);
		else
			pstmt.setNull(10, Types.INTEGER);
		if (approval != null)
			pstmt.setInt(11, approval);
		else
			pstmt.setNull(11, Types.INTEGER);
		if (orders != null)
			pstmt.setInt(12, orders);
		else
			pstmt.setNull(12, Types.INTEGER);
		if (sectionIdx != null)
			pstmt.setInt(13, sectionIdx);
		else
			pstmt.setNull(13, Types.INTEGER);
		if (fileIdx != null)
			pstmt.setInt(14, fileIdx);
		else
			pstmt.setNull(14, Types.INTEGER);

		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}
	
	// 선행 조회 
	// 파라미터 : followingIdx
	// 리턴값 : wam_idx, wam_type, title, deadline_date
	// 특정 작업의 선행작업을 조회하는 메서드 
	public ArrayList<WamAllDto> followingWamGet(int followingIdx) throws Exception {
		String sql = "SELECT wam_idx, wam_type, title, deadline_date" + " FROM wam" + " WHERE following_idx =?";
		ArrayList<WamAllDto> list = new ArrayList<WamAllDto>();
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, followingIdx);
		ResultSet rs = pstmt.executeQuery();
		while (rs.next()) {
			int wamIdx = rs.getInt("wam_idx");
			char wamType = rs.getString("wam_type").charAt(0);
			String title = rs.getString("title");
			String deadlineDate = rs.getString("deadline_date");
			WamAllDto dto = new WamAllDto();
			dto.setWamIdx(wamIdx);
			dto.setWamType(wamType);
			dto.setTitle(title);
			dto.setDeadlineDate("deadlineDate");
			list.add(dto);
		}
		rs.close();
		pstmt.close();
		conn.close();
		return list;
	}
	
	// 하위작업 조회 
	// 파라미터 :  wamParentIdx
	// 리턴값 : wam_idx, wam_type, title, deadline_date, manager_idx
	// 특정 작업의 하위작업을 조회하는 메서드 
	public ArrayList<WamAllDto> subTaskGet(int wamParentIdx) throws Exception {
		String sql = "SELECT wam_idx, wam_type, title, deadline_date, manager_idx" + " FROM wam"
				+ " WHERE wam_parent_idx = ?";
		ArrayList<WamAllDto> list = new ArrayList<WamAllDto>();
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, wamParentIdx);
		ResultSet rs = pstmt.executeQuery();
		while (rs.next()) {
			int wamIdx = rs.getInt("wam_idx");
			char wamType = rs.getString("wam_type").charAt(0);
			String title = rs.getString("title");
			String deadlineDate = rs.getString("deadline_date");
			int managerIdx = rs.getInt("manager_idx");
			WamAllDto dto = new WamAllDto();
			dto.setWamIdx(wamIdx);
			dto.setWamType(wamType);
			dto.setTitle(title);
			dto.setDeadlineDate(deadlineDate);
			dto.setManagerIdx(managerIdx);
			list.add(dto);
		}
		rs.close();
		pstmt.close();
		conn.close();
		return list;
	}
	
	// 작업의 세션을 변경
	// 파라미터  sectionIdx, wamIdx
	// 특정작업을 다른 세션으로 변경하는 메서드 
	public void wamOfSectionUpdate(int sectionIdx, int wamIdx) throws Exception {
		String sql = "update wam set section_idx = ? where wam_idx = ?";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, sectionIdx);
		pstmt.setInt(2, wamIdx);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}
	
	// 작업이 속한 세션의 이름 조회 
	// 파라미터 : wamIdx
	// 리턴값 : section.name
	// 특정 작업이 속한 세션의 이름 조회하는 메서드 
	public String wamOfSectionNameGet(int wamIdx) throws Exception {
		String sql = "SELECT s.name" + " FROM wam w inner join section s" + " ON w.section_idx = s.section_idx"
				+ " WHERE wam_idx = ?";
		String name = null;
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, wamIdx);
		ResultSet rs = pstmt.executeQuery();
		if (rs.next()) {
			String result = rs.getString("name");
			name = result;
		}
		rs.close();
		pstmt.close();
		conn.close();
		return name;
	}
	
	// 후속작업 변경
	// 파라미터 : followingIdx, wamIdx
	// 특정 작업의 후속작업을 변경하는 메서드 
	public void wamOfFollowingUpdate(int followingIdx, int wamIdx) throws Exception {
		String sql = "update wam set  following_idx = ? where wam_idx = ?";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, followingIdx);
		pstmt.setInt(2, wamIdx);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}
	
	// 작업의 내용 변경 
	// 파라미터 :  content, wamIdx
	// 특정 작업의 내용을 변경하는 메서드 
	public void wamOfContentUpdate(String content, int wamIdx) throws Exception {
		String sql = "update wam set  content = ? where wam_idx = ?";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, content);
		pstmt.setInt(2, wamIdx);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}
	
	// 세션의 이름 변경 
	// 파라미터 :  name, sectionIdx
	// 특정 세션의 이름 변경하는 메서드 
	public void sectionOfNameUpdate(String name, int sectionIdx) throws Exception {
		String sql = "update section set  name = ? where section_idx = ?";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, name);
		pstmt.setInt(2, sectionIdx);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();

	}
	
	// 세션 추가 
	// 파라미터 :  projectIdx, name, sectionOrder
	// 작업을 구별하는 세션추가 하는 메서드 
	public void sectionInsert(int projectIdx, String name, int sectionOrder) throws Exception {
		String sql = "insert into section(section_idx, project_idx, name, section_order) values(seq_section_idx.nextval, ?, ?, ?)";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, projectIdx);
		pstmt.setString(2, name);
		pstmt.setInt(3, sectionOrder);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}
	
	// 작업의 순서 변경
	// 파라미터 : orders, wamIdx
	// 세션안에서 작업의 순서를 변경하는 메서드 
	public void wamOfUpdateOrder(int orders, int wamIdx) throws Exception {
		String sql = "update wam set orders=? where wam_idx=?";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, orders);
		pstmt.setInt(2, wamIdx);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}
	
	// 세션 순서 변경 
	// 파라미터 :  sectionOrder, sectionIdx
	// 특정 세션마다 순서를 변경하는 메서드 
	public void sectionOfUpdateSectionOrder(int sectionOrder, int sectionIdx) throws Exception {
		String sql = "update section set section_order=? where section_idx=?";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, sectionOrder);
		pstmt.setInt(2, sectionIdx);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}
	
	// 세션 조회 
	// 파라미터 : sectionIdx
	// 리턴값 : section_idx, project_idx , name, section_order
	// 특정 세션의 세부내용 조회하는 메서드 
	public SectionAllDto selectGetAll(int sectionIdx) throws Exception {
		String sql = "SELECT section_idx, project_idx , name, section_order" + " FROM section" + " WHERE section_idx=?";
		SectionAllDto dto = null;
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, sectionIdx);
		ResultSet rs = pstmt.executeQuery();
		while (rs.next()) {
			sectionIdx = rs.getInt("section_idx");
			int projectIdx = rs.getInt("project_idx");
			String name = rs.getString("name");
			int sectionOrder = rs.getInt("section_order");
			dto = new SectionAllDto(sectionIdx, projectIdx, name, sectionOrder);
		}
		rs.close();
		pstmt.close();
		conn.close();
		return dto;
	}
	
	// 세션에 속한 작업 갯수 조회 
	// 파라미터 : sectionIdx
	// 리턴값 : 작업의 갯수
	// 세션에 속한 작업의 갯수를 조회하는 메서드 
	public int sectionOfCountWam(int sectionIdx) throws Exception {
		String sql = "SELECT count(wam_idx)" + " FROM wam" + " WHERE section_idx= ?";
		int result = 0;
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, sectionIdx);
		ResultSet rs = pstmt.executeQuery();
		if (rs.next()) {
			result = rs.getInt("count(wam_idx)");
		}
		rs.close();
		pstmt.close();
		conn.close();
		return result;
	}
	
	// 프로젝트별 세션 조회 
	// 파라미터 :  projectIdx
	// 리턴값 : section_idx, name, section_order
	// 특정  프로젝트별 세션 조회하는 메서드 
	public ArrayList<SectionAllDto> projectOfSectionGet(int projectIdx) throws Exception {
		String sql = "SELECT section_idx, name, section_order" + " FROM section" + " WHERE project_idx = ?";
		ArrayList<SectionAllDto> list = new ArrayList<SectionAllDto>();
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, projectIdx);
		ResultSet rs = pstmt.executeQuery();
		while (rs.next()) {
			int sectionIdx = rs.getInt("section_idx");
			String name = rs.getString("name");
			int sectionOrder = rs.getInt("section_order");
			SectionAllDto dto = new SectionAllDto();
			dto.setSectionIdx(sectionIdx);
			dto.setName(name);
			dto.setSectionIdx(sectionIdx);
			list.add(dto);
		}
		rs.close();
		pstmt.close();
		conn.close();
		return list;
	}
	
	// 세션별 작업 조회 
	// 파라미터 : sectionIdx
	// 리턴값 :  wam_idx, wam_type, title, manager_idx, deadline_date
	// 세션별로 저장되있는 작업의 순서대로 작업 조회하는 메서드 
	public ArrayList<WamAllDto> wamOfDetailGet(int sectionIdx) throws Exception {
		String sql = "SELECT wam_idx, wam_type, title, manager_idx, deadline_date" + " FROM wam w inner join section s"
				+ " ON w.section_idx = s.section_idx" + " WHERE w.section_idx=?" + " ORDER BY w.orders";
		ArrayList<WamAllDto> list = new ArrayList<WamAllDto>();
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, sectionIdx);
		ResultSet rs = pstmt.executeQuery();
		while (rs.next()) {
			char wamType = rs.getString("wam_type").charAt(0);
			String title = rs.getString("title");
			int managerIdx = rs.getInt("manager_idx");
			String deadlineDate = rs.getString("deadline_date");
			WamAllDto dto = new WamAllDto();
			dto.setWamType(wamType);
			dto.setTitle(title);
			dto.setManagerIdx(managerIdx);
			dto.setDeadlineDate(deadlineDate);
			list.add(dto);
		}
		rs.close();
		pstmt.close();
		conn.close();
		return list;
	}
	
	// 작업의 좋아요 수 조회 
	// 파라미터 : wamIdx
	// 리턴값 : 좋아요 수 
	// 작업의 좋아요 수 조회 하는 메서드 
	public int wamOfLikeCount(int wamIdx) throws Exception {
		String sql = "SELECT count(wam_idx)" + " FROM likes" + " WHERE wam_idx = ?";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, wamIdx);
		ResultSet rs = pstmt.executeQuery();
		int result = 0;
		if (rs.next()) {
			result = rs.getInt("count(wam_idx)");
		}
		rs.close();
		pstmt.close();
		conn.close();
		return result;
	}
	
	// 작업 댓글의 좋아요 수 조회 
	// 파라미터 : wamIdx
	// 리턴값 : 작업 댓글의 좋아요 수 
	// 작업 댓글의 좋아요 수 조회 하는 메서드 
	public int wamOfCommentsCount(int wamIdx) throws Exception {
		String sql = "SELECT count(comments_idx)" + " FROM comments" + " WHERE wam_idx=?";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, wamIdx);
		int result = 0;
		ResultSet rs = pstmt.executeQuery();
		if (rs.next()) {
			result = rs.getInt("count(comments_idx)");
		}
		rs.close();
		pstmt.close();
		conn.close();
		return result;
	}
	
	// 하위 작업의 수 조회 
	// 파라미터 : wamParentIdx
	// 리턴값 : 하위 작업의 수 
	// 나의 하위작업의 수를 조회하는 메서드 
	public int wamOfSubTaskCount(int wamParentIdx) throws Exception {
		String sql = "SELECT count(wam_idx)" + " FROM wam" + " WHERE wam_parent_idx = ?";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, wamParentIdx);
		int result = 0;
		ResultSet rs = pstmt.executeQuery();
		if (rs.next()) {
			result = rs.getInt("count(wam_idx)");
		}
		rs.close();
		pstmt.close();
		conn.close();
		return result;
	}
	
	// 후속 조회 
	// 파라미터 : wamIdx
	// 리턴값 :  wam_type, title, project_idx, complete_date, approval
	// 나를 제외하고 나의 선행을 제외한 후속을 조회하는 메서드 
	public ArrayList<WamAllDto> dependencyOfClick(int wamIdx) throws Exception {
		String sql = "SELECT wam_type, title, project_idx, complete_date, approval" + " FROM wam" + " WHERE wam_idx !=?"
				+ " AND wam_idx NOT IN (SELECT wam_idx" + "     FROM wam" + "     WHERE following_idx=?)";
		ArrayList<WamAllDto> list = new ArrayList<WamAllDto>();
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, wamIdx);
		pstmt.setInt(2, wamIdx);
		ResultSet rs = pstmt.executeQuery();
		while (rs.next()) {
			char wamType = rs.getString("wam_type").charAt(0);
			String title = rs.getString("title");
			int projectIdx = rs.getInt("project_idx");
			String completeDate = rs.getString("complete_date");

			Integer approval;
			rs.getInt("approval");
			if (!rs.wasNull()) {
				approval = rs.getInt("approval");
			} else {
				approval = null;
			}
			WamAllDto dto1 = new WamAllDto(wamType, title, projectIdx, completeDate);
			list.add(dto1);
		}
		rs.close();
		pstmt.close();
		conn.close();
		return list;
	}
	
	// 선행관계 조회 
	// 파라미터 :  wamIdx
	// 리턴값 :  wam_idx, wam_type, title, project_idx, complete_date, approval
	// 선행관계 클릭시 조회되는 리스트 조회하는 메서드 
	public ArrayList<WamAllDto> precedingOfClick(int wamIdx) throws Exception {
		String sql = "SELECT wam_idx, wam_type, title, project_idx, complete_date, approval" + " FROM wam"
				+ " WHERE wam_idx !=?" + " AND wam_idx NOT IN (SELECT wam_idx" + "     FROM wam"
				+ "     WHERE following_idx=?)";
		ArrayList<WamAllDto> list = new ArrayList<WamAllDto>();
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, wamIdx);
		pstmt.setInt(2, wamIdx);
		ResultSet rs = pstmt.executeQuery();
		while (rs.next()) {
			wamIdx = rs.getInt("wam_idx");
			char wamType = rs.getString("wam_type").charAt(0);
			String title = rs.getString("title");
			int projectIdx = rs.getInt("project_idx");
			String completeDate = rs.getString("complete_date");

			Integer approval;
			rs.getInt("approval");
			if (!rs.wasNull()) {
				approval = rs.getInt("approval");
			} else {
				approval = null;
			}
			WamAllDto dto1 = new WamAllDto(wamIdx, wamType,  projectIdx, title, completeDate, approval);
			list.add(dto1);
		}
		rs.close();
		pstmt.close();
		conn.close();
		return list;
	}

	// 프로젝트에 속한 작업 조회 
	// 파라미터 :  projectIdx
	// 리턴값 :  wam_idx, wam_type , title , manager_idx, creator_idx , deadline_date, create_date, start_date, complete_date, wam_parent_idx, content, following_idx, approval, correction_date,orders, section_idx, file_idx
	// 특정 프로젝트에 속한 작업내용 조회하는 메서드 
	public ArrayList<WamAllDto> wamBelongingToTheProject(int projectIdx) throws Exception {
		String sql = "SELECT wam_idx, wam_type , title , manager_idx, creator_idx , deadline_date, create_date, start_date, complete_date, wam_parent_idx, content, following_idx, approval, correction_date,orders, section_idx, file_idx"
				+ " FROM wam" + " WHERE project_idx =?";
		ArrayList<WamAllDto> list = new ArrayList<WamAllDto>();
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, projectIdx);
		ResultSet rs = pstmt.executeQuery();
		while (rs.next()) {
			WamAllDto dto = new WamAllDto();
			int wamIdx = rs.getInt("wam_idx");
			char wamType = rs.getString("wam_type").charAt(0);
			String title = rs.getString("title");
			int managerIdx = rs.getInt("manager_idx");
			int creatorIdx = rs.getInt("creator_idx");
			String deadlineDate = rs.getString("deadline_date");
			String createDate = rs.getString("create_date");
			String startDate = rs.getString("start_date");
			String completeDate = rs.getString("complete_date");
			rs.getInt("wam_parent_idx");
			Integer wamParentIdx;
			if (!rs.wasNull()) {
				wamParentIdx = rs.getInt("wam_parent_idx");
			} else {
				wamParentIdx = null;
			}
			String content = rs.getString("content");
			rs.getInt("following_idx");
			Integer followingIdx;
			if (!rs.wasNull()) {
				followingIdx = rs.getInt("following_idx");
			} else {
				followingIdx = null;
			}
			rs.getInt("approval");
			Integer approval;
			if (!rs.wasNull()) {
				approval = rs.getInt("approval");

			} else {
				approval = null;
			}
			String correctionDate = rs.getString("correction_date");
			rs.getInt("orders");
			Integer orders;
			if (!rs.wasNull()) {
				orders = rs.getInt("orders");
			} else
				orders = null;
			rs.getInt("section_Idx");
			Integer sectionIdx;
			if (!rs.wasNull()) {
				sectionIdx = rs.getInt("section_idx");
			} else {
				sectionIdx = null;
			}
			rs.getInt("file_idx");
			Integer fileIdx;
			if (!rs.wasNull()) {
				fileIdx = rs.getInt("file_idx");
			} else {
				fileIdx = null;
			}

			dto.setWamIdx(wamIdx);
			dto.setWamType(wamType);
			dto.setTitle(title);
			dto.setManagerIdx(managerIdx);
			dto.setCreatorIdx(creatorIdx);
			dto.setDeadlineDate(deadlineDate);
			dto.setCreateDate(createDate);
			dto.setStartDate(startDate);
			dto.setCompleteDate(completeDate);
			dto.setWamParentIdx(wamParentIdx);
			dto.setFollowingIdx(followingIdx);
			dto.setApproval(approval);
			dto.setCorrectionDate(correctionDate);
			dto.setSectionIdx(sectionIdx);
			dto.setFileIdx(fileIdx);
			list.add(dto);
		}
		rs.close();
		pstmt.close();
		conn.close();
		return list;
	}
	
	// 완료한 작업 조회 
	// 파라미터 :  projectIdx
	// 리턴값 : wam_idx, wam_type, title, manager_idx, start_date, deadline_date, complete_date, approval, following_idx, creator_idx, create_date, correction_date
	// 완료 세션 (특정 프로젝트에 완료한 작업) 조회하는 메서드 
	public ArrayList<WamAllDto> boardOfCompletedWam(int projectIdx) throws Exception {
		String sql = "SELECT wam_idx, wam_type, title, manager_idx, start_date, deadline_date, complete_date, approval, following_idx, creator_idx, create_date, correction_date"
				+ " FROM wam " + " WHERE complete_date IS NOT NULL" + " AND project_idx=?";
		ArrayList<WamAllDto> wamAllDtoList = new ArrayList<WamAllDto>();
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, projectIdx);
		ResultSet rs = pstmt.executeQuery();
		while (rs.next()) {
			int wamIdx = rs.getInt("wam_idx");
			char wamType = rs.getString("wam_type").charAt(0);
			String title = rs.getString("title");
			int managerIdx = rs.getInt("manager_idx");
			String startDate = rs.getString("start_date");
			String deadlineDate = rs.getString("deadline_date");
			String completeDate = rs.getString("complete_date");
			rs.getInt("approval");
			Integer approval = null;
			if (!rs.wasNull()) {
				approval = rs.getInt("approval");
			} else {
				approval = null;
			}
			rs.getInt("following_idx");
			Integer followingIdx = null;
			if (!rs.wasNull()) {
				followingIdx = rs.getInt("following_idx");
			} else {
				followingIdx = null;
			}
			int creatorIdx = rs.getInt("creator_idx");
			String createDate = rs.getString("create_date");
			String correctionDate = rs.getString("correction_date");
			WamAllDto wamAllDto = new WamAllDto(wamIdx, wamType, title, managerIdx, startDate, deadlineDate,
					completeDate, approval, followingIdx, creatorIdx, createDate, correctionDate);
			wamAllDtoList.add(wamAllDto);
		}
		rs.close();
		pstmt.close();
		conn.close();
		return wamAllDtoList;
	}
	
	// 완료세션의 작업 수 조회 
	// 파라미터 :  projectIdx
	// 완료 세션의 작업의 수 조회하는 메서드 
	public int countWamCompletedSection(int projectIdx) throws Exception {
		String sql = "SELECT count(*)" + " FROM wam " + " WHERE complete_date IS NOT NULL" + " AND project_idx=?";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, projectIdx);
		ResultSet rs = pstmt.executeQuery();
		int count = 0;
		if (rs.next()) {
			count = rs.getInt("count(*)");
		}
		rs.close();
		pstmt.close();
		conn.close();
		return count;
	}
	
	// 수행중 세션의 작업 조회
	// 파라미터 :  projectIdx
	// 리턴값 :  wam_idx, wam_type, title, manager_idx, start_date, deadline_date, complete_date, approval, following_idx, creator_idx, create_date, correction_date
	// 특정 프로젝트의 수행중 세션의 작업 조회하는 메서드 
	public ArrayList<WamAllDto> runningWamlist(int projectIdx) throws Exception {
		String sql = "SELECT wam_idx, wam_type, title, manager_idx, start_date, deadline_date, complete_date, approval, following_idx, creator_idx, create_date, correction_date"
				+ " FROM wam" + " WHERE complete_date IS NULL" + " AND project_idx=?";
		ArrayList<WamAllDto> wamAllDtolist = new ArrayList<WamAllDto>();
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, projectIdx);
		ResultSet rs = pstmt.executeQuery();
		while (rs.next()) {
			int wamIdx = rs.getInt("wam_idx");
			char wamType = rs.getString("wam_type").charAt(0);
			String title = rs.getString("title");
			int managerIdx = rs.getInt("manager_idx");
			String startDate = rs.getString("start_date");
			String deadlineDate = rs.getString("deadline_date");
			String completeDate = rs.getString("complete_date");
			rs.getInt("approval");
			Integer approval = null;
			if (!rs.wasNull()) {
				approval = rs.getInt("approval");
			} else {
				approval = null;
			}
			rs.getInt("following_idx");
			Integer followingIdx = null;
			if (!rs.wasNull()) {
				followingIdx = rs.getInt("following_idx");
			} else {
				followingIdx = null;
			}
			
			int creatorIdx = rs.getInt("creator_idx");
			String createDate = rs.getString("create_date");
			String correctionDate = rs.getString("correction_date");
			WamAllDto wamAllDto = new WamAllDto(wamIdx, wamType, title, managerIdx, startDate, deadlineDate,
					completeDate, approval, followingIdx, creatorIdx, createDate, correctionDate);
			wamAllDtolist.add(wamAllDto);
		}
		rs.close();
		pstmt.close();
		conn.close();
		return wamAllDtolist;
	}
	
	// 수행중 세션에 속한 작업 갯수 조회 
	// 파라미터 : projectIdx
	// 리턴값 : 작업 갯수 조회 
	// 특정 프로젝트의 수행중 세션에 속한 작업 갯수 조회  
	public int countWamRunningSection(int projectIdx) throws Exception {
		String sql = "SELECT count(*)" + " FROM wam " + " WHERE complete_date IS NULL" + " AND project_idx=?";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, projectIdx);
		ResultSet rs = pstmt.executeQuery();
		int count = 0;
		if (rs.next()) {
			count = rs.getInt("count(*)");
		}
		rs.close();
		pstmt.close();
		conn.close();
		return count;
	}
	
	// 모두 세션의 작업 조회 
	// 파라미터 : projectIdx
	// 리턴값 :  wam_idx, wam_type, title, manager_idx, start_date, deadline_date, complete_date, approval, following_idx, creator_idx, create_date, correction_date
	// 특정 프로젝트의 모두 세션에 저장되어있는 작업 조회하는 메서드 
	public ArrayList<WamAllDto> allSectionWamlist(int projectIdx) throws Exception {
		String sql = "SELECT wam_idx, wam_type, title, manager_idx, start_date, deadline_date, complete_date, approval, following_idx, creator_idx, create_date, correction_date"
				+ " FROM wam" + " WHERE project_idx=?";
		ArrayList<WamAllDto> wamAllDtolist = new ArrayList<WamAllDto>();
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, projectIdx);
		ResultSet rs = pstmt.executeQuery();
		while (rs.next()) {
			int wamIdx = rs.getInt("wam_idx");
			char wamType = rs.getString("wam_type").charAt(0);
			String title = rs.getString("title");
			int managerIdx = rs.getInt("manager_idx");
			String startDate = rs.getString("start_date");
			String deadlineDate = rs.getString("deadline_date");
			String completeDate = rs.getString("complete_date");
			rs.getInt("approval");
			Integer approval = null;
			if (!rs.wasNull()) {
				approval = rs.getInt("approval");
			} else {
				approval = null;
			}
			rs.getInt("following_idx");
			Integer followingIdx = null;
			if (!rs.wasNull()) {
				followingIdx = rs.getInt("following_idx");
			} else {
				followingIdx = null;
			}
			
			int creatorIdx = rs.getInt("creator_idx");
			String createDate = rs.getString("create_date");
			String correctionDate = rs.getString("correction_date");
			WamAllDto wamAllDto = new WamAllDto(wamIdx, wamType, title, managerIdx, startDate, deadlineDate,
					completeDate, approval, followingIdx, creatorIdx, createDate, correctionDate);
			wamAllDtolist.add(wamAllDto);
		}
		rs.close();
		pstmt.close();
		conn.close();
		return wamAllDtolist;
	}
	
	// 모두 세션의 작업 수 조회 
	// 파라미터 :  projectIdx
	// 리턴값 : 작업 수 
	// 모두 세션의 작업 수 조회하는 메서드 
	public int countWamAllSection(int projectIdx) throws Exception {
		String sql = "SELECT count(*)" + " FROM wam " + " WHERE project_idx=?";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, projectIdx);
		ResultSet rs = pstmt.executeQuery();
		int count = 0;
		if (rs.next()) {
			count = rs.getInt("count(*)");
		}
		rs.close();
		pstmt.close();
		conn.close();
		return count;
	}

	// 작업 생성
	// 파라미터 : projectIdx, wamType, title, creatorIdx, content
	// 작업 생성하는 메서드 
	public void createWam(int projectIdx, char wamType, String title, int creatorIdx, String content) throws Exception {
		String sql = "INSERT INTO wam(wam_idx, project_idx,  wam_type, title, creator_idx, content)"
				+ " VALUES (seq_wam_idx.nextval, ?, ?, ?, ?, ?)";

		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, projectIdx);
		pstmt.setString(2, wamType + "");
		pstmt.setString(3, title);
		pstmt.setInt(4, creatorIdx);
		pstmt.setString(5, content);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}

	// wam 의 로우 리스트 출력
	// 파라미터 : project_idx
	// 리턴값 : wam_idx
	// 해당 프로젝트의 wam 리스트를 조회하는 메서드
	public ArrayList<Integer> getListWamIdxByProjectIdx(int projectIdx) throws Exception {
		ArrayList<Integer> listRet = new ArrayList<Integer>();
		String sql = "SELECT wam_idx FROM wam WHERE project_idx=? ORDER BY wam_idx ASC";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, projectIdx);
		ResultSet rs = pstmt.executeQuery();
		while (rs.next()) {
			listRet.add(rs.getInt("wam_idx"));
		}
		rs.close();
		pstmt.close();
		conn.close();
		return listRet;
	}

	// wam 리스트의 컬럼 조회
	// 파라미터 : wam_idx
	// 리턴값 : 작업이름, 담당자, 마감일
	// 해당 wam 의 컬럼들을 조회하는 메서드
	public ArrayList<String> getWamDtoTitleManagerDeadlineDateByWamIdx(int wamIdx) throws Exception {
		String sql = "SELECT  w.wam_type||' '||w.title \"title\", m.profile_img||' '||m.nickname \"manager\", w.deadline_date \"deadline_date\""
				+ " FROM wam w" + " INNER JOIN member m ON w.manager_idx = m.member_idx"
				+ " INNER JOIN member m ON w.creator_idx = m.member_idx" + " WHERE wam_idx=?";

		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, wamIdx);
		ResultSet rs = pstmt.executeQuery();

		ArrayList<String> list = new ArrayList<String>();
		if (rs.next()) {
			list.add(rs.getString("title"));
			list.add(rs.getString("manager"));
			list.add(rs.getString("deadline_date"));
		}

		rs.close();
		pstmt.close();
		conn.close();
		return list;
	}

	// wam 리스트의 컬럼 조회
	// 파라미터 : wam_idx
	// 리턴값 : 협업참여자
	// 해당 wam 의 컬럼들을 조회하는 메서드
	public ArrayList<String> getWamDtoCooperatorByWamIdx(int wamIdx) throws Exception {
		String sql = "SELECT DISTINCT m.profile_img \"협업참여자\"" + " FROM wam_cooperation wc"
				+ " INNER JOIN member m ON wc.member_idx = m.member_idx" + " WHERE wam_idx=?";

		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, wamIdx);
		ResultSet rs = pstmt.executeQuery();

		ArrayList<String> list = new ArrayList<String>();
		while (rs.next()) {
			list.add(rs.getString("협업참여자"));
		}

		rs.close();
		pstmt.close();
		conn.close();
		return list;
	}

	// wam 리스트의 컬럼 조회
	// 파라미터 : wam_idx
	// 리턴값 : 생성한사용자
	// 해당 wam 의 컬럼들을 조회하는 메서드
	public ArrayList<String> getWamDtoCreatorByWamIdx(int wamIdx) throws Exception {
		String sql = "SELECT  m.nickname \"생성자\"" + " FROM wam w"
				+ " INNER JOIN member m ON w.creator_idx = m.member_idx" + " WHERE wam_idx=?";

		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, wamIdx);
		ResultSet rs = pstmt.executeQuery();

		ArrayList<String> list = new ArrayList<String>();
		while (rs.next()) {
			list.add(rs.getString("생성자"));
		}

		rs.close();
		pstmt.close();
		conn.close();
		return list;
	}

	// wam 리스트의 컬럼 조회
	// 파라미터 : wam_idx
	// 리턴값 : 생성일, 수정일, 완료일
	// 해당 wam 의 컬럼들을 조회하는 메서드
	public ArrayList<String> getWamDtoCreateCorrectionCompleteDateByWamIdx(int wamIdx) throws Exception {
		String sql = "SELECT w.create_date \"생성일\", w.correction_date \"수정일\", w.complete_date \"완료일\"" + " FROM wam w"
				+ " INNER JOIN member m ON w.manager_idx = m.member_idx"
				+ " INNER JOIN member m ON w.creator_idx = m.member_idx" + " WHERE wam_idx=?";

		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, wamIdx);
		ResultSet rs = pstmt.executeQuery();

		ArrayList<String> list = new ArrayList<String>();
		while (rs.next()) {
			list.add(rs.getString("생성일"));
			list.add(rs.getString("수정일"));
			list.add(rs.getString("완료일"));
		}

		rs.close();
		pstmt.close();
		conn.close();
		return list;
	}

	// 작업 이름 수정
	// 파라미터 : wam_idx, title
	// 해당 wam의 제목을 수정하는 메서드
	public void updateWamTitle(int wamIdx, String title) throws Exception {
		String sql = "UPDATE wam SET title=? WHERE wam_idx=?";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, title);
		pstmt.setInt(2, wamIdx);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}

	// 작업 담당자 수정
	// 파라미터 : wam_idx, manager_idx
	// 해당 wam의 담당자를 수정하는 메서드
	public void updateWamManagerIdx(int wamIdx, Integer ManagerIdx) throws Exception {
		String sql = "UPDATE wam SET manager_idx=? WHERE wam_idx=?";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		if (ManagerIdx != null)
			pstmt.setInt(1, ManagerIdx);// 1
		else
			pstmt.setNull(1, Types.INTEGER);// null
//			pstmt.setInt(1, ManagerIdx);
		pstmt.setInt(2, wamIdx);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}

	// 작업 마감일 수정
	// 파라미터 : wam_idx, deadline_date
	// 해당 wam의 마감일을 수정하는 메서드
	public void updateWamDeadlineDate(int wamIdx, String DeadlineDate) throws Exception {
		String sql = "UPDATE wam SET deadline_date=TO_DATE(?, 'YYYY/MM/DD HH24:MI') WHERE wam_idx=?";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, DeadlineDate);
		pstmt.setInt(2, wamIdx);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}

	// 작업 수정일 수정
	// 파라미터 : wam_idx, correction_date
	// 해당 wam의 수정일을 변경하는 메서드
	public void updateWamCorrectionDate(int wamIdx, String CorrectionDate) throws Exception {
		String sql = "UPDATE wam SET correction_date=TO_DATE(?, 'YYYY/MM/DD HH24:MI') WHERE wam_idx=?";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, CorrectionDate);
		pstmt.setInt(2, wamIdx);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}

	// 작업 완료일 수정
	// 파라미터 : wam_idx, complete_date
	// 해당 wam의 완료일을 변경하는 메서드
	public void updateWamCompleteDate(int wamIdx, String CompleteDate) throws Exception {
		String sql = "UPDATE wam SET complete_date=TO_DATE(?, 'YYYY/MM/DD HH24:MI') WHERE wam_idx=?";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, CompleteDate);
		pstmt.setInt(2, wamIdx);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}

	// wam 삭제
	// 파라미터 : wam_idx
	// 해당 wam을 삭제하는 메서드
	public void deleteWam(int wamIdx) throws Exception {
		String sql = "DELETE FROM wam WHERE wam_idx=?";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, wamIdx);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}

	//	wam 협업참여자 추가
	// 파라미터 : wam_idx, member_idx
	// 해당 wam에 협업참여자를 추가하는 메서드
	public void WamcooperationInsert(int wamIdx, int memberIdx) throws Exception {
		String sql = "INSERT INTO wam_cooperation(wam_idx, member_idx) VALUES (?,?)";

		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, wamIdx);
		pstmt.setInt(2, memberIdx);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}

	// wam 협업참여자 삭제
	// 파라미터 : wam_idx, member_idx
	// 해당 wam에 협업참여자를 삭제하는 메서드
	public void WamCooperationDelete(int wamIdx, int memberIdx) throws Exception {
		String sql = "DELETE FROM wam_cooperation WHERE wam_idx=? AND member_idx=?";

		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, wamIdx);
		pstmt.setInt(2, memberIdx);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}

	//	내가 담당자인  작업 보여주기
	//	파라미터 : member_idx(숫자)  
	//	리턴값 : title, name, deadline_date
	// 내가 담담자인 모든 작업을 보여주는 메서드
	public ArrayList<WamDto> getWamsDto(int managerIdx) throws Exception {
		String sql = "SELECT w.title, p.name, TO_CHAR(w.deadline_date,'YY')||'년'||TO_CHAR(w.deadline_date,'MM')||'월'||TO_CHAR(w.deadline_date,'DD')||'일' \"deadline_date\""
				+ " FROM wam w" + " INNER JOIN project p ON w.project_idx = p.project_idx" + " WHERE manager_idx = ?";
		ArrayList<WamDto> list = new ArrayList<>();
		WamDto wDTO = null;

		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, managerIdx);
		ResultSet rs = pstmt.executeQuery();
		while (rs.next()) {
			String title = rs.getString("title");
			String name = rs.getString("name");
			String deadlineDate = rs.getString("deadline_date");

			ProjectDto pDTO = new ProjectDto();
			pDTO.setName(name);
			wDTO = new WamDto(title, deadlineDate, pDTO);
			list.add(wDTO);
		}
		rs.close();
		pstmt.close();
		conn.close();
		return list;
	}

	//	내가 담당자인 승인 보여주기
	//	파라미터 : managerIdx  
	//	리턴값 : title, name, deadline_date, wam_idx
	// 내가 담당자인 모든 승인을 보여주는 메서드
	public ArrayList<WamDto> getApprovDto(int managerIdx) throws Exception {
		String sql = "SELECT w.title, p.name, w.deadline_date, w.wam_idx" + " FROM wam w"
				+ " INNER JOIN project p ON w.project_idx = p.project_idx"
				+ " WHERE manager_idx = ? AND w.wam_type='a'";
		ArrayList<WamDto> list = new ArrayList<>();
		WamDto wdto = null;

		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, managerIdx);
		ResultSet rs = pstmt.executeQuery();
		while (rs.next()) {
			String title = rs.getString("title");
			String name = rs.getString("name");
			String deadlineDate = rs.getString("deadline_date");
			int wamIdx = rs.getInt("wam_idx");

			ProjectDto pdto = new ProjectDto();
			pdto.setName(name);
			wdto = new WamDto(title, deadlineDate, wamIdx, pdto);
			list.add(wdto);
		}
		rs.close();
		pstmt.close();
		conn.close();
		return list;
	}

	//		마감일 지나기 전의 manegerIdx 가 담당자인 wam list
	//		input: member_idx(숫자)  
	//		output:리스트 of { wam_type, title, manager_idx, creator_idx, deadline_date, create_date, start_date, complete_date, wam_under_idx, following_idx, approval, correction_date}
	public ArrayList<WamDto> getWamsDtoBeforeDeadline(int managerIdx) throws Exception {
		String sql = "SELECT w.wam_type , w.title, p.name, TO_CHAR(w.deadline_date,'YY')||'년'||TO_CHAR(w.deadline_date,'MM')||'월'||TO_CHAR(w.deadline_date,'DD')||'일' \"deadline_date\""
				+ " FROM wam w" + " INNER JOIN project p ON w.project_idx = p.project_idx"
				+ " WHERE manager_idx = ? AND w.deadline_date > sysdate";
		ArrayList<WamDto> list = new ArrayList<>();
		WamDto wDto = null;

		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, managerIdx);
		ResultSet rs = pstmt.executeQuery();
		while (rs.next()) {
			String wamType = rs.getString("wam_type");
			String title = rs.getString("title");
			String name = rs.getString("name");
			String deadlineDate = rs.getString("deadline_date");

			ProjectDto pDto = new ProjectDto();
			pDto.setName(name);
			wDto = new WamDto(wamType, title, deadlineDate, pDto);
			list.add(wDto);
		}
		rs.close();
		pstmt.close();
		conn.close();
		return list;
	}

	//	내가 담당자인  마일스톤 보여주기
	//	파라미터 : managerIdx  
	//	리턴값 : title, name, deadline_date, wam_idx
	// 내가 담당자인 모든 마일스톤을 보여주는 메서드
	public ArrayList<WamDto> getMilestoneDto(int managerIdx) throws Exception {
		String sql = "SELECT w.title, p.name, w.deadline_date, wam_idx" + " FROM wam w"
				+ " INNER JOIN project p ON w.project_idx = p.project_idx"
				+ " WHERE manager_idx = ? AND w.wam_type='m'";
		ArrayList<WamDto> list = new ArrayList<>();
		WamDto wdto = null;

		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, managerIdx);
		ResultSet rs = pstmt.executeQuery();
		while (rs.next()) {
			String title = rs.getString("title");
			String name = rs.getString("name");
			String deadlineDate = rs.getString("deadline_date");
			int wamIdx = rs.getInt("wam_idx");

			ProjectDto pdto = new ProjectDto();
			pdto.setName(name);
			wdto = new WamDto(title, deadlineDate, wamIdx, pdto);
			list.add(wdto);
		}
		rs.close();
		pstmt.close();
		conn.close();
		return list;
	}

	//	마감일 지난 작업
	//	파라미터 : managerIdx
	//	리턴값 : wam_type, title, name, deadline_date
	//	마감일이 지난 모든 작업을 보여주는 메서드
	public ArrayList<WamDto> PastDeadline(int managerIdx) throws Exception {
		String sql = "SELECT w.wam_type, w.title, p.name, TO_CHAR(w.deadline_date,'YY')||'년'||TO_CHAR(w.deadline_date,'MM')||'월'||TO_CHAR(w.deadline_date,'DD')||'일' \"deadline_date\""
				+ " FROM wam w" + " INNER JOIN project p ON w.project_idx = p.project_idx" + " WHERE manager_idx = ?"
				+ " AND w.deadline_date < SYSDATE" + " AND w.complete_date IS NULL";

		ArrayList<WamDto> list = new ArrayList<>();
		WamDto wDto = null;

		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, managerIdx);
		ResultSet rs = pstmt.executeQuery();
		while (rs.next()) {
			String wamType = rs.getString("wam_type");
			String title = rs.getString("title");
			String name = rs.getString("name");
			String deadlineDate = rs.getString("deadline_date");

			ProjectDto pDto = new ProjectDto();
			pDto.setName(name);
			wDto = new WamDto(wamType, title, deadlineDate, pDto);
			list.add(wDto);
		}
		rs.close();
		pstmt.close();
		conn.close();
		return list;
	}
	
	//	완료 된 작업 보여주기
	//	파라미터 : managerIdx
	//	리턴값 : title, name, deadline_date
	//	완료 된 모든 작업을 보여주는 메서드
	public ArrayList<WamDto> CheckWamDto(int managerIdx) throws Exception {
		String sql = "SELECT w.title, p.name, TO_CHAR(w.deadline_date,'YY')||'년'||TO_CHAR(w.deadline_date,'MM')||'월'||TO_CHAR(w.deadline_date,'DD')||'일' \"deadline_date\""
				+ " FROM wam w" + " INNER JOIN project p ON w.project_idx = p.project_idx" + " WHERE manager_idx = ?"
				+ " AND w.complete_date IS NOT NULL";

		ArrayList<WamDto> list = new ArrayList<>();
		WamDto wDto = null;

		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, managerIdx);
		ResultSet rs = pstmt.executeQuery();
		while (rs.next()) {
			String title = rs.getString("title");
			String name = rs.getString("name");
			String deadlineDate = rs.getString("deadline_date");

			ProjectDto pDto = new ProjectDto();
			pDto.setName(name);
			wDto = new WamDto(title, deadlineDate, pDto);
			list.add(wDto);
		}
		rs.close();
		pstmt.close();
		conn.close();
		return list;
	}
	
	//	완료된 작업 카운트
	//	파라미터 : managerIdx
	//	리턴값 : COUNT
	// 완료된 작업을 카운트하여 맞는 개수를 출력하는 메서드
	public int getWamCount(int managerIdx) throws Exception {
		String sql = "SELECT COUNT(*)" + " FROM(SELECT w.title, p.name, w.deadline_date " + " FROM wam w "
				+ " INNER JOIN project p ON w.project_idx = p.project_idx" + " WHERE manager_idx = ?"
				+ " AND w.complete_date IS NOT NULL)";
		Connection conn = getConnection();

		int ret = 0;
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, managerIdx);
		ResultSet rs = pstmt.executeQuery();
		if (rs.next()) {
			ret = rs.getInt(1);
		}
		rs.close();
		pstmt.close();
		conn.close();
		return ret;
	}
	
	//	작업 협업 참여자 카운트 
	//	파라미터 : memberIdx, trueMemberIdx
	//	리턴값 : COUNT(member_idx)
	// 로그인한 멤버를 제외하고 작업 협업 참여자를 카운트하는 메서드
	public int getWamCooperation(int memberIdx, int trueMemberIdx) throws Exception {
		String sql = "SELECT COUNT(DISTINCT wc.member_idx)" + " FROM wam_cooperation wc"
				+ " INNER JOIN wam w ON wc.wam_idx = w.wam_idx" + " WHERE wc.member_idx != ?" + " AND wc.wam_idx IN ("
				+ " SELECT wam_idx" + " FROM wam_cooperation" + " WHERE member_idx = ?" + " )";
		Connection conn = getConnection();

		int ret = 0;
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, memberIdx);
		pstmt.setInt(2, trueMemberIdx);
		ResultSet rs = pstmt.executeQuery();
		if (rs.next()) {
			ret = rs.getInt(1);
		}
		rs.close();
		pstmt.close();
		conn.close();
		return ret;
	}

	//	내가 배정한 작업 보여주기
	//	파라미터 : creatorIdx, managerIdx
	//	리턴값 : wam_idx, wam_type, title, name, deadline_date, profile_img
	//	내가 상대방에게 배정을 해준 모든 작업을 보여주는 메서드
	public ArrayList<WamDto> AssignWamsDto(int creatorIdx, int managerIdx) throws Exception {
		String sql = "SELECT w.wam_idx, w.wam_type, w.title, p.name, TO_CHAR(w.deadline_date,'YY')||'년'||TO_CHAR(w.deadline_date,'MM')||'월'||TO_CHAR(w.deadline_date,'DD')||'일' deadline_date, m.profile_img"
				+ " FROM project p INNER JOIN wam w" + " ON w.project_idx = p.project_idx" + " INNER JOIN member m"
				+ " ON w.manager_idx = m.member_idx" + " WHERE w.creator_idx = ? AND manager_idx = ?" + " ORDER BY 1";
		ArrayList<WamDto> list = new ArrayList<>();
		WamDto dto = null;

		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, creatorIdx);
		pstmt.setInt(2, managerIdx);
		ResultSet rs = pstmt.executeQuery();
		while (rs.next()) {
			int wamIdx = rs.getInt("wam_idx");
			String wamType = rs.getString("wam_type");
			String title = rs.getString("title");
			String name = rs.getString("name");
			String deadlineDate = rs.getString("deadline_date");
			String profileImg = rs.getString("profile_img");

			ProjectDto pDto = new ProjectDto();
			pDto.setName(name);
			MemberDto mDto = new MemberDto();
			mDto.setProfileImg(profileImg);

			dto = new WamDto();
			dto.setWamIdx(wamIdx);
			dto.setWamType(wamType);
			dto.setTitle(title);
			dto.setDeadlineDate(deadlineDate);
			dto.setMemberDto(mDto);
			dto.setProjectDto(pDto);

			list.add(dto);
		}
		rs.close();
		pstmt.close();
		conn.close();
		return list;
	}

	//	로그인 한 멤버와 들어간 프로필 멤버 둘 다 협업에 참여하고 있는 작업 보여주기 
	//	파라미터 : memberIdx, memberIdx1
	//	리턴값 : wam_idx, wam_type, title, name, deadline_date, profile_img
	//	로그인 한 멤버와 내가 원하는 멤버 프로필을 들어갔을 때 둘 다 협업에 참여하고 있는 모든 작업을 보여주는 메서드
	public ArrayList<WamDto> getTogetherWamsDto(int memberIdx, int memberIdx1) throws Exception {
		String sql = "SELECT DISTINCT w.wam_idx, w.wam_type, w.title, p.name, TO_CHAR(w.deadline_date,'YY')||'년'||TO_CHAR(w.deadline_date,'MM')||'월'||TO_CHAR(w.deadline_date,'DD')||'일' \"deadline_date\", mb.profile_img"
				+ " FROM wam w" + " INNER JOIN project p ON w.project_idx = p.project_idx"
				+ " INNER JOIN member mb ON w.manager_idx = mb.member_idx"
				+ " INNER JOIN wam_cooperation wc ON wc.wam_idx = w.wam_idx" + " WHERE wc.member_idx IN (?, ?)"
				+ " GROUP BY w.wam_idx, w.wam_type, w.wam_idx, w.title, p.name, w.deadline_date, mb.profile_img"
				+ " HAVING COUNT(DISTINCT wc.member_idx) >= 2" + " ORDER BY 1";
		ArrayList<WamDto> list = new ArrayList<>();
		WamDto dto = null;

		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, memberIdx);
		pstmt.setInt(2, memberIdx1);
		ResultSet rs = pstmt.executeQuery();
		while (rs.next()) {
			int wamIdx = rs.getInt("wam_idx");
			String wamType = rs.getString("wam_type");
			String title = rs.getString("title");
			String name = rs.getString("name");
			String deadlineDate = rs.getString("deadline_date");
			String profileImg = rs.getString("profile_img");

			ProjectDto pDto = new ProjectDto();
			pDto.setName(name);

			MemberDto mDto = new MemberDto();
			mDto.setProfileImg(profileImg);
			dto = new WamDto();
			dto.setWamIdx(wamIdx);
			dto.setWamType(wamType);
			dto.setTitle(title);
			dto.setDeadlineDate(deadlineDate);
			dto.setProjectDto(pDto);
			dto.setMemberDto(mDto);
			list.add(dto);
		}
		rs.close();
		pstmt.close();
		conn.close();
		return list;
	}
		
	//	클릭된멤버의 로그인멤버가 배정한작업과 로그인멤버와 함께 협업중인 작업 조회
	//	파라미터 : 로그인 member_idx, 클릭된 member_idx
	//	리턴값 : wam_idx, wam_type, title, name, deadline_date, profile_img
	//	로그인 한 멤버와 내가 원하는 멤버 프로필을 들어갔을 때 둘 다 협업에 참여하고 있는 모든 작업 + 로그인멤버가 원하는 멤버에게 배정한 작업을 보여주는 메서드
	public ArrayList<WamDto> getAllWamListByLoginMemberAndOtherMember(int loginMemberIdx, int memberIdx) throws Exception {
		String sql = "SELECT DISTINCT w.wam_idx, w.wam_type, w.title, p.name, TO_CHAR(w.deadline_date,'YY')||'년'||TO_CHAR(w.deadline_date,'MM')||'월'||TO_CHAR(w.deadline_date,'DD')||'일' deadline_date, m.profile_img"
				+ " FROM project p INNER JOIN wam w" + " ON w.project_idx = p.project_idx" + " INNER JOIN member m"
				+ " ON w.manager_idx = m.member_idx" + " WHERE w.creator_idx = ? AND manager_idx = ?" + " UNION"
				+ " SELECT DISTINCT w.wam_idx, w.wam_type, w.title, p.name, TO_CHAR(w.deadline_date,'YY')||'년'||TO_CHAR(w.deadline_date,'MM')||'월'||TO_CHAR(w.deadline_date,'DD')||'일' \"deadline_date\", mb.profile_img"
				+ " FROM wam w" + " INNER JOIN project p ON w.project_idx = p.project_idx"
				+ " INNER JOIN member mb ON w.manager_idx = mb.member_idx"
				+ " INNER JOIN wam_cooperation wc ON wc.wam_idx = w.wam_idx" + " WHERE wc.member_idx IN (?, ?)"
				+ " GROUP BY w.wam_idx, w.wam_type, w.wam_idx, w.title, p.name, w.deadline_date, mb.profile_img"
				+ " HAVING COUNT(DISTINCT wc.member_idx) >= 2" + " ORDER BY 1";

		ArrayList<WamDto> list = new ArrayList<>();
		WamDto dto = null;

		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, loginMemberIdx);
		pstmt.setInt(2, memberIdx);
		pstmt.setInt(3, loginMemberIdx);
		pstmt.setInt(4, memberIdx);
		ResultSet rs = pstmt.executeQuery();
		while (rs.next()) {
			int wamIdx = rs.getInt("wam_idx");
			String wamType = rs.getString("wam_type");
			String title = rs.getString("title");
			String name = rs.getString("name");
			String deadlineDate = rs.getString("deadline_date");
			String profileImg = rs.getString("profile_img");

			ProjectDto pDto = new ProjectDto();
			pDto.setName(name);
			MemberDto mDto = new MemberDto();
			mDto.setProfileImg(profileImg);

			dto = new WamDto();
			dto.setWamIdx(wamIdx);
			dto.setWamType(wamType);
			dto.setTitle(title);
			dto.setDeadlineDate(deadlineDate);
			dto.setMemberDto(mDto);
			dto.setProjectDto(pDto);

			list.add(dto);
		}
		rs.close();
		pstmt.close();
		conn.close();
		return list;
	}

	//	작업 완료
	//	파라미터 : wamIdx
	//	특정 작업을 완료하는 메서드
	public void setWamCompleteDto(int wamIdx) throws Exception {
		String sql = "UPDATE wam SET complete_date = sysdate WHERE wam_idx = ?";

		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, wamIdx);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}

	public static void main(String[] args) throws Exception {

	}
}
