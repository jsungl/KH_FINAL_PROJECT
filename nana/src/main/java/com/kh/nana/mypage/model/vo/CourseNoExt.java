package com.kh.nana.mypage.model.vo;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@ToString(callSuper = true)
@NoArgsConstructor
@AllArgsConstructor
public class CourseNoExt extends Course {

	private int courseNo;

	public CourseNoExt(String id, int no, String title, Date travelDate, String travelLocal, String content,
			Date regDate, int courseNo) {
		super(id, no, title, travelDate, travelLocal, content, regDate);
		this.courseNo = courseNo;
		
	}
	
	

}
