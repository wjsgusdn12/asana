package dto;

public class LookMemoDto {
	private Integer projectIdx;
	private String title;
	private String content;
	private String writeDate;
	
	public LookMemoDto(Integer projectIdx, String title, String content, String writeDate) {
		super();
		this.projectIdx = projectIdx;
		this.title = title;
		this.content = content;
		this.writeDate = writeDate;
	}
	public Integer getProjectIdx() {
		return projectIdx;
	}
	public void setProjectIdx(Integer projectIdx) {
		this.projectIdx = projectIdx;
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
	public String getWriteDate() {
		return writeDate;
	}
	public void setWriteDate(String writeDate) {
		this.writeDate = writeDate;
	}
	
	
}
