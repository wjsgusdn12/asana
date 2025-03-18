package dto;

public class ProjectAllDto {
	private int project_idx; //프로젝트 번호 
	private String name; //이름
	private int member_idx; //생성자 회원번호 
	private int range; //공개범위(엑세스 설정)
	private int default_view; //기본보기 1:목록 2:보드 3:캘린더 
	private String create_date; //생성일시 
	private String recent_date; //최근활동일시 
	private String start_date; // 시작
	private String deadline_date; //마감
	private String title; //프로젝트 설명 제
	private String content; //프로젝트 설명 내용 

	public ProjectAllDto(int project_idx, String name, int member_idx, int range, int default_view, String create_date,
			String recent_date, String start_date, String deadline_date, String title, String content) {
		
		this.project_idx = project_idx;
		this.name = name;
		this.member_idx = member_idx;
		this.range = range;
		this.default_view = default_view;
		this.create_date = create_date;
		this.recent_date = recent_date;
		this.start_date = start_date;
		this.deadline_date = deadline_date;
		this.title = title;
		this.content = content;
	}
	
	public ProjectAllDto() {
		
	}

	public int getProject_idx() {
		return project_idx;
	}

	public void setProject_idx(int project_idx) {
		this.project_idx = project_idx;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public int getMember_idx() {
		return member_idx;
	}

	public void setMember_idx(int member_idx) {
		this.member_idx = member_idx;
	}

	public int getRange() {
		return range;
	}

	public void setRange(int range) {
		this.range = range;
	}

	public int getDefault_view() {
		return default_view;
	}

	public void setDefault_view(int default_view) {
		this.default_view = default_view;
	}

	public String getCreate_date() {
		return create_date;
	}

	public void setCreate_date(String create_date) {
		this.create_date = create_date;
	}

	public String getRecent_date() {
		return recent_date;
	}

	public void setRecent_date(String recent_date) {
		this.recent_date = recent_date;
	}

	public String getStart_date() {
		return start_date;
	}

	public void setStart_date(String start_date) {
		this.start_date = start_date;
	}

	public String getDeadline_date() {
		return deadline_date;
	}

	public void setDeadline_date(String deadline_date) {
		this.deadline_date = deadline_date;
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
	
	
	
	
}
