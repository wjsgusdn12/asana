package dto;

import java.util.ArrayList;

public class MessageDto {
	private int messageIdx;
	private int projectIdx;
	private int writerIdx;
	private String title;
	private String content;
	private String writeDate;
	private int deleteCheck;
	
	private MemberDto memberDto;
	
	private ProjectDto projectDto;
	private ArrayList<CommentsDto> listReply;
	private FileDto fileDto;
	
	public FileDto getFileDto() {
		return fileDto;
	}
	public void setFileDto(FileDto fileDto) {
		this.fileDto = fileDto;
	}
	public MessageDto() {
		
	}
	public MessageDto(int messageIdx, int projectIdx, int writerIdx, String title, String content, String writeDate,
			int deleteCheck) {
		this.messageIdx = messageIdx;
		this.projectIdx = projectIdx;
		this.writerIdx = writerIdx;
		this.title = title;
		this.content = content;
		this.writeDate = writeDate;
		this.deleteCheck = deleteCheck;
	}
	public MessageDto(int messageIdx, String title, MemberDto memberDto, String content, String writeDate, ProjectDto projectDto) {
		this.messageIdx = messageIdx;
		this.title = title;
		this.memberDto = memberDto;
		this.content = content;
		this.writeDate = writeDate;
		this.projectDto = projectDto;
	}

	public ProjectDto getProjectDto() {
		return projectDto;
	}
	public ArrayList<CommentsDto> getListReply() {
		return listReply;
	}
	public void setListReply(ArrayList<CommentsDto> listReply) {
		this.listReply = listReply;
	}
	public void setProjectDto(ProjectDto projectDto) {
		this.projectDto = projectDto;
	}
	public int get() {
		return messageIdx;
	}

	

	public int getMessageIdx() {
		return messageIdx;
	}
	public void setMessageIdx(int messageIdx) {
		this.messageIdx = messageIdx;
	}
	public int getProjectIdx() {
		return projectIdx;
	}
	public void setProjectIdx(int projectIdx) {
		this.projectIdx = projectIdx;
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
	public int getDeleteCheck() {
		return deleteCheck;
	}
	public void setDeleteCheck(int deleteCheck) {
		this.deleteCheck = deleteCheck;
	}
	public MemberDto getMemberDto() {
		return memberDto;
	}
	public void setMemberDto(MemberDto memberDto) {
		this.memberDto = memberDto;
	}
	public int getprojectIdx() {
		return projectIdx;
	}

	public void setprojectIdx(int projectIdx) {
		this.projectIdx = projectIdx;
	}

	public int getwriterIdx() {
		return writerIdx;
	}

	public void setwriterIdx(int writerIdx) {
		this.writerIdx = writerIdx;
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

	public String getwriteDate() {
		return writeDate;
	}

	public void setwriteDate(String writeDate) {
		this.writeDate = writeDate;
	}

	public int getdeleteCheck() {
		return deleteCheck;
	}

	public void setdeleteCheck(int deleteCheck) {
		this.deleteCheck = deleteCheck;
	}
	
}
