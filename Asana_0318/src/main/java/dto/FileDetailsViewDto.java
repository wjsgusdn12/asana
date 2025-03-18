package dto;

public class FileDetailsViewDto {
	private String name;
	private String writeDate;
	
	public FileDetailsViewDto(String name, String writeDate) {
		this.name = name;
		this.writeDate = writeDate;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getWriteDate() {
		return writeDate;
	}

	public void setWriteDate(String writeDate) {
		this.writeDate = writeDate;
	}
	
	
}
