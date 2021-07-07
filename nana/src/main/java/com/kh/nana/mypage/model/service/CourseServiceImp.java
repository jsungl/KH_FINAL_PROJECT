package com.kh.nana.mypage.model.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.nana.board.model.vo.Board;
import com.kh.nana.board.model.vo.BoardComment;
import com.kh.nana.member.model.vo.Member;
import com.kh.nana.mypage.model.dao.CourseDao;
import com.kh.nana.mypage.model.vo.Course;
import com.kh.nana.mypage.model.vo.CourseExt;
import com.kh.nana.mypage.model.vo.CourseNo;
import com.kh.nana.mypage.model.vo.CourseNoExt;
import com.kh.nana.mypage.model.vo.CourseNoList;
import com.kh.nana.mypage.model.vo.CoursePhoto;
import com.kh.nana.mypage.model.vo.MyBoardLike;
import com.kh.nana.mypage.model.vo.MyPlaceLike;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class CourseServiceImp implements CourseService {

	@Autowired
	private CourseDao courseDao;

	@Override
	public List<CourseExt> selectCourseOneList(String title) {
		List<CourseExt> courses = courseDao.selectCourseOneList(title);
		return courses;
	}

	@Override
	public int insertCourse(CourseExt course) {
		int result = 0;

		result = courseDao.insertCourse(course);
		log.debug("course = {}", course);

		if (course.getCoursePhoto() != null) {
			course.getCoursePhoto().setId(course.getId());
			course.getCoursePhoto().setNo(course.getNo());
			result = insertPhoto(course.getCoursePhoto());
		}

		return result;
	}

	@Override
	public int insertPhoto(CoursePhoto photo) {
		return courseDao.insertPhoto(photo);
	}

	@Override
	public int deleteCourse(int no) {
		return courseDao.deleteCourse(no);
	}

	@Override
	public List<CourseNoExt> selectCourseList(String id) {
		return courseDao.selectCourseList(id);
	}

	@Override
	public String selectCourseTitleByNo(int courseNo) {
		return courseDao.selectCourseTitleByNo(courseNo);
	}
	
	@Override
	public int enrollListCourse(CourseNo courseNo) {
		return courseDao.enrollListCourse(courseNo);
	}

	@Override
	public CourseNo selectCourseNo(int no) {
		CourseNo course = courseDao.selectCourseNo(no);
		return course;
	}

	@Override
	public int selectCourseNoList(String title) {
		return courseDao.selectCourseNoList(title);
	}

	@Override
	public int findCourseNo(String title) {
		return courseDao.findCourseNo(title);
	}

	@Override
	public int deleteCourseNo(String title) {
		return courseDao.deleteCourseNo(title);
	}

	@Override
	public int deleteCourseAll(String title) {
		return courseDao.deleteCourseAll(title);
	}

	@Override
	public List<Course> selectCourseIdList(String id) {
		return courseDao.selectCourseIdList(id);
	}

	@Override
	public List<CourseNoList> selectCourseHeadTitleList(String id, Map<String, Object> param) {
		return courseDao.selectCourseHeadTitleList(id, param);
	}

	@Override
	public int selectCourseTotalContents(String id) {
		return courseDao.selectCourseTotalContents(id);
	}

	@Override
	public List<Board> selectBoardIdList(String id, Map<String, Object> param) {
		return courseDao.selectBoardIdList(id, param);
	}

	@Override
	public int selectBoardTotalContents(String id) {
		return courseDao.selectBoardTotalContents(id);
	}

	@Override
	public List<BoardComment> selectBoardCommentIdList(String id, Map<String, Object> param) {
		return courseDao.selectBoardCommentIdList(id, param);
	}

	@Override
	public int selectBoardCommentTotalContents(String id) {
		return courseDao.selectBoardCommentTotalContents(id);
	}

	@Override
	public List<MyBoardLike> selectBoardLikeList(String id, Map<String, Object> param) {
		return courseDao.selectBoardLikeList(id, param);
	}

	@Override
	public int selectboardLikeContents(String id) {
		return courseDao.selectboardLikeContents(id);
	}

	@Override
	public List<MyPlaceLike> selectPlaceLikeList(String id, Map<String, Object> param) {
		return courseDao.selectPlaceLikeList(id, param);
	}

	@Override
	public int selectPlaceLikeTotalContents(String id) {
		return courseDao.selectPlaceLikeTotalContents(id);
	}

	@Override
	public int memberUpdate(Member member) {
		return courseDao.memberUpdate(member);
	}

}
