package util;

import java.util.Properties;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.Multipart;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;

public class MailSender {
	public void send(String emailTo, int code) {	// code : 6자리 숫자(int타입)
		// [1] 이메일 관련 전역 변수 설정
		String host = "smtp.naver.com";					// ★ (수정) SMTP 서버명 작성
		String port = "587";				// ★ (수정) POP3/SMTP 465  IMAP/SMTP 587
		final String id = "korea3zo@naver.com";			// ★ (수정) 송신자이메일주소
		final String pw = "korea1234";				// ★ (수정) 2차인증X ( 비밀번호 ) 2차인증 O ( 앱비밀번호 )
		String to = emailTo;				// ★ (수정) 수신자이메일주소
		String title = "제목임";
		String content = "<a href='http://localhost:9091/AsanaMVC/MailAuthInviteServlet?email="+emailTo+"&code="+code+"'>클릭 인증</div>";
		/*
		 * 멤버초대 메서드
		 * 누가 초대했는지 : loginMemberIdx
		 * 초대한 멤버의 내작업공간 번호 : loginMemberIdx가 소속한 MyWorkspaceIdx
		 *  
		 */
		// [2-1] 이메일 환경 설정 ( 공통 )
		Properties props = new Properties();
		props.put("mail.smtp.host", host);						// SMTP 호스트
		props.put("mail.smtp.port", port);						// SMTP 포트
		props.put("mail.smtp.auth", "true");					// 인증 허용
		props.put("mail.smtp.ssl.protocols", "TLSv1.2");		// SSL/TLS 버전 호환 설정
		props.put("mail.smtp.ssl.enable", "false");				// 자동적으로 보안 채널을 생성하여 메일을 전송 [ SSL/TLS ]
		props.put("mail.smtp.ssl.trust", host);					// 인증 서 관련 오류 발생
		props.put("mail.debug", "true");						// 디버그 활성화 여부
		props.put("mail.smtp.socketFactory.fallback", "false"); // 도메인 이름을 SSL 속성 변경함
		props.put("mail.smtp.starttls.enable", "true");			// 보안 관련 채널 생성해서 인증서 확인 등의 작업 [ Starttls ]
		props.put("mail.smtp.socketFactory.port", "587");
			
		try {
			
			// [3] 로그인 실시
			Session session = Session.getDefaultInstance(props, new Authenticator() {
				@Override
				protected PasswordAuthentication getPasswordAuthentication() {
					return new PasswordAuthentication(id, pw);
				}
			});
			
			// [4] 메시지 내용 보내기 설정
			MimeMessage message = new MimeMessage(session);
			message.setFrom(new InternetAddress(id));
			message.addRecipient(Message.RecipientType.TO, new InternetAddress(to));
			
			message.setSubject(title);	// ★ (수정) 메일제목
			message.setText(content);		// ★ (수정) 메일내용
			
			// [5] 메세지 발송 프로세스
			message.setSentDate(new java.util.Date());
			
			MimeBodyPart mbp1 = new MimeBodyPart();
			mbp1.setContent(content, "text/html;charset=UTF-8");
			Multipart mp = new MimeMultipart();
			mp.addBodyPart(mbp1);
			message.setContent(mp);
			
			Transport.send(message);
			
		}catch(Exception e) {
			e.printStackTrace();
		}
	}
	public static void main(String[] args) {
		MailSender obj = new MailSender();
//		obj.send("gusdntkd2@naver.com", 123567); // 됨
	}
}
