package dto;

public class GoalSelectAllDto {
	private int goalIdx; //목표번호 
	private int projectIdx; //해당 프로젝트 번호 
	private String title; //목표제목
	private int owner; // 목표 소유자 
	private Integer parentGoalIdx; //부모목표 
	private int periodIdx; //기간 
	private int range; //공개범위 1:비공개 0 : 공개 (디폴트)
	private String content; //설명
	private String startDate; //사용자지정 시작일 
	private String deadlineDate; //사용자지정 마감일 
	private int ficalYear; //연도 
	
	
	public GoalSelectAllDto(){}
	
	
	public GoalSelectAllDto(int goalIdx, int projectIdx, String title, int owner, Integer parentGoalIdx, int periodIdx,
			int range, String content, String startDate, String deadlineDate, int ficalYear) {
		this.goalIdx = goalIdx;
		this.projectIdx = projectIdx;
		this.title = title;
		this.owner = owner;
		this.parentGoalIdx = parentGoalIdx;
		this.periodIdx = periodIdx;
		this.range = range;
		this.content = content;
		this.startDate = startDate;
		this.deadlineDate = deadlineDate;
		this.ficalYear = ficalYear;
	}
	
	
	public int getGoalIdx() {
		return goalIdx;
	}
	public void setGoalIdx(int goalIdx) {
		this.goalIdx = goalIdx;
	}
	public int getProjectIdx() {
		return projectIdx;
	}
	public void setProjectIdx(int projectIdx) {
		this.projectIdx = projectIdx;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public int getOwner() {
		return owner;
	}
	public void setOwner(int owner) {
		this.owner = owner;
	}
	public Integer getParentGoalIdx() {
		return parentGoalIdx;
	}
	public void setParentGoalIdx(Integer parentGoalIdx) {
		this.parentGoalIdx = parentGoalIdx;
	}
	public int getPeriodIdx() {
		return periodIdx;
	}
	public void setPeriodIdx(int periodIdx) {
		this.periodIdx = periodIdx;
	}
	public int getRange() {
		return range;
	}
	public void setRange(int range) {
		this.range = range;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
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
	public int getFicalYear() {
		return ficalYear;
	}
	public void setFicalYear(int ficalYear) {
		this.ficalYear = ficalYear;
	}
	
	

	

}
