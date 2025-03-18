package servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import dao.MemberDao;
import dao.PortfolioDao;
import dao.StatusGetAllDao;
import dto.MemberAllDto;
import dto.PortfolioAllDto;
import dto.StatusAllDto;


@WebServlet("/ExConnectionPortfolioDelete")
public class ExConnectionPortfolioDelete extends HttpServlet {
	private static final long serialVersionUID = 1L;
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int portfolioidx = Integer.parseInt(request.getParameter("portfolioidx"));
		int projectIdx = Integer.parseInt(request.getParameter("projectIdx"));
		PortfolioDao portfolioDao = new PortfolioDao();
		MemberDao memberDao = new MemberDao();
		StatusGetAllDao statusGetAllDao = new StatusGetAllDao();
		MemberAllDto memberAllDto = null;
		StatusAllDto statusAllDto11 = null;
		try {
			portfolioDao.connectedPortfolioDeleteDto(projectIdx, portfolioidx);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		//연결된 포트폴리오 조회 ajax 처리 
				ArrayList<PortfolioAllDto> portfoliolist = null;
				try {
					portfoliolist = portfolioDao.connectedPortfolioGetDto(projectIdx);
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				
				JSONArray ArrJson = new JSONArray();
				for(PortfolioAllDto portfolioDto : portfoliolist) {
					JSONObject jsonObj = new JSONObject();
					portfolioDto.getName(); //포트폴리오 이름
					portfolioDto.getMemberIdx(); //포트폴리오 작성자 
					portfolioDto.getStatus_idx(); //상태 idx 
					try {
						memberAllDto = memberDao.getMemberAllDto(portfolioDto.getMemberIdx());
					} catch (Exception e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					memberAllDto.getProfileImg(); //포트폴리오 작성자 이미지 
					
					if(portfolioDto.getStatus_idx()!=null) {
						try {
							statusAllDto11 = statusGetAllDao.getStatusAllDto(portfolioDto.getStatus_idx());
						} catch (Exception e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
						
						statusAllDto11.getName(); //상태 이름 
						statusAllDto11.getBackgroundColor();
						statusAllDto11.getCharColor();
						jsonObj.put("statusNullCheck", 1); //상태 idx null 이 아니라면 1 리턴 
						jsonObj.put("statusName", statusAllDto11.getName());
						jsonObj.put("statusBackground", statusAllDto11.getBackgroundColor());
						jsonObj.put("statusCharColor", statusAllDto11.getCharColor());
					}else {
						jsonObj.put("statusNullCheck", 0); //상태 idx null 이라면 0 리턴 
					}
					jsonObj.put("portfolioIdx", portfolioDto.getPortfolioIdx());
					jsonObj.put("portfolioName", portfolioDto.getName());
					jsonObj.put("memberprofileImg", memberAllDto.getProfileImg());
					ArrJson.add(jsonObj);
				}
				
				
				response.setCharacterEncoding("utf-8");
				response.setContentType("application/json");
				PrintWriter out = response.getWriter();
				out.println(ArrJson);
				
		
		
		
	}

}
