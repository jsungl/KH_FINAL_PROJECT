package com.kh.nana.noti.model.dao;

import java.util.HashMap;
import java.util.List;

import com.kh.nana.noti.model.vo.Notification;

public interface NotificationDao {

	int saveNoti(HashMap<String, String> map);

	List<Notification> selectAllNotification(String id);

	int deleteNoti(int notiNo);

}
