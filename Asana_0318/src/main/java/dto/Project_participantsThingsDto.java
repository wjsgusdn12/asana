package dto;

public class Project_participantsThingsDto {
	private int member_idx; //회원번호 
	private String authority_name; //권한 
	private int authority; //권한idx 
	public Project_participantsThingsDto(int member_idx, String authority_name, int authority) {
		this.member_idx = member_idx;
		this.authority_name = authority_name;
		this.authority = authority;
	}
	public int getMember_idx() {
		return member_idx;
	}
	public void setMember_idx(int member_idx) {
		this.member_idx = member_idx;
	}
	public String getAuthority_name() {
		return authority_name;
	}
	public void setAuthority_name(String authority_name) {
		this.authority_name = authority_name;
	}
	public int getAuthority() {
		return authority;
	}
	public void setAuthority(int authority) {
		this.authority = authority;
	}
	
	
	
	
	
	
	
	
	
	

	

}
