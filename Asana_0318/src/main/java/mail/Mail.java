package mail;

import java.util.Properties;
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class Mail {
	    // 이메일 전송 메소드
	    public static void sendMail(String recipientEmail, int authCode) {
	        // SMTP 서버 설정 (Gmail 사용)
	        Properties properties = new Properties();
	        properties.put("mail.smtp.host", "smtp.naver.com");
	        properties.put("mail.smtp.port", "587");
	        properties.put("mail.smtp.auth", "true");
	        properties.put("mail.smtp.starttls.enable", "true");

	        // 인증 정보 (발신자 이메일, 앱 비밀번호)
	        String senderEmail = "wjdrlfwn13@naver.com";  // 발신자 이메일 (여기에 본인의 Gmail 계정 사용)
	        String password = "soccer12!@";         // 앱 비밀번호

	        // 이메일 세션 생성
	        Session session = Session.getInstance(properties, new Authenticator() {
	            @Override
	            protected PasswordAuthentication getPasswordAuthentication() {
	                return new PasswordAuthentication(senderEmail, password);
	            }
	        });

	        try {
	            // 이메일 메시지 설정
	            Message message = new MimeMessage(session);
	            message.setFrom(new InternetAddress(senderEmail));  // 발신자 이메일 설정
	            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));  // 수신자 이메일 설정
	            message.setSubject("회원가입 인증 코드");  // 이메일 제목
	            String content = "안녕하세요! 회원가입을 위한 인증 코드입니다.\n\n" +
	                             "인증 코드: " + authCode + "\n\n" +
	                             "감사합니다.";
	            message.setText(content);  // 이메일 본문 내용 설정

	            // 이메일 전송
	            Transport.send(message);  // 메일 발송
	            System.out.println("인증 코드 이메일이 성공적으로 발송되었습니다.");

	        } catch (MessagingException e) {
	            e.printStackTrace();
	        }
	    }
	}