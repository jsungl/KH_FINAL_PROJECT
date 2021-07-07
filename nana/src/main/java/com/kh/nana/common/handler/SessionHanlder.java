package com.kh.nana.common.handler;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.security.authentication.AbstractAuthenticationToken;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import lombok.extern.slf4j.Slf4j;

@Slf4j
public class SessionHanlder extends TextWebSocketHandler {

	
	 //로그인 한 전체 
	 List<WebSocketSession>sessions = new ArrayList<WebSocketSession>();
	 // 1대1 
	 Map<String, WebSocketSession>userSessionsMap = new HashMap<String, WebSocketSession>();


	// 서버에 접속 성공
	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		
		String loginId = "";
		
		sessions.add(session);
		if(getMemberId(session) != "")  {
			loginId = getMemberId(session);
			log.debug(loginId + " 연결 됨");
			userSessionsMap.put(loginId , session);
		}
		
	}

	// 소켓에 메세지를 보냈을 때
	@Override
	protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {

		log.debug("onmessage : {} from : {}", message, session);

		String msg = message.getPayload();

		log.debug("msg : {}", msg);

		if (StringUtils.isNotEmpty(msg)) {
			String senderName = null;
			String receverId = null;
			String toastMsg = null;
			
			/* 
			 * 메세지 분리
			 * chat:으로 시작할 경우 -> 채팅 알림
			 * 그 외 -> 게시물 좋아요 알림
			 * */
			if(msg.startsWith("chat:")) {
				msg = msg.replaceAll("chat:", "");
				toastMsg = "님으로부터 새 메세지가 도착했습니다.";
			}
			else {
				toastMsg = "님이 내 게시글을 좋아요 했습니다.";
			}
			
			String[] strs = msg.split(",");
			if(strs != null) {
				senderName = strs[0];
				receverId = strs[1];
			}
			
			toastMsg = senderName + toastMsg;
			
			if(userSessionsMap.get(receverId) != null) {
				WebSocketSession boardWriterSession = userSessionsMap.get(receverId);
				TextMessage txtMsg = new TextMessage(toastMsg);
				boardWriterSession.sendMessage(txtMsg);
			}
			
			
			//------------------
			
			
			/* 채팅 알림 처리 */
//			if(msg.startsWith("chat:")) {
//				//msg 형태 : "chat:{fromId},{receiveId}"
//				
//				msg = msg.replaceAll("chat:", "");
//				String[] strs = msg.split(",");
//				if(strs != null) {
//					String fromId = strs[0];
//					String receiveId = strs[1];
//					
//					WebSocketSession boardWriterSession = userSessionsMap.get(receiveId);
//					
//					TextMessage txtMsg = new TextMessage(fromId + "님으로부터 새 메세지가 도착했습니다.");
//					boardWriterSession.sendMessage(txtMsg);
//				}
//				
//				
//			/* 게시글 좋아요 알림 처리 */
//			}else {
//				String[] strs = msg.split(",");
//				
//				if (strs != null) {
//					String senderName = strs[0];
//					String receverId = strs[1];
//					//String boardNo = strs[2];
//
//					// 작성자가 로그인 해서 있다면
//					WebSocketSession boardWriterSession = userSessionsMap.get(receverId);
//
//					log.debug("boardWriterSession = {}", boardWriterSession);
//					// if("reply".equals(cmd) && boardWriterSession != null) {
//					TextMessage txtMsg = new TextMessage(
//							senderName + "님이 내 게시글</a>을 좋아요 했습니다.");
//					boardWriterSession.sendMessage(txtMsg);
//					// }
//				}
//			}

			

		}

	}

	// 연결이 해제됐을 때
	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
		userSessionsMap.remove(session.getId());
	}

	//접속한 유저의 세션을 조회하여 ID를 찾음
	private String getMemberId(WebSocketSession session) {
		//인증된 객체에서 멤버 가져오기
		
		AbstractAuthenticationToken principal;
		String userId = "";
		
		if(session.getPrincipal() != null) {
			principal = (AbstractAuthenticationToken)session.getPrincipal();
			userId = principal.getName();
		}
		
		return userId == "" ? "" : userId;

	}
}
