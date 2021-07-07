<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%-- header --%>
<jsp:include page="/WEB-INF/views/common/header.jsp">
	<jsp:param value="나홀로 나들이" name="title" />
</jsp:include>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/button.css" />
<style>
div#demo-container {
	width: 550px;
}

.img-container>img {
	height: 8vw;
	width: 8vw;
}

.uploadResult ul li {
	list-style: none;
	float: left;
	display: inline-block;
}

.btn.btn-danger {
	border-radius: 50%;
	float: right;
}

.filename {
	float: left;
}

.img-container {
	display: inline-block;
}
</style>

<script
	src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoServiceKey}&libraries=services"></script>
<script
	src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<div class="container mt-5 mb-5">
	<h1 class="text-center">장소 정보</h1>
	<div id="demo-container"
		class="border mx-auto p-3 rounded shadow p-3 mb-5 bg-body">
		<form:form id="updatePlaceFrm" method="POST">
			<div class="form-group row">
				<label for="name" class="col-sm-2 col-form-label">장소명</label>
				<div class="col-sm-10">
					<input type="text" class="form-control" id="placeName"
						name="placeName" value="${place.placeName}" readonly>
				</div>
			</div>
			<div class="form-group row">
				<label for="name" class="col-form-label col-sm-2">지역</label>
				<div class="col-sm-4">
					<input type="text" class="form-control" name="localName"
						id="localName" value="${place.localName}" readonly />
				</div>
			</div>
			<div class="form-group row">
				<label for="name" class="col-form-label col-sm-2">카테고리</label>
				<div class="col-sm-4">
					<input type="text" class="form-control" name="localName"
						id="localName" value="${place.categoryName}" readonly />
				</div>
			</div>
			<div class="form-group row">
				<label for="name" class="col-sm-2 col-form-label">주소</label>

				<div class="col-sm-10">
					<input type="text" class="form-control" id="address"
						placeholder="주소" name="address" value="${place.address}" readonly>
					<!-- 카카오 지도 보여주는 행 -->
					<div class="col-sm-10 p-0">
						<div id="map" class="mt-3 mb-3"
							style="width: 425px; height: 300px;"></div>
					</div>

				</div>
			</div>

			<div class="form-group row">
				<label for="name" class="col-sm-2 col-form-label">상세정보</label>
				<div class="col-sm-10">
					<textarea class="form-control" id="content" name="content" rows="5"
						readonly>${place.content}</textarea>
				</div>
			</div>
			<!-- 장소 사진 보여주는 행 -->
			<div class="form-group row">
				<div class="col-lg-12">
					<div class="card mb-4">
						<div class="card-header">
							<h5 class="m-0 font-weight-bold">첨부 사진</h5>
						</div>
						<div class="card-body">
							<div class="uploadResult">
								<ul class="pl-0 row"></ul>
							</div>
						</div>
					</div>
				</div>
			</div>
			<!-- 전송버튼  -->
			<div class="list-group">
				<input type="button" class="btn yellowBorderBtn" value="목록으로" onclick="goBack();"/>
			</div>
		</form:form>
	</div>
</div>

<script>
	<%-- 첨부된 파일 조회 --%>
	$(function(){
		if("${place.photoList[0].renamedFilename}" == "") {
			//조회된 파일이 없을 경우
			str = "<p class='text-secondary mt-2 mb-2 text-center'>조회된 파일이 없습니다.</p>"
			$(".uploadResult ul").html(str);
		}
		else {
			//조회된 파일이 있을 경우
			var str = "";
			<c:forEach items="${place.photoList}" var="photo" varStatus="status">
				str += "<li class='p-3'><div class='name-container text-truncate'><span class='pl-1 pr-1 filename'>${photo.originalFilename}</span></div>";
				/* str += "<button type='button' class='btn btn-danger btn-sm mb-1'><i class='fa fa-times'></i></button></div>"; */
				str += "<div class='img-container'><img class='d-block' src='${pageContext.request.contextPath}/resources/upload/place/${photo.renamedFilename}'></div>"
				str += "</li>";
			</c:forEach>
			$(".uploadResult ul").html(str);
		}
	});

	var mapContainer = document.getElementById('map'), // 지도를 표시할 div
	mapOption = {
		center : new daum.maps.LatLng("${place.YCoord}", "${place.XCoord}"), // 지도의 중심좌표
		level : 5
	// 지도의 확대 레벨
	};
	//지도 생성
	var map = new daum.maps.Map(mapContainer, mapOption);
	//주소-좌표 변환 객체를 생성
	var geocoder = new daum.maps.services.Geocoder();
	//마커를 생성
	var marker = new daum.maps.Marker({
		position : new daum.maps.LatLng("${place.YCoord}", "${place.XCoord}"),
		map : map
	});

	function goBack() {
	    window.history.back();
	}
</script>
<%-- footer --%>
<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>