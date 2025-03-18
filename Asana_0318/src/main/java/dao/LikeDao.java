package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class LikeDao {
	public Connection getConnection() throws Exception {
		String driver = "oracle.jdbc.driver.OracleDriver";
		String url = "jdbc:oracle:thin:@gusdntkd.cafe24.com:1521:xe";
		String id = "asana_hw";
		String pw = "asana12345";

		Class.forName(driver);
		Connection conn = DriverManager.getConnection(url, id, pw);
		return conn;
	}

	//	메시지 내용 좋아요 추가
	//	파라미터 : memberIdx, messageIdx
	//	해당 메시지 내용에 좋아요를 추가하는 메서드
	public void insertLike(int memberIdx, int messageIdx) throws Exception {
		String sql = "INSERT INTO likes(member_idx, message_idx) VALUES(?,?)";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, memberIdx);
		pstmt.setInt(2, messageIdx);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}

	//	메시지 내용 좋아요 삭제
	//	파라미터 : memberIdx, messageIdx
	//	해당 메시지 내용에 좋아요를 취소하는 메서드
	public void deleteLike(int memberIdx, int messageIdx) throws Exception {
		String sql = "DELETE FROM likes WHERE member_idx = ? AND message_idx = ?";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, memberIdx);
		pstmt.setInt(2, messageIdx);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}

	//	메시지 좋아요 수 조회
	//	파라미터 : message_idx
	//	리턴값 : COUNT
	//	해당 메시지에 좋아요 수를 조회하는 메서드
	public int CountMessageLikeDto(int messageIdx) throws Exception {
		String sql = "SELECT COUNT(*)" + " FROM likes" + " WHERE message_idx = ?";

		int ret = 0;
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, messageIdx);
		ResultSet rs = pstmt.executeQuery();
		if (rs.next()) {
			ret = rs.getInt(1);
		}
		rs.close();
		pstmt.close();
		conn.close();

		return ret;
	}
	
	//	특정 메시지의 특정 댓글 좋아요 수 조회
	//	파라미터 : message_idx
	//	리턴값 : count
	// 특정 메시지의 특정 댓글의 좋아요 수를 조회하는 메서드
	public int CountMessageCommentsLikeDto(int commentsIdx) throws Exception {
		String sql = "SELECT count(*)" + " FROM likes"
				+ " INNER JOIN comments ON likes.comments_idx = comments.comments_idx"
				+ " INNER JOIN message ON message.message_idx = comments.message_idx"
				+ " WHERE comments.comments_idx = ?";

		int ret = 0;
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, commentsIdx);
		ResultSet rs = pstmt.executeQuery();
		if (rs.next()) {
			ret = rs.getInt(1);
		}
		rs.close();
		pstmt.close();
		conn.close();

		return ret;
	}
	
	//	메시지 좋아요 여부 조회
	//	파라미터 : member_idx, message_idx
	//	리턴값 : COUNT
	//	특정 메시지에 좋아요 눌렀는지 여부(1:좋아요, 0:안 좋아요)를 체크하는 메서드
	public int getMessageLikeCheckDto(int memberIdx, int messageIdx) throws Exception {
		String sql = "SELECT  count(*)" + " FROM likes" + " WHERE member_idx = ?  AND message_idx = ?";
		int ret = 0;
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, memberIdx);
		pstmt.setInt(2, messageIdx);
		ResultSet rs = pstmt.executeQuery();
		if (rs.next()) {
			ret = rs.getInt(1);
		}
		rs.close();
		pstmt.close();
		conn.close();

		return ret;
	}
	
	//	메시지 댓글 좋아요 여부 조회
	//	파라미터 : memberIdx, commentsIdx
	// 	리턴값 : COUNT
	//	특정 댓글에 좋아요 눌렀는지 여부(1:좋아요, 0:안 좋아요)를 체크하는 메서드
	public int getMessageCommentLikeCheckDto(int memberIdx, int commentsIdx) throws Exception {
		String sql = "SELECT  count(*)" + " FROM likes" + " WHERE member_idx = ? AND comments_idx = ?";
		int ret = 0;
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, memberIdx);
		pstmt.setInt(2, commentsIdx);
		ResultSet rs = pstmt.executeQuery();
		if (rs.next()) {
			ret = rs.getInt(1);
		}
		rs.close();
		pstmt.close();
		conn.close();

		return ret;
	}

	//	특정 메시지 댓글 좋아요 추가
	//	파라미터 : memberIdx, commentIdx
	//	특정 메시지에 달린 댓글에 좋아요를 추가하는 메서드
	public void insertCommentLike(int memberIdx, int commentIdx) throws Exception {
		String sql = "INSERT INTO likes(member_idx, comments_idx) VALUES(?,?)";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, memberIdx);
		pstmt.setInt(2, commentIdx);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}

	//	특정 메시지 댓글 좋아요 삭제
	//	파라미터 : memberIdx, commentIdx
	//	특정 메시지에 달린 댓글에 좋아요를 삭제하는 메서드
	public void deleteCommentLike(int memberIdx, int commentIdx) throws Exception {
		String sql = "DELETE FROM likes WHERE member_idx = ? AND comments_idx = ?";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, memberIdx);
		pstmt.setInt(2, commentIdx);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}

	public static void main(String[] args) throws Exception {
		
	}
}
