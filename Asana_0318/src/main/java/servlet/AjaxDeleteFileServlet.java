package servlet;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;

import dao.FileDao;

@WebServlet("/AjaxDeleteFileServlet")
public class AjaxDeleteFileServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int messageIdx = Integer.parseInt(request.getParameter("message_idx"));
		FileDao dao = new FileDao();
		try {
			dao.deleteFile(messageIdx);
		} catch (Exception e) {
			e.printStackTrace();
		}
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		JSONObject obj = new JSONObject();
		obj.put("result", 1);
		out.println(obj);
	}

}
