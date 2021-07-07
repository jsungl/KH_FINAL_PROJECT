package com.kh.nana.search.model.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.kh.nana.board.model.vo.Board;
import com.kh.nana.place.model.vo.Place;
import com.kh.nana.place.model.vo.PlaceExt;
import com.kh.nana.place.model.vo.PlacePet;
import com.kh.nana.place.model.vo.PlacePhoto;

public interface SearchService {

	List<PlaceExt> selectMainPlaceList(List<Integer> mainPlaceNo);
	
	String selectKeyword(String searchKeyword);

	void updateKeyword(String searchKeyword);

	void insertKeyword(String searchKeyword);
	
	List<Integer> selectSearchPlaceNoList(String searchKeyword);
	
	List<String> selectTop5KeywordList();

	List<PlaceExt> selectPlaceList(List<Integer> placeNoList);
	
	List<Integer> selectDetailSearchPlaceNoList(HashMap<String, Object> map);
	
	List<PlaceExt> selectThemePlaceList();
	
	List<Integer> selectPlaceLikeNoList();

	List<Place> selectPlaceLikeList(List<Integer> placeLikeNoList);
	
	List<Integer> selectBoardLikeNoList();
	
	List<Board> selectBoardLikeList(List<Integer> boardLikeNoList);
	
	List<PlacePhoto> selectPlacePhotoList(List<Integer> placeList);

	List<Place> selectPlaceListByName(String keyword);

	List<PlacePet> selectAllPlaceList();

	List<PlacePet> selectPlaceListByDetailSearch1(Map<String, Object> map);

	List<PlaceExt> selectPlaceSortList(HashMap<String, Object> map);

}
