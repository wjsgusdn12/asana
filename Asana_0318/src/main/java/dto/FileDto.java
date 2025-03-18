package dto;

public class FileDto {
	private int fileIdx;
	private String name;
	private int memberIdx;
	private String writeDate;
	private Integer messageIdx;
	private Integer commentsIdx;
	private Integer memoIdx;
	private Integer wamIdx;
	
	CommentsDto commentsDto;
	
	public FileDto(int fileIdx, String name, int memberIdx, String writeDate, Integer messageIdx, Integer commentsIdx,
			Integer memoIdx, Integer wamIdx) {
		this.fileIdx = fileIdx;
		this.name = name;
		this.memberIdx = memberIdx;
		this.writeDate = writeDate;
		this.messageIdx = messageIdx;
		this.commentsIdx = commentsIdx;
		this.memoIdx = memoIdx;
		this.wamIdx = wamIdx;
	}
	public FileDto(){
		
	}

	public int getFileIdx() {
		return fileIdx;
	}

	public CommentsDto getcommentsDto() {
		return commentsDto;
	}
	public void setcommentsDto(CommentsDto commentsDto) {
		this.commentsDto = commentsDto;
	}
	public void setFileIdx(int fileIdx) {
		this.fileIdx = fileIdx;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public int getMemberIdx() {
		return memberIdx;
	}

	public void setMemberIdx(int memberIdx) {
		this.memberIdx = memberIdx;
	}

	public String getWriteDate() {
		return writeDate;
	}

	public void setWriteDate(String writeDate) {
		this.writeDate = writeDate;
	}

	public Integer getMessageIdx() {
		return messageIdx;
	}

	public void setMessageIdx(Integer messageIdx) {
		this.messageIdx = messageIdx;
	}

	public Integer getCommentsIdx() {
		return commentsIdx;
	}

	public void setCommentsIdx(Integer commentsIdx) {
		this.commentsIdx = commentsIdx;
	}

	public Integer getMemoIdx() {
		return memoIdx;
	}

	public void setMemoIdx(Integer memoIdx) {
		this.memoIdx = memoIdx;
	}

	public Integer getWamIdx() {
		return wamIdx;
	}

	public void setWamIdx(Integer wamIdx) {
		this.wamIdx = wamIdx;
	}
	
	
}
