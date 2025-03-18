package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import dto.AlarmUpdateDto;

public class AlarmUpdateDao {
	public Connection getConnection() throws Exception{
		String driver = "oracle.jdbc.driver.OracleDriver";
		String url = "jdbc:oracle:thin:@gusdntkd.cafe24.com:1521:xe";
		String id = "asana_hw";
		String pw = "asana12345";
				
		Class.forName(driver);
		Connection conn = DriverManager.getConnection(url, id, pw);
		return conn;
    }
	
	// 멤버별 실시간 알림 
	// 파라미터 : memberIdx
	// 리턴값 : alarm_idx, member_idx, content
	// 멤버별 최신순기준으로 알림을 보여주는 메서드 
	public ArrayList<AlarmUpdateDto> getAlarmSelect(int memberIdx) throws Exception{
		String sql = "SELECT alarm_idx, member_idx, content"
				+ " FROM alarm_update "
				+ " WHERE member_idx=? "
				+ " ORDER BY alarm_idx DESC";
		ArrayList<AlarmUpdateDto> alarmUpdateDto = new ArrayList<AlarmUpdateDto>();
		
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, memberIdx);
		ResultSet rs = pstmt.executeQuery();
		while(rs.next()) {
			int alarmIdx = rs.getInt("alarm_idx");
			memberIdx = rs.getInt("member_idx");
			String content = rs.getString("content");
			AlarmUpdateDto dto = new AlarmUpdateDto(alarmIdx, memberIdx, content);
			alarmUpdateDto.add(dto);
		}
		rs.close();
		pstmt.close();
		conn.close();
		return alarmUpdateDto;
	}
	
	// 멤버별 실시간 알림 삭제 
	// 파라미터 : memberIdx
	// 멤버별 실시간 알림 후 삭제하는 메서드 
	public void deleteAlarmUpdate(int memberIdx) throws Exception {
		String sql= " DELETE FROM alarm_update WHERE member_idx=?";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, memberIdx);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}
	
	// 실시간 알림 저장 
	// 파라미터 :  memberIdx, content
	// 실시간 알림의 기능에 해댱될때 내작업 공간 멤버, 실시간 알림 내용을 저장하는 메서드 
	public void insertAlarmUpdate(int memberIdx, String content) throws Exception {
		String sql= "insert into alarm_update(alarm_idx, member_idx, content) "
				+ "values(seq_alarm_idx.nextval, ?, ?)";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, memberIdx);
		pstmt.setString(2, content);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}
	
	public static void main(String[] args) throws Exception  {
		
	}
}
