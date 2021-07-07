package com.kh.nana.mypage.model.service;

import java.util.List;
import java.util.Map;

import com.kh.nana.board.model.vo.Board;
import com.kh.nana.board.model.vo.BoardComment;
import com.kh.nana.board.model.vo.BoardLike;
import com.kh.nana.member.model.vo.Member;
import com.kh.nana.mypage.model.vo.Course;
import com.kh.nana.mypage.model.vo.CourseExt;
import com.kh.nana.mypage.model.vo.CourseNo;
import com.kh.nana.mypage.model.vo.CourseNoExt;
import com.kh.nana.mypage.model.vo.CourseNoList;
import com.kh.nana.mypage.model.vo.CoursePhoto;
import com.kh.nana.mypage.model.vo.MyBoardLike;
import com.kh.nana.mypage.model.vo.MyPlaceLike;
import com.kh.nana.place.model.vo.PlaceLike;

public interface CourseService {
	
	List<CourseExt> selectCourseOneList(String title);
	
	int insertCourse(CourseExt course);

	int insertPhoto(CoursePhoto photo);

	int deleteCourse(int no);

	List<CourseNoExt> selectCourseList(String id);

	String selectCourseTitleByNo(int courseNo);

	int enrollListCourse(CourseNo courseNo);

	CourseNo selectCourseNo(int no);

	int selectCourseNoList(String title);

	int findCourseNo(String title);

	int deleteCourseNo(String title);

	int deleteCourseAll(String title);

	List<Course> selectCourseIdList(String id);

	List<CourseNoList> selectCourseHeadTitleList(String id, Map<String, Object> param);

	int selectCourseTotalContents(String id);

	List<Board> selectBoardIdList(String id, Map<String, Object> param);

	int selectBoardTotalContents(String string);

	List<BoardComment> selectBoardCommentIdList(String id, Map<String, Object> param);

	int selectBoardCommentTotalContents(String id);

	List<MyBoardLike> selectBoardLikeList(String id, Map<String, Object> param);

	int selectboardLikeContents(String id);

	List<MyPlaceLike> selectPlaceLikeList(String id, Map<String, Object> param);

	int selectPlaceLikeTotalContents(String id);

	int memberUpdate(Member member);

}
