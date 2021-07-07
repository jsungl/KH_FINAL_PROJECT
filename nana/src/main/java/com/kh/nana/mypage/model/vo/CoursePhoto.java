package com.kh.nana.mypage.model.vo;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CoursePhoto {
	private String id;
	private int no;
	private int imgNo;
	private String originalFilename;
	private String renamedFilename;
	private Date uploadDate;
}
