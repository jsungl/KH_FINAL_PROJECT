package com.kh.nana.board.model.vo;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class BoardComment {
	
	private int replyNo;
	private int commentLevel; // 1: 댓글, 2: 대댓글
	private String id;
	private String content;
	private int boardNo;
	private int commentRef;
	private Date regDate;

}
