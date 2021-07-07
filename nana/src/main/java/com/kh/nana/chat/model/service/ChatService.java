package com.kh.nana.chat.model.service;

import java.util.List;

import com.kh.nana.chat.model.vo.Chat;

public interface ChatService {

	int insertChat(Chat chat);

	List<Chat> selectChatByAddress(String address);

	List<String> selectChatIdList();

}
