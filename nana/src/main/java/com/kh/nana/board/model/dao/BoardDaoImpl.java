package com.kh.nana.board.model.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.kh.nana.board.model.vo.Board;
import com.kh.nana.board.model.vo.BoardComment;
import com.kh.nana.board.model.vo.BoardLike;


@Repository
public class BoardDaoImpl implements BoardDao {

	@Autowired
	private SqlSessionTemplate session;
	
	@Override
	public List<Board> selectBoardList(Map<String, Object> page1) {
		int offset = (int)page1.get("offset");
		int limit = (int)page1.get("limit");
		RowBounds rowBounds = new RowBounds(offset, limit);
		return session.selectList("board.selectBoardList", null, rowBounds);
	}

	@Override
	public int insertBoard(Board board) {
		return session.insert("board.insertBoard", board);
	}

	@Override
	public int insertAuthority(Board board) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public Board selectBoardOne(int boardNo) {
		return session.selectOne("board.selectBoardOne", boardNo);
	}

	@Override
	public List<Board> selectBoardListById(String id) {
		return session.selectList("board.selectBoardListById", id);
	}

	@Override
	public List<Board> selectLikeBoardList(String id) {
		return session.selectList("board.selectLikeBoardList",id);
	}

	public List<BoardComment> selectCommentList(int boardNo) {
		return session.selectList("board.selectCommentList", boardNo);
	}

	@Override
	public int selectCommentCount(int boardNo) {
		return session.selectOne("board.selectCommentCount", boardNo);
	}

	@Override
	public int selectTotalBoard() {
		// TODO Auto-generated method stub
		return session.selectOne("board.selectTotalBoard");
	}

	@Override
	public int insertBoardComment(BoardComment boardComment) {
		return session.insert("board.insertBoardComment", boardComment);
	}

	@Override
	public int deleteBoardComment(int replyNo) {
		return session.delete("board.deleteBoardComment", replyNo);
	}

	@Override
	public int deleteBoard(int boardNo) {
		return session.delete("board.deleteBoard", boardNo);
	}

	@Override
	public int updateBoard(Board board) {

		return session.update("board.updateBoard", board);
	}
	
	public List<BoardComment> selectCommentListByAdmin(String id) {
		return session.selectList("board.selectCommentListByAdmin",id);
	}

	@Override
	public int selectBoardLikeCount(int boardNo) {
		return session.selectOne("board.selectBoardLikeCount", boardNo);
	}

	@Override
	public BoardLike selectBoardLikeById(Map<String, Object> param) {
		return session.selectOne("board.selectBoardLikeById", param);
	}

	@Override
	public int insertBoardLike(BoardLike boardLike) {
		return session.insert("board.insertBoardLike", boardLike);
	}

	@Override
	public int deleteBoardLike(BoardLike boardLike) {
		return session.delete("board.deleteBoardLike", boardLike);
	}
	
	@Override
	public int updateBoardLikeCount(Map<String, Object> param) {
		return session.update("board.updateBoardLikeCount", param);
	}

	@Override
	public int updateReadCount(Map<String, Object> param) {
		return session.update("board.updateReadCount", param);
	}

	/* -------------------------------------------------------- */
	@Override
	public List<Board> selectBoardListByPlaceNo(int placeNo, Map<String, Object> page) {
		int offset = (int)page.get("offset");
		int limit = (int)page.get("limit");
		RowBounds rowBounds = new RowBounds(offset, limit);
		return session.selectList("board.selectBoardListByPlaceNo", placeNo, rowBounds);
	}

	@Override
	public int totalBoardContentByPlaceNo(int placeNo) {
		return session.selectOne("board.totalBoardContentByPlaceNo", placeNo);
	}
	


}
