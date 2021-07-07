package com.kh.nana.search.model.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.nana.board.model.vo.Board;
import com.kh.nana.place.model.vo.Place;
import com.kh.nana.place.model.vo.PlaceExt;
import com.kh.nana.place.model.vo.PlacePet;
import com.kh.nana.place.model.vo.PlacePhoto;
import com.kh.nana.search.model.dao.SearchDao;

@Service
public class SearchServiceImpl implements SearchService {

	@Autowired
	private SearchDao searchDao;

	
	@Override
	public List<PlaceExt> selectMainPlaceList(List<Integer> mainPlaceNo) {
		return searchDao.selectMainPlaceList(mainPlaceNo);
	}

	@Override
	public String selectKeyword(String searchKeyword) {
		return searchDao.selectKeyword(searchKeyword);
	}

	@Override
	public void updateKeyword(String searchKeyword) {
		searchDao.updateKeyword(searchKeyword);
	}
	
	@Override
	public void insertKeyword(String searchKeyword) {
		searchDao.insertKeyword(searchKeyword);
	}

	@Override
	public List<Integer> selectSearchPlaceNoList(String searchKeyword) {
		return searchDao.selectSearchPlaceNoList(searchKeyword);
	}
	
	@Override
	public List<String> selectTop5KeywordList() {
		return searchDao.selectTop5KeywordList();
	}
	
	@Override
	public List<PlaceExt> selectPlaceList(List<Integer> placeNoList) {
		return searchDao.selectPlaceList(placeNoList);
	}
	
	@Override
	public List<Integer> selectDetailSearchPlaceNoList(HashMap<String, Object> map) {
		return searchDao.selectDetailSearchPlaceNoList(map);
	}
	
	@Override
	public List<PlaceExt> selectThemePlaceList() {
		return searchDao.selectThemePlaceList();
	}

	@Override
	public List<Integer> selectBoardLikeNoList() {
		return searchDao.selectBoardLikeNoList();
	}

	@Override
	public List<Board> selectBoardLikeList(List<Integer> boardLikeNoList) {
		return searchDao.selectBoardLikeList(boardLikeNoList);
	}
		
	@Override
	public List<Integer> selectPlaceLikeNoList() {
		return searchDao.selectPlaceLikeNoList();
	}

	@Override
	public List<Place> selectPlaceLikeList(List<Integer> placeLikeNoList) {
		return searchDao.selectPlaceLikeList(placeLikeNoList);
	}
	
	@Override
	public List<PlacePhoto> selectPlacePhotoList(List<Integer> placeList) {
		return searchDao.selectPlacePhotoList(placeList);
	}

	@Override
	public List<Place> selectPlaceListByName(String keyword) {
		return searchDao.selectPlaceListByName(keyword);
	}

	@Override
	public List<PlacePet> selectAllPlaceList() {
		return searchDao.selectAllPlaceList();
	}

	@Override
	public List<PlacePet> selectPlaceListByDetailSearch1(Map<String, Object> map) {
		return searchDao.selectPlaceListByDetailSearch1(map);
	}
	
	public List<PlaceExt> selectPlaceSortList(HashMap<String, Object> map) {
		return searchDao.selectPlaceSortList(map);
	}

}
