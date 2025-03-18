package dto;

public class Progress_statusAllDto {
	private int goal_idx; //목표번호 
	private int project_connection; //연결된 프로젝트 (프로젝트 번호)
	private int progress_status; //진행퍼센트 
	private String update_date; //업데이트 시간 

	public Progress_statusAllDto(int goal_idx, int project_connection, int progress_status, String update_date) {
		this.goal_idx = goal_idx;
		this.project_connection = project_connection;
		this.progress_status = progress_status;
		this.update_date = update_date;
	}

	public int getGoal_idx() {
		return goal_idx;
	}

	public void setGoal_idx(int goal_idx) {
		this.goal_idx = goal_idx;
	}

	public int getProject_connection() {
		return project_connection;
	}

	public void setProject_connection(int project_connection) {
		this.project_connection = project_connection;
	}

	public int getProgress_status() {
		return progress_status;
	}

	public void setProgress_status(int progress_status) {
		this.progress_status = progress_status;
	}

	public String getUpdate_date() {
		return update_date;
	}

	public void setUpdate_date(String update_date) {
		this.update_date = update_date;
	}
	
	
	
	
	
	

}
