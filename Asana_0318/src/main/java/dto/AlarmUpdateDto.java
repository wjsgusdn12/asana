package dto;

public class AlarmUpdateDto {
	private int alarmIdx;
	private int memberIdx;
	private String content;

	public AlarmUpdateDto(int alarmIdx, int memberIdx, String content) {
		this.alarmIdx = alarmIdx;
		this.memberIdx = memberIdx;
		this.content = content;
	}
	
	public int getAlarmIdx() {
		return alarmIdx;
	}
	public void setAlarmIdx(int alarmIdx) {
		this.alarmIdx = alarmIdx;
	}
	public int getMemberIdx() {
		return memberIdx;
	}
	public void setMemberIdx(int memberIdx) {
		this.memberIdx = memberIdx;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	
	
	
	

}
