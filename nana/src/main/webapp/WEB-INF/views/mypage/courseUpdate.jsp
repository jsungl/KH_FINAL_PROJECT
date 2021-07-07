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

<script>
/* textarea에도 required속성을 적용가능하지만, 공백이 입력된 경우 대비 유효성검사를 실시함. */
function boardValidate(){
	var $title = $("[name=title]");
	var $local = $("[name=local]");
	if(/^(.|\n)+$/.test($title.val()) == false){
		alert("여행 코스 제목 항목을 채워세요");
		return false;
	}
	if(/^(.|\n)+$/.test($local.val()) == false){
		alert("여행 장소 항목을 채워세요");
		return false;
	}
	return true;
}

function deleteCourse(){
	if (confirm("코스를 삭제하시겠습니까?") == true){
	    document.form.submit();
	}else{
	    return;
	}
}

function updateListCourse(){
	if (confirm("코스 수정을 끝내시겠습니까?") == true){
	    document.form.submit();
	}else{
	    return;
	}
}

</script>
<main>
        <section>

            <div class="container" id="course-container">
                <div class="col-xs-12" id="my-title">
                    <h5><strong>내가 만드는 여행 코스</strong></h5>
                </div>
                <div class="row col-xs-12" style="padding: 0 40px;">
                    <div class="col course-settings">
                        <div class="col-xs-12" id="my-title">
                            <h5><strong>여행 일정 추가하기</strong></h5>
                        </div>
                        <div class="map_wrap">
                            <div id="map" style="height:380px;position:relative;overflow:hidden;"></div>

                            <div id="menu_wrap" class="bg_white">
                                <div class="option">
                                    <div>
                                        <form onsubmit="searchPlaces(); return false;">
                                            <input type="text" value="서울특별시" id="keyword" size="31">
                                            <button type="submit">검색하기</button>
                                        </form>
                                    </div>
                                </div>
                                <hr>
                                <ul id="placesList"></ul>
                                <div id="pagination"></div>
                            </div>
                        </div>
                        <form:form class="col" 
                        name="courseFrm"
                        action="${pageContext.request.contextPath}/mypage/courseUpdateEnroll?${_csrf.parameterName}=${_csrf.token}"
						method="post"
						enctype="multipart/form-data"
						onsubmit="return boardValidate();">
							<input type="hidden" name="id" value="${principal.id}">
                            <label for=""><strong>여행 코스 제목</strong></label>
                            <input type="text" class="course-title" name="title" value="${courseTitle}" placeholder="제목을 입력하세요."  readonly/>
                            <label for=""><strong>여행 장소</strong></label>
                            <input type="text" class="course-name" name="travelLocal" id="course-name" value="" placeholder="여행 장소를 위의 리스트에서 추가하세요." readonly/>
                            <label for=""><strong>여행 날짜 지정</strong></label>
                            <input type="date" name="travelDate" style="width: 100%; margin-bottom: 20px;">
                            <label for=""><strong>장소 사진 추가</strong></label>
                            <input type="file" name="photo" style="width: 100%; margin-bottom: 20px;">
                            <label for=""><strong>여행 일정 코멘트</strong></label>
                            <textarea type="textarea" name="content" id="subject" placeholder="일정을 넣어보세요."></textarea>
                            <input type="submit" class="course-submit btn btn-outline-success" value="일정추가" >
                        </form:form>
                    </div>

                    <div class="col-4" style="margin-top: 20px; margin-bottom: 20px; border: 1px solid black;">
                        <div class="col-xs-12" id="my-title">
                            <h5><strong>일정 목록</strong></h5>
                        </div>
                        <c:choose>
                        <c:when test="${empty courseList}">
	                        <div style="margin-top: 140px; text-align: center; color: rgb(148, 148, 148);">
	                            <h5><strong>일정이 비어있습니다.</strong></h5>
	                        </div>
						</c:when>
                        <c:otherwise>
                        <form class="course-div"
		                        name="courseListEnrollFrm"
		                        method="get"
		                        action="${pageContext.request.contextPath}/mypage/courseUpdateEnter"
								onsubmit="return updateListCourse();">
		                    <input type="hidden" name="no" value="${travelNo}">
		                    <input type="hidden" name="id" value="${principal.id}">
                            <button type="submit" class="col course-enroll">코스 등록</button>
                        </form>
						<c:forEach items="${courseList}" var="course">
							<form class="course-div"
		                        name="courseDetailFrm"
		                        action="${pageContext.request.contextPath}/mypage/courseUpdateDelete?${_csrf.parameterName}=${_csrf.token}"
								method="post"
								data-no="${course.no}"
								onsubmit="return deleteCourse();">
		                            <div class="course-comment">
		                            	<input type="hidden" name="no" value="${course.no}">
		                            	<input type="hidden" name="title" value="${course.title}">
		                                <img src="${pageContext.request.contextPath}/resources/upload/course/${course.coursePhoto.renamedFilename}" alt="">
		                                <h5><strong>${course.travelLocal}</strong></h5>
		                                <p>${course.travelDate}</p>
		                                <p>${course.content}</p>
		                                <c:if test="${fn:length(courseList) > 1}">
		                                <div>
		                                	<input type="submit" class="course-del btn btn-outline-success" value="삭제" >
		                                </div>
		                                </c:if>
		                            </div>
                        		</form>
						</c:forEach>
						</c:otherwise>
						</c:choose>
                    </div>
                </div>
            </div>

        </section>
    </main>

    <script type="text/javascript"
        src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoServiceKey}&libraries=services"></script>
    <script>
        // 마커를 담을 배열입니다
        var markers = [];

        var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
            mapOption = {
                center: new kakao.maps.LatLng(37.566826, 126.9786567), // 지도의 중심좌표
                level: 3 // 지도의 확대 레벨
            };

        // 지도를 생성합니다    
        var map = new kakao.maps.Map(mapContainer, mapOption);

        // 장소 검색 객체를 생성합니다
        var ps = new kakao.maps.services.Places();

        // 검색 결과 목록이나 마커를 클릭했을 때 장소명을 표출할 인포윈도우를 생성합니다
        var infowindow = new kakao.maps.InfoWindow({ zIndex: 1 });

        // 키워드로 장소를 검색합니다
        searchPlaces();

        // 키워드 검색을 요청하는 함수입니다
        function searchPlaces() {

            var keyword = document.getElementById('keyword').value;

            if (!keyword.replace(/^\s+|\s+$/g, '')) {
                alert('키워드를 입력해주세요!');
                return false;
            }

            // 장소검색 객체를 통해 키워드로 장소검색을 요청합니다
            ps.keywordSearch(keyword, placesSearchCB);
        }

        // 장소검색이 완료됐을 때 호출되는 콜백함수 입니다
        function placesSearchCB(data, status, pagination) {
            if (status === kakao.maps.services.Status.OK) {

                // 정상적으로 검색이 완료됐으면
                // 검색 목록과 마커를 표출합니다
                displayPlaces(data);

                // 페이지 번호를 표출합니다
                displayPagination(pagination);

            } else if (status === kakao.maps.services.Status.ZERO_RESULT) {

                alert('검색 결과가 존재하지 않습니다.');
                return;

            } else if (status === kakao.maps.services.Status.ERROR) {

                alert('검색 결과 중 오류가 발생했습니다.');
                return;

            }
        }

        // 검색 결과 목록과 마커를 표출하는 함수입니다
        function displayPlaces(places) {

            var listEl = document.getElementById('placesList'),
                menuEl = document.getElementById('menu_wrap'),
                fragment = document.createDocumentFragment(),
                bounds = new kakao.maps.LatLngBounds(),
                listStr = '';

            // 검색 결과 목록에 추가된 항목들을 제거합니다
            removeAllChildNods(listEl);

            // 지도에 표시되고 있는 마커를 제거합니다
            removeMarker();

            for (var i = 0; i < places.length; i++) {

                // 마커를 생성하고 지도에 표시합니다
                var placePosition = new kakao.maps.LatLng(places[i].y, places[i].x),
                    marker = addMarker(placePosition, i),
                    itemEl = getListItem(i, places[i]); // 검색 결과 항목 Element를 생성합니다

                // 검색된 장소 위치를 기준으로 지도 범위를 재설정하기위해
                // LatLngBounds 객체에 좌표를 추가합니다
                bounds.extend(placePosition);

                // 마커와 검색결과 항목에 mouseover 했을때
                // 해당 장소에 인포윈도우에 장소명을 표시합니다
                // mouseout 했을 때는 인포윈도우를 닫습니다
                (function (marker, title) {
                    kakao.maps.event.addListener(marker, 'mouseover', function () {
                        displayInfowindow(marker, title);
                    });

                    kakao.maps.event.addListener(marker, 'mouseout', function () {
                        infowindow.close();
                    });

                    itemEl.onmouseover = function () {
                        displayInfowindow(marker, title);
                    };

                    itemEl.onmouseout = function () {
                        infowindow.close();
                    };
                })(marker, places[i].place_name);

                fragment.appendChild(itemEl);
            }

            // 검색결과 항목들을 검색결과 목록 Elemnet에 추가합니다
            listEl.appendChild(fragment);
            menuEl.scrollTop = 0;

            // 검색된 장소 위치를 기준으로 지도 범위를 재설정합니다
            map.setBounds(bounds);
        }

        // 검색결과 항목을 Element로 반환하는 함수입니다
        function getListItem(index, places) {

            var el = document.createElement('li'),
                itemStr = '<span class="markerbg marker_' + (index + 1) + '"></span>' +
                    '<div class="info">' +
                    '   <h5><strong>' + places.place_name + '</strong></h5>';

            if (places.road_address_name) {
                itemStr += '    <span>' + places.road_address_name + '</span>' +
                    '   <span class="jibun gray">' + places.address_name + '</span>';
            } else {
                itemStr += '    <span>' + places.address_name + '</span>';
            }

            itemStr += '  <span class="tel">' + places.phone + '</span>';

            itemStr += '  <button type="button" class="add-local-btn" onclick="addCourseTitle(this);">추가</button>' +
                '</div>';

            el.innerHTML = itemStr;
            el.className = 'item';

            return el;
        }

        // 마커를 생성하고 지도 위에 마커를 표시하는 함수입니다
        function addMarker(position, idx, title) {
            var imageSrc = 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_number_blue.png', // 마커 이미지 url, 스프라이트 이미지를 씁니다
                imageSize = new kakao.maps.Size(36, 37),  // 마커 이미지의 크기
                imgOptions = {
                    spriteSize: new kakao.maps.Size(36, 691), // 스프라이트 이미지의 크기
                    spriteOrigin: new kakao.maps.Point(0, (idx * 46) + 10), // 스프라이트 이미지 중 사용할 영역의 좌상단 좌표
                    offset: new kakao.maps.Point(13, 37) // 마커 좌표에 일치시킬 이미지 내에서의 좌표
                },
                markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imgOptions),
                marker = new kakao.maps.Marker({
                    position: position, // 마커의 위치
                    image: markerImage
                });

            marker.setMap(map); // 지도 위에 마커를 표출합니다
            markers.push(marker);  // 배열에 생성된 마커를 추가합니다

            return marker;
        }

        // 지도 위에 표시되고 있는 마커를 모두 제거합니다
        function removeMarker() {
            for (var i = 0; i < markers.length; i++) {
                markers[i].setMap(null);
            }
            markers = [];
        }

        // 검색결과 목록 하단에 페이지번호를 표시는 함수입니다
        function displayPagination(pagination) {
            var paginationEl = document.getElementById('pagination'),
                fragment = document.createDocumentFragment(),
                i;

            // 기존에 추가된 페이지번호를 삭제합니다
            while (paginationEl.hasChildNodes()) {
                paginationEl.removeChild(paginationEl.lastChild);
            }

            for (i = 1; i <= pagination.last; i++) {
                var el = document.createElement('a');
                el.href = "#";
                el.innerHTML = i;

                if (i === pagination.current) {
                    el.className = 'on';
                } else {
                    el.onclick = (function (i) {
                        return function () {
                            pagination.gotoPage(i);
                        }
                    })(i);
                }

                fragment.appendChild(el);
            }
            paginationEl.appendChild(fragment);
        }

        // 검색결과 목록 또는 마커를 클릭했을 때 호출되는 함수입니다
        // 인포윈도우에 장소명을 표시합니다
        function displayInfowindow(marker, title) {
            var content = '<div style="padding:5px;z-index:1;">' + title + '</div>';

            infowindow.setContent(content);
            infowindow.open(map, marker);
        }

        // 검색결과 목록의 자식 Element를 제거하는 함수입니다
        function removeAllChildNods(el) {
            while (el.hasChildNodes()) {
                el.removeChild(el.lastChild);
            }
        }

        //일정 카테고리에 추가하는 버튼입니다.
        function addCourseTitle(e) {
            var local = $(e).parent('div.info').children( 'h5' ).text();
            
            $('#course-name').val(local);
        }
    </script>
    
<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>