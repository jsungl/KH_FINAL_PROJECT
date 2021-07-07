package com.kh.nana.admin.controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ResourceLoader;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.kh.nana.board.model.service.BoardService;
import com.kh.nana.board.model.vo.Board;
import com.kh.nana.board.model.vo.BoardComment;
import com.kh.nana.chat.model.service.ChatService;
import com.kh.nana.chat.model.vo.Chat;
import com.kh.nana.common.util.HelloSpringUtils;
import com.kh.nana.member.model.service.MemberService;
import com.kh.nana.member.model.vo.Member;
import com.kh.nana.place.model.service.PlaceService;
import com.kh.nana.place.model.vo.Place;
import com.kh.nana.place.model.vo.PlaceExt;
import com.kh.nana.place.model.vo.PlacePhoto;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/admin")
public class AdminController {

	@Autowired
	private PlaceService placeService;
	
	@Autowired
	private MemberService memberService;

	@Autowired
	private ServletContext application;

	@Autowired
	private ResourceLoader resourceLoader;
	
	@Autowired
	private BoardService boardService;
	
	@Autowired
	private ChatService chatService;
	
	
	/**
	 * 관리자페이지 첫화면
	 */
	@GetMapping("/adminManagement.do")
	public void adminManagement() {
		
	}
	
	@GetMapping("/adminPlaceList.do")
	public void AdminPlaceList(Model model, @RequestParam(required = true, defaultValue = "1") int cpage,
			HttpServletRequest request) {

		// 페이지당 노출할 값
		final int limit = 10;
		int offset = (cpage - 1) * limit;

		Map<String, Object> page = new HashMap<>();
		page.put("limit", limit);
		page.put("offset", offset);

		List<Place> placeList = placeService.selectAllPlaceList(page);

		int totalContents = placeService.selectPlaceTotalContents(); // 110
		String url = request.getRequestURI();
		log.debug("totalContents = {}, url = {}", totalContents, url);
		log.debug("cPage = {}", cpage);
		log.debug("placeList = {}", placeList);
		

		String pageBar = HelloSpringUtils.getPageBar(totalContents, cpage, limit, url);
		
		
		model.addAttribute("placeList", placeList);
		model.addAttribute("pageBar", pageBar);
		model.addAttribute("cpage", cpage);
		

	}
	
	/**
	 * 회원목록 리스트 페이지
	 * @param model
	 * @param cpage
	 * @param request
	 */
	@GetMapping("/memberList.do")
	public void MemberList(Model model, @RequestParam(required = true, defaultValue = "1") int cpage,
			HttpServletRequest request) {
		log.debug("cpage = {}",cpage);
		final int limit = 10;
		int offset = (cpage - 1) * limit;

		Map<String, Object> page = new HashMap<>();
		page.put("limit", limit);
		page.put("offset", offset);
		List<Member> memberList = memberService.selectMemberList(page);
		log.debug("memberList = {}", memberList);
		
		int totalMemberCount = memberService.selectTotalMember();
		log.debug("totalMemberCount = {}", totalMemberCount);
		String url = request.getRequestURI();
		
		
		String memberPageBar = HelloSpringUtils.getPageBar(totalMemberCount, cpage, limit, url);
		
		model.addAttribute("memberList", memberList);
		model.addAttribute("page", cpage);
		model.addAttribute("memberPageBar", memberPageBar);
	}
	
	
	/*
	 * 장소관리 페이지
	 */
	@GetMapping("/adminPlaceForm.do")
	public void adminPlaceForm(Model model) {
		String kakaoServiceKey = HelloSpringUtils.getApiKey("apikeys.properties", "kakaoServiceKey");
		model.addAttribute("kakaoServiceKey", kakaoServiceKey);
	}

	@ResponseBody
	@PostMapping("/adminPlaceForm.do")
	public Map<String, Object> adminPlaceForm(MultipartHttpServletRequest request, PlaceExt place, RedirectAttributes redirectAttr)
			throws Exception {

		Map<String, Object> map;
		
		try {
			log.debug("request = {}", request);
			Iterator<String> iterator = request.getFileNames();
			MultipartFile multipartFile = null;
			
			String saveDirectory = application.getRealPath("resources/upload/place");

			//디렉토리 생성
			File dir = new File(saveDirectory);
			// 디렉토리가 존재하지 않는다면 생성한다
			if (!dir.exists())
				dir.mkdirs(); // 복수 개의 디렉토리를 생성한다
			
			// 파일이 저장될 폴더
			List<PlacePhoto> photoList = new ArrayList<>();

			while (iterator.hasNext()) {
				multipartFile = request.getFile(iterator.next());
				if (multipartFile.isEmpty() == false) {

					log.debug("------------- file start -------------");
					log.debug("name : " + multipartFile.getName());
					log.debug("filename : " + multipartFile.getOriginalFilename());
					log.debug("size : " + multipartFile.getSize());
					log.debug("-------------- file end --------------\n");

					String renamedFilename = HelloSpringUtils.getRenamedFilename(multipartFile.getOriginalFilename());

					// 서버 컴퓨터에 저장
					File dest = new File(saveDirectory, renamedFilename);
					multipartFile.transferTo(dest);

					// 저장된 데이터를 Photo객체에 저장 및 list에 추가
					PlacePhoto photo = new PlacePhoto();
					photo.setOriginalFilename(multipartFile.getOriginalFilename());
					photo.setRenamedFilename(renamedFilename);
					photoList.add(photo);
				}
			}

			place.setPhotoList(photoList);
			log.debug("insertPlace = {}", place);

			// 업무로직
			int result = placeService.insertPlace(place);
			
			map = new HashMap<>();

			// 사용자 피드백, redirect
			if (result > 0) {
				map.put("msg", "장소 추가 성공!");
				
				//등록한 장소 정보 가져오기 (placeName, placeNo)
				String placeName = place.getPlaceName();
				Place insertedPlace = placeService.selectPlaceByName(placeName);
				map.put("place", insertedPlace);
			}
			else
				map.put("msg", "장소 추가 실패!");

		}	catch (IOException e) {
			log.error("장소 등록 오류", e);
			throw e;
		}
		
		return map;
	}

	/**
	 * 
	 * 회원 수정 페이지
	 * @param placeNo
	 * @param cpage
	 * @param model
	 * @throws IOException
	 */
	@GetMapping("/updatePlace.do")
	public void updatePlace(@RequestParam int placeNo, @RequestParam(required = true, defaultValue = "1") int cpage, Model model) throws IOException {

		try {
			String kakaoServiceKey = HelloSpringUtils.getApiKey("apikeys.properties", "kakaoServiceKey");

			PlaceExt place = placeService.selectOnePlace(placeNo);

			System.out.println(place);

			model.addAttribute("place", place);
			model.addAttribute("kakaoServiceKey", kakaoServiceKey);
			model.addAttribute("cpage", cpage);
		} catch (Exception e) {
			log.error("회원 수정 페이지 로드 오류", e);
		}

	}

	@PostMapping("/updatePlace.do")
	public String updatePlace(@RequestParam(required = true, defaultValue = "1") int cpage, MultipartHttpServletRequest request, PlaceExt place, RedirectAttributes redirectAttr)
			throws Exception {

		try {
			log.debug("request = {}", request);
			Iterator<String> iterator = request.getFileNames();
			MultipartFile multipartFile = null;

			// 파일이 저장될 폴더
			String saveDirectory = application.getRealPath("resources/upload/place");

			List<PlacePhoto> photoList = new ArrayList<>();
			while (iterator.hasNext()) {
				multipartFile = request.getFile(iterator.next());
				if (multipartFile.isEmpty() != true) {

					
					log.debug("------------- file start -------------");
					log.debug("name : " + multipartFile.getName());
					log.debug("filename : " + multipartFile.getOriginalFilename());
					log.debug("size : " + multipartFile.getSize());
					log.debug("-------------- file end --------------\n");
					
					// 서버 폴더에 저장된 사진 파일 삭제
					int result = deletePlacePhoto(saveDirectory, place.getPlaceNo());

					String renamedFilename = HelloSpringUtils.getRenamedFilename(multipartFile.getOriginalFilename());

					// 2-1. 서버 컴퓨터에 저장
					File dest = new File(saveDirectory, renamedFilename);
					multipartFile.transferTo(dest);

					// 2-2. 저장된 데이터를 Photo객체에 저장 및 list에 추가
					PlacePhoto photo = new PlacePhoto();
					photo.setOriginalFilename(multipartFile.getOriginalFilename());
					photo.setRenamedFilename(renamedFilename);
					photoList.add(photo);
				}
			}

			place.setPhotoList(photoList);

			/* log.debug("upFiles = {} ", upFiles); */
			log.debug("place = {}", place);

			// 업무로직
			int result = placeService.updatePlace(place);

			// 사용자 피드백, redirect
			if (result > 0)
				redirectAttr.addFlashAttribute("msg", "장소 업데이트 성공!");
			else
				redirectAttr.addFlashAttribute("msg", "장소 업데이트 실패!");
		} catch (IOException e) {
			log.error("회원 수정 오류", e);
			throw e;
		}

		return "redirect:/admin/adminPlaceList.do?cpage=" + cpage;
	}

	@PostMapping("/deletePlace.do")
	public String deletePlace(@RequestParam int placeNo, @RequestParam int cpage, RedirectAttributes redirectAttr) throws IOException {
		int result = 0;
		try {
			List<PlacePhoto> placePhotos = placeService.selectAllPlacePhoto(placeNo);
			
			log.debug("plageNo = {}", placeNo);
			
			// 사진이 존재한다면 서버에 저장된 사진 삭제
			if (!(placePhotos.isEmpty())) {
				String saveDirectory = application.getRealPath("resources/upload/place");
				result = deletePlacePhoto(saveDirectory, placeNo);
			}

			result = placeService.deleteOnePlace(placeNo);

			if (result > 0)
				redirectAttr.addAttribute("msg", "장소 삭제 성공");
			else
				redirectAttr.addAttribute("msg", "장소 삭제 실패");
		} catch (IOException e) {
			log.error("회원 삭제 오류", e);
			throw e;
		}

		return "redirect:/admin/adminPlaceList.do?cpage=" + cpage;
	}

	public int deletePlacePhoto(String saveDirectory, int placeNo) throws IOException {

		int result = 0;
		List<PlacePhoto> photos = placeService.selectAllPlacePhoto(placeNo);

		try {
			for (PlacePhoto photo : photos) {
				Path path = Paths.get(saveDirectory);
				String fileName = photo.getRenamedFilename();
				Path filePath = path.resolve(fileName);
				Files.deleteIfExists(filePath);
			}
			result = placeService.deletePlacePicture(placeNo);

		} catch (IOException e) {
			log.error("장소 삭제 오류", e);
			throw e;
		}
		return result;
	}
	
	
	/**
	 * 회원삭제
	 * @param memberId
	 * @param redirectAttr
	 * @return
	 */
	@PostMapping("/deleteMember.do")
	public String deleteMember(@RequestParam String memberId, RedirectAttributes redirectAttr) {
		log.debug("memberId = {}",memberId);
		try {
			int result = memberService.deleteMember(memberId);
			if (result > 0)
				redirectAttr.addAttribute("msg", "회원 삭제 성공");
			else
				redirectAttr.addAttribute("msg", "회원 삭제 실패");
		} catch(Exception e) {
			log.error("회원 삭제 오류", e);
			throw e;
		}
		
		return "redirect:/admin/memberList.do";
	}
	
	/**
	 * 회원상세
	 * @param id
	 * @param model
	 */
	@GetMapping("/memberDetail.do")
	public void memberDetail(@RequestParam String id, Model model) {
		try {
			log.debug("memberId = {}", id);
			Member member = memberService.selectOneMember(id);
			log.debug("member = {}", member);
			List<Board> boardListById = boardService.selectBoardListById(id);
			log.debug("boardListById = {}", boardListById);
			List<Board> likeBoardList = boardService.selectLikeBoardList(id);
			log.debug("likeBoardList = {}",likeBoardList);
			List<Place> likePlaceList = placeService.selectLikePlaceList(id);
			log.debug("likePlaceList = {}",likePlaceList);
			List<BoardComment> boardCommentList = boardService.selectCommentListByAdmin(id);
			log.debug("boardCommentList = {}", boardCommentList);
			model.addAttribute("member", member);
			model.addAttribute("boardListById", boardListById);
			model.addAttribute("likeBoardList", likeBoardList);
			model.addAttribute("likePlaceList", likePlaceList);
			model.addAttribute("boardCommentList", boardCommentList);
			
		} catch(Exception e) {
			log.error("회원상세 조회 오류", e);
			throw e;
		}
	}
	

	@GetMapping("/adminPlaceDetail.do")
	public void adminPlaceDetail(@RequestParam int placeNo, Model model) {
		
		try {
			String kakaoServiceKey = HelloSpringUtils.getApiKey("apikeys.properties", "kakaoServiceKey");
			PlaceExt place = placeService.selectOnePlace(placeNo);
			log.debug("placeExt = {}", place);
			
			model.addAttribute("place", place);
			model.addAttribute("kakaoServiceKey", kakaoServiceKey);
		} catch (Exception e) {
			log.error("장소 디테일 불러오기 오류", e);
			throw e;
		}
	}
	
	@ResponseBody
	@GetMapping("/checkPlaceNameDupl.do")
	public Map<String, Object> checkPlaceNameDupl(@RequestParam String placeName) {
		boolean available = false;
		String placeName2 = "";
		Map<String, Object> map = new HashMap<>();
		
		
		try {
			Place place = placeService.selectPlaceByName(placeName);
			
			
			if(place != null) {
				available = false;
				placeName2 = place.getPlaceName();
			}
			else
				available = true;

			
			map.put("placeName", placeName2);
			map.put("available", available);
		} catch (Exception e) {
			log.error("장소 이름 중복 오류", e);
			throw e;
		}
		
		return map;
	}
	
	@GetMapping("/adminChatList.do")
	public void adminChatList(Model model) {
		
		List<String> chatIdList = chatService.selectChatIdList(); // admin빼고 다 나옴
		log.debug("chatIdList = {}", chatIdList);
		
		model.addAttribute("chatIdList", chatIdList);
		
	}
	
	@ResponseBody
	@GetMapping("/adminChatListById.do")
	public List<Chat> adminChatListById(@RequestParam String id){
		String toAddress = "/ask/" + id;
		log.debug("toAddress = {}", toAddress);
		List<Chat> chatList = null;
		
		try {
			chatList = chatService.selectChatByAddress(toAddress);
			log.debug("chatList = {}", chatList);
			
		}catch(Exception e) {
			log.error("채팅 기록 조회 오류", e);
			throw e;
		}
		
		return chatList;
		
	}

}
