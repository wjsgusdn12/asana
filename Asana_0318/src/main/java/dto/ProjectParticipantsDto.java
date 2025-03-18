package dto;

public class ProjectParticipantsDto {
	private ProjectDto projectDto;
	private MemberDto memberDto;
	private int authority;
	private int projectParticipants;
	private String participatnDate;
	
	public ProjectParticipantsDto() {
		
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

	public int getAuthority() {
		return authority;
	}

	public void setAuthority(int authority) {
		this.authority = authority;
	}

	public int getProjectParticipants() {
		return projectParticipants;
	}

	public void setProjectParticipants(int projectParticipants) {
		this.projectParticipants = projectParticipants;
	}

	public String getParticipatnDate() {
		return participatnDate;
	}

	public void setParticipatnDate(String participatnDate) {
		this.participatnDate = participatnDate;
	}
	
}
