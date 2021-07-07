package com.kh.nana.mypage.model.vo;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@ToString()
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
public class MyPlaceLike {

	private int no;
	private String id;
	private int placeNo;
	private String placeName;
	private String address;
	private String content;
	
}
