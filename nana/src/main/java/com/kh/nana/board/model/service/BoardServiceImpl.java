package com.kh.nana.board.model.service;


import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.nana.board.model.dao.BoardDao;
import com.kh.nana.board.model.vo.Board;
import com.kh.nana.board.model.vo.BoardComment;
import com.kh.nana.board.model.vo.BoardExt;
import com.kh.nana.board.model.vo.BoardLike;

@Service
public class BoardServiceImpl implements BoardService {
	
	@Autowired
	private BoardDao boardDao;

	@Override
	public int insertBoard(Board board) {
		return boardDao.insertBoard(board);
	}


	@Override
	public List<Board> selectBoardList(Map<String, Object> page1) {
		return boardDao.selectBoardList(page1);
	}


	@Override
	public Board selectBoardOne(int boardNo) {
		return boardDao.selectBoardOne(boardNo);
	}


	@Override
	public List<Board> selectBoardListById(String id) {
		return boardDao.selectBoardListById(id);
	}


	@Override
	public List<Board> selectLikeBoardList(String id) {
		return boardDao.selectLikeBoardList(id);
	}	

	public BoardExt selectOneBoardCollection(int no) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<BoardComment> selectCommentList(int boardNo) {
		return boardDao.selectCommentList(boardNo);
	}

	@Override
	public int selectCommentCount(int boardNo) {
		return boardDao.selectCommentCount(boardNo);
	}


	@Override
	public int selectTotalBoard() {
		return boardDao.selectTotalBoard();
	}


	@Override
	public int insertBoardComment(BoardComment boardComment) {
		return boardDao.insertBoardComment(boardComment);
	}

	@Override
	public int deleteBoardComment(int replyNo) {
		return boardDao.deleteBoardComment(replyNo);
	}


	@Override
	public int deleteBoard(int boardNo) {
		return boardDao.deleteBoard(boardNo);
	}

	@Override
	public int updateBoard(Board board) {
		return boardDao.updateBoard(board);
			
	}
	
	public List<BoardComment> selectCommentListByAdmin(String id) {
		return boardDao.selectCommentListByAdmin(id);
	}


	@Override
	public int selectBoardLikeCount(int boardNo) {
		return boardDao.selectBoardLikeCount(boardNo);
	}


	@Override
	public BoardLike selectBoardLikeById(Map<String, Object> param) {
		return boardDao.selectBoardLikeById(param);
	}


	@Override
	public int insertBoardLike(BoardLike boardLike) {
		return boardDao.insertBoardLike(boardLike);
	}


	@Override
	public int deleteBoardLike(BoardLike boardLike) {
		return boardDao.deleteBoardLike(boardLike);
	}

	@Override
	public int updateBoardLikeCount(Map<String, Object> param) {
		return boardDao.updateBoardLikeCount(param);
	}

	@Override
	public int updateReadCount(Map<String, Object> param) {
		return boardDao.updateReadCount(param);
	}


	/* -------------------------------------------------------- */
	@Override
	public List<Board> selectBoardListByPlaceNo(int placeNo, Map<String, Object> page) {
		return boardDao.selectBoardListByPlaceNo(placeNo, page);
	}


	@Override
	public int totalBoardContentByPlaceNo(int placeNo) {
		return boardDao.totalBoardContentByPlaceNo(placeNo);
	}
	
	
	
}

