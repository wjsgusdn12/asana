package dto;

public class Alarm_settingAllDto {
	private int project_idx; //프로젝트 번호
	private int member_idx; //회원번호 
	private int sts_update; //상태 업데이트 0 : 체크 1 : 체크 안함
	private int message_alarm; //메시지 0 :체크 1: 체크 안함
	private int work; //작업추가됨 0 : 체크 1: 체크 안함 
	public Alarm_settingAllDto(int project_idx, int member_idx, int sts_update, int message_alarm, int work) {
		this.project_idx = project_idx;
		this.member_idx = member_idx;
		this.sts_update = sts_update;
		this.message_alarm = message_alarm;
		this.work = work;
	}
	
	public Alarm_settingAllDto() {
		
	}
	
	
	public int getProject_idx() {
		return project_idx;
	}
	public void setProject_idx(int project_idx) {
		this.project_idx = project_idx;
	}
	public int getMember_idx() {
		return member_idx;
	}
	public void setMember_idx(int member_idx) {
		this.member_idx = member_idx;
	}
	public int getSts_update() {
		return sts_update;
	}
	public void setSts_update(int sts_update) {
		this.sts_update = sts_update;
	}
	public int getMessage_alarm() {
		return message_alarm;
	}
	public void setMessage_alarm(int message_alarm) {
		this.message_alarm = message_alarm;
	}
	public int getWork() {
		return work;
	}
	public void setWork(int work) {
		this.work = work;
	}
	
	
	
	

}
