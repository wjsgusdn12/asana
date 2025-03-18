package dto;

public class SelectProject_idxGetmemberDto {
	private String profile_img;
	private String nickname;
	
	public SelectProject_idxGetmemberDto(String profile_img, String nickname) {
		this.profile_img = profile_img;
		this.nickname = nickname;
	}

	public String getProfile_img() {
		return profile_img;
	}

	public void setProfile_img(String profile_img) {
		this.profile_img = profile_img;
	}

	public String getNickname() {
		return nickname;
	}

	public void setNickname(String nickname) {
		this.nickname = nickname;
	}
	
	
	
	

}
