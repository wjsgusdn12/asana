package dto;

public class GoalOfGoal_statusGetDto {
	private String update_date; //업데이트 일시 
	private int status_idx; //상태번호 
	
	public GoalOfGoal_statusGetDto(String update_date, int status_idx) {
		this.update_date = update_date;
		this.status_idx = status_idx;
	}

	public String getUpdate_date() {
		return update_date;
	}

	public void setUpdate_date(String update_date) {
		this.update_date = update_date;
	}

	public int getStatus_idx() {
		return status_idx;
	}

	public void setStatus_idx(int status_idx) {
		this.status_idx = status_idx;
	}
	
	
	
	

}
