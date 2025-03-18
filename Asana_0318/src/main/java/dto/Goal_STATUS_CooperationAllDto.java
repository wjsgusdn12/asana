package dto;

public class Goal_STATUS_CooperationAllDto {
	private int status_idx; //상태의 목표 
	private int member_idx; //협업참여자 
	
	public Goal_STATUS_CooperationAllDto(int status_idx, int member_idx) {
		this.status_idx = status_idx;
		this.member_idx = member_idx;
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
	
	
	
	

}
