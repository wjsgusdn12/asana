package dto;

public class CommentsDto {
	private String writeDate;
	private String content;
	private int fix;
	private int commentIdx;
	private int memberIdx;
	private int fileIdx;
	private int messageIdx;
	
	
	private MemberDto memberDto;
	private MessageDto messageDto;
	private FileDto fileDto;
	
	public CommentsDto(String writeDate, String content, int fix, int commentIdx, int memberIdx, MemberDto memberDto, MessageDto messageDto, FileDto fileDto ) {
		this.writeDate = writeDate;
		this.content = content;
		this.fix = fix;
		this.commentIdx = commentIdx;
		this.memberIdx = memberIdx;
		this.memberDto = memberDto;
		this.messageDto = messageDto;
		this.fileDto = fileDto;
	}
	public CommentsDto(String writerDate, String content, int fix, int commentIdx, int memberIdx, int fileIdx, int messageIdx) {
		this.writeDate = writerDate;
		this.content = content;
		this.fix = fix;
		this.commentIdx = commentIdx;
		this.memberIdx = memberIdx;
		this.fileIdx = fileIdx;
		this.messageIdx = messageIdx;
	}
	public CommentsDto(String writerDate, String content, int fix, MemberDto memberDto) {
		
	}
	public CommentsDto(String writerDate, String content, int fix, int commentIdx, MemberDto memberDto, FileDto fileDto, MessageDto messageDto ) {
		this.writeDate = writerDate;
		this.content = content;
		this.fix = fix;
		this.commentIdx = commentIdx;
		this.memberDto = memberDto;
		this.fileDto = fileDto;
		this.messageDto = messageDto;
	}
	public CommentsDto() {
		
	}

	public int getMemberIdx() {
		return memberIdx;
	}
	public void setMemberIdx(int memberIdx) {
		this.memberIdx = memberIdx;
	}
	public int getFileIdx() {
		return fileIdx;
	}
	public void setFileIdx(int fileIdx) {
		this.fileIdx = fileIdx;
	}
	public int getMessageIdx() {
		return messageIdx;
	}
	public void setMessageIdx(int messageIdx) {
		this.messageIdx = messageIdx;
	}
	public MessageDto getMessageDto() {
		return messageDto;
	}
	public void setMessageDto(MessageDto messageDto) {
		this.messageDto = messageDto;
	}
	public FileDto getFileDto() {
		return fileDto;
	}
	public void setFileDto(FileDto fileDto) {
		this.fileDto = fileDto;
	}
	public int getCommentIdx() {
		return commentIdx;
	}
	public void setCommentIdx(int commentIdx) {
		this.commentIdx = commentIdx;
	}
	public String getWriteDate() {
		return writeDate;
	}

	public void setWriteDate(String writeDate) {
		this.writeDate = writeDate;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public MemberDto getMemberDto() {
		return memberDto;
	}

	public void setMemberDto(MemberDto memberDto) {
		this.memberDto = memberDto;
	}
	public int getFix() {
		return fix;
	}
	public void setFix(int fix) {
		this.fix = fix;
	}
	
}
