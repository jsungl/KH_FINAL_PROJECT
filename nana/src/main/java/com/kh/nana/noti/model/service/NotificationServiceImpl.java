package com.kh.nana.noti.model.service;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.nana.noti.model.dao.NotificationDao;
import com.kh.nana.noti.model.vo.Notification;

@Service
public class NotificationServiceImpl implements NotificationService {

	@Autowired
	NotificationDao notificationDao;

	@Override
	public int saveNoti(HashMap<String, String> map) {
		return notificationDao.saveNoti(map);
	}

	@Override
	public List<Notification> selectAllNotification(String id) {
		return notificationDao.selectAllNotification(id);
	}

	@Override
	public int deleteNoti(int notiNo) {
		return notificationDao.deleteNoti(notiNo);
	}
	
	
}
