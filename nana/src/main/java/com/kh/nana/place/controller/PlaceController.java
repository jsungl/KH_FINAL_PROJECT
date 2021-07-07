package com.kh.nana.place.controller;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javax.servlet.http.HttpServletRequest;

import java.util.Properties;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ClassPathResource;
import org.springframework.http.MediaType;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kh.nana.board.model.service.BoardService;
import com.kh.nana.board.model.vo.Board;
import com.kh.nana.common.util.HelloSpringUtils;
import com.kh.nana.member.model.vo.Member;
import com.kh.nana.place.model.service.PlaceService;
import com.kh.nana.place.model.vo.LocalPhoto;
import com.kh.nana.place.model.vo.PlaceExt;
import com.kh.nana.place.model.vo.PlaceLike;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/place")
public class PlaceController {
	
	@Autowired
	private PlaceService placeService;
	
	@Autowired
	private BoardService boardService;

	/* ------------------------------ youngmi ------------------------------ */
	@GetMapping("/localDetail.do")
	public void localDetail(@RequestParam String localCode, Model model) throws IOException {
		log.debug("localCode = {}", localCode);
		
		//지역명 1개 ->장소리스트에서 하나 빼내기
		
		//지역사진 by 지역코드
		List<LocalPhoto> localPhotoList = placeService.selectLocalPhotoList(localCode);
		log.debug("localPhotoList = {}", localPhotoList);
	
		//카테고리 리스트
		List<Map<String, Object>> categoryList = placeService.selectCategoryList();
		log.debug("categoryList = {}", categoryList);
		
		//장소리스트 by localCode
		Map<String, String> codeMap = new HashMap<>();
		codeMap.put("localCode", localCode);
//		List<Place> placeList = placeService.selectPlaceList(codeMap);
		List<Map<String, Object>> placeList = placeService.selectPlaceListWithPhoto(codeMap);
		log.debug("placeList = {}", placeList);
		
		//지역명
//		String localName = placeList.get(0).getLocalName();
		Map<String, Object> map = placeList.get(0);
		String localName = (String)map.get("localName");
		
		//날씨 api key -> ajax
		
		
		//미세먼지 정보
		
		//model
		model.addAttribute("localPhotoList", localPhotoList);
		model.addAttribute("localCode", localCode);
		model.addAttribute("categoryList", categoryList);
		model.addAttribute("placeList", placeList);
		model.addAttribute("localName", localName);
	}
	
	@GetMapping(value="/weather.do", produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public String getWeather(@RequestParam(name="localCode", required = true) String localCode) {
		
		log.debug("localCode = {}", localCode);
		//1. 파라미터 준비
		/*
		 * serviceKey
		 numOfRow : 한 페이지 결과 수 / default 10
		 pageNo : 페이지 번호 / default 1
		 dataType : XML or JSON / default : JSON
		 base_date : 발표일자 / ex)20151201 (15년 12월 1일 발표)
		 base_time : 발표시각 / 0500 (05시 발표)
		 nx : 예보지점 x좌표
		 ny : 예보지점 y좌표		 
		 */
		URL url;
		StringBuilder sb = null;
		try {
			//serviceKey
			ClassPathResource resource = new ClassPathResource("apikeys.properties");
			log.debug("apikeys.properties = {}", resource.getFile());
			
			Properties prop = new Properties();
			String serviceKey = null;
	
			try{
				prop.load(new FileReader(resource.getFile()));
				serviceKey = prop.getProperty("serviceKey");
			}catch(IOException e){
				e.printStackTrace();
			}
			
			// base_date, base_time
			Date now = new Date();
			Map<String, String> dateAndTime = getDateAndTime(now);
			String baseDate = dateAndTime.get("baseDate");
			String baseTime = dateAndTime.get("baseTime");
			
			// nx, ny
			Map<String, Integer> xy = getXY(localCode);
			int nx = xy.get("x");
			int ny = xy.get("y");
			
			// put all the parameters to hashmap
			Map<String, Object> param = new HashMap<>();
			param.put("serviceKey", serviceKey);
			param.put("numOfRows", 50);
			param.put("pageNo", 1);
			param.put("dataType", "JSON");
			param.put("base_date", baseDate);
			param.put("base_time", baseTime);
			param.put("nx", nx);
			param.put("ny", ny);
			
			String apiUrl = "http://apis.data.go.kr/1360000/VilageFcstInfoService/getVilageFcst?";
			StringBuilder paramSb = new StringBuilder(apiUrl);
			for(Entry<String, Object> elem : param.entrySet()) {
				paramSb.append(elem.getKey() + "=" + elem.getValue() + "&");
			}
			String paramStr = (paramSb.substring(0, paramSb.length()-1)).toString();
			log.debug("paramStr = {}", paramStr);
			
			
			// 1. rest api 요청
			url = new URL(paramStr);
			HttpURLConnection conn = (HttpURLConnection)url.openConnection();
			conn.setRequestMethod("GET");
			conn.setDoInput(true);
			conn.setDoOutput(true);
			
			int responseCode = conn.getResponseCode();
			log.debug("responseCode = {}", responseCode);
			
			// 2, 읽을 준비
			BufferedReader br = null;
			if(responseCode >= 200 && responseCode <= 300) {
				br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "utf-8"));
			}
			else {
				br = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
			}
			
			//3. 응답메세지 : 자바 변수에 기록
			String data = null;
			sb = new StringBuilder();
			while((data = br.readLine()) != null) {
				sb.append(data);
			}
			log.debug("응답 json = {}", sb.toString());
			br.close();
			conn.disconnect();
			
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		//4. client에 전송
		return sb.toString();
		
	      /*
	       * 응답결과
         * POP	강수확률	 %
         * PTY	강수형태	코드값
         * R06	6시간 강수량	범주 (1 mm)
         * REH	습도	 %
         * S06	6시간 신적설	범주(1 cm)
         * SKY	하늘상태	코드값
         * T3H	3시간 기온	 ℃
         * TMN	아침 최저기온	 ℃
         * TMX	낮 최고기온	 ℃
         * UUU	풍속(동서성분)	 m/s
         * VVV	풍속(남북성분)	 m/s
         * WAV  파고 			M
         * VEC	풍향			deg
         * WSD	풍속			m/s
         */
	}
	
	private Map<String, String> getDateAndTime(Date now) {
		
		Calendar cal = Calendar.getInstance();
		cal.setTime(now);
		
		SimpleDateFormat sdfDate = new SimpleDateFormat("yyyyMMdd");
		SimpleDateFormat sdfTime = new SimpleDateFormat("HHmm");
		
		String baseDate = sdfDate.format(cal.getTime());
		String baseTime = sdfTime.format(cal.getTime());
		
		/**
		 * 현재시간에 따라 시간배치
		 * Base_time : 0200, 0500, 0800, 1100, 1400, 1700, 2000, 2300 (1일 8회)
		 */
		for(int i = 200; i <= 2300; i += 300) {
			int baseTimeInt = Integer.parseInt(baseTime);
			if(baseTimeInt < 200) {
				cal.add(Calendar.DATE, -1); //하루빼기
				baseDate = sdfDate.format(cal.getTime());
				baseTime = "2300";
				break;
			}
			else if(baseTimeInt >= i && baseTimeInt <= i + 259) {
				if(i < 1000) {
					baseTime = "0" + i;
				}else {
					baseTime = String.valueOf(i);
				}
				break;
			}
		}
		
		Map<String, String> map = new HashMap<>();
		map.put("baseDate", baseDate);
		map.put("baseTime", baseTime);
		
		return map;
		
	}
	
	
	private Map<String, Integer> getXY(String localCode) {
		Map<String, Integer> xy = new HashMap<>();
		/*
		 x/y좌표값
		 L1 서울 : 60, 27
		 L2 충청도(대전) : 67, 100
		 L3 전라도(광주) : 58, 74
		 L4 경기 : 60, 120
		 L5 강원 : 73, 134
		 L6 제주 : 52, 38
		 L7 경상(부산) : 98, 76
		*/
		switch(localCode){
		case "L1" : 
			xy.put("x", 60);
			xy.put("y", 27);
		case "L2" : 
			xy.put("x", 67);
			xy.put("y", 100);
		case "L3" : 
			xy.put("x", 58);
			xy.put("y", 74);
		case "L4" : 
			xy.put("x", 60);
			xy.put("y", 120);
		case "L5" : 
			xy.put("x", 73);
			xy.put("y", 134);
		case "L6" : 
			xy.put("x", 52);
			xy.put("y", 38);
		case "L7" : 
			xy.put("x", 98);
			xy.put("y", 76);

		}
		return xy;
	}
	
	
	
	@GetMapping("/categoryList.do")
	public void categoryList(@RequestParam String categoryCode,
							@RequestParam String localCode,
							@RequestParam String sort,
							Model model) {
		log.debug("categoryCode = {}, localCode = {}", categoryCode, localCode);
		log.debug("sort = {}", sort);
		
		//카테고리 리스트
		List<Map<String, Object>> categoryList = placeService.selectCategoryList();
		log.debug("categoryList = {}", categoryList);
		
		//지역리스트
		List<Map<String, Object>> localList = placeService.selectLocalList();
		log.debug("localList = {}", localList);
		
		//카테고리별 장소 리스트 조회 (장소별 대표사진 1개 표함)
		Map<String, String> codeMap = new HashMap<>();
		codeMap.put("categoryCode", categoryCode);
		codeMap.put("localCode", localCode); 
		codeMap.put("sort", sort); //'like-count', 'board-count', 'place-name'(default)
		log.debug("codeMap = {}", codeMap);
//		List<Place> placeList = placeService.selectPlaceList(codeMap);
		List<Map<String, Object>> placeList = placeService.selectPlaceListWithPhoto(codeMap);
		log.debug("placeList = {}", placeList);
		
		//장소설명 내용 잘라내기
		if(placeList != null) {
			for(Map<String, Object> place : placeList) {
				String content = (String)place.get("content");
				content = StringUtils.abbreviate(content, 70);
				log.debug("abbreviatedContent = {}", content);
				place.put("content", content);
			}
			
		}
		
		
		//지역명
		String categoryName = null;
		if(!("C0".equals(categoryCode))) {
			categoryName = placeService.selectCategoryName(categoryCode);
		}
		else {
			categoryName = "전체보기";
		}
		
		String localName = null;
		if(!("L0".equals(localCode))) {
			localName = placeService.selectLocalName(localCode);
		}
		else {
			localName = "전체지역";
		}
		
		log.debug("categoryName = {}, localName = {}", categoryName, localName);
		
		//동적 조건 : categoryCode and localCode
		//전체보기(c0)의 경우 where절 없이 전체조회 -> mapper에서 동적으로 처리
		
		// model.addAttribute("placeList")
		// model.addAttribute("categoryCode")
		// c0값은 DB에 없으니까 jsp에서 따로 삽입
		
		model.addAttribute("codeMap", codeMap);
		model.addAttribute("localName", localName);
		model.addAttribute("categoryName", categoryName);
		model.addAttribute("localList", localList);
		model.addAttribute("categoryList", categoryList);
		model.addAttribute("placeList", placeList);
		model.addAttribute("sort", sort);
		
	}
	/* ---------------------------------------------------------------------- */
	
	/* ------------------------------ yunjin ------------------------------ */

	@GetMapping("/placeDetail.do")
	public void placeDetail(Authentication authentication, 
			@RequestParam int placeNo,
			@RequestParam(required = false, defaultValue = "1") int cpage,
			Model model, HttpServletRequest request) throws IOException {
		try {
			log.debug("placeNo = {}", placeNo);
			
			String kakaoServiceKey = HelloSpringUtils.getApiKey("apikeys.properties", "kakaoServiceKey");
			String kakaoRestApiKey = HelloSpringUtils.getApiKey("apikeys.properties", "kakaoRestApiKey");
			
			PlaceExt place = placeService.selectOnePlace(placeNo);
			log.debug("place = {}", place);
			
			/* 로그인한 멤버가 있을 때 징소 찜 조회*/
			if(authentication != null) {
				Member principal = (Member)authentication.getPrincipal();
				String id = principal.getUsername();
				log.debug("member = {}", principal);
				
				Map<String, Object> map = new HashMap<>();
				map.put("placeNo", placeNo);
				map.put("id", id);
				PlaceLike placeLike = placeService.placeLiked(map);
				log.debug("placeLike = {}", placeLike);
				
				model.addAttribute("id", id);
				model.addAttribute("placeLike", placeLike);
			}
			
			// 페이지당 노출할 값
			final int limit = 3;
			int offset = (cpage - 1) * limit;

			Map<String, Object> page = new HashMap<>();
			page.put("limit", limit);
			page.put("offset", offset);
					
			/* 커뮤니티 게시글 불러오기 */
			List<Board> boardList = boardService.selectBoardListByPlaceNo(placeNo, page);
			
			/* 페이징 불러오기 */
			int totalBoardContents = boardService.totalBoardContentByPlaceNo(placeNo);
			String url = request.getRequestURI() + "?placeNo=" + placeNo;
			String pageBar = HelloSpringUtils.getPageBar(totalBoardContents, cpage, limit, url);
			
			log.debug("board = {}", boardList);
			/* 게시글 내용 잘라내기 */
			if(boardList != null) {
				for(Board board : boardList) {
					String html = board.getContent();
					String content = HelloSpringUtils.removeTag(html);
					//abbreviate(문자열, 말줄임표(...)를 포함해서 노출할 글자 수)
					content = StringUtils.abbreviate(content, 80);
					log.debug("content = {}", content);
					board.setContent(content);
				}
			}
			/* 장소 찜, 게시글 수 불러오기 */
			int placeLikeCnt = placeService.totalPlaceLikeCnt(placeNo);
			int boardCnt = placeService.totalboardCnt(placeNo);
			
			
			
			model.addAttribute("place", place);
			/* model.addAttribute("length", place.getPhotoList().size()); */
			model.addAttribute("kakaoServiceKey", kakaoServiceKey);
			model.addAttribute("kakaoRestApiKey", kakaoRestApiKey);
			model.addAttribute("placeLikeCnt", placeLikeCnt);
			model.addAttribute("boardCnt", boardCnt);
			model.addAttribute("boardList", boardList);
			model.addAttribute("pageBar", pageBar);
		} catch (Exception e) {
			log.error("장소 상세페이지 오류", e);
			throw e;
		}
		

	}
	
	@ResponseBody
	@PostMapping("/likePlace.do")
	public String likePlace(PlaceLike placeLike) {
		log.debug("palceLike = {}", placeLike);
		int result = 0;
		String str = "";
		
		try {
			if(placeLike.getLikeValiable() > 0) {
				//like 삭제
				result = placeService.deletePlaceLike(placeLike);
				str = "delete";
			}
			else {
				//like 추가
				result = placeService.insertPlaceLike(placeLike);
				str = "insert";
			}
		} catch (Exception e) {
			log.error("좋아요 오류", e);
			throw e;
		}
		return str;
	}
	
	/* ---------------------------------------------------------------------- */
}
