package dto;

public class PortfolioDto {
	private int portfolioIdx;
	private String name;
	private int statusIdx;
	private int range;
	private int defaultView;
	private int priority;
	private int memberIdx;
	private int parentIdx;
	
	public PortfolioDto(int portfolioIdx, String name, int statusIdx, int range, int defaultView, int priority,
			int memberIdx, int parentIdx) {
		this.portfolioIdx = portfolioIdx;
		this.name = name;
		this.statusIdx = statusIdx;
		this.range = range;
		this.defaultView = defaultView;
		this.priority = priority;
		this.memberIdx = memberIdx;
		this.parentIdx = parentIdx;
	}
	public PortfolioDto() {
		
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
	public int getStatusIdx() {
		return statusIdx;
	}
	public void setStatusIdx(int statusIdx) {
		this.statusIdx = statusIdx;
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
	public int getPriority() {
		return priority;
	}
	public void setPriority(int priority) {
		this.priority = priority;
	}
	public int getMemberIdx() {
		return memberIdx;
	}
	public void setMemberIdx(int memberIdx) {
		this.memberIdx = memberIdx;
	}
	public int getParentIdx() {
		return parentIdx;
	}
	public void setParentIdx(int parentIdx) {
		this.parentIdx = parentIdx;
	}
	
}
