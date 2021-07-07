package com.kh.nana.noti.model.dao;

import java.util.HashMap;
import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.kh.nana.noti.model.vo.Notification;

@Repository
public class NotificationDaoImpl implements NotificationDao {

	@Autowired
	private SqlSessionTemplate session;

	@Override
	public int saveNoti(HashMap<String, String> map) {
		return session.insert("noti.saveNoti", map);
	}

	@Override
	public List<Notification> selectAllNotification(String id) {
		return session.selectList("noti.selectAllNotification", id);
	}

	@Override
	public int deleteNoti(int notiNo) {
		return session.delete("noti.deleteNoti", notiNo);
	}
	
	
}
