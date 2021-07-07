package com.kh.nana.place.model.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kh.nana.place.model.dao.PlaceDao;
import com.kh.nana.place.model.vo.LocalPhoto;
import com.kh.nana.place.model.vo.Place;
import com.kh.nana.place.model.vo.PlaceExt;
import com.kh.nana.place.model.vo.PlaceLike;
import com.kh.nana.place.model.vo.PlacePhoto;

@Service
public class PlaceServiceImpl implements PlaceService {

	/* ------------------------------ youngmi ------------------------------ */

	@Autowired
	private PlaceDao placeDao;

	@Override
	public List<Map<String, Object>> selectCategoryList() {
		return placeDao.selectCategoryList();
	}

	@Override
	public List<Map<String, Object>> selectLocalList() {
		return placeDao.selectLocalList();
	}
	
	@Override
	public List<Place> selectPlaceList(Map<String, String> codeMap) {
		return placeDao.selectPlaceList(codeMap);
	}

	@Override
	public List<LocalPhoto> selectLocalPhotoList(String localCode) {
		return placeDao.selectLocalPhotoList(localCode);
	}

	@Override
	public String selectCategoryName(String categoryCode) {
		return placeDao.selectCategoryName(categoryCode);
	}

	@Override
	public String selectLocalName(String localCode) {
		return placeDao.selectLocalName(localCode);
	}
	
	@Override
	public Place selectPlaceByName(String placeName) {
		return placeDao.selectPlaceByName(placeName);
	}
	
	@Override
	public List<Map<String, Object>> selectPlaceListWithPhoto(Map<String, String> codeMap) {
		return placeDao.selectPlaceListWithPhoto(codeMap);
	}
	
	

	/* --------------------------------------------------------------------- */
	/* ------------------------------ yunjin ------------------------------ */


	@Override
	public PlaceExt selectOnePlace(int no) {
		return placeDao.selectOnePlace(no);
	}

	@Override
	public List<Place> selectAllPlaceList(Map<String, Object> page) {
		return placeDao.selectAllPlaceList(page);
	}

	@Override
	public int selectPlaceTotalContents() {
		return placeDao.selectPlaceTotalContents();
	}
	
	

	@Override
	public List<PlacePhoto> selectAllPlacePhoto(int placeNo) {
		return placeDao.selectAllPlacePhoto(placeNo);
	}

	@Override
	public int updatePlace(PlaceExt place) {
		int result = 0;

		// 1. 장소 업데이트
		result = placeDao.updatePlace(place);

		// 2. 사진 추가
		if (place.getPhotoList() != null && place.getPhotoList().size() > 0) {
			for (PlacePhoto photo : place.getPhotoList()) {
				photo.setPlaceNo(place.getPlaceNo());
				result = insertPlacePhoto(photo);
			}
		}

		return result;
	}

	@Transactional(rollbackFor = Exception.class)
	@Override
	public int insertPlace(PlaceExt place) {
		int result = 0;

		// 1. 장소 업데이트
		result = placeDao.insertPlace(place);

		// 2. 사진 추가
		if (place.getPhotoList().size() > 0) {
			for (PlacePhoto photo : place.getPhotoList()) {
				photo.setPlaceNo(place.getPlaceNo());
				result = insertPlacePhoto(photo);
			}
		}

		return result;
	}

	@Transactional(rollbackFor = Exception.class)
	@Override
	public int insertPlacePhoto(PlacePhoto placePhoto) {
		return placeDao.insertPlacePhoto(placePhoto);
	}

	@Override
	public int deleteOnePlace(int placeNo) {
		return placeDao.deleteOnePlace(placeNo);
	}

	@Override
	public int deletePlacePicture(int placeNo) {
		return placeDao.deletePlacePicture(placeNo);
	}


	@Override
	public PlaceLike placeLiked(Map<String, Object> map) {
		return placeDao.placeLiked(map);
	}

	@Override
	public int deletePlaceLike(PlaceLike placeLike) {
		return placeDao.deletePlaceLike(placeLike);
	}

	@Override
	public int insertPlaceLike(PlaceLike placeLike) {
		return placeDao.insertPlaceLike(placeLike);
	}

	
	@Override
	public int totalPlaceLikeCnt(int placeNo) {
		return placeDao.totalPlaceLikeCnt(placeNo);
	}

	@Override
	public int totalboardCnt(int placeNo) {
		return placeDao.totalboardCnt(placeNo);
	}
	
	
	/* --------------------------------------------------------------------- */



	@Override
	public List<Place> selectLikePlaceList(String id) {
		return placeDao.selectLikePlaceList(id);
	}
}
