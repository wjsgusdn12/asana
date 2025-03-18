<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	<script src="https://code.jquery.com/jquery-3.7.1.slim.min.js" integrity="sha256-kmHvs0B+OpCW5GVHUNjv9rOmY0IvSIRcf7zGUDTDQM8=" crossorigin="anonymous"></script>
	<script type="text/javascript">
		let webSocket = new WebSocket("ws://localhost:9092/WebProject3/broadcasting") //서버와 연결 
		webSocket.onmessage = function(e){
			$("#div_message").append("<p>" + e.data + "</p>") //서버쪽에서 남들이 말한거 
		}
		webSocket.onopen = function(e){
			alert("연결되었습니다.")
			
		}
		webSocket.onerror = function(e){
			alert("error ! ");
		}
		$(function(){
			$("#btn_send").click(function(){
				let my_id = $("#id_chat").val();
				let msg = $("#input_message").val();
				webSocket.send(my_id + "|" + msg); // 서버 쪽으로 메세지보내기 
				$("#div_message").append("<p> 나 : " + msg + "</p>"); //내가 말한건 
			});
		});
	</script>
</head>
<body>
	My ID : <input type="text" id="id_chat" value="(이름 쓰세요 )"/>
	Message : 
	<div id="div_message">
		<input type="text" id="input_message"/>
		<button id="btn_send">전송 </button>
	
	</div>

</body>
</html>