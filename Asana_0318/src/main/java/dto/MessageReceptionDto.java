package dto;

public class MessageReceptionDto {
	private int messageIdx;
	private int memberidx;
	private int projectIdx;
	
	private ProjectDto projectDto;
	private MemberDto memberDto;
	public MessageReceptionDto(int messageIdx, int memberidx, int projectIdx, ProjectDto projectDto,
			MemberDto memberDto) {
		this.messageIdx = messageIdx;
		this.memberidx = memberidx;
		this.projectIdx = projectIdx;
		this.projectDto = projectDto;
		this.memberDto = memberDto;
	}
	public MessageReceptionDto() {
		
	}
	public int getMessageIdx() {
		return messageIdx;
	}
	public void setMessageIdx(int messageIdx) {
		this.messageIdx = messageIdx;
	}
	public int getMemberidx() {
		return memberidx;
	}
	public void setMemberidx(int memberidx) {
		this.memberidx = memberidx;
	}
	public int getProjectIdx() {
		return projectIdx;
	}
	public void setProjectIdx(int projectIdx) {
		this.projectIdx = projectIdx;
	}
	public ProjectDto getProjectDto() {
		return projectDto;
	}
	public void setProjectDto(ProjectDto projectDto) {
		this.projectDto = projectDto;
	}
	public MemberDto getMemberDto() {
		return memberDto;
	}
	public void setMemberDto(MemberDto memberDto) {
		this.memberDto = memberDto;
	}
	
}
