package dto;

public class InviteWhoDto {
	private String profileImg;
	private String nickname;
	private String email;
	
	public InviteWhoDto(String profileImg, String nickname, String email) {
		this.profileImg = profileImg;
		this.nickname = nickname;
		this.email = email;
	}
	public String getProfileImg() {
		return profileImg;
	}
	public void setProfileImg(String profileImg) {
		this.profileImg = profileImg;
	}
	public String getNickname() {
		return nickname;
	}
	public void setNickname(String nickname) {
		this.nickname = nickname;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	
	
}
