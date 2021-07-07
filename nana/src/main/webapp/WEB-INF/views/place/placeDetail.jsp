<%@page import="com.kh.nana.place.model.vo.PlaceExt"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<%@page import="java.util.HashSet"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@ page import="com.kh.nana.place.model.vo.Place"%>
<%-- header --%>
<jsp:include page="/WEB-INF/views/common/header.jsp">
	<jsp:param value="나홀로 나들이" name="title" />
</jsp:include>
<%
// 장소 no로 조회된 장소객체 받아옴
Place place = (Place) request.getAttribute("place");
// 장소 객체의 no만 따로저장
//	String placeNo = Integer.toString(place.getPlaceNo());
int placeNo = place.getPlaceNo();
//	System.out.println("placeNo@jsp = " + placeNo);

// session의 list를 받아옴 -> null point 발생.. 
//	List<String> list = (ArrayList)session.getAttribute("visitList");
List<Integer> list = (ArrayList) session.getAttribute("visitList");
//	System.out.println("list@jsp = " + list);

// list가 없으면 새로 생성
if (list == null)
	list = new ArrayList<>();

// list 에 사용자가 열람한 장소 번호 추가
list.add(placeNo);

// 열람한 장소가 추가된 리스트를 세션에 담음
session.setAttribute("visitList", list);
//	System.out.println("visitList@jsp=" + list);
%>
<%-- 카카오 지도 라이브러리 API 인증 key --%>
<script type="text/javascript"
	src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoServiceKey}&libraries=services,clusterer,drawing"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/button.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/card.css" />
<style>
.row {
	margin: 0 5px;
}

/* h3 {
	border-bottom: 3px solid #333;
} */
/* .carousel-item {
	margin-right: auto !important;
} */
.container>* {
	padding-top: 5px;
}

.modal-content {
	background-color: rgba(255, 255, 255, 0.5);
}

.carousel-item>img {
	height: 28vw;
	object-fit: cover;
}

#map2 {
	height: 40vw;
}


</style>
<div class="container mt-3">
	<%-- content --%>
	<%-- 카테고리 --%>
	<%-- https://getbootstrap.com/docs/5.0/components/navs-tabs/ --%>
	<nav class="nav pl-2">
		<a class="nav-link active" aria-current="page" href="${pageContext.request.contextPath}/place/localDetail.do?localCode=${place.localCode}">${place.localName}</a>
		<a class="nav-link" href="${pageContext.request.contextPath}/place/categoryList.do?categoryCode=${place.categoryCode}&localCode=${place.localCode}&sort=place-name">${place.categoryName}</a>
		<a class="nav-link disabled" tabindex="-1" aria-disabled="true">${place.placeName}</a>
	</nav>
	<%-- 카테고리 끝 --%>


	<%-- 콘텐츠 상단 --%>
	<div class="row align-items-end pb-2">
		<div class="col-9" id="title">
			<!-- 장소 -->
			<h1 class="mb-1"><c:if test="${place.fromUser eq 1}">
			<span id="badge" class="badge badge-warning mr-2">유저등록</span></c:if>${place.placeName}
			</h1>
		</div>
			

		<div class="col-9">
			<!-- 상세주소-->
			<div class="text-muted fst-italic mb-2 p0">${place.address}</div>
		
		</div>
		<div class="col-9">
		<!-- 찜 하기 시작-->
				<input type="hidden" class="placeNo" value="${place.placeNo}" /> <input
					type="hidden" class="memberId" value="${id}" /> <input
					type="hidden" class="memberRole"
					value="<sec:authentication property="authorities"/>" />

				<c:choose>
					<c:when test="${empty placeLike.no}">
						<button type="button" class="btn likeBtn" id="likeBtn"
							onclick="placeLikeClick();">
							<span class="likeIcon" id="likeIcon"> <i
								class="fa fa-heart" aria-hidden="true"></i> 찜
							</span>
						</button>
						<input type="hidden" id="likeValiable" value="0" />
					</c:when>
					<c:when test="${not empty placeLike.no}">
						<button type="button" class="btn likedBtn" id="likedBtn"
							onclick="placeLikeClick();">
							<span class="likedIcon" id="likeIcon"> <i
								class="fa fa-heart" aria-hidden="true"></i> 찜
							</span>
						</button>
						<input type="hidden" id="likeValiable" value="1" />
					</c:when>
				</c:choose>
				<!-- 찜 하기 끝 -->
				<!-- 게시글 작성 -->
				<button type="button" class="btn yellowBorderBtn"
					onclick="location.href=`${pageContext.request.contextPath}/board/selectPlaceBoardForm.do?placeNo=${place.placeNo}&placeName=${place.placeName}`;">
					<i class="fa fa-pencil-square-o" aria-hidden="true"></i>글쓰기
				</button>
			<!-- 찜 수 / 게시글 수 -->
				<span><i class="fa fa-heart likedIcon" aria-hidden="true"></i></span>
				<span id="likeCnt">  ${placeLikeCnt}</span>
				<i class="fa fa-pencil-square-o boardIcon" aria-hidden="true"></i>
				<span>${boardCnt}</span>
			
		</div>
	</div>
	<%-- 콘텐츠 상단 끝 --%>

	<%-- https://getbootstrap.com/docs/4.0/components/carousel/ --%>
	<div class="row">
		<div id="carouselExampleIndicators" class="carousel slide col-7"
			data-ride="carousel">
			<ol class="carousel-indicators"></ol>
			<div class="carousel-inner">
				<a class="carousel-control-prev" href="#carouselExampleIndicators"
					role="button" data-slide="prev" style="z-index: 10;"> <span
					class="carousel-control-prev-icon" aria-hidden="true"></span> <span
					class="sr-only">Previous</span>
				</a> <a class="carousel-control-next" href="#carouselExampleIndicators"
					role="button" data-slide="next" style="z-index: 10;"> <span
					class="carousel-control-next-icon" aria-hidden="true"></span> <span
					class="sr-only">Next</span>
				</a>
			</div>

		</div>
		<%-- 장소 사진 끝 --%>

		<%-- kakao 지도 시작 --%>
		<div class="col-5" id="map">
			<div class="mt-2" style="z-index: 10; position: absolute;">
				<button type="button" class="btn btn-warning"
					onclick="goKakaoPage();">길찾기</button>
			</div>
		</div>
		<%-- kakao 지도 끝 --%>
	</div>

	<br />

	<%-- 장소 상세정보 시작 --%>
	<div class="row">
		<div class="col-12">
			<h3>장소 상세정보</h3>
			<p>${place.content}</p>
		</div>
	</div>
	<%-- 장소 상세정보 끝 --%>

	<br />

	<%-- 게시글 시작 --%>
	<div class="row board-page">
		<br /> <br /> <br />
		<div class="container-fluid">
		<div class="col-12" id="#boardList"><h3>게시글</h3></div>
			<div class="well">
			<c:if test="${not empty boardList}">
				<c:forEach items="${boardList}" var="board" varStatus="status">
				<div class="row mb-2 border p-4">
					<article class="col-md-12">
						<div class="col-md-12 p-0">
							<h5 class="m-2">
							<span id="badge" class="badge badge-warning">
							<c:choose>
								<c:when test="${board.category eq 'info'}">정보공유</c:when>
								<c:when test="${board.category eq 'review'}">여행후기</c:when>
								<c:when test="${board.category eq 'chat'}">잡담</c:when>
								<c:otherwise>카테고리 없음</c:otherwise>
							</c:choose>
							</span>
							${board.title}</h5>
							<hr />
							<div class="text-right m-2">
								<span>${board.id}</span><span>  |  </span>
								<span>${board.writeDate}</span>
							</div>
							<span class="m-2">
								${board.content}
							</span>
							<a href="${pageContext.request.contextPath}/board/boardDetail.do?boardNo=${board.boardNo}">더 보기</a>
						</div>
					</article>
				</div>
				<br />
				</c:forEach>
				${pageBar}
				</div>
			</c:if>
			<c:if test="${empty boardList}">
				<div class="col-12 d-flex justify-content-center mt-3 mb-3"><i class="fa fa-exclamation-circle fa-3x" aria-hidden="true"></i></div>
				<h5 class="col-12 fs-3 text-center">조회된 게시글이 없습니다.</h5>
			</c:if>
			<br />
	<%-- 게시글 끝 --%>
	<div class="row mb-5" id="local-content">
		<div class="col-12">
			<h3>주변 숙소 추천</h3>
		</div>
	</div>
</div>
<%-- 주변숙소 추천 끝 --%>


<%-- content 끝 --%>


<script>

	
	/* ----------------------------------- 찜하기 -----------------------------------*/
	function placeLikeClick() {
		const role = $(".memberRole").val();
		if(role == "[ROLE_ANONYMOUS]"){
			console.log("권한없음");
			location.href = "${pageContext.request.contextPath}/member/memberLogin.do";
		}else{
			console.log("like!");
			const id = $(".memberId").val();
			const placeNo = $(".placeNo").val();
			const likeValiable = $("#likeValiable").val()
			
			const $like = $("#likeBtn");
			const $liked = $("#likedBtn");

			var likeCnt = document.getElementById("likeCnt").innerText;

			console.log(likeCnt);
	
			$.ajax({
				url: "${pageContext.request.contextPath}/place/likePlace.do?${_csrf.parameterName}=${_csrf.token}",
				type : "POST",
				data: {id, placeNo, likeValiable},
				success: (data) => {
					console.log(data);
					if(data == 'delete') {
						$("#likeValiable").val(0);
						$("#likeBtn").removeClass("likedBtn").addClass("likeBtn");
						$("#likeIcon").removeClass("likedIcon").addClass("likeIcon");
						likeCnt = parseInt(likeCnt) - 1;
					}
					else {
						$("#likeValiable").val(1);
						$("#likeBtn").removeClass("likeBtn").addClass("likedBtn");
						$("#likeIcon").removeClass("likeIcon").addClass("likedIcon")
						likeCnt = parseInt(likeCnt) + 1;
					}				
					document.getElementById("likeCnt").innerText = likeCnt;
				},
				error: console.log
			}); 
		}
	}

	/* ----------------------------------- 카카오 지도 표시 ---------------------------------------*/
  	window.onload = function() {
		var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
		mapOption = {
			center : new kakao.maps.LatLng("${place.YCoord}", "${place.XCoord}"), // 지도의 중심좌표
			level : 3
		// 지도의 확대 레벨
		};

		var content = '<div class ="label"><span class="left"></span><span class="center">길찾기</span><span class="right"></span></div>';
		var map = new kakao.maps.Map(mapContainer, mapOption); // 지도를 생성합니다
		// 마커가 표시될 위치입니다 
		var position = new kakao.maps.LatLng("${place.YCoord}", "${place.XCoord}");
		// 마커를 생성합니다
		var marker = new kakao.maps.Marker({
			position : position
		});
		
		// 마커가 지도 위에 표시되도록 설정합니다
		marker.setMap(map);
		
		// 마커가 드래그 가능하도록 설정합니다 
		marker.setDraggable(true);

		map.relayout();
	
  	}
	

	/* ------------------------------ 주변 호텔 추천 ------------------------------ */ 
	
	const query = "${place.address}".split(" ");
	
	$.ajax({
		/* url: "https://dapi.kakao.com/v2/local/search/keyword.json?page=1&sort=accuracy&category_group_code=AD5&radius=2000&size=6&x=${place.XCoord}&y=${place.YCoord}&query=" + encodeURIComponent(query[0]), */
		url: "https://dapi.kakao.com/v2/local/search/keyword.json?",
		type: "GET",
		headers: { "Authorization" : "KakaoAK ${kakaoRestApiKey}" },
		data : {
			//검색어 data
			page : "1",
			sort : "accuracy",
			category_group_code : "AD5",
			radius : "2000",
			size : "8",
			x : "${place.XCoord}",
			y : "${place.YCoord}",
			query : query
		},
		success: function(data){
			const locals = data.documents; //Array
			const $localContent = $("#local-content"); //주변 숙소 추천 div
			console.log(locals);

			if(locals.length > 0) {
				for(var i = 0; i < locals.length; i++) {
					var categoryNames = locals[i].category_name.split(" > "); // category_name = "여행 < 숙박 < 펜션"
					var categoryName = categoryNames[categoryNames.length - 1]; // "펜션"
					var distance = locals[i].distance;
					distance = distance < 1000 ? distance + "m" : (distance / 1000).toFixed(1) + "km";
					var html = `
					<div class="col-3 mb-3">
						<div class="card text-dark bg-light">
						<div class="card-header">\${locals[i].place_name}</div>
							<div class="card-body">
								<span>\${categoryName}</span></br>
								<span class="card-text">\${locals[i].address_name}</span></br>
								<span>약 \${distance}</span></br></br>
								<a href="\${locals[i].place_url}" target="_black"><i class="fa fa-arrow-right" aria-hidden="true"></i>
								바로가기</a>
							</div>
						</div>
					</div>
					`;
					$localContent.append(html);
				}
			}
			else {
				var html = `
					<div class="col-12 d-flex justify-content-center mt-3 mb-3"><i class="fa fa-exclamation-circle fa-3x" aria-hidden="true"></i></div>
					<h5 class="col-12 fs-3 text-center">조회된 숙소가 없습니다.</h5>
					`;
				$localContent.append(html);			
			}
				
		},
		error: function(e){
			console.log(e);
		}
	});


	// 지도를 클릭하면 길찾기 페이지로 이동
	function goKakaoPage() {
		window
			.open(`https://map.kakao.com/link/to/${place.placeName},${place.YCoord},${place.XCoord}`);
	}
	

	/* ------------------------------ 동적 캐러셀 생성 ------------------------------ */ 
	
	$(function(){
		if("${place.photoList[0].renamedFilename}" == "") {	
			$('<div class="carousel-item active"><img class="d-block w-100" src="${pageContext.request.contextPath}/resources/images/no_img.png")></div>')
			.appendTo('.carousel-inner');
		}

		else {
			<c:forEach items="${place.photoList}" var="photo" varStatus="status">
			$('<li data-target="#carouselExampleIndicators" class="slide-list" data-slide-to=${status.index}></li>')
					.appendTo(".carousel-indicators");		
			$('<div class="carousel-item"><img class="d-block w-100" src="${pageContext.request.contextPath}/resources/upload/place/${photo.renamedFilename}"></div>')
					.appendTo('.carousel-inner');
			</c:forEach>
				
			$('.carousel-item').first().addClass('active');
			$('.slide-list').first().addClass('active');

		}
		
	});
	
</script>
<%-- footer --%>
<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>
