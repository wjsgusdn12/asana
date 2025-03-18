package servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Properties;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;

@WebServlet("/AjaxInvitationMailSender")
public class AjaxInvitationMailSender extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private void sendMail(String emailAddress) throws AddressException, MessagingException {
		Properties properties = new Properties();
		properties.put("mail.smtp.host", "smtp.naver.com");
		properties.put("mail.smtp.port", "587");   // 587
		properties.put("mail.smtp.auth", "true");
		properties.put("mail.smtp.starttls.enable", "true");

		Session session = Session.getInstance(properties,
		    new Authenticator() {
		        protected PasswordAuthentication getPasswordAuthentication() {
		            return new PasswordAuthentication("korea3zo@naver.com", "korea1234");
		        }
		    });
		
		Message message = new MimeMessage(session);
		message.setFrom(new InternetAddress("korea3zo@naver.com"));
		message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(emailAddress));
		message.setSubject("자바메일API 테스트 제목입니당. Testing JavaMail API");
		
		String content = "<div style='color:red; font-size:27px;'>머시기머시기...</div>";
		//message.setText(content);  // not working.
		
		MimeBodyPart mbp1 = new MimeBodyPart();
		mbp1.setContent(content, "text/html;charset=UTF-8");

		Multipart mp = new MimeMultipart();
		mp.addBodyPart(mbp1);

		message.setContent(mp);

		Transport.send(message);
	}
	
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String email = request.getParameter("email");
		
		//System.out.println("요청 들어옴 mail sender, 다음 주소로 메일 발송: " + email);

		String[] arrEmail = email.split("\n");
		
		for(String emailAddress : arrEmail) {
			try {
				sendMail(emailAddress);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		JSONObject obj = new JSONObject();
		obj.put("result", 1);
		out.println(obj);
	}
}
