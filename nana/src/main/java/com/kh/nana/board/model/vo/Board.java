package com.kh.nana.board.model.vo;

import java.sql.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Board {
	
	private int boardNo;
	private int placeNo;
	private int courseNo;
	private String id;
	private String category; // chat, review, info
	private String title;
	private String content;
	private int readCount;
	private int likeCount;
	private Date writeDate;

}

