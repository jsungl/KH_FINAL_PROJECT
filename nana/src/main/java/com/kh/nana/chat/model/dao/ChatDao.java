package com.kh.nana.chat.model.dao;

import java.util.List;

import com.kh.nana.chat.model.vo.Chat;

public interface ChatDao {

	int insertChat(Chat chat);

	List<Chat> selectChatByAddress(String address);

	List<String> selectChatIdList();

}
