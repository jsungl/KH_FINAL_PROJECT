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
public class Course {

	private String id;
	private int no;
	private String title;
	@DateTimeFormat(pattern = "yyyy-MM-dd")
	private Date travelDate;
	private String travelLocal;
	private String content;
	private Date regDate;
	
}
