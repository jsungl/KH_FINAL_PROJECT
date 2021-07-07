<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<jsp:include page="/WEB-INF/views/mypage/mypageHead.jsp"></jsp:include>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/mypage.css" />

<div class="container" id="my-post">
	<div class="col no-category">
		<h3>선택된 카테고리가 없습니다</h3>
	</div>
</div>

<jsp:include page="/WEB-INF/views/mypage/mypageFoot.jsp"></jsp:include>