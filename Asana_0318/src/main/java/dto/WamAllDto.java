package dto;

public class WamAllDto {
	private int wamIdx; //wam번호 
	private int projectIdx; //프로젝트idx
	private char wamType; //wam타입 
	private String title; //이름(제목)
	private int managerIdx; //담당자 idx
	private int creatorIdx; //생성자 idx 
	private String deadlineDate; //마감일 
	private String createDate; //생성일 
	private String startDate; //시작일 
	private String completeDate; //완료일 
	private Integer wamParentIdx; //부모 wam 번호 
	private String content; //내용 
	private Integer followingIdx; //후속 
	private Integer approval; // 승인
	private String correctionDate; //수정일자 
	private Integer orders; //섹션안 wam 순서 
	private Integer sectionIdx; //섹션 idx 
	private Integer fileIdx; //파일 idx 
	
	
	
	
	

	public WamAllDto(int projectIdx, int wamIdx, char wamType, String title, String completeDate, Integer approval) {
		super();
		this.wamIdx = wamIdx;
		this.projectIdx = projectIdx;
		this.wamType = wamType;
		this.title = title;
		this.completeDate = completeDate;
		this.approval = approval;
	}

	public WamAllDto(int wamIdx, char wamType, int projectIdx, String title, String completeDate, Integer approval) {
		
		this.wamIdx = wamIdx;
		this.wamType = wamType;
		this.title = title;
		this.projectIdx = projectIdx;
		this.completeDate = completeDate;
		this.approval = approval;
	}

	public WamAllDto(int wamIdx, char wamType, String title, int managerIdx, String deadlineDate) {
		this.wamIdx= wamIdx;
		this.wamType = wamType;
		this.title= title;
		this.managerIdx=managerIdx;
		this.deadlineDate=deadlineDate;
		
	}
	
	public WamAllDto(int wamIdx, char wamType, String title, int managerIdx, String deadlineDate, Integer approval) {
		this.approval = approval;
		this.wamIdx= wamIdx;
		this.wamType = wamType;
		this.title= title;
		this.managerIdx=managerIdx;
		this.deadlineDate=deadlineDate;
		
	}
	
	
	
	
	
	public WamAllDto(int wamIdx, char wamType, String title, int managerIdx, String startDate, String deadlineDate, String completeDate, Integer approval, Integer followingIdx) {
		this.wamIdx= wamIdx;
		this.wamType = wamType;
		this.title= title;
		this.managerIdx=managerIdx;
		this.startDate=startDate;
		this.deadlineDate=deadlineDate;
		this.completeDate=completeDate;
		this.approval=approval;
		this.followingIdx=followingIdx;
		
		
	}
	
	public WamAllDto(char wamType, String title, int projectIdx , String completeDate) {
		this.wamType = wamType;
		this.title= title;
		this.completeDate=completeDate;
		this.projectIdx=projectIdx;
		
	}
	
	public WamAllDto(int wamIdx, char wamType, String title, int managerIdx, String startDate, String deadlineDate, String completeDate, Integer approval, Integer followingIdx, int creatorIdx, String createDate, String correctionDate) {
		this.approval = approval;
		this.wamIdx= wamIdx;
		this.wamType = wamType;
		this.title= title;
		this.managerIdx=managerIdx;
		this.deadlineDate=deadlineDate;
		this.startDate = startDate;
		this.completeDate = completeDate;
		this.followingIdx = followingIdx;
		this.creatorIdx = creatorIdx;
		this.createDate = createDate;
		this.correctionDate = correctionDate;
		
	}
	
	
	
	public WamAllDto() {}

	public WamAllDto(int wamIdx, int projectIdx, char wamType, String title, int managerIdx, int creatorIdx,
			String deadlineDate, String createDate, String startDate, String completeDate, Integer wamParentIdx,
			String content, Integer followingIdx, Integer approval, String correctionDate, Integer orders,
			Integer sectionIdx, Integer fileIdx) {
		this.wamIdx = wamIdx;
		this.projectIdx = projectIdx;
		this.wamType = wamType;
		this.title = title;
		this.managerIdx = managerIdx;
		this.creatorIdx = creatorIdx;
		this.deadlineDate = deadlineDate;
		this.createDate = createDate;
		this.startDate = startDate;
		this.completeDate = completeDate;
		this.wamParentIdx = wamParentIdx;
		this.content = content;
		this.followingIdx = followingIdx;
		this.approval = approval;
		this.correctionDate = correctionDate;
		this.orders = orders;
		this.sectionIdx = sectionIdx;
		this.fileIdx = fileIdx;
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

	public char getWamType() {
		return wamType;
	}

	public void setWamType(char wamType) {
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

	public Integer getWamParentIdx() {
		return wamParentIdx;
	}

	public void setWamParentIdx(Integer wamParentIdx) {
		this.wamParentIdx = wamParentIdx;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public Integer getFollowingIdx() {
		return followingIdx;
	}

	public void setFollowingIdx(Integer followingIdx) {
		this.followingIdx = followingIdx;
	}

	public Integer getApproval() {
		return approval;
	}

	public void setApproval(Integer approval) {
		this.approval = approval;
	}

	public String getCorrectionDate() {
		return correctionDate;
	}

	public void setCorrectionDate(String correctionDate) {
		this.correctionDate = correctionDate;
	}

	public Integer getOrders() {
		return orders;
	}

	public void setOrders(Integer orders) {
		this.orders = orders;
	}

	public Integer getSectionIdx() {
		return sectionIdx;
	}

	public void setSectionIdx(Integer sectionIdx) {
		this.sectionIdx = sectionIdx;
	}

	public Integer getFileIdx() {
		return fileIdx;
	}

	public void setFileIdx(Integer fileIdx) {
		this.fileIdx = fileIdx;
	}
	
	
	
	
	
	
	
	
	
}
