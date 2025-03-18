package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import dto.StatusAllDto;

public class StatusGetAllDao {
	public Connection getConnection() throws Exception{
		String driver = "oracle.jdbc.driver.OracleDriver";
		String url = "jdbc:oracle:thin:@gusdntkd.cafe24.com:1521:xe";
		String id = "asana_hw";
		String pw = "asana12345";
				
		Class.forName(driver);
		Connection conn = DriverManager.getConnection(url, id, pw);
		return conn;
	}
		
	// 상태 조회 
	// 파라미터 : statusIdx
	// 리턴값 :  name, char_color, background_color, circle_color
	// 특정 statusIdx를 통해 상태 조회하는 메서드 
	public StatusAllDto getStatusAllDto(int statusIdx) throws Exception {
		String sql="SELECT name, char_color, background_color, circle_color"
				+ " FROM status"
				+ " WHERE status_idx=?";
		StatusAllDto dto = null;
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, statusIdx);
		ResultSet rs =  pstmt.executeQuery();
		
		if(rs.next()) {
			 String name =rs.getString("name"); 
			 String charColor = rs.getString("char_color"); 
			 String backgroundColor =rs.getString("background_color"); 
			 String circleColor =rs.getString("circle_color"); 
			 dto = new StatusAllDto(statusIdx, name, charColor, backgroundColor, circleColor);
		}
		rs.close();
		pstmt.close();
		conn.close();
		return dto;
	}
	
	public static void main(String[] args) {
		
	}
}