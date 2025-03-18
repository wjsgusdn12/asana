package dto;

public class CommentsAllDto {
	private int commentsIdx; //댓글번호 (PK)
	private Integer projectStatusIdx;// 프로젝트의 상태번호
	private Integer goalIdx; // 목표번호 
	private Integer goalStatusIdx;//목표의 상태 번호 
	private Integer wamIdx; //wam 번호 
	private Integer messageIdx;//메세지 번호 
	private Integer memberIdx; //회원번호 
	private String content;//내용 
	//private String fileName; //파일명 
	private Integer fileIdx;   // 파일 idx
	private String writedate;//작성시간 
	private int fix; //댓글고정여부 0 : rhwjd 

	public CommentsAllDto() { }

	public CommentsAllDto(int commentsIdx, Integer projectStatusIdx, Integer goalIdx, Integer goalStatusIdx,
			Integer wamIdx, Integer messageIdx, Integer memberIdx, String content, Integer fileIdx, String writedate,
			int fix) {
		this.commentsIdx = commentsIdx;
		this.projectStatusIdx = projectStatusIdx;
		this.goalIdx = goalIdx;
		this.goalStatusIdx = goalStatusIdx;
		this.wamIdx = wamIdx;
		this.messageIdx = messageIdx;
		this.memberIdx = memberIdx;
		this.content = content;
		this.fileIdx = fileIdx;
		this.writedate = writedate;
		this.fix = fix;
	}

	public int getCommentsIdx() {
		return commentsIdx;
	}

	public void setCommentsIdx(int commentsIdx) {
		this.commentsIdx = commentsIdx;
	}

	public Integer getProjectStatusIdx() {
		return projectStatusIdx;
	}

	public void setProjectStatusIdx(Integer projectStatusIdx) {
		this.projectStatusIdx = projectStatusIdx;
	}

	public Integer getGoalIdx() {
		return goalIdx;
	}

	public void setGoalIdx(Integer goalIdx) {
		this.goalIdx = goalIdx;
	}

	public Integer getGoalStatusIdx() {
		return goalStatusIdx;
	}

	public void setGoalStatusIdx(Integer goalStatusIdx) {
		this.goalStatusIdx = goalStatusIdx;
	}

	public Integer getWamIdx() {
		return wamIdx;
	}

	public void setWamIdx(Integer wamIdx) {
		this.wamIdx = wamIdx;
	}

	public Integer getMessageIdx() {
		return messageIdx;
	}

	public void setMessageIdx(Integer messageIdx) {
		this.messageIdx = messageIdx;
	}

	public Integer getMemberIdx() {
		return memberIdx;
	}

	public void setMemberIdx(Integer memberIdx) {
		this.memberIdx = memberIdx;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public Integer getFileIdx() {
		return fileIdx;
	}

	public void setFileIdx(Integer fileIdx) {
		this.fileIdx = fileIdx;
	}

	public String getWritedate() {
		return writedate;
	}

	public void setWritedate(String writedate) {
		this.writedate = writedate;
	}

	public int getFix() {
		return fix;
	}

	public void setFix(int fix) {
		this.fix = fix;
	}
	
	
	
}
