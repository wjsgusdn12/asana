package dto;

import java.sql.ResultSet;

public class MemberDto {
	private int memberIdx;
	private String email;
	private String pw;
	private String nickname;
	private String profileImg;
	private String joinDate;
	private int alarm;
	private String startDate;
	private String deadlineDate;
	private int alarmSend;
	private String myIntroduce;
	private Integer code;
	private String codeDate;
	private String naverId;
	
	public MemberDto() {
		
	}

	public MemberDto(int memberIdx, String email, String pw, String nickname, String profileImg, String joinDate,
			int alarm, String startDate, String deadlineDate, int alarmSend, String myIntroduce, Integer code,
			String codeDate) {
		super();
		this.memberIdx = memberIdx;
		this.email = email;
		this.pw = pw;
		this.nickname = nickname;
		this.profileImg = profileImg;
		this.joinDate = joinDate;
		this.alarm = alarm;
		this.startDate = startDate;
		this.deadlineDate = deadlineDate;
		this.alarmSend = alarmSend;
		this.myIntroduce = myIntroduce;
		this.code = code;
		this.codeDate = codeDate;
	}
	
	public MemberDto(String nickname, String profileImg) {
		this.nickname = nickname;
		this.profileImg = profileImg;
	}


	public int getMemberIdx() {
		return memberIdx;
	}

	public void setMemberIdx(int memberIdx) {
		this.memberIdx = memberIdx;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getPw() {
		return pw;
	}

	public void setPw(String pw) {
		this.pw = pw;
	}

	public String getNickname() {
		return nickname;
	}

	public void setNickname(String nickname) {
		this.nickname = nickname;
	}

	public String getProfileImg() {
		return profileImg;
	}

	public void setProfileImg(String profileImg) {
		this.profileImg = profileImg;
	}

	public String getJoinDate() {
		return joinDate;
	}

	public void setJoinDate(String joinDate) {
		this.joinDate = joinDate;
	}

	public int getAlarm() {
		return alarm;
	}

	public void setAlarm(int alarm) {
		this.alarm = alarm;
	}

	public String getStartDate() {
		return startDate;
	}

	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}

	public String getDeadlineDate() {
		return deadlineDate;
	}

	public void setDeadlineDate(String deadlineDate) {
		this.deadlineDate = deadlineDate;
	}

	public int getAlarmSend() {
		return alarmSend;
	}

	public void setAlarmSend(int alarmSend) {
		this.alarmSend = alarmSend;
	}

	public String getMyIntroduce() {
		return myIntroduce;
	}

	public void setMyIntroduce(String myIntroduce) {
		this.myIntroduce = myIntroduce;
	}

	public Integer getCode() {
		return code;
	}

	public void setCode(Integer code) {
		this.code = code;
	}

	public String getCodeDate() {
		return codeDate;
	}

	public void setCodeDate(String codeDate) {
		this.codeDate = codeDate;
	}

	public String getNaverId() {
		return naverId;
	}

	public void setNaverId(String naverId) {
		this.naverId = naverId;
	}

	
	
}
