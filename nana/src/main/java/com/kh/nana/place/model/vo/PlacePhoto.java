package com.kh.nana.place.model.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class PlacePhoto {
	
	private int placePhotoNo;
	private int placeNo;
	private String originalFilename;
	private String renamedFilename;
}
