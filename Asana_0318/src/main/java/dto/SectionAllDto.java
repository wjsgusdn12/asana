package dto;

public class SectionAllDto  {
	private int sectionIdx; //섹션 idx
	private int projectIdx; //프로젝트 번호 
	private String name; // 섹션이름 
	private int sectionOrder; //섹션의 순서 

	public SectionAllDto(int sectionIdx, int projectIdx, String name, int sectionOrder) {
		this.sectionIdx = sectionIdx;
		this.projectIdx = projectIdx;
		this.name = name;
		this.sectionOrder = sectionOrder;
	}
	
	public SectionAllDto() {
		
	}

	public int getSectionIdx() {
		return sectionIdx;
	}

	public void setSectionIdx(int sectionIdx) {
		this.sectionIdx = sectionIdx;
	}

	public int getProjectIdx() {
		return projectIdx;
	}

	public void setProjectIdx(int projectIdx) {
		this.projectIdx = projectIdx;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public int getSectionOrder() {
		return sectionOrder;
	}

	public void setSectionOrder(int sectionOrder) {
		this.sectionOrder = sectionOrder;
	}
	
	
	
	

}
