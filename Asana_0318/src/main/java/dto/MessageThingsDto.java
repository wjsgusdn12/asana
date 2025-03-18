package dto;

public class MessageThingsDto {
	private String title; //제목 
	private int writerIdx; //회원번호 (작성자)
	private String writeDate; //작성시간 
	
	public MessageThingsDto(String title, int writerIdx, String writeDate) {
	
		this.title = title;
		this.writerIdx = writerIdx;
		this.writeDate = writeDate;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public int getWriterIdx() {
		return writerIdx;
	}

	public void setWriterIdx(int writerIdx) {
		this.writerIdx = writerIdx;
	}

	public String getWriteDate() {
		return writeDate;
	}

	public void setWriteDate(String writeDate) {
		this.writeDate = writeDate;
	}
	
	
	
	
	
	

}
