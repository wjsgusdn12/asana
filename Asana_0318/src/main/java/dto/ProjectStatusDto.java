package dto;

public class ProjectStatusDto {
	private int projectStatusIdx ; //프로젝트의 상태번호 
	private int statusIdx; //상태번호 
	private int projectIdx; //프로젝트 번호 
	private int memberIdx; //상태의 작성자 
	private String statusDate; //업데이트 시간 
	public ProjectStatusDto(int projectStatusIdx, int statusIdx, int projectIdx, int memberIdx, String statusDate) {
		
		this.projectStatusIdx = projectStatusIdx;
		this.statusIdx = statusIdx;
		this.projectIdx = projectIdx;
		this.memberIdx = memberIdx;
		this.statusDate = statusDate;
	}
	
	public ProjectStatusDto(int projectStatusIdx, int statusIdx, int memberIdx, String statusDate) {
		this.projectStatusIdx = projectStatusIdx;
		this.statusIdx = statusIdx;
		this.memberIdx = memberIdx;
		this.statusDate = statusDate;
	}
	
	public ProjectStatusDto() {
		
	}
	public int getProjectStatusIdx() {
		return projectStatusIdx;
	}
	public void setProjectStatusIdx(int projectStatusIdx) {
		this.projectStatusIdx = projectStatusIdx;
	}
	public int getStatusIdx() {
		return statusIdx;
	}
	public void setStatusIdx(int statusIdx) {
		this.statusIdx = statusIdx;
	}
	public int getProjectIdx() {
		return projectIdx;
	}
	public void setProjectIdx(int projectIdx) {
		this.projectIdx = projectIdx;
	}
	public int getMemberIdx() {
		return memberIdx;
	}
	public void setMemberIdx(int memberIdx) {
		this.memberIdx = memberIdx;
	}
	public String getStatusDate() {
		return statusDate;
	}
	public void setStatusDate(String statusDate) {
		this.statusDate = statusDate;
	}
	
	
	
	

}
