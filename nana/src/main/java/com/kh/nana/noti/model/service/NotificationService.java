package com.kh.nana.noti.model.service;

import java.util.HashMap;
import java.util.List;

import com.kh.nana.noti.model.vo.Notification;

public interface NotificationService {

	int saveNoti(HashMap<String, String> map);

	List<Notification> selectAllNotification(String id);

	int deleteNoti(int notiNo);

}
