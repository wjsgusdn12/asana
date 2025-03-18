package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import dto.CommentsDto;
import dto.FileDto;
import dto.MemberDto;
import dto.MessageDto;
import dto.ProjectDto;
import dto.ProjectParticipantsDto;

public class MessageDao {
	public Connection getConnection() throws Exception{
		String driver = "oracle.jdbc.driver.OracleDriver";
		String url = "jdbc:oracle:thin:@gusdntkd.cafe24.com:1521:xe";
		String id = "asana_hw";
		String pw = "asana12345";
		
		Class.forName(driver);
		Connection conn = DriverManager.getConnection(url, id, pw);
		return conn;
	}
	
	// 	메시지 내용
	//	파라미터 : message_idx(숫자)
	//	리턴값 : content
	//	원하는 메시지 내용을 보여주는 메서드
	public String getMessageContentDto(int messageIdx) throws Exception{
		String sql = "SELECT content"
					+" FROM message "
					+" WHERE message_idx=?";
		Connection conn = getConnection();
		
		String ret = null;
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, messageIdx);
		ResultSet rs = pstmt.executeQuery();
		if(rs.next()) {
			ret = rs.getString("content");
		}
		rs.close();
		pstmt.close();
		conn.close();
		
		return ret;
	}
	
	//	프로젝트명 보이기
	//	파라미터 : message_idx, project_idx
	//	리턴값 : name
	//	해당 메시지의 프로젝트명을 보여주는 메서드
	public String getProjectNameDto(int messageIdx) throws Exception{
		String sql = "SELECT p.name" +
				" FROM project p INNER JOIN message m ON m.project_idx = p.project_idx" +
				" WHERE m.message_idx=?";
		Connection conn = getConnection();
		
		String ret = null;
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1,messageIdx);
		ResultSet rs = pstmt.executeQuery();
		if(rs.next()) {
			 ret = rs.getString("name");
		}
		rs.close();
		pstmt.close();
		conn.close();
		
		return ret;
	}
	
	//	메시지 작성시간
	//	파라미터 : message_idx
	//	리턴값 : write_date
	//	해당 메시지의 작성시간을 보여주는 메서드
	public String getMessageWriteDateDto(int messageIdx) throws Exception{
		String sql = "SELECT write_date FROM message WHERE message_idx=?";
		Connection conn = getConnection();
		
		String ret = null;
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, messageIdx);
		ResultSet rs = pstmt.executeQuery();
		if(rs.next()) {
			ret = rs.getString("write_date");
		}
		rs.close();
		pstmt.close();
		conn.close();
		
		return ret;
	}
	
	//	작성자 보여주기
	//	파라미터: member_idx(숫자)
	//	리턴값 : nickname, profile_img
	//	작성자의 닉네임, 프로필이미지를 보여주는 메서드
	public MemberDto getMessageWriterDto(int messageIdx) throws Exception{
		String sql = "SELECT  nickname, profile_img"
				+ " FROM message "
				+ " INNER JOIN member ON member.member_idx = message.writer_idx"
				+ " WHERE message_idx = ?";
		
		Connection conn = getConnection();
		
		MemberDto dto = null;
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, messageIdx);
		ResultSet rs = pstmt.executeQuery();
		if(rs.next()) {
			String nickname = rs.getString("nickname");
			String profileImg = rs.getString("profile_img");
			dto = new MemberDto(nickname, profileImg);
		}
		rs.close();
		pstmt.close();
		conn.close();
		return dto;	
	}
	
	//	메시지 노출
	//	파라미터 : messageIdx
	//	메시지 삭제대신 1,0으로 보여주기 혹은 숨기기로 결정하는 메서드
	public void updateDeleteCheck(int messageIdx) throws Exception {
		String sql = "UPDATE message SET delete_check = 1 WHERE message_idx = ?";
		Connection conn = getConnection();
		
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1,messageIdx);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}
	
	//	메시지 삭제하기 
	//	파라미터 : message_idx
	//	메시지를 삭제하는 메서드
	public void DeleteMessage(int messageIdx) throws Exception{
		String sql = "DELETE FROM message WHERE message_idx=?";
				Connection conn = getConnection();
				
				PreparedStatement pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1,messageIdx);
				pstmt.executeUpdate();
				pstmt.close();
				conn.close();
	}
	
	//	특정 프로젝트에 있는 메시지 보여주기
	//	파라미터 : projectIdx
	//	리턴값 : title, content, write_date, nickname, profile_img, name, message_idx, writer_idx, comments_idx, member_idx
	//	특정 프로젝트 idx가 가지고 있는 모든 메시지의 상세내용을 보여주는 메서드
	public ArrayList<MessageDto> getMessagesDto(int projectIdx) throws Exception{
		String sql ="SELECT me.title, me.content, me.write_date, mb.nickname, mb.profile_img, p.name, message_idx, delete_check, writer_idx" 
				+ " FROM message me INNER JOIN project p"
				+ " ON me.project_idx = p.project_idx"
				+ " INNER JOIN member mb"
				+ " ON mb.member_idx = me.writer_idx"
				+ " WHERE me.project_idx = ?"
				+ " ORDER BY write_date DESC";
		ArrayList<MessageDto> listMessage = new ArrayList<>();
		
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1,projectIdx);
		ResultSet rs = pstmt.executeQuery();// 이 세개를 담고 있는 메서드 생성(코드 중복을 제거)
		while(rs.next()) {
			String title = rs.getString("title");
			String content = rs.getString("content");
			String writeDate = rs.getString("write_date");
			String nickName = rs.getString("nickname");
			String profileImg = rs.getString("profile_img");
			String name = rs.getString("name");
			int deleteCheck = rs.getInt("delete_check");
			int messageIdx = rs.getInt("message_idx");
			int writerIdx = rs.getInt("writer_idx");
			
			MemberDto mdto = new MemberDto();
			mdto.setNickname(nickName);
			mdto.setProfileImg(profileImg);
			
			ProjectDto pdto = new ProjectDto();
			pdto.setName(name);
			
			MessageDto dto = new MessageDto();
			dto.setTitle(title);
			dto.setContent(content);
			dto.setWriteDate(writeDate);
			dto.setMessageIdx(messageIdx);
			dto.setMemberDto(mdto);
			dto.setProjectDto(pdto);
			dto.setDeleteCheck(deleteCheck);
			dto.setWriterIdx(writerIdx);
			
			// 댓글뽑기 (message_idx)
			String sql2 = "SELECT c.writedate, c.content, m.profile_img, m.nickname, c.fix, c.comments_idx, c.member_idx"
					+ " FROM comments c INNER JOIN member m"
					+ " ON c.member_idx = m.member_idx"
					+ " WHERE c.message_idx = ?"
					+ " ORDER BY fix DESC, writedate";
			ArrayList<CommentsDto> listReply = new ArrayList<CommentsDto>();
			
			PreparedStatement pstmt2 = conn.prepareStatement(sql2);
			pstmt2.setInt(1,messageIdx);
			ResultSet rs2 = pstmt2.executeQuery();
			while(rs2.next()) {
				
					String writedate = rs2.getString("writedate");
					String commentsContent = rs2.getString("content");
					String commentsProfileImg = rs2.getString("profile_img");
					String nickname = rs2.getString("nickname");
					int fix = rs2.getInt("fix");
					int commentIdx = rs2.getInt("comments_idx");
					int memberIdx = rs2.getInt("member_idx");
					
					CommentsDto commentsDto = new CommentsDto();
					commentsDto.setWriteDate(writedate);
					commentsDto.setFix(fix);
					commentsDto.setContent(commentsContent);
					commentsDto.setCommentIdx(commentIdx);
					commentsDto.setMemberIdx(memberIdx);
					
					MemberDto memberDto = new MemberDto();
					memberDto.setProfileImg(commentsProfileImg);
					memberDto.setNickname(nickname);
					commentsDto.setMemberDto(memberDto);
					listReply.add(commentsDto);
			}
			dto.setListReply(listReply);
			listMessage.add(dto);
			
			String sql3 = "SELECT name FROM files WHERE message_idx = ?";
			FileDto fileDto = new FileDto();
			PreparedStatement pstmt3 = conn.prepareStatement(sql3);
			pstmt3.setInt(1, messageIdx);
			ResultSet rs3 = pstmt3.executeQuery();
			if(rs3.next()) {
				String fileName = rs3.getString("name");
				fileDto.setName(fileName);
			}
			dto.setFileDto(fileDto);
		}
		rs.close();
		pstmt.close();
		conn.close();
		
		return listMessage;
	}
	
	//	메시지 제목 변경 
	//	파라미터 : message_idx, title
	//	특정 메시지의 제목을 변경해주는 메서드
	public void UpdateMessageTitle(String title, int messageIdx) throws Exception {
		String sql = "UPDATE message SET title = ? WHERE message_idx = ?";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		
		pstmt.setString(1, title);
		pstmt.setInt(2, messageIdx);
		pstmt.executeUpdate();
		
		pstmt.close();
		conn.close();
	}
	
	//	메시지 내용 변경 
	//	파라미터 : message_idx, content
	//	특정 메시지 내용을 변경해주는 메서드
	public void UpdateMessageContent(String content, int messageIdx) throws Exception {
		String sql = "UPDATE message SET content = ?  WHERE message_idx = ?";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		
		pstmt.setString(1, content);
		pstmt.setInt(2, messageIdx);
		pstmt.executeUpdate();
		
		pstmt.close();
		conn.close();
	}
	
	//	메시지 등록
	//	input: projectIdx, writerIdx, title, content
	//	특정 프로젝트 안에 메시지를 등록하는 메서드
	public void CreateMessage(int projectIdx, int writerIdx, String title, String content) throws Exception {
		String sql = "INSERT INTO message(message_idx, project_idx, writer_idx, title, content, write_date)"
				+ " VALUES (seq_message_idx.nextval, ?, ?, ?, ?, sysdate)";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		
		pstmt.setInt(1, projectIdx);
		pstmt.setInt(2, writerIdx);
		pstmt.setString(3, title);
		pstmt.setString(4, content);
		pstmt.executeUpdate();
		
		pstmt.close();
		conn.close();
	}
	
	//	메시지 조회
	//	input: message_idx 
	//	output: name, title, profile_img, nickname, write_date, content
	//	특정 메시지를 조회하는 메서드
	public MessageDto getMessageDto(int messageIdx) throws Exception{
		String sql = "SELECT pjt.name, msg.title, mb.profile_img, mb.nickname, msg.write_date, msg.content"
				+ " FROM message msg"
				+ " INNER JOIN project pjt ON msg.project_idx = pjt.project_idx"
				+ " INNER JOIN member mb ON mb.member_idx = msg.writer_idx"
				+ " WHERE msg.message_idx = ?";
		
		MessageDto dto = null;
		
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		
		pstmt.setInt(1,messageIdx);
		ResultSet rs = pstmt.executeQuery();
		if(rs.next()) {
			String nickName = rs.getString("nickname");
			String profileImg = rs.getString("profile_img");
			String writeDate = rs.getString("write_date");
			String name = rs.getString("name");
			String title = rs.getString("title");
			String content = rs.getString("content");
			
			MemberDto md = new MemberDto(nickName, profileImg);
			
			ProjectDto pd = new ProjectDto();
			pd.setName(name);
			
			dto = new MessageDto(messageIdx,  title,  md,  content,  writeDate, pd);
			
		}
		rs.close();
		pstmt.close();
		conn.close();
		return dto;
	}
	
	//	특정 메시지의 작성자idx 조회
	//	파라미터 : messageIdx
	//	리턴값 : writer_idx
	//	특정 메시지의 작성자idx를 가져오는 메서드
	public int getMessageOwner(int messageIdx) throws Exception {
		String sql = "SELECT writer_idx FROM message WHERE message_idx = ?";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, messageIdx);
		int ownerIdx = 0;
		ResultSet rs = pstmt.executeQuery();
		if(rs.next()) {
			ownerIdx = rs.getInt("writer_idx");
		}
		rs.close();
		pstmt.close();
		conn.close();
		return ownerIdx;
	}
	
	public static void main(String[] args) throws Exception {
		
	}
}
