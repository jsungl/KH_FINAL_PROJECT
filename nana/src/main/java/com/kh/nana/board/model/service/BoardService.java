package com.kh.nana.board.model.service;


import java.util.List;
import java.util.Map;

import com.kh.nana.board.model.vo.Board;
import com.kh.nana.board.model.vo.BoardComment;
import com.kh.nana.board.model.vo.BoardExt;
import com.kh.nana.board.model.vo.BoardLike;


public interface BoardService {
	
	List<Board> selectBoardList(Map<String, Object> page1);

	int insertBoard(Board board);

	public Board selectBoardOne(int boardNo);
	
	BoardExt selectOneBoardCollection(int no);

	public List<BoardComment> selectCommentList(int boardNo);

	public int selectCommentCount(int boardNo);
	
	int selectTotalBoard();

	public List<Board> selectBoardListById(String id);

	public List<Board> selectLikeBoardList(String id);

	public int insertBoardComment(BoardComment boardComment);

	public int deleteBoardComment(int replyNo);

	public int deleteBoard(int boardNo);

	public int updateBoard(Board board);
	
	public List<BoardComment> selectCommentListByAdmin(String id);
	
	int updateBoardLikeCount(Map<String, Object> param);

	int updateReadCount(Map<String, Object> param);
	
	/* -------------------------------------------------------- */
	public List<Board> selectBoardListByPlaceNo(int placeNo, Map<String, Object> page);

	public int totalBoardContentByPlaceNo(int placeNo);

	public int selectBoardLikeCount(int boardNo);

	public BoardLike selectBoardLikeById(Map<String, Object> param);

	public int insertBoardLike(BoardLike boardLike);

	public int deleteBoardLike(BoardLike boardLike);



}
