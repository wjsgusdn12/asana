package dto;

public class MemberAllDto {
	private int memberIdx; //회원번호 
	private String email; //이메일 
	private int pw; //비밀번호 
	private String nickname; //닉네임 
	private String profileImg; //프로필 이미지 
	private String joinDate; //가입일 
	private int alarm; //부재여부 
	private String startDate; // 부재시작일 
	private String deadlineDate; //부재 종료일 
	private int alarmSend; //부재시 알림 보내기 
	private String myIntroduce; //내 소개 
	public MemberAllDto() {
		
	}
	
	
	public MemberAllDto(int memberIdx, String email, int pw, String nickname, String profileImg, String joinDate,
			int alarm, String startDate, String deadlineDate, int alarmSend, String myIntroduce) {
		
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
	public int getPw() {
		return pw;
	}
	public void setPw(int pw) {
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
	
	
	
	
	
	
	

}
