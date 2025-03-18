package servlet;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;

import dao.CommentsDao;
import dao.LikeDao;
import dao.MemberDao;
import dao.MessageDao;
import dto.CommentsDto;
import dto.MemberDto;
import dto.MessageDto;

@WebServlet("/AjaxCreateCommentServlet")
public class AjaxCreateCommentServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	    int memberIdx = Integer.parseInt(request.getParameter("member_idx"));
	    int messageIdx = Integer.parseInt(request.getParameter("message_idx"));
	    String content = request.getParameter("content");

	    // CommentsDao 객체 생성
	    CommentsDao dao = new CommentsDao();
	    int commentIdx = 0;
	    CommentsDto dto = null;
	    LikeDao ldao = new LikeDao();
	    int cnt = 0;
	    MessageDao mdao = new MessageDao();
	    int MessageWriterIdx = 0;
	    // 댓글 생성
	    try {
	        // createComment 메서드를 호출하여 comment_idx를 반환받음
	        commentIdx = dao.showCreateComment(memberIdx, messageIdx, content);
	        dto = dao.showCommentDto(commentIdx);
	        cnt = ldao.CountMessageCommentsLikeDto(commentIdx);
	        MessageWriterIdx = mdao.getMessageOwner(messageIdx);
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    response.setCharacterEncoding("utf-8");
	    response.setContentType("application/json");
	    PrintWriter out = response.getWriter();
	    JSONObject obj = new JSONObject();
	    obj.put("result", 1);
	    obj.put("commentIdx", commentIdx);
	    obj.put("content", content);
	    obj.put("writeDate", dto.getWriteDate());
	    obj.put("profile", dto.getMemberDto().getProfileImg());
	    obj.put("nickname", dto.getMemberDto().getNickname());
	    obj.put("cnt", cnt); // 좋아요 개수
	    obj.put("memberIdx", memberIdx); // 로그인한 사람
	    obj.put("writerIdx", dto.getMemberIdx()); // 작성자
	    obj.put("MessageWriterIdx", MessageWriterIdx);
	    out.println(obj); 
		}
	}