package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Types;
import java.util.ArrayList;

import dto.CommentsAllDto;
import dto.CommentsDto;
import dto.FileDto;
import dto.MemberDto;
import dto.MessageDto;

public class CommentsDao {
	public Connection getConnection() throws Exception {
		String driver = "oracle.jdbc.driver.OracleDriver";
		String url = "jdbc:oracle:thin:@gusdntkd.cafe24.com:1521:xe";
		String id = "asana_hw";
		String pw = "asana12345";

		Class.forName(driver);
		Connection conn = DriverManager.getConnection(url, id, pw);
		return conn;
	}
	
	// 댓글 작성 
	// 파라미터 : goalStatusIdx, goalIdx, projectStatusIdx, wamIdx, messageIdx, memberIdx, content, fileIdx
	// 댓글 작성하는 메서드 
	public void insertComment(Integer goalStatusIdx, Integer goalIdx, Integer projectStatusIdx, Integer wamIdx,
			Integer messageIdx, int memberIdx, String content, Integer fileIdx) throws Exception {
		String sql = "insert into comments(comments_idx, project_status_idx, goal_idx, goal_status_idx, wam_idx, message_idx, "
				+ " member_idx, content, file_idx, writedate, fix) "
				+ "	values(seq_comments_idx.nextval, ?, ?, ?, ?, ?, ?, ?, ?, sysdate, 0)";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);

		if (goalStatusIdx != null)
			pstmt.setInt(1, goalStatusIdx);// 1
		else
			pstmt.setNull(1, Types.INTEGER);// null

		if (goalIdx != null)
			pstmt.setInt(2, goalIdx);
		else
			pstmt.setNull(2, Types.INTEGER);

		if (projectStatusIdx != null)
			pstmt.setInt(3, projectStatusIdx);
		else
			pstmt.setNull(3, Types.INTEGER);

		if (wamIdx != null)
			pstmt.setInt(4, wamIdx);
		else
			pstmt.setNull(4, Types.INTEGER);

		if (messageIdx != null)
			pstmt.setInt(5, messageIdx);
		else
			pstmt.setNull(5, Types.INTEGER);

		pstmt.setInt(6, memberIdx);
		pstmt.setString(7, content);

		if (fileIdx != null)
			pstmt.setInt(8, fileIdx);
		else
			pstmt.setNull(8, Types.INTEGER);

		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}
	
	// 댓글 조회 
	// 파라미터 :  goalStatusIdx, goalIdx, projectStatusIdx, wamIdx, messageIdx
	// 리턴값 :  comments_idx, member_idx, writedate, content, file_idx, fix
	// 댓글 조회하는 메서드 
	public ArrayList<CommentsAllDto> getCommentsDto(Integer goalStatusIdx, Integer goalIdx, Integer projectStatusIdx,
			Integer wamIdx, Integer messageIdx) throws Exception {
		String sql = "SELECT comments_idx, member_idx, writedate, content, file_idx, fix" + " FROM comments"
				+ " WHERE 1=1";

		sql += " AND goal_status_idx ";
		if (goalStatusIdx != null)
			sql += " = " + goalStatusIdx;
		else
			sql += " IS NULL";

		sql += " AND goal_idx ";
		if (goalIdx != null)
			sql += " = " + goalIdx;
		else
			sql += " IS NULL";

		sql += " AND project_status_idx";
		if (projectStatusIdx != null)
			sql += " = " + projectStatusIdx;
		else
			sql += " IS NULL";

		sql += " AND wam_idx";
		if (wamIdx != null)
			sql += " = " + wamIdx;
		else
			sql += " IS NULL";

		sql += " AND message_idx";
		if (messageIdx != null)
			sql += " = " + messageIdx;
		else
			sql += " IS NULL";

		ArrayList<CommentsAllDto> list = new ArrayList<CommentsAllDto>();
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		ResultSet rs = pstmt.executeQuery();
		while (rs.next()) {
			int commentsIdx = rs.getInt("comments_idx");
			int memberIdx = rs.getInt("member_idx");
			String writedate = rs.getString("writedate");
			String content = rs.getString("content");
			Integer fileIdx = rs.getInt("file_idx");
			int fix = rs.getInt("fix");
			CommentsAllDto dto = new CommentsAllDto(commentsIdx, projectStatusIdx, goalIdx, goalStatusIdx, wamIdx,
					messageIdx, memberIdx, content, fileIdx, writedate, fix);
			list.add(dto);
		}

		rs.close();
		pstmt.close();
		conn.close();
		return list;
	}
	
//	댓글 수정
//	파라미터 : content, commentsIdx
//	특정 댓글을 수정하는 메서드
	public void updateCommentsDto(String content, int commentsIdx) throws Exception {
		String sql = "Update comments set content = ?, writedate = sysdate where comments_idx = ?";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, content);
		pstmt.setInt(2, commentsIdx);
		pstmt.executeQuery();
		pstmt.close();
		conn.close();
	}
	
	//	댓글 삭제
	//	파라미터 : commentsIdx
	//	특정 댓글을 삭제하는 메서드
	public void deleteCommentsDto(int commentsIdx) throws Exception {
		String sql = "Delete FROM comments WHERE comments_idx=?";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, commentsIdx);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}
	
	// 	댓글 고정
	//	파라미터 : fix, commentIdx
	//	특정 댓글을 고정하는 메서드
	public void fixCommentsDto(int fix, int commentIdx) throws Exception {
		String sql = "Update comments set fix = ? where comments_idx =?";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, fix);
		pstmt.setInt(2, commentIdx);
		pstmt.executeQuery();
		pstmt.close();
		conn.close();
	}

	//	댓글 생성하면서 그 댓글의 idx 가져오기
	//	파라미터 : memberIdx, messageIdx, content
	//	댓글이 생성되면서 그 댓글의 idx를 가져오는 메서드
	public int showCreateComment(int memberIdx, int messageIdx, String content) throws Exception {
		String sql = "INSERT INTO comments (comments_idx, member_idx, message_idx, content, writedate)"
				+ " VALUES (seq_comments_idx.nextval, ?, ?, ?, sysdate)";

		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, memberIdx);
		pstmt.setInt(2, messageIdx);
		pstmt.setString(3, content);
		pstmt.executeUpdate();

		//		댓글 삽입 후, 가장 최근에 삽입된 comment_idx를 가져오는 SELECT 쿼리
		String sql2 = "SELECT seq_comments_idx.currval FROM dual"; // currval은 마지막으로 생성된 시퀀스 값을 반환
		PreparedStatement pstmt2 = conn.prepareStatement(sql2);
		ResultSet rs = pstmt2.executeQuery();

		int commentIdx = 0;
		if (rs.next()) {
			commentIdx = rs.getInt(1); // 생성된 comment_idx를 가져옴
		}

		rs.close();
		pstmt2.close();
		pstmt.close();
		conn.close();

		return commentIdx; // 생성된 comment_idx를 반환
	}

	//	메시지 댓글 쓰기
	//	파라미터 : memberIdx, messageIdx, content
	//	특정 메시지의 댓글을 쓰는 메서드
	public void createComment(int memberIdx, int messageIdx, String content) throws Exception {
		String sql = "INSERT INTO comments (comments_idx, member_idx, message_idx, content, writedate)"
				+ " VALUES (seq_comments_idx.nextval, ?, ?, ?, sysdate)";

		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);

		pstmt.setInt(1, memberIdx);
		pstmt.setInt(2, messageIdx);
		pstmt.setString(3, content);
		pstmt.executeUpdate();

		pstmt.close();
		conn.close();
	}
	
	//	메시지 댓글 조회
	//	파라미터 : messageIdx
	//	리턴값 : writedate, content, profile_img, nickname, fix
	//	특정 메시지의 모든 댓글을 조회하는 메서드
	public ArrayList<CommentsDto> getMessageCommentsDto(int messageIdx) throws Exception {
		String sql = "SELECT c.writedate, c.content, m.profile_img, m.nickname, c.fix"
				+ " FROM comments c INNER JOIN member m" + " ON c.member_idx = m.member_idx"
				+ " WHERE c.message_idx = ?" + " ORDER BY fix DESC, writedate ASC";

		ArrayList<CommentsDto> list = new ArrayList<>();

		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, messageIdx);
		ResultSet rs = pstmt.executeQuery();

		while (rs.next()) {
			String writedate = rs.getString("writedate");
			String content = rs.getString("content");
			String profileImg = rs.getString("profile_img");
			String nickName = rs.getString("nickname");
			int fix = rs.getInt("fix");
			MemberDto mto = new MemberDto();

			CommentsDto cto = new CommentsDto(writedate, content, fix, mto);

			list.add(cto);

		}
		rs.close();
		pstmt.close();
		conn.close();

		return list;
	}
	
	//	메시지 댓글 수정 
	//	파라미터 : content, commentIdx
	//	특정 메시지의 특정 댓글을 수정하는 메서드
	public void UpdateMessageCommentDto(String content, int commentIdx) throws Exception {
		String sql = "UPDATE comments" + " SET content = ? , writedate = sysdate" + " WHERE comments_idx = ?";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);

		pstmt.setString(1, content);
		pstmt.setInt(2, commentIdx);
		pstmt.executeUpdate();

		pstmt.close();
		conn.close();
	}
	
	//	메시지 댓글 삭제 
	//	파라미터 : commentIdx
	//	특정 메시지의 특정 댓글을 삭제하는 메서드
	public void DeleteMessageCommentDto(int commentIdx) throws Exception {
		String sql = "DELETE FROM comments WHERE comments_idx = ?";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);

		pstmt.setInt(1, commentIdx);
		pstmt.executeUpdate();

		pstmt.close();
		conn.close();
	}
	
	//	댓글 상단에 고정하는 메서드
	//	파라미터 : commentIdx
	//	특정 댓글을 상단에 고정하는 메서드
	public void fixCommentDto(int commentIdx) throws Exception {
		String sql = "UPDATE comments SET fix=1 WHERE comments_idx = ?";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);

		pstmt.setInt(1, commentIdx);
		pstmt.executeUpdate();

		pstmt.close();
		conn.close();
	}
	
	//	댓글 상단에 고정해제하는 메서드
	//	파라미터 : commentIdx
	//	특정 댓글을 상단에 고정해제하는 메서드
	public void fixCommentCancelDto(int commentIdx) throws Exception {
		String sql = "UPDATE comments SET fix = 0 WHERE comments_idx = ?";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);

		pstmt.setInt(1, commentIdx);
		pstmt.executeUpdate();

		pstmt.close();
		conn.close();
	}

	//	해당 댓글 상세보기
	//	파라미터 : commentIdx
	//	리턴값 : comments_idx, message_idx, member_idx, content, writeDate, fix, file_idx, nickname, profile_img
	//	해당 댓글을 상세조회하는 메서드
	public CommentsDto showCommentDto(int commentIdx) throws Exception {
		String sql = "SELECT c.comments_idx, c.message_idx, c.member_idx, c.content, c.writeDate, c.fix, c.file_idx, m.nickname, m.profile_img"
				+ " FROM comments c INNER JOIN member m" + " ON c.member_idx = m.member_idx"
				+ " WHERE c.comments_idx = ?";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, commentIdx);
		ResultSet rs = pstmt.executeQuery();
		CommentsDto dto = null;
		if (rs.next()) {
			int commentsIdx = rs.getInt("comments_idx");
			int messageIdx = rs.getInt("message_idx"); // MessageDto
			int memberIdx = rs.getInt("member_idx"); //
			String content = rs.getString("content");
			String writeDate = rs.getString("writeDate");
			String nickname = rs.getString("nickname");
			String profile = rs.getString("profile_img");
			int fileIdx = rs.getInt("file_idx"); // fileDto
			int fix = rs.getInt("fix");

			FileDto fdto = new FileDto();
			fdto.setFileIdx(fileIdx);
			MessageDto mdto = new MessageDto();
			mdto.setMessageIdx(messageIdx);
			MemberDto mbdto = new MemberDto();
			mbdto.setNickname(nickname);
			mbdto.setProfileImg(profile);
			dto = new CommentsDto(writeDate, content, fix, commentsIdx, memberIdx, mbdto, mdto, fdto);
		}
		rs.close();
		pstmt.close();
		conn.close();

		return dto;
	}

	public static void main(String[] args) throws Exception {

	}
}
