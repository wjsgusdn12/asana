package dto;

public class Related_workAllDto {
	private int goalIdx; //목표번호 
	private Integer projectIdx; //관련업무 (프로젝트)
	private Integer wamIdx; //관련 업무 (wam 번호)
	private Integer portfolioIdx; //관련업무 (포트폴리오)
	
	
	public Related_workAllDto(int goalIdx, Integer projectIdx, Integer wamIdx, Integer portfolioIdx) {
	
		this.goalIdx = goalIdx;
		this.projectIdx = projectIdx;
		this.wamIdx = wamIdx;
		this.portfolioIdx = portfolioIdx;
	}
	
	public Related_workAllDto() {
		
	}


	public int getGoalIdx() {
		return goalIdx;
	}


	public void setGoalIdx(int goalIdx) {
		this.goalIdx = goalIdx;
	}


	public Integer getProjectIdx() {
		return projectIdx;
	}


	public void setProjectIdx(Integer projectIdx) {
		this.projectIdx = projectIdx;
	}


	public Integer getWamIdx() {
		return wamIdx;
	}


	public void setWamIdx(Integer wamIdx) {
		this.wamIdx = wamIdx;
	}


	public Integer getPortfolioIdx() {
		return portfolioIdx;
	}


	public void setPortfolioIdx(Integer portfolioIdx) {
		this.portfolioIdx = portfolioIdx;
	}
	
	
	
	
	
	

}
