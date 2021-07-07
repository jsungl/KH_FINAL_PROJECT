package com.kh.nana.chat.controller;

import java.util.Date;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

import com.kh.nana.chat.model.service.ChatService;
import com.kh.nana.chat.model.vo.Chat;

import lombok.extern.slf4j.Slf4j;

@Controller
//@RequestMapping("/chat")
@Slf4j
public class ChatController {
	
	@Autowired
	private SimpMessagingTemplate simpMessagingTemplate;
	
	@Autowired
	private ChatService chatService;
	
//	@GetMapping("/chat.do")
//	public void chat() {
//		
//	}

	/**
	 *  /app/a로 전달 시, /app가 ApplicationDestinationPrefixes에 등록되어있으므로
	 *  @MessageMapping("/a") messageHandler로 전달됨
	 *  - prefix 생략하고 작성할 것
	 *  
	 *  @SendTo("/bpp/a")에 의해 SimpleBroker로 전달된다.
	 *  - SimpleBroker에 /bpp가 등록되어 있어야 한다.
	 *  
	 * @param msg
	 * @return
	 */
	@MessageMapping("/a")
	@SendTo("/bpp/a")
	public String app(String msg) {
		log.debug("/app 요청 : {}", msg);
		return msg;
	}

	@MessageMapping("/{id}")
	@SendTo("/ask/{id}")
	public void sendMessage(@DestinationVariable String id, String msg) throws ParseException {
		log.debug("id = {}, msg = {}", id, msg);
		

		// 1. 메세지 정보 DB에 담기
		
		// 1-1. JSON타입의 msg를 parsing하기
		JSONParser parser = new JSONParser();
		JSONObject obj = (JSONObject) parser.parse(msg);
		
		Chat chat = new Chat();
		chat.setFromId((String)obj.get("fromId"));
		chat.setToAddress((String)obj.get("toAddress"));
		chat.setMessage((String)obj.get("message"));
		chat.setRegTime(new Date((long)obj.get("regTime")));
		// client에서 millis로 들어오는 시간 정보를 java.util.Date 타입으로 형변환 후 insert
		// (java.util.Date <-> Oracle date는 mybatis가 자동으로 형변환 해준다고 함)
		
		log.debug("chat = {}", chat);
		
		// 1-2. DB에 insert
		int result = chatService.insertChat(chat);
		
		// 2. /ask/admin으로도 메세지 보내기
		if(!id.equals("admin"))
			simpMessagingTemplate.convertAndSend("/ask/admin", msg);

		//알림 메세지 보내기
		
		String receiver = null;
		if(chat.getFromId().equals("admin")) {
			receiver = id;
		}else {
			receiver = "admin";
		}
		
		simpMessagingTemplate.convertAndSend("/ask/noti/" + receiver, msg);

		
	}
	
}
