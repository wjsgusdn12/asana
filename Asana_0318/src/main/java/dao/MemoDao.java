package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import dto.LookMemoDto;

public class MemoDao {

	public Connection getConnection() throws Exception{
		String driver = "oracle.jdbc.driver.OracleDriver";
		String url = "jdbc:oracle:thin:@gusdntkd.cafe24.com:1521:xe";
		String id = "asana_hw";
		String pw = "asana12345";
				
		Class.forName(driver);
		Connection conn = DriverManager.getConnection(url, id, pw);
		return conn;
	}
	
	//	프로젝트에 소속된 memo_idx 조회
	//	파라미터 : project_idx
	//	리턴값 : memo_idx
	//	해당 프로젝트에 있는 메모를 조회하는 메서드
	public int getMemoIdxByProjectIdx(int projectIdx) throws Exception{
		String sql = "SELECT memo_idx"
				+ " FROM memo"
				+ " WHERE project_idx = ?";
		
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, projectIdx);
		ResultSet rs = pstmt.executeQuery();
		int idx = 0;
		if(rs.next()) {
			idx = rs.getInt(1);
		}
		
		rs.close();
		pstmt.close();
		conn.close();
		return idx;
	}
	
	//	메모 제목 등록
	//	파라미터 : project_idx, title
	//	해당 메모의 제목을 등록하는 메서드
	public void registerMemoTitle(int projectIdx, String title) throws Exception{
		String sql ="UPDATE memo SET title = ?, write_date = sysdate WHERE project_idx = ?";
		
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, title);
		pstmt.setInt(2, projectIdx);
		pstmt.executeUpdate();
		
		pstmt.close();
		conn.close();
	}
	
	//	메모 내용 등록
	//	파라미터 : project_idx, content
	//	해당 메모의 내용을 등록하는 메서드
	public void registerMemoContent(int projectIdx, String content) throws Exception{
		String sql = "UPDATE memo SET content = ?, write_date = sysdate WHERE project_idx = ?";
		
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, content);
		pstmt.setInt(2, projectIdx);
		pstmt.executeUpdate();
		
		pstmt.close();
		conn.close();
	}
	
	//	메모 제목 수정
	//	파라미터 : project_idx, title
	//	해당 메모의 제목을 수정하는 메서드
	public void updateMemoTitleByMemoIdx(int memoIdx, String title) throws Exception{
		String sql ="UPDATE memo SET title = ?, write_date = sysdate WHERE memo_idx = ?";
		
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, title);
		pstmt.setInt(2, memoIdx);
		pstmt.executeUpdate();
		
		pstmt.close();
		conn.close();
	}
	
	//	메모 내용 수정
	//	파라미터 : project_idx, title
	//	해당 메모의 내용을 수정하는 메서드
	public void updateMemoContentByMemoIdx(int memoIdx, String content) throws Exception{
		String sql = "UPDATE memo SET content = ?, write_date = sysdate WHERE memo_idx = ?";
		
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, content);
		pstmt.setInt(2, memoIdx);
		pstmt.executeUpdate();
		
		pstmt.close();
		conn.close();
	}
	
	//	메모 조회
	//	파라미터 : project_idx
	//	리턴값 : title, content, write_date
	//	해당 메모의 내용을 조회하는 메서드
	public LookMemoDto getLookMemoDtoFromProjectIdx(int projectIdx) throws Exception{
		String sql ="SELECT project_idx, title, content, TO_CHAR(write_date, 'YYYY')||'년'||"
				+ "                                    TO_CHAR(write_date, 'MM')||'월'||"
				+ "                                    TO_CHAR(write_date, 'DD')||'일 '||"
				+ "                                    TO_CHAR(write_date, 'HH12')||'시'||"
				+ "                                    TO_CHAR(write_date, 'MI')||'분' \"작성시간\""
				+ " FROM memo"
				+ " WHERE project_idx=?";
		LookMemoDto dto = null;
		
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, projectIdx);
		ResultSet rs = pstmt.executeQuery();
		if(rs.next()) {
			Integer projectIdx1 = rs.getInt("project_idx");
			String title = rs.getString("title");
			String content = rs.getString("content");
			String writeDate = rs.getString("작성시간");
			dto = new LookMemoDto(projectIdx1, title, content, writeDate);
		}
		rs.close();
		pstmt.close();
		conn.close();
		return dto;
	}
	
	//	메모 삭제
	//	파라미터 : project_idx
	//	해당 메모를 삭제하는 메서드 (프로젝트 삭제시 해당 프로젝트의 메모도 같이 삭제)
	public void DeleteMemoByprojectIdx(int projectIdx) throws Exception{
		String sql = "DELETE FROM memo WHERE project_idx = ?";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, projectIdx);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}
	
	//	메모 생성
	//	파라미터 : project_idx
	//	해당 메모를 생성하는 메서드 (프로젝트 삭제시 해당 프로젝트의 메모도 같이 생성)
	public void CreateMemoByProjectIdx(int projectIdx) throws Exception{
		String sql = "INSERT INTO memo (memo_idx, project_idx) VALUES (seq_memo_idx.nextval, ?)";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, projectIdx);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}
	
	//	메모 시간 조회
	//	리턴값 : 수정된 date
	//	해당 메모의 최종수정시간을 조회하는 메서드
	public String nowMemoTime() throws Exception{
		String sql = "SELECT TO_CHAR(sysdate, 'YYYY')||'년'||"
				+ "        TO_CHAR(sysdate, 'MM')||'월'||"
				+ "        TO_CHAR(sysdate, 'DD')||'일 '||"
				+ "        TO_CHAR(sysdate, 'HH12')||'시'||"
				+ "        TO_CHAR(sysdate, 'MI')||'분' \"현재시간\""
				+ " FROM dual";
		
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		ResultSet rs = pstmt.executeQuery();
		
		String nowMemoTime = null;
		if(rs.next()) {
			nowMemoTime = rs.getString("현재시간");
		}
		
		rs.close();
		pstmt.close();
		conn.close();
		return nowMemoTime;
	}
	
	public static void main(String[] args) throws Exception{
		
	}
}
