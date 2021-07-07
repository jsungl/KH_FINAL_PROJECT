package com.kh.nana.board.controller;


import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StopWatch;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.kh.nana.board.model.service.BoardService;
import com.kh.nana.board.model.vo.Board;
import com.kh.nana.board.model.vo.BoardComment;
import com.kh.nana.board.model.vo.BoardLike;
import com.kh.nana.common.util.HelloSpringUtils;
import com.kh.nana.member.model.vo.Member;
import com.kh.nana.mypage.model.service.CourseService;
import com.kh.nana.mypage.model.vo.CourseNoExt;
import com.kh.nana.place.model.service.PlaceService;
import com.kh.nana.place.model.vo.Place;
import com.kh.nana.place.model.vo.PlaceExt;

import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/board")
@Slf4j
public class BoardController {
	
	@Autowired
	private CourseService courseService;
	
	@Autowired
	private BoardService boardService;
	
	@Autowired
	private PlaceService placeService;
	

	@GetMapping("/boardList.do")
	public void boardList(@ModelAttribute Board board, Model model, @RequestParam(required=true, defaultValue = "1") int cpage,
			HttpServletRequest request) {
		StopWatch stopWatch = new StopWatch();
		stopWatch.start();
		
		
		log.debug("cpage = {}",cpage);
		final int limit = 10;
		int offset = (cpage - 1) * limit;

		Map<String, Object> page1 = new HashMap<>();
		page1.put("limit", limit);
		page1.put("offset", offset);
		List<Board> boardList = boardService.selectBoardList(page1);
		log.debug("boardList = {}", boardList);
		
		int selectTotalBoard = boardService.selectTotalBoard();
		log.debug("selectTotalBoard = {}", selectTotalBoard);
		String url = request.getRequestURI();
		
		
		String boardPageBar = HelloSpringUtils.getPageBar(selectTotalBoard, cpage, limit, url);
		
		model.addAttribute("boardList", boardList);
		model.addAttribute("page", cpage);
		model.addAttribute("boardPageBar", boardPageBar);
		
		stopWatch.stop();
		double duration = stopWatch.getTotalTimeSeconds();
		log.debug("소요시간 = {}", duration);
		
	}
	
	
	
	@GetMapping("/boardForm.do")
	public void boardForm(@RequestParam(name="boardNo", required=false)String boardNo, Authentication authentication, Model model) {
		//loginMember 객체 가져오기
		Member principal = (Member)authentication.getPrincipal();
		String id = principal.getId();
		log.debug("id = {}", id);
		
		log.debug("boardNo = {}", boardNo);
		Board board = null;
		Place place = null;
		if(boardNo != null) {
			//수정 시 게시글 조회
			board = boardService.selectBoardOne(Integer.parseInt(boardNo));
			log.debug("board = {}", board);
			
			//수정 시 선택한 장소 타이틀 가져오기
			place = placeService.selectOnePlace(board.getPlaceNo());
			log.debug("place = {}", place);
		}
		
		//id로 여행코스 리스트 조회
		List<CourseNoExt> courseList = courseService.selectCourseList(id);
		log.debug("courseList = {}", courseList);
		
		String kakaoServiceKey = HelloSpringUtils.getApiKey("apikeys.properties", "kakaoServiceKey");
		
		
		model.addAttribute("kakaoServiceKey", kakaoServiceKey);
		model.addAttribute("id", id);
		model.addAttribute("courseList", courseList);
		model.addAttribute("board", board);
		model.addAttribute("place", place);
	}
	
	@PostMapping("/insertBoard.do")
	public String insertBoard(@ModelAttribute Board board, RedirectAttributes redirectAttr) {
		log.debug("board = {}", board);
		
		try {
			//업무로직
			int result = boardService.insertBoard(board);
			
			//사용자 피드백 & 리다이렉트
			redirectAttr.addFlashAttribute("msg", "게시글 등록 성공!");
			

		}catch (Exception e) {
			log.error("board 등록 오류!", e);
			throw e;
		}
		
		return "redirect:/board/boardList.do";
		
	}
	
	@GetMapping("/boardDetail.do")
	public void boardDetail(@RequestParam int boardNo, Model model, Authentication authentication) {
		log.debug("boardNo = {}", boardNo);
		
		//게시물 조회
		Board board = boardService.selectBoardOne(boardNo);
		log.debug("board = {}", board);
		
		//조회수 추가
		int readCount = board.getReadCount();
		log.debug("readCount = {}", readCount);
		readCount++;
		log.debug("readCount++ = {}", readCount);
		
		board.setReadCount(readCount);
		
		Map<String, Object> param = new HashMap<>();
		param.put("boardNo", boardNo);
		param.put("readCount", readCount);
		int result = boardService.updateReadCount(param);
		
		
		//여행코스 제목 조회
		int courseNo = board.getCourseNo();
		String courseTitle = null;
		if(courseNo > 0)
			courseTitle = courseService.selectCourseTitleByNo(board.getCourseNo());
		log.debug("courseTitle = {}", courseTitle);
		
		//댓글 리스트 조회
		List<BoardComment> commentList = boardService.selectCommentList(boardNo);
		log.debug("commentList = {}", commentList);
		
		//댓글 수 조회
		int commentCount = boardService.selectCommentCount(boardNo);
		log.debug("commentCount = {}", commentCount);
		
		//로그인한 사용자 id
		Member loginMember = null;
		String id = null;
		if(authentication != null) {
			loginMember = (Member)authentication.getPrincipal();
			id = loginMember.getId();
		}
		log.debug("loginMember = {}", loginMember);
		log.debug("id = {}", id);
		
		//좋아요 수 조회
		int boardLikeCount = boardService.selectBoardLikeCount(boardNo);
		log.debug("boardLikeCount = {}", boardLikeCount);
		
		//로그인 한 사용자의 장소 좋아요 여부
		//Map<String, Object> param = new HashMap<>();
		//param.put("boardNo", boardNo);
		param.put("id", id);
		BoardLike boardLike = boardService.selectBoardLikeById(param);
		log.debug("boardLike = {}", boardLike);
		
		//게시물 연관 장소 조회
		PlaceExt place = placeService.selectOnePlace(board.getPlaceNo());
		log.debug("place = {}", place);
		
		model.addAttribute("board", board);
		model.addAttribute("place", place);
		model.addAttribute("id", id);
		model.addAttribute("commentList", commentList);
		model.addAttribute("commentCount", commentCount);
		model.addAttribute("courseTitle", courseTitle);
		model.addAttribute("boardLikeCount", boardLikeCount);
		model.addAttribute("boardLike", boardLike);
		
	}
	
	@GetMapping("/selectPlaceBoardForm.do")
	public void selectPlaceBoardForm(@RequestParam int placeNo, @RequestParam String placeName, Model model) {
		log.debug("placeNo = {}", placeNo);
		log.debug("placeName = {}", placeName);
		
		model.addAttribute("placeNo", placeNo);
		model.addAttribute("placeName", placeName);
	}
	
	@PostMapping("/selectPlaceBoardForm.do")
	public String selectPlaceBoardInsert(@ModelAttribute Board board, RedirectAttributes redirectAttr) {
		log.debug("board = {}", board);
		try {
			//업무로직
			int result = boardService.insertBoard(board);
			//사용자 피드백 & 리다이렉트
			redirectAttr.addFlashAttribute("msg", "게시글 등록 성공!");
		}catch (Exception e) {
			log.error("게시글 등록 오류!", e);
			throw e;
		}
		return "redirect:/board/boardList.do";
	}
	
	@PostMapping("/insertBoardComment.do")
	public String insertBoardComment(@ModelAttribute BoardComment boardComment, RedirectAttributes redirectAttr) {
		log.debug("boardComment = {}", boardComment);
		
		try {
			int result = boardService.insertBoardComment(boardComment);
			
			redirectAttr.addFlashAttribute("msg", "댓글 등록 성공!");
			
		}catch(Exception e) {
			log.error("댓글 등록 오류!", e);
			throw e;
		}
		
		return "redirect:/board/boardDetail.do?boardNo=" + boardComment.getBoardNo();
	}
	
	@PostMapping("/deleteComment.do")
	public String deleteBoardComment(@RequestParam int boardNo, @RequestParam int replyNo, RedirectAttributes redirectAttr) {		
		try {
			log.debug("boardNo = {}, replyNo = {}", boardNo, replyNo);
			int result = boardService.deleteBoardComment(replyNo);
			
			redirectAttr.addFlashAttribute("msg", "댓글 삭제 성공!");
		}catch(Exception e) {
			log.error("댓글 삭제 오류!", e);
			throw e;
		}
		
		
		return "redirect:/board/boardDetail.do?boardNo=" + boardNo;
	}
	
	@PostMapping("/deleteBoard.do")
	public String deleteBoard(@RequestParam int boardNo, RedirectAttributes redirectAttr) {
		try {
			log.debug("boardNo = {}", boardNo);
			
			int result = boardService.deleteBoard(boardNo);
			
			redirectAttr.addFlashAttribute("msg", "게시글 삭제 성공!");
			
		}catch(Exception e) {
			log.error("게시글 삭제 오류!", e);
			throw e;
		}
		
		return "redirect:/board/boardList.do";
	}
	
	@PostMapping("/updateBoard.do")
	public String updateBoard(@ModelAttribute Board board, RedirectAttributes redirectAttr) {
		try {
			log.debug("board = {}", board);
			
			int result = boardService.updateBoard(board);
			redirectAttr.addFlashAttribute("msg", "게시글 수정 성공!");
			
		}catch(Exception e) {
			log.error("게시글 수정 오류!", e);
			throw e;
		}
		
		return "redirect:/board/boardDetail.do?boardNo=" + board.getBoardNo();
	}
	
	@ResponseBody
	@PostMapping("/likeBoard.do")
	public Map<String, Object> likeBoard(BoardLike boardLike, @RequestParam int likeValVal) {
		log.debug("boardLike = {}, likeValVal = {}", boardLike, likeValVal);
		
		String code = "";
		int result = 0;
		if(likeValVal == 0) {
			result = boardService.insertBoardLike(boardLike);
			code = "insert";
		}
		else if(likeValVal == 1) {
			result = boardService.deleteBoardLike(boardLike);
			code = "delete";
		}
		int cnt = boardService.selectBoardLikeCount(boardLike.getBoardNo());
		
		//board테이블에 cnt값 insert
		Map<String, Object> param = new HashMap<>();
		param.put("boardNo", boardLike.getBoardNo());
		param.put("cnt", cnt);
		result = boardService.updateBoardLikeCount(param);
		
		//return할 map
		Map<String, Object> map = new HashMap<>();
		map.put("code", code);
		map.put("cnt", cnt);
		
		return map;
	}
	


}