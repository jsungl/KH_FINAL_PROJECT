package com.kh.nana.chat.model.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.kh.nana.chat.model.vo.Chat;

@Repository
public class ChatDaoImpl implements ChatDao {

	@Autowired
	private SqlSessionTemplate session;

	@Override
	public int insertChat(Chat chat) {
		return session.insert("chat.insertChat", chat);
	}

	@Override
	public List<Chat> selectChatByAddress(String address) {
		return session.selectList("chat.selectChatByAddress", address);
	}

	@Override
	public List<String> selectChatIdList() {
		return session.selectList("chat.selectChatIdList");
	}
	
	
	
}
