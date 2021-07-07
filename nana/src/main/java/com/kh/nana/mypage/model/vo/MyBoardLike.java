package com.kh.nana.mypage.model.vo;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@ToString(callSuper = true)
@NoArgsConstructor
@AllArgsConstructor
@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
public class MyBoardLike {

	private int no;
	private String id;
	private int boardNo;
	private String title;
	private String content;
	private String category;
	@DateTimeFormat(pattern = "yyyy-MM-dd")
	private Date writeDate;
	
}
