package dto;

public class WamDto {
	private int wamIdx;
	private int projectIdx;
	private String wamType;
	private String title;
	private int managerIdx;
	private int creatorIdx;
	private String deadlineDate;
	private String createDate;
	private String startDate;
	private String completeDate;
	private int wamParentIdx;
	private String content;
	private int followingIdx;
	private int approval;
	private String correctionDate;
	private int orders;
	private int sectionIdx;
	private ProjectDto projectDto;
	private MemberDto memberDto;
	
	
	public WamDto(String title, String deadlineDate, int wamIdx, ProjectDto pdto) {
		this.title=title;
		this.deadlineDate = deadlineDate;
		this.wamIdx=wamIdx;
		this.projectDto=pdto;
	}
	public WamDto( String title, String deadlineDate, ProjectDto projectDto) {
		this.title = title;
		this.deadlineDate = deadlineDate;
		this.projectDto = projectDto;
	}
	public WamDto(String wamType, String title, String deadlineDate, ProjectDto projectDto) {
		this.wamType = wamType;
		this.title = title;
		this.deadlineDate = deadlineDate;
		this.projectDto = projectDto;
	}
	public WamDto() {
		
	}
	
	public int getWamIdx() {
		return wamIdx;
	}
	public void setWamIdx(int wamIdx) {
		this.wamIdx = wamIdx;
	}
	public int getProjectIdx() {
		return projectIdx;
	}
	public void setProjectIdx(int projectIdx) {
		this.projectIdx = projectIdx;
	}
	public String getWamType() {
		return wamType;
	}
	public void setWamType(String wamType) {
		this.wamType = wamType;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public int getManagerIdx() {
		return managerIdx;
	}
	public void setManagerIdx(int managerIdx) {
		this.managerIdx = managerIdx;
	}
	public int getCreatorIdx() {
		return creatorIdx;
	}
	public void setCreatorIdx(int creatorIdx) {
		this.creatorIdx = creatorIdx;
	}
	public String getDeadlineDate() {
		return deadlineDate;
	}
	public void setDeadlineDate(String deadlineDate) {
		this.deadlineDate = deadlineDate;
	}
	public String getCreateDate() {
		return createDate;
	}
	public void setCreateDate(String createDate) {
		this.createDate = createDate;
	}
	public String getStartDate() {
		return startDate;
	}
	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}
	public String getCompleteDate() {
		return completeDate;
	}
	public void setCompleteDate(String completeDate) {
		this.completeDate = completeDate;
	}
	public int getWamParentIdx() {
		return wamParentIdx;
	}
	public void setWamParentIdx(int wamParentIdx) {
		this.wamParentIdx = wamParentIdx;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public int getFollowingIdx() {
		return followingIdx;
	}
	public void setFollowingIdx(int followingIdx) {
		this.followingIdx = followingIdx;
	}
	public int getApproval() {
		return approval;
	}
	public void setApproval(int approval) {
		this.approval = approval;
	}
	public String getCorrectionDate() {
		return correctionDate;
	}
	public void setCorrectionDate(String correctionDate) {
		this.correctionDate = correctionDate;
	}
	public int getOrders() {
		return orders;
	}
	public void setOrders(int orders) {
		this.orders = orders;
	}
	public int getSectionIdx() {
		return sectionIdx;
	}
	public void setSectionIdx(int sectionIdx) {
		this.sectionIdx = sectionIdx;
	}
	public ProjectDto getProjectDto() {
		return projectDto;
	}
	public void setProjectDto(ProjectDto projectDto) {
		this.projectDto = projectDto;
	}
	public MemberDto getMemberDto() {
		return memberDto;
	}
	public void setMemberDto(MemberDto memberDto) {
		this.memberDto = memberDto;
	}
	
}
