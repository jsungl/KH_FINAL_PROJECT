package com.kh.nana.place.model.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Place {
	
	private int placeNo;
	private String placeName;
	private String localCode; //L1, L2, L3,...
	private String localName;
	private String categoryCode; // C1, C2, C3,...
	private String categoryName;
	private String address;
	private String content;
	// x좌표, y좌표 추가
	private double xCoord;
	private double yCoord;

}
