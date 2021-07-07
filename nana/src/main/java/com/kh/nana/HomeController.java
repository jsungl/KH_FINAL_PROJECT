package com.kh.nana;

import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedHashSet;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.kh.nana.board.model.vo.Board;
import com.kh.nana.chat.model.service.ChatService;
import com.kh.nana.chat.model.vo.Chat;
import com.kh.nana.common.util.HelloSpringUtils;
import com.kh.nana.member.model.vo.Member;
import com.kh.nana.place.model.vo.Place;
import com.kh.nana.place.model.vo.PlaceExt;
import com.kh.nana.place.model.vo.PlacePet;
import com.kh.nana.place.model.vo.PlacePhoto;
import com.kh.nana.search.model.service.SearchService;

import lombok.extern.slf4j.Slf4j;


/**
 * Handles requests for the application home page.
 */
@Controller
@Slf4j
public class HomeController {

	@Autowired
	private SearchService searchService;
	
	@Autowired
	private ChatService chatService;

	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);

	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(Model model, HttpSession session) {
		logger.info("index 페이지 요청!");
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		Object obj = authentication.getPrincipal();
		log.debug("member = {}",obj); //anonymousUser(String)
				
		// 메인슬라이드 장소번호 리스트
		List<Integer> mainPlaceNo = new ArrayList<>();
		mainPlaceNo.add(70);
		mainPlaceNo.add(84);
		mainPlaceNo.add(57);
		
		// 메인 슬라이드 컨텐츠 3개
		List<PlaceExt> mainPlace = searchService.selectMainPlaceList(mainPlaceNo); 
		model.addAttribute("mainPlace",mainPlace);
		
		// 최근 검색어
		List<String> keywordList = (List<String>) session.getAttribute("keywordList");
		// 최근 본 순서대로 reverse
		if (keywordList != null) {
			Collections.reverse(keywordList);
			// 중복 제거
			LinkedHashSet<String> reKeywordList = new LinkedHashSet<String>(keywordList);
			keywordList = new ArrayList<String>(reKeywordList);
			if (keywordList != null)
				model.addAttribute("keywordList", keywordList);
		}

		// 최근 본 장소
		List<Integer> visitList = (List<Integer>) session.getAttribute("visitList");
		if (visitList != null) {
			// 최근 본 순서대로 reverse
			Collections.reverse(visitList);
			// 중복 제거
			LinkedHashSet<Integer> reVisitList = new LinkedHashSet<Integer>(visitList);
			visitList = new ArrayList<Integer>(reVisitList);
			List<PlaceExt> visitPlace = searchService.selectPlaceList(visitList);
			// DB조회시 순서 뒤섞임 -> 최근본 순서로 셋팅
			List<PlaceExt> visitPlaceList = new ArrayList<>();
			for(int i = 0; i < visitList.size(); i++) {
				for(int j = 0; j < visitPlace.size(); j++) {
					if(visitList.get(i) == visitPlace.get(j).getPlaceNo()) { 
						visitPlaceList.add(i, visitPlace.get(j));
						break;
					}
				}
			}
			model.addAttribute("visitPlaceList", visitPlaceList);
			// reverse 원래대로
			visitList = (List<Integer>) session.getAttribute("visitList");
			Collections.reverse(visitList);
		}
		
		// 인기검색어
		List<String> top5Keyword = searchService.selectTop5KeywordList();
		session.setAttribute("top5Keyword", top5Keyword);
		
		// 랜덤 테마 장소
		List<PlaceExt> randomThemeList = searchService.selectThemePlaceList();
		model.addAttribute("themePlaceList", randomThemeList);

		// 게시글 좋아요 top3
		List<Board> boardLikeList = boardLikeList();
		model.addAttribute("boardLikeList", boardLikeList);

		// 장소 찜 top3
		List<PlaceExt> placeLikeList = placeLikeList(); 
		model.addAttribute("placeLikeList", placeLikeList);
		
		//상세검색 : 장소테이블 전체리스트(좌표)
		List<PlacePet> allPlaceList = searchService.selectAllPlaceList();
//		for(int i = 0; i < allPlaceList.size(); i++) {
//			log.debug("allPlaceList = {}",allPlaceList.get(i));
//		}
		//log.debug("allPlaceList = {}", allPlaceList);
		//log.debug("allPlaceList size = {}", allPlaceList.size());
		//log.debug("xcoord = {}", allPlaceList.get(0).getXCoord());
		//log.debug("ycoord = {}", allPlaceList.get(0).getYCoord());
		//log.debug("petCheck = {}", allPlaceList.get(0).getPet());
		model.addAttribute("allPlaceList", allPlaceList);
		
		
		//일반사용자 로그인 시 관리자와의 채팅 기록 가져오기
		List<Chat> chatList = getChatListForUser(obj);
		log.debug("chatList = {}", chatList);
		if(chatList != null)
			model.addAttribute("chatList", chatList);
		
		
		return "forward:/index.jsp";
	}
		
	/**
	 * 
	 * @param obj : SecurityContextHolder에서 가져온 principal객체
	 * @return
	 */
	private List<Chat> getChatListForUser(Object obj) {
		
		List<Chat> chatList = null;
		
		//비회원이 아닐 경우
		if(!obj.equals("anonymousUser")){
			Member loginMember = (Member)obj;
			String id = loginMember.getId();
			
			//관리자가 아닐 경우
			if(!"admin".equals(id)) {
				String address = "/ask/" + id;
				chatList = chatService.selectChatByAddress(address);
			}
		}
		
		return chatList;
	}

	private List<Board> boardLikeList() {
		// 게시글 top3 번호
		List<Integer> boardLikeNoList = searchService.selectBoardLikeNoList();
		// 게시글 top3 게시글
		List<Board> boardLikeList = searchService.selectBoardLikeList(boardLikeNoList);
		
		// 게시글 내용 잘라내기
		for(Board board : boardLikeList) {
			String html = board.getContent();
			String content = HelloSpringUtils.removeTag(html);
			content = StringUtils.abbreviate(content, 250);
//			log.debug(content);
			board.setContent(content);
		}
		return boardLikeList; 
	}
	
	private List<PlaceExt> placeLikeList() {
		// 장소 top3 번호
		List<Integer> placeLikeNoList = searchService.selectPlaceLikeNoList();
		// 장소 top3 장소
		return searchService.selectPlaceList(placeLikeNoList);
	}

	public List<PlacePhoto> placePhotoList(List<Place> placeList) {
		// placeNo 리스트
		List<Integer> list = new ArrayList<>();
		for (Place pList : placeList)
			list.add(pList.getPlaceNo());
		// 장소 사진 가져오기
		return searchService.selectPlacePhotoList(list);
	}

	@GetMapping("/error/accessDenied.do")
	public void accesDenied() {
	}

}
