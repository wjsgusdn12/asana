package dto;

public class Portfolio_CompositionAllDto {
	private int portfolioIdx; //부모 포트폴리오 번호 
	private int projectIdx; //자식 프로젝트 번호 
	
	public Portfolio_CompositionAllDto(int portfolioIdx, int projectIdx) {
		this.portfolioIdx = portfolioIdx;
		this.projectIdx = projectIdx;
	}
	public Portfolio_CompositionAllDto() {
		
	}

	public int getPortfolioIdx() {
		return portfolioIdx;
	}

	public void setPortfolioIdx(int portfolioIdx) {
		this.portfolioIdx = portfolioIdx;
	}

	public int getProjectIdx() {
		return projectIdx;
	}

	public void setProjectIdx(int projectIdx) {
		this.projectIdx = projectIdx;
	}
	
	
	
	

}
