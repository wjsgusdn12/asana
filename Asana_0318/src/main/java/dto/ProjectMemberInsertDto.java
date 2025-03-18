package dto;

public class ProjectMemberInsertDto {
	private int memberIdx;
	private String email;
	private String nickname;
	private String profileImg;
	private int projectIdx;
	private int authority;
	
	public ProjectMemberInsertDto(int memberIdx, String email, String nickname, String profileImg, int projectIdx,
			int authority) {
		this.memberIdx = memberIdx;
		this.email = email;
		this.nickname = nickname;
		this.profileImg = profileImg;
		this.projectIdx = projectIdx;
		this.authority = authority;
	}

	public int getMemberIdx() {
		return memberIdx;
	}

	public void setMemberIdx(int memberIdx) {
		this.memberIdx = memberIdx;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getNickname() {
		return nickname;
	}

	public void setNickname(String nickname) {
		this.nickname = nickname;
	}

	public String getProfileImg() {
		return profileImg;
	}

	public void setProfileImg(String profileImg) {
		this.profileImg = profileImg;
	}

	public int getProjectIdx() {
		return projectIdx;
	}

	public void setProjectIdx(int projectIdx) {
		this.projectIdx = projectIdx;
	}

	public int getAuthority() {
		return authority;
	}

	public void setAuthority(int authority) {
		this.authority = authority;
	}
	
	

}
