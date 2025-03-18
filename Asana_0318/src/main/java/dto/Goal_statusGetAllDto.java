package dto;

public class Goal_statusGetAllDto {
	private int goal_idx; //목표번호 
	private int status_idx; //상태번호 
	private int member_idx; //상태의 작성자 
	private String update_date; //업데이트 일시 
	public Goal_statusGetAllDto(int goal_idx, int status_idx, int member_idx, String update_date) {
		this.goal_idx = goal_idx;
		this.status_idx = status_idx;
		this.member_idx = member_idx;
		this.update_date = update_date;
	}
	public int getGoal_idx() {
		return goal_idx;
	}
	public void setGoal_idx(int goal_idx) {
		this.goal_idx = goal_idx;
	}
	public int getStatus_idx() {
		return status_idx;
	}
	public void setStatus_idx(int status_idx) {
		this.status_idx = status_idx;
	}
	public int getMember_idx() {
		return member_idx;
	}
	public void setMember_idx(int member_idx) {
		this.member_idx = member_idx;
	}
	public String getUpdate_date() {
		return update_date;
	}
	public void setUpdate_date(String update_date) {
		this.update_date = update_date;
	}
	
	
	
	
	
	

}
