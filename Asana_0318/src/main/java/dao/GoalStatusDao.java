package dao;

import java.sql.Connection;

import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import dto.GoalStatusCommentsDto;

public class GoalStatusDao {
	public Connection getConnection() throws Exception {
		String driver = "oracle.jdbc.driver.OracleDriver";
		String url = "jdbc:oracle:thin:@gusdntkd.cafe24.com:1521:xe";
		String id = "asana_hw";
		String pw = "asana12345";

		Class.forName(driver);
		Connection conn = DriverManager.getConnection(url, id, pw);
		return conn;
	}

	// 목표의 상태업데이트의 댓글 조회 
	// 파라미터 : comments_idx
	// 리턴값 :  project_status_idx, goal_idx, goal_status_idx, wam_idx, message_idx, member_idx, content, file_name, writedate, fix
	// 목표의 상태 업데이트의 작성된 댓글을 조회해주는 메서드
	public GoalStatusCommentsDto getGoalStatusUpdateCommentsDto(int commentsIdx) throws Exception {
		String sql = "SELECT project_status_idx, goal_idx, goal_status_idx, wam_idx, message_idx, member_idx, content, file_name, writedate, fix"
				+ " FROM comments" + " WHERE comments_idx = ?";
		GoalStatusCommentsDto dto = null;

		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, commentsIdx); 
		ResultSet rs = pstmt.executeQuery();

		if (rs.next()) {
			Integer projectStatusIdx = rs.getInt("project_status_idx"); 
			Integer goalIdx = rs.getInt("goal_idx");
			Integer GoalStatusIdx = rs.getInt("goal_status_idx"); 
			Integer wamIdx = rs.getInt("wam_idx"); 
			Integer messageIdx = rs.getInt("message_idx"); 
			Integer membeIdx = rs.getInt("member_idx");
			String content = rs.getString("content"); 
			String fileName = rs.getString("file_name"); 
			String writeDate = rs.getString("writedate"); 
			int fix = rs.getInt("fix"); 
			dto = new GoalStatusCommentsDto(membeIdx, projectStatusIdx, goalIdx, GoalStatusIdx, wamIdx, messageIdx,
					membeIdx, content, fileName, writeDate, fix);
		}
		
		rs.close();
		pstmt.close();
		conn.close();
		return dto;
	}

	public static void main(String[] args) throws Exception {
		
	}

}