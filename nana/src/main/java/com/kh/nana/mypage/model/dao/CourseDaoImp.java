package com.kh.nana.mypage.model.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.kh.nana.board.model.vo.Board;
import com.kh.nana.board.model.vo.BoardComment;
import com.kh.nana.member.model.vo.Member;
import com.kh.nana.mypage.model.vo.Course;
import com.kh.nana.mypage.model.vo.CourseExt;
import com.kh.nana.mypage.model.vo.CourseNo;
import com.kh.nana.mypage.model.vo.CourseNoExt;
import com.kh.nana.mypage.model.vo.CourseNoList;
import com.kh.nana.mypage.model.vo.CoursePhoto;
import com.kh.nana.mypage.model.vo.MyBoardLike;
import com.kh.nana.mypage.model.vo.MyPlaceLike;

@Repository
public class CourseDaoImp implements CourseDao {

	@Autowired
	private SqlSessionTemplate session;

	@Override
	public List<CourseExt> selectCourseOneList(String title) {
		return session.selectList("course.selectOneCourseCollection", title);
	}

	@Override
	public int insertCourse(CourseExt course) {
		return session.insert("course.insertCourse", course);
	}

	@Override
	public int insertPhoto(CoursePhoto photo) {
		return session.insert("course.insertPhoto", photo);
	}

	@Override
	public int deleteCourse(int no) {
		return session.delete("course.deleteCourse", no);
	}

	@Override
	public List<CourseNoExt> selectCourseList(String id) {
		return session.selectList("course.selectCourseList", id);
	}

	@Override
	public String selectCourseTitleByNo(int courseNo) {
		return session.selectOne("course.selectCourseTitleByNo", courseNo);
	}
	
	@Override
	public int enrollListCourse(CourseNo courseNo) {
		return session.insert("course.enrollListCourse", courseNo);
	}

	@Override
	public CourseNo selectCourseNo(int no) {
		return session.selectOne("course.selectCourseNo", no);
	}

	@Override
	public int selectCourseNoList(String title) {
		return session.selectOne("course.selectCourseNoList", title);
	}

	@Override
	public int findCourseNo(String title) {
		return session.selectOne("course.findCourseNo", title);
	}

	@Override
	public int deleteCourseNo(String title) {
		return session.delete("course.deleteCourseNo", title);
	}

	@Override
	public int deleteCourseAll(String title) {
		return session.delete("course.deleteCourseAll", title);
	}

	@Override
	public List<Course> selectCourseIdList(String id) {
		return session.selectList("course.selectCourseIdList", id);
	}

	@Override
	public List<CourseNoList> selectCourseHeadTitleList(String id, Map<String, Object> param) {
		int offset = (int)param.get("offset");
		int limit = (int)param.get("limit");
		RowBounds rowBounds = new RowBounds(offset, limit);
		return session.selectList("course.selectCourseHeadTitleList", id, rowBounds);
	}

	@Override
	public int selectCourseTotalContents(String id) {
		return session.selectOne("course.selectCourseTotalContents", id);
	}

	@Override
	public List<Board> selectBoardIdList(String id, Map<String, Object> param) {
		int offset = (int)param.get("offset");
		int limit = (int)param.get("limit");
		RowBounds rowBounds = new RowBounds(offset, limit);
		return session.selectList("course.selectBoardIdList", id, rowBounds);
	}

	@Override
	public int selectBoardTotalContents(String id) {
		return session.selectOne("course.selectBoardTotalContents", id);
	}

	@Override
	public List<BoardComment> selectBoardCommentIdList(String id, Map<String, Object> param) {
		int offset = (int)param.get("offset");
		int limit = (int)param.get("limit");
		RowBounds rowBounds = new RowBounds(offset, limit);
		return session.selectList("course.selectBoardCommentIdList", id, rowBounds);
	}

	@Override
	public int selectBoardCommentTotalContents(String id) {
		return session.selectOne("course.selectBoardCommentTotalContents", id);
	}

	@Override
	public List<MyBoardLike> selectBoardLikeList(String id, Map<String, Object> param) {
		int offset = (int)param.get("offset");
		int limit = (int)param.get("limit");
		RowBounds rowBounds = new RowBounds(offset, limit);
		return session.selectList("course.selectBoardLikeList", id, rowBounds);
	}

	@Override
	public int selectboardLikeContents(String id) {
		return session.selectOne("course.selectboardLikeContents", id);
	}

	@Override
	public List<MyPlaceLike> selectPlaceLikeList(String id, Map<String, Object> param) {
		int offset = (int)param.get("offset");
		int limit = (int)param.get("limit");
		RowBounds rowBounds = new RowBounds(offset, limit);
		return session.selectList("course.selectPlaceLikeList", id, rowBounds);
	}

	@Override
	public int selectPlaceLikeTotalContents(String id) {
		return session.selectOne("course.selectPlaceLikeTotalContents", id);
	}

	@Override
	public int memberUpdate(Member member) {
		return session.update("course.memberUpdate", member);
	}

}
