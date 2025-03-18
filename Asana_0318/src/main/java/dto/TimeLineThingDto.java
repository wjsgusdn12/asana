package dto;

public class TimeLineThingDto {
	private int idx; //project_status_idx , project_participants, message_idx
	private String date; // 날짜 
	private String type; // project_participants , message , project_status
	
	public TimeLineThingDto(int idx, String date, String type) {
		
		this.idx = idx;
		this.date = date;
		this.type = type;
	}
	public TimeLineThingDto() {
		
	}

	public int getIdx() {
		return idx;
	}

	public void setIdx(int idx) {
		this.idx = idx;
	}

	public String getDate() {
		return date;
	}

	public void setDate(String date) {
		this.date = date;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}
	
	
	
	

}
