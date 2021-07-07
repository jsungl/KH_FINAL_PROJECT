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
		<h5>나의 여행 코스 목록</h5>
	</div>
	<div class="row text-center">
		<c:forEach items="${courseNoList}" var="courseNoList">
			<form class="course-set" name="travelBoardFrm"
				action="${pageContext.request.contextPath}/mypage/courseView"
				method="get" onclick="travelBoardSubmit(this)">
				<div class="col course-set-title">
					<p>${courseNoList.title}</p>
					<input type="hidden" name="no" value="${courseNoList.courseNo}" />
				</div>
				<c:forEach items="${courseNoList.course}" var="course"
					varStatus="status">
					<div class="course-mini">
						<div style="padding: 10px;">
							<div class="course-mini-cell">${status.count}</div>
							<p>${course.travelLocal}</p>
						</div>
					</div>
				</c:forEach>
			</form>
		</c:forEach>
	</div>
	<div style="margin: 140px 0 50px 0">${pageBar}</div>
</div>

<script>
		function travelBoardSubmit(e){
			$(e).submit();
		}
</script>
<jsp:include page="/WEB-INF/views/mypage/mypageFoot.jsp"></jsp:include>