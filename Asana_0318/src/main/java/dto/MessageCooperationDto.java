package dto;

public class MessageCooperationDto {
	private int MessageIdx;
	private int MemberIdx;
	
	private MemberDto memberDto;
	
	public MessageCooperationDto() {
		
	}
	
	public MessageCooperationDto(int messageIdx, int memberIdx) {
		MessageIdx = messageIdx;
		MemberIdx = memberIdx;
	}

	public int getMessageIdx() {
		return MessageIdx;
	}

	public void setMessageIdx(int messageIdx) {
		MessageIdx = messageIdx;
	}

	public int getMemberIdx() {
		return MemberIdx;
	}

	public void setMemberIdx(int memberIdx) {
		MemberIdx = memberIdx;
	}

	public MemberDto getMemberDto() {
		return memberDto;
	}

	public void setMemberDto(MemberDto memberDto) {
		this.memberDto = memberDto;
	}
	
}
