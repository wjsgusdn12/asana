package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import dto.MemberDto;
import dto.ProjectParticipantsDto;

public class ProjectParticipantsDao {
	public Connection getConnection() throws Exception{
		String driver = "oracle.jdbc.driver.OracleDriver";
		String url = "jdbc:oracle:thin:@gusdntkd.cafe24.com:1521:xe";
		String id = "asana_hw";
		String pw = "asana12345";
		
		Class.forName(driver);
		Connection conn = DriverManager.getConnection(url, id, pw);
		return conn;
	}
	
	//	프로젝트 참여 멤버 조회
	//	파라미터 : projectIdx
	//	리턴값 : email, nickname, profile_img
	//	특정 프로젝트에 참여하고 있는 멤버를 보여주는 메서드
	public ArrayList<ProjectParticipantsDto> getPerson(int projectIdx) throws Exception{
		String sql = "SELECT m.email, m.nickname, m.profile_img"
				+ " FROM project_participants pp "
				+ " INNER JOIN member m ON pp.member_idx = m.member_idx"
				+ " WHERE pp.project_idx=?";
		
		ArrayList<ProjectParticipantsDto> listPerson = new ArrayList<>();
		
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1,projectIdx);
		ResultSet rs = pstmt.executeQuery();
		while(rs.next()) {
			String email = rs.getString("email");
			String profileImg = rs.getString("profile_img");
			String nickName = rs.getString("nickname");
			
			MemberDto mdto = new MemberDto();
			mdto.setNickname(nickName);
			mdto.setProfileImg(profileImg);
			mdto.setEmail(email);
			
			ProjectParticipantsDto pdto = new ProjectParticipantsDto();
			pdto.setMemberDto(mdto);
			
			listPerson.add(pdto);
		}
		rs.close();
		pstmt.close();
		conn.close();
		return listPerson;
	}
	
	public static void main(String[] args) throws Exception{
		
	}
}
