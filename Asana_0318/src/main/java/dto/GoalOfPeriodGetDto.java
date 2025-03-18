package dto;

public class GoalOfPeriodGetDto {
	private int fical_year; //연도 
	private int period_idx; //기간
	private String name; //기간이름
	private String term; //세부기간
	
	public GoalOfPeriodGetDto(int fical_year, int period_idx, String name, String term) {
		this.fical_year = fical_year;
		this.period_idx = period_idx;
		this.name = name;
		this.term = term;
	}

	public int getFical_year() {
		return fical_year;
	}

	public void setFical_year(int fical_year) {
		this.fical_year = fical_year;
	}

	public int getPeriod_idx() {
		return period_idx;
	}

	public void setPeriod_idx(int period_idx) {
		this.period_idx = period_idx;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getTerm() {
		return term;
	}

	public void setTerm(String term) {
		this.term = term;
	}
	
	
	


}
