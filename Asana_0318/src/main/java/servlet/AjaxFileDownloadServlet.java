package servlet;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLDecoder;
import java.net.URLEncoder;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


@WebServlet("/AjaxFileDownloadServlet")
public class AjaxFileDownloadServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
doHandle(request, response);
}
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doHandle(request, response);
	}
	
	protected void doHandle(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setCharacterEncoding("utf-8");
		response.setContentType("application/json");
//		String file_repo = "/file_img";
		String fileName = (String)request.getParameter("fileName");
// URL디코딩 (나중에 삭제 later)
//System.out.println("URL디코딩 전 : " + fileName);
//		fileName = URLDecoder.decode(fileName, "UTF-8");
//System.out.println("URL디코딩 후 : " + fileName);
			
		ServletContext application = getServletContext(); // 중요x
		String path = application.getRealPath("file_img"); // 파일이 저장될 폴더 ("upload") 의 절대경로 
		System.out.println("(참고) 절대 경로 real path : " + path);
		
		System.out.println("fileName : " + fileName);
		OutputStream out = response.getOutputStream();
		System.out.println("OutputStream 생성완료");
//		String downFile = file_repo + "/" + fileName;
		String downFile = path + "\\" + fileName;
		File f = new File(downFile);
		System.out.println("File 생성완료"); 
		
		System.out.println("response.setHeader(\"Cache-Control\",  \"no-cache\"); 실행시작");
		// 여기까지 실행 됨, 밑으로 에러 , 예외 : \file_img\2번 메시지의 파일1.jpg (지정된 경로를 찾을 수 없습니다)
		
		fileName = URLEncoder.encode(fileName, "UTF-8");	// 없으면, 파일 한글이름 깨짐.
		
		response.setHeader("Cache-Control",  "no-cache");
		response.addHeader("Content-disposition",  "attachment; fileName = " + fileName);
		FileInputStream in = new FileInputStream(f);
		System.out.println("FileInputStream 생성완료");
		
		byte[] buffer = new byte[1024*8];
		System.out.println("buffer 생성완료");
		while(true) {
			System.out.println("while문 돌아가는중");
			int count = in.read(buffer);
			if(count==-1) break;
			out.write(buffer, 0, count);
		}
		in.close();
		out.close();
		
		
//		PrintWriter out2 = response.getWriter();
//		JSONObject obj = new JSONObject();
//		obj.put("fileName", fileName);
//		out2.print(obj);
	}

}
