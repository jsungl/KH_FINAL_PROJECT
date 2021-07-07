package com.kh.nana.mypage.model.vo;

import org.springframework.format.annotation.DateTimeFormat;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@ToString(callSuper = true)
@NoArgsConstructor
@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
public class CourseExt extends Course {
	@DateTimeFormat(pattern = "yyyy-MM-dd")
	private CoursePhoto coursePhoto;
}
