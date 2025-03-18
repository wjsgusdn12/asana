package dto;

public class FileListDto {
	private String name;
	private String title;
	private String nickname;
	private String writeTime;
	private int projectIdx;
	
	public FileListDto() {}
	
	public FileListDto(String name, String title, String nickname, String writeTime, int projectIdx) {
		super();
		this.name = name;
		this.title = title;
		this.nickname = nickname;
		this.writeTime = writeTime;
		this.projectIdx = projectIdx;
	}
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getNickname() {
		return nickname;
	}
	public void setNickname(String nickname) {
		this.nickname = nickname;
	}
	public String getWriteTime() {
		return writeTime;
	}
	public void setWriteTime(String writeTime) {
		this.writeTime = writeTime;
	}
	public int getProjectIdx() {
		return projectIdx;
	}
	public void setProjectIdx(int projectIdx) {
		this.projectIdx = projectIdx;
	}
	
	
	
}
