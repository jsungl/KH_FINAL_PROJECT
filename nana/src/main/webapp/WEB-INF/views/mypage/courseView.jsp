<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %> 
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<jsp:include page="/WEB-INF/views/common/header.jsp">
	<jsp:param value="나홀로 나들이" name="title"/>
</jsp:include>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/mypage.css" />

<main>
	<section>

		<div class="container" id="view-title">
			<h1>
				<strong>${courseNo.title}</strong>
			</h1>
			<div class="view-title-btns">
				<form name="courseFrm"
					action="${pageContext.request.contextPath}/mypage/courseUpdate"
					method="get">
					<input type="hidden" name="title" value="${courseNo.title}">
					<button type="submit" class="view-title-btn">수정</button>
				</form>
				<form name="courseFrm"
					action="${pageContext.request.contextPath}/mypage/courseDeleteList"
					method="get"
					onsubmit="return delCheck();">
					<input type="hidden" name="title" value="${courseNo.title}">
					<button type="submit" class="view-title-btn">삭제</button>
				</form>
			</div>
		</div>

		<div class="container" id="kaka-map">
			<div id="map" style="width: 100%; height: 560px; margin-top: 50px;"></div>
		</div>

		<div class="container" id="local-info">
			<div class="row">
				<div class="local-info-container">
					<div class="local-info-view">
						<div class="col-xs-12 title-color" id="my-title">
							<h5>
								<strong id="c-title">${firstCourse.travelLocal}</strong>
							</h5>
						</div>
						<img id="c-photo" src="${pageContext.request.contextPath}/resources/upload/course/${firstCourse.coursePhoto.renamedFilename}" alt="" style="width: 100%;">
						<div class="local-info-detail">
							<label for=""><strong>여행 날짜</strong></label>
							<p id="c-date">${firstCourse.travelDate}</p>
							<label for=""><strong>여행 코스에 대한 코멘트</strong></label>
							<p id="c-content">${firstCourse.content}</p>
						</div>
					</div>
				</div>
				<div class="local-info-list">
					<div class="col-xs-12 title-color" id="my-title">
						<h5>
							<strong>코스 목록</strong>
						</h5>
					</div>
					<div class="course-scroll">
						<c:forEach items="${courseList}" var="course" varStatus="status">
							<form onclick="searchPlaces(this); return false;">
								<div class="course-list-container">
									<div class="row">
										<div class="course-list-num">${status.count}</div>
										<div class="course-list-body">
											<h5>
												<input type="hidden" class="c-keyword" value="${course.travelLocal}">
												<input type="hidden" class="c-photo" value="${pageContext.request.contextPath}/resources/upload/course/${course.coursePhoto.renamedFilename}">
												<input type="hidden" class="c-date" value="${course.travelDate}">
												<input type="hidden" class="c-content" value="${course.content}">
												<strong>${course.travelLocal}</strong>
											</h5>
										</div>
									</div>
								</div>
							</form>
						</c:forEach>
					</div>
				</div>
			</div>
		</div>

	</section>
</main>

    <script type="text/javascript"
    src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoServiceKey}&libraries=services"></script>
    <script>
					// 마커를 클릭하면 장소명을 표출할 인포윈도우 입니다
					var infowindow = new kakao.maps.InfoWindow({
						zIndex : 1
					});

					var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
					mapOption = {
						center : new kakao.maps.LatLng(37.566826, 126.9786567), // 지도의 중심좌표
						level : 3
					// 지도의 확대 레벨
					};

					// 지도를 생성합니다    
					var map = new kakao.maps.Map(mapContainer, mapOption);

					// 장소 검색 객체를 생성합니다
					var ps = new kakao.maps.services.Places();

					// 키워드로 장소를 검색합니다
					ps.keywordSearch('${firstCourse.travelLocal}', placesSearchCB);

					// 장소 검색 함수
					function searchPlaces(e) {
						var keyword = $(e).find('input.c-keyword').val();
						var photo = $(e).find('input.c-photo').val();
						var date = $(e).find('input.c-date').val();
						var content = $(e).find('input.c-content').val();

						if (!keyword.replace(/^\s+|\s+$/g, '')) {
							alert('키워드를 입력해주세요!');
							return false;
						}

						// 장소검색 객체를 통해 키워드로 장소검색을 요청합니다
						ps.keywordSearch(keyword, placesSearchCB);

						$('#c-title').text(keyword);
						$('#c-photo').attr('src',photo);;
						$('#c-date').text(date);
						$('#c-content').text(content);
					}

					// 키워드 검색 완료 시 호출되는 콜백함수 입니다
					function placesSearchCB(data, status, pagination) {
						if (status === kakao.maps.services.Status.OK) {

							// 검색된 장소 위치를 기준으로 지도 범위를 재설정하기위해
							// LatLngBounds 객체에 좌표를 추가합니다
							var bounds = new kakao.maps.LatLngBounds();

							for (var i = 0; i < data.length; i++) {
								displayMarker(data[i]);
								bounds.extend(new kakao.maps.LatLng(data[i].y,
										data[i].x));
							}

							// 검색된 장소 위치를 기준으로 지도 범위를 재설정합니다
							map.setBounds(bounds);
						}
					}

					// 지도에 마커를 표시하는 함수입니다
					function displayMarker(place) {

						// 마커를 생성하고 지도에 표시합니다
						var marker = new kakao.maps.Marker({
							map : map,
							position : new kakao.maps.LatLng(place.y, place.x)
						});

						// 마커에 클릭이벤트를 등록합니다
						kakao.maps.event
								.addListener(
										marker,
										'click',
										function() {
											// 마커를 클릭하면 장소명이 인포윈도우에 표출됩니다
											infowindow
													.setContent('<div style="padding:5px;font-size:12px;">'
															+ place.place_name
															+ '</div>');
											infowindow.open(map, marker);
										});
					}

					/* 코스 삭제시 확인 요청 */
					function delCheck(){
						if (confirm("현재 코스를 삭제하시겠습니까?") == true){
						    document.form.submit();
						}else{
						    return false;
						}
					}
				</script>
    
<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>