package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import dto.MemberAllDto;
import dto.MemberDto;

public class MemberDao {
	public Connection getConnection() throws Exception {
		String driver = "oracle.jdbc.driver.OracleDriver";
		String url = "jdbc:oracle:thin:@gusdntkd.cafe24.com:1521:xe";
		String id = "asana_hw";
		String pw = "asana12345";

		Class.forName(driver);
		Connection conn = DriverManager.getConnection(url, id, pw);
		return conn;
	}

	//	네이버 추가
	//	파라미터 : naverId, email, nickname
	//	네이버로 가입하기를 할 때 naverId를 추가하는 메서드
	public void insertNaver(String naverId, String email, String nickname) throws Exception {
		String sql = "INSERT INTO member(member_idx, naver_id, email, nickname) "
				+ " VALUES(seq_member_idx.nextval,?,?,?)";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, naverId);
		pstmt.setString(2, email);
		pstmt.setString(3, nickname);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}

	//	네이버 아이디 있는지 조회
	//	파라미터 : naverId
	//	리턴값 : COUNT(1 or 0)
	//	1 or 0으로 네이버 아이디가 있는지 조회하는 메서드
	public Integer selectNaverId(String naverId) throws Exception {
		String sql = "SELECT COUNT(*) FROM member WHERE naver_id = ?";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, naverId);
		ResultSet rs = pstmt.executeQuery();
		Integer memberIdx = null;
		if (rs.next()) {
			memberIdx = rs.getInt(1); // memberIdx 가져오기
		}
		rs.close();
		pstmt.close();
		conn.close();
		return memberIdx;
	}

	//	네이버 아이디 member_idx 조회
	//	파라미터 : naverId
	//	리턴값 : member_idx
	//	네이버로 로그인 했을 때 해당 member_idx를 조회하는 메서드
	public Integer selectNaverIdForMemberIdx(String naverId) throws Exception {
		String sql = "SELECT member_idx FROM member WHERE naver_id = ?";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, naverId);
		ResultSet rs = pstmt.executeQuery();
		Integer memberIdx = null;
		if (rs.next()) {
			memberIdx = rs.getInt(1); // memberIdx 가져오기
		}
		rs.close();
		pstmt.close();
		conn.close();
		return memberIdx;
	}

	//	특정 멤버 삭제
	//	파라미터 : email
	//	특정 멤버를 삭제하는 메서드
	public void deleteMember(String email) throws Exception {
		String sql = " DELETE FROM member WHERE email=?";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, email);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}

//	회원가입 
//	파라미터 : email, pw
//  회원가입하는 메서드
//	public void registerMember(String email, String pw) throws Exception {
//		String sql = "INSERT INTO member(member_idx, email, pw) " + " VALUES (seq_member_idx.nextval, ?,?)";
//		Connection conn = getConnection();
//		PreparedStatement pstmt = conn.prepareStatement(sql);
//		pstmt.setString(1, email);
//		pstmt.setString(2, pw);
//		pstmt.executeUpdate();
//		pstmt.close();
//		conn.close();
//	}

	//	회원가입 (이메일 입력시 인증번호)
	//	파라미터 : email, code
	//	이메일로 가입시 해당 코드를 입력하면 회원가입이 완료되는 메서드
	public void insertMember(String email, int code) throws Exception {
		String sql = "INSERT INTO member(member_idx, email, code, code_date)"
				+ " VALUES (seq_member_idx.nextval, ?, ?, SYSDATE + INTERVAL '9' HOUR + INTERVAL '5' MINUTE)";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, email);
		pstmt.setInt(2, code);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}

	//	인증시간 재등록
	//	파라미터 : email
	//	인증시간 5분이 지나면 인증시간 초기화로 5분이 다시 시작되는 메서드
	public void resendCodeDate(String email) throws Exception {
		String sql = "UPDATE member SET code_date = (SYSDATE + INTERVAL '9' HOUR + INTERVAL '5' MINUTE) WHERE email = ?";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, email);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}

	//	codeDate 출력
	//	파라미터 : email
	//	리턴값 : code_date
	//	인증코드가 만들어진 시간을 출력하는 메서드
	public String showCodeTime(String email) throws Exception {
		String sql = "SELECT code_date FROM member WHERE email = ?";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, email);
		ResultSet rs = pstmt.executeQuery();
		String time = null;
		if (rs.next()) {
			time = rs.getString("code_date");
		}
		rs.close();
		pstmt.close();
		conn.close();
		return time;
	}

	//	인증번호 확인 
	//	파라미터 : email, inputCode
	//	리턴값 : code
	//	인증번호를 확인하는 메서드
	public boolean checkCode(String email, int inputCode) throws Exception {
		String sql = "SELECT code FROM member WHERE email = ?";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, email);
		ResultSet rs = pstmt.executeQuery();
		if (rs.next()) {
			// DB에서 가져온 인증번호
			int storedCode = rs.getInt("code");

			// 입력된 코드와 DB에서 가져온 코드 비교
			return storedCode == inputCode;
		}
		pstmt.close();
		conn.close();
		return false;
	}

	// 	인증코드 업데이트 메서드
	//	파라미터 : newCode, email
	//	새로운 인증코드를 받는 메서드
	public void updateMemberCode(Integer newCode, String email) throws Exception {
		String sql = "UPDATE member set code = ? WHERE email = ?";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		if (newCode == null) {
			pstmt.setNull(1, java.sql.Types.INTEGER); // null을 넣고 타입을 명시적으로 지정
		} else {
			pstmt.setInt(1, newCode);
		}
		pstmt.setString(2, email);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}

	// 	인증날짜(null로) 업데이트
	//	파라미터 : email
	//	특정 멤버의 인증날짜를 null로 바꾸는 메서드
	public void updateCodeDate(String email) throws Exception {
		String sql = "UPDATE member SET code_date = null WHERE email = ?";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, email);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}
	
	//	로그인
	//	파라미터 : email
	//	리턴값 : member_idx, email, pw, nickname, profile_img, join_date, alarm, start_date, deadline_date, alarm_send, code, code_date
	//	특정 멤버의 정보를 조회하는 메서드
	public MemberDto getMember(String email) throws Exception {
		String sql = "SELECT member_idx, email, pw, nickname, profile_img, join_date, "
				+ " alarm, start_date, deadline_date, alarm_send, code, code_date " + " FROM member WHERE email = ?";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, email);
		// pstmt.setString(2, pw);

		MemberDto dto = null;
		ResultSet rs = pstmt.executeQuery();
		if (rs.next()) {
			int memberIdx = rs.getInt("member_idx");
			String id = rs.getString("email");
			String password = rs.getString("pw");
			String nickname = rs.getString("nickname");
			String profileImg = rs.getString("profile_img");
			String joinDate = rs.getString("join_date");
			int alarm = rs.getInt("alarm");
			String startDate = rs.getString("start_date");
			String deadlineDate = rs.getString("deadline_date");
			int alarmSend = rs.getInt("alarm_send");
			Integer code = (Integer)rs.getObject("code"); // null을 처리하기 위해 getObject 사용
			String codeDate = rs.getString("code_date"); // null을 처리하기 위해 getObject 사용

			dto = new MemberDto(memberIdx, email, password, nickname, profileImg, joinDate, alarm, startDate,
					deadlineDate, alarmSend, deadlineDate, code, codeDate);
		}
		rs.close();
		pstmt.close();
		conn.close();
		return dto;
	}

	//	아이디 확인   
	//	파라미터 : email
	//	리턴값 : member_idx
	//	아이디가 맞는지 확인하는 메서드
	public boolean CheckMember(String email) throws Exception {
		String sql = "SELECT member_idx FROM member WHERE email = ?";
		Connection conn = getConnection();

		boolean login = false;

		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, email);
		ResultSet rs = pstmt.executeQuery();
		login = rs.next();

		rs.close();
		pstmt.close();
		conn.close();

		return login;
	}
	
	//	멤버가 있는지 확인
	//	파라미터 : email
	//	리턴값 : COUNT(1 or 0)
	//	로그인한 멤버가 있는지 확인하는 메서드
	public int loginCheckMember(String email) throws Exception {
		String sql = "SELECT COUNT(*) FROM member WHERE email = ?";
		Connection conn = getConnection();

		boolean login = false;

		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, email);
		ResultSet rs = pstmt.executeQuery();
		int cnt = 0;
		if (rs.next()) {
			cnt = rs.getInt(1);
		}

		rs.close();
		pstmt.close();
		conn.close();
		return cnt;
	}

	//	프로필 이미지 삭제
	//	파라미터 : memberIdx
	//	특정 멤버의 프로필 이미지를 삭제하는 메서드
	public void deleteProfile(int memberIdx) throws Exception {
		String sql = "UPDATE member SET profile_img = null WHERE member_idx = ?";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, memberIdx);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}
	
	//	상대방 프로필 노출
	//	파라미터 : member_id
	//	리턴값 : email, nickname, profile_img
	//	특정 멤버의 프로필을 보여주는 메서드
	public MemberDto getOtherMemberProfile(int memberIdx) throws Exception {
		String sql = "SELECT email, nickname, profile_img FROM member WHERE member_idx = ?";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, memberIdx);

		MemberDto dto = null;
		ResultSet rs = pstmt.executeQuery();
		if (rs.next()) {
			String email = rs.getString("email");
			String nickname = rs.getString("nickname");
			String profileImg = rs.getString("profile_img");

			dto = new MemberDto();
			dto.setEmail(email);
			dto.setNickname(nickname);
			dto.setProfileImg(profileImg);
		}
		rs.close();
		pstmt.close();
		conn.close();
		return dto;
	}
	
	//	닉네임 수정
	//	파라미터 : member_idx, nickname
	//	특정 멤버의 닉네임을 수정하는 메서드
	public void UpdateNickname(String nickname, int memberIdx) throws Exception {
		String sql = " UPDATE member SET nickname = ?" + " WHERE member_idx = ?";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, nickname);
		pstmt.setInt(2, memberIdx);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}
	
	//	프로필 보여주기
	//	input: member_idx(숫자)
	//	output: nickname, email, my_introduce, profile_img, start_date, deadline_date, alarm
	//	특정 멤버의 프로필을 보여주는 메서드
	public MemberDto getMemberDto(int memberIdx) throws Exception {
		String sql = "SELECT nickname, email, my_introduce, profile_img, start_date, deadline_date, alarm"
				+ " FROM member WHERE member_idx = ?";

		MemberDto dto = null;
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, memberIdx);
		ResultSet rs = pstmt.executeQuery();
		while (rs.next()) {
			String nickname = rs.getString("nickname");
			String email = rs.getString("email");
			String myIntroduce = rs.getString("my_introduce");
			String profileImg = rs.getString("profile_img");
			String startDate = rs.getString("start_date");
			String deadlineDate = rs.getString("deadline_date");
			int alarm = rs.getInt("alarm");
			dto = new MemberDto();
			dto.setNickname(nickname);
			dto.setEmail(email);
			dto.setMyIntroduce(myIntroduce);
			dto.setProfileImg(profileImg);
			dto.setStartDate(startDate);
			dto.setDeadlineDate(deadlineDate);
			dto.setAlarm(alarm);
		}
		rs.close();
		pstmt.close();
		conn.close();

		return dto;
	}
	
	// 멤버 정보 조회 
	// 파라미터 : memberIdx
	// 리턴값 : email, pw, nickname, profile_img, join_date, alarm , start_date, deadline_date, alarm_send, my_introduce
	// 특정 멤버의 정보 조회하는 메서드 
	public MemberAllDto getMemberAllDto(int memberIdx) throws Exception {
		String sql =" SELECT email, pw, nickname, profile_img, join_date, alarm , start_date, deadline_date, alarm_send, my_introduce"
				+ " FROM member"
				+ " WHERE member_idx=?";
		
		MemberAllDto dto = null; 
		Connection conn = getConnection();
		PreparedStatement pstmt= conn.prepareStatement(sql);
		pstmt.setInt(1,memberIdx);
		ResultSet rs= pstmt.executeQuery();
		if(rs.next()) {
			 String email = rs.getString("email");
			 int pw =rs.getInt("pw"); 
			 String nickname = rs.getString("nickname"); 
			 String profile_img = rs.getString("profile_img"); 
			 String join_date = rs.getString("join_date");
			 int alarm = rs.getInt("alarm"); 
			 String start_date = rs.getString("start_date"); 
			 String deadline_date = rs.getString("deadline_date"); 
			 int alarm_send = rs.getInt("alarm"); 
			 String my_introduce = rs.getString("my_introduce"); 
			 dto = new MemberAllDto(memberIdx, email, pw, nickname, profile_img, join_date, alarm, start_date, deadline_date, alarm_send, my_introduce);
			 
		}
		
		rs.close();
		pstmt.close();
		conn.close();
		
		return dto;
	}

	//	내 소개 편집
	//	파라미터 : my_introduce, member_idx
	//	특정 멤버의 내 소개를 편집하는 메서드
	public void UpdateMyIntroduce(String myIntroduce, int memberIdx) throws Exception {
		String sql = "UPDATE member SET my_introduce = ? " + " WHERE member_idx = ?";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, myIntroduce);
		pstmt.setInt(2, memberIdx);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}
	
	//	부재중 여부 확인
	//	파라미터 : member_idx
	//	리턴값 : 1 or 0  
	//	1 or 0 으로 부재중 여부를 확인하는 메서드
	public int getAlarmIng(int memberIdx) throws Exception {
		String sql = "SELECT CASE" + " WHEN alarm = 1 THEN 1 " + " WHEN alarm = 0 THEN 0 " + " END AS alarm"
				+ " FROM member" + " WHERE member_idx = ?";
		Connection conn = getConnection();

		int ret = 3;
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, memberIdx);
		ResultSet rs = pstmt.executeQuery();
		if (rs.next()) {
			ret = rs.getInt("alarm");
		}
		rs.close();
		pstmt.close();
		conn.close();

		return ret;
	}

	//	부재중으로 설정
	//	input: memberIdx
	//	부재중으로 설정하는 메서드
	public void setAlarm(int memberIdx) throws Exception {
		String sql = "UPDATE member SET alarm = 1 WHERE member_idx = ?";
		Connection conn = getConnection();

		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, memberIdx);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}
	
	//	부재종료로 설정
	//	파라미터 : memberIdx
	//	부재종료로 설정하는 메서드
	public void setAlarmEnd(int memberIdx) throws Exception {
		String sql = "UPDATE member SET alarm = 0 WHERE member_idx = ?";
		Connection conn = getConnection();

		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, memberIdx);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}
	
	//	부재중 시작일 업데이트
	//	파라미터 : start_date, memberIdx
	//	부재중 시작일을 업데이트하는 메서드
	public void UpdateStartDate(String startDate, int memberIdx) throws Exception {
		String sql = "UPDATE member " + " SET start_date = TO_DATE(? , 'YYYY/MM/DD/')" + " WHERE member_idx = ?";
		Connection conn = getConnection();

		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, startDate);
		pstmt.setInt(2, memberIdx);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}
	
	//	부재중 종료일 업데이트
	//	파라미터 : deadlineDate, memberIdx
	//	부재중 종료일을 업데이트하는 메서드
	public void UpdateDeadlineDate(String deadlineDate, int memberIdx) throws Exception {
		String sql = "UPDATE member " + " SET deadline_date = TO_DATE(? , 'YYYY/MM/DD/')" + " WHERE member_idx = ?";
		Connection conn = getConnection();

		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, deadlineDate);
		pstmt.setInt(2, memberIdx);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}
	
	//	내 프로필 보기
	//	파라미터 : memberIdx
	//	리턴값 : profile_img, nickname
	//	특정 멤버의 프로필을 보여주는 메서드
	public MemberDto getMyProfile(int memberIdx) throws Exception {
		String sql = "SELECT profile_img, nickname FROM member WHERE member_idx = ?";
		Connection conn = getConnection();

		MemberDto dto = null;
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, memberIdx);
		ResultSet rs = pstmt.executeQuery();
		if (rs.next()) {
			String profileImg = rs.getString("profile_img");
			String nickname = rs.getString("nickname");

			dto = new MemberDto();
			dto.setProfileImg(profileImg);
			dto.setNickname(nickname);
		}
		rs.close();
		pstmt.close();
		conn.close();

		return dto;
	}

	//	멤버 조회 
	//	파라미터 : name
	//	리턴값 : profile_img, nickname
	//	닉네임을 통해 멤버 조회하는 메서드 
	public ArrayList<MemberDto> MemberDtoList(String name) throws Exception {
		String sql = "SELECT profile_img, nickname FROM member WHERE nickname LIKE ?";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, "%" + name + "%");
		ArrayList<MemberDto> list = new ArrayList<MemberDto>();
		ResultSet rs = pstmt.executeQuery();
		while (rs.next()) {
			String profile = rs.getString("profile_img");
			String nickname = rs.getString("nickname");
			MemberDto dto = new MemberDto();
			dto.setNickname(nickname);
			dto.setProfileImg(profile);
			list.add(dto);
		}
		rs.close();
		pstmt.close();
		conn.close();
		return list;
	}
	
	//	멤버 조회 
	//	파라미터 : email
	//	리턴값 : member_idx
	//	이메일로 멤버 조회하는 메서드 
	public int getMemberIdx(String email) throws Exception {
		String sql = "SELECT member_idx FROM member WHERE email = ?";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, email);
		int memberIdx = 0;
		ResultSet rs = pstmt.executeQuery();
		if (rs.next()) {
			memberIdx = rs.getInt("member_idx");
		}
		rs.close();
		pstmt.close();
		conn.close();
		return memberIdx;
	}

	// 멤버 조회 
	// 파라미터 : email
	// 리턴값 : member_idx
	// 이메일로 멤버 조회하는 메서드 
	public String loginEmail(int memberIdx) throws Exception {
		String sql = "SELECT email FROM member WHERE member_idx=?";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, memberIdx);
		ResultSet rs = pstmt.executeQuery();
		String email = null;
		if (rs.next()) {
			email = rs.getString("email");
		}
		rs.close();
		pstmt.close();
		conn.close();
		return email;
	}

	// 멤버 닉네임 조회 
	// 파라미터 :  memberIdx 
	// 리턴값 : nickname
	// 특정 멤버 닉네임 조회하는 메서드 
	public String loginNickname(int memberIdx) throws Exception {
		String sql = "SELECT nickname FROM member WHERE member_idx=?";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, memberIdx);
		ResultSet rs = pstmt.executeQuery();
		String nickname = null;
		if (rs.next()) {
			nickname = rs.getString("nickname");
		}
		rs.close();
		pstmt.close();
		conn.close();
		return nickname;
	}

	//	프로필이미지 조회
	//	파라미터 : memberIdx
	//	리턴값 : prfile_img
	//	특정 멤버의 프로필이미지를 조회하는 메서드
	public String loginProfileImg(int memberIdx) throws Exception {
		String sql = "SELECT profile_img FROM member WHERE member_idx=?";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, memberIdx);
		ResultSet rs = pstmt.executeQuery();
		String profileImg = null;
		if (rs.next()) {
			profileImg = rs.getString("profile_img");
		}
		rs.close();
		pstmt.close();
		conn.close();
		return profileImg;
	}

	//	현시간 출력
	//	리턴값 : sysdate (**시**분)
	//	현재시간을 **시**분으로 출력해주는 메서드
	public String nowTime() throws Exception {
		String sql = "SELECT sysdate FROM dual";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		ResultSet rs = pstmt.executeQuery();
		String nowTime = null;
		if (rs.next()) {
			nowTime = rs.getString("sysdate");
		}
		rs.close();
		pstmt.close();
		conn.close();
		return (nowTime.split(" ")[1]).split(":")[0] + "시 " + (nowTime.split(" ")[1]).split(":")[1] + "분";
	}

	//	현일자 출력
	//	리턴값 : sysdate (**월 **일)
	//	현재날짜을 **월**일로 출력해주는 메서드
	public String nowDay() throws Exception {
		String sql = "SELECT sysdate FROM dual";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		ResultSet rs = pstmt.executeQuery();
		String nowTime = null;
		if (rs.next()) {
			nowTime = rs.getString("sysdate");
		}
		rs.close();
		pstmt.close();
		conn.close();
		return (nowTime.split(" ")[0]).split("-")[1] + "월 " + (nowTime.split(" ")[0]).split("-")[2] + "일";
	}

	// loginCheck(id, pw) : 로그인 체크 기능
	// 파라미터 id : 입력한 id 값
	// 파라미터 pw : 입력한 pw 값
	// 리턴 값 : 로그인 성공(true), 실패(false)
	public boolean loginCheck(String id, String pw) throws Exception {
		String sql = "SELECT COUNT(*) FROM member1 WHERE id=? AND pw=?";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, id);
		pstmt.setString(2, pw);
		ResultSet rs = pstmt.executeQuery();
		boolean result = false;
		if (rs.next()) {
			result = rs.getInt(1) == 1;
		}
		rs.close();
		pstmt.close();
		conn.close();
		return result;
	}

	// 멤버 즐겨찾기 추가
	// 파라미터 : 로그인된 member_idx, 즐겨찾기할 member_idx
	// 로그인멤버가 측정 멤버를 즐겨찾기 추가하는 메서드
	public void addFavoritesMember(int loginMemberIdx, int otherLoginMemberIdx) throws Exception {
		String sql = "INSERT INTO favorites (member_idx, favorites_member_idx) VALUES (?,?)";

		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(loginMemberIdx, 1);
		pstmt.setInt(otherLoginMemberIdx, 2);
		pstmt.executeUpdate();

		pstmt.close();
		conn.close();
	}

	// 멤버 즐겨찾기 삭제
	// 파라미터 : 로그인된 member_idx, 즐겨찾기할 member_idx
	// 로그인멤버가 측정 멤버를 즐겨찾기 삭제하는 메서드
	public void removeFavoritesMember(int loginMemberIdx, int otherLoginMemberIdx) throws Exception {
		String sql = "DELETE FROM favorites WHERE member_idx=? AND favorites_member_idx=?";

		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(loginMemberIdx, 1);
		pstmt.setInt(otherLoginMemberIdx, 2);
		pstmt.executeUpdate();

		pstmt.close();
		conn.close();
	}

	// 즐겨찾기 목록조회
	// 파라미터 : 로그인된 member_idx
	// 리턴 값 : profile_img, nickname, member_idx
	// 로그인멤버의 즐겨찾기 멤버 목록을 조회하는 메서드
	public ArrayList<MemberDto> favoritesMemberList(int loginMemberIdx) throws Exception {
		String sql = "SELECT m2.profile_img, m2.nickname, m2.member_idx" + " FROM favorites f"
				+ " INNER JOIN member m ON f.member_idx = m.member_idx"
				+ " INNER JOIN member m2 ON f.favorites_member_idx = m2.member_idx" + " WHERE f.member_idx = ?"
				+ " AND f.favorites_member_idx IS NOT NULL" + " ORDER BY m2.member_idx ASC";

		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, loginMemberIdx);
		ResultSet rs = pstmt.executeQuery();
		ArrayList<MemberDto> list = new ArrayList<MemberDto>();
		while (rs.next()) {
			String profileImg = rs.getString("profile_img");
			String nickName = rs.getString("nickname");
			int memberIdx = rs.getInt("member_idx");
			MemberDto dto = new MemberDto();
			dto.setProfileImg(profileImg);
			dto.setNickname(nickName);
			dto.setMemberIdx(memberIdx);
			list.add(dto);
		}
		rs.close();
		pstmt.close();
		conn.close();

		return list;
	}

	// 즐겨찾기 유무 상태 (0 혹은 1)
	// 파라미터 : 로그인된 member_idx, 확인할 member_idx
	// 리턴 값 : 0 혹은 1
	// 로그인멤버의 즐겨찾기멤버인지 체크하는 메서드 (0이면 즐겨찾기중이 아닌 멤버, 1이면 즐겨찾기중인 멤버)
	public int favoritesMemberIdxCheckByLoginMemberIdx(int loginMemberIdx, int memberIdx) throws Exception {
		String sql = "SELECT COUNT(*)" + " FROM favorites" + " WHERE member_idx=? AND favorites_member_idx=?";

		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, loginMemberIdx);
		pstmt.setInt(2, memberIdx);
		ResultSet rs = pstmt.executeQuery();
		int count = 0;
		if (rs.next()) {
			count = rs.getInt(1);
		}
		rs.close();
		pstmt.close();
		conn.close();
		return count;
	}

	// 초대발송 후 DB 초대코드 선 등록
	// 파라미터 : code
	// 특정 이메일에게 초대를 발송한 후 DB에 초대코드를 먼저 등록하는 메서드
	public void insertInviteCode(int code) throws Exception {
		String sql = "INSERT INTO member(member_idx, code) VALUES (seq_member_idx.nextval, ?)";

		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, code);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}

	// 초대 받은 이메일 초대코드 유효체크
	// 파라미터 : code
	// 리턴값 : true 혹은 false
	// DB의 초대코드와 초대받은 이메일의 초대코드가 동일한지 체크하는 메서드
	public boolean inviteCodeCheck(int code) throws Exception {
		String sql = "SELECT COUNT(*) FROM member WHERE code=?";
		boolean codeCheck = false;
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, code);
		ResultSet rs = pstmt.executeQuery();
		int cnt = 0;
		if (rs.next()) {
			cnt = rs.getInt(1);
		}
		rs.close();
		pstmt.close();
		conn.close();
		if (cnt == 1) {
			return true;
		} else {
			return false;
		}
	}

	// 초대 받은 이메일 DB 등록
	// 파라미터 : email, code
	// DB의 초대코드와 초대받은 이메일의 초대코드가 동일하면 초대코드를 null로 변경 후 DB에 초대받은 이메일을 등록하는 메서드
	public void updateInviteEmail(String email, int code) throws Exception {
		String sql = "UPDATE member SET email=?, nickname=?, code='' WHERE code=?";

		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, email);
		pstmt.setString(2, email);
		pstmt.setInt(3, code);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}

	// 초대된 이메일의 member_idx 등록
	// 파라미터 : email
	// 리턴값 : member_idx
	// 초대되어 추가된 이메일의 member_idx 를 조회하는 메서드
	public int getInviteMemberIdx(String email) throws Exception {
		String sql = "SELECT member_idx FROM member WHERE email=?";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, email);
		ResultSet rs = pstmt.executeQuery();
		int memberIdx = 0;
		if (rs.next()) {
			memberIdx = rs.getInt("member_idx");
		}
		rs.close();
		pstmt.close();
		conn.close();
		return memberIdx;
	}

	// 초대된 멤버 내작업공간에 추가
	// 파라미터 : member_idx
	// 초대되어 추가된 이메일의 member_idx를 초대한 멤버가 소속된 내작업공간으로 추가하는 메서드
	public void AddNewMemberIdxToMyWorkspace(int memberIdx) throws Exception {
		String sql = "INSERT INTO my_workspace (owner_idx, member_idx) VALUES (1, ?)";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, memberIdx);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}

	public static void main(String[] args) throws Exception {
		
	}
}
