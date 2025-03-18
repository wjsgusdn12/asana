package dto;

public class StatusAllDto {
	private int statusIdx; //상태번호 
	private String name; //상태이름
	private String charColor; //글자 색상
	private String backgroundColor; //배경색상
	private String circleColor; //동그라미 색상
	private String type; //타입 
	
	public StatusAllDto() {}

	public StatusAllDto(int statusIdx, String name, String charColor, String backgroundColor, String circleColor,
			String type) {
		this.statusIdx = statusIdx;
		this.name = name;
		this.charColor = charColor;
		this.backgroundColor = backgroundColor;
		this.circleColor = circleColor;
		this.type = type;
	}
	
	public StatusAllDto(int statusIdx, String name, String charColor, String backgroundColor, String circleColor) {
		this.statusIdx = statusIdx;
		this.name = name;
		this.charColor = charColor;
		this.backgroundColor = backgroundColor;
		this.circleColor = circleColor;
		
	}

	public int getStatusIdx() {
		return statusIdx;
	}

	public void setStatusIdx(int statusIdx) {
		this.statusIdx = statusIdx;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getCharColor() {
		return charColor;
	}

	public void setCharColor(String charColor) {
		this.charColor = charColor;
	}

	public String getBackgroundColor() {
		return backgroundColor;
	}

	public void setBackgroundColor(String backgroundColor) {
		this.backgroundColor = backgroundColor;
	}

	public String getCircleColor() {
		return circleColor;
	}

	public void setCircleColor(String circleColor) {
		this.circleColor = circleColor;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}
	
	
	
	
	
	
	


}
