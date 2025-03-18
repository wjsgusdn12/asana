package dto;

public class GoalStatusCommentsDto {
	private Integer contentIdx; 		//댓글번호
	private Integer projectStatusIdx; 	//프로젝트의 상태번호
	private Integer goalIdx;			//목표번호
	private Integer goalStatusIdx;		//목표의 상태번호
	private Integer wamIdx; 			//WAM 번호
	private Integer messageIdx; 		//메시지 번호
	private Integer membeIdx; 			//회원번호
	private String content;				//내용
	private String fileName; 			//파일명
	private String writeDate; 			//작성 시간
	private int fix; 					//댓글 고정여부 (0:고정X, 1:고정)
	
	public GoalStatusCommentsDto(Integer contentIdx, Integer projectStatusIdx, Integer goalIdx, Integer goalStatusIdx,
			Integer wamIdx, Integer messageIdx, Integer membeIdx, String content, String fileName, String writeDate,
			int fix) {
		
		this.contentIdx = contentIdx;
		this.projectStatusIdx = projectStatusIdx;
		this.goalIdx = goalIdx;
		this.goalStatusIdx = goalStatusIdx;
		this.wamIdx = wamIdx;
		this.messageIdx = messageIdx;
		this.membeIdx = membeIdx;
		this.content = content;
		this.fileName = fileName;
		this.writeDate = writeDate;
		this.fix = fix;
	}
	public Integer getContentIdx() {
		return contentIdx;
	}
	public void setContentIdx(Integer contentIdx) {
		this.contentIdx = contentIdx;
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
	public Integer getMembeIdx() {
		return membeIdx;
	}
	public void setMembeIdx(Integer membeIdx) {
		this.membeIdx = membeIdx;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getFileName() {
		return fileName;
	}
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
	public String getWriteDate() {
		return writeDate;
	}
	public void setWriteDate(String writeDate) {
		this.writeDate = writeDate;
	}
	public int getFix() {
		return fix;
	}
	public void setFix(int fix) {
		this.fix = fix;
	}
	
	
	
}
