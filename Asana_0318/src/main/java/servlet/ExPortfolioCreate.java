package servlet;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.PortfolioDao;


@WebServlet("/ExPortfolioCreate")
public class ExPortfolioCreate extends HttpServlet {
	private static final long serialVersionUID = 1L;
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//1. 포트폴리오 테이블에 insert -> 메서드 실행후 포트폴리오 idx 리턴 
		//2. connected_portfolio 에 insert 
		String portfolioName = request.getParameter("portfolioName");
		int loginMemberIdx = Integer.parseInt(request.getParameter("loginMemberIdx"));
		int projectIdx = Integer.parseInt(request.getParameter("projectIdx"));
		
		//1. 포트폴리오 테이블에 insert -> 메서드 실행후 포트폴리오 idx 리턴 
		PortfolioDao portfolioDao = new PortfolioDao();
		int portfolioIdx = 0; // 리턴 받아야함 
		try {
			portfolioIdx = portfolioDao.portfolioInsert(portfolioName, loginMemberIdx);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		//2. connected_portfolio 에 insert 
		
		try {
			portfolioDao.connectedPortfolioInsertDto(projectIdx, portfolioIdx);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
		
		
		
	
	}

}
