package dto;

public class Project_participantsAllDto {
	private int project_participants; // pk 
	private String participant_date; //참여된 시간 
	private int project_idx; //프로젝트 번호 
	private int member_idx; //회원번호
	private int authority; //권한 
	
	

	public int getProject_idx() {
		return project_idx;
	}
	
	public Project_participantsAllDto() {
		
	}



	public Project_participantsAllDto(int project_participants, String participant_date, int project_idx,
			int member_idx, int authority) {
		this.project_participants = project_participants;
		this.participant_date = participant_date;
		this.project_idx = project_idx;
		this.member_idx = member_idx;
		this.authority = authority;
	}



	public int getProject_participants() {
		return project_participants;
	}



	public void setProject_participants(int project_participants) {
		this.project_participants = project_participants;
	}



	public String getParticipant_date() {
		return participant_date;
	}



	public void setParticipant_date(String participant_date) {
		this.participant_date = participant_date;
	}



	public int getMember_idx() {
		return member_idx;
	}



	public void setMember_idx(int member_idx) {
		this.member_idx = member_idx;
	}



	public int getAuthority() {
		return authority;
	}



	public void setAuthority(int authority) {
		this.authority = authority;
	}



	public void setProject_idx(int project_idx) {
		this.project_idx = project_idx;
	}
	
	
	
	

	

}
