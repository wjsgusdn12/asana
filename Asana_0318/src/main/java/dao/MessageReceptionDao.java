package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

public class MessageReceptionDao {
	public Connection getConnection() throws Exception{
		String driver = "oracle.jdbc.driver.OracleDriver";
		String url = "jdbc:oracle:thin:@gusdntkd.cafe24.com:1521:xe";
		String id = "asana_hw";
		String pw = "asana12345";
		
		Class.forName(driver);
		Connection conn = DriverManager.getConnection(url, id, pw);
		return conn;
	}
	
	//	메시지 수신함에 프로젝트 추가
	//	파라미터 : messageIdx, projectIdx
	//	메시지를 보낼 때 수신에 프로젝트를 추가하면 알림이 가는 메서드
	public void InsertMessageReceptionProjectDto(int messageIdx, int projectIdx)throws Exception {
		String sql = "INSERT INTO message_reception(message_idx, project_idx) VALUES(?,?)";
		
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, messageIdx);
		pstmt.setInt(2, projectIdx);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}
	
	//	메시지 수신함에 멤버 추가
	//	파라미터 : messageIdx, memberIdx
	//	메시지를 보낼 때 수신에 멤버를 추가하면 알림이 가는 메서드
	public void InsertMessageReceptionMemberDto(int messageIdx, int memberIdx)throws Exception {
		String sql = "INSERT INTO message_reception(message_idx, member_idx) VALUES(?,?)";
		
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, messageIdx);
		pstmt.setInt(2, memberIdx);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}
}
