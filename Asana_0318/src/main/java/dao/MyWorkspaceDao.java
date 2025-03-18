package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import dto.MemberDto;
import dto.MyWorkspaceDto;

public class MyWorkspaceDao {
	public Connection getConnection() throws Exception{
		String driver = "oracle.jdbc.driver.OracleDriver";
		String url = "jdbc:oracle:thin:@gusdntkd.cafe24.com:1521:xe";
		String id = "asana_hw";
		String pw = "asana12345";
				
		Class.forName(driver);
		Connection conn = DriverManager.getConnection(url, id, pw);
		return conn;
	}
	
	//	내작업공간 멤버 리스트 조회
	//	파라미터 : ownerIdx
	//	리턴값 :  profile_img, nickname, member_idx
	//	내작업공간 멤버 리스트 조회하는 메서드 
	public ArrayList<MyWorkspaceDto> myWorkspaceMemberList(int ownerIdx) throws Exception{
		String sql ="SELECT mb.profile_img, mb.nickname, mb.member_idx"
				+ " FROM member mb"
				+ " INNER JOIN my_workspace mw ON mw.member_idx = mb.member_idx"
				+ " WHERE mw.owner_idx=?";
		MyWorkspaceDto Dto = null;
		ArrayList<MyWorkspaceDto> listDto = new ArrayList<MyWorkspaceDto>();
		
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, ownerIdx);
		ResultSet rs = pstmt.executeQuery();
		while(rs.next()) {
			String profileImg = rs.getString("profile_img");
			String nickname = rs.getString("nickname");
			int memberIdx = rs.getInt("member_idx");
			MemberDto MemberDto = new MemberDto();
			MemberDto.setProfileImg(profileImg);
			MemberDto.setNickname(nickname);
			MemberDto.setMemberIdx(memberIdx);
			Dto = new MyWorkspaceDto();
			Dto.setMemberDto(MemberDto);
			listDto.add(Dto);
		}
		rs.close();
		pstmt.close();
		conn.close();
		return listDto;
	}
	
	//	내 작업 공간 멤버 조회 
	//	파라미터 : 로그인한 멤버 idx(숫자) -> 제외하고 
	//	리턴값 : 리스트 of (member_idx(숫자))
	//	나를 제외하고 내 작업 공간 멤버를 조회하는 메서드
	public ArrayList<MyWorkspaceDto> getMinusMyWorkspaceDto(int memberIdx, int ownerIdx) throws Exception {
		String sql = "SELECT m.profile_img, m.nickname, m.email, m.member_idx FROM my_workspace mw"
				+ " INNER JOIN MEMBER m ON mw.member_idx = m.member_idx"
				+ " WHERE m.member_idx != ? AND mw.owner_idx = ?";
		ArrayList<MyWorkspaceDto> list = new ArrayList<>();
		MyWorkspaceDto Dto = null;
		
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, memberIdx);
		pstmt.setInt(2, ownerIdx);
		ResultSet rs = pstmt.executeQuery();
		while(rs.next()) {
			String profileImg = rs.getString("profile_img");
			String nickname = rs.getString("nickname");
			String email = rs.getString("email");
			int otherMemberIdx = rs.getInt("member_idx");
			MemberDto mDto = new MemberDto();
			mDto.setProfileImg(profileImg);
			mDto.setNickname(nickname);
			mDto.setEmail(email);
			mDto.setMemberIdx(otherMemberIdx);
			Dto = new MyWorkspaceDto();
			Dto.setMemberDto(mDto);
			list.add(Dto);
		}
		rs.close();
		pstmt.close();
		conn.close();
		return list;
	}
	
	//	내 작업 공간 멤버 조회 
	//	파라미터 : member_idx
	//	리턴값 : 리스트 of (member_idx(숫자))
	//	나를 포함한 내 작업 공간 멤버를 조회하는 메서드
	public ArrayList<MyWorkspaceDto> getMyWorkspaceDto(int ownerIdx) throws Exception {
		String sql = "SELECT m.profile_img, m.nickname, m.email FROM my_workspace mw"
				 + " INNER JOIN MEMBER m ON mw.member_idx = m.member_idx"
				 + " WHERE mw.owner_idx = ?";

		ArrayList<MyWorkspaceDto> list = new ArrayList<>();
		MyWorkspaceDto Dto = null;
		
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, ownerIdx);
		ResultSet rs = pstmt.executeQuery();
		while(rs.next()) {
			String profileImg = rs.getString("profile_img");
			String nickname = rs.getString("nickname");
			String email = rs.getString("email");
			
			MemberDto mDto = new MemberDto();
			mDto.setProfileImg(profileImg);
			mDto.setNickname(nickname);
			mDto.setEmail(email);
			
			Dto = new MyWorkspaceDto();
			Dto.setMemberDto(mDto);
			list.add(Dto);
		}
		rs.close();
		pstmt.close();
		conn.close();
		return list;
	}
	
	//	내 작업 공간에서 제거
	//	input: 로그인한 멤버 idx, 제거할 멤버 idx
	//	내 작업 공간에서 원하는 멤버를 제거하는 메서드
	public void DeleteMember(int memberIdx, int ownerIdx) throws Exception {
		String sql = "DELETE FROM my_workspace "
				+ " WHERE owner_idx = ? AND member_idx = ?";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, memberIdx);
		pstmt.setInt(2, ownerIdx);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}
	
	//	내 작업공간 즐겨찾기 유무
	//	파라미터 : memberIdx
	//	리턴값 : 1,0
	//	1 or 0 에 따라 즐겨찾기의 유무를 확인하는 메서드
	public int isFavoritesWorkspaceByMemberIdx(int memberIdx) throws Exception{
		String sql = "SELECT COUNT(*)"
				+ " FROM favorites"
				+ " WHERE my_workspace_owner_idx=1 AND member_idx=?";
		
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, memberIdx);
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
	
	//	프로젝트 즐겨찾기 추가
	//	파라미터 : memberIdx	
	//	특정 프로젝트를 즐겨찾기에 추가하는 메서드
	public void addWorkspaceFavorites(int memberIdx) throws Exception {
		String sql = "INSERT INTO favorites (member_idx, my_workspace_owner_idx) VALUES (?, 1)";

		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, memberIdx);
		pstmt.executeUpdate();

		pstmt.close();
		conn.close();
	}

	//	프로젝트 즐겨찾기 삭제
	//	파라미터 : memberIdx
	//	특정 프로젝트를 즐겨찾기에서 삭제하는 메서드
	public void removeWorkspaceFavorites(int memberIdx) throws Exception {
		String sql = "DELETE FROM favorites WHERE member_idx=? AND my_workspace_owner_idx=1";

		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, memberIdx);
		pstmt.executeUpdate();

		pstmt.close();
		conn.close();
	}
	
	//	즐겨찾기 총 갯수 조회
	//	파라미터 : memberIdx
	//	리턴값 : COUNT
	//	즐겨찾기에 추가된 목록들을 조회하는 메서드
	public int favoritesCount(int memberIdx) throws Exception{
		String sql = "SELECT COUNT(*) FROM favorites WHERE member_idx= ?";
		
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, memberIdx);
		ResultSet rs = pstmt.executeQuery();
		int count = 0;
		while(rs.next()) {
			count = rs.getInt(1);
		}
		rs.close();
		pstmt.close();
		conn.close();
		return count;
	}
	
	public static void main(String[] args) throws Exception{
		
	}
}
