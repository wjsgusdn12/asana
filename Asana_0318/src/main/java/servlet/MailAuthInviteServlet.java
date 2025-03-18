package servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.MemberDao;

@WebServlet("/MailAuthInviteServlet")
public class MailAuthInviteServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String email = request.getParameter("email");
		int code = Integer.parseInt(request.getParameter("code"));
		
		System.out.println("email : " + email);
		System.out.println("code : " + code);
		
		// 처음에 초대: INSERT INTO member (member_idx, code) VALUES(seq_______.nextval, ?)
		
		// 1) 다오 --> email, code 이용해서 SELECT COUNT(1) ---> true: 
		MemberDao mDao = new MemberDao();
		boolean codeCheck = false;
		try {
			codeCheck = mDao.inviteCodeCheck(code);
			System.out.println("유효코드입니다");
		} catch (Exception e) {
			e.printStackTrace();
		}
		if(codeCheck) { // true , 초대code 가 잇는 DB로우의 email IS NULL 인 컬럼을 파라미터 email 로 update
			try {
				mDao.updateInviteEmail(email, code);
				System.out.println("이메일 등록이 완료되었습니다");
				//"내작업공간"에 초대수락한 신규 이메일유저 추가(내작업공간 멤버 추가 메서드)
				int inviteMemberIdx = mDao.getInviteMemberIdx(email);
				mDao.AddNewMemberIdxToMyWorkspace(inviteMemberIdx);
				System.out.println("내작업공간에 초대된 멤버 추가 완료(번호) = " + inviteMemberIdx);
				//초대수락한 신규 이메일유저의 member_idx 조회 메서드 후 변수에 담기
				int loginMemberIdx = inviteMemberIdx;
				//초대 수락한 이메일의 member_idx 를 loginMemberIdx 잡고 파라미터에 member_idx 담아서 홈 화면으로 이돟
				request.getRequestDispatcher("Controller?command=home&member_idx="+inviteMemberIdx).forward(request, response);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}else { // false
			// ---> false:
			// 인증번호 잘못... URL이 이상해... 잘못 메시지 출력 & 적당히 forward 또는 redirect.
		}
		
	}
}
