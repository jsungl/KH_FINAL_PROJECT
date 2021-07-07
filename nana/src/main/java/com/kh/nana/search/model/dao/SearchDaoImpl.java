package com.kh.nana.search.model.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.kh.nana.board.model.vo.Board;
import com.kh.nana.place.model.vo.Place;
import com.kh.nana.place.model.vo.PlaceExt;
import com.kh.nana.place.model.vo.PlacePet;
import com.kh.nana.place.model.vo.PlacePhoto;


@Repository
public class SearchDaoImpl implements SearchDao {

	@Autowired
	private SqlSessionTemplate session;
	
	@Override
	public List<PlaceExt> selectMainPlaceList(List<Integer> mainPlaceNo) {
		return session.selectList("search.selectMainPlaceList", mainPlaceNo);
	}

	@Override
	public String selectKeyword(String searchKeyword) {
		return session.selectOne("search.selectKeyword", searchKeyword);
	}

	@Override
	public void updateKeyword(String searchKeyword) {
		session.update("search.updateKeyword" ,searchKeyword);
	}

	@Override
	public void insertKeyword(String searchKeyword) {
		session.insert("search.insertKeyword",searchKeyword);
	}
	
	@Override
	public List<Integer> selectSearchPlaceNoList(String searchKeyword) {
		return session.selectList("search.selectSearchPlaceNoList", searchKeyword);
	}

	@Override
	public List<String> selectTop5KeywordList() {
		return session.selectList("search.selectTop5KeywordList");
	}
	
	@Override
	public List<PlaceExt> selectPlaceList(List<Integer> placeNoList) {
		return session.selectList("search.selectPlaceList", placeNoList);
	}
	
	@Override
	public List<Integer> selectDetailSearchPlaceNoList(HashMap<String, Object> map) {
		return session.selectList("selectDetailSearchPlaceNoList", map);
	}
	
	@Override
	public List<PlaceExt> selectThemePlaceList() {
		return session.selectList("search.selectThemePlaceList");
	}

	@Override
	public List<Integer> selectBoardLikeNoList() {
		return session.selectList("search.selectBoardLikeNoList");
	}

	@Override
	public List<Board> selectBoardLikeList(List<Integer> boardLikeNoList) {
		return session.selectList("search.selectBoardLikeList", boardLikeNoList);
	}

	@Override
	public List<Integer> selectPlaceLikeNoList() {
		return session.selectList("search.selectPlaceLikeNoList");
	}
	
	@Override
	public List<Place> selectPlaceLikeList(List<Integer> placeLikeNoList) {
		return session.selectList("search.selectPlaceLikeList", placeLikeNoList);
	}

	@Override
	public List<PlacePhoto> selectPlacePhotoList(List<Integer> placeList) {
		return session.selectList("search.selectPlacePhotoList", placeList);
	}
	
	@Override
	public List<Place> selectPlaceListByName(String keyword) {
		return session.selectList("selectPlaceListByName", keyword);
	}

	@Override
	public List<PlacePet> selectAllPlaceList() {
		return session.selectList("search.selectAllPlaceList");
	}

	@Override
	public List<PlacePet> selectPlaceListByDetailSearch1(Map<String, Object> map) {
		return session.selectList("selectPlaceListByDetailSearch1", map);
	}
	
	public List<PlaceExt> selectPlaceSortList(HashMap<String, Object> map) {
		return session.selectList("selectPlaceSortList", map);
	}
	
	
}
