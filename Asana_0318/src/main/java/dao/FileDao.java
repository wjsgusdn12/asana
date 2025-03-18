package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import dto.FileDetailsViewDto;
import dto.FileListDto;

public class FileDao {
	public Connection getConnection() throws Exception {
		String driver = "oracle.jdbc.driver.OracleDriver";
		String url = "jdbc:oracle:thin:@gusdntkd.cafe24.com:1521:xe";
		String id = "asana_hw";
		String pw = "asana12345";

		Class.forName(driver);
		Connection conn = DriverManager.getConnection(url, id, pw);
		return conn;
	}

	// 파일 목록 조회
	// 파라미터 : project_idx
	// 리턴값 : name, title, nickname, write_time, project_idx
	// 해당 프로젝트의 모든 파일을 조회하는 메서드
	public ArrayList<FileListDto> getFileListDto(int inputProjectIdx) throws Exception {
		String sql = "SELECT name, title, nickname, write_date, project_idx"
				+ " FROM ("
				+ " SELECT f.name, msg.title, mb.nickname, f.write_date, msg.project_idx"
				+ " FROM files f"
				+ " INNER JOIN message msg ON msg.message_idx = f.message_idx"
				+ " INNER JOIN member mb ON mb.member_idx = f.member_idx"
				+ " WHERE f.message_idx IS NOT NULL"
				+ " UNION ALL"
				+ " SELECT f.name, w.title, mb.nickname, f.write_date, w.project_idx"
				+ " FROM files f"
				+ " INNER JOIN wam w ON w.wam_idx = f.wam_idx"
				+ " INNER JOIN member mb ON mb.member_idx = f.member_idx"
				+ " WHERE f.wam_idx IS NOT NULL"
				+ " UNION ALL"
				+ " SELECT f.name, mmo.title, mb.nickname, f.write_date, mmo.project_idx"
				+ " FROM files f"
				+ " INNER JOIN memo mmo ON mmo.memo_idx = f.memo_idx"
				+ " INNER JOIN member mb ON mb.member_idx = f.member_idx"
				+ " WHERE f.memo_idx IS NOT NULL"
				+ " UNION ALL"
				+ " SELECT f.name, m.title, mb.nickname, f.write_date, m.project_idx"
				+ " FROM comments c"
				+ " INNER JOIN message m ON m.message_idx = c.message_idx"
				+ " INNER JOIN member mb ON mb.member_idx = c.member_idx"
				+ " INNER JOIN files f ON f.comments_idx = c.comments_idx"
				+ " WHERE c.message_idx IS NOT NULL"
				+ " UNION ALL"
				+ " SELECT f.name, '상태 업데이트 - '||ps.status_date \"PS.NAME\", mb.nickname, f.write_date, ps.project_idx"
				+ " FROM comments c"
				+ " INNER JOIN member mb ON mb.member_idx = c.member_idx"
				+ " INNER JOIN project_status ps ON ps.project_status_idx = c.project_status_idx"
				+ " INNER JOIN files f ON f.comments_idx = c.comments_idx"
				+ " WHERE c.project_status_idx IS NOT NULL"
				+ " UNION ALL"
				+ " SELECT f.name, w.title, mb.nickname, f.write_date, w.project_idx"
				+ " FROM comments c"
				+ " INNER JOIN member mb ON mb.member_idx = c.member_idx"
				+ " INNER JOIN files f ON f.comments_idx = c.comments_idx"
				+ " INNER JOIN wam w ON w.wam_idx = c.wam_idx"
				+ " WHERE c.wam_idx IS NOT NULL"
				+ " )"
				+ " WHERE project_idx = ?";
		ArrayList<FileListDto> list = new ArrayList<FileListDto>();
		
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, inputProjectIdx);
		ResultSet rs = pstmt.executeQuery();
		
		while (rs.next()) {
			String name = rs.getString("name");
			String title = rs.getString("title");
			String nickname = rs.getString("nickname");
			String writeTime = rs.getString("write_date");
			int projectIdx = rs.getInt("project_idx");
			
			FileListDto dto = new FileListDto(name, title, nickname, writeTime, projectIdx);
			list.add(dto);
		}
		
		rs.close();
		pstmt.close();
		conn.close();
		return list;
	}

	// 파일 상세정보 조회 (메시지에 등록된 파일일 경우)
	// 파라미터 : message_idx
	// 리턴값 : name, write_date
	// 해당 파일의 상세정보를 조회하는 메서드
	public ArrayList<FileDetailsViewDto> getFileDetailsViewDtoFromMessageIdx(int messageIdx) throws Exception {
		String sql = "SELECT name, write_date" + " FROM files" + " WHERE message_idx=?";

		ArrayList<FileDetailsViewDto> list = new ArrayList<FileDetailsViewDto>();

		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, messageIdx);
		ResultSet rs = pstmt.executeQuery();

		while (rs.next()) {
			String name = rs.getString("name");
			String writeDate = rs.getString("write_date");

			FileDetailsViewDto dto = new FileDetailsViewDto(name, writeDate);
			list.add(dto);
		}

		rs.close();
		pstmt.close();
		conn.close();
		return list;
	}

	// 파일 상세정보 조회 (메모에 등록된 파일일 경우)
	// 파라미터 : memo_idx
	// 리턴값 : name, write_date
	// 해당 파일의 상세정보를 조회하는 메서드
	public ArrayList<FileDetailsViewDto> getFileDetailsViewDtoFromMemoIdx(int memoIdx) throws Exception {
		String sql = "SELECT name, write_date" + " FROM files" + " WHERE memo_idx=?";

		ArrayList<FileDetailsViewDto> list = new ArrayList<FileDetailsViewDto>();

		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, memoIdx);
		ResultSet rs = pstmt.executeQuery();

		while (rs.next()) {
			String name = rs.getString("name");
			String writeDate = rs.getString("write_date");

			FileDetailsViewDto dto = new FileDetailsViewDto(name, writeDate);
			list.add(dto);
		}

		rs.close();
		pstmt.close();
		conn.close();
		return list;
	}

	// 파일 상세정보 조회 (wam에 등록된 파일일 경우)
	// 파라미터 : wam_idx
	// 리턴값 : name, write_date
	// 해당 파일의 상세정보를 조회하는 메서드
	public ArrayList<FileDetailsViewDto> getFileDetailsViewDtoFromWamIdx(int wamIdx) throws Exception {
		String sql = "SELECT name, write_date" + " FROM files" + " WHERE wam_idx=?";

		ArrayList<FileDetailsViewDto> list = new ArrayList<FileDetailsViewDto>();

		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, wamIdx);
		ResultSet rs = pstmt.executeQuery();

		while (rs.next()) {
			String name = rs.getString("name");
			String writeDate = rs.getString("write_date");

			FileDetailsViewDto dto = new FileDetailsViewDto(name, writeDate);
			list.add(dto);
		}

		rs.close();
		pstmt.close();
		conn.close();
		return list;
	}

	// 파일 상세정보 조회 (메시지 댓글에 등록된 파일일 경우)
	// 파라미터 : message_idx
	// 리턴값 : name, write_date
	// 해당 파일의 상세정보를 조회하는 메서드
	public ArrayList<FileDetailsViewDto> getCommentsFileDetailsViewDtoFromMessageIdx(int messageIdx) throws Exception {
		String sql = "SELECT f.name, f.write_date" + " FROM files f"
				+ " INNER JOIN comments c ON f.comments_idx = c.comments_idx"
				+ " INNER JOIN message m ON m.message_idx = c.message_idx" + " WHERE m.message_idx=?";

		ArrayList<FileDetailsViewDto> list = new ArrayList<FileDetailsViewDto>();

		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, messageIdx);
		ResultSet rs = pstmt.executeQuery();

		while (rs.next()) {
			String name = rs.getString("name");
			String writeDate = rs.getString("write_date");

			FileDetailsViewDto dto = new FileDetailsViewDto(name, writeDate);
			list.add(dto);
		}

		rs.close();
		pstmt.close();
		conn.close();
		return list;
	}

	// 파일 상세정보 조회 (프로젝트 상태에 등록된 파일일 경우)
	// 파라미터 : project_status_idx
	// 리턴값 : name, write_date
	// 해당 파일의 상세정보를 조회하는 메서드
	public ArrayList<FileDetailsViewDto> getCommentsFileDetailsViewDtoFromProjectStatusIdx(int projectStatusIdx)
			throws Exception {
		String sql = "SELECT f.name, f.write_date" + " FROM files f"
				+ " INNER JOIN comments c ON f.comments_idx = c.comments_idx"
				+ " INNER JOIN project_status ps ON ps.project_status_idx = c.project_status_idx"
				+ " WHERE ps.project_idx=?";

		ArrayList<FileDetailsViewDto> list = new ArrayList<FileDetailsViewDto>();

		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, projectStatusIdx);
		ResultSet rs = pstmt.executeQuery();

		while (rs.next()) {
			String name = rs.getString("name");
			String writeDate = rs.getString("write_date");

			FileDetailsViewDto dto = new FileDetailsViewDto(name, writeDate);
			list.add(dto);
		}

		rs.close();
		pstmt.close();
		conn.close();
		return list;
	}

	// 파일 상세정보 조회 (wam 댓글에 등록된 파일일 경우)
	// 파라미터 : wam_idx
	// 리턴값 : name, write_date
	// 해당 파일의 상세정보를 조회하는 메서드
	public ArrayList<FileDetailsViewDto> getCommentsFileDetailsViewDtoFromWamIdx(int wamIdx) throws Exception {
		String sql = "SELECT f.name, f.write_date" + " FROM files f"
				+ " INNER JOIN comments c ON f.comments_idx = c.comments_idx"
				+ " INNER JOIN wam w ON w.wam_idx = c.wam_idx" + " WHERE w.wam_idx=?";

		ArrayList<FileDetailsViewDto> list = new ArrayList<FileDetailsViewDto>();

		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, wamIdx);
		ResultSet rs = pstmt.executeQuery();

		while (rs.next()) {
			String name = rs.getString("name");
			String writeDate = rs.getString("write_date");

			FileDetailsViewDto dto = new FileDetailsViewDto(name, writeDate);
			list.add(dto);
		}

		rs.close();
		pstmt.close();
		conn.close();
		return list;
	}

	// 메모 제목 수정
	// 파라미터 : title, memo_idx
	// 해당 메모의 제목을 수정하는 메서드
	public void updateMemoFromTitle(String title, int memoIdx) throws Exception {
		String sql = "UPDATE memo SET title=? WHERE memo_idx=?";

		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, title);
		pstmt.setInt(2, memoIdx);
		pstmt.executeUpdate();

		pstmt.close();
		conn.close();
	}

	// 해당 파일 삭제
	// 파라미터 : message_idx
	// 해당 메시지에 등록된 파일을 삭제하는 메서드
	public void deleteFile(int messageIdx) throws Exception {
		String sql = "DELETE FROM files WHERE message_idx=?";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, messageIdx);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}

	public static void main(String[] args) throws Exception {

	}

}
