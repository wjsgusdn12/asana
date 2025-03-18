package dto;

public class PortfolioAllDto {
	private int portfolioIdx; //포트폴리오 idx
	private String name; //포트폴리오 이름 
	private Integer status_idx; //포트폴리오의 상태 번호 
	private int range; //공개범위 
	private int defaultView; //기본보기 
	private Integer priority; //우선순위 
	private int memberIdx; //소유자 (회원번호 )
	private Integer parentIdx; //부모 포트폴리오 번호 
	
	public PortfolioAllDto(int portfolioIdx, String name, Integer status_idx, int range, int defaultView,
			Integer priority, int memberIdx, Integer parentIdx) {
		
		this.portfolioIdx = portfolioIdx;
		this.name = name;
		this.status_idx = status_idx;
		this.range = range;
		this.defaultView = defaultView;
		this.priority = priority;
		this.memberIdx = memberIdx;
		this.parentIdx = parentIdx;
	}
	public PortfolioAllDto() {
		
	}
	
	public PortfolioAllDto(int portfolioIdx, String name, Integer status_idx, int memberIdx) {
		this.portfolioIdx = portfolioIdx;
		this.name = name;
		this.status_idx = status_idx;
		this.memberIdx = memberIdx;
	}
	
	

	public int getPortfolioIdx() {
		return portfolioIdx;
	}

	public void setPortfolioIdx(int portfolioIdx) {
		this.portfolioIdx = portfolioIdx;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Integer getStatus_idx() {
		return status_idx;
	}

	public void setStatus_idx(Integer status_idx) {
		this.status_idx = status_idx;
	}

	public int getRange() {
		return range;
	}

	public void setRange(int range) {
		this.range = range;
	}

	public int getDefaultView() {
		return defaultView;
	}

	public void setDefaultView(int defaultView) {
		this.defaultView = defaultView;
	}

	public Integer getPriority() {
		return priority;
	}

	public void setPriority(Integer priority) {
		this.priority = priority;
	}

	public int getMemberIdx() {
		return memberIdx;
	}

	public void setMemberIdx(int memberIdx) {
		this.memberIdx = memberIdx;
	}

	public Integer getParentIdx() {
		return parentIdx;
	}

	public void setParentIdx(Integer parentIdx) {
		this.parentIdx = parentIdx;
	}
	
	
	
	
	

}
