package com.kh.nana.place.model.vo;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@ToString(callSuper = true)
@NoArgsConstructor
@AllArgsConstructor
public class PlaceExt extends Place {

	private List<PlacePhoto> photoList;
	private int fromUser; // 0: 관리자 등록(default), 1: 사용자 등록
	private int boardCount;
	private int placeLikeCount;
}
