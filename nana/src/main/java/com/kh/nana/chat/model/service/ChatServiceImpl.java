package com.kh.nana.chat.model.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.nana.chat.model.dao.ChatDao;
import com.kh.nana.chat.model.vo.Chat;

@Service
public class ChatServiceImpl implements ChatService {

	@Autowired
	private ChatDao chatDao;

	@Override
	public int insertChat(Chat chat) {
		return chatDao.insertChat(chat);
	}

	@Override
	public List<Chat> selectChatByAddress(String address) {
		return chatDao.selectChatByAddress(address);
	}

	@Override
	public List<String> selectChatIdList() {
		return chatDao.selectChatIdList();
	}
	
	
	
}
