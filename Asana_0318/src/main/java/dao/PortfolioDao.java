package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Scanner;

import dto.PortfolioAllDto;
import dto.PortfolioDto;

public class PortfolioDao {
	public Connection getConnection() throws Exception {
		String driver = "oracle.jdbc.driver.OracleDriver";
		String url = "jdbc:oracle:thin:@gusdntkd.cafe24.com:1521:xe";
		String id = "asana_hw";
		String pw = "asana12345";

		Class.forName(driver);
		Connection conn = DriverManager.getConnection(url, id, pw);
		return conn;
	}
	
	// 포트폴리오 조회 
	// 파라미터 : portfolioIdx
	// 리턴값 :  name , status_idx , member_idx
	// 특정 포트폴리오 세부정보 조회 
	public PortfolioAllDto getPortfolioDto(int portfolioIdx) throws Exception {
		String sql = "SELECT name , status_idx , member_idx" + " FROM portfolio" + " WHERE portfolio_idx = ?";

		PortfolioAllDto dto = null;
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, portfolioIdx);
		ResultSet rs = pstmt.executeQuery();
		if (rs.next()) {
			String name = rs.getString("name");
			int statusIdx = rs.getInt("status_idx");
			int memberIdx = rs.getInt("member_idx");
			dto = new PortfolioAllDto();
			dto.setName(name);
			dto.setStatus_idx(statusIdx);
			dto.setMemberIdx(memberIdx);
		}
		rs.close();
		pstmt.close();
		conn.close();
		return dto;
	}
	
	// 연결된 포트폴리오 검색시 조회
	// 파라미터 : projectIdx
	// 리턴값 : name , portfolio_idx
	// 특정 프로젝트와 연결된 포트폴리오를 제외한 포트폴리오 조회하는 메서드 
	public ArrayList<PortfolioAllDto> connectedPortfolioClickGetDto(int projectIdx) throws Exception {
		String sql = "SELECT name , portfolio_idx" + " FROM PORTFOLIO"
				+ " WHERE portfolio_idx not in(select portfolio_idx" + " from connected_portfolio"
				+ " where project_idx = ?)";
		ArrayList<PortfolioAllDto> list = new ArrayList<PortfolioAllDto>();
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, projectIdx);
		ResultSet rs = pstmt.executeQuery();
		while (rs.next()) {
			String name = rs.getString("name");
			int portfolioIdx = rs.getInt("portfolio_idx");
			PortfolioAllDto dto = new PortfolioAllDto();
			dto.setName(name);
			dto.setPortfolioIdx(portfolioIdx);
			list.add(dto);
		}
		rs.close();
		pstmt.close();
		conn.close();
		return list;
	}
	
	// 포트폴리오에 프로젝트 저장
	// 파라미터 :  projectIdx, portfolioIdx
	// 특정 포트폴리오에 프로젝트 저장하는 메서드 
	public void connectedPortfolioInsertDto(int projectIdx, int portfolioIdx) throws Exception {
		String sql = "INSERT INTO connected_portfolio (project_idx, portfolio_idx) VALUES (?, ?)";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, projectIdx);
		pstmt.setInt(2, portfolioIdx);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}
	
	// 연결된 포트폴리오 조회 
	// 파라미터 : projectIdx
	// 리턴값 : name, member_idx, status_idx, portfolio_idx
	// 특정 프로젝트와 연결된 포트폴리오 조회하는 메서드 
	public ArrayList<PortfolioAllDto> connectedPortfolioGetDto(int projectIdx) throws Exception {
		String sql = "SELECT name, member_idx, status_idx, portfolio_idx" + " FROM PORTFOLIO"
				+ " WHERE portfolio_idx IN (SELECT portfolio_idx" + " FROM connected_portfolio"
				+ " WHERE project_idx = ?)";
		ArrayList<PortfolioAllDto> list = new ArrayList<PortfolioAllDto>();
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, projectIdx);
		ResultSet rs = pstmt.executeQuery();
		while (rs.next()) {
			String name = rs.getString("name");
			int memberIdx = rs.getInt("member_idx");
			rs.getInt("status_idx");
			Integer statusIdx = null;
			if (!rs.wasNull()) {
				statusIdx = rs.getInt("status_idx");
			}
			int portfolioIdx = rs.getInt("portfolio_idx");
			PortfolioAllDto dto = new PortfolioAllDto(portfolioIdx, name, statusIdx, memberIdx);
			list.add(dto);
		}
		rs.close();
		pstmt.close();
		conn.close();
		return list;
	}
	
	// 연결된 포트폴리오 제거 
	// 파라미터 : projectIdx, portfolioIdx
	// 특정 프로젝트와 연결된 포트폴리오 제거하는 메서드 
	public void connectedPortfolioDeleteDto(int projectIdx, int portfolioIdx) throws Exception {
		String sql = "DELETE FROM connected_portfolio WHERE project_idx =? and portfolio_idx=?";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, projectIdx);
		pstmt.setInt(2, portfolioIdx);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}
	
	// 프로젝트의 포트폴리오 조회 
	// 파라미터 :  projectIdx
	// 리턴값 : portfolio_idx
	// 특정 프로젝트와 연결된 포트폴리오 조회하는 메서드 
	public ArrayList<PortfolioAllDto> portfolioTheProjectBelongsTo(int projectIdx) throws Exception {
		String sql = "SELECT portfolio_idx" + " FROM connected_portfolio" + " WHERE project_idx = ?";
		ArrayList<PortfolioAllDto> list = new ArrayList<PortfolioAllDto>();
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, projectIdx);
		ResultSet rs = pstmt.executeQuery();
		while (rs.next()) {
			int portfolioIdx = rs.getInt("portfolio_idx");
			PortfolioAllDto dto = new PortfolioAllDto();
			dto.setPortfolioIdx(portfolioIdx);
			list.add(dto);
		}
		rs.close();
		pstmt.close();
		conn.close();
		return list;
	}
	
	// 연결된 포트폴리오 검색시 조회 
	// 파라미터 : projectIdx, portfoliName
	// 리턴값 : name , portfolio_idx
	// 특정 프로젝트와 연결된 포트폴리오를 제외하고 검색한 포트폴리오 조회 
	public ArrayList<PortfolioAllDto> connectedPortfolioSearch(int projectIdx, String portfoliName) throws Exception {
		String sql = "SELECT name , portfolio_idx" + " FROM PORTFOLIO"
				+ " WHERE portfolio_idx not in(select portfolio_idx"
				+ "                           from connected_portfolio"
				+ "                           where project_idx = ?)" + " AND NAME LIKE ?";
		ArrayList<PortfolioAllDto> list = new ArrayList<PortfolioAllDto>();
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, projectIdx);
		pstmt.setString(2, "%" + portfoliName + "%");
		ResultSet rs = pstmt.executeQuery();
		while (rs.next()) {
			String name = rs.getString("name");
			int portfolioIdx = rs.getInt("portfolio_idx");
			PortfolioAllDto dto = new PortfolioAllDto();
			dto.setName(name);
			dto.setPortfolioIdx(portfolioIdx);
			list.add(dto);
		}
		rs.close();
		pstmt.close();
		conn.close();
		return list;
	}
	
	// 연결된 포트폴리오 검색시 포트폴리오 갯수 조회 
	// 파라미터 : projectIdx, portfoliName
	// 리턴값 : 포트폴리오 갯수 
	// 특정 프로젝트와 연결된 포트폴리오를 제외하고 검색한 포트폴리오의 갯수 조회 
	public int portfolioSearchCount(int projectIdx, String portfoliName) throws Exception {
		String sql = "SELECT count(*)" + " FROM PORTFOLIO" + " WHERE portfolio_idx not in(select portfolio_idx"
				+ "                           from connected_portfolio"
				+ "                           where project_idx =?)" + " AND NAME LIKE ?";
		int count = 0;
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, projectIdx);
		pstmt.setString(2, "%" + portfoliName + "%");
		ResultSet rs = pstmt.executeQuery();
		if (rs.next()) {
			count = rs.getInt("count(*)");
		}
		rs.close();
		pstmt.close();
		conn.close();
		return count;
	}
	
	// 포트폴리오 생성 
	// 파라미터 : portfolioName , memberIdx
	// 리턴값 : portfolio_idx
	// 포트폴리오 생성, 생성된 portfolio_idx 를 반환하는 메서드 
	public int portfolioInsert(String portfolioName , int memberIdx) throws Exception {
		String sql="insert into portfolio(portfolio_idx, name, status_idx, range, default_view, priority, member_idx, parent_idx) "
				+ "values(seq_portfolio_idx.nextval, ?, null, 0, 1, null, ?, null)";
		Connection conn = getConnection();
		String[] arr = {"portfolio_idx"};
		PreparedStatement pstmt = conn.prepareStatement(sql, arr); 
		pstmt.setString(1, portfolioName);
		pstmt.setInt(2, memberIdx);
		pstmt.executeUpdate();
		ResultSet rs = pstmt.getGeneratedKeys();
		Integer pkValue = null;
		if (rs.next()) {
	        pkValue = rs.getInt(1);
	    }
		rs.close();
		pstmt.close();
		conn.close();
		return pkValue;
	}

	// 포트폴리오 생성 
	// 파라미터 :  name, memberIdx
	// 포트폴리오 생성하는 메서드 
	public void createPortfolio(String name, int memberIdx) throws Exception {
		String sql = "INSERT INTO portfolio(portfolio_idx, name, member_idx)"
				+ " VALUES(SEQ_PORTFOLIO_IDX.nextval, ?, ?)";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, name);
		pstmt.setInt(2, memberIdx);
		pstmt.executeUpdate();

		pstmt.close();
		conn.close();
	}

	// 포트폴리오에 추가할 "업무 목록" 조회
	// 리턴값 : portfolio.name
	// 포트폴리오에 추가할 포트폴리오 이름 목록을 조회하는 메서드
	public ArrayList<String> addWorkToPortfolio() throws Exception {
		String sql = "SELECT '프로젝트 : '||name \"추가할 업무\"" + " FROM project" + " UNION ALL" + " SELECT '포트폴리오 : '||name"
				+ " FROM portfolio";
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		ResultSet rs = pstmt.executeQuery();
		ArrayList<String> add = new ArrayList<>();
		while (rs.next()) {
			add.add(rs.getString("추가할 업무"));
		}
		rs.close();
		pstmt.close();
		conn.close();
		for (int i = 0; i < add.size(); i++) {
			System.out.println(add.get(i));
		}
		return add;
	}

	// 포트폴리오 제목 수정
	// 파라미터 : portfolio.name , portfolio_idx
	// 포트폴리오 제목을 수정하는 메서드
	public void UpdatePortfolioNameFromPortfolioIdx(String name, int portfolioIdx) throws Exception {
		String sql = "UPDATE portfolio SET name = ?" + " WHERE portfolio_idx=?";

		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, name);
		pstmt.setInt(2, portfolioIdx);
		pstmt.executeUpdate();
	}

	// 포트폴리오 상태 번호 수정
	// 파라미터 : status_idx , portfolio_idx
	// 포트폴리오 상태 번호를 수정하는 메서드
	public void UpdatePortfolioStatusIdxFromPortfolioIdx(int statusIdx, int portfolioIdx) throws Exception {
		String sql = "UPDATE portfolio SET status_idx = ?" + " WHERE portfolio_idx=?";

		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, statusIdx);
		pstmt.setInt(2, portfolioIdx);
		pstmt.executeUpdate();
	}

	// 포트폴리오 공개범위 수정
	// 파라미터 : range , portfolio_idx
	// 포트폴리오 공개범위를 수정하는 메서드
	public void UpdatePortfolioRangeFromPortfolioIdx(int range, int portfolioIdx) throws Exception {
		String sql = "UPDATE portfolio SET range = ?" + " WHERE portfolio_idx=?";

		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, range);
		pstmt.setInt(2, portfolioIdx);
		pstmt.executeUpdate();
	}

	// 포트폴리오 중요도 수정
	// 파라미터 : priority , portfolio_idx
	// 포트폴리오 중요도를 설정(수정)하는 메서드
	public void UpdatePortfolioPriorityFromPortfolioIdx(int priority, int portfolioIdx) throws Exception {
		String sql = "UPDATE portfolio SET priority = ?" + " WHERE portfolio_idx=?";

		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, priority);
		pstmt.setInt(2, portfolioIdx);
		pstmt.executeUpdate();
	}

	// 포트폴리오 소유자 수정
	// 파라미터 : member_idx , portfolio_idx
	// 해당 포트폴리오의 소유자를 변경하는 메서드
	public void UpdatePortfolioMemberIdxFromPortfolioIdx(int memberIdx, int portfolioIdx) throws Exception {
		String sql = "UPDATE portfolio SET member_idx = ?" + " WHERE portfolio_idx=?";

		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, memberIdx);
		pstmt.setInt(2, portfolioIdx);
		pstmt.executeUpdate();
	}

	// 포트폴리오 부모번호 수정
	// 파라미터 : parent_idx , portfolio_idx
	// 해당 포트폴리오의 부모 번호를 설정(수정)하는 메서드
	public void UpdatePortfolioParentIdxFromPortfolioIdx(int parentIdx, int portfolioIdx) throws Exception {
		String sql = "UPDATE portfolio SET parent_idx = ?" + " WHERE portfolio_idx=?";

		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, parentIdx);
		pstmt.setInt(2, portfolioIdx);
		pstmt.executeUpdate();
	}

	// 포트폴리오 삭제
	// 파라미터 : portfolio_idx
	// 해당 포트폴리오를 삭제하는 메서드
	public void DeletePortfolioFromPortfolioIdx(int portfolioIdx) throws Exception {
		String sql = "DELETE FROM portfolio WHERE portfolio_idx=?";

		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, portfolioIdx);
		pstmt.executeUpdate();
	}

	// 포트폴리오 조회
	// 리턴값 : portfolio.name, portfolio_idx
	// 포트폴리오를 조회하는 메서드
	public ArrayList<PortfolioDto> getPortfolioDto() throws Exception {
		String sql = "SELECT name, portfolio_idx FROM portfolio ORDER BY portfolio_idx";
		ArrayList<PortfolioDto> list = new ArrayList<>();

		Connection conn = getConnection();

		PreparedStatement pstmt = conn.prepareStatement(sql);
		ResultSet rs = pstmt.executeQuery();
		while (rs.next()) {
			String name = rs.getString("name");
			int portfolioIdx = rs.getInt(2);
			PortfolioDto dto = new PortfolioDto();
			dto.setName(name);
			dto.setPortfolioIdx(portfolioIdx);
			list.add(dto);
		}
		rs.close();
		pstmt.close();
		conn.close();
		return list;
	}

	public static void main(String[] args) throws Exception {

	}
}
