package com.kh.nana.noti.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.socket.config.annotation.EnableWebSocket;
import org.springframework.web.socket.config.annotation.WebSocketConfigurer;
import org.springframework.web.socket.config.annotation.WebSocketHandlerRegistry;

import com.kh.nana.common.handler.SessionHanlder;

@Configuration
@EnableWebSocket 
public class NotificationConfig implements WebSocketConfigurer {

	@Autowired
	private SessionHanlder sessionHanlder;
	
	@Override
	public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
		registry
		.addHandler(sessionHanlder, "/notification")
		.withSockJS();
	}
	/*
	 * @Override public void registerStompEndpoints(StompEndpointRegistry registry)
	 * { //메세지를 송수신할 때 사용할 주소의 prefix
	 * registry.addEndpoint("notifications").withSockJS(); }
	 * 
	 * @Override public void configureMessageBroker(MessageBrokerRegistry registry)
	 * { //클라이언트는 /notification을 이용하여 브로커의 메세지를 읽는다.
	 * registry.enableSimpleBroker("/notification"); // 서버에서 클라이언트로부터의 메세지를 받을 api의
	 * prefix를 설정한다. registry.setApplicationDestinationPrefixes("/notification"); }
	 */

}
