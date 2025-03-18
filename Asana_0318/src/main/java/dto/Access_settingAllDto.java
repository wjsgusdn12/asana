package dto;

public class Access_settingAllDto {
	private int range; //공개범위(엑세스 설정)
	private String title; // 공개범위 제목 
	private String content; //공개범위 내용 
	
	public Access_settingAllDto(int range, String title, String content) {
		this.range = range;
		this.title = title;
		this.content = content;
	}
	
	public int getRange() {
		return range;
	}
	public void setRange(int range) {
		this.range = range;
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
