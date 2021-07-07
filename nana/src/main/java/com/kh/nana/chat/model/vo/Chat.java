package com.kh.nana.chat.model.vo;

import java.util.Date;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class Chat {
	
	private int chatNo;
	private String fromId; // 송신자 id
	private String toAddress; // 보내는 주소
	private String message;
	private Date regTime;

}
