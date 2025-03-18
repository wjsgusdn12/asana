package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import dto.InviteWhoDto;

public class InviteDao {
	public Connection getConnection() throws Exception {
		String driver = "oracle.jdbc.driver.OracleDriver";
		String url = "jdbc:oracle:thin:@gusdntkd.cafe24.com:1521:xe";
		String id = "asana_hw";
		String pw = "asana12345";

		Class.forName(driver);
		Connection conn = DriverManager.getConnection(url, id, pw);
		return conn;
	}
	
	// 초대할 목록 띄우기.(로그인한 member_idx 제외)
	// 파라미터 : member_idx
	// 리턴값 :  profile_img, nickname, email
	// 목표의 상태 업데이트의 작성된 댓글을 조회해주는 메서드
	public ArrayList<InviteWhoDto> getInviteWhoDto(int memberIdx) throws Exception {
		String sql = "SELECT profile_img, nickname,email" + " FROM member" + " WHERE member_idx != ?";
		ArrayList<InviteWhoDto> InviteMember = new ArrayList<InviteWhoDto>();

		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, memberIdx);
		ResultSet rs = pstmt.executeQuery();

		while (rs.next()) {
			String profileImg = rs.getString("profile_img");
			String nickname = rs.getString("nickname");
			String email = rs.getString("email");
			InviteWhoDto dto = new InviteWhoDto(profileImg, nickname, email);
			InviteMember.add(dto);
		}
		rs.close();
		pstmt.close();
		conn.close();

		return InviteMember;
	}

	public static void main(String[] args) throws Exception {

	}

}
