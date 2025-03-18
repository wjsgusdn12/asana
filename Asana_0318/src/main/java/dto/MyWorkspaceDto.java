package dto;

public class MyWorkspaceDto {
	private int member_idx;
	private int owner_idx;
	private MemberDto memberDto;
	public MyWorkspaceDto(int member_idx, int owner_idx, MemberDto memberDto) {
		this.member_idx = member_idx;
		this.owner_idx = owner_idx;
		this.memberDto = memberDto;
	}
	public MyWorkspaceDto() {
		
	}
	public int getMember_idx() {
		return member_idx;
	}
	public void setMember_idx(int member_idx) {
		this.member_idx = member_idx;
	}
	public int getOwner_idx() {
		return owner_idx;
	}
	public void setOwner_idx(int owner_idx) {
		this.owner_idx = owner_idx;
	}
	public MemberDto getMemberDto() {
		return memberDto;
	}
	public void setMemberDto(MemberDto memberDto) {
		this.memberDto = memberDto;
	}
	
}
