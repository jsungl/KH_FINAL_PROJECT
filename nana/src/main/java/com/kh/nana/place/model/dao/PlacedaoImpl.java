package com.kh.nana.place.model.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.kh.nana.place.model.vo.LocalPhoto;
import com.kh.nana.place.model.vo.Place;
import com.kh.nana.place.model.vo.PlaceExt;
import com.kh.nana.place.model.vo.PlaceLike;
import com.kh.nana.place.model.vo.PlacePhoto;


@Repository
public class PlacedaoImpl implements PlaceDao {

	@Autowired
	private SqlSessionTemplate session;
	
	/* ------------------------------ youngmi ------------------------------ */

	@Override
	public List<Map<String, Object>> selectCategoryList() {
		return session.selectList("place.selectCategoryList");
	}

	@Override
	public List<Map<String, Object>> selectLocalList() {
		return session.selectList("place.selectLocalList");
	}

	//	@Override
//	public List<Place> selectPlaceList() {
//		return session.selectList("place.selectPlaceList");
//	}
	
	@Override
	public List<Place> selectPlaceList(Map<String, String> code) {
		return session.selectList("place.selectPlaceList", code);
	}

//	@Override
//	public List<Place> selectLocalCodeList() {
//		return session.selectList("place.selectLocalCodeList");
//	}

//	@Override
//	public List<Place> selectPlaceListByLocalCode(String localCode) {
//		return session.selectList("place.selectPlaceListByLocalCode", localCode);
//	}

	@Override
	public List<LocalPhoto> selectLocalPhotoList(String localCode) {
		return session.selectList("place.selectLocalPhotoList", localCode);
	}
	
	@Override
	public String selectCategoryName(String categoryCode) {
		return session.selectOne("place.selectCategoryName", categoryCode);
	}

	@Override
	public String selectLocalName(String localCode) {
		return session.selectOne("place.selectLocalName", localCode);
	}

	@Override
	public Place selectPlaceByName(String placeName) {
		return session.selectOne("place.selectPlaceByName", placeName);
	}

	@Override
	public List<Map<String, Object>> selectPlaceListWithPhoto(Map<String, String> codeMap) {
		return session.selectList("place.selectPlaceListWithPhoto", codeMap);
	}
	
	
	
	
	

	/* -------------------------------------------------------------------- */
	/* ------------------------------ yunjin ------------------------------ */
	@Override
	public PlaceExt selectOnePlace(int placeNo) {
		return session.selectOne("place.selectOnePlace", placeNo);
	}

	@Override
	public List<Place> selectAllPlaceList(Map<String, Object> page) {
		int offset = (int)page.get("offset");
		int limit = (int)page.get("limit");
		RowBounds rowBounds = new RowBounds(offset, limit);
		return session.selectList("place.selectAllPlaceList", null, rowBounds);
	}

	
	
	@Override
	public List<PlacePhoto> selectAllPlacePhoto(int placeNo) {
		return session.selectList("place.selectAllPlacePhoto", placeNo);
	}

	@Override
	public int selectPlaceTotalContents() {
		return session.selectOne("place.selectPlaceTotalContents");
	}

	@Override
	public int updatePlace(Place place) {
		return session.update("place.updatePlace", place);
	}

	
	@Override
	public int insertPlace(PlaceExt place) {
		return session.insert("place.insertPlace", place);
	}

	@Override
	public int insertPlacePhoto(PlacePhoto placePhoto) {
		return session.update("place.insertPlacePhoto", placePhoto);
	}

	@Override
	public int deleteOnePlace(int placeNo) {
		return session.delete("place.deleteOnePlace", placeNo);
	}

	@Override
	public int deletePlacePicture(int placeNo) {
		return session.delete("place.deletePlacePhoto", placeNo);
	}

	@Override
	public PlaceLike placeLiked(Map<String, Object> map) {
		return session.selectOne("place.selectPlaceLiked", map);
	}

	@Override
	public int deletePlaceLike(PlaceLike placeLike) {
		return session.delete("place.deletePlaceLike", placeLike);
	}

	@Override
	public int insertPlaceLike(PlaceLike placeLike) {
		return session.insert("place.insertPlaceLike", placeLike);
	}

	@Override
	public int totalPlaceLikeCnt(int placeNo) {
		return session.selectOne("place.totalPlaceLikeCnt", placeNo);
	}
	
	@Override
	public int totalboardCnt(int placeNo) {
		return session.selectOne("place.totalboardCnt", placeNo);
	}
	
	/* -------------------------------------------------------------------- */
	


	@Override
	public List<Place> selectLikePlaceList(String id) {
		return session.selectList("place.selectLikePlaceList",id);
	}
	
}
