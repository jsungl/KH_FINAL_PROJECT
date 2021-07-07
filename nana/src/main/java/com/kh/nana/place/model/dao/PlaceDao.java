package com.kh.nana.place.model.dao;

import java.util.List;
import java.util.Map;

import com.kh.nana.place.model.vo.LocalPhoto;
import com.kh.nana.place.model.vo.Place;
import com.kh.nana.place.model.vo.PlaceExt;
import com.kh.nana.place.model.vo.PlaceLike;
import com.kh.nana.place.model.vo.PlacePhoto;

public interface PlaceDao {


	/* ------------------------------ youngmi ------------------------------ */
	List<Map<String, Object>> selectCategoryList();

	List<Map<String, Object>> selectLocalList();
	
//	List<Place> selectPlaceList();

	List<Place> selectPlaceList(Map<String, String> Code);
	
//	List<Place> selectLocalCodeList();

//	List<Place> selectPlaceListByLocalCode(String localCode);

	List<LocalPhoto> selectLocalPhotoList(String localCode);

	String selectCategoryName(String categoryCode);
	
	String selectLocalName(String localCode);
	
	Place selectPlaceByName(String placeName);
	
	List<Place> selectLikePlaceList(String id);
	
	List<Map<String, Object>> selectPlaceListWithPhoto(Map<String, String> codeMap);
	
	
	
	
	
	
	/* --------------------------------------------------------------------- */
	/* ------------------------------ yunjin ------------------------------ */
	
	PlaceExt selectOnePlace(int no);

	List<Place> selectAllPlaceList(Map<String, Object> page);

	int updatePlace(Place place);

	int insertPlacePhoto(PlacePhoto placePhoto);

	int selectPlaceTotalContents();

	int insertPlace(PlaceExt place);

	List<PlacePhoto> selectAllPlacePhoto(int placeNo);

	int deleteOnePlace(int placeNo);

	int deletePlacePicture(int placeNo);

	PlaceLike placeLiked(Map<String, Object> map);

	int deletePlaceLike(PlaceLike placeLike);

	int insertPlaceLike(PlaceLike placeLike);

	int totalPlaceLikeCnt(int placeNo);

	int totalboardCnt(int placeNo);

	
	/* --------------------------------------------------------------------- */

	
}
