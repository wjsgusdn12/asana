package dao;

import java.sql.Connection;

import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import dto.CommentsAllDto;
import dto.GoalThingsDto;

public class CommentsGetAllDao {
	public Connection getConnection() throws Exception{
		String driver = "oracle.jdbc.driver.OracleDriver";
		String url = "jdbc:oracle:thin:@gusdntkd.cafe24.com:1521:xe";
		String id = "asana_hw";
		String pw = "asana12345";
				
		Class.forName(driver);
		Connection conn = DriverManager.getConnection(url, id, pw);
		return conn;
	}
	
	// 댓글 조회 
	// 파라미터 : commentsIdx 
	// 리턴값 : comments_idx, project_status_idx, goal_idx, goal_status_idx, wam_idx, message_idx, member_idx, content, file_idx, writedate, fix
	// commentIdx 를 통한 댓글 조회하는 메서드 
	public CommentsAllDto getGoalStatusUpdateCommentDto(int commentsIdx ) throws Exception {
		String sql = "select comments_idx, project_status_idx, goal_idx, goal_status_idx, wam_idx, message_idx, member_idx, content, file_idx, writedate, fix"
				+ " from COMMENTS"
				+ " where comments_idx = ?";
		CommentsAllDto dto = null;
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, commentsIdx); 
		ResultSet rs = pstmt.executeQuery();
		System.out.println("!");
		if(rs.next()) {
			commentsIdx = rs.getInt(commentsIdx);
			Integer projectStatusIdx = rs.getInt("project_status_idx");
			Integer goalIdx = rs.getInt("goal_idx"); 
			Integer goalStatusIdx = rs.getInt("goal_status_idx");
			Integer wamIdx = rs.getInt("wam_idx"); 
			Integer messageIdx = rs.getInt("message_idx");
			Integer memberIdx =rs.getInt("member_idx"); 
			 String content =rs.getString("content");
			 int fileIdx = rs.getInt("file_idx");
			 String writedate = rs.getString("writedate");
			 int fix = rs.getInt("fix");
			 dto = new CommentsAllDto(commentsIdx, projectStatusIdx, goalIdx, goalStatusIdx, wamIdx, messageIdx, memberIdx, content, fileIdx, writedate, fix);
		}
	
	
		rs.close();
		pstmt.close();
		conn.close();
		return dto;
	}
	

}
