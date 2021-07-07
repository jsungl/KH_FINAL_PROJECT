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
		<h5>나의 좋아요 / 찜 목록</h5>
	</div>
	<form class="col-xs-12 m-3" style="height: 20px;">
		<button type="submit">조회</button>
		<select name="myBoard" id="my-board">
			<option value="likeBoard">좋아요</option>
			<option value="likePlace">찜</option>
		</select>
	</form>
	<div class="post-comment-center">
	
		<c:if test="${!empty boardLikeList}">
		<c:forEach items="${boardLikeList}" var="boardList">
			<div class="post-set"
				onclick="location.href = '${pageContext.request.contextPath}/board/boardDetail.do?boardNo=${boardList.boardNo}'">
				<div class="post-set-title">
					<p>
						<strong>${boardList.title}</strong>
					</p>
				</div>
				<div class="post-set-content">
					<p>
						<strong>${boardList.content}</strong>
					</p>

					<p>${boardList.category} . ${boardList.writeDate}</p>
				</div>
			</div>
		</c:forEach>
		</c:if>
		
		<c:if test="${!empty placeLikeList}">
		<c:forEach items="${placeLikeList}" var="placeList">
		<div class="comment-set"
				onclick="location.href = '${pageContext.request.contextPath}//place/placeDetail.do??placeNo=${placeList.placeNo}'">
				<div class="comment-set-title like-set-title">
					<p>
						<strong>${placeList.placeName}</strong>
					</p>
				</div>
				<div class="comment-set-content">
					<p>
						<strong>"${placeList.content}"</strong>
					</p>
					<p>${placeList.address}</p>
				</div>
			</div>
		</c:forEach>
		</c:if>
		
	</div>
	<div style="margin: 140px 0 50px 0">${pageBar}</div>
</div>

<jsp:include page="/WEB-INF/views/mypage/mypageFoot.jsp"></jsp:include>