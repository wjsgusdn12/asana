package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import dto.MemberDto;
import dto.MessageCooperationDto;

public class MessageCooperationDao {
	public Connection getConnection() throws Exception{
		String driver = "oracle.jdbc.driver.OracleDriver";
		String url = "jdbc:oracle:thin:@gusdntkd.cafe24.com:1521:xe";
		String id = "asana_hw";
		String pw = "asana12345";
		
		Class.forName(driver);
		Connection conn = DriverManager.getConnection(url, id, pw);
		return conn;
	}
	
	//	메시지 협업 참여
	//	파라미터 : message_idx, member_idx
	//	특정 메시지에 협업 참여자를 추가하는 메서드
	public void MessageCooperation(int MessageIdx, int MemberIdx) throws Exception {
		String sql = " INSERT INTO message_cooperation VALUES(?,?)";
				
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		
		pstmt.setInt(1, MessageIdx);
		pstmt.setInt(2, MemberIdx);
		pstmt.executeUpdate();
		
		pstmt.close();
		conn.close();
	}
	
	//	메시지 협업 나가기
	//	파라미터 : message_idx, member_idx
	//	특정 메시지에서 협업 참여자 나가는 메서드
	public void OutMessageCooperation(int MessageIdx, int MemberIdx) throws Exception { 
		String sql = " DELETE FROM message_cooperation WHERE message_idx = ? AND member_idx = ?";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		
		pstmt.setInt(1, MessageIdx);
		pstmt.setInt(2, MemberIdx);
		pstmt.executeUpdate();
		
		pstmt.close();
		conn.close();
	}
	
	//	메시지 협업 참여 여부
	//	파라미터 : messageIdx, memberIdx
	//	리턴값 :	COUNT(1,0)
	//	1 or 0 으로 메시지 협업 참여 여부를 확인하는 메서드
	public int checkMessageCooperation(int messageIdx, int memberIdx) throws Exception {
		String sql = "SELECT COUNT(*) FROM message_cooperation WHERE message_idx = ? AND member_idx = ?";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, messageIdx);
		pstmt.setInt(2, memberIdx);
		ResultSet rs = pstmt.executeQuery();
		int count = 0;
		if(rs.next()) {
			 count = rs.getInt(1);
		}
		rs.close();
		pstmt.close();
		conn.close();
		return count;
	}
	
	//	메시지 협업 참여자 조회 
	//	파라미터 : message_idx
	//	리턴값 : profile_img
	//	특정 메시지의 협업 참여자를 조회하는 메서드
	public ArrayList<MessageCooperationDto> getMessageCooperationDto(int MessageIdx) throws Exception {
		String sql = "SELECT DISTINCT mb.profile_img, mb.nickname, mb.member_idx"
				+ " FROM message_cooperation mc"
				+ " INNER JOIN member mb ON mc.member_idx = mb.member_idx"
				+ " WHERE mc.message_idx=?";
				
		ArrayList<MessageCooperationDto> list = new ArrayList<>();
		
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, MessageIdx);
		
		ResultSet rs = pstmt.executeQuery();
		while(rs.next()) {
			String profileImg = rs.getString("profile_img");
			String nickname = rs.getString("nickname");
			int memberIdx = rs.getInt("member_idx");
			MemberDto mdto = new MemberDto();
			mdto.setProfileImg(profileImg);
			mdto.setNickname(nickname);
			mdto.setMemberIdx(memberIdx);
			
			MessageCooperationDto mcdto = new MessageCooperationDto();
			mcdto.setMemberDto(mdto);
			
			list.add(mcdto);
		}
		rs.close();
		pstmt.close();
		conn.close();
		
		return list;
	}
	
	public static void main(String[] args) throws Exception {
		
	}
}
