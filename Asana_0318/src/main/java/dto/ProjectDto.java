package dto;

public class ProjectDto {
	private int projectIdx;
	private String name;
	private int memberIdx;
	private int range;
	private int defaultView;
	private String createDate;
	private String recentDate;
	private String startDate;
	private String deadlineDate;
	private String title;
	private String content;
	
	private PortfolioDto portfolioDto;
	private MemberDto memberDto;
	
	public MemberDto getMemberDto() {
		return memberDto;
	}
	public void setMemberDto(MemberDto memberDto) {
		this.memberDto = memberDto;
	}
	public ProjectDto(int projectIdx, String name, int memberIdx, int range, int defaultView, String createDate,
			String recentDate, String startDate, String deadlineDate, String title, String content) {
		this.projectIdx = projectIdx;
		this.name = name;
		this.memberIdx = memberIdx;
		this.range = range;
		this.defaultView = defaultView;
		this.createDate = createDate;
		this.recentDate = recentDate;
		this.startDate = startDate;
		this.deadlineDate = deadlineDate;
		this.title = title;
		this.content = content;
	}
	public ProjectDto() {
		
	}

	public int getProjectIdx() {
		return projectIdx;
	}

	public PortfolioDto getPortfolioDto() {
		return portfolioDto;
	}
	public void setPortfolioDto(PortfolioDto portfolioDto) {
		this.portfolioDto = portfolioDto;
	}
	public void setProjectIdx(int projectIdx) {
		this.projectIdx = projectIdx;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public int getMemberIdx() {
		return memberIdx;
	}

	public void setMemberIdx(int memberIdx) {
		this.memberIdx = memberIdx;
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

	public String getCreateDate() {
		return createDate;
	}

	public void setCreateDate(String createDate) {
		this.createDate = createDate;
	}

	public String getRecentDate() {
		return recentDate;
	}

	public void setRecentDate(String recentDate) {
		this.recentDate = recentDate;
	}

	public String getStartDate() {
		return startDate;
	}

	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}

	public String getDeadlineDate() {
		return deadlineDate;
	}

	public void setDeadlineDate(String deadlineDate) {
		this.deadlineDate = deadlineDate;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}
	
}
