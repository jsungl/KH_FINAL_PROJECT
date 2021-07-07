<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<jsp:include page="/WEB-INF/views/mypage/mypageHead.jsp"></jsp:include>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/mypage.css" />

<div class="container" id="my-post">
	<div class="col-xs-12" id="my-title">
		<h5>나의 활동 기록</h5>
	</div>
	<form class="col-xs-12 m-3" style="height: 20px;">
		<button type="submit">조회</button>
		<select name="myBoard" id="my-board">
			<option value="posting">게시물</option>
			<option value="comment">댓글</option>
		</select>
	</form>
	<div class="post-comment-center">
	
		<c:if test="${!empty boardList}">
		<c:forEach items="${boardList}" var="list">
			<div class="post-set"
				onclick="location.href = '${pageContext.request.contextPath}/board/boardDetail.do?boardNo=${list.boardNo}'">
				<div class="post-set-title">
					<p>
						<strong>${list.title}</strong>
					</p>
				</div>
				<div class="post-set-content">
					<p>
						<strong>${list.content}</strong>
					</p>

					<p>${list.category} . ${list.writeDate}</p>
				</div>
			</div>
		</c:forEach>
		</c:if>
		
		<c:if test="${!empty boardCommentList}">
		<c:forEach items="${boardCommentList}" var="commentList">
		<div class="comment-set">
				<div class="comment-set-title">
					<p>
						<strong>${commentList.regDate}</strong>
					</p>
				</div>
				<div class="comment-set-content">
					<p>
						<strong>"${commentList.content}"</strong>
					</p>
					<p>
						<a href="${pageContext.request.contextPath}/board/boardDetail.do?boardNo=${commentList.boardNo}">댓글을 남긴 게시글로 이동</a>
					</p>
				</div>
			</div>
		</c:forEach>
		</c:if>
		
	</div>
	<div style="margin: 140px 0 50px 0">${pageBar}</div>
</div>

<jsp:include page="/WEB-INF/views/mypage/mypageFoot.jsp"></jsp:include>