package com.kh.nana.noti.model.vo;

import java.sql.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Notification {

	int notiNo;
	int boardNo;
	String type;
	String senderName;
	String receverId;
	String messageContent;
	Date sendTime;
}
