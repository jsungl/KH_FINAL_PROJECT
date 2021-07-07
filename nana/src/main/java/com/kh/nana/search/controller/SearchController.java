package com.kh.nana.search.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.kh.nana.place.model.vo.Place;
import com.kh.nana.place.model.vo.PlaceExt;
import com.kh.nana.place.model.vo.PlacePet;
import com.kh.nana.search.model.service.SearchService;

import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/search")
@Slf4j
@SessionAttributes("loginMember")
public class SearchController {

	@Autowired
	private SearchService searchService;
	
	// 키워드 검색
	@GetMapping("/keyword.do")
	public void searchKeyword(@RequestParam(value="searchKeyword") String searchKeyword,
							  @RequestParam(value="sort") String sort,
							  Model model) {
		// 검색어 DB저장
		// 동일 키워드 검사
		String result = searchService.selectKeyword(searchKeyword);

		// null이나 공백 입력시 키워드 저장안하고 전체 리스트 출력
		if(!(searchKeyword == null || searchKeyword.trim().isEmpty())){
			if (searchKeyword.equals(result)) {
				// 동일한 키워드일 경우 카운트 증가
				searchService.updateKeyword(searchKeyword);
			}else {
				// 다른 키워드일 경우 새로 저장
				searchService.insertKeyword(searchKeyword);
			}
			model.addAttribute("searchKeyword", searchKeyword);
		}
		
		// 검색어가 포함된 장소 번호 리스트
		List<Integer> searchPlaceNoList = searchService.selectSearchPlaceNoList(searchKeyword);
		HashMap<String, Object> map = new HashMap<>();
		map.put("list", searchPlaceNoList);
		map.put("sort", sort);
		
		if(!searchPlaceNoList.isEmpty()) {
			List<PlaceExt> searchPlace = searchService.selectPlaceSortList(map);
			model.addAttribute("searchPlace", searchPlace);
			model.addAttribute("sort", sort);
		}
	}
	
	// 상세 검색 
	@PostMapping("/detailSearch.do")
	public String detailSearch(@RequestParam(value="detailSrchPlaceNo[]") String[] detailSrchPlaceNo,
							   @RequestParam(value="sort") String sort,
							   HttpServletRequest request,
							   Model model) {
		
		
		List<Integer> placeNoList = new ArrayList<>();
		if(detailSrchPlaceNo.length == 0) {
			placeNoList.add(0, 0); //검색조건에 맞는경우가 하나도 없을때
		}else {
			for(int i = 0; i < detailSrchPlaceNo.length; i++) {
				placeNoList.add(i, Integer.parseInt(detailSrchPlaceNo[i]));
			}	
		}

		HashMap<String, Object> map = new HashMap<>();
		map.put("list", placeNoList);
		map.put("sort", sort);
		
		List<PlaceExt> searchPlace = searchService.selectPlaceSortList(map);
		model.addAttribute("searchPlace", searchPlace);
		model.addAttribute("sort", sort);
		
		String endPlace = request.getParameter("endPlace");
		switch (endPlace) {
		case "L1":endPlace = "서울";break;
		case "L2":endPlace = "경기도/인천";break;
		case "L3":endPlace = "충청도/대전/세종";break;
		case "L4":endPlace = "전라도/광주";break;
		case "L5":endPlace = "강원도";break;
		case "L6":endPlace = "제주도";break;
		case "L7":endPlace = "경상도/부산/대구/울산";break;
		}

		String[] category = request.getParameterValues("category");
		for(int i = 0; i < category.length; i++) {
			switch (category[i]) {
			case "C1": category[i] = "랜드마크";break;
			case "C2": category[i] = "맛집";break;
			case "C3": category[i] = "오락";break;
			case "C4": category[i] = "레저/스포츠";break;
			case "C5": category[i] = "캠핑/차박";break;
			}
		}

		model.addAttribute("startPlace", request.getParameter("selectedStartPlace"));
		model.addAttribute("endPlace", endPlace);
		model.addAttribute("timeCost", request.getParameter("timeCost"));
		model.addAttribute("category", category);
		model.addAttribute("dueDate", request.getParameter("dueDate").isEmpty() ? "미정" :  request.getParameter("dueDate"));
		model.addAttribute("pet", "1".equals(request.getParameter("pet")) ? "펫 동반" : "");
		return "search/detailSearch";
	}
	
	/**
	 * 게시글 작성할 때 ajax로 장소 검색
	 */
	@GetMapping("/searchPlace.do")
	public ResponseEntity<Map<String, Object>> searchPlace(@RequestParam String keyword){
		log.debug("keyword = {}", keyword);
		Map<String, Object> map = null;
		try {
			List<Place> searchPlaceList = searchService.selectPlaceListByName(keyword);
			map = new HashMap<>();
			map.put("searchPlaceList", searchPlaceList);
			log.debug("map = {}", map);
			
		}catch(Exception e) {
			log.error("장소 ajax 검색 오류!", e);
			throw e;
		}
		return ResponseEntity.ok().header(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_JSON_UTF8_VALUE).body(map);
	}
	
	
	@GetMapping("/detailSearch1.do")
	@ResponseBody
	public Map<String,Object> detailSearch1(@RequestParam String endplace, @RequestParam(value="categoryArr[]") String[] categoryArr, @RequestParam int withPet){
		Map<String,Object> param = new HashMap<>();
		Map<String,Object> map = new HashMap<>();
		try {		
			map.put("endPlace", endplace);
			map.put("category", categoryArr);
			map.put("pet", withPet);
			List<PlacePet> list = searchService.selectPlaceListByDetailSearch1(map);
//			log.debug("list = {}", list);
			
			param.put("result", true);
			param.put("list", list);
		} catch(Exception e) {
			log.error("1차검색 오류!", e);
			throw e;
		}
		return param;
	}
	
	
}
